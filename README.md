# Metadata Env Buildkite Plugin [![Build status](https://badge.buildkite.com/bbe46dcd1115c367a4a8018bd0df56059f72da1feb76a88e66.svg?branch=master)](https://buildkite.com/vital/metadata-env-buildkite-plugin)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for
retrieving build metadata values and setting them as environment variables.
This provides a nice way to pass environment variables between steps in a
build, even when their values are dynamically calculated.

Notably, this plugin is just syntactic sugar for `export FOO=$(buildkite-agent
meta-data get env-FOO)`, but can be used with other plugins where the command
isn't executed directly on the agent (e.g. the docker-compose plugin)

## Usage

This plugin uses the prefix `env-` in build metadata to denote a piece of
metadata that can be exported as an environment variable. Set the value you're
interested in earlier in the build, using the `buildkite-agent meta-data set`
command:

```yaml
steps:
  - label: "Set and store an env var"
    command:
      - export FOO=$(something-dynamic)
      - buildkite-agent meta-data set env-FOO ${FOO}
```

Later, in a different build step, use the plugin to retrieve the value you set
and recreate the environment variable:

```yaml
steps:
  - label:   "Retrieve and use an env var"
    command: echo "The value was $FOO"
    plugins:
      - vital-software/metadata-env#0.0.1:
          get: [FOO]
```

## Configuration

### `get`

A list of environment variable names. Their values will be retrieved from the
build metadata, if set, and used for the current command.

## TODO

- This plugin initially came with logic to support a corresponding `set`
  configuration, where it would store env var variables back to the metadata,
  post-command. However, if the value was calculated within a build step, the
  post-command hook won't have access to it. Suggestions for working around
  that are welcome.

## Developing

To run the tests:

```bash
docker-compose run --rm tests
```


## License

MIT (see [LICENSE](LICENSE))
