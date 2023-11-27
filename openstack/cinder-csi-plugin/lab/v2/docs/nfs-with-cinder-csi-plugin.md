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
    replicas: 2  # [9] The number of replicas, this field is contrainted by the nodeSelector field below
    selector:
      matchLabels:
        app: nfs-server  # MUST be same value with [6]
    template:
      metadata:
        labels:
          app: nfs-server  # [6] The app label, CAN be changed
      spec:
        nodeSelector:
          kubernetes.io/hostname: <PUT_THE_HOSTNAME_OF_THE_PROPER_NODE>  # This field MUST be set if the replicas [9] greater than 1
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
  > persistentvolume/pvc-7c44e5a4-9713-4dce-aadf-d83e1a71dec3   1Gi        RWO            Delete           Bound    default/csi-pvc-cinderplugin   csi-sc-cinderplugin            13m   Filesystem
  > 
  > NAME                                         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE   VOLUMEMODE
  > persistentvolumeclaim/csi-pvc-cinderplugin   Bound    pvc-7c44e5a4-9713-4dce-aadf-d83e1a71dec3   1Gi        RWO            csi-sc-cinderplugin   14m   Filesystem
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

  - At this moment, you **SHOULD** take note the `CLUSTER IP` of `nfs-service` service, in my case, it is `10.254.193.248`, this IPv4 address will be used later.

## 7.4. Deploy a service to test the NFS server
- Now that my cluster has an NFS server, I can create `PersistentVolume` and `PersistentVolumeClaim` using this NFS server.
- I will deploy an `nginx` deployment with 3 replicas and use volumes mounted from this NFS server.
- In my case, I want my `nginx` deployment to save its data at the `/pvc` path on the `nginx` pods. Therefore I **MUST** create a `/pvc` path inside the `/exports` path of the NFS server.
- To do the above, create the `/pvc` directory in the NFS server:
  ```bash
  kubectl get pods
  kubectl exec <NAME_OF_NFS_SERVER_POD> -- mkdir /exports/pvc
  kubectl exec <NAME_OF_NFS_SERVER_POD> -- ls /exports
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get pods
  > NAME                          READY   STATUS    RESTARTS   AGE
  > nfs-server-6bc5d94774-pr662   1/1     Running   0          70s
  >
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl exec nfs-server-6bc5d94774-pr662 -- mkdir /exports/pvc
  >
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl exec nfs-server-6bc5d94774-pr662 -- ls /exports
  > index.html
  > lost+found
  > pvc
  > ```

- Now, I will create `PersistentVolume`, `PersistentVolumeClaim` and `nginx` `Deployment`, follwing the content of file [nginx-deployment.yaml](./../manifest/nfs-x-cinder-csi-plugin/nginx-deployment.yaml), you **MUST** use the IPv4 address of the `nfs-service` service which I mentioned in the previous section:
  ```bash
  apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: nfs-pv  # [1] The PersistentVolume name, CAN be changed
    labels:
      app: nfs-data  # [2] The app label, CAN be changed
  spec:
    capacity:
      storage: 1Gi  # The volume size, MUST less than or equal to the size of the PVC that was mounted to the NFS server
    accessModes:
      - ReadWriteMany  # MUST be ReadWriteMany
    nfs:
      server: "<PUT_IPv4_ADDRESS_OF_NFS_SERVICE_HERE>"  # Change this value to proper IPv4 address
      path: "/pvc"  # The path inside the NFS server which I used kubectl exec to create in the previous section
  ---

  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: nfs-pvc  # [3] The PersistentVolumeClaim name, CAN be changed
  spec:
    accessModes:
      - ReadWriteMany  # MUST be ReadWriteMany
    storageClassName: ""  # MUST be empty
    resources:
      requests:
        storage: 1Gi  # The volume size, MUST less than or equal to the size of the volume size of [1]
    selector:
      matchLabels:
        app: nfs-data  # MUST be same value with [2]
  ---

  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nginx-deployment  # [4] The Deployment name, CAN be changed
    labels:
      app: nginx  # [6] The app label, CAN be changed
  spec:
    replicas: 3  # [5] The number of replicas, CAN be changed
    selector:
      matchLabels:
        app: nginx  # MUST be same value with [6]
    template:
      metadata:
        labels:
          app: nginx  # MUST be same value with [6]
      spec:
        containers:
        - name: nginx
          image: nginx
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /var/lib/www/html  # The mount path in container, CAN be changed
              name: my-volume-name  # MUST be same value with [7]
        volumes:
        - name: my-volume-name  # [7] The volume mount name, CAN be changed
          persistentVolumeClaim:
            claimName: nfs-pvc  # MUST be same value with [3]
            readOnly: false
  ```

- Apply the above manifest:
  ```bash
  kubectl apply -f nginx-deployment.yaml
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl apply -f nginx-deployment.yaml
  > persistentvolume/nfs-pv created
  > persistentvolumeclaim/nfs-pvc created
  > deployment.apps/nginx-deployment created
  > ```

- Verify the resources have been created:
  ```bash
  kubectl get sc,pv,pvc -owide
  kubectl get pods -owide
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
  >
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get pods -owide
  > NAME                              READY   STATUS    RESTARTS   AGE   IP               NODE                                             NOMINATED NODE   READINESS GATES
  > nfs-server-6bc5d94774-pr662       1/1     Running   0          14m   10.100.91.1      lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-1   <none>           <none>
  > nginx-deployment-c7f9488d-8bvqs   1/1     Running   0          36s   10.100.91.2      lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-1   <none>           <none>
  > nginx-deployment-c7f9488d-f2dsg   1/1     Running   0          36s   10.100.251.131   lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-0   <none>           <none>
  > nginx-deployment-c7f9488d-ssq9h   1/1     Running   0          36s   10.100.251.130   lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-0   <none>           <none>
  > ```

## 7.5. Test the NFS server
- To test the NFS server, I will `ssh` into each pod of the `nginx` deployment and create some test files, then I will `ssh` into the NFS server pod to verify the test files have been created, finally I will `ssh` into the other pods of the `nginx` deployment to verify the test files have been synchronized to these pods.
- Now, get the pods of `nginx` deployment:
  ```bash
  kubectl get pods -owide
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get pods -owide
  > NAME                              READY   STATUS    RESTARTS   AGE   IP               NODE                                             NOMINATED NODE   READINESS GATES
  > nfs-server-6bc5d94774-pr662       1/1     Running   0          14m   10.100.91.1      lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-1   <none>           <none>
  > nginx-deployment-c7f9488d-8bvqs   1/1     Running   0          36s   10.100.91.2      lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-1   <none>           <none>
  > nginx-deployment-c7f9488d-f2dsg   1/1     Running   0          36s   10.100.251.131   lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-0   <none>           <none>
  > nginx-deployment-c7f9488d-ssq9h   1/1     Running   0          36s   10.100.251.130   lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-0   <none>           <none>
  > ```

- `ssh` into the `nginx-deployment-c7f9488d-8bvqs` pod on `node-1` to create test file:
  ```bash
  kubectl exec -it nginx-deployment-c7f9488d-8bvqs -- bash
  
  # inside the pod
  cd /var/lib/www/html/
  echo "Lalisa - Lisa" > lalisa.txt
  ls
  cat lalisa.txt
  exit
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl exec -it nginx-deployment-c7f9488d-8bvqs -- bash
  >
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# # inside the pod
  > 
  > root@nginx-deployment-c7f9488d-8bvqs:/# cd /var/lib/www/html/
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# echo "Lalisa - Lisa" > lalisa.txt
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# ls
  > lalisa.txt
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# cat lalisa.txt 
  > Lalisa - Lisa
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# exit
  > exit
  > ```

- `ssh` into the `nginx-deployment-c7f9488d-f2dsg` pod on `node-0` to create test file:
  ```bash
  kubectl exec -it nginx-deployment-c7f9488d-f2dsg -- bash

  # inside the pod
  cd /var/lib/www/html/
  ls
  cat lalisa.txt
  echo "On the ground - Rosie" > on-the-ground.txt
  ls
  cat on-the-ground.txt
  exit
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl exec -it nginx-deployment-c7f9488d-f2dsg -- bash
  >
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# # inside the pod
  > 
  > root@nginx-deployment-c7f9488d-f2dsg:/# cd /var/lib/www/html/
  > root@nginx-deployment-c7f9488d-f2dsg:/var/lib/www/html# ls
  > lalisa.txt
  > root@nginx-deployment-c7f9488d-f2dsg:/var/lib/www/html# cat lalisa.txt 
  > Lalisa - Lisa
  > root@nginx-deployment-c7f9488d-f2dsg:/var/lib/www/html# echo "On the ground - Rosie" > on-the-ground.txt
  > root@nginx-deployment-c7f9488d-f2dsg:/var/lib/www/html# ls
  > lalisa.txt  on-the-ground.txt
  > root@nginx-deployment-c7f9488d-f2dsg:/var/lib/www/html# cat on-the-ground.txt 
  > On the ground - Rosie
  > root@nginx-deployment-c7f9488d-f2dsg:/var/lib/www/html# exit
  > exit
  > ```

- `ssh` into the `nginx-deployment-c7f9488d-ssq9h` pod on `node-0` to create test file:
  ```bash
  kubectl exec -it nginx-deployment-c7f9488d-ssq9h -- bash

  # inside the pod
  cd /var/lib/www/html/
  ls
  cat lalisa.txt
  cat on-the-ground.txt
  echo "Flower - Jisoo" > flower.txt
  ls
  cat flower.txt 
  lsblk
  exit
  ```
  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl exec -it nginx-deployment-c7f9488d-ssq9h -- bash
  >
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# # inside the pod
  > 
  > root@nginx-deployment-c7f9488d-ssq9h:/# cd /var/lib/www/html/
  > root@nginx-deployment-c7f9488d-ssq9h:/var/lib/www/html# ls
  > lalisa.txt  on-the-ground.txt
  > root@nginx-deployment-c7f9488d-ssq9h:/var/lib/www/html# cat lalisa.txt 
  > Lalisa - Lisa
  > root@nginx-deployment-c7f9488d-ssq9h:/var/lib/www/html# cat on-the-ground.txt 
  > On the ground - Rosie
  > root@nginx-deployment-c7f9488d-ssq9h:/var/lib/www/html# echo "Flower - Jisoo" > flower.txt
  > root@nginx-deployment-c7f9488d-ssq9h:/var/lib/www/html# ls
  > flower.txt  lalisa.txt	on-the-ground.txt
  > root@nginx-deployment-c7f9488d-ssq9h:/var/lib/www/html# cat flower.txt 
  > Flower - Jisoo
  > root@nginx-deployment-c7f9488d-ssq9h:/var/lib/www/html# lsblk
  > NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
  > vda    252:0    0   20G  0 disk 
  > |-vda1 252:1    0    1M  0 part 
  > |-vda2 252:2    0  127M  0 part 
  > |-vda3 252:3    0  384M  0 part 
  > `-vda4 252:4    0 19.5G  0 part /dev/termination-log
  >                                 /etc/hosts
  > vdb    252:16   0   30G  0 disk /etc/resolv.conf
  >                                 /etc/hostname
  > root@nginx-deployment-c7f9488d-ssq9h:/var/lib/www/html# exit
  > exit
  > ```

- `ssh` back to the first `nginx` pod, check if I can see `on-the-ground.txt` and `flower.txt` exist.
  > ```bash
  > kubectl exec -it nginx-deployment-c7f9488d-8bvqs -- bash
  > 
  > # inside the pod
  > cd /var/lib/www/html/
  > ls
  > cat flower.txt
  > cat lalisa.txt
  > cat on-the-ground.txt
  > exit
  > ```

  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl exec -it nginx-deployment-c7f9488d-8bvqs -- bash
  >
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# # inside the pod
  > 
  > root@nginx-deployment-c7f9488d-8bvqs:/# cd /var/lib/www/html/
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# ls
  > flower.txt  lalisa.txt	on-the-ground.txt
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# cat flower.txt 
  > Flower - Jisoo
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# cat lalisa.txt 
  > Lalisa - Lisa
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# cat on-the-ground.txt 
  > On the ground - Rosie
  > root@nginx-deployment-c7f9488d-8bvqs:/var/lib/www/html# exit
  > exit
  > ```

- Check on the `nfs-server` pod:
  ```bash
  kubectl get pods -owide
  kubectl exec <NFS_SERVER_POD_NAME> -- ls /exports/pvc
  kubectl exec <NFS_SERVER_POD_NAME> -- cat /exports/pvc/flower.txt
  ```

  > ```bash
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl get pods -owide
  > NAME                              READY   STATUS    RESTARTS   AGE     IP               NODE                                             NOMINATED NODE   READINESS GATES
  > nfs-server-6bc5d94774-pr662       1/1     Running   0          19m     10.100.91.1      lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-1   <none>           <none>
  > nginx-deployment-c7f9488d-8bvqs   1/1     Running   0          5m44s   10.100.91.2      lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-1   <none>           <none>
  > nginx-deployment-c7f9488d-f2dsg   1/1     Running   0          5m44s   10.100.251.131   lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-0   <none>           <none>
  > nginx-deployment-c7f9488d-ssq9h   1/1     Running   0          5m44s   10.100.251.130   lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-node-0   <none>           <none>
  > 
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl exec nfs-server-6bc5d94774-pr662 -- ls /exports/pvc
  > flower.txt
  > lalisa.txt
  > on-the-ground.txt
  > 
  > [root@lab-kristy-wheeler-v1-27-6-iwfy6ecxjeby-master-0 core]# kubectl exec nfs-server-6bc5d94774-pr662 -- cat /exports/pvc/flower.txt
  > Flower - Jisoo
  > ```