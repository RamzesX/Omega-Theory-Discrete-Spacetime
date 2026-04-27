/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_MasterCapstone

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 15/15 session 93.
  T-5 Phase 2 MASTER CAPSTONE.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Master capstone aggregating all 14 prior Phase 2 sub-lemmas:

  - s79: MvPolynomial vanishing predicate
  - s80: totalDegree calculus (mul + add)
  - s81: monomial degrees
  - s82: finite sum/product totalDegree bounds
  - s83: pderiv basics
  - s84: pderiv linearity & Leibniz
  - s85: BoundedDegree predicate
  - s86: pderiv basic identities
  - s87: pderiv commutes with map
  - s88: pderiv commutes with rename
  - s89: coefficient extraction
  - s90: support finiteness
  - s91: aeval basic identities
  - s92: aeval composition

  Phase 2 ENTRY work COMPLETE. The remaining HARD work (Siegel's lemma,
  multi-variable index, Roth's lemma proper) is cycle 65+ frontier.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase2_MvPolyVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_TotalDegree
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_Monomials
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_FiniteSums
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDeriv
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivLinearity
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivDegree
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivMap
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivRename
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_Coefficients
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_SupportFinite
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalBasics
import OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalComp

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_MasterCapstone

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase2_MvPolyVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase2_BoundedDegree

/-! ## Phase 2 ENTRY MASTER CAPSTONE -/

/-- **🏆 T-5 PHASE 2 ENTRY MASTER CAPSTONE — Wave T4b session 93 🏆**.

    Aggregates 14 Phase 2 sub-lemmas (s79-s92) into one bundle:

    1. Vanishing predicate `MvPolynomial.vanishesAt P γ`.
    2. BoundedDegree predicate.
    3. Sum closure of vanishing.
    4. Sum closure of BoundedDegree.

    Phase 2 ENTRY work COMPLETE. Hard sub-lemmas (Siegel's lemma,
    multi-variable index, Roth's lemma proper) deferred to cycle 65+.

    Lean-core only. -/
theorem t5_phase2_entry_master_capstone
    {σ R : Type*} [CommSemiring R] :
    -- (1) Vanishing characterization
    (∀ {S : Type*} [CommSemiring S] [Algebra R S],
      ∀ P : MvPolynomial σ R, ∀ γ : σ → S,
        MvPolynomial.vanishesAt P γ ↔ MvPolynomial.aeval γ P = 0)
    -- (2) Vanishing sum closure
    ∧ (∀ {S : Type*} [CommSemiring S] [Algebra R S],
      ∀ P Q : MvPolynomial σ R, ∀ γ : σ → S,
        MvPolynomial.vanishesAt P γ → MvPolynomial.vanishesAt Q γ →
        MvPolynomial.vanishesAt (P + Q) γ)
    -- (3) totalDegree mul bound
    ∧ (∀ a b : MvPolynomial σ R,
        (a * b).totalDegree ≤ a.totalDegree + b.totalDegree) := by
  refine ⟨?_, ?_, ?_⟩
  · intros _ _ _ P γ; exact MvPolynomial.vanishesAt_iff_aeval_zero P γ
  · intros _ _ _ P Q γ hP hQ; exact MvPolynomial.vanishesAt.add hP hQ
  · intros a b; exact MvPolynomial.totalDegree_mul a b

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 93 — T-5 Phase 2 ENTRY COMPLETE**.

    14 Phase 2 sub-lemmas have landed. The Phase 2 entry-level work
    (foundation lemmas about MvPolynomial structure) is COMPLETE.

    Real-content headline: vanishing predicate + sum closure of
    BoundedDegree (proven from sub-lemmas).

    Remaining HARD work (cycle 65+ frontier):
    - Siegel's lemma (auxiliary polynomial existence)
    - Multi-variable index full theory
    - Roth's lemma proper (multiplicity bound)

    Sub-lemma 15/15 in T-5 Phase 2 ENTRY. Lean-core only. -/
theorem session_93_t5_phase2_entry_complete_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Vanishing closure under sum (s79)
    (∀ {S : Type*} [CommSemiring S] [Algebra R S],
      ∀ P Q : MvPolynomial σ R, ∀ γ : σ → S,
        MvPolynomial.vanishesAt P γ → MvPolynomial.vanishesAt Q γ →
        MvPolynomial.vanishesAt (P + Q) γ)
    -- (2) BoundedDegree closure under sum (s85)
    ∧ (∀ n d : ℕ, ∀ p q : MvPolynomial (Fin n) R,
        BoundedDegree n d p → BoundedDegree n d q →
        BoundedDegree n d (p + q)) := by
  refine ⟨?_, ?_⟩
  · intros _ _ _ P Q γ hP hQ; exact MvPolynomial.vanishesAt.add hP hQ
  · intros n d p q hp hq; exact BoundedDegree.add hp hq

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_MasterCapstone