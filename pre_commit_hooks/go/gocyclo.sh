#!/usr/bin/env bash

set -e

if ! command -v gocyclo >/dev/null 2>&1; then
  echo >&2 "gocyclo is not available on this system."
  echo >&2 "Please install it by running 'go get -u github.com/fzipp/gocyclo/cmd/gocyclo'"
  exit 1
fi

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    echo "Please add 'args: [-over=15]' in your pre-commit config"
    exit 1
fi

exec gocyclo "${@}"
