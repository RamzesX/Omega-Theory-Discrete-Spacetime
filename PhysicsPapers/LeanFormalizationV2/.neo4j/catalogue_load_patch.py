#!/usr/bin/env python3
"""
catalogue_load_patch — enrich Lean declarations with LeanDojo retriever embeddings.

Standalone module (not a patch of catalogue_load.py): importable via

    from catalogue_load_patch import enrich_with_embedding, EmbeddingBatcher

Embedder
--------
LeanDojo-Lean4-Retriever (`kaiyuy/leandojo-lean4-retriever-byt5-small`,
ByT5-small, 82M params, OPEN weights, d_model = 1472). Substituted for
Lean-Finder because the latter turned out to be a hosted-only HF Space
with no downloadable checkpoint.

Design goals
------------
* Non-crashing: if the retriever REST server is down, log a warning and
  skip (the calling loader must continue to materialize the graph).
* Batched: POST ~100 declarations per request to amortize Python/HTTP
  overhead; configurable via ``batch_size``.
* Retries: exponential backoff up to ``max_retries`` on timeouts /
  transient 5xx responses.  The last attempt is surfaced to the caller.
* Timeouts: 30 s per HTTP call by default.
* Driver-agnostic: takes a live ``neo4j`` Session and issues the
  minimum-possible Cypher (SET ... = $e) so the caller controls TX scope.

Dependencies
------------
* Python 3.11+
* ``neo4j`` driver
* ``httpx`` (preferred for async, has sync fallback).  If httpx missing,
  falls back to ``requests`` automatically.

Example usage inside catalogue_load.py::

    from catalogue_load_patch import EmbeddingBatcher

    batcher = EmbeddingBatcher(
        session=session,
        embedder_url='http://localhost:7999/v1/embeddings',
        model='leandojo-lean4-retriever',
        batch_size=100,
    )
    for decl in scanned_declarations:
        batcher.add(name=decl.name,
                    label=decl.declaration_type,   # 'Theorem' | 'Axiom' | 'Declaration'
                    namespace=decl.namespace,
                    signature=decl.signature,
                    docstring=decl.docstring or '')
    batcher.flush()
"""
from __future__ import annotations

import logging
import time
from dataclasses import dataclass, field
from typing import Iterable

try:  # preferred
    import httpx  # type: ignore

    _HTTP = 'httpx'
except ImportError:  # pragma: no cover -- fallback for minimal envs
    import requests  # type: ignore

    httpx = None  # type: ignore
    _HTTP = 'requests'

log = logging.getLogger('catalogue_load_patch')

# ---------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------
DEFAULT_EMBEDDER_URL = 'http://localhost:7999/v1/embeddings'
DEFAULT_MODEL = 'leandojo-lean4-retriever'
DEFAULT_EMBEDDING_DIM = 1472  # ByT5-small d_model (kaiyuy/leandojo-lean4-retriever-byt5-small)
DEFAULT_BATCH_SIZE = 100
DEFAULT_TIMEOUT = 30.0        # seconds per HTTP call
DEFAULT_MAX_RETRIES = 3       # not counting the original attempt
DEFAULT_BACKOFF_BASE = 0.5    # seconds; multiplied by 2**attempt


# ---------------------------------------------------------------------
# Simple, stateless helper for one-shot embedding
# ---------------------------------------------------------------------
def enrich_with_embedding(
    session,
    declaration_name: str,
    signature: str,
    docstring: str,
    label: str = 'Theorem',
    namespace: str = 'OmegaTheoryV2',
    embedder_url: str = DEFAULT_EMBEDDER_URL,
    model: str = DEFAULT_MODEL,
    timeout: float = DEFAULT_TIMEOUT,
    max_retries: int = DEFAULT_MAX_RETRIES,
) -> None:
    """POST one declaration to the LeanDojo retriever, store the vector.

    Non-crashing: logs a warning and returns on any failure.
    Use ``EmbeddingBatcher`` for bulk ingestion (100x faster).
    """
    text = _format_text(signature=signature, docstring=docstring)
    try:
        embeddings = _post_embeddings(
            url=embedder_url,
            model=model,
            inputs=[text],
            timeout=timeout,
            max_retries=max_retries,
        )
    except Exception as exc:  # noqa: BLE001  -- explicit non-crash
        log.warning(
            'LeanDojo retriever unavailable for %s (%s); skipping embedding',
            declaration_name,
            exc,
        )
        return

    if not embeddings:
        log.warning('LeanDojo retriever returned empty vector for %s; skipping', declaration_name)
        return

    _write_embedding(session, label, namespace, declaration_name, embeddings[0])


# ---------------------------------------------------------------------
# Batched helper -- use this inside catalogue_load.py's main loop
# ---------------------------------------------------------------------
@dataclass
class _PendingDecl:
    name: str
    label: str
    namespace: str
    text: str


