###### [_↩ Back to `homepage`_](./../../README.md)

# Chapter 5. Pods

###### 🌈 Table of Contents
  - ##### 1. [Pods in K8s](#1-pods-in-k8s-1)
  - ##### 2. [The Pod manifest](#2-the-pod-manifest-1)
    - ##### 2.1. [Creating a Pod](#21-creating-a-pod-1)
    - ##### 2.2. [Creating a Pod manifest](#22-creating-a-pod-manifest-1)
  - ##### 3. [Accessing your pod](#3-accessing-your-pod-1)
    - ##### 3.1. [Using port forwarding](#31-using-port-forwarding-1)
    - ##### 3.2. []

# [1. Pods in K8s](#1-pods-in-k8s)
- A Pod represents a collection of application containers and volumes running in the same execution environment.
- Applications running in the same Pod share the same IP address and port space (network namespace), have the same hostname, and can communicate using native interprocess communications over System V IPC or POSIX message queues (IPC namespace).

# [2. The Pod manifest](#2-the-pod-manifest)
## [2.1. Creating a Pod](#21-creating-a-pod)
- Running the simple pod:
  ```bash
  kubectl run kuard --image=gcr.io/kuar-demo/kuard-amd64:blue 
  kubectl get pods
  kubectl delete pod kuard
  ```

## [2.2. Creating a Pod manifest](#22-creating-a-pod-manifest)
- In the chapter 2, we use the below command to run the **kuard** application:
  ```bash
  docker run -d --name kuard \
    --publish 8080:8080 \
    gcr.io/kuar-demo/kuard-amd64:blue
  ```

- Now run the **kuard** in K8s cluster (the manifest file at [`kuard-pod.yaml`](./../../resources/chap05/kuard-pod.yaml)):
  ```bash
  kubectl apply -f kuard-pod.yaml
  ```

- To delete the pod, run the command:
  ```bash
  kubectl delete -f kuard-pod.yaml
  # or
  kubectl delete pod kuard
  ```

# [3. Accessing your pod](#3-accessing-your-pod)
- This section teach you how to interact with your pod.

## [3.1. Using port forwarding](#31-using-port-forwarding)
- To access the pod at only the local machine, you can use the port forwarding feature of `kubectl`:
  ```bash
  kubectl port-forward kuard 8080:8080
  ```
- Open new terminal and run the command:
  ```bash
  curl 0.0.0.0:8080
  ```


