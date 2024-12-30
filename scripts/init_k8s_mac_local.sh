#!/usr/bin/env bash

set -x
set -eo pipefail

if ! [ -x "$(command -v docker)" ]; then
  echo >&2 "Error: docker is not installed."
  echo >&2 "Go to:"
  echo >&2 "    https://www.docker.com/products/docker-desktop/"
  echo >&2 "to install it."
fi

if ! [ -x "$(command -v kubectl)" ]; then
  echo >&2 "Error: kubectl is not installed."
  echo >&2 "Use:"
  echo >&2 "    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl""
  echo >&2 "to install it."
  echo >&2 "Verify with:"
  echo >&2 "  "kubectl version --client""
fi

if ! [ -x "$(command -v minikube)" ]; then
  echo >&2 "Error: minikube is not installed."
  echo >&2 "Use:"
  echo >&2 "    brew install minikube"
  echo >&2 "to install it."
  echo >&2 "Verify with:"
  echo >&2 "  "kubectl version --client""
fi

VAR_EXAMPLE="${POSTGRES_USER:=fall_back}"
# Skip Flag
if [[ -z "${SKIP_DOCKER}" ]]
then
  echo "Optional"
fi

>&2 echo "Enviroment is all set, ready to go!"
