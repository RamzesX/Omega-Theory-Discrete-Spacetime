/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExtraction

  Cycle 63→64 Phase B Wave T-4b session 56 — extract h_ℤ from p_ℤ via X^m
  divisibility (m = rootMultiplicity 0 p_ℤ).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Given p_ℤ : ℤ[X] from s50 (with p_ℤ ≠ 0 from s55, p_ℤ.eval 0 = 0 from s52):

  - Define `m := p_ℤ.rootMultiplicity 0`.
  - Define `h_ℤ := p_ℤ /ₘ X^m`.
  - Prove:
    1. m ≥ 1 (via rootMultiplicity_pos + IsRoot at 0).
    2. p_ℤ = X^m * h_ℤ (Mathlib `pow_mul_divByMonic_rootMultiplicity_eq`).
    3. h_ℤ.eval 0 ≠ 0 (Mathlib `eval_divByMonic_pow_rootMultiplicity_ne_zero`).
    4. h_ℤ ≠ 0 (since h_ℤ.eval 0 ≠ 0).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroExpSum

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExtraction

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvalPolyLiftZ
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroXdvd
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPzeroExpSum

/-! ## h_ℤ definition + structural properties -/

/-- **Wave T4b session 56 — h_ℤ extraction**.

    Given p_ℤ from s50 (non-zero, with p_ℤ.eval 0 = 0), define
    `h_ℤ := p_ℤ /ₘ X^m` where `m := p_ℤ.rootMultiplicity 0`.

    Returns: ∃ h_ℤ : ℤ[X], ∃ m : ℕ, h_ℤ ≠ 0 ∧ h_ℤ.eval 0 ≠ 0 ∧
             0 < m ∧ p_ℤ = X^m * h_ℤ. -/
theorem h_Z_extraction
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α)
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)) :
    ∃ (h_ℤ : Polynomial ℤ) (m : ℕ),
      h_ℤ ≠ 0 ∧
      h_ℤ.eval 0 ≠ 0 ∧
      0 < m ∧
      p_ℤ = Polynomial.X ^ m * h_ℤ := by
  -- p_ℤ ≠ 0 from s55
  have h_pZ_ne : p_ℤ ≠ 0 := p_Z_ne_zero n α p_ℤ b h_b_ne h_pZ
  -- p_ℤ.eval 0 = 0 from s52
  have h_pZ_eval_zero : p_ℤ.eval 0 = 0 :=
    p_Z_eval_zero_eq_zero f h_ne n α h_α p_ℤ b h_b_ne h_pZ
  -- Define m := rootMultiplicity 0 p_ℤ
  let m := p_ℤ.rootMultiplicity 0
  -- m ≥ 1: rootMultiplicity_pos
  have h_m_pos : 0 < m := by
    rw [show m = p_ℤ.rootMultiplicity 0 from rfl]
    rw [Polynomial.rootMultiplicity_pos h_pZ_ne]
    exact h_pZ_eval_zero  -- h_pZ_eval_zero : eval 0 p_ℤ = 0 = IsRoot p_ℤ 0
  -- Define h_ℤ := p_ℤ /ₘ (X^m)
  let h_ℤ : Polynomial ℤ := p_ℤ /ₘ (Polynomial.X ^ m)
  -- p_ℤ = X^m * h_ℤ via pow_mul_divByMonic_rootMultiplicity_eq
  have h_factor : Polynomial.X ^ m * h_ℤ = p_ℤ := by
    have := p_ℤ.pow_mul_divByMonic_rootMultiplicity_eq 0
    -- (X - C 0)^m * (p_ℤ /ₘ (X - C 0)^m) = p_ℤ
    -- where m on LHS = rootMultiplicity 0 p_ℤ = our m
    simp only [map_zero, sub_zero] at this
    exact this
  -- h_ℤ.eval 0 ≠ 0 via eval_divByMonic_pow_rootMultiplicity_ne_zero
  have h_h_eval_zero_ne : h_ℤ.eval 0 ≠ 0 := by
    have := Polynomial.eval_divByMonic_pow_rootMultiplicity_ne_zero (p := p_ℤ) (a := 0) h_pZ_ne
    -- this : eval 0 (p_ℤ /ₘ (X - C 0)^(rootMultiplicity 0 p_ℤ)) ≠ 0
    simp only [map_zero, sub_zero] at this
    exact this
  -- h_ℤ ≠ 0
  have h_h_ne : h_ℤ ≠ 0 := by
    intro h
    rw [h, Polynomial.eval_zero] at h_h_eval_zero_ne
    exact h_h_eval_zero_ne rfl
  refine ⟨h_ℤ, m, h_h_ne, h_h_eval_zero_ne, h_m_pos, ?_⟩
  exact h_factor.symm

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 56**.  Given p_ℤ from s50, extract
    h_ℤ : ℤ[X] with h_ℤ ≠ 0, h_ℤ.eval 0 ≠ 0, m ≥ 1 such that
    p_ℤ = X^m * h_ℤ. -/
theorem session_56_h_Z_extraction_headline
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α)
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ)
    (p_ℤ : Polynomial ℤ) (b : ℤ) (h_b_ne : b ≠ 0)
    (h_pZ : p_ℤ.map (algebraMap ℤ ℂ) =
       (b : ℂ) • ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom)) :
    ∃ (h_ℤ : Polynomial ℤ) (m : ℕ),
      h_ℤ ≠ 0 ∧
      h_ℤ.eval 0 ≠ 0 ∧
      0 < m ∧
      p_ℤ = Polynomial.X ^ m * h_ℤ :=
  h_Z_extraction n α h_iPi_mem f h_ne h_α p_ℤ b h_b_ne h_pZ

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofHzeroExtraction
