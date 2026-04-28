/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowQDenIdentity

  T-5 (Roth's theorem) — **Phase 7 ext #114: rpow q.den identity
  `(1/(M · q.den^d))^(1/k) = M^(-1/k) · q.den^(-d/k)` (cubic+
  chain Roth-form rewrite)**, sub session 559nnnnnnn — STRICT
  critical-path #316 (T-5) Phase 7 ext #114.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #113 (rpow reciprocal-product) with Real.rpow_natCast +
  Real.rpow_mul to give the Roth-form rewrite:

  For M > 0, q : ℚ, d : ℕ, k : ℕ, k ≥ 1:
    `(1 / (M · ((q.den : ℝ))^d)) ^ (1 / (k : ℝ))
       = M ^ (-(1 / (k : ℝ))) · ((q.den : ℝ)) ^ (-(d / (k : ℝ)))`

  This exposes the Roth-form structure `M^(-1/k) · q.den^(-d/k)`,
  setting up direct comparison with `M^(-1/k) · q.den^(-(2+ε))`
  via q.den exponent monotonicity.

  Single derivation:
  1. `T5_rpow_qden_roth_form_identity`: full Roth-form rewrite.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #114 — rpow q.den Roth-form identity.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowReciprocalProduct
import Mathlib.Data.Rat.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowQDenIdentity

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowReciprocalProduct

/-! ## Roth-form rewrite -/

/-- **🚨 Wave T5 session 559nnnnnnn — Roth-form rewrite identity**.

    For M > 0, q : ℚ, d : ℕ, k : ℕ:
      `(1 / (M · q.den^d))^(1/k) = M^(-1/k) · q.den^(-(d/k : ℝ))`. -/
theorem T5_rpow_qden_roth_form_identity
    (M : ℝ) (hM : 0 < M) (q : ℚ) (d k : ℕ) :
    (1 / (M * ((q.den : ℝ)) ^ d)) ^ (1 / (k : ℝ))
      = M ^ (-(1 / (k : ℝ))) * ((q.den : ℝ)) ^ (-((d : ℝ) / (k : ℝ))) := by
  -- q.den > 0 → (q.den : ℝ) > 0 → q.den^d > 0
  have hqden_pos : (0 : ℝ) < (q.den : ℝ) := by exact_mod_cast q.pos
  have hqden_d_pos : (0 : ℝ) < ((q.den : ℝ)) ^ d := pow_pos hqden_pos d
  -- Apply s113: (1/(a·b))^c = a^(-c) · b^(-c) with a = M, b = q.den^d, c = 1/k
  rw [T5_rpow_reciprocal_product M (((q.den : ℝ)) ^ d) hM hqden_d_pos (1 / (k : ℝ))]
  -- Goal: M^(-(1/k)) · (q.den^d)^(-(1/k)) = M^(-(1/k)) · q.den^(-(d/k))
  congr 1
  -- (q.den^d)^(-(1/k)) = q.den^(-(d/k))
  -- q.den^d = q.den^(d : ℝ) by Real.rpow_natCast
  rw [show ((q.den : ℝ)) ^ d = ((q.den : ℝ)) ^ ((d : ℕ) : ℝ) from by
    rw [Real.rpow_natCast]]
  -- (q.den^(d : ℝ))^(-(1/k)) = q.den^((d : ℝ) · -(1/k)) = q.den^(-(d/k))
  rw [← Real.rpow_mul hqden_pos.le]
  congr 1
  -- (d : ℝ) · -(1/k) = -(d/k)
  ring

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559nnnnnnn — T-5 Phase 7 ext #114:
    rpow q.den Roth-form identity**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #114.

    🏆 ROTH-FORM REWRITE — exposes `M^(-1/k) · q.den^(-d/k)` structure.

    Single derivation:
    1. `T5_rpow_qden_roth_form_identity` — full Roth-form rewrite.

    Strategy: apply ext #113 reciprocal-product with `a = M`, `b = q.den^d`,
    `c = 1/k`. Then convert `q.den^d` (Nat.pow) to `q.den^(d:ℝ)` (Real.rpow)
    via `Real.rpow_natCast`. Apply `Real.rpow_mul` to combine
    `(q.den^(d:ℝ))^(-(1/k)) = q.den^((d:ℝ) · (-(1/k)))`. Simplify with `ring`.

    Used in cubic+ chain to expose Roth-form structure for comparison
    with `q.den^(-(2+ε))`. Together with q.den exponent monotonicity
    (ext #111) and Roth budget condition `d/k < 2+ε`, gives
    `M^(-1/k) · q.den^(-(2+ε)) ≤ M^(-1/k) · q.den^(-d/k) ≤ |q-α|`.

    Mathlib usage: `T5_rpow_reciprocal_product` (ext #113),
    `Real.rpow_natCast`, `Real.rpow_mul`, `pow_pos`, `q.pos`, `ring`.

    Sub-lemma 287/N in T-1 (T-5 Phase 7 ext #114).  Lean-core only. -/
theorem session_559nnnnnnn_T5_phase7_rpow_qden_roth_form_identity_headline
    (M : ℝ) (hM : 0 < M) (q : ℚ) (d k : ℕ) :
    (1 / (M * ((q.den : ℝ)) ^ d)) ^ (1 / (k : ℝ))
      = M ^ (-(1 / (k : ℝ))) * ((q.den : ℝ)) ^ (-((d : ℝ) / (k : ℝ))) :=
  T5_rpow_qden_roth_form_identity M hM q d k

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowQDenIdentity
