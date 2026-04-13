/-
  OmegaTheory.HealingFlow.Convergence

  Global convergence properties of the healing flow.

  ## Theorems proven (all 0-sorry)

  1. **F = 0 -> equilibrium** (regional): if the healing functional vanishes
     on a region, the equilibrium balance equation holds at every point in
     that region — because each sub-term is forced to zero.

  2. **Monotone convergence structure**: the sequence `F(path(tau_0 + n*dt))`
     is bounded below by 0 and non-increasing under the Lyapunov hypothesis.

  3. **Gradient summability**: dt * Sigma_{k<n} ||grad F(k)||^2 <= F(0)
     for all n. The discrete analog of "integral ||grad F||^2 dt < infty".

  4. **Gradient infimum is zero**: for any epsilon > 0, there exists a step
     where ||grad F||^2 < epsilon. Proof by contradiction.

  5. **Gradient vanishing from functional convergence**: if the functional
     differences F(n) - F(n+1) -> 0, then ||grad F(n)||^2 -> 0 uniformly.

  6. **Global convergence theorem** (Theorem 6.2): combines the above.

  ## Physics interpretation

  This formalizes Theorem 6.2 of Appendix D:
  "The healing flow drives spacetime toward equilibrium."
-/

import OmegaTheory.HealingFlow.Periodic

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## Part 1: F = 0 -> Equilibrium -/

/-- If the info term vanishes at p, then I(p) = I_bar. -/
theorem infoTerm_eq_zero_imp (I : InformationDensity) (I_bar : ℝ) (p : LatticePoint) :
    infoTerm I I_bar p = 0 → I p = I_bar := by
  intro h
  unfold infoTerm at h
  have h12 : (0 : ℝ) < 1 / 2 := by norm_num
  have hsq := (mul_eq_zero.mp h).resolve_left (ne_of_gt h12)
  have := sq_eq_zero_iff.mp hsq
  linarith

/-- If the defect term vanishes at p with lambda > 0, then D_{mu nu}(p) = 0. -/
theorem defectTerm_eq_zero_imp (g_actual g_exact : DiscreteMetric)
    {lambda : ℝ} (hlam : 0 < lambda) (p : LatticePoint) :
    defectTerm g_actual g_exact lambda p = 0 →
    ∀ μ ν, defectTensor g_actual g_exact p μ ν = 0 := by
  intro h μ ν
  unfold defectTerm at h
  have hlam2 : (0 : ℝ) < lambda / 2 := by linarith
  have hmsq := (mul_eq_zero.mp h).resolve_left (ne_of_gt hlam2)
  unfold defectMagnitudeSq at hmsq
  have houter := Finset.sum_eq_zero_iff_of_nonneg (fun α _ =>
    Finset.sum_nonneg fun β _ => sq_nonneg (defectTensor g_actual g_exact p α β))
      |>.mp hmsq μ (Finset.mem_univ μ)
  have hinner := Finset.sum_eq_zero_iff_of_nonneg (fun β _ =>
    sq_nonneg (defectTensor g_actual g_exact p μ β))
      |>.mp houter ν (Finset.mem_univ ν)
  exact pow_eq_zero_iff (by norm_num : 2 ≠ 0) |>.mp hinner

/-- If the smoothness term vanishes at p with mu > 0, then the
    discrete Laplacian of each metric component vanishes. -/
theorem smoothnessTerm_eq_zero_imp (g : DiscreteMetric)
    {mu : ℝ} (hmu : 0 < mu) (p : LatticePoint) :
    smoothnessTerm g mu p = 0 →
    ∀ a b, discreteLaplacian (fun q => g q a b) p = 0 := by
  intro h a b
  unfold smoothnessTerm at h
  have hmu2 : (0 : ℝ) < mu / 2 := by linarith
  have hsum := (mul_eq_zero.mp h).resolve_left (ne_of_gt hmu2)
  have houter := Finset.sum_eq_zero_iff_of_nonneg (fun α _ =>
    Finset.sum_nonneg fun β _ =>
      sq_nonneg (discreteLaplacian (fun q => g q α β) p))
      |>.mp hsum a (Finset.mem_univ a)
  have hinner := Finset.sum_eq_zero_iff_of_nonneg (fun β _ =>
    sq_nonneg (discreteLaplacian (fun q => g q a β) p))
      |>.mp houter b (Finset.mem_univ b)
  exact pow_eq_zero_iff (by norm_num : 2 ≠ 0) |>.mp hinner

/-- **F = 0 implies equilibrium (regional)**: if the healing functional
    vanishes on a region, the equilibrium balance equation holds at
    every point in that region. The balance becomes 0 = 0 + 0. -/
theorem healingFunctional_zero_implies_equilibrium
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ) (region : Finset LatticePoint) :
    healingFunctional params g g_exact I I_bar region = 0 →
    ∀ p ∈ region, ∀ μ ν : Fin 4,
      params.mu * discreteLaplacian (fun q => g q μ ν) p =
      params.lambda * defectTensor g g_exact p μ ν +
      params.gamma * (I p - I_bar) := by
  intro hF p hp μ ν
  have ⟨hinfo, hdefect, hsmooth⟩ :=
    healingFunctional_eq_zero_iff params g g_exact I I_bar region hF p hp
  have hIeq := infoTerm_eq_zero_imp I I_bar p hinfo
  have hDeq := defectTerm_eq_zero_imp g g_exact params.lambda_pos p hdefect μ ν
  have hLap := smoothnessTerm_eq_zero_imp g params.mu_pos p hsmooth μ ν
  rw [hLap, hDeq, hIeq, sub_self, mul_zero, mul_zero, mul_zero, add_zero]

/-- **F = 0 implies each physical condition separately**:
    information is uniform, defects vanish, metric Laplacian vanishes. -/
theorem healingFunctional_zero_implies_all_vanish
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ) (region : Finset LatticePoint) :
    healingFunctional params g g_exact I I_bar region = 0 →
    ∀ p ∈ region,
      (I p = I_bar) ∧
      (∀ μ ν, defectTensor g g_exact p μ ν = 0) ∧
      (∀ μ ν, discreteLaplacian (fun q => g q μ ν) p = 0) := by
  intro hF p hp
  have ⟨hinfo, hdefect, hsmooth⟩ :=
    healingFunctional_eq_zero_iff params g g_exact I I_bar region hF p hp
  exact ⟨
    infoTerm_eq_zero_imp I I_bar p hinfo,
    defectTerm_eq_zero_imp g g_exact params.lambda_pos p hdefect,
    smoothnessTerm_eq_zero_imp g params.mu_pos p hsmooth⟩

/-! ## Part 2: Functional Along Flow -/

/-- The healing functional evaluated along a flow at discrete step n. -/
noncomputable def functionalAlongFlow
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) (delta_tau : ℝ) (tau0 : ℝ) :
    ℕ → ℝ :=
  fun n => healingFunctional params (path (tau0 + n * delta_tau)) g_exact I I_bar region

/-- The functional along any flow is bounded below by 0. -/
theorem functionalAlongFlow_nonneg
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) (delta_tau : ℝ) (tau0 : ℝ) (n : ℕ) :
    0 ≤ functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 n := by
  unfold functionalAlongFlow
  exact healingFunctional_nonneg params _ g_exact I I_bar region

/-- Under the Lyapunov hypothesis, F(n+1) <= F(n). -/
theorem functionalAlongFlow_antitone_step
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region) (n : ℕ) :
    functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 (n + 1) ≤
    functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 n := by
  unfold functionalAlongFlow
  have hdec := hflow.decrement (tau0 + n * delta_tau)
  have harith : tau0 + ↑n * delta_tau + delta_tau = tau0 + ↑(n + 1) * delta_tau := by
    push_cast; ring
  rw [harith] at hdec
  have hpos := mul_nonneg (le_of_lt hflow.step_pos)
    (gradientNormSq_nonneg params (path (tau0 + ↑n * delta_tau)) g_exact I I_bar region)
  linarith

/-- The functional along a Lyapunov flow is antitone. -/
theorem functionalAlongFlow_antitone (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region) :
    Antitone (functionalAlongFlow params path g_exact I I_bar region delta_tau tau0) := by
  apply antitone_nat_of_succ_le
  intro n
  exact functionalAlongFlow_antitone_step params path g_exact I I_bar delta_tau
    region tau0 hflow n

/-! ## Part 3: Gradient summability -/

/-- The per-step functional decrease bounds delta_tau * ||grad F(n)||^2. -/
theorem functionalAlongFlow_step_decrease
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region) (n : ℕ) :
    delta_tau * gradientNormSq params (path (tau0 + n * delta_tau)) g_exact I I_bar region ≤
    functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 n -
    functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 (n + 1) := by
  unfold functionalAlongFlow
  have hdec := hflow.decrement (tau0 + n * delta_tau)
  have harith : tau0 + ↑n * delta_tau + delta_tau = tau0 + ↑(n + 1) * delta_tau := by
    push_cast; ring
  rw [harith] at hdec
  linarith

/-- **Gradient summability**: dt * Sigma_{k<n} ||grad F(k)||^2 <= F(0). -/
theorem sum_gradientNormSq_bounded
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region) (n : ℕ) :
    delta_tau * totalDissipation params path g_exact I I_bar region delta_tau n tau0 ≤
    functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 0 := by
  have htel := healingFunctional_telescoping params path g_exact I I_bar delta_tau
    region hflow tau0 n
  have hnn := healingFunctional_nonneg params (path (tau0 + n * delta_tau)) g_exact I I_bar region
  unfold functionalAlongFlow
  simp only [Nat.cast_zero, zero_mul, add_zero]
  linarith

/-- totalDissipation <= F(0) / delta_tau. -/
theorem gradientNormSq_summable
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region) (n : ℕ) :
    totalDissipation params path g_exact I I_bar region delta_tau n tau0 ≤
    healingFunctional params (path tau0) g_exact I I_bar region / delta_tau := by
  have hbound := sum_gradientNormSq_bounded params path g_exact I I_bar delta_tau
    region tau0 hflow n
  unfold functionalAlongFlow at hbound
  simp only [Nat.cast_zero, zero_mul, add_zero] at hbound
  have hdt : (0 : ℝ) < delta_tau := hflow.step_pos
  -- delta_tau * total <= F0, and delta_tau > 0, so total <= F0 / delta_tau
  -- Use: a <= b / c iff c * a <= b (for c > 0)
  rw [le_div_iff₀ hdt]
  linarith [mul_comm delta_tau
    (totalDissipation params path g_exact I I_bar region delta_tau n tau0)]

/-! ## Part 4: Gradient infimum is zero -/

/-- **Gradient infimum is zero**: for any epsilon > 0, there exists a step
    where ||grad F||^2 < epsilon. -/
theorem gradientNormSq_inf_zero
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region) :
    ∀ eps : ℝ, 0 < eps →
      ∃ n : ℕ,
        gradientNormSq params (path (tau0 + n * delta_tau)) g_exact I I_bar region < eps := by
  intro eps heps
  by_contra h
  push Not at h
  -- h : forall n, eps <= gradientNormSq(n)
  have hbig : ∀ n : ℕ,
      eps * n ≤ totalDissipation params path g_exact I I_bar region delta_tau n tau0 := by
    intro n
    unfold totalDissipation
    induction n with
    | zero => simp
    | succ n ih =>
      rw [Finset.sum_range_succ]
      have hstep := h n
      push_cast
      linarith
  -- But total dissipation is bounded by F(0)/delta_tau
  set bound := healingFunctional params (path tau0) g_exact I I_bar region /
    delta_tau
  -- Choose N such that eps * N > bound
  set N := ⌈bound / eps⌉₊ + 1
  have hN_big : bound < eps * ↑N := by
    have hle : bound / eps ≤ ↑⌈bound / eps⌉₊ := Nat.le_ceil _
    have hlt : (↑⌈bound / eps⌉₊ : ℝ) < ↑N := by
      change (↑⌈bound / eps⌉₊ : ℝ) < ↑(⌈bound / eps⌉₊ + 1)
      push_cast; linarith
    have : bound / eps < ↑N := lt_of_le_of_lt hle hlt
    calc bound = eps * (bound / eps) := by field_simp
      _ < eps * ↑N := by nlinarith
  have hsum_bound := gradientNormSq_summable params path g_exact I I_bar delta_tau
    region tau0 hflow N
  have hsum_big := hbig N
  -- eps * N <= total(N) <= bound < eps * N: contradiction
  linarith

/-! ## Part 5: Gradient vanishing from functional convergence -/

/-- **Gradient vanishing**: if the functional differences tend to zero,
    then ||grad F(n)||^2 vanishes asymptotically. -/
theorem gradientNormSq_vanishes
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (hconv : ∀ eps : ℝ, 0 < eps → ∃ N : ℕ, ∀ n ≥ N,
      functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 n -
      functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 (n + 1) < eps) :
    ∀ eps : ℝ, 0 < eps → ∃ N : ℕ, ∀ n ≥ N,
      gradientNormSq params (path (tau0 + n * delta_tau)) g_exact I I_bar region < eps := by
  intro eps heps
  have hdt := hflow.step_pos
  obtain ⟨N, hN⟩ := hconv (delta_tau * eps) (mul_pos hdt heps)
  exact ⟨N, fun n hn => by
    have hstep := functionalAlongFlow_step_decrease params path g_exact I I_bar
      delta_tau region tau0 hflow n
    have hdiff := hN n hn
    -- delta_tau * ||grad F(n)||^2 <= F(n) - F(n+1) < delta_tau * eps
    have h : delta_tau * gradientNormSq params (path (tau0 + ↑n * delta_tau))
        g_exact I I_bar region < delta_tau * eps := by linarith
    -- Since delta_tau > 0, cancel it
    exact lt_of_mul_lt_mul_left h (le_of_lt hdt)⟩

/-! ## Part 6: Global convergence theorem -/

/-- **Asymptotic equilibrium**: on any Lyapunov healing flow, for any
    epsilon > 0, there exists a step where ||grad F||^2 < epsilon. -/
theorem asymptotic_equilibrium_exists
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region) :
    ∀ eps : ℝ, 0 < eps → ∃ n : ℕ,
      gradientNormSq params (path (tau0 + n * delta_tau)) g_exact I I_bar region < eps :=
  gradientNormSq_inf_zero params path g_exact I I_bar delta_tau region tau0 hflow

/-- **Global convergence theorem (Theorem 6.2)**: on a Lyapunov healing
    flow where the functional differences converge to zero:
    1. The gradient norm squared vanishes asymptotically.
    2. The functional is bounded below by 0 at every step.
    3. The functional sequence is antitone. -/
theorem global_convergence
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) (region : Finset LatticePoint) (tau0 : ℝ)
    (hflow : IsLyapunovHealingFlow params path g_exact I I_bar delta_tau region)
    (hconv : ∀ eps : ℝ, 0 < eps → ∃ N : ℕ, ∀ n ≥ N,
      functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 n -
      functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 (n + 1) < eps) :
    (∀ eps : ℝ, 0 < eps → ∃ N : ℕ, ∀ n ≥ N,
      gradientNormSq params (path (tau0 + n * delta_tau)) g_exact I I_bar region < eps) ∧
    (∀ n : ℕ, 0 ≤ functionalAlongFlow params path g_exact I I_bar region delta_tau tau0 n) ∧
    (Antitone (functionalAlongFlow params path g_exact I I_bar region delta_tau tau0)) :=
  ⟨gradientNormSq_vanishes params path g_exact I I_bar delta_tau region tau0 hflow hconv,
   fun n => functionalAlongFlow_nonneg params path g_exact I I_bar region delta_tau tau0 n,
   functionalAlongFlow_antitone params path g_exact I I_bar delta_tau region tau0 hflow⟩

end OmegaTheory.HealingFlow
