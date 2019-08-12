#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
export BUILDKITE_AGENT_METADATA_ENV_DEBUG=/dev/tty

@test "Environment gets build metadata" {
  stub buildkite-agent \
    "meta-data get env-FOO : echo foo-123" \
    "meta-data get env-BAR : echo bar-456"

  export BUILDKITE_PLUGIN_METADATA_ENV_GET_0="FOO"
  export BUILDKITE_PLUGIN_METADATA_ENV_GET_1="BAR"

  run "$PWD/hooks/environment"

  assert_output --partial "Retrieved FOO=foo-123 from build metadata"
  assert_output --partial "Retrieved BAR=bar-456 from build metadata"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_METADATA_ENV_GET_0
  unset BUILDKITE_PLUGIN_METADATA_ENV_GET_1
}

@test "Environment gets build metadata with spaces" {
  stub buildkite-agent \
    "meta-data get env-SPACE : echo Contains some spaces"

    export BUILDKITE_PLUGIN_METADATA_ENV_GET_0="SPACE"

    run "$PWD/tests/space-as-expected"

    assert_output --partial "Environment Variable SPACE: 'Contains some spaces' as expected"

    unstub buildkite-agent
    unset BUILDKITE_PLUGIN_METADATA_ENV_GET_0
}

@test "Environment copes with missing metadata" {
  stub buildkite-agent \
    "meta-data get env-MISSING : echo 'Failed to get metadata metadata-env-plugin-API_VERSION' >&2 && exit 1"

  export BUILDKITE_PLUGIN_METADATA_ENV_GET_0="MISSING"

  run "$PWD/hooks/environment"

  assert_output --partial "Value for MISSING is missing or empty in build metadata - not setting variable"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_METADATA_ENV_GET_0
}
