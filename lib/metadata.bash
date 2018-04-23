#!/usr/bin/env bash

function plugin_get_metadata() {
  local key="env-$1"
  plugin_prompt buildkite-agent meta-data get "$key"
  buildkite-agent meta-data get "$key" || (
    echo "~~~ Failed to get metadata $key (exit $?)" >&2
    return 1
  )
}

function plugin_set_metadata() {
  local key="env-$1"
  local value="$2"
  plugin_prompt_and_must_run buildkite-agent meta-data set "$key" "$value"
}
