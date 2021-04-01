#!/usr/bin/env bash

set -e

if ! command -v terragrunt >/dev/null 2>&1; then
  echo >&2 "terragrunt is not available on this system."
  echo >&2 "Please install it by running 'brew install terragrunt'"
  exit 1
fi

terragrunt hclfmt
