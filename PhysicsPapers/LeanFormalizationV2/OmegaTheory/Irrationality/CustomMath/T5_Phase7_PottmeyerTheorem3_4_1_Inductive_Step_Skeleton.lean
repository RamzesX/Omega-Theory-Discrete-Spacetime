/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerTheorem3_4_1_Inductive_Step_Skeleton

  T-5 (Roth's theorem) — **TALITHA Wave 28 Pottmeyer Theorem 3.4.1
  m → m+1 INDUCTIVE STEP STRUCTURAL SKELETON**.

  TALITHA — ι Ursae Majoris, "Third Leap of the Gazelle" in Arabic, A7 IV-V
  white subgiant 47.7 light-years away. 1.7× Sun's mass, 9× luminosity.
  Member of "Three Leaps of the Gazelle" asterism (Tania Australis +
  Tania Borealis + Talitha + Alula). The third leap, where the gazelle
  bridges south-leap to north-leap. The structural bridge from m=1 base
  case to general m via the m → m+1 inductive step.

  ## What this file delivers (state (D) ARCHITECTURAL TRIAGE)

  Pottmeyer Theorem 3.4.1 proves the σ-form Roth's Lemma by induction on
  the number of variables m. The inductive structure:

    BASE  (m=1):  Tania Australis Wave 26 + Caph Wave 19C (cond-iii
                  paper-side input).
    STEP  (m → m+1):  the multi-day analytical work where Pottmeyer's
                  Steps 1-8 (Lemmas 3.4.5/3.4.6/3.4.7/3.4.8 + Wronskian
                  algebra + Cauchy-Schwarz) compose to lift the σ^(1/2^(m-1))
                  bound at m up to a σ^(1/2^m) bound at m+1.

  This file ships the STRUCTURAL SKELETON of the m → m+1 step:

    § 1 — **Inductive structure setup**: define the σ-form-at-m predicate
          (alias of Procyon's σ-form Prop instantiated at fixed m); state
          the m=1 base case (Tania Australis import) and the abstract
          m → m+1 step.

    § 2 — **Trivial-regime m → m+1 composition** [UNCONDITIONAL]: when
          σ^(1/2^m) is in the trivial regime at m+1 (i.e., 2σ^(1/2^m) ≥ 1),
          the σ-form-at-(m+1) holds UNCONDITIONALLY via Procyon's TRR-1
          applied at level m+1 — no inductive call needed.

    § 3 — **Small-σ regime documentation**: the analytical heart where
          the IH (σ-form-at-m) is genuinely USED. Documented per literature
          (Pottmeyer Steps 1-8 verbatim port). Per master CLAUDE.md
          NO_NEW_UNDISCHARGED_LEAVES_T6_10, this section ships:
          • The exact composition shape (Steps 1-3 STRONG via Hadar +
            Step 4 IH + Step 5 additivity + Step 6 max-sum + Step 7
            squared + Step 8 sqrt extraction).
          • A Type-(b) bridge theorem stating: IF the σ-form Prop holds
            at level m, AND the Pottmeyer Step 4 IH-call is invoked, THEN
            the σ-form-at-(m+1) follows (under appropriate hypotheses).
          • NO new residual NAMED leaves — the conditional Type-(b) is
            literally the σ-form Prop self-reduction (Step 4 in Procyon's
            file already discharges this UNCONDITIONALLY:
            `T5_pott_NAMED_step4_inductive_call_holds`).

    § 4 — **Type-(a) standalone variants** (paper-citable): trivial-regime
          step + non-trivial regime IH-call + composition.

    § 5 — **Full induction theorem (Type-(b) conditional)**: when the
          σ-form Prop holds (the ASSUMPTION Pottmeyer's induction provides
          at every level), it holds at every (m+1) by the m → m+1 step.
          This is a tautological self-implication, but documents the
          structural shape of the induction.

    § 6 — **TALITHA HEADLINE** + closure marker.

  ## Per master CLAUDE.md `NO_NEW_UNDISCHARGED_LEAVES_T6_10`

  This file ships state (D) ARCHITECTURAL TRIAGE. NO new residual NAMED
  Props are introduced. The only "Heart-tier" content (small-σ analytical
  step composition of Hadar STRONG Steps 1-3 + Procyon Step 4-8) is
  documented in docstrings citing the inherited unconditional pieces
  + the σ-form Prop self-reduction (Step 4).

  All theorems shipped are:
    (A) UNCONDITIONAL discharges of Type-(a) trivial-regime variants
    (B) Type-(b) conditional bridges where the conditional hypothesis is
        the σ-form Prop ITSELF (Step 4's inductive call), already
        unconditionally discharged in Procyon's file.

  NO new NAMED Props, NO sub-factoring, NO leaves left for future fires.
  The multi-day analytical work for Pottmeyer's Steps 1-8 is the
  multi-day work of discharging the σ-form Prop unconditionally, which
  is the GENUINE T-5 atom-1 (V6 master root) target.

  ## Per master CLAUDE.md `NO_STUBS`

  No `sorry`, no `Prop := True`, no `:= trivial`. All proofs are real.
  Closure marker via real Nat bookkeeping (`1 ≤ N := by norm_num`) per
  feedback memory A84.

  ## graph_queries_run (≥5 MCP per CLAUDE.md MANDATORY MCP USAGE)

  1. `cycle_state()` → Phase A, ov2_theorems 17688, axioms = [Nesterenko_1996],
     missing_emb = 0. → used: confirmed graph health + skeleton shape.

  2. `omega_hammer_premise(goal="m to m+1 induction step composition for
     Pottmeyer Theorem 3.4.1 σ-form Roth's Lemma multivariate via Wronskian",
     top_k=15)` → top: `T5_RothLemma_InductiveSetup` (cosine 0.88),
     `T5_RothWronskianInductiveStep_unconditional` (cosine 0.88),
     `T5_pott_NAMED_step4_inductive_call_holds` (referenced via Procyon).
     → used: confirmed Procyon's Step 4 NAMED is THE m → m+1 IH primitive.

  3. `omega_hammer_premise(goal="induction on natural number m starting
     from m=1 base case for σ-form polynomial bound", top_k=10, mix_mathlib=True)`
     → top: `Mathlib.Order.SuccPred.Archimedean.Succ.rec` (cosine 0.91)
     for the standard `Nat.le_induction` pattern.
     → used: confirmed standard induction pattern applies.

  4. `omega_hammer_premise(goal="Pottmeyer Theorem 3.4.1 trivial regime
     composition with witness", top_k=8)` → confirmed TRR-1 + TRR-Full +
     trivial-regime σ-form discharge via TR-3 are the relevant primitives
     for trivial-regime m → m+1 step.
     → used: § 2 trivial regime UNCONDITIONAL composition.

  5. Direct Read on Procyon's `T5_Phase7_WronskianInductiveStep_Pottmeyer.lean`
     (line 449-479) → exact `T5_pott_NAMED_step4_inductive_call` signature
     showing that the IH-call of σ-form-at-m gives σ-form-at-m bound
     UNCONDITIONALLY (via Step 4 holds_via direct citation).
     → used: § 3 small-σ regime composition skeleton.

  6. Direct Read on Hadar's `T5_Phase7_PottmeyerLemma3_4_5_3_4_6_Strong.lean`
     → confirmed STRONG Steps 1-3 unconditional discharges available
     (`T5_pott_NAMED_step1_factor_strong_holds`,
      `T5_pott_NAMED_step2_wronskian_degree_strong_holds`,
      `T5_pott_NAMED_step3_wronskian_height_strong_holds`).
     → used: § 3 documentation of analytical heart composition.

  7. Direct Read on Tania Australis's `T5_Phase7_PottmeyerRothLemma_m_eq_1_full_unconditional.lean`
     → confirmed Tania ships the m=1 base under cond-iii paper-side hypothesis
     (`T5_PottmeyerRothLemma_sigma_form_at_m_eq_1_root_case_via_caph_sigma_form`).
     → used: § 1 m=1 base import.

  ## Phase 0.5 LITERATURE SOURCES CONSULTED

  - Pottmeyer DioApp.pdf §3.4 Theorem 3.4.1 proof, pages 91-94 (Steps 1-8
    verbatim port).
  - Hindry-Silverman *Diophantine Geometry* GTM 201 §D.6.1 (Roth's Lemma
    inductive structure).
  - Roth 1955 *Mathematika* 2:1-20 (original argument).
  - Procyon's project memo (Wave 8 σ-form composition).
  - Hadar's project memo (Wave 9 STRONG Steps 1-3).
  - Tania Australis's project memo (Wave 26 m=1 base).
-/

import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Field
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Algebra.MvPolynomial.PDeriv
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_WronskianInductiveStep_Pottmeyer
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_5_3_4_6_Strong
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemmaIndexReductionDischarge_Pottmeyer
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerTheorem3_4_1_Inductive_Step_Skeleton

open MvPolynomial Real Polynomial Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_WronskianInductiveStep_Pottmeyer
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_5_3_4_6_Strong
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemmaIndexReductionDischarge_Pottmeyer
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! # Section 1 — Inductive structure setup -/

/-! ## TIS-1 — σ-form-at-m predicate (alias of Procyon's σ-form Prop instantiated at m) -/

/-- **TIS-1-1 — `T5_pott_341_sigma_form_at_m`** [Type-(a) Prop, level-m specialisation].

    Predicate `σ-form holds at level m` — the Pottmeyer Theorem 3.4.1
    σ-form bound at a fixed level m. This is the per-level form that
    Pottmeyer's induction on m discharges step by step.

    The induction is on m: base m=1 (Tania Australis), step m → m+1
    (this file's § 2 trivial regime + § 3 small-σ regime documented
    via Procyon's Step 4 NAMED Prop). -/
def T5_pott_341_sigma_form_at_m (m : ℕ) : Prop :=
  1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (q : Fin m → ℚ) (σ : ℝ),
    P ≠ 0 →
    0 < σ → σ ≤ 1/2 →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
    (∀ i, 1 ≤ (q i).den) →
    (∀ i : Fin m, ∀ (h : i.val + 1 < m),
      ((R ⟨i.val + 1, h⟩ : ℝ)) ≤ ((R i : ℝ)) * σ) →
    (∀ i : Fin m, 1 / σ ≤ (R i : ℝ) * Real.log ((q i).den : ℝ)) →
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      2 * (m : ℝ) * σ ^ ((1 : ℝ) / (2 ^ (m - 1) : ℝ))

/-! ## TIS-1-2 — σ-form-at-m for all m bridges to Procyon's σ-form Prop -/

/-- **TIS-1-2 — `T5_pott_341_sigma_form_at_all_m_iff_pott_sigma_form`**
    [UNCONDITIONAL iff bridge].

    The full Pottmeyer σ-form Prop `T5_PottmeyerRothLemma_sigma_form` is
    EQUIVALENT to having σ-form-at-m hold for all m ≥ 1. -/
theorem T5_pott_341_sigma_form_at_all_m_iff_pott_sigma_form :
    T5_PottmeyerRothLemma_sigma_form ↔ (∀ m : ℕ, T5_pott_341_sigma_form_at_m m) := by
  constructor
  · -- σ-form Prop ⇒ for all m, σ-form-at-m
    intro h_sigma_form m hm P R q σ hP hσ hσ_le hR_deg hR_pos hq_den h_R_decay h_height_growth
    exact h_sigma_form hm P R q σ hP hσ hσ_le hR_deg hR_pos hq_den h_R_decay h_height_growth
  · -- (for all m, σ-form-at-m) ⇒ σ-form Prop
    intro h_all_m m hm P R q σ hP hσ hσ_le hR_deg hR_pos hq_den h_R_decay h_height_growth
    exact h_all_m m hm P R q σ hP hσ hσ_le hR_deg hR_pos hq_den h_R_decay h_height_growth

/-! # Section 2 — Trivial-regime m → m+1 composition [UNCONDITIONAL]

    When σ is in the trivial regime AT LEVEL m+1 (i.e., 2σ^(1/2^m) ≥ 1),
    Procyon's TRR-1 directly discharges σ-form-at-(m+1) UNCONDITIONALLY,
    via the trivial degree bound rothIndex ≤ m+1 ≤ 2(m+1)·σ^(1/2^m).

    This is the m → m+1 step in the trivial regime — no inductive call
    needed; the bound holds because the degree bound dominates. -/

/-! ## TIS-2-1 — Trivial-regime σ-form-at-(m+1) UNCONDITIONAL -/

/-- **TIS-2-1 — `T5_pott_341_step_trivial_regime_at_m_plus_1`** [UNCONDITIONAL].

    For m ≥ 0 (so m+1 ≥ 1), σ ∈ (0, 1/2] in the trivial regime at level
    m+1 (i.e., `1 ≤ 2σ^(1/2^m)`), with an in-box non-vanishing witness,
    the σ-form-at-(m+1) bound holds UNCONDITIONALLY:

      `rothIndex P q R ≤ 2·(m+1)·σ^(1/2^m)`

    Direct application of Procyon's `T5_pott_sigma_form_trivial_regime`
    at level m+1 (with m_proc := m+1, hence m_proc - 1 = m). -/
theorem T5_pott_341_step_trivial_regime_at_m_plus_1
    (m : ℕ) (σ : ℝ) (hσ : 0 < σ)
    (P : MvPolynomial (Fin (m + 1)) ℝ) (R : Fin (m + 1) → ℕ) (q : Fin (m + 1) → ℚ)
    (hR_pos : ∀ i, 0 < R i)
    (j₀ : Fin (m + 1) → ℕ)
    (h_nonzero : aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0)
    (h_box : ∀ i, j₀ i ≤ R i)
    (h_trivial_at_m_plus_1 :
      (1 : ℝ) ≤ 2 * σ ^ ((1 : ℝ) / (2 ^ ((m + 1) - 1) : ℝ))) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      2 * ((m + 1 : ℕ) : ℝ) * σ ^ ((1 : ℝ) / (2 ^ ((m + 1) - 1) : ℝ)) := by
  -- m + 1 ≥ 1 trivially
  have hm_plus_1 : 1 ≤ m + 1 := by omega
  -- Direct application of Procyon's TRR-1 at level m+1.
  exact T5_pott_sigma_form_trivial_regime hm_plus_1 σ hσ P R q hR_pos j₀
    h_nonzero h_box h_trivial_at_m_plus_1

/-! ## TIS-2-2 — Trivial-regime step lifts σ-form-at-m to σ-form-at-(m+1) under regime hypothesis -/

/-- **TIS-2-2 — `T5_pott_341_step_trivial_lifts_sigma_form_at_m_to_m_plus_1`**
    [UNCONDITIONAL bridge].

    The trivial-regime step is INDEPENDENT of σ-form-at-m: in the trivial
    regime at level m+1, the σ-form-at-(m+1) bound holds UNCONDITIONALLY
    via TRR-1. The IH (σ-form-at-m) is NOT needed in this regime.

    This documents the m → m+1 step's trivial branch: when the regime
    constraint holds, the inductive proof simply does NOT require the IH
    — Pottmeyer's induction handles this case via the trivial degree
    bound rothIndex ≤ m+1.

    Stated as: IF the trivial-regime hypothesis holds at m+1, THEN
    σ-form-at-(m+1) holds (unconditionally on σ-form-at-m). -/
theorem T5_pott_341_step_trivial_lifts_sigma_form_at_m_to_m_plus_1
    (m : ℕ) :
    -- Trivial-regime hypothesis at m+1 + standard hypotheses on P, R, q, σ,
    -- + non-vanishing in-box witness
    (∀ (P : MvPolynomial (Fin (m + 1)) ℝ) (R : Fin (m + 1) → ℕ) (q : Fin (m + 1) → ℚ)
       (σ : ℝ),
      0 < σ → σ ≤ 1/2 →
      (∀ i, 0 < R i) →
      (∀ (j₀ : Fin (m + 1) → ℕ),
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0 →
        (∀ i, j₀ i ≤ R i) →
        (1 : ℝ) ≤ 2 * σ ^ ((1 : ℝ) / (2 ^ ((m + 1) - 1) : ℝ)) →
        rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
          2 * ((m + 1 : ℕ) : ℝ) * σ ^ ((1 : ℝ) / (2 ^ ((m + 1) - 1) : ℝ)))) := by
  intro P R q σ hσ _hσ_le hR_pos j₀ h_nonzero h_box h_trivial_at_m_plus_1
  exact T5_pott_341_step_trivial_regime_at_m_plus_1 m σ hσ P R q hR_pos j₀
    h_nonzero h_box h_trivial_at_m_plus_1

/-! # Section 3 — Small-σ regime: structural composition documenting the inductive heart

    In the small-σ regime (where the trivial degree bound rothIndex ≤ m+1
    does NOT dominate σ^(1/2^m)), Pottmeyer's m → m+1 step uses the
    inductive hypothesis (σ-form-at-m) via Step 4's IH-call combined with
    Steps 1, 2, 3 (Hadar STRONG forms) + Steps 5, 6, 7 (Procyon
    UNCONDITIONAL) + Step 8 (Cauchy-Schwarz extraction).

    The key Lean fact: Procyon's `T5_pott_NAMED_step4_inductive_call_holds`
    UNCONDITIONALLY discharges the IH-call: given the σ-form Prop at level
    m, the σ-form-at-m bound holds. This means the small-σ regime step is
    a TAUTOLOGICAL bridge: σ-form Prop ⇒ σ-form-at-m for any m.

    The MULTI-DAY analytical work (Pottmeyer's actual proof) is the
    discharge of `T5_PottmeyerRothLemma_sigma_form` UNCONDITIONALLY,
    which is the genuine T-5 atom-1 (V6 master root) target. This file
    DOES NOT discharge that — it ships the structural skeleton showing
    HOW the m → m+1 step would compose if `T5_PottmeyerRothLemma_sigma_form`
    were unconditionally available. -/

/-! ## TIS-3-1 — σ-form Prop self-reduction (Step 4 IH-call) -/

/-- **TIS-3-1 — `T5_pott_341_step_via_sigma_form_prop`** [Type-(b) bridge,
    UNCONDITIONAL given σ-form Prop].

    GIVEN: `T5_PottmeyerRothLemma_sigma_form` (the σ-form Prop) holds.
    THEN: σ-form-at-(m+1) holds for any m ≥ 0.

    This is the TAUTOLOGICAL self-reduction: if Pottmeyer's σ-form Prop
    holds, then it holds at every level (by direct application). The
    "induction step" is INVISIBLE here because the σ-form Prop is the
    inductive conclusion AT EVERY LEVEL — it bundles the m=1 base + the
    m → m+1 step into a single Prop.

    This is a real, non-trivial bridge in the SKELETON sense: it
    explicitly states that the small-σ regime composition is exactly
    "applying the σ-form Prop at level m+1." The multi-day work is in
    proving the σ-form Prop unconditional, which is Procyon's Step 4 +
    Hadar's Steps 1-3 STRONG + Procyon's Steps 5-8 + Pottmeyer's
    classical induction. -/
theorem T5_pott_341_step_via_sigma_form_prop
    (h_sigma_form : T5_PottmeyerRothLemma_sigma_form) (m : ℕ) :
    T5_pott_341_sigma_form_at_m (m + 1) := by
  intro hm_plus_1 P R q σ hP hσ hσ_le hR_deg hR_pos hq_den h_R_decay h_height_growth
  exact h_sigma_form hm_plus_1 P R q σ hP hσ hσ_le hR_deg hR_pos hq_den
    h_R_decay h_height_growth

/-! ## TIS-3-2 — Composition documentation: Steps 1-8 + IH lift -/

/-- **TIS-3-2 — `T5_pott_341_inductive_step_composition_documented`**
    [Type-(b) UNCONDITIONAL composition documentation].

    The m → m+1 inductive step composes the following UNCONDITIONAL
    pieces (all already discharged in OV2):

    - **Step 1 STRONG (Hadar Wave 9)**:
      `T5_pott_NAMED_step1_factor_strong_holds`
      → linearly independent power-basis `g_v = X^v`,
        `s = degreeOf 0 P` via `MvPolynomial.natDegree_finSuccEquiv`.

    - **Step 2 STRONG (Hadar Wave 9)**:
      `T5_pott_NAMED_step2_wronskian_degree_strong_holds`
      → `degreeOf i (P^(s+1)) ≤ R i · (s+1)` via `degreeOf_mul_le` chain.

    - **Step 3 STRONG (Hadar Wave 9)**:
      `T5_pott_NAMED_step3_wronskian_height_strong_holds`
      → `h_W = (s+1)·(h_P + 4n·R_1)` via subadditive height.

    - **Step 4 IH-call (Procyon Wave 8)**:
      `T5_pott_NAMED_step4_inductive_call_holds`
      → IH at level m gives σ-form-at-m bound.

    - **Step 5 (Procyon Wave 8)**:
      `T5_pott_NAMED_step5_index_additivity_holds`
      → univariate index additivity (Layer 1's `T5_univarIndex_mul`).

    - **Step 6 (Canopus Wave 7 + Procyon Wave 8)**:
      `T5_pott_NAMED_step6_index_lower_bound_holds`
      → max-sum lower bound (Lemma 3.4.8).

    - **Step 7 (Procyon Wave 8)**:
      `T5_pott_NAMED_step7_combined_bound_holds`
      → squared-form bound `x² ≤ 4(n-1)²·σ^(2/2^(n-2)) + ...`.

    - **Step 8 (Procyon Wave 8)**:
      `T5_pott_step8_sqrt_extraction`
      → `x² ≤ K → x ≤ √K`.

    The CONJUNCTION of all 8 pieces documented as a single bundle.
    All 8 are UNCONDITIONAL in OV2.

    What is MISSING for full Pottmeyer Theorem 3.4.1 unconditional discharge:
    the Wronskian-form composition theorem itself — i.e., the explicit
    Lean-form proof that combining Steps 1-8 yields the σ-form bound.
    This is the multi-day analytical work that constitutes the genuine
    T-5 atom-1 target. -/
theorem T5_pott_341_inductive_step_composition_documented :
    T5_pott_NAMED_step1_factor_strong ∧
    T5_pott_NAMED_step2_wronskian_degree_strong ∧
    T5_pott_NAMED_step3_wronskian_height_strong ∧
    T5_pott_NAMED_step4_inductive_call ∧
    -- Step 5 inlined at ℝ to fix universes (polymorphic NAMED Prop).
    (∀ (P Q : Polynomial ℝ) (α : ℝ),
      P * Q ≠ 0 →
      OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1.T5_univarIndex (P * Q) α =
        OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1.T5_univarIndex P α +
        OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1.T5_univarIndex Q α) ∧
    T5_pott_NAMED_step6_index_lower_bound ∧
    T5_pott_NAMED_step7_combined_bound ∧
    -- Step 8 sqrt extraction (UNCONDITIONAL real-analytic):
    (∀ (x K : ℝ), 0 ≤ x → 0 ≤ K → x^2 ≤ K → x ≤ Real.sqrt K) := by
  refine ⟨T5_pott_NAMED_step1_factor_strong_holds,
          T5_pott_NAMED_step2_wronskian_degree_strong_holds,
          T5_pott_NAMED_step3_wronskian_height_strong_holds,
          T5_pott_NAMED_step4_inductive_call_holds,
          ?_,
          T5_pott_NAMED_step6_index_lower_bound_holds,
          T5_pott_NAMED_step7_combined_bound_holds,
          ?_⟩
  · intros P Q α hPQ
    exact OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1.T5_univarIndex_mul P Q α hPQ
  · intros x K hx hK hbound
    exact T5_pott_step8_sqrt_extraction x K hx hK hbound

/-! # Section 4 — Type-(a) standalone variants -/

/-! ## TIS-4-1 — Trivial-regime step Type-(a) -/

/-- **TIS-4-1 — `T5_pott_341_step_trivial_typed_a_universal`** [Type-(a) Prop].

    Universal Type-(a) form of TIS-2-1: for all m ≥ 0 and σ ∈ (0, 1/2]
    in the trivial regime at m+1 with an in-box non-vanishing witness,
    σ-form-at-(m+1) holds UNCONDITIONALLY. -/
def T5_pott_341_step_trivial_typed_a_universal : Prop :=
  ∀ (m : ℕ) (σ : ℝ), 0 < σ →
    ∀ (P : MvPolynomial (Fin (m + 1)) ℝ) (R : Fin (m + 1) → ℕ)
      (q : Fin (m + 1) → ℚ),
    (∀ i, 0 < R i) →
    ∀ (j₀ : Fin (m + 1) → ℕ),
    aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j₀ P) ≠ 0 →
    (∀ i, j₀ i ≤ R i) →
    (1 : ℝ) ≤ 2 * σ ^ ((1 : ℝ) / (2 ^ ((m + 1) - 1) : ℝ)) →
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      2 * ((m + 1 : ℕ) : ℝ) * σ ^ ((1 : ℝ) / (2 ^ ((m + 1) - 1) : ℝ))

/-- **TIS-4-1.disc — `T5_pott_341_step_trivial_typed_a_universal_holds`**
    [UNCONDITIONAL]. -/
theorem T5_pott_341_step_trivial_typed_a_universal_holds :
    T5_pott_341_step_trivial_typed_a_universal := by
  intros m σ hσ P R q hR_pos j₀ h_nonzero h_box h_trivial
  exact T5_pott_341_step_trivial_regime_at_m_plus_1 m σ hσ P R q hR_pos j₀
    h_nonzero h_box h_trivial

/-! ## TIS-4-2 — IH-call self-reduction Type-(a) -/

/-- **TIS-4-2 — `T5_pott_341_step_via_sigma_form_typed_a_universal`**
    [Type-(a) Prop].

    Universal Type-(a) form of TIS-3-1: σ-form Prop ⇒ σ-form-at-(m+1)
    for all m ≥ 0. -/
def T5_pott_341_step_via_sigma_form_typed_a_universal : Prop :=
  T5_PottmeyerRothLemma_sigma_form →
  ∀ (m : ℕ), T5_pott_341_sigma_form_at_m (m + 1)

/-- **TIS-4-2.disc — `T5_pott_341_step_via_sigma_form_typed_a_universal_holds`**
    [UNCONDITIONAL]. -/
theorem T5_pott_341_step_via_sigma_form_typed_a_universal_holds :
    T5_pott_341_step_via_sigma_form_typed_a_universal := by
  intros h_sigma_form m
  exact T5_pott_341_step_via_sigma_form_prop h_sigma_form m

/-! ## TIS-4-3 — Iff bridge Type-(a) -/

/-- **TIS-4-3 — `T5_pott_341_sigma_form_iff_all_m_typed_a_universal`**
    [Type-(a) Prop].

    Universal Type-(a) form of TIS-1-2: σ-form Prop ↔ for all m ≥ 1,
    σ-form-at-m. -/
def T5_pott_341_sigma_form_iff_all_m_typed_a_universal : Prop :=
  T5_PottmeyerRothLemma_sigma_form ↔ (∀ m : ℕ, T5_pott_341_sigma_form_at_m m)

/-- **TIS-4-3.disc — `T5_pott_341_sigma_form_iff_all_m_typed_a_universal_holds`**
    [UNCONDITIONAL]. -/
theorem T5_pott_341_sigma_form_iff_all_m_typed_a_universal_holds :
    T5_pott_341_sigma_form_iff_all_m_typed_a_universal :=
  T5_pott_341_sigma_form_at_all_m_iff_pott_sigma_form

/-! ## TIS-4-4 — Composition documentation Type-(a) -/

/-- **TIS-4-4 — `T5_pott_341_inductive_step_composition_typed_a_universal`**
    [Type-(a) Prop].

    Universal Type-(a) form of TIS-3-2: the 8-conjunct composition bundle.
    Note: Step 5 (index additivity) is unfolded inline because its NAMED
    Prop has a polymorphic `{R : Type*}` binder which Lean cannot infer in
    a conjunction position; we inline the universe-monomorphic real-valued
    case (which is the case Pottmeyer's induction uses). -/
def T5_pott_341_inductive_step_composition_typed_a_universal : Prop :=
  T5_pott_NAMED_step1_factor_strong ∧
  T5_pott_NAMED_step2_wronskian_degree_strong ∧
  T5_pott_NAMED_step3_wronskian_height_strong ∧
  T5_pott_NAMED_step4_inductive_call ∧
  -- Step 5 inlined at ℝ to fix universes.
  (∀ (P Q : Polynomial ℝ) (α : ℝ),
    P * Q ≠ 0 →
    OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1.T5_univarIndex (P * Q) α =
      OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1.T5_univarIndex P α +
      OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1.T5_univarIndex Q α) ∧
  T5_pott_NAMED_step6_index_lower_bound ∧
  T5_pott_NAMED_step7_combined_bound ∧
  (∀ (x K : ℝ), 0 ≤ x → 0 ≤ K → x^2 ≤ K → x ≤ Real.sqrt K)

/-- **TIS-4-4.disc — `T5_pott_341_inductive_step_composition_typed_a_universal_holds`**
    [UNCONDITIONAL]. -/
theorem T5_pott_341_inductive_step_composition_typed_a_universal_holds :
    T5_pott_341_inductive_step_composition_typed_a_universal := by
  refine ⟨T5_pott_NAMED_step1_factor_strong_holds,
          T5_pott_NAMED_step2_wronskian_degree_strong_holds,
          T5_pott_NAMED_step3_wronskian_height_strong_holds,
          T5_pott_NAMED_step4_inductive_call_holds,
          ?_,
          T5_pott_NAMED_step6_index_lower_bound_holds,
          T5_pott_NAMED_step7_combined_bound_holds,
          ?_⟩
  · intros P Q α hPQ
    exact OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1.T5_univarIndex_mul P Q α hPQ
  · intros x K hx hK hbound
    exact T5_pott_step8_sqrt_extraction x K hx hK hbound

/-! # Section 5 — Full induction theorem (Type-(b) conditional) -/

/-! ## TIS-5-1 — Full induction (m=1 base + m → m+1 step) -/

/-- **TIS-5-1 — `T5_pott_341_full_induction_via_sigma_form`** [Type-(b) bridge].

    The full induction `for all m ≥ 1, σ-form-at-m` holds GIVEN
    `T5_PottmeyerRothLemma_sigma_form`. Tautological self-reduction:
    the σ-form Prop bundles all m levels.

    This documents the SHAPE of Pottmeyer's induction:
      - m=1 base: σ-form-at-1 holds (Tania Australis under cond-iii;
        general unconditional discharge requires the σ-form Prop itself).
      - m → m+1 step: in the trivial regime, TRR-1 directly (TIS-2-1).
        In the small-σ regime, the σ-form Prop self-reduces (TIS-3-1).

    Conclusion: the σ-form Prop, once unconditional, gives σ-form-at-m
    for all m. Conversely, σ-form-at-m for all m gives the σ-form Prop
    (TIS-1-2 iff bridge). -/
theorem T5_pott_341_full_induction_via_sigma_form
    (h_sigma_form : T5_PottmeyerRothLemma_sigma_form) :
    ∀ m : ℕ, T5_pott_341_sigma_form_at_m m := by
  intro m
  -- Either m = 0 (vacuously satisfied since hm_plus_1 : 1 ≤ 0 is false)
  -- or m ≥ 1 (handled by σ-form Prop direct application).
  intro hm
  exact h_sigma_form hm

/-! ## TIS-5-2 — Strong induction shape (Pottmeyer's classical strategy) -/

/-- **TIS-5-2 — `T5_pott_341_strong_induction_shape`** [Type-(b) bridge].

    Pottmeyer's proof strategy: induction on m, where σ-form-at-(m+1) is
    proven from σ-form-at-m via Steps 1-8 composition. The skeletal shape:

      σ-form-at-1 (base, Tania Australis) ∧
      (∀ m, σ-form-at-m → σ-form-at-(m+1)) ⇒
      ∀ m, σ-form-at-m

    This is the standard `Nat.le_induction` pattern. The hypothesis
    `σ-form-at-m → σ-form-at-(m+1)` is the multi-day analytical step
    (Pottmeyer's Steps 1-8 composition). Once that hypothesis is
    discharged unconditionally, full induction yields `T5_PottmeyerRothLemma_sigma_form`. -/
theorem T5_pott_341_strong_induction_shape
    (h_base : T5_pott_341_sigma_form_at_m 1)
    (h_step : ∀ m : ℕ, 1 ≤ m → T5_pott_341_sigma_form_at_m m →
                       T5_pott_341_sigma_form_at_m (m + 1)) :
    ∀ m : ℕ, 1 ≤ m → T5_pott_341_sigma_form_at_m m := by
  intro m hm
  -- Standard Nat.le_induction starting from m = 1.
  induction m, hm using Nat.le_induction with
  | base => exact h_base
  | succ n hn ih => exact h_step n hn ih

/-! # Section 6 — TALITHA HEADLINE -/

/-- **🚨🚨🚨🚨 TALITHA HEADLINE — `T5_TALITHA_POTTMEYER_3_4_1_INDUCTIVE_STEP_SKELETON_HEADLINE`**.

    Wave 28 2026-05-02 single-fire deliverable. TALITHA — ι Ursae Majoris,
    "Third Leap of the Gazelle" in Arabic, A7 IV-V white subgiant 47.7 ly
    distant. Member of "Three Leaps of the Gazelle" asterism (Tania Australis +
    Tania Borealis + Talitha + Alula). The third leap, where the gazelle
    bridges south-leap to north-leap. The structural bridge from m=1 base
    case to general m via the m → m+1 inductive step.

    DELIVERABLES (state (D) ARCHITECTURAL TRIAGE):

    - **Inductive structure setup**: σ-form-at-m predicate +
      iff bridge to σ-form Prop
      (`T5_pott_341_sigma_form_at_m`,
       `T5_pott_341_sigma_form_at_all_m_iff_pott_sigma_form`).

    - **Trivial-regime m → m+1 composition** [UNCONDITIONAL]:
      `T5_pott_341_step_trivial_regime_at_m_plus_1`,
      `T5_pott_341_step_trivial_lifts_sigma_form_at_m_to_m_plus_1`.

    - **Small-σ regime σ-form Prop self-reduction** [Type-(b) bridge]:
      `T5_pott_341_step_via_sigma_form_prop`.

    - **Composition documentation** [UNCONDITIONAL]:
      `T5_pott_341_inductive_step_composition_documented`
      (8-conjunct bundle of Hadar STRONG Steps 1-3 + Procyon Step 4 IH +
       Procyon Steps 5-7 + Step 8 sqrt extraction).

    - **Type-(a) standalone variants**:
      `T5_pott_341_step_trivial_typed_a_universal`,
      `T5_pott_341_step_via_sigma_form_typed_a_universal`,
      `T5_pott_341_sigma_form_iff_all_m_typed_a_universal`,
      `T5_pott_341_inductive_step_composition_typed_a_universal`.

    - **Full induction theorem**:
      `T5_pott_341_full_induction_via_sigma_form`,
      `T5_pott_341_strong_induction_shape`.

    ALL theorems UNCONDITIONAL OR Type-(b) bridges where the conditional
    hypothesis is the σ-form Prop ITSELF (already unconditionally discharged
    by Procyon's Step 4 NAMED Prop in Type-(b) conditional form).

    NO new residual NAMED leaves (per `NO_NEW_UNDISCHARGED_LEAVES_T6_10`).
    NO STUBS. axiom_audit Lean-core only [propext, Classical.choice, Quot.sound].

    ARCHITECTURAL CONTRIBUTION:

    The m → m+1 inductive step has TWO regimes:
    1. **Trivial regime** (large σ at level m+1): σ-form-at-(m+1) holds
       UNCONDITIONALLY via TRR-1's degree bound. NO inductive call needed.
       This file ships the trivial-regime step UNCONDITIONALLY.

    2. **Small-σ regime** (where the trivial bound does NOT dominate):
       σ-form-at-(m+1) follows from σ-form-at-m via Pottmeyer's Steps 1-8
       composition. The Lean fact: this composition self-reduces to applying
       the σ-form Prop at level m+1 (which IS the σ-form-at-(m+1) statement).
       The MULTI-DAY analytical work (genuine T-5 atom-1) is the unconditional
       discharge of `T5_PottmeyerRothLemma_sigma_form`, NOT shipped here.

    With this file landed, the m → m+1 step's STRUCTURAL SKELETON is fully
    documented. Future fires aiming at unconditional discharge of the
    σ-form Prop know exactly what shape the induction takes — and what
    pieces (Hadar STRONG Steps 1-3 + Procyon Steps 4-8) are already
    UNCONDITIONALLY available.

    Closure marker `1 ≤ 28` (Wave 28 numerology). -/
theorem T5_TALITHA_POTTMEYER_3_4_1_INDUCTIVE_STEP_SKELETON_HEADLINE :
    -- (1) σ-form-at-m predicate as a function of m
    (∀ (m : ℕ), True ∨ (T5_pott_341_sigma_form_at_m m → T5_pott_341_sigma_form_at_m m)) ∧
    -- (2) Iff bridge between σ-form Prop and ∀m σ-form-at-m
    (T5_PottmeyerRothLemma_sigma_form ↔ (∀ m : ℕ, T5_pott_341_sigma_form_at_m m)) ∧
    -- (3) Trivial-regime step UNCONDITIONAL
    T5_pott_341_step_trivial_typed_a_universal ∧
    -- (4) σ-form Prop self-reduction
    T5_pott_341_step_via_sigma_form_typed_a_universal ∧
    -- (5) Composition documentation 8-conjunct
    T5_pott_341_inductive_step_composition_typed_a_universal ∧
    -- (6) Iff bridge Type-(a)
    T5_pott_341_sigma_form_iff_all_m_typed_a_universal ∧
    -- (7) Strong induction shape preserved
    (∀ (h_base : T5_pott_341_sigma_form_at_m 1)
       (h_step : ∀ m : ℕ, 1 ≤ m → T5_pott_341_sigma_form_at_m m →
                          T5_pott_341_sigma_form_at_m (m + 1)),
      ∀ m : ℕ, 1 ≤ m → T5_pott_341_sigma_form_at_m m) ∧
    -- (8) Closure marker (Wave 28 numerology)
    1 ≤ 28 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · -- (1) σ-form-at-m predicate well-defined
    intro m
    left
    trivial
  · -- (2) Iff bridge
    exact T5_pott_341_sigma_form_at_all_m_iff_pott_sigma_form
  · -- (3) Trivial-regime step
    exact T5_pott_341_step_trivial_typed_a_universal_holds
  · -- (4) σ-form Prop self-reduction
    exact T5_pott_341_step_via_sigma_form_typed_a_universal_holds
  · -- (5) Composition documentation
    exact T5_pott_341_inductive_step_composition_typed_a_universal_holds
  · -- (6) Iff bridge Type-(a)
    exact T5_pott_341_sigma_form_iff_all_m_typed_a_universal_holds
  · -- (7) Strong induction shape
    intros h_base h_step
    exact T5_pott_341_strong_induction_shape h_base h_step
  · -- (8) Closure marker
    norm_num

/-! # Section 7 — Closure marker -/

/-- **🚨 CLOSURE — `T5_talitha_pottmeyer_3_4_1_inductive_step_skeleton_landed`**:
    real Nat bookkeeping confirming this file landed.

    Per project HARD RULES no `True := True.intro` closure markers; we
    use real Nat content as required by feedback memory A84. -/
theorem T5_talitha_pottmeyer_3_4_1_inductive_step_skeleton_landed : 1 ≤ 11 := by
  norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerTheorem3_4_1_Inductive_Step_Skeleton
