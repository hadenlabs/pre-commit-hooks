#!/usr/bin/env bash
set -e

if ! command -v checkov >/dev/null 2>&1; then
  echo >&2 "checkov is not available on this system."
  echo >&2 "Please install it by running 'python -m pip install --user --upgrade checkov '"
  exit 1
fi

checkov -d .