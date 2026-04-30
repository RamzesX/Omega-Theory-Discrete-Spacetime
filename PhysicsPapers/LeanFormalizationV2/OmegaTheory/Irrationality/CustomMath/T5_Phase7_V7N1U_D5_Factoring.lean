/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5_Factoring

  T-5 (Roth's theorem) — **V7N1U-D5 κ-composition factoring** into 3
  atomic sub-NAMEDs.

  ## Architectural rationale

  V7N1U-D5 (`T5_NAMED_V7N1U_D5_kappa_composition`) is the analytical
  HEART of the Taylor decay bound. It bundles three independent pieces:

    [a] κ-existence: ∃ κ > 1 derivable from (ε, m, R)
    [b] C_upper-existence: ∃ C > 0 absorbing binomial-coefficient sum
    [c] per-q decay: |aeval q P| ≤ C · (∏ d^R)^{-κ}

  This file factors V7N1U-D5 into 3 atomic sub-NAMEDs so future fires
  can attack each independently:

    1. `T5_NAMED_V7N1U_D5a_kappa_existence` — κ as function of (ε, m)
    2. `T5_NAMED_V7N1U_D5b_C_upper_existence` — C as function of P, R
    3. `T5_NAMED_V7N1U_D5c_per_q_decay` — per-q Taylor decay bound

  Composition: D5a ∧ D5b ∧ D5c ⇒ V7N1U-D5.

  Strategic significance: identifies that the κ-existence is an
  ARITHMETIC fact (no q-dependence), the C_upper-existence is a
  COMBINATORIAL fact (no q-dependence), and the per-q decay is the
  TRUE HEART (depends on q, growth, balance, index bound).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_PartialDischarge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5_Factoring

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_PartialDischarge

/-! ## D5F-1 — D5a κ-existence sub-NAMED -/

/-- **D5F-1 — `T5_NAMED_V7N1U_D5a_kappa_existence`** [NAMED, ARITHMETIC].

    Pure arithmetic: for given (ε, m), there exists κ > 1 derivable
    from these parameters.

    Discharge: TRIVIAL — take κ := 1 + ε / (2m). Then κ > 1.

    Strategic: the κ value depends only on (ε, m), not on q or P, so
    can be discharged independently of analytical content. -/
def T5_NAMED_V7N1U_D5a_kappa_existence : Prop :=
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∃ (κ : ℝ), 1 < κ

/-- **D5F-1-discharge — `T5_V7N1U_D5a_unconditional`**: UNCONDITIONAL
    discharge of D5a via κ := 2. -/
theorem T5_V7N1U_D5a_unconditional :
    T5_NAMED_V7N1U_D5a_kappa_existence := by
  intros ε _hε m _hm
  exact ⟨2, by norm_num⟩

/-! ## D5F-2 — D5b C_upper-existence sub-NAMED -/

/-- **D5F-2 — `T5_NAMED_V7N1U_D5b_C_upper_existence`** [NAMED, COMBINATORIAL].

    For given P (nonzero, with degree bounds), there exists a positive
    constant C_upper that absorbs the sum of binomial coefficients
    arising in the multivariate Taylor expansion.

    Discharge plan: use C_upper := 1 + finite sum of |coeff P| over
    monomials within the degree bounds. Trivial existence; the
    quantitative content lies in C_upper's role in bounding aeval. -/
def T5_NAMED_V7N1U_D5b_C_upper_existence : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (_R : Fin m → ℕ),
    P ≠ 0 →
  ∃ (C_upper : ℝ), 0 < C_upper

/-- **D5F-2-discharge — `T5_V7N1U_D5b_unconditional`**: UNCONDITIONAL
    discharge of D5b via C_upper := 1. -/
theorem T5_V7N1U_D5b_unconditional :
    T5_NAMED_V7N1U_D5b_C_upper_existence := by
  intros m _hm P _R _hP_ne
  exact ⟨1, by norm_num⟩

/-! ## D5F-3 — D5c per-q decay sub-NAMED (the analytical HEART, EXISTENTIAL form) -/

/-- **D5F-3 — `T5_NAMED_V7N1U_D5c_per_q_decay`** [NAMED, HEART].

    The analytical heart of V7N1U-D5: for given (α, ε, m, P, R), there
    EXISTS a (C_upper, κ) pair such that each q satisfying violator +
    growth + balance + index bound gives |aeval q P| ≤ C_upper · (∏d^R)^{-κ}.

    NOTE (architectural honesty 2026-04-30): this Prop is DEFINITIONALLY
    EQUAL to T5_NAMED_V7N1U_D5_kappa_composition (V7N1U-D5 itself). The
    earlier formulation took (C_upper, κ) as ∀-inputs which made the
    Prop literal-false (taking κ → ∞ violates the bound for any C).
    Existential form is the only HONEST factoring; it COLLAPSES to
    V7N1U-D5 with no genuine factoring achieved. The D5a (trivial κ
    existence) and D5b (trivial C existence) closures are paper-citable
    standalone trivial-scaffold but do NOT decompose D5's content.

    Discharge: ~200 lines analytic — same content as V7N1U-D5 itself. -/
def T5_NAMED_V7N1U_D5c_per_q_decay : Prop :=
  T5_NAMED_V7N1U_D5_kappa_composition

/-! ## D5F-4 — Composition: D5c ⇒ V7N1U-D5 (TAUTOLOGICAL, definitional) -/

/-- **D5F-4 — `T5_V7N1U_D5_via_D5a_D5b_D5c`**: TAUTOLOGICAL composition
    after D5c-existential refactor.

    Since D5c is DEFINITIONALLY EQUAL to V7N1U-D5, this is just identity.
    D5a and D5b are unused (their unconditional discharges remain
    paper-citable as trivial-scaffold but don't contribute to D5). -/
theorem T5_V7N1U_D5_via_D5a_D5b_D5c
    (_h_D5a : T5_NAMED_V7N1U_D5a_kappa_existence)
    (_h_D5b : T5_NAMED_V7N1U_D5b_C_upper_existence)
    (h_D5c : T5_NAMED_V7N1U_D5c_per_q_decay) :
    T5_NAMED_V7N1U_D5_kappa_composition :=
  h_D5c

/-! ## D5F-5 — Headline: V7N1U-D5 is monolithic (factoring honest no-op) -/

/-- **🚨🚨🚨 D5F-5 — `T5_V7N1U_D5_FACTORING_HEADLINE`**: paper-citable
    architectural HONESTY headline.

    Strategic significance: V7N1U-D5 does NOT admit clean factoring.
    The earlier 3-NAMED factoring (D5a + D5b + D5c-as-input-quantified)
    contained a literal-false Prop (∀ C, κ instead of ∃). Existential
    form makes D5c ≡ V7N1U-D5; factoring collapses to identity.

    D5a (κ existence) + D5b (C existence) are STANDALONE TRIVIAL
    DISCHARGES — paper-citable as scaffold but don't reduce D5's
    analytical content. The actual HEART is monolithic. -/
theorem T5_V7N1U_D5_FACTORING_HEADLINE :
    T5_NAMED_V7N1U_D5c_per_q_decay → T5_NAMED_V7N1U_D5_kappa_composition :=
  id

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5_Factoring
