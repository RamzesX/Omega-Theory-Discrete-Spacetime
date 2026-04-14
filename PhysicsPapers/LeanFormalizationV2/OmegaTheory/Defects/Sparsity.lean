/-
  OmegaTheory.Defects.Sparsity

  Quantitative sparsity of defect sites.

  A defect site is a lattice point where the metric defect magnitude
  exceeds a threshold `τ`.  In any finite region `F` of the lattice,
  the number of defect sites is controlled by the L²-energy of the
  defect over `F` via a Markov (a.k.a. Chebyshev) inequality:

      |{p ∈ F : |D(p)| ≥ τ}| · τ²  ≤  Σ_{p ∈ F} |D(p)|²

  Combining this with the uniform amplitude bound `|D(p)| ≤ ε` of a
  `SemiSmoothMetric`, one gets the sparsity-fraction estimate

      |{p ∈ F : |D(p)| ≥ τ}| / |F|  ≤  16 · ε² / τ²

  (the `16` is the number of metric components `Fin 4 × Fin 4`).  If
  `ε` decays exponentially with the computational budget `N` —
  `ε ≤ C · exp(−α·N)` — then so does the sparsity fraction, which is
  the quantitative "defect sparsity" claim of the Omega theory.

  No new axioms.
-/

import OmegaTheory.Defects.DefectTensor
import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Exp

namespace OmegaTheory.Defects

open OmegaTheory.Geometry
open OmegaTheory.Spacetime
open OmegaTheory.Foundations

/-! ## Generic Markov inequality for non-negative finset sums

For any non-negative function `f : α → ℝ`, a threshold `τ > 0`, and a
finite set `F : Finset α`, the number of `a ∈ F` where `f a ≥ τ` is at
most `(F.sum f) / τ`.  We prove the cleanly-rearranged form that
multiplies by `τ`, valid without assuming `τ > 0`. -/

/-- Markov inequality: for a non-negative function over a finset, the
    number of points where `f ≥ τ` times `τ` is bounded by the total
    sum.  The inequality is automatic for `τ < 0` (LHS non-positive,
    RHS non-negative), so no hypothesis on `τ` is needed. -/
theorem finset_markov {α : Type*} (F : Finset α) (f : α → ℝ)
    (hf : ∀ a ∈ F, 0 ≤ f a) (τ : ℝ) :
    ((F.filter (fun a => τ ≤ f a)).card : ℝ) * τ ≤ F.sum f := by
  -- The key inequality: for each a ∈ F.filter (τ ≤ f ·), τ ≤ f a.
  -- So the sum of τ over the filtered set ≤ sum of f over the filtered set ≤ F.sum f.
  have h_filter_sum :
      (F.filter (fun a => τ ≤ f a)).sum (fun _ => τ) ≤
      (F.filter (fun a => τ ≤ f a)).sum f := by
    apply Finset.sum_le_sum
    intro a ha
    exact (Finset.mem_filter.mp ha).2
  have h_filter_le_total :
      (F.filter (fun a => τ ≤ f a)).sum f ≤ F.sum f := by
    apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
    intro a haF _
    exact hf a haF
  have h_sum_const :
      (F.filter (fun a => τ ≤ f a)).sum (fun _ : α => τ) =
      ((F.filter (fun a => τ ≤ f a)).card : ℝ) * τ := by
    rw [Finset.sum_const, nsmul_eq_mul]
  linarith [h_filter_sum, h_filter_le_total, h_sum_const.symm.le]

/-! ## Defect sites over a finite lattice region -/

/-- The set of defect sites in `F` at threshold `τ`:
    points where the defect magnitude squared is at least `τ²`. -/
noncomputable def defectSites (g_actual g_exact : DiscreteMetric)
    (F : Finset LatticePoint) (τ : ℝ) : Finset LatticePoint :=
  F.filter (fun p => τ ^ 2 ≤ defectMagnitudeSq g_actual g_exact p)

/-- **Defect-sparsity Chebyshev inequality.**  The number of defect
    sites times `τ²` is bounded by the total defect L²-energy on `F`. -/
theorem defectSites_chebyshev (g_actual g_exact : DiscreteMetric)
    (F : Finset LatticePoint) (τ : ℝ) :
    ((defectSites g_actual g_exact F τ).card : ℝ) * τ ^ 2 ≤
    F.sum (defectMagnitudeSq g_actual g_exact) := by
  have hf : ∀ p ∈ F, 0 ≤ defectMagnitudeSq g_actual g_exact p := by
    intro p _
    exact defectMagnitudeSq_nonneg _ _ _
  exact finset_markov F (defectMagnitudeSq g_actual g_exact) hf (τ ^ 2)

/-! ## The amplitude bound: `defectMagnitudeSq ≤ ε²`

For a `SemiSmoothMetric`, the `defect_bounded` axiom gives
`defectMagnitude ≤ ε` pointwise.  Squaring yields the analogous bound
on the squared magnitude, and summing over a finite region gives a
total-energy bound of `|F| · ε²`. -/

/-- Squaring the pointwise amplitude bound: `|D(p)|² ≤ ε². -/
theorem defectMagnitudeSq_le_epsilon_sq
    (ssm : SemiSmoothMetric) (p : LatticePoint) :
    defectMagnitudeSq ssm.g ssm.g_exact p ≤ ssm.epsilon ^ 2 := by
  have h_mag : defectMagnitude ssm.g ssm.g_exact p ≤ ssm.epsilon :=
    ssm.defect_bounded p
  have h_nonneg : 0 ≤ defectMagnitude ssm.g ssm.g_exact p :=
    defectMagnitude_nonneg _ _ _
  have h_eq : defectMagnitudeSq ssm.g ssm.g_exact p =
      (defectMagnitude ssm.g ssm.g_exact p) ^ 2 := by
    unfold defectMagnitude
    rw [Real.sq_sqrt (defectMagnitudeSq_nonneg _ _ _)]
  rw [h_eq]
  exact sq_le_sq' (by linarith [ssm.epsilon_nonneg]) h_mag

/-- Summed amplitude bound: the L²-energy on `F` is at most `|F| · ε². -/
theorem sum_defectMagnitudeSq_le
    (ssm : SemiSmoothMetric) (F : Finset LatticePoint) :
    F.sum (defectMagnitudeSq ssm.g ssm.g_exact) ≤
    (F.card : ℝ) * ssm.epsilon ^ 2 := by
  calc F.sum (defectMagnitudeSq ssm.g ssm.g_exact)
      ≤ F.sum (fun _ => ssm.epsilon ^ 2) := by
        apply Finset.sum_le_sum
        intro p _
        exact defectMagnitudeSq_le_epsilon_sq ssm p
    _ = (F.card : ℝ) * ssm.epsilon ^ 2 := by
        rw [Finset.sum_const, nsmul_eq_mul]

/-- **Defect-site count bound.**  Combining Chebyshev and the
    amplitude bound: `|S| ≤ |F| · ε² / τ²`. -/
theorem defectSites_card_le
    (ssm : SemiSmoothMetric) (F : Finset LatticePoint)
    {τ : ℝ} (hτ : 0 < τ) :
    ((defectSites ssm.g ssm.g_exact F τ).card : ℝ) ≤
    (F.card : ℝ) * ssm.epsilon ^ 2 / τ ^ 2 := by
  have h_cheb := defectSites_chebyshev ssm.g ssm.g_exact F τ
  have h_sum := sum_defectMagnitudeSq_le ssm F
  have hτ_sq_pos : 0 < τ ^ 2 := pow_pos hτ 2
  have h_combined :
      ((defectSites ssm.g ssm.g_exact F τ).card : ℝ) * τ ^ 2 ≤
      (F.card : ℝ) * ssm.epsilon ^ 2 := le_trans h_cheb h_sum
  rwa [le_div_iff₀ hτ_sq_pos]

/-! ## Sparsity fraction

Normalising the site count by `|F|` removes the region-size dependence
and gives the density of defect sites, which is bounded by `ε²/τ²` —
a *universal* constant independent of `F`. -/

/-- Defect-site fraction in a region: `|{p ∈ F : |D(p)|² ≥ τ²}| / |F|`. -/
noncomputable def defectFraction
    (ssm : SemiSmoothMetric) (F : Finset LatticePoint) (τ : ℝ) : ℝ :=
  ((defectSites ssm.g ssm.g_exact F τ).card : ℝ) / F.card

/-- **Sparsity fraction bound.**  For any non-empty region and positive
    threshold, the density of defect sites is at most `ε²/τ²`. -/
theorem defectFraction_le
    (ssm : SemiSmoothMetric) {F : Finset LatticePoint} (hF : 0 < F.card)
    {τ : ℝ} (hτ : 0 < τ) :
    defectFraction ssm F τ ≤ ssm.epsilon ^ 2 / τ ^ 2 := by
  unfold defectFraction
  have hFpos : (0 : ℝ) < F.card := Nat.cast_pos.mpr hF
  rw [div_le_iff₀ hFpos]
  have h := defectSites_card_le ssm F hτ
  calc ((defectSites ssm.g ssm.g_exact F τ).card : ℝ)
      ≤ (F.card : ℝ) * ssm.epsilon ^ 2 / τ ^ 2 := h
    _ = ssm.epsilon ^ 2 / τ ^ 2 * F.card := by ring

/-- Sparsity fraction is non-negative. -/
theorem defectFraction_nonneg
    (ssm : SemiSmoothMetric) (F : Finset LatticePoint) (τ : ℝ) :
    0 ≤ defectFraction ssm F τ := by
  unfold defectFraction
  exact div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _)

/-! ## Exponential decay with computational budget

If the amplitude bound `ε` itself decays exponentially with a
parameter `N` (the computational budget — e.g. number of healing
iterations, inverse lattice spacing, etc.), then the sparsity
fraction decays twice as fast:

    ε ≤ C · exp(−α·N)  ⟹  |S|/|F|  ≤  (C² / τ²) · exp(−2α·N).

This is the quantitative "defect sparsity" claim of the Omega
theory in its sharpest form: the fraction of the lattice occupied
by non-trivial defects is exponentially suppressed by the
computational budget. -/

/-- Squaring an exponential bound: `(C · exp(−α·N))² = C² · exp(−2α·N)`. -/
theorem exp_amp_sq (C α N : ℝ) :
    (C * Real.exp (-α * N)) ^ 2 = C ^ 2 * Real.exp (-2 * α * N) := by
  rw [mul_pow]
  congr 1
  rw [sq, ← Real.exp_add]
  congr 1
  ring

/-- If the amplitude `ε` decays exponentially with `N`, so does `ε²`. -/
theorem epsilon_sq_exp_bound (ssm : SemiSmoothMetric)
    {C α N : ℝ} (hC : 0 ≤ C) (h_eps : ssm.epsilon ≤ C * Real.exp (-α * N)) :
    ssm.epsilon ^ 2 ≤ C ^ 2 * Real.exp (-2 * α * N) := by
  have h_rhs_nonneg : 0 ≤ C * Real.exp (-α * N) :=
    mul_nonneg hC (Real.exp_pos _).le
  have h_sq : ssm.epsilon ^ 2 ≤ (C * Real.exp (-α * N)) ^ 2 :=
    sq_le_sq' (by linarith [ssm.epsilon_nonneg]) h_eps
  rwa [exp_amp_sq] at h_sq

/-- **Defect-sparsity exponential bound.**  If `ε ≤ C · exp(−α·N)` then
    `|S|/|F| ≤ (C² / τ²) · exp(−2α·N)`.  Valid for any non-empty region
    `F`, any threshold `τ > 0`, and any computational budget `N`. -/
theorem defectFraction_exp_bound
    (ssm : SemiSmoothMetric) {F : Finset LatticePoint} (hF : 0 < F.card)
    {τ : ℝ} (hτ : 0 < τ) {C α N : ℝ} (hC : 0 ≤ C)
    (h_eps : ssm.epsilon ≤ C * Real.exp (-α * N)) :
    defectFraction ssm F τ ≤ C ^ 2 * Real.exp (-2 * α * N) / τ ^ 2 := by
  have h_frac := defectFraction_le ssm hF hτ
  have h_eps_sq := epsilon_sq_exp_bound ssm hC h_eps
  have hτ_sq_pos : 0 < τ ^ 2 := pow_pos hτ 2
  calc defectFraction ssm F τ
      ≤ ssm.epsilon ^ 2 / τ ^ 2 := h_frac
    _ ≤ C ^ 2 * Real.exp (-2 * α * N) / τ ^ 2 := by gcongr

end OmegaTheory.Defects
