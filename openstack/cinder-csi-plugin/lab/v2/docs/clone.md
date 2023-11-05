###### [↩ Back to `README`](./../README.md)

# 2. Clone
- This manifest will create a `StorageClass`, 2 `PersistentVolumeClaim`, 2 `PersistentVolume` and 1 `Pod`.
- File [clone.yaml](./manifest/clone/clone.yaml).
  ```yaml
  # Define the StorageClass
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
    name: csi-cinderplugin-sc  # [1] The StorageClass name, CAN be changed
  provisioner: cinder.csi.openstack.org
  parameters:
    type: <PUT_VOLUME_TYPE_UUID_OR_NAME>  # Change it to your volume type UUID or name
  ---

  # Define the source PVC
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: source-pvc  # [2] The source PVC name, CAN be changed
  spec:
    storageClassName: csi-cinderplugin-sc  # MUST be same value with [1]
    accessModes:
      - ReadWriteOnce  # Currently, MUST be ReadWriteOnce
    resources:
      requests:
        storage: 1Gi  # The size of volume, CAN be changed
  ---

  # Define the cloned PVC
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: csi-pvc-clone  # [3] The cloned PVC name, CAN be changed
  spec:
    dataSource:
      name: source-pvc  # The volume name vor volume ID of the source PVC, MUST be same value with [2]
      kind: PersistentVolumeClaim
      apiGroup: ""
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 1Gi
    storageClassName: csi-cinderplugin-sc  # MUST be same value with [1]
  ---

  # Define the Pod that using the cloned PVC
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
          name: csi-data-cinderplugin  # [4] The volume name, CAN be changed
    volumes:
    - name: csi-data-cinderplugin  # MUST be same value with [4]
      persistentVolumeClaim:
        claimName: csi-pvc-clone  # MUST be same value with [3]
        readOnly: false
  ```
- If a `PersistentVolumeClaim` is cloned, the `PersistentVolume` will be cloned too.
- In the **controller server**, the two interfaces of `CreateVolume` and `ControllerPublishVolume` will be called.
  ![](./img/06.png)

- This will be create two volumes in the **OpenStack Cinder**:
  ![](./img/07.png)


- The logs of **controller server**:
  ```bash
  I1101 02:00:14.892645       1 utils.go:88] [ID:2622] GRPC call: /csi.v1.Controller/CreateVolume
  I1101 02:00:14.892814       1 utils.go:89] [ID:2622] GRPC request: {"accessibility_requirements":{"preferred":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"requisite":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}]},"capacity_range":{"required_bytes":1073741824},"name":"pvc-ecd10328-e0df-403a-84cd-5e37c59265cf","parameters":{"csi.storage.k8s.io/pv/name":"pvc-ecd10328-e0df-403a-84cd-5e37c59265cf","csi.storage.k8s.io/pvc/name":"source-pvc","csi.storage.k8s.io/pvc/namespace":"default","type":"7816bad1-7f5b-4400-b2fd-b6334dc32d4b"},"volume_capabilities":[{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}}]}
  I1101 02:00:14.920173       1 controllerserver.go:49] CreateVolume: called with args {"accessibility_requirements":{"preferred":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"requisite":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}]},"capacity_range":{"required_bytes":1073741824},"name":"pvc-ecd10328-e0df-403a-84cd-5e37c59265cf","parameters":{"csi.storage.k8s.io/pv/name":"pvc-ecd10328-e0df-403a-84cd-5e37c59265cf","csi.storage.k8s.io/pvc/name":"source-pvc","csi.storage.k8s.io/pvc/namespace":"default","type":"7816bad1-7f5b-4400-b2fd-b6334dc32d4b"},"volume_capabilities":[{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}}]}
  I1101 02:00:15.624955       1 controllerserver.go:150] CreateVolume: Successfully created volume c5feff62-671e-4472-b35f-cd07f8308acb in Availability Zone: nova of size 1 GiB
  I1101 02:00:15.625010       1 utils.go:94] [ID:2622] GRPC response: {"volume":{"accessible_topology":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"capacity_bytes":1073741824,"volume_id":"c5feff62-671e-4472-b35f-cd07f8308acb"}}
  I1101 02:00:16.829246       1 utils.go:88] [ID:2623] GRPC call: /csi.v1.Controller/CreateVolume
  I1101 02:00:16.829324       1 utils.go:89] [ID:2623] GRPC request: {"accessibility_requirements":{"preferred":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"requisite":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}]},"capacity_range":{"required_bytes":1073741824},"name":"pvc-c88922d8-9a92-40ad-b733-d2ef52615045","parameters":{"csi.storage.k8s.io/pv/name":"pvc-c88922d8-9a92-40ad-b733-d2ef52615045","csi.storage.k8s.io/pvc/name":"csi-pvc-clone","csi.storage.k8s.io/pvc/namespace":"default","type":"7816bad1-7f5b-4400-b2fd-b6334dc32d4b"},"volume_capabilities":[{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}}],"volume_content_source":{"Type":{"Volume":{"volume_id":"c5feff62-671e-4472-b35f-cd07f8308acb"}}}}
  I1101 02:00:16.829705       1 controllerserver.go:49] CreateVolume: called with args {"accessibility_requirements":{"preferred":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"requisite":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}]},"capacity_range":{"required_bytes":1073741824},"name":"pvc-c88922d8-9a92-40ad-b733-d2ef52615045","parameters":{"csi.storage.k8s.io/pv/name":"pvc-c88922d8-9a92-40ad-b733-d2ef52615045","csi.storage.k8s.io/pvc/name":"csi-pvc-clone","csi.storage.k8s.io/pvc/namespace":"default","type":"7816bad1-7f5b-4400-b2fd-b6334dc32d4b"},"volume_capabilities":[{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}}],"volume_content_source":{"Type":{"Volume":{"volume_id":"c5feff62-671e-4472-b35f-cd07f8308acb"}}}}
  I1101 02:00:18.051910       1 controllerserver.go:150] CreateVolume: Successfully created volume cd322b1a-12dd-45b1-9ddb-b44821b2fa8e in Availability Zone: nova of size 1 GiB
  I1101 02:00:18.051949       1 utils.go:94] [ID:2623] GRPC response: {"volume":{"accessible_topology":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"capacity_bytes":1073741824,"content_source":{"Type":{"Volume":{"volume_id":"c5feff62-671e-4472-b35f-cd07f8308acb"}}},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}}
  I1101 02:00:18.671725       1 utils.go:88] [ID:2624] GRPC call: /csi.v1.Controller/ControllerPublishVolume
  I1101 02:00:18.673549       1 utils.go:89] [ID:2624] GRPC request: {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}
  I1101 02:00:18.676341       1 controllerserver.go:179] ControllerPublishVolume: called with args {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}
  E1101 02:00:20.311405       1 controllerserver.go:214] Failed to AttachVolume: failed to attach cd322b1a-12dd-45b1-9ddb-b44821b2fa8e volume to 8222a67a-1a5e-400c-abe1-45d4a94ecd0a compute: Bad request with: [POST http://49.213.90.206:8774/v2.1/c430b410b86f412194999216f04ec39a/servers/8222a67a-1a5e-400c-abe1-45d4a94ecd0a/os-volume_attachments], error message: {"badRequest": {"message": "Invalid input received: Invalid volume: Volume cd322b1a-12dd-45b1-9ddb-b44821b2fa8e status must be available or in-use or downloading to reserve, but the current status is creating. (HTTP 400) (Request-ID: req-57410ebe-38dc-4b5a-86f7-f79e0d776530)", "code": 400}}
  E1101 02:00:20.311462       1 utils.go:92] [ID:2624] GRPC error: rpc error: code = Internal desc = [ControllerPublishVolume] Attach Volume failed with error failed to attach cd322b1a-12dd-45b1-9ddb-b44821b2fa8e volume to 8222a67a-1a5e-400c-abe1-45d4a94ecd0a compute: Bad request with: [POST http://49.213.90.206:8774/v2.1/c430b410b86f412194999216f04ec39a/servers/8222a67a-1a5e-400c-abe1-45d4a94ecd0a/os-volume_attachments], error message: {"badRequest": {"message": "Invalid input received: Invalid volume: Volume cd322b1a-12dd-45b1-9ddb-b44821b2fa8e status must be available or in-use or downloading to reserve, but the current status is creating. (HTTP 400) (Request-ID: req-57410ebe-38dc-4b5a-86f7-f79e0d776530)", "code": 400}}
  I1101 02:00:20.500090       1 utils.go:88] [ID:2625] GRPC call: /csi.v1.Controller/ControllerPublishVolume
  I1101 02:00:20.500116       1 utils.go:89] [ID:2625] GRPC request: {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}
  I1101 02:00:20.500762       1 controllerserver.go:179] ControllerPublishVolume: called with args {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}
  I1101 02:00:26.894079       1 controllerserver.go:231] ControllerPublishVolume cd322b1a-12dd-45b1-9ddb-b44821b2fa8e on 8222a67a-1a5e-400c-abe1-45d4a94ecd0a is successful
  I1101 02:00:26.894419       1 utils.go:94] [ID:2625] GRPC response: {"publish_context":{"DevicePath":"/dev/vdc"}}
  ```

- The logs of **node server**:
  ```bash
  # Phase: NodeStageVolume
  I1101 02:08:23.290616       1 utils.go:88] [ID:8033] GRPC call: /csi.v1.Node/NodeStageVolume
  I1101 02:08:23.290640       1 utils.go:89] [ID:8033] GRPC request: {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}
  I1101 02:08:23.290859       1 nodeserver.go:352] NodeStageVolume: called with args {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}
  I1101 02:08:23.717066       1 mount.go:172] Found disk attached as "virtio-cd322b1a-12dd-45b1-9"; full devicepath: /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9
  I1101 02:08:23.717238       1 mount_linux.go:487] Attempting to determine if disk "/dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9" is formatted using blkid with args: ([-p -s TYPE -s PTTYPE -o export /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9])
  I1101 02:08:23.775299       1 mount_linux.go:490] Output: ""
  I1101 02:08:23.775373       1 mount_linux.go:449] Disk "/dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9" appears to be unformatted, attempting to format as type: "ext4" with options: [-F -m0 /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9]
  I1101 02:08:24.419051       1 mount_linux.go:459] Disk successfully formatted (mkfs): ext4 - /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9 /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount
  I1101 02:08:24.419124       1 mount_linux.go:477] Attempting to mount disk /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9 in ext4 format at /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount
  I1101 02:08:24.419357       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o defaults /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9 /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount)
  I1101 02:08:24.444637       1 mount_linux.go:487] Attempting to determine if disk "/dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9" is formatted using blkid with args: ([-p -s TYPE -s PTTYPE -o export /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9])
  I1101 02:08:24.465440       1 mount_linux.go:490] Output: "DEVNAME=/dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9\nTYPE=ext4\n"
  I1101 02:08:24.465477       1 resizefs_linux.go:124] ResizeFs.needResize - checking mounted volume /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9
  I1101 02:08:24.469372       1 resizefs_linux.go:128] Ext size: filesystem size=1073741824, block size=4096
  I1101 02:08:24.469502       1 resizefs_linux.go:140] Volume /dev/disk/by-id/virtio-cd322b1a-12dd-45b1-9: device size=1073741824, filesystem size=1073741824, block size=4096
  I1101 02:08:24.469627       1 utils.go:94] [ID:8033] GRPC response: {}

  # ...

  # Phase: NodePublishVolume
  I1101 02:08:24.488079       1 utils.go:88] [ID:8037] GRPC call: /csi.v1.Node/NodePublishVolume
  I1101 02:08:24.488096       1 utils.go:89] [ID:8037] GRPC request: {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount","target_path":"/var/lib/kubelet/pods/12085192-7a90-447a-864b-0b96173a604a/volumes/kubernetes.io~csi/pvc-c88922d8-9a92-40ad-b733-d2ef52615045/mount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"csi.storage.k8s.io/ephemeral":"false","csi.storage.k8s.io/pod.name":"nginx","csi.storage.k8s.io/pod.namespace":"default","csi.storage.k8s.io/pod.uid":"12085192-7a90-447a-864b-0b96173a604a","csi.storage.k8s.io/serviceAccount.name":"default","storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}
  I1101 02:08:24.488211       1 nodeserver.go:51] NodePublishVolume: called with args {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount","target_path":"/var/lib/kubelet/pods/12085192-7a90-447a-864b-0b96173a604a/volumes/kubernetes.io~csi/pvc-c88922d8-9a92-40ad-b733-d2ef52615045/mount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"csi.storage.k8s.io/ephemeral":"false","csi.storage.k8s.io/pod.name":"nginx","csi.storage.k8s.io/pod.namespace":"default","csi.storage.k8s.io/pod.uid":"12085192-7a90-447a-864b-0b96173a604a","csi.storage.k8s.io/serviceAccount.name":"default","storage.kubernetes.io/csiProvisionerIdentity":"1698725962891-8081-cinder.csi.openstack.org"},"volume_id":"cd322b1a-12dd-45b1-9ddb-b44821b2fa8e"}
  I1101 02:08:24.706661       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o bind /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount /var/lib/kubelet/pods/12085192-7a90-447a-864b-0b96173a604a/volumes/kubernetes.io~csi/pvc-c88922d8-9a92-40ad-b733-d2ef52615045/mount)
  I1101 02:08:24.710693       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o bind,remount,rw /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/7f218661ee05b91ca97047a477c82bd9a012f71b450a4f992271a450d961c4df/globalmount /var/lib/kubelet/pods/12085192-7a90-447a-864b-0b96173a604a/volumes/kubernetes.io~csi/pvc-c88922d8-9a92-40ad-b733-d2ef52615045/mount)
  I1101 02:08:24.714410       1 utils.go:94] [ID:8037] GRPC response: {}
  ```