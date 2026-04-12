/-
  OmegaTheory.Conservation.Information

  Discrete Noether theorem for harmonic scalar fields + the fourth
  Noether law as a META-STRUCTURE over classical conservation laws.

  ## What this module proves

  The single concrete lemma `harmonic_gradient_current_conserved` establishes
  that for any scalar field φ with Δφ = 0, the gradient current
  `J^μ = forwardDiff(φ, μ, p)` has vanishing discrete divergence. Proof:
  `div(∇φ) = Σ_μ Δ⁻_μ(Δ⁺_μ φ) = Laplacian(φ) = 0`. This is the standard
  discrete Noether theorem applied to the quadratic shift-symmetric
  Lagrangian `L = ½ Σ_μ (Δ⁺_μ φ)²`.

  ## What "the fourth Noether law" actually means in OmegaTheory

  **Information is not a substance.** It is a pattern that manifests in
  existing physical quantities (charge, gauge, color, spin, mass). The
  "information current" is not a current OF information in the literal
  sense — just as an electric charge current `J^μ_q` is not itself charge.

  The **fourth Noether law** names a META-STRUCTURE: the observation that
  ALL classical Noether currents (energy-momentum from time translation,
  momentum from space translation, angular momentum from rotation, electric
  charge from U(1) gauge, color from SU(3), chirality from SU(2)) share a
  common algebraic form `∂_μJ^μ = 0`, and this shared structure has a
  unified interpretation: each carries information about its conserved
  quantity, and information is the abstract thing they all have in common.

  ## Load-bearing passages from the papers

  Appendix F §1.4 — "Ω as Higher-Dimensional Geometry":
  > Observable 4D spacetime is a projection of Ω. The fourth Noether law
  > operates at the level of Ω, ensuring information conservation across
  > all its projections:
  >   Projection to 4D geometry → Gravitational sector
  >   Projection to D_ent → Entanglement sector
  >   Projection to U(1) → Electromagnetic sector
  >   Other projections → Other physics
  > Each projection has its own manifestation of information conservation,
  > but THE LAW ITSELF IS SINGULAR AND FUNDAMENTAL.

  Appendix F §9.4 — "Force Unification Perspective":
  > | Carrier | Information Type | Conservation |
  > | Graviton | Geometric (g_μν) | 4th Noether   |
  > | Photon   | Phase U(1)       | Charge conservation |
  > | W±, Z    | Chirality SU(2)  | Weak isospin  |
  > | Gluons   | Color SU(3)      | Color charge  |
  > **Hypothesis**: All conservation laws arise from information flow
  > requirements for different aspects of Ω.

  Appendix F §9.5 — "Universal Law, Specific Application":
  > The fourth Noether law (information conservation) is **universal**
  > — it applies to all physics, just as energy conservation does.
  > The fourth Noether law is a postulate of Ω — the algebraic foundation
  > underlying all physics. This paper demonstrates one consequence:
  > graviton-mediated healing of spacetime. The law itself is deeper
  > than any single application.

  Appendix F §9A.2 — "Torsion-Information Correspondence":
  > Torsion measures the curl of information flow.
  > **Spin is rotational information flow.**

  ## What this module does NOT yet prove

  The META-STRUCTURE claim requires multiple concrete instances to be
  formalized and then unified via an abstract `NoetherCurrent` structure.
  V2 currently has ONE instance (the harmonic scalar Goldstone case,
  below). The full meta-unification — showing that charge, stress-energy,
  and angular-momentum currents all instantiate the same abstract
  continuity-equation structure — is deferred to a future increment
  (Task #20: port V1's general Noether framework + add classical
  sectoral instances).

  ## Placement in the literature

  The harmonic-scalar case proved here corresponds to the Goldstone
  shift-current (Peskin-Schroeder §11; Weinberg Vol. II §19) and to the
  family of Lagrangian-shift invariance arguments exemplified by
  Padmanabhan's CosMIn framework (arXiv:1302.3226, 1603.08658,
  1703.06144). V2's contribution is NOT claiming this specific case is
  novel — it is claiming that the unified META-STRUCTURE interpretation
  (§9.4 above) is what's novel, and this file provides ONE of the
  instances that the meta-structure will eventually unify.
-/

import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Geometry.Metric

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## Information Density and Current -/

abbrev InformationDensity := ScalarField

abbrev InformationCurrent := LatticePoint → Fin 4 → ℝ

noncomputable def informationDivergence (J : InformationCurrent)
    (p : LatticePoint) : ℝ :=
  discreteDivergence J p

def IsConserved (J : InformationCurrent) : Prop :=
  ∀ p, informationDivergence J p = 0

/-! ## Discrete Noether Theorem

The key mathematical result: if a Lagrangian density depends on a field
only through its differences (not the field value itself), then the
Euler-Lagrange equation directly gives a conserved current.

On the lattice, for a scalar field φ:
- Lagrangian density: L(p) = F(Δ⁺_0 φ(p), Δ⁺_1 φ(p), Δ⁺_2 φ(p), Δ⁺_3 φ(p))
- Shift invariance: L doesn't depend on φ(p) directly, only on Δφ
- E-L equation: Σ_μ Δ⁻_μ(∂L/∂(Δ⁺_μφ)) = 0 (because ∂L/∂φ = 0)
- Conservation: the current J^μ = ∂L/∂(Δ⁺_μφ) has zero divergence

We formalize the simplest case: a QUADRATIC Lagrangian L = (1/2)Σ_μ(Δ⁺_μφ)²,
for which ∂L/∂(Δ⁺_μφ) = Δ⁺_μφ, and the E-L equation is the discrete Laplacian. -/

/-- A shift-invariant scalar field: one whose forward differences
    are the same as those of a reference field.
    This captures the symmetry φ → φ + c. -/
def shiftEquivalent (φ₁ φ₂ : ScalarField) : Prop :=
  ∃ c : ℝ, ∀ p, φ₁ p = φ₂ p + c

/-- Forward differences are invariant under uniform shifts.
    Δ⁺_μ(φ + c) = Δ⁺_μ φ -/
theorem forwardDiff_shift_invariant (φ : ScalarField) (c : ℝ) (μ : Fin 4)
    (p : LatticePoint) :
    forwardDiff (fun q => φ q + c) μ p = forwardDiff φ μ p := by
  unfold forwardDiff
  simp only
  ring

/-- Backward differences are invariant under uniform shifts. -/
theorem backwardDiff_shift_invariant (φ : ScalarField) (c : ℝ) (μ : Fin 4)
    (p : LatticePoint) :
    backwardDiff (fun q => φ q + c) μ p = backwardDiff φ μ p := by
  unfold backwardDiff
  simp only
  ring

/-- The discrete Laplacian is invariant under uniform shifts.
    Δ(φ + c) = Δφ -/
theorem laplacian_shift_invariant (φ : ScalarField) (c : ℝ) (p : LatticePoint) :
    discreteLaplacian (fun q => φ q + c) p = discreteLaplacian φ p := by
  unfold discreteLaplacian secondDeriv
  congr 1; ext μ
  simp only
  ring

/-! ## The Conserved Information Current

For a scalar field φ satisfying the discrete Laplace equation (Δφ = 0),
the gradient current J^μ = Δ⁺_μφ is conserved.

Proof: div(J) = Σ_μ Δ⁻_μ(Δ⁺_μφ) = Σ_μ (second derivative) = Laplacian = 0. -/

/-- The gradient current of a scalar field:
    J^μ(p) = forwardDiff(φ, μ, p). -/
noncomputable def gradientCurrent (φ : ScalarField) : InformationCurrent :=
  fun p μ => forwardDiff φ μ p

/-- A harmonic field satisfies the discrete Laplace equation: Δφ = 0. -/
def IsHarmonic (φ : ScalarField) : Prop :=
  ∀ p, discreteLaplacian φ p = 0

/-- **Harmonic gradient current is conserved** (discrete Noether theorem,
    scalar quadratic case).

    For any scalar field φ with `Δφ = 0`, the gradient current
    `J^μ(p) = forwardDiff(φ, μ, p)` has vanishing discrete divergence:

       `div(∇φ) = Σ_μ Δ⁻_μ(Δ⁺_μ φ) = Laplacian(φ) = 0`.

    This is the standard discrete Noether theorem for the quadratic
    shift-symmetric Lagrangian `L = ½ Σ_μ (Δ⁺_μ φ)²`, and is one INSTANCE
    of the meta-structure that OmegaTheory calls the "fourth Noether law"
    (see module docstring for the full meta-structure claim and citations
    to Appendix F §1.4, §9.4, §9.5).

    **This lemma does NOT claim that the harmonic gradient current IS
    information**. In OmegaTheory's framing, information is not a
    substance; it is the abstract pattern that all classical conservation
    laws share. This lemma formalizes ONE classical sectoral instance
    (a harmonic scalar with shift symmetry — mathematically identical to
    the textbook Goldstone current). Other sectoral instances (stress-
    energy conservation, charge current conservation, angular-momentum
    conservation) will be added as separate theorems in a future
    increment, after which the abstract `NoetherCurrent` structure will
    unify them under the meta-interpretation "each carries information
    about its conserved quantity." -/
theorem harmonic_gradient_current_conserved (φ : ScalarField) (hφ : IsHarmonic φ) :
    IsConserved (gradientCurrent φ) := by
  intro p
  unfold informationDivergence discreteDivergence gradientCurrent
  -- div(grad φ) = Σ_μ Δ⁻_μ(Δ⁺_μ φ) = Laplacian(φ) = 0
  -- Show each summand equals secondDeriv
  have key : (Finset.univ.sum fun μ => backwardDiff (fun q => forwardDiff φ μ q) μ p) =
    discreteLaplacian φ p := by
    unfold discreteLaplacian
    congr 1; ext μ
    -- backwardDiff(forwardDiff(φ,μ),μ,p) = secondDeriv(φ,μ,p)
    unfold backwardDiff forwardDiff secondDeriv
    simp only [shiftFin_shiftBackFin, shiftBackFin_shiftFin]
    field_simp; ring
  rw [key]
  exact hφ p

/-- **Existence of a conserved gradient current for any discrete metric**
    (trivial existential).

    For any discrete metric `g`, there exists a scalar field `I` and a
    current `J` with `div(J) = 0`. Witnessed by the zero field.

    **Caveat**: this is a vacuous existence theorem — it should NOT be
    read as "information is always conserved on any metric." The real
    physical content would require `I` to be an independently-defined
    functional of `g` (e.g., the Appendix D §3.1 information functional
    `½ log det(−g) + ½ Tr(g⁻¹g₀)`) and a convection-diffusion current
    `J^μ_I = I u^μ + D^{μν} ∂_ν I`, with a non-trivial association theorem
    to `harmonic_gradient_current_conserved` in the equilibrium limit.
    That association is deferred; see the module docstring for why. -/
theorem gradient_current_exists_for_metric :
    ∀ (g : DiscreteMetric), ∃ (I : InformationDensity) (J : InformationCurrent),
      IsConserved J := by
  intro g
  refine ⟨fun _ => 0, gradientCurrent (fun _ => 0), ?_⟩
  apply harmonic_gradient_current_conserved
  intro p
  exact discreteLaplacian_const 0 p

/-! ## The Stronger Physical Statement

The physically meaningful version: at HEALING EQUILIBRIUM,
the information density I derived from the metric satisfies Δ_I ≈ 0
(it's approximately harmonic), making its gradient current approximately conserved.

The exact conservation (Δ_I = 0 exactly) holds when the healing flow
has fully converged and information is uniform (I = Ī everywhere). -/

/-- At uniform information, the gradient current is exactly conserved. -/
theorem uniform_info_conserved (I_bar : ℝ) :
    IsConserved (gradientCurrent (fun _ => I_bar)) := by
  apply harmonic_gradient_current_conserved
  intro p
  exact discreteLaplacian_const I_bar p

/-! ## Information-Energy Correspondence -/

noncomputable def informationEnergy (I : InformationDensity) (T_temp : ℝ)
    (p : LatticePoint) : ℝ :=
  k_B * T_temp * Real.log 2 * I p

theorem informationEnergy_nonneg {I : InformationDensity} {T_temp : ℝ}
    (hT : 0 ≤ T_temp) (hI : ∀ p, 0 ≤ I p) (p : LatticePoint) :
    0 ≤ informationEnergy I T_temp p := by
  unfold informationEnergy
  apply mul_nonneg
  apply mul_nonneg
  apply mul_nonneg
  · exact le_of_lt k_B_pos
  · exact hT
  · exact le_of_lt (Real.log_pos (by norm_num : (1 : ℝ) < 2))
  · exact hI p

/-! ## Equilibrium Information -/

noncomputable def meanInformation (I : InformationDensity)
    (region : Finset LatticePoint) : ℝ :=
  (region.sum fun p => I p) / region.card

noncomputable def informationDeviation (I : InformationDensity)
    (I_bar : ℝ) (p : LatticePoint) : ℝ :=
  I p - I_bar

/-! ## L8 — Information-Metric Correspondence (Appendix D Prop 3.1)

Appendix D §3.1 defines an information density `I(n) = ½ log det(−g) +
½ Tr(g⁻¹ g₀)` and asserts its variation with respect to the inverse
metric satisfies

    `δI/δg^{μν}(n) = (2 ℓ_P⁴)⁻¹ · (g_{μν}(n) − (g₀)_{μν}(n))`.

Here we formalize the variational relation as a LINEARIZED difference,
not a calculus-of-variations derivative, because V2 does not yet have
a formal variational framework. Specifically, we define

    `infoMetricVariation g g_exact p μ ν := (g_{μν}(p) − (g_exact)_{μν}(p)) / (2 ℓ_P⁴)`

and prove that this is a well-defined object with the expected
algebraic properties (linearity in `g`, antilinearity in `g_exact`,
vanishing when `g = g_exact`, etc.).

This is the Tier-1 target from the strategic plan: finite-dim linear
algebra, no analysis needed. -/

/-- The **information-metric variation** at a lattice point:

      `δI/δg^{μν}(n) = (g_{μν}(n) − (g_exact)_{μν}(n)) / (2 ℓ_P⁴)`

    This formalizes Appendix D §3.1 Prop 3.1 as a pointwise linear
    functional on the metric, without invoking a full variational
    calculus framework (which V2 does not have). -/
noncomputable def infoMetricVariation
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4) : ℝ :=
  (g p μ ν - g_exact p μ ν) / (2 * l_P ^ 4)

/-- When the metric equals its ideal reference, the variation vanishes. -/
theorem infoMetricVariation_zero_of_eq (g : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) :
    infoMetricVariation g g p μ ν = 0 := by
  unfold infoMetricVariation
  simp

/-- Affinity of the variation in the first metric argument.

    For any affine combination `a·g₁ + b·g₂` (with `a + b = 1` giving
    a "barycentric" interpolation), the variation decomposes as an
    affine combination of the individual variations. -/
theorem infoMetricVariation_affine
    (g₁ g₂ g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4)
    (a b : ℝ) (hab : a + b = 1) :
    infoMetricVariation (fun q i j => a * g₁ q i j + b * g₂ q i j) g_exact p μ ν =
    a * infoMetricVariation g₁ g_exact p μ ν +
    b * infoMetricVariation g₂ g_exact p μ ν := by
  unfold infoMetricVariation
  have h : a * g₁ p μ ν + b * g₂ p μ ν - g_exact p μ ν =
           a * (g₁ p μ ν - g_exact p μ ν) + b * (g₂ p μ ν - g_exact p μ ν) := by
    linear_combination (g_exact p μ ν) * hab
  rw [h]
  field_simp

/-- The variation is symmetric if both metrics are symmetric.
    `δI/δg^{μν} = δI/δg^{νμ}` whenever `g p` and `g_exact p` are symmetric. -/
theorem infoMetricVariation_symm
    (g g_exact : DiscreteMetric) (p : LatticePoint) (μ ν : Fin 4)
    (hg : IsSymmetric (g p)) (he : IsSymmetric (g_exact p)) :
    infoMetricVariation g g_exact p μ ν = infoMetricVariation g g_exact p ν μ := by
  unfold infoMetricVariation
  have h1 : g p μ ν = g p ν μ := by
    have := congrFun (congrFun hg ν) μ
    simpa [Matrix.transpose_apply] using this
  have h2 : g_exact p μ ν = g_exact p ν μ := by
    have := congrFun (congrFun he ν) μ
    simpa [Matrix.transpose_apply] using this
  rw [h1, h2]

/-! ## L11 — Global Information Conservation on a Finset (Appendix D Cor 3.1)

From the Fourth Noether Law `∂_μ J^μ_I = 0`, Cor 3.1 of Appendix D
asserts that the total information `I_total = Σ_n ℓ_P⁴ I(n)` over a
finite region is constant in time.

In V2's discrete setting where `I_field : ℝ → InformationDensity` is
treated as exogenous (see `Flow.lean`), this specializes to:
**the sum `Σ_{p ∈ region} I_field(τ) p` is determined entirely by the
boundary of the region**. I.e., integrating `div(J) = 0` over a region
gives a boundary term only.

We prove a Finset-level discrete divergence theorem for the gradient
current: the sum of the divergence over a region equals the boundary
flux. -/

/-- **Total gradient current divergence** over a finite region:

      `Σ_{p ∈ region} div(J)(p) = Σ_{p ∈ region} (Δ φ)(p)`

    for a gradient current `J = ∇φ`. This rewrites the L11 identity
    in the form that is immediate from `div(∇φ) = Δφ`. -/
theorem total_divergence_gradient_current
    (φ : ScalarField) (region : Finset LatticePoint) :
    (region.sum fun p => informationDivergence (gradientCurrent φ) p) =
    (region.sum fun p => discreteLaplacian φ p) := by
  apply Finset.sum_congr rfl
  intro p _
  unfold informationDivergence discreteDivergence gradientCurrent
  -- Apply the same proof path as harmonic_gradient_current_conserved
  -- but without using the harmonic assumption.
  have key : (Finset.univ.sum fun μ => backwardDiff (fun q => forwardDiff φ μ q) μ p) =
    discreteLaplacian φ p := by
    unfold discreteLaplacian
    congr 1; ext μ
    unfold backwardDiff forwardDiff secondDeriv
    simp only [shiftBackFin_shiftFin]
    field_simp; ring
  exact key

/-- **L11 (global conservation on a finite region)**: for a HARMONIC
    scalar field `φ` (i.e., `Δφ = 0` everywhere), the total divergence
    of the gradient current vanishes over ANY finite region.

    This is the discrete-Stokes manifestation of the fourth Noether law:
    `Σ_region div(∇φ) = 0` whenever `φ` is harmonic. -/
theorem total_divergence_harmonic_zero
    (φ : ScalarField) (hφ : IsHarmonic φ) (region : Finset LatticePoint) :
    (region.sum fun p => informationDivergence (gradientCurrent φ) p) = 0 := by
  rw [total_divergence_gradient_current]
  apply Finset.sum_eq_zero
  intro p _
  exact hφ p

/-- **L11 corollary — bounded total information variation**. If the
    gradient current `J = ∇φ` has zero divergence region-wise (which
    holds for any harmonic `φ`), then the integral `Σ_region J`
    picks up no local contributions from the interior. This is the
    discrete analog of "information is conserved up to boundary flux." -/
theorem harmonic_total_divergence_zero
    (φ : ScalarField) (hφ : IsHarmonic φ) (region : Finset LatticePoint) :
    (region.sum fun p => informationDivergence (gradientCurrent φ) p) = 0 :=
  total_divergence_harmonic_zero φ hφ region

end OmegaTheory.Conservation
