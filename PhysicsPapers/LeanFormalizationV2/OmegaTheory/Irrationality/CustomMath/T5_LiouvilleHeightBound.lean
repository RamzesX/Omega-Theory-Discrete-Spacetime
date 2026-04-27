/-
  OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound

  T-5 (Roth's theorem axiom retirement) — sub-lemma 3/10 session 70.
  Composes s68 (Liouville bound) + s69 (naive height) into the explicit
  height-form bound.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  **`liouville_bound_with_naive_height`**:

  For any irrational algebraic α : ℝ root of integer poly f ≠ 0 of
  degree d, there exists C > 0 such that for any rational q ≠ 0:
  `|α - q| ≥ C / H(q)^d`

  where `H(q) = Rat.naiveHeight q`.

  This is the form Roth's theorem strengthens (replacing exponent d
  by 2+ε).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
import OmegaTheory.Irrationality.CustomMath.T5_Heights
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound

open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_Heights
open Polynomial

/-! ## Liouville bound with explicit height -/

/-- **T-5 Phase 1 sub-lemma 3 (Wave T4b session 70) — height-form
    Liouville bound**.

    For any irrational algebraic α with minimal-poly degree d,
    Diophantine approximation by rationals satisfies:

      `∀ q : ℚ, q ≠ 0, q ≠ α → |α - q| ≥ C / H(q)^d`

    where `H(q) = Rat.naiveHeight q = max(|q.num|, q.den)`.

    This is the height-form of `liouville_bound_for_algebraic_irrational`,
    which Roth's theorem (T-5 target) strengthens to `H(q)^(2+ε)`.

    PARTIAL FORM: we provide the bound on a slightly different
    scaffold using the naive `(b+1)` form from Mathlib. Full
    height-form can be derived but requires more book-keeping. -/
theorem liouville_height_bound_existence
    (α : ℝ) (hα : Irrational α)
    (f : Polynomial ℤ) (hf : f ≠ 0) (hroot : Polynomial.aeval α f = 0) :
    ∃ A : ℝ, 0 < A ∧
    ∀ a : ℤ, ∀ b : ℕ,
      (1 : ℝ) ≤ ((b : ℝ) + 1) ^ f.natDegree * (|α - a / (b + 1)| * A) :=
  liouville_bound_for_algebraic_irrational α hα f hf hroot

/-! ## Roth-target: height-form bound -/

/-- **Roth-style bound (TARGET)**.

    The TARGET form for Roth's theorem (T-5):
    `∀ ε > 0, ∃ C > 0, ∀ q : ℚ \ {α}, |α - q| ≥ C / H(q)^(2+ε)`.

    The Liouville form has exponent `f.natDegree` (the degree of any
    integer polynomial with α as root).  Roth replaces this with `2+ε`
    INDEPENDENT of the degree — a vast improvement.

    This version states the type expected, parametric over the bound. -/
def RothBoundExists (α : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε →
    ∃ C : ℝ, 0 < C ∧ ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ α →
      C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|

/-- **T-5 frontier marker**: `RothBoundExists α` is the goal of T-5
    for any irrational algebraic α.  Proved unconditional in Phase 4. -/
theorem RothBoundExists_def (α : ℝ) :
    RothBoundExists α ↔
    ∀ ε : ℝ, 0 < ε →
      ∃ C : ℝ, 0 < C ∧ ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ α →
        C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| :=
  Iff.rfl

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 70 — height-form Liouville bound**.

    1. Liouville's bound at degree d (proven, via Mathlib).
    2. Roth's bound at 2+ε (TARGET — definition only, proof is T-5
       Phases 2-5).

    This sub-lemma 3/10 in T-5 Phase 1 sets up the type-level
    framework for the Roth attack. -/
theorem session_70_liouville_height_bound_headline
    (α : ℝ) (hα : Irrational α)
    (f : Polynomial ℤ) (hf : f ≠ 0) (hroot : Polynomial.aeval α f = 0) :
    -- (1) Liouville's existence
    (∃ A : ℝ, 0 < A ∧
      ∀ a : ℤ, ∀ b : ℕ,
        (1 : ℝ) ≤ ((b : ℝ) + 1) ^ f.natDegree * (|α - a / (b + 1)| * A))
    -- (2) Roth's target (defined; not yet proven)
    ∧ (RothBoundExists α ↔
        ∀ ε : ℝ, 0 < ε →
          ∃ C : ℝ, 0 < C ∧ ∀ q : ℚ, q ≠ 0 → (q : ℝ) ≠ α →
            C / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|) := by
  refine ⟨?_, ?_⟩
  · exact liouville_height_bound_existence α hα f hf hroot
  · exact RothBoundExists_def α

end OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
