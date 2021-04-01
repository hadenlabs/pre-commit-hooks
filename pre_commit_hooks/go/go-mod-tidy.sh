#!/usr/bin/env bash

set -e

if ! command -v go >/dev/null 2>&1; then
  echo >&2 "go is not available on this system."
  echo >&2 "Please install it by running 'brew install go'"
  exit 1
fi

if go mod tidy -v 2>&1 | grep -q 'updates to go.mod needed'; then
    exit 1
fi

git diff --exit-code go.* &> /dev/null

if [ $? -eq 1 ]; then
    echo "go.mod or go.sum differs, please re-add it to your commit"

    exit 1
fi
