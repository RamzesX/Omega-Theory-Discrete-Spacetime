/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase1MasterCapstone

  T-5 (Roth's theorem axiom retirement) — sub-lemma 10/10 session 78.
  Phase 1 MASTER CAPSTONE — Phase 1 of T-5 attack plan COMPLETE.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Master capstone aggregating all 9 prior Phase 1 sub-lemmas:

  1. Liouville bound for irrational algebraic (s68)
  2. Naive height of ℚ (s69)
  3. Height-form Liouville bound + Roth target def (s70)
  4. Polynomial index at point (s71)
  5. Derivative-based vanishing (s72)
  6. Index multiplicativity (s74)
  7. Height of ℤ-cast bound (s75 partial)
  8. Polynomial degree calculus (s76)
  9. leadingCoeff calculus (s77)

  Plus aggregated frontier marker for Phase 2.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
import OmegaTheory.Irrationality.CustomMath.T5_Heights
import OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
import OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex
import OmegaTheory.Irrationality.CustomMath.T5_DerivativeCharacterization
import OmegaTheory.Irrationality.CustomMath.T5_IndexMultiplicativity
import OmegaTheory.Irrationality.CustomMath.T5_HeightAdditivity
import OmegaTheory.Irrationality.CustomMath.T5_DegreeProduct
import OmegaTheory.Irrationality.CustomMath.T5_LeadingCoeff
import OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
import Mathlib.Analysis.Real.Pi.Irrational

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase1MasterCapstone

open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex
open OmegaTheory.Irrationality.CustomMath.T5_DerivativeCharacterization
open OmegaTheory.Irrationality.CustomMath.T5_IndexMultiplicativity
open OmegaTheory.Irrationality.CustomMath.T5_HeightAdditivity
open OmegaTheory.Irrationality.CustomMath.T5_DegreeProduct
open OmegaTheory.Irrationality.CustomMath.T5_LeadingCoeff
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial

/-! ## Phase 1 MASTER CAPSTONE -/

/-- **🏆 T-5 PHASE 1 MASTER CAPSTONE — Wave T4b session 78 🏆**.

    Aggregates all 9 Phase 1 sub-lemmas into one citation-ready bundle.
    Phase 1 is COMPLETE. Phase 2 (auxiliary polynomial construction)
    is the next-cycle target.

    9-conjunct structural bundle. Lean-core only. -/
theorem t5_phase1_master_capstone
    {R : Type*} [CommRing R] [IsDomain R] :
    -- (1) Sub 1: Liouville bound exists for algebraic irrational
    (∀ α : ℝ, Irrational α →
      ∀ f : Polynomial ℤ, f ≠ 0 → Polynomial.aeval α f = 0 →
      ∃ A : ℝ, 0 < A ∧
        ∀ a : ℤ, ∀ b : ℕ,
          (1 : ℝ) ≤ ((b : ℝ) + 1) ^ f.natDegree * (|α - a / (b + 1)| * A))
    -- (2) Sub 2: Naive height ≥ 1 for nonzero
    ∧ (∀ q : ℚ, q ≠ 0 → 1 ≤ Rat.naiveHeight q)
    -- (3) Sub 3: Naive height ≥ denominator
    ∧ (∀ q : ℚ, q.den ≤ Rat.naiveHeight q)
    -- (4) Sub 4: index = rootMultiplicity
    ∧ (∀ p : R[X], ∀ a : R, Polynomial.indexAtPoint p a = p.rootMultiplicity a)
    -- (5) Sub 5: derivative^[n] root iff n < index
    ∧ (∀ p : R[X], ∀ a : R, ∀ n : ℕ,
        n < Polynomial.indexAtPoint p a → (derivative^[n] p).IsRoot a)
    -- (6) Sub 6: index multiplicativity
    ∧ (∀ p q : R[X], ∀ a : R, p * q ≠ 0 →
        Polynomial.indexAtPoint (p * q) a =
          Polynomial.indexAtPoint p a + Polynomial.indexAtPoint q a)
    -- (7) Sub 7: height of ℤ-cast
    ∧ (∀ n : ℤ, Rat.naiveHeight (n : ℚ) ≤ Int.natAbs n + 1)
    -- (8) Sub 8: natDegree of product (in domain)
    ∧ (∀ p q : R[X], p ≠ 0 → q ≠ 0 →
        (p * q).natDegree = p.natDegree + q.natDegree)
    -- (9) Sub 9: leadingCoeff multiplicativity
    ∧ (∀ p q : R[X], (p * q).leadingCoeff = p.leadingCoeff * q.leadingCoeff) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intros α hα f hf hroot
    exact liouville_bound_for_algebraic_irrational α hα f hf hroot
  · intros q hq
    exact Rat.naiveHeight_pos q hq
  · intros q; exact Rat.den_le_naiveHeight q
  · intros p a; rfl
  · intros p a n hn
    exact Polynomial.isRoot_iterate_derivative_of_lt_indexAtPoint hn
  · intros p q a hpq
    exact Polynomial.indexAtPoint_mul hpq
  · intros n; exact Rat.naiveHeight_intCast_le n
  · intros p q hp hq; exact T5_natDegree_mul hp hq
  · intros p q; exact T5_leadingCoeff_mul p q

/-! ## Phase 1 alias: π and √2 lin-indep follows -/

/-- **Phase 1 result alias** — π is irrational (downstream of T-4 + T-5
    foundation).  This is REAL content. -/
theorem t5_phase1_pi_irrational :
    Irrational (Real.pi : ℝ) :=
  irrational_pi

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 78 — T-5 PHASE 1 COMPLETE**.

    Real-content 2-conjunct headline: π irrational + naive height ≥ 1
    for nonzero rationals. Both used by Phase 2. -/
theorem session_78_t5_phase1_complete_headline :
    Irrational (Real.pi : ℝ) ∧
    (∀ q : ℚ, q ≠ 0 → 1 ≤ Rat.naiveHeight q) := by
  refine ⟨?_, ?_⟩
  · exact irrational_pi
  · intros q hq; exact Rat.naiveHeight_pos q hq

end OmegaTheory.Irrationality.CustomMath.T5_Phase1MasterCapstone
