#!/usr/bin/env bash

set -x
set -eo pipefail

if ! [ -x "$(command -v k9s)" ]; then
  echo >&2 "Error: K9s is not installed."
  echo >&2 "Use:"
  echo >&2 "    brew install derailed/k9s/k9s"
  echo >&2 "to install it."
  exit 1
fi

echo >&2 "K9s is installed and ready to use."
