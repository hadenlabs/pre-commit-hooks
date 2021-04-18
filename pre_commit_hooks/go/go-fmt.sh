#!/usr/bin/env bash

set -e

if ! command -v go >/dev/null 2>&1; then
  echo >&2 "go is not available on this system."
  echo >&2 "Please install it by running 'brew install go'"
  exit 1
fi

for file in "$@"; do
  go fmt "./$(dirname "$file")"
done
