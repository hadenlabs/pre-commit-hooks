#!/usr/bin/env bash

# Global arrays
declare -a FILES=()
declare -a BLOCKED_EXTENSIONS=()

main() {
  initialize_
  parse_cmdline_ "$@"
  block_files_
}

initialize_() {
  local dir
  local source
  source="${BASH_SOURCE[0]}"
  while [[ -L $source ]]; do
    dir="$(cd -P "$(dirname "$source")" >/dev/null && pwd)"
    source="$(readlink "$source")"
    [[ $source != /* ]] && source="$dir/$source"
  done
  _SCRIPT_DIR="$(dirname "$source")"

  # shellcheck source=/dev/null
  source "$_SCRIPT_DIR/../../libs/github.com/agriffis/pure-getopt/getopt.bash"
}

parse_cmdline_() {
  local argv
  argv=$(getopt -o e: --long ext: -- "$@") || return
  eval set -- "$argv"

  while true; do
    case "$1" in
    -e | --ext)
      BLOCKED_EXTENSIONS+=("$2")
      shift 2
      ;;
    --)
      shift
      FILES=("$@")
      break
      ;;
    *)
      echo "❌ Unexpected option: $1"
      exit 1
      ;;
    esac
  done

  # If no files passed, use staged files
  if [[ ${#FILES[@]} -eq 0 ]]; then
    mapfile -t FILES < <(git diff --cached --name-only)
  fi
}

block_files_() {
  local blocked=0

  for file in "${FILES[@]}"; do
    for ext in "${BLOCKED_EXTENSIONS[@]}"; do
      local clean_ext="${ext//\\/}"
      # case-insensitive comparison compatible con Bash <4
      local lc_file
      lc_file=$(echo "$file" | tr '[:upper:]' '[:lower:]')

      local lc_ext
      lc_ext=$(echo "$clean_ext" | tr '[:upper:]' '[:lower:]')

      # echo "Checking file: $file against extension: $clean_ext"
      if [[ "$lc_file" == *"$lc_ext" ]]; then
        echo "❌ Blocked file: $file"
        blocked=1
      fi
    done
  done

  if [[ $blocked -eq 1 ]]; then
    echo "🚨 Commit aborted. Forbidden extensions: ${BLOCKED_EXTENSIONS[*]}"
    exit 1
  fi
}

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
