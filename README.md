[↩ Back to `main` branch](https://github.com/cuongpiger/cloud)

###### References
- Youtube - [https://youtube.com/playlist?list=PL2We04F3Y_41jYdadX55fdJplDvgNGENo](https://youtube.com/playlist?list=PL2We04F3Y_41jYdadX55fdJplDvgNGENo)
- Github - [https://github.com/mmumshad/kubernetes-the-hard-way](https://github.com/mmumshad/kubernetes-the-hard-way)

<hr>

# 1. The design
![](./img/01.png)
- Deploys 5 VMs   with the name `kubernetes-ha-*`:
  - 2 masters
  - 2 workers
  - 1 load balancer
- Set's IP addresses in the range `192.168.5`.
- Add's a DNS entry to each of the nodes to access internet.
- Install's Docker on the nodes.

## 1.1. Up the VMs
- Using the `vagrant up` command to up the VMs.
  ```bash
  cd ./kubernetes-the-hard-way/vagrant
  vagrant up
  ```
  ![](./img/02.png)

- The below image is the 5 VMs up and running in VirtualBox.
  ![](./img/03.png)

- Using the command `vagrant status` to check the VMs' status.
  ![](./img/04.png)

- Use the command `vagrant ssh master-1` to ssh into the VM `master-1`.
  ![](./img/05.png)

- In the VM `master-1`, use the command `ip a` to check the IP address of the VM.
  ![](./img/06.png)
