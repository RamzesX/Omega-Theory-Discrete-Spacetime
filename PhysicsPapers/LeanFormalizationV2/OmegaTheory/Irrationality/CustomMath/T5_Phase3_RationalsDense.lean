/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_RationalsDense

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 156.
  Rationals are dense in ℝ.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-export of Mathlib's `exists_rat_btwn`:

      For x < y in ℝ (or any Archimedean field), ∃ q : ℚ with x < q < y.

  This is the density of rationals in the reals — foundational for
  Diophantine approximation.  Combined with Hurwitz/Dirichlet, it
  forms the basis of the rate-of-approximation analysis in Roth's
  theorem.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Real.Archimedean

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_RationalsDense

/-! ## ℚ is dense -/

/-- **Wave T5 session 156 — rationals are dense**.

    For any `x < y` in an Archimedean ordered field, there's a
    rational `q` strictly between them. -/
theorem T5_exists_rat_btwn
    {K : Type*} [Field K] [LinearOrder K] [IsStrictOrderedRing K] [Archimedean K]
    {x y : K} (h : x < y) :
    ∃ q : ℚ, x < (q : K) ∧ (q : K) < y :=
  exists_rat_btwn h

/-- **Wave T5 session 156 — rationals dense in ℝ**.

    Specialization to ℝ: between any two reals there's a rational. -/
theorem T5_exists_rat_btwn_real {x y : ℝ} (h : x < y) :
    ∃ q : ℚ, x < (q : ℝ) ∧ (q : ℝ) < y :=
  T5_exists_rat_btwn h

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 156 — ℚ dense in ℝ**.

    Two formulations:
    1. General Archimedean ordered field.
    2. Specialization to ℝ.

    Sub-lemma 43/N in T-5 Phase 3.  Lean-core only.

    Foundational for Diophantine approximation: combined with
    Hurwitz/Dirichlet (s136-s137), gives the basis of the
    rate-of-approximation analysis in Roth's theorem. -/
theorem session_156_rationals_dense_headline :
    -- (1) General Archimedean field
    (∀ {K : Type*} [_inst : Field K] [_inst' : LinearOrder K]
        [_inst'' : IsStrictOrderedRing K] [_inst''' : Archimedean K]
        {x y : K}, x < y → ∃ q : ℚ, x < (q : K) ∧ (q : K) < y)
    -- (2) ℝ specialization
    ∧ (∀ {x y : ℝ}, x < y → ∃ q : ℚ, x < (q : ℝ) ∧ (q : ℝ) < y) := by
  refine ⟨?_, ?_⟩
  · intros K _ _ _ _ x y h; exact T5_exists_rat_btwn h
  · intros x y h; exact T5_exists_rat_btwn_real h

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_RationalsDense
