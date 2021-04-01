#!/usr/bin/env bash

set -e

if ! command -v golangci-lint >/dev/null 2>&1; then
  echo >&2 "golangci-lint is not available on this system."
  echo >&2 "Please install it by running 'go get -u github.com/golangci/golangci-lint/cmd/golangci-lint'"
  exit 1
fi

golangci-lint run --fix "${@}"
