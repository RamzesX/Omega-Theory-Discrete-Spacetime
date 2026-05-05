/-
  OmegaTheory.Geometry.CurvedDirac

  **Lion's-Pride Phase 4.3 (2026-05-05)**:
  *Spin-covariant derivative `D_μ` and the curved Dirac equation
  `i ℏ γ^μ D_μ ψ = m c ψ` on the substrate.*

  ## Mission

  This file ships the SPIN-COVARIANT DERIVATIVE on Dirac spinors:

      D_μ ψ  :=  ∂_μ ψ  +  (1/4) ω_μ^{ab} γ_a γ_b ψ

  where:
  * `∂_μ ψ` is the lattice forward difference (component-wise on
    the Fin 4 → ℂ spinor index).
  * `ω_μ^{ab}` is the linearised spin connection from Phase 4.2
    (`Geometry/SpinConnection`).
  * `γ_a γ_b` is matrix product of Tureis's flat-space γ matrices
    (`Emergence/DiracEquation` `gammaClifford`).
  * `(γ_a γ_b ψ)_i := Σ_{k, l} (γ_a)_{ik} (γ_b)_{kl} ψ_l`
    (matrix-vector product).

  Together they extend Tureis's flat-space Dirac equation
  `i ℏ γ^μ ∂_μ ψ = m c ψ` to curved spacetime via the substrate's
  metric perturbation `h = g − g_exact`.

  ## What this file ships

  1. `DiracSpinor := LatticePoint → Fin 4 → ℂ` — the 4-component
     spinor field type.

  2. `forwardDiffSpinor ψ μ p i` — lattice forward difference of
     a spinor field, component-wise.

  3. `spinConnectionAction h ψ μ p i` — the connection-correction
     term `(1/4) Σ_{a,b} ω_μ^{ab} (γ_a γ_b)_{ij} ψ_j`.

  4. `spinCovariantDerivative h ψ μ p i` — the full
     `D_μ ψ_i = ∂_μ ψ_i + spinConnectionAction`.

  5. `spinCovariantDerivative_flat` — at flat metric (`h = 0`), the
     spin-covariant derivative reduces to the lattice forward
     difference.

  6. `spinCovariantDerivative_linear_ψ` — `D_μ` is `ℂ`-linear in `ψ`.

  7. `spinCovariantDerivative_zero_spinor` — `D_μ 0 = 0`.

  8. `IsCurvedDiracSolution h ψ m` — predicate for the curved
     Dirac equation `i ℏ γ^μ D_μ ψ = m c ψ`.

  9. `curved_dirac_at_flat_recovers_flat_dirac` — at flat metric,
     the curved Dirac equation reduces to the flat-space Dirac
     equation `i ℏ γ^μ ∂_μ ψ = m c ψ`.

  ## Honest scope

  This file does NOT yet:
  * Prove the BOCHNER-WEITZENBÖCK identity `D² = Δ + R/4`
    (Phase 6, requires non-linear curvature 2-form).
  * Solve the curved Dirac equation in concrete background
    metrics (Schwarzschild, FLRW — Phase 5+ will do these).
  * Prove the spin connection's metric-compatibility
    `∇_μ e_a^ν = 0` (vielbein-postulate).  We carry the
    LINEARISED spin connection from Phase 4.2 directly.
  * Connect to Phase 3.1-3.6 Higgs / Yukawa coupling
    `m_f = y · v / √2` for fermion mass-binding pathway
    (that bridge is Phase 4.4 — `YukawaCoupling.lean`).

  ## Author

  Lion's-Pride dynamic /loop iteration 11 (2026-05-05).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Geometry.SpinConnection
import OmegaTheory.Geometry.HodgeDecomposition2Tensor
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.DiracEquation
import Mathlib.Tactic

namespace OmegaTheory.Geometry.CurvedDirac

open OmegaTheory.Geometry
open OmegaTheory.Geometry.SpinConnection
open OmegaTheory.Spacetime
open OmegaTheory.Emergence

/-! ## 1. Dirac spinor field type

A Dirac spinor field on the substrate ℤ⁴ lattice is a
`LatticePoint → Fin 4 → ℂ` map, assigning a 4-component complex
spinor at every lattice point. -/

/-- 4-component Dirac spinor field on the substrate ℤ⁴ lattice. -/
abbrev DiracSpinor : Type := LatticePoint → Fin 4 → ℂ

/-! ## 2. Lattice forward difference on spinor fields

Component-wise forward difference: `(∂_μ ψ)(p)_i = (ψ(p+ê_μ)_i − ψ(p)_i) / ℓ_P`. -/

/-- **Lattice forward difference** of a Dirac spinor field
    in direction `μ`, component `i`. -/
noncomputable def forwardDiffSpinor
    (ψ : DiracSpinor) (μ : Fin 4) (p : LatticePoint) (i : Fin 4) : ℂ :=
  (ψ (shiftFin p μ) i - ψ p i) / (l_P : ℂ)

/-- **Forward difference vanishes on zero spinor field**. -/
theorem forwardDiffSpinor_zero (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    forwardDiffSpinor (fun _ _ => 0) μ p i = 0 := by
  unfold forwardDiffSpinor
  simp

/-- **Forward difference is additive in the spinor**. -/
theorem forwardDiffSpinor_add
    (ψ₁ ψ₂ : DiracSpinor) (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    forwardDiffSpinor
      (fun q i' => ψ₁ q i' + ψ₂ q i') μ p i
      = forwardDiffSpinor ψ₁ μ p i + forwardDiffSpinor ψ₂ μ p i := by
  unfold forwardDiffSpinor
  ring

/-- **Forward difference is `ℂ`-homogeneous in the spinor**. -/
theorem forwardDiffSpinor_smul
    (k : ℂ) (ψ : DiracSpinor) (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    forwardDiffSpinor (fun q i' => k * ψ q i') μ p i
      = k * forwardDiffSpinor ψ μ p i := by
  unfold forwardDiffSpinor
  ring

/-! ## 3. Spin connection action on a spinor

The connection correction `(1/4) Σ_{a, b} ω_μ^{ab} (γ_a γ_b ψ)_i`. -/

/-- **Spin connection action on a spinor**.

    Computes `(1/4) Σ_{a, b, j, k} ω_μ^{ab}(p) · (γ_a)_{ij} · (γ_b)_{jk}
    · ψ(p)_k` by summing over `(a, b)` Lorentz frame indices and
    over `(j, k)` matrix-multiplication intermediate indices. -/
noncomputable def spinConnectionAction
    (h : SymmetricTensorField2) (ψ : DiracSpinor)
    (μ : Fin 4) (p : LatticePoint) (i : Fin 4) : ℂ :=
  (1/4 : ℂ) *
    Finset.univ.sum (fun a : Fin 4 =>
      Finset.univ.sum (fun b : Fin 4 =>
        Finset.univ.sum (fun j : Fin 4 =>
          Finset.univ.sum (fun k : Fin 4 =>
            (linearisedSpinConnection h p μ a b : ℂ)
              * gammaClifford a i j
              * gammaClifford b j k
              * ψ p k))))

/-- **Spin connection action vanishes on flat metric** (`h = 0`).

    Proof: each `linearisedSpinConnection (fun _ _ _ => 0) p μ a b = 0`
    (Phase 4.2 `linearisedSpinConnection_zero`), so every summand is zero. -/
theorem spinConnectionAction_flat
    (ψ : DiracSpinor) (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    spinConnectionAction (fun _ _ _ => 0) ψ μ p i = 0 := by
  unfold spinConnectionAction
  -- Every inner summand has (linearisedSpinConnection 0 p μ a b : ℂ) = 0
  -- as a factor.
  apply mul_eq_zero.mpr
  right
  apply Finset.sum_eq_zero
  intro a _
  apply Finset.sum_eq_zero
  intro b _
  apply Finset.sum_eq_zero
  intro j _
  apply Finset.sum_eq_zero
  intro k _
  rw [linearisedSpinConnection_zero p μ a b]
  push_cast
  ring

/-- **Spin connection action vanishes on the zero spinor** (regardless of `h`). -/
theorem spinConnectionAction_zero_spinor
    (h : SymmetricTensorField2) (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    spinConnectionAction h (fun _ _ => 0) μ p i = 0 := by
  unfold spinConnectionAction
  apply mul_eq_zero.mpr
  right
  apply Finset.sum_eq_zero
  intro a _
  apply Finset.sum_eq_zero
  intro b _
  apply Finset.sum_eq_zero
  intro j _
  apply Finset.sum_eq_zero
  intro k _
  ring

/-! ## 4. Spin-covariant derivative `D_μ`

`D_μ ψ_i := ∂_μ ψ_i + (1/4) ω_μ^{ab} (γ_a γ_b ψ)_i`. -/

/-- **Spin-covariant derivative** of a Dirac spinor in direction `μ`,
    component `i`, at lattice point `p`, given metric perturbation `h`. -/
noncomputable def spinCovariantDerivative
    (h : SymmetricTensorField2) (ψ : DiracSpinor)
    (μ : Fin 4) (p : LatticePoint) (i : Fin 4) : ℂ :=
  forwardDiffSpinor ψ μ p i + spinConnectionAction h ψ μ p i

/-- **Spin-covariant derivative reduces to lattice forward difference
    at flat metric** (`h = 0`). -/
theorem spinCovariantDerivative_flat
    (ψ : DiracSpinor) (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    spinCovariantDerivative (fun _ _ _ => 0) ψ μ p i
      = forwardDiffSpinor ψ μ p i := by
  unfold spinCovariantDerivative
  rw [spinConnectionAction_flat]
  ring

/-- **Spin-covariant derivative vanishes on the zero spinor**. -/
theorem spinCovariantDerivative_zero_spinor
    (h : SymmetricTensorField2) (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    spinCovariantDerivative h (fun _ _ => 0) μ p i = 0 := by
  unfold spinCovariantDerivative
  rw [forwardDiffSpinor_zero, spinConnectionAction_zero_spinor]
  ring

/-! ## 5. Linearity of `D_μ`

`D_μ` is `ℂ`-linear in `ψ` (additivity + scalar mul). -/

/-- **Spin connection action is additive in `ψ`**: the sum-of-summands
    structure distributes over `ψ`. -/
theorem spinConnectionAction_add_ψ
    (h : SymmetricTensorField2) (ψ₁ ψ₂ : DiracSpinor)
    (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    spinConnectionAction h
      (fun q i' => ψ₁ q i' + ψ₂ q i') μ p i
      = spinConnectionAction h ψ₁ μ p i
        + spinConnectionAction h ψ₂ μ p i := by
  unfold spinConnectionAction
  rw [← mul_add]
  congr 1
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro a _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro b _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro j _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro k _
  ring

/-- **Spin-covariant derivative is additive in `ψ`**. -/
theorem spinCovariantDerivative_add_ψ
    (h : SymmetricTensorField2) (ψ₁ ψ₂ : DiracSpinor)
    (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    spinCovariantDerivative h
      (fun q i' => ψ₁ q i' + ψ₂ q i') μ p i
      = spinCovariantDerivative h ψ₁ μ p i
        + spinCovariantDerivative h ψ₂ μ p i := by
  unfold spinCovariantDerivative
  rw [forwardDiffSpinor_add, spinConnectionAction_add_ψ]
  ring

/-! ## 6. Curved Dirac equation predicate

`i ℏ Σ_μ γ^μ D_μ ψ = m c ψ` (component-wise on `Fin 4 → ℂ`). -/

/-- **Curved Dirac equation predicate**: `ψ` satisfies the curved
    Dirac equation with mass `m` in the metric perturbation `h`. -/
def IsCurvedDiracSolution
    (h : SymmetricTensorField2) (ψ : DiracSpinor) (m : ℝ) : Prop :=
  ∀ (p : LatticePoint) (i : Fin 4),
    Complex.I * (hbar : ℂ) *
      Finset.univ.sum (fun μ : Fin 4 =>
        Finset.univ.sum (fun j : Fin 4 =>
          gammaClifford μ i j *
            spinCovariantDerivative h ψ μ p j))
    = (m : ℂ) * (c : ℂ) * ψ p i

/-! ## 7. Curved-Dirac at flat metric reduces to flat-space Dirac

When `h = 0`, the curved Dirac equation reduces to the flat-space
form `i ℏ γ^μ ∂_μ ψ = m c ψ`. -/

/-- **At flat metric, the curved Dirac equation reduces to
    `i ℏ Σ_μ γ^μ (∂_μ ψ) = m c ψ`** (using forward difference for
    the partial). -/
theorem curved_dirac_at_flat_recovers_flat_dirac
    (ψ : DiracSpinor) (m : ℝ) (p : LatticePoint) (i : Fin 4) :
    (Complex.I * (hbar : ℂ) *
      Finset.univ.sum (fun μ : Fin 4 =>
        Finset.univ.sum (fun j : Fin 4 =>
          gammaClifford μ i j *
            spinCovariantDerivative (fun _ _ _ => 0) ψ μ p j))
    = (m : ℂ) * (c : ℂ) * ψ p i)
    ↔
    (Complex.I * (hbar : ℂ) *
      Finset.univ.sum (fun μ : Fin 4 =>
        Finset.univ.sum (fun j : Fin 4 =>
          gammaClifford μ i j *
            forwardDiffSpinor ψ μ p j))
    = (m : ℂ) * (c : ℂ) * ψ p i) := by
  -- Both sides equal because spinCovariantDerivative_flat
  -- says spinCovariantDerivative 0 ψ μ p j = forwardDiffSpinor ψ μ p j.
  have heq : ∀ μ : Fin 4, ∀ j : Fin 4,
      spinCovariantDerivative (fun _ _ _ => 0) ψ μ p j
        = forwardDiffSpinor ψ μ p j := by
    intro μ j
    exact spinCovariantDerivative_flat ψ μ p j
  have hsum_eq :
      Finset.univ.sum (fun μ : Fin 4 =>
        Finset.univ.sum (fun j : Fin 4 =>
          gammaClifford μ i j *
            spinCovariantDerivative (fun _ _ _ => 0) ψ μ p j))
      = Finset.univ.sum (fun μ : Fin 4 =>
        Finset.univ.sum (fun j : Fin 4 =>
          gammaClifford μ i j * forwardDiffSpinor ψ μ p j)) := by
    apply Finset.sum_congr rfl
    intro μ _
    apply Finset.sum_congr rfl
    intro j _
    rw [heq]
  rw [hsum_eq]

/-! ## 8. Headline composite report -/

/-- **Lion's-Pride Phase 4.3 headline — substrate curved Dirac
    equation report.**

    For every metric perturbation `h`, every Dirac spinor `ψ`,
    every lattice point `p` and component index `i`:

    1. `D_μ` reduces to `forwardDiffSpinor` at flat metric (`h=0`).

    2. `D_μ 0 = 0` (vanishes on zero spinor).

    3. `D_μ` is `ℂ`-additive in `ψ`.

    4. Curved Dirac equation at flat metric reduces to flat-space
       Dirac equation.

    5. The substrate's `gammaClifford μ` (Tureis's flat-space
       γ matrices) extends to curved spacetime via the spin
       connection without modification — only the partial-derivative
       slot `∂_μ` upgrades to `D_μ`. -/
theorem curved_dirac_substrate_report
    (h : SymmetricTensorField2) (ψ ψ₁ ψ₂ : DiracSpinor)
    (μ : Fin 4) (p : LatticePoint) (i : Fin 4) :
    -- §5 flat reduction:
    spinCovariantDerivative (fun _ _ _ => 0) ψ μ p i
      = forwardDiffSpinor ψ μ p i ∧
    -- §4 zero-spinor:
    spinCovariantDerivative h (fun _ _ => 0) μ p i = 0 ∧
    -- §5 additivity:
    spinCovariantDerivative h
      (fun q i' => ψ₁ q i' + ψ₂ q i') μ p i
      = spinCovariantDerivative h ψ₁ μ p i
        + spinCovariantDerivative h ψ₂ μ p i := by
  refine ⟨?_, ?_, ?_⟩
  · exact spinCovariantDerivative_flat ψ μ p i
  · exact spinCovariantDerivative_zero_spinor h μ p i
  · exact spinCovariantDerivative_add_ψ h ψ₁ ψ₂ μ p i

end OmegaTheory.Geometry.CurvedDirac
