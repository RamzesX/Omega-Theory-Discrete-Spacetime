/-
  OmegaTheory.Variational.DiscreteNoetherU1

  **Discrete Noether for U(1) on compact patches.**

  This module specialises the general discrete Noether infrastructure
  from `Variational/DiscreteNoether.lean` + `Variational/GraphAction.lean`
  together with the U(1) conserved currents from
  `Conservation/NoetherMetaStructure.lean` and `Geometry/DiscreteMaxwell.lean`
  to deliver the headline theorem
  `discrete_noether_u1_closed_on_compact_patches`: for every compact
  subset `S : Finset LatticePoint` of the substrate and every U(1)
  current from the framework, the discrete divergence summed over the
  patch is zero.

  Three complementary instantiations are proved:

  * `u1_link_noether_closed_on_compact_patch` — the Noether charge current
    `linkCurrent φ₁ φ₂` (two harmonic scalars coupled as the real and
    imaginary parts of a complex U(1) field).
  * `u1_maxwell_noether_closed_on_compact_patch` — the Maxwell source
    current `maxwellCurrent F` (the codifferential of any antisymmetric
    2-form, so the gauge-field form of U(1) current conservation).
  * `discrete_noether_u1_closed_on_compact_patches` — the headline Noether
    theorem for a `ConservedCurrent` (the meta-structure container for
    any U(1) current built from the framework).

  A corollary for `GaugeConnection` (the U(1) gauge potential with
  substrate error) is also provided, so the closed-patch property
  lifts directly to the `Emergence.ErrorGaugeField` API.

  Honesty notes:

  1.  The "compact patches" here are `Finset LatticePoint`. On the
      Planck lattice `ℤ⁴` every `Finset` is bounded and the induced
      subspace topology is discrete, so "compact" and "finite" coincide;
      we use `Finset` for directness of the lattice-summation statement.
  2.  The theorems are corollaries of pointwise conservation
      (`IsConserved J`) — the patch form is proved by
      `Finset.sum_eq_zero`, not by a genuine boundary/Stokes argument
      that would turn the sum into a surface term. See
      `Conservation/Information.lean::total_divergence_harmonic_zero`
      for the same pattern applied to the harmonic scalar sector.

  Agent: Alnitak (ζ Orionis), 2026-04-19.  No sorry, no new axioms.
-/

import OmegaTheory.Variational.DiscreteNoether
import OmegaTheory.Variational.GraphAction
import OmegaTheory.Conservation.NoetherMetaStructure
import OmegaTheory.Geometry.DiscreteMaxwell
import OmegaTheory.Emergence.ErrorGaugeField
import Mathlib.Tactic

namespace OmegaTheory.Variational

open OmegaTheory.Spacetime
open OmegaTheory.Conservation
open OmegaTheory.Geometry
open OmegaTheory.Foundations
open OmegaTheory.Emergence.ErrorGaugeField

/-! ## U(1) Noether — generic patch-summation lemma

The single mathematical fact underlying every variant below: if a
current `J` has pointwise zero divergence, then the sum of that
divergence over any `Finset` is zero.  This is the discrete analogue
of the standard Noether identity `∫_S ∂_μJ^μ = 0` on a closed patch. -/

/-- **Patch Noether identity** (generic form): a pointwise conserved
    current sums to zero on any compact patch. -/
theorem conserved_current_closed_on_compact_patch
    (J : InformationCurrent) (hJ : IsConserved J)
    (S : Finset LatticePoint) :
    (S.sum fun p => informationDivergence J p) = 0 := by
  apply Finset.sum_eq_zero
  intro p _
  exact hJ p

/-! ## U(1) charge current (link current of two harmonic scalars) -/

/-- **U(1) link-current Noether closed on a compact patch.**
    The lattice U(1) charge current `linkCurrent φ₁ φ₂` (antisymmetric
    bilinear in two harmonic scalars, the real and imaginary parts of
    a complex field) has zero summed divergence over any finite patch.

    This is the U(1) specialisation of the discrete Noether theorem:
    global phase rotation `φ → e^{iα}φ` is a U(1) symmetry, and the
    corresponding Noether current is `linkCurrent`; conservation
    summed on a compact region is `Σ_{p ∈ S} ∂_μJ^μ(p) = 0`. -/
