###### [↩ Back to `README`](./../README.md)

# 6. Migrate `PersistentVolumeClaim` to new Kubernetes clusters
- Suppose you have a Kubernetes cluster $A$ with the `PersistentVolumeClaim` $\text{pvc}$. Now, you want to migrate the $\text{pvc}$ to a new Kubernetes cluster $B$. This guide will show you how to do it, step by step:
  - **Step 1**: Decrease number of replicas of the deployment that is using the $\text{pvc}$ to 0.
  ```bash
  # cluster A
  kubectl scale deployment <DEPLOYMENT_NAME> --replicas=0
  ```

  - **Step 2**: Get the list of all `PersistentVolume` in your Kubernetes cluster:
  ```bash
  # cluster A
  kubectl get pv
  ```
  > - Suppose I want to migrate a `PersistentVolume` with the name $\text{pvc-4846ea7c-489b-4aaa-ba9b-0e7b4e44b6d5}$ after executing the above command.

  - **Step 3**: Get the **backend volume ID** of the $\text{pvc}$:
  ```bash
  # cluster A
  kubectl get pv pvc-4846ea7c-489b-4aaa-ba9b-0e7b4e44b6d5 -o jsonpath='{.spec.csi.volumeHandle}'
  ```
  > - Suppose the result of the above command is $\text{8766d416-72c5-4732-a717-72d9c2d05e70}$.

  - **Step 4** [Optional]: Create the Snapshot for the $\text{pvc}$.
  - **Step 5**: Mark the `PersistentVolume`’s reclaim policy as `Retain`. This will keep the volume in VNG CLOUD even if the PV or PVC is accidentally deleted from the cluster.
  ```bash
  # cluster A
  kubectl patch pv pvc-4846ea7c-489b-4aaa-ba9b-0e7b4e44b6d5 -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
  ```
  - **Step 6**: Export the `PersistentVolume` $\text{pvc-4846ea7c-489b-4aaa-ba9b-0e7b4e44b6d5}$, and `PersistentVolumeClaim` $\text{pvc}$ to a YAML file:
  ```bash
  # cluster A
  kubectl get pv pvc-4846ea7c-489b-4aaa-ba9b-0e7b4e44b6d5 -o yaml > pv.yaml
  kubectl get pvc pvc -o yaml > pvc.yaml
  ```
  - **Step 7**: Deploy a new Kubernetes cluster $B$.
  - **Step 8** [Optional]: Scaling down the cluster $B$ deployment that you want to migrate to 0.
  ```bash
  # cluster B
  kubectl scale deployment <DEPLOYMENT_NAME> --replicas=0
  ```

  - **Step 9** [Optional]: Delete the old `PersistentVolumeClaim` that the cluster $B$ deployment is using.
  ```bash
  # cluster B
  kubectl delete pvc <PVC_NAME>
  ```

  - **Step 10**: Apply the manifest file $\text{pvc.yaml}$ to the cluster $B$.
  ```bash
  # cluster B
  kubectl apply -f pvc.yaml
  ```

  - **Step 11**: Grab the `uid` of the `PersistentVolumeClaim` $\text{pvc}$. This is needed when applying the $\text{pvc-4846ea7c-489b-4aaa-ba9b-0e7b4e44b6d5}$ to the cluster.
  ```bash
  kubectl get pvc pvc -o jsonpath='{.metadata.uid}'
  ```
  > - Suppose the result for the above command is $\text{d2eabdf9-e70f-4c15-8327-0862ef514cb1}$.

  - **Step 12**: Now we can apply the `PersistentVolume` $\text{pvc-4846ea7c-489b-4aaa-ba9b-0e7b4e44b6d5}$. We will additionally set the `claimRef` to the `uid` found in the previous step.
  ```bash
  kubectl apply -f pv.yaml
  kubectl patch pv pvc-4846ea7c-489b-4aaa-ba9b-0e7b4e44b6d5 -p '{"spec":{"claimRef":{"uid":"d2eabdf9-e70f-4c15-8327-0862ef514cb1"}}}'
  ```

  - **Step 13** [Optional]: At this point it is safe to delete the `PersistentVolumeClaim`, `PersistentVolume` and cluster $A$. Because the reclaim policy was previously set to `Retain`, the volume will stay active in VNG CLOUD.

  - **Step 14**: Scale the application on the new cluster to its original replicas count. It may take a few minutes for the volume to attach to the new node.