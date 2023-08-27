#!/bin/bash

alpaca_prod() {
  kubectl run alpaca-prod \
    --image=gcr.io/kuar-demo/kuard-amd64:blue \
    --replicas=2 \
    --labels="ver=1,app=alpaca,env=prod"
}

alpaca_test() {
  kubectl run alpaca-test \
    --image=gcr.io/kuar-demo/kuard-amd64:green \
    --replicas=1 \
    --labels="ver=2,app=alpaca,env=test"
}

bandicoot_prod() {
  kubectl run bandicoot-prod \
    --image=gcr.io/kuar-demo/kuard-amd64:green \
    --replicas=2 \
    --labels="ver=2,app=bandicoot,env=prod"
}

bandicoot_staging() {
  kubectl run bandicoot-staging \
    --image=gcr.io/kuar-demo/kuard-amd64:green \
    --replicas=1 \
    --labels="ver=2,app=bandicoot,env=staging"
}

case $1 in
alpaca-prod) alpaca_prod ;;
alpaca-test) alpaca_test ;;
bandicoot-prod) bandicoot_prod ;;
bandicoot-staging) bandicoot_staging ;;
*)
  echo "Usage: $0 { alpaca | alpaca-test | bandicoot | bandicoot-staging }" >&2
  exit 1
  ;;
esac
