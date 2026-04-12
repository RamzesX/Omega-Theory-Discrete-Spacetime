/-
  OmegaTheory.Tensor.ValuedGeometry

  The bridge from error algebra to differential geometry: Christoffel symbols
  that carry explicit error bounds derived from metric defects.

  Given a SemiSmoothMetric with defect bound epsilon, the actual Christoffel
  symbol Gamma[g] differs from the ideal Gamma[g_exact] by at most a computable
  bound involving epsilon, the inverse-metric magnitude M_inv, the derivative
  magnitude M_deriv, and the lattice spacing l_P.

  Physics:
    Gamma^rho_{mu nu} = (1/2) Sum_sigma g^{rho sigma} * bracket_{mu nu sigma}
    where bracket = partial_mu g_{nu sigma} + partial_nu g_{mu sigma} - partial_sigma g_{mu nu}

  Error sources:
    (a) g^{rho sigma} vs g_exact^{rho sigma}  --  bounded by epsilon_inv
    (b) bracket[g] vs bracket[g_exact]         --  bounded by 3 * epsilon / l_P
        (each symmetric diff of a defect-epsilon field has error <= epsilon / l_P,
         and the bracket sums three such terms)

  Product rule (abs_mul_sub_mul_bound):
    |g^{rs} * bracket - g_exact^{rs} * bracket_exact|
      <= M_inv * bracket_err + M_bracket * inv_err + inv_err * bracket_err

  Final bound is summed over sigma (4 terms) and halved.
-/

import OmegaTheory.Geometry.Connection
import OmegaTheory.Defects.DefectTensor
import OmegaTheory.Tensor.ErrorTensor
import OmegaTheory.Tensor.Operations
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace OmegaTheory.Tensor

open OmegaTheory.Foundations
open OmegaTheory.Geometry
open OmegaTheory.Defects
open OmegaTheory.Spacetime

/-! ## Hypotheses for Christoffel error propagation

We parameterize the bound by two magnitude constants that a concrete
metric must supply. These are standard a priori bounds in lattice
perturbation theory. -/

/-- Assumptions needed to bound Christoffel errors.
    M_inv: uniform bound on |g^{rho sigma}(p)| for all indices and points
    M_deriv: uniform bound on |partial_mu g_{nu sigma}(p)| for the exact metric
    epsilon_inv: bound on |g^{rs} - g_exact^{rs}| (inverse metric perturbation) -/
structure ChristoffelErrorData (ssm : SemiSmoothMetric) where
  /-- Bound on components of the actual inverse metric: |g^{rs}(p)| <= M_inv. -/
  M_inv : ℝ
  M_inv_pos : 0 < M_inv
  inv_bounded : ∀ (p : LatticePoint) (ρ σ : Fin 4),
    |inverseMetric (ssm.g p) ρ σ| ≤ M_inv
  /-- Bound on exact metric derivatives: |partial_mu g_exact_{nu sigma}| <= M_deriv. -/
  M_deriv : ℝ
  M_deriv_nonneg : 0 ≤ M_deriv
  deriv_bounded : ∀ (p : LatticePoint) (μ ν σ : Fin 4),
    |metricDerivative ssm.g_exact μ ν σ p| ≤ M_deriv
  /-- Bound on inverse metric perturbation:
      |g^{rs}(p) - g_exact^{rs}(p)| <= epsilon_inv. -/
  epsilon_inv : ℝ
  epsilon_inv_nonneg : 0 ≤ epsilon_inv
  inv_perturb_bounded : ∀ (p : LatticePoint) (ρ σ : Fin 4),
    |inverseMetric (ssm.g p) ρ σ - inverseMetric (ssm.g_exact p) ρ σ| ≤ epsilon_inv

/-! ## The Christoffel error bound -/

/-- The bracket expression inside the Christoffel formula:
    B_{mu nu sigma}(p) = partial_mu g_{nu sigma} + partial_nu g_{mu sigma} - partial_sigma g_{mu nu} -/
noncomputable def christoffelBracket (g : DiscreteMetric) (μ ν σ : Fin 4)
    (p : LatticePoint) : ℝ :=
  metricDerivative g μ ν σ p + metricDerivative g ν μ σ p - metricDerivative g σ μ ν p

/-- The bracket error: since each metricDerivative is a symmetricDiff of
    a field differing by epsilon, the per-derivative error is epsilon / l_P.
    The bracket sums/subtracts three such terms, so bracket error <= 3 * epsilon / l_P. -/
noncomputable def bracketError (epsilon : ℝ) : ℝ := 3 * epsilon / l_P

theorem bracketError_nonneg {epsilon : ℝ} (heps : 0 ≤ epsilon) :
    0 ≤ bracketError epsilon :=
  div_nonneg (mul_nonneg (by norm_num : (0 : ℝ) ≤ 3) heps) l_P_nonneg

/-- Bound on the exact bracket magnitude: |B_exact| <= 3 * M_deriv. -/
noncomputable def bracketBound (M_deriv : ℝ) : ℝ := 3 * M_deriv

/-- The per-summand Christoffel error (before the 1/2 factor and sigma sum):
    For a single sigma, the product g^{rho sigma} * bracket_{mu nu sigma}
    has error bounded by
      M_inv * bracketError + bracketBound * epsilon_inv + epsilon_inv * bracketError
    via abs_mul_sub_mul_bound. -/
noncomputable def christoffelSummandError (M_inv M_deriv epsilon epsilon_inv : ℝ) : ℝ :=
  M_inv * bracketError epsilon +
  bracketBound M_deriv * epsilon_inv +
  epsilon_inv * bracketError epsilon

/-- The total Christoffel error:
    (1/2) * 4 * christoffelSummandError
    = 2 * christoffelSummandError
    (sum over 4 values of sigma, then multiply by 1/2). -/
noncomputable def christoffelError (M_inv M_deriv epsilon epsilon_inv : ℝ) : ℝ :=
  2 * christoffelSummandError M_inv M_deriv epsilon epsilon_inv

theorem christoffelError_nonneg {M_inv M_deriv epsilon epsilon_inv : ℝ}
    (hM : 0 ≤ M_inv) (hD : 0 ≤ M_deriv) (heps : 0 ≤ epsilon) (hinv : 0 ≤ epsilon_inv) :
    0 ≤ christoffelError M_inv M_deriv epsilon epsilon_inv := by
  unfold christoffelError christoffelSummandError
  apply mul_nonneg (by norm_num : (0 : ℝ) ≤ 2)
  apply add_nonneg
  · apply add_nonneg
    · exact mul_nonneg hM (bracketError_nonneg heps)
    · exact mul_nonneg (by unfold bracketBound; exact mul_nonneg (by norm_num) hD) hinv
  · exact mul_nonneg hinv (bracketError_nonneg heps)

/-! ## Symmetric difference perturbation bound

Key lemma: if `|f(q) - f_exact(q)| ≤ ε` for all q, then
`|symmetricDiff f μ p - symmetricDiff f_exact μ p| ≤ ε / l_P`. -/

theorem symmetricDiff_perturbation
    (f f_exact : ScalarField) (ε : ℝ)
    (hbound : ∀ q, |f q - f_exact q| ≤ ε) (μ : Fin 4) (p : LatticePoint) :
    |symmetricDiff f μ p - symmetricDiff f_exact μ p| ≤ ε / l_P := by
  unfold symmetricDiff
  have hlP_pos : (0 : ℝ) < 2 * l_P := mul_pos two_pos l_P_pos
  have hlP_ne : (2 : ℝ) * l_P ≠ 0 := ne_of_gt hlP_pos
  have h1 := hbound (shiftFin p μ)
  have h2 := hbound (shiftBackFin p μ)
  -- Rewrite the difference of two quotients with the same denominator
  have hdiff :
      (f (shiftFin p μ) - f (shiftBackFin p μ)) / (2 * l_P) -
      (f_exact (shiftFin p μ) - f_exact (shiftBackFin p μ)) / (2 * l_P) =
      ((f (shiftFin p μ) - f_exact (shiftFin p μ)) -
       (f (shiftBackFin p μ) - f_exact (shiftBackFin p μ))) / (2 * l_P) := by
    rw [← div_sub_div_same]; congr 1; ring
  rw [hdiff]
  set a := f (shiftFin p μ) - f_exact (shiftFin p μ)
  set b := f (shiftBackFin p μ) - f_exact (shiftBackFin p μ)
  have hab : |a - b| ≤ |a| + |b| := by
    calc |a - b| = |a + (-b)| := by ring_nf
      _ ≤ |a| + |-b| := abs_add_le _ _
      _ = |a| + |b| := by rw [abs_neg]
  have hnum : |a - b| ≤ 2 * ε := by linarith [add_le_add h1 h2]
  have hgoal : (2 * ε) / (2 * l_P) = ε / l_P := by
    rw [mul_div_mul_left _ _ (two_ne_zero)]
  calc |(a - b) / (2 * l_P)| = |a - b| / (2 * l_P) := by
        rw [abs_div, abs_of_pos hlP_pos]
    _ ≤ (2 * ε) / (2 * l_P) := by
        exact div_le_div_of_nonneg_right hnum (le_of_lt hlP_pos)
    _ = ε / l_P := hgoal

/-- Metric derivative perturbation: since `metricDerivative g σ μ ν p =
    symmetricDiff (fun q => g q μ ν) σ p`, the perturbation bound follows
    directly from `symmetricDiff_perturbation`. -/
theorem metricDerivative_perturbation
    (ssm : SemiSmoothMetric) (σ μ ν : Fin 4) (p : LatticePoint) :
    |metricDerivative ssm.g σ μ ν p - metricDerivative ssm.g_exact σ μ ν p| ≤
    ssm.epsilon / l_P := by
  unfold metricDerivative
  exact symmetricDiff_perturbation _ _ ssm.epsilon
    (fun q => ssm.component_bounded q μ ν) σ p

/-! ## Valued Christoffel Symbol -/

/-- A Christoffel symbol carrying an explicit error bound.
    - `.val` = christoffelSymbol g rho mu nu p (the actual Christoffel)
    - `.error` = bound on |Gamma[g] - Gamma[g_exact]| -/
noncomputable def valuedChristoffelSymbol
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (ρ μ ν : Fin 4) (p : LatticePoint) : Valued ℝ :=
  { val := christoffelSymbol ssm.g ρ μ ν p
    error := ⟨christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv,
              christoffelError_nonneg (le_of_lt ced.M_inv_pos)
                ced.M_deriv_nonneg ssm.epsilon_nonneg ced.epsilon_inv_nonneg⟩ }

/-- The value component equals the unvalued Christoffel symbol. -/
theorem valuedChristoffelSymbol_val
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (ρ μ ν : Fin 4) (p : LatticePoint) :
    (valuedChristoffelSymbol ssm ced ρ μ ν p).val = christoffelSymbol ssm.g ρ μ ν p :=
  rfl

/-- The error component equals the christoffelError formula. -/
theorem valuedChristoffelSymbol_err
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (ρ μ ν : Fin 4) (p : LatticePoint) :
    (valuedChristoffelSymbol ssm ced ρ μ ν p).error.val =
    christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv :=
  rfl

/-- The main error bound theorem: the actual Christoffel differs from
    the exact Christoffel by at most the computed error bound.

    |Gamma[g](rho,mu,nu,p) - Gamma[g_exact](rho,mu,nu,p)| <= christoffelError(...)

    Proof sketch:
    1. Expand both Christoffels as (1/2) * Sum_sigma g^{rs} * bracket
    2. For each sigma, apply abs_mul_sub_mul_bound to the product
       g^{rs} * bracket with the known bounds
    3. Sum over sigma (4 terms) and multiply by 1/2
    4. The bracket error follows from defect_bounded + triangle inequality
       on symmetricDiff -/
theorem valuedChristoffelSymbol_err_bound
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (ρ μ ν : Fin 4) (p : LatticePoint) :
    |christoffelSymbol ssm.g ρ μ ν p - christoffelSymbol ssm.g_exact ρ μ ν p| ≤
    christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv := by
  -- The core algebraic bound: expand Christoffel as (1/2) * Sum_sigma (g^{rs} * bracket),
  -- apply abs_mul_sub_mul_bound per summand, sum over sigma, multiply by 1/2.
  -- Each step uses: inv_bounded, deriv_bounded, component_bounded, inv_perturb_bounded.
  sorry

/-- The bracket perturbation bound: the bracket of the actual metric
    differs from the bracket of the exact metric by at most 3*epsilon/l_P.

    This follows from the triangle inequality: each of the three
    metricDerivative terms is a symmetricDiff, and symmetricDiff of a
    function perturbed by epsilon has error at most epsilon/l_P. -/
theorem bracket_perturbation_bound
    (ssm : SemiSmoothMetric) (μ ν σ : Fin 4) (p : LatticePoint) :
    |christoffelBracket ssm.g μ ν σ p - christoffelBracket ssm.g_exact μ ν σ p| ≤
    bracketError ssm.epsilon := by
  unfold christoffelBracket bracketError
  have d1 := metricDerivative_perturbation ssm μ ν σ p
  have d2 := metricDerivative_perturbation ssm ν μ σ p
  have d3 := metricDerivative_perturbation ssm σ μ ν p
  have hdec :
      (metricDerivative ssm.g μ ν σ p + metricDerivative ssm.g ν μ σ p -
        metricDerivative ssm.g σ μ ν p) -
      (metricDerivative ssm.g_exact μ ν σ p + metricDerivative ssm.g_exact ν μ σ p -
        metricDerivative ssm.g_exact σ μ ν p) =
      (metricDerivative ssm.g μ ν σ p - metricDerivative ssm.g_exact μ ν σ p) +
      (metricDerivative ssm.g ν μ σ p - metricDerivative ssm.g_exact ν μ σ p) -
      (metricDerivative ssm.g σ μ ν p - metricDerivative ssm.g_exact σ μ ν p) := by
    ring
  rw [hdec]
  -- |a + b - c| ≤ |a| + |b| + |c| ≤ ε/l_P + ε/l_P + ε/l_P = 3ε/l_P
  set a := metricDerivative ssm.g μ ν σ p - metricDerivative ssm.g_exact μ ν σ p
  set b := metricDerivative ssm.g ν μ σ p - metricDerivative ssm.g_exact ν μ σ p
  set cc := metricDerivative ssm.g σ μ ν p - metricDerivative ssm.g_exact σ μ ν p
  have hab : |a + b - cc| ≤ |a| + |b| + |cc| := by
    calc |a + b - cc| = |a + b + (-cc)| := by ring_nf
      _ ≤ |a + b| + |-cc| := abs_add_le _ _
      _ ≤ (|a| + |b|) + |cc| := by rw [abs_neg]; linarith [abs_add_le a b]
  have hsum : |a| + |b| + |cc| ≤ ssm.epsilon / l_P + ssm.epsilon / l_P + ssm.epsilon / l_P :=
    add_le_add (add_le_add d1 d2) d3
  have heq : ssm.epsilon / l_P + ssm.epsilon / l_P + ssm.epsilon / l_P = 3 * ssm.epsilon / l_P := by
    ring
  linarith

/-- The exact bracket is bounded by 3 * M_deriv.
    Direct from triangle inequality and deriv_bounded. -/
theorem bracket_exact_bounded
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (μ ν σ : Fin 4) (p : LatticePoint) :
    |christoffelBracket ssm.g_exact μ ν σ p| ≤ bracketBound ced.M_deriv := by
  unfold christoffelBracket bracketBound
  calc |metricDerivative ssm.g_exact μ ν σ p + metricDerivative ssm.g_exact ν μ σ p -
        metricDerivative ssm.g_exact σ μ ν p|
      ≤ |metricDerivative ssm.g_exact μ ν σ p + metricDerivative ssm.g_exact ν μ σ p| +
        |metricDerivative ssm.g_exact σ μ ν p| := by
        rw [sub_eq_add_neg, ← abs_neg (metricDerivative ssm.g_exact σ μ ν p)]
        exact abs_add_le _ _
    _ ≤ |metricDerivative ssm.g_exact μ ν σ p| +
        |metricDerivative ssm.g_exact ν μ σ p| +
        |metricDerivative ssm.g_exact σ μ ν p| := by
        linarith [abs_add_le (metricDerivative ssm.g_exact μ ν σ p)
                   (metricDerivative ssm.g_exact ν μ σ p)]
    _ ≤ ced.M_deriv + ced.M_deriv + ced.M_deriv := by
        linarith [ced.deriv_bounded p μ ν σ, ced.deriv_bounded p ν μ σ,
                  ced.deriv_bounded p σ μ ν]
    _ = 3 * ced.M_deriv := by ring

/-! ## Valued Christoffel inherits symmetry -/

/-- The valued Christoffel inherits lower-index symmetry from the metric. -/
theorem valuedChristoffelSymbol_symmetry
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (hsym : ssm.g.IsEverywhereSymmetric) (ρ μ ν : Fin 4) (p : LatticePoint) :
    (valuedChristoffelSymbol ssm ced ρ μ ν p).val =
    (valuedChristoffelSymbol ssm ced ρ ν μ p).val := by
  simp only [valuedChristoffelSymbol_val]
  exact christoffel_symmetry ssm.g hsym ρ μ ν p

/-! ## ErrorBound packaging -/

/-- Package the Christoffel error as an ErrorBound. -/
noncomputable def christoffelErrorBound
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm) : ErrorBound :=
  ⟨christoffelError ced.M_inv ced.M_deriv ssm.epsilon ced.epsilon_inv,
   christoffelError_nonneg (le_of_lt ced.M_inv_pos)
     ced.M_deriv_nonneg ssm.epsilon_nonneg ced.epsilon_inv_nonneg⟩

/-- The valued Christoffel uses exactly this ErrorBound at every point. -/
theorem valuedChristoffelSymbol_uniform_error
    (ssm : SemiSmoothMetric) (ced : ChristoffelErrorData ssm)
    (ρ μ ν : Fin 4) (p : LatticePoint) :
    (valuedChristoffelSymbol ssm ced ρ μ ν p).error =
    christoffelErrorBound ssm ced := by
  simp [valuedChristoffelSymbol, christoffelErrorBound]

end OmegaTheory.Tensor
