#!/bin/bash

install_kind() {
  [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
}

install_kubectl() {
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
}

create_simple_cluster() {
  config_file="${1:-}"
  if [ -z "${config_file}" ]; then
    echo "No config file provided"
    exit 1
  fi
  
  # config_file: kind-config.yaml
  kind create cluster --name simple-cluster --config ${config_file}
}

option="${1:-}"

case ${option} in
"install_kind")
  install_kind
  ;;
"install_kubectl")
  install_kubectl
  ;;
"create_simple_cluster")
  create_simple_cluster "${2:-}"
  ;;
*)
  echo "No such option ${option}"
  ;;
esac
