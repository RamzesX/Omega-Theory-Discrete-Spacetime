/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleWithNeg

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 133.
  `LiouvilleWith` neg / sub closures.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `LiouvilleWith` more closures:

  1. **`T5_LiouvilleWith_neg`** : `LiouvilleWith p x → LiouvilleWith p (-x)`.
  2. **`T5_LiouvilleWith_sub_rat`** : `LiouvilleWith p x → LiouvilleWith p (x - r)`.

  These extend s132's algebra (mono/add/mul) to include negation and
  subtraction of rationals.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.NumberTheory.Transcendental.Liouville.LiouvilleWith

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleWithNeg

/-! ## LiouvilleWith neg + sub closures -/

/-- **Wave T5 session 133 — LiouvilleWith preserved under negation**.

    `LiouvilleWith p x → LiouvilleWith p (-x)`. -/
theorem T5_LiouvilleWith_neg {p x : ℝ} (h : LiouvilleWith p x) :
    LiouvilleWith p (-x) :=
  h.neg

/-- **Wave T5 session 133 — LiouvilleWith preserved under -ℚ**.

    `LiouvilleWith p x → LiouvilleWith p (x - r)` for `r : ℚ`. -/
theorem T5_LiouvilleWith_sub_rat {p x : ℝ}
    (h : LiouvilleWith p x) (r : ℚ) :
    LiouvilleWith p (x - (r : ℝ)) :=
  h.sub_rat r

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 133 — LiouvilleWith neg/sub closures**.

    Two foundational closures:
    1. `LiouvilleWith p x → LiouvilleWith p (-x)`.
    2. `LiouvilleWith p x → LiouvilleWith p (x - r)` for r : ℚ.

    Sub-lemma 22/N in T-5 Phase 3.  Lean-core only.

    Combined with s132 (mono / add_rat / mul_rat), the LiouvilleWith
    property is closed under all of: -, +ℚ, -ℚ, *ℚ_{≠0}, mono. -/
theorem session_133_liouville_with_neg_sub_headline :
    -- (1) Neg
    (∀ {p x : ℝ}, LiouvilleWith p x → LiouvilleWith p (-x))
    -- (2) Sub rat
    ∧ (∀ {p x : ℝ} (h : LiouvilleWith p x) (r : ℚ),
        LiouvilleWith p (x - (r : ℝ))) :=
  ⟨T5_LiouvilleWith_neg, T5_LiouvilleWith_sub_rat⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleWithNeg
