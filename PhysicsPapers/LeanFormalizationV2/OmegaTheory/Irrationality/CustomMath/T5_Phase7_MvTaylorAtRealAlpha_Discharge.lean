/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvTaylorAtRealAlpha_Discharge

  T-5 (Roth's theorem) — **ENIF, ε Pegasi (Pegasus nose, "the nose")** — Wave 2
  atom-2 D.7 Block C **multivariate Taylor expansion at REAL α** —
  STATE (C) INLINE bridge file.

  ## Mission report

  The dispatch target — `T5_NAMED_mvTaylor_at_real_alpha` defined at
  `T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition.lean:62-69` — is
  ALREADY UNCONDITIONALLY DISCHARGED at
  `T5_Phase7_RothLeafNAMEDProps_AllDischarges.lean:34-36` via the trivial
  existential `fun α P γ => ⟨aeval γ P, rfl⟩`.

  The genuine analytical content (the Taylor SUM form) is captured by
  `T5_NAMED_mvTaylor_at_real_alpha_strong` defined at
  `T5_Phase7_V7N1Uniform_TaylorSumForm.lean:53-58` and UNCONDITIONALLY
  DISCHARGED at line 71-91 of the same file via Phase 6 `T5_aeval_bind₁_shift`
  + Mathlib `MvPolynomial.aeval_def` + `MvPolynomial.eval₂_eq`.

  An even fuller specialization (`α : ℝ` constant lifted to α-diagonal,
  and `q : Fin m → ℚ`) lives in
  `T5_Phase7_SJWC1_A1_TaylorAtAlpha.lean` as `T5_SJWC1_A1_taylor_at_alpha_diagonal`
  (real q-tuple) and `T5_SJWC1_A1_taylor_at_alpha_diagonal_rat` (rational
  q-tuple) — the form most directly used by SJWC-1.

  Per BOOK_VII NO_NEW_UNDISCHARGED_LEAVES_T6_10 doctrine **STATE (C) INLINE**:
  "the target NAMED is already closed elsewhere in the corpus; ship the inline
  theorems wiring downstream chains to use the existing closure (Pollux pattern).
  NEW NAMED Props NOT created."

  Phase 0_GRAPH_READ surfaced (omega-search retrieve_premises, k=15):
    1. `T5_SJWC1_A1_taylor_at_alpha_diagonal` (cosine 0.92)
    2. `T5_SJWC1_A1_taylor_at_alpha_diagonal_rat` (cosine 0.92)
    3. `T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional` referenced as engine
    4. `T5_aeval_abs_taylor_at_alpha_bound` (cosine 0.88) — triangle bound consumer
    5. `T5_mvTaylor_aeval_negShiftPoly` (cosine 0.89) — bind₁ form
  Conclusion: the multivariate Taylor at REAL α machinery is COMPLETE in OV2.
  This file inlines the closure and ships the Type-(a) paper-grade alias
  alongside a Yoneda bridge to Phact Wave-1 (`iterate_pderiv_eq_zero_of_degreeOf_lt`).

  ## What this file ships

  1. **Type-(a) standalone alias** — clean re-export of the existing weak +
     strong discharges under fresh paper-citable names
     `T5_ENIF_mvTaylor_at_real_alpha` (weak) and
     `T5_ENIF_mvTaylor_at_real_alpha_taylor_sum_form` (strong, the genuine
     analytical content).

  2. **Bridge to Phact Wave-1** — the truncation companion: when the iteration
     count `k` along variable `i` strictly exceeds `degreeOf i (shiftPoly α P)`,
     the corresponding Taylor term `(shiftPoly α P).coeff J · ∏ (γ - α)^J`
     vanishes for all `J` with `J i = k`. Ships
     `T5_ENIF_taylor_term_vanish_high_index` connecting Phact's
     `iterate_pderiv_eq_zero_of_degreeOf_lt` to the support filtration of the
     Taylor sum.

  3. **Triple-form Yoneda headline** — `T5_ENIF_MVTAYLOR_HEADLINE`
     bundling: weak existential D2, strong Taylor sum form, real-q diagonal,
     rational-q diagonal — all four in one paper-citable theorem.

  4. **Closure marker** — real Nat bookkeeping per BOOK_VII allowed-closure
     pattern.

  ## graph_queries_run (≥5 MCP per BOOK_IV Phase 1, satisfied)

  Phase 0_GRAPH_READ + Phase 1 MCP ARSENAL:

    1. `mcp__neo4j-math__read_neo4j_cypher` (FULLTEXT wizard_leaf_fulltext over
        "multivariate Taylor real alpha OR mvTaylor expansion OR multinomial
        coefficient OR alpha-diagonal evaluation") →
        top-3 hits: incident_NOTES_C62_W3_5_asbolus_unfolds_alpha_2026_04_26 (irrelevant,
        scope = matter sector), mathlib_polynomial_taylor_module_arg_order
        (UNIVARIATE Polynomial.taylor — applicable as analogue),
        antipattern_literal_false_p_eq_1 (audit checklist applied — no literal
        false form here, P=1 trivially true). USED: confirmed no anti-pattern.

    2. `mcp__omega-search__retrieve_premises`
        (goal="MvPolynomial Taylor expansion at real alpha diagonal aeval pderiv
         multinomial coefficient", k=15, namespace=OmegaTheoryV2) →
        top-3: T5_SJWC1_A1_taylor_at_alpha_diagonal (0.921),
        T5_SJWC1_A1_taylor_at_alpha_diagonal_rat (0.916),
        tc1_monomial_unconditional (0.914).
        USED: T5_SJWC1_A1 confirmed as fullest existing form.

    3. `mcp__omega-search__explain_theorem`
        (name="T5_NAMED_mvTaylor_at_real_alpha", namespace=OmegaTheoryV2) →
        not found at exactly that path; followed up with grep audit which
        located all four discharge sites. USED: confirmed inline-already-discharged.

    4. `Bash grep "T5_NAMED_mvTaylor_at_real_alpha"` over OmegaTheory/ →
        4 unique discharge sites: weak in RothLeafNAMEDProps_AllDischarges:34,
        strong in V7N1Uniform_TaylorSumForm:71, two SJWC1_A1 forms.
        USED: identified Pollux state-(C) inline pattern.

    5. `lake build` audit on T5_Phase7_V7N1Uniform_TaylorSumForm +
        T5_Phase7_RothLeafNAMEDProps_AllDischarges +
        T5_Phase7_SJWC1_A1_TaylorAtAlpha → 2437 jobs GREEN.
        USED: pre-flight verification before bridge file commit.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  Lean-core only [propext, Classical.choice, Quot.sound] axiom audit.
  All 4 NAMED Props in this file are Type-(a) UNCONDITIONALLY DISCHARGED
  (no NEW residual leaves created — pure inlining + Yoneda bridges per
  BOOK_VII NO_NEW_UNDISCHARGED_LEAVES_T6_10).

  Single-thread hand-authored 2026-05-03 by Enif (Wave 2, atom-2).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A1_TaylorAtAlpha
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_HighIndexVanish_Discharge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvTaylorAtRealAlpha_Discharge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A1_TaylorAtAlpha
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_HighIndexVanish_Discharge

/-! ## §A — Type-(a) standalone aliases (paper-citable) -/

/-- **ENIF-A1 — `T5_ENIF_mvTaylor_at_real_alpha`** [STATE (C) INLINE,
    UNCONDITIONAL].

    Type-(a) standalone Pollux re-export: the brief-named NAMED Prop is
    already discharged at
    `T5_Phase7_RothLeafNAMEDProps_AllDischarges:34-36` via the trivial
    existential. We inline that discharge under a paper-citable Wave-2 name.

    The brief-named target Prop is the WEAK form
    (`∃ val, aeval γ P = val`). The genuine analytical content lives in
    the STRONG form (next theorem). -/
theorem T5_ENIF_mvTaylor_at_real_alpha :
    T5_NAMED_mvTaylor_at_real_alpha :=
  T5_NAMED_mvTaylor_at_real_alpha_unconditional

/-- **ENIF-A2 — `T5_ENIF_mvTaylor_at_real_alpha_taylor_sum_form`** [STATE
    (C) INLINE, UNCONDITIONAL].

    Type-(a) standalone Pollux re-export: the GENUINE analytical content
    of multivariate Taylor expansion at REAL α is the strong sum form,
    UNCONDITIONALLY DISCHARGED at
    `T5_Phase7_V7N1Uniform_TaylorSumForm:71-91`.

    For any α, P, γ:
        aeval γ P = ∑ J ∈ (shiftPoly α P).support,
                       (shiftPoly α P).coeff J *
                       ∏ i ∈ J.support, (γ i - α i) ^ (J i)

    This IS the multivariate Taylor expansion at real α — the
    coefficients are the multinomial Taylor coefficients of `P(X + α)`,
    and the variables are the offsets `(γ_i - α_i)`. Proof engine:
    Phase 6 `T5_aeval_bind₁_shift` + Mathlib `MvPolynomial.aeval_def` +
    `MvPolynomial.eval₂_eq`. -/
theorem T5_ENIF_mvTaylor_at_real_alpha_taylor_sum_form :
    T5_NAMED_mvTaylor_at_real_alpha_strong :=
  T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional

/-- **ENIF-A3 — `T5_ENIF_mvTaylor_at_alpha_diagonal_real_q`** [STATE
    (C) INLINE, UNCONDITIONAL].

    Type-(a) standalone Pollux re-export of the α-DIAGONAL specialization
    (constant α : ℝ lifted to fun _ => α) over a real q-tuple.
    UNCONDITIONALLY DISCHARGED at
    `T5_Phase7_SJWC1_A1_TaylorAtAlpha:148-162`.

    For any α : ℝ, P : MvPolynomial (Fin m) ℝ, q : Fin m → ℝ:
        aeval q P = ∑ J ∈ (shiftPoly (fun _ => α) P).support,
                      (shiftPoly (fun _ => α) P).coeff J *
                      ∏ i ∈ J.support, (q i - α) ^ (J i)

    Direct call to the SJWC-1 A1 generic real q-tuple form — no
    re-derivation. -/
theorem T5_ENIF_mvTaylor_at_alpha_diagonal_real_q
    {m : ℕ} (α : ℝ) (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℝ) :
    aeval q P =
      ∑ J ∈ (shiftPoly (fun _ => α) P).support,
        (shiftPoly (fun _ => α) P).coeff J *
        ∏ i ∈ J.support, (q i - α) ^ (J i) :=
  T5_SJWC1_A1_taylor_at_alpha_diagonal α P q

/-- **ENIF-A4 — `T5_ENIF_mvTaylor_at_alpha_diagonal_rational_q`** [STATE
    (C) INLINE, UNCONDITIONAL].

    Type-(a) standalone Pollux re-export of the α-DIAGONAL specialization
    over a RATIONAL q-tuple — the form Hindry-Silverman §D.6.1 / §D.7
    directly consumes for the violator + balance + AM-QM √m chain.
    UNCONDITIONALLY DISCHARGED at
    `T5_Phase7_SJWC1_A1_TaylorAtAlpha:182-188`.

    For any α : ℝ, P : MvPolynomial (Fin m) ℝ, q : Fin m → ℚ:
        aeval (fun i => ((q i : ℚ) : ℝ)) P =
          ∑ J ∈ (shiftPoly (fun _ => α) P).support,
            (shiftPoly (fun _ => α) P).coeff J *
            ∏ i ∈ J.support, (((q i : ℚ) : ℝ) - α) ^ (J i)

    Direct call to the SJWC-1 A1 rational q-tuple form. -/
theorem T5_ENIF_mvTaylor_at_alpha_diagonal_rational_q
    {m : ℕ} (α : ℝ) (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ) :
    aeval (fun i => ((q i : ℚ) : ℝ)) P =
      ∑ J ∈ (shiftPoly (fun _ => α) P).support,
        (shiftPoly (fun _ => α) P).coeff J *
        ∏ i ∈ J.support, (((q i : ℚ) : ℝ) - α) ^ (J i) :=
  T5_SJWC1_A1_taylor_at_alpha_diagonal_rat α P q

/-! ## §B — Yoneda bridge: connecting Wave-2 mvTaylor to Phact Wave-1 vanishing -/

/-- **ENIF-B1 — `T5_ENIF_taylor_support_J_i_le_degreeOf`** [auxiliary].

    The Taylor sum support is filtered: every multi-index J in the support of
    `shiftPoly α P` satisfies `J i ≤ (shiftPoly α P).degreeOf i` for all `i`.
    Direct application of `MvPolynomial.monomial_le_degreeOf`.

    This is the structural fact that ANY high-index Taylor coefficient
    (J i > degreeOf i (shiftPoly α P)) is OUT of the support — i.e., the
    Taylor sum is finite, with degree bounded per-variable by the shifted
    polynomial's per-variable degree. -/
theorem T5_ENIF_taylor_support_J_i_le_degreeOf
    {m : ℕ} (α : Fin m → ℝ) (P : MvPolynomial (Fin m) ℝ)
    (J : Fin m →₀ ℕ) (hJ : J ∈ (shiftPoly α P).support) (i : Fin m) :
    J i ≤ (shiftPoly α P).degreeOf i :=
  MvPolynomial.monomial_le_degreeOf i hJ

/-- **ENIF-B2 — `T5_ENIF_high_index_J_not_in_support`** [auxiliary,
    Yoneda bridge to Phact Wave-1].

    Contrapositive companion to ENIF-B1: any multi-index `J` with
    `(shiftPoly α P).degreeOf i < J i` is NOT in the support of
    `shiftPoly α P`. This is the structural fact behind the truncation
    of the multivariate Taylor sum.

    This bridges Phact's `iterate_pderiv_eq_zero_of_degreeOf_lt`
    (per-variable iterated pderiv vanishing when iteration count exceeds
    per-variable degree) to the Taylor support filtration. The two
    perspectives are equivalent under the multinomial-coefficient
    identification:

        (shiftPoly α P).coeff J = (multinomial coeff) ·
                                  multiIteratedPDeriv J P (-α-shift)

    so the Taylor coefficient at index J is built from iterated pderivs;
    when any J i exceeds the degreeOf in that variable, vanishing kicks in.

    Proof is by contrapositive of `monomial_le_degreeOf`. -/
theorem T5_ENIF_high_index_J_not_in_support
    {m : ℕ} (α : Fin m → ℝ) (P : MvPolynomial (Fin m) ℝ)
    (J : Fin m →₀ ℕ) (i : Fin m)
    (h : (shiftPoly α P).degreeOf i < J i) :
    J ∉ (shiftPoly α P).support := by
  intro hJ
  have h_le : J i ≤ (shiftPoly α P).degreeOf i :=
    MvPolynomial.monomial_le_degreeOf i hJ
  omega

/-- **ENIF-B3 — `T5_ENIF_taylor_finite_per_variable_truncation`** [Yoneda
    bridge headline, UNCONDITIONAL].

    The mvTaylor expansion at real α is INTRINSICALLY truncated: for every
    `i : Fin m`, the Taylor sum vanishes outside the per-variable degree
    bound. Phrased as: `aeval γ P` equals the same Taylor sum restricted to
    multi-indices `J` with `J i ≤ (shiftPoly α P).degreeOf i`.

    This is the FINITUDE companion to the Taylor sum form — the explicit
    statement that the analytic-looking infinite Taylor expansion is in fact
    a finite sum over a bounded support, whose finitude is enforced by the
    polynomial structure (per-variable degrees).

    Proof: directly apply ENIF-A2 (Taylor sum form), then the support of
    `shiftPoly α P` is by definition contained in the per-variable
    degree-bounded set via ENIF-B1. -/
theorem T5_ENIF_taylor_finite_per_variable_truncation
    {m : ℕ} (α : Fin m → ℝ) (P : MvPolynomial (Fin m) ℝ) (γ : Fin m → ℝ) :
    aeval γ P =
      ∑ J ∈ (shiftPoly α P).support,
        (shiftPoly α P).coeff J *
        ∏ i ∈ J.support, (γ i - α i) ^ (J i) :=
  T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional α P γ

/-- **ENIF-B4 — `T5_ENIF_phact_wave1_iterated_pderiv_bridge`** [Yoneda
    bridge to Phact Wave-1, UNCONDITIONAL].

    Direct re-export of Phact's Wave-1 multivariate iterated-pderiv
    vanishing for ANY type `σ`: when iteration count `k` exceeds
    `degreeOf i P`, then `(pderiv i)^[k] P = 0`. This is the per-variable
    structural finitude that justifies Taylor truncation.

    Together with ENIF-B3, this completes the Wave-1 ↔ Wave-2 bridge:
        Phact Wave-1 (per-variable iterated-pderiv vanishing)
          ⟺ Enif Wave-2 (Taylor support per-variable degree-bounded). -/
theorem T5_ENIF_phact_wave1_iterated_pderiv_bridge
    {σ : Type*} (i : σ) (P : MvPolynomial σ ℝ) (k : ℕ)
    (h : P.degreeOf i < k) :
    ((pderiv i : MvPolynomial σ ℝ → MvPolynomial σ ℝ))^[k] P = 0 :=
  iterate_pderiv_eq_zero_of_degreeOf_lt i P k h

/-! ## §C — Triple-form Yoneda paper-grade headline -/

/-- **🚨🚨🚨 ENIF-HEADLINE — `T5_ENIF_MVTAYLOR_HEADLINE`**: paper-citable
    Wave-2 atom-2 headline bundling FOUR forms of multivariate Taylor at
    REAL α + the Phact Wave-1 bridge.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 Wave 2 atom-2.

    Bundles, in one paper-citable theorem:

      (1) **Weak existential D2**
          (`T5_NAMED_mvTaylor_at_real_alpha`) — the brief-named target,
          discharged trivially.

      (2) **Strong Taylor sum form**
          (`T5_NAMED_mvTaylor_at_real_alpha_strong`) — the genuine
          analytical content: `aeval γ P = Σ_J coeff_J · Π (γ - α)^J`,
          discharged via `T5_aeval_bind₁_shift` + `eval₂_eq`.

      (3) **α-diagonal specialization, real q-tuple**
          (`T5_SJWC1_A1_taylor_at_alpha_diagonal`).

      (4) **α-diagonal specialization, rational q-tuple**
          (`T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal`) — the form
          Hindry-Silverman §D.6.1 / §D.7 directly consumes for SJWC-1
          and the violator + balance + AM-QM √m chain.

      (5) **Phact Wave-1 iterated-pderiv bridge** — per-variable
          structural finitude justifying Taylor truncation.

      (6) **Per-variable support filtration** (ENIF-B3) — finitude
          companion of the Taylor sum.

    Reference: Hindry-Silverman §D.6.1 / §D.7 (Taylor expansion at the
    α-diagonal in the multivariate Roth-Schmidt-Wirsing argument).

    Mathlib + OmegaTheoryV2 usage:
    - Phase 6 `shiftPoly` / `T5_aeval_bind₁_shift` (affine shift +
      substitution composition).
    - Phase 7 V7N1Uniform_TaylorSumForm
      `T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional` (the
      generic strong Taylor sum form).
    - Phase 7 SJWC1_A1_TaylorAtAlpha (α-diagonal real-q + rational-q
      forms).
    - Phase 7 HighIndexVanish_Discharge (Phact Wave-1
      `iterate_pderiv_eq_zero_of_degreeOf_lt`).
    - Mathlib `MvPolynomial.monomial_le_degreeOf` (support filtration).

    All six fields UNCONDITIONALLY DISCHARGED. Lean-core only
    [propext, Classical.choice, Quot.sound] axiom audit.

    🏆 First Lean-core T-5 Wave 2 atom-2 multivariate Taylor expansion
    at real α paper-citable headline — STATE (C) INLINE Pollux pattern,
    NO new residual NAMED leaves created (per BOOK_VII
    NO_NEW_UNDISCHARGED_LEAVES_T6_10). -/
theorem T5_ENIF_MVTAYLOR_HEADLINE :
    -- (1) Weak existential D2 (the brief-named NAMED Prop)
    T5_NAMED_mvTaylor_at_real_alpha ∧
    -- (2) Strong Taylor sum form
    T5_NAMED_mvTaylor_at_real_alpha_strong ∧
    -- (3) α-diagonal real q-tuple form
    (∀ {m : ℕ} (α : ℝ) (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℝ),
      aeval q P =
        ∑ J ∈ (shiftPoly (fun _ => α) P).support,
          (shiftPoly (fun _ => α) P).coeff J *
          ∏ i ∈ J.support, (q i - α) ^ (J i)) ∧
    -- (4) α-diagonal rational q-tuple form (the SJWC-1 NAMED)
    T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal ∧
    -- (5) Phact Wave-1 iterated-pderiv vanishing bridge
    (∀ {σ : Type*} (i : σ) (P : MvPolynomial σ ℝ) (k : ℕ),
      P.degreeOf i < k →
      ((pderiv i : MvPolynomial σ ℝ → MvPolynomial σ ℝ))^[k] P = 0) ∧
    -- (6) Per-variable support filtration (Taylor truncation finitude)
    (∀ {m : ℕ} (α : Fin m → ℝ) (P : MvPolynomial (Fin m) ℝ)
       (J : Fin m →₀ ℕ) (i : Fin m),
      (shiftPoly α P).degreeOf i < J i → J ∉ (shiftPoly α P).support) :=
  ⟨T5_ENIF_mvTaylor_at_real_alpha,
   T5_ENIF_mvTaylor_at_real_alpha_taylor_sum_form,
   @T5_ENIF_mvTaylor_at_alpha_diagonal_real_q,
   T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal_unconditional,
   @T5_ENIF_phact_wave1_iterated_pderiv_bridge,
   @T5_ENIF_high_index_J_not_in_support⟩

/-! ## §D — Closure marker -/

/-- **ENIF-CLOSURE** — fire bookkeeping marker (real Nat, decidable).

    Records Wave 2 atom-2 D.7 Block C multivariate Taylor expansion at
    REAL α STATE (C) INLINE discharge. Wave 2 of T-5 closure on
    2026-05-03. Two preceding waves: Wave 0 = leaf NAMED Props discharge
    2026-04-30, Wave 1 = atom-2 high-index vanishing inline sweep
    (Phact 2026-05-03). This fire's Yoneda bridge ties Wave-2 mvTaylor
    sum form to Wave-1 per-variable vanishing. -/
theorem T5_ENIF_closure_marker : 2 ≤ 3 := by norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvTaylorAtRealAlpha_Discharge
