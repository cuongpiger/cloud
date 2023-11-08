###### [↩ Back to `README`](./../README.md)

# 4. Resize
- Apply the below manifest to create a PVC, a Pod and a StorageClass.
- To get the `StorageClass`'s type, visit [here](./../docs/block.md#11-apply-the-manifest).
- File [resize.yaml](./../manifest/resize/resize.yaml)
  ```yaml
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
    name: csi-sc-cinderplugin  # [1] The name of the StorageClass, CAN be changed
  parameters:
    type: 5000iops_PUBC06-NVME-01  # The IOPS type of the volume, CAN be changed
  provisioner: cinder.csi.openstack.org
  allowVolumeExpansion: true  # enable volume expansion

  ---
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: csi-pvc-cinderplugin  # [2] The name of the PVC, CAN be changed
  spec:
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 1Gi
    storageClassName: csi-sc-cinderplugin  # MUST be the same as [1]

  ---
  apiVersion: v1
  kind: Pod
  metadata:
    name: nginx
  spec:
    containers:
    - image: nginx
      imagePullPolicy: IfNotPresent
      name: nginx
      ports:
      - containerPort: 80
        protocol: TCP
      volumeMounts:
        - mountPath: /var/lib/www/html
          name: csi-data-cinderplugin  # [3] The name of the volume, CAN be changed
    volumes:
    - name: csi-data-cinderplugin  # MUST be the same as [3]
      persistentVolumeClaim:
        claimName: csi-pvc-cinderplugin  # MUST be the same as [2]
        readOnly: false
  ```

- To resize the PVC `csi-pvc-cinderplugin`, run the below command:
  ```bash
  cat <<EOF | kubectl apply -f-
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: csi-pvc-cinderplugin
  spec:
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 5Gi  # change the size to 5Gi
    storageClassName: csi-sc-cinderplugin
  EOF
  ```



- The logs of **controller server**:
  ```bash
  I1105 14:37:16.542513       1 utils.go:88] [ID:19045] GRPC call: /csi.v1.Controller/ControllerExpandVolume
  I1105 14:37:16.542565       1 utils.go:89] [ID:19045] GRPC request: {"capacity_range":{"required_bytes":5368709120},"volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_id":"bdde744e-0ed5-4ef8-8e49-092c4875729f"}
  I1105 14:37:16.549702       1 controllerserver.go:595] ControllerExpandVolume: called with args {"capacity_range":{"required_bytes":5368709120},"volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_id":"bdde744e-0ed5-4ef8-8e49-092c4875729f"}
  I1105 14:37:18.327947       1 controllerserver.go:644] ControllerExpandVolume resized volume bdde744e-0ed5-4ef8-8e49-092c4875729f to size 5
  I1105 14:37:18.328020       1 utils.go:94] [ID:19045] GRPC response: {"capacity_bytes":5368709120,"node_expansion_required":true}
  ```

- The logs of **node server**:
  ```bash
  I1105 14:45:27.704504       1 utils.go:88] [ID:47328] GRPC call: /csi.v1.Node/NodeExpandVolume
  I1105 14:45:27.704538       1 utils.go:89] [ID:47328] GRPC request: {"capacity_range":{"required_bytes":5368709120},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/a5f104386b3ae2fb4fe8786d5fce043360d7d191e33516e16739bb2a5c8f1518/globalmount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_id":"bdde744e-0ed5-4ef8-8e49-092c4875729f","volume_path":"/var/lib/kubelet/pods/a6ff173c-71a0-4015-b4e3-83585d902ac9/volumes/kubernetes.io~csi/pvc-7532e54a-c4dd-4fcd-9f0e-ea4ef034bbe1/mount"}
  I1105 14:45:27.704832       1 nodeserver.go:541] NodeExpandVolume: called with args {"capacity_range":{"required_bytes":5368709120},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/a5f104386b3ae2fb4fe8786d5fce043360d7d191e33516e16739bb2a5c8f1518/globalmount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_id":"bdde744e-0ed5-4ef8-8e49-092c4875729f","volume_path":"/var/lib/kubelet/pods/a6ff173c-71a0-4015-b4e3-83585d902ac9/volumes/kubernetes.io~csi/pvc-7532e54a-c4dd-4fcd-9f0e-ea4ef034bbe1/mount"}
  I1105 14:45:27.921940       1 mount_linux.go:487] Attempting to determine if disk "/dev/vdc" is formatted using blkid with args: ([-p -s TYPE -s PTTYPE -o export /dev/vdc])
  I1105 14:45:27.927204       1 mount_linux.go:490] Output: "DEVNAME=/dev/vdc\nTYPE=ext4\n"
  I1105 14:45:27.927289       1 resizefs_linux.go:56] ResizeFS.Resize - Expanding mounted volume /dev/vdc
  I1105 14:45:28.071401       1 resizefs_linux.go:71] Device /dev/vdc resized successfully
  I1105 14:45:28.071439       1 utils.go:94] [ID:47328] GRPC response: {}
  ```