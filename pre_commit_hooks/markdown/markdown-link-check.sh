#!/usr/bin/env bash

set -eo pipefail

if ! command -v markdown-link-check >/dev/null 2>&1; then
    echo >&2 "markdown-link-check is not available on this system."
    echo >&2 "Please install it by running 'yarn global add -g markdown-link-check'"
    exit 1
fi

main() {
    initialize_
    parse_cmdline_ "$@"
    markdown-link-check_
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

    argv=$(getopt -o p:c:q:v:a:r --long progress:,config:,quiet:,verbose:,alive:,retry: -- "$@") || return

    eval "set -- ${argv}"

    for argv; do
        case $argv in
            -p | --progress)
                shift
                ARGS+=("--progress=${1}")
                shift
                ;;
            -c | --config)
                shift
                ARGS+=("--config=${1}")
                shift
                ;;
            -q | --quiet)
                shift
                ARGS+=("--quiet=${1}")
                shift
                ;;
            -v | --verbose)
                shift
                ARGS+=("--verbose=${1}")
                shift
                ;;
            -a | --alive)
                shift
                ARGS+=("--alive=${1}")
                shift
                ;;
            -r | --retry)
                shift
                ARGS+=("--retry=${1}")
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

markdown-link-check_() {
    for file_path in "${FILES[@]}"; do
        markdown-link-check "${ARGS[@]}" "${file_path}"
    done
}

# global arrays
declare -a ARGS
declare -a FILES

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
