# 1. Scenario
- File [hello-node.yaml](./../manifests/http-healthcheck/hello-node.yaml)
- This testcase creates an `Hello World` deployment, expose this service to the internet, to healthcheck the application, access the url "/" with success code is `200`.

- Apply the manifest
```bash
kubectl apply -f hello-node.yaml
```
![](./img/http-healthcheck/01.png)

# 2. Test
After applying the manifest, we will have a deployment and a service as below:
- Get Apache2 deployment with 2 replicas
```bash
kubectl get pods
```
![](./img/http-healthcheck/02.png)

```bash
kubectl get svc
```
![](./img/http-healthcheck/03.png)
> - The public IP address of the load balancer is `180.93.181.91`.
> - You need to wait about 3 minutes for the load balancer to be ready.

- Check from the portal UI
![](./img/http-healthcheck/04.png)
![](./img/http-healthcheck/05.png)
![](./img/http-healthcheck/06.png)

- Access the above public endpoint on the browser
![](./img/http-healthcheck/07.png)

- Delete the entire resource
```bash
kubectl delete -f hello-node.yaml
```
![](./img/http-healthcheck/08.png)