#!/usr/bin/env bash

set -x
set -eo pipefail

# Error util
# Use: err some error message -> echo "[<timestamp>]: some error message >&2
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if [[ -z "${SLOT}" || $SLOT -gt 1 ]]; then
  err "Please specific valid SLOT number! Provided value: 0,1"
  exit 1
fi

k8s_namespace_prefix="dev"
target_k8s_namespace="${k8s_namespace_prefix}-${SLOT}"

echo >&2 "Removing namespace ${target_k8s_namespace}"
kubectl delete namespace ${target_k8s_namespace}

echo >&2 "Cleanup process is finished."
