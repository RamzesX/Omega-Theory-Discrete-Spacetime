/-
  OmegaTheory.Geometry.StructureEquation

  Cartan structure equation and differential Bianchi identity for the
  discrete Planck-scale lattice.

  Main results:
  1. `curvatureForm_eq_riemannForward` — the curvature 2-form Ω = dω + ω∧ω
     equals the forward-difference Riemann tensor (EXACT).
  2. `curvatureForm_eq_riemann_add_correction` — Ω differs from the standard
     (symmetric-difference) Riemann tensor by an explicit O(l_P) correction.
  3. `d2_dGL1_zero` — d²=0 for gl(4,R)-valued forms (from DiscreteForms.d2_comp_d1).
  4. `triple_wedge_cancel` — ω∧(ω∧ω) = (ω∧ω)∧ω (same-point algebra).
  5. `differential_bianchi_flat` — D_ω(Ω) = 0 for flat metric (exact).
  6. Bounded differential Bianchi infrastructure.

  The key insight: the curvature 2-form (defined via forwardDiff in the DEC)
  and the Riemann tensor (defined via symmetricDiff in the curvature module)
  use different discrete derivative operators. The bridge identity
  `forwardDiff = symmetricDiff + (l_P/2) * secondDeriv` (Operators.lean)
  gives the exact correction formula.

  Agent: Lyra (April 13, 2026)
-/

import OmegaTheory.Geometry.WedgeProduct
import OmegaTheory.Geometry.Curvature
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime

/-! ## Section A: Forward-Difference Riemann Tensor

  The same formula as `riemannTensor` but using `forwardDiff` instead of
  `symmetricDiff` (via `christoffelDerivative`). This is what `curvatureForm`
  actually computes. -/

/-- Forward-difference Riemann tensor:
    R_fwd^ρ_{σμν} = Δ⁺_μ Γ^ρ_{νσ} - Δ⁺_ν Γ^ρ_{μσ}
                   + Σ_λ Γ^ρ_{μλ} Γ^λ_{νσ} - Σ_λ Γ^ρ_{νλ} Γ^λ_{μσ}. -/
