###### [↩ Back to `README`](./../README.md)

# 1. Block
## 1.1. Apply the manifest
- The K8s manifest. This manifest will create a `StorageClass`, a `PersistentVolumeClaim` and a `Pod`, the `Pod` will mount the `PersistentVolumeClaim` as a volume.
- The values of `<PUT_VOLUME_TYPE_UUID_OR_NAME>` can be:
  - `3000iops_PUBC06-NVME-01`
  - `5000iops_PUBC06-NVME-01`
  - `10000iops_PUBC06-NVME-01`
  - `20000iops_PUBC06-NVME-01`
  - `40000iops_PUBC06-NVME-01`
  - `60000iops_PUBC06-NVME-01`

- File [block.yaml](../manifest/block/block.yaml).
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
- Logs of **controller server**:
  ```bash
  # Phase: CreateVolume
  I1031 04:26:30.758150       1 utils.go:88] [ID:36] GRPC call: /csi.v1.Controller/CreateVolume
  I1031 04:26:30.758201       1 utils.go:89] [ID:36] GRPC request: {"accessibility_requirements":{"preferred":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"requisite":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}]},"capacity_range":{"required_bytes":1073741824},"name":"pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a","parameters":{"csi.storage.k8s.io/pv/name":"pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a","csi.storage.k8s.io/pvc/name":"csi-pvc-cinderplugin","csi.storage.k8s.io/pvc/namespace":"default","type":"7816bad1-7f5b-4400-b2fd-b6334dc32d4b"},"volume_capabilities":[{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}}]}
  I1031 04:26:30.758704       1 controllerserver.go:49] CreateVolume: called with args {"accessibility_requirements":{"preferred":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"requisite":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}]},"capacity_range":{"required_bytes":1073741824},"name":"pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a","parameters":{"csi.storage.k8s.io/pv/name":"pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a","csi.storage.k8s.io/pvc/name":"csi-pvc-cinderplugin","csi.storage.k8s.io/pvc/namespace":"default","type":"7816bad1-7f5b-4400-b2fd-b6334dc32d4b"},"volume_capabilities":[{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}}]}
  I1031 04:26:31.465832       1 controllerserver.go:150] CreateVolume: Successfully created volume 23698f4e-3558-4efe-9a74-440f7fc7cd74 in Availability Zone: nova of size 1 GiB
  I1031 04:26:31.465937       1 utils.go:94] [ID:36] GRPC response: {"volume":{"accessible_topology":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"capacity_bytes":1073741824,"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}}
  
  # ...

  # Phase: ControllerPublishVolume
  I1031 04:26:32.052531       1 utils.go:88] [ID:37] GRPC call: /csi.v1.Controller/ControllerPublishVolume
  I1031 04:26:32.052672       1 utils.go:89] [ID:37] GRPC request: {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 04:26:32.052948       1 controllerserver.go:179] ControllerPublishVolume: called with args {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 04:26:38.185161       1 controllerserver.go:231] ControllerPublishVolume 23698f4e-3558-4efe-9a74-440f7fc7cd74 on 8222a67a-1a5e-400c-abe1-45d4a94ecd0a is successful
  I1031 04:26:38.185215       1 utils.go:94] [ID:37] GRPC response: {"publish_context":{"DevicePath":"/dev/vdc"}}
  ```

