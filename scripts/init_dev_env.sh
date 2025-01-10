#!/usr/bin/env bash

set -x

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
echo "${ticket_id}"
found_port=0

# Find an available port in the range 8000-9000
# Todo: make range dynamic
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

echo $port

# Error util
# Use: err some error message -> echo "[<timestamp>]: some error message >&2
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

