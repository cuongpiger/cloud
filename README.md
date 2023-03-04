###### References
* Medium - [https://medium.com/devstream/creating-a-local-kubernetes-cluster-from-the-groud-up-a-tutorial-of-kind-f5433ee1408a](https://medium.com/devstream/creating-a-local-kubernetes-cluster-from-the-groud-up-a-tutorial-of-kind-f5433ee1408a)
* StackOverFlow - [https://stackoverflow.com/questions/62432961/how-to-use-nodeport-with-kind](https://stackoverflow.com/questions/62432961/how-to-use-nodeport-with-kind)

<hr>

# 1. Advanced Kind Features
## 1.1. Port Mapping
* Imagine you are running an Nginx container listening on port 8080 in a KinD cluster but you wish the outside world _(outside of the cluster)_ to access the Nginx port. To archieve this, we can add the `extraPortMappings` configuration to the config file.
  ```bash
  kind: Cluster
  apiVersion: kind.x-k8s.io/v1alpha4
  nodes:
  - role: control-plane
    extraPortMappings:
    - containerPort: 8080
      hostPort: 8080
      listenAddress: "0.0.0.0"
      protocol: tcp
  ```
  * The above configuration will map the container port 8080 to the host port 8080. This means that any traffic that is sent to the host port 8080 will be forwarded to the container port 8080.
* Now, we can run the following command to create the cluster _(workdir: `resources`)_.
  ```bash
  kind create cluster --config multi-node-config.yaml --name multi-node-cluster
  ```

* Using `kubectl` to check the cluster has been created.
  ```bash
  kubectl cluster-info --context kind-multi-node-cluster
  ```
  ![](./img/01.png)

* Run Nginx as deployment.
  ```bash
  kubectl apply -f deployment.yaml
  ```

* Expose the Nginx deployment as a service.
  ```bash
  kubectl apply -f nodeport.yaml
  ```

* View all the resources that are running on the cluster.
  ```bash
  kubectl get all
  ```
  ![](./img/02.png)

* The image below shows the port mapping between the host and the container.
  ![](./img/05.png)

* Now, we can access the Nginx service through the IP dddress [http://0.0.0.0:8080](http://0.0.0.0:8080):
  ![](./img/06.png)

* Delete the Kind cluster.
  ```bash
  kind delete cluster --name multi-node-cluster
  ```
