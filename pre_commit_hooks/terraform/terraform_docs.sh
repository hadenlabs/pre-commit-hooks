#!/usr/bin/env bash

set -e

if ! command -v terraform-docs >/dev/null 2>&1; then
  echo >&2 "terraform-docs is not available on this system."
  echo >&2 "Please install it by running 'brew install terraform-docs'"
  exit 1
fi

main() {
  initialize_
  parse_cmdline_ "$@"
  terraform_docs_
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

  argv=$(getopt -o c --long config:,footer-from:,header-from:,format:,hide:,hide-all:,output-file:,output-mode:,output-template:,output-values:,output-values-from:,show:,show-all:,sort:,sort-by-required:,sort-by-type: -- "$@") || return

  eval "set -- ${argv}"

  for argv; do
    case $argv in
      -c | --config)
        shift
        ARGS+=("--config ${1}")
        shift
        ;;
      --footer-from)
        shift
        ARGS+=("--footer-from ${1}")
        shift
        ;;
      --header-from)
        shift
        ARGS+=("--header-from ${1}")
        shift
        ;;
      --format)
        shift
        ARGS+=("--format ${1}")
        shift
        ;;
      --hide)
        shift
        ARGS+=("--hide ${1}")
        shift
        ;;
      --hide-all)
        shift
        ARGS+=("--hide-all ${1}")
        shift
        ;;
      --output-file)
        shift
        ARGS+=("--output-file ${1}")
        shift
        ;;
      --output-mode)
        shift
        ARGS+=("--output-mode ${1}")
        shift
        ;;
      --output-template)
        shift
        ARGS+=("--output-template${1}")
        shift
        ;;
      --output-values)
        shift
        ARGS+=("--output-values ${1}")
        shift
        ;;
      --output-values-from)
        shift
        ARGS+=("--output-values-from ${1}")
        shift
        ;;
      --show)
        shift
        ARGS+=("--show ${1}")
        shift
        ;;
      --show-all)
        shift
        ARGS+=("--show-all ${1}")
        shift
        ;;
      --sort)
        shift
        ARGS+=("--sort ${1}")
        shift
        ;;
      --sort-by-required)
        shift
        ARGS+=("--sort-by-required")
        shift
        ;;
      --sort-by-type)
        shift
        ARGS+=("--sort-by-type")
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

terraform_docs_() {
  local index=0
  for file_with_path in "${FILES[@]}"; do
    file_with_path="${file_with_path// /__REPLACED__SPACE__}"

    paths[index]=$(dirname "$file_with_path")

    (( index++ )) || true
  done

  for path_uniq in $(echo "${paths[*]}" | tr ' ' '\n' | sort -u); do
    path_uniq="${path_uniq//__REPLACED__SPACE__/ }"
    eval terraform-docs markdown table "${path_uniq}" "${ARGS[@]}"
  done
}

# global arrays
declare -a ARGS
declare -a FILES

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
