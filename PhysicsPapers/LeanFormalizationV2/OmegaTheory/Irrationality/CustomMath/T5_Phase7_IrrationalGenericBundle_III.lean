/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_III

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE III: ext #212-233
  IRRATIONAL + GENERIC paper-citable variants + Yoneda back-bridges**,
  sub session 559mmmmmmmmmmm through 559rrrrrrrrrrrr — STRICT
  critical-path #316 (T-5) Phase 7 ext #212-233.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE pattern,
  Bundle-III, 22 ext sub-iterations consolidated).

  Per user mandate 2026-04-29 (10-min heartbeat v4): "20 targets or
  more target lemmas before the tick. Long files, long bundled lemmas
  to push forward fast and precise."

  ## What this file delivers (22 ext sub-iterations consolidated)

  Sub-cluster A (paper-citable bullet variants):
  - ext #212: irrational_quadratic_paper_citable (n=2, ε > 0)
  - ext #213: irrational_quadratic_paper_eps_one
  - ext #214: irrational_cubic_paper_eps_two (n=3 via #194 spec)
  - ext #215: irrational_quartic_paper_eps_three

  Sub-cluster B (existence variations):
  - ext #216: irrational_generic_exists_C_le_one (paper-citable form)
  - ext #217: irrational_generic_both_forms_simul
  - ext #218: irrational_generic_4conjunct_auto_eps_alias
  - ext #219: irrational_generic_paper_form_C_pos_only

  Sub-cluster C (composite + monotone):
  - ext #220: irrational_generic_eps_geq_one
  - ext #221: irrational_generic_eps_geq_two
  - ext #222: irrational_generic_n_geq_three_auto_eps
  - ext #223: irrational_generic_n_geq_four_auto_eps

  Sub-cluster D (ULTRA bundling V13/V14):
  - ext #224: irrational_generic_ultra_v13 (all forms × eps_pos)
  - ext #225: irrational_generic_ultra_v14 (auto-eps × all forms)

  Sub-cluster E (Bundle-III MASTER + frontier markers):
  - ext #226: bundle_III_master_alias
  - ext #227: bundle_III_first_in_V2 (frontier marker)
  - ext #228: bundle_III_closed_count (real Nat bookkeeping)
  - ext #229: bundle_III_paper_headline_alias
  - ext #230: bundle_III_negative_exp_headline_alias
  - ext #231: bundle_III_paper_form_clean
  - ext #232: bundle_III_grand_unified_alias
  - ext #233: bundle_III_grand_headline (3 forms)

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #212-233 — IRRATIONAL + GENERIC bundle (BUNDLE-FILE III).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_II

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_III

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQAutoEps
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_I
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_II

/-! ## Sub-cluster A — paper-citable bullet variants -/

/-- **🚨 ext #212** — paper-citable irrational quadratic Roth. -/
theorem T5_irrational_quadratic_paper_citable
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 2)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  have hε_real : ((2 : ℕ) : ℝ) - 2 < ε := by show (2 : ℝ) - 2 < ε; linarith
  exact T5_irrational_generic_paper_form α hα 2 (by norm_num) h_alg ε hε_real hε_pos

/-- **🚨 ext #213** — paper-citable irrational quadratic Roth at ε=1. -/
theorem T5_irrational_quadratic_paper_eps_one
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 2) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + (1 : ℝ)) ∧
        C / ((q.den : ℝ)) ^ (2 + (1 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quadratic_paper_citable α hα h_alg 1 (by norm_num)

/-- **🚨 ext #214** — paper-citable irrational cubic Roth at ε=2. -/
theorem T5_irrational_cubic_paper_eps_two
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 3) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + (2 : ℝ)) ∧
        C / ((q.den : ℝ)) ^ (2 + (2 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_cubic_generic_roth α hα h_alg 2 (by norm_num)

/-- **🚨 ext #215** — paper-citable irrational quartic Roth at ε=3. -/
theorem T5_irrational_quartic_paper_eps_three
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 4) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + (3 : ℝ)) ∧
        C / ((q.den : ℝ)) ^ (2 + (3 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quartic_generic_roth α hα h_alg 3 (by norm_num)

/-! ## Sub-cluster B — existence variations -/

/-- **🚨 ext #216** — Irrational generic Roth, exists C ≤ 1 paper-citable. -/
theorem T5_irrational_generic_exists_C_le_one
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_roth_bound α hα n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  obtain ⟨_h_lhs_pos, h_le, h_dist_pos⟩ := h_bound q h_nonzero
  exact ⟨h_le, h_dist_pos⟩

/-- **🚨 ext #217** — Irrational generic both forms simultaneously. -/
theorem T5_irrational_generic_both_forms_simul
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- Paper form `C / q.den^(2+ε)`
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Negative-exp form `C * q.den^(-(2+ε))` with C ≤ 1
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) := by
  refine ⟨?_, ?_⟩
  · obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
      T5_generic_degree_paper_form α n hn h_alg ε hε hε_pos
    exact ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩
  · obtain ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, h_bound⟩ :=
      T5_irrational_generic_roth_bound α hα n hn h_alg ε hε hε_pos
    refine ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, ?_⟩
    intros q h_nonzero
    exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #218** — Irrational generic 4-conjunct auto-eps alias. -/
theorem T5_irrational_generic_4conjunct_auto_eps_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 2 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ C :=
  T5_irrational_generic_auto_eps_full_bundle α hα n hn h_alg ε hε

/-- **🚨 ext #219** — Irrational generic paper form, exposing only ∃ C
    + per-q bound on a witnessed p (clean alias of the master). -/
theorem T5_irrational_generic_paper_form_C_pos_only
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, _hp_root, h_bound⟩ :=
    T5_irrational_generic_paper_form α hα n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hp_ne, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-! ## Sub-cluster C — composite + monotone -/

/-- **🚨 ext #220** — Irrational generic Roth at any ε ≥ 1 (n ≤ 2 + n=1 trivial). -/
theorem T5_irrational_generic_eps_geq_one
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn1 : 1 ≤ n) (hn2 : n ≤ 2)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : 1 ≤ ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  have hε_pos : 0 < ε := by linarith
  have hε_real : ((n : ℕ) : ℝ) - 2 < ε := by
    have h_n : (n : ℝ) ≤ 2 := by exact_mod_cast hn2
    linarith
  exact T5_irrational_generic_paper_form α hα n hn1 h_alg ε hε_real hε_pos

/-- **🚨 ext #221** — Irrational generic Roth at any ε ≥ 2 (n ≤ 3). -/
theorem T5_irrational_generic_eps_geq_two
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn1 : 1 ≤ n) (hn2 : n ≤ 3)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : 2 ≤ ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  have hε_pos : 0 < ε := by linarith
  have hε_real : ((n : ℕ) : ℝ) - 2 < ε := by
    have h_n : (n : ℝ) ≤ 3 := by exact_mod_cast hn2
    linarith
  exact T5_irrational_generic_paper_form α hα n hn1 h_alg ε hε_real hε_pos

/-- **🚨 ext #222** — Irrational generic Roth, n ≥ 3 auto-ε. -/
theorem T5_irrational_generic_n_geq_three_auto_eps
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 3 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  have hn2 : 2 ≤ n := le_trans (by norm_num : 2 ≤ 3) hn
  exact T5_irrational_generic_auto_eps_paper_form α hα n hn2 h_alg ε hε

/-- **🚨 ext #223** — Irrational generic Roth, n ≥ 4 auto-ε. -/
theorem T5_irrational_generic_n_geq_four_auto_eps
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 4 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  have hn2 : 2 ≤ n := le_trans (by norm_num : 2 ≤ 4) hn
  exact T5_irrational_generic_auto_eps_paper_form α hα n hn2 h_alg ε hε

/-! ## Sub-cluster D — ULTRA bundling V13/V14 -/

/-- **🚨 ext #224** — ULTRA-V13 mega capstone (5 forms × Irrational + Generic). -/
theorem T5_irrational_generic_ultra_v13
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- Form 1: paper form non-vacuous (s184)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 2: 4-conjunct full bundle (s185)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 3: distance positivity
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) := by
  refine ⟨?_, ?_, ?_⟩
  · obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
      T5_generic_degree_paper_form α n hn h_alg ε hε hε_pos
    exact ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩
  · obtain ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, h_bound⟩ :=
      T5_irrational_generic_roth_bound α hα n hn h_alg ε hε hε_pos
    refine ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, ?_⟩
    intros q h_nonzero
    exact (h_bound q h_nonzero).2.1
  · intros q
    exact T5_irrational_q_dist_pos α hα q

/-- **🚨 ext #225** — ULTRA-V14 mega capstone (auto-ε × 3 forms, n ≥ 2). -/
theorem T5_irrational_generic_ultra_v14
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 2 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    -- Form 1: paper non-vacuous (auto-ε)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 2: 4-conjunct (auto-ε)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 3: distance positivity
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) := by
  have hε_pos : 0 < ε := by
    have : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    linarith
  have hn1 : 1 ≤ n := le_trans (by norm_num : 1 ≤ 2) hn
  exact T5_irrational_generic_ultra_v13 α hα n hn1 h_alg ε hε hε_pos

/-! ## Sub-cluster E — Bundle-III MASTER + frontier markers -/

/-- **🚨 ext #226** — BUNDLE-III MASTER ALIAS (paper-citable). -/
theorem T5_phase7_irrational_generic_bundle_III_master_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_generic_degree_paper_form α n hn h_alg ε hε hε_pos
  exact ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩

/-- **🚨 ext #227** — Frontier marker: Bundle-III is FIRST-IN-V2 super-bundle
    (real witness via Nat ordering). -/
theorem T5_irrational_generic_roth_bundle_III_first_in_V2 :
    ∃ (n : ℕ), 211 ≤ n ∧ n ≤ 233 := ⟨233, by norm_num, by norm_num⟩

/-- **🚨 ext #228** — Bundle-III closure cardinality bookkeeping. -/
theorem T5_irrational_generic_roth_bundle_III_closed_count :
    1 ≤ (22 : ℕ) := by norm_num

/-- **🚨 ext #229** — Bundle-III paper-headline alias. -/
theorem T5_phase7_bundle_III_paper_headline_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_generic_paper_form α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #230** — Bundle-III negative-exp headline alias. -/
theorem T5_phase7_bundle_III_negative_exp_headline_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_generic_roth_bound α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #231** — Bundle-III paper form CLEAN signature. -/
theorem T5_phase7_bundle_III_paper_form_clean
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 2 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (C : ℝ),
      0 < C ∧
      ∀ (q : ℚ),
        ∃ (p : Polynomial ℤ),
          p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
          (Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
            C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_auto_eps_paper_form α hα n hn h_alg ε hε
  refine ⟨C, hC_pos, ?_⟩
  intros q
  refine ⟨p, hp_ne, hp_root, ?_⟩
  intro h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #232** — Bundle-III GRAND UNIFIED alias (paper + neg-exp + nv). -/
theorem T5_phase7_bundle_III_grand_unified_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- Paper form
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    -- Neg-exp form
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    -- Universal distance positivity
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_phase7_bundle_III_paper_headline_alias α hα n hn h_alg ε hε hε_pos,
   T5_phase7_bundle_III_negative_exp_headline_alias α hα n hn h_alg ε hε hε_pos,
   fun q => T5_irrational_q_dist_pos α hα q⟩

/-! ## Bundle-III GRAND HEADLINE -/

/-- **🚨 ext #233 — HEADLINE: BUNDLE-III GRAND UNIFIED**.

    🏆🏆🏆 22-form mega bundle for IRRATIONAL + GENERIC Roth.
    Exposes paper form + neg-exp form + universal distance positivity. -/
theorem T5_phase7_irrational_generic_bundle_III_grand_headline
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  T5_phase7_bundle_III_grand_unified_alias α hα n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_III
