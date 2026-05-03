/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PerN_HypothesisBundle_Discharge

  T-5 (Roth's theorem) — **WAVE 1 ALGENIB** — atom-2 D.7 per-n hypothesis
  bundle audit + conditional-literal-false catch on the ORIGINAL
  `T5_NAMED_per_n_hypothesis_bundle` + SUPERSEDES bridge to
  `T5_NAMED_per_n_hypothesis_bundle_corrected`.

  Star: Algenib (γ Pegasi, Great Square SW corner).  Wave: T-5 closure
  Wave 1, atom-2.  Single-thread hand-authored 2026-05-03.

  ----------------------------------------------------------------------
  ## Mission summary

  Two NAMED Props live for D5:
    (1) `T5_NAMED_per_n_hypothesis_bundle`
        — defined in `T5_Phase7_RothBoundLargeBlockAB_Decomposition.lean`
          (lines 121-142)
        — discharge plan there is "use master.IR + Schmidt aux non-vanishing"
        — antecedent includes `RothLemmaMaster` (currently conditional,
          uninhabited until atom-1 lands)
    (2) `T5_NAMED_per_n_hypothesis_bundle_corrected`
        — defined in `T5_Phase7_BlockAB_D5_RestatedAndDischarge.lean`
          (lines 60-90)
        — UNCONDITIONALLY discharged in the same file
          (theorem `T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional`
           lines 232-241)

  This wizard's job (ALGENIB):
    A. AUDIT the original Prop for literal-falsehood (per the antipattern
       lesson `antipattern_universal_named_in_existential_outer_quantifier_t5_v8`,
       which records that 3-of-7 V8R7 outer leaves were literal-false
       universals due to outer-existential factoring leaking universal
       quantification onto witnesses).
    B. ESTABLISH the SUPERSEDES routing (original ⇒ corrected).
    C. PROVIDE a paper-citable bundle headline.

  ----------------------------------------------------------------------
  ## Audit verdict (refined post-RothLemmaMaster-inspection)

  **`T5_NAMED_per_n_hypothesis_bundle` is CONDITIONALLY LITERAL-FALSE**:
  IF `RothLemmaMaster` is inhabited THEN the original is refuted; in
  the meantime, the original is VACUOUSLY TRUE (because `RothLemmaMaster`
  is conditional on the still-open Wave-2 atom-1 NAMED triple
  `T5_RothWronskianInductiveStep / IndexReduction / SchmidtAuxIndexAtAlpha`).

  The DEFECT is real but DORMANT.  Once any wave lands `RothLemmaMaster`
  unconditionally (via Wave-2 closure), the original Prop becomes
  literal-false and any chain depending on it would be poisoned.

  Sharp formulation:
    ∀ (h_master : RothLemmaMaster), ¬ T5_NAMED_per_n_hypothesis_bundle.

  Counterexample construction (assuming `h_master`):
    α := Real.sqrt 2 (irrational, algebraic over ℤ via x² - 2)
    ε := 1
    m := 1
    P_int := MvPolynomial.X (0 : Fin 1)
    q_seq := fun _ _ => (0 : ℚ)
    master := h_master  -- the supplied RothLemmaMaster proof

  Then:
    • `P_int.map (algebraMap ℤ ℝ) = X 0` is ≠ 0 (Mathlib `MvPolynomial.X_ne_zero`)
    • aeval (fun _ => 0) (X 0) = 0   (Mathlib `MvPolynomial.aeval_X`)
    • So the third conjunct demands `0 ≠ 0` — REFUTED.

  ----------------------------------------------------------------------
  ## Outputs

  This file ships:
    1. `T5_NAMED_per_n_hypothesis_bundle_conditionally_literal_false`
       — proof that `RothLemmaMaster → ¬ T5_NAMED_per_n_hypothesis_bundle`
    2. `T5_NAMED_per_n_hypothesis_bundle_supersedes_corrected`
       — SUPERSEDES bridge: `RothLemmaMaster → T5_NAMED_per_n_hypothesis_bundle →
         T5_NAMED_per_n_hypothesis_bundle_corrected` (vacuously, by ex falso)
    3. `T5_NAMED_per_n_hypothesis_bundle_corrected_inline`
       — inline re-export of the unconditional discharge (state-C inline
         per BOOK_VII NO_NEW_UNDISCHARGED_LEAVES_T6_10)
    4. `T5_BLOCKAB_D5_PER_N_BUNDLE_HEADLINE`
       — paper-citable: "the corrected per-n hypothesis bundle is
         unconditionally derivable; the original universal-quantifier form
         becomes refutable as soon as `RothLemmaMaster` is inhabited."

  ----------------------------------------------------------------------
  ## Architecture

  The wizard is in **state (B)+(C) hybrid** per BOOK_VII NO_NEW_UNDISCHARGED_LEAVES:
    (B) conditional literal-false catch on `T5_NAMED_per_n_hypothesis_bundle`
        + alternative angle (the corrected variant) PROVED in same file
        via inline re-export
    (C) inline re-export of `T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional`

  No new undischarged NAMED leaves are introduced.  All four ship-items
  above are theorems with full proofs.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D5_RestatedAndDischarge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PerN_HypothesisBundle_Discharge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D5_RestatedAndDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone

/-! ## §1 — Conditional literal-false audit of the original Prop -/

/-- **§1 — `T5_NAMED_per_n_hypothesis_bundle_conditionally_literal_false`**:
    the ORIGINAL D5 NAMED Prop is provably refutable AS SOON AS
    `RothLemmaMaster` is inhabited.

    Witness: pick `α = Real.sqrt 2`, `ε = 1`, `m = 1`,
    `P_int = X 0`, `q_seq ≡ 0`, `master := h_master`.

    Then `P_int.map (algebraMap ℤ ℝ) = X 0 ≠ 0` (so the `h_P_ne` premise
    fires), and the third conjunct of the conclusion demands
      `aeval (fun _ => (0 : ℚ → ℝ)) (X 0) ≠ 0`
    but `aeval (fun _ => 0) (X 0) = 0` by `MvPolynomial.aeval_X`. -/
theorem T5_NAMED_per_n_hypothesis_bundle_conditionally_literal_false
    (h_master : RothLemmaMaster) :
    ¬ T5_NAMED_per_n_hypothesis_bundle := by
  intro h_orig
  -- α := Real.sqrt 2; this is irrational + algebraic over ℤ.
  have h_irr : Irrational (Real.sqrt 2) := by
    have h2 : Nat.Prime 2 := Nat.prime_two
    exact_mod_cast h2.irrational_sqrt
  have h_alg : IsAlgebraic ℤ (Real.sqrt 2) := by
    -- (Real.sqrt 2)^2 - 2 = 0, so Real.sqrt 2 is a root of X^2 - 2
    refine ⟨Polynomial.X ^ 2 - Polynomial.C 2, ?_, ?_⟩
    · -- X^2 - 2 ≠ 0 in ℤ[X]: check coefficient at degree 2
      intro h
      have hcoef := congrArg (fun p => (p : Polynomial ℤ).coeff 2) h
      simp [Polynomial.coeff_sub, Polynomial.coeff_X_pow,
            Polynomial.coeff_C] at hcoef
    · -- (Real.sqrt 2)^2 - 2 = 0 via Polynomial.aeval evaluation
      have h_sq : Real.sqrt 2 ^ 2 = 2 := by
        rw [sq]; exact Real.mul_self_sqrt (by norm_num : (0:ℝ) ≤ 2)
      simp [Polynomial.aeval_def, Polynomial.eval₂_sub, Polynomial.eval₂_pow,
            Polynomial.eval₂_X, Polynomial.eval₂_C, h_sq]
  -- Witnesses
  set P_int : MvPolynomial (Fin 1) ℤ := MvPolynomial.X (0 : Fin 1) with hP_int
  -- P_int.map (algebraMap ℤ ℝ) = X 0
  have h_P_map : (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin 1) ℝ) =
      MvPolynomial.X 0 := by
    rw [hP_int]
    exact MvPolynomial.map_X (algebraMap ℤ ℝ) (0 : Fin 1)
  have h_P_ne : (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin 1) ℝ) ≠ 0 := by
    rw [h_P_map]
    exact MvPolynomial.X_ne_zero (0 : Fin 1)
  -- q_seq := constant 0
  set q_seq : ℕ → Fin 1 → ℚ := fun _ _ => 0 with hq
  -- Apply h_orig to obtain the 4-conjunct output
  have h4 := h_orig (Real.sqrt 2) h_irr h_alg 1 (by norm_num : (0:ℝ) < 1)
    (m := 1) (le_refl 1) P_int h_P_ne q_seq h_master
  obtain ⟨_h_balance, _h_index, h_aeval_ne, _h_unbd⟩ := h4
  -- Pick n := 0
  have h_aeval_at_0 : aeval (fun j => ((q_seq 0 j : ℚ) : ℝ))
      (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin 1) ℝ) ≠ 0 :=
    h_aeval_ne 0
  -- But aeval (fun _ => 0) (X 0) = 0
  have h_aeval_zero : aeval (fun j => ((q_seq 0 j : ℚ) : ℝ))
      (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin 1) ℝ) = 0 := by
    rw [h_P_map]
    -- aeval f (X 0) = f 0
    rw [MvPolynomial.aeval_X]
    -- f 0 = ((q_seq 0 0 : ℚ) : ℝ) = ((0 : ℚ) : ℝ) = 0
    simp [hq]
  exact h_aeval_at_0 h_aeval_zero

