/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowReciprocalProduct

  T-5 (Roth's theorem) — **Phase 7 ext #113: Real.rpow reciprocal-product
  identity `(1/(a·b))^c = a^(-c) · b^(-c)` (cubic+ chain rpow algebra)**,
  sub session 559mmmmmmm — STRICT critical-path #316 (T-5) Phase 7 ext #113.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Real.rpow algebraic identity used to convert
  `(1/(M · q.den^d))^(1/k)` into `M^(-1/k) · q.den^(-d/k)`:

  For a, b > 0, c ∈ ℝ:
    `(1 / (a · b)) ^ c = a ^ (-c) · b ^ (-c)`

  Single derivation:
  1. `T5_rpow_reciprocal_product`: `(1/(a·b))^c = a^(-c) · b^(-c)`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  Per anti-pattern lock 2026-04-29: NO STUBS — full prove mode only.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #113 — rpow reciprocal-product algebra.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowReciprocalProduct

/-! ## Real.rpow reciprocal-product identity -/

/-- **🚨 Wave T5 session 559mmmmmmm — `(1/(a·b))^c = a^(-c) · b^(-c)`**.

    For a, b > 0, c ∈ ℝ. -/
theorem T5_rpow_reciprocal_product
    (a b : ℝ) (ha : 0 < a) (hb : 0 < b) (c : ℝ) :
    (1 / (a * b)) ^ c = a ^ (-c) * b ^ (-c) := by
  have h_ab_pos : 0 < a * b := mul_pos ha hb
  -- 1 / (a·b) = (a·b)⁻¹
  rw [one_div]
  -- (a·b)⁻¹^c = ((a·b)^c)⁻¹
  rw [Real.inv_rpow h_ab_pos.le]
  -- (a·b)^c = a^c · b^c
  rw [Real.mul_rpow ha.le hb.le]
  -- (a^c · b^c)⁻¹ = (a^c)⁻¹ · (b^c)⁻¹
  rw [mul_inv]
  -- (a^c)⁻¹ = a^(-c) (and same for b)
  rw [← Real.rpow_neg ha.le, ← Real.rpow_neg hb.le]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559mmmmmmm — T-5 Phase 7 ext #113:
    Real.rpow reciprocal-product identity**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #113.

    🏆 RPOW ALGEBRA — converts `(1/(a·b))^c` to `a^(-c) · b^(-c)`.

    Single derivation:
    1. `T5_rpow_reciprocal_product` — `(1/(a·b))^c = a^(-c) · b^(-c)`.

    Strategy: `1/(a·b) = (a·b)⁻¹` → `((a·b)⁻¹)^c = ((a·b)^c)⁻¹` (Real.inv_rpow)
    → `((a·b)^c) = a^c · b^c` (Real.mul_rpow) → `(a^c · b^c)⁻¹ = (a^c)⁻¹ · (b^c)⁻¹`
    (mul_inv) → `(a^c)⁻¹ = a^(-c)` (Real.rpow_neg backwards).

    Used in cubic+ chain to convert kth-root form
    `(1/(M · q.den^d))^(1/k)` into `M^(-1/k) · q.den^(-d/k)`,
    exposing the Roth-form structure.

    Mathlib usage: `Real.inv_rpow`, `Real.mul_rpow`, `mul_inv`,
    `Real.rpow_neg`, `one_div`.

    Sub-lemma 286/N in T-1 (T-5 Phase 7 ext #113).  Lean-core only. -/
theorem session_559mmmmmmm_T5_phase7_rpow_reciprocal_product_headline
    (a b : ℝ) (ha : 0 < a) (hb : 0 < b) (c : ℝ) :
    (1 / (a * b)) ^ c = a ^ (-c) * b ^ (-c) :=
  T5_rpow_reciprocal_product a b ha hb c

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowReciprocalProduct
