#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
export BUILDKITE_AGENT_METADATA_ENV_DEBUG=/dev/tty

@test "Pre-command sets build metadata" {
  stub buildkite-agent \
    "meta-data set metadata-env-plugin-FOO foo-123 : echo Setting metadata-env-plugin-FOO" \
    "meta-data set metadata-env-plugin-BAR bar-456 : echo Setting metadata-env-plugin-BAR"

  export BUILDKITE_PLUGIN_METADATA_ENV_SET_0="FOO"
  export BUILDKITE_PLUGIN_METADATA_ENV_SET_1="BAR"
  export FOO="foo-123"
  export BAR="bar-456"

  run "$PWD/hooks/pre-command"

  assert_success
  assert_output --partial "Setting metadata-env-plugin-FOO"
  assert_output --partial "Setting metadata-env-plugin-BAR"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_METADATA_ENV_SET_0
  unset BUILDKITE_PLUGIN_METADATA_ENV_SET_1
}
