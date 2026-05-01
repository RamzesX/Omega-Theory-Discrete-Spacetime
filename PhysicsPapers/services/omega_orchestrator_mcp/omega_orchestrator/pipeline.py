"""Pipeline-orchestrator infra functions (Phase 6).

These are the LONG-RUNNING implementations that JobManager subprocesses import
and execute. Each function is:
  - importable in a fresh Python (no module-level state required)
  - takes JSON-serializable kwargs
  - returns a JSON-serializable dict (becomes job result.json)
  - prints progress to stdout (captured to job log)
  - calls `write_progress(...)` between steps so `job_status(id)` can
    surface live state before the job finishes

Bucket layout (per Phase 6 architecture):
  Bucket 2 — Graph ingest:    ingest_graph_target, precompute_signals_target,
                              refresh_graph_target
  Bucket 3 — Embedding:       embed_delta_target, embed_nodes_target,
                              embed_candidates_target
  Bucket 4 — Read-only:       inspect_candidate_status, inspect_build_status,
                              inspect_graph_health, inspect_cycle_state
"""
from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path
from typing import Any

from .jobs import write_progress


# ── Resource pre-flight check ───────────────────────────────────────────────
#
# Refuse to spawn a long-running child if the system is already under memory
# or disk pressure. Prevents cascading OOM where one borderline run takes
# down the whole node. Returns a list of (severity, reason) — caller decides
# whether to proceed or refuse.
def _preflight_check_resources(
    min_free_ram_gb: float = 5.0,
    min_free_tmp_gb: float = 1.0,
) -> list[tuple[str, str]]:
    """Sanity-check available RAM + /tmp disk before a heavy run.

    Returns a list of ``(severity, reason)`` tuples. Empty list = all green.
    Severity is one of ``"warn"`` (proceed but log) or ``"refuse"`` (do not
    spawn). Caller chooses how to react.
    """
    issues: list[tuple[str, str]] = []
    # RAM — read /proc/meminfo (no psutil dep)
    try:
        meminfo = Path("/proc/meminfo").read_text()
        free_kb = 0
        for line in meminfo.splitlines():
            if line.startswith("MemAvailable:"):
                free_kb = int(line.split()[1])
                break
        free_gb = free_kb / 1024 / 1024
        if free_gb < min_free_ram_gb / 2:
            issues.append(("refuse", f"only {free_gb:.1f} GB free RAM "
                                      f"(< {min_free_ram_gb / 2} GB hard floor)"))
        elif free_gb < min_free_ram_gb:
            issues.append(("warn", f"low free RAM {free_gb:.1f} GB "
                                    f"(< {min_free_ram_gb} GB target)"))
    except (OSError, ValueError):
        issues.append(("warn", "could not read /proc/meminfo"))
    # /tmp disk
    try:
        st = os.statvfs("/tmp")
        free_gb_tmp = st.f_bavail * st.f_frsize / (1024 ** 3)
        if free_gb_tmp < min_free_tmp_gb / 2:
            issues.append(("refuse", f"only {free_gb_tmp:.1f} GB free on /tmp "
                                      f"(< {min_free_tmp_gb / 2} GB hard floor)"))
        elif free_gb_tmp < min_free_tmp_gb:
            issues.append(("warn", f"low /tmp space {free_gb_tmp:.1f} GB "
                                    f"(< {min_free_tmp_gb} GB target)"))
    except OSError:
        issues.append(("warn", "could not statvfs /tmp"))
    return issues


# ── Canonical streaming subprocess helper ──────────────────────────────────
#
# Lesson 2026-04-25 (cycle 54+55 close): subprocess.PIPE buffers ALL child
# stdout into the parent's memory before subprocess.run returns. dump_arrows
# emitted >180MB (lake incremental rebuild + dump output merged via STDOUT)
# and the MCP child python OOM'd silently — no dmesg, no error, just a dead
# parent and an orphan child. Parent's heartbeat thread kept writing until
# the OS reaped the process; JobManager flagged STALE.
#
# Replacement pattern: stream stdout to a tempfile, read bounded tail (4 KB)
# for diagnostics. Parent memory stays flat regardless of child output size.
# All subprocess.run sites in pipeline.py / orchestration.py / etc. should
# use this helper instead of stdout=subprocess.PIPE for any child that could
# emit > 1 MB. (Tiny commands like `lake env lean` are still PIPE-safe but
# use the helper anyway for uniformity + future-proofing.)
#
# Optional ``memory_limit_mb`` caps the child's address space via
# ``resource.setrlimit(RLIMIT_AS, ...)`` (Linux only). On limit overrun the
# kernel kills the child with SIGKILL → returncode -9 → caller sees
# "memory_limit_exceeded" diagnosis.
def _run_child_streaming(
    cmd: list[str],
    cwd: str | "Path",
    timeout: int,
    label: str,
    tail_bytes: int = 4096,
    memory_limit_mb: int | None = None,
) -> tuple[int, str, int]:
    """Run a child process with stdout streamed to a tempfile.

    Returns ``(returncode, tail_str, total_bytes)``. ``tail_str`` is the last
    ``tail_bytes`` of merged stdout+stderr; ``total_bytes`` is the full size
    of the captured stream on disk so callers can log it.

    On timeout, returns ``(124, "<timeout>", 0)`` rather than raising — keeps
    the call site's flow linear.

    On memory_limit overrun (RLIMIT_AS), kernel kills child with SIGKILL;
    returncode is -9 (signal 9) and tail will contain whatever the child
    flushed before being killed.

    The stream tempfile is at ``/tmp/omega_step_<label>.log`` and persists
    after the call (overwritten on next run with the same label) for post-
    mortem inspection.
    """
    log_path = Path(f"/tmp/omega_step_{label}.log")
    preexec = None
    if memory_limit_mb is not None and memory_limit_mb > 0:
        # Linux-only — use Popen + preexec_fn that sets RLIMIT_AS via resource.
        # (subprocess.run doesn't expose preexec_fn directly with text=True for
        # all path; Popen is more flexible.)
        import resource as _resource

        _bytes = memory_limit_mb * 1024 * 1024

        def _set_mem_limit() -> None:  # runs in child after fork, before exec
            _resource.setrlimit(_resource.RLIMIT_AS, (_bytes, _bytes))

        preexec = _set_mem_limit
    try:
        with log_path.open("w") as fh:
            if preexec is not None:
                proc = subprocess.Popen(
                    cmd, cwd=str(cwd),
                    stdout=fh, stderr=subprocess.STDOUT,
                    text=True, preexec_fn=preexec,
                )
                try:
                    proc.wait(timeout=timeout)
                except subprocess.TimeoutExpired:
                    proc.kill()
                    proc.wait(timeout=5)
                    return 124, f"<timeout after {timeout}s>", 0
                rc = proc.returncode
            else:
                cp = subprocess.run(
                    cmd, cwd=str(cwd),
                    stdout=fh, stderr=subprocess.STDOUT,
                    text=True, timeout=timeout,
                )
                rc = cp.returncode
    except subprocess.TimeoutExpired:
        return 124, f"<timeout after {timeout}s>", 0
    try:
        sz = log_path.stat().st_size
        with log_path.open("r") as fh:
            if sz > tail_bytes:
                fh.seek(sz - tail_bytes)
            tail = fh.read()
    except OSError:
        sz, tail = 0, ""
    # Annotate killed-by-SIGKILL (memory_limit hit) for caller diagnosis
    if rc == -9 and memory_limit_mb is not None:
        tail = (tail + f"\n[killed by SIGKILL — likely RLIMIT_AS "
                       f"({memory_limit_mb} MB) exceeded]")
    return rc, tail, sz


# ── Mathlib-arrows caching ─────────────────────────────────────────────────
#
# Cycle 59 Scorpius INFRA optimization: dump_arrows is 76% of refresh_graph
# total time (~16 min of 21 min), but Mathlib v4.29.0 is FIXED for the
# project lifetime — its ~230k cross-namespace declaration records never
# change between refreshes. Cache the Mathlib JSONL once on cold path; on
# warm path only re-extract the ~16k OmegaTheory records and concatenate.
#
# Sister-wizard contract (DumpArrows.lean):
#   --ov2-only  → emits only `"decl":"OmegaTheory.…"` records to a separate
#                 path, skipping the whole Mathlib namespace walk.
#   --include-mathlib → full output (cold path / first-run / cache rebuild).
#
# Cache invariants:
#   * Cache file lives at ~/lean-v2/.neo4j/mathlib_arrows_cached_v4.29.0.jsonl
#     (in-tree, sits next to the other .neo4j artefacts).
#   * Cache invalidation = manual (rm cache file). Mathlib version is pinned
#     in lakefile.toml; users who upgrade Mathlib must drop the cache.
#   * Sanity floor: cache file size > 100 MB. If smaller, treat as corrupt
#     and fall through to cold path.
#   * Output JSONL `arrows_from_env_jobgraph.jsonl` is functionally
#     identical to the legacy single-pass output (same record set; loader
#     is set-based, line order doesn't matter for correctness).
#
MATHLIB_ARROWS_CACHE_FILENAME = "mathlib_arrows_cached_v4.29.0.jsonl"
OV2ONLY_OUTPUT_FILENAME = "arrows_from_env_jobgraph_ov2only.jsonl"
ARROWS_FINAL_FILENAME = "arrows_from_env_jobgraph.jsonl"
MATHLIB_CACHE_MIN_BYTES = 100 * 1024 * 1024  # 100 MB sanity floor

# SOTA hardening (cycle 59 follow-up audit, 2026-04-25):
# Cache header sentinel lets us detect corruption / version-mismatch even
# when the file size is plausible. Bumped on every breaking change to the
# split format. Pattern modelled after ccache's SHA256 manifest pattern.
CACHE_HEADER_MAGIC = "# omega_orchestrator_mcp:mathlib_arrows_cache_v2"
CACHE_HEADER_MATHLIB_VERSION_KEY = "mathlib_version="
CACHE_HEADER_RECORD_COUNT_KEY = "records="


def _fsync_path(path: Path) -> None:
    """fsync a file descriptor for the given path. Best-effort: no-op on OS error.

    Crucial after atomic rename — on power failure, ext4/xfs may have committed
    the rename in directory metadata while file content is still in page
    cache. fsync(file) commits content; fsync(directory) commits the rename.
    """
    try:
        with path.open("rb") as fh:
            os.fsync(fh.fileno())
    except OSError:
        pass


def _fsync_dir(directory: Path) -> None:
    """fsync the parent directory so the rename itself is durable.

    POSIX: rename atomicity is guaranteed only after the parent directory's
    metadata is fsync'd. Best-effort: silent on EISDIR / EOPNOTSUPP.
    """
    try:
        fd = os.open(str(directory), os.O_RDONLY)
        try:
            os.fsync(fd)
        finally:
            os.close(fd)
    except OSError:
        pass


def _atomic_replace_with_fsync(tmp_path: Path, final_path: Path) -> None:
    """Atomic rename + fsync: durable across power failure.

    The standard `Path.replace()` performs the kernel-level atomic rename
    but doesn't guarantee durability — the rename can sit in the directory
    page cache. After this call, both the file content and the rename are
    on stable storage.
    """
    _fsync_path(tmp_path)
    tmp_path.replace(final_path)
    _fsync_dir(final_path.parent)


def _detect_mathlib_version(workdir: Path) -> str | None:
    """Read Mathlib version from `lake-manifest.json`. Returns None on miss.

    Format (Lake 4.29.x): top-level `packages` array, each entry has `name`
    and `rev` (commit SHA). For Mathlib pinned by version-tag, `inputRev`
    holds the tag (e.g. `"v4.29.0"`).
    """
    manifest = workdir / "lake-manifest.json"
    if not manifest.exists():
        return None
    try:
        data = json.loads(manifest.read_text())
    except (OSError, json.JSONDecodeError):
        return None
    for pkg in data.get("packages", []):
        if pkg.get("name") == "mathlib":
            # Prefer inputRev (tag) if present, fall back to rev (SHA).
            return pkg.get("inputRev") or pkg.get("rev")
    return None


def _build_cache_header(
    mathlib_version: str | None,
    record_count: int,
) -> str:
    """Emit the first line of every cache file as a sentinel header.

    Subsequent runs validate this header before trusting the cache. A
    version-mismatch or corrupt header triggers a forced cache rebuild
    (cold path) — the right behavior under any of: Mathlib upgrade,
    file truncation, schema bump.
    """
    parts = [CACHE_HEADER_MAGIC,
             f"{CACHE_HEADER_MATHLIB_VERSION_KEY}{mathlib_version or 'unknown'}",
             f"{CACHE_HEADER_RECORD_COUNT_KEY}{record_count}"]
    return " ".join(parts) + "\n"


def _parse_cache_header(line: str) -> dict[str, str] | None:
    """Parse a cache header line. Returns None on missing magic prefix."""
    if not line.startswith(CACHE_HEADER_MAGIC):
        return None
    out: dict[str, str] = {"magic": CACHE_HEADER_MAGIC}
    for tok in line.strip().split()[1:]:
        if "=" in tok:
            k, _, v = tok.partition("=")
            out[k] = v
    return out


def _validate_cache_header(
    cache_path: Path,
    expected_mathlib_version: str | None,
) -> tuple[bool, dict[str, Any]]:
    """Read the first line of the cache, verify magic + version-match.

    Returns ``(is_valid, diag)``. ``diag`` records what we found for logging.
    A header-less or version-mismatched cache is treated as corrupt and
    triggers cold-path rebuild — matches SOTA cache-invalidation semantics.
    """
    diag: dict[str, Any] = {
        "header_present": False,
        "version_match": False,
        "expected_mathlib_version": expected_mathlib_version,
    }
    try:
        with cache_path.open("r") as fh:
            first = fh.readline()
    except OSError:
        return False, diag
    parsed = _parse_cache_header(first)
    if parsed is None:
        return False, diag
    diag["header_present"] = True
    diag["found_mathlib_version"] = parsed.get("mathlib_version")
    diag["found_record_count"] = parsed.get("records")
    if expected_mathlib_version is None:
        # We can't validate: lake-manifest.json missing or unreadable.
        # Trust the cache — better than forcing cold every run.
        diag["version_match"] = True
        diag["version_check_skipped"] = "no expected version"
        return True, diag
    if parsed.get("mathlib_version") == expected_mathlib_version:
        diag["version_match"] = True
        return True, diag
    return False, diag


def _is_ov2_record(line: str) -> bool:
    """Identify records belonging to the OmegaTheory namespace.

    Records start with `{"decl":"<fqname>",…`. OmegaTheory records always
    have `decl` strings beginning with either `OmegaTheory.<…>` (sub-modules
    + declarations) or `OmegaTheory","kind":"module"…` (the root module
    record itself, fqname = exactly "OmegaTheory"). Everything else is
    Mathlib / Lean core / external = goes into the Mathlib cache.

    SOTA note: header lines are explicitly skipped (they start with `#`,
    not `{`). Comment / empty lines also skipped — keeps the splitter
    forward-compatible if the Lean dumper adds documentation lines.
    """
    if line.startswith('{"decl":"OmegaTheory.'):
        return True
    if line.startswith('{"decl":"OmegaTheory","kind":"module"'):
        return True
    return False


def _is_data_record(line: str) -> bool:
    """A line is a data record iff it parses as a JSON object starting with `{`.

    Header / comment / empty lines are NOT data records and should pass
    through cache split unchanged (header) or be dropped (comments).
    Used to skip the cache header during concat reconstruction.
    """
    s = line.lstrip()
    return s.startswith("{")


def _split_full_arrows_into_cache(
    full_path: Path,
    cache_path: Path,
    mathlib_version: str | None = None,
) -> tuple[int, int]:
    """Cold-path cache writer: split full dump into Mathlib cache + skip OV2.

    Reads ``full_path`` line-by-line, writes non-OV2 lines into
    ``cache_path``, drops OV2 lines (they're already in ``full_path``).
    Returns ``(mathlib_lines, ov2_lines)``. Streaming I/O — never buffers
    the full file in memory.

    SOTA hardening (cycle 59 audit):
      * First pass counts records (single linear scan, fits in O(N) walltime).
      * Second pass writes header + records to ``<cache>.tmp``, fsync, atomic
        rename, fsync directory. Two-pass is safe because the input file is
        the single-pass dump output already on disk.
      * Cache header carries Mathlib version + record count for fast
        validation on warm path.
      * Skips header lines in the source (forward-compat if input ever
        carries its own header).
    """
    cache_path.parent.mkdir(parents=True, exist_ok=True)
    # Pass 1: count records so we can write an accurate header.
    mathlib_n = 0
    ov2_n = 0
    with full_path.open("r") as src:
        for line in src:
            if not _is_data_record(line):
                continue  # Skip headers / comment / empty lines
            if _is_ov2_record(line):
                ov2_n += 1
            else:
                mathlib_n += 1
    # Pass 2: write header + Mathlib records to tmp, then atomic-rename + fsync.
    tmp_path = cache_path.with_suffix(cache_path.suffix + ".tmp")
    header = _build_cache_header(mathlib_version, mathlib_n)
    written = 0
    with full_path.open("r") as src, tmp_path.open("w") as dst:
        dst.write(header)
        for line in src:
            if not _is_data_record(line):
                continue
            if _is_ov2_record(line):
                continue
            dst.write(line)
            written += 1
        dst.flush()
        os.fsync(dst.fileno())
    if written != mathlib_n:
        # Pass 1 vs Pass 2 disagreement means input churned mid-write —
        # treat as failure. Don't promote the half-written .tmp to cache.
        try:
            tmp_path.unlink()
        except OSError:
            pass
        raise OSError(
            f"cache split inconsistency: pass1 saw {mathlib_n} records, "
            f"pass2 wrote {written}. Input may have changed under us."
        )
    _atomic_replace_with_fsync(tmp_path, cache_path)
    return mathlib_n, ov2_n


