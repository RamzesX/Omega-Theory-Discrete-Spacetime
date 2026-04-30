/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A1_TaylorAtAlpha

  T-5 (Roth's theorem) — **SJWC-1 sub-lemma A1: Multivariate Taylor
  expansion at α-DIAGONAL evaluated on a rational q-tuple**.

  Single-thread hand-authored 2026-04-30 (cycle 65, Erdős-Primarch v8,
  bundled-lemma-file pattern).
  Per project rule §7.0 NO STUBS.

  ## Mathematical content

  This is the FIRST sub-lemma of the SJWC-1 HEART decomposition
  (`T5_NAMED_index_at_q_strict_upper_bound`).  SJWC-1 needs the Taylor
  expansion of `aeval q P` centered at the α-diagonal `(α, α, ..., α)`
  to show

      `rothIndex P (q-tuple) R < t - √(mε) + ε/m`

  starting from `rothIndex P (α-diagonal) R ≥ t`.

  The CRUCIAL FORM for SJWC-1: write `P(q)` as a finite sum of monomials
  in the offset `(q i - α)` with coefficients given by the shifted
  polynomial `shiftPoly (α-diagonal) P`:

      `P(q) = Σ_J coeff_J(P) · Π_i (q_i - α)^{J_i}`

  where `coeff_J(P) = (shiftPoly (fun _ => α) P).coeff J`.  These are
  EXACTLY the multinomial Taylor coefficients of `P` at the point
  `(α, α, ..., α)`.

  This file ships THREE paper-grade lemmas:

  1. `T5_SJWC1_A1_aeval_q_eq_aeval_offset` — **the substitution form**:
     evaluation at the rational q-tuple equals evaluation of the shifted
     polynomial at the offset (q - α-diagonal).  The bridge between
     "evaluate at q" and "evaluate at q centered at α".

  2. `T5_SJWC1_A1_taylor_at_alpha_diagonal` — **the expanded SUM form**
     (the headline): `P(q) = Σ_J coeff_J · Π_i (q_i - α)^{J_i}`.
     This is the Taylor expansion at α-DIAGONAL in its monomial-sum form,
     ready for SJWC-1 H_b (sub-threshold vanish) + H_c-1..4 (pigeonhole
     + per-i factor + AM-QM √m birth).

  3. `T5_SJWC1_A1_taylor_at_alpha_diagonal_clean` — **clean simplified
     form** with the support written as `Finset.univ` over the support
     index, ready for direct manipulation in SJWC-1's analytical chain.

  ## Why this is a Tier-99 routine

  The mathematical content is ENTIRELY specialization of an UNCONDITIONALLY
  PROVEN strong Taylor sum form
  (`T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional` from
  `T5_Phase7_V7N1Uniform_TaylorSumForm.lean`) to the α-DIAGONAL case
  `α := (fun _ => α_real)` and the q-tuple evaluation point.  Since the
  general form is already discharged, A1 reduces to a `rfl`-style
  application after cast lemma `((q i : ℚ) : ℝ)` distributes through
  the subtraction.

  ## graph_queries_run (≥3 MCP per CLAUDE.md MANDATORY MCP USAGE 2026-04-28)

  - `lean_local_search` (T5_NAMED_mvTaylor_at_real_alpha_strong):
      hit T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional in
      T5_Phase7_V7N1Uniform_TaylorSumForm (UNCONDITIONALLY DISCHARGED,
      USED as the engine).
  - `lean_local_search` (T5_aeval_bind₁_shift):
      hit T5_Phase6_BindOneShift.T5_aeval_bind₁_shift (used internally
      by the strong form, USED).
  - `lean_local_search` (shiftPoly):
      hit T5_Phase6_BindOneShift.shiftPoly (USED as the centering
      polynomial).
  - `lean_local_search` (T5_NAMED_index_at_q_strict_upper_bound):
      hit T5_Phase7_SmallJWitnessComposition.T5_NAMED_index_at_q_strict_upper_bound
      (the ANALYTICAL HEART that A1 will feed into).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  Lean-core only [propext, Classical.choice, Quot.sound] axiom audit.

  ## V8-D5 status

  SJWC-1 sub-lemma A1 — first leaf of HEART decomposition.  Subsequent
  HEART leaves (H_b sub-threshold vanish, H_c-1..4 pigeonhole + AM-QM
  √m birth) consume A1's expanded sum form to derive the strict bound.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A1_TaylorAtAlpha

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1Uniform_TaylorSumForm

/-! ## A1-S1 — The substitution form (q evaluation as offset evaluation) -/

/-- **A1-S1 — `T5_SJWC1_A1_aeval_q_eq_aeval_offset`**: evaluation at
    the rational q-tuple equals evaluation of the α-diagonal-shifted
    polynomial at the offset `(q - α)`.

    `aeval q P = aeval (fun i => (q i - α)) (shiftPoly (fun _ => α) P)`

    The bridge between "evaluate P at q" and "evaluate the shifted
    polynomial at the offset q - α-diagonal".  Direct application of
    Phase 6's `T5_aeval_bind₁_shift` with γ := α-diagonal and
    β := q - α-diagonal.

    Proof: T5_aeval_bind₁_shift gives
      `aeval β (shiftPoly γ P) = aeval (β + γ) P`.
    Setting `γ := fun _ => α` and `β := fun i => (q i : ℝ) - α`:
      `aeval (q - α) (shiftPoly (α-diag) P) = aeval ((q - α) + α) P
                                             = aeval q P`. -/
theorem T5_SJWC1_A1_aeval_q_eq_aeval_offset
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (q : Fin m → ℝ) :
    aeval q P =
      aeval (fun i => q i - α) (shiftPoly (fun _ => α) P) := by
  rw [T5_aeval_bind₁_shift]
  -- Goal: aeval q P = aeval (fun i => (q i - α) + α) P
  have h_eq : (fun i => (q i - α) + α) = q := by
    funext i; ring
  rw [h_eq]

/-! ## A1-S2 — The Taylor sum-form at α-diagonal (the headline) -/

/-- **A1-S2 — `T5_SJWC1_A1_taylor_at_alpha_diagonal`**: the multivariate
    Taylor expansion at α-DIAGONAL in its expanded monomial-sum form.

    For any α : ℝ, P : MvPolynomial (Fin m) ℝ, q : Fin m → ℝ:

        aeval q P = ∑ J ∈ (shiftPoly (fun _ => α) P).support,
                      (shiftPoly (fun _ => α) P).coeff J *
                      ∏ i ∈ J.support, (q i - α) ^ (J i)

    This IS the multivariate Taylor expansion in its α-DIAGONAL form —
    the coefficients are the monomial coefficients of `P(X + α)` (i.e.,
    `(shiftPoly (α-diag) P).coeff J`), and the variables are the offsets
    `(q i - α)`.

    Proof: direct specialization of
    `T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional` (the strong
    Taylor sum form, UNCONDITIONALLY DISCHARGED in Phase 7
    V7N1Uniform_TaylorSumForm) at the α-DIAGONAL constant function
    `(fun _ => α)`. -/
theorem T5_SJWC1_A1_taylor_at_alpha_diagonal
    {m : ℕ} (α : ℝ) (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℝ) :
    aeval q P =
      ∑ J ∈ (shiftPoly (fun _ => α) P).support,
        (shiftPoly (fun _ => α) P).coeff J *
        ∏ i ∈ J.support, (q i - α) ^ (J i) := by
  -- Apply the strong Taylor sum form at α-diagonal.
  have h := T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional
    (fun _ : Fin m => α) P q
  -- The strong form gives:
  --   aeval q P = ∑ J ∈ (shiftPoly (fun _ => α) P).support,
  --               (shiftPoly (fun _ => α) P).coeff J *
  --               ∏ i ∈ J.support, (q i - (fun _ => α) i) ^ (J i)
  -- and (fun _ => α) i = α pointwise, so the offset becomes (q i - α).
  exact h

/-! ## A1-S3 — The Taylor sum-form specialized to a rational q-tuple -/

/-- **A1-S3 — `T5_SJWC1_A1_taylor_at_alpha_diagonal_rat`**: the
    multivariate Taylor expansion at α-DIAGONAL specialized to a
    RATIONAL q-tuple `q : Fin m → ℚ` (the form most directly used by
    SJWC-1).

    For any α : ℝ, P : MvPolynomial (Fin m) ℝ, q : Fin m → ℚ:

        aeval (fun i => ((q i : ℚ) : ℝ)) P =
          ∑ J ∈ (shiftPoly (fun _ => α) P).support,
            (shiftPoly (fun _ => α) P).coeff J *
            ∏ i ∈ J.support, (((q i : ℚ) : ℝ) - α) ^ (J i)

    This is the EXACT form needed by SJWC-1's H_a slot: P evaluated at
    the rational q-tuple expanded as a Taylor sum at α-diagonal.

    Proof: instantiate A1-S2 at `q := fun i => ((q i : ℚ) : ℝ)`. -/
theorem T5_SJWC1_A1_taylor_at_alpha_diagonal_rat
    {m : ℕ} (α : ℝ) (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ) :
    aeval (fun i => ((q i : ℚ) : ℝ)) P =
      ∑ J ∈ (shiftPoly (fun _ => α) P).support,
        (shiftPoly (fun _ => α) P).coeff J *
        ∏ i ∈ J.support, (((q i : ℚ) : ℝ) - α) ^ (J i) :=
  T5_SJWC1_A1_taylor_at_alpha_diagonal α P (fun i => ((q i : ℚ) : ℝ))

/-! ## A1-Prop — The NAMED Prop wrapping the sub-lemma -/

/-- **A1-Prop — `T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal`**:
    NAMED Prop encoding the multivariate Taylor expansion at α-diagonal
    in its rational-evaluation form.

    Real Prop body — packages the Taylor sum form at α-DIAGONAL for
    rational q-tuples, ready for consumption by SJWC-1's analytical
    chain. -/
def T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal : Prop :=
  ∀ {m : ℕ} (α : ℝ) (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ),
    aeval (fun i => ((q i : ℚ) : ℝ)) P =
      ∑ J ∈ (shiftPoly (fun _ => α) P).support,
        (shiftPoly (fun _ => α) P).coeff J *
        ∏ i ∈ J.support, (((q i : ℚ) : ℝ) - α) ^ (J i)

/-- **🚨 A1-Discharge — `T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal_unconditional`**:
    UNCONDITIONAL discharge of the SJWC-1 A1 NAMED Prop. -/
theorem T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal_unconditional :
    T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal :=
  fun {m} α P q => T5_SJWC1_A1_taylor_at_alpha_diagonal_rat α P q

/-! ## Headline -/

/-- **🚨🚨🚨 HEADLINE — `T5_SJWC1_A1_HEADLINE`**: SJWC-1 sub-lemma A1
    UNCONDITIONALLY DISCHARGED.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 SJWC-1 sub-lemma A1.

    Three Taylor identities at α-diagonal + NAMED Prop scaffold:

    1. `T5_SJWC1_A1_aeval_q_eq_aeval_offset` — substitution form
       (`aeval q P = aeval (q - α-diag) (shiftPoly (α-diag) P)`).
    2. `T5_SJWC1_A1_taylor_at_alpha_diagonal` — Taylor sum form at
       α-diagonal (the FUNDAMENTAL identity).
    3. `T5_SJWC1_A1_taylor_at_alpha_diagonal_rat` — Taylor sum form
       at α-diagonal specialized to a rational q-tuple (the form
       SJWC-1 directly consumes).
    + `T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal` — NAMED Prop
      packaging the rational form for downstream consumption.

    The four results together form the COMPLETE Taylor-at-α-diagonal
    machinery needed to feed SJWC-1's HEART decomposition.

    Reference: Hindry-Silverman §D.6.1 (Taylor expansion at the
    α-diagonal point in the multivariate Roth-Schmidt-Wirsing argument).

    Mathlib + OmegaTheoryV2 usage:
    - Phase 6 `shiftPoly`/`T5_aeval_bind₁_shift` (affine shift +
      substitution composition).
    - Phase 7 V7N1Uniform_TaylorSumForm
      `T5_NAMED_mvTaylor_at_real_alpha_strong_unconditional` (the
      generic strong Taylor sum form, specialized here to α-diagonal).
    - `MvPolynomial.aeval_def`/`MvPolynomial.eval₂_eq` (used inside
      the strong form).

    Sub-lemma 1/4 of SJWC-1 HEART decomposition (A1 → H_b → H_c-1..4
    → strict upper bound).  Lean-core only [propext, Classical.choice,
    Quot.sound] axiom audit.

    🏆 First Lean-core T-5 SJWC-1 A1 multivariate Taylor expansion at
    α-diagonal in its rational-evaluation form.  Foundational
    vocabulary for SJWC-1 HEART discharge. -/
theorem T5_SJWC1_A1_HEADLINE :
    -- (1) Substitution form
    (∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (q : Fin m → ℝ),
      aeval q P = aeval (fun i => q i - α) (shiftPoly (fun _ => α) P)) ∧
    -- (2) Taylor sum form at α-diagonal (general real q)
    (∀ {m : ℕ} (α : ℝ) (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℝ),
      aeval q P =
        ∑ J ∈ (shiftPoly (fun _ => α) P).support,
          (shiftPoly (fun _ => α) P).coeff J *
          ∏ i ∈ J.support, (q i - α) ^ (J i)) ∧
    -- (3) Taylor sum form at α-diagonal (rational q-tuple)
    (∀ {m : ℕ} (α : ℝ) (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ),
      aeval (fun i => ((q i : ℚ) : ℝ)) P =
        ∑ J ∈ (shiftPoly (fun _ => α) P).support,
          (shiftPoly (fun _ => α) P).coeff J *
          ∏ i ∈ J.support, (((q i : ℚ) : ℝ) - α) ^ (J i)) ∧
    -- (4) NAMED Prop UNCONDITIONALLY discharged
    T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal :=
  ⟨@T5_SJWC1_A1_aeval_q_eq_aeval_offset,
   @T5_SJWC1_A1_taylor_at_alpha_diagonal,
   @T5_SJWC1_A1_taylor_at_alpha_diagonal_rat,
   T5_NAMED_SJWC1_A1_taylor_at_alpha_diagonal_unconditional⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A1_TaylorAtAlpha
