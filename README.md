###### References:
* Youtube - [https://youtu.be/kmTqXJW09tM](https://youtu.be/kmTqXJW09tM)

<hr>

* Create the cluster using KinD:
  ```bash
  cd resources
  kind create cluster --config config.yaml
  ```

* Get all the nodes in the cluster:
  ```bash
  kubectl get nodes -o wide
  ```
  ![](./img/01.png)

* Docker also create two containers on the host machine:
  ```bash
  docker ps
  ```
  ![](./img/02.png)
  > * The control-plane's container ID is `749f532fec91`.

* Interact the shell of the control-plane's container:
  ```bash
  docker exec -it 749f532fec91 /bin/bash
  ```

* Open a new terminal to create a deployment Nginx:
  ```bash
  kubectl create deployment nginx-deployment --image=nginx --replicas=2
  kubectl get pods
  ```
  ![](./img/03.png)

* Expose the deployment as a service:
  ```bash
  kubectl expose deployment nginx-deployment --port=80 --type=NodePort --name=nginx-service
  kubectl get services
  ```
  ![](./img/04.png)

* Now need to get the internal-IP of the control-plane:
  ```bash
  kubectl get nodes -o wide
  ```
  ![](./img/01.png)
  > * Currently running on IP `172.18.0.2` and `172.18.0.3`.

* Get the PORT of NodePort service `nginx-service`:
  ```bash
  kubectl describe service/nginx-service
  ```
  ![](./img/06.png)
  > * Currently running on PORT `32080`.

* Now you can access the Nginx service through these pairs of IP and PORT:
  * http://172.18.0.3:32080
  * http://172.18.0.2:32080
  ![](./img/07.png)

* Delete the cluster:
  ```bash
  kind delete cluster --name kind
  ```