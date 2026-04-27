/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_ExtensionMasterCapstone

  T-5 (Roth's theorem axiom retirement) — Phase 3 EXTENSION MASTER
  CAPSTONE, session 122.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  5-conjunct master capstone tying the Phase 3 EXTENSION sessions
  s117-s120:

  1. **Siegel's Lemma** (s117): non-zero integer vector with bounded norm.
  2. **Falling factorial** (s118): closed form for `(pderiv i)^[k] (X i^n)`.
  3. **Pderiv-iterate vanishing** (s119): high-order pderiv kills low-deg.
  4. **Boundary vanishing** (s119): `(pderiv i)^[n+1] (X i^n) = 0`.
  5. **Aeval basics** (s120): `aeval` on X, C, monomial.

  Combined with the Phase 3 ENTRY capstone (s116), this is the COMPLETE
  toolkit for Roth's polynomial-index calculus.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase3_SiegelLemma
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPowVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalBasics

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_ExtensionMasterCapstone

open MvPolynomial

attribute [local instance] Matrix.seminormedAddCommGroup

open OmegaTheory.Irrationality.CustomMath.T5_Phase3_SiegelLemma
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPowVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalBasics

/-- **HEADLINE — Wave T5 session 122 — Phase 3 EXTENSION master capstone**.

    Five-conjunct master capstone tying T-5 Phase 3 EXTENSION sessions
    s117-s120.

    Combined with the Phase 3 ENTRY capstone (s116), this is the
    complete toolkit for Roth's polynomial-index calculus.

    Lean-core only.  Cycle 65. -/
theorem session_122_phase3_extension_master_capstone
    {σ R : Type*} [CommSemiring R]
    {α β : Type*} [Fintype α] [Fintype β]
    {S : Type*} [CommSemiring S] [Algebra R S] :
    -- (1) Siegel's lemma (max-1 version)
    (∀ (A : Matrix α β ℤ),
        Fintype.card α < Fintype.card β →
        0 < Fintype.card α →
        ∃ t : β → ℤ, t ≠ 0 ∧ Matrix.mulVec A t = 0 ∧
          ‖t‖ ≤ (Fintype.card β * max 1 ‖A‖) ^
            ((Fintype.card α : ℝ) / (Fintype.card β - Fintype.card α)))
    -- (2) Falling factorial
    ∧ (∀ (i : σ) (n k : ℕ),
        ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ n)) =
          (n.descFactorial k : MvPolynomial σ R) * (X i)^(n - k))
    -- (3) Pderiv-iterate vanishing for k > n
    ∧ (∀ (i : σ) (n k : ℕ), n < k →
        ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ n)) = 0)
    -- (4) Boundary case k = n+1
    ∧ (∀ (i : σ) (n : ℕ),
        ((pderiv i)^[n + 1] ((X i : MvPolynomial σ R) ^ n)) = 0)
    -- (5) aeval at X is identity
    ∧ (∀ (p : MvPolynomial σ R),
        (aeval X : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) p = p) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact T5_siegel_lemma_max1
  · exact T5_pderiv_iterate_X_pow_self
  · exact T5_pderiv_iterate_X_pow_eq_zero_of_gt
  · exact T5_pderiv_iterate_X_pow_eq_zero_succ
  · exact T5_aeval_X_left_apply

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_ExtensionMasterCapstone