@dataclass
class EmbeddingBatcher:
    session: object   # neo4j bolt Session
    embedder_url: str = DEFAULT_EMBEDDER_URL
    model: str = DEFAULT_MODEL
    batch_size: int = DEFAULT_BATCH_SIZE
    timeout: float = DEFAULT_TIMEOUT
    max_retries: int = DEFAULT_MAX_RETRIES

    _buffer: list[_PendingDecl] = field(default_factory=list)
    n_embedded: int = 0
    n_skipped: int = 0

    def add(
        self,
        name: str,
        label: str,
        namespace: str,
        signature: str,
        docstring: str = '',
    ) -> None:
        self._buffer.append(_PendingDecl(
            name=name,
            label=label,
            namespace=namespace,
            text=_format_text(signature=signature, docstring=docstring),
        ))
        if len(self._buffer) >= self.batch_size:
            self.flush()

    def flush(self) -> None:
        """Ship the current buffer to the LeanDojo retriever and persist results."""
        if not self._buffer:
            return
        inputs = [d.text for d in self._buffer]
        try:
            vectors = _post_embeddings(
                url=self.embedder_url,
                model=self.model,
                inputs=inputs,
                timeout=self.timeout,
                max_retries=self.max_retries,
            )
        except Exception as exc:  # noqa: BLE001
            log.warning(
                'LeanDojo retriever unavailable for batch of %d (%s); skipping',
                len(self._buffer),
                exc,
            )
            self.n_skipped += len(self._buffer)
            self._buffer.clear()
            return

        if len(vectors) != len(self._buffer):
            log.warning(
                'LeanDojo retriever returned %d vectors for batch of %d; skipping',
                len(vectors),
                len(self._buffer),
            )
            self.n_skipped += len(self._buffer)
            self._buffer.clear()
            return

        for decl, vec in zip(self._buffer, vectors, strict=True):
            _write_embedding(self.session, decl.label, decl.namespace, decl.name, vec)
            self.n_embedded += 1
        self._buffer.clear()


# ---------------------------------------------------------------------
# Internals
# ---------------------------------------------------------------------
def _format_text(signature: str, docstring: str) -> str:
    """Concatenate signature + docstring into the retriever's input format.

    Following the HF card for kaiyuy/leandojo-lean4-retriever-byt5-small,
    goal/premise text is passed verbatim at the character level; docstring
    is an optional context prefix.
    """
    sig = (signature or '').strip()
    doc = (docstring or '').strip()
    if doc:
        return f'{doc}\n{sig}'
    return sig


def _post_embeddings(
    url: str,
    model: str,
    inputs: list[str],
    timeout: float,
    max_retries: int,
) -> list[list[float]]:
    """POST to an OpenAI-compatible /v1/embeddings endpoint.

    Returns the ``embedding`` field of each response item, in input order.
    Raises on exhausted retries -- the caller must catch.
    """
    payload = {'model': model, 'input': inputs}
    last_exc: Exception | None = None

    for attempt in range(max_retries + 1):
        try:
            data = _http_post_json(url=url, payload=payload, timeout=timeout)
            items = data.get('data', [])
            return [item['embedding'] for item in items]
        except Exception as exc:  # noqa: BLE001 -- catches httpx/requests + KeyError
            last_exc = exc
            if attempt >= max_retries:
                break
            backoff = DEFAULT_BACKOFF_BASE * (2 ** attempt)
            log.info(
                'LeanDojo retriever attempt %d/%d failed (%s); retrying in %.2fs',
                attempt + 1, max_retries + 1, exc, backoff,
            )
            time.sleep(backoff)

    assert last_exc is not None
    raise last_exc


def _http_post_json(url: str, payload: dict, timeout: float) -> dict:
    """Tiny sync JSON POST wrapper over httpx or requests, whichever is installed."""
    if _HTTP == 'httpx':
        with httpx.Client(timeout=timeout) as client:  # type: ignore[union-attr]
            resp = client.post(url, json=payload)
            resp.raise_for_status()
            return resp.json()
    # requests fallback
    import requests  # type: ignore
    resp = requests.post(url, json=payload, timeout=timeout)
    resp.raise_for_status()
    return resp.json()


def _write_embedding(
    session,
    label: str,
    namespace: str,
    name: str,
    vector: list[float],
) -> None:
    """Persist one embedding with the minimum Cypher possible.

    Label is interpolated (not parameterizable in the Cypher syntax); we
    whitelist to ``Theorem`` / ``Axiom`` / ``Declaration`` to block injection.
    """
    if label not in ('Theorem', 'Axiom', 'Declaration'):
        log.warning('Unknown declaration label %r for %s; skipping write', label, name)
        return

    query = (
        f'MATCH (n:{label} {{namespace: $ns, name: $name}}) '
        'SET n.embedding_lean = $vec'
    )
    try:
        session.run(query, ns=namespace, name=name, vec=vector)
    except Exception as exc:  # noqa: BLE001 -- don't crash the loader
        log.warning('Neo4j write failed for %s:%s (%s)', label, name, exc)


# ---------------------------------------------------------------------
# Convenience: integration hint block for catalogue_load.py
# ---------------------------------------------------------------------
def example_integration() -> None:  # pragma: no cover
    """Illustrative only -- shows how catalogue_load.py would call this module."""
    from neo4j import GraphDatabase
    URI = 'bolt://localhost:7687'
    driver = GraphDatabase.driver(URI, auth=('neo4j', 'omegatheory2026'))
    with driver.session() as session:
        batcher = EmbeddingBatcher(session=session)
        batcher.add(
            name='hpw_laplacian_ricci_convergence',
            label='Axiom',
            namespace='OmegaTheoryV2',
            signature='forall (g : DiscreteMetric), |discreteLaplacian g + 2 * ricci g| <= l_P / 2',
            docstring='HPW 2006 convergence: graph Laplacian of g approximates -2 Ricci to within half a Planck length.',
        )
        batcher.flush()
        log.info('embedded=%d skipped=%d', batcher.n_embedded, batcher.n_skipped)
    driver.close()


if __name__ == '__main__':  # pragma: no cover
    logging.basicConfig(level=logging.INFO)
    example_integration()
