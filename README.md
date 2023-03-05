# K8s networking implementation

###### Brief
* This guideline shows how to implement K8s networking.

<hr>

###### References

* Xie Xian Bin Blog - [https://www.xiexianbin.cn/kubernetes/network/index.html](https://www.xiexianbin.cn/kubernetes/network/index.html)

<hr>

# 1. K8s network communication
* There are some kind of network communication requirements:
  * Inter-container communication: communication among multiple containers in the same Pod is via `lo` network interface.
  * Pod communication: Pod IP $\Leftrightarrow$ Pod IP.
  * Pod communicate with service: Pod IP $\Leftrightarrow$ Cluster IP.
  * Communication between service and clients outside the cluster: through **NodePort**, **LoadBalancer** or **Ingress**, etc.

## 1.1. External access to pods in K8s
* NodePort
* LoadBalancer - using **MetalLB** as your service load balancer.
* Ingress

# 2. CNI
* **Flannel**: The most common implementation provides a variety of network backend implementations, covering a variety of scenarios. The disadvantage is that it does not support network policies. The backend networks include:
  * UDP
  * VxLAN
  * Host-GW
* **Calico**: Calico uses policy routing + BGP to provide direct network connection.
* **Cannal** (Flannel for network + Calico for firewalling).
* **Cilium**.
* **WeaveNet**.
