###### [_↩ Back to `homepage`_](./../../README.md)

# Chapter 4. Common `kubectl` commands

###### 🌈 Table of Contents
  - ##### 1. [Namespaces](#1-namespaces-1)
  - ##### 2. [Contexts](#2-contexts-1)
  - ##### 3. [Creating, updating, and destroying K8s objects](#3-creating-updating-and-destroying-k8s-objects-1)

# [1. Namespaces](#1-namespaces)
- K8s use **namespaces** to organize objects in the cluster.
- You can think each namespace as a folder that holds a set of objects.
- For example, if you want to get all pods in the `kube-system` namespaces, run the command:
  ```bash
  kubectl get pods -n kube-system
  ```

- To get pods in all namespaces in the cluster, run the command:
  ```bash
  kubectl get pods -A
  ```

- To get all namespaces in the cluster, run the command:
  ```bash
  kubectl get namespaces
  ```

# [2. Contexts](#2-contexts)
- You use `context` to change the default namespace more permanently.
- For example, to create context `my-context` which uses namespace `my-namespace`, run the command:
  ```bash
  kubectl config set-context my-context --namespace=my-namespace
  kubectl config use-context my-context
  ```
- Contexts can also be used to manage different clusters or different users for authenticating to those clusters using the `--users` or `--clusters` flags with the `set-context` command.

# [3. Creating, updating, and destroying K8s objects](#3-creating-updating-and-destroying-k8s-objects)
- Objects in K8s API are represented as JSON or YAML files.
- Let's assume that you have a simple object stored in `obj.yaml`. You can use the below command to create the object in the cluster:
  ```bash
  kubectl apply -f obj.yaml
  ```
- To update the object, you can edit the `obj.yaml` file and run the above command again.
- If you want to see the `apply` command will do without actually changing the object, you can use the `--dry-run` flag:
  ```bash
  kubectl apply -f obj.yaml --dry-run
  ```