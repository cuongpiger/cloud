**Resources**:
  * **Source code**: [https://github.com/k8s-cookbook/recipes](https://github.com/k8s-cookbook/recipes)
  * Prepare environment:
    ```bash
    multipass launch --name k8s minikube
    multipass shell k8s

    # inside the VM
    minikube start
    kubectl version
    ```



# Chapter 01. Getting Started with K8s
## 1.1. Starting Your First Application on Minikube
