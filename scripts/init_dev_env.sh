#!/usr/bin/env bash

set -x
# Immediately exit on first fail command and print the first exit status of the first failing command in the pipeline.
# set -eo pipefail

if ! [ -x "$(command -v envsubst)" ]; then
  echo >&2 "Error: envsubst is not installed."
  echo >&2 "Use:"
  echo >&2 "    brew install brew install gettext"
  echo >&2 "    brew link --force gettext"
  echo >&2 "to install it."
  exit 1
fi

# Error util
# Use: err some error message -> echo "[<timestamp>]: some error message >&2
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

# Create image
# Use: err some error message -> echo "[<timestamp>]: some error message >&2
build_image() {
  eval $(minikube docker-env)
  docker build -t ${1} ${2}
  # verify image created successfully
  docker image inspect "${1}"
  # $? is last return code. If 0 mean previous command failed
  if [ $? -ne 0 ]; then
      err "Image ${1} is not available"
      err "Please try again!"
      exit 1
  fi
}

k8s_namespace_prefix="front-end-dev"
#check king SLOT number
# SLOT=0 mean target namespace: front-end-dev-0
# support
# TODO: err with value is non-number
if [[ -z "${SLOT}" || $SLOT -gt 1 ]]; then
  err "Please specific valid SLOT number! Provided value: 0,1"
  exit 1
fi
target_k8s_namespace="${k8s_namespace_prefix}-${SLOT}"
echo "Checking namespace ${target_k8s_namespace} status"
kubectl get namespaces/${target_k8s_namespace}
if [ $? -ne 0 ]; then
  err "namespaces/${target_k8s_namespace} is not available"
  err "Use: "
  err "    kubectl create namespace ${target_k8s_namespace}"
  err "to create target namespace"
  exit 1
fi

# Fetch current branch
# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)
# Skip appending for merge commits and rebase
if [[ "$branch_name" == "HEAD" || $branch_name != feature/UNEY-* || "$branch_name" == "" ]]; then
  err "Invalid feature branch_name"
  err "Please follow convention: feature/UNEY-*"
  exit 0
fi

# Get substring of ticket_id from branch_name
# E.g: feature/UNEY-2222-something -> UNEY-2222
ticket_id=${branch_name:8:9}
# lovercase to create image
lovercase_ticket_id=$(echo "${ticket_id}" | tr '[:upper:]' '[:lower:]')
echo "Initializing Local Environment: ${lovercase_ticket_id}"

# Setting image with naming convention:
# <ticket_id>-<app_name>:<version>
current_commit_hash=$(git rev-parse HEAD)
#current_deploy_hash is used to verified curernt version
current_deploy_hash=${current_commit_hash:0:3}
app_name="fe"
minikube_image_tag="${lovercase_ticket_id}-${app_name}-${current_deploy_hash}"
minikube_image="react-app:${minikube_image_tag}"
echo "Building image ${minikube_image} for deployment"
build_image ${minikube_image} ./repos/react-app/.

echo "Building k8s resources with kustomization"
export IMAGE_TAG=${minikube_image_tag}
kustomize build ./frontend_app/overlays/dev${SLOT} | envsubst |\
    kubectl apply -f -

echo "K8s resources for ${minikube_image_tag} ready"
