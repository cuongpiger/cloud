###### [_↩ Back to `main` branch_](https://github.com/cuongpiger/cloud)

<hr>

|#|Command|Description|Note|Tag|
|---|---|---|---|---|
|1|`kubectl get secret ${CLUSTER_NAME}-kubeconfig -o jsonpath='{.data.value}' \| base64 -d > ${CONFIG_PATH}`|Get the kubeconfig file of the cluster|- `CLUSTER_NAME` is the name of the cluster.<br>- `CONFIG_PATH` is the directory path that you want to save the `kubeconfig` file.<br>- You can get the `CLUSTER_NAME` by using the command [**#2**]|`kubeconfig`|
|2|`kubectl get cluster -owide`|Get all the clusters in the current namespace||`cluster`|