#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export BUILDKITE_AGENT_METADATA_ENV_DEBUG=/dev/tty

@test "Pre-command sets build metadata" {
  stub buildkite-agent \
    "metadata-env get FOO : echo Setting metadata"

  export BUILDKITE_PLUGIN_METADATA_ENV_SET_1="FOO"
  export BUILDKITE_PLUGIN_METADATA_ENV_SET_2="BAR"
  run "$PWD/hooks/pre-command"

  assert_success
  assert_output --partial "Setting metadata"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_METADATA_ENV_SET_1
  unset BUILDKITE_PLUGIN_METADATA_ENV_SET_2
}
