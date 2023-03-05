* This guideline helps you set up a KinD cluster using Calico as the CNI.
* Firstly, create a KinD cluster with the following command:
  ```bash
  # workdir: resources
  kind create cluster --config kind-config.yaml
  ```
* Then, install Calico with the following command, this manifest will config Calico resources in the `kube-system` namespace:
  ```bash
  kubectl apply -f https://docs.tigera.io/archive/v3.25/manifests/calico.yaml
  ```
* Finally, you can check the status of Calico pods:
  ```bash
  kubectl get pods -n kube-system
  ```
  ![](./img/01.png)

* Now let's create two `busybox` pods in the `kube-system` namespace.
  ```bash
  kubectl create deployment nwtest --image busybox -n kube-system --replicas 2 -- sleep infinity
  ```

* Check the status and IP address of these two `busybox` pods:
  ```bash
  kubectl get pods -n kube-system -o wide
  ```
  ![](./img/02.png)

* Now let's ping each other:
  ```bash
  kubectl exec nwtest-5f6dffd846-n87tm -n kube-system -- ping -c 3 10.244.110.129
  ```
  ![](./img/03.png)
  * Everything works fine.

* Delete the KinD cluster:
  ```bash
  kind delete cluster --name kind
  ```