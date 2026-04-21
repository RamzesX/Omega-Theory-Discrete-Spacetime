# 12 — Graph register: the live `:TheoremCandidate` + `:GraphFinding` nodes

This memo pins the Neo4j nodes created in this session. Future agents can query the graph directly:

```cypher
MATCH (n:TheoremCandidate {namespace:'OmegaTheoryV2', scope:'IrrationalityClasses', registered_by:'Rasalas'})
RETURN n.name, n.status, n.class_target, n.difficulty, n.session_estimate, n.mathlib_gap
ORDER BY n.session_estimate ASC, n.name ASC
```

## 31 `:TheoremCandidate` nodes registered

### Provable today (7)
| Name | Target | Sessions |
|---|---|---:|
| `ic_pi_gt_three_numeric` | Layer1_Pairwise | 0.5 |
| `ic_e_lt_pi_numeric` | Layer1_Pairwise | 0.5 |
| `ic_sqrt2_lt_e_numeric` | Layer1_Pairwise | 0.5 |
| `ic_catalanG_lt_one` | Layer1_Pairwise | 1.0 |
| `ic_four_irrationals_pairwise_distinct` | Layer1_Pairwise headline | 2.0 |
| `ic_catalanG_pos` | Catalan_infra | 1.0 |
| `ic_sqrt2_is_algebraic` | Layer2_Alg_vs_Trans | 1.0 |

**Total provable-today: 7 candidates, 6.5 sessions.**

### Provable today with more work (4)
| Name | Target | Sessions |
|---|---|---:|
| `ic_catalanG_definition_summability` | Catalan_infra | 3.0 |
| `ic_trunc_origin_inductive` | Layer4_4Origin | 5.0 |
| `ic_omega_four_origin_separation` (headline Layer 4) | Layer4 | 5.0 |
| `ic_e_irrational_via_Euler` | Catalan_infra | 1.0 |

### Statement-ready, blocked on axiom / upstream (4)
| Name | Target | Sessions | Blocker |
|---|---|---:|---|
| `ic_pi_transcendental_wrap` | Layer2 | 0.5 | Mathlib Lindemann port |
| `ic_three_constants_transcendental` | Layer2 headline | 2.0 | Layer2 axioms or port |
| `ic_separation_theorem_headline` | ALL_LAYERS | 5.0 | Layers 1-4 ready |
| `ic_e_vs_pi_E_function_separation` | Layer3 | 5.0 | Layer 3 framework |

### Blocked on Mathlib port (12)
| Name | Target | Sessions | Blocker |
|---|---|---:|---|
| `ic_exp_one_transcendental` | Layer2 | 20 | Hermite 1873 port |
| `ic_Hermite_1873_port_to_Mathlib` | Lindemann_upstream | 25 | Mathlib contribution |
| `ic_Lindemann_Weierstrass_to_Mathlib` | Lindemann_upstream | 10 | Mathlib contribution |
| `ic_EFunction_structure_def` | Layer3 | 12 | coefficient-height + growth infra |
| `ic_e_is_E_function_value` | Layer3 | 8 | E-function framework |
| `ic_pi_is_not_E_function_value` | Layer3 | 30 | E-function + classification |
| `ic_Shidlovsky_theorem_port` | E_function_upstream | 60 | Siegel-Shidlovsky port |
| `ic_irrationality_measure_framework` | Mahler_framework | 25 | μ in Mathlib |
| `ic_Roth_theorem_port` | Mahler_framework | 35 | Roth port |
| `ic_Mahler_classification_framework` | Mahler_framework | 80 | Mahler port |
| `ic_e_Mahler_S_with_omega_eq_1` | Mahler_framework | 15 | Mahler port |
| `ic_sqrt2_Mahler_A_class` | Mahler_framework | 2 | Mahler port |
| `ic_rivoal_zudilin_2003_port` | Rivoal_Zudilin | 60 | Hermite-Pade + RZ construction |

### Classical open / research-frontier (4)
| Name | Target | Sessions | Status |
|---|---|---:|---|
| `ic_catalanG_irrationality_conjecture` | Classical_open | ∞ | OPEN_PROBLEM |
| `ic_catalanG_Mahler_S_conditional` | Mahler_framework | ∞ | CONJECTURAL (cascades from irrationality) |
| `ic_pi_Mahler_S_conditional` | Mahler_framework | ∞ | CONJECTURAL |

## 4 `:GraphFinding` nodes registered

| Name | Paper-worthy? | Summary |
|---|---|---|
| `rasalas_IC_four_origin_separation_design` | ✅ yes | Mahler cannot cleanly separate {π, e, √2, G}; refined to TruncOrigin constructors → 4 distinct cells |
| `rasalas_IC_catalanG_irrationality_is_open` | ✅ yes | Catalan G irrationality still open (Zudilin 2019); counter-factual if G rational |
| `rasalas_IC_class_ordering_vs_asymptotic_ordering` | no | Class ordering (qualitative, incomparable cells) distinct from asymptotic ordering (numerical scalars) |
| `rasalas_IC_mahler_pi_e_share_class_S` | ✅ yes | π and e both conjecturally S-class, so nominal "4 Mahler classes" target is FALSE — refined to TruncOrigin |

## Sanity-check query

```cypher
MATCH (tc:TheoremCandidate {namespace:'OmegaTheoryV2', scope:'IrrationalityClasses'})
RETURN tc.status AS status, count(tc) AS n
ORDER BY n DESC;
-- Expected:
-- BLOCKED_ON_MATHLIB      11
-- PROVABLE_TODAY           8
-- STATEMENT_READY          4
-- CONJECTURAL              3  (including 2 Mahler conditionals)
-- BLOCKED_ON_FRAMEWORK     3
-- OPEN_PROBLEM             1
-- (boundary cases may land in different buckets — verify live)
```

## How to use this register in future cycles

1. **Cycle 44 start**: query for `PROVABLE_TODAY` and pick low-session items.
2. **Mathlib PR tracking**: when a Mathlib contribution lands (e.g., Lindemann), update the relevant nodes' `status` to `PROVABLE_NOW` and the blocker field to `'cleared'`.
3. **Paper writeup**: quote `:GraphFinding` summaries verbatim (they're already paper-style prose).

## Audit trail

All 31 `:TheoremCandidate` + 4 `:GraphFinding` nodes carry:
- `registered_by: 'Rasalas'`
- `registered_at: <datetime>`
- `session_date: '2026-04-21'`
- `scope: 'IrrationalityClasses'`

This makes the register reproducible and attributable.
