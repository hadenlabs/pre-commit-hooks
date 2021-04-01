#!/usr/bin/env bash

set -e

if ! command -v terragrunt >/dev/null 2>&1; then
  echo >&2 "terragrunt is not available on this system."
  echo >&2 "Please install it by running 'brew install terragrunt'"
  exit 1
fi

declare -a paths

index=0

for file_with_path in "$@"; do
  file_with_path="${file_with_path// /__REPLACED__SPACE__}"

  paths[index]=$(dirname "$file_with_path")

  (( index++ )) || true
done

for path_uniq in $(echo "${paths[*]}" | tr ' ' '\n' | sort -u); do
  path_uniq="${path_uniq//__REPLACED__SPACE__/ }"

  pushd "$path_uniq" > /dev/null
  terragrunt validate
  popd > /dev/null
done
