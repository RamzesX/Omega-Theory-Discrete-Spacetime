#!/usr/bin/env python3
"""Repo-wide markdown link validator.

Walks every .md file in the repo, extracts relative links to other .md files,
resolves each target relative to the source file's directory, and reports
every broken link.

Usage:
    python3 scripts/check_links.py [--root PATH] [--verbose]

Exit codes:
    0  no broken links
    1  at least one broken link detected
    2  internal error (bad CLI args / missing root)

Output format (TSV, one row per broken link):
    source_file<TAB>target<TAB>line_number<TAB>reason

Skips:
    .git, node_modules, .lake, dist, site/.astro, site/node_modules,
    site/dist, __pycache__, and the absolute-URL protocols http(s):/ /
    mailto:, #anchor-only links.

Part of the repo-wide navigation overhaul (plan: elegant-sauteeing-simon.md,
Phase G). Added 2026-04-21.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

SKIP_DIRS = {
    ".git", "node_modules", ".lake", "dist",
    "__pycache__", ".astro",
    # nested skip paths — matched as substrings
}

SKIP_PATH_SUBSTRINGS = [
    "/node_modules/", "/.lake/", "/.git/", "/__pycache__/",
    "/site/.astro/", "/site/dist/", "/site/node_modules/",
    "/dist/",
]

# Matches markdown link syntax ](target) where target ends in .md
# and may have an optional #anchor suffix.
#
# Not matched: http(s)://, mailto:, #-only anchors, and non-.md extensions.
LINK_RE = re.compile(r"\]\(([^)#\s]+\.md)(?:#[^)]*)?\)", re.UNICODE)


def should_skip_path(p: Path) -> bool:
    s = str(p).replace("\\", "/")
    for sub in SKIP_PATH_SUBSTRINGS:
        if sub in s:
            return True
    return False


def iter_markdown_files(root: Path):
    """Yield all .md files under root, honouring skip rules."""
    for p in root.rglob("*.md"):
        if should_skip_path(p):
            continue
        yield p


def extract_links(path: Path):
    """Yield (line_number, target_str) for every relative .md link."""
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError as e:
        print(f"# could not read {path}: {e}", file=sys.stderr)
        return
    for lineno, line in enumerate(text.splitlines(), start=1):
        for m in LINK_RE.finditer(line):
            target = m.group(1)
            # Skip absolute URLs (http(s), mailto, etc.) in case regex allowed them
            low = target.lower()
            if low.startswith(("http://", "https://", "mailto:", "ftp://")):
                continue
            yield lineno, target


def resolve_target(source: Path, target: str, root: Path) -> Path:
    """Resolve a link target relative to the source file's directory.

    Absolute (leading /) paths are interpreted as repo-root-relative.
    """
    if target.startswith("/"):
        return (root / target.lstrip("/")).resolve()
    return (source.parent / target).resolve()


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--root", default=".", help="Repo root (default: cwd)")
    ap.add_argument("--verbose", action="store_true",
                    help="Also print files checked + link counts")
    args = ap.parse_args()

    root = Path(args.root).resolve()
    if not root.is_dir():
        print(f"error: root is not a directory: {root}", file=sys.stderr)
        return 2

    n_files = 0
    n_links = 0
    broken = []  # list of (source, target, line, reason)

    for src in iter_markdown_files(root):
        n_files += 1
        for lineno, target in extract_links(src):
            n_links += 1
            try:
                resolved = resolve_target(src, target, root)
            except (OSError, ValueError) as e:
                broken.append((src, target, lineno, f"resolve error: {e}"))
                continue
            if not resolved.exists():
                # Report using a path relative to root if possible
                try:
                    src_rel = src.relative_to(root)
                except ValueError:
                    src_rel = src
                broken.append((src_rel, target, lineno, "target does not exist"))

    # Emit TSV
    if broken:
        print("source_file\ttarget\tline\treason")
        for src, tgt, ln, reason in broken:
            print(f"{src}\t{tgt}\t{ln}\t{reason}")

    if args.verbose:
        print(f"# checked {n_files} files, {n_links} relative-md links, "
              f"{len(broken)} broken", file=sys.stderr)

    return 1 if broken else 0


if __name__ == "__main__":
    sys.exit(main())
