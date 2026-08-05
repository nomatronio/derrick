# Derrick compatibility with Waypoint

Derrick is a fork of HashiCorp Waypoint v0.11.4. Some wire formats and deployment
metadata retain legacy Waypoint identifiers for backward compatibility with
existing deployments and tooling.

## Deployment labels

Derrick-managed resources are labeled with **both** legacy and current keys:

| Purpose | Legacy (Waypoint) | Current (Derrick) |
|---------|-------------------|-------------------|
| Deployment ID | `waypoint.hashicorp.com/id` | `derrick.hashicorp.com/id` |
| Deploy nonce | `waypoint.hashicorp.com/nonce` | `derrick.hashicorp.com/nonce` |

New deployments receive both labels. Derrick reads either key when locating
existing resources.

Supported platforms in Phase 0: **Kubernetes**, **Docker**.

## Container entrypoint

Container images may use:

- `/derrick-entrypoint` (current)
- `/waypoint-entrypoint` (legacy, still recognized)

See `internal/pkg/epinject/entrypoint.go`.

## gRPC authentication metadata

Clients send bearer tokens using the metadata key:

- `waypoint-token` (current; retained for protocol compatibility)

## Plugin runtime handshake

External plugins use the go-plugin magic cookie key `WAYPOINT_PLUGIN` via the
public plugin SDK. Renaming this requires a coordinated SDK release.

## Migrating existing deployments

No action is required for deployments that only carry legacy labels. On the next
`derrick up`, platforms that support dual-write will add `derrick.hashicorp.com/*`
labels alongside existing `waypoint.hashicorp.com/*` labels.
