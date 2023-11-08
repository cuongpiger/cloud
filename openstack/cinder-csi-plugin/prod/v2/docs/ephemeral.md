###### [↩ Back to `README`](./../README.md)

# 3. Ephemeral
## 3.1. Ephemeral inline volumes
- Epheemeral inline volumes do not create a persistent volume object in Kubernetes, and are not managed by the CSI driver, or cloud providers.
- They are created and destroyed with the pod.
- File [inline-volume.yaml](./../manifest/ephemeral/inline-volume.yaml)
  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: inline-pod  # The pod name, CAN be changed
  spec:
    containers:
    - image: nginx
      imagePullPolicy: IfNotPresent
      name: nginx-inline
      volumeMounts:
      - name: my-csi-volume  # [1] The name of the volume, CAN be changed
        mountPath: /var/lib/www/html
    volumes:
    - name: my-csi-volume  # MUST match [1]
      csi:
        driver: cinder.csi.openstack.org  # The name of CSI driver
        volumeAttributes:
          capacity: 1Gi # default is 1Gi
        readOnly: false  # default is false
        fsType: ext4 # default is ext4
  ```

## 3.2. Ephemeral volumes
- This type of volumes are created and managed by the CSI driver, and cloud providers.
- It also creates a volume in OpenStack Cinder.
- The `PersistentVolume` and `PersistentVolumeClaim` objects are deleted when the pod is deleted.
- File [ephemeral.yaml](./../manifest/ephemeral/ephemeral.yaml)
  ```yaml
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
    name: scratch-storage-class  # [1] The name of the storage class, CAN be changed
  provisioner: cinder.csi.openstack.org

  ---
  apiVersion: v1
  kind: Pod
  metadata:
    name: ephemeral-example  # [2] The name of the pod, CAN be changed
  spec:
    containers:
    - image: nginx
      imagePullPolicy: IfNotPresent
      name: nginx-inline
      volumeMounts:
      - name: scratch-volume  # [3] The name of the volume, CAN be changed
        mountPath: /var/lib/www/html
    volumes:
    - name: scratch-volume  # MUST match [3]
      ephemeral:
        volumeClaimTemplate:
          metadata:
            labels:
              type: my-frontend-volume  # [4] The name of the volume, CAN be changed
          spec:
            accessModes: [ "ReadWriteOnce" ]
            storageClassName: scratch-storage-class  # MUST match [1]
            resources:
              requests:
                storage: 1Gi
  ```

- Logs of the **controller node**:
  ```bash
  I1105 14:15:47.277669       1 utils.go:88] [ID:18993] GRPC call: /csi.v1.Controller/CreateVolume
  I1105 14:15:47.277695       1 utils.go:89] [ID:18993] GRPC request: {"accessibility_requirements":{"preferred":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"requisite":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}]},"capacity_range":{"required_bytes":1073741824},"name":"pvc-e5cda086-ed40-47f6-b382-f51c9a0d9377","parameters":{"csi.storage.k8s.io/pv/name":"pvc-e5cda086-ed40-47f6-b382-f51c9a0d9377","csi.storage.k8s.io/pvc/name":"ephemeral-example-scratch-volume","csi.storage.k8s.io/pvc/namespace":"default"},"volume_capabilities":[{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}}]}
  I1105 14:15:47.277887       1 controllerserver.go:49] CreateVolume: called with args {"accessibility_requirements":{"preferred":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"requisite":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}]},"capacity_range":{"required_bytes":1073741824},"name":"pvc-e5cda086-ed40-47f6-b382-f51c9a0d9377","parameters":{"csi.storage.k8s.io/pv/name":"pvc-e5cda086-ed40-47f6-b382-f51c9a0d9377","csi.storage.k8s.io/pvc/name":"ephemeral-example-scratch-volume","csi.storage.k8s.io/pvc/namespace":"default"},"volume_capabilities":[{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}}]}
  I1105 14:15:47.858710       1 controllerserver.go:150] CreateVolume: Successfully created volume 8497591d-97eb-4687-a37a-2ed1d111aa88 in Availability Zone: nova of size 1 GiB
  I1105 14:15:47.939800       1 utils.go:94] [ID:18993] GRPC response: {"volume":{"accessible_topology":[{"segments":{"topology.cinder.csi.openstack.org/zone":"nova"}}],"capacity_bytes":1073741824,"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}}
  I1105 14:15:49.549550       1 utils.go:88] [ID:18994] GRPC call: /csi.v1.Controller/ControllerPublishVolume
  I1105 14:15:49.549581       1 utils.go:89] [ID:18994] GRPC request: {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1699188944396-8081-cinder.csi.openstack.org"},"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}
  I1105 14:15:49.557911       1 controllerserver.go:179] ControllerPublishVolume: called with args {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1699188944396-8081-cinder.csi.openstack.org"},"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}

  # ...

  I1105 14:15:55.445632       1 controllerserver.go:231] ControllerPublishVolume 8497591d-97eb-4687-a37a-2ed1d111aa88 on 8222a67a-1a5e-400c-abe1-45d4a94ecd0a is successful
  I1105 14:15:55.445696       1 utils.go:94] [ID:18994] GRPC response: {"publish_context":{"DevicePath":"/dev/vdc"}}
  I1105 14:15:55.581912       1 utils.go:88] [ID:18996] GRPC call: /csi.v1.Controller/ControllerPublishVolume
  I1105 14:15:55.581946       1 utils.go:89] [ID:18996] GRPC request: {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1699188944396-8081-cinder.csi.openstack.org"},"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}
  I1105 14:15:55.582101       1 controllerserver.go:179] ControllerPublishVolume: called with args {"node_id":"8222a67a-1a5e-400c-abe1-45d4a94ecd0a","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1699188944396-8081-cinder.csi.openstack.org"},"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}
  I1105 14:15:56.466983       1 openstack_volumes.go:184] Disk 8497591d-97eb-4687-a37a-2ed1d111aa88 is already attached to instance 8222a67a-1a5e-400c-abe1-45d4a94ecd0a
  I1105 14:15:56.795017       1 controllerserver.go:231] ControllerPublishVolume 8497591d-97eb-4687-a37a-2ed1d111aa88 on 8222a67a-1a5e-400c-abe1-45d4a94ecd0a is successful
  I1105 14:15:56.795085       1 utils.go:94] [ID:18996] GRPC response: {"publish_context":{"DevicePath":"/dev/vdc"}}
  ```

- The logs of the **node server**:
  ```bash
  I1105 14:23:49.380978       1 utils.go:88] [ID:47170] GRPC call: /csi.v1.Node/NodeStageVolume
  I1105 14:23:49.381047       1 utils.go:89] [ID:47170] GRPC request: {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1699188944396-8081-cinder.csi.openstack.org"},"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}
  I1105 14:23:49.381412       1 nodeserver.go:352] NodeStageVolume: called with args {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1699188944396-8081-cinder.csi.openstack.org"},"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}
  I1105 14:23:49.543419       1 mount.go:172] Found disk attached as "virtio-8497591d-97eb-4687-a"; full devicepath: /dev/disk/by-id/virtio-8497591d-97eb-4687-a
  I1105 14:23:49.543789       1 mount_linux.go:487] Attempting to determine if disk "/dev/disk/by-id/virtio-8497591d-97eb-4687-a" is formatted using blkid with args: ([-p -s TYPE -s PTTYPE -o export /dev/disk/by-id/virtio-8497591d-97eb-4687-a])
  I1105 14:23:49.575377       1 mount_linux.go:490] Output: ""
  I1105 14:23:49.575624       1 mount_linux.go:449] Disk "/dev/disk/by-id/virtio-8497591d-97eb-4687-a" appears to be unformatted, attempting to format as type: "ext4" with options: [-F -m0 /dev/disk/by-id/virtio-8497591d-97eb-4687-a]
  I1105 14:23:50.306001       1 mount_linux.go:459] Disk successfully formatted (mkfs): ext4 - /dev/disk/by-id/virtio-8497591d-97eb-4687-a /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount
  I1105 14:23:50.306050       1 mount_linux.go:477] Attempting to mount disk /dev/disk/by-id/virtio-8497591d-97eb-4687-a in ext4 format at /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount
  I1105 14:23:50.306123       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o defaults /dev/disk/by-id/virtio-8497591d-97eb-4687-a /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount)
  I1105 14:23:50.328413       1 utils.go:94] [ID:47170] GRPC response: {}

  # ...

  I1105 14:23:50.345651       1 utils.go:88] [ID:47174] GRPC call: /csi.v1.Node/NodePublishVolume
  I1105 14:23:50.345693       1 utils.go:89] [ID:47174] GRPC request: {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount","target_path":"/var/lib/kubelet/pods/eeb0617d-663a-4430-945b-25b98a696510/volumes/kubernetes.io~csi/pvc-e5cda086-ed40-47f6-b382-f51c9a0d9377/mount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"csi.storage.k8s.io/ephemeral":"false","csi.storage.k8s.io/pod.name":"ephemeral-example","csi.storage.k8s.io/pod.namespace":"default","csi.storage.k8s.io/pod.uid":"eeb0617d-663a-4430-945b-25b98a696510","csi.storage.k8s.io/serviceAccount.name":"default","storage.kubernetes.io/csiProvisionerIdentity":"1699188944396-8081-cinder.csi.openstack.org"},"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}
  I1105 14:23:50.346110       1 nodeserver.go:51] NodePublishVolume: called with args {"publish_context":{"DevicePath":"/dev/vdc"},"staging_target_path":"/var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount","target_path":"/var/lib/kubelet/pods/eeb0617d-663a-4430-945b-25b98a696510/volumes/kubernetes.io~csi/pvc-e5cda086-ed40-47f6-b382-f51c9a0d9377/mount","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"csi.storage.k8s.io/ephemeral":"false","csi.storage.k8s.io/pod.name":"ephemeral-example","csi.storage.k8s.io/pod.namespace":"default","csi.storage.k8s.io/pod.uid":"eeb0617d-663a-4430-945b-25b98a696510","csi.storage.k8s.io/serviceAccount.name":"default","storage.kubernetes.io/csiProvisionerIdentity":"1699188944396-8081-cinder.csi.openstack.org"},"volume_id":"8497591d-97eb-4687-a37a-2ed1d111aa88"}
  I1105 14:23:50.477125       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o bind /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount /var/lib/kubelet/pods/eeb0617d-663a-4430-945b-25b98a696510/volumes/kubernetes.io~csi/pvc-e5cda086-ed40-47f6-b382-f51c9a0d9377/mount)
  I1105 14:23:50.482019       1 mount_linux.go:183] Mounting cmd (mount) with arguments (-t ext4 -o bind,remount,rw /var/lib/kubelet/plugins/kubernetes.io/csi/cinder.csi.openstack.org/d99a0e55b335359b803f9ef67ee9df920eb421d4ad7d980eb130ab2b9c86f462/globalmount /var/lib/kubelet/pods/eeb0617d-663a-4430-945b-25b98a696510/volumes/kubernetes.io~csi/pvc-e5cda086-ed40-47f6-b382-f51c9a0d9377/mount)
  I1105 14:23:50.485690       1 utils.go:94] [ID:47174] GRPC response: {}
  ```