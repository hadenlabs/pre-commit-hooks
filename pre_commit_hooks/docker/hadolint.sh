#!/usr/bin/env bash

set -eo pipefail

if ! command -v hadolint >/dev/null 2>&1; then
  echo >&2 "hadolint is not available on this system."
  echo >&2 "Please install it by running 'brew install hadolint'"
  exit 1
fi


main() {
  initialize_
  parse_cmdline_ "$@"
  hadolint_
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
  argv=$(getopt -o c --long config: -- "$@") || return

  eval "set -- ${argv}"

  for argv; do
    case $argv in
      -c | --config)
        shift
        ARGS+=("--config ${1}")
        shift
        ;;
    esac
  done

}

hadolint_() {
  hadolint "${ARGS[@]}"
}

# global arrays
declare -a ARGS

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
