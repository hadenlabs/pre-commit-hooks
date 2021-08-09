#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# this commit hook prepends the  branch name to the commit message
# so that jira, github, gitlab can associate it with a ticket

function sed::inplace {
  if [[ ${OSTYPE} =~ ^darwin ]]; then
    /usr/bin/sed -i '' "${@}"
  else
    /usr/bin/sed -i "${@}"
  fi
}

if [ -z "$BRANCHES_TO_SKIP" ]; then
    BRANCHES_TO_SKIP=(main master develop test release)
fi

REGEX_VALIDATION="^[0-9]+$"

BRANCH_NAME=$(git symbolic-ref --short HEAD)
BRANCH_NAME="${BRANCH_NAME##*/}"

BRANCH_IN_COMMIT=$(/usr/bin/grep -c "\\[$BRANCH_NAME\\]" "${1}")
BRANCH_EXCLUDED=$(printf "%s\\n" "${BRANCHES_TO_SKIP[@]}" | /usr/bin/grep -c "^$BRANCH_NAME$")

if [[ -n "${BRANCH_NAME}" ]] && [[ "${BRANCH_NAME}" =~ ${REGEX_VALIDATION} ]] ; then
    BRANCH_NAME="#${BRANCH_NAME}"
fi

if [ -n "${BRANCH_NAME}" ] && ! [[ ${BRANCH_EXCLUDED} -eq 1 ]] && ! [[ ${BRANCH_IN_COMMIT} -ge 1 ]]; then
    sed::inplace -e "1s/^/(${BRANCH_NAME}) /" "${1}"
fi