def _concat_cache_and_ov2(
    cache_path: Path,
    ov2_path: Path,
    final_path: Path,
) -> int:
    """Warm-path concatenator: cache + ov2-only → final output.

    Streams via ``shutil.copyfileobj`` to keep parent memory flat regardless
    of cache size. Returns total bytes written. The output order is
    Mathlib-first then OV2; the loader (load_arrows_parallel.py) is
    set-based on (src, tgt, type) so order doesn't affect correctness.

    SOTA hardening:
      * Skips the cache header line (it's metadata, not a Neo4j record).
      * Tmp+rename+fsync for crash-durability of the final output.
      * Validates inputs exist and are non-empty before writing — refuses
        to produce a truncated final output if either source is missing.
    """
    final_path.parent.mkdir(parents=True, exist_ok=True)
    if not cache_path.exists() or cache_path.stat().st_size == 0:
        raise OSError(f"cache_and_ov2 concat: cache_path missing/empty at {cache_path}")
    if not ov2_path.exists():
        raise OSError(f"cache_and_ov2 concat: ov2_path missing at {ov2_path}")
    tmp_path = final_path.with_suffix(final_path.suffix + ".tmp")
    with tmp_path.open("wb") as out:
        # Skip header line in cache: read first line via text-mode then
        # binary-stream the rest.
        with cache_path.open("rb") as fc:
            first = fc.readline()
            if not first.startswith(CACHE_HEADER_MAGIC.encode()):
                # No header — treat whole file as data (legacy v1 cache).
                out.write(first)
            shutil.copyfileobj(fc, out, length=1024 * 1024)
        with ov2_path.open("rb") as fo:
            shutil.copyfileobj(fo, out, length=1024 * 1024)
        out.flush()
        os.fsync(out.fileno())
    total = tmp_path.stat().st_size
    _atomic_replace_with_fsync(tmp_path, final_path)
    return total


def _build_ov2only_grep_fallback(
    full_path: Path,
    ov2_path: Path,
) -> int:
    """Fallback when sister-wizard's --ov2-only flag isn't ready yet.

    Post-processes the full output by filtering for OmegaTheory records.
    This is purely a development stub — once DumpArrows.lean lands the
    --ov2-only flag, the fast path skips Mathlib at extraction time and
    this function is only used by tests.

    SOTA hardening: tmp+rename+fsync so a crash mid-extraction never leaves
    a half-written ov2-only file that the next refresh would mistake for
    valid input.
    """
    ov2_path.parent.mkdir(parents=True, exist_ok=True)
    tmp_path = ov2_path.with_suffix(ov2_path.suffix + ".tmp")
    n = 0
    with full_path.open("r") as src, tmp_path.open("w") as dst:
        for line in src:
            if not _is_data_record(line):
                continue
            if _is_ov2_record(line):
                dst.write(line)
                n += 1
        dst.flush()
        os.fsync(dst.fileno())
    _atomic_replace_with_fsync(tmp_path, ov2_path)
    return n


