#!/usr/bin/env bash

set -e

if ! command -v goimports >/dev/null 2>&1; then
  echo >&2 "goimports is not available on this system."
  echo >&2 "Please install it by running 'go get -u golang.org/x/tools/cmd/goimports'"
  exit 1
fi

for file in "$@"; do
    goimports -l -w "$(dirname "$file")"
done
