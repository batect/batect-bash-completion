#! /usr/bin/env bash

# What is this?
# This is a script that simulates a tab completion for a given command line and returns the suggestions generated.
# Bash doesn't have a nice way to do this (like Fish's "complete -C'...'"), so we have to do some magic to make it work.

function test_complete() {
    source ~/.bashrc # Load any completions configured in .bashrc

    local COMP_LINE=$*
    local COMP_POINT=${#COMP_LINE}

    eval set -- "$@" # HACK: This will do all kinds of things beyond just splitting the string into arguments (eg. expansion of embedded commands).
    local COMP_WORDS=("$@")

    if [[ "${COMP_LINE: -1}" == " " ]]; then
        COMP_WORDS+=("")
    fi

    local COMP_CWORD=$((${#COMP_WORDS[@]} - 1))
    local command_name="${COMP_WORDS[0]##*/}"

    local completion_spec=$(complete -p "$command_name" || exit 1)

    if [[ "$completion_spec" == "" ]]; then
        echo "$0: No completion function found for command '$command_name'" >/dev/stderr
        exit 1
    fi

    local completion_function=$(echo "$completion_spec" | sed -E 's/.* -F ([^ ]*).*/\1/') # Horrible HACK: find the value of the -F argument
    local COMPREPLY=()
    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local previous_word=""

    if [[ $COMP_CWORD -gt 1 ]]; then
        previous_word="${COMP_WORDS[$((COMP_CWORD - 1))]}"
    fi

    $completion_function "$command_name" "$current_word" "$previous_word" || {
        echo "$0: completion function '$completion_function' failed." >/dev/stderr && exit 1;
    }

    printf '%s\n' "${COMPREPLY[@]}"
}

test_complete "$@"