noncomputable def riemannForward (g : DiscreteMetric) (ρ σ μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  forwardDiff (fun q => christoffelSymbol g ρ ν σ q) μ p -
  forwardDiff (fun q => christoffelSymbol g ρ μ σ q) ν p +
  Finset.univ.sum (fun l => christoffelSymbol g ρ μ l p * christoffelSymbol g l ν σ p) -
  Finset.univ.sum (fun l => christoffelSymbol g ρ ν l p * christoffelSymbol g l μ σ p)

/-- The curvature 2-form equals the forward-difference Riemann tensor.
    This is the Cartan structure equation: Ω^ρ_σ(p,μ,ν) = R_fwd^ρ_{σμν}(p). -/
theorem curvatureForm_eq_riemannForward (g : DiscreteMetric) (ρ σ : Fin 4)
    (p : LatticePoint) (μ ν : Fin 4) :
    curvatureForm g ρ σ p μ ν = riemannForward g ρ σ μ ν p := by
  unfold curvatureForm dGL1 d1 connectionForm wedgeGL riemannForward
  simp only [Finset.sum_sub_distrib]
  ring

/-- Forward-difference Riemann is antisymmetric in the last two indices. -/
theorem riemannForward_antisym (g : DiscreteMetric) (ρ σ μ ν : Fin 4)
    (p : LatticePoint) :
    riemannForward g ρ σ μ ν p = -riemannForward g ρ σ ν μ p := by
  unfold riemannForward; linarith

/-- Forward-difference Riemann vanishes for flat metric. -/
theorem riemannForward_flat (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannForward DiscreteMetric.flat ρ σ μ ν p = 0 := by
  unfold riemannForward
  simp [christoffel_flat, forwardDiff_const]

/-! ## Section B: Correction Formula

  The exact relationship between the two curvature definitions:
  R_fwd = R_sym + (l_P/2) · correction. -/

/-- The O(l_P) correction between forward-difference and symmetric-difference
    Riemann tensors. Each christoffelDerivative picks up a secondDeriv term. -/
noncomputable def curvatureCorrection (g : DiscreteMetric) (ρ σ μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  (l_P / 2) * (secondDeriv (fun q => christoffelSymbol g ρ ν σ q) μ p -
                secondDeriv (fun q => christoffelSymbol g ρ μ σ q) ν p)

/-- The forward-difference Riemann equals the standard Riemann plus correction:
    R_fwd = R + (l_P/2) · (∂²_μ Γ_{νσ} - ∂²_ν Γ_{μσ}). -/
theorem riemannForward_eq_riemann_add_correction (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannForward g ρ σ μ ν p =
    riemannTensor g ρ σ μ ν p + curvatureCorrection g ρ σ μ ν p := by
  unfold riemannForward riemannTensor christoffelDerivative curvatureCorrection
  have h1 := forwardDiff_eq_symmetricDiff_add
    (fun q => christoffelSymbol g ρ ν σ q) μ p
  have h2 := forwardDiff_eq_symmetricDiff_add
    (fun q => christoffelSymbol g ρ μ σ q) ν p
  linarith

/-- The curvature 2-form equals the standard Riemann tensor plus correction:
    Ω^ρ_σ(p,μ,ν) = R^ρ_{σμν}(p) + (l_P/2) · correction(p). -/
theorem curvatureForm_eq_riemann_add_correction (g : DiscreteMetric)
    (ρ σ : Fin 4) (p : LatticePoint) (μ ν : Fin 4) :
    curvatureForm g ρ σ p μ ν =
    riemannTensor g ρ σ μ ν p + curvatureCorrection g ρ σ μ ν p := by
  rw [curvatureForm_eq_riemannForward]
  exact riemannForward_eq_riemann_add_correction g ρ σ μ ν p

/-- The correction is antisymmetric in the form indices. -/
theorem curvatureCorrection_antisymmetric (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    curvatureCorrection g ρ σ μ ν p = -curvatureCorrection g ρ σ ν μ p := by
  unfold curvatureCorrection; ring

/-- The correction vanishes for flat metric. -/
theorem curvatureCorrection_flat (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    curvatureCorrection DiscreteMetric.flat ρ σ μ ν p = 0 := by
  unfold curvatureCorrection secondDeriv
  simp [christoffel_flat]

/-! ## Section C: Exact Structural Results for Bianchi -/

/-- d²=0 for gl(4,R)-valued forms: d₂(d₁(ω^ρ_σ)) = 0.
    Immediate from `d2_comp_d1` applied fiberwise. -/
theorem d2_dGL1_zero (ω : GLValued1Form) (ρ σ : Fin 4)
    (p : LatticePoint) (μ ν α : Fin 4) :
    d2 (dGL1 ω ρ σ) p μ ν α = 0 := by
  unfold dGL1
  exact d2_comp_d1 (ω ρ σ) p μ ν α

/-- The differential Bianchi identity holds exactly for flat metric:
    D_ω(Ω) = 0 when g = η (Minkowski). -/
theorem differential_bianchi_flat (ρ σ : Fin 4)
    (p : LatticePoint) (μ ν α : Fin 4) :
    covariantExtDeriv (connectionForm DiscreteMetric.flat)
      (curvatureForm DiscreteMetric.flat) ρ σ p μ ν α = 0 := by
  unfold covariantExtDeriv d2 wedgeGL12 wedgeGL21
  simp [curvatureForm_flat, connectionForm_flat, forwardDiff_const]

/-! ### Triple Wedge Identity

  ω ∧ (ω ∧ ω) = (ω ∧ ω) ∧ ω for gl(4,R)-valued 1-forms.
  This is a purely algebraic identity at a single lattice point — no shifts,
  no derivatives. It corresponds to associativity of matrix multiplication
  combined with the alternating structure of 3-form indices. -/

/-- The triple wedge identity: wedgeGL12(ω, wedgeGL(ω,ω)) = wedgeGL21(wedgeGL(ω,ω), ω).
    Both sides compute the same triple sum Σ_{l,m} ω^ρ_l · ω^l_m · ω^m_σ
    with the same alternating sign pattern in (μ,ν,α). -/
theorem triple_wedge_cancel (ω : GLValued1Form) (ρ σ : Fin 4)
    (p : LatticePoint) (μ ν α : Fin 4) :
    wedgeGL12 ω (wedgeGL ω ω) ρ σ p μ ν α =
    wedgeGL21 (wedgeGL ω ω) ω ρ σ p μ ν α := by
  simp only [wedgeGL12, wedgeGL21, wedgeGL]
  -- Push products inside sums: a * Σ_l f(l) → Σ_l a * f(l) and (Σ_l f(l)) * b → Σ_l f(l) * b
  simp_rw [Finset.mul_sum, Finset.sum_mul]
  -- Collapse all additions/subtractions of sums into single double sums
  simp only [← Finset.sum_sub_distrib, ← Finset.sum_add_distrib]
  -- Swap summation order: Σ_x Σ_l f(x,l) = Σ_l Σ_x f(x,l) = Σ_x Σ_l f(l,x)
  rw [Finset.sum_comm]
  -- After renaming bound variables, summands match by ring
  apply Finset.sum_congr rfl; intro x _
  apply Finset.sum_congr rfl; intro l _
  ring

/-! ### Leibniz Defect

  The discrete product rule shifts one factor: Δ⁺(fg)(p) = f(p)·Δ⁺g(p) + Δ⁺f(p)·g(p+).
  The defect from the "unshifted" Leibniz rule is exactly l_P · Δ⁺f · Δ⁺g. -/

/-- The shifted evaluation satisfies: f(p+e_μ) = f(p) + l_P · Δ⁺f(p). -/
theorem shifted_eq_plus_lP_forwardDiff (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    f (shiftFin p μ) = f p + l_P * forwardDiff f μ p := by
  unfold forwardDiff
  field_simp [l_P_ne_zero]
  ring

/-- The Leibniz defect: the discrete product rule minus the unshifted version
    equals l_P · Δ⁺f · Δ⁺g. -/
theorem forwardDiff_leibniz_defect (f g : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff (fun q => f q * g q) μ p -
    (f p * forwardDiff g μ p + forwardDiff f μ p * g p) =
    l_P * forwardDiff f μ p * forwardDiff g μ p := by
  have hmul : forwardDiff (fun q => f q * g q) μ p =
    f p * forwardDiff g μ p + forwardDiff f μ p * g (shiftFin p μ) := by
    unfold forwardDiff; field_simp [l_P_ne_zero]; ring
  rw [hmul, shifted_eq_plus_lP_forwardDiff g μ p]
  ring

/-- Bound on the Leibniz defect: |defect| ≤ l_P · M_f · M_g. -/
theorem forwardDiff_leibniz_defect_bound (f g : ScalarField) (μ : Fin 4)
    (p : LatticePoint) (Mf Mg : ℝ) (hMf : 0 ≤ Mf) (_hMg : 0 ≤ Mg)
    (hf : |forwardDiff f μ p| ≤ Mf)
    (hg : |forwardDiff g μ p| ≤ Mg) :
    |forwardDiff (fun q => f q * g q) μ p -
     (f p * forwardDiff g μ p + forwardDiff f μ p * g p)| ≤
    l_P * Mf * Mg := by
  rw [forwardDiff_leibniz_defect]
  rw [abs_mul, abs_mul, abs_of_nonneg l_P_nonneg]
  calc l_P * |forwardDiff f μ p| * |forwardDiff g μ p|
      ≤ l_P * Mf * |forwardDiff g μ p| := by
        apply mul_le_mul_of_nonneg_right
        · exact mul_le_mul_of_nonneg_left hf l_P_nonneg
        · exact abs_nonneg _
    _ ≤ l_P * Mf * Mg := by
        apply mul_le_mul_of_nonneg_left hg
        exact mul_nonneg l_P_nonneg hMf

/-! ## Section D: Bounded Differential Bianchi

  The differential Bianchi D_ω(Ω) is not exactly zero on the lattice,
  but is bounded by O(l_P). The bound arises from shifted Leibniz defects
  in d₂(ω∧ω) — everything else cancels exactly. -/

/-- Uniform bounds on a connection form and its derivatives. -/
structure SmoothConnectionData where
  /-- The underlying discrete metric. -/
  g : DiscreteMetric
  /-- Uniform bound on connection form components. -/
  M_conn : ℝ
  M_conn_nonneg : 0 ≤ M_conn
  conn_bounded : ∀ ρ σ μ (p : LatticePoint),
    |christoffelSymbol g ρ μ σ p| ≤ M_conn
  /-- Uniform bound on first derivatives of connection. -/
  M_dconn : ℝ
  M_dconn_nonneg : 0 ≤ M_dconn
  dconn_bounded : ∀ ρ σ μ α (p : LatticePoint),
    |forwardDiff (fun q => christoffelSymbol g ρ μ σ q) α p| ≤ M_dconn

/-- The flat metric has trivially smooth connection data. -/
noncomputable def SmoothConnectionData.flat : SmoothConnectionData where
  g := DiscreteMetric.flat
  M_conn := 0
  M_conn_nonneg := le_refl 0
  conn_bounded := by intro ρ σ μ p; simp [christoffel_flat]
  M_dconn := 0
  M_dconn_nonneg := le_refl 0
  dconn_bounded := by intro ρ σ μ α p; simp [christoffel_flat, forwardDiff_const]

/-! ### Decomposition of D_ω(Ω)

  D_ω(Ω) = d₂(Ω) + ω∧Ω − Ω∧ω
          = d₂(dω) + d₂(ω∧ω) + ω∧Ω − Ω∧ω
          = 0 + d₂(ω∧ω) + ω∧Ω − Ω∧ω    [d²=0]

  The "continuum part" of d₂(ω∧ω) gives dω∧ω − ω∧dω, which combined
  with ω∧Ω − Ω∧ω reduces to ω∧(ω∧ω) − (ω∧ω)∧ω = 0 [triple wedge].

  Only the shifted Leibniz defects survive, giving O(l_P). -/

/-- The curvature form splits as Ω = dω + ω∧ω (definitional). -/
theorem curvatureForm_split (g : DiscreteMetric) (ρ σ : Fin 4)
    (p : LatticePoint) (μ ν : Fin 4) :
    curvatureForm g ρ σ p μ ν =
    dGL1 (connectionForm g) ρ σ p μ ν +
    wedgeGL (connectionForm g) (connectionForm g) ρ σ p μ ν := by
  rfl

/-- The covariant exterior derivative of the curvature 2-form decomposes as:
    D_ω(Ω) = d₂(dω) + d₂(ω∧ω) + ω∧Ω − Ω∧ω.
    This is the starting point for the Bianchi analysis. -/
theorem bianchi_decomposition (g : DiscreteMetric) (ρ σ : Fin 4)
    (p : LatticePoint) (μ ν α : Fin 4) :
    covariantExtDeriv (connectionForm g) (curvatureForm g) ρ σ p μ ν α =
    d2 (dGL1 (connectionForm g) ρ σ) p μ ν α +
    d2 (wedgeGL (connectionForm g) (connectionForm g) ρ σ) p μ ν α +
    wedgeGL12 (connectionForm g) (curvatureForm g) ρ σ p μ ν α -
    wedgeGL21 (curvatureForm g) (connectionForm g) ρ σ p μ ν α := by
  unfold covariantExtDeriv curvatureForm d2
  simp only [forwardDiff]
  ring

/-- Simplified Bianchi decomposition using d²=0:
    D_ω(Ω) = d₂(ω∧ω) + ω∧Ω − Ω∧ω. -/
theorem bianchi_after_d_squared (g : DiscreteMetric) (ρ σ : Fin 4)
    (p : LatticePoint) (μ ν α : Fin 4) :
    covariantExtDeriv (connectionForm g) (curvatureForm g) ρ σ p μ ν α =
    d2 (wedgeGL (connectionForm g) (connectionForm g) ρ σ) p μ ν α +
    wedgeGL12 (connectionForm g) (curvatureForm g) ρ σ p μ ν α -
    wedgeGL21 (curvatureForm g) (connectionForm g) ρ σ p μ ν α := by
  rw [bianchi_decomposition]
  simp only [d2_dGL1_zero (connectionForm g) ρ σ p μ ν α, zero_add]

end OmegaTheory.Geometry
