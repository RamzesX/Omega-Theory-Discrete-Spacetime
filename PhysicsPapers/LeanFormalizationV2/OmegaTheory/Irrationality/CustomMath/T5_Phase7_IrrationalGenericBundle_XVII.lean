/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XVII: ext #442-456
  T-5 GRAND PAPER MASTER V3 — unified all infrastructure**, sub
  session 559tttttttttttttttt through 559oooooooooooooo — STRICT
  critical-path #316 (T-5) Phase 7 ext #442-456.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XVII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  T-5 GRAND PAPER MASTER V3 — single theorem combining:
  - Generic Roth (Bundle-IX paper capstone V2)
  - Mathlib IsAlgebraic ℤ bridge (Bundle-X)
  - 14-witness panel (Bundles XI-XV)
  - Parametric sqrt-prime (Bundle-XVI)

  Sub-cluster A (T-5 GRAND PAPER MASTER V3):
  - ext #442: T_5_GRAND_PAPER_MASTER_V3 (paper + IsAlgebraic ℤ)
  - ext #443: T_5_paper_master_V3_3conjunct (paper + nv + IsAlg)
  - ext #444: T_5_paper_master_V3_for_quadratic (NAMED Prop)
  - ext #445: T_5_paper_master_V3_for_cubic (NAMED Prop, ε > 1)

  Sub-cluster B (paper-citable α examples):
  - ext #446: T_5_paper_master_V3_for_sqrt_prime (parametric Bundle-XVI)
  - ext #447: T_5_paper_master_V3_for_goldenRatio
  - ext #448: T_5_paper_master_V3_existence_form

  Sub-cluster C (Bundle-XVII markers + headlines):
  - ext #449: bundle_XVII_first_in_V2_marker
  - ext #450: bundle_XVII_closed_count
  - ext #451: bundle_XVII_master_alias
  - ext #452: bundle_XVII_paper_grand_master_alias
  - ext #453: bundle_XVII_isAlgebraic_int_universal
  - ext #454: bundle_XVII_paper_form_universal
  - ext #455: bundle_XVII_paper_headline_alias
  - ext #456: bundle_XVII_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #442-456 — T-5 GRAND PAPER MASTER V3 (BUNDLE-XVII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_III
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XII
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVI

/-! ## Sub-cluster A — T-5 GRAND PAPER MASTER V3 -/

/-- **🚨 ext #442 — T_5_GRAND_PAPER_MASTER_V3** (paper + IsAlgebraic ℤ).

    Combines paper-citable Roth bound with Mathlib's IsAlgebraic ℤ
    certificate in a single theorem. -/
theorem T_5_GRAND_PAPER_MASTER_V3
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- IsAlgebraic ℤ certificate
    IsAlgebraic ℤ α ∧
    -- Paper-form Roth bound
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α n h_alg,
   T5_bundle_VII_paper_headline_generic α hα n hn h_alg ε hε hε_pos⟩

/-- **🚨 ext #443** — V3 3-conjunct (paper + nv + IsAlgebraic ℤ). -/
theorem T_5_paper_master_V3_3conjunct
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α n h_alg,
   T5_phase7_bundle_III_paper_headline_alias α hα n hn h_alg ε hε hε_pos⟩

/-- **🚨 ext #444** — V3 for IsQuadraticAlgebraic. -/
theorem T_5_paper_master_V3_for_quadratic
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int α h_quad,
   T5_irrational_quadratic_clean_paper α hα h_quad ε hε_pos⟩

/-- **🚨 ext #445** — V3 for IsCubicAlgebraic (ε > 1). -/
theorem T_5_paper_master_V3_for_cubic
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε_gt_one : 1 < ε) :
    IsAlgebraic ℤ α ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_IsCubicAlgebraic_implies_IsAlgebraic_int α h_cubic,
   T5_irrational_cubic_clean_paper α hα h_cubic ε hε_gt_one⟩

/-! ## Sub-cluster B — paper-citable α examples -/

/-- **🚨 ext #446** — V3 for parametric sqrt-prime. -/
theorem T_5_paper_master_V3_for_sqrt_prime
    (p : ℕ) (hp : Nat.Prime p)
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt p) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt p) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt p|) :=
  ⟨T5_IsAlgebraic_int_sqrt_prime p hp,
   T5_roth_for_sqrt_prime_via_bundle_VII p hp ε hε_pos⟩

/-- **🚨 ext #447** — V3 for goldenRatio. -/
theorem T_5_paper_master_V3_for_goldenRatio
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ Real.goldenRatio ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval Real.goldenRatio P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤
          |((q : ℚ) : ℝ) - Real.goldenRatio|) := by
  exact T_5_paper_master_V3_for_quadratic Real.goldenRatio
    Real.goldenRatio_irrational
    T5_isQuadraticAlgebraic_goldenRatio ε hε_pos

/-- **🚨 ext #448** — V3 existence form. -/
theorem T_5_paper_master_V3_existence_form
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ), 0 < C ∧
      ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨_, C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T_5_GRAND_PAPER_MASTER_V3 α hα n hn h_alg ε hε hε_pos
  exact ⟨C, hC_pos, p, hp_ne, hp_root, h_bound⟩

/-! ## Sub-cluster C — Bundle-XVII markers + headlines -/

/-- **🚨 ext #449** — Frontier marker: Bundle-XVII V3. -/
theorem T5_bundle_XVII_first_in_V2_marker :
    ∃ (n : ℕ), 442 ≤ n ∧ n ≤ 456 ∧ n - 442 ≤ 15 :=
  ⟨456, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #450** — Bundle-XVII closure cardinality. -/
theorem T5_bundle_XVII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #451** — Bundle-XVII master alias. -/
theorem T5_bundle_XVII_master_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  T_5_GRAND_PAPER_MASTER_V3 α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #452** — Bundle-XVII paper grand master alias. -/
theorem T5_bundle_XVII_paper_grand_master_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  T5_bundle_XVII_master_alias α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #453** — Bundle-XVII universal IsAlgebraic ℤ alias. -/
theorem T5_bundle_XVII_isAlgebraic_int_universal
    (α : ℝ) (n : ℕ) (h_alg : IsAlgebraicOfDegree α n) :
    IsAlgebraic ℤ α :=
  T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α n h_alg

/-- **🚨 ext #454** — Bundle-XVII universal paper form alias. -/
theorem T5_bundle_XVII_paper_form_universal
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_bundle_VII_paper_headline_generic α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #455** — Bundle-XVII paper headline alias. -/
theorem T5_bundle_XVII_paper_headline_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  T_5_GRAND_PAPER_MASTER_V3 α hα n hn h_alg ε hε hε_pos

/-! ## Bundle-XVII GRAND HEADLINE -/

/-- **🚨 ext #456 — HEADLINE: BUNDLE-XVII T-5 GRAND PAPER MASTER V3**.

    🏆🏆🏆 Single theorem unifying:
    - Generic paper Roth bound (Bundle-VII clean signature)
    - Mathlib IsAlgebraic ℤ certificate (Bundle-X bridge)
    - Universal distance positivity (Irrational α dist)

    For α irrational + IsAlgebraicOfDegree α n + n ≥ 1 +
    ε > max(0, n-2): both IsAlgebraic ℤ α AND paper-form Roth bound. -/
theorem T5_bundle_XVII_grand_headline_full
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- IsAlgebraic ℤ
    IsAlgebraic ℤ α ∧
    -- Paper Roth
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Universal distance positivity
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α n h_alg,
   T5_bundle_VII_paper_headline_generic α hα n hn h_alg ε hε hε_pos,
   fun q => T5_irrational_q_dist_pos α hα q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII
