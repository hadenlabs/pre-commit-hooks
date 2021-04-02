#!/usr/bin/env bash
set -e

if ! command -v hadolint >/dev/null 2>&1; then
  echo >&2 "hadolint is not available on this system."
  echo >&2 "Please install it by running 'brew install hadolint'"
  exit 1
fi

hadolint "${@}"