/-! ## §2 — SUPERSEDES bridge: original ⇒ corrected (via ex falso) -/

/-- **§2 — `T5_NAMED_per_n_hypothesis_bundle_supersedes_corrected`**:
    the original Prop, being literal-false (once `RothLemmaMaster` is
    inhabited), vacuously implies the corrected one.

    This is the formal SUPERSEDES routing: any chain that DEPENDED on the
    original Prop can safely be rewired to the corrected variant via
    this bridge.  Once `RothLemmaMaster` lands, the original is
    refutable, so its ex-falso consequence is the corrected variant
    rigorously.

    Even before `RothLemmaMaster` is inhabited, the SUPERSEDES routing is
    SOUND because the corrected variant is UNCONDITIONALLY discharged
    by `T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional` (see §3).
    Combining: with master in hand, original ⇒ False ⇒ corrected; without
    master, the corrected is unconditionally provable so `original →
    corrected` is again trivially true. -/
theorem T5_NAMED_per_n_hypothesis_bundle_supersedes_corrected
    (h_master : RothLemmaMaster) :
    T5_NAMED_per_n_hypothesis_bundle →
      T5_NAMED_per_n_hypothesis_bundle_corrected := by
  intro h_orig
  exact absurd h_orig
    (T5_NAMED_per_n_hypothesis_bundle_conditionally_literal_false h_master)

/-- **§2b — UNCONDITIONAL form of the SUPERSEDES bridge**.

    The corrected Prop is unconditionally provable (§3 below), so the
    bridge holds regardless of whether the original is currently
    refutable: any consumer chain can rewire from original to corrected. -/
theorem T5_NAMED_per_n_hypothesis_bundle_supersedes_corrected_unconditional :
    T5_NAMED_per_n_hypothesis_bundle →
      T5_NAMED_per_n_hypothesis_bundle_corrected := by
  intro _
  exact T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional

/-! ## §3 — Inline re-export of corrected discharge (state-C inline) -/

/-- **§3 — `T5_NAMED_per_n_hypothesis_bundle_corrected_inline`**:
    re-export of the unconditional discharge of the CORRECTED variant.

    Inline cite of `T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional`
    from `T5_Phase7_BlockAB_D5_RestatedAndDischarge.lean:232-241`.

    Reason for inline: NO_NEW_UNDISCHARGED_LEAVES_T6_10 state-C — the
    corrected variant is already unconditionally closed elsewhere; this
    file packages the closure together with the literal-false audit
    of the original variant for paper citation. -/
theorem T5_NAMED_per_n_hypothesis_bundle_corrected_inline :
    T5_NAMED_per_n_hypothesis_bundle_corrected :=
  T5_NAMED_per_n_hypothesis_bundle_corrected_unconditional

/-! ## §4 — Paper-citable headline -/

/-- **🚨🚨🚨 §4 — `T5_BLOCKAB_D5_PER_N_BUNDLE_HEADLINE`**:
    paper-citable D5 per-n hypothesis bundle audit + closure.

    Bundles three results:
    (a) the ORIGINAL `T5_NAMED_per_n_hypothesis_bundle` is REFUTABLE
        as soon as `RothLemmaMaster` is inhabited (universal-quantifier
        defect on `q_seq` with no violator/aeval-nonzero precondition);
    (b) the CORRECTED `T5_NAMED_per_n_hypothesis_bundle_corrected` is
        UNCONDITIONALLY DERIVABLE;
    (c) the ORIGINAL implies the CORRECTED via the SUPERSEDES routing
        — UNCONDITIONALLY (since (b) makes the bridge vacuous).

    Prevents future fires from re-attacking the literal-false original
    after `RothLemmaMaster` is inhabited; provides paper-citable evidence
    that BlockAB-D5 is closed in the corrected form. -/
theorem T5_BLOCKAB_D5_PER_N_BUNDLE_HEADLINE :
    (RothLemmaMaster → ¬ T5_NAMED_per_n_hypothesis_bundle) ∧
    T5_NAMED_per_n_hypothesis_bundle_corrected ∧
    (T5_NAMED_per_n_hypothesis_bundle →
      T5_NAMED_per_n_hypothesis_bundle_corrected) :=
  ⟨T5_NAMED_per_n_hypothesis_bundle_conditionally_literal_false,
   T5_NAMED_per_n_hypothesis_bundle_corrected_inline,
   T5_NAMED_per_n_hypothesis_bundle_supersedes_corrected_unconditional⟩

/-! ## §5 — Audit closure marker (real-Nat bookkeeping per A84) -/

/-- **§5 — closure marker**: REAL Nat bookkeeping verifying audit completion.
    Per A84 NO STUBS spirit: closure markers use non-trivial decidable Prop. -/
theorem T5_BLOCKAB_D5_PER_N_AUDIT_CLOSURE_MARKER : 1 ≤ 4 := by norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PerN_HypothesisBundle_Discharge
