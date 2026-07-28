#!/usr/bin/env python3
"""Waypoint → Derrick rename for website, docs, and embedJson content."""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

TARGET_DIRS = [
    ROOT / "website",
    ROOT / "embedJson" / "gen",
    ROOT / "docs" / "gen",
]

SKIP_PARTS = {
    "node_modules",
    ".git",
    "package-lock.json",
}

EXTENSIONS = {".mdx", ".md", ".json", ".js", ".hbs", ".yaml", ".yml"}

PROTECT = [
    ("upstream-waypoint", "___UPSTREAM_WAYPOINT___"),
    ("hashicorp/waypoint-hzn", "___WAYPOINT_HZN___"),
    ("hashicorp/waypoint-helm", "___WAYPOINT_HELM___"),
    ("waypoint.hashicorp.com", "___WAYPOINT_HASHICORP___"),
]

REPLACEMENTS = [
    # URLs and site paths (longest first)
    ("/waypoint/docs/waypoint-hcl", "/derrick/docs/derrick-hcl"),
    ("/waypoint/docs/derrick-hcl", "/derrick/docs/derrick-hcl"),
    ("/waypoint/docs/", "/derrick/docs/"),
    ("/waypoint/plugins/", "/derrick/plugins/"),
    ("/waypoint/integrations", "/derrick/integrations"),
    ("/waypoint/tutorials/", "/derrick/docs/"),
    ("https://www.waypointproject.io", "https://derrick.dev"),
    ("https://waypointproject.io", "https://derrick.dev"),
    ("https://developer.hashicorp.com/waypoint", "https://derrick.dev/docs"),
    ("https://learn.hashicorp.com/tutorials/waypoint/", "https://derrick.dev/docs/"),
    ("https://discuss.hashicorp.com/c/waypoint/", "https://github.com/nomatronio/derrick/discussions"),
    ("github.com/hashicorp/waypoint-plugin-sdk", "github.com/nomatronio/derrick-plugin-sdk"),
    ("github.com/hashicorp/waypoint-plugin-examples", "github.com/nomatronio/derrick"),
    ("github.com/hashicorp/waypoint", "github.com/nomatronio/derrick"),
    ("ghcr.io/hashicorp/waypoint", "ghcr.io/nomatronio/derrick"),
    ("hub.docker.com/r/hashicorp/waypoint", "hub.docker.com/r/nomatronio/derrick"),
    ("gallery.ecr.aws/hashicorp/waypoint", "gallery.ecr.aws/nomatronio/derrick"),
    ("hashicorp/waypoint-odr", "nomatronio/derrick-odr"),
    ("hashicorp/waypoint", "nomatronio/derrick"),
    ("waypoint/hashicorp/", "derrick/nomatronio/"),
    ("waypoint-plugin-", "derrick-plugin-"),
    (".config/waypoint/plugins", ".config/derrick/plugins"),
    ("$HOME/.config/waypoint/plugins", "$HOME/.config/derrick/plugins"),
    ("waypoint-server-token", "derrick-server-token"),
    ("waypoint-server", "derrick-server"),
    ("waypoint-runner", "derrick-runner"),
    ("waypoint-ui", "derrick-ui"),
    ("waypoint/workspace", "derrick/workspace"),
    ('"waypoint/${k}"', '"derrick/${k}"'),
    ('prefix "waypoint/"', 'prefix "derrick/"'),
    ('prefix all our labels with "waypoint/"', 'prefix all our labels with "derrick/"'),
    ('label "waypoint/workspace', 'label "derrick/workspace'),
    ("waypoint.hcl", "derrick.hcl"),
    ("waypoint-hcl", "derrick-hcl"),
    ("`waypoint ", "`derrick "),
    (" waypoint ", " derrick "),
    ("# waypoint", "# derrick"),
    ("$ waypoint", "$ derrick"),
    ("waypoint install", "derrick install"),
    ("waypoint runner", "derrick runner"),
    ("waypoint login", "derrick login"),
    ("waypoint up", "derrick up"),
    ("waypoint deploy", "derrick deploy"),
    ("waypoint build", "derrick build"),
    ("waypoint release", "derrick release"),
    ("waypoint status", "derrick status"),
    ("waypoint exec", "derrick exec"),
    ("waypoint context", "derrick context"),
    ("waypoint project", "derrick project"),
    ("waypoint server", "derrick server"),
    ("waypoint config", "derrick config"),
    ("waypoint entrypoint", "derrick entrypoint"),
    ("waypoint-entrypoint", "derrick-entrypoint"),
    ("waypoint/helm", "derrick/helm"),
    ("waypoint/kubernetes-apply", "derrick/kubernetes-apply"),
    ("waypoint/kubernetes", "derrick/kubernetes"),
    ("waypoint/google-cloud-run", "derrick/google-cloud-run"),
    ("waypoint/azure-container-instance", "derrick/azure-container-instance"),
    ("waypoint/nomad-jobspec-canary", "derrick/nomad-jobspec-canary"),
    ("waypoint/nomad-jobspec", "derrick/nomad-jobspec"),
    ("waypoint/terraform-cloud", "derrick/terraform-cloud"),
    ("waypoint/lambda-function-url", "derrick/lambda-function-url"),
    ("waypoint/aws-ecr-pull", "derrick/aws-ecr-pull"),
    ("waypoint/docker-pull", "derrick/docker-pull"),
    ("waypoint/docker-ref", "derrick/docker-ref"),
    ("waypoint/aws-lambda", "derrick/aws-lambda"),
    ("waypoint/aws-ecr", "derrick/aws-ecr"),
    ("waypoint/aws-ecs", "derrick/aws-ecs"),
    ("waypoint/aws-ec2", "derrick/aws-ec2"),
    ("waypoint/aws-alb", "derrick/aws-alb"),
    ("waypoint/aws-ami", "derrick/aws-ami"),
    ("waypoint/aws-ssm", "derrick/aws-ssm"),
    ("waypoint/docker", "derrick/docker"),
    ("waypoint/nomad", "derrick/nomad"),
    ("waypoint/packer", "derrick/packer"),
    ("waypoint/consul", "derrick/consul"),
    ("waypoint/vault", "derrick/vault"),
    ("waypoint/exec", "derrick/exec"),
    ("waypoint/files", "derrick/files"),
    ("waypoint/null", "derrick/null"),
    ("waypoint/pack", "derrick/pack"),
    ("HashiCorp Waypoint", "Derrick"),
    ("HashiCorp Learn", "Derrick documentation"),
    ("HCP Waypoint", "Derrick"),
    ("Waypoint server", "Derrick server"),
    ("Waypoint runner", "Derrick runner"),
    ("Waypoint entrypoint", "Derrick entrypoint"),
    ("Waypoint URL", "Derrick URL"),
    ("Waypoint CLI", "Derrick CLI"),
    ("Waypoint UI", "Derrick UI"),
    ("Waypoint Helm", "Derrick Helm"),
    ("Waypoint configuration", "Derrick configuration"),
    ("Waypoint config", "Derrick config"),
    ("Waypoint project", "Derrick project"),
    ("Waypoint deployment", "Derrick deployment"),
    ("Waypoint deployments", "Derrick deployments"),
    ("Waypoint application", "Derrick application"),
    ("Waypoint applications", "Derrick applications"),
    ("Waypoint operations", "Derrick operations"),
    ("Waypoint operation", "Derrick operation"),
    ("Waypoint workspace", "Derrick workspace"),
    ("Waypoint workspaces", "Derrick workspaces"),
    ("Waypoint context", "Derrick context"),
    ("Waypoint contexts", "Derrick contexts"),
    ("Waypoint plugin", "Derrick plugin"),
    ("Waypoint plugins", "Derrick plugins"),
    ("Waypoint release", "Derrick release"),
    ("Waypoint install", "Derrick install"),
    ("Waypoint upgrade", "Derrick upgrade"),
    ("Waypoint users", "Derrick users"),
    ("Waypoint user", "Derrick user"),
    ("Waypoint team", "Derrick team"),
    ("Waypoint teams", "Derrick teams"),
    ("Waypoint's", "Derrick's"),
    ("Waypoint", "Derrick"),
    ('"waypoint-docs"', '"derrick-docs"'),
    ("waypoint-docs", "derrick-docs"),
    ("PRODUCT=waypoint", "PRODUCT=derrick"),
    ("REPO=waypoint", "REPO=derrick"),
    ("PREVIEW_FROM_REPO=waypoint", "PREVIEW_FROM_REPO=derrick"),
]


def should_skip(path: Path) -> bool:
    return any(part in SKIP_PARTS for part in path.parts)


def collect_files() -> list[Path]:
    files: list[Path] = []
    for base in TARGET_DIRS:
        if not base.exists():
            continue
        for path in base.rglob("*"):
            if not path.is_file() or should_skip(path):
                continue
            if path.suffix.lower() in EXTENSIONS:
                files.append(path)
    return sorted(files)


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
        try:
            original = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        updated = transform(original)
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            changed += 1
    print(f"updated {changed} files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
