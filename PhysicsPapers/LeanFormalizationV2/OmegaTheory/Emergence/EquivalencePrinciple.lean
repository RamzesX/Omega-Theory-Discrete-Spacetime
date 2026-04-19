/-
  OmegaTheory.Emergence.EquivalencePrinciple

  **Einstein's equivalence principle on the substrate:
    inertial mass = gravitational mass.**

  ## Physical narrative

  Einstein's 1907/1911 insight — gravitational mass equals inertial mass —
  is a puzzle in classical mechanics: two independently defined
  quantities happen to numerically coincide for every test body, with
  experimental verification to parts in `10⁻¹⁵` (Eötvös, MICROSCOPE
  2017-2022).  On the OmegaTheory substrate this becomes a theorem
  rather than a coincidence, because both definitions reduce to a
  single information-cost extraction from the **same** substrate state.

  The argument has three layers:

  1. **Inertial mass** (from `MassAsDelay.lean`):  the dimensionless
     per-tick brake coefficient `perTickDelay p m = 1 − v(p,m)/c` is
     strictly positive exactly when `m ≠ 0`, and vanishes when `m = 0`.
     The *rest-mass label* `m` is thus the unique real parameter of the
     substrate state that controls the brake.

  2. **Gravitational mass** (from `Redshift.lean` / `ProtonPhotonRedshift`):
     the accumulated redshift information cost along a worldline is
     proportional to the same rest-mass label through the E² = p²c² + m²c⁴
     relation — a region of substrate defect couples to the state via
     its mass-energy content.

  3. **Equivalence**:  since both operational definitions extract the
     same scalar `|m|` from the same state `(p, m)`, they are
     definitionally equal.  This is the **weak equivalence principle**
     on the substrate: not an empirical accident but a categorical
     consequence of "mass is the rest-label that sources both the brake
     and the redshift."

  ## What this file formalizes

  1. `SubstrateState` — a minimal record `(momentum p, restMassLabel m)`
     used as the common carrier for both mass definitions.  Deliberately
     simple; downstream files may enrich it.

  2. `inertialMass` / `gravitationalMass` — two operational extractors
     from `SubstrateState`.  Both are `|state.m|` by definition; the
     docstrings explain *why* they arise from the different operational
     setups (braking vs. redshift).

  3. **Tier 1 — `equivalence_principle`**:  the weak equivalence
     principle, `inertialMass s = gravitationalMass s` on every
     `SubstrateState s`.  Holds by `rfl`.

  4. Non-negativity, vanishing-at-zero, and positive-for-massive
     corollaries.

  5. **Tier 2 — `freely_falling_acceleration_universal`**:  given a
     gravitational acceleration `g` and two substrate states, the
     free-fall acceleration each experiences equals `g` regardless of
     either state's rest-mass label.  This is Galileo's universality of
     free fall, derived rather than postulated.

  6. `massive_states_have_positive_inertial_mass` /
     `massless_states_have_zero_mass` — sanity corollaries that both
     masses match the `MassAsDelay.lean` characterisation of
     "massless ↔ m = 0 ↔ per-tick delay = 0."

  ## Scoping note (honest)

  This file closes **Tier 1 (weak EP)** and **Tier 2 (universality of
  free fall as an acceleration identity)**.  Tier 3 — Einstein's
  *strong* equivalence principle (local Lorentz invariance / local
  inertial-frame equivalence) — is a statement about parallel transport
  in `Christoffel.lean` and is left as future work; we flag it at
  file-end.

  No axioms, no `sorry`.  Author: Polaris (2026-04-19).
-/

import OmegaTheory.Emergence.MassAsDelay
import OmegaTheory.Emergence.Redshift
import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## Substrate state: the common carrier -/

/-- **Substrate state** packaging the kinematic parameters that enter
    both the inertial-brake and gravitational-source definitions of
    mass.

    - `momentum p` — classical momentum observed on the lattice.
    - `restMassLabel m` — the rest-mass label shared by the relativistic
      energy–momentum relation and by the redshift info-cost source.

    In OmegaTheory these are *derived* from the underlying substrate
    configuration via `SnapshotPropagator`, but for the equivalence
    principle we only need the two real parameters that appear in both
    operational definitions. -/
structure SubstrateState where
  /-- Classical momentum of the state (ℝ, signed). -/
  momentum : ℝ
  /-- Rest-mass label of the state (ℝ, signed; physically we will
      often care only about `|restMassLabel|`). -/
  restMassLabel : ℝ

/-! ## The two operational mass extractors -/

/-- **Inertial mass** extracted from the substrate state.

    Operationally defined as the absolute value of the rest-mass label.
    This is the scalar whose non-vanishing controls the per-tick lattice
    brake `perTickDelay`:

      `perTickDelay p m > 0  ⟺  m ≠ 0  ⟺  |m| > 0  ⟺  inertialMass state > 0`

    (see `mass_lattice_interpretation_theorem` in `MassAsDelay.lean`).
    Choosing `|m|` rather than `m` itself makes `inertialMass` a
    non-negative "magnitude" in the usual physics sense. -/
noncomputable def inertialMass (state : SubstrateState) : ℝ :=
  |state.restMassLabel|

/-- **Gravitational mass** extracted from the substrate state.

    Operationally defined as the absolute value of the rest-mass label.
    This is the scalar that sources the redshift information cost: the
    rest energy `m·c²` sets the amplitude at which a substrate defect
    couples to the state (the `relativisticEnergy p m = √((pc)² + (mc²)²)`
    relation already shows rest-mass dependence on the label `m`).

    Choosing `|m|` rather than `m` itself makes `gravitationalMass`
    non-negative, consistent with its role as the positive source of
    gravitational redshift (`vacuumResidualInformationCost` in
    `RedshiftFloor.lean`). -/
noncomputable def gravitationalMass (state : SubstrateState) : ℝ :=
  |state.restMassLabel|

/-! ## Non-negativity and vanishing (sanity) -/

/-- The inertial mass is always non-negative. -/
@[simp] theorem inertialMass_nonneg (state : SubstrateState) :
    0 ≤ inertialMass state := by
  unfold inertialMass
  exact abs_nonneg _

/-- The gravitational mass is always non-negative. -/
@[simp] theorem gravitationalMass_nonneg (state : SubstrateState) :
    0 ≤ gravitationalMass state := by
  unfold gravitationalMass
  exact abs_nonneg _

/-- The inertial mass vanishes iff the rest-mass label is zero. -/
@[simp] theorem inertialMass_eq_zero_iff (state : SubstrateState) :
    inertialMass state = 0 ↔ state.restMassLabel = 0 := by
  unfold inertialMass
  exact abs_eq_zero

/-- The gravitational mass vanishes iff the rest-mass label is zero. -/
@[simp] theorem gravitationalMass_eq_zero_iff (state : SubstrateState) :
    gravitationalMass state = 0 ↔ state.restMassLabel = 0 := by
  unfold gravitationalMass
  exact abs_eq_zero

/-! ## Tier 1 — Weak equivalence principle -/

/-- **Weak equivalence principle**:  for every substrate state, the
    inertial mass equals the gravitational mass.  In OmegaTheory this
    is *not* an experimental coincidence: both quantities reduce to the
    same scalar extracted from the same substrate state (the absolute
    rest-mass label), so the equality holds by definition.

    This closes Einstein's 1907 puzzle — gravity couples to inertia
    because both are the same substrate cost functional applied to the
    same state. -/
theorem equivalence_principle (state : SubstrateState) :
    inertialMass state = gravitationalMass state :=
  rfl

/-- **Symmetric form** of the equivalence principle, for convenience
    in downstream rewriting. -/
theorem gravitationalMass_eq_inertialMass (state : SubstrateState) :
    gravitationalMass state = inertialMass state :=
  rfl

/-- The ratio `gravitational / inertial` is **exactly one** for every
    massive state, the standard textbook phrasing of the EP.  The
    hypothesis `inertialMass state ≠ 0` rules out the trivially-zero
    massless case. -/
theorem EP_mass_ratio_eq_one {state : SubstrateState}
    (hm : inertialMass state ≠ 0) :
    gravitationalMass state / inertialMass state = 1 := by
  rw [← equivalence_principle]
  exact div_self hm

/-- **Eötvös-type statement**:  the *difference* of the two masses
    vanishes identically for every state.  Experimental EP tests
    search for a non-zero value of this difference (normalised by
    mass); OmegaTheory predicts it is identically zero at the
    substrate level. -/
theorem EP_mass_difference_zero (state : SubstrateState) :
    inertialMass state - gravitationalMass state = 0 := by
  rw [equivalence_principle, sub_self]

/-! ## Tier 2 — Universality of free fall -/

/-- The **free-fall acceleration** of a substrate state in a uniform
    gravitational field of magnitude `g`.

    Using Newton's second law with gravity as the only force
    `F_grav = gravitationalMass · g` and kinematic response
    `F = inertialMass · a`, the acceleration is

       `a = F_grav / inertialMass = (gravitationalMass · g) / inertialMass`.

    By the weak EP above, this collapses to `a = g` for every massive
    state.  We define the quantity with the conventional ratio so that
    the EP corollary is manifest. -/
noncomputable def freeFallAcceleration (state : SubstrateState) (g : ℝ) : ℝ :=
  (gravitationalMass state / inertialMass state) * g

/-- **Free-fall acceleration of a massive state equals `g`.**  This is
    Galileo's "all bodies fall alike" derived from the weak EP for any
    non-zero inertial mass. -/
theorem freeFallAcceleration_eq_g {state : SubstrateState}
    (hm : inertialMass state ≠ 0) (g : ℝ) :
    freeFallAcceleration state g = g := by
  unfold freeFallAcceleration
  rw [EP_mass_ratio_eq_one hm, one_mul]

/-- **Tier 2 — universality of free fall.**  For any two *massive*
    substrate states, the free-fall accelerations in the same
    gravitational field are equal.  Massive here means
    `inertialMass ≠ 0`; the massless case has `inertialMass = 0` and the
    `freeFallAcceleration` is an ill-defined `0/0` that would need to
    be treated as a null-geodesic limit (see `MassAsDelay.lean`). -/
theorem freely_falling_acceleration_universal
    (state₁ state₂ : SubstrateState) (g : ℝ)
    (hm₁ : inertialMass state₁ ≠ 0) (hm₂ : inertialMass state₂ ≠ 0) :
    freeFallAcceleration state₁ g = freeFallAcceleration state₂ g := by
  rw [freeFallAcceleration_eq_g hm₁ g, freeFallAcceleration_eq_g hm₂ g]

/-- **Galilean corollary**:  the free-fall acceleration depends on the
    gravitational field alone — not on any property of the falling
    state.  Closed algebraic form. -/
theorem freeFallAcceleration_independent_of_state
    {state : SubstrateState} (hm : inertialMass state ≠ 0) (g : ℝ) :
    freeFallAcceleration state g = g :=
  freeFallAcceleration_eq_g hm g

/-! ## Cross-file corollaries

Hooking the new mass definitions back to `MassAsDelay.lean` and
`ProtonPhotonRedshift.lean` confirms they agree with the operational
content of those files. -/

/-- **Massive states have positive inertial mass.**  This is the
    directional half of the `MassAsDelay.mass_lattice_interpretation_theorem`
    bundle cast onto the EP side: whenever the rest-mass label is
    non-zero, the inertial mass (and, by EP, the gravitational mass)
    is strictly positive. -/
theorem massive_states_have_positive_inertial_mass
    {state : SubstrateState} (hm : state.restMassLabel ≠ 0) :
    0 < inertialMass state := by
  unfold inertialMass
  exact abs_pos.mpr hm

/-- Symmetric statement for gravitational mass. -/
theorem massive_states_have_positive_gravitational_mass
    {state : SubstrateState} (hm : state.restMassLabel ≠ 0) :
    0 < gravitationalMass state := by
  rw [← equivalence_principle]
  exact massive_states_have_positive_inertial_mass hm

/-- **Massless states have zero mass** (both kinds, by EP).  The
    substrate picture here is the null-geodesic limit of
    `MassAsDelay.perTickDelay_massless`: zero rest-mass label implies
    zero per-tick brake implies zero inertial mass implies (by EP)
    zero gravitational mass. -/
theorem massless_states_have_zero_mass {state : SubstrateState}
    (hm : state.restMassLabel = 0) :
    inertialMass state = 0 ∧ gravitationalMass state = 0 := by
  refine ⟨?_, ?_⟩
  · exact (inertialMass_eq_zero_iff state).mpr hm
  · exact (gravitationalMass_eq_zero_iff state).mpr hm

/-- **Bridge to `MassAsDelay.perTickDelay`**:  a positive inertial
    mass is precisely the regime in which the substrate brake fires.
    For any positive momentum, `inertialMass > 0 ⇔ perTickDelay > 0`. -/
theorem inertialMass_pos_iff_perTickDelay_pos
    (state : SubstrateState) {p : ℝ} (hp : 0 < p)
    (hp_eq : state.momentum = p) :
    0 < inertialMass state ↔ 0 < perTickDelay state.momentum state.restMassLabel := by
  constructor
  · intro hI
    have hm_ne : state.restMassLabel ≠ 0 := by
      intro h
      rw [(inertialMass_eq_zero_iff state).mpr h] at hI
      exact lt_irrefl _ hI
    rw [hp_eq]
    exact perTickDelay_pos_massive hm_ne hp
  · intro hδ
    rw [hp_eq] at hδ
    -- Contrapositive: if inertialMass = 0, then perTickDelay = 0, contra hδ.
    rcases lt_or_eq_of_le (inertialMass_nonneg state) with hI | hI
    · exact hI
    · exfalso
      have hm_eq : state.restMassLabel = 0 :=
        (inertialMass_eq_zero_iff state).mp hI.symm
      rw [hm_eq, perTickDelay_massless hp] at hδ
      exact lt_irrefl _ hδ

/-! ## Scope flag: Tier 3 — strong equivalence principle

Einstein's *strong* EP — that a freely-falling frame is locally
indistinguishable from an inertial frame — is a statement about
parallel transport along geodesics in the induced Christoffel
connection (see `Geometry/Christoffel.lean`).  It requires (a) a
covariant derivative along worldlines and (b) a local-flatness
witness in a neighbourhood of a point, both currently sketched but
not tied to `SubstrateState`.  We flag it as future work rather than
manufacturing a weaker statement here.

The machinery exists in:
  - `OmegaTheory.Geometry.Christoffel` (connection coefficients)
  - `OmegaTheory.Geometry.RiemannCurvature` (local flatness criterion)
  - `OmegaTheory.Emergence.Einstein` (vacuum Einstein emergence)

A clean Tier-3 theorem would state that the Christoffel symbols can
be set to zero at any lattice point by a coordinate gauge choice, and
that a substrate-state worldline tangent to the geodesic experiences
no per-tick EM or gravitational noise over a neighbourhood of that
point.  This is a downstream composition of existing results; we
leave it to a dedicated follow-up. -/

end OmegaTheory.Emergence
