#!/usr/bin/env bash

set -x
# Immediately exit on first fail command and print the first exit status of the first failing command in the pipeline.
set -eo pipefail

find_port() {
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
}


#######################################
# Cleanup files from the backup directory.
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
#######################################
function cleanup() {
  echo "Cleaning up"
}

# Example of todo with your name inside
# TODO(tdog): Handle the unlikely edge cases (bug ####)
