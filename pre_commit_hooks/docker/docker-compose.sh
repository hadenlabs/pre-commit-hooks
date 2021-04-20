#!/usr/bin/env bash

set -e

if ! command -v docker-compose >/dev/null 2>&1; then
  echo >&2 "hadolint is not available on this system."
  echo >&2 "Please install it by running 'python -m pip install --user --upgrade docker-compose'"
  exit 1
fi

main() {
  parse_cmdline_ "$@"
  docker_compose_
}

parse_cmdline_() {
  FILES=("$@")
}

docker_compose_() {
  for file_validate in "${FILES[@]}"; do
    docker-compose --file "${file_validate}" config --quiet
  done
}

# global arrays
declare -a FILES

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
