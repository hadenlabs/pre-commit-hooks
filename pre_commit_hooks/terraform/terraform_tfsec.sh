#!/usr/bin/env bash

set -e

if ! command -v tfsec >/dev/null 2>&1; then
  echo >&2 "tfsec is not available on this system."
  echo >&2 "Please install it by running 'brew install tfsec'"
  exit 1
fi

tfsec .