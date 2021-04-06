#!/usr/bin/env bash

set -eo pipefail

if ! command -v tflint >/dev/null 2>&1; then
  echo >&2 "tflint is not available on this system."
  echo >&2 "Please install it by running 'brew install tflint'"
  exit 1
fi

main() {
  initialize_
  parse_cmdline_ "$@"
  tflint_
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
  argv=$(getopt -o conf:log:lang:format --long config:,loglevel:,langserver:,format: -- "$@") || return

  eval "set -- ${argv}"

  for argv; do
    case $argv in
      -conf | --config)
        shift
        ARGS+=("--config=${1}")
        shift
        ;;
      -log | --loglevel)
        shift
        ARGS+=("--loglevel=${1}")
        shift
        ;;
      -lang | --langserver)
        shift
        ARGS+=("--langserver=${1}")
        shift
        ;;
      -format | --format)
        shift
        ARGS+=("--format=${1}")
        shift
        ;;
      --)
        shift
        FILES=("$@")
        break
        ;;
    esac
  done

}

tflint_() {
  local index=0
  for file_with_path in "${FILES[@]}"; do
    file_with_path="${file_with_path// /__REPLACED__SPACE__}"

    paths[index]=$(dirname "$file_with_path")

    (( index++ )) || true
  done

  for path_uniq in $(echo "${paths[*]}" | tr ' ' '\n' | sort -u); do
    path_uniq="${path_uniq//__REPLACED__SPACE__/ }"
    tflint "${ARGS[@]}" "${path_uniq}"
  done
}

# global arrays
declare -a ARGS
declare -a FILES

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
