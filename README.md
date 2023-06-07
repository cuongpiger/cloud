###### References
* [https://devopscube.com/kubernetes-cluster-vagrant](https://devopscube.com/kubernetes-cluster-vagrant)
* [https://github.com/techiescamp/vagrant-kubeadm-kubernetes](https://github.com/techiescamp/vagrant-kubeadm-kubernetes)


# 1. Troubleshooting
* Latest version of VirtualBox for Mac/Linux can cause issues.
* Following the below steps to fix the issue.
  ```bash=
  sudo mkdir -p /etc/vbox/
  echo "* 0.0.0.0/0 ::/0" | sudo tee -a /etc/vbox/networks.conf
  ```

# 2. Instructions
* **Up** the VMs using `vagrant` command:
  ```bash=
  vagrant up
  ```

* **SSH** into the VMs using `vagrant` command:
  ```bash=
  vagrant ssh master
  ```

* List all the cluster nodes to ensure the worker nodes are connected to the master and in a ready state.
  ```bash=
  kubectl get/top nodes
  ```

* List all the pods in kube-system namespace and ensure it is in a running state.
  ```bash=
  kubectl get pods -n kube-system
  ```

* Run the `nginx` server on the master node:
  ```bash=
  kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/sample-app.yaml
  ```

* Get the services running on the cluster node:
  ```bash=
  kubectl get svc --all-namespaces
  ```

* You can visit `10.0.0.10-11:32000` to catch the service:
  ![](./img/01.png)

* To shut down the Kubernetes VMs, execute the halt command.
  ```bash=
  vagrant halt
  ```

* Whenever you need the cluster, just execute,
  ```bash
  vagrant up
  ```

* To destroy the Kubernetes VMs, execute the destroy command.
  ```bash=
  vagrant destroy
  ```