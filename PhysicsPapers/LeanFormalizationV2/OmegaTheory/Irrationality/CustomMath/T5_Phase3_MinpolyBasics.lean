/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_MinpolyBasics

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 131.
  `minpoly` foundational identities.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `minpoly` core identities:

  1. **`T5_minpoly_aeval`** : `aeval x (minpoly A x) = 0`.  The minimal
     polynomial of x annihilates x.
  2. **`T5_minpoly_ne_zero`** : if `x` is integral over `A` (with
     `[Nontrivial A]`), then `minpoly A x ≠ 0`.

  Used as the foundation for Liouville-style approximation bounds in
  Roth's theorem.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.FieldTheory.Minpoly.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_MinpolyBasics

variable {A B : Type*} [CommRing A] [Ring B] [Algebra A B]

/-! ## Minpoly basics -/

/-- **Wave T5 session 131 — minpoly annihilates the element**.

    `aeval x (minpoly A x) = 0`. -/
theorem T5_minpoly_aeval (x : B) :
    (Polynomial.aeval x) (minpoly A x) = 0 :=
  minpoly.aeval A x

/-- **Wave T5 session 131 — minpoly of integral element is nonzero**.

    If `x` is integral over `A`, then `minpoly A x ≠ 0`. -/
theorem T5_minpoly_ne_zero {x : B} [Nontrivial A] (hx : IsIntegral A x) :
    minpoly A x ≠ 0 :=
  minpoly.ne_zero hx

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 131 — minpoly basics**.

    Two foundational facts about minimal polynomials:
    1. `aeval x (minpoly A x) = 0` (annihilates).
    2. integral element ⇒ minpoly ≠ 0.

    Sub-lemma 20/N in T-5 Phase 3.  Lean-core only.

    Used as the foundation for Liouville-style approximation bounds in
    Roth's theorem. -/
theorem session_131_minpoly_basics_headline
    {A B : Type*} [CommRing A] [Ring B] [Algebra A B] :
    -- (1) annihilation
    (∀ (x : B), (Polynomial.aeval x) (minpoly A x) = 0)
    -- (2) integral ⇒ nonzero
    ∧ (∀ {x : B} [_inst : Nontrivial A], IsIntegral A x → minpoly A x ≠ 0) :=
  ⟨T5_minpoly_aeval, fun {_x} _inst hx => T5_minpoly_ne_zero hx⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_MinpolyBasics
