/-
  OmegaTheory.Geometry.HodgeDecomposition

  Orthogonality of the three summands in the discrete Hodge decomposition
  for 1-forms on boundary-free finite regions.

  On a boundary-free finite region R, the space of 1-forms decomposes
  orthogonally:

    Omega^1(R) = Im(d_0) ⊕ Im(delta_1) ⊕ Harmonic(R)

  Where:
  - exact        = d_0(f) for some scalar f
  - coexact      = delta_1(beta) for some antisymmetric 2-form beta
  - harmonic     = {omega : d_1 omega = 0 AND delta_0 omega = 0}

  The orthogonalities follow from summation-by-parts (d_0-delta_0 adjoint)
  together with delta^2 = 0 and the definition of harmonic.

  Key results:
  1. `exact_orth_coexact`   — ⟨d_0 f, delta_1 beta⟩ = 0 (via delta_0 . delta_1 = 0)
  2. `exact_orth_harmonic`  — ⟨d_0 f, h⟩ = 0 (via delta_0 h = 0)
  3. `innerProduct2`        — L^2 inner product on 2-forms
  4. `summation_by_parts_1_antisym` — d_1 and delta_1 are formal adjoints (with boundary)
  5. `coexact_orth_harmonic` — ⟨delta_1 beta, h⟩ = 0 (via d_1 h = 0)

  Agent: Vega (April 14, 2026)
-/

import OmegaTheory.Geometry.InnerProduct
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime Finset

/-! ## Harmonic 1-Forms -/

/-- A 1-form is harmonic if it is closed (d_1 = 0) and co-closed (delta_0 = 0).
    Equivalently, it lies in the kernel of the Hodge Laplacian Delta_1. -/
def IsHarmonic1 (ω : Discrete1Form) : Prop :=
  IsClosed1 ω ∧ IsCoClosed1 ω

/-- Harmonic 1-forms have d_1 omega = 0. -/
theorem IsHarmonic1.closed {ω : Discrete1Form} (h : IsHarmonic1 ω) : IsClosed1 ω := h.1

/-- Harmonic 1-forms have delta_0 omega = 0. -/
theorem IsHarmonic1.coclosed {ω : Discrete1Form} (h : IsHarmonic1 ω) : IsCoClosed1 ω := h.2

/-! ## Auxiliary: Inner Product of Function with Zero -/

theorem innerProduct0_zero_right (R : Finset LatticePoint) (f : Discrete0Form) :
    innerProduct0 R f (fun _ => 0) = 0 := by
  unfold innerProduct0; simp

theorem innerProduct1_zero_right (R : Finset LatticePoint) (ω : Discrete1Form) :
    innerProduct1 R ω (fun _ _ => 0) = 0 := by
  unfold innerProduct1; simp

/-! ## Orthogonality: Exact ⊥ Coexact -/

/-- **Exact 1-forms are orthogonal to coexact 1-forms** on boundary-free regions.

    Proof: summation-by-parts gives
      ⟨d_0 f, delta_1 beta⟩_1 + ⟨f, delta_0(delta_1 beta)⟩_0 = boundaryFlux.
    But delta_0 . delta_1 = 0 (codiff0_comp_codiff1, using antisymmetry),
    so the second term vanishes. On boundary-free R, the RHS vanishes too. -/
theorem exact_orth_coexact
    (R : Finset LatticePoint)
    (f : Discrete0Form) (β : Discrete2Form) (hanti : IsAntisymmetric2 β)
    (hbdry : boundaryFlux R f (codiff1 β) = 0) :
    innerProduct1 R (d0 f) (codiff1 β) = 0 := by
  have sbp := summation_by_parts R f (codiff1 β)
  have hzero : codiff0 (codiff1 β) = fun _ => 0 := by
    funext p; exact codiff0_comp_codiff1 β hanti p
  rw [hzero, innerProduct0_zero_right] at sbp
  linarith

/-! ## Orthogonality: Exact ⊥ Harmonic -/

/-- **Exact 1-forms are orthogonal to harmonic 1-forms** on boundary-free regions.

    Proof: summation-by-parts gives
      ⟨d_0 f, h⟩_1 + ⟨f, delta_0 h⟩_0 = boundaryFlux.
    But delta_0 h = 0 by harmonicity, so on boundary-free R the inner product vanishes. -/
theorem exact_orth_harmonic
    (R : Finset LatticePoint)
    (f : Discrete0Form) (h : Discrete1Form) (hharm : IsHarmonic1 h)
    (hbdry : boundaryFlux R f h = 0) :
    innerProduct1 R (d0 f) h = 0 := by
  have sbp := summation_by_parts R f h
  have hco : codiff0 h = fun _ => 0 := by
    funext p; exact hharm.coclosed p
  rw [hco, innerProduct0_zero_right] at sbp
  linarith

/-! ## Inner Product on 2-Forms

To prove `coexact perp harmonic`, we need a degree-1 analog of summation-by-parts:
an adjoint pairing between d_1 : Omega^1 → Omega^2 and delta_1 : Omega^2 → Omega^1. -/

/-- L^2 inner product on 2-forms over a finite region R:
    ⟨ω₁, ω₂⟩_R = Σ_{p ∈ R} Σ_μ Σ_ν ω₁(p,μ,ν) · ω₂(p,μ,ν). -/
noncomputable def innerProduct2 (R : Finset LatticePoint)
    (ω₁ ω₂ : Discrete2Form) : ℝ :=
  R.sum fun p => univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
    ω₁ p μ ν * ω₂ p μ ν

/-- The 2-form inner product is symmetric. -/
theorem innerProduct2_comm (R : Finset LatticePoint) (ω₁ ω₂ : Discrete2Form) :
    innerProduct2 R ω₁ ω₂ = innerProduct2 R ω₂ ω₁ := by
  unfold innerProduct2
  apply Finset.sum_congr rfl; intro p _
  apply Finset.sum_congr rfl; intro μ _
  apply Finset.sum_congr rfl; intro ν _; ring

/-- Inner product of zero 2-form with anything is zero. -/
theorem innerProduct2_zero_left (R : Finset LatticePoint) (ω : Discrete2Form) :
    innerProduct2 R (fun _ _ _ => 0) ω = 0 := by
  unfold innerProduct2; simp

/-! ## Key Antisymmetry Swap Identity

The core algebraic identity used to reduce `⟨d_1 α, β⟩_2` by half when β is
antisymmetric. -/

/-- **Antisymmetry swap identity**: for antisymmetric β and a function f on Fin 4 × Fin 4,
    `sum_{μ, ν} f(ν, μ) · β(p, μ, ν) = -sum_{μ, ν} f(μ, ν) · β(p, μ, ν)`.

    Proof: rewrite β p μ ν = -β p ν μ pointwise, pull negation out, swap sum order. -/
private theorem antisym_swap_sum (p : LatticePoint)
    (f : Fin 4 → Fin 4 → ℝ)
    (β : Discrete2Form) (hanti : IsAntisymmetric2 β) :
    (univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 => f ν μ * β p μ ν) =
    -(univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 => f μ ν * β p μ ν) := by
  -- Step 1: β p μ ν = -β p ν μ
  have h1 : (univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 => f ν μ * β p μ ν) =
      (univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 => -(f ν μ * β p ν μ)) := by
    apply Finset.sum_congr rfl; intro μ _
    apply Finset.sum_congr rfl; intro ν _
    rw [hanti p μ ν]; ring
  rw [h1]
  -- Step 2: pull out negation
  rw [show (univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 => -(f ν μ * β p ν μ)) =
      -(univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 => f ν μ * β p ν μ) from by
    simp only [← Finset.sum_neg_distrib]]
  -- Step 3: swap sum indices to match target
  -- Target: -Σ_μ Σ_ν f(ν, μ) * β(ν, μ) = -Σ_μ Σ_ν f(μ, ν) * β(μ, ν)
  -- After sum_comm in the LHS: -Σ_ν Σ_μ f(ν, μ) * β(ν, μ)
  -- This is definitionally equal to -Σ_a Σ_b f(a, b) * β(a, b) [a=ν, b=μ]
  -- Which equals -Σ_μ Σ_ν f(μ, ν) * β(μ, ν) [rename a→μ, b→ν].
  congr 1
  exact Finset.sum_comm

