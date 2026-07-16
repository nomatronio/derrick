# Derrick

**Enterprise application delivery under control.**

Derrick is a developer-centric, multi-runtime application delivery platform with enterprise governance. It is an open-core fork of [HashiCorp Waypoint](https://github.com/hashicorp/waypoint) v0.11.4 (MPL 2.0).

## Quick Start

```bash
# Build CLI (requires go-bindata in PATH)
make bin/cli-only
./derrick version

# Full build (includes entrypoint cross-compilation)
make bin
```

Requires Go 1.19 or later.

## Configuration

- Application config file: `derrick.hcl`
- CLI config directory: `~/.config/derrick`
- Environment variables: `DERRICK_SERVER_ADDR`, `DERRICK_SERVER_TOKEN`, etc.

## Fork Provenance

See [FORK.md](FORK.md) for full fork details and [NOTICE](NOTICE) for copyright attribution.

## Repository Layout

| Repository | Purpose |
|------------|---------|
| [`nomatronio/derrick`](https://github.com/nomatronio/derrick) | Public MPL 2.0 open core (this repo) |
| [`nomatronio/derrick-plugin-sdk`](https://github.com/nomatronio/derrick-plugin-sdk) | Public MPL 2.0 plugin SDK |
| `nomatronio/derrick-enterprise` | Private enterprise implementation |

## Local Development

Use a local `go.work` file in the parent directory:

```go
go 1.22

use (
    ./derrick
    ./derrick-enterprise
    ./derrick-plugin-sdk
)
```

**Do not commit `go.work` to any repository.**

## Contributing

Read [AGENTS.md](AGENTS.md) before making changes.

## Legal

- Product name **Derrick** is pending formal trademark clearance.
- This is not legal advice. See [FORK.md](FORK.md) and [LICENSE](LICENSE) for license terms.
