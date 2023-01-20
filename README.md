**Resources**:
* **Source code** [https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide](https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide) 

# Chapter 4. Deploying Kubernetes using KinD
## 4.1. Introducing Kubernetes components and objects
* This chapter refers to common K8s **objects** and **components**.
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
  ![](./img/chap04/07.png)
  > * This will list all the running components for the cluster, including the base components that are installed by default.

### 4.2.1. KinD and Docker networking
* You should have a solid understanding how KinD and Docker networking work together. This is important to understand so that you can use KinD effectively as a testing environment.<br>
  ![](./img/chap04/05.png)<br>
  * As an example, you want to deploy a web server to you K8s cluster. You deploy an Ingress controller in the KinD cluster and you want to test the site using Chrome on your host machine. You attempt to target the host on port 80 and receive a failure in your browser. Why would this fail?

* Look at the below image:<br>
  ![](./img/chap04/06.png)<br>
  * The pod running the web server is in layer 3 and can not receive direct traffic from the host machine. In order to access the web server from your host machine, you will need to forward the traffic from the host machine to KinD layer.

## 4.3. Installing KinD
* Firstly, install **kubectl**, follow this guideline: [Install kubectl binary with curl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux).
* Then install **KinD** by this guideline: [Installing From Release Binaries ](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries).


## 4.4. Creating a KinD cluster
* By the end of the chapter, you will have a **two-node cluster** running - a single control plane node and a single worker node.
### 4.4.1. Create a simple cluster
* Creare **a single-node cluster**, use the command:
  ```bash
  kind create cluster [--name <cluster_name>]
  ```
  ![](./img/chap04/01.png)
  > * This will create a cluster with all the K8s components in a single Docker container by using a cluster name of `kind`.
  > * It will also assign the Docker container a name of `kind-control-plane`.
  > * You can use `docker container ls` command to verify KinD has create a container.
  >   ![](./img/chap04/02.png)

* The `create` command will create the cluster and modify the `~/.kube/config` file. KinD will add the new cluster to your current `~/.kube/config` file, and it will set the new cluster as the default context.

* To verify that the cluster was created successfully, run the command:
  ```bash
  kubectl get nodes
  ```
  ![](./img/chap04/03.png)

### 4.4.2. Deleting a cluster
* You can delete the cluster using the `delete` command, the `delete` command will delete the cluster, inlcuding any entries in your `~/.kube/config` file.
  ```bash
  kind delete cluster --name <cluster_name>
  kind get clusters # to verify that the cluster was deleted
  ```
  ![](./img/chap04/04.png)

### 4.4.3. Creating a cluster config file
* When creating a multi-node cluster, such as two-node cluster with custom options, we need to create **a cluster config file**.
* The config file is a YAML file.
* This is a sample config file:
  ```yaml
  # path: resources/me/chap04/cluster01-kind.yaml
  kind: Cluster
  apiVersion: kind.x-k8s.io/v1alpha4
  networking:
    apiServerAddress: "0.0.0.0"
    disableDefaultCNI: true
  kubeadmConfigPatches:
  -
    apiVersion: kubeadm.k8s.io/v1beta2
    kind: ClusterConfiguration
    metadata:
      name: config
    networking:
      serviceSubnet: "10.96.0.1/12"
      podSubnet: "192.168.0.0/16"
  nodes:
  - role: control-plane
  - role: worker
    extraPortMappings:
    - containerPort: 80
      hostPort: 80
    - containerPort: 443
      hostPort: 443
    extraMounts:
    - hostPath: ./me/chap04/src
      containerPath: /usr/src
  ```
  > * Using **multiple control plane** creates a additional complexity since we can only target a single host or IP in our configuration files, so we need a load balancer here. So KinD will create an additional container running a HAProxy load balancer.
* If you wanted a multi-node cluster without any extra options, you could create a simple configuration file that lists the number and node types you want in the cluster.
* This config file includes 3 control plane and 3 worker nodes:
  ```yaml
  kind: Cluster
  apiVersion: kind.x-k8s.io/v1alpha4
  nodes:
  - role: control-plane
  - role: control-plane
  - role: control-plane
  - role: worker
  - role: worker
  - role: worker
  ```
* Open file [resources/chapter4/cluster01-kind.yaml](./resources/me/chap04/cluster01-kind.yaml)
* Create a KinD cluster with the above config file
  ```bash
  kind create cluster --name cluster01 --config resources/me/chap04/cluster01-kind.yaml

  # verity that the cluster was created successfully
  kutectl get nodes
  docker container ls
  ```
  ![](./img/chap04/08.png)
  ![](./img/chap04/09.png)
  > * I need to remember when creating clusters in KinD, all the cluster names will be followed by the predix `kind-`.
  > * Following this rule, the final name of our created cluster is `kind-cluster01`.

* Because we disable the default CNI of KinD. We can check that all our nodes are currently unready. We need to install a CNI plugin for our cluster. We will use **Calico** as our CNI plugin.
  * Check the status of the nodes:
    ```bash
    kubectl get nodes
    ```
    ![](./img/chap04/10.png)

### 4.4.4. Installing Calico
* You can visit the official website of Calico to check the latest version. [Calico website - Install Calilo Manifest tab](https://projectcalico.docs.tigera.io/getting-started/kubernetes/self-managed-onprem/onpremises). At the time of writing this book, the latest version is `v3.25`.
  ![](./img/chap04/11.png)

* Install Calico by using the command:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
  ```
  ![](./img/chap04/12.png)
  > * This will pull manifests from the internet and apply them to the cluster.

* Now we can check on its status using the command:
  ```bash
  kubectl get pods -n kube-system
  ```
  ![](./img/chap04/13.png)
  > * We can see the first three rows are the pods of Calico.
  > * The next two rows are the two CoreDNS pods.
  > * And other components of the cluster that are all running.

### 4.4.5. Installing an Ingress controller
* To install the controller, execute the following line:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
  ```

* We have one more step so that we have a fully functioning Ingress controller, we need to expose ports 80 and 443 to the running pod. This can be done by patching the deployment. Here, we have included the patch to patch the deployment.
  ```bash
  kubectl patch deployments -n ingress-nginx nginx-ingress-controller -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx-ingress-controller","ports":[{"containerPort":80,"hostPort":80},{"containerPort":443,"hostPort":443}]}]}}}}'
  ```