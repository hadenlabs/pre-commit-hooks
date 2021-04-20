#!/usr/bin/env bash

set -eo pipefail

if ! command -v golangci-lint >/dev/null 2>&1; then
  echo >&2 "golangci-lint is not available on this system."
  echo >&2 "Please install it by running 'go get -u github.com/golangci/golangci-lint/cmd/golangci-lint'"
  exit 1
fi

main() {
  initialize_
  parse_cmdline_ "$@"
  golangcilint_
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
  argv=$(getopt -o c:E:D:P:e --long fix:,config:,out-format:,print-issued-lines:,uniq-by-line:,sort-results:,path-prefix:,modules-download-mode:,issue-exit-code:,build-tags:,timeout:,no-config:,skip-dirs:,skip-dirs-use-default:,skip-files:,enable:,disable:,disable-all:,presets:,exclude:,exclude-use-default: -- "$@") || return

  eval "set -- ${argv}"

  for argv; do
    case $argv in
      --fix)
        shift
        ARGS+=("--fix ${1}")
        shift
        ;;
      -c | --config)
        shift
        ARGS+=("--config ${1}")
        shift
        ;;
      --out-format)
        shift
        ARGS+=("--output-format ${1}")
        shift
        ;;
      --print-issued-lines)
        shift
        ARGS+=("--print-issued-lines ${1}")
        shift
        ;;
      --uniq-by-line)
        shift
        ARGS+=("--uniq-by-line ${1}")
        shift
        ;;
      --sort-results)
        shift
        ARGS+=("--sort-results")
        shift
        ;;
      --path-prefix)
        shift
        ARGS+=("--path-prefix ${1}")
        shift
        ;;
      --modules-download-mode)
        shift
        ARGS+=("--modules-download-mode ${1}")
        shift
        ;;
      --issue-exit-code)
        shift
        ARGS+=("--issue-exit-code ${1}")
        shift
        ;;
      --build-tags)
        shift
        ARGS+=("--build-tags ${1}")
        shift
        ;;
      --timeout)
        shift
        ARGS+=("--timeout ${1}")
        shift
        ;;
      --no-config)
        shift
        ARGS+=("--no-config")
        shift
        ;;
      --skip-dirs)
        shift
        ARGS+=("--skip-dirs ${1}")
        shift
        ;;
      --skip-dirs-use-default)
        shift
        ARGS+=("--skip-dirs-user-default ${1}")
        shift
        ;;
      --skip-files)
        shift
        ARGS+=("--skip-files ${1}")
        shift
        ;;
      -E | --enable)
        shift
        ARGS+=("--skip-files ${1}")
        shift
        ;;
      --disable)
        shift
        ARGS+=("--skip-files ${1}")
        shift
        ;;
      --disable-all)
        shift
        ARGS+=("--disable-all")
        shift
        ;;
      -p | --presets)
        shift
        ARGS+=("--presets ${1}")
        shift
        ;;
      -e | --exclude)
        shift
        ARGS+=("--exclude ${1}")
        shift
        ;;
      --exclude-use-default)
        shift
        ARGS+=("--exclude-use-default ${1}")
        shift
        ;;
      --)
        shift
        FILES=("${1}")
        break
        ;;
    esac
  done

}

golangcilint_() {
  for file_validate in "${FILES[@]}"; do
    eval golangci-lint run "${ARGS[@]}" "${file_validate}"
  done
}

# global arrays
declare -a ARGS
declare -a FILES

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
