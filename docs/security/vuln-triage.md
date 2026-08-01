# Vulnerability Triage (Foundation Hardening)

This document records vulnerability findings from `govulncheck` that are intentionally deferred during the foundation hardening phase. Tier-3b modules were bumped where a clear fixed version exists and tests pass.

## Fixed in foundation hardening (tier 3b)

| Module | Previous | Updated | Notes |
|--------|----------|---------|-------|
| `google.golang.org/grpc` | v1.50.1 | v1.56.3 | Stepwise bump (GO-2023-2153); v1.79+ deferred — breaks TLS serverclient tests until test/server TLS config is updated |
| `golang.org/x/text` | v0.7.0 | v0.39.0 | Direct bump |
| `golang.org/x/net` | v0.1.0 (SDK) | v0.23.0 | Bumped in SDK |
| `github.com/go-git/go-git/v5` | v5.2.0 | v5.19.1 | Git datasource paths |
| `github.com/opencontainers/runc` | v1.1.5 | v1.3.6 | Indirect dep |
| `github.com/distribution/distribution/v3` | pseudo-version | N/A | Migrated `internal/installutil` to `github.com/distribution/reference` |

## Deferred (track per-plugin / modernization)

### `google.golang.org/grpc` (v1.57+)

- **Rationale:** v1.80+ causes `pkg/serverclient` TLS integration test failures (gRPC dial timeout with self-signed certs). Requires follow-up to set `NextProtos: []string{"h2"}` on test TLS configs and validate production server TLS before further bumps.
- **Impact:** Server client connection paths.

### `github.com/docker/docker`

- **Rationale:** Large API surface; Dependabot ignored in this repo. Fix during Docker plugin extraction and modernization.
- **Impact:** Docker builder/platform builtins.

### `github.com/containerd/containerd`

- **Rationale:** Indirect via Docker/buildpacks; no simple patch without Docker ecosystem upgrade.
- **Impact:** Container build paths (pack, docker).

### `golang.org/x/crypto` (openpgp)

- **Rationale:** openpgp package is unmaintained; findings trace via Helm chart verify and go-git init. No drop-in fixed version.
- **Impact:** Helm and git-related verification paths.

### `k8s.io/*` (client-go, apimachinery, etc.)

- **Rationale:** Major version migration; Dependabot explicitly defers k8s bumps. Address during Kubernetes plugin modernization.
- **Impact:** k8s, k8s/apply, k8s/helm builtins.

### `github.com/docker/distribution` (v2)

- **Rationale:** Legacy v2 module still used by several builtins for `reference` parsing. Separate from `distribution/v3`; migrate to `github.com/distribution/reference` incrementally.
- **Impact:** docker, k8s, pack, azure/aci reference validation.

## CI

`govulncheck ./...` runs on every PR in `.github/workflows/go-tests.yml` (derrick and derrick-plugin-sdk). New high-severity findings in tier-3b scope should be fixed or added here with rationale before merging.
