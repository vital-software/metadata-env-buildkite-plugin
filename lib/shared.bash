#!/usr/bin/env bash

# Show a prompt for a command
function plugin_prompt() {
  if [[ -z "${HIDE_PROMPT:-}" ]] ; then
    echo -ne '\033[90m$\033[0m' >&2
    printf " %q" "$@" >&2
    echo >&2
  fi
}

# Shows the command being run, and runs it
function plugin_prompt_and_run() {
  plugin_prompt "$@"
  "$@"
}

# Shows the command about to be run, and exits if it fails
function plugin_prompt_and_must_run() {
  plugin_prompt_and_run "$@" || exit $?
}

# Reads either a value or a list from plugin config
function plugin_read_list() {
  local prefix="BUILDKITE_PLUGIN_METADATA_ENV_$1"
  local parameter="${prefix}_0"

  if [[ -n "${!parameter:-}" ]]; then
    local i=0
    local parameter="${prefix}_${i}"
    while [[ -n "${!parameter:-}" ]]; do
      echo "${!parameter}"
      i=$((i+1))
      parameter="${prefix}_${i}"
    done
  elif [[ -n "${!prefix:-}" ]]; then
    echo "${!prefix}"
  fi
}

# Joins all arguments by a delimiter
function join_by {
    local d=$1
    shift
    echo -n "$1"
    shift
    printf "%s" "${@/#/$d}"
}
