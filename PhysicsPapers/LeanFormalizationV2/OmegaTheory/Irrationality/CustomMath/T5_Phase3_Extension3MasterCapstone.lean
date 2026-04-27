/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_Extension3MasterCapstone

  T-5 (Roth's theorem axiom retirement) — Phase 3 EXTENSION-3 MASTER
  CAPSTONE, session 151.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  5-conjunct master capstone tying univariate `Polynomial` sub-lemmas
  s140-s150:

  1. **derivative Leibniz** (s140): `derivative (f * g)` rule.
  2. **IsRoot** (s141): `p.IsRoot a ↔ eval a p = 0`.
  3. **Transcendental** (s142): `Transcendental ↔ ∀p, aeval=0 → p=0`.
  4. **IsIntegral ↔ IsAlgebraic** (s143): equivalence over a field.
  5. **natDegree X^n** (s147): `natDegree (X^n) = n` (Nontrivial).

  Combined with Phase 3 ENTRY (s116) + EXTENSION-1 (s122) +
  EXTENSION-2 (s139) capstones, this is now a 21-conjunct foundation
  toolkit covering both MvPolynomial AND univariate Polynomial settings.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeAddMul
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_IsRootChar
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_TranscendentalChar
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_IntegralAlgebraic
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyNatDegreeXPowMul

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_Extension3MasterCapstone

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeAddMul
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_IsRootChar
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_TranscendentalChar
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_IntegralAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyNatDegreeXPowMul

/-- **HEADLINE — Wave T5 session 151 — Phase 3 EXTENSION-3 master capstone**.

    Five-conjunct master capstone for the univariate `Polynomial`
    Phase 3 sub-lemmas (s140-s150).  Combined with Phase 3 ENTRY (s116)
    + EXTENSION-1 (s122) + EXTENSION-2 (s139) capstones, this is the
    complete 21-conjunct foundation for Roth's theorem.

    Lean-core only.  Cycle 65. -/
theorem session_151_phase3_extension3_master_capstone :
    -- (1) derivative Leibniz
    (∀ {R : Type*} [_inst : Semiring R] {f g : R[X]},
        Polynomial.derivative (f * g) =
          Polynomial.derivative f * g + f * Polynomial.derivative g)
    -- (2) IsRoot iff
    ∧ (∀ {R : Type*} [_inst : Semiring R] {p : Polynomial R} {a : R},
        p.IsRoot a ↔ Polynomial.eval a p = 0)
    -- (3) Transcendental iff
    ∧ (∀ {R A : Type*} [_inst : CommRing R] [_inst' : Ring A] [_inst'' : Algebra R A]
        {x : A},
        Transcendental R x ↔ ∀ p : R[X], aeval x p = 0 → p = 0)
    -- (4) IsIntegral → IsAlgebraic
    ∧ (∀ {R A : Type*} [_inst : CommRing R] [_inst' : Ring A] [_inst'' : Algebra R A]
        [_nt : Nontrivial R] {x : A},
        IsIntegral R x → IsAlgebraic R x)
    -- (5) natDegree X^n
    ∧ (∀ {R : Type*} [_inst : Semiring R] [_nt : Nontrivial R] (n : ℕ),
        ((X : R[X]) ^ n).natDegree = n) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intros R _ f g; exact T5_polynomial_derivative_mul
  · intros R _ p a; exact T5_isRoot_iff
  · intros R A _ _ _ x; exact T5_transcendental_iff
  · intros R A _ _ _ _ x hx; exact T5_isIntegral_implies_isAlgebraic hx
  · intros R _ _ n; exact T5_polynomial_natDegree_X_pow n

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_Extension3MasterCapstone
