###### [↩ Back to `README`](./../README.md)

# 6. Migrate `PersistentVolumeClaim` to new Kubernetes
- Suppose you have a Kubernetes cluster $A$ with the `PersistentVolumeClaim` $\text{pvc}$. Now, you want to migrate the $pvc$ to a new Kubernetes cluster $B$. This guide will show you how to do it, step by step:
  - **Step 1**: Decrease number of replicas of the deployment that is using the $pvc$ to 0.
  ```bash
  kubectl scale deployment <DEPLOYMENT_NAME> -n <NAMESPACE> --replicas=0
  ```

  - **Step 2**: Get the list of all `PersistentVolume` in your Kubernetes cluster:
  ```bash
  kubectl get pv
  ```
  > - Suppose I have a `PersistentVolume` with the name $\text{pvc-abcxyz}$ after executing the above command.

  - **Step 3**: Get the **backend volume ID** of the $\text{pvc}$:
  ```bash