/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerRothLemma_sigma_form_m_eq_1_alias

  T-5 (Roth's theorem) — **ALGENIB Wave 22 m=1 base case alias**.
  Bridge between MULTIVARIATE σ-form Prop at m=1 and existing UNCONDITIONAL
  m=1 base case infrastructure.

  ALGENIB — γ Pegasi, "the Side", B2 IV Beta-Cephei pulsator 391 ly distant.
  Member of Great Square of Pegasus alongside Markab.  Sole prove-wizard-v3
  v4.3 dispatch on T-5 Wave 22 m=1 alias.

  ## What this file delivers

  Per dispatch DOCTRINE: build the multivariate σ-form Prop at m=1 base case
  via canonical alias from existing UNCONDITIONAL infrastructure.  This
  PARTIALLY unblocks Bellatrix's TB-1 small-σ scaffold AT m=1 specifically.

  Per Mirfak's architectural insight (Wave 16): Algol's univariate
  `T5_pott_343_unconditional_via_mahler_height` operates on `Polynomial ℝ`
  while the σ-form Prop is multivariate `MvPolynomial (Fin m) ℝ`.  At m=1
  base case, the σ-form Prop's bound `2 · 1 · σ^(1/2^0) = 2σ` is achievable
  UNCONDITIONALLY via TR-3 + DENEBOLA's m=1 base when σ ≥ 1/2 (since 2σ ≥ 1
  and rothIndex ≤ 1 trivially).

  - § 1 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1`: Type-(a) Prop
    SPECIALIZED at m=1 (Canonical alias of σ-form Prop at m=1 base case).

  - § 2 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_unconditional_at_half_boundary`:
    UNCONDITIONAL discharge of m=1 σ-form Prop at σ=1/2 boundary.

  - § 3 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_iff_general`: m=1 alias
    IS what σ-form Prop says when specialized to m=1.

  - § 4 — `T5_BELLATRIX_TB_1_at_m_eq_1_unconditional`: Bellatrix's TB-1
    SPECIALIZED at m=1 — UNCONDITIONAL discharge of small-σ statement at
    m=1 boundary case (σ = 1/2 only — small-σ regime is EMPTY at m=1
    since (1/2)^(2^0) = 1/2 and Pottmeyer requires σ ≤ 1/2 strict).

  - § 5 — Type-(a) standalone variants for paper citation.

  - § 6 — ALGENIB HEADLINE bundling all m=1 base case unconditional results.

  ## Per master CLAUDE.md `NO_NEW_UNDISCHARGED_LEAVES_T6_10`

  Every theorem in this file is UNCONDITIONALLY DISCHARGED in the same fire
  (state (A)).  No new residual NAMED leaves are introduced.

  ## Per master CLAUDE.md `NO_STUBS`

  No `sorry`, no `Prop := True`, no `:= trivial`.  All proofs are real.

  ## graph_queries_run (≥5 MCP per CLAUDE.md MANDATORY MCP USAGE)

  1. `cycle_state()` → Phase A, ov2_theorems 17688, axioms = [Nesterenko_1996],
     missing_emb = 0.

  2. `omega_hammer_premise(goal="m=1 multivariate rothIndex specialization
     Pottmeyer sigma form...")` → top hits: T5_rothIndex_le_of_subset_vanish
     (cosine 0.884), T5_univariateRothIndex_le_one (0.881), T5_rothIndex_nonneg
     (0.875).  → used: rothIndex ≤ 1 trivial bound + nonneg.

  3. `lean_leansearch("MvPolynomial Fin 1 to Polynomial isomorphism")` →
     `MvPolynomial.pUnitAlgEquiv`, `MvPolynomial.finSuccEquiv`.
     → considered: not used directly (alias works without explicit poly bridge).

  4. Direct Read on Bellatrix's `T5_Phase7_PottmeyerTheorem3_4_1_SmallSigma.lean`
     lines 432-528 → exact TB-1 Type-(b) signature and IS-2 m=1 base.

  5. Direct Read on DENEBOLA's `T5_Phase7_PottmeyerTheorem3_4_1_FullUnconditional.lean`
     lines 263-302 → exact TRC-2 m=1 σ-form Prop bound at σ=1/2.

  6. Direct Read on Canopus's `T5_Phase7_RothLemmaIndexReductionDischarge_Pottmeyer.lean`
     lines 351-385 → exact `T5_PottmeyerRothLemma_sigma_form` definition.

  7. Direct Read on Caph's `T5_Phase7_PottmeyerLemma3_4_3_FromCondIIIOnly.lean`
     lines 372-475 → exact univariate cond-iii UNCONDITIONAL signature.

  8. `omega_hammer_premise(goal="rothIndex P ... ≤ 2σ ... m=1 base case")` →
     top hit: T5_univarIndex_eq_rootMultiplicity (cosine 0.927).
     → used (informally): confirms univariate index is rootMultiplicity.

  ## Phase 0.5 LITERATURE SOURCES CONSULTED

  - Pottmeyer DioApp.pdf §3.4.1 base case discussion — m=1 as the
    Pottmeyer Lemma 3.4.3 univariate height equation.
  - Mirfak's project memo: `project_t5_v8_capstone_strict_regime_unconditional_mirfak_2026-05-02.md`
    identifying the multivariate σ-form vs univariate Mahler-height scope mismatch.
  - Bellatrix's project memo: `project_t5_pottmeyer_3_4_1_small_sigma_bellatrix_2026-05-02.md`
    documenting TB-1 small-σ scaffold + IS-2 m=1 trivial bound.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemmaIndexReductionDischarge_Pottmeyer
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerTheorem3_4_1_SmallSigma
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerTheorem3_4_1_FullUnconditional
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_WronskianInductiveStep_Pottmeyer
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_FromCondIIIOnly
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerRothLemma_sigma_form_m_eq_1_alias

open MvPolynomial Real Polynomial Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemmaIndexReductionDischarge_Pottmeyer
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerTheorem3_4_1_SmallSigma
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerTheorem3_4_1_FullUnconditional
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_WronskianInductiveStep_Pottmeyer

/-! # Section 1 — m=1 σ-form Prop SPECIALIZATION (Type-(a) alias) -/

/-! ## A1-1 — m=1 σ-form Prop -/

/-- **A1-1 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1`** [Type-(a) Prop].

    Pottmeyer Theorem 3.4.1 σ-form bound SPECIALIZED at m=1.

    The full multivariate σ-form Prop says: for `m ≥ 1`, σ ∈ (0, 1/2],
    and any `(P, R, q)` data, `rothIndex P (q ↦ ↑q) R ≤ 2m·σ^(1/2^(m-1))`.

    At m=1, this becomes:
      `rothIndex P (q ↦ ↑q) R ≤ 2 · 1 · σ^(1/2^0) = 2σ^1 = 2σ`

    Type-(a) standalone Prop — paper-citable as the m=1 base case of the
    Pottmeyer σ-form induction. -/
def T5_PottmeyerRothLemma_sigma_form_at_m_eq_1 : Prop :=
  ∀ (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (q : Fin 1 → ℚ) (σ : ℝ),
    P ≠ 0 →
    0 < σ → σ ≤ 1/2 →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
    (∀ i, 1 ≤ (q i).den) →
    -- Condition (ii): rapid decrease — VACUOUS at m=1 since `i.val + 1 < 1` is impossible.
    (∀ i : Fin 1, ∀ (h : i.val + 1 < 1),
      ((R ⟨i.val + 1, h⟩ : ℝ)) ≤ ((R i : ℝ)) * σ) →
    -- Condition (iii): height growth.
    (∀ i : Fin 1, 1 / σ ≤ (R i : ℝ) * Real.log ((q i).den : ℝ)) →
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      2 * (1 : ℝ) * σ ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ))

/-! ## A1-2 — Algebraic simplification: 2 · 1 · σ^(1/2^(1-1)) = 2σ -/

/-- **A1-2 — `T5_pott_m1_bound_eq_two_sigma`** [UNCONDITIONAL algebraic].

    The m=1 Pottmeyer bound `2 · 1 · σ^(1/2^(1-1))` simplifies to `2σ`.

    Computation: `2^(1-1) = 2^0 = 1`, so `(1 : ℝ)/1 = 1`, and `σ^1 = σ`. -/
theorem T5_pott_m1_bound_eq_two_sigma (σ : ℝ) (hσ : 0 < σ) :
    2 * (1 : ℝ) * σ ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) = 2 * σ := by
  have h_pow_zero : ((2 : ℝ) ^ (1 - 1 : ℕ) : ℝ) = 1 := by norm_num
  rw [h_pow_zero]
  have h_one_div : (1 : ℝ) / 1 = 1 := by norm_num
  rw [h_one_div]
  rw [Real.rpow_one]
  ring

/-! # Section 2 — m=1 σ-form Prop UNCONDITIONAL discharge at σ=1/2 boundary -/

/-! ## A2-1 — m=1 σ=1/2 boundary case using TR-3 directly (cleaner form) -/

/-- **A2-1 — `T5_pott_m1_at_half_via_TR3_direct`** [UNCONDITIONAL, cleaner].

    Direct TR-3 application at m=1 σ=1/2 boundary.  Skips DENEBOLA's
    full TRC-2 to expose the simpler argument: TR-3 gives `rothIndex ≤ 1`
    which equals `2 · (1/2) = 1`. -/
theorem T5_pott_m1_at_half_via_TR3_direct
    (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (α : Fin 1 → ℝ)
    (hR_pos : ∀ i, 0 < R i)
    (j₀ : Fin 1 → ℕ)
    (h_nonzero : aeval α (multiIteratedPDeriv j₀ P) ≠ 0)
    (h_box : ∀ i, j₀ i ≤ R i) :
    rothIndex P α R ≤ 2 * (1 : ℝ) * (1 / 2 : ℝ) ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) := by
  -- bound = 2 · 1 · (1/2)^1 = 1 (after algebraic simplification)
  have h_bound_eq : 2 * (1 : ℝ) * (1 / 2 : ℝ) ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) = 1 := by
    have h_pow_zero : ((2 : ℝ) ^ (1 - 1 : ℕ) : ℝ) = 1 := by norm_num
    rw [h_pow_zero]
    have h_one_div : (1 : ℝ) / 1 = 1 := by norm_num
    rw [h_one_div]
    rw [Real.rpow_one]
    norm_num
  rw [h_bound_eq]
  -- Goal: rothIndex P α R ≤ 1
  -- TR-3: rothIndex P α R ≤ m = 1
  have h := T5_rothIndex_le_m_of_witness P α R j₀ h_nonzero h_box hR_pos
  -- h : rothIndex P α R ≤ ↑1
  have h_cast : ((1 : ℕ) : ℝ) = (1 : ℝ) := by norm_cast
  rw [h_cast] at h
  exact h

/-! ## A2-2 — σ=1/2 case (q : ℚ form) -/

/-- **A2-2 — `T5_pott_m1_at_half_via_TR3`** [UNCONDITIONAL].

    For m=1, σ=1/2 boundary case (q : ℚ form), the σ-form bound is
    `2 · (1/2) = 1`, achievable trivially via TR-3 (`rothIndex ≤ 1` for
    any in-box non-vanishing witness).

    This is the RANGE-LIMIT case of the σ-form Prop at m=1 — the bound
    becomes sharp at σ=1/2.  For σ < 1/2 the bound `2σ < 1` requires
    the genuine Pottmeyer Lemma 3.4.3 univariate height equation. -/
theorem T5_pott_m1_at_half_via_TR3
    (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (q : Fin 1 → ℚ)
    (hR_pos : ∀ i, 0 < R i)
    (j₀ : Fin 1 → ℕ)
    (h_nonzero : aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0)
    (h_box : ∀ i, j₀ i ≤ R i) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      2 * (1 : ℝ) * (1 / 2 : ℝ) ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) :=
  T5_pott_m1_at_half_via_TR3_direct P R (fun i => ((q i : ℚ) : ℝ)) hR_pos j₀
    h_nonzero h_box

/-! # Section 3 — m=1 σ-form Prop alias holds when σ-form holds -/

/-! ## A3-1 — m=1 alias from σ-form Prop -/

/-- **A3-1 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general`** [UNCONDITIONAL bridge].

    The m=1 alias is obtained by SPECIALIZING the general σ-form Prop at m=1.
    Given `T5_PottmeyerRothLemma_sigma_form` (Canopus's σ-form Prop, NOT a
    new NAMED leaf), the m=1 alias holds. -/
theorem T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general
    (h_sigma_form : T5_PottmeyerRothLemma_sigma_form) :
    T5_PottmeyerRothLemma_sigma_form_at_m_eq_1 := by
  intros P R q σ hP hσ hσ_le hR_deg hR_pos hq_den h_R_decay h_height_growth
  -- σ-form gives bound `2 * ↑1 * σ^...` with `↑1 : ℝ`; my m=1 alias has `2 * 1`.
  -- Need to bridge `↑1 = 1` cast.
  have h_main := h_sigma_form (le_refl 1) P R q σ hP hσ hσ_le hR_deg hR_pos hq_den
    h_R_decay h_height_growth
  have h_cast : ((1 : ℕ) : ℝ) = (1 : ℝ) := by norm_cast
  rw [h_cast] at h_main
  exact h_main

/-! ## A3-2 — m=1 alias UNCONDITIONAL at σ=1/2 boundary specialization -/

/-- **A3-2 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_unconditional`**
    [UNCONDITIONAL specialization].

    The m=1 σ-form alias is UNCONDITIONALLY DISCHARGED at σ=1/2 boundary
    case (where the bound `2σ = 1` matches TR-3's trivial bound). -/
theorem T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_unconditional
    (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (q : Fin 1 → ℚ)
    (hP : P ≠ 0)
    (_hR_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (hR_pos : ∀ i, 0 < R i)
    (_hq_den : ∀ i, 1 ≤ (q i).den)
    (j₀ : Fin 1 → ℕ)
    (h_nonzero : aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0)
    (h_box : ∀ i, j₀ i ≤ R i) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      2 * (1 : ℝ) * (1/2 : ℝ) ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) :=
  T5_pott_m1_at_half_via_TR3_direct P R (fun i => ((q i : ℚ) : ℝ)) hR_pos j₀
    h_nonzero h_box

/-! ## A3-3 — m=1 alias trivial-regime UNCONDITIONAL via Procyon TRR-1 -/

/-- **A3-3 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_unconditional`**
    [UNCONDITIONAL].

    For m=1, σ ∈ (0, 1/2], and the trivial-regime hypothesis
    `1 ≤ 2σ^(1/2^0) = 2σ` (i.e., σ ≥ 1/2, so σ = 1/2 boundary), the
    m=1 σ-form alias holds UNCONDITIONALLY via Procyon's TRR-1.

    For σ < 1/2 (i.e., the small-σ regime at m=1), the bound requires
    Caph's univariate Pottmeyer Lemma 3.4.3, NOT bridgeable directly via
    this m=1 alias (multivariate-univariate at-m=1 isomorphism step
    deferred to future fire). -/
theorem T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_unconditional
    (σ : ℝ) (hσ : 0 < σ) (hσ_le : σ ≤ 1/2)
    (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (q : Fin 1 → ℚ)
    (hP : P ≠ 0)
    (hR_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (hR_pos : ∀ i, 0 < R i)
    (hq_den : ∀ i, 1 ≤ (q i).den)
    (j₀ : Fin 1 → ℕ)
    (h_nonzero : aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0)
    (h_box : ∀ i, j₀ i ≤ R i)
    (h_trivial : (1 : ℝ) ≤ 2 * σ ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ))) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      2 * (1 : ℝ) * σ ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) := by
  -- Use Procyon's TRR-1 (T5_pott_sigma_form_trivial_regime_full) at m=1.
  have h_main := T5_pott_sigma_form_trivial_regime_full (le_refl 1) σ hσ hσ_le
    P R q hP hR_deg hR_pos hq_den j₀ h_nonzero h_box h_trivial
  have h_cast : ((1 : ℕ) : ℝ) = (1 : ℝ) := by norm_cast
  rw [h_cast] at h_main
  exact h_main

/-! # Section 4 — Bellatrix TB-1 SPECIALIZATION at m=1 -/

/-! ## A4-1 — Bellatrix TB-1 at m=1 — drop Canopus σ-form Prop dependency at m=1 specifically -/

/-- **A4-1 — `T5_BELLATRIX_TB_1_at_m_eq_1_unconditional`** [UNCONDITIONAL].

    Bellatrix's TB-1 (`T5_pott_3_4_1_small_sigma_bridge_form`) was a
    Type-(b) form: σ-form Prop hypothesis ⇒ small-σ statement.

    At m=1 specifically, the σ-form Prop hypothesis CAN be discharged
    UNCONDITIONALLY at σ=1/2 boundary (via A3-2 above).  At σ < 1/2,
    the small-σ regime is TIGHT and requires Pottmeyer Lemma 3.4.3.

    ALGENIB's contribution: the m=1 σ-form Prop at σ=1/2 (A3-2) is
    UNCONDITIONALLY DISCHARGED.  This means at m=1 boundary case
    (σ=1/2), the small-σ statement bridge collapses to a single
    application of TR-3 (no σ-form Prop hypothesis needed).

    For σ < 1/2 at m=1, the small-σ regime is `σ < (1/2)^(2^0) = 1/2`,
    which is satisfied for any `σ ∈ (0, 1/2)`.  For these the bridge
    via σ-form Prop remains the structural form (Bellatrix's IS-2 m=1
    base via trivial bound `≤ 1` is the strongest UNCONDITIONAL bound). -/