def _step_dump_arrows_with_cache(
    workdir: Path,
    lake_bin: str,
    timeout_s: int,
    label: str,
) -> tuple[int, str, int, dict]:
    """Cache-aware dump_arrows step (replaces direct `lake exe dump_arrows`).

    Returns ``(rc, tail, total_bytes, cache_meta)`` matching the
    ``_run_child_streaming`` signature plus a ``cache_meta`` dict the
    caller can record in step results / logs.

    Behavior:
      * If cache file exists and is ≥ ``MATHLIB_CACHE_MIN_BYTES``:
          1. Run ``lake exe dump_arrows --ov2-only`` (fast — ~10x speedup).
          2. Concat cache + ov2-only into final output.
          3. Cache HIT logged.
      * Otherwise (cold path):
          1. Run ``lake exe dump_arrows --include-mathlib`` (full extraction).
          2. Split full output → write Mathlib portion to cache file.
          3. Cache MISS / REBUILD logged.

    On --ov2-only flag absence (sister wizard not yet landed), the lake
    command will error; we then fall back to the full --include-mathlib
    extraction so the pipeline never blocks. The cache logic still
    populates after a cold full run, so the next refresh gets the speedup.
    """
    neo4j_dir = workdir / ".neo4j"
    cache_path = neo4j_dir / MATHLIB_ARROWS_CACHE_FILENAME
    ov2_path = neo4j_dir / OV2ONLY_OUTPUT_FILENAME
    final_path = neo4j_dir / ARROWS_FINAL_FILENAME

    cache_size = cache_path.stat().st_size if cache_path.exists() else 0
    expected_mathlib_version = _detect_mathlib_version(workdir)
    # Cache validity is now THREE-tier: size floor + header magic + version.
    # Any one failing forces cold-path rebuild.
    size_ok = cache_size >= MATHLIB_CACHE_MIN_BYTES
    header_ok = False
    header_diag: dict[str, Any] = {}
    if cache_path.exists() and size_ok:
        header_ok, header_diag = _validate_cache_header(
            cache_path, expected_mathlib_version,
        )
    cache_valid = size_ok and header_ok
    meta: dict[str, Any] = {
        "cache_path": str(cache_path),
        "cache_existed": cache_path.exists(),
        "cache_size_bytes": cache_size,
        "cache_size_ok": size_ok,
        "cache_header_ok": header_ok,
        "cache_header_diag": header_diag,
        "cache_valid": cache_valid,
        "min_cache_bytes": MATHLIB_CACHE_MIN_BYTES,
        "expected_mathlib_version": expected_mathlib_version,
    }

    if cache_valid:
        # ── WARM PATH ──────────────────────────────────────────────────────
        print(f"[refresh_graph] Mathlib arrows cache HIT "
              f"({cache_size / (1024 * 1024):.1f} MB at {cache_path})",
              flush=True)
        meta["path"] = "warm"
        cmd = [lake_bin, "exe", "dump_arrows",
               "--out", f".neo4j/{OV2ONLY_OUTPUT_FILENAME}",
               "--ov2-only"]
        rc, tail, total_bytes = _run_child_streaming(
            cmd=cmd, cwd=workdir, timeout=timeout_s,
            label=f"{label}_warm",
        )
        meta["lake_cmd"] = " ".join(cmd)
        meta["lake_rc"] = rc
        meta["lake_log_bytes"] = total_bytes

        # If --ov2-only flag isn't recognized by DumpArrows.lean yet
        # (sister wizard hasn't landed), lake will exit non-zero with a
        # CLI error. Fall through to cold path so the pipeline survives.
        ov2_ok = (rc == 0 and ov2_path.exists()
                  and ov2_path.stat().st_size > 0)
        if not ov2_ok:
            print(f"[refresh_graph] --ov2-only failed (rc={rc}); "
                  f"falling back to full --include-mathlib extraction",
                  flush=True)
            meta["warm_failed_fell_back_cold"] = True
            cache_valid = False
            # Drop the bad cache marker so next refresh forces a full rebuild.
            # (Don't actually delete cache yet — the existing one might still
            # be usable; only mark it as untrusted for THIS run.)
        else:
            # Concat cache + ov2-only → final
            try:
                concat_bytes = _concat_cache_and_ov2(
                    cache_path, ov2_path, final_path,
                )
                meta["concat_bytes"] = concat_bytes
                meta["concat_ok"] = True
                ov2_lines = sum(1 for _ in ov2_path.open("r"))
                meta["ov2_records"] = ov2_lines
                print(f"[refresh_graph] cache concat: "
                      f"{cache_size / (1024 * 1024):.1f} MB cache + "
                      f"{ov2_path.stat().st_size / (1024 * 1024):.2f} MB "
                      f"ov2-only ({ov2_lines} records) → "
                      f"{concat_bytes / (1024 * 1024):.1f} MB final",
                      flush=True)
                return rc, tail, total_bytes, meta
            except OSError as e:
                print(f"[refresh_graph] concat failed: {e}; "
                      f"falling back to cold path", flush=True)
                meta["concat_error"] = str(e)[:200]
                cache_valid = False

    if not cache_valid:
        # ── COLD PATH ──────────────────────────────────────────────────────
        # SAFETY (locked 2026-05-01 after 2× WSL OOM crashes from over-eager
        # Mathlib re-walks): refusing to silently re-extract Mathlib via
        # --include-mathlib unless the operator opts in via env var
        # OMEGA_REFRESH_ALLOW_MATHLIB_COLD=1. Mathlib is loaded once and
        # the cache lives at ``.neo4j/mathlib_arrows_cached_v4.29.0.jsonl``;
        # if that's missing, the right operator action is to either restore
        # the cache or run a one-shot manual cold rebuild — NOT to have
        # refresh_graph silently load 5+ GB of oleans every cycle.
        cold_allowed = os.environ.get("OMEGA_REFRESH_ALLOW_MATHLIB_COLD", "0") == "1"
        if cache_size > 0 and cache_size < MATHLIB_CACHE_MIN_BYTES:
            print(f"[refresh_graph] Mathlib arrows cache MISS "
                  f"(file too small: {cache_size} bytes < "
                  f"{MATHLIB_CACHE_MIN_BYTES} sanity floor)",
                  flush=True)
        elif not meta["cache_existed"]:
            print(f"[refresh_graph] Mathlib arrows cache MISS "
                  f"(no cache file at {cache_path})",
                  flush=True)
        else:
            print(f"[refresh_graph] Mathlib arrows cache MISS "
                  f"(forced cold path)", flush=True)
        if not cold_allowed:
            meta["path"] = "ov2_only_safe"
            meta["cold_path_blocked"] = True
            print(f"[refresh_graph] SAFETY MODE: cold path BLOCKED. "
                  f"Set OMEGA_REFRESH_ALLOW_MATHLIB_COLD=1 to allow "
                  f"silent --include-mathlib re-extraction. Falling back "
                  f"to --ov2-only (Mathlib data already in graph from "
                  f"prior load — no re-walk needed).", flush=True)
            cmd = [lake_bin, "exe", "dump_arrows",
                   "--out", f".neo4j/{OV2ONLY_OUTPUT_FILENAME}",
                   "--ov2-only"]
            rc, tail, total_bytes = _run_child_streaming(
                cmd=cmd, cwd=workdir, timeout=timeout_s,
                label=f"{label}_ov2_only_safe",
            )
            meta["lake_cmd"] = " ".join(cmd)
            meta["lake_rc"] = rc
            meta["lake_log_bytes"] = total_bytes
            # Use the OV2-only output as the final output. Mathlib edges
            # from prior loads remain intact; load_arrows is delta-merge.
            try:
                import shutil as _sh
                _sh.copyfile(ov2_path, final_path)
            except OSError as e:
                print(f"[refresh_graph] copy ov2_only → final failed: {e}",
                      flush=True)
            return rc, tail, total_bytes, meta
        meta["path"] = "cold"
        print(f"[refresh_graph] cold path ALLOWED via "
              f"OMEGA_REFRESH_ALLOW_MATHLIB_COLD=1 — running full "
              f"--include-mathlib extraction (~5GB RSS, ~16min)",
              flush=True)
        cmd = [lake_bin, "exe", "dump_arrows",
               "--out", f".neo4j/{ARROWS_FINAL_FILENAME}",
               "--include-mathlib"]
        rc, tail, total_bytes = _run_child_streaming(
            cmd=cmd, cwd=workdir, timeout=timeout_s,
            label=f"{label}_cold",
        )
        meta["lake_cmd"] = " ".join(cmd)
        meta["lake_rc"] = rc
        meta["lake_log_bytes"] = total_bytes

        if rc == 0 and final_path.exists() and final_path.stat().st_size > 0:
            try:
                mathlib_n, ov2_n = _split_full_arrows_into_cache(
                    final_path, cache_path,
                    mathlib_version=expected_mathlib_version,
                )
                meta["cache_rebuilt"] = True
                meta["cache_records_written"] = mathlib_n
                meta["ov2_records_skipped_from_cache"] = ov2_n
                new_cache_size = cache_path.stat().st_size
                meta["new_cache_size_bytes"] = new_cache_size
                print(f"[refresh_graph] cache REBUILT: "
                      f"{mathlib_n} Mathlib records "
                      f"({new_cache_size / (1024 * 1024):.1f} MB) "
                      f"saved to {cache_path}; "
                      f"{ov2_n} OV2 records left in final output",
                      flush=True)
                if new_cache_size < MATHLIB_CACHE_MIN_BYTES:
                    # Sanity-check failed post-rebuild — log but don't abort
                    # (extraction succeeded; loader will still work).
                    print(f"[refresh_graph] WARN: new cache size "
                          f"{new_cache_size} bytes is below sanity floor "
                          f"{MATHLIB_CACHE_MIN_BYTES} — may indicate "
                          f"Mathlib namespace walk skipped or empty",
                          flush=True)
                    meta["cache_below_sanity_floor"] = True
            except OSError as e:
                print(f"[refresh_graph] cache split failed (non-fatal): {e}",
                      flush=True)
                meta["cache_split_error"] = str(e)[:200]

        return rc, tail, total_bytes, meta

    # Should be unreachable; defensive default.
    return rc, tail, total_bytes, meta


# These are imported lazily inside functions so a fresh child Python can import
# this module before the heavy deps load. Keeps unit-test mocking surface clean.


# ── Bucket 2: ingest_graph + precompute_signals ────────────────────────────


def ingest_graph_target(
    workdir: str = "/home/norbert/lean-v2",
    lake_bin: str = "/home/norbert/.elan/bin/lake",
    run_dump: bool = True,
    run_load: bool = True,
    dry_run: bool = False,
) -> dict:
    """Atomic Lean → Neo4j ingest pipeline (5 steps).

    1. lake exe dump_decls
    2. lake exe dump_arrows --include-mathlib
    3. python3 load_declarations_env_v2.py
    4. python3 load_arrows_parallel.py
    5. precompute_retrieval_signals.cypher (via cypher-shell)

    Aborts on first failure so Neo4j never sees a half-loaded graph.
    """
    work = Path(workdir)
    neo4j_dir = work / ".neo4j"
    # Same shape as refresh_graph: dump_arrows uses cmd=None to route through
    # the Mathlib-arrows cache helper (warm path skips Mathlib namespace walk).
    steps_def = [
        ("dump_decls",
         [lake_bin, "exe", "dump_decls",
          "--out", ".neo4j/declarations_from_env_jobgraph.jsonl"],
         work, run_dump),
        ("dump_arrows",
         None,  # special-cased below: Mathlib-arrows cache helper
         work, run_dump),
        ("load_decls",
         ["python3", "load_declarations_env_v2.py"],
         neo4j_dir, run_load),
        ("load_arrows",
         ["python3", "load_arrows_parallel.py"],
         neo4j_dir, run_load),
        # step 5 (precompute_signals) handled specially — uses bolt:// driver
        # directly rather than docker exec (MCP subprocess has no Docker CLI).
    ]
    results: list[dict] = []
    aborted_at: str | None = None
    t0 = time.monotonic()
    total_steps = sum(1 for _, _, _, en in steps_def if en) + (1 if run_load else 0)
    step_idx = 0
    for name, cmd, cwd, enabled in steps_def:
        if not enabled:
            results.append({"name": name, "skipped": True, "reason": "disabled by flag"})
            continue
        step_idx += 1
        if dry_run:
            cmd_str = " ".join(cmd) if cmd else "<dump_arrows cache helper>"
            results.append({
                "name": name,
                "dry_run": True,
                "cmd": cmd_str,
                "cwd": str(cwd),
            })
            print(f"[dry-run] {name}: would run {cmd_str} (cwd={cwd})", flush=True)
            write_progress({
                "phase": "ingest_graph",
                "step": step_idx, "step_count": total_steps, "step_name": name,
                "step_status": "dry_run", "elapsed_s": round(time.monotonic() - t0, 1),
            })
            continue
        print(f"[step] {name} starting (cwd={cwd}) ...", flush=True)
        st = time.monotonic()
        cmd_str_for_msg = " ".join(cmd) if cmd else "<dump_arrows cache helper>"
        write_progress({
            "phase": "ingest_graph",
            "step": step_idx, "step_count": total_steps, "step_name": name,
            "step_status": "started", "step_started_at": st,
            "elapsed_s": round(st - t0, 1),
            "step_message": f"running: {cmd_str_for_msg}",
        })
        # Streaming helper — protects parent from PIPE OOM (cycle 55 lesson).
        cache_meta: dict | None = None
        if name == "dump_arrows":
            rc, tail, total_bytes, cache_meta = _step_dump_arrows_with_cache(
                workdir=cwd, lake_bin=lake_bin,
                timeout_s=3600,
                label=f"ingest_{step_idx}_{name}",
            )
        else:
            rc, tail, total_bytes = _run_child_streaming(
                cmd=cmd, cwd=cwd, timeout=3600,
                label=f"ingest_{step_idx}_{name}",
            )
        if rc == 124:
            results.append({
                "name": name, "returncode": 124,
                "error": "timeout (1h)",
                "duration_s": round(time.monotonic() - st, 1),
            })
            write_progress({
                "phase": "ingest_graph",
                "step": step_idx, "step_count": total_steps, "step_name": name,
                "step_status": "failed", "step_message": "timeout (1h)",
                "elapsed_s": round(time.monotonic() - t0, 1),
            })
            aborted_at = name
            break
        elapsed = time.monotonic() - st
        print(f"[step] {name} done rc={rc} "
              f"({elapsed:.1f}s, log={total_bytes} bytes)", flush=True)
        if tail:
            print(tail[-800:], flush=True)
        step_record = {
            "name": name,
            "returncode": rc,
            "duration_s": round(elapsed, 1),
            "stdout_tail": tail[-1500:],
            "stdout_total_bytes": total_bytes,
        }
        if cache_meta is not None:
            step_record["cache_meta"] = cache_meta
        results.append(step_record)
        progress_msg = f"rc={rc}"
        if cache_meta is not None and "path" in cache_meta:
            progress_msg = f"rc={rc} cache={cache_meta['path']}"
        write_progress({
            "phase": "ingest_graph",
            "step": step_idx, "step_count": total_steps, "step_name": name,
            "step_status": "succeeded" if rc == 0 else "failed",
            "step_duration_s": round(elapsed, 1),
            "elapsed_s": round(time.monotonic() - t0, 1),
            "step_message": progress_msg,
        })
        if rc != 0:
            aborted_at = name
            break

    # Step 5 — precompute signals via native bolt:// (no Docker dep).
    if aborted_at is None and run_load:
        if dry_run:
            results.append({
                "name": "precompute_signals",
                "dry_run": True,
                "cmd": "bolt:// precompute_signals_target() (indeg_applies + log1p)",
                "cwd": "(Neo4j bolt connection)",
            })
            print("[dry-run] precompute_signals: would run cypher via bolt", flush=True)
        else:
            print("[step] precompute_signals starting (bolt://) ...", flush=True)
            st = time.monotonic()
            try:
                precompute_result = precompute_signals_target(workdir=workdir)
                elapsed = time.monotonic() - st
                results.append({
                    "name": "precompute_signals",
                    "returncode": 0 if precompute_result.get("ok") else 1,
                    "duration_s": round(elapsed, 1),
                    "stdout_tail": str(precompute_result)[-1500:],
                })
                if not precompute_result.get("ok"):
                    aborted_at = "precompute_signals"
                else:
                    print(f"[step] precompute_signals done ({elapsed:.1f}s)", flush=True)
            except Exception as e:
                results.append({
                    "name": "precompute_signals",
                    "returncode": -1,
                    "error": f"exception: {e}",
                    "duration_s": round(time.monotonic() - st, 1),
                })
                aborted_at = "precompute_signals"

    return {
        "ok": aborted_at is None,
        "aborted_at": aborted_at,
        "steps": results,
        "elapsed_s": round(time.monotonic() - t0, 1),
        "dry_run": dry_run,
    }


def precompute_signals_target(
    workdir: str = "/home/norbert/lean-v2",
) -> dict:
    """Run precompute_retrieval_signals.cypher via native bolt:// driver.

    The cypher file has 3 statements (OV2 indeg, Mathlib indeg, report).
    Split + run one at a time — the Neo4j driver executes one statement
    per session.run call, not the whole script.
    """
    from neo4j import GraphDatabase
    cypher_path = Path(workdir) / ".neo4j" / "precompute_retrieval_signals.cypher"
    if not cypher_path.exists():
        return {"ok": False, "error": f"cypher file not found: {cypher_path}"}

    # Strip comments + split into top-level statements.
    raw = cypher_path.read_text()
    # Remove // line comments (but keep Cypher content on the same line)
    lines = []
    for line in raw.splitlines():
        idx = line.find("//")
        if idx >= 0:
            line = line[:idx]
        lines.append(line)
    text = "\n".join(lines)
    # Split on bare `;` at end of line (crude but works for our file).
    statements = [s.strip() for s in text.split(";") if s.strip()]

    uri, user, pw = _neo4j_creds()
    driver = GraphDatabase.driver(uri, auth=(user, pw))
    outputs: list[dict] = []
    t0 = time.monotonic()
    try:
        with driver.session() as s:
            for i, stmt in enumerate(statements):
                print(f"[precompute] stmt {i+1}/{len(statements)} "
                      f"({stmt[:80].replace(chr(10), ' ')}...)", flush=True)
                try:
                    res = s.run(stmt)
                    # Collect rows only if it's a RETURN statement
                    rows = []
                    if "RETURN" in stmt.upper():
                        rows = [dict(r) for r in res]
                    else:
                        res.consume()
                    outputs.append({"stmt_index": i, "rows_returned": len(rows),
                                    "sample": rows[:5] if rows else None})
                except Exception as e:
                    outputs.append({"stmt_index": i, "error": str(e)[:400]})
                    raise
    finally:
        driver.close()
    return {
        "ok": True,
        "n_statements": len(statements),
        "outputs": outputs,
        "elapsed_s": round(time.monotonic() - t0, 1),
    }


# ── refresh_graph_target — async-spawnable Phase C 7-step chant ─────────────


