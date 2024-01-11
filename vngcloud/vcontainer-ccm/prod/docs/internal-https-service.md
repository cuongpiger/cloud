# 1. Scenario
- File [internal-httpd-service.yaml](./../manifests/internal/internal-httpd-service.yaml)
- This testcase creates an `Apache2` deployment, and then create an **INTERNAL** loadbalancer service to expose the deployment.

- Apply the manifest
```bash
kubectl apply -f internal-httpd-service.yaml
```

# 2. Test
After applying the manifest, we will have a deployment and a service as below:
- Get Apache2 deployment with 2 replicas
```bash
kubectl get deploy
```
![](./img/internal/02.png)

```bash
kubectl get svc
```
![](./img/internal/01.png)
> - The internal IP address of the load balancer is `10.21.0.9`.

- To test this case, you can create an Ubuntu pod using host network and then exec to this pod, install `curl` cli tool and make GET request to this IP address.

- Apply file [ubuntu-pod.yaml](./../manifests/internal/ubuntu-pod.yaml)
```bash
kubectl apply -f ubuntu-pod.yaml
kubectl get pods
```
![](./img/internal/03.png)

- Exec to this pod
```bash
kubectl exec -it ubuntu-pod -- bash

# inside the ubuntu-pod
apt update && apt install curl -y
```
![](./img/internal/04.png)

- Make GET request to the internal IP address of the load balancer
```bash
curl http://10.21.0.9:8080
```
![](./img/internal/05.png)

- Check load balancer in the portal UI
![](./img/internal/06.png)

- Check the listener
![](./img/internal/07.png)

- Check the backend pool
![](./img/internal/08.png)

## 2.1. test delete the above service
```bash
kubectl delete -f internal-httpd-service.yaml
```
![](./img/internal/09.png)
![](./img/internal/10.png)

- Check inside the k8s
```bash
kubectl get pods,svc
```
![](./img/internal/11.png)