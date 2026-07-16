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
