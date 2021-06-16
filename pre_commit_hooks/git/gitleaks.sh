#!/usr/bin/env bash

set -eo pipefail

if ! command -v gitleaks >/dev/null 2>&1; then
    echo >&2 "tflint is not available on this system."
    echo >&2 "Please install it by running 'go get github.com/zricethezav/gitleaks/v7'"
    exit 1
fi

main() {
    initialize_
    parse_cmdline_ "$@"
    gitleaks_
}

parse_cmdline_() {
    declare argv

    argv=$(getopt -o v:q:r:p:c:o:f --long verbose,quiet:,repo-url:,path:,config-path:,repo-config-path:,clone-path:,version:,username:,password:,access-token:,threads:,ssh-key:,unstaged:,branch:,redact:,debug:,no-git:,additional-config:,report:,format:,files-at-commit:,commit:,commits:,commits-file:,commit-from:,commit-to:,commit-since:,commit-until:,depth: -- "$@") || return

    eval "set -- ${argv}"

    for argv; do
        case $argv in
            -v | --verbose)
                shift
                ARGS+=("--verbose")
                shift
                ;;
            -q | --quiet)
                shift
                ARGS+=("--quiet=${1}")
                shift
                ;;
            -r | --repo-url)
                shift
                ARGS+=("--repo-url=${1}")
                shift
                ;;
            -p | --path)
                shift
                ARGS+=("--path=${1}")
                shift
                ;;
            -c | --config-path)
                shift
                ARGS+=("--config-path=${1}")
                shift
                ;;
            --repo-config-path)
                shift
                ARGS+=("--repo-config-path=${1}")
                shift
                ;;
            --clone-path)
                shift
                ARGS+=("--path-prefix=${1}")
                shift
                ;;
            --version)
                shift
                ARGS+=("--exclude-use-default=${1}")
                shift
                ;;
            --username)
                shift
                ARGS+=("--username=${1}")
                shift
                ;;
            --password)
                shift
                ARGS+=("--password=${1}")
                shift
                ;;
            --access-token)
                shift
                ARGS+=("--access-token=${1}")
                shift
                ;;
            --threads)
                shift
                ARGS+=("--threads=${1}")
                shift
                ;;
            --ssh-key)
                shift
                ARGS+=("--ssh-key=${1}")
                shift
                ;;
            --unstaged)
                shift
                ARGS+=("--unstaged=${1}")
                shift
                ;;
            --branch)
                shift
                ARGS+=("--branch=${1}")
                shift
                ;;
            --redact)
                shift
                ARGS+=("--redact=${1}")
                shift
                ;;
            --debug)
                shift
                ARGS+=("--debug=${1}")
                shift
                ;;
            --no-git)
                shift
                ARGS+=("--no-git=${1}")
                shift
                ;;
            --additional-config)
                shift
                ARGS+=("--additional-config=${1}")
                shift
                ;;
            --report)
                shift
                ARGS+=("--report=${1}")
                shift
                ;;
            --format)
                shift
                ARGS+=("--format=${1}")
                shift
                ;;
            --files-at-commit)
                shift
                ARGS+=("--files-at-commit=${1}")
                shift
                ;;
            --commit)
                shift
                ARGS+=("--commit=${1}")
                shift
                ;;
            --commits)
                shift
                ARGS+=("--commits=${1}")
                shift
                ;;
            --commits-file)
                shift
                ARGS+=("--commits-file=${1}")
                shift
                ;;
            --commit-from)
                shift
                ARGS+=("--commit-from=${1}")
                shift
                ;;
            --commit-to)
                shift
                ARGS+=("--commit-to=${1}")
                shift
                ;;
            --commit-since)
                shift
                ARGS+=("--commit-since=${1}")
                shift
                ;;
            --commit-until)
                shift
                ARGS+=("--commit-until=${1}")
                shift
                ;;
            --commit-depth)
                shift
                ARGS+=("--commit-depth=${1}")
                shift
                ;;
        esac
    done

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
    exec gitleaks "${ARGS[@]}"
}

# global arrays
declare -a ARGS

[[ ${BASH_SOURCE[0]} != "$0" ]] || main "$@"
