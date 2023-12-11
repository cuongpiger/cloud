#!/bin/bash

REGISTRY_URL=quay.io/cuongdm8499
IMAGE_NAME=cdm-aws
IMAGE_TAG=v0.0.1

build() {
  echo "Building..."
  docker build -t ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG} .
}

push() {
  echo "Pushing..."
  docker push ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}
}

case $1 in
build)
  build
  ;;
push)
  push
  ;;
*)
  echo "Usage: $0 {build|push}"
  exit 1
  ;;
esac