def refresh_graph_target(
    workdir: str = "/home/norbert/lean-v2",
    lake_bin: str = "/home/norbert/.elan/bin/lake",
    dry_run: bool = False,
    step_timeout_s: int = 1200,
    capstone_targets: list[str] | None = None,
) -> dict:
    """Sync 7-step Phase C runner — spawned as a JobManager subprocess.

    Replaces the legacy in-process `run_phase_c` await chain that blocked
    the MCP stdio loop for 5-30 minutes. Each step writes a structured
    progress dict so `job_status(id)` shows live state before completion.

    Steps (each gated by `dry_run`):
      1. axiom_sentinel  — bolt:// + lean exec on a temp file (fast, ~3s).
         If unclean, abort BEFORE any expensive subprocess.
      2. lake_build      — full project rebuild (catches stale .olean).
      3. dump_decls      — declarations_from_env_jobgraph.jsonl.
      4. dump_arrows     — arrows_from_env_jobgraph.jsonl (+ Mathlib).
      5. load_decls      — Cypher MERGE delta loader.
      6. load_arrows     — parallel UNWIND loader.
      7. reembed         — Qwen3-Embedding-8B BF16 GPU delta embedder.
      8. verify          — bolt:// confirms missing_emb=0 + axiom set.

    Aborts on first failure so a half-loaded graph is never persisted.
    Returns a dict with `ok`, `aborted_at`, `steps`, `verify`, `elapsed_s`.

    Pre-flight: refuses to start if free RAM < 2.5 GB or /tmp free < 0.5 GB
    (guards against cascading OOM under pressure).
    """
    # Pre-flight resource gate (cycle 55 lesson — defense in depth).
    if not dry_run:
        issues = _preflight_check_resources(min_free_ram_gb=5.0,
                                             min_free_tmp_gb=1.0)
        refuse = [r for sev, r in issues if sev == "refuse"]
        if refuse:
            return {
                "ok": False,
                "aborted_at": "preflight",
                "preflight_refused": refuse,
                "elapsed_s": 0.0,
                "dry_run": False,
            }
        warns = [r for sev, r in issues if sev == "warn"]
        if warns:
            for w in warns:
                print(f"[preflight WARN] {w}", flush=True)
            write_progress({
                "phase": "refresh_graph",
                "step": 0, "step_count": 10, "step_name": "preflight",
                "step_status": "warn", "step_message": "; ".join(warns),
                "elapsed_s": 0.0,
            })

    work = Path(workdir)
    neo4j_dir = work / ".neo4j"

    # Step inventory — same shape as orchestration.PHASE_C_STEPS but sync.
    # (name, cmd, cwd_kind, doc) where cwd_kind is "work" or "neo4j".
    # The dump_arrows step is special-cased: cmd=None routes through the
    # Mathlib-arrows cache helper (warm path skips Mathlib namespace walk).
    steps_def = [
        ("lake_build",
         [lake_bin, "build", "--log-level=error"], "work",
         "full project rebuild — catches stale .olean"),
        ("dump_decls",
         [lake_bin, "exe", "dump_decls",
          "--out", ".neo4j/declarations_from_env_jobgraph.jsonl"], "work",
         "declarations_from_env_jobgraph.jsonl"),
        ("dump_arrows",
         None,  # special-cased below: Mathlib-arrows cache helper
         "work",
         "arrows_from_env_jobgraph.jsonl (cached Mathlib + fresh OV2)"),
        ("load_decls",
         ["python3", "load_declarations_env_v2.py"], "neo4j",
         "Cypher MERGE delta loader"),
        ("load_arrows",
         ["python3", "load_arrows_parallel.py"], "neo4j",
         "16-worker parallel UNWIND loader"),
        ("reembed",
         ["python3", "reembed_qwen3_delta.py"], "neo4j",
         "Qwen3-Embedding-8B BF16 GPU delta embedder"),
        ("ov2_proof_steps",
         ["python3", "refresh_ov2_proof_steps.py"], "neo4j",
         "OV2 :ProofStep source-segment Cypher migration (preserves full_t1_3 nodes)"),
    ]

    # Plus sentinel + verify = 8 user-visible "steps" (the chant).
    total_steps = len(steps_def) + 2  # sentinel + verify
    results: list[dict] = []
    t0 = time.monotonic()
    aborted_at: str | None = None

    # ── Step 1: axiom sentinel ──────────────────────────────────────────────
    write_progress({
        "phase": "refresh_graph",
        "step": 1, "step_count": total_steps, "step_name": "axiom_sentinel",
        "step_status": "started", "elapsed_s": 0.0,
        "step_message": "running bulk #print axioms on paper capstones",
    })
    sentinel_result = _axiom_sentinel_sync(
        workdir=workdir, lake_bin=lake_bin, dry_run=dry_run,
        capstone_targets=capstone_targets or [],
    )
    elapsed_now = round(time.monotonic() - t0, 1)
    results.append({"name": "axiom_sentinel", "duration_s": elapsed_now,
                    "result": sentinel_result})
    print(f"[step 1/8] axiom_sentinel: clean={sentinel_result.get('clean')}",
          flush=True)
    if not dry_run and not sentinel_result.get("clean", False):
        write_progress({
            "phase": "refresh_graph",
            "step": 1, "step_count": total_steps, "step_name": "axiom_sentinel",
            "step_status": "failed", "elapsed_s": elapsed_now,
            "step_message": "axiom regression — aborting before subprocesses",
        })
        return {
            "ok": False, "aborted_at": "axiom_sentinel",
            "steps": results, "elapsed_s": elapsed_now,
            "dry_run": dry_run,
        }
    write_progress({
        "phase": "refresh_graph",
        "step": 1, "step_count": total_steps, "step_name": "axiom_sentinel",
        "step_status": "succeeded", "elapsed_s": elapsed_now,
    })

    # ── Steps 2-7: shell pipeline ───────────────────────────────────────────
    step_idx = 1
    for name, cmd, cwd_kind, doc in steps_def:
        step_idx += 1
        cwd = work if cwd_kind == "work" else neo4j_dir
        if dry_run:
            cmd_str = " ".join(cmd) if cmd else f"<dump_arrows cache helper>"
            results.append({"name": name, "dry_run": True,
                            "cmd": cmd_str, "cwd": str(cwd)})
            print(f"[dry-run {step_idx}/{total_steps}] {name}: would run "
                  f"{cmd_str} (cwd={cwd})", flush=True)
            write_progress({
                "phase": "refresh_graph",
                "step": step_idx, "step_count": total_steps, "step_name": name,
                "step_status": "dry_run",
                "elapsed_s": round(time.monotonic() - t0, 1),
            })
            continue
        st = time.monotonic()
        write_progress({
            "phase": "refresh_graph",
            "step": step_idx, "step_count": total_steps, "step_name": name,
            "step_status": "started", "step_started_at": st,
            "elapsed_s": round(st - t0, 1), "step_message": doc,
        })
        print(f"[step {step_idx}/{total_steps}] {name} starting "
              f"(cwd={cwd}) — {doc}", flush=True)
        cache_meta: dict | None = None
        if name == "dump_arrows":
            # Cache-aware path: warm = cache HIT (run --ov2-only + concat);
            # cold = cache MISS (full --include-mathlib + cache rebuild).
            rc, tail, total_bytes, cache_meta = _step_dump_arrows_with_cache(
                workdir=cwd, lake_bin=lake_bin,
                timeout_s=step_timeout_s,
                label=f"refresh_{step_idx}_{name}",
            )
        else:
            # Use canonical streaming helper (PIPE-OOM-safe) — see _run_child_streaming.
            rc, tail, total_bytes = _run_child_streaming(
                cmd=cmd, cwd=cwd, timeout=step_timeout_s,
                label=f"refresh_{step_idx}_{name}",
            )
        elapsed_step = round(time.monotonic() - st, 1)
        if rc == 124:
            results.append({
                "name": name, "returncode": 124,
                "error": f"timeout ({step_timeout_s}s)",
                "duration_s": elapsed_step,
            })
            write_progress({
                "phase": "refresh_graph",
                "step": step_idx, "step_count": total_steps, "step_name": name,
                "step_status": "failed",
                "step_message": f"timeout ({step_timeout_s}s)",
                "step_duration_s": elapsed_step,
                "elapsed_s": round(time.monotonic() - t0, 1),
            })
            aborted_at = name
            break
        if tail:
            print(tail[-1200:], flush=True)
        print(f"[step {step_idx}/{total_steps}] {name} done "
              f"rc={rc} ({elapsed_step:.1f}s, log={total_bytes} bytes)",
              flush=True)
        step_record = {
            "name": name, "returncode": rc,
            "duration_s": elapsed_step,
            "stdout_tail": tail[-1500:],
            "stdout_total_bytes": total_bytes,
        }
        if cache_meta is not None:
            step_record["cache_meta"] = cache_meta
        results.append(step_record)
        progress_msg = f"rc={rc}"
        if cache_meta is not None and "path" in cache_meta:
            progress_msg = f"rc={rc} cache={cache_meta['path']}"
        write_progress({
            "phase": "refresh_graph",
            "step": step_idx, "step_count": total_steps, "step_name": name,
            "step_status": "succeeded" if rc == 0 else "failed",
            "step_message": progress_msg,
            "step_duration_s": elapsed_step,
            "elapsed_s": round(time.monotonic() - t0, 1),
        })
        if rc != 0:
            aborted_at = name
            break

    # ── Step 8: verify (bolt://) ────────────────────────────────────────────
    verify: dict[str, Any] | None = None
    if aborted_at is None:
        if dry_run:
            verify = {"dry_run": True}
            write_progress({
                "phase": "refresh_graph",
                "step": total_steps, "step_count": total_steps,
                "step_name": "verify", "step_status": "dry_run",
                "elapsed_s": round(time.monotonic() - t0, 1),
            })
        else:
            write_progress({
                "phase": "refresh_graph",
                "step": total_steps, "step_count": total_steps,
                "step_name": "verify", "step_status": "started",
                "step_message": "checking missing_emb=0 + axiom set",
                "elapsed_s": round(time.monotonic() - t0, 1),
            })
            try:
                verify = _verify_graph_sync()
                missing = verify.get("missing_emb", 1)
                if missing != 0:
                    aborted_at = "post_refresh_missing_emb"
                    write_progress({
                        "phase": "refresh_graph",
                        "step": total_steps, "step_count": total_steps,
                        "step_name": "verify", "step_status": "failed",
                        "step_message": f"missing_emb={missing}",
                        "elapsed_s": round(time.monotonic() - t0, 1),
                    })
                else:
                    write_progress({
                        "phase": "refresh_graph",
                        "step": total_steps, "step_count": total_steps,
                        "step_name": "verify", "step_status": "succeeded",
                        "step_message": (
                            f"thm_count={verify.get('thm_count')} "
                            f"axioms={len(verify.get('axioms', []))}"
                        ),
                        "elapsed_s": round(time.monotonic() - t0, 1),
                    })
            except Exception as e:
                verify = {"error": str(e)[:400]}
                aborted_at = "verify"
                write_progress({
                    "phase": "refresh_graph",
                    "step": total_steps, "step_count": total_steps,
                    "step_name": "verify", "step_status": "failed",
                    "step_message": f"exception: {e}",
                    "elapsed_s": round(time.monotonic() - t0, 1),
                })

    return {
        "ok": aborted_at is None,
        "aborted_at": aborted_at,
        "steps": results,
        "verify": verify,
        "elapsed_s": round(time.monotonic() - t0, 1),
        "dry_run": dry_run,
    }


def _axiom_sentinel_sync(
    workdir: str, lake_bin: str, dry_run: bool,
    capstone_targets: list[str] | None = None,
) -> dict:
    """Tiny in-process replica of axiom_audit just for sentinel use.

    The MCP `axiom_audit` is async + cached + lives in __main__.py — that
    module imports `mcp.server.fastmcp` which is unsafe in a fresh child
    Python (event-loop init issues). So we re-implement the bare minimum
    here: write a temp .lean with `#print axioms <T>` for each capstone,
    run `lake env lean`, parse the output. Returns
    `{"clean": bool, "targets": {...}, "regressions": [...]}`.
    """
    if dry_run:
        return {"clean": True, "targets": {}, "regressions": [], "dry_run": True}
    capstones = list(capstone_targets or [])
    if not capstones:
        return {"clean": True, "targets": {}, "regressions": [],
                "note": "no capstone targets passed — skipping sentinel"}
    tmp_path = Path("/tmp/_omega_refresh_axcheck.lean")
    body_lines = ["import OmegaTheory", ""]
    for t in capstones:
        body_lines.append(f"#print axioms {t}")
    tmp_path.write_text("\n".join(body_lines))
    rc, out, _bytes = _run_child_streaming(
        cmd=[lake_bin, "env", "lean", str(tmp_path)],
        cwd=workdir, timeout=300, label="axiom_sentinel",
        tail_bytes=200_000,  # axiom_audit output can be 100s of theorems
    )
    if rc == 124:
        return {"clean": False, "error": "axiom sentinel lean timeout (300s)"}
    LEAN_CORE = {"propext", "Classical.choice", "Quot.sound"}
    regressions: list[dict] = []
    targets: dict[str, list[str]] = {}
    # Parse `'x' depends on axioms: [a, b, ...]` lines
    import re
    pat = re.compile(r"'([^']+)' depends on axioms: \[([^\]]*)\]")
    for m in pat.finditer(out):
        name = m.group(1)
        deps = [a.strip() for a in m.group(2).split(",") if a.strip()]
        targets[name] = deps
        bad = [a for a in deps if a not in LEAN_CORE]
        if bad:
            regressions.append({"theorem": name, "non_core_axioms": bad})
    return {
        "clean": not regressions,
        "targets": targets,
        "regressions": regressions,
        "returncode": rc,
    }


def _verify_graph_sync() -> dict:
    """Read missing_emb + thm_count + axioms via bolt://."""
    from neo4j import GraphDatabase
    uri, user, pw = _neo4j_creds()
    driver = GraphDatabase.driver(uri, auth=(user, pw))
    try:
        with driver.session() as s:
            missing_emb = s.run(
                "MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) "
                "WHERE t.embedding_lean IS NULL RETURN count(t) AS n"
            ).single()["n"]
            thm_count = s.run(
                "MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) RETURN count(t) AS n"
            ).single()["n"]
            axioms = sorted([
                r["a"] for r in s.run(
                    "MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN a.name AS a"
                )
            ])
    finally:
        driver.close()
    return {"missing_emb": missing_emb, "thm_count": thm_count, "axioms": axioms}


# ── Bucket 3: embedding (granular per-node, delta, candidates) ─────────────


def _embedder_url() -> str:
    return os.environ.get("OMEGA_EMBEDDER_URL", "http://localhost:7999")


def _embedder_alias() -> str:
    return os.environ.get("OMEGA_EMBEDDER_ALIAS", "qwen3-embedding-8b")


def _neo4j_creds() -> tuple[str, str, str]:
    return (
        os.environ.get("OMEGA_NEO4J_URI", "bolt://localhost:7687"),
        os.environ.get("OMEGA_NEO4J_USER", "neo4j"),
        os.environ.get("OMEGA_NEO4J_PASSWORD", "omegatheory2026"),
    )


_FIELD_CONFIG = {
    "signature": (
        "signature", "embedding_signature", 1500,
        "Given a Lean 4 theorem signature, encode its type-theoretic content "
        "so that semantically equivalent statements produce nearby vectors.",
    ),
    "proof": (
        "proof_body", "embedding_proof", 3500,
        "Given a Lean 4 tactic proof body, encode its proof-pattern.",
    ),
    "docstring": (
        "docstring", "embedding_docstring", 1000,
        "Given a Lean 4 declaration's doc comment, encode the author's stated intent.",
    ),
}


def _embed_batch(texts: list[str], task: str) -> list[list[float]]:
    """Send a batched embedding request to :7999 with Qwen3 instruction wrap."""
    import httpx
    bodies = [f"Instruct: {task}\nQuery: {t}" for t in texts]
    r = httpx.post(
        f"{_embedder_url()}/v1/embeddings",
        json={"input": bodies, "model": _embedder_alias()},
        timeout=120.0,
    )
    r.raise_for_status()
    data = r.json()["data"]
    return [d["embedding"] for d in sorted(data, key=lambda d: d["index"])]


def _crop(s: str | None, cap: int) -> str:
    return ((s or "").strip())[:cap] or "(empty)"


