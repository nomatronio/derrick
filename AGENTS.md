# Agent and Contributor Rules — MPL Compliance

This repository contains MPL-covered files inherited from HashiCorp Waypoint v0.11.4. All contributors and AI agents must follow these rules.

## Core Rule

> This repository contains MPL-covered files inherited from Waypoint. You may modify those files only in this public open-core repository. Proprietary enterprise features must be implemented in separate files, packages, modules, or plugin binaries in the `derrick-enterprise` repository that do not copy MPL source. When in doubt, pause and request legal/maintainer review.

## Required Rules

1. Treat files inherited from Waypoint v0.11.4 as MPL-covered unless proven otherwise.
2. Any modification to an MPL-covered file must be made in this public open-core repository.
3. Do not add proprietary enterprise logic to MPL-covered files.
4. Do not copy code from MPL-covered files into private enterprise files.
5. Enterprise features must be implemented behind public interfaces, extension points, or out-of-process plugin boundaries.
6. New private files must not contain MPL-covered source unless they are also published under MPL.
7. Generated files derived from MPL-covered inputs must be reviewed before being placed in private repos.
8. Public extension points should be generic and product-appropriate, not hard-coded around private enterprise implementations.
9. Private enterprise builds may link or load private modules, but this public fork must remain buildable with open/basic/no-op implementations.
10. Any agent that is unsure whether a change touches MPL-covered code must stop and ask for human review.
11. Every PR should classify whether it touches open-core MPL files, private enterprise files, or both.
12. Release automation must verify that the source corresponding to all MPL-covered binary components is public or otherwise provided to recipients.
13. Plugin registry protocol, plugin manifest format, plugin lock file format, and plugin runtime protocol belong in this public core unless legal/maintainer review explicitly approves another boundary.
14. Private plugins may be proprietary, but they must use public plugin interfaces and must not require private-only changes to the public plugin loader.

## Where Code Belongs

| Change | Repository |
|--------|------------|
| Modifications to inherited Waypoint files | `derrick` (this repo) |
| New public interfaces for approvals/audit/policy/RBAC | `derrick` (this repo) |
| Basic/no-op approval/audit/policy implementation | `derrick` (this repo) |
| Plugin registry protocol/client/resolver | `derrick` (this repo) |
| Built-in and community plugins | `derrick` (this repo) |
| Proprietary RBAC, SSO, license enforcement | `derrick-enterprise` |
| Enterprise approval/audit/policy implementations | `derrick-enterprise` |
| Private enterprise plugins | `derrick-enterprise` |

## PR Checklist

See `.github/PULL_REQUEST_TEMPLATE.md` for the PR checklist.

## Cursor Cloud specific instructions

Derrick is a Go monolith (`derrick` = CLI + server + runner, `cmd/derrick`) plus an
Ember.js web UI (`ui/`). Standard build/run/test commands live in `README.md`,
`.github/CONTRIBUTING.md`, `ui/README.md`, the root `Makefile`, `ui/Makefile`, and the
CI workflows under `.github/workflows/`. Only the non-obvious environment caveats are
noted here.

### Toolchain (already installed; interactive/`tmux` shells load it via `~/.bashrc`)
- Go **1.19.13** at `/usr/local/go-1.19.13` — the repo pins Go 1.19 (`.go-version`,
  `go.mod`). The base image's system Go is newer; use 1.19 for parity with CI and
  because `golangci-lint` needs it (see Lint).
- `go-bindata` (kevinburke, v3.23.0) in `~/go/bin` — **required** by `make bin`/`make static-assets`.
- Node **14** via `nvm` (set as the default alias) — the UI does not build on the
  system/`/exec-daemon` Node (v22). `~/.bashrc` runs `nvm use 14`.
- The **Shell tool runs non-interactively and does not source `~/.bashrc`**. In one-off
  shell commands either wrap them in `bash -lc '...'`, or prepend PATH explicitly, e.g.
  `export PATH="/usr/local/go-1.19.13/bin:$HOME/go/bin:$PATH"` (Go) and
  `export PATH="$HOME/.nvm/versions/node/v14.21.3/bin:$PATH"` (UI).

### Critical gotcha: proto registration panic
Several built-in plugins register a proto file named `plugin.proto`, which makes the
`derrick` binary **and Go tests panic** on startup: `proto: file "plugin.proto" is
already registered`. You MUST set `GOLANG_PROTOBUF_REGISTRATION_CONFLICT=warn` when
running the binary or `go test` (CI sets this; `~/.bashrc` exports it). Harmless
`WARNING: proto: ...` lines are then printed to stderr — filter them out when reading
CLI output.

### Backend build / test / lint
- Build: `make bin` (~2 min; cross-compiles the entrypoint and embeds it). `make bin/cli-only`
  is faster but omits the entrypoint (CEB).
- Test: `make test` runs everything. Packages under `pkg/server/singleprocess` need a
  Postgres (see `.github/services/go-tests/docker-compose.yml`); **Docker is not installed**
  by default, so run self-contained packages directly (e.g. `go test ./internal/pkg/...
  ./internal/config/...`) or `make test/boltdbstate`.
- Lint: `./bin/golangci-lint` (v1.50.1) with the CI flags (`--disable-all --enable gofmt
  --enable gosimple --enable govet`). It requires Go 1.19 (typecheck-errors against a
  newer stdlib) and can OOM at high concurrency — keep `--concurrency 2` and lint scoped
  package sets rather than the whole tree at once.

### Running the server + CLI (no Docker needed)
```
./derrick server run -accept-tos -db=/tmp/derrick-data.db \
  -listen-grpc=127.0.0.1:9701 -listen-http=127.0.0.1:9702      # long-running; use tmux
./derrick server bootstrap -server-addr=127.0.0.1:9701 -server-tls-skip-verify  # one-time
./derrick project apply <name>        # creates a project (exercises server + BoltDB state)
./derrick user token                  # token for UI/CLI login
```
Real build/deploy/release (`derrick up`, docker/k8s/nomad platforms) require Docker,
which is not installed here.

### UI (`ui/`)
- `ember` is a local dependency, not global — run `./node_modules/.bin/ember ...`
  (or `yarn <script>`), under Node 14.
- Dev UI: `./node_modules/.bin/ember serve local` serves `http://localhost:4200` and
  points the API at `https://localhost:9702` (the running server). Because the server
  uses a self-signed cert, first open `https://localhost:9702` in the browser and accept
  the warning, then log in at `:4200` with the output of `derrick user token`.
- The server's **embedded** UI at `:9702` is stale (a pre-fork Waypoint build committed in
  `pkg/server/gen/bindata_ui.go`) and shows `unknown service hashicorp.waypoint.Waypoint`;
  regenerate it with `cd ui && ./node_modules/.bin/ember build && cd .. && make static-assets`.
  For UI work prefer the `:4200` dev server.
- Ember tests need Chrome with `--no-sandbox`; run `CI=true yarn test:ember:ci` (Chrome is
  at `/usr/local/bin/google-chrome`).
