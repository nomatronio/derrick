#!/usr/bin/env python3
"""Waypoint → Derrick plugin identifier and label namespace rename."""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REPLACEMENTS = [
    ("waypoint-plugin-", "derrick-plugin-"),
    (".waypoint/plugins", ".derrick/plugins"),
    ('".waypoint", "plugins"', '".derrick", "plugins"'),
    ('".config", "waypoint", "plugins"', '".config", "derrick", "plugins"'),
    ("waypoint/workspace", "derrick/workspace"),
    ('prefix "waypoint/"', 'prefix "derrick/"'),
    ('prefix \'waypoint/\'', "prefix 'derrick/'"),
    ('HasPrefix(k, "waypoint/")', 'HasPrefix(k, "derrick/")'),
    ('"waypoint/${k}"', '"derrick/${k}"'),
    ("waypoint/hashicorp/", "derrick/nomatronio/"),
]

TARGETS = [
    ROOT / "internal/plugin/discover.go",
    ROOT / "internal/plugin/discover_test.go",
    ROOT / "internal/config/plugin.go",
    ROOT / "internal/config/validate.go",
    ROOT / "internal/config/app.go",
    ROOT / "internal/config/app_test.go",
    ROOT / "internal/config/testdata",
    ROOT / "internal/core/project.go",
    ROOT / "internal/core/app_build_test.go",
    ROOT / "pkg/config/funcs/selector_test.go",
    ROOT / "internal/cli/artifact_list.go",
    ROOT / "internal/cli/deployment_list.go",
    ROOT / "internal/cli/release_list.go",
    ROOT / ".github/workflows/notify-integration-release-manual.yml",
]


def collect_files() -> list[Path]:
    files: list[Path] = []
    for target in TARGETS:
        if target.is_dir():
            files.extend(sorted(target.rglob("*")))
        elif target.is_file():
            files.append(target)
    return [f for f in files if f.is_file()]


def main() -> int:
    changed = 0
    for path in collect_files():
        try:
            original = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        updated = original
        for old, new in REPLACEMENTS:
            updated = updated.replace(old, new)
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            changed += 1
            print(f"updated {path.relative_to(ROOT)}")
    print(f"done: {changed} files updated")
    return 0


if __name__ == "__main__":
    sys.exit(main())
