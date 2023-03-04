###### References
* Docs - [https://routemyip.com/posts/k8s/setup/flannel/](https://routemyip.com/posts/k8s/setup/flannel/)

<hr>

* This guideline shows you how to run a Kubernetes cluster with KinD and Flannel CNI plugin.
* To use KinD as a local Kubernetes cluster, you must to disable the defautl KinD CNI `kindnetd` plugin and use the `flannel` plugin instead. Use the following config file to disable the `kindnetd` plugin.
  ```bash
  # workdir: resources
  kind create cluster --config kind-disable-kindnetd.yaml
  ```
* Check the cluster has been created successfully.
  ```bash
  kubectl get nodes
  ```
  ![](./img/01.png)

* If you get all the available pods inside the cluster, the `coredns` and `local-path-storage` pods are in pending state. This is expected as the CNI has not been configured yet.
  ```bash
  kubectl get pods -A
  ```
  ![](./img/02.png)

* Now, we understand the problem, let's delete the above cluster.
  ```bash
  kind delete cluster --name kind
  ```

* Now, let's talk a bit about Flannel, the latest Flannel CNI can be obtained from the [repo](https://github.com/flannel-io/flannel), this is the [`yaml` configuration file](https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml). By default, Flannel CNI uses VXLAN as the backend mechanism. Look at the YAML file, this configuration will be like this:
  ```yaml
  # ...
  net-conf.json: |
    {
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "vxlan"
      }
    }
  # ...    
  ```
* You can change it to **one** of the supported [backend mechanisms](https://github.com/flannel-io/flannel/blob/master/Documentation/backends.md) based on your requirement.
  * vxlan
  * host-gw
  * udp
  * alivpc
  * alloc
  * awsvpc
  * gce
  * techtonic cloud vpc
  * ipip
  * ipsec
  * wireguard

* Now, let's create a new cluster with the Flannel CNI plugin. Let's build the `bridge plugin`. Download the source code from the [repo](https://github.com/containernetworking/plugins). And then extract it at `/home` directory. Inside the `plugins-main` directory, run the following command to build the `bridge` plugin.
  ```bash
  ./build_linux.sh
  ```
  ![](./img/03.png)

* After running the above command, we get the directory `bin` inside the `plugins-main` directory. Copy entire this directory into the `resources` of this project.
  ![](./img/04.png)

* After the above step, we will use the file `kind-flannel.yaml` to create the new cluster using Flannel CNI.
  ```bash
  # workdir: resources
  kind create cluster --config kind-flannel.yaml
  ```

* Apply the Flannel CNI plugin.
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
  ```

* Let's check our cluster has been up and running.
  ```bash
  kubectl get pods -A
  ```
  ![](./img/05.png)

* Test the Flannel network, deploying the two busy box pods and then `ping` them to ensure that our Flannel CNI has got configured properly and is working as expected.
  ```bash
  kubectl create deployment nwtest --image busybox --replicas 2 -- sleep infinity
  ```
* Check the status of the two new `busy` pods.
  ```bash
  kubectl get pods -o wide
  ```
  ![](./img/06.png)

* Let's `ping` from `10.244.1.5` to `10.244.2.2`.
  ```bash
  kubectl exec -it nwtest-5f6dffd846-4q5xl -- ping -c 3 10.244.2.2
  ```
  ![](./img/07.png)

* Great, the ping works and prove that we have successfully configured the Flannel CNI plugin using KinD.
* Now delete the cluster.
  ```bash
  kind delete cluster --name kind
  ```