#!/usr/bin/env bash

set -x
# Immediately exit on first fail command and print the first exit status of the first failing command in the pipeline.
set -eo pipefail

source ./scripts/init_kustomize.sh
source ./scripts/init_k8s_mac_local.sh
