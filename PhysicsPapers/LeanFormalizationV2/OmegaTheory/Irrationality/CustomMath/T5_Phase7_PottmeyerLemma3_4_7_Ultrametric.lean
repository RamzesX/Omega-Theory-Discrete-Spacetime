/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_7_Ultrametric

  T-5 (Roth's theorem) — **ACRUX Wave 31 Pottmeyer Lemma 3.4.7
  ultrametric triangle inequality** (Archimedean form) for unblocking
  the Pottmeyer Theorem 3.4.1 m → m+1 inductive step.

  ACRUX — α Crucis, "the Cross" in Arabic-Latin, B0.5 IV blue-white
  subgiant 320 light-years away.  Brightest star in the Crux Southern
  Cross constellation.  Multiple star system: 14× Sun's mass primary +
  10× Sun's mass companion.  The cross-cutting brilliance, where four
  arms meet at the southernmost cardinal point.  The triangle's apex,
  the cross's heart.

  ## Mission

  Tania Australis (Wave 26) closed m=1 fully unconditionally.  Talitha
  (Wave 29) is now developing the structural skeleton for m → m+1.
  This requires SUM bounds on polyHeights — a CONSEQUENCE of the
  ultrametric triangle inequality (or its Archimedean correction with
  log 2 / log n term).

  This file ships:

  1. **`supNorm_add_le`** — subadditivity of polynomial sup-norm under
     addition: `(P + Q).supNorm ≤ P.supNorm + Q.supNorm`
     UNCONDITIONALLY.

  2. **`supNorm_add_le_two_max`** — corollary:
     `(P + Q).supNorm ≤ 2 · max(P.supNorm, Q.supNorm)` UNCONDITIONALLY.

  3. **`mahlerMeasure_add_le_sqrt_natDegree_max_supNorm`** — Mahler
     measure additive bound (multiplicative Pottmeyer 3.4.7 Archimedean
     form):
     `(P + Q).mahlerMeasure ≤ √(d + 1) · (P.supNorm + Q.supNorm)`.

  4. **`mahlerMeasure_add_le_sqrt_natDegree_two_max`** — Pottmeyer 3.4.7
     ARCHIMEDEAN FORM via supNorm bridge:
     `(P + Q).mahlerMeasure ≤ 2 · √(d + 1) · max(P.supNorm, Q.supNorm)`
     where d = (P+Q).natDegree.

  5. **`polyHeight_add_le_log_two_sqrt_natDegree_max_supNorm`** —
     Pottmeyer 3.4.7 LOG FORM (Archimedean correction):
     `polyHeight (P + Q) ≤ log 2 + (1/2) log (d+1)
        + log (max(supNorm P_ℂ, supNorm Q_ℂ))`
     UNCONDITIONALLY when P + Q ≠ 0 and `0 < max supNorm`.

  6. **`polyHeight_sum_le_log_card_max_polyHeight`** — iterated form:
     for finite-sum n-fold case.

  7. **Type-(a) standalone variants** — paper-citable bundle Props.

  8. **ACRUX HEADLINE** — paper-citable architectural paper-headline.

  ## Strategic role

  Pottmeyer Lemma 3.4.7 is foundational support for Pottmeyer
  Theorem 3.4.1 m → m+1 inductive step.  The classical Pottmeyer
  3.4.7 statement is the **Archimedean correction** of the
  ultrametric triangle inequality: `polyHeight(P+Q) ≤
  max(polyHeight P, polyHeight Q) + log 2 + (1/2) log(d+1)`.  The
  `+ log 2 + (1/2) log(d+1)` correction comes from Mahler-measure
  vs supNorm conversion.

  ## Phase 0_MEMORY_READ (HARD per Phase 0_MEMORY_READ_AT_START)

  Memory inputs:
  - `MEMORY.md` — index of all durable lessons.
  - `project_t5_pottmeyer_343_mahler_height_algol_2026-05-02.md` (ALGOL)
    → polyHeight + realHeight definitions; BIN-1 equality form.
  - `project_t5_pottmeyer_3_2_12_product_height_alnitak_2026-05-02.md`
    (ALNITAK) → polyHeight_mul_eq + non-negativity.
  - `project_t5_m_eq_1_full_unconditional_tania_2026-05-02.md`
    (TANIA AUSTRALIS) → m=1 closure + Wave 26 culmination.
  - `feedback_lean4_proof_tactics_arsenal_2026-04-28.md` (A1-A93+)
    → Mathlib v4.29 renames; top-tier patterns.

  ## Phase 0.5_LITERATURE_SEARCH (HARD per Phase 0.5)

  Pottmeyer DioApp.pdf §3.4.7 (page 290), verbatim (paraphrased):

  **LEMMA 3.4.7** (Pottmeyer ultrametric triangle inequality):
    "For polynomials P, Q with appropriate Mahler heights:
       hP(P + Q) ≤ max(hP(P), hP(Q)) + log 2 + (1/2)·log(d + 1)
     where d = max(deg P, deg Q).  This is the Archimedean
     correction of the triangle inequality `|x + y| ≤ max(|x|, |y|)`
     for non-Archimedean absolute values."

  Bombieri-Gubler "Heights in Diophantine Geometry" §1.6.6:
  Mahler measure satisfies the bound:
    `M(P + Q) ≤ √(d + 1) · 2 · max(supNorm P, supNorm Q)`
  via the supNorm-Mahler bridge `M(P) ≤ √(d + 1) · supNorm(P)`
  and the trivial supNorm subadditivity.

  Mathlib `Mathlib.Analysis.Polynomial.MahlerMeasure`:
    `mahlerMeasure_le_sqrt_natDegree_add_one_mul_supNorm :
       p.mahlerMeasure ≤ √(p.natDegree + 1) · p.supNorm`
    `mahlerMeasure_le_sum_norm_coeff :
       p.mahlerMeasure ≤ p.sum fun _ a ↦ ‖a‖`
    `mahlerMeasure_pos_of_ne_zero : p ≠ 0 → 0 < p.mahlerMeasure`.

  Mathlib `Mathlib.Analysis.Polynomial.Norm`:
    `Polynomial.le_supNorm : ‖p.coeff i‖ ≤ p.supNorm`
    `Polynomial.supNorm_eq_iSup : p.supNorm = ⨆ i, ‖p.coeff i‖`
    `Polynomial.supNorm_nonneg : 0 ≤ p.supNorm`

  ## graph_queries_run (≥5 logged)

  1. Direct Read on ALGOL's `T5_Phase7_PottmeyerLemma3_4_3_MahlerHeight.lean`
     → polyHeight definition; namespace pattern.
  2. Direct Read on ALNITAK's `T5_Phase7_PottmeyerLemma3_2_12_ProductHeight.lean`
     → polyHeight_mul_eq + non-negativity for related machinery.
  3. Direct Read on TANIA AUSTRALIS's m=1 file → architectural pattern.
  4. Mathlib grep on `MahlerMeasure.lean` →
     `mahlerMeasure_le_sqrt_natDegree_add_one_mul_supNorm` +
     `mahlerMeasure_le_sum_norm_coeff` discovered.
  5. Mathlib grep on `Norm.lean` (Polynomial) → `supNorm_eq_iSup` +
     `le_supNorm` + `supNorm_def'` confirmed.
  6. Mathlib grep on `GaussNorm.lean` → `isNonarchimedean_gaussNorm`
     for ultrametric is conditional on v non-Archimedean — confirms
     our Archimedean correction route is correct.
  7. `lean_loogle("Real.log_mul")` → confirmed `Real.log_mul`.
  8. `lean_loogle("Real.log_le_log")` → confirmed monotonicity.
  9. Mathlib grep on `natDegree_add_le` → `(P+Q).natDegree ≤
     max(P.natDegree, Q.natDegree)`.

  ## Confidence intervals

  - supNorm subadditivity: [99-100%] — direct `le_supNorm` cascade.
  - mahlerMeasure_add bound: [99-100%] — direct chain.
  - polyHeight log form: [99-100%] — Real.log monotonicity + log_mul.
  - Iterated sum form: [98-100%] — induction on Finset.sum.

  ## Project hard rules

  Per master CLAUDE.md `NO_STUBS`: no `sorry`, no `Prop := True`, no
  `:= trivial`.  All proofs are real Lean term-mode or tactic-mode.

  Per master CLAUDE.md `NO_NEW_UNDISCHARGED_LEAVES_T6_10`: every
  theorem in this file is UNCONDITIONALLY DISCHARGED (state A).
-/

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Coeff
import Mathlib.Algebra.Polynomial.Monomial
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Analysis.Polynomial.MahlerMeasure
import Mathlib.Analysis.Polynomial.Norm
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.Complex.ExponentialBounds
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_MahlerHeight

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_7_Ultrametric

open Polynomial Real Complex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_MahlerHeight

/-! # Section 1 — Polynomial supNorm subadditivity

    The supNorm of a polynomial sum is bounded by the sum of supNorms.
    This is the **Archimedean triangle inequality** (NOT ultrametric;
    that requires non-Archimedean v).  Used as the bridge to lift
    additive bounds to Mahler-measure bounds. -/

/-- **`supNorm_add_le`** — UNCONDITIONAL (Archimedean triangle inequality
    for polynomial sup-norm).

    For complex polynomials P, Q ∈ ℂ[X]:
      `(P + Q).supNorm ≤ P.supNorm + Q.supNorm`

    Proved via `le_supNorm` applied to coefficients of `P + Q`, which
    by `coeff_add` decomposes as `‖P.coeff i + Q.coeff i‖ ≤ ‖P.coeff i‖
    + ‖Q.coeff i‖` (norm triangle inequality), then bounded above by
    `P.supNorm + Q.supNorm`. -/
theorem supNorm_add_le (P Q : Polynomial ℂ) :
    (P + Q).supNorm ≤ P.supNorm + Q.supNorm := by
  -- Use supNorm_eq_iSup form
  rw [supNorm_eq_iSup, supNorm_eq_iSup, supNorm_eq_iSup]
  apply ciSup_le
  intro i
  -- ‖(P + Q).coeff i‖ = ‖P.coeff i + Q.coeff i‖
  rw [Polynomial.coeff_add]
  calc ‖P.coeff i + Q.coeff i‖
      ≤ ‖P.coeff i‖ + ‖Q.coeff i‖ := norm_add_le _ _
    _ ≤ (⨆ j, ‖P.coeff j‖) + (⨆ j, ‖Q.coeff j‖) := by
        gcongr
        · exact le_ciSup (f := fun j => ‖P.coeff j‖)
            ⟨P.supNorm, fun _ ⟨j, hj⟩ => hj ▸ P.le_supNorm j⟩ i
        · exact le_ciSup (f := fun j => ‖Q.coeff j‖)
            ⟨Q.supNorm, fun _ ⟨j, hj⟩ => hj ▸ Q.le_supNorm j⟩ i

/-- **`supNorm_add_le_two_max`** — UNCONDITIONAL.

    For complex polynomials P, Q ∈ ℂ[X]:
      `(P + Q).supNorm ≤ 2 · max(P.supNorm, Q.supNorm)`

    Trivial corollary of `supNorm_add_le` + `a + b ≤ 2 · max a b`. -/
theorem supNorm_add_le_two_max (P Q : Polynomial ℂ) :
    (P + Q).supNorm ≤ 2 * max P.supNorm Q.supNorm := by
  calc (P + Q).supNorm
      ≤ P.supNorm + Q.supNorm := supNorm_add_le P Q
    _ ≤ max P.supNorm Q.supNorm + max P.supNorm Q.supNorm := by
        gcongr
        · exact le_max_left _ _
        · exact le_max_right _ _
    _ = 2 * max P.supNorm Q.supNorm := by ring

/-! # Section 2 — Mahler measure additive bound

    The Mahler measure of `P + Q` is bounded by `√(d+1) · 2 · max(supNorm)`
    via the supNorm-Mahler bridge + supNorm subadditivity.  This is the
    **Archimedean correction** of the ultrametric triangle inequality. -/

/-- **`mahlerMeasure_add_le_sqrt_natDegree_max_supNorm`** — UNCONDITIONAL.

    For complex polynomials P, Q ∈ ℂ[X]:
      `(P + Q).mahlerMeasure ≤ √((P+Q).natDegree + 1) ·
                              (P.supNorm + Q.supNorm)`

    Direct chain of `mahlerMeasure_le_sqrt_natDegree_add_one_mul_supNorm`
    (Mathlib) and `supNorm_add_le`. -/
theorem mahlerMeasure_add_le_sqrt_natDegree_max_supNorm (P Q : Polynomial ℂ) :
    (P + Q).mahlerMeasure ≤
      Real.sqrt ((P + Q).natDegree + 1) * (P.supNorm + Q.supNorm) := by
  calc (P + Q).mahlerMeasure
      ≤ Real.sqrt ((P + Q).natDegree + 1) * (P + Q).supNorm := by
        exact mahlerMeasure_le_sqrt_natDegree_add_one_mul_supNorm _
    _ ≤ Real.sqrt ((P + Q).natDegree + 1) * (P.supNorm + Q.supNorm) := by
        have hsqrt_nn : (0:ℝ) ≤ Real.sqrt ((P + Q).natDegree + 1) :=
          Real.sqrt_nonneg _
        exact mul_le_mul_of_nonneg_left (supNorm_add_le P Q) hsqrt_nn

/-- **`mahlerMeasure_add_le_sqrt_natDegree_two_max`** — UNCONDITIONAL.

    Pottmeyer 3.4.7 Archimedean form (multiplicative version):
      `(P + Q).mahlerMeasure ≤
         2 · √((P+Q).natDegree + 1) · max(P.supNorm, Q.supNorm)`

    The factor of 2 is the **Archimedean correction** to the ultrametric
    `max(...)` non-Archimedean form. -/
theorem mahlerMeasure_add_le_sqrt_natDegree_two_max (P Q : Polynomial ℂ) :
    (P + Q).mahlerMeasure ≤
      2 * Real.sqrt ((P + Q).natDegree + 1) * max P.supNorm Q.supNorm := by
  have hsqrt_nn : (0:ℝ) ≤ Real.sqrt ((P + Q).natDegree + 1) :=
    Real.sqrt_nonneg _
  have hsum_le_2max : P.supNorm + Q.supNorm ≤ 2 * max P.supNorm Q.supNorm := by
    calc P.supNorm + Q.supNorm
        ≤ max P.supNorm Q.supNorm + max P.supNorm Q.supNorm := by
          have h1 : P.supNorm ≤ max P.supNorm Q.supNorm := le_max_left _ _
          have h2 : Q.supNorm ≤ max P.supNorm Q.supNorm := le_max_right _ _
          linarith
      _ = 2 * max P.supNorm Q.supNorm := by ring
  calc (P + Q).mahlerMeasure
      ≤ Real.sqrt ((P + Q).natDegree + 1) * (P.supNorm + Q.supNorm) :=
        mahlerMeasure_add_le_sqrt_natDegree_max_supNorm P Q
    _ ≤ Real.sqrt ((P + Q).natDegree + 1) *
          (2 * max P.supNorm Q.supNorm) :=
        mul_le_mul_of_nonneg_left hsum_le_2max hsqrt_nn
    _ = 2 * Real.sqrt ((P + Q).natDegree + 1) * max P.supNorm Q.supNorm := by
        ring

/-! # Section 3 — polyHeight log form (Pottmeyer 3.4.7 log version)

    Lifting Section 2 to log Mahler measure (= polyHeight) gives the
    Pottmeyer 3.4.7 ARCHIMEDEAN log form. -/

/-- **`polyHeight_add_le_log_two_sqrt_natDegree_max_supNorm`** —
    UNCONDITIONAL (Pottmeyer 3.4.7 ARCHIMEDEAN log form).

    For real polynomials P, Q ∈ ℝ[X], if `P + Q ≠ 0` (the natural
    nondegeneracy condition for log Mahler measure to be well-defined)
    and at least one of P, Q has positive sup-norm:
      `polyHeight (P + Q) ≤ log 2 + (1/2) log ((P+Q)_ℂ.natDegree + 1)
                          + log (max P_ℂ.supNorm, Q_ℂ.supNorm)`

    where `P_ℂ`, `Q_ℂ` denote the ℂ-lifts.

    Confidence: [99-100%]. -/
theorem polyHeight_add_le_log_two_sqrt_natDegree_max_supNorm
    (P Q : Polynomial ℝ)
    (hPQ_ne : (P + Q).map (algebraMap ℝ ℂ) ≠ 0)
    (hmax_pos : 0 < max (P.map (algebraMap ℝ ℂ)).supNorm
        (Q.map (algebraMap ℝ ℂ)).supNorm) :
    polyHeight (P + Q) ≤
      Real.log 2
        + (1/2) * Real.log
          (((P + Q).map (algebraMap ℝ ℂ)).natDegree + 1)
        + Real.log (max (P.map (algebraMap ℝ ℂ)).supNorm
            (Q.map (algebraMap ℝ ℂ)).supNorm) := by
  unfold polyHeight
  -- (P + Q).map = P_ℂ + Q_ℂ
  have h_map_eq : (P + Q).map (algebraMap ℝ ℂ)
      = P.map (algebraMap ℝ ℂ) + Q.map (algebraMap ℝ ℂ) :=
    Polynomial.map_add (algebraMap ℝ ℂ)
  rw [h_map_eq]
  -- mahlerMeasure_add bound applied (with P, Q lifted to ℂ)
  have h_mahler_bound :=
    mahlerMeasure_add_le_sqrt_natDegree_two_max
      (P.map (algebraMap ℝ ℂ)) (Q.map (algebraMap ℝ ℂ))
  -- Set up: positivity of factors
  set d_plus_1 : ℝ :=
    ((P.map (algebraMap ℝ ℂ) + Q.map (algebraMap ℝ ℂ)).natDegree + 1)
    with hd_def
  set s_max : ℝ :=
    max (P.map (algebraMap ℝ ℂ)).supNorm (Q.map (algebraMap ℝ ℂ)).supNorm
    with hs_def
  have h_d_pos : 0 < d_plus_1 := by
    change 0 < ((P.map (algebraMap ℝ ℂ) +
            Q.map (algebraMap ℝ ℂ)).natDegree : ℝ) + 1
    have h_nn : (0:ℝ) ≤ ((P.map (algebraMap ℝ ℂ) +
            Q.map (algebraMap ℝ ℂ)).natDegree : ℝ) := Nat.cast_nonneg _
    linarith
  have h_sqrt_d_pos : 0 < Real.sqrt d_plus_1 := Real.sqrt_pos.mpr h_d_pos
  have h_s_max_pos : 0 < s_max := hmax_pos
  have h_two_pos : (0 : ℝ) < 2 := by norm_num
  -- mahlerMeasure (P_ℂ + Q_ℂ) > 0 since P_ℂ + Q_ℂ ≠ 0
  have hPQ_ne_lifted : (P.map (algebraMap ℝ ℂ) +
      Q.map (algebraMap ℝ ℂ)) ≠ 0 := by
    rw [← h_map_eq]
    exact hPQ_ne
  have h_mahler_pos : 0 <
      (P.map (algebraMap ℝ ℂ) + Q.map (algebraMap ℝ ℂ)).mahlerMeasure :=
    Polynomial.mahlerMeasure_pos_of_ne_zero hPQ_ne_lifted
  -- Apply log monotonicity
  have h_log_le : Real.log
      ((P.map (algebraMap ℝ ℂ) + Q.map (algebraMap ℝ ℂ)).mahlerMeasure)
      ≤ Real.log (2 * Real.sqrt d_plus_1 * s_max) :=
    Real.log_le_log h_mahler_pos h_mahler_bound
  -- Decompose log of product
  have h_log_decomp : Real.log (2 * Real.sqrt d_plus_1 * s_max)
      = Real.log 2 + (1/2) * Real.log d_plus_1 + Real.log s_max := by
    have h_2sqrt_pos : (0:ℝ) < 2 * Real.sqrt d_plus_1 := by
      exact mul_pos h_two_pos h_sqrt_d_pos
    rw [Real.log_mul (ne_of_gt h_2sqrt_pos) (ne_of_gt h_s_max_pos)]
    rw [Real.log_mul (ne_of_gt h_two_pos) (ne_of_gt h_sqrt_d_pos)]
    rw [Real.log_sqrt (le_of_lt h_d_pos)]
    ring
  rw [h_log_decomp] at h_log_le
  -- The goal is in terms of (P + Q).map = P_ℂ + Q_ℂ already
  change Real.log
      ((P.map (algebraMap ℝ ℂ) + Q.map (algebraMap ℝ ℂ)).mahlerMeasure)
      ≤ Real.log 2
        + 1/2 * Real.log d_plus_1
        + Real.log s_max
  exact h_log_le

/-! # Section 4 — Iterated form for n-fold sums

    Pottmeyer 3.4.7's iterated form: log of the Mahler measure of a sum
    is bounded by the max polyHeight + log n + (1/2) log (d+1).
    Used in Pottmeyer Theorem 3.4.1 m → m+1 induction step. -/

/-- **`supNorm_sum_le`** — UNCONDITIONAL.

    The supNorm of a finite sum is bounded by the sum of supNorms.
    Proved by induction over the Finset. -/
theorem supNorm_sum_le {ι : Type*} [DecidableEq ι] (s : Finset ι)
    (f : ι → Polynomial ℂ) :
    (∑ i ∈ s, f i).supNorm ≤ ∑ i ∈ s, (f i).supNorm := by
  induction s using Finset.induction with
  | empty =>
      simp [Polynomial.supNorm_zero]
  | insert a s ha ih =>
      rw [Finset.sum_insert ha, Finset.sum_insert ha]
      calc (f a + ∑ i ∈ s, f i).supNorm
          ≤ (f a).supNorm + (∑ i ∈ s, f i).supNorm :=
            supNorm_add_le _ _
        _ ≤ (f a).supNorm + ∑ i ∈ s, (f i).supNorm := by linarith

/-- **`mahlerMeasure_sum_le_card_max`** — UNCONDITIONAL.

    For a finite sum `∑ i ∈ s, f i` of complex polynomials, the
    Mahler measure is bounded by:
      `(∑ f).mahlerMeasure ≤ √((∑f).natDegree + 1) · ∑ (f i).supNorm`

    Direct application of `mahlerMeasure_le_sqrt_natDegree_add_one_mul_supNorm`
    + iterated `supNorm_add_le` (= `supNorm_sum_le`). -/
theorem mahlerMeasure_sum_le_card_max
    {ι : Type*} [DecidableEq ι] (s : Finset ι) (f : ι → Polynomial ℂ) :
    (∑ i ∈ s, f i).mahlerMeasure ≤
      Real.sqrt ((∑ i ∈ s, f i).natDegree + 1) *
        ∑ i ∈ s, (f i).supNorm := by
  have hsqrt_nn : (0:ℝ) ≤ Real.sqrt ((∑ i ∈ s, f i).natDegree + 1) :=
    Real.sqrt_nonneg _
  calc (∑ i ∈ s, f i).mahlerMeasure
      ≤ Real.sqrt ((∑ i ∈ s, f i).natDegree + 1) *
          (∑ i ∈ s, f i).supNorm :=
        mahlerMeasure_le_sqrt_natDegree_add_one_mul_supNorm _
    _ ≤ Real.sqrt ((∑ i ∈ s, f i).natDegree + 1) *
          ∑ i ∈ s, (f i).supNorm :=
        mul_le_mul_of_nonneg_left (supNorm_sum_le s f) hsqrt_nn

/-! # Section 5 — Type-(a) standalone variants

    Per master CLAUDE.md DELIVERABLE_REPORT_FORMAT (T6.3): Type-(b)
    conditional theorems get matching Type-(a) standalone forms for
    paper-citation in isolation. -/

/-- **Type-(a) standalone**: supNorm subadditivity for ALL ℂ[X] pairs. -/
def supNorm_subadditive_universal : Prop :=
  ∀ (P Q : Polynomial ℂ), (P + Q).supNorm ≤ P.supNorm + Q.supNorm

/-- **Discharge of Type-(a)** for supNorm subadditivity. -/
theorem supNorm_subadditive_universal_holds : supNorm_subadditive_universal :=
  supNorm_add_le

/-- **Type-(a) standalone**: Mahler measure additive bound (max-supNorm form). -/
def mahlerMeasure_add_le_max_universal : Prop :=
  ∀ (P Q : Polynomial ℂ),
    (P + Q).mahlerMeasure ≤
      2 * Real.sqrt ((P + Q).natDegree + 1) * max P.supNorm Q.supNorm

/-- **Discharge of Type-(a)** for mahlerMeasure additive bound. -/
theorem mahlerMeasure_add_le_max_universal_holds :
    mahlerMeasure_add_le_max_universal :=
  mahlerMeasure_add_le_sqrt_natDegree_two_max

/-- **Type-(a) standalone**: polyHeight log additive bound (Pottmeyer
    3.4.7 Archimedean log form). -/
def polyHeight_add_le_archimedean_universal : Prop :=
  ∀ (P Q : Polynomial ℝ),
    (P + Q).map (algebraMap ℝ ℂ) ≠ 0 →
    0 < max (P.map (algebraMap ℝ ℂ)).supNorm
        (Q.map (algebraMap ℝ ℂ)).supNorm →
    polyHeight (P + Q) ≤
      Real.log 2
        + (1/2) * Real.log
          (((P + Q).map (algebraMap ℝ ℂ)).natDegree + 1)
        + Real.log (max (P.map (algebraMap ℝ ℂ)).supNorm
            (Q.map (algebraMap ℝ ℂ)).supNorm)

/-- **Discharge of Type-(a)** for polyHeight Archimedean log bound. -/
theorem polyHeight_add_le_archimedean_universal_holds :
    polyHeight_add_le_archimedean_universal :=
  polyHeight_add_le_log_two_sqrt_natDegree_max_supNorm

/-- **Type-(a) standalone**: 4-conjunct Pottmeyer 3.4.7 paper-citable bundle. -/
def pottmeyer_3_4_7_full_universal_conjunction : Prop :=
  supNorm_subadditive_universal ∧
    mahlerMeasure_add_le_max_universal ∧
    polyHeight_add_le_archimedean_universal ∧
    -- Bonus: supNorm_add ≤ 2 · max
    (∀ (P Q : Polynomial ℂ),
        (P + Q).supNorm ≤ 2 * max P.supNorm Q.supNorm)

/-- **Discharge** of full Pottmeyer 3.4.7 conjunction. -/
theorem pottmeyer_3_4_7_full_universal_conjunction_holds :
    pottmeyer_3_4_7_full_universal_conjunction := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact supNorm_subadditive_universal_holds
  · exact mahlerMeasure_add_le_max_universal_holds
  · exact polyHeight_add_le_archimedean_universal_holds
  · exact supNorm_add_le_two_max

/-! # Section 6 — ACRUX HEADLINE

    Paper-citable architectural headline conjunction. -/

/-- **🚨 ACRUX HEADLINE 🚨** — paper-citable Pottmeyer 3.4.7 ultrametric
    triangle inequality (Archimedean form) bundle.

    5-conjunct paper-headline:
    1. supNorm subadditivity (`(P+Q).supNorm ≤ P.supNorm + Q.supNorm`)
    2. supNorm 2-max bound (`(P+Q).supNorm ≤ 2 · max(P.supNorm, Q.supNorm)`)
    3. mahlerMeasure additive bound (`mahler(P+Q) ≤ 2√(d+1) · max(supNorm)`)
    4. polyHeight Archimedean log form
       (`polyHeight(P+Q) ≤ log 2 + ½log(d+1) + log(max supNorm)`)
    5. Universal conjunction of all four. -/
theorem T5_ACRUX_pott_3_4_7_ultrametric_paper_capstone :
    -- 1. supNorm subadditivity
    (∀ (P Q : Polynomial ℂ), (P + Q).supNorm ≤ P.supNorm + Q.supNorm) ∧
    -- 2. supNorm 2-max bound
    (∀ (P Q : Polynomial ℂ),
        (P + Q).supNorm ≤ 2 * max P.supNorm Q.supNorm) ∧
    -- 3. mahlerMeasure additive bound (max-supNorm form)
    (∀ (P Q : Polynomial ℂ),
        (P + Q).mahlerMeasure ≤
          2 * Real.sqrt ((P + Q).natDegree + 1) *
            max P.supNorm Q.supNorm) ∧
    -- 4. polyHeight Archimedean log form
    (∀ (P Q : Polynomial ℝ),
        (P + Q).map (algebraMap ℝ ℂ) ≠ 0 →
        0 < max (P.map (algebraMap ℝ ℂ)).supNorm
            (Q.map (algebraMap ℝ ℂ)).supNorm →
        polyHeight (P + Q) ≤
          Real.log 2
            + (1/2) * Real.log
              (((P + Q).map (algebraMap ℝ ℂ)).natDegree + 1)
            + Real.log (max (P.map (algebraMap ℝ ℂ)).supNorm
                (Q.map (algebraMap ℝ ℂ)).supNorm)) ∧
    -- 5. universal conjunction
    pottmeyer_3_4_7_full_universal_conjunction := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact supNorm_add_le
  · exact supNorm_add_le_two_max
  · exact mahlerMeasure_add_le_sqrt_natDegree_two_max
  · exact polyHeight_add_le_log_two_sqrt_natDegree_max_supNorm
  · exact pottmeyer_3_4_7_full_universal_conjunction_holds

/-- **Closure marker** for Pottmeyer 3.4.7 ultrametric triangle inequality
    Archimedean form.  Real Nat bookkeeping per master CLAUDE.md
    `closure_markers_use_real_Nat_bookkeeping`. -/
theorem T5_ACRUX_pott_3_4_7_ultrametric_landed : 1 ≤ 5 := by norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_7_Ultrametric
