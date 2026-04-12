/-
  OmegaTheory.Conservation.NoetherMetaStructure

  **The fourth Noether law, as a META-STRUCTURE, formalized in Lean.**

  ## Why this file exists

  The OmegaTheory papers (Appendix F §1.4, §9.4, §9.5) claim that the
  "fourth Noether law" is not a new conservation law from a new symmetry,
  but rather the unified interpretation of the META-STRUCTURE that ALL
  classical Noether currents share: each sectoral current `J^μ` — whether
  it's the energy-momentum current from time translation, the charge
  current from U(1) gauge, the color current from SU(3), the spin current,
  or the gradient current of a harmonic scalar field — obeys the same
  abstract continuity equation `∂_μJ^μ = 0`, and the unified
  interpretation is that each carries INFORMATION about its conserved
  quantity.

  Information itself is not a substance; it is the abstract common
  structure. See Appendix F §1.4:

      > Each projection has its own manifestation of information
      > conservation, but the law itself is singular and fundamental.

  And §9.4:

      > **Hypothesis**: All conservation laws arise from information
      > flow requirements for different aspects of Ω.

  ## What this file formalizes

  We define an abstract `ConservedCurrent` structure that bundles a
  vector field on the lattice with a proof that its discrete divergence
  vanishes. This is the Lean incarnation of "a thing that obeys the
  fourth Noether law." It is parameterless (no symmetry group mentioned)
  and purely structural — exactly matching the meta-structure claim.

  We then prove:

  1. The harmonic-gradient current (from `Information.lean`) is a
     `ConservedCurrent`. This is the instance the papers derive in
     Appendix F §2.1–2.3 (scalar reshaping field), mathematically
     identical to the textbook Goldstone current.

  2. Any constant-field gradient current (zero current) is a
     `ConservedCurrent`. Trivial instance.

  3. **`ConservedCurrent` is closed under addition**: if `J₁` and `J₂`
     are both conserved, so is `J₁ + J₂`. This is the compositional
     property of the meta-structure: if information conservation holds
     in two sectors, it holds in their union.

  4. **`ConservedCurrent` is closed under scalar multiplication**: if
     `J` is conserved and `c : ℝ`, then `c · J` is conserved.

  5. **The meta-law**: any term of type `ConservedCurrent` automatically
     satisfies `∂_μJ^μ = 0` by construction. This is the "fourth Noether
     law" as Lean sees it.

  ## What this file does NOT yet formalize

  Beyond the harmonic-scalar case already in V2, the paper's full list
  of sectoral instances (U(1) charge current from a complex scalar,
  SU(3) color current from a gauge field, stress-energy from time
  translation) would each require formalizing the corresponding classical
  Lagrangian and deriving its Noether current. We add **one** additional
  instance below (the `sum` and `smul` operations on `ConservedCurrent`),
  but the broader program of instantiating charge/color/stress-energy
  currents is deferred.

  The point of this file is not to add lots of concrete instances — it
  is to give the META-STRUCTURE claim a Lean-level type signature. Once
  the type exists, future work can populate it with additional instances
  and prove compositional theorems against it.

  ## Placement in the literature

  The abstract `ConservedCurrent` structure is close in spirit to Wald's
  1993 Noether-charge formulation of black hole entropy (which is also
  about a meta-structure over classical Noether currents). It is NOT
  the same as Padmanabhan's Lagrangian-shift invariance principle
  (which is about a specific class of symmetries). V2's contribution is
  the EXPLICIT META-TYPE that makes the meta-structure claim mechanical.
-/

import OmegaTheory.Conservation.Information

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime

/-! ## The `ConservedCurrent` abstract structure -/

/-- A **conserved current**: a lattice vector field with vanishing
    discrete divergence. This is the Lean type-level analog of the
    OmegaTheory claim that "everything obeying the fourth Noether law
    is an instance of the same meta-structure." -/
structure ConservedCurrent where
  /-- The underlying current. -/
  current : InformationCurrent
  /-- The continuity equation: `∂_μJ^μ = 0`. -/
  conserved : IsConserved current

/-! ## The meta-law

The single most important theorem in this file: every term of type
`ConservedCurrent` automatically obeys the continuity equation. This
is vacuous by construction — but vacuous-by-construction is exactly
what it means to have formalized a META-STRUCTURE in Lean. -/

/-- **The fourth Noether law, as a meta-structure**: every conserved
    current obeys `∂_μ J^μ = 0`.

    This is the Lean statement of the OmegaTheory claim that "all
    classical conservation laws share the same underlying continuity
    structure, and that shared structure is what we call information
    conservation."

    Proof: by construction — the `ConservedCurrent` type bundles the
    conservation proof with the current itself, so unpacking one
    immediately gives the other. -/
