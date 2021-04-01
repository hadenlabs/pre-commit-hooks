#!/usr/bin/env bash
set -e

if ! command -v go >/dev/null 2>&1; then
  echo >&2 "go is not available on this system."
  echo >&2 "Please install it by running 'brew install go'"
  exit 1
fi

go mod vendor
git diff --exit-code vendor &> /dev/null

if [ $? -eq 1 ]; then
    echo "vendor dir differs, please re-add it to your commit"
    exit 1
fi
