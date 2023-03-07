###### Brief
* This guideline helps you set up a **native K8s cluster** using **kubeadm**.

<hr>

###### References
* Docs - [https://devopscube.com/kubernetes-cluster-vagrant/](https://devopscube.com/kubernetes-cluster-vagrant/)
* Docs - [https://devopscube.com/setup-kubernetes-cluster-kubeadm/](https://devopscube.com/setup-kubernetes-cluster-kubeadm/)

<hr>

# 1. Prerequisites
* Install VirtualBox.
  * Download `*deb` file which is proper for your system at this link [https://www.virtualbox.org/wiki/Linux_Downloads](https://www.virtualbox.org/wiki/Linux_Downloads)
  * Using the `sudo apt install ./<file_name>.deb` command, install the downloaded file.
* Fix error `The IP address configured for the host-only network is not within the allowed ranges` of VirtualBox when using `vagrant up` command, following these commands:
  ```bash
  sudo touch /etc/vbox/networks.conf
  sudo cat << EOF | sudo tee /etc/vbox/networks.conf
  * 10.0.0.0/8 192.168.0.0/16
  * 2001::/64
  EOF
  ```
* Install Vagrant for Linux at this link [https://developer.hashicorp.com/vagrant/downloads](https://developer.hashicorp.com/vagrant/downloads).

# 2. K8s cluster setup using `kubeadm`
## 2.1. Enable `iptables` bridged traffic on all nodes
* Execute the following command on all the nodes for **IPtables** to see bridged traffic:
  ```bash
  sudo touch 
  ```