/-! ## Helper: Expanding the codifferential inner product

To compute `innerProduct1 R α (codiff1 β)` as a triple sum over (p, μ, ν). -/

private theorem innerProduct1_codiff1_expand (R : Finset LatticePoint)
    (α : Discrete1Form) (β : Discrete2Form) :
    innerProduct1 R α (codiff1 β) =
    R.sum (fun p => univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
      α p ν * backwardDiff (fun q => β q μ ν) μ p) := by
  unfold innerProduct1 codiff1
  apply Finset.sum_congr rfl; intro p _
  -- Goal: Σ_ν α p ν * (Σ_μ bd β q μ ν p) = Σ_μ Σ_ν α p ν * bd β q μ ν p
  -- Pull α p ν into the Σ_μ
  rw [show (univ.sum fun ν : Fin 4 => α p ν *
          univ.sum fun μ : Fin 4 => backwardDiff (fun q => β q μ ν) μ p) =
      (univ.sum fun ν : Fin 4 => univ.sum fun μ : Fin 4 =>
        α p ν * backwardDiff (fun q => β q μ ν) μ p) from by
    apply Finset.sum_congr rfl; intro ν _
    rw [Finset.mul_sum]]
  -- Swap outer ν with inner μ
  rw [Finset.sum_comm]

/-! ## Helper: Expanding the d_1 inner product

To compute `innerProduct2 R (d_1 α) β` for antisymmetric β, we use the
antisymmetry swap identity to show the d_1 term is twice the "half-term". -/

private theorem innerProduct2_d1_half_eq (R : Finset LatticePoint)
    (α : Discrete1Form) (β : Discrete2Form) (hanti : IsAntisymmetric2 β) :
    (1/2 : ℝ) * innerProduct2 R (d1 α) β =
    R.sum (fun p => univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
      forwardDiff (fun q => α q ν) μ p * β p μ ν) := by
  unfold innerProduct2 d1
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl; intro p _
  -- Goal: (1/2) * Σ_μ Σ_ν (Δ⁺_μ α_ν - Δ⁺_ν α_μ) β(p,μ,ν) = Σ_μ Σ_ν Δ⁺_μ α_ν · β(p,μ,ν)
  -- Step A: distribute the subtraction
  have eqA : (univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
      (forwardDiff (fun q => α q ν) μ p - forwardDiff (fun q => α q μ) ν p) * β p μ ν) =
      (univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
        forwardDiff (fun q => α q ν) μ p * β p μ ν) -
      (univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
        forwardDiff (fun q => α q μ) ν p * β p μ ν) := by
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl; intro μ _
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl; intro ν _
    ring
  rw [eqA]
  -- Step B: use antisym_swap_sum to replace the second term
  -- Let f := forwardDiff_of_α, so second term is Σ f(ν, μ) · β(p, μ, ν)
  have eqB : (univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
      forwardDiff (fun q => α q μ) ν p * β p μ ν) =
      -(univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
        forwardDiff (fun q => α q ν) μ p * β p μ ν) := by
    -- Apply antisym_swap_sum with f(μ, ν) = forwardDiff (fun q => α q ν) μ p
    -- f(ν, μ) = forwardDiff (fun q => α q μ) ν p ✓
    exact antisym_swap_sum p (fun μ ν => forwardDiff (fun q => α q ν) μ p) β hanti
  rw [eqB]
  ring

/-! ## Summation by Parts at Degree 1 -/

/-- Boundary flux for the degree-1 adjoint: flux of alpha against beta_{μν}
    summed over all index pairs. -/
noncomputable def boundaryFlux1 (R : Finset LatticePoint)
    (α : Discrete1Form) (β : Discrete2Form) : ℝ :=
  R.sum fun p => univ.sum fun μ : Fin 4 => univ.sum fun ν : Fin 4 =>
    (α (shiftFin p μ) ν * β p μ ν - α p ν * β (shiftBackFin p μ) μ ν) / l_P

/-- **Degree-1 summation by parts** (d_1 - delta_1 adjoint).

    For antisymmetric 2-forms β:
      (1/2) ⟨d_1 α, β⟩_2 + ⟨α, delta_1 β⟩_1 = boundaryFlux1 R α β

    The factor 1/2 arises because the natural inner product on 2-forms
    double-counts via antisymmetry (both (μ,ν) and (ν,μ) contribute).

    Proof: reduce ⟨d_1 α, β⟩_2 to `Σ Δ⁺ α · β` via antisymmetry, rearrange
    `⟨α, delta_1 β⟩_1` to match the index structure, then apply the pointwise
    forward-backward adjoint identity at each cell. -/
theorem summation_by_parts_1_antisym
    (R : Finset LatticePoint) (α : Discrete1Form) (β : Discrete2Form)
    (hanti : IsAntisymmetric2 β) :
    (1/2) * innerProduct2 R (d1 α) β + innerProduct1 R α (codiff1 β) =
    boundaryFlux1 R α β := by
  rw [innerProduct2_d1_half_eq R α β hanti, innerProduct1_codiff1_expand R α β]
  unfold boundaryFlux1
  -- Goal: Σ_p Σ_μ Σ_ν (Δ⁺_μ α_ν · β(p,μ,ν)) + Σ_p Σ_μ Σ_ν α_ν · Δ⁻_μ β(·,μ,ν) p
  --     = Σ_p Σ_μ Σ_ν (α(p+μ, ν) β(p,μ,ν) - α(p,ν) β(p-μ,μ,ν)) / l_P
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro p _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro μ _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro ν _
  -- Per cell: Δ⁺_μ α_ν · β(p,μ,ν) + α_ν · Δ⁻_μ β(·,μ,ν) p = cell RHS / l_P
  exact forward_backward_adjoint (fun q => α q ν) (fun q => β q μ ν) μ p

/-! ## Orthogonality: Coexact ⊥ Harmonic

For coexact delta_1 β and harmonic h (d_1 h = 0 AND delta_0 h = 0):

    (1/2) ⟨d_1 h, β⟩_2 + ⟨h, delta_1 β⟩_1 = boundary_flux

But d_1 h = 0 by harmonicity, so on boundary-free R the inner product vanishes. -/

/-- **Coexact 1-forms are orthogonal to harmonic 1-forms** on boundary-free regions. -/
theorem coexact_orth_harmonic
    (R : Finset LatticePoint)
    (β : Discrete2Form) (hanti : IsAntisymmetric2 β)
    (h : Discrete1Form) (hharm : IsHarmonic1 h)
    (hbdry : boundaryFlux1 R h β = 0) :
    innerProduct1 R (codiff1 β) h = 0 := by
  rw [innerProduct1_comm]
  have sbp := summation_by_parts_1_antisym R h β hanti
  -- d_1 h = 0 by harmonicity
  have hcl : d1 h = fun _ _ _ => 0 := by
    funext p μ ν; exact hharm.closed p μ ν
  rw [hcl, innerProduct2_zero_left] at sbp
  linarith

/-! ## The Full Orthogonality Statement -/

/-- **Full orthogonality**: on boundary-free regions, any exact, coexact, and
    harmonic 1-forms are pairwise orthogonal.

    This is the Hilbert-space content of the Hodge decomposition:
    Omega^1(R) = Im(d_0) ⊕ Im(delta_1) ⊕ Harmonic(R) (orthogonal sum). -/
theorem hodge_orthogonal
    (R : Finset LatticePoint)
    (f : Discrete0Form) (β : Discrete2Form) (hanti : IsAntisymmetric2 β)
    (h : Discrete1Form) (hharm : IsHarmonic1 h)
    (hb1 : boundaryFlux R f (codiff1 β) = 0)
    (hb2 : boundaryFlux R f h = 0)
    (hb3 : boundaryFlux1 R h β = 0) :
    innerProduct1 R (d0 f) (codiff1 β) = 0 ∧
    innerProduct1 R (d0 f) h = 0 ∧
    innerProduct1 R (codiff1 β) h = 0 :=
  ⟨exact_orth_coexact R f β hanti hb1,
   exact_orth_harmonic R f h hharm hb2,
   coexact_orth_harmonic R β hanti h hharm hb3⟩

end OmegaTheory.Geometry
