###### [↩ Back to `README`](./../README.md)

# 3. Default resources
- After installing the `vcontainer-storage-interface`, there are 2 `StorageClass` that are installed by default.
- The `PROVISIONER` value **MUST** be `csi.vngcloud.vn`.
  ```bash
  kubectl get sc -owide
  ```
  > ![](./../img/02.png)

- And there are no `PersistentVolume` or `PersistentVolumeClaim` that are created by default.
  ```bash
  kubectl get pvc
  kubectl get pv
  ```
  > ![](./../img/03.png)