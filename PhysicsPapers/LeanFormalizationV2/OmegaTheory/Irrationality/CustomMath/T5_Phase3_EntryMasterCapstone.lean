/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_EntryMasterCapstone

  T-5 (Roth's theorem axiom retirement) — Phase 3 ENTRY MASTER CAPSTONE,
  session 116.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  6-conjunct master capstone tying Phase 3 entry sub-lemmas s110-s115:

  1. **Schwarz** (s110)         : `pderiv` commutes.
  2. **Weighted degree** (s111) : generator-level w-hom basics.
  3. **Rename composition** (s112): aeval ∘ rename ∘ rename = aeval ∘ comp.
  4. **W-hom closure** (s113)   : `+`, `*`, `C·`, `^` preserve w-homogeneity.
  5. **PDeriv kills C** (s114)  : iterated pderiv vanishes on constants.
  6. **Power rule** (s115)      : `pderiv i (X i^n) = n * X i^(n-1)`.

  This is the SCAFFOLD for Roth's polynomial-index calculus.  All six
  facts are needed in a single proof of Roth's lemma.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivCommute
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedDegree
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalRenameRename
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedHomClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterate
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivXPow

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_EntryMasterCapstone

open MvPolynomial

open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivCommute
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalRenameRename
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedHomClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterate
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivXPow

/-- **HEADLINE — Wave T5 session 116 — Phase 3 entry master capstone**.

    Six-conjunct master capstone for the T-5 Phase 3 entry session run
    (s110-s115).  All facts are foundational for Roth's polynomial-index
    calculus.

    Lean-core only.  Cycle 65 entry. -/
theorem session_116_phase3_entry_master_capstone
    {σ R : Type*} [CommSemiring R] :
    -- (1) Schwarz commutativity
    (∀ (i j : σ) (p : MvPolynomial σ R),
        pderiv i (pderiv j p) = pderiv j (pderiv i p))
    -- (2) X i is w-hom of degree (w i)
    ∧ (∀ {M : Type*} [SemilatticeSup M] [OrderBot M] [AddCommMonoid M]
          (w : σ → M) (i : σ),
        IsWeightedHomogeneous w (X i : MvPolynomial σ R) (w i))
    -- (3) Rename composition under aeval
    ∧ (∀ {τ υ S : Type*} [CommSemiring S] [Algebra R S]
          (k : σ → τ) (f : τ → υ) (g : υ → S) (p : MvPolynomial σ R),
        (aeval g : MvPolynomial υ R →ₐ[R] S) (rename f (rename k p)) =
          (aeval (g ∘ f ∘ k) : MvPolynomial σ R →ₐ[R] S) p)
    -- (4) Mul closure for w-hom
    ∧ (∀ {M : Type*} [AddCommMonoid M]
          {w : σ → M} {φ ψ : MvPolynomial σ R} {m n : M},
        IsWeightedHomogeneous w φ m →
        IsWeightedHomogeneous w ψ n →
        IsWeightedHomogeneous w (φ * ψ) (m + n))
    -- (5) PDeriv kills constants at depth ≥ 1
    ∧ (∀ (i : σ) (r : R) (k : ℕ),
        ((pderiv i)^[k + 1] (C r : MvPolynomial σ R)) = 0)
    -- (6) Power rule
    ∧ (∀ (i : σ) (n : ℕ),
        pderiv i ((X i : MvPolynomial σ R) ^ n) =
          (n : MvPolynomial σ R) * (X i)^(n - 1)) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact T5_pderiv_pderiv_comm
  · intros M _ _ _ w i; exact T5_isWeightedHomogeneous_X w i
  · intros τ υ S _ _ k f g p; exact T5_aeval_rename_rename k f g p
  · intros M _ w φ ψ m n hφ hψ; exact T5_isWeightedHomogeneous_mul hφ hψ
  · exact T5_pderiv_iterate_C_succ
  · exact T5_pderiv_X_pow_self

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_EntryMasterCapstone
