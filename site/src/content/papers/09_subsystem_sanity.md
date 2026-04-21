---
title: "09 — Subsystem sanity check"
description: "Detected subsystems vs expected OmegaTheory physics themes (Foundations, Irrationality, Gauge, Emergence, Predictions, Conservation)."
category: "Graph Research · Neo4j"
order: 118
---

<!-- orig-frontmatter: name: 09_subsystem_sanity -->
<!-- orig-frontmatter: parent: OmegaTheoryAlgebra -->
<!-- orig-frontmatter: phase: 1 -->
<!-- orig-frontmatter: author: Dubhe (α Ursae Majoris) -->
<!-- orig-frontmatter: team: Merak -->
<!-- orig-frontmatter: date: 2026-04-18 -->
<!-- orig-frontmatter: status: DRAFT — placeholders for Grothendieck + Erdős pipeline output -->
# 09 — Subsystem Sanity Check

**TL;DR.** Once the Grothendieck algebraic-topology sheaf + the Erdős community-detection pipeline have run over the populated OmegaTheory + Mathlib graph, this file audits whether the **detected subsystems** (spectral clusters in the Magnetic Laplacian + FastRP embedding space) line up with the **human-known physics themes** of OmegaTheory. The target overlap is ≥ 70 %. Today the pipeline hasn't run — all numeric sections below are placeholders with explicit `TBD` markers.

---

## 1. Methodology

The subsystem detector runs in three stages (per memo `06_fastrp_scaling.md` + `07_single_lens_rationale.md`):

1. **FastRP embedding** over the 15-relation Magnetic Laplacian components. Dimension d = 256 (to match V3 HypatiaBasis §8.1). Per-relation α_k weights are measured from edge counts (file 04 §4.1).
2. **Spectral clustering** using the top-K eigenvectors of 𝔄. The expected rank (after data lands) is 4 per memo 05 §4; we pick K = 6 to include decaying modes.
3. **Grothendieck cohomology layer** (SheafContext over the typed-arrow quiver) to detect non-trivial subsystem boundaries where locally-agreed embeddings fail to glue globally. Output: a set of `SubsystemNavigator` nodes, each with `name`, `physics_theme`, `member_nodes_count`, and `cohomology_class`.

Expected count: **12 – 25** SubsystemNavigator nodes, matching V3's 17 ± 5 subsystems in CheckItOut.

---

## 2. Expected physics themes (ground truth from OmegaTheory)

These 9 themes are the human-curated physics domains in OmegaTheory V2 (from `PhysicsPapers/CLAUDE.md` §module index). Each is covered by one or more Lean sub-directories and should emerge as ≥ 1 detected subsystem:

| # | Physics theme           | Lean directory                              | Expected subsystem(s)          |
|---|-------------------------|---------------------------------------------|--------------------------------|
| 1 | Foundations             | `Foundations/Error*`                        | 1 (error algebra core)         |
| 2 | Spacetime               | `Spacetime/{Lattice,Constants,Operators}`   | 1 – 2 (lattice + operators)    |
| 3 | Geometry                | `Geometry/{Metric,Curvature,Maxwell,Hodge}` | 2 – 3 (curvature, gauge)       |
| 4 | Emergence               | `Emergence/{Einstein,QM,Higgs,Inflation}`   | 3 – 5 (one per capstone)       |
| 5 | Predictions             | `Predictions/*.lean`                        | 1 (falsifiable-claims cluster) |
| 6 | Conservation            | `Conservation/{Info,Noether,Stress}`        | 1 – 2 (conservation laws)      |
| 7 | HealingFlow             | `HealingFlow/{Lyapunov,LaSalle}`            | 1 (dynamics + convergence)     |
| 8 | Torsion                 | `Torsion/{Spin,BigBounce}`                  | 1 (Popławski bounce)           |
| 9 | Irrationality / π-Hunch | `Irrationality/*.lean`                      | 1 (computational uncertainty)  |

**Total expected** ≥ 12 detected subsystems, ≤ 25 if the pipeline further splits Geometry or Emergence.

---

## 3. Overlap metric

For each detected `SubsystemNavigator` S, compute

- `S.member_nodes` = Theorems + Definitions clustered into S
- `theme_overlap(S, T)` = |{nodes in S that live under the Lean directory for theme T}| / |S.member_nodes|

The **assigned theme** for S is `argmax_T theme_overlap(S, T)` and the overlap score is the maximum itself.

Pipeline-level **match rate**:

```
match_rate = (# subsystems where assigned-theme-overlap ≥ 0.70) / (# total subsystems)
```

Target: `match_rate ≥ 0.70`. Below that, the algebra is over-decomposing (making too many artificial cuts) or the theme granularity is wrong.

---

## 4. Results (placeholders — to be filled by pipeline rerun)

### 4.1 Detected subsystem count

```
Total SubsystemNavigator nodes: TBD  (expected 12 – 25)
Pipeline runtime:               TBD seconds
Grothendieck cohomology rank:   TBD
```

### 4.2 Subsystem ↔ theme alignment table

| Subsystem name          | Member count | Assigned theme          | Overlap | Status |
|-------------------------|:------------:|-------------------------|:-------:|:------:|
| TBD_subsystem_01        | TBD          | TBD                     | TBD     | TBD    |
| TBD_subsystem_02        | TBD          | TBD                     | TBD     | TBD    |
| ...                     | ...          | ...                     | ...     | ...    |

### 4.3 Unexpected clusters

List of subsystems whose assigned theme has overlap < 0.70. Possible causes:

1. **Cross-cutting concern.** A Lean module like `Irrationality/PredictionsBridge.lean` legitimately spans "Irrationality" and "Predictions" themes. These should be flagged but not counted as failures.
2. **Nilpotent residue.** Subsystems dominated by arrows that don't sit in a cycle (USES, IMPORTS, INSTANTIATES) look like flat nilpotent blocks — not cleanly associated with any one physics theme.
3. **Miscalibration.** If a theme like "Emergence" over-fragments (5 + detected subsystems when only 3 expected), reduce K in spectral clustering.

### 4.4 Cohomology signature

Grothendieck sheaf detects obstructions to gluing local subsystem definitions globally. Expect `H¹(QuiverAlgebra) = 0` if the ontology is complete; any non-trivial class indicates a missing relation type (see Alt-C in `05_cycle_hypotheses.md`).

```
H^0 rank: TBD   (global sections — expect = number of connected components ≈ 1)
H^1 rank: TBD   (obstructions — expect 0; a non-zero rank predicts a 16th arrow type)
```

---

## 5. Sanity verdict (template)

- ✓ If `match_rate ≥ 0.70` AND `H¹ = 0` AND subsystem count ∈ [12, 25]:
  → the Magnetic Laplacian + FastRP + Grothendieck trio faithfully recovers OmegaTheory's human-curated physics map. Phase 0 is closed successfully.

- ✗ If `match_rate < 0.70`:
  → the spectral decomposition does not align with physics themes. Either (a) the Lean ontology has real latent structure that physics authors haven't articulated (interesting!), or (b) the algebra is leaking noise from nilpotent 𝒩-block arrows.

- ✗ If `H¹ ≠ 0`:
  → a missing arrow type (file 05 Alt-C). File a memo adding the candidate relation and re-run.

---

## 6. Current state (2026-04-18)

Neither the Grothendieck nor the Erdős pipeline has run on OmegaTheoryV2; both depend on:

- Phobos's Lean arrow extractor completing on at least Foundations + Irrationality modules.
- FastRP α_k weights measured from populated edge counts (currently 1 / 15 relations active).

Once those land, re-run:

```bash
# 1. Populate FastRP embeddings per relation
python3 run_fastrp_per_relation.py --dim 256

# 2. Spectral cluster
python3 spectral_subsystem_detector.py --k 6

# 3. Grothendieck cohomology layer
python3 run_grothendieck_sheaf.py

# 4. Emit SubsystemNavigator nodes + overlap report
python3 emit_subsystem_report.py --out 09_subsystem_sanity_results.json
```

Then fill §4 of this file from the JSON blob.

---

*Companion files:* `06_fastrp_scaling.md`, `07_single_lens_rationale.md`, `08_empirical_spectrum.md`.
