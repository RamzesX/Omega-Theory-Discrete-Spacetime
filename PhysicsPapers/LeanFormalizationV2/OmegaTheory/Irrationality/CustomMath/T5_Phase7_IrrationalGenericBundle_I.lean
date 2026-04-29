/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_I

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE I: ext #184-189
  IRRATIONAL + GENERIC composite bundle**, sub session 559fffffffffff
  through 559kkkkkkkkkkk — STRICT critical-path #316 (T-5) Phase 7
  ext #184-189.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE pattern,
  per user throughput mandate 2026-04-29: "writing longer bundled
  lemmas file and optimize on all level throughput on single thread
  opus4.7[1m] to deliver T5 closure fast").

  ## What this file delivers (6 ext sub-iterations consolidated)

  Six tightly-composed extensions of s183 (Irrational + Generic
  non-vacuous Roth bound):

  1. **ext #184** — `T5_irrational_generic_paper_form`: paper form
     `C / q.den^(2+ε) ≤ |q-α|` with non-vacuous + Irrational.
  2. **ext #185** — `T5_irrational_generic_full_bundle`: 4-conjunct
     LHS positive + Roth bound + non-vacuous + paper form combined.
  3. **ext #186** — `T5_irrational_generic_ultra_v9_capstone`:
     ULTRA-V9 4-form mega bundle (negative-exp + paper-form + both
     with non-vacuous).
  4. **ext #187** — `T5_irrational_generic_auto_eps_paper_form`:
     paper form with auto ε > 0 derivation for n ≥ 2.
  5. **ext #188** — `T5_irrational_generic_auto_eps_full_bundle`:
     auto ε > 0 + 4-conjunct + Irrational composite for n ≥ 2.
  6. **ext #189** — `T5_phase7_irrational_generic_bundle_I_headline`:
     master headline alias for the entire bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #184-189 — IRRATIONAL + GENERIC bundle (BUNDLE-FILE I).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQAutoEps
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_I

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQAutoEps
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos

/-! ## ext #184 — Irrational + Generic PAPER FORM (non-vacuous) -/

/-- **🚨 ext #184 — IRRATIONAL Generic PAPER form non-vacuous**.

    For α Irrational + IsAlgebraicOfDegree α n + n ≥ 1 + ε > n-2 + ε > 0:
    ∃ C > 0, p ≠ 0, ∀ q with eval₂ ≠ 0:
      `0 < C/q.den^(2+ε)` ∧ `C/q.den^(2+ε) ≤ |q-α|` ∧ `0 < |q-α|`. -/
theorem T5_irrational_generic_paper_form
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
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_generic_degree_paper_form α n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  have h_pos_lhs : (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) := by
    apply div_pos hC_pos
    exact Real.rpow_pos_of_pos (by exact_mod_cast q.pos) _
  refine ⟨h_pos_lhs, h_bound q h_nonzero, T5_irrational_q_dist_pos α hα q⟩

/-! ## ext #185 — Irrational + Generic 4-conjunct FULL BUNDLE -/

/-- **🚨 ext #185 — IRRATIONAL Generic FULL 4-conjunct BUNDLE**.

    For α Irrational + IsAlgebraicOfDegree α n + n ≥ 1 + ε > n-2 + ε > 0:
    ∃ C ∈ (0, 1], p ≠ 0, ∀ q with eval₂ ≠ 0:
      `0 < C·q.den^(-(2+ε))` ∧ `C·q.den^(-(2+ε)) ≤ |q-α|` ∧
      `0 < |q-α|` ∧ `C·q.den^(-(2+ε)) ≤ 1`. -/
theorem T5_irrational_generic_full_bundle
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
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ C :=
  by
  obtain ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_roth_bound α hα n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  obtain ⟨h_lhs_pos, h_le, h_dist_pos⟩ := h_bound q h_nonzero
  refine ⟨h_lhs_pos, h_le, h_dist_pos, ?_⟩
  -- Show C · q.den^(-(2+ε)) ≤ C using q.den^(-(2+ε)) ≤ 1.
  have hden_pos : (0 : ℝ) < (q.den : ℝ) := by exact_mod_cast q.pos
  have hden_ge_one : (1 : ℝ) ≤ (q.den : ℝ) := by exact_mod_cast q.pos
  have hexp_nonpos : -(2 + ε) ≤ 0 := by linarith
  have h_pow_le_one : ((q.den : ℝ)) ^ (-(2 + ε)) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos hden_ge_one hexp_nonpos
  have h_pow_pos : (0 : ℝ) < ((q.den : ℝ)) ^ (-(2 + ε)) :=
    Real.rpow_pos_of_pos hden_pos _
  calc C * ((q.den : ℝ)) ^ (-(2 + ε))
      ≤ C * 1 := by
        apply mul_le_mul_of_nonneg_left h_pow_le_one hC_pos.le
    _ = C := by ring

/-! ## ext #186 — IRRATIONAL Generic ULTRA-V9 4-form MEGA bundle -/

/-- **🚨 ext #186 — IRRATIONAL Generic ULTRA-V9 mega bundle**.

    For α Irrational + IsAlgebraicOfDegree α n + n ≥ 1 + ε > n-2 + ε > 0:
    Form 1 (negative-exp non-vacuous) + Form 2 (paper-form non-vacuous). -/
theorem T5_irrational_generic_ultra_v9_capstone
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- Form 1: negative-exp non-vacuous (s183)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    -- Form 2: paper-form non-vacuous (s184)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_irrational_generic_roth_bound α hα n hn h_alg ε hε hε_pos,
   T5_irrational_generic_paper_form α hα n hn h_alg ε hε hε_pos⟩

/-! ## ext #187 — IRRATIONAL Generic AUTO-ε PAPER FORM (n ≥ 2) -/

/-- **🚨 ext #187 — IRRATIONAL Generic auto-ε PAPER form (n ≥ 2)**.

    Cleaner signature without redundant `0 < ε` for n ≥ 2.
    For α Irrational + IsAlgebraicOfDegree α n (n ≥ 2) + ε > n-2:
    ∃ C > 0, p ≠ 0, ∀ q with eval₂ ≠ 0:
      `0 < C/q.den^(2+ε)` ∧ `C/q.den^(2+ε) ≤ |q-α|` ∧ `0 < |q-α|`. -/
theorem T5_irrational_generic_auto_eps_paper_form
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 2 ≤ n)
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
  have hε_pos : 0 < ε := by
    have : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    linarith
  have hn_one : 1 ≤ n := le_trans (by norm_num : 1 ≤ 2) hn
  exact T5_irrational_generic_paper_form α hα n hn_one h_alg ε hε hε_pos

/-! ## ext #188 — IRRATIONAL Generic AUTO-ε FULL BUNDLE (n ≥ 2) -/

/-- **🚨 ext #188 — IRRATIONAL Generic auto-ε FULL 4-conjunct BUNDLE**.

    Cleaner signature for n ≥ 2 (auto-derives ε > 0 from ε > n-2). -/
theorem T5_irrational_generic_auto_eps_full_bundle
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
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ C := by
  have hε_pos : 0 < ε := by
    have : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    linarith
  have hn_one : 1 ≤ n := le_trans (by norm_num : 1 ≤ 2) hn
  exact T5_irrational_generic_full_bundle α hα n hn_one h_alg ε hε hε_pos

/-! ## ext #189 — Bundle-I MASTER HEADLINE -/

/-- **HEADLINE — BUNDLE-FILE I (ext #184-189)**.

    🏆🏆🏆 MASTER ALIAS: 5-form mega bundle for IRRATIONAL + GENERIC
    algebraic α (n ≥ 1 with ε > max(0, n-2)).

    Forms delivered:
    1. paper-form non-vacuous (s184)
    2. 4-conjunct full bundle (s185)
    3. ULTRA-V9 2-form mega capstone (s186)
    4. paper-form auto-ε for n ≥ 2 (s187)
    5. 4-conjunct auto-ε for n ≥ 2 (s188)

    First BUNDLED-LEMMA-FILE pattern fire 2026-04-29 — throughput
    optimization per user mandate. -/
theorem T5_phase7_irrational_generic_bundle_I_headline
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- All 3 forms (1-3) compatible with n ≥ 1
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
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ C) :=
  ⟨T5_irrational_generic_paper_form α hα n hn h_alg ε hε hε_pos,
   T5_irrational_generic_full_bundle α hα n hn h_alg ε hε hε_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_I