- Logs of **node server**:
  ```bash
  # Phase: NodeStageVolume
  I1031 04:34:31.418962       1 utils.go:88] [ID:23] GRPC call: /csi.v1.Node/NodeStageVolume
  I1031 04:34:31.418985       1 utils.go:89] [ID:23] GRPC request: {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 04:34:31.419424       1 nodeserver.go:352] NodeStageVolume: called with args {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 04:34:31.802377       1 mount.go:172] Found disk attached as "virtio-23698f4e-3558-4efe-9"; full devicepath: /dev/disk/by-id/virtio-23698f4e-3558-4efe-9
  I1031 04:34:31.802708       1 mount_linux.go:487] Attempting to determine if disk "/dev/disk/by-id/virtio-23698f4e-3558-4efe-9" is formatted using blkid with args: ([-p -s TYPE -s PTTYPE -o export /dev/disk/by-id/virtio-23698f4e-3558-4efe-9])
  I1031 04:34:31.834373       1 mount_linux.go:490] Output: ""
  I1031 04:34:31.834511       1 mount_linux.go:449] Disk "/dev/disk/by-id/virtio-23698f4e-3558-4efe-9" appears to be unformatted, attempting to format as type: "ext4" with options: [-F -m0 /dev/disk/by-id/virtio-23698f4e-3558-4efe-9]
  I1031 04:34:32.311239       1 mount_linux.go:459] Disk successfully formatted (mkfs): ext4 - /dev/disk/by-id/virtio-23698f4e-3558-4efe-9 /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount
  I1031 04:34:32.311680       1 mount_linux.go:477] Attempting to mount disk /dev/disk/by-id/virtio-23698f4e-3558-4efe-9 in ext4 format at /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount
  I1031 04:34:32.311754       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o defaults /dev/disk/by-id/virtio-23698f4e-3558-4efe-9 /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount)
  I1031 04:34:32.338494       1 utils.go:94] [ID:23] GRPC response: {}
  
  # ...


  # Phase: NodePublishVolume
  I1031 04:34:32.353974       1 utils.go:88] [ID:27] GRPC call: /csi.v1.Node/NodePublishVolume
  I1031 04:34:32.354001       1 utils.go:89] [ID:27] GRPC request: {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount","target_path":"/var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"csi.storage.k8s.io/ephemeral":"false","csi.storage.k8s.io/pod.name":"nginx","csi.storage.k8s.io/pod.namespace":"default","csi.storage.k8s.io/pod.uid":"9d8af40f-ced2-423e-a5bc-ff25b0359bc8","csi.storage.k8s.io/serviceAccount.name":"default","storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 04:34:32.354198       1 nodeserver.go:51] NodePublishVolume: called with args {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount","target_path":"/var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"csi.storage.k8s.io/ephemeral":"false","csi.storage.k8s.io/pod.name":"nginx","csi.storage.k8s.io/pod.namespace":"default","csi.storage.k8s.io/pod.uid":"9d8af40f-ced2-423e-a5bc-ff25b0359bc8","csi.storage.k8s.io/serviceAccount.name":"default","storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 04:34:32.515021       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o bind /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount /var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount)
  I1031 04:34:32.520586       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o bind,remount,rw /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount /var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount)
  I1031 04:34:32.525324       1 utils.go:94] [ID:27] GRPC response: {}
  ```

- Expected output:
  ![](./img/01.png)

## 1.2. Delete the `nginx` pod
- To **unmount** a `PersistentVolumeClaim` out of the Kubernetes resources, the simple way is to delete the `Pod` which mounts the `PersistentVolumeClaim`.
- Despite the `Pod` is deleted, the `PersistentVolumeClaim` and `PersistentVolume` is still there $\Rightarrow$ The volume that the `PersistentVolumeClaim` mounts is still there in the OpenStack.
  - The `PersistentVolumeClaim` and `PersistentVolume` do not be deleted because the `reclaimPolicy` of `PersistentVolume` is `Retain`.
    ![](./img/02.png)
  
  - The volume is still there in the **OpenStack Cinder**:
    ![](./img/03.png)

- The log of **controller server**:
  ```bash
  # Phase: ControllerUnpublishVolume
  I1031 07:23:12.512712       1 utils.go:88] [ID:391] GRPC call: /csi.v1.Controller/ControllerUnpublishVolume
  I1031 07:23:12.512745       1 utils.go:89] [ID:391] GRPC request: {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 07:23:12.513029       1 controllerserver.go:243] ControllerUnpublishVolume: called with args {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 07:23:13.563345       1 openstack_volumes.go:290] Successfully detached volume: 23698f4e-3558-4efe-9a74-440f7fc7cd74 from compute: 8222a67a-1a5e-400c-abe1-45d4a94ecd0a
  I1031 07:23:14.905472       1 controllerserver.go:281] ControllerUnpublishVolume 23698f4e-3558-4efe-9a74-440f7fc7cd74 on 8222a67a-1a5e-400c-abe1-45d4a94ecd0a
  I1031 07:23:14.905701       1 utils.go:94] [ID:391] GRPC response: {}
  I1031 07:23:17.127837       1 utils.go:88] [ID:392] GRPC call: /csi.v1.Controller/ListVolumes
  I1031 07:23:17.128033       1 utils.go:89] [ID:392] GRPC request: {}
  I1031 07:23:17.316177       1 utils.go:94] [ID:392] GRPC response: {"entries":[{"status":{},"volume":{"capacity_bytes":1073741824,"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}},{"status":{"published_node_ids":["b391c204-3407-4ea8-8261-daa6ee7aee19"]},"volume":{"capacity_bytes":32212254720,"volume_id":"e66a6e2d-0992-48f3-86b1-a4f046453562"}},{"status":{"published_node_ids":["8222a67a-1a5e-400c-abe1-45d4a94ecd0a"]},"volume":{"capacity_bytes":32212254720,"volume_id":"27d8d7ea-b1fe-4df3-af12-553db4340d97"}},{"status":{"published_node_ids":["b391c204-3407-4ea8-8261-daa6ee7aee19"]},"volume":{"capacity_bytes":21474836480,"volume_id":"7a230f33-0ca3-413f-ab5f-7489023e43df"}},{"status":{"published_node_ids":["8222a67a-1a5e-400c-abe1-45d4a94ecd0a"]},"volume":{"capacity_bytes":21474836480,"volume_id":"2a92b979-2b27-4ae6-860e-070cc8a198de"}},{"status":{"published_node_ids":["63718a7b-6b7c-400a-84d8-89b1fe104e11"]},"volume":{"capacity_bytes":32212254720,"volume_id":"656ee556-cf8f-4ab2-8d7f-c413a8192bbc"}},{"status":{"published_node_ids":["63718a7b-6b7c-400a-84d8-89b1fe104e11"]},"volume":{"capacity_bytes":53687091200,"volume_id":"15125760-06b3-4faa-b491-804b5c5e8413"}},{"status":{"published_node_ids":["63718a7b-6b7c-400a-84d8-89b1fe104e11"]},"volume":{"capacity_bytes":21474836480,"volume_id":"17f9eaef-2061-4be2-9179-a86549c7a510"}}]}
  ```

- The log of **node server**:
  ```bash
  # Phase: NodeUnpublishVolume
  I1031 07:30:58.683233       1 utils.go:88] [ID:1322] GRPC call: /csi.v1.Node/NodeUnpublishVolume
  I1031 07:30:58.683310       1 utils.go:89] [ID:1322] GRPC request: {"target_path":"/var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount","volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 07:30:58.683885       1 nodeserver.go:269] NodeUnPublishVolume: called with args {"target_path":"/var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount","volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 07:30:59.138726       1 mount_helper_common.go:99] "/var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount" is a mountpoint, unmounting
  I1031 07:30:59.139052       1 mount_linux.go:294] Unmounting /var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount
  W1031 07:30:59.145964       1 mount_helper_common.go:133] Warning: "/var/lib/kubelet/pods/9d8af40f-ced2-423e-a5bc-ff25b0359bc8/volumes/kubernetes.io~csi/pvc-7a25697b-3bdb-40ee-80b7-a17995c7b15a/mount" is not a mountpoint, deleting
  I1031 07:30:59.146307       1 utils.go:94] [ID:1322] GRPC response: {}

  # ...

  # Phase: NodeUnstageVolume
  I1031 07:30:59.189682       1 utils.go:88] [ID:1324] GRPC call: /csi.v1.Node/NodeUnstageVolume
  I1031 07:30:59.189745       1 utils.go:89] [ID:1324] GRPC request: {"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount","volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 07:30:59.189937       1 nodeserver.go:437] NodeUnstageVolume: called with args {"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount","volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 07:30:59.378752       1 mount_helper_common.go:99] "/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount" is a mountpoint, unmounting
  I1031 07:30:59.378797       1 mount_linux.go:294] Unmounting /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount
  W1031 07:30:59.391695       1 mount_helper_common.go:133] Warning: "/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/85d87f63e677d7e240db3075b94e22af56ee13bfb663575ef26a6b4550bb343f/globalmount" is not a mountpoint, deleting
  I1031 07:30:59.391824       1 utils.go:94] [ID:1324] GRPC response: {}
  ```

## 1.3. Delete `PersistentVolumeClaim`
- If a `PersistentVolumeClaim` is deleted, the `PersistentVolume` will be deleted too.
  ![](./img/04.png)

- It causes the volume that the `PersistentVolumeClaim` mounts is deleted in the OpenStack Cinder.
  ![](./img/05.png)
- The logs of **controller server**:
  ```bash
  # Phase: DeleteVolume
  I1031 07:43:33.020579       1 utils.go:88] [ID:433] GRPC call: /csi.v1.Controller/DeleteVolume
  I1031 07:43:33.020612       1 utils.go:89] [ID:433] GRPC request: {"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 07:43:33.020715       1 controllerserver.go:156] DeleteVolume: called with args {"volume_id":"23698f4e-3558-4efe-9a74-440f7fc7cd74"}
  I1031 07:43:33.364360       1 controllerserver.go:173] DeleteVolume: Successfully deleted volume 23698f4e-3558-4efe-9a74-440f7fc7cd74
  I1031 07:43:33.364771       1 utils.go:94] [ID:433] GRPC response: {}
  ```