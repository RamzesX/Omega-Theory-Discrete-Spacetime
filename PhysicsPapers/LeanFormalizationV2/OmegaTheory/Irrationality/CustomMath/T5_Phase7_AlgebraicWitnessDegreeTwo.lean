/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeTwo

  T-5 (Roth's theorem) — **Phase 7 ext #54: For IRRATIONAL algebraic α,
  there exists an integer-poly witness with natDegree ≥ 2 (cubic+
  chain structural lemma — full version)**, sub session 559uuuu —
  STRICT critical-path #316 (T-5) Phase 7 ext #54.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Strengthens ext #53 (natDegree ≥ 1) to natDegree ≥ 2 for the
  irrational case: a degree-1 witness `a*X + b` would imply
  `α = -b/a ∈ ℚ`, contradicting `Irrational α`.

  Strategy: ext #53 gives natDegree ≥ 1 from non-zero. Need to also
  rule out natDegree = 1: if f = C a * X + C b with a ≠ 0, then
  aeval α f = a*α + b = 0 ⟹ α = -b/a ∈ ℚ ⟹ contradiction.

  Single derivation:
  1. `T5_irrational_algebraic_witness_natDegree_ge_two`: for irrational
     algebraic α, ∃ witness polynomial of natDegree ≥ 2.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #54 — irrational algebraic witness natDegree ≥ 2.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeOne
import Mathlib.Algebra.Polynomial.Degree.SmallDegree
import Mathlib.NumberTheory.Real.Irrational

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeTwo

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeOne

/-! ## Witness polynomial natDegree ≥ 2 for irrational algebraic α -/

/-- **🚨 Wave T5 session 559uuuu — Witness polynomial natDegree ≥ 2**.

    For α : ℝ irrational AND `IsAlgebraic ℤ α`, there exists f : ℤ[X]
    with f ≠ 0, aeval α f = 0, AND f.natDegree ≥ 2.

    Strategy: get any witness from IsAlgebraic. Rule out natDegree = 0
    (constant case, ruled out by ext #53 logic). Rule out natDegree = 1:
    f = C a * X + C b with a ≠ 0 ⟹ α = -b/a ∈ ℚ contradicting Irrational. -/
theorem T5_irrational_algebraic_witness_natDegree_ge_two
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α) :
    ∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0 ∧
      2 ≤ f.natDegree := by
  -- α is irrational → α ≠ 0
  have hα_ne : α ≠ 0 := by
    intro h_eq
    apply hα
    rw [h_eq]
    exact ⟨0, by simp⟩
  -- Get witness with natDegree ≥ 1
  obtain ⟨f, hf_ne, hf_root, hf_deg_ge_one⟩ :=
    T5_nonzero_algebraic_witness_natDegree_ge_one α hα_ne h_alg
  refine ⟨f, hf_ne, hf_root, ?_⟩
  by_contra h_lt
  push_neg at h_lt
  -- f.natDegree < 2 and ≥ 1 → f.natDegree = 1
  have h_deg_one : f.natDegree = 1 := by omega
  -- f = C (f.coeff 1) * X + C (f.coeff 0) via Polynomial.eq_X_add_C_of_natDegree_le_one
  have h_form : f = C (f.coeff 1) * X + C (f.coeff 0) :=
    Polynomial.eq_X_add_C_of_natDegree_le_one (by omega : f.natDegree ≤ 1)
  -- aeval α f = (f.coeff 1 : ℝ) * α + (f.coeff 0 : ℝ) = 0
  have h_aeval : Polynomial.aeval α f =
                 ((f.coeff 1 : ℤ) : ℝ) * α + ((f.coeff 0 : ℤ) : ℝ) := by
    conv_lhs => rw [h_form]
    rw [map_add, map_mul, Polynomial.aeval_C, Polynomial.aeval_C,
        Polynomial.aeval_X]
    simp [Algebra.id.smul_eq_mul, Int.cast_id]
  rw [h_aeval] at hf_root
  -- f.coeff 1 ≠ 0 since natDegree = 1 means leadingCoeff ≠ 0
  have h_coeff1_ne : f.coeff 1 ≠ 0 := by
    have h_lead : f.leadingCoeff = f.coeff 1 := by
      rw [Polynomial.leadingCoeff, h_deg_one]
    have h_lead_ne : f.leadingCoeff ≠ 0 :=
      Polynomial.leadingCoeff_ne_zero.mpr hf_ne
    rw [h_lead] at h_lead_ne
    exact h_lead_ne
  -- a * α + b = 0 → α = -b / a, rational
  have h_coeff1_real_ne : ((f.coeff 1 : ℤ) : ℝ) ≠ 0 := by exact_mod_cast h_coeff1_ne
  have h_alpha_eq : α = -((f.coeff 0 : ℤ) : ℝ) / ((f.coeff 1 : ℤ) : ℝ) := by
    field_simp
    linarith
  apply hα
  -- α = -b/a ∈ ℝ is the cast of the rational -b/a
  refine ⟨((-f.coeff 0 : ℤ) : ℚ) / ((f.coeff 1 : ℤ) : ℚ), ?_⟩
  rw [h_alpha_eq]
  push_cast
  ring

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559uuuu — T-5 Phase 7 ext #54:
    Irrational algebraic witness natDegree ≥ 2**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #54.

    🏆 STRENGTHENED structural lemma for cubic+ chain.

    Single derivation:
    1. `T5_irrational_algebraic_witness_natDegree_ge_two` — for α
       irrational AND algebraic over ℤ, ∃ witness polynomial of
       natDegree ≥ 2.

    Strategy: ext #53 gives natDegree ≥ 1 from non-zero (irrational
    implies non-zero). Rule out natDegree = 1 via
    `Polynomial.eq_X_add_C_of_natDegree_le_one`: f = C a*X + C b,
    aeval α f = a*α + b = 0 ⟹ α = -b/a ∈ ℚ, contradicts Irrational.

    Mathlib usage: `Polynomial.eq_X_add_C_of_natDegree_le_one`,
    `Polynomial.leadingCoeff_ne_zero`, `Polynomial.aeval_C`,
    `Polynomial.aeval_X`, `Polynomial.aeval_add`,
    `Polynomial.aeval_mul`, `Irrational` def, `field_simp + linarith`.

    Sub-lemma 247/N in T-1 (T-5 Phase 7 ext #54).  Lean-core only.

    🏆 Cubic+ chain structural lemma — irrational algebraic α has
    witness polynomial of natDegree ≥ 2. This is the foundation for
    why classical Liouville (degree-d exponent) fails to imply Roth
    (2+ε exponent) for d ≥ 3 — Roth is genuinely stronger. Escanor
    Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559uuuu_T5_phase7_irrational_algebraic_witness_natDegree_ge_two_headline
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α) :
    ∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0 ∧
      2 ≤ f.natDegree :=
  T5_irrational_algebraic_witness_natDegree_ge_two α hα h_alg

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AlgebraicWitnessDegreeTwo
