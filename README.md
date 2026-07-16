# Derrick

**Enterprise application delivery under control.**

Derrick is a developer-centric, multi-runtime application delivery platform with enterprise governance. It is an open-core fork of [HashiCorp Waypoint](https://github.com/hashicorp/waypoint) v0.11.4 (MPL 2.0).

> **Rename in progress.** The product is named Derrick, but the codebase still uses Waypoint naming (CLI binary, Go module path, `waypoint.hcl`). The binary currently builds as `waypoint` until the rename milestone.

## Fork Provenance

This repository was forked from Waypoint tag `v0.11.4` under the Mozilla Public License 2.0. Post-v0.11.4 BUSL-licensed upstream code is **not** included.

See [FORK.md](FORK.md) for full fork details and [NOTICE](NOTICE) for copyright attribution.

## Repository Layout

| Repository | Purpose |
|------------|---------|
| [`nomatronio/derrick`](https://github.com/nomatronio/derrick) | Public MPL 2.0 open core (this repo) |
| `nomatronio/derrick-enterprise` | Private enterprise implementation |

Enterprise features (RBAC, SSO, advanced approvals, license enforcement) live in the separate `derrick-enterprise` repository and are wired in via public extension points.

## Quick Start (Current Waypoint Build)

Until the rename milestone, build and run using the existing Waypoint toolchain:

```bash
# CLI-only build (fastest sanity check)
make bin/cli-only
./waypoint version

# Full build (includes entrypoint cross-compilation)
make bin
```

Requires Go 1.19 or later.

## Local Development With Enterprise

Use a local `go.work` file in the parent directory to develop both repos together. See the `derrick-enterprise` repository README.

**Do not commit `go.work` to either repository.**

## Contributing

Read [AGENTS.md](AGENTS.md) before making changes. All modifications to MPL-covered Waypoint files must stay in this public repository.

## Legal

- Product name **Derrick** is pending formal trademark clearance.
- This is not legal advice. See [FORK.md](FORK.md) and [LICENSE](LICENSE) for license terms.
