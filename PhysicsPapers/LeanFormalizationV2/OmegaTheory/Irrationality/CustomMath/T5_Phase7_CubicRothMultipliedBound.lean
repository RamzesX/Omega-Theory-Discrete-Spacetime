/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothMultipliedBound

  T-5 (Roth's theorem) — **Phase 7 ext #106: Cubic+ Roth multiplied
  bound `|q-α|^k · M · q.den^d ≥ 1` (cubic+ chain step 7 — algebraic
  flip)**, sub session 559ffffff — STRICT critical-path #316
  (T-5) Phase 7 ext #106.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Algebraic rearrangement of the s104 distance lower bound into a
  PRODUCT-FORM inequality:

  For aux poly p with index ≥ k at α, q : ℚ with |q-α| ≤ 1 AND
  `eval₂ q p ≠ 0` AND M > 0:
    `|q - α|^k · M · q.den^p.natDegree ≥ 1`

  This is the SAME inequality as s104 (just with denominators cleared)
  but in product form, which is the building block for ANY subsequent
  real-power / k-th root manipulation toward the Roth-form bound.

  Single derivation:
  1. `T5_cubic_roth_multiplied_bound`: |q-α|^k · M · q.den^d ≥ 1.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #106 — cubic+ multiplied bound (algebraic flip).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothMultipliedBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothCorePartial

/-! ## Multiplied-form bound -/

/-- **🚨 Wave T5 session 559ffffff — `|q-α|^k · M · q.den^d ≥ 1`**.

    Algebraic rearrangement of s104. From `1/(M·q.den^d) ≤ |q-α|^k`,
    multiplying both sides by `M·q.den^d > 0` gives `1 ≤ |q-α|^k · M · q.den^d`. -/
theorem T5_cubic_roth_multiplied_bound
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    (1 : ℝ) ≤
      |((q : ℚ) : ℝ) - α| ^ k *
        (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
        ((q.den : ℝ)) ^ p.natDegree := by
  -- s104 gives: 1/(M·q.den^d) ≤ |q-α|^k
  have h_s104 := T5_cubic_roth_distance_lower_bound
                  α p k h_index q h_close h_nonzero h_M_pos
  -- M > 0 (assumed) and q.den^d > 0 (q.pos)
  have h_qden_pos : (0 : ℝ) < ((q.den : ℝ)) ^ p.natDegree := by
    apply pow_pos; exact_mod_cast q.pos
  have h_M_qden_pos : (0 : ℝ) < (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
            ((q.den : ℝ)) ^ p.natDegree :=
    mul_pos h_M_pos h_qden_pos
  -- Multiply s104 by (M · q.den^d) > 0
  rw [div_le_iff₀ h_M_qden_pos] at h_s104
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ffffff — T-5 Phase 7 ext #106:
    Cubic+ Roth multiplied bound**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #106.

    🏆 ALGEBRAIC FLIP — product-form Roth inequality.

    Single derivation:
    1. `T5_cubic_roth_multiplied_bound` — `1 ≤ |q-α|^k · M · q.den^d`.

    Strategy: from s104 `1/(M·q.den^d) ≤ |q-α|^k`, multiply both sides
    by `M·q.den^d > 0` (which holds since M > 0 by hypothesis and
    q.den ≥ 1 by Rat positivity) → `1 ≤ |q-α|^k · M · q.den^d`.

    This is the BUILDING BLOCK for ANY subsequent real-power / k-th root
    manipulation toward Roth-form `|q-α| ≥ C · q.den^(-(2+ε))`.

    Mathlib usage: `pow_pos`, `mul_pos`, `div_le_iff₀`, `linarith`,
    `exact_mod_cast q.pos`.

    Sub-lemma 279/N in T-1 (T-5 Phase 7 ext #106).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 cubic+ multiplied bound — clean
    algebraic flip preparing the kth-root step for unconditional Roth. -/
theorem session_559ffffff_T5_phase7_cubic_roth_multiplied_bound_headline
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    (1 : ℝ) ≤
      |((q : ℚ) : ℝ) - α| ^ k *
        (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
        ((q.den : ℝ)) ^ p.natDegree :=
  T5_cubic_roth_multiplied_bound α p k h_index q h_close h_nonzero h_M_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothMultipliedBound
