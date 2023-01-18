**Resources**:
* **Source code** [https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide](https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide) 

# Chapter 4. Deploying Kubernetes using KinD
## 4.1. Installing KinD
* Install Go.
  1. Download the latest version of Go from the official website [https://golang.org/dl](https://golang.org/dl/)
  2. Extract the downloaded archive file by running the command:
    ```bash
    tar -xzf go<version>.linux-amd64.tar.gz
    ```
  3. Move the extracted folder to the /usr/local directory:
    ```bash
    sudo mv go /usr/local/
    ```
  4. Add the Go binary directory to your system's PATH environment variable by adding the following line to your ~/.bashrc file:
    ```bash
    export PATH=$PATH:/usr/local/go/bin
    ```
  5. Reload the ~/.bashrc file by running the command:
    ```bash
    source ~/.bashrc
    ```
  6. Verify the installation by running the command:
    ```bash
    go version
    ```
* Install `kubectl`.
  ```bash
  sudo snap install kubectl --classic
  ```

* Install KinD.
  1. Download the latest version of KinD by running the command _(or manually download at [https://github.com/kubernetes-sigs/kind/releases](https://github.com/kubernetes-sigs/kind/releases))_:
    ```bash
    curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/v0.8.1/kind-linux-amd64
    ```
  2. Make the downloaded binary executable by running the command:
    ```bash
    chmod +x kind
    ```
  3. Move the binary to a location in your PATH by running the command:
    ```bash
    sudo mv kind /usr/local/bin/
    ```
  4. Verify the installation by running the command:
    ```bash
    kind version
    ```

## 4.2. Kubernetes components and objects
* **Components**:
  * **Control plane**:
    * **API-Server**: Front-end of the control plane that accepts requests from clients.
    * `kube-scheduler`: Assigns workloads to nodes.
    * `etcd`: Database that contains all cluster data.
    * `kube-controller-manager`: Watches for node health, pod replicas, endpoints, service accounts, and tokens.
  * **Nodes**:
    * `kubelet`: The agent that runs a pod based on instructions from the control plane.
    * `kube-proxy`: Creates and deletes network rules for pod communication.
    * **Container runtime**: Component responsible for running a container.

* **Objects**:
  * **Container**: A single immutable image that contains everything needed to run an application.
  * **Pod**: The smallest object that K8s can control. A pod holds a container, or multiple containers. All containers in a pd are scheduled on the same server in a shared context _(that is, each container in a pod can address other pods using localhost)_.
  * **Deployment**: Used to deploy an application to a cluster based on a desired state, including the number of podds and rolling update configurations.
  * **Storage class**: Defines storage providers and presents them to the cluster.
  * **Persistent Volume (PV)**: Provide a storage target that can be claimed by a Persistent Volume Request.
  * **Persistent Volume Claim (PVC)**: Connect (claims) a Persistent Volume so that it can be used inside a pod.
  * **Container Network Interface (CNI)**: Provide the network connection for pods. Common CNI examples include Flannel and Calico.
  * **Container Storage Interface (CSI)**: Provides the connection between pods and storage systems.

## 4.3. Creating a KinD cluster
### 4.3.1. Create a simple cluster
* Create a simple cluster that runs the control plane and a worker node in a single container.
  ```bash
  kind create [--name <cluster_name>] cluster
  ```
  ![](./img/chap04/01.png)
  * The `create` command will create the cluster and modify the kubectl config file.

* Listing the nodes.
  ```bash
  kubectl get nodes
  ```
  ![](./img/chap04/02.png)

### 4.3.2. Deleting a cluster
* Use the below command.
  ```bash
  kind delete cluster --name <cluster_name>
  ```
  ![](./img/chap04/03.png)

### 4.3.3. Creating a cluster config file
* Open file [resources/chapter4/cluster01-kind.yaml](./resources/chapter4/cluster01-kind.yaml)
* Create a KinD cluster with the above config file
  ```bash
  kind create cluster --name cluster01 --config resources/chapter4/cluster01-kind.yaml
  ```