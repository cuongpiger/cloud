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
* Install MicroK8s.
  1. Download the latest version of MicroK8s by running the command:
    ```bash
    sudo snap install microk8s --classic
    ```
  2. Verify the installation by running the command:
    ```bash
    microk8s status
    ```
  3. Alias `kubectl` command in `.bashrc` file.
    ```bash
    alias kubectl='microk8s.kubectl'
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
|Component|Description|
|-|-|
|Control Plane|**API-Server**: Frontend of the control plane that accepts requests from clients.<hr>`kube-scheduler`: Assigns workloads to nodes.<hr>`etcd`: Database that contains all cluster data.|