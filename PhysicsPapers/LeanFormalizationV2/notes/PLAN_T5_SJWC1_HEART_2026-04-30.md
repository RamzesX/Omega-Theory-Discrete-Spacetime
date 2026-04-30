# PLAN: T-5 SJWC-1 (smallJ analytical heart) UNCONDITIONAL DISCHARGE

## Target

**SJWC-1** = `T5_NAMED_index_at_q_strict_upper_bound`
File: `T5_Phase7_SmallJWitnessComposition.lean:53`

**Statement**:
```lean
∀ {m} ≥ 1, ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
  (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ),
  P ≠ 0 → 0 < ε →
  (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
  (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
  T5_DenominatorGrowthCondition q ε →
  T5_DegreeHeightBalanceCondition R q ε →
  rothIndex P (fun _ => α) R ≥ t →
  rothIndex P (fun i => ((q i : ℚ) : ℝ)) R <
    t - Real.sqrt ((m : ℝ) * ε) + ε / (m : ℝ)
```

**English**: under D.6.1 hypotheses, the multivariate Roth-index of P at the rational tuple q is STRICTLY less than t − √(mε) + ε/m, where t is the index at the α-diagonal.

**Why this matters**: SJWC-1 is the CORE analytical content of Hindry-Silverman §D.6.1 inner. Discharging it produces:
- Constrained smallJ via SJWC-1 + UWF-2 (existing CSJ-2)
- Combined with my V8R6 architecture, V8R6 → V8R5 (one less NAMED)
- Combined with REWIRE NAMED + RW-3, V8R5 unconditional → T-5 closer to UNCONDITIONAL

## Decomposition into 7 atomic sub-lemmas

Following Hindry-Silverman §D.6.1 + Ishak Uppsala 2008 §A6-A11.

### A1 — Multivariate Taylor expansion at α-diagonal
```lean
theorem T5_SJWC1_A1_Taylor_at_alpha
    {m : ℕ} (hm : 1 ≤ m) (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (q : Fin m → ℚ) :
    aeval (fun i => ((q i : ℚ) : ℝ)) P =
      ∑ J in P.support, MvPolynomial.coeff J P *
        ∏ i, ((q i : ℚ) : ℝ - α) ^ (J i) * α ^ (...)
```
**Dependencies**: existing `T5_Phase7_MvPolyTaylorAtIntPoint.lean` (W1-A) — multivariate Taylor at INT point, adapt to REAL α.
**Estimate**: ~80 lines.
**Risk**: MEDIUM — requires substitution-form ↔ expanded-sum bridge.

### A2 — Per-i violator factor bound
```lean
theorem T5_SJWC1_A2_per_i_violator_factor
    (α : ℝ) (ε : ℝ) (hε : 0 < ε)
    (q : ℚ) (hq : q ∈ T5_RothViolatingSet α ε) (k : ℕ) :
    |((q : ℚ) : ℝ) - α| ^ k ≤ ((q.den : ℝ)) ^ (-(2 + ε) * k)
```
**Dependencies**: definition of `T5_RothViolatingSet`.
**Estimate**: ~30 lines.
**Risk**: LOW — direct from violator definition + `Real.rpow` monotonicity.

### A3 — Combined per-i factor product
```lean
theorem T5_SJWC1_A3_product_factor_bound
    {m : ℕ} (α : ℝ) (ε : ℝ) (hε : 0 < ε)
    (q : Fin m → ℚ) (h_viol : ∀ i, q i ∈ T5_RothViolatingSet α ε)
    (J : Fin m → ℕ) :
    ∏ i, |((q i : ℚ) : ℝ) - α| ^ (J i) ≤
      ∏ i, ((q i).den : ℝ) ^ (-(2 + ε) * (J i : ℝ))
```
**Dependencies**: A2.
**Estimate**: ~40 lines.
**Risk**: LOW — Finset.prod_le_prod + A2.

### A4 — Multi-index pigeonhole
```lean
theorem T5_SJWC1_A4_pigeonhole_multi_index
    {m : ℕ} (hm : 1 ≤ m) (R : Fin m → ℕ) (hR_pos : ∀ i, 0 < R i)
    (t : ℝ) (ht_pos : 0 ≤ t)
    {S : Finset (Fin m → ℕ)} (hS : S.Nonempty) :
    ∃ J ∈ S, ∑ i, (J i : ℝ) / (R i : ℝ) ≤ S.sup (fun J' => ∑ i, (J' i : ℝ) / (R i : ℝ))
```
**Dependencies**: Finset basic.
**Estimate**: ~30 lines.
**Risk**: LOW — Finset.exists_max_image.

