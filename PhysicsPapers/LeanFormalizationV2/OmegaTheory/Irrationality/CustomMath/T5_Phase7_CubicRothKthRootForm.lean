/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothKthRootForm

  T-5 (Roth's theorem) — **Phase 7 ext #110: Cubic+ Roth kth-root form
  `(1/(M · q.den^d))^(1/k) ≤ |q-α|` (real-power lower bound)**, sub
  session 559jjjjjjj — STRICT critical-path #316 (T-5) Phase 7 ext #110.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #104 (distance lower bound `1/(M · q.den^d) ≤ |q-α|^k`)
  with ext #109 (kth-root step) into the REAL-POWER FORM:

  For aux poly p with index ≥ k at α, q : ℚ with |q-α| ≤ 1 AND
  eval₂ q p ≠ 0 AND M > 0 AND k ≥ 1:
    `(1/(M · q.den^d))^(1/k) ≤ |q-α|`

  This is the kth-root form of the distance lower bound — the natural
  setup for combining with `q.den^(-d/k) ≥ q.den^(-(2+ε))` to give
  Roth-form `|q-α| ≥ M^(-1/k) · q.den^(-(2+ε))`.

  Single derivation:
  1. `T5_cubic_roth_kth_root_form`: composes s104 + s109.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #110 — cubic+ Roth kth-root real-power form.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_KthRootStep

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothKthRootForm

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothCorePartial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_KthRootStep

/-! ## Cubic+ kth-root form -/

/-- **🚨 Wave T5 session 559jjjjjjj — `(1/(M · q.den^d))^(1/k) ≤ |q-α|`**.

    Composes s104 (distance lower bound `1/(M · q.den^d) ≤ |q-α|^k`) with
    s109 (kth-root step) to give the real-power Roth-form lower bound. -/
theorem T5_cubic_roth_kth_root_form
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ) (hk : 1 ≤ k)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    ((1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
      ((q.den : ℝ)) ^ p.natDegree)) ^ (1 / (k : ℝ)) ≤
      |((q : ℚ) : ℝ) - α| := by
  -- s104 gives: 1/(M · q.den^d) ≤ |q-α|^k
  have h_s104 := T5_cubic_roth_distance_lower_bound
                  α p k h_index q h_close h_nonzero h_M_pos
  -- Need positivity for kth-root step
  have h_qden_pos : (0 : ℝ) < ((q.den : ℝ)) ^ p.natDegree := by
    apply pow_pos; exact_mod_cast q.pos
  have h_M_qden_pos : (0 : ℝ) < (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
            ((q.den : ℝ)) ^ p.natDegree :=
    mul_pos h_M_pos h_qden_pos
  have h_inv_pos : (0 : ℝ) < 1 / ((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
            ((q.den : ℝ)) ^ p.natDegree) := by
    positivity
  have h_abs_nn : 0 ≤ |((q : ℚ) : ℝ) - α| := abs_nonneg _
  -- Apply s109 kth-root step
  exact T5_kth_root_step _ _ h_abs_nn (le_of_lt h_inv_pos) k hk h_s104

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559jjjjjjj — T-5 Phase 7 ext #110:
    Cubic+ Roth kth-root form**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #110.

    🏆 REAL-POWER LOWER BOUND — Roth-form preliminary.

    Single derivation:
    1. `T5_cubic_roth_kth_root_form` — `(1/(M · q.den^d))^(1/k) ≤ |q-α|`.

    Strategy: chain s104 (`1/(M · q.den^d) ≤ |q-α|^k`) → s109 kth-root
    flip (under x ≥ 0, A ≥ 0, k ≥ 1: `A ≤ x^k → A^(1/k) ≤ x`).

    Combined with `(1/(M · q.den^d))^(1/k) = q.den^(-d/k) / M^(1/k)`:
    `|q - α| ≥ M^(-1/k) · q.den^(-d/k)`.

    For `k > d/(2+ε)`: `q.den^(-d/k) > q.den^(-(2+ε))`, so:
    `|q - α| > M^(-1/k) · q.den^(-(2+ε))`.

    This is the **ROTH-FORM BOUND** with `C = M^(-1/k)`.

    REMAINING for unconditional Roth: discharge SchmidtAuxPolyExists
    via Schmidt-Wirsing-Roth multivariate machinery.

    Mathlib usage: composition of ext #104 + ext #109.

    Sub-lemma 283/N in T-1 (T-5 Phase 7 ext #110).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 cubic+ Roth kth-root form — REAL-POWER
    Roth-form lower bound shipped. Escanor Pride + Erdős Primarch. -/
theorem session_559jjjjjjj_T5_phase7_cubic_roth_kth_root_form_headline
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ) (hk : 1 ≤ k)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    ((1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
      ((q.den : ℝ)) ^ p.natDegree)) ^ (1 / (k : ℝ)) ≤
      |((q : ℚ) : ℝ) - α| :=
  T5_cubic_roth_kth_root_form α p k hk h_index q h_close h_nonzero h_M_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothKthRootForm
