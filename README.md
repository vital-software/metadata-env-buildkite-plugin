# Metadata Env Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for setting and retrieving metadata to and from
environment variables.

## Example

```yaml
steps:
  - label:   "Set some dynamic variables in an early part of the build"
    command: export FOO=$(something-dynamic)
    plugins:
      vital-software/metadata-env#0.0.1:
        set:
          - FOO

[...]

  - label:   "Use those variables later"
    command: echo "The value was $FOO"
    plugins:
      vital-software/metadata-env#0.0.1:
        get:
          - FOO
```

## Configuration

### `set`

A list of environment variable names. Their values after running the current command will be persisted into build metadata.

### `get`

Another list of environment variable names. Their values will be retrieved from the build metadata, and set for the current command.

## License

MIT (see [LICENSE](LICENSE))
