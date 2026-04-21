"""
measure_non_commutativity.py
----------------------------
Compute the 6x6 Magnetic Laplacian Algebra matrix 'A' for the Lean theorem
quiver on the live OmegaTheoryV2 graph, decompose it per-relation, measure
the commutator spectrum, and run Sarin-Beta's three empirical kill-switch
tests from 05_cycle_hypotheses.md (rank 4, lambda1/lambda2 in [1.8, 3.2],
non-commutativity fraction >= 90%).

Construction follows 04_magnetic_laplacian.md (HypatiaBasis Definition 7.1
recipe at charge g = 1/4, phases e^{+/- i pi/2} = +/- i).

The script gracefully handles the sparse-graph regime that the graph is in
today (only IMPORTS edges present) and reports 'INSUFFICIENT DATA - awaiting
Phobos arrow extractor' with diagnostics rather than crashing.

Output: JSON to stdout AND a companion file '08_empirical_spectrum_results.json'.
Optional Neo4j write-back (--write) persists the computed A back to the
MagneticLaplacian node and the per-relation components.

Author: Dubhe (alpha Ursae Majoris), Team Merak, omega-search-v3
Date:   2026-04-18
"""
from __future__ import annotations

import argparse
import json
import logging
import os
import sys
import time
from dataclasses import dataclass, field, asdict
from datetime import datetime, timezone
from typing import Dict, List, Tuple

import numpy as np
from neo4j import GraphDatabase

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

NEO4J_URI = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
NEO4J_USER = os.environ.get("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.environ.get("NEO4J_PASSWORD", "omegatheory2026")

NAMESPACE_LEAN = "LeanAlgebra"
NAMESPACE_DATA = "OmegaTheoryV2"

# Vertex order MUST match the MagneticLaplacian node's `vertex_order` property
# (alphabetical). This is the schema contract.
VERTEX_ORDER: List[str] = [
    "Axiom", "Definition", "Instance", "Namespace", "Structure", "Theorem"
]
VERTEX_INDEX: Dict[str, int] = {v: i for i, v in enumerate(VERTEX_ORDER)}
N_VERT = len(VERTEX_ORDER)

# The 15 typed arrows (from 02_relationships.md / schema).
# `tail` and `head` specify legal endpoint types per file 04 Section 1.
RELATIONS: List[Dict] = [
    {"name": "IMPORTS",          "tail": ["Namespace"], "head": ["Namespace"], "category": "I"},
    {"name": "OPENS_NAMESPACE",  "tail": ["Namespace"], "head": ["Namespace"], "category": "I"},
    {"name": "EXTENDS",          "tail": ["Structure"], "head": ["Structure"], "category": "I"},
    {"name": "INSTANTIATES",     "tail": ["Instance"],  "head": ["Structure"], "category": "I"},
    {"name": "ASSUMES",          "tail": ["Theorem"],   "head": ["Axiom"],     "category": "II"},
    {"name": "APPLIES",          "tail": ["Theorem"],   "head": ["Theorem"],   "category": "II"},
    {"name": "UNFOLDS",          "tail": ["Theorem"],   "head": ["Definition"], "category": "II"},
    {"name": "SPECIALIZES",      "tail": ["Theorem"],   "head": ["Theorem"],   "category": "II"},
    {"name": "REWRITES_BY",      "tail": ["Theorem"],   "head": ["Theorem"],   "category": "II"},
    {"name": "HAS_TYPE",         "tail": ["Definition", "Theorem"], "head": ["Structure"], "category": "III"},
    {"name": "CONSTRAINED_BY",   "tail": ["Definition", "Theorem"], "head": ["Structure"], "category": "III"},
    {"name": "PARAMETRIZES",     "tail": ["Definition", "Theorem"], "head": ["Structure"], "category": "III"},
    {"name": "REDUCES_TO",       "tail": ["Definition"], "head": ["Definition"], "category": "IV"},
    {"name": "ELABORATES_AS",    "tail": ["Definition", "Theorem"], "head": ["Theorem"],  "category": "IV"},
    {"name": "SUGGESTED_BY",     "tail": ["Theorem"],   "head": ["Theorem"],   "category": "IV"},
]
REL_NAMES: List[str] = [r["name"] for r in RELATIONS]

# LeanFile nodes in the OmegaTheoryV2 graph correspond to the 'Namespace'
# entity of the Magnetic Laplacian (per file 04 section 1: 'Namespace' = the
# file-level module scope that carries IMPORTS / OPENS_NAMESPACE). We map
# labels accordingly.
LABEL_TO_VERTEX: Dict[str, str] = {
    "Axiom":      "Axiom",
    "Definition": "Definition",
    "Theorem":    "Theorem",
    "Structure":  "Structure",
    "Instance":   "Instance",
    "Namespace":  "Namespace",
    "LeanFile":   "Namespace",  # LeanFile is the current materialization of the Namespace type
}

CHARGE_G = 0.25       # charge parameter (file 04 section 3)
EIG_TOL = 1e-9        # numerical tolerance for "nonzero eigenvalue"
LAMBDA_RATIO_LO = 1.8
LAMBDA_RATIO_HI = 3.2
NON_COMM_TARGET = 0.90

# Resulting JSON next to this script
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
RESULTS_PATH = os.path.join(SCRIPT_DIR, "08_empirical_spectrum_results.json")


# -----------------------------------------------------------------------------
# Logging
# -----------------------------------------------------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
log = logging.getLogger("dubhe.magnetic")


# -----------------------------------------------------------------------------
# Data structures
# -----------------------------------------------------------------------------

@dataclass
class RelationBlock:
    """Per-relation 6x6 block data, filled either from Neo4j or synthetic."""
    name: str
    B: np.ndarray = field(default_factory=lambda: np.zeros((N_VERT, N_VERT)))
    A_k: np.ndarray = field(default_factory=lambda: np.zeros((N_VERT, N_VERT), dtype=np.complex128))

    def total(self) -> int:
        return int(self.B.sum())


# -----------------------------------------------------------------------------
# Neo4j helpers
# -----------------------------------------------------------------------------

def make_driver():
    return GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))


