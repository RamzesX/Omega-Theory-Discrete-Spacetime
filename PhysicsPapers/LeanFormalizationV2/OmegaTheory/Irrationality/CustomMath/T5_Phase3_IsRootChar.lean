/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_IsRootChar

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 141.
  `Polynomial.IsRoot` characterization.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.IsRoot` characterizations:

  1. **`T5_isRoot_iff`** : `p.IsRoot a ↔ eval a p = 0`.
  2. **`T5_isRoot_eq_zero`** : `p.IsRoot x → eval x p = 0`.

  Used in T-5 to identify roots of the minimal polynomial of an
  algebraic α — the algebraic conjugates of α.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_IsRootChar

variable {R : Type*} [Semiring R]

/-! ## IsRoot characterization -/

/-- **Wave T5 session 141 — `IsRoot` characterization**.

    `p.IsRoot a ↔ eval a p = 0`. -/
theorem T5_isRoot_iff {p : Polynomial R} {a : R} :
    p.IsRoot a ↔ Polynomial.eval a p = 0 :=
  Polynomial.IsRoot.def

/-- **Wave T5 session 141 — `IsRoot` implies eval = 0**.

    `p.IsRoot x → eval x p = 0`. -/
theorem T5_isRoot_eq_zero {p : Polynomial R} {x : R} (h : p.IsRoot x) :
    Polynomial.eval x p = 0 :=
  h.eq_zero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 141 — IsRoot characterizations**.

    Two equivalent formulations of "x is a root of p":
    1. `IsRoot p a ↔ eval a p = 0`.
    2. `IsRoot p x → eval x p = 0`.

    Sub-lemma 29/N in T-5 Phase 3.  Lean-core only.

    Used in T-5 to identify roots of minimal polynomials — the
    algebraic conjugates of α play a key role in Roth's theorem
    (and any Diophantine approximation result on algebraic numbers). -/
theorem session_141_is_root_char_headline
    {R : Type*} [Semiring R] :
    -- (1) iff
    (∀ {p : Polynomial R} {a : R}, p.IsRoot a ↔ Polynomial.eval a p = 0)
    -- (2) →
    ∧ (∀ {p : Polynomial R} {x : R}, p.IsRoot x → Polynomial.eval x p = 0) :=
  ⟨T5_isRoot_iff, T5_isRoot_eq_zero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_IsRootChar
