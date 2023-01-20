**Resources**:
* **Source code** [https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide](https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide) 

# Chapter 4. Deploying Kubernetes using KinD
## 4.1. Introducing Kubernetes components and objects
* This chapter refers to common K8s objects and components.
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

### 4.1.1. Interacting with a cluster
* We will use these basic commands to deploys parts of the cluster that we will use throughout this guideline.
  |kubectl command|Description|
  |-|-|
  |`kubectl get <object>`|Retrieves a list of the requested objects. Example: `kubectl get nodes`.|
  |`kubectl create -f <manifest_name>`|Creates the objects in the `include` manifest that is provided. `create` can only create the **initial objects**, it **can not update the objects**.|
  |`kubecrl apply -f <manufest_name>`|Deploys the objects in the `include` manifest that is provided. Unlike the `create` option, the `aplly` command can update objects, as well as create objects.|
  |`kubectl patch <object_type> <object_name> -p {patching options}`|Patches the supplied `object_type` with the options provided.|

## 4.2. Using development clusters
* **KinD** tool allows us to create **multiple clusters**, and each cluster can have multiple control plane and worker nodes.
* KinD also has an additional component that is not part of most standard installations, such as:
  * **Kindnet**: It is the included, default CNI when you install a base KinD cluster. You also have the option to disable it and use an alternative, such as **Calico**.

* To show the complete cluster and all the components that are running, we can run the command:
  ```bash
  kubectl get pods --all-namespaces
  ```
  ![](./img/chap04/04.png)
  > * This will list all the running components for the cluster, including the base components that are installed by default.

### 4.2.1. KinD and Docker networking
* You should have a solid understanding how KinD and Docker networking work together. This is important to understand so that you can use KinD effectively as a testing environment.<br>
  ![](./img/chap04/05.png)<br>
  * As an example, you want to deploy a web server to you K8s cluster. You deploy an Ingress controller in the KinD cluster and you want to test the site using Chrome on your host machine. You attempt to target the host on port 80 and receive a failure in your browser. Why would this fail?

* Look at the below image:<br>
  ![](./img/chap04/06.png)<br>
  * The pod running the web server is in layer 3 and can not receive direct traffic from the host machine. In order to access the web server from your host machine, you will need to forward the traffic from the host machine to KinD layer.

## 4.3. Installing KinD
* Firstly, install **microk8s**, there will be a few more steps that you need to take before you can actually use **microk8s**, after that, you need to restart your machine.
  ```bash
  sudo snap install microk8s --classic
  ```

* After restarting your machine, you need to alias `kubectl` command.
  ```bash
  echo "alias kubectl='microk8s kubectl'" >> ~/.zshrc
  ```

* Then install **KinD** by this guideline: [Installing From Release Binaries ](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries)


## 4.4. Creating a KinD cluster
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