#!/usr/bin/env bash

set -x
set -eo pipefail

if ! [ -x "$(command -v  kustomize)" ]; then
  echo >&2 "Error: kustomize is not installed."
  echo >&2 "Use:"
  echo >&2 "    brew install kustomize"
  echo >&2 "to install it."
  exit 1
fi

echo >&2 "Kustomize is installed and ready to use."
