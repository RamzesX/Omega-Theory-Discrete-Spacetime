# Neo4j Schema Completeness Pass — pi_sun namespace

**Session 15, 2026-04-14 — Claude Opus 4.6 team (team-lead spec for neo4j-curator Task #27)**

This document specifies the final completeness extension of the `pi_sun` Neo4j namespace. After the 127-node / 330-edge structural skeleton landed at end of Session 15, six categories of missing genealogy were identified. This spec drives the extension to the target ~200 nodes / ~500 edges.

All writes use `MERGE` (idempotent) and carry `namespace: 'pi_sun'`.

---

## Category 1 — Citation nodes

New `EntityNavigator:CitationLayer` under `NavigationMaster`. Leaf nodes `ConcreteImpl:Citation` for each external reference cited across the project's 9 papers + 15 markdown modules.

### Target citation list (34 refs)

| Node name | Authors / Year | Venue or arxiv |
|---|---|---|
| `Lindemann_1882` | F. Lindemann, 1882 | Math. Ann. 20 |
| `Siegel_1929` | C.L. Siegel, 1929 | Abh. Preuss. Akad. Wiss. |
| `Shidlovskii_1956` | A.B. Shidlovskii, 1956 | E-function theorem |
| `Euler_1737` | L. Euler, 1737 | CF of e |
| `Lagrange_1770` | J.-L. Lagrange, 1770 | Quadratic CF characterisation |
| `Carlitz_1935` | L. Carlitz, 1935 | Carlitz module |
| `Mahler_1929` | K. Mahler, 1929 | U/T/S classification |
| `Mahler_1953` | K. Mahler, 1953 | Specialization theorem |
| `Nesterenko_1996` | Y. Nesterenko, 1996 | C.R. Acad. Sci. Paris 322 |
| `Nishioka_1996` | K. Nishioka, 1996 | Mahler specialization |
| `Beukers_1981` | F. Beukers, 1981 | ζ(3) irrationality |
| `Ball_Rivoal_2001` | Ball–Rivoal, 2001 | ζ(2k+1) irrationality |
| `Rivoal_2000` | T. Rivoal, 2000 | ζ(2k+1) |
| `Bombieri_Vaaler_1983` | Bombieri–Vaaler, 1983 | Invent. Math., adelic |
| `Schmidt_1972` | W.M. Schmidt, 1972 | Acta Math. 131 |
| `Evertse_1984` | J.-H. Evertse, 1984 | Schmidt effectivity |
| `Faltings_1991` | G. Faltings, 1991 | Ann. Math. 133 — product theorem |
| `Hata_1993` | M. Hata, 1993 | Irrationality measures |
| `Pellarin_2008` | F. Pellarin, 2008 | |
| `Wirsing_1974` | E. Wirsing, 1974 | Gauss-map mixing |
| `Adamczewski_Bugeaud_2005` | B. Adamczewski, Y. Bugeaud, 2005 | Ann. Math., automatic numbers |
| `ADH_2016` | Adamczewski–Dreyfus–Hardouin, 2016 | arXiv:1607.00793 |
| `Dettweiler_Reiter` | Dettweiler–Reiter | arXiv:math/0512078, motivic |
| `Sabbah_Yu` | Sabbah–Yu | Irregular Hodge |
| `Salikhov_2008` | V.K. Salikhov, 2008 | Russian Math. Surveys, μ(π) |
| `Zeilberger_Zudilin_2020` | Zeilberger–Zudilin, 2020 | Moscow J. Combinatorics |
| `FA_2023` | Faverjon–Adamczewski, 2023 | arXiv:2303.05997 |
| `FA_2025` | Faverjon–Adamczewski, 2025 | arXiv:2502.09999 |
| `FA_2026` | Faverjon–Adamczewski, 2026 | arXiv:2604.08208 |
| `Estienne_2026` | Estienne, 2026 | arXiv:2603.18832 |
| `DiVizio_Pellarin_2026` | Di Vizio–Pellarin, 2026 | arXiv:2508.21237 |
| `Andre_2024` | Y. André, 2024 | arXiv:2501.09867 |
| `Nesterenko_Philippon_2001` | Nesterenko–Philippon, 2001 | Panoramas et Synthèses |
| `Kontsevich_Zagier` | Kontsevich–Zagier | Periods |

### Edges
For each paper/module, read its References section and emit `Paper -CITES→ Citation`.

---

## Category 2 — Sessions 1–15

Linear timeline. New `ConcreteImpl:Session` nodes with `NEXT→` chaining.

### Session titles and leads

| Session | Title | Lead | Date (UTC) |
|---|---|---|---|
| 1 | Foundation and predictor hierarchy | Gauss | 2026-04-13 |
| 2 | SS reduction + Decoupling Theorem | Gauss | 2026-04-13 |
| 3 | Attempts 11–15 + FA Specialization | Gauss | 2026-04-13 |
| 4 | HP × Liouville correction (Module 08→09) | Gauss | 2026-04-13 |
| 5 | FA BLOCKED by Decoupling, G_Gauss correction | Gauss | 2026-04-13 |
| 6 | Attack 19 pre-Siegel HP introduced | Rigel | 2026-04-14 |
| 7 | PSLQ falsifiability suite for Conj 4A.4 | Claude Opus 4.6 team | 2026-04-14 |
| 8 | Slice-change rescue — GAP_F closed, F54 discovered | Claude Opus 4.6 team | 2026-04-14 |
| 9 | Lean Phase 1 — Decoupling + PiStratum | lean-formalizer | 2026-04-14 |
| 10 | Arb-rigorized bounds | slice-attacker | 2026-04-14 |
| 11 | Attack 13 F27 ord_p dichotomy confirmed | attack-researcher | 2026-04-14 |
| 12 | Attack 12 Carlitz-Frobenius numerical support | attack-researcher | 2026-04-14 |
| 13 | Triple agent sweep — motivic, panorama, F49 Lean | Opus team | 2026-04-14 |
| 14 | Opus team batch — Module 15 parity law + 4 companion papers + F50/F54 Lean | Opus team | 2026-04-14 |
| 15 | Attacks 20/21/22 + F51 Lean + Paper-F54 + 79/79 parity definitive | Opus team | 2026-04-14 |

### Edges
- `Session_N -NEXT→ Session_{N+1}`
- Each Module / Target / LeanTheorem `-BELONGS_TO_SESSION→` its Session, derived from the `session` property already stored.

---

## Category 3 — Tools

New `EntityNavigator:ToolLayer` under `NavigationMaster`. Leaf `ConcreteImpl:Tool` nodes.

| Tool | Version | Install | Role |
|---|---|---|---|
| `Python_3_12` | 3.12.3 | pre-installed in WSL | driver language |
| `sympy` | 1.14.0 | `pip` | exact rational arithmetic + nullspace |
| `mpmath` | 1.3.0 | `pip` | arbitrary-precision floats + PSLQ |
| `python_flint` | 0.8.0 | `pip3 install --user --break-system-packages python-flint` | Arb ball arithmetic |
| `PARI_GP` | 2.15.4 | `sudo apt install -y pari-gp` | lindep, algdep, modular |
| `Lean` | 4.29.1 | via `elan` | formal proof assistant |
| `Mathlib` | v4.29.0 | via `lake` | standard lib |
| `Neo4j_Enterprise` | 2026.03 | Docker container `math` | knowledge graph |
| `mcp_neo4j_cypher` | latest via uvx | `uvx mcp-neo4j-cypher@latest ...` | MCP server |
| `Docker` | per WSL | — | container runtime |
| `uvx` | — | `pip install uv` | isolated Python exec |

### Edges
- Each `Target -USES_TOOL→ Tool` inferred from `tool` property
- `LeanTheorem -USES_TOOL→ Lean, Mathlib` for each
- `Target_F2 / Target_F2b -USES_TOOL→ PARI_GP`
- `Target_B_rigorous / Target_S8_rigorous_1_3 -USES_TOOL→ python_flint`

---

## Category 4 — Facts F1–F48

Currently modelled: F27, F49–F55 plus F52_p3_rescue, F54_parity_refinement. Missing: F1–F26 (some), F28–F48.

### Minimum must-have list (from README "Proof Status at a Glance")

| Fact | Meaning | Status | Module |
|---|---|---|---|
| `F25_G_jet_flat` | G-jet reduces to Grothendieck Period Conjecture, reformulation only | DEAD | Module 11 |
| `F26_Frobenius_Mahler_eq` | Frobenius product Φ(z) satisfies Mahler eq | PROVEN | Attack 12 / Module 05 |
| `F28_BSL2_motivic_dim5` | B×SL₂ motivic Galois dim 5, stabiliser dim 2 | PROVEN | Attack 14 |
| `F38_System_B_degenerate` | System B {1,f,f',g,zg} degenerate | PROVEN | Module 09 |
| `F39_System_C_rate` | System C rate ≈ 4.5/N | COMPUTED | Module 09 |
| `F40_HP_heights_exp10N` | HP heights ~ exp(10N) | PROVEN | Module 09 |
| `F41_comparison_sigma_nup1` | Comparison needs ρ^{m-1} > σ^{ν+1} | PROVEN | Module 09 |
| `F42_sigma_to_e2` | σ → e² via PNT | PROVEN | Module 09 |
| `F43_min_m_9` | (1+√2)^8 > e^6 → min m=9 | PROVEN | Module 09 |
| `F44_second_solution_algebraic` | z^(-1/2) algebraic at correct hypergeometric | CORRECTED | Module 10 |
| `F45_B_connected` | Borel connected → no common quotient | PROVEN | Module 10 |
| `F46_combined_solvable` | B × (G_a ⋊ Z/2Z) entire solvable | PROVEN | Module 10 |
| `F47_FA_siegel_blocked` | FA ou→et Siegel step blocked | BLOCKED | Module 10 |
| `F48_product_specialization_circular` | Product spec = alg-ind, circular | PROVEN | Module 10 |

### Edges
- `Module -DOCUMENTS→ Fact` for each fact discussed in that module
- `Attack -USES_FACT→ Fact` where the attack invokes the fact

---

## Category 5 — Axioms

Lean axioms + Mathlib primitives.

| Axiom node | Status | Citation |
|---|---|---|
| `Real_pi_transcendental` | `CITED_AS_AXIOM` | `Lindemann_1882` |
| `propext` | `STANDARD_MATHLIB` | — |
| `Classical_choice` | `STANDARD_MATHLIB` | — |
| `Quot_sound` | `STANDARD_MATHLIB` | — |

### Edges
- `PiStratum_lean -USES_AXIOM→ Real_pi_transcendental`
- All 6 Lean files `-USES_AXIOM→ propext, Classical_choice, Quot_sound`
- `Real_pi_transcendental -CITED_FROM→ Lindemann_1882`

---

## Category 6 — Per-theorem sub-nodes

Each Lean file decomposes into individual theorems. Create `ConcreteImpl:TheoremInFile` leaves:

| Parent file | TheoremInFile leaves | Count |
|---|---|---|
| `Decoupling_lean` | `decoupling_scalar`, `decoupling`, `decoupling_matrix` | 3 |
| `PiStratum_lean` | `pi_stratum_integer`, `pi_stratum_vector` | 2 |
| `F49_Existence_lean` | `F49_existence_matrix`, `F49_existence_pade` | 2 |
| `F50_Decay_lean` | `taylor_tail_bound`, `F50_decay_algebraic` | 2 |
| `F54_SlicePrime_lean` | `pochhammer_num_coprime`, `F54_slope_minus_one` | 2 |
| `F51_Denominator_lean` | `common_denom_divides_finset_lcm`, `common_denom_clears_to_int`, `F51_Pade_denominator_bound` | 3 |

### Properties
- `name`, `signature` (short), `session`, `status: PASSING_0_SORRIES`

### Edges
- `TheoremInFile -CONTAINED_IN→ LeanTheorem` parent
- `TheoremInFile -USES_AXIOM→ Axiom` for each axiom invoked
- All PiStratum theorems additionally `-USES_AXIOM→ Real_pi_transcendental`

---

## Expected final state

- **Before**: 127 nodes / 330 edges
- **After completeness pass**: ~200 nodes / ~500 edges
- **Categories**: +8 EntityNavigator levels (CitationLayer, ToolLayer, plus 6 new ConcreteImpl types: Citation, Session, Tool, Fact extras, Axiom, TheoremInFile)

## Reporting protocol

For each of the 6 categories, `neo4j-curator` prints the per-category node and edge delta. If any single category adds more than 50 nodes or 150 edges, it stops early and flags. At the end, `StatusReport_Session15` is updated with the new totals and the completeness pass is declared complete.

---

*Document written as part of Task #27 (completeness pass), Session 15, 2026-04-14. Claude Opus 4.6 team, team-lead spec for neo4j-curator execution.*
