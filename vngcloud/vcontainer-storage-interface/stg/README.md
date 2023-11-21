# 1. The Kubernetes cluster information
- I use **VNG-CLOUD vContainer** to create my own Kubernetes cluster that contains 1 master node and 2 worker nodes.
  ```bash
  kubectl get nodes -owide
  ```
  > ```console
  > [root@cuongdm3-csi-au4styyjdebn-master-0 csi]# kubectl get nodes -owide
  > NAME                                 STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP    OS-IMAGE                        KERNEL-VERSION           CONTAINER-RUNTIME
  > cuongdm3-csi-au4styyjdebn-master-0   Ready    master   72m   v1.28.2   192.168.1.3   61.28.234.69   Fedora CoreOS 38.20230722.3.0   6.3.12-200.fc38.x86_64   containerd://1.7.1
  > cuongdm3-csi-au4styyjdebn-node-0     Ready    <none>   63m   v1.28.2   192.168.1.5   61.28.234.71   Fedora CoreOS 38.20230722.3.0   6.3.12-200.fc38.x86_64   containerd://1.7.1
  > cuongdm3-csi-au4styyjdebn-node-1     Ready    <none>   63m   v1.28.2   192.168.1.4   61.28.234.70   Fedora CoreOS 38.20230722.3.0   6.3.12-200.fc38.x86_64   containerd://1.7.1
  > ```

# 2. Install `vcontainer-storage-interface`
- Prepare the [`values.yaml`](./script/values.yaml) file with the below content:
  ```yaml
  csi:
    plugin:
      image:
        repository: docker.io/manhcuong8499/vcontainer-storage-interface
        tag: latest
        pullPolicy: Always

  logVerbosityLevel: 5


  vcontainerConfig:
    create: true
    filename: vcontainer-config.conf
    name: vcontainer-config-secret
    identityURL: "https://hcm-3.api.vngcloud.tech/iam/accounts-api/v2"
    computeURL: "https://hcm-3.api.vngcloud.tech/new-vserver-gateway/v2"
    portalURL: "https://hcm-3.api.vngcloud.tech/new-vserver-gateway/v1"
    blockstorageURL: "https://hcm-3.api.vngcloud.tech/new-vserver-gateway/v2"
    caFile: "/etc/kubernetes/ca-bundle.crt"
    clientID: "<PUT_YOUR_CLIENT_ID>"
    clientSecret: "<PUT_YOUR_CLIENT_SECRET>"
  ```

- Create the [`main.sh`](./script/main.sh) file with the below content:
  ```bash
  #!/bin/bash

  rehelm() {
      helm uninstall -n kube-system vcontainer-storage-interface

      rm -rf vcontainer-helm-infra

      git clone https://github.com/vngcloud/vcontainer-helm-infra.git --branch dev --depth 1

      helm install -n kube-system vcontainer-storage-interface vcontainer-helm-infra/vcontainer-storage-interface --values values.yaml

      rm -rf vcontainer-helm-infra
  }

  loghelm() {
      pod_id=$(kubectl get pods -n kube-system | grep vcontainer-storage-interface-controllerplugin | awk '{print $1}')
      kubectl logs -n kube-system -f $pod_id vcontainer-storage-interface
  }

  opt=$1
  case $opt in
  rehelm)
      rehelm
      ;;
  loghelm)
      loghelm
      ;;
  *)
      echo "Usage: $0 {rehelm|loghelm}"
      exit 1
      ;;
  esac
  ```

- Grant the execution permission for the `main.sh` file:
  ```bash
  chmod +x main.sh
  ```

- Install the `vcontainer-storage-interface`:
  ```bash
  ./main.sh rehelm
  ```
  > ```console
  > [root@cuongdm3-csi-au4styyjdebn-master-0 csi]# ./main.sh rehelm
  > Error: uninstall: Release not loaded: vcontainer-storage-interface: release: not found
  > Cloning into 'vcontainer-helm-infra'...
  > remote: Enumerating objects: 21, done.
  > remote: Counting objects: 100% (21/21), done.
  > remote: Compressing objects: 100% (20/20), done.
  > remote: Total 21 (delta 4), reused 8 (delta 1), pack-reused 0
  > Receiving objects: 100% (21/21), 17.45 KiB | 558.00 KiB/s, done.
  > Resolving deltas: 100% (4/4), done.
  > W1121 06:29:11.025127   47899 warnings.go:70] unknown field "spec.template.spec.containers[2].hostAliases"
  > NAME: vcontainer-storage-interface
  > LAST DEPLOYED: Tue Nov 21 06:29:09 2023
  > NAMESPACE: kube-system
  > STATUS: deployed
  > REVISION: 1
  > TEST SUITE: None
  > ```

- Verify the `vcontainer-storage-interface` is installed successfully.
  ```bash
  kubectl get pods -A -owide
  ```
  > ![](./img/01.png)
  - **⛔ NOTE**
    - All the pods of `vcontainer-storage-interface` **MUST** be deployed on the workers nodes.