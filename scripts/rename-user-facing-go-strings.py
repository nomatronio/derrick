#!/usr/bin/env python3
"""Replace Waypoint branding in user-facing Go string literals."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

TARGET_DIRS = [
    ROOT / "cmd",
    ROOT / "internal/cli",
    ROOT / "internal/cli/app_docs.go",
    ROOT / "internal/serverinstall",
    ROOT / "internal/runnerinstall",
    ROOT / "internal/installutil",
    ROOT / "internal/runner",
    ROOT / "internal/ceb",
    ROOT / "internal/core",
    ROOT / "internal/config",
    ROOT / "internal/client",
    ROOT / "internal/clicontext",
    ROOT / "internal/server",
    ROOT / "internal/appconfig",
    ROOT / "internal/datasource",
    ROOT / "internal/plugin",
    ROOT / "internal/version",
    ROOT / "internal/pkg",
    ROOT / "builtin",
    ROOT / "pkg/auth",
    ROOT / "pkg/config",
    ROOT / "pkg/serverclient",
    ROOT / "pkg/server/singleprocess",
    ROOT / "pkg/serverhandler",
    ROOT / "pkg/serverstate",
    ROOT / "test-e2e",
]

SKIP_SUFFIXES = ("_test.go",)
SKIP_PARTS = {"gen", "plugin.pb.go", "testdata"}

PROTECT = [
    "waypoint/workspace",
    "waypoint-plugin",
    "waypoint.run",
    "api.waypoint.run",
    "waypoint.hashicorp.com",
    "waypoint-examples",
    "hashicorp/waypoint-hzn",
    "hashicorp/waypoint-helm",
    "hashicorp/waypoint",
    "github.com/hashicorp/waypoint",
    "circleci/waypoint",
    "waypoint-ui",
    "waypoint-server",
    "waypoint-server-snapshot",
    "waypoint-static-runner",
    "waypoint-type",
    "from-waypoint-hcl",
    "waypoint-hcl",
    "-waypoint-hcl",
    "<waypoint-hcl>",
]

STRING_RE = re.compile(r'`(?:\\.|[^`\\])*`|"(?:\\.|[^"\\])*"')


def protect(text: str) -> str:
    tokens: dict[str, str] = {}
    for i, orig in enumerate(PROTECT):
        token = f"___WP_PROT_{i}___"
        if orig in text:
            tokens[token] = orig
            text = text.replace(orig, token)
    return text, tokens


def unprotect(text: str, tokens: dict[str, str]) -> str:
    for token, orig in tokens.items():
        text = text.replace(token, orig)
    return text


def transform_string_literal(literal: str) -> str:
    protected, tokens = protect(literal)
    updated = protected
    # Longer / specific phrases before generic replacement.
    for old, new in [
        ("HashiCorp Waypoint", "Derrick"),
        ("Hashicorp Waypoint", "Derrick"),
        ("/waypoint/docs/", "/derrick/docs/"),
        ("Waypoint.hcl", "derrick.hcl"),
        ("waypoint.hcl", "derrick.hcl"),
        ("hashicorp/waypoint:latest", "nomatronio/derrick:latest"),
        ("hashicorp/waypoint-odr:latest", "nomatronio/derrick-odr:latest"),
        ("waypoint login", "derrick login"),
        ("waypoint init", "derrick init"),
        ("waypoint install", "derrick install"),
        ("waypoint version", "derrick version"),
        ("waypoint upgrade", "derrick upgrade"),
        ("waypoint uninstall", "derrick uninstall"),
        ("waypoint runner", "derrick runner"),
        ("waypoint server", "derrick server"),
        ("waypoint context", "derrick context"),
        ("waypoint status", "derrick status"),
        ("waypoint project", "derrick project"),
        ("waypoint user", "derrick user"),
        ("waypoint token", "derrick token"),
        ("waypoint up", "derrick up"),
        ("waypoint build", "derrick build"),
        ("waypoint deploy", "derrick deploy"),
        ("waypoint logs", "derrick logs"),
        ("waypoint ui", "derrick ui"),
        ("waypoint config", "derrick config"),
        ("waypoint job", "derrick job"),
        ("waypoint task", "derrick task"),
        ("waypoint release", "derrick release"),
        ("waypoint artifact", "derrick artifact"),
        ("waypoint deployment", "derrick deployment"),
        ("waypoint exec", "derrick exec"),
        ("waypoint destroy", "derrick destroy"),
        ("waypoint snapshot", "derrick snapshot"),
        ("waypoint -v", "derrick -v"),
        ("run \"waypoint", "run \"derrick"),
        ("use \"waypoint", "use \"derrick"),
        ("see \"waypoint", "see \"derrick"),
        ("with \"waypoint", "with \"derrick"),
        ("call 'waypoint", "call 'derrick"),
        ("'waypoint ", "'derrick "),
        ("`waypoint ", "`derrick "),
        ("“waypoint ", "“derrick "),
        ("‘waypoint ", "‘derrick "),
        ("Waypoint", "Derrick"),
    ]:
        updated = updated.replace(old, new)
    return unprotect(updated, tokens)


def transform_file(text: str, *, is_hcl: bool = False) -> str:
    if is_hcl:
        protected, tokens = protect(text)
        updated = protected.replace("Waypoint", "Derrick")
        return unprotect(updated, tokens)

    def repl(match: re.Match[str]) -> str:
        return transform_string_literal(match.group(0))

    return STRING_RE.sub(repl, text)


def should_process(path: Path) -> bool:
    if path.suffix not in {".go", ".hcl"}:
        return False
    if path.name.endswith(SKIP_SUFFIXES) and "test-e2e" not in path.parts:
        return False
    if any(part in SKIP_PARTS for part in path.parts):
        return False
    if path.name == "plugin.pb.go":
        return False
    return True


def collect_files() -> list[Path]:
    files: list[Path] = []
    for base in TARGET_DIRS:
        if not base.exists():
            continue
        if base.is_file():
            if should_process(base):
                files.append(base)
            continue
        for path in base.rglob("*"):
            if path.is_file() and should_process(path):
                files.append(path)
    tpl = ROOT / "internal/cli/data/init.tpl.hcl"
    if tpl.exists():
        files.append(tpl)
    return sorted(set(files))


def main() -> int:
    changed = 0
    for path in collect_files():
        original = path.read_text(encoding="utf-8")
        updated = transform_file(original, is_hcl=path.suffix == ".hcl")
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            changed += 1
            print(f"updated {path.relative_to(ROOT)}")
    print(f"done: {changed} files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
