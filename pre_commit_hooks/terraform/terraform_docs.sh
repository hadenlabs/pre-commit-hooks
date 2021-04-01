#!/usr/bin/env bash

set -e

if ! command -v terraform-docs >/dev/null 2>&1; then
  echo >&2 "terraform-docs is not available on this system."
  echo >&2 "Please install it by running 'brew install terraform-docs'"
  exit 1
fi

for file in "$@"; do
 terraform-docs markdown "$file"
done
