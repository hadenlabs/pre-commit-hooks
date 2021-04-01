#!/usr/bin/env bash
set -e

if ! command -v go >/dev/null 2>&1; then
  echo >&2 "go is not available on this system."
  echo >&2 "Please install it by running 'brew install'"
  exit 1
fi

pkg=$(go list)
for dir in $(echo "${@}"|xargs -n1 dirname|sort -u); do
  go vet "${pkg}/${dir}"
done