def query_pair_counts(session, rel_name: str) -> Dict[Tuple[str, str], int]:
    """Count edges of type `rel_name`, bucketed by (tail_label -> head_label).

    We enumerate the labels on both endpoints and map LeanFile -> Namespace.
    """
    cypher = (
        "MATCH (a)-[r:`%s`]->(b) "
        "RETURN labels(a) AS src_lbls, labels(b) AS tgt_lbls, count(*) AS c"
    ) % rel_name
    result = session.run(cypher)
    bucket: Dict[Tuple[str, str], int] = {}
    for row in result:
        src_vertex = _labels_to_vertex(row["src_lbls"])
        tgt_vertex = _labels_to_vertex(row["tgt_lbls"])
        if src_vertex is None or tgt_vertex is None:
            continue
        key = (src_vertex, tgt_vertex)
        bucket[key] = bucket.get(key, 0) + int(row["c"])
    return bucket


def _labels_to_vertex(labels: List[str]) -> str | None:
    """Pick the first label that maps to a vertex type, or None."""
    for lab in labels:
        if lab in LABEL_TO_VERTEX:
            return LABEL_TO_VERTEX[lab]
    return None


# -----------------------------------------------------------------------------
# Magnetic Laplacian construction
# -----------------------------------------------------------------------------

def build_component(rel: RelationBlock) -> np.ndarray:
    """Return the 6x6 complex Hermitian sub-Laplacian for a single relation.

    A_k = Delta_k - T_k^(g) * W_k^(s)  elementwise,
      W_k^(s) = (B_k + B_k^T) / 2
      D_k     = sign(B_k - B_k^T)
      T_k^(g) = exp(i * 2*pi * g * D_k)
      Delta_k = diag(row-sums of W_k^(s))
    """
    B = rel.B
    Wsym = 0.5 * (B + B.T)
    Dsign = np.sign(B - B.T)
    Tphase = np.exp(1j * 2.0 * np.pi * CHARGE_G * Dsign)
    Delta = np.diag(Wsym.sum(axis=1))
    A_k = Delta - Tphase * Wsym
    return A_k


def verify_hermitian(A: np.ndarray, label: str) -> float:
    """Return Frobenius norm ||A - A^dagger||. Warn if > 1e-9."""
    defect = float(np.linalg.norm(A - A.conj().T, ord="fro"))
    if defect > 1e-9:
        log.warning("Hermiticity defect on %s: ||A - A^H||_F = %.3e", label, defect)
    return defect


# -----------------------------------------------------------------------------
# Spectrum + commutator analysis
# -----------------------------------------------------------------------------

def commutator_matrix(A: np.ndarray, B: np.ndarray) -> np.ndarray:
    return A @ B - B @ A


def commutator_norm(A: np.ndarray, B: np.ndarray) -> float:
    return float(np.linalg.norm(commutator_matrix(A, B), ord="fro"))


def rank_of_full_commutator_block(components: Dict[str, np.ndarray]) -> int:
    """Compute rank of the aggregated commutator matrix.

    Concatenate all pairwise [A_k, A_l] (upper triangle) as rows and count
    numerical rank. This proxies the dimension of the derived algebra.
    """
    rows: List[np.ndarray] = []
    names = list(components.keys())
    for i in range(len(names)):
        for j in range(i + 1, len(names)):
            C = commutator_matrix(components[names[i]], components[names[j]])
            if np.linalg.norm(C) < EIG_TOL:
                continue
            rows.append(C.flatten())
    if not rows:
        return 0
    M = np.stack(rows)
    return int(np.linalg.matrix_rank(M, tol=EIG_TOL))


def global_commutator_eigenvalue_pairs(components: Dict[str, np.ndarray]) -> List[complex]:
    """Eigenvalues of sum_k,l [A_k, A_l]. Imaginary part carries the signal."""
    C_total = np.zeros((N_VERT, N_VERT), dtype=np.complex128)
    names = list(components.keys())
    for i in range(len(names)):
        for j in range(i + 1, len(names)):
            C_total = C_total + commutator_matrix(components[names[i]], components[names[j]])
    eigvals = np.linalg.eigvals(C_total)
    return sorted(eigvals, key=lambda z: -abs(z))


def non_commutativity_fraction(components: Dict[str, np.ndarray]) -> Tuple[float, int, int]:
    names = [n for n, M in components.items() if np.linalg.norm(M) > EIG_TOL]
    total = 0
    non_comm = 0
    for i in range(len(names)):
        for j in range(i + 1, len(names)):
            total += 1
            if commutator_norm(components[names[i]], components[names[j]]) > EIG_TOL:
                non_comm += 1
    frac = (non_comm / total) if total else 0.0
    return frac, non_comm, total


# -----------------------------------------------------------------------------
# Test runners
# -----------------------------------------------------------------------------

def run_sarin_beta_tests(components: Dict[str, np.ndarray]) -> Dict:
    active = {n: M for n, M in components.items() if np.linalg.norm(M) > EIG_TOL}
    n_active = len(active)

    rank = rank_of_full_commutator_block(components)

    global_eigs = global_commutator_eigenvalue_pairs(components)
    imag_mag = sorted(
        (abs(e.imag) for e in global_eigs if abs(e.imag) > EIG_TOL),
        reverse=True,
    )
    if len(imag_mag) >= 2 and imag_mag[1] > EIG_TOL:
        lam_ratio = imag_mag[0] / imag_mag[1]
        ratio_in_band = LAMBDA_RATIO_LO <= lam_ratio <= LAMBDA_RATIO_HI
    else:
        lam_ratio = None
        ratio_in_band = False

    frac, nc, tot = non_commutativity_fraction(components)
    noncomm_pass = frac >= NON_COMM_TARGET

    verdict = "PASS"
    reasons: List[str] = []
    if n_active < 2:
        verdict = "INSUFFICIENT_DATA"
        reasons.append(
            f"Only {n_active} active relation(s) (need >= 2). "
            "Graph is sparse -- awaiting Phobos arrow extractor."
        )
    else:
        if rank != 4:
            reasons.append(f"Rank {rank} != expected 4 (two su(2) factors).")
        if lam_ratio is None:
            reasons.append("Second imaginary eigenvalue pair absent (single su(2) at best).")
        elif not ratio_in_band:
            reasons.append(
                f"lambda1/lambda2 = {lam_ratio:.3f} outside [{LAMBDA_RATIO_LO}, {LAMBDA_RATIO_HI}]."
            )
        if not noncomm_pass:
            reasons.append(
                f"Non-commutativity {100*frac:.1f}% < {100*NON_COMM_TARGET:.0f}% target."
            )
        if reasons:
            verdict = "FAIL"

    return {
        "rank_of_commutator_algebra":         int(rank),
        "rank_expected":                       4,
        "rank_pass":                           bool(rank == 4),
        "lambda1_over_lambda2":                (float(lam_ratio) if lam_ratio is not None else None),
        "lambda_ratio_band":                   [LAMBDA_RATIO_LO, LAMBDA_RATIO_HI],
        "lambda_ratio_pass":                   bool(ratio_in_band),
        "non_commutativity_fraction":          float(frac),
        "non_commutativity_pairs":             {"non_comm": int(nc), "total": int(tot)},
        "non_commutativity_target":            NON_COMM_TARGET,
        "non_commutativity_pass":              bool(noncomm_pass),
        "active_relation_count":               int(n_active),
        "top_imag_eigenvalues":                [float(x) for x in imag_mag[:6]],
        "verdict":                             verdict,
        "reasons":                             reasons,
    }


# -----------------------------------------------------------------------------
# Data collection (live Neo4j or synthetic)
# -----------------------------------------------------------------------------

def collect_live_blocks(session, permissive: bool = False) -> Dict[str, RelationBlock]:
    """Collect typed-arrow counts into 6x6 per-relation blocks.

    If permissive=True, we accept any (src,tgt) pair even when it violates
    the memo-04 type spec -- useful while Phobos's extractor has not yet
    emitted `:Structure`/`:Instance`/`:Namespace` node labels and is routing
    those vertex types into `:Definition`/`:Theorem` as a temporary workaround.
    """
    blocks: Dict[str, RelationBlock] = {}
    dropped: Dict[str, int] = {}
    for rel in RELATIONS:
        rb = RelationBlock(name=rel["name"])
        counts = query_pair_counts(session, rel["name"])
        for (src, tgt), c in counts.items():
            if src not in VERTEX_INDEX or tgt not in VERTEX_INDEX:
                continue
            # Enforce legal tail/head filtering per file 04: drop edges whose
            # endpoint types are outside the allowed set for this relation.
            # In permissive mode, accept anyway and log.
            if src not in rel["tail"] or tgt not in rel["head"]:
                dropped[rel["name"]] = dropped.get(rel["name"], 0) + c
                if not permissive:
                    log.debug(
                        "Skipping %d off-type %s: %s -> %s (allowed %s -> %s)",
                        c, rel["name"], src, tgt, rel["tail"], rel["head"],
                    )
                    continue
            rb.B[VERTEX_INDEX[src], VERTEX_INDEX[tgt]] += c
        blocks[rel["name"]] = rb
    if dropped:
        total_dropped = sum(dropped.values())
        mode = "kept (permissive)" if permissive else "dropped (strict)"
        log.info("Off-type edges %s: %s (total %d)", mode, dropped, total_dropped)
    return blocks


def synthetic_dense_blocks(seed: int = 42, scale: float = 10.0) -> Dict[str, RelationBlock]:
    """Generate a synthetic OmegaTheory-shaped dense graph by sampling edge
    counts with Poisson rates tuned to the canonical shape in 04 section 1.1.
    This does NOT touch Neo4j; it only exercises the math pipeline.
    """
    rng = np.random.default_rng(seed)
    base_rates = {
        # (tail, head): Poisson rate per relation (roughly V3-density)
        ("Theorem",    "Theorem"):    5.0 * scale,
        ("Theorem",    "Definition"): 2.0 * scale,
        ("Theorem",    "Structure"):  1.5 * scale,
        ("Theorem",    "Axiom"):      1.0 * scale,
        ("Definition", "Theorem"):    1.5 * scale,
        ("Definition", "Definition"): 1.0 * scale,
        ("Definition", "Structure"):  1.5 * scale,
        ("Structure",  "Structure"):  0.8 * scale,
        ("Instance",   "Structure"):  1.2 * scale,
        ("Namespace",  "Namespace"):  2.0 * scale,
    }
    blocks: Dict[str, RelationBlock] = {}
    for rel in RELATIONS:
        rb = RelationBlock(name=rel["name"])
        for src in rel["tail"]:
            for tgt in rel["head"]:
                rate = base_rates.get((src, tgt), 0.0)
                if rate <= 0:
                    continue
                # Per-relation amplitude: categories IV > II > III > I on average
                cat_weight = {"I": 0.6, "II": 1.0, "III": 0.8, "IV": 1.2}[rel["category"]]
                count = int(rng.poisson(rate * cat_weight))
                rb.B[VERTEX_INDEX[src], VERTEX_INDEX[tgt]] = count
        blocks[rel["name"]] = rb
    return blocks


# -----------------------------------------------------------------------------
# Assembly + JSON-safe serialization
# -----------------------------------------------------------------------------

def assemble_matrices(blocks: Dict[str, RelationBlock]) -> Tuple[np.ndarray, Dict[str, np.ndarray]]:
    components: Dict[str, np.ndarray] = {}
    A_total = np.zeros((N_VERT, N_VERT), dtype=np.complex128)
    for name, rb in blocks.items():
        A_k = build_component(rb)
        rb.A_k = A_k
        components[name] = A_k
        A_total += A_k
        verify_hermitian(A_k, f"A_{name}")
    verify_hermitian(A_total, "A_total")
    return A_total, components


def matrix_to_flat(A: np.ndarray) -> Dict[str, List[float]]:
    return {
        "real_part": [float(x) for x in np.real(A).flatten().tolist()],
        "imag_part": [float(x) for x in np.imag(A).flatten().tolist()],
    }


def eigenspectrum(A: np.ndarray) -> List[float]:
    """Hermitian eigenvalues in descending order."""
    evals = np.linalg.eigvalsh(A)
    return sorted((float(x) for x in evals), reverse=True)


# -----------------------------------------------------------------------------
# Neo4j write-back
# -----------------------------------------------------------------------------

def persist_to_neo4j(session, A_total: np.ndarray, blocks: Dict[str, RelationBlock]):
    flat = matrix_to_flat(A_total)
    session.run(
        """
        MATCH (m:MagneticLaplacian {namespace: $ns})
        SET m.real_part = $real_part,
            m.imag_part = $imag_part,
            m.charge_parameter_g = $g,
            m.populated = true,
            m.computed_at = datetime(),
            m.last_updated = datetime()
        """,
        ns=NAMESPACE_LEAN,
        real_part=flat["real_part"],
        imag_part=flat["imag_part"],
        g=CHARGE_G,
    )

    # One MagneticLaplacian_component per relation (uniqueness constraint is
    # on (namespace, relation_name) per Phobos's seed). We aggregate across
    # all legal (tail -> head) endpoint pairs and report the single dominant
    # cell as the component's source/target_idx. raw_count / reverse_count
    # sum over every contributing cell so the whole relation's traffic is
    # preserved.
    for rel in RELATIONS:
        rb = blocks[rel["name"]]
        B = rb.B
        Wsym = 0.5 * (B + B.T)
        Dsign = np.sign(B - B.T)
        Tphase = np.exp(1j * 2.0 * np.pi * CHARGE_G * Dsign)

        raw_total = 0
        reverse_total = 0
        best_cell = None  # (raw_count, i, j) with the largest raw count
        for src in rel["tail"]:
            for tgt in rel["head"]:
                i, j = VERTEX_INDEX[src], VERTEX_INDEX[tgt]
                raw_total += int(B[i, j])
                reverse_total += int(B[j, i])
                if best_cell is None or B[i, j] > best_cell[0]:
                    best_cell = (int(B[i, j]), i, j)
        if best_cell is None:
            continue
        i, j = best_cell[1], best_cell[2]
        sym_w = float(Wsym[i, j])
        dsig = int(Dsign[i, j])
        phase = complex(Tphase[i, j])
        rank_contrib = 2 if (raw_total > 0 and i != j) else 0

        session.run(
            """
            MERGE (c:MagneticLaplacian_component {
                namespace: $ns, relation_name: $rel
            })
            SET c.category = $cat,
                c.source_idx = $si,
                c.target_idx = $ti,
                c.raw_count = $raw,
                c.reverse_count = $reverse,
                c.symmetric_weight = $sym,
                c.direction_sign = $dsig,
                c.phase_real = $pr,
                c.phase_imag = $pi,
                c.rank_contribution = $rank,
                c.last_updated = datetime()
            """,
            ns=NAMESPACE_LEAN,
            rel=rel["name"],
            si=i, ti=j,
            cat=rel["category"],
            raw=raw_total,
            reverse=reverse_total,
            sym=sym_w,
            dsig=dsig,
            pr=float(phase.real),
            pi=float(phase.imag),
            rank=rank_contrib,
        )


# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

def run_analysis(mode: str, write: bool, seed: int, scale: float,
                 permissive: bool = False) -> Dict:
    t0 = time.time()
    driver = make_driver()

    # Collect blocks
    with driver.session() as session:
        if mode == "live":
            log.info(
                "Collecting typed-arrow counts from Neo4j live graph (%s mode)...",
                "permissive" if permissive else "strict",
            )
            blocks = collect_live_blocks(session, permissive=permissive)
        elif mode == "synthetic":
            log.info("Generating synthetic-dense blocks (seed=%d, scale=%.1f)...", seed, scale)
            blocks = synthetic_dense_blocks(seed=seed, scale=scale)
        else:
            raise ValueError(f"Unknown mode: {mode}")

        # Per-relation report
        per_rel_report: List[Dict] = []
        for rel in RELATIONS:
            rb = blocks[rel["name"]]
            per_rel_report.append({
                "relation": rel["name"],
                "category": rel["category"],
                "total_edges": rb.total(),
                "B_matrix": rb.B.tolist(),
            })

        # Assemble Magnetic Laplacian
        log.info("Assembling 6x6 Magnetic Laplacian from %d relations...", len(blocks))
        A_total, components = assemble_matrices(blocks)

        # Spectrum + tests
        full_spectrum = eigenspectrum(A_total)
        log.info("Hermitian spectrum of A (descending): %s", full_spectrum)

        tests = run_sarin_beta_tests(components)
        log.info("Verdict: %s", tests["verdict"])
        for r in tests["reasons"]:
            log.info("  - %s", r)

        # Optional write-back
        if write and mode == "live":
            log.info("Persisting A and per-relation components to Neo4j...")
            persist_to_neo4j(session, A_total, blocks)
        elif write and mode != "live":
            log.warning("--write ignored: refusing to persist synthetic data to Neo4j.")

    driver.close()

    dt = time.time() - t0
    report = {
        "metadata": {
            "script":     "measure_non_commutativity.py",
            "author":     "Dubhe",
            "team":       "Merak",
            "date":       datetime.now(timezone.utc).isoformat(),
            "mode":       mode,
            "seed":       seed if mode == "synthetic" else None,
            "scale":      scale if mode == "synthetic" else None,
            "neo4j_uri":  NEO4J_URI,
            "namespace_lean":  NAMESPACE_LEAN,
            "namespace_data":  NAMESPACE_DATA,
            "vertex_order":    VERTEX_ORDER,
            "charge_g":        CHARGE_G,
            "runtime_seconds": round(dt, 3),
            "wrote_neo4j":     bool(write and mode == "live"),
            "permissive":      bool(permissive),
        },
        "per_relation": per_rel_report,
        "A_total": {
            **matrix_to_flat(A_total),
            "hermitian_defect_frobenius": verify_hermitian(A_total, "A_total"),
            "trace": float(np.real(np.trace(A_total))),
            "eigenvalues_descending": full_spectrum,
        },
        "tests": tests,
    }
    return report


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Measure the 6x6 Magnetic Laplacian and its commutator spectrum "
                    "on the OmegaTheoryV2 Lean graph.",
    )
    p.add_argument("--mode", choices=["live", "synthetic"], default="live",
                   help="'live' reads Neo4j; 'synthetic' generates Poisson-dense data.")
    p.add_argument("--write", action="store_true",
                   help="Persist A and components back to Neo4j (only in 'live' mode).")
    p.add_argument("--dry-run", action="store_true",
                   help="Alias for --mode live without --write.")
    p.add_argument("--seed", type=int, default=42, help="Synthetic RNG seed.")
    p.add_argument("--scale", type=float, default=10.0, help="Synthetic density scale factor.")
    p.add_argument("--permissive", action="store_true",
                   help="Accept off-type edges (Phobos routes Structure/Instance/Namespace through "
                        "Definition/Theorem until :Structure label lands). Strict mode is the default.")
    p.add_argument("--results-path", default=RESULTS_PATH,
                   help="Where to dump the JSON results file.")
    return p.parse_args()


def main() -> int:
    args = parse_args()
    if args.dry_run:
        args.write = False
        args.mode = "live"

    try:
        report = run_analysis(mode=args.mode, write=args.write, seed=args.seed,
                              scale=args.scale, permissive=args.permissive)
    except Exception as e:
        log.exception("Analysis failed: %s", e)
        return 2

    print(json.dumps(report, indent=2))

    try:
        with open(args.results_path, "w") as f:
            json.dump(report, f, indent=2)
        log.info("Wrote JSON report -> %s", args.results_path)
    except OSError as e:
        log.error("Could not write results file %s: %s", args.results_path, e)
        return 3

    # Exit code: 0 success regardless of verdict (INSUFFICIENT_DATA is expected now);
    # 4 only when the graph connection fails earlier, which we caught above.
    return 0


if __name__ == "__main__":
    sys.exit(main())
