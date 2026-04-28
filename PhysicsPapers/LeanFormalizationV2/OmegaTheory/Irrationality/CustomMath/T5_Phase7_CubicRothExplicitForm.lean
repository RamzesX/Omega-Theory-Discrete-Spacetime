/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExplicitForm

  T-5 (Roth's theorem) — **Phase 7 ext #115: Cubic+ Roth explicit
  form `M^(-1/k) · q.den^(-d/k) ≤ |q-α|` (cubic+ chain Roth-form
  rewrite applied)**, sub session 559ooooooo — STRICT critical-path
  #316 (T-5) Phase 7 ext #115.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #110 (kth-root form) with ext #114 (Roth-form rewrite)
  to give the EXPLICIT Roth-form preliminary:

  For aux poly p with index ≥ k at α (k ≥ 1), q : ℚ with |q-α| ≤ 1
  AND eval₂ q p ≠ 0 AND M > 0:
    `M^(-1/k) · q.den^(-d/k) ≤ |q-α|`

  This is the CLEAN Roth-form preliminary, ready for combining with
  Roth budget `d/k < 2+ε` + q.den ≥ 1.

  Single derivation:
  1. `T5_cubic_roth_explicit_form`: composes s110 + s114.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #115 — cubic+ Roth explicit form.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothKthRootForm
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowQDenIdentity

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExplicitForm

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothKthRootForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RpowQDenIdentity

/-! ## Roth-form explicit -/

/-- **🚨 Wave T5 session 559ooooooo — Roth-form explicit `M^(-1/k) · q.den^(-d/k) ≤ |q-α|`**.

    Composes s110 (kth-root form) + s114 (Roth-form rewrite). -/
theorem T5_cubic_roth_explicit_form
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ) (hk : 1 ≤ k)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
      ((q.den : ℝ)) ^ (-((p.natDegree : ℝ) / (k : ℝ))) ≤
      |((q : ℚ) : ℝ) - α| := by
  -- s110 gives: (1 / (M · q.den^d))^(1/k) ≤ |q-α|
  have h_s110 := T5_cubic_roth_kth_root_form
                  α p k hk h_index q h_close h_nonzero h_M_pos
  -- s114 rewrites LHS to: M^(-1/k) · q.den^(-d/k)
  have h_s114 := T5_rpow_qden_roth_form_identity
                  (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                      |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)
                  h_M_pos q p.natDegree k
  rw [h_s114] at h_s110
  exact h_s110

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ooooooo — T-5 Phase 7 ext #115:
    Cubic+ Roth explicit form**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #115.

    🏆 ROTH-FORM PRELIMINARY — `M^(-1/k) · q.den^(-d/k) ≤ |q-α|`.

    Single derivation:
    1. `T5_cubic_roth_explicit_form` — Roth-form preliminary.

    Strategy: chain s110 (kth-root form `(1/(M·q.den^d))^(1/k) ≤ |q-α|`)
    + s114 (rewrite LHS to `M^(-1/k) · q.den^(-d/k)`).

    REMAINING for unconditional Roth: combine with Roth budget
    `k(2+ε) > d ↔ d/k < 2+ε` and q.den ≥ 1 to get
    `q.den^(-(2+ε)) ≤ q.den^(-d/k)` (via ext #111), yielding
    `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|`. Then discharge SchmidtAuxPolyExists.

    Mathlib usage: composition of ext #110 + ext #114.

    Sub-lemma 288/N in T-1 (T-5 Phase 7 ext #115).  Lean-core only. -/
theorem session_559ooooooo_T5_phase7_cubic_roth_explicit_form_headline
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ) (hk : 1 ≤ k)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
    (h_M_pos : (0 : ℝ) <
      ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) :
    (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
        |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
      ((q.den : ℝ)) ^ (-((p.natDegree : ℝ) / (k : ℝ))) ≤
      |((q : ℚ) : ℝ) - α| :=
  T5_cubic_roth_explicit_form α p k hk h_index q h_close h_nonzero h_M_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExplicitForm
