#!/usr/bin/env bash
set -e

if ! command -v terraform >/dev/null 2>&1; then
  echo >&2 "terraform is not available on this system."
  echo >&2 "Please install it by running 'brew install terraform'"
  exit 1
fi

# set default aws region for validating aws providers
export AWS_REGION=${AWS_REGION:="none"}

while read -r dir; do
  terraform init -backend=false "$dir"
  terraform validate "$dir"
done < <(printf '%s\n' "${@}" | xargs -i dirname {} | sort -u)
