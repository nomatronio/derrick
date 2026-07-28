#!/usr/bin/env python3
"""Targeted Waypoint → Derrick rename for install/runtime Go packages."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

TARGETS = [
    ROOT / "internal/serverinstall",
    ROOT / "internal/runnerinstall",
    ROOT / "internal/installutil",
    ROOT / "internal/runner",
    ROOT / "internal/ceb",
    ROOT / "cmd/derrick-entrypoint",
    ROOT / "internal/cli/login.go",
    ROOT / "internal/cli/server_run.go",
]

PROTECT = [
    ("github.com/hashicorp/waypoint-hzn", "___WAYPOINT_HZN___"),
    ("hashicorp/waypoint-helm", "___WAYPOINT_HELM___"),
    ("waypoint.hashicorp.com", "___WAYPOINT_HASHICORP___"),
    ("api.waypoint.run", "___API_WAYPOINT___"),
]

REPLACEMENTS = [
    ("HashiCorp Waypoint", "Derrick"),
    ("ghcr.io/hashicorp/waypoint", "ghcr.io/nomatronio/derrick"),
    ("hashicorp/waypoint-odr", "nomatronio/derrick-odr"),
    ("hashicorp/waypoint", "nomatronio/derrick"),
    ("defaultWaypointConsulHostname", "defaultDerrickConsulHostname"),
    ("waypointBackendServiceName", "derrickBackendServiceName"),
    ("waypointUIServiceName", "derrickUIServiceName"),
    ("waypointNomadJob", "derrickNomadJob"),
    ("waypointRunnerNomadJob", "derrickRunnerNomadJob"),
    ("getWaypointAddress", "getDerrickAddress"),
    ("waypointServerContainer", "derrickServerContainer"),
    ("waypointNetwork", "derrickNetwork"),
    ("waypointUserID", "derrickUserID"),
    ("waypointGroupID", "derrickGroupID"),
    ("waypointRunnerJobName", "derrickRunnerJobName"),
    ("waypoint-server-security-group", "derrick-server-security-group"),
    ("waypoint-server-execution-role", "derrick-server-execution-role"),
    ("waypoint-runner-execution-role", "derrick-runner-execution-role"),
    ("waypoint-server-logs", "derrick-server-logs"),
    ("waypoint-runner-logs", "derrick-runner-logs"),
    ("waypoint-server-nlb", "derrick-server-nlb"),
    ("waypoint-server-grpc", "derrick-server-grpc"),
    ("waypoint-server-http", "derrick-server-http"),
    ("waypoint-static-runner", "derrick-static-runner"),
    ("waypoint-server-token", "derrick-server-token"),
    ("waypoint-bootstrap", "derrick-bootstrap"),
    ("waypoint-runner-odr", "derrick-runner-odr"),
    ("waypoint-runner-rolebinding", "derrick-runner-rolebinding"),
    ("waypoint-runner-role", "derrick-runner-role"),
    ("waypoint-odr-policy", "derrick-odr-policy"),
    ("waypointserverdata", "derrickserverdata"),
    ("/waypoint-data", "/derrick-data"),
    ("waypointdata", "derrickdata"),
    ("waypoint-server", "derrick-server"),
    ("waypoint-runner", "derrick-runner"),
    ("waypoint-ui", "derrick-ui"),
    ("waypoint-type", "derrick-type"),
    ("waypoint_heap", "derrick_heap"),
    ("`waypoint install`", "`derrick install`"),
    ("`waypoint runner install`", "`derrick runner install`"),
    ("`waypoint runner agent`", "`derrick runner agent`"),
    ("`waypoint config`", "`derrick config`"),
    ("`waypoint:latest`", "`derrick:latest`"),
    ('"waypoint install"', '"derrick install"'),
    (".waypoint", ".derrick"),
    ("waypoint-test", "derrick-test"),
    ("Waypoint", "Derrick"),
    ('Label "use=waypoint"', 'Label "use=derrick"'),
    ('"use=waypoint"', '"use=derrick"'),
    ('"use": "waypoint"', '"use": "derrick"'),
    ('NetworkCreate(ctx, "waypoint"', 'NetworkCreate(ctx, "derrick"'),
    ('Network:     "waypoint"', 'Network:     "derrick"'),
    ('"waypoint": {}', '"derrick": {}'),
    ('Prefix: "waypoint"', 'Prefix: "derrick"'),
    ('serviceName                  = "waypoint"', 'serviceName                  = "derrick"'),
    ('defaultServiceTag             = "waypoint"', 'defaultServiceTag             = "derrick"'),
    ('client.ReleaseName = "waypoint"', 'client.ReleaseName = "derrick"'),
    ('created by waypoint', 'created by derrick'),
    ('waypoint control service', 'derrick control service'),
    ('no waypoint server configured', 'no derrick server configured'),
    ('waypoint server', 'derrick server'),
    ('waypoint runner', 'derrick runner'),
    ('waypoint image', 'derrick image'),
    ('waypoint job', 'derrick job'),
    ('waypoint server container', 'derrick server container'),
    ('waypoint network', 'derrick network'),
    ('waypoint ', 'derrick '),
    ("waypoint\n", "derrick\n"),
    ('"waypoint"', '"derrick"'),
    ("'waypoint'", "'derrick'"),
    ("waypoint.", "derrick."),
]


def collect_files() -> list[Path]:
    files: list[Path] = []
    for target in TARGETS:
        if target.is_dir():
            files.extend(sorted(target.rglob("*.go")))
        elif target.is_file():
            files.append(target)
    return files


def protect(text: str) -> str:
    for orig, token in PROTECT:
        text = text.replace(orig, token)
    return text


def unprotect(text: str) -> str:
    for orig, token in PROTECT:
        text = text.replace(token, orig)
    return text


def transform(text: str) -> str:
    text = protect(text)
    for old, new in REPLACEMENTS:
        text = text.replace(old, new)
    text = unprotect(text)
    return text


def main() -> int:
    changed = 0
    for path in collect_files():
        original = path.read_text(encoding="utf-8")
        updated = transform(original)
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            changed += 1
            print(f"updated {path.relative_to(ROOT)}")
    print(f"done: {changed} files updated")
    return 0


if __name__ == "__main__":
    sys.exit(main())