### A5 — AM-QM (Cauchy-Schwarz) for √m birth
```lean
theorem T5_SJWC1_A5_AM_QM_for_sqrt_m
    {m : ℕ} (a : Fin m → ℝ) (ha_nonneg : ∀ i, 0 ≤ a i) :
    (∑ i, a i) ≤ Real.sqrt ((m : ℝ) * ∑ i, (a i) ^ 2)
```
**Dependencies**: Mathlib `Finset.inner_mul_le_norm_mul_norm` or
`Finset.sq_sum_le_card_mul_sum_sq`.
**Estimate**: ~30 lines.
**Risk**: LOW — existing Mathlib AM-QM.

### A6 — Vanishing-derivative at α
```lean
theorem T5_SJWC1_A6_high_index_vanish
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ) (t : ℝ)
    (h_idx : rothIndex P (fun _ => α) R ≥ t)
    (J : Fin m → ℕ) (hJ : ∑ i, (J i : ℝ) / (R i : ℝ) < t) :
    aeval (fun _ => α) (multiIteratedPDeriv J P) = 0
```
**Dependencies**: existing `T5_rothIndex_lower_bound_implies_subthreshold_vanish` (D-pre-aux6).
**Estimate**: ~30 lines bridge.
**Risk**: LOW — direct Mathlib + existing.

### A7 — FINAL COMPOSITION
```lean
theorem T5_SJWC1_unconditional :
    T5_NAMED_index_at_q_strict_upper_bound := by
  -- Combine A1 (Taylor) + A2/A3 (factor bounds) + A4 (pigeonhole) +
  -- A5 (AM-QM) + A6 (high-index vanish) to get the bound.
  -- The KEY identity: rothIndex P at q ≤ ∑ J_min_i / R_i,
  -- where J_min_i is chosen via pigeonhole + AM-QM.
  ...
```
**Dependencies**: A1, A2, A3, A4, A5, A6.
**Estimate**: ~80 lines.
**Risk**: MEDIUM — composition heavy.

**Total**: 7 sub-lemmas, ~320 lines. 5 LOW-risk + 2 MEDIUM-risk.

## Agent dispatch plan

5 opus-code-crawler agents in parallel, each on one independent sub-lemma:
- **Agent A1**: A1 Taylor expansion at real α (most complex, MEDIUM risk)
- **Agent A2-A3**: A2 + A3 per-i factor bounds (LOW risk, both simple, can be done by one agent)
- **Agent A4**: A4 multi-index pigeonhole (LOW risk)
- **Agent A5**: A5 AM-QM (LOW risk)
- **Agent A6**: A6 high-index vanish (LOW risk bridge)

Each agent:
1. Reads the plan file + relevant existing OV2 infrastructure
2. Writes a NEW file `T5_Phase7_SJWC1_<sub-lemma-name>.lean` with proof
3. Builds at `~/lean-v2`, mirrors to `/mnt/c`, commits
4. Reports back

After all 5 agents complete, I write A7 (FINAL COMPOSITION) in the main file `T5_Phase7_SJWC1_FullDischarge.lean` and discharge SJWC-1 unconditionally.

## TODO list

1. Plan file (this file) — DONE
2. Spawn agent A1: A1 Taylor at α
3. Spawn agent A2-A3: per-i factor bounds (2 lemmas one agent)
4. Spawn agent A4: multi-index pigeonhole
5. Spawn agent A5: AM-QM
6. Spawn agent A6: high-index vanish
7. (Wait for agents to complete in parallel)
8. Write FINAL composition A7 in main file
9. Refresh graph (so new theorems are in Neo4j for Yoneda bridges)
10. Yoneda bridge sweep (find_similar on each new theorem >0.85)

## Graph refresh fix

After all SJWC-1 sub-lemmas land:
```
mcp__omega-orchestrator__refresh_graph(dry_run=False)
# poll job_status
# verify result.verify.missing_emb == 0
mcp__omega-orchestrator__axiom_audit(targets=[
  "T5_SJWC1_unconditional",
  "T5_NAMED_index_at_q_strict_upper_bound"
])
```

This ensures:
- All new theorems ingested into Neo4j
- find_similar returns non-empty results for Yoneda bridges
- Architectural work persists across sessions

## References

- Hindry-Silverman *Diophantine Geometry* §D.6.1
- Ishak Uppsala 2008 §A6-A11 (`/tmp/ishak_thue_siegel_roth.txt`)
- LeVeque-Cassels Ch.5 (`/tmp/cassels_chapter5_roth_lemma.txt`)
- Existing OV2 infrastructure:
  - `T5_Phase7_MvPolyTaylorAtIntPoint.lean` (W1-A multivariate Taylor)
  - `T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish.lean` (D-pre-aux6 vanish)
  - `T5_Phase7_HEART_Sublemmas_Decomposition.lean` (this fire's distinct/inj/skip)
  - `T5_Phase7_BlockAB_D4_PigeonholeSequence.lean` (D4 chain)
