#!/usr/bin/env python3
"""Waypoint → Derrick rename for CI/CD and release tooling."""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

TARGETS = [
    ROOT / "Makefile",
    ROOT / "Dockerfile",
    ROOT / "CRT.Dockerfile",
    ROOT / "hack/Dockerfile.evanphx",
    ROOT / "tools.Dockerfile",
    ROOT / ".github",
    ROOT / ".release",
    ROOT / "test-e2e",
    ROOT / "tools/gendocs",
]

SKIP_PARTS = {"node_modules", ".git"}
EXTENSIONS = {
    ".yml", ".yaml", ".sh", ".nix", ".hcl", ".go", ".md", ".Dockerfile",
    "Dockerfile", ".evanphx", ".toml",
}

PROTECT = [
    ("hashicorp/waypoint-hzn", "___WAYPOINT_HZN___"),
    ("hashicorp/waypoint-helm", "___WAYPOINT_HELM___"),
    ("waypoint.hashicorp.com", "___WAYPOINT_HASHICORP___"),
    ("api.waypoint.run", "___API_WAYPOINT___"),
    ("waypoint-examples", "___WAYPOINT_EXAMPLES___"),
    ("circleci/waypoint", "___CIRCLECI_WAYPOINT___"),
    ("action-setup-waypoint", "___ACTION_SETUP_WAYPOINT___"),
    ("action-waypoint", "___ACTION_WAYPOINT___"),
    ("waypoint-images", "___WAYPOINT_IMAGES___"),
]

