#!/usr/bin/env bash

set -x
set -eo pipefail

# Fetch current branch
# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Skip appending for merge commits and rebase
if [[ "$branch_name" == "HEAD" || $branch_name != feature/UNEY-* || "$branch_name" == "" ]]; then
  echo >&2 "Invalid feature branch_name"
  echo >&2 "Please follow convention: feature/UNEY-*"
  exit 0
fi

# Get substring of ticket_id from branch_name
# E.g: feature/UNEY-2222-something -> UNEY-2222
ticket_id=${branch_name:8:9}
echo "${ticket_id}"

# fetch available port
# for local enviroment


