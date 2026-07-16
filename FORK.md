# Fork Provenance

This repository is **Derrick**, an open-core fork of [HashiCorp Waypoint](https://github.com/hashicorp/waypoint).

## Fork Point

| Field | Value |
|-------|-------|
| Upstream repository | https://github.com/hashicorp/waypoint |
| Fork tag | `v0.11.4` |
| Fork commit | `7128fba03891df32b77e341d2380fe8f48a0b508` |
| License at fork point | Mozilla Public License 2.0 (MPL 2.0) |

## What Is In Scope

This repository contains only the MPL 2.0-licensed Waypoint Community Edition source as of tag `v0.11.4`. It was cloned with `--single-branch` from that tag so that no post-v0.11.4 Business Source License (BUSL) commits are included.

## What Is Out Of Scope

- HashiCorp Waypoint `main` branch and any release after v0.11.4 (BUSL-licensed).
- HCP Waypoint (HashiCorp's SaaS product).
- Proprietary enterprise features (see the separate `derrick-enterprise` repository).

## Upstream Remote

The read-only remote `upstream-waypoint` points to the original HashiCorp repository. Do **not** merge from `upstream-waypoint/main`. It may be used for reference or selective cherry-picks of MPL-era changes only, with legal review.

## Modifications

Nomatron Ltd modifications to this fork are tracked in this repository. All changes to MPL-covered files must remain in this public repository per the MPL 2.0 license and project `AGENTS.md` rules.

## Rename Status

The product is named **Derrick**. The codebase still uses Waypoint naming (binary, module path, HCL filename) until a dedicated rename milestone. See `README.md` for current build instructions.
