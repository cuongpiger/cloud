# K8s networking implementation

###### Brief
* This guideline shows how to implement K8s networking.

<hr>

###### References

* Xie Xian Bin Blog - [https://www.xiexianbin.cn/kubernetes/network/index.html](https://www.xiexianbin.cn/kubernetes/network/index.html)

<hr>

# 1. K8s
* There are some kind of network communication requirements:
  * Inter-container communication: communication among multiple containers in the same Pod is via `lo` network interface.
  * Pod communication: Pod IP $\Leftrightarrow$ Pod IP.
  * Pod communicate with service: Pod IP $\Leftrightarrow$ Cluster IP.
  * Communication between service and clients outside the cluster: through **NodePort**, **LoadBalancer** or **Ingress**, etc.