###### [↩ Back to `README`](./../README.md)

# 7. NFS server with `cinder-csi-plugin`
## 7.1. Using NFS server to solve the `cinder-csi-plugin`'s problems
- One drawback of the `cinder-csi-plugin` is that it **DOES NOT** support `RWX` mode for block volumes, this is understandable because Linux filesystem type `ext4` **DOES NOT** have multiple node writing permission.
- Therefore, to use `RWX` mode, the block volume must be replaced with a shared file system or NFS server.
- But now a problem arises: what should we do if the NFS server is **shut down**? The data of the NFS server **MAY** be **LOST** if the volume of that NFS server is **NOT backed up**, or if it **CANNOT ensure high availability** for the servers, services are retrieving this NFS server.
- **💡 SOLUTION**:
  - To solve the above problem, I will build the NFS server right inside the Kubernetes clusters, ensure high availability for it using Kubernetes Deployment, and allow services inside the cluster to access it via Kubernetes Service.

## 7.2. Prepare the Cluster
- To perform this lab, I will need a Kubernetes cluster consisting of 1 master and 2 workers, below is my cluster information:
  ```bash
  kubectl get nodes -owide
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get nodes -owide
  > NAME                                               STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP     OS-IMAGE                        KERNEL-VERSION           CONTAINER-RUNTIME
  > lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0   Ready    master   83m   v1.27.6   10.0.0.74     49.213.90.205   Fedora CoreOS 38.20230709.3.0   6.3.11-200.fc38.x86_64   containerd://1.7.1
  > lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-0     Ready    <none>   77m   v1.27.6   10.0.0.187    49.213.90.204   Fedora CoreOS 38.20230709.3.0   6.3.11-200.fc38.x86_64   containerd://1.7.1
  > lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-1     Ready    <none>   77m   v1.27.6   10.0.0.157    49.213.90.198   Fedora CoreOS 38.20230709.3.0   6.3.11-200.fc38.x86_64   containerd://1.7.1
  > ```

- Make sure `cinder-csi-plugin` is running:
  ```bash
  kubectl get pods -n kube-system | grep -i "cinder"
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get pods -n kube-system | grep -i "cinder"
  > csi-cinder-controllerplugin-867c6458fb-g7wr4   6/6     Running   0          85m
  > csi-cinder-nodeplugin-5bwgm                    3/3     Running   0          80m
  > csi-cinder-nodeplugin-5dvks                    3/3     Running   0          79m
  > csi-cinder-nodeplugin-smltb                    3/3     Running   0          85m
  > ```

## 7.3. Deploy NFS server
- As mentioned before, I will use the `PersistentVolume` created by the `cinder-csi-plugin` and then mount this volume to the NFS server deployment, finally creating the NFS server service so that other services can retrieve the NFS server deployment through the NFS server service.
- To do that, apply file [nfs-server.yaml](./../manifest/nfs-x-cinder-csi-plugin/nfs-server.yaml) with the following content:
  ```yaml
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
    name: csi-sc-cinderplugin  # [1] The StorageClass name, CAN be changed
  provisioner: cinder.csi.openstack.org
  parameters:
    type: <PUT_THE_VOLUME_TYPE_UUID>  # Change this value to proper Volume Type UUID
  allowVolumeExpansion: true
  ---

  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: csi-pvc-cinderplugin  # [2] The PersistentVolumeClaim name, CAN be changed
  spec:
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 1Gi  # [3] The volume size, CAN be changed
    storageClassName: csi-sc-cinderplugin  # MUST be same value with [1]
  ---

  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nfs-server  # [7] The Deployment name, CAN be changed
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: nfs-server  # MUST be same value with [6]
    template:
      metadata:
        labels:
          app: nfs-server  # [6] The app label, CAN be changed
      spec:
        containers:
        - name: nfs-server
          image: registry.vngcloud.vn/public/volume-nfs:0.8
          ports:
          - name: nfs
            containerPort: 2049
          - name: mountd
            containerPort: 20048
          - name: rpcbind
            containerPort: 111
          securityContext:
            privileged: true
          volumeMounts:
            - mountPath: /exports  # [5] The volume mount path, CAN be changed
              name: my-volume-name  # MUST be same value with [4]
        volumes:
        - name: my-volume-name  # [4] The volume mount name, CAN be changed
          persistentVolumeClaim:
            claimName: csi-pvc-cinderplugin  # MUST be same value with [2]
            readOnly: false
  ---

  apiVersion: v1
  kind: Service
  metadata:
    name: nfs-service  # [8] The Service name, CAN be changed
  spec:
    ports:
    - name: nfs
      port: 2049
    - name: mountd
      port: 20048
    - name: rpcbind
      port: 111
    selector:
      app: nfs-server  # MUST be same value with [6]
  ```

- Apply the above manifest file:
  ```bash
  kubectl apply -f nfs-server.yaml
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl apply -f nfs-server.yaml 
  > storageclass.storage.k8s.io/csi-sc-cinderplugin created
  > persistentvolumeclaim/csi-pvc-cinderplugin created
  > deployment.apps/nfs-server created
  > service/nfs-service created
  > ```

- Verify the resources have been created
  ```
  kubectl get sc,pv,pvc -owide
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get sc,pv,pvc -owide
  > NAME                                                        PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
  > storageclass.storage.k8s.io/csi-sc-cinderplugin             cinder.csi.openstack.org   Delete          Immediate           true                   14m
  > storageclass.storage.k8s.io/vcontainer-ceph-csi (default)   cinder.csi.openstack.org   Delete          Immediate           false                  35m
  > 
  > NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                          STORAGECLASS          REASON   AGE   VOLUMEMODE
  > persistentvolume/nfs-pv                                     1Gi        RWX            Retain           Bound    default/nfs-pvc                                               10s   Filesystem
  > persistentvolume/pvc-7c44e5a4-9713-4dce-aadf-d83e1a71dec3   1Gi        RWO            Delete           Bound    default/csi-pvc-cinderplugin   csi-sc-cinderplugin            13m   Filesystem
  > 
  > NAME                                         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE   VOLUMEMODE
  > persistentvolumeclaim/csi-pvc-cinderplugin   Bound    pvc-7c44e5a4-9713-4dce-aadf-d83e1a71dec3   1Gi        RWO            csi-sc-cinderplugin   14m   Filesystem
  > persistentvolumeclaim/nfs-pvc                Bound    nfs-pv                                     1Gi        RWX                                  10s   Filesystem
  > ```

  ```bash
  kubectl get pods
  kubectl get svc
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get pods
  > NAME                          READY   STATUS    RESTARTS   AGE
  > nfs-server-6bc5d94774-pr662   1/1     Running   0          70s
  > 
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get svc
  > NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
  > kubernetes    ClusterIP   10.254.0.1       <none>        443/TCP                      26m
  > nfs-service   ClusterIP   10.254.193.248   <none>        2049/TCP,20048/TCP,111/TCP   4m15s
  > ```