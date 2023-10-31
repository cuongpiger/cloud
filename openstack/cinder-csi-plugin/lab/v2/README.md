# 1. Block
- The K8s manifest.
  ```yaml
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
    name: csi-sc-cinderplugin  # [1] The StorageClass name, CAN be changed
  provisioner: cinder.csi.openstack.org
  parameters:
    type: <PUT_VOLUME_TYPE_UUID_OR_NAME>  # Change it to your volume type UUID or name

  ---
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: csi-pvc-cinderplugin  # [2] The PVC name, CAN be changed
  spec:
    accessModes:
    - ReadWriteOnce  # MUST set this value, currently only support RWO
    resources:
      requests:
        storage: 1Gi  # [3] The PVC size, CAN be changed
    storageClassName: csi-sc-cinderplugin  # MUST be same value with [1]

  ---
  apiVersion: v1
  kind: Pod
  metadata:
    name: nginx
  spec:
    containers:
    - image: nginx
      imagePullPolicy: Always
      name: nginx
      ports:
      - containerPort: 80
        protocol: TCP
      volumeMounts:
        - mountPath: /var/lib/www/html  # The mount path in container, CAN be changed
          name: csi-data-cinderplugin  # MUST be same value with [4]
    volumes:
    - name: csi-data-cinderplugin  # [4] The volume mount name, CAN be changed
      persistentVolumeClaim:
        claimName: csi-pvc-cinderplugin  # MUST be same value with [2]
        readOnly: false
  ```