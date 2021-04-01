#!/usr/bin/env bash
set -e

if ! command -v gocritic >/dev/null 2>&1; then
  echo >&2 "gocritic is not available on this system."
  echo >&2 "Please install it by running 'go get -v -u github.com/go-critic/go-critic/cmd/gocritic'"
  exit 1
fi

failed=false

for file in "$@"; do
    # redirect stderr so that violations and summaries are properly interleaved.
    if ! gocritic check "$file" 2>&1
    then
        failed=true
    fi
done

if [[ $failed == "true" ]]; then
    exit 1
fi
