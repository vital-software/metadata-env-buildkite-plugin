#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
export BUILDKITE_AGENT_METADATA_ENV_DEBUG=/dev/tty

@test "Pre-command gets build metadata" {
  stub buildkite-agent \
    "meta-data get metadata-env-plugin-FOO : echo foo-123" \
    "meta-data get metadata-env-plugin-BAR : echo bar-456"

  export BUILDKITE_PLUGIN_METADATA_ENV_GET_0="FOO"
  export BUILDKITE_PLUGIN_METADATA_ENV_GET_1="BAR"

  run "$PWD/hooks/pre-command"

  assert_output --partial "Retrieved FOO=foo-123 from build metadata"
  assert_output --partial "Retrieved BAR=bar-456 from build metadata"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_METADATA_ENV_GET_0
  unset BUILDKITE_PLUGIN_METADATA_ENV_GET_1
}

@test "Post-command sets build metadata" {
  stub buildkite-agent \
    "meta-data set metadata-env-plugin-FOO foo-123 : echo Setting metadata-env-plugin-FOO" \
    "meta-data set metadata-env-plugin-BAR bar-456 : echo Setting metadata-env-plugin-BAR"

  export BUILDKITE_PLUGIN_METADATA_ENV_SET_0="FOO"
  export BUILDKITE_PLUGIN_METADATA_ENV_SET_1="BAR"
  export FOO="foo-123"
  export BAR="bar-456"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Setting metadata-env-plugin-FOO"
  assert_output --partial "Setting metadata-env-plugin-BAR"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_METADATA_ENV_SET_0
  unset BUILDKITE_PLUGIN_METADATA_ENV_SET_1
}
