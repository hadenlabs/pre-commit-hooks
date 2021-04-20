#!/usr/bin/env bash

set -e

if ! command -v docker-compose >/dev/null 2>&1; then
  echo >&2 "hadolint is not available on this system."
  echo >&2 "Please install it by running 'python -m pip install --user --upgrade docker-compose'"
  exit 1
fi

main() {
  initialize_
  parse_cmdline_ "$@"
  docker_compose_
}

initialize_() {
  # get directory containing this script
  local dir
  local source
  source="${BASH_SOURCE[0]}"
  while [[ -L $source ]]; do # resolve $source until the file is no longer a symlink
    dir="$(cd -P "$(dirname "$source")" > /dev/null && pwd)"
    source="$(readlink "$source")"
    # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $source != /* ]] && source="$dir/$source"
  done
  _SCRIPT_DIR="$(dirname "$source")"

  # shellcheck source=/dev/null
  source "$_SCRIPT_DIR/../../libs/github.com/agriffis/pure-getopt/getopt.bash"

}

parse_cmdline_() {
  declare argv
  argv=$(getopt -- "$@") || return

  eval "set -- ${argv}"

  for argv; do
    case $argv in
      --)
        shift
        FILES=("${1}")
        break
        ;;
    esac
  done

}

docker_compose_() {
  for file_validate in "${FILES[@]}"; do
    docker-compose --file "${file_validate}" config --quiet 2>&1 \
        | sed "/variable is not set. Defaulting/d"
  done
}

# global arrays
declare -a FILES

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
