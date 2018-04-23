#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
export BUILDKITE_AGENT_METADATA_ENV_DEBUG=/dev/tty

@test "Environment gets build metadata" {
  stub buildkite-agent \
    "meta-data get metadata-env-plugin-FOO : echo foo-123" \
    "meta-data get metadata-env-plugin-BAR : echo bar-456"

  export BUILDKITE_PLUGIN_METADATA_ENV_GET_0="FOO"
  export BUILDKITE_PLUGIN_METADATA_ENV_GET_1="BAR"

  run "$PWD/hooks/environment"

  assert_output --partial "Retrieved FOO=foo-123 from build metadata"
  assert_output --partial "Retrieved BAR=bar-456 from build metadata"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_METADATA_ENV_GET_0
  unset BUILDKITE_PLUGIN_METADATA_ENV_GET_1
}
