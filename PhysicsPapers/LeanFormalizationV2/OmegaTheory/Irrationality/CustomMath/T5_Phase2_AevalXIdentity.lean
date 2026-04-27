/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalXIdentity

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub session 108.
  MvPolynomial.aeval at X is identity (canonical evaluation).

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-export of MvPolynomial.aeval_X_left:

      `aeval X = AlgHom.id R (MvPolynomial σ R)`
      `aeval X p = p`

  This is the universal property of MvPolynomial: variable evaluation
  at the variables themselves is the identity.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Eval

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalXIdentity

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## aeval at X is identity -/

/-- **Wave T4b session 108 — aeval at X is the identity AlgHom**. -/
theorem T5_aeval_X_left :
    (aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) =
      AlgHom.id R (MvPolynomial σ R) :=
  MvPolynomial.aeval_X_left

/-- **Wave T4b session 108 — aeval X p = p**. -/
theorem T5_aeval_X_left_apply (p : MvPolynomial σ R) :
    (aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) p = p :=
  MvPolynomial.aeval_X_left_apply p

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 108 — aeval at X is identity**.

    Two equivalent forms:
    1. `aeval X = AlgHom.id R (MvPolynomial σ R)` (function-level)
    2. `aeval X p = p` (point-wise)

    Lean-core only. -/
theorem session_108_aeval_X_identity_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) AlgHom-level
    ((aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) =
      AlgHom.id R (MvPolynomial σ R))
    -- (2) Point-wise
    ∧ (∀ p : MvPolynomial σ R,
        (aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) p = p) := by
  refine ⟨T5_aeval_X_left, T5_aeval_X_left_apply⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalXIdentity
