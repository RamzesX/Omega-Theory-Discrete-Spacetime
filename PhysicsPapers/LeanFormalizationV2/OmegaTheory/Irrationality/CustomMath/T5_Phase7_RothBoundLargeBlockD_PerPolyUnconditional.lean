/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyUnconditional

  T-5 (Roth's theorem) — **V7-N2 PER-POLY UNCONDITIONAL APPLICATION
  + Yoneda bridges**.

  Direct unconditional applications of `T5_NAMED_BlockD_integer_lower_bound`
  (now a THEOREM via DCFD-4) for any polynomial p, removing the
  per-polynomial clearance hypothesis from PPL-2 and PPL-3.

  Plus Yoneda-style bridge theorems documenting V7-N2 closure.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — direct applications, no sorry.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyLowerBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyUnconditional

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyLowerBound

/-! ## DPU-1 — Per-polynomial V7-N2 lower bound UNCONDITIONALLY -/

/-- **DPU-1 — `T5_BlockD_lower_bound_per_p_unconditional`**: V7-N2
    multivariate integer non-vanishing lower bound holds for ANY
    p : MvPolynomial (Fin m) ℤ, without per-polynomial clearance
    hypothesis.

    Direct application of the now-unconditional V7-N2
    `T5_NAMED_BlockD_integer_lower_bound_unconditional` to a
    specific p + q. -/
theorem T5_BlockD_lower_bound_per_p_unconditional
    {m : ℕ} (hm : 1 ≤ m) (p : MvPolynomial (Fin m) ℤ) (q : Fin m → ℚ)
    (h_eval_ne : aeval (fun i => ((q i : ℚ) : ℝ))
      ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0) :
    1 / (∏ i, ((q i).den : ℝ) ^
      (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) ≤
      |aeval (fun i => ((q i : ℚ) : ℝ))
        ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ)| :=
  T5_NAMED_BlockD_integer_lower_bound_unconditional hm p q h_eval_ne

/-! ## DPU-2 — Yoneda bridge: V7-N2 unconditional applies to X i case -/

/-- **DPU-2 — `T5_BlockD_X_lower_bound_unconditional`**: V7-N2
    conclusion for `p = X i` discharged WITHOUT the clearance hypothesis,
    as a direct corollary of V7-N2 unconditional.

    This SUPERSEDES PPL-2 (which used DCX-2 clearance witness).
    Now the V7-N2 conclusion for X i follows from the V7-N2 NAMED
    Prop being a theorem. -/
theorem T5_BlockD_X_lower_bound_unconditional
    {m : ℕ} (hm : 1 ≤ m) (i : Fin m) (q : Fin m → ℚ)
    (h_eval_ne : aeval (fun j => ((q j : ℚ) : ℝ))
      (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
        (algebraMap ℤ ℝ))) ≠ 0) :
    1 / (∏ j, ((q j).den : ℝ) ^
      (MvPolynomial.degreeOf j
        ((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)) : ℕ)) ≤
      |aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)))| :=
  T5_BlockD_lower_bound_per_p_unconditional hm (MvPolynomial.X i) q h_eval_ne

/-! ## DPU-3 — Yoneda bridge: V7-N2 unconditional applies to C c case -/

/-- **DPU-3 — `T5_BlockD_C_lower_bound_unconditional`**: V7-N2 for
    `p = C c` unconditional via V7-N2 theorem.  Supersedes PPL-3. -/
theorem T5_BlockD_C_lower_bound_unconditional
    {m : ℕ} (hm : 1 ≤ m) (c : ℤ) (q : Fin m → ℚ)
    (h_eval_ne : aeval (fun j => ((q j : ℚ) : ℝ))
      (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
        (algebraMap ℤ ℝ))) ≠ 0) :
    1 / (∏ j, ((q j).den : ℝ) ^
      (MvPolynomial.degreeOf j
        ((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)) : ℕ)) ≤
      |aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)))| :=
  T5_BlockD_lower_bound_per_p_unconditional hm (MvPolynomial.C c) q h_eval_ne

/-! ## DPU-4 — Yoneda bridge: V7-N2 unconditional applies to monomial case -/

/-- **DPU-4 — `T5_BlockD_monomial_lower_bound_unconditional`**: V7-N2
    for `p = monomial d c` unconditional via V7-N2 theorem.

    Generalizes DPU-2 (X i case = monomial (single i 1) 1) and DPU-3
    (C c case = monomial 0 c). -/
theorem T5_BlockD_monomial_lower_bound_unconditional
    {m : ℕ} (hm : 1 ≤ m) (d : Fin m →₀ ℕ) (c : ℤ) (q : Fin m → ℚ)
    (h_eval_ne : aeval (fun j => ((q j : ℚ) : ℝ))
      (((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
        (algebraMap ℤ ℝ))) ≠ 0) :
    1 / (∏ j, ((q j).den : ℝ) ^
      (MvPolynomial.degreeOf j
        ((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)) : ℕ)) ≤
      |aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)))| :=
  T5_BlockD_lower_bound_per_p_unconditional hm (MvPolynomial.monomial d c) q
    h_eval_ne

/-! ## DPU-5 — Headline: V7-N2 unconditional bundle -/

/-- **🚨🚨🚨 DPU-5 — `T5_DPU_BLOCK_D_V7N2_UNCONDITIONAL_BUNDLE`**:
    paper-citable bundle of V7-N2 unconditional applications.

    Demonstrates that V7-N2 conclusion (multivariate integer non-vanishing
    lower bound) is now provable for ANY polynomial p, including
    specific monomial cases (X i, C c, general monomial d c).

    This bundle SOLIDIFIES the V7-N2 closure achievement: not just the
    universal NAMED Prop is unconditional, but ALL the per-polynomial
    consequences follow without any per-clearance hypothesis. -/
theorem T5_DPU_BLOCK_D_V7N2_UNCONDITIONAL_BUNDLE :
    -- (a) DPU-1: per-p unconditional V7-N2
    (∀ {m : ℕ}, 1 ≤ m → ∀ (p : MvPolynomial (Fin m) ℤ) (q : Fin m → ℚ),
      aeval (fun i => ((q i : ℚ) : ℝ))
        ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0 →
      1 / (∏ i, ((q i).den : ℝ) ^
        (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) ≤
        |aeval (fun i => ((q i : ℚ) : ℝ))
          ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ)|) ∧
    -- (b) DPU-2: X i case unconditional
    (∀ {m : ℕ}, 1 ≤ m → ∀ (i : Fin m) (q : Fin m → ℚ),
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ))) ≠ 0 →
      1 / (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          ((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)) : ℕ)) ≤
        |aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)))|) ∧
    -- (c) DPU-3: C c case unconditional
    (∀ {m : ℕ}, 1 ≤ m → ∀ (c : ℤ) (q : Fin m → ℚ),
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ))) ≠ 0 →
      1 / (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          ((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)) : ℕ)) ≤
        |aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)))|) ∧
    -- (d) DPU-4: monomial d c case unconditional
    (∀ {m : ℕ}, 1 ≤ m → ∀ (d : Fin m →₀ ℕ) (c : ℤ) (q : Fin m → ℚ),
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ))) ≠ 0 →
      1 / (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          ((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)) : ℕ)) ≤
        |aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)))|) :=
  ⟨fun {m} hm p q h => T5_BlockD_lower_bound_per_p_unconditional hm p q h,
   fun {m} hm i q h => T5_BlockD_X_lower_bound_unconditional hm i q h,
   fun {m} hm c q h => T5_BlockD_C_lower_bound_unconditional hm c q h,
   fun {m} hm d c q h => T5_BlockD_monomial_lower_bound_unconditional hm d c q h⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyUnconditional
