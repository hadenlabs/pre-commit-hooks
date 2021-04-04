#!/usr/bin/env bash

set -e

if ! command -v tfsec >/dev/null 2>&1; then
  echo >&2 "tfsec is not available on this system."
  echo >&2 "Please install it by running 'brew install tfsec'"
  exit 1
fi

main() {
  initialize_
  parse_cmdline_ "$@"
  tfsec_
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
  source "$_SCRIPT_DIR/../libs/lib_getopt"

}

parse_cmdline_() {
  declare argv
  argv=$(getopt -o e:f --long custom-check-dir:,exclude:,format:,no-color:,no-colour:,tfvars-file: -- "$@") || return

  eval "set -- ${argv}"

  for argv; do
    case $argv in
      --custom-check-dir)
        shift
        ARGS+=("--custom-check-dir ${1}")
        shift
        ;;
      -e | --exclude)
        shift
        ARGS+=("--exclude ${1}")
        shift
        ;;
      -f | --format)
        shift
        ARGS+=("--format ${1}")
        shift
        ;;
      --no-color)
        shift
        ARGS+=("--no-color ${1}")
        shift
        ;;
      --no-colour)
        shift
        ARGS+=("--no-colour ${1}")
        shift
        ;;
      --tfvars-file)
        shift
        ARGS+=("--tfvars-file ${1}")
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

tfsec_() {
  local index=0
  for file_with_path in "${FILES[@]}"; do
    file_with_path="${file_with_path// /__REPLACED__SPACE__}"

    paths[index]=$(dirname "$file_with_path")

    (( index++ )) || true
  done

  for path_uniq in $(echo "${paths[*]}" | tr ' ' '\n' | sort -u); do
    path_uniq="${path_uniq//__REPLACED__SPACE__/ }"
    tfsec "${path_uniq}" "${ARGS[@]}"
  done
}

# global arrays
declare -a ARGS
declare -a FILES

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
