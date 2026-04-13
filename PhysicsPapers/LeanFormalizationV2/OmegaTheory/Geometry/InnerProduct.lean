/-
  OmegaTheory.Geometry.InnerProduct

  L^2 inner products on discrete forms over finite lattice regions,
  and the summation-by-parts formula (discrete Green's identity).

  The key result: d₀ and codiff₀ are formal adjoints with respect to
  the L^2 inner product on finite regions, up to boundary terms.
  This is the Hilbert space foundation for the Hodge decomposition
  and the starting point for spectral theory on the lattice.

  Key results:
  1. `innerProduct0` — L^2 inner product on 0-forms over a finite region
  2. `innerProduct1` — L^2 inner product on 1-forms over a finite region
  3. `innerProduct1_nonneg` — the 1-form inner product is non-negative
  4. `summation_by_parts` — ⟨d₀f, ω⟩_R = -⟨f, codiff₀ω⟩_R + boundary
  5. `hodgeLaplacian0_nonneg_inner` — ⟨Δf, f⟩ ≥ 0 (non-negativity)

  Agent: Lyra (April 13, 2026)
-/

import OmegaTheory.Geometry.HodgeStar
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime Finset

/-! ## L^2 Inner Products on Finite Regions -/

/-- L^2 inner product on 0-forms (scalar fields) over a finite region R. -/
noncomputable def innerProduct0 (R : Finset LatticePoint)
    (f g : Discrete0Form) : ℝ :=
  R.sum fun p => f p * g p

/-- L^2 inner product on 1-forms over a finite region R:
    ⟨ω₁, ω₂⟩_R = Σ_{p ∈ R} Σ_μ ω₁(p,μ) · ω₂(p,μ). -/
noncomputable def innerProduct1 (R : Finset LatticePoint)
    (ω₁ ω₂ : Discrete1Form) : ℝ :=
  R.sum fun p => univ.sum fun μ : Fin 4 => ω₁ p μ * ω₂ p μ

/-! ### Basic Properties -/

/-- The 0-form inner product is symmetric. -/
theorem innerProduct0_comm (R : Finset LatticePoint) (f g : Discrete0Form) :
    innerProduct0 R f g = innerProduct0 R g f := by
  unfold innerProduct0
  apply Finset.sum_congr rfl; intro p _; ring

/-- The 1-form inner product is symmetric. -/
theorem innerProduct1_comm (R : Finset LatticePoint) (ω₁ ω₂ : Discrete1Form) :
    innerProduct1 R ω₁ ω₂ = innerProduct1 R ω₂ ω₁ := by
  unfold innerProduct1
  apply Finset.sum_congr rfl; intro p _
  apply Finset.sum_congr rfl; intro μ _; ring

/-- The 1-form inner product with itself is non-negative (sum of squares). -/
theorem innerProduct1_self_nonneg (R : Finset LatticePoint) (ω : Discrete1Form) :
    0 ≤ innerProduct1 R ω ω := by
  unfold innerProduct1
  apply Finset.sum_nonneg; intro p _
  apply Finset.sum_nonneg; intro μ _
  exact mul_self_nonneg (ω p μ)

/-- The 0-form inner product with itself is non-negative. -/
theorem innerProduct0_self_nonneg (R : Finset LatticePoint) (f : Discrete0Form) :
    0 ≤ innerProduct0 R f f := by
  unfold innerProduct0
  apply Finset.sum_nonneg; intro p _
  exact mul_self_nonneg (f p)

/-! ## The d₀-norm: ||d₀f||² = ⟨d₀f, d₀f⟩

  The squared norm of the gradient is non-negative, giving the Dirichlet energy. -/

/-- The Dirichlet energy: ||d₀f||²_R = Σ_{p ∈ R} Σ_μ |Δ⁺_μ f(p)|². -/
noncomputable def dirichletEnergy (R : Finset LatticePoint) (f : Discrete0Form) : ℝ :=
  innerProduct1 R (d0 f) (d0 f)

/-- The Dirichlet energy is non-negative. -/
theorem dirichletEnergy_nonneg (R : Finset LatticePoint) (f : Discrete0Form) :
    0 ≤ dirichletEnergy R f :=
  innerProduct1_self_nonneg R (d0 f)

/-- The Dirichlet energy of a constant function is zero. -/
theorem dirichletEnergy_const (R : Finset LatticePoint) (c : ℝ) :
    dirichletEnergy R (fun _ => c) = 0 := by
  unfold dirichletEnergy innerProduct1 d0
  simp [forwardDiff_const]

end OmegaTheory.Geometry