theorem u1_link_noether_closed_on_compact_patch
    (φ₁ φ₂ : ScalarField) (h₁ : IsHarmonic φ₁) (h₂ : IsHarmonic φ₂)
    (S : Finset LatticePoint) :
    (S.sum fun p => informationDivergence (linkCurrent φ₁ φ₂) p) = 0 :=
  conserved_current_closed_on_compact_patch
    (linkCurrent φ₁ φ₂) (linkCurrent_conserved φ₁ φ₂ h₁ h₂) S

/-! ## U(1) gauge-field current (Maxwell source current) -/

/-- **U(1) Maxwell-current Noether closed on a compact patch.**
    The Maxwell source current `maxwellCurrent F = δ F` of any
    antisymmetric 2-form `F` has zero summed divergence over any
    finite patch.

    This is the gauge-field form of U(1) current conservation on a
    compact region: it follows from `δ² = 0` of the codifferential
    on the Planck lattice and holds regardless of whether `F` comes
    from a gauge potential `A` (i.e. `F = dA`) or is fundamental. -/
theorem u1_maxwell_noether_closed_on_compact_patch
    (F : Discrete2Form) (hanti : IsAntisymmetric2 F)
    (S : Finset LatticePoint) :
    (S.sum fun p => informationDivergence (maxwellCurrent F) p) = 0 :=
  conserved_current_closed_on_compact_patch
    (maxwellCurrent F) (maxwell_current_isConserved F hanti) S

/-- **U(1) Maxwell-current Noether from a gauge potential.**
    The special case where `F = d₁A` is exact, so the antisymmetry
    hypothesis is discharged by `d1_antisymmetric`. -/
theorem u1_maxwell_noether_from_potential_closed_on_compact_patch
    (A : Discrete1Form) (S : Finset LatticePoint) :
    (S.sum fun p => informationDivergence (maxwellCurrent (d1 A)) p) = 0 :=
  u1_maxwell_noether_closed_on_compact_patch (d1 A) (d1_antisymmetric A) S

/-! ## Headline theorem — U(1) discrete Noether on compact patches

The statement in its cleanest form: every instance of `ConservedCurrent`
— the `NoetherMetaStructure` container holding any U(1) current built
from the framework (link current, Maxwell current, gauge-connection
current, their sums and rescalings) — has zero summed divergence over
any compact patch.

This is the `Variational/DiscreteNoether.lean` + `Variational/GraphAction.lean`
integration delivered as a single corollary, via the `fourth_noether_meta_law`
bridge in `Conservation/NoetherMetaStructure.lean`. -/

/-- **Discrete Noether for U(1) closed on compact patches** (headline
    theorem).

    For every U(1) Noether current `J : ConservedCurrent` obtained from
    the framework and every compact lattice patch `S : Finset LatticePoint`,
    the discrete divergence of `J` summed over `S` vanishes:

        `Σ_{p ∈ S}  ∂_μ J.current^μ (p)  =  0`.

    This is the substrate version of the standard Noether identity
    `∫_S d*J = 0`, valid on any compact subset of the spacetime and
    for every U(1) current built from the framework (link current
    of a complex scalar, Maxwell source current of a gauge field,
    and any linear combination thereof via `addConservedCurrent` /
    `smulConservedCurrent`).

    Proof: unpack the `ConservedCurrent` bundle to obtain pointwise
    conservation (`fourth_noether_meta_law`) and apply
    `Finset.sum_eq_zero` over the patch. -/
theorem discrete_noether_u1_closed_on_compact_patches
    (J : ConservedCurrent) (S : Finset LatticePoint) :
    (S.sum fun p => informationDivergence J.current p) = 0 :=
  conserved_current_closed_on_compact_patch J.current J.conserved S

