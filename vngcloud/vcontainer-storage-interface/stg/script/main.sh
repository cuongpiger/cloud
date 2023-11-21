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