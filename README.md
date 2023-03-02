**Resources**:
* **Source code** [https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide](https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide) 


# Chapter 4. Deploying K8s using KinD
## 4.1. Creating a KinD Cluster
### 4.1.1. Creating a simple cluster
* Create a quick single-node cluster with only one control plane node.
  ```bash
  kind create cluter
  ```
  * By the default, the KinD create the cluster with the prefix is `kind-<cluster name>`.
* Check the cluster info.
  ```bash
  kubectl cluster-info --context kind-kind
  ```

* Get all nodes inside the cluster.
  ```bash
  kubectl get nodes -o wide
  ```

### 4.1.2. Delete a cluster
* Delete a cluster (do not need to include the prefix `kind-` in the `<cluster name>`).
  ```bash
  kind delete cluster --name <cluster name>
  ```

### 4.1.6. Creating a custom KinD cluster
* Use the file `cluster01-kind.yaml`.
  ```bash
  kind create cluster --name cluster01 --config ./cluster01-kind.yaml
  ```

### 4.1.7. Install Calico
* Install Calico.
  ```bash
  kubectl apply -f https://docs.tigera.io/archive/v3.25/manifests/calico.yaml
  ```

* Check everything is running.
  ```bash
  kubectl get all -n kube-system
  ```

### 4.1.8. Install an Ingress controller

## 4.2. Reviewing the KinD cluster
### 4.2.1. KinD storage objects
* Get a CSInodes object.
  ```bash
  kubectl get csinodes
  ```

  