REPLACEMENTS = [
    ("build-waypoint-oss.yml", "build-derrick-oss.yml"),
    ("waypoint-entrypoint-release-metadata.hcl", "derrick-entrypoint-release-metadata.hcl"),
    ("waypoint-release-metadata.hcl", "derrick-release-metadata.hcl"),
    ("github.com/hashicorp/waypoint/test-e2e", "github.com/nomatronio/derrick/test-e2e"),
    ("github.com/hashicorp/waypoint", "github.com/nomatronio/derrick"),
    ("ghcr.io/hashicorp/waypoint", "ghcr.io/nomatronio/derrick"),
    ("public.ecr.aws/hashicorp/waypoint", "public.ecr.aws/nomatronio/derrick"),
    ("docker.io/hashicorp/waypoint", "docker.io/nomatronio/derrick"),
    ("hub.docker.com/r/hashicorp/waypoint", "hub.docker.com/r/nomatronio/derrick"),
    ("gallery.ecr.aws/hashicorp/waypoint", "gallery.ecr.aws/nomatronio/derrick"),
    ("releases.hashicorp.com/waypoint", "github.com/nomatronio/derrick/releases"),
    ("hashicorp/waypoint-odr", "nomatronio/derrick-odr"),
    ("hashicorp/waypoint", "nomatronio/derrick"),
    ("WAYPOINT_GOOS", "DERRICK_GOOS"),
    ("WAYPOINT_GOARCH", "DERRICK_GOARCH"),
    ("WP_SERVERIMAGE_UPGRADE", "DERRICK_SERVERIMAGE_UPGRADE"),
    ("WP_ODRIMAGE_UPGRADE", "DERRICK_ODRIMAGE_UPGRADE"),
    ("WP_SERVERIMAGE", "DERRICK_SERVERIMAGE"),
    ("WP_ODRIMAGE", "DERRICK_ODRIMAGE"),
    ("WP_PROJECT_TEMPLATE_PATH", "DERRICK_PROJECT_TEMPLATE_PATH"),
    ("WP_EXAMPLES_PATH", "DERRICK_EXAMPLES_PATH"),
    ("WP_TESTE2E_DIR", "DERRICK_TESTE2E_DIR"),
    ("WP_BINARY", "DERRICK_BINARY"),
    ("WP_SERVER_PLATFORM", "DERRICK_SERVER_PLATFORM"),
    ("waypoint-version", "derrick-version"),
    ("waypoint-base-version", "derrick-base-version"),
    ("waypoint-prerelease", "derrick-prerelease"),
    ("waypoint-binary", "derrick-binary"),
    ("waypoint-tar", "derrick-tar"),
    ("waypoint-image", "derrick-image"),
    ("waypoint-odr-tar", "derrick-odr-tar"),
    ("waypoint-odr-image", "derrick-odr-image"),
    ("package-docker-waypoint-server", "package-docker-derrick-server"),
    ("package-docker-waypoint-odr", "package-docker-derrick-odr"),
    ("build-waypoint", "build-derrick"),
    ("push-waypoint-odr", "push-derrick-odr"),
    ("push-waypoint", "push-derrick"),
    ("install-waypoint", "install-derrick"),
    ("bin/crt-waypoint-entrypoint", "bin/crt-derrick-entrypoint"),
    ("bin/crt-waypoint", "bin/crt-derrick"),
    ("waypoint-entrypoint_", "derrick-entrypoint_"),
    ("waypoint_odr-crt", "derrick_odr-crt"),
    ("waypoint_crt_", "derrick_crt_"),
    ("waypoint_${", "derrick_${"),
    ("waypoint_", "derrick_"),
    ("waypoint-entrypoint", "derrick-entrypoint"),
    ("waypoint-odr:dev", "derrick-odr:dev"),
    ("waypoint-odr:", "derrick-odr:"),
    ("waypoint:dev", "derrick:dev"),
    ("/kaniko/waypoint", "/kaniko/derrick"),
    ("/usr/bin/waypoint-entrypoint", "/usr/bin/derrick-entrypoint"),
    ("/usr/bin/waypoint", "/usr/bin/derrick"),
    ("COPY waypoint ", "COPY derrick "),
    ("COPY waypoint-entrypoint", "COPY derrick-entrypoint"),
    ("/tmp/wp-src/waypoint", "/tmp/wp-src/derrick"),
    ("/tmp/wp-src/waypoint-entrypoint", "/tmp/wp-src/derrick-entrypoint"),
    ("addgroup waypoint", "addgroup derrick"),
    ("-G waypoint waypoint", "-G derrick derrick"),
    ("chown -R waypoint:waypoint", "chown -R derrick:derrick"),
    ("chown -R waypoint ", "chown -R derrick "),
    ("/home/waypoint", "/home/derrick"),
    ("USER waypoint", "USER derrick"),
    ("ENV USER waypoint", "ENV USER derrick"),
    ("echo waypoint:", "echo derrick:"),
    ("-v `pwd`:/waypoint", "-v `pwd`:/derrick"),
    ("POSTGRES_DB: waypoint_test", "POSTGRES_DB: derrick_test"),
    ("waypoint-restore.db", "derrick-restore.db"),
    ("waypoint version", "derrick version"),
    ('["waypoint", "cli-docs"]', '["derrick", "cli-docs"]'),
    ('["waypoint", "derrick-entrypoint"]', '["derrick", "derrick-entrypoint"]'),
    ('pkg-name: [ "waypoint"', 'pkg-name: [ "derrick"'),
    ('dist/$TARGETOS/$TARGETARCH/waypoint', 'dist/$TARGETOS/$TARGETARCH/derrick'),
    ('WORKDIR /waypoint', 'WORKDIR /derrick'),
    ('docker.io/hashicorp/${{env.repo}}', 'docker.io/nomatronio/${{env.repo}}'),
    ('public.ecr.aws/hashicorp/${{env.repo}}', 'public.ecr.aws/nomatronio/${{env.repo}}'),
    ('waypoint/hashicorp/', 'derrick/nomatronio/'),
    ('waypoint install', 'derrick install'),
    ('path/to/waypoint', 'path/to/derrick'),
    ('in place of `waypoint`', 'in place of `derrick`'),
    ('myusername/waypoint', 'myusername/derrick'),
    ('$TESTDIR/waypoint', '$TESTDIR/derrick'),
    ('./waypoint', './derrick'),
    ('Getenv("DERRICK_BINARY", "waypoint")', 'Getenv("DERRICK_BINARY", "derrick")'),
    ('# configure newuidmap/newgidmap to work with our waypoint user', '# configure newuidmap/newgidmap to work with our derrick user'),
    ('# bin/cli-only only recompiles waypoint', '# bin/cli-only only recompiles derrick'),
    ('pkg-name: "waypoint"', 'pkg-name: "derrick"'),
    ('PKG_NAME: "waypoint"', 'PKG_NAME: "derrick"'),
    ('repo: "waypoint"', 'repo: "derrick"'),
    ('repo-name: "waypoint"', 'repo-name: "derrick"'),
    ('cache-key=waypoint-ui', 'cache-key=derrick-ui'),
    ("go run ./cmd/waypoint", "go run ./cmd/derrick"),
    ("project \"waypoint\"", "project \"derrick\""),
    ('team = "waypoint"', 'team = "nomatron"'),
    ('repository = "waypoint"', 'repository = "derrick"'),
    ('organization = "hashicorp"', 'organization = "nomatronio"'),
    ("waypointproject.io", "derrick.dev"),
    ("HashiCorp Waypoint Team <waypoint@hashicorp.com>", "Nomatron Derrick Team <derrick@nomatron.io>"),
    ('LABEL name="Waypoint"', 'LABEL name="Derrick"'),
    ("ARG NAME=waypoint", "ARG NAME=derrick"),
    ('package-name == \'waypoint\'', "package-name == 'derrick'"),
    ("package-name == 'waypoint'", "package-name == 'derrick'"),
    ("# Creates the binaries for Waypoint", "# Creates the binaries for Derrick"),
    ("# Builds a Waypoint server", "# Builds a Derrick server"),
    ("# Builds a Waypoint on-demand", "# Builds a Derrick on-demand"),
    ("# Generates the changelog for Waypoint", "# Generates the changelog for Derrick"),
    ("# Build and copy binaries to $GOPATH/bin/waypoint", "# Build and copy binaries to $GOPATH/bin/derrick"),
    ("cp ./waypoint ", "cp ./derrick "),
    ("name: build_waypoint", "name: build_derrick"),
    ("Determine intended Waypoint version", "Determine intended Derrick version"),
    ("title=Waypoint Version", "title=Derrick Version"),
    ("Download Waypoint", "Download Derrick"),
    ("Tag and Push Waypoint ODR", "Tag and Push Derrick ODR"),
    ("Tag and Push Waypoint", "Tag and Push Derrick"),
    ("install waypoint binary", "install derrick binary"),
    ("mv waypoint ", "mv derrick "),
    ("bin/waypoint", "bin/derrick"),
    ("Make waypoint binary", "Make derrick binary"),
    ("waypoint.tar", "derrick.tar"),
    ("initializing waypoint project", "initializing derrick project"),
    ("deploying waypoint project", "deploying derrick project"),
    ("destroying waypoint project", "destroying derrick project"),
    ("uninstalling waypoint server", "uninstalling derrick server"),
    ("Testing waypoint is available", "Testing derrick is available"),
    ("Building waypoint binary", "Building derrick binary"),
    ("# Contributing to Waypoint", "# Contributing to Derrick"),
    ("Contributing to Waypoint", "Contributing to Derrick"),
    ("Waypoint's security", "Derrick's security"),
    ("issue in Waypoint", "issue in Derrick"),
    ("Building Waypoint", "Building Derrick"),
    ("work on Waypoint", "work on Derrick"),
    ("Making Changes to Waypoint", "Making Changes to Derrick"),
    ("fork Waypoint", "fork Derrick"),
    ("waypoint-core", "derrick-core"),
    ("waypoint-frontend", "derrick-frontend"),
    ("waypoint-ecosystem", "derrick-ecosystem"),
    ("discuss.hashicorp.com/c/waypoint", "github.com/nomatronio/derrick/discussions"),
    ("waypoint.hcl", "derrick.hcl"),
    ("Waypoint CLI Version", "Derrick CLI Version"),
    ("Waypoint Server Platform", "Derrick Server Platform"),
    ("Waypoint Plugin", "Derrick Plugin"),
    ("Waypoint Platform Versions", "Derrick Platform Versions"),
    ("Waypoint uses", "Derrick uses"),
    ("Waypoint maintainer", "Derrick maintainer"),
    ("Waypoint configuration", "Derrick configuration"),
    ("Running `waypoint`", "Running `derrick`"),
    ("the Waypoint project", "the Derrick project"),
    ("a waypoint server", "a derrick server"),
    ("waypoint server", "derrick server"),
    ("waypoint project", "derrick project"),
    ("waypoint binary", "derrick binary"),
    ("waypoint commands", "derrick commands"),
    ("Default: \"waypoint\"", 'Default: "derrick"'),
    ('Getenv("WP_BINARY", "waypoint")', 'Getenv("DERRICK_BINARY", "derrick")'),
    ("vendor=\"HashiCorp\"", "vendor=\"Nomatron\""),
    ("maintainer: \"HashiCorp\"", "maintainer: \"Nomatron\""),
    ("Waypoint", "Derrick"),
]


def should_process(path: Path) -> bool:
    if any(p in SKIP_PARTS for p in path.parts):
        return False
    if path.name in EXTENSIONS or path.suffix in EXTENSIONS:
        return True
    if path.name == "Makefile":
        return True
    return False


def collect_files() -> list[Path]:
    files: list[Path] = []
    for base in TARGETS:
        if base.is_file():
            files.append(base)
        elif base.is_dir():
            for path in base.rglob("*"):
                if path.is_file() and should_process(path):
                    files.append(path)
    return sorted(set(files))


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
    return unprotect(text)


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
            print(f"updated {path.relative_to(ROOT)}")
    print(f"done: {changed} files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
