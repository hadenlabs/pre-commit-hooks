#!/usr/bin/env bash

set -eo pipefail

if ! command -v gitleaks >/dev/null 2>&1; then
  echo >&2 "tflint is not available on this system."
  echo >&2 "Please install it by running 'go get github.com/zricethezav/gitleaks/v7'"
  exit 1
fi

main() {
  initialize_
  gitleaks_ "$@"
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

gitleaks_() {
  gitleaks "$@"
}

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
