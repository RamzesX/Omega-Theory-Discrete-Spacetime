# T-5 V8 — 7-NAMED-Leaf-Relaxed Decomposition (Post-Fire 2026-04-30)

**Status**: V8 closure path further restructured this fire. The previous
5-NAMED (smallJ-witness + V7-N1-uniform + SM-1/2/3) decomposition is
NOW factored into a 7-NAMED-relaxed form with finer-grained analytical
leaves.

## 7-NAMED Decomposition (post-fire)

| # | NAMED Leaf | Risk | Discharge plan | Status |
|---|---|---|---|---|
| 1 | `T5_NAMED_index_at_q_strict_upper_bound` (SJWC-1) | HEART | Output of H_a + H_b + H_c-1..4 + AM-QM √m birth chain (all helpers DONE) | OPEN |
| 2 | `T5_NAMED_universal_aeval_witness` (V8DS-1) | Tier-99 | P ≠ 0 ⇒ ∃ J in P.support coeff ≠ 0; Schmidt aux degree-bound | OPEN |
| 3 | `T5_NAMED_BlockC_Taylor_upper_bound_uniform` (V7-N1) | HEART | Taylor decay with κ > 1; D2 + D4 + composition | OPEN |
| 4 | `T5_NAMED_Schmidt_aux_int_poly` (SM-1) | MED | Mathlib SiegelsLemma + restrictDegree lift | OPEN |
| 5 | `T5_NAMED_Schmidt_balance_per_n` (SM-2) | HARD | R-aware q_seq (d_i ≈ exp(C/R_i)) | OPEN |
| 6 | universal aeval-witness for ℤ-polys (SM-3 sub-leaf) | Tier-99 | P_int ≠ 0 + generic q rationality | OPEN |
| 7 | relaxed-form δ → 0 limit | LOW | Real-analytic limit: ε/m → 0 as ε → 0 | OPEN |

## Composition Path

```
SJWC-1 + universal-witness ⇒ relaxed smallJ witness  [V8AS-2]
                                ↓
SM-1 + SM-2 + (universal-aeval-ℤ ⇒ SM-3)  [SM3PD-1]
                                ↓
relaxed smallJ + V7N1U + SM-1 + SM-2 + SM-3  ⇒  V8 paper headline V8 (relaxed)
                                ↓
δ → 0 limit  ⇒  V8 paper headline V8 (strict)
                                ↓
T-5 UNCONDITIONAL = `omega_theory_v2_T5_roth_unconditional`
```

## Files this fire (8 commits, ~98 jobs added)

- `T5_Phase7_PigeonholeTaylorOffsets.lean` (H_c-2 — 86 lines)
- `T5_Phase7_RootMBirth.lean` (H_c-4 √m birth — 117 lines)
- `T5_Phase7_SmallJWitnessFromIndexBound.lean` (H_c-5 — 110 lines)
- `T5_Phase7_SmallJWitnessComposition.lean` (SJWC factoring — 140 lines)
- `T5_Phase7_HcBundleHeadline.lean` (H_c paper bundle — 66 lines)
- `T5_Phase7_SJWC2_Discharge.lean` (SJWC-2 partial — 95 lines)
- `T5_Phase7_V8AtomOne_via_SJWC.lean` (V8-atom-1 path — 90 lines)
- `T5_Phase7_SM3_PartialDischarge.lean` (SM-3 partial — 90 lines)
- `T5_Phase7_V8_DecompositionStatus.lean` (7-NAMED status — 95 lines)

Build delta: 4637 → 4735 GREEN (+98 jobs).

## Strategic Insight

The 7-NAMED form exposes the architecture more clearly:
- **2 Tier-99 leaves** (universal-witness for ℝ, universal-aeval for ℤ)
  are routine non-degeneracy facts.  The Schmidt aux poly construction
  (SM-1) provides the relevant non-degeneracy by degree-bound.
- **2 HEART leaves** (SJWC-1 analytical heart, V7N1U Taylor decay)
  are the genuine analytical content.
- **3 SM leaves** (SM-1 Siegel, SM-2 balance, SM-3 aeval-nonzero) carry
  the Schmidt construction.
- **1 LOW-risk leaf** (δ → 0 limit) is real-analytic finalization.

The previous 5-NAMED form bundled "smallJ witness" and "rothIndex set
non-emptyness" together; the 7-NAMED form separates them cleanly.

## Next fires

Priority order:
1. SJWC-1 analytical heart discharge (HEART, ~150-300 lines)
2. SM-1 SiegelsLemma + restrictDegree lift (MED, ~150 lines)
3. universal-witness Tier-99 discharge (~50 lines)
4. universal-aeval-ℤ Tier-99 discharge (~50 lines)
5. δ → 0 limit packaging (~80 lines)
6. SM-2 R-aware q_seq retuning (HARD, ~200 lines)
7. V7N1U full composition (HEART, ~200 lines)

Estimated remaining: ~1000 lines, 6-10 single-thread fires to V8
unconditional.

## Sources

- `~/.claude/plans/binary-painting-dijkstra.md` — T-5 plan v2 + addendum 2026-04-30 v5
- `notes/NOTES_T5_5_NAMED_LEAVES_DISCHARGE_PLAN_2026-04-30.md` — 5-NAMED V8 architecture
- Hindry-Silverman §D.6.1 + §D.7 — original Roth's lemma decomposition
- Ishak Uppsala 2008 A1-A13 — pedagogical port (`/tmp/ishak_thue_siegel_roth.txt`)
