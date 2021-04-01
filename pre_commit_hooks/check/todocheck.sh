#!/usr/bin/env bash
set -e

if ! command -v todocheck >/dev/null 2>&1; then
  echo >&2 "todocheck is not available on this system."
  echo >&2 "Please install it by running 'go get -u github.com/preslavmihaylov/todocheck'"
  exit 1
fi

todocheck "${@}"