theorem fourth_noether_meta_law (J : ConservedCurrent) :
    ∀ p, informationDivergence J.current p = 0 := J.conserved

/-! ## Instance 1 — Harmonic gradient current

The instance already proved in `Information.lean`: for any harmonic
scalar field `φ`, the gradient current `J^μ = Δ⁺_μφ` is conserved. -/

/-- Package a harmonic gradient current as a `ConservedCurrent`. -/
noncomputable def harmonicConservedCurrent (φ : ScalarField) (hφ : IsHarmonic φ) :
    ConservedCurrent where
  current := gradientCurrent φ
  conserved := harmonic_gradient_current_conserved φ hφ

/-! ## Instance 2 — Uniform information field

A trivially-conserved instance: the gradient of a constant field is
zero, which is vacuously divergence-free. -/

/-- Package a uniform-information gradient current as a `ConservedCurrent`. -/
noncomputable def uniformConservedCurrent (I_bar : ℝ) : ConservedCurrent where
  current := gradientCurrent (fun _ => I_bar)
  conserved := uniform_info_conserved I_bar

/-! ## Closure properties

`ConservedCurrent` is closed under addition and scalar multiplication.
This is the compositional content of the meta-structure: if information
conservation holds in two sectors, their superposition also conserves. -/

/-- Pointwise addition of two information currents. -/
noncomputable def addCurrent (J₁ J₂ : InformationCurrent) : InformationCurrent :=
  fun p μ => J₁ p μ + J₂ p μ

/-- Pointwise scalar multiplication of an information current. -/
noncomputable def smulCurrent (c : ℝ) (J : InformationCurrent) : InformationCurrent :=
  fun p μ => c * J p μ

/-- The discrete divergence is additive. -/
theorem informationDivergence_add (J₁ J₂ : InformationCurrent) (p : LatticePoint) :
    informationDivergence (addCurrent J₁ J₂) p =
    informationDivergence J₁ p + informationDivergence J₂ p := by
  unfold informationDivergence discreteDivergence addCurrent backwardDiff
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro μ _
  ring

/-- The discrete divergence is homogeneous. -/
theorem informationDivergence_smul (c : ℝ) (J : InformationCurrent) (p : LatticePoint) :
    informationDivergence (smulCurrent c J) p =
    c * informationDivergence J p := by
  unfold informationDivergence discreteDivergence smulCurrent backwardDiff
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro μ _
  ring

/-- `ConservedCurrent` is closed under addition. -/
noncomputable def addConservedCurrent (J₁ J₂ : ConservedCurrent) : ConservedCurrent where
  current := addCurrent J₁.current J₂.current
  conserved := by
    intro p
    rw [informationDivergence_add]
    rw [J₁.conserved p, J₂.conserved p]
    ring

/-- `ConservedCurrent` is closed under scalar multiplication. -/
noncomputable def smulConservedCurrent (c : ℝ) (J : ConservedCurrent) : ConservedCurrent where
  current := smulCurrent c J.current
  conserved := by
    intro p
    rw [informationDivergence_smul]
    rw [J.conserved p]
    ring

/-! ## The trivial zero current

Useful as a base point: the zero current is conserved. This plus
`addConservedCurrent` makes `ConservedCurrent` into an additive monoid
structurally — though we don't instantiate the `AddMonoid` typeclass
here because that's not required for the meta-law. -/

/-- The identically-zero current. -/
noncomputable def zeroCurrent : InformationCurrent := fun _ _ => 0

/-- The zero current is conserved. -/
theorem zero_is_conserved : IsConserved zeroCurrent := by
  intro p
  unfold informationDivergence discreteDivergence zeroCurrent backwardDiff
  simp

/-- The zero conserved current. -/
noncomputable def zeroConservedCurrent : ConservedCurrent where
  current := zeroCurrent
  conserved := zero_is_conserved

/-! ## Instance 3 — U(1) charge current (lattice link form)

The conserved current associated with U(1) symmetry of a complex scalar
field `φ = φ₁ + i·φ₂`. In continuum QFT this is `J^μ = Im(φ* ∂_μ φ)`.

On the lattice, the naive product `φ₁ · ∂_μ φ₂ - φ₂ · ∂_μ φ₁` is NOT
exactly conserved (the discrete product rule has correction terms). The
LATTICE-ADAPTED form uses the "link current":

    `J^μ(p) = (φ₁(p)·φ₂(p+μ̂) - φ₂(p)·φ₁(p+μ̂)) / l_P`

whose divergence equals EXACTLY `φ₁·Δφ₂ - φ₂·Δφ₁` (by commutativity
of ℝ multiplication — the cross terms that break the product rule cancel
pairwise). So for two harmonic fields (Δφ₁ = 0, Δφ₂ = 0), this current
is exactly conserved.

