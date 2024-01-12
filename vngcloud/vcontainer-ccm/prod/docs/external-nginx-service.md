# Test case 1
## 1.1 Scenario
- File [external-nginx-service.yaml](./../manifests/external/external-nginx-service.yaml)
- This testcase creates an `Nginx` deployment, and then create an **EXTERNAL** loadbalancer service to expose the deployment.

- Apply the manifest
```bash
kubectl apply -f external-nginx-service.yaml
```

## 1.2 Test
After applying the manifest, we will have a deployment and a service as below:
- Get Nginx deployment with 2 replicas
  ```bash
  kubectl apply -f external-nginx-service.yaml
  kubectl get pods
  kubectl get svc
  ```
  ![](./img/external/01.png)


- Waiting until the load balancer is `ACTIVE` on the VNG CLOUD portal
  ![](./img/external/02.png)

- Check the pool
  ![](./img/external/03.png)

- Let browse to to public IP address of the load balancer
  ![](./img/external/04.png)

- Yeahhhhhhhhhhh, it worked
  ![](./img/external/05.png)

## 1.3 test delete the above service
- Delete the service
  ```bash
  kubectl delete -f external-nginx-service.yaml
  ```
  ![](./img/external/06.png)


- Now when you access the previous public IP address, you will be pending forever
  ![](./img/external/07.png)
  ![](./img/external/10.png)

- Test from the portal, the loadbalancer must be disappeared
  ![](./img/external/08.png)

- From the inside k8s, let try
```bash
kubectl get pods,svc
```
![](./img/external/09.png)

# Test case 2

- This test case will deploy an traefic deployment with multiple listeners and pools in the same loadbalancer.
- Using large flavor of loadbalancer in the manifest
- Name the loadbalancer in the manifest
- Apply the manifest [traefik.yaml](./../manifests/external-local-tp/traefik.yaml)
  ```bash
  kubectl apply -f traefik.yaml
  ```
  ![](./img/external-local-tp/01.png)

  ```bash
  kubectl get svc,pods
  ```
  ![](./img/external-local-tp/02.png)

- From the portal
  ![](./img/external-local-tp/03.png)

- Waiting until the load balancer is `ACTIVE` on the VNG CLOUD portal, this loadbalancer **MUST** include 2 listeners and 2 pools
  ![](./img/external-local-tp/04.png)
  ![](./img/external-local-tp/05.png)

- Access Traefik dashboard
  ![](./img/external-local-tp/06.png)

- Inside the k8s, service is assign with the above public ip address
  ![](./img/external-local-tp/07.png)


- Now delete the entire resources
  ```bash
  kubectl delete -f traefik.yaml
  ```
  ![](./img/external-local-tp/08.png)

- Go to the portal to confirm the this loadbalancer is deleted