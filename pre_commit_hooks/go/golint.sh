#!/usr/bin/env bash

set -e

if ! command -v golint >/dev/null 2>&1; then
  echo >&2 "golint is not available on this system."
  echo >&2 "Please install it by running 'go get -u golang.org/x/lint/golint'"
  exit 1
fi


exit_status=0

for file in "${@}"; do
    if ! golint -set_exit_status "$file"; then
        exit_status=1
    fi
done

exit ${exit_status}
