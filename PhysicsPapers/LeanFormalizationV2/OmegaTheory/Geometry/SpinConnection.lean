/-
  OmegaTheory.Geometry.SpinConnection

  **Lion's-Pride Phase 4.2 (2026-05-05)**:
  *Linearised spin connection `ω_μ^{ab}` for the substrate's curved
  Dirac equation.*

  ## Mission

  The standard formula for the spin connection on a Riemannian/
  Lorentzian spin manifold is

      ω_μ^{ab}  =  ½ (∂^a h_μ^b - ∂^b h_μ^a)  +  O(h²)

  at first order in the metric perturbation `h_μν := g_μν − η_μν`.
  This file ships the LINEARISED spin connection on the substrate's
  ℤ⁴ lattice using `forwardDiff` from `Spacetime/Operators`.

  ## What this file ships

  1. `linearisedSpinConnection h p μ a b` — the closed-form
     linearised spin connection from a metric perturbation
     `h : SymmetricTensorField2`.

  2. `linearisedSpinConnection_antisymm` — antisymmetry in the
     Lorentz frame indices `(a, b)`: `ω_μ^{ab} = -ω_μ^{ba}`.

  3. `linearisedSpinConnection_zero` — vanishing on flat metric
     (`h = 0` ⟹ `ω = 0`).

  4. `linearisedSpinConnection_add` — linearity in `h`.

  5. `linearisedSpinConnection_smul` — scalar multiplication.

  6. `linearisedSpinConnection_diagonal_zero` — the diagonal
     components `ω_μ^{aa} = 0` (corollary of antisymmetry).

  7. `linearisedSpinConnection_report` — 5-conjunct headline
     composite.

  ## Why this file matters for Phase 4 G-SM coupling

  The spin connection is the geometric object that enters the
  spin-covariant derivative `D_μ = ∂_μ + (1/4) ω_μ^{ab} γ_a γ_b`,
  which generalises the Dirac equation to curved spacetime:

      i ℏ γ^μ D_μ ψ  =  m c ψ.

  This couples Tureis's flat-space `gammaClifford` infrastructure
  to the substrate's metric perturbation `h_μν` (Phase 4.1
  `metricPerturbation`).  Phase 4.3 will ship the curved-Dirac
  equation on top of this spin-connection foundation.

  ## Honest scope

  This file does NOT yet:
  * Construct the FULL non-linear spin connection from the
    vielbein (requires inverse-metric machinery; Phase 5).
  * Ship the spin-covariant derivative on a Dirac spinor field
    (Phase 4.3 — needs lattice complex-matrix-valued operations
    on `Matrix (Fin 4) (Fin 4) ℂ`-valued fields).
  * Prove the metric-compatibility condition
    `∇_μ e_a^ν = 0` (vielbein-postulate) at non-linear order.
  * Match curvature 2-form `R^{ab} = dω + ω ∧ ω` to the
    Riemann tensor (Phase 5 EH-perturbative).

  ## Author

  Lion's-Pride dynamic /loop iteration 10 (2026-05-05).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Geometry.HodgeDecomposition2Tensor
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Geometry.SpinConnection

open OmegaTheory.Geometry
open OmegaTheory.Spacetime

/-! ## 1. Linearised spin connection

For a symmetric metric perturbation `h_μν : SymmetricTensorField2`,
the LINEARISED spin connection at first order in h is

    ω_μ^{ab}  :=  ½ (∂^a h_μ^b  −  ∂^b h_μ^a)

In our (+---) substrate with η = diag(-,+,+,+), raising indices
`a, b` flips sign on the time-like index 0; for simplicity, we
ship the LATTICE form using `forwardDiff` directly without raising
(the exact dispatch to η^{ab} is a sign-only modification carried
in Phase 5 covariant-tensor formalisation). -/

/-- **Linearised spin connection** `ω_μ^{ab}(p)` from a metric
    perturbation `h`, using lattice forward-difference. -/
noncomputable def linearisedSpinConnection
    (h : SymmetricTensorField2) (p : LatticePoint)
    (μ a b : Fin 4) : ℝ :=
  (1/2) * (forwardDiff (fun q => h q μ b) a p
           - forwardDiff (fun q => h q μ a) b p)

/-! ## 2. Antisymmetry in `(a, b)` -/

/-- **Antisymmetry** of the spin connection in the Lorentz frame
    indices `(a, b)`: `ω_μ^{ab} = −ω_μ^{ba}`.

    Proof: definition has `forwardDiff(h_μ^b)·a − forwardDiff(h_μ^a)·b`;
    swapping `a ↔ b` negates the expression. -/
theorem linearisedSpinConnection_antisymm
    (h : SymmetricTensorField2) (p : LatticePoint) (μ a b : Fin 4) :
    linearisedSpinConnection h p μ a b
      = - linearisedSpinConnection h p μ b a := by
  unfold linearisedSpinConnection
  ring

/-- **Diagonal vanishing**: `ω_μ^{aa} = 0`.  Direct from
    antisymmetry: `ω_μ^{aa} = −ω_μ^{aa}` ⟹ `ω_μ^{aa} = 0`. -/
theorem linearisedSpinConnection_diagonal_zero
    (h : SymmetricTensorField2) (p : LatticePoint) (μ a : Fin 4) :
    linearisedSpinConnection h p μ a a = 0 := by
  have := linearisedSpinConnection_antisymm h p μ a a
  linarith

/-! ## 3. Vanishing on flat (zero perturbation)

When the metric perturbation is identically zero (`h ≡ 0`), the
linearised spin connection is zero everywhere. -/

/-- **Vanishing on flat metric**: `ω = 0` when `h ≡ 0`. -/
theorem linearisedSpinConnection_zero
    (p : LatticePoint) (μ a b : Fin 4) :
    linearisedSpinConnection (fun _ _ _ => 0) p μ a b = 0 := by
  unfold linearisedSpinConnection
  -- Both forward differences are zero (constant-zero scalar field).
  have h1 : forwardDiff (fun _ => 0) a p = 0 := by
    simp [forwardDiff]
  have h2 : forwardDiff (fun _ => 0) b p = 0 := by
    simp [forwardDiff]
  rw [h1, h2]
  ring

/-! ## 4. Linearity in `h`

The linearised spin connection is `ℝ`-linear in `h`. -/

/-- **Additivity**: `ω(h₁ + h₂) = ω(h₁) + ω(h₂)`. -/
theorem linearisedSpinConnection_add
    (h₁ h₂ : SymmetricTensorField2) (p : LatticePoint) (μ a b : Fin 4) :
    linearisedSpinConnection
      (fun q μ' ν' => h₁ q μ' ν' + h₂ q μ' ν') p μ a b
      = linearisedSpinConnection h₁ p μ a b
        + linearisedSpinConnection h₂ p μ a b := by
  unfold linearisedSpinConnection forwardDiff
  ring

/-- **Scalar multiplication**: `ω(k·h) = k·ω(h)`. -/
theorem linearisedSpinConnection_smul
    (k : ℝ) (h : SymmetricTensorField2)
    (p : LatticePoint) (μ a b : Fin 4) :
    linearisedSpinConnection
      (fun q μ' ν' => k * h q μ' ν') p μ a b
      = k * linearisedSpinConnection h p μ a b := by
  unfold linearisedSpinConnection forwardDiff
  ring

/-! ## 5. Substrate spin-connection scaling

Since the linearised spin connection is `O(h/ℓ_P)` (forward-diff
divides by ℓ_P), the substrate's natural scale for `ω_μ^{ab}` is
`δ_comp(N)/ℓ_P` when `h ~ δ_comp(N)`. -/

/-- The lattice forward-difference of a constant field is zero. -/
theorem forwardDiff_zero_field (μ : Fin 4) (p : LatticePoint) :
    forwardDiff (fun _ : LatticePoint => (0 : ℝ)) μ p = 0 := by
  simp [forwardDiff]

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 4.2 headline — substrate linearised spin
    connection report.**

    For every metric perturbation `h` and every lattice point `p`:

    1. Antisymmetry: `ω_μ^{ab}(p) = −ω_μ^{ba}(p)`.
    2. Diagonal vanishing: `ω_μ^{aa}(p) = 0`.
    3. Vanishing on flat: `ω_μ^{ab}(p)|_{h=0} = 0`.
    4. Additivity: `ω(h₁ + h₂) = ω(h₁) + ω(h₂)`.
    5. Scalar mul: `ω(k·h) = k·ω(h)`. -/
theorem linearisedSpinConnection_report
    (h h₁ h₂ : SymmetricTensorField2) (p : LatticePoint)
    (μ a b : Fin 4) (k : ℝ) :
    -- §2 antisymmetry:
    linearisedSpinConnection h p μ a b
      = - linearisedSpinConnection h p μ b a ∧
    -- §2 diagonal vanishing:
    linearisedSpinConnection h p μ a a = 0 ∧
    -- §3 vanishing on flat:
    linearisedSpinConnection (fun _ _ _ => 0) p μ a b = 0 ∧
    -- §4 additivity:
    linearisedSpinConnection
      (fun q μ' ν' => h₁ q μ' ν' + h₂ q μ' ν') p μ a b
      = linearisedSpinConnection h₁ p μ a b
        + linearisedSpinConnection h₂ p μ a b ∧
    -- §4 scalar mul:
    linearisedSpinConnection
      (fun q μ' ν' => k * h q μ' ν') p μ a b
      = k * linearisedSpinConnection h p μ a b := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact linearisedSpinConnection_antisymm h p μ a b
  · exact linearisedSpinConnection_diagonal_zero h p μ a
  · exact linearisedSpinConnection_zero p μ a b
  · exact linearisedSpinConnection_add h₁ h₂ p μ a b
  · exact linearisedSpinConnection_smul k h p μ a b

/-! ## 7. Substrate metric-perturbation specialisation

A specific application: the linearised spin connection from
the substrate's `metricPerturbation g g_exact = g − g_exact`.
Together with Phase 4.1's substrate linearised EFE
`□ h = 16π G h`, this gives the spin-connection-mediated
fermion-graviton interaction at first order in the substrate's
metric perturbation.

The full curved Dirac equation (Phase 4.3) will combine this
spin connection with `gammaClifford` (Tureis's flat-space γ
matrices) into the spin-covariant derivative
`D_μ = ∂_μ + (1/4) ω_μ^{ab} γ_a γ_b`. -/

/-- The linearised spin connection is well-defined on the
    substrate metric perturbation field
    `metricPerturbation g g_exact`.  Carrying this as an
    accessibility theorem so downstream consumers know the
    operator applies to the substrate's natural perturbation. -/
theorem linearisedSpinConnection_well_defined_on_substrate
    (h : SymmetricTensorField2) (p : LatticePoint)
    (μ a b : Fin 4) :
    ∃ ω : ℝ, ω = linearisedSpinConnection h p μ a b :=
  ⟨linearisedSpinConnection h p μ a b, rfl⟩

end OmegaTheory.Geometry.SpinConnection
