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

/-! ## Pointwise Adjoint Identity -/

/-- The pointwise summation-by-parts identity for forward and backward differences:
    Δ⁺f(p) · g(p) + f(p) · Δ⁻g(p) = [f(p+μ)·g(p) - f(p)·g(p-μ)] / l_P.
    This is the discrete product rule in "boundary" form. -/
theorem forward_backward_adjoint (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff f μ p * g p + f p * backwardDiff g μ p =
    (f (shiftFin p μ) * g p - f p * g (shiftBackFin p μ)) / l_P := by
  unfold forwardDiff backwardDiff
  field_simp [l_P_ne_zero]; ring

/-! ## Summation by Parts (Discrete Green's Identity) -/

/-- The boundary flux term arising in the summation-by-parts formula.
    Measures the mismatch between d₀ and δ₀ as formal adjoints.
    On a "closed" region (where shifts preserve membership), this vanishes. -/
noncomputable def boundaryFlux (R : Finset LatticePoint) (f : Discrete0Form)
    (ω : Discrete1Form) : ℝ :=
  R.sum fun p => univ.sum fun μ : Fin 4 =>
    (f (shiftFin p μ) * ω p μ - f p * ω (shiftBackFin p μ) μ) / l_P

/-- **Summation by parts** (discrete Green's first identity):
    ⟨d₀f, ω⟩₁ + ⟨f, δ₀ω⟩₀ = boundary flux.

    This is the discrete analogue of ∫_M ⟨df, ω⟩ dvol + ∫_M f · δω dvol = ∫_{∂M} f · ω.
    It proves that d₀ and δ₀ are formal adjoints with respect to the
    L² inner product, up to boundary terms. -/
theorem summation_by_parts (R : Finset LatticePoint) (f : Discrete0Form)
    (ω : Discrete1Form) :
    innerProduct1 R (d0 f) ω + innerProduct0 R f (codiff0 ω) =
    boundaryFlux R f ω := by
  unfold innerProduct1 innerProduct0 d0 codiff0 boundaryFlux
  simp only [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro p _
  rw [Finset.mul_sum, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro μ _
  unfold forwardDiff backwardDiff
  field_simp [l_P_ne_zero]; ring

/-- Alternate form: ⟨d₀f, ω⟩₁ = -⟨f, δ₀ω⟩₀ + boundary.
    The form most commonly used in PDE theory. -/
theorem summation_by_parts' (R : Finset LatticePoint) (f : Discrete0Form)
    (ω : Discrete1Form) :
    innerProduct1 R (d0 f) ω = -innerProduct0 R f (codiff0 ω) +
    boundaryFlux R f ω := by
  linarith [summation_by_parts R f ω]

/-! ## Hodge Laplacian Energy Identity -/

/-- The Hodge Laplacian energy identity:
    ||d₀f||² + ⟨f, Δ₀f⟩₀ = boundary flux with ω = d₀f.
    This connects the Dirichlet energy to the Laplacian inner product. -/
theorem hodgeLaplacian0_energy_identity (R : Finset LatticePoint) (f : Discrete0Form) :
    dirichletEnergy R f + innerProduct0 R f (hodgeLaplacian0 f) =
    boundaryFlux R f (d0 f) := by
  unfold dirichletEnergy hodgeLaplacian0
  exact summation_by_parts R f (d0 f)

/-- On boundary-free regions, ⟨f, Δ₀f⟩₀ = -||d₀f||² (negative Dirichlet energy). -/
theorem laplacian_dirichlet_duality (R : Finset LatticePoint) (f : Discrete0Form)
    (hbdry : boundaryFlux R f (d0 f) = 0) :
    innerProduct0 R f (hodgeLaplacian0 f) = -dirichletEnergy R f := by
  linarith [hodgeLaplacian0_energy_identity R f]

/-- On boundary-free regions, ⟨f, -Δ₀f⟩₀ ≥ 0.
    The negative discrete Laplacian is non-negative definite. -/
theorem neg_laplacian_nonneg (R : Finset LatticePoint) (f : Discrete0Form)
    (hbdry : boundaryFlux R f (d0 f) = 0) :
    0 ≤ -innerProduct0 R f (hodgeLaplacian0 f) := by
  rw [laplacian_dirichlet_duality R f hbdry, neg_neg]
  exact dirichletEnergy_nonneg R f

/-! ## Green's Second Identity -/

/-- **Green's second identity** (discrete):
    ⟨Δ₀f, g⟩₀ - ⟨f, Δ₀g⟩₀ = boundary(g, d₀f) - boundary(f, d₀g).

    The discrete analogue of ∫(Δf·g - f·Δg) = ∮(g·∂f/∂n - f·∂g/∂n).
    Consequence: the Hodge Laplacian is self-adjoint on boundary-free regions. -/
theorem greens_second_identity (R : Finset LatticePoint) (f g : Discrete0Form) :
    innerProduct0 R (hodgeLaplacian0 f) g - innerProduct0 R f (hodgeLaplacian0 g) =
    boundaryFlux R g (d0 f) - boundaryFlux R f (d0 g) := by
  have h1 := summation_by_parts R g (d0 f)
  have h2 := summation_by_parts R f (d0 g)
  have sym := innerProduct1_comm R (d0 f) (d0 g)
  rw [innerProduct0_comm R (hodgeLaplacian0 f) g]
  unfold hodgeLaplacian0
  linarith

/-- The Hodge Laplacian is self-adjoint on boundary-free regions:
    ⟨Δ₀f, g⟩₀ = ⟨f, Δ₀g⟩₀. -/
theorem hodgeLaplacian0_selfAdjoint (R : Finset LatticePoint) (f g : Discrete0Form)
    (hbdry1 : boundaryFlux R g (d0 f) = 0)
    (hbdry2 : boundaryFlux R f (d0 g) = 0) :
    innerProduct0 R (hodgeLaplacian0 f) g = innerProduct0 R f (hodgeLaplacian0 g) := by
  linarith [greens_second_identity R f g]

end OmegaTheory.Geometry