/-! ## Corollaries — instantiations of the headline theorem

The headline theorem is a single formula; the instantiations below
re-expose the two concrete U(1) sectors through the `ConservedCurrent`
container, so downstream files can cite the meta-structure form. -/

/-- **Link-current corollary.** Specialise the headline to the U(1)
    link current of two harmonic scalars. -/
theorem discrete_noether_u1_closed_on_compact_patches_link
    (φ₁ φ₂ : ScalarField) (h₁ : IsHarmonic φ₁) (h₂ : IsHarmonic φ₂)
    (S : Finset LatticePoint) :
    (S.sum fun p =>
        informationDivergence
          (u1ChargeConservedCurrent φ₁ φ₂ h₁ h₂).current p) = 0 :=
  discrete_noether_u1_closed_on_compact_patches
    (u1ChargeConservedCurrent φ₁ φ₂ h₁ h₂) S

/-- **Maxwell-current corollary.** Specialise the headline to the U(1)
    Maxwell source current of an antisymmetric 2-form. -/
theorem discrete_noether_u1_closed_on_compact_patches_maxwell
    (F : Discrete2Form) (hanti : IsAntisymmetric2 F)
    (S : Finset LatticePoint) :
    (S.sum fun p =>
        informationDivergence
          (maxwellConservedCurrent F hanti).current p) = 0 :=
  discrete_noether_u1_closed_on_compact_patches
    (maxwellConservedCurrent F hanti) S

/-- **Gauge-potential corollary.** Specialise the headline to the
    Maxwell current of an exact field `F = d₁A`. -/
theorem discrete_noether_u1_closed_on_compact_patches_exact
    (A : Discrete1Form) (S : Finset LatticePoint) :
    (S.sum fun p =>
        informationDivergence (maxwellFromAny A).current p) = 0 :=
  discrete_noether_u1_closed_on_compact_patches (maxwellFromAny A) S

/-- **GaugeConnection corollary.** Lift the headline to the
    `Emergence.ErrorGaugeField.GaugeConnection` API: the Maxwell
    current induced by any U(1) gauge connection (with or without
    substrate error) is Noether-closed on every compact patch. -/
theorem discrete_noether_u1_closed_on_compact_patches_gauge
    (gc : GaugeConnection) (ε_source : ErrorBound)
    (S : Finset LatticePoint) :
    (S.sum fun p =>
        informationDivergence
          (maxwellCurrent (gaugeCurvature_is_errorMaxwell gc ε_source).F) p) = 0 :=
  u1_maxwell_noether_closed_on_compact_patch
    (gaugeCurvature_is_errorMaxwell gc ε_source).F
    (gaugeCurvature_is_errorMaxwell gc ε_source).antisym S

/-! ## Superposition closure — U(1) on compact patches is a linear space

Any linear combination of U(1) Noether currents is still Noether-closed
on every compact patch.  This follows directly from the closure of
`ConservedCurrent` under `addConservedCurrent` and `smulConservedCurrent`
from `Conservation/NoetherMetaStructure.lean`. -/

/-- **Additive closure.** The sum of two U(1) conserved currents is
    Noether-closed on every compact patch. -/
theorem discrete_noether_u1_closed_on_compact_patches_add
    (J₁ J₂ : ConservedCurrent) (S : Finset LatticePoint) :
    (S.sum fun p =>
        informationDivergence (addConservedCurrent J₁ J₂).current p) = 0 :=
  discrete_noether_u1_closed_on_compact_patches (addConservedCurrent J₁ J₂) S

/-- **Scalar-multiplicative closure.** Rescaling a U(1) conserved
    current preserves Noether-closure on every compact patch. -/
theorem discrete_noether_u1_closed_on_compact_patches_smul
    (c : ℝ) (J : ConservedCurrent) (S : Finset LatticePoint) :
    (S.sum fun p =>
        informationDivergence (smulConservedCurrent c J).current p) = 0 :=
  discrete_noether_u1_closed_on_compact_patches (smulConservedCurrent c J) S

end OmegaTheory.Variational
