#!/usr/bin/env bash

set -x
# Immediately exit on first fail command and print the first exit status of the first failing command in the pipeline.
# set -eo pipefail

# Error util
# Use: err some error message -> echo "[<timestamp>]: some error message >&2
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

# Create image
# Use: err some error message -> echo "[<timestamp>]: some error message >&2
build_image() {
  eval $(minikube docker-env)                                               
  docker build -t $1 $2
  # verify image created successfully
  docker image inspect "$1"
  # $? is last return code. If 0 mean port is in-used
  if [ $? -ne 0 ]; then
      err "Image $1 is not available"
      err "Please try again!"
      exit 1
  fi
}

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
lovercase_ticket_id=$(echo "$ticket_id" | tr '[:upper:]' '[:lower:]')

echo "Initializing Local Environment: ${lovercase_ticket_id}"

# Find an available port in the range 8000-9000
# Todo: make range dynamic
found_port=0
for port in {8000..9000}; do
    nc -zv 127.0.0.1 $port
    # $? is last return code. If 0 mean port is in-used
    if [ $? -ne 0 ]; then
        echo "Port $port is available"
        found_port=1
        break
    fi
done

if [[ $found_port -eq 0 ]]; then
  err "No available port in range 8000..9000"
  err "Please try again! "
  exit 0
fi

echo "Setting port $port for deployment"

# Setting image with naming convention:
# <ticket_id>-<app_name>:<version>
current_commit_hash=$(git rev-parse HEAD)
#minikube_tag is used to verified curernt version
minikube_tag=${current_commit_hash:0:3}
app_name="fe"
minikube_image="$lovercase_ticket_id-$app_name:$minikube_tag"
echo "Building image $minikube_image for deployment"
build_image $minikube_image ./repos/react-app/.

