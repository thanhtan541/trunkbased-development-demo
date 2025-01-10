#!/usr/bin/env bash

set -x
set -eo pipefail

if ! [ -x "$(command -v flux)" ]; then
  echo >&2 "Error: Flux CLI is not installed."
  echo >&2 "Use:"
  echo >&2 "    brew install fluxcd/tap/flux"
  echo >&2 "Or:"
  echo >&2 "    curl -s https://fluxcd.io/install.sh | sudo bash"
  echo >&2 "to install it."
  exit 1
fi

echo >&2 "Flux CLI is installed and ready to use."