This is a genuinely different instance from the harmonic gradient current:
the gradient current carries information about a SINGLE scalar's spatial
variation; the link current carries information about the RELATIVE PHASE
between two scalars. In QFT terms, the gradient current is the Goldstone
current; the link current is the Noether charge current. -/

/-- The lattice link current for a pair of scalar fields: the U(1) charge
    current in lattice-adapted form. `J^μ(p) = Im(φ*(p) · φ(p+μ̂)) / l_P`. -/
noncomputable def linkCurrent (φ₁ φ₂ : ScalarField) : InformationCurrent :=
  fun p μ => (φ₁ p * φ₂ (shiftFin p μ) - φ₂ p * φ₁ (shiftFin p μ)) / l_P

/-- The divergence of the link current equals `φ₁·Δφ₂ - φ₂·Δφ₁` exactly.

    This is the key identity: it says the link-current divergence
    factorizes into the Laplacians of the component fields times
    the OTHER component. No approximation — exact on the lattice. -/
theorem linkCurrent_divergence (φ₁ φ₂ : ScalarField) (p : LatticePoint) :
    informationDivergence (linkCurrent φ₁ φ₂) p =
    φ₁ p * discreteLaplacian φ₂ p - φ₂ p * discreteLaplacian φ₁ p := by
  unfold informationDivergence discreteDivergence linkCurrent
  unfold discreteLaplacian secondDeriv backwardDiff
  have hlP : l_P ≠ 0 := l_P_ne_zero
  simp only [shiftBackFin_shiftFin, Fin.sum_univ_four]
  field_simp
  ring

/-- For two harmonic fields, the link current is conserved.
    This is the U(1) Noether theorem on the lattice. -/
theorem linkCurrent_conserved (φ₁ φ₂ : ScalarField)
    (h₁ : IsHarmonic φ₁) (h₂ : IsHarmonic φ₂) :
    IsConserved (linkCurrent φ₁ φ₂) := by
  intro p
  rw [linkCurrent_divergence]
  rw [h₁ p, h₂ p]
  ring

/-- Package the U(1) link current as a `ConservedCurrent`. -/
noncomputable def u1ChargeConservedCurrent
    (φ₁ φ₂ : ScalarField) (h₁ : IsHarmonic φ₁) (h₂ : IsHarmonic φ₂) :
    ConservedCurrent where
  current := linkCurrent φ₁ φ₂
  conserved := linkCurrent_conserved φ₁ φ₂ h₁ h₂

/-- The link current is antisymmetric: swapping φ₁ ↔ φ₂ negates the current. -/
theorem linkCurrent_antisymm (φ₁ φ₂ : ScalarField) (p : LatticePoint) (μ : Fin 4) :
    linkCurrent φ₁ φ₂ p μ = -linkCurrent φ₂ φ₁ p μ := by
  unfold linkCurrent; field_simp; ring

/-- The link current of a field with itself is zero (charge-neutrality). -/
theorem linkCurrent_self (φ : ScalarField) (p : LatticePoint) (μ : Fin 4) :
    linkCurrent φ φ p μ = 0 := by
  unfold linkCurrent; field_simp; ring

/-! ## Instance count

`ConservedCurrent` now has THREE non-trivial instance families:
1. `harmonicConservedCurrent φ hφ` — gradient current of a harmonic scalar
2. `u1ChargeConservedCurrent φ₁ φ₂ h₁ h₂` — U(1) charge current from two harmonic scalars
3. `addConservedCurrent` / `smulConservedCurrent` — closure under linear combination

The first captures the GEOMETRIC sector (energy-like conservation from
shift symmetry). The second captures the GAUGE sector (charge conservation
from phase rotation). Together they demonstrate that `ConservedCurrent`
is a genuine meta-structure, not a one-trick type. -/

/-! ## Remark on the meta-structure

The preceding definitions and theorems establish `ConservedCurrent` as
a closed-under-addition-and-scalar-multiplication abstraction, with
`fourth_noether_meta_law` as the trivial extraction of the conservation
property. This is what Reading D of the fourth Noether law looks like
in Lean: the law is the TYPE, not a theorem about any single current.

Future work (Task #9 / future increments):
  * Add a charge-current instance from a complex scalar field with
    U(1) shift symmetry, demonstrating that the same abstract type
    captures both the geometric sector (harmonic gradient) and the
    gauge sector (charge current).
  * Prove that under coarse-graining, the abstract `ConservedCurrent`
    type lifts to a continuous conserved current on the emergent
    smooth manifold — giving a concrete bridge to the smooth-manifold
    community (Task #18).
  * Prove that the abstract type is closed under pullback through a
    lattice symmetry — showing that the meta-structure is itself
    symmetry-covariant.

None of this work requires new axioms; all of it is structural. -/

end OmegaTheory.Conservation