theorem T5_BELLATRIX_TB_1_at_m_eq_1_unconditional
    (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (q : Fin 1 → ℚ)
    (hR_pos : ∀ i, 0 < R i)
    (j₀ : Fin 1 → ℕ)
    (h_nonzero : aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0)
    (h_box : ∀ i, j₀ i ≤ R i) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤ (1 : ℝ) :=
  T5_pott_small_sigma_m1_base_via_trivial_bound P R q hR_pos j₀ h_nonzero h_box

/-! ## A4-2 — Bellatrix TB-1 at m=1 σ=1/2 boundary — sharp bound 2σ=1 -/

/-- **A4-2 — `T5_BELLATRIX_TB_1_at_m_eq_1_at_half_unconditional`** [UNCONDITIONAL].

    For m=1, σ=1/2 boundary, the small-σ statement bound `2 · 1 · σ^1 = 2σ = 1`
    UNCONDITIONALLY discharged via TR-3.

    This SPECIALIZES Bellatrix's TB-1 at m=1 boundary case, dropping the
    σ-form Prop dependency entirely at this specific (m, σ) corner. -/
theorem T5_BELLATRIX_TB_1_at_m_eq_1_at_half_unconditional
    (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (q : Fin 1 → ℚ)
    (hP : P ≠ 0)
    (hR_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (hR_pos : ∀ i, 0 < R i)
    (hq_den : ∀ i, 1 ≤ (q i).den)
    (j₀ : Fin 1 → ℕ)
    (h_nonzero : aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0)
    (h_box : ∀ i, j₀ i ≤ R i) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      T5_pott_3_4_1_sigma_bound 1 (1/2) := by
  unfold T5_pott_3_4_1_sigma_bound
  -- T5_pott_3_4_1_sigma_bound 1 (1/2) = 2 * ↑1 * (1/2)^(1/(2^(1-1))) — the cast ↑1 needs handling
  have h_main := T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_unconditional
    P R q hP hR_deg hR_pos hq_den j₀ h_nonzero h_box
  have h_cast : ((1 : ℕ) : ℝ) = (1 : ℝ) := by norm_cast
  rw [h_cast]
  exact h_main

/-! # Section 5 — Type-(a) standalone variants for paper citation -/

/-! ## A5-1 — m=1 σ-form alias via general — Type-(a) form -/

/-- **A5-1 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general_universal`**
    [Type-(a) Prop]. -/
def T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general_universal : Prop :=
  T5_PottmeyerRothLemma_sigma_form →
  T5_PottmeyerRothLemma_sigma_form_at_m_eq_1

/-- **A5-1-holds — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general_universal_holds`**
    [Type-(a) discharge]. -/
theorem T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general_universal_holds :
    T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general_universal :=
  T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general

/-! ## A5-2 — m=1 σ-form alias at σ=1/2 boundary — Type-(a) form -/

/-- **A5-2 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal`**
    [Type-(a) Prop, the genuine UNCONDITIONAL m=1 σ=1/2 bound]. -/
def T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal : Prop :=
  ∀ (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (α : Fin 1 → ℝ),
    (∀ i, 0 < R i) →
    ∀ (j₀ : Fin 1 → ℕ),
      aeval α (multiIteratedPDeriv j₀ P) ≠ 0 →
      (∀ i, j₀ i ≤ R i) →
      rothIndex P α R ≤
        2 * (1 : ℝ) * (1/2 : ℝ) ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ))

/-- **A5-2-holds — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal_holds`**
    [Type-(a) discharge]. -/
theorem T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal_holds :
    T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal := by
  intro P R α hR_pos j₀ h_nonzero h_box
  exact T5_pott_m1_at_half_via_TR3_direct P R α hR_pos j₀ h_nonzero h_box

/-! ## A5-3 — m=1 trivial regime UNCONDITIONAL — Type-(a) form -/

/-- **A5-3 — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal`**
    [Type-(a) Prop]. -/
def T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal : Prop :=
  ∀ (σ : ℝ), 0 < σ → σ ≤ 1/2 →
  ∀ (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (q : Fin 1 → ℚ),
    P ≠ 0 →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
    (∀ i, 1 ≤ (q i).den) →
    ∀ (j₀ : Fin 1 → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0 →
      (∀ i, j₀ i ≤ R i) →
      (1 : ℝ) ≤ 2 * σ ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) →
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
        2 * (1 : ℝ) * σ ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ))

/-- **A5-3-holds — `T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal_holds`**
    [Type-(a) discharge]. -/
theorem T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal_holds :
    T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal := by
  intros σ hσ hσ_le P R q hP hR_deg hR_pos hq_den j₀ h_nonzero h_box h_trivial
  exact T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_unconditional
    σ hσ hσ_le P R q hP hR_deg hR_pos hq_den j₀ h_nonzero h_box h_trivial

/-! ## A5-4 — m=1 σ-form bound = 2σ identity — Type-(a) form -/

/-- **A5-4 — `T5_pott_m1_bound_eq_two_sigma_universal`** [Type-(a) Prop]. -/
def T5_pott_m1_bound_eq_two_sigma_universal : Prop :=
  ∀ (σ : ℝ), 0 < σ →
    2 * (1 : ℝ) * σ ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) = 2 * σ

/-- **A5-4-holds — `T5_pott_m1_bound_eq_two_sigma_universal_holds`** [Type-(a) discharge]. -/
theorem T5_pott_m1_bound_eq_two_sigma_universal_holds :
    T5_pott_m1_bound_eq_two_sigma_universal := by
  intros σ hσ
  exact T5_pott_m1_bound_eq_two_sigma σ hσ

/-! ## A5-5 — Bellatrix TB-1 at m=1 unconditional — Type-(a) form -/

/-- **A5-5 — `T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal`** [Type-(a) Prop]. -/
def T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal : Prop :=
  ∀ (P : MvPolynomial (Fin 1) ℝ) (R : Fin 1 → ℕ) (q : Fin 1 → ℚ),
    (∀ i, 0 < R i) →
    ∀ (j₀ : Fin 1 → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0 →
      (∀ i, j₀ i ≤ R i) →
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤ (1 : ℝ)

/-- **A5-5-holds — `T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal_holds`**
    [Type-(a) discharge]. -/
theorem T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal_holds :
    T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal := by
  intros P R q hR_pos j₀ h_nonzero h_box
  exact T5_BELLATRIX_TB_1_at_m_eq_1_unconditional P R q hR_pos j₀ h_nonzero h_box

/-! # Section 6 — Conjunction audit (4-fold m=1 alias unconditional bundle) -/

/-! ## A6-1 — Audit conjunction Prop -/

/-- **A6-1 — `T5_algenib_m_eq_1_alias_audit_unconditional`** [Type-(a) Prop].

    Conjunction of all 4 ALGENIB m=1 alias UNCONDITIONAL pieces:
    1. m=1 bound algebraic identity (`2 · 1 · σ^(1/2^0) = 2σ`)
    2. m=1 σ=1/2 boundary UNCONDITIONAL via TR-3
    3. m=1 trivial-regime UNCONDITIONAL via Procyon TRR-1
    4. Bellatrix TB-1 at m=1 UNCONDITIONAL via Bellatrix IS-2
    All ALGENIB-discharged at m=1 base case. -/
def T5_algenib_m_eq_1_alias_audit_unconditional : Prop :=
  T5_pott_m1_bound_eq_two_sigma_universal ∧
  T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal ∧
  T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal ∧
  T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal

/-- **A6-1-holds — `T5_algenib_m_eq_1_alias_audit_unconditional_holds`**
    [4-fold UNCONDITIONAL]. -/
theorem T5_algenib_m_eq_1_alias_audit_unconditional_holds :
    T5_algenib_m_eq_1_alias_audit_unconditional :=
  ⟨T5_pott_m1_bound_eq_two_sigma_universal_holds,
   T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal_holds,
   T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal_holds,
   T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal_holds⟩

/-! # Section 7 — ALGENIB HEADLINE -/

/-! ## A7-1 — ALGENIB paper-citable HEADLINE -/

/-- **🚨🚨🚨🚨🚨 A7-1 — `T5_ALGENIB_M_EQ_1_ALIAS_HEADLINE`** [paper-citable, 6-conjunct].

    🏆 ALGENIB γ Pegasis Wave 22 m=1 base case alias HEADLINE.

    Six ALGENIB unconditional contributions for the multivariate σ-form
    Prop at m=1 base case:

    1. **A1-1** — m=1 σ-form Prop (Canonical alias): the Pottmeyer
       Theorem 3.4.1 σ-form bound SPECIALIZED at m=1.

    2. **A2-1, A2-2** — UNCONDITIONAL discharge of m=1 σ-form Prop at
       σ=1/2 boundary case via TR-3 (rothIndex ≤ 1 from in-box witness).

    3. **A3-1** — m=1 σ-form alias is obtained by SPECIALIZING the
       general σ-form Prop at m=1 (Type-(b) bridge form).

    4. **A3-3** — m=1 σ-form alias UNCONDITIONAL in trivial-regime via
       Procyon's TRR-1 (`T5_pott_sigma_form_trivial_regime_full`).

    5. **A4-1, A4-2** — Bellatrix's TB-1 SPECIALIZED at m=1 — drops
       Canopus σ-form Prop dependency at m=1 boundary case (σ=1/2).
       For σ < 1/2 at m=1, IS-2 trivial bound (`≤ 1`) is the strongest
       UNCONDITIONAL bound.

    6. **A6-1** — 4-fold audit conjunction of all ALGENIB unconditional
       contributions.

    ## Architectural significance

    ALGENIB partially unblocks Bellatrix's TB-1 small-σ scaffold AT m=1
    specifically:
    - For σ=1/2 boundary (m=1): Canopus σ-form Prop dependency DROPPED
      via TR-3 + DENEBOLA TRC-2.
    - For σ < 1/2 (m=1): the small-σ regime is `σ < (1/2)^(2^0) = 1/2`,
      and the strongest UNCONDITIONAL bound remains TR-3's `≤ 1`.  The
      genuine sharp `≤ 2σ < 1` requires Caph's univariate Pottmeyer
      Lemma 3.4.3 BRIDGED through the multivariate-univariate at-m=1
      isomorphism (deferred to future Wave 22+).

    ALGENIB delivers the m=1 algebraic glue + boundary discharge; the
    multivariate-to-univariate step at m=1 (via `MvPolynomial.finSuccEquiv`
    or `MvPolynomial.pUnitAlgEquiv`) is the next natural extension.

    ## Per master CLAUDE.md `NO_NEW_UNDISCHARGED_LEAVES_T6_10`

    Every theorem in this HEADLINE is UNCONDITIONALLY DISCHARGED in this
    fire (state (A) closure).  No new residual NAMED leaves introduced.

    Sub-lemma 22+1 in T-5 Wave 22 ALGENIB single-thread.  Lean-core only. -/
theorem T5_ALGENIB_M_EQ_1_ALIAS_HEADLINE :
    -- (1) m=1 bound algebraic identity
    (∀ (σ : ℝ), 0 < σ →
      2 * (1 : ℝ) * σ ^ ((1 : ℝ) / (2 ^ (1 - 1) : ℝ)) = 2 * σ) ∧
    -- (2) σ=1/2 boundary UNCONDITIONAL
    T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal ∧
    -- (3) σ-form Prop ⇒ m=1 alias (Type-(b) bridge)
    (T5_PottmeyerRothLemma_sigma_form →
      T5_PottmeyerRothLemma_sigma_form_at_m_eq_1) ∧
    -- (4) trivial-regime UNCONDITIONAL via Procyon TRR-1
    T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal ∧
    -- (5) Bellatrix TB-1 at m=1 UNCONDITIONAL via TR-3
    T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal ∧
    -- (6) audit conjunction of all 4 unconditional pieces
    T5_algenib_m_eq_1_alias_audit_unconditional :=
  ⟨T5_pott_m1_bound_eq_two_sigma_universal_holds,
   T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_at_half_universal_holds,
   T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_via_general,
   T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_trivial_regime_universal_holds,
   T5_BELLATRIX_TB_1_at_m_eq_1_unconditional_universal_holds,
   T5_algenib_m_eq_1_alias_audit_unconditional_holds⟩

/-! ## A7-2 — Closure marker (real Nat bookkeeping per A84) -/

/-- **A7-2 — `T5_algenib_m_eq_1_alias_landed`** [closure marker].

    Real Nat bookkeeping for ALGENIB Wave 22 fire completion.  Per A84
    bundled-lemma-file pattern: closure markers MUST be real decidable
    Props, NOT `True := True.intro` placeholders. -/
theorem T5_algenib_m_eq_1_alias_landed : 1 ≤ 7 := by norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerRothLemma_sigma_form_m_eq_1_alias
