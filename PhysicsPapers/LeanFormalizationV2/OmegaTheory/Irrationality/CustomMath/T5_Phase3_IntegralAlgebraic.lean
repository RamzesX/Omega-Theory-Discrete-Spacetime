/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_IntegralAlgebraic

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 143.
  IsIntegral ↔ IsAlgebraic equivalence.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's IsIntegral / IsAlgebraic equivalences:

  1. **`T5_isIntegral_implies_isAlgebraic`** : `IsIntegral R x → IsAlgebraic R x`
     (always, with [Nontrivial R]).
  2. **`T5_isAlgebraic_implies_isIntegral`** : `IsAlgebraic K x → IsIntegral K x`
     (only over a field K).

  Useful for T-5 because `minpoly` requires `IsIntegral` while `Roth`
  uses `IsAlgebraic`.  Over ℚ (a field), the two notions coincide.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.RingTheory.Algebraic.Integral

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_IntegralAlgebraic

/-! ## IsIntegral → IsAlgebraic -/

/-- **Wave T5 session 143 — IsIntegral implies IsAlgebraic**.

    Always (with [Nontrivial R]). -/
theorem T5_isIntegral_implies_isAlgebraic
    {R A : Type*} [CommRing R] [Ring A] [Algebra R A] [Nontrivial R] {x : A}
    (hx : IsIntegral R x) : IsAlgebraic R x :=
  hx.isAlgebraic

/-! ## IsAlgebraic → IsIntegral (over field) -/

/-- **Wave T5 session 143 — IsAlgebraic implies IsIntegral over a field**.

    Only when the base ring is a field (so any nonzero polynomial can
    be made monic by scaling). -/
theorem T5_isAlgebraic_implies_isIntegral
    {K A : Type*} [Field K] [Ring A] [Algebra K A] {x : A}
    (hx : IsAlgebraic K x) : IsIntegral K x :=
  hx.isIntegral

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 143 — IsIntegral ↔ IsAlgebraic**.

    Two directions:
    1. `IsIntegral R x → IsAlgebraic R x` (always, [Nontrivial R]).
    2. `IsAlgebraic K x → IsIntegral K x` (only over field).

    Sub-lemma 31/N in T-5 Phase 3.  Lean-core only.

    Useful for T-5 since `minpoly` requires `IsIntegral` while Roth
    uses `IsAlgebraic`.  Over ℚ (a field), the two notions coincide. -/
theorem session_143_integral_algebraic_headline :
    -- (1) Integral → algebraic (general)
    (∀ {R A : Type*} [_inst : CommRing R] [_inst' : Ring A] [_inst'' : Algebra R A]
       [_inst''' : Nontrivial R] {x : A},
        IsIntegral R x → IsAlgebraic R x)
    -- (2) Algebraic → integral (over field)
    ∧ (∀ {K A : Type*} [_inst : Field K] [_inst' : Ring A] [_inst'' : Algebra K A] {x : A},
        IsAlgebraic K x → IsIntegral K x) := by
  refine ⟨?_, ?_⟩
  · intros R A _ _ _ _ x hx; exact T5_isIntegral_implies_isAlgebraic hx
  · intros K A _ _ _ x hx; exact T5_isAlgebraic_implies_isIntegral hx

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_IntegralAlgebraic
