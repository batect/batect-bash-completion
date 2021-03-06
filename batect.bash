#! /usr/bin/env bash

_batect_completion_proxy_loaded_versions=()

function _batect_completion_proxy() {
    local wrapper_script_path
    wrapper_script_path="${COMP_WORDS[0]}"

    if [[ ! -x "$wrapper_script_path" ]]; then
        _batect_completion_proxy_fallback
        return 0
    fi

    local batect_version
    batect_version=$(sed -En 's/VERSION="(.*)"/\1/p' "$wrapper_script_path" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    local use_disk_cache=true

    if [[ "$batect_version" != "" ]]; then
        local batect_version_major batect_version_minor
        batect_version_major=$(echo "$batect_version" | sed -En 's/([0-9]+)\.([0-9]+)\..*/\1/p')
        batect_version_minor=$(echo "$batect_version" | sed -En 's/([0-9]+)\.([0-9]+)\..*/\2/p')

        if [[ "$batect_version_major" -eq 0 && "$batect_version_minor" -lt 73 ]]; then
            # If we know what the version is, and it's too old, fallback to as if this completion script doesn't exist.
            _batect_completion_proxy_fallback
            return 0
        fi
    else
        # HACK: this makes it easier to test completions locally when testing with the start script generated by Gradle.
        batect_version="0.0.0-local-dev"
        use_disk_cache=false
    fi

    export BATECT_COMPLETION_PROXY_REGISTER_AS="_batect-$batect_version"
    export BATECT_COMPLETION_PROXY_VERSION="0.2.0-dev"
    export BATECT_COMPLETION_PROXY_WRAPPER_PATH="$wrapper_script_path"

    if ! _batect_completion_proxy_have_loaded_version "$batect_version"; then
        _batect_completion_proxy_load_version "$wrapper_script_path" "$batect_version" "$use_disk_cache"
    fi

    "$BATECT_COMPLETION_PROXY_REGISTER_AS" "$@"
}

function _batect_completion_proxy_have_loaded_version() {
    local version=$1

    for loaded_version in "${_batect_completion_proxy_loaded_versions[@]}"; do
        if [[ "$loaded_version" == "$version" ]]; then
            return 0
        fi
    done

    return 1
}

function _batect_completion_proxy_load_version() {
    local wrapper_script_path="$1"
    local batect_version="$2"
    local use_disk_cache="$3"
    local disk_cache_root="$HOME/.batect/completion/bash-wrapper-$BATECT_COMPLETION_PROXY_VERSION"
    local disk_cache_path="$disk_cache_root/$batect_version"
    local completion_script

    if [[ "$use_disk_cache" == "true" && -f "$disk_cache_path" ]]; then
        completion_script=$(cat "$disk_cache_path")
    else
        completion_script=$(BATECT_QUIET_DOWNLOAD=true $wrapper_script_path --generate-completion-script=bash) || (
            echo "Running Batect $batect_version to generate completion script failed: $completion_script" >/dev/stderr && exit 1
        )
    fi

    eval "$completion_script"
    batect_completion_proxy_loaded_versions+=("$batect_version")

    if [[ "$use_disk_cache" == "true" && ! -f "$disk_cache_path" ]]; then
        mkdir -p "$disk_cache_root"
        echo "$completion_script" >"$disk_cache_path"
    fi
}

function _batect_completion_proxy_fallback() {
    local word=${COMP_WORDS[COMP_CWORD]}

    COMPREPLY=($(compgen -o bashdefault -o default -o dirnames -o filenames "$word"))
}

complete -F _batect_completion_proxy batect
