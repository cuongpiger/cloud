**Resources**:
  * **Source code**: [https://github.com/luksa/kubernetes-in-action](https://github.com/luksa/kubernetes-in-action)

# Chap 2. First steps with Docker and K8s
## 2.2. Setting up a K8s cluster
### 2.2.1. Running a local single-node K8s cluster with Minikube
* Installing Minikube using the below command:
  ```bash
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

  # verify the installation succeeded
  minikube version
  ```

* Starting a K8s cluster with Minikube:
  ```bash
  minikube start
  ```
  ![](./img/chap02/01.png)

* Installing Kubectl using the below command:
  ```bash
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl && sudo mv kubectl /usr/local/bin/

  # verify the installation succeeded
  kubectl version --short
  kubectl cluster-info
  ```
  ![](./img/chap02/02.png)
  ![](./img/chap02/03.png)

### 2.2.2. Using a hosted K8s cluster with Google K8s Engine
* Setting up a Google Cloud Project and downloading the necessary client binaries:
  * Following this instruction to get started: [https://cloud.google.com/container-engine/docs/before-you-begin](https://cloud.google.com/container-engine/docs/before-you-begin).
  * After that, you can install `kubectl` tool in `gcloud` by the below command:
    ```bash
    gcloud components install kubectl
    ```
* Creating a K8s cluster with 3-nodes:
  ```bash
  gcloud container clusters create kubia --num-nodes 3 --machine-type f1-micro --zone asia-northeast1-a
  ```

## 2.3. Running our first app on K8s
### 2.3.1. Deplying your Node.js app
* Prepare `manhcuong8499/kubia` image:
  ```bash
  cd resources/me/chap02/kubia
  docker build -t kubia .
  docker tag kubia manhcuong8499/kubia
  docker push manhcuong8499/kubia
  ```

* Deloy kubia app in K8s:
  ```bash
  kubectl run kubia --image=manhcuong8499/kubia --port=8080
  ```

#### 2.3.1.1. Introducing Pods
* Listing all pods in the cluster:
  ```bash
  kubectl get pods
  ```
  ![](./img/chap02/04.png)

* To see more information about the pods, use the `describe` command:
  ```bash
  kubectl describe pod kubia
  ```
  ![](./img/chap02/05.png)

### 2.3.2. Accessing your web application
* Tell K8s expose the `kubia` app to the outside world by creating a service object:
  ```bash
  kubectl expose pod kubia --type=NodePort --name kubia-http
  ```
  ![](./img/chap02/06.png)

* Listing all services in the cluster:
  ```bash
  kubectl get services
  ```
  ![](./img/chap02/07.png)

* Get IP-Address:
  ```bash
  minikube service kubia-http --url
  ```
  ![](./img/chap02/08.png)

* Testing the app:
  ```bash
  curl http://192.168.49.2:30884
  ```
  ![](./img/chap02/09.png)

### 2.3.3. Horizontally scaling the application
* Create kubia service:
  ```bash
  kubectl create deployment kubia --image=manhcuong8499/kubia
  ```
  ![](./img/chap02/10.png)

* Get replication controller:
  ```bash
  kubectl get replicasets
  ```
  ![](./img/chap02/11.png)
  * The `DISIRED` column shows the number of replicas that we want to have.

* To scale up the number of replicas of your pod, you need to change the desired replica count on the replication controller:
  ```bash
  kubectl scale deployment kubia --replicas=3
  ```
  ![](./img/chap02/12.png)

* Verify the number of pods:
  ```bash
  kubectl get all
  ```
  ![](./img/chap02/13.png)
