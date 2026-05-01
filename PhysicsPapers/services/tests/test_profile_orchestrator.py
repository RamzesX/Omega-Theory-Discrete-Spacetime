"""Tests for the TOML profile loader."""
from __future__ import annotations

import os
from pathlib import Path
from textwrap import dedent
from unittest.mock import patch

import pytest

from omega_orchestrator.profile import (
    ModelProfile,
    RetrievalConfig,
    ServerEntry,
    active_profile_path,
    current_profile,
    load_profile,
    reload_profile,
)


MIN_PROFILE = dedent("""
    [profile]
    name        = "testing"
    description = "unit-test profile"
    version     = 1

    [[servers]]
    id            = "embedder"
    role          = "embedding"
    launcher      = "/tmp/embed.sh"
    port          = 7999
    alias         = "test-emb"
    model_path    = "/tmp/emb.gguf"
    model_dim     = 1024
    ctx           = 2048
    batch         = 1024
    parallel      = 2
    threads       = 2
    query_wrap    = "Query: {text}"
    boot_grace_s  = 30
    process_match = "port 7999"

    [retrieval]
    active_indices = ["idx_theorem"]
""").strip()


def _write(tmp_path: Path, body: str) -> Path:
    p = tmp_path / "test.toml"
    p.write_text(body)
    return p


# ── Happy path ──────────────────────────────────────────────────────────────


def test_load_minimal_profile(tmp_path):
    p = _write(tmp_path, MIN_PROFILE)
    prof = load_profile(p)
    assert isinstance(prof, ModelProfile)
    assert prof.name == "testing"
    assert prof.description == "unit-test profile"
    assert prof.version == 1
    assert len(prof.servers) == 1
    assert prof.embedder is not None
    assert prof.embedder.port == 7999
    assert prof.has_reranker() is False


def test_load_full_default_profile_on_disk():
    # The real default.toml we just wrote should parse.
    p = Path("/home/norbert/services/profiles/default.toml")
    prof = load_profile(p)
    assert prof.name == "default"
    assert prof.embedder and prof.embedder.port == 7999
    assert prof.reranker and prof.reranker.port == 7996
    assert "lean_retriever_embedding_theorem" in prof.retrieval.active_indices


def test_servers_by_id_and_role(tmp_path):
    body = MIN_PROFILE + "\n" + dedent("""
        [[servers]]
        id            = "reranker"
        role          = "reranking"
        launcher      = "/tmp/rerank.sh"
        port          = 7996
        alias         = "test-rerank"
        model_path    = "/tmp/rerank.gguf"
        ctx           = 4096
        batch         = 2048
        parallel      = 1
        threads       = 8
        query_wrap    = "<Q>: {text}"
        boot_grace_s  = 60
        process_match = "port 7996"
    """)
    prof = load_profile(_write(tmp_path, body))
    assert "embedder" in prof.servers_by_id
    assert "reranker" in prof.servers_by_id
    assert prof.servers_by_role["embedding"].alias == "test-emb"
    assert prof.servers_by_role["reranking"].alias == "test-rerank"
    assert prof.has_reranker() is True


# ── Validation ──────────────────────────────────────────────────────────────


def test_missing_profile_name_raises(tmp_path):
    body = MIN_PROFILE.replace('name        = "testing"', "")
    with pytest.raises(ValueError, match="name"):
        load_profile(_write(tmp_path, body))


def test_bad_name_characters_raise(tmp_path):
    body = MIN_PROFILE.replace('"testing"', '"has space!"')
    with pytest.raises(ValueError, match="alphanumeric"):
        load_profile(_write(tmp_path, body))


def test_no_servers_raises(tmp_path):
    body = dedent("""
        [profile]
        name = "bad"
    """)
    with pytest.raises(ValueError, match="at least one"):
        load_profile(_write(tmp_path, body))


def test_missing_server_field_raises(tmp_path):
    body = MIN_PROFILE.replace('port          = 7999\n', "")
    with pytest.raises(ValueError, match="missing required"):
        load_profile(_write(tmp_path, body))


def test_duplicate_port_raises(tmp_path):
    # Both servers use port 7999 — collision detected.
    body = MIN_PROFILE + "\n" + dedent("""
        [[servers]]
        id            = "reranker"
        role          = "reranking"
        launcher      = "/tmp/x.sh"
        port          = 7999
        alias         = "test-r"
        model_path    = "/tmp/r.gguf"
        ctx           = 4096
        batch         = 2048
        parallel      = 1
        threads       = 8
        query_wrap    = "X"
        boot_grace_s  = 60
        process_match = "port 7999"
    """)
    with pytest.raises(ValueError, match="duplicate port"):
        load_profile(_write(tmp_path, body))


def test_multiple_embedders_raise(tmp_path):
    body = MIN_PROFILE + "\n" + dedent("""
        [[servers]]
        id            = "embedder2"
        role          = "embedding"
        launcher      = "/tmp/e2.sh"
        port          = 7998
        alias         = "e2"
        model_path    = "/tmp/e2.gguf"
        ctx           = 2048
        batch         = 1024
        parallel      = 2
        threads       = 2
        query_wrap    = "X"
        boot_grace_s  = 30
        process_match = "port 7998"
    """)
    with pytest.raises(ValueError, match="more than one embedding"):
        load_profile(_write(tmp_path, body))


# ── Discovery ───────────────────────────────────────────────────────────────


def test_env_var_override_path(tmp_path, monkeypatch):
    p = _write(tmp_path, MIN_PROFILE)
    monkeypatch.setenv("OMEGA_PROFILE_PATH", str(p))
    resolved = active_profile_path()
    assert resolved == p.resolve()


def test_missing_env_path_raises(monkeypatch):
    monkeypatch.setenv("OMEGA_PROFILE_PATH", "/does/not/exist.toml")
    with pytest.raises(FileNotFoundError):
        active_profile_path()


def test_named_profile_env(tmp_path, monkeypatch):
    # OMEGA_PROFILE=foo resolves to profiles_dir/foo.toml
    p = tmp_path / "foo.toml"
    p.write_text(MIN_PROFILE)
    monkeypatch.setenv("OMEGA_PROFILES_DIR", str(tmp_path))
    monkeypatch.setenv("OMEGA_PROFILE", "foo")
    # Re-import path fn with new env
    import importlib, omega_orchestrator.profile
    importlib.reload(omega_orchestrator.profile)
    from omega_orchestrator.profile import active_profile_path as reloaded
    resolved = reloaded()
    assert resolved.name == "foo.toml"


# ── Retrieval config defaults ──────────────────────────────────────────────


def test_retrieval_defaults_when_section_absent(tmp_path):
    body = MIN_PROFILE.split("[retrieval]")[0]
    prof = load_profile(_write(tmp_path, body))
    r = prof.retrieval
    assert r.active_indices == ("lean_retriever_embedding_theorem",)
    assert r.rrf_k == 60
    assert r.bm25_enabled is False


def test_retrieval_bm25_enabled(tmp_path):
    body = MIN_PROFILE + "\n" + dedent("""
        [retrieval.bm25]
        enabled = true
        k1      = 1.2
    """)
    prof = load_profile(_write(tmp_path, body))
    assert prof.retrieval.bm25_enabled is True
    assert prof.retrieval.bm25_k1 == 1.2


# ── SOTA T1.3 + #9 + #17 wiring (added 2026-05-01) ─────────────────────────


def test_lean_profile_includes_embedding_goal_index():
    """The lean profile (services/profiles/lean.toml) must include
    theorem_embedding_goal in active_indices — wires the per-theorem goal
    embedding (4096-d Qwen3 [goal] task) into omega_hammer_premise via
    dense_multi_index_rrf. Without it, SOTA T1.3 #9 + #17 are NOT live."""
    import os
    profile_path = "/home/norbert/services/profiles/lean.toml"
    if not os.path.exists(profile_path):
        import pytest
        pytest.skip(f"profile not found: {profile_path}")
    prof = load_profile(profile_path)
    assert "theorem_embedding_goal" in prof.retrieval.active_indices, (
        f"theorem_embedding_goal missing from active_indices: "
        f"{prof.retrieval.active_indices}")


def test_delta_reembedder_includes_goal_field():
    """reembed_qwen3_delta.py SPLIT_FIELD_CONFIG must include `goal` field
    so refresh_graph cycles auto-keep embedding_goal current for new
    theorems. Without this, embedding_goal coverage drifts after every
    Phase C refresh."""
    import os
    delta_path = "/home/norbert/lean-v2/.neo4j/reembed_qwen3_delta.py"
    if not os.path.exists(delta_path):
        import pytest
        pytest.skip(f"delta reembedder not found: {delta_path}")
    with open(delta_path) as f:
        src = f.read()
    assert '"goal"' in src and "embedding_goal" in src, (
        "reembed_qwen3_delta.py SPLIT_FIELD_CONFIG missing 'goal' field — "
        "refresh_graph will not auto-update embedding_goal")