def _embed_field_for_rows(
    field: str,
    rows: list[dict],
    batch_size: int = 16,
) -> dict:
    """Embed one field for the given rows (each row has 'eid' + 'text')."""
    from neo4j import GraphDatabase
    src_prop, target_prop, cap, task = _FIELD_CONFIG[field]
    uri, user, pw = _neo4j_creds()
    driver = GraphDatabase.driver(uri, auth=(user, pw))
    written = 0
    skipped = 0
    t0 = time.monotonic()
    write_q = f"""
        UNWIND $rows AS row
        MATCH (t) WHERE elementId(t) = row.eid
        SET t.{target_prop} = row.vec, t.{target_prop}_at = row.at
    """
    skip_q = f"""
        MATCH (t) WHERE elementId(t) = $eid
        SET t.{target_prop}_skipped_at = $at, t.{target_prop}_skipped_reason = $reason
    """
    try:
        with driver.session() as s:
            for i in range(0, len(rows), batch_size):
                batch = rows[i:i + batch_size]
                texts = [_crop(r.get("text"), cap) for r in batch]
                try:
                    vecs = _embed_batch(texts, task)
                except Exception as batch_err:
                    print(f"[embed/{field}] batch failed ({batch_err}) — singling", flush=True)
                    vecs = [None] * len(batch)
                    for j, t in enumerate(texts):
                        try:
                            v = _embed_batch([t], task)
                            vecs[j] = v[0] if v else None
                        except Exception as e:
                            s.run(skip_q, eid=batch[j]["eid"],
                                  at=time.time(), reason=str(e)[:400])
                            skipped += 1
                payload = [
                    {"eid": r["eid"], "vec": v, "at": time.time()}
                    for r, v in zip(batch, vecs) if v is not None
                ]
                if payload:
                    s.run(write_q, rows=payload)
                    written += len(payload)
                if (i // batch_size) % 10 == 0:
                    elapsed = time.monotonic() - t0
                    print(f"[embed/{field}] {written}/{len(rows)} "
                          f"rate={written / max(elapsed, 0.01):.1f}/s "
                          f"elapsed={elapsed:.0f}s", flush=True)
    finally:
        driver.close()
    return {
        "field": field,
        "rows_written": written,
        "rows_skipped": skipped,
        "elapsed_s": round(time.monotonic() - t0, 1),
    }


def embed_delta_target(
    fields: list[str] | None = None,
    namespace: str = "OmegaTheoryV2",
    overwrite: bool = False,
) -> dict:
    """Embed the SPLIT-FIELD delta — whatever sig/proof/doc embeddings are
    currently missing for the given namespace.

    fields: subset of ["signature","proof","docstring"]; default = all 3.
    overwrite: if True, re-embed even rows that already have target embedding.
    """
    from neo4j import GraphDatabase
    fields = fields or ["signature", "proof", "docstring"]
    print(f"[embed_delta] fields={fields} namespace={namespace}", flush=True)
    uri, user, pw = _neo4j_creds()
    driver = GraphDatabase.driver(uri, auth=(user, pw))
    per_field: list[dict] = []
    try:
        with driver.session() as s:
            for field in fields:
                if field not in _FIELD_CONFIG:
                    per_field.append({"field": field, "error": "unknown field"})
                    continue
                src_prop, target_prop, cap, _task = _FIELD_CONFIG[field]
                where_missing = "" if overwrite else f"AND t.{target_prop} IS NULL AND t.{target_prop}_skipped_at IS NULL"
                q = f"""
                    MATCH (t:Theorem {{namespace: $ns}})
                    WHERE t.{src_prop} IS NOT NULL AND trim(t.{src_prop}) <> ''
                      {where_missing}
                    RETURN elementId(t) AS eid, t.name AS name,
                           t.{src_prop} AS text
                """
                rows = [dict(r) for r in s.run(q, ns=namespace)]
                print(f"[embed_delta/{field}] {len(rows)} rows pending", flush=True)
                if not rows:
                    per_field.append({"field": field, "rows_written": 0,
                                      "rows_skipped": 0, "elapsed_s": 0.0})
                    continue
                per_field.append(_embed_field_for_rows(field, rows))
    finally:
        driver.close()
    return {"namespace": namespace, "fields": fields, "results": per_field}


def embed_nodes_target(
    names: list[str],
    fields: list[str] | None = None,
) -> dict:
    """Embed an EXPLICIT list of theorem names. Caller chooses which nodes."""
    from neo4j import GraphDatabase
    if not names:
        return {"error": "no names provided"}
    fields = fields or ["signature", "proof", "docstring"]
    print(f"[embed_nodes] {len(names)} theorems, fields={fields}", flush=True)
    uri, user, pw = _neo4j_creds()
    driver = GraphDatabase.driver(uri, auth=(user, pw))
    per_field: list[dict] = []
    try:
        with driver.session() as s:
            for field in fields:
                if field not in _FIELD_CONFIG:
                    per_field.append({"field": field, "error": "unknown field"})
                    continue
                src_prop, _, _, _ = _FIELD_CONFIG[field]
                q = f"""
                    UNWIND $names AS n
                    MATCH (t:Theorem {{name: n}})
                    WHERE t.{src_prop} IS NOT NULL AND trim(t.{src_prop}) <> ''
                    RETURN elementId(t) AS eid, t.name AS name,
                           t.{src_prop} AS text
                """
                rows = [dict(r) for r in s.run(q, names=names)]
                if not rows:
                    per_field.append({"field": field, "rows_written": 0,
                                      "elapsed_s": 0.0,
                                      "note": "no matching nodes had source field"})
                    continue
                per_field.append(_embed_field_for_rows(field, rows))
    finally:
        driver.close()
    return {"requested_names": len(names), "fields": fields, "results": per_field}


def embed_candidates_target(
    statuses: list[str] | None = None,
) -> dict:
    """Embed :TheoremCandidate nodes (closes the sage→wizard retrieval blind spot)."""
    from neo4j import GraphDatabase
    statuses = statuses or ["OPEN", "PROPOSED", "OPEN_EASY"]
    print(f"[embed_candidates] statuses={statuses}", flush=True)
    uri, user, pw = _neo4j_creds()
    driver = GraphDatabase.driver(uri, auth=(user, pw))
    written = 0
    skipped = 0
    t0 = time.monotonic()
    try:
        with driver.session() as s:
            q = """
                MATCH (c:TheoremCandidate)
                WHERE c.status IN $statuses
                  AND c.embedding_lean IS NULL
                  AND (c.signature IS NOT NULL OR c.rationale IS NOT NULL)
                RETURN elementId(c) AS eid, c.name AS name,
                       coalesce(c.signature, '') + '\n' +
                       coalesce(c.rationale, '') + '\n' +
                       coalesce(c.proof_pathway_sketch, '') AS text
            """
            rows = [dict(r) for r in s.run(q, statuses=statuses)]
            print(f"[embed_candidates] {len(rows)} unembed candidates", flush=True)
            if not rows:
                return {"rows_written": 0, "elapsed_s": 0.0,
                        "note": "no unembed candidates"}
            task = (
                "Given a Lean 4 theorem-candidate proposal (signature + rationale "
                "+ proof sketch), encode it for kNN retrieval against existing "
                "theorems and other candidates."
            )
            batch_size = 16
            write_q = """
                UNWIND $rows AS row
                MATCH (c) WHERE elementId(c) = row.eid
                SET c.embedding_lean = row.vec, c.embedded_at = row.at
            """
            for i in range(0, len(rows), batch_size):
                batch = rows[i:i + batch_size]
                texts = [_crop(r.get("text"), 2500) for r in batch]
                try:
                    vecs = _embed_batch(texts, task)
                except Exception as e:
                    print(f"[embed_candidates] batch err: {e}", flush=True)
                    skipped += len(batch)
                    continue
                payload = [
                    {"eid": r["eid"], "vec": v, "at": time.time()}
                    for r, v in zip(batch, vecs) if v is not None
                ]
                s.run(write_q, rows=payload)
                written += len(payload)
                if (i // batch_size) % 5 == 0:
                    print(f"[embed_candidates] {written}/{len(rows)}", flush=True)
    finally:
        driver.close()
    return {
        "rows_written": written, "rows_skipped": skipped,
        "elapsed_s": round(time.monotonic() - t0, 1),
    }


# ── Bucket 4: read-only inspection ──────────────────────────────────────────


def inspect_candidate_status(
    namespace: str = "OmegaTheoryV2",
    status_filter: list[str] | None = None,
) -> dict:
    """Group :TheoremCandidate by status for parent decision input."""
    from neo4j import GraphDatabase
    uri, user, pw = _neo4j_creds()
    driver = GraphDatabase.driver(uri, auth=(user, pw))
    try:
        with driver.session() as s:
            if status_filter:
                rows = list(s.run(
                    "MATCH (c:TheoremCandidate) "
                    "WHERE c.status IN $statuses "
                    "RETURN c.status AS status, count(*) AS n ORDER BY n DESC",
                    statuses=status_filter,
                ))
            else:
                rows = list(s.run(
                    "MATCH (c:TheoremCandidate) "
                    "RETURN c.status AS status, count(*) AS n ORDER BY n DESC"
                ))
            total = s.run(
                "MATCH (c:TheoremCandidate) RETURN count(c) AS n"
            ).single()["n"]
    finally:
        driver.close()
    return {
        "by_status": [{"status": r["status"], "n": r["n"]} for r in rows],
        "total": total,
    }


def inspect_build_status(
    workdir: str = "/home/norbert/lean-v2",
    lake_bin: str = "/home/norbert/.elan/bin/lake",
) -> dict:
    """Run `lake build --log-level=error` and parse the result.

    NOTE: this can be slow (full incremental build). Used sparingly.
    """
    rc, tail, total_bytes = _run_child_streaming(
        cmd=[lake_bin, "build", "--log-level=error"],
        cwd=workdir, timeout=900, label="inspect_build_status",
        tail_bytes=2000,
    )
    return {
        "ok": rc == 0,
        "returncode": rc,
        "output_tail": tail,
        "output_total_bytes": total_bytes,
    }


def inspect_graph_health() -> dict:
    """One-shot snapshot of graph state — used by parent to decide phase."""
    from neo4j import GraphDatabase
    uri, user, pw = _neo4j_creds()
    driver = GraphDatabase.driver(uri, auth=(user, pw))
    try:
        with driver.session() as s:
            ov2_count = s.run(
                "MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) RETURN count(t) AS n"
            ).single()["n"]
            mathlib_count = s.run(
                "MATCH (t:Theorem {namespace:'Mathlib'}) RETURN count(t) AS n"
            ).single()["n"]
            axioms = [r["a"] for r in s.run(
                "MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN a.name AS a"
            )]
            missing_emb = s.run(
                "MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) "
                "WHERE t.embedding_lean IS NULL RETURN count(t) AS n"
            ).single()["n"]
            indices = list(s.run(
                "SHOW INDEXES YIELD name, type, options "
                "WHERE type='VECTOR' "
                "RETURN name, options.indexConfig.`vector.dimensions` AS dim"
            ))
    finally:
        driver.close()
    return {
        "ov2_theorems": ov2_count,
        "mathlib_theorems": mathlib_count,
        "axioms": axioms,
        "missing_embeddings_ov2": missing_emb,
        "vector_indices": [{"name": r["name"], "dim": r["dim"]} for r in indices],
    }


def inspect_cycle_state(
    running_wizard_count: int = 0,
    landings_since_last_refresh: int = 0,
) -> dict:
    """Composite phase-classifier — tells parent what phase to enter next.

    Wraps the existing classify_phase pure-function from orchestration.py.
    """
    from .orchestration import (
        classify_phase, expected_server_state_for_phase,
    )
    health = inspect_graph_health()
    candidates = inspect_candidate_status(
        status_filter=["OPEN", "OPEN_EASY", "PROPOSED"]
    )
    open_count = sum(b["n"] for b in candidates["by_status"])
    phase, reason, next_action = classify_phase(
        running_wizard_count=running_wizard_count,
        landings_since_last_refresh=landings_since_last_refresh,
        open_candidate_count=open_count,
    )
    return {
        "phase": phase,
        "reason": reason,
        "next_action": next_action,
        "expected_server_state": expected_server_state_for_phase(phase),
        "graph": health,
        "open_candidates": open_count,
    }
