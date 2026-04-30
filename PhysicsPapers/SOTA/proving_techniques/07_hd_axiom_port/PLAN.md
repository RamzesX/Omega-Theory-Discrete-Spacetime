# T9 — HermitePadé / Nesterenko_1996 Axiom Port

**Status**: DEFERRED parallel | **Effort**: 2-4 weeks | **Priority**: paper-headline target

## Goal

Port `OmegaTheory.Irrationality.HermitePade.Nesterenko_1996` axiom (the LAST remaining axiom in the OV2 graph) to UNCONDITIONAL Lean 4 proof.

This is the analogue of T-4's `Real.pi_transcendental` retirement (commit c0ab2b7, single day for π — but π had Mathlib L-W partial; HD has nothing upstream).

## Strategy: 5-PHASE HYBRID + frontier V2

1. **Phase A** — state the harder theorem with NAMED hypotheses (Siegel-Shidlovskii structure, Mahler framework)
2. **Phase B** — truth-rank: routine cleanups (factorial bounds, contour integrals) Tier-99; Wronskian non-vanish + denominator bounds Tier-80; the genuine analytical heart (Hermite-Padé approximant convergence) Tier-Heart
3. **Phase C** — discharge per tier
4. **Phase D** — bottom-up: Lean 4 contour integration primitives if missing in Mathlib
5. **Phase E** — compose + Yoneda bridge + axiom_audit

## References

- Nesterenko, "Modular functions and transcendence questions" (1996)
- Siegel-Shidlovskii framework (already in `HermitePade/SiegelShidlovskiiSubLemmas.lean`)
- Mahler, "Lectures on Transcendental Numbers" (1976)
- Existing HermitePadé infra: `~/lean-v2/OmegaTheory/Irrationality/HermitePade/F27, F50, F51, F56, etc.lean`

## Why deferred

Apply NEW infra (T1-T7) first. The hybrid retrieval + goal-state checkpoints + propose_conjecture + goal_to_proof_step will significantly accelerate this porting.

T-4 took 1 day with limited tools. T-9 with full SOTA infra should take ~2-4 weeks. Without infra: ~6-12 weeks.

## Agent

Use `irrationality-hunter-v2` (T7.2) once shipped.
