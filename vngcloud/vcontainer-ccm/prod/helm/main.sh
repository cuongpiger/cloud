#!/bin/bash

rehelm() {
    helm uninstall -n kube-system vcontainer-ccm

    rm -rf vcontainer-helm-infra

    git clone https://github.com/cuongpiger/vcontainer-helm-infra.git --branch dev --depth 1

    helm install -n kube-system vcontainer-ccm vcontainer-helm-infra/vcontainer-ccm --values values.yaml

    rm -rf vcontainer-helm-infra
}

loghelm() {
    pod_id=$(kubectl get pods -n kube-system | grep vcontainer-ccm | awk '{print $1}')
    kubectl logs -n kube-system -f $pod_id
}

source_kubeconfig() {
    export KUBECONFIG=/media/cuongdm/cuongdm/work/ssh-keys/stg/vcontainer/cuongdm3-len-dum-con.txt
}

opt=$1
case $opt in
rehelm)
    rehelm
    ;;
loghelm)
    loghelm
    ;;
source_kubeconfig)
    source_kubeconfig
    ;;
*)
    echo "Usage: $0 {rehelm|loghelm}"
    exit 1
    ;;
esac
