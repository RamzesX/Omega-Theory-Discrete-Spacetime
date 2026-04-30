# T8 — T-5 Closure Resume

**Status**: DEFERRED post-infra | **Effort**: 3-7 days with new infra
**Current state**: V8-atom-1 strict ⇐ TC1-monomial ✓ (commit 3eed094) + Hi-Glue (residual)

## Remaining residuals

| # | Residual | Form | Discharge plan |
|---|---|---|---|
| 1 | **Hi-Glue** (V8-atom-1 heart) | `T5_NAMED_N3c_HiGlue_pigeon_AM_QM_balance_growth` | ~150-250 lines via A2/A3/A4/A5 + balance/growth + TC-1 + UWF-1 transfer |
| 2 | V7N1U-D5 monolithic (V7-atom-2) | `T5_NAMED_V7N1U_D5_kappa_composition` | ~200 lines analytical (Taylor κ-decay) |
| 3 | SM-1 Schmidt aux integer poly | `T5_NAMED_Schmidt_aux_int_poly` | Siegel + restrictDegree lift |
| 4 | SM-2 Schmidt balance per-n | `T5_NAMED_Schmidt_balance_per_n` | R-aware q_seq retuning |
| 5 | SM-3 Schmidt aeval-nonzero | `T5_NAMED_Schmidt_aeval_nonzero_per_n` | universal-aeval-ℤ via UWF chain |

## Tools that didn't exist before (use NOW)

- **T2 goal-embedding** + **T4.2 `goal_to_premises`**: live retrieval at each `lake build` failure
- **T4.2 `goal_to_proof_step`**: find analogous AM-QM √(mε) birth in corpus
- **T4.1 `propose_conjecture`**: surface analogous Schmidt aux constructions in Mathlib
- **T6.4 reflective repair loop**: codified failure-recovery
- **T6.10 conjecture generation**: variants per landed theorem
- **T6.8 SubGoal DSL**: explicit Suppose/Define/ShowBy/Conclude for clarity

## Expected speedup

- Old (manual): Hi-Glue ~ 5-7 fires
- New (with infra): Hi-Glue ~ 2-3 fires (50-60% reduction)
- Old V7N1U + 3 SM: ~ 10-15 fires
- New: ~5-7 fires

Total T-5 closure: ~3-7 days with infra (vs ~2-3 weeks without)

## V8 capstone target

```lean
theorem omega_theory_v2_T5_roth_paper_headline_V8 : RothTheorem
```

With axiom_audit returning `[propext, Classical.choice, Quot.sound]` ONLY.

This is the **second first-of-kind Lean 4 formalization** in OV2 (after T-4 π transcendence). Diophantine Roth has never been formalized in any prover.
