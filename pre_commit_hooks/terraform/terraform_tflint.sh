#!/usr/bin/env bash

set -e

if ! command -v tflint >/dev/null 2>&1; then
  echo >&2 "tflint is not available on this system."
  echo >&2 "Please install it by running 'brew install tflint'"
  exit 1
fi

for file in "$@"; do
  tflint "$file"
done
