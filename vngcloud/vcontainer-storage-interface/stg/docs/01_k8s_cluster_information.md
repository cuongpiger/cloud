###### [↩ Back to `README`](./../README.md)

# 1. The Kubernetes cluster information
- I use **VNG-CLOUD vContainer** to create my own Kubernetes cluster that contains 1 master node and 2 worker nodes.
  ```bash
  kubectl get nodes -owide
  ```
  > ```console
  > [root@cuongdm3-csi-au4styyjdebn-master-0 csi]# kubectl get nodes -owide
  > NAME                                 STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP    OS-IMAGE                        KERNEL-VERSION           CONTAINER-RUNTIME
  > cuongdm3-csi-au4styyjdebn-master-0   Ready    master   72m   v1.28.2   192.168.1.3   61.28.234.69   Fedora CoreOS 38.20230722.3.0   6.3.12-200.fc38.x86_64   containerd://1.7.1
  > cuongdm3-csi-au4styyjdebn-node-0     Ready    <none>   63m   v1.28.2   192.168.1.5   61.28.234.71   Fedora CoreOS 38.20230722.3.0   6.3.12-200.fc38.x86_64   containerd://1.7.1
  > cuongdm3-csi-au4styyjdebn-node-1     Ready    <none>   63m   v1.28.2   192.168.1.4   61.28.234.70   Fedora CoreOS 38.20230722.3.0   6.3.12-200.fc38.x86_64   containerd://1.7.1
  > ```