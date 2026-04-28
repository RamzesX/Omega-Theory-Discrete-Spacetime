/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

  T-5 (Roth's theorem) — **Phase 7 ext #116: Cubic+ Roth-form bound
  `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|` (cubic+ chain Roth-form
  combined inequality)**, sub session 559ppppppp — STRICT
  critical-path #316 (T-5) Phase 7 ext #116.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #115 (Roth-form preliminary `M^(-1/k) · q.den^(-d/k) ≤ |q-α|`)
  with ext #111 (q.den exponent mono) and Roth budget `k(2+ε) > d` to give:

  For aux poly p with index ≥ k at α, k ≥ 1, k(2+ε) > p.natDegree (Roth budget),
  q : ℚ with |q-α| ≤ 1 AND eval₂ q p ≠ 0 AND M > 0:
    `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|`

  This IS the Roth-form bound with C = M^(-1/k).

  Single derivation:
  1. `T5_cubic_roth_form_bound`: composes s115 + s111 + budget.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #116 — cubic+ Roth-form bound (combined).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExplicitForm
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExplicitForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono

/-! ## Roth-form bound -/

/-- **🚨 Wave T5 session 559ppppppp — Roth-form bound `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|`**.

    Composes s115 (Roth-form preliminary) + s111 (q.den exponent mono)
    + Roth budget `k(2+ε) > d` to give the Roth-form bound. -/
theorem T5_cubic_roth_form_bound
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ) (hk : 1 ≤ k)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (ε : ℝ) (hε : 0 < ε)
    (h_budget : (k : ℝ) * (2 + ε) > p.natDegree)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
      ((q.den : ℝ)) ^ (-(2 + ε)) ≤
      |((q : ℚ) : ℝ) - α| := by
  -- s115 gives: M^(-1/k) · q.den^(-d/k) ≤ |q-α|
  have h_s115 := T5_cubic_roth_explicit_form
                  α p k hk h_index q h_close h_nonzero h_M_pos
  -- Need: M^(-1/k) · q.den^(-(2+ε)) ≤ M^(-1/k) · q.den^(-d/k)
  -- Equivalently (M^(-1/k) > 0): q.den^(-(2+ε)) ≤ q.den^(-d/k)
  -- From h_budget: k(2+ε) > d, divide by k > 0: 2+ε > d/k → -(2+ε) < -d/k
  --   (since k > 0 from hk)
  -- Apply s111 (qden_rpow_mono) with a = -(2+ε), b = -d/k.
  have hk_pos : (0 : ℝ) < (k : ℝ) := by exact_mod_cast Nat.lt_of_lt_of_le (by norm_num) hk
  have h_dk_lt : (p.natDegree : ℝ) / (k : ℝ) < 2 + ε := by
    rw [div_lt_iff₀ hk_pos]; linarith
  have h_neg_le : -(2 + ε) ≤ -((p.natDegree : ℝ) / (k : ℝ)) := by linarith
  have h_qden_mono := T5_qden_rpow_mono q (-(2 + ε)) (-((p.natDegree : ℝ) / (k : ℝ))) h_neg_le
  -- M^(-1/k) ≥ 0 (since M > 0): for non-negative x, monotonicity in second factor
  have h_M_inv_k_nn : (0 : ℝ) ≤
      (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) := by
    apply Real.rpow_nonneg
    exact le_of_lt h_M_pos
  -- Multiply h_qden_mono by M^(-1/k) ≥ 0 on the LEFT
  have h_chain : (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
        ((q.den : ℝ)) ^ (-(2 + ε)) ≤
      (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
        ((q.den : ℝ)) ^ (-((p.natDegree : ℝ) / (k : ℝ))) :=
    mul_le_mul_of_nonneg_left h_qden_mono h_M_inv_k_nn
  -- Combine with s115
  exact le_trans h_chain h_s115

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ppppppp — T-5 Phase 7 ext #116:
    Cubic+ Roth-form bound**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #116.

    🏆 ROTH-FORM BOUND — `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|`.

    Single derivation:
    1. `T5_cubic_roth_form_bound` — Roth-form bound with C = M^(-1/k).

    Strategy: chain s115 (`M^(-1/k) · q.den^(-d/k) ≤ |q-α|`) +
    s111 q.den exponent mono (`-(2+ε) ≤ -d/k → q.den^(-(2+ε)) ≤ q.den^(-d/k)`) +
    Roth budget `k(2+ε) > d → d/k < 2+ε → -(2+ε) < -d/k` (k > 0). Multiply
    by M^(-1/k) ≥ 0.

    This IS the Roth-form bound for THIS aux poly p, q. Combined with
    SchmidtAuxPolyExists (witness construction), gives unconditional Roth.

    Mathlib usage: composition of ext #115 + ext #111, `mul_le_mul_of_nonneg_left`,
    `Real.rpow_nonneg`, `div_lt_iff₀`, `le_trans`, `linarith`.

    Sub-lemma 289/N in T-1 (T-5 Phase 7 ext #116).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 ROTH-FORM BOUND. Escanor Pride +
    Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559ppppppp_T5_phase7_cubic_roth_form_bound_headline
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ) (hk : 1 ≤ k)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (ε : ℝ) (hε : 0 < ε)
    (h_budget : (k : ℝ) * (2 + ε) > p.natDegree)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
      ((q.den : ℝ)) ^ (-(2 + ε)) ≤
      |((q : ℚ) : ℝ) - α| :=
  T5_cubic_roth_form_bound α p k hk h_index ε hε h_budget q h_close h_nonzero h_M_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound
