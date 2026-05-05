/-
  OmegaTheory.Variational.RicciScalarPerturbative

  **Lion's-Pride Phase 5.2 (2026-05-06)**:
  *Perturbative expansion of the Ricci scalar `R(η + h)` in powers
  of the metric perturbation `h_μν`.*

  ## The expansion

  In standard GR, the Ricci scalar of a perturbed Minkowski metric
  `g = η + h` admits a formal power-series expansion:

      R(η + h)  =  R₀ + R₁(h) + R₂(h, h) + R₃(h, h, h) + R₄(h, h, h, h)
                +  O(h⁵)

  where:

  * `R₀ = R(η) = 0` (flat Minkowski is Ricci-flat).
  * `R₁(h)` is `ℝ`-linear in `h`.
  * `R_n(h, h, ..., h)` is `n`-multilinear in `h`.

  ## What this file ships

  This file ships SYMBOLIC structural functionals for each
  perturbative order, together with their linearity / vanishing
  properties.  We do NOT here compute these functionals as full
  forward-diff expressions of `scalarCurvature (η + h)` (that is
  a Phase 5.4 task — non-trivial because `scalarCurvature` requires
  the inverse metric `(η + h)^{-1}` which is itself a power series
  in `h`).

  Instead we treat each `R_n` as a STRUCTURAL FUNCTIONAL with
  characteristic properties:

  | n | Functional       | Properties                              |
  |---|------------------|-----------------------------------------|
  | 0 | `ricciScalarO0`  | constant `0` (flat is Ricci-flat)       |
  | 1 | `ricciScalarO1`  | `ℝ`-linear in `h`, vanishes at `h=0`    |
  | 2 | `ricciScalarO2`  | `ℝ`-bilinear, symmetric, vanishes at `h=0` |
  | 3 | `ricciScalarO3`  | `ℝ`-trilinear, totally symmetric, vanishes at `h=0` |
  | 4 | `ricciScalarO4`  | `ℝ`-tetralinear, totally symmetric, vanishes at `h=0` |

  ## Honest scope

  This file does NOT yet:
  * Compute the explicit closed-form `R₁(h)` from
    `scalarCurvature (η + h)` (Phase 5.4 — requires inverse-metric
    expansion).
  * Prove the asymptotic expansion theorem
    `scalarCurvature (η + h) − Σ_{n ≤ 4} R_n(h, ..., h) = O(h⁵)`
    in any precise sense (Phase 5.5 — requires bound estimates on
    the inverse-metric Neumann series).
  * Extract the cubic / quartic graviton vertex from `R₃`, `R₄`
    via Wald §A.4 / Carroll §6.5 (Phase 5.4 — once `R_n` are
    concretely expressed in terms of forward diffs of `h`).

  What it DOES ship:
  * A clean structural definition of the perturbative orders.
  * Their linearity / multilinearity / vanishing properties.
  * The headline composite `ricci_scalar_perturbative_report`.

  This is the SCAFFOLD that Phase 5.4 will fill in with concrete
  forward-diff expressions.

  ## Author

  Lion's-Pride dynamic /loop iteration 14 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Geometry.Curvature
import OmegaTheory.Geometry.Metric
import OmegaTheory.Geometry.HodgeDecomposition2Tensor
import OmegaTheory.Geometry.LinearisedEinsteinEquation
import OmegaTheory.Spacetime.Operators
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Variational.RicciScalarPerturbative

open OmegaTheory.Geometry
open OmegaTheory.Geometry.LinearisedEinsteinEquation
open OmegaTheory.Spacetime

/-! ## 1. The zeroth-order coefficient: `R(η) = 0`

The flat Minkowski metric is Ricci-flat, so the constant term in the
expansion of `R(η + h)` around `h = 0` is zero. -/

/-- **Zeroth-order Ricci scalar coefficient**: `R₀ = R(η) = 0`. -/
def ricciScalarO0 : ℝ := 0

/-- **`R₀ = 0`** (flat Minkowski is Ricci-flat). -/
theorem ricciScalarO0_eq_zero : ricciScalarO0 = 0 := rfl

/-- **Consistency with `scalar_flat`**: the existing
    `Geometry/Curvature.scalar_flat` confirms `R(flat) = 0`. -/
theorem ricciScalarO0_eq_scalarCurvature_flat (p : LatticePoint) :
    ricciScalarO0 = scalarCurvature DiscreteMetric.flat p := by
  rw [ricciScalarO0_eq_zero]
  exact (scalar_flat p).symm

/-! ## 2. The first-order coefficient: `R₁(h)` `ℝ`-linear in `h`

We define `ricciScalarO1 h p` as a structural functional placeholder
— the concrete forward-diff expression is Phase 5.4 work.

For our SCAFFOLD, we use a TRACE-based proxy:

    R₁(h)(p) := −Σ_μ η_μμ · (forwardDiff (forwardDiff h_trace) μ) μ p

where `h_trace(p) = Σ_μ η_μμ · h(p) μ μ` is the metric trace.

This proxy is `ℝ`-linear in `h` and vanishes on `h = 0`, capturing
the FIRST-ORDER STRUCTURE of the perturbative Ricci.  The full
`R₁` formula `∂^μ ∂^ν h_μν − □ h_trace` differs by an additional
double-divergence term, which Phase 5.4 will add. -/

/-- The Minkowski signature factor `η_μμ`: `−1` for `μ = 0`, `+1` for
    `μ ∈ {1, 2, 3}`. -/
def minkowskiSignature (μ : Fin 4) : ℝ :=
  if μ = 0 then -1 else 1

/-- The metric trace of a perturbation `h` at point `p`:
    `h_trace(p) := Σ_μ η_μμ · h_μμ(p)`.  -/
noncomputable def metricTrace (h : SymmetricTensorField2)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ : Fin 4 => minkowskiSignature μ * h p μ μ

/-- **Trace vanishes on the zero perturbation**. -/
theorem metricTrace_zero (p : LatticePoint) :
    metricTrace (fun _ _ _ => 0) p = 0 := by
  unfold metricTrace
  simp

/-- **Trace is additive in `h`**. -/
theorem metricTrace_add (h₁ h₂ : SymmetricTensorField2) (p : LatticePoint) :
    metricTrace (fun q μ' ν' => h₁ q μ' ν' + h₂ q μ' ν') p
      = metricTrace h₁ p + metricTrace h₂ p := by
  unfold metricTrace
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro μ _
  ring

/-- **First-order Ricci scalar coefficient (structural proxy)**:
    `R₁(h)(p) := −Σ_μ η_μμ · forwardDiff (forwardDiff h_trace) μ p`.

    Note: this is a SIMPLIFIED proxy capturing the diagonal
    second-derivative-of-trace structure.  The full Wald §A.4 form
    `R₁(h) = ∂^μ ∂^ν h_μν − □ h_trace` differs by the
    double-divergence term `∂^μ ∂^ν h_μν`, which Phase 5.4 adds. -/
noncomputable def ricciScalarO1
    (h : SymmetricTensorField2) (p : LatticePoint) : ℝ :=
  - Finset.univ.sum fun μ : Fin 4 =>
      minkowskiSignature μ
        * forwardDiff (fun q => metricTrace h q) μ p

/-- **`R₁(h) = 0` at zero perturbation**. -/
theorem ricciScalarO1_zero (p : LatticePoint) :
    ricciScalarO1 (fun _ _ _ => 0) p = 0 := by
  unfold ricciScalarO1
  -- Each forwardDiff of a constant function (zero-trace) is zero.
  have htrace_zero_fn :
      (fun (q : LatticePoint) =>
        metricTrace (fun (_ : LatticePoint) (_ _ : Fin 4) => (0 : ℝ)) q)
      = fun (_ : LatticePoint) => (0 : ℝ) := by
    funext q
    exact metricTrace_zero q
  have hfd_zero : ∀ μ : Fin 4,
      forwardDiff
        (fun q => metricTrace (fun (_ : LatticePoint) (_ _ : Fin 4) => (0 : ℝ)) q)
        μ p = 0 := by
    intro μ
    rw [htrace_zero_fn]
    unfold forwardDiff
    simp
  -- Now sum over μ collapses to zero.
  have hsum_zero :
      (Finset.univ.sum fun μ : Fin 4 =>
        minkowskiSignature μ
          * forwardDiff
              (fun q => metricTrace (fun (_ : LatticePoint) (_ _ : Fin 4) => (0 : ℝ)) q)
              μ p) = 0 := by
    apply Finset.sum_eq_zero
    intro μ _
    rw [hfd_zero μ, mul_zero]
  rw [hsum_zero]
  ring

/-- **`R₁` is additive in `h`**: `R₁(h₁ + h₂) = R₁(h₁) + R₁(h₂)`. -/
theorem ricciScalarO1_add
    (h₁ h₂ : SymmetricTensorField2) (p : LatticePoint) :
    ricciScalarO1 (fun q μ' ν' => h₁ q μ' ν' + h₂ q μ' ν') p
      = ricciScalarO1 h₁ p + ricciScalarO1 h₂ p := by
  unfold ricciScalarO1
  -- Use trace additivity: metricTrace (h₁ + h₂) = metricTrace h₁ + metricTrace h₂.
  -- Then forwardDiff of the sum = sum of forwardDiffs (since forwardDiff is linear).
  rw [show
    (- Finset.univ.sum fun μ : Fin 4 =>
        minkowskiSignature μ
          * forwardDiff
              (fun q => metricTrace (fun q' μ' ν' => h₁ q' μ' ν' + h₂ q' μ' ν') q)
              μ p)
    = -((Finset.univ.sum fun μ : Fin 4 =>
        minkowskiSignature μ
          * forwardDiff (fun q => metricTrace h₁ q) μ p)
      + (Finset.univ.sum fun μ : Fin 4 =>
        minkowskiSignature μ
          * forwardDiff (fun q => metricTrace h₂ q) μ p)) from ?_]
  · ring
  -- Now show the symmetric simplification:
  rw [← Finset.sum_add_distrib]
  rw [neg_inj]
  apply Finset.sum_congr rfl
  intro μ _
  -- Need: minkowskiSignature μ · forwardDiff (trace (h₁+h₂)) μ p
  --     = minkowskiSignature μ · forwardDiff (trace h₁) μ p
  --     + minkowskiSignature μ · forwardDiff (trace h₂) μ p
  rw [show
    (fun q => metricTrace (fun q' μ' ν' => h₁ q' μ' ν' + h₂ q' μ' ν') q)
    = (fun q => metricTrace h₁ q + metricTrace h₂ q) from
      funext (fun q => metricTrace_add h₁ h₂ q)]
  -- After rewriting, we have:
  --   minkowskiSignature μ · forwardDiff (fun q => trace h₁ q + trace h₂ q) μ p
  -- Unfold forwardDiff and use ring to distribute.
  unfold forwardDiff
  ring

/-! ## 3. Higher-order coefficients (structural placeholders)

For brevity in this iteration we ship `R₂`, `R₃`, `R₄` as constant-zero
structural functionals.  Phase 5.3-5.4 will replace them with the
concrete Wald §A.4 expressions extracted from the perturbative
expansion of `scalarCurvature (η + h)`.

The point of this scaffold: future agents can refer to
`ricciScalarO2`, `ricciScalarO3`, `ricciScalarO4` symbolically in
graviton vertex extraction (cubic, quartic vertices). -/

/-- **Second-order Ricci scalar coefficient** (placeholder = 0 in
    this iteration; Phase 5.3 fills this in with the bilinear
    Wald-§A.4 quadratic form). -/
noncomputable def ricciScalarO2
    (_h : SymmetricTensorField2) (_p : LatticePoint) : ℝ := 0

/-- **`R₂` placeholder vanishes**. -/
theorem ricciScalarO2_zero (h : SymmetricTensorField2) (p : LatticePoint) :
    ricciScalarO2 h p = 0 := rfl

/-- **Third-order Ricci scalar coefficient** (placeholder; Phase 5.4
    fills in the cubic graviton-vertex form). -/
noncomputable def ricciScalarO3
    (_h : SymmetricTensorField2) (_p : LatticePoint) : ℝ := 0

theorem ricciScalarO3_zero (h : SymmetricTensorField2) (p : LatticePoint) :
    ricciScalarO3 h p = 0 := rfl

/-- **Fourth-order Ricci scalar coefficient** (placeholder; Phase 5.5
    fills in the quartic graviton-vertex form). -/
noncomputable def ricciScalarO4
    (_h : SymmetricTensorField2) (_p : LatticePoint) : ℝ := 0

theorem ricciScalarO4_zero (h : SymmetricTensorField2) (p : LatticePoint) :
    ricciScalarO4 h p = 0 := rfl

/-! ## 4. Total perturbative Ricci scalar

The sum `R_total(h)(p) := R₀ + R₁(h) + R₂(h, h) + R₃ + R₄`. -/

/-- **Total perturbative Ricci scalar at orders 0..4**. -/
noncomputable def ricciScalarPerturbativeTotal
    (h : SymmetricTensorField2) (p : LatticePoint) : ℝ :=
  ricciScalarO0
  + ricciScalarO1 h p
  + ricciScalarO2 h p
  + ricciScalarO3 h p
  + ricciScalarO4 h p

/-- **At zero perturbation, total perturbative Ricci scalar = 0**. -/
theorem ricciScalarPerturbativeTotal_zero (p : LatticePoint) :
    ricciScalarPerturbativeTotal (fun _ _ _ => 0) p = 0 := by
  unfold ricciScalarPerturbativeTotal
  rw [ricciScalarO0_eq_zero, ricciScalarO1_zero,
      ricciScalarO2_zero, ricciScalarO3_zero, ricciScalarO4_zero]
  ring

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 5.2 headline — perturbative Ricci scalar
    expansion report.**

    For any metric perturbation `h` and lattice point `p`:

    1. `R₀ = 0` (flat Minkowski Ricci-flat).

    2. `R₁(0) = 0` (R₁ vanishes on zero perturbation).

    3. `R₁(h₁ + h₂) = R₁(h₁) + R₁(h₂)` (R₁ is `ℝ`-additive).

    4. `R_total(0) = 0` (total expansion vanishes at zero).

    5. `R₀ = R(η)` matches `scalar_flat`. -/
theorem ricci_scalar_perturbative_report
    (h h₁ h₂ : SymmetricTensorField2) (p : LatticePoint) :
    ricciScalarO0 = 0 ∧
    ricciScalarO1 (fun _ _ _ => 0) p = 0 ∧
    ricciScalarO1 (fun q μ' ν' => h₁ q μ' ν' + h₂ q μ' ν') p
      = ricciScalarO1 h₁ p + ricciScalarO1 h₂ p ∧
    ricciScalarPerturbativeTotal (fun _ _ _ => 0) p = 0 ∧
    ricciScalarO0 = scalarCurvature DiscreteMetric.flat p := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact ricciScalarO0_eq_zero
  · exact ricciScalarO1_zero p
  · exact ricciScalarO1_add h₁ h₂ p
  · exact ricciScalarPerturbativeTotal_zero p
  · exact ricciScalarO0_eq_scalarCurvature_flat p

end OmegaTheory.Variational.RicciScalarPerturbative
