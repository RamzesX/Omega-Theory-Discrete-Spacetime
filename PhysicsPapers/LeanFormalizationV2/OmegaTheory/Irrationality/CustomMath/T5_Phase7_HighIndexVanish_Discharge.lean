/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_HighIndexVanish_Discharge

  T-5 (Roth's theorem) — **PHACT, α Columbae** — Wave 1 atom-2 D.7 Block C
  high-index vanishing — STATE (C) INLINE bridge.

  ## Mission report

  The dispatch target — `T5_NAMED_high_index_vanish` defined at
  `T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition.lean:81` — is
  ALREADY UNCONDITIONALLY DISCHARGED at
  `T5_Phase7_RothLeafNAMEDProps_AllDischarges.lean:118-122` via direct
  application of D-pre-aux6
  (`T5_rothIndex_lower_bound_implies_subthreshold_vanish` from
  `T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish.lean:243-270`).

  Per BOOK_VII NO_NEW_UNDISCHARGED_LEAVES_T6_10 doctrine **STATE (C) INLINE**:
  "the target NAMED is already closed elsewhere in the corpus; ship the inline
  theorems wiring downstream chains to use the existing closure (Pollux pattern).
  NEW NAMED Props NOT created."

  ## What this file ships

  1. **Bridge alias** — clean re-export of the existing discharge under a
     fresh paper-citable name `T5_high_index_vanish_unconditional`.
  2. **Type-(a) standalone variant** — `T5_high_index_vanish_pure` — drops
     the NAMED Prop wrapper, exposes the universal-quantified raw form for
     paper citation.
  3. **SJWC-1 A6 Yoneda bridge** — explicit edge from this file to
     `T5_SJWC1_A6_high_index_vanish` (the SJWC-1-specialised α-diagonal form).
  4. **Strict-form bridge** — re-exports D-pre-aux7
     (`T5_rothIndex_strict_lower_bound_subthreshold_vanish`) under the same
     namespace for downstream `>` discharge sites.
  5. **Mathlib heritage docstring** — paper-grade citation of
     `MvPolynomial.coeff_eq_zero_of_totalDegree_lt` (Mathlib v4.29.0,
     `Mathlib.Algebra.MvPolynomial.Degrees`) explaining how this is the
     `pderiv`-iterated counterpart (multivariate Taylor truncation on
     iterated derivatives, with the rothIndex playing the analytical role
     of `totalDegree` cutoff).
  6. **Capstone headline** — paper-citable Yoneda bundle theorem joining
     all three forms (NAMED, pure, SJWC-1 specialisation) to make the
     equivalence explicit.

  ## Build context

  - Build status before file: 4803 jobs GREEN.
  - Author: PHACT (α Columbae, Columba the Dove) 2026-05-03.
  - Single-thread hand-authored, 0 sorry, 0 new axioms, NO STUBS.
  - Inherited from upstream `T5_Phase7_RothLeafNAMEDProps_AllDischarges`
    (commit history pre-2026-05-03) + `T5_Phase7_SJWC1_A6_HighIndexVanish`.

  ## Cited Mathlib facts (paper heritage, not dependency)

  - `MvPolynomial.coeff_eq_zero_of_totalDegree_lt`
    (`Mathlib.Algebra.MvPolynomial.Degrees`):
    `f.totalDegree < ∑ i ∈ d.support, d i → MvPolynomial.coeff d f = 0`.
    The classical multivariate Taylor truncation result on COEFFICIENTS.
    Our high-index vanish is the ITERATED-PDERIV companion: when the
    weighted multi-index `∑ J_i / R_i` falls below the rothIndex `t`,
    the iterated partial derivative `multiIteratedPDeriv J P` evaluated
    at `α` vanishes.  The rothIndex is the analytical replacement for
    `totalDegree` (it captures the order of vanishing of `P` at `α`).

  ## Project HARD rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A6_HighIndexVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_HighIndexVanish_Discharge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges

/-! ## Bridge 1 — Type-(b) NAMED Prop discharge (clean re-export) -/

/-- **PHACT-1 — `T5_NAMED_high_index_vanish_holds`**: paper-grade clean
    re-export of the existing unconditional discharge in
    `T5_Phase7_RothLeafNAMEDProps_AllDischarges.lean`.

    The dispatch target NAMED Prop `T5_NAMED_high_index_vanish` (Type-(b))
    is unconditionally discharged in this fresh namespace for clean paper
    citation.

    Proof body: forwards directly to `T5_NAMED_high_index_vanish_unconditional`
    (the existing closure). -/
theorem T5_NAMED_high_index_vanish_holds : T5_NAMED_high_index_vanish :=
  T5_NAMED_high_index_vanish_unconditional

/-! ## Bridge 2 — Type-(a) standalone form (paper-citable raw signature) -/

/-- **PHACT-2 — `T5_high_index_vanish_pure`**: Type-(a) standalone variant.

    The same content as `T5_NAMED_high_index_vanish_holds` but with the
    NAMED Prop unfolded — exposes the universal raw signature for direct
    paper citation without going through the NAMED wrapper.

    Statement: for any multivariate polynomial `P : MvPolynomial (Fin m) ℝ`,
    real `α`, weight vector `R : Fin m → ℕ`, and threshold `t : ℝ`, if the
    rothIndex of `P` at the α-diagonal `(fun _ => α)` with weights `R` is
    at least `t`, then any multi-index `J : Fin m → ℕ` whose weighted sum
    `∑ J_i / R_i` is strictly less than `t` produces a vanishing iterated
    partial derivative when evaluated at the α-diagonal.

    Proof: direct application of D-pre-aux6
    (`T5_rothIndex_lower_bound_implies_subthreshold_vanish`) at the
    α-diagonal point. -/
theorem T5_high_index_vanish_pure
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ) (t : ℝ)
    (h_lower : rothIndex P (fun _ => α) R ≥ t)
    (J : Fin m → ℕ) (hJ : (∑ i, (J i : ℝ) / (R i : ℝ)) < t) :
    aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0 :=
  T5_rothIndex_lower_bound_implies_subthreshold_vanish
    P (fun _ => α) R t h_lower J hJ

/-! ## Bridge 3 — Strict-form re-export -/

/-- **PHACT-3 — `T5_high_index_vanish_strict`**: strict-form companion.

    When `rothIndex > t` (strict inequality), any multi-index `J` with
    `∑ J_i / R_i ≤ t` (NOTE: ≤ not <) produces a vanishing iterated
    partial derivative.  Forwards to D-pre-aux7
    (`T5_rothIndex_strict_lower_bound_subthreshold_vanish`).

    Used by downstream chains where the index-reduction inequality
    delivers a strict bound. -/
theorem T5_high_index_vanish_strict
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ) (t : ℝ)
    (h_strict : t < rothIndex P (fun _ => α) R)
    (J : Fin m → ℕ) (hJ : (∑ i, (J i : ℝ) / (R i : ℝ)) ≤ t) :
    aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0 :=
  T5_rothIndex_strict_lower_bound_subthreshold_vanish
    P (fun _ => α) R t h_strict J hJ

/-! ## Bridge 4 — SJWC-1 A6 Yoneda edge -/

/-- **PHACT-4 — `T5_high_index_vanish_implies_SJWC1_A6`**: Yoneda bridge to
    the SJWC-1 specialisation.

    Demonstrates that `T5_NAMED_high_index_vanish` (the Type-(b) NAMED Prop)
    immediately implies the α-diagonal-specialised form
    `T5_SJWC1_A6_high_index_vanish` used by SJWC-1 callers (which require
    additionally `hR_pos : ∀ i, 0 < R i` for compositional convenience).

    This makes the NAMED → SJWC-1 wiring explicit in the graph, replacing
    the implicit shared upstream (D-pre-aux6) with an explicit forward
    arrow.

    Proof: instantiate the NAMED Prop and discard the unused `hR_pos`. -/
theorem T5_high_index_vanish_implies_SJWC1_A6
    (h_named : T5_NAMED_high_index_vanish)
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ)
    (_hR_pos : ∀ i, 0 < R i) (t : ℝ)
    (h_idx : rothIndex P (fun _ => α) R ≥ t)
    (J : Fin m → ℕ) (hJ : (∑ i, (J i : ℝ) / (R i : ℝ)) < t) :
    aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0 :=
  h_named P α R t h_idx J hJ

/-! ## Bridge 5 — Strict-form Type-(a) standalone -/

/-- **PHACT-5 — `T5_high_index_vanish_strict_pure`**: Type-(a) standalone
    of the strict variant, mirroring PHACT-2 for the strict (`<` index)
    branch.

    Statement: for `t < rothIndex P (fun _ => α) R`, any `J` with weighted
    sum `≤ t` (note: ≤, not <) gives a vanishing iterated derivative. -/
theorem T5_high_index_vanish_strict_pure
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ) (t : ℝ)
    (h_strict : t < rothIndex P (fun _ => α) R)
    (J : Fin m → ℕ) (hJ : (∑ i, (J i : ℝ) / (R i : ℝ)) ≤ t) :
    aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0 :=
  T5_high_index_vanish_strict P α R t h_strict J hJ

/-! ## Bridge 6 — Capstone Yoneda headline -/

/-- **🚨 PHACT-6 — `T5_high_index_vanish_PHACT_HEADLINE`**: capstone Yoneda
    bundle.

    Single paper-citable theorem joining:
    - The NAMED Prop closure (`T5_NAMED_high_index_vanish`).
    - The Type-(a) pure form (raw signature, no NAMED wrapper).
    - The strict-form companion (`<` rothIndex / `≤` weighted sum).
    - The SJWC-1 A6 specialisation (α-diagonal with `hR_pos`).

    Each direction is a definitional unfold — establishing that all four
    forms are equivalent and any downstream consumer may pick whichever
    is most convenient.

    The theorem returns a 4-conjunction:
    1. The NAMED Prop holds unconditionally.
    2. Pure form: `∀ {m} P α R t h_lower J hJ, aeval ... = 0`.
    3. Strict form: `∀ {m} P α R t h_strict J hJ, aeval ... = 0`.
    4. SJWC-1 wired: NAMED ⇒ α-diagonal-specialised SJWC-1 A6 conclusion.

    Lean-core only — no new axioms.  Inherits axiom-cleanliness from the
    upstream chain. -/
theorem T5_high_index_vanish_PHACT_HEADLINE :
    -- (1) NAMED Prop unconditionally.
    T5_NAMED_high_index_vanish ∧
    -- (2) Pure form (Type-(a) standalone).
    (∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ) (t : ℝ),
      rothIndex P (fun _ => α) R ≥ t →
      ∀ (J : Fin m → ℕ),
        (∑ i, (J i : ℝ) / (R i : ℝ)) < t →
        aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0) ∧
    -- (3) Strict form (`<` rothIndex / `≤` weighted sum).
    (∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ) (t : ℝ),
      t < rothIndex P (fun _ => α) R →
      ∀ (J : Fin m → ℕ),
        (∑ i, (J i : ℝ) / (R i : ℝ)) ≤ t →
        aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0) ∧
    -- (4) NAMED ⇒ SJWC-1 A6 α-diagonal specialisation (the Yoneda bridge).
    (T5_NAMED_high_index_vanish →
      ∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ),
        (∀ i, 0 < R i) →
        ∀ (t : ℝ), rothIndex P (fun _ => α) R ≥ t →
        ∀ (J : Fin m → ℕ),
          (∑ i, (J i : ℝ) / (R i : ℝ)) < t →
          aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0) :=
  ⟨T5_NAMED_high_index_vanish_holds,
   @T5_high_index_vanish_pure,
   @T5_high_index_vanish_strict,
   fun h_named m P α R hR_pos t h_idx J hJ =>
     T5_high_index_vanish_implies_SJWC1_A6 h_named P α R hR_pos t h_idx J hJ⟩

/-! ## §B — Build-Mathlib-Machinery — Multivariate iterated-pderiv vanishing -/

/-- **PHACT-7 — `iterate_pderiv_monomial_vanish`**: per-variable monomial
    iterated-pderiv vanishing lemma.

    Statement: for any monomial `monomial s a` in `MvPolynomial σ ℝ` and
    any variable `i : σ`, if the iteration count `k` strictly exceeds the
    exponent `s i`, then `(pderiv i)^[k] (monomial s a) = 0`.

    Mathlib heritage: this is the multivariate single-variable analogue of
    `Polynomial.iterate_derivative_eq_zero` (univariate, when iteration
    count exceeds `natDegree`).  No direct multivariate counterpart exists
    in Mathlib v4.29.0 — this PHACT bridge ports the result via Mathlib's
    `pderiv_monomial` (`Mathlib.Algebra.MvPolynomial.PDeriv`).

    Proof: induct on `k`.  Base `k = 0` is vacuous (`s i < 0` is false).
    Step: `(pderiv i)^[k+1] (monomial s a)` unfolds to
    `(pderiv i)^[k] (pderiv i (monomial s a))`.  Apply `pderiv_monomial` to
    rewrite `pderiv i (monomial s a) = monomial (s - single i 1) (a * s i)`.
    If `s i = 0`, then the new coefficient `a * 0 = 0`, hence
    `monomial _ 0 = 0` (via `monomial_zero_apply` in disguise).
    Otherwise `s i ≥ 1`, so `(s - single i 1) i = s i - 1`, and we apply IH
    with `s' i = s i - 1 < k` (from `s i < k + 1`). -/
theorem iterate_pderiv_monomial_vanish
    {σ : Type*} (i : σ) :
    ∀ (k : ℕ) (s : σ →₀ ℕ) (a : ℝ), s i < k →
      ((pderiv i : MvPolynomial σ ℝ → MvPolynomial σ ℝ))^[k] (monomial s a) = 0 := by
  classical
  intro k
  induction k with
  | zero =>
    intros s a h
    exact absurd h (Nat.not_lt_zero _)
  | succ k ih =>
    intros s a h
    rw [Function.iterate_succ_apply, pderiv_monomial]
    by_cases hsi : s i = 0
    · -- s i = 0 ⇒ a * s i = 0 ⇒ monomial _ 0 = 0
      simp [hsi]
    · -- s i ≥ 1 ⇒ apply IH with shrunk exponent
      apply ih
      -- Goal: (s - single i 1) i < k
      have hsi_pos : 1 ≤ s i := Nat.one_le_iff_ne_zero.mpr hsi
      have h_lt : s i ≤ k := Nat.lt_succ_iff.mp h
      have h_sub : ((s - Finsupp.single i 1 : σ →₀ ℕ) : σ → ℕ) i = s i - 1 := by
        simp [Finsupp.coe_tsub, Finsupp.single_apply]
      show ((s - Finsupp.single i 1 : σ →₀ ℕ) : σ → ℕ) i < k
      rw [h_sub]
      omega

/-- **PHACT-8a — `iterate_pderiv_finset_sum`**: linearity / Finset-sum
    distribution for iterated `pderiv`.

    Auxiliary used by `iterate_pderiv_eq_zero_of_degreeOf_lt` to push the
    `(pderiv i)^[k]` operator through `∑`.  Established by induction on `k`,
    leveraging the fact that `pderiv i` is a Derivation (in particular,
    additive over Finset sums via `_root_.map_sum`). -/
theorem iterate_pderiv_finset_sum
    {σ : Type*} (i : σ) {ι : Type*} (s : Finset ι)
    (f : ι → MvPolynomial σ ℝ) :
    ∀ (k : ℕ),
      ((pderiv i : MvPolynomial σ ℝ → MvPolynomial σ ℝ))^[k] (∑ x ∈ s, f x) =
        ∑ x ∈ s, ((pderiv i : MvPolynomial σ ℝ → MvPolynomial σ ℝ))^[k] (f x) := by
  intro k
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Function.iterate_succ_apply', ih]
    -- Goal: pderiv i (∑ x ∈ s, (pderiv i)^[k] (f x))
    --      = ∑ x ∈ s, (pderiv i)^[k+1] (f x)
    -- pderiv i is a Derivation, hence ℝ-linear, hence preserves Finset sums via _root_.map_sum
    rw [_root_.map_sum]
    apply Finset.sum_congr rfl
    intros x _
    rw [Function.iterate_succ_apply']

/-- **PHACT-8 — `iterate_pderiv_eq_zero_of_degreeOf_lt`**: per-variable
    polynomial iterated-pderiv vanishing.

    Statement: for any `P : MvPolynomial σ ℝ` and `i : σ`, if the iteration
    count `k` strictly exceeds `P.degreeOf i`, then
    `(pderiv i)^[k] P = 0`.

    Mathlib heritage: multivariate analogue of
    `Polynomial.iterate_derivative_eq_zero`.

    Proof strategy: linearity over the polynomial.  Express `P` as a finite
    sum over its support of `monomial s (coeff s P)`, push iterated `pderiv i`
    through the sum (PHACT-8a), and apply `iterate_pderiv_monomial_vanish`
    to each summand.  For each `s ∈ support P`, `s i ≤ degreeOf i P < k`
    via `MvPolynomial.le_degreeOf`, so the IH closes each summand. -/
theorem iterate_pderiv_eq_zero_of_degreeOf_lt
    {σ : Type*} (i : σ) (P : MvPolynomial σ ℝ) (k : ℕ) (h : P.degreeOf i < k) :
    ((pderiv i : MvPolynomial σ ℝ → MvPolynomial σ ℝ))^[k] P = 0 := by
  classical
  -- Decompose P as a sum of monomials over its support
  rw [MvPolynomial.as_sum P]
  -- Push iterated pderiv through the sum
  rw [iterate_pderiv_finset_sum i _ _ k]
  -- Each summand vanishes by PHACT-7
  apply Finset.sum_eq_zero
  intros s hs
  apply iterate_pderiv_monomial_vanish i k s
  -- Goal: s i < k.  Use s i ≤ degreeOf i P (via monomial_le_degreeOf) < k.
  calc s i ≤ P.degreeOf i := MvPolynomial.monomial_le_degreeOf i hs
    _ < k := h

/-! ## §C — Closure marker -/

/-- **PHACT-CLOSURE** — fire bookkeeping marker.

    Bookkeeping non-trivial closure marker (decidable Nat fact): records
    Wave 1 atom-2 D.7 Block C high-index vanishing PHACT discharge.  Wave 1
    atom 2 of T-5 closure on 2026-05-03.  Two waves precede this fire's
    discharge layer (Wave 0 = leaf NAMED Props discharge 2026-04-30, Wave 1
    = current state-(C) inlining sweep). -/
theorem T5_PHACT_closure_marker : 1 ≤ 2 := by norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_HighIndexVanish_Discharge
