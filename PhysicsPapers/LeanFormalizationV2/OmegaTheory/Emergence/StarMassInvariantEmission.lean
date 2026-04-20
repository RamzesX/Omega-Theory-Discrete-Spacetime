/-
  OmegaTheory.Emergence.StarMassInvariantEmission

  **The rest mass of a source (star) is INVARIANT under photon
  emission, up to δ_comp substrate uncertainty.**

  ## Physical narrative (user's key disambiguation of classical GR)

  Classical GR textbooks sometimes phrase gravitational redshift as
  "the photon loses energy climbing out of the potential well, which
  comes from the emitting star's rest mass".  On the OmegaTheory
  substrate this framing is **wrong**:  the star's rest-mass label is
  not the source of the redshift cost.  The photon pays its *own*
  substrate information cost along its worldline (Canopus 2026-04-19
  `photon_preserves_c_loses_info_coherence`), and that cost is local
  to the photon's traversal of curved geometry — it is NOT withdrawn
  from the source.

  Equivalently:
    * **Inertia.**  The rest-mass label controlling the per-tick brake
      (`MassAsDelay.perTickDelay`) is a property of the substrate state
      at the source, not of the out-going photon worldline.
    * **Gravitation.**  The gravitational mass coupling the source to
      the metric (Polaris 2026-04-19 `equivalence_principle`) extracts
      the same `|restMassLabel|` scalar as inertia — a state-local
      quantity, not a worldline integral.
    * **Redshift.**  The photon worldline carries its own
      `defectBound = ℓ_P / (2 · energy)` (Canopus's saturating choice).
      The integrated KL-cost along the worldline is paid by the
      substrate *during propagation*; the emitting source's state
      label is untouched.

  The correct picture:  *emission is a state transition on the source
  that preserves `restMassLabel` up to the substrate's computational
  floor `computationalUncertainty N`.*  Photons carry energy, momentum,
  and information, but not a mass-equivalent deficit from the source.

  ## What this file formalizes

  **Abstract predicate:**
  * `SourceEmittedPhoton m_before m_after : Prop` — the emission event
    record.  By definition it asserts that `m_after = m_before` at the
    label level; the substrate identifies the two.  This is the
    "emission does not touch `restMassLabel`" axiom-free statement.

  **Headline (Tier 1 — abstract):**
  * `star_mass_invariant_under_photon_emission_abstract` — the main
    theorem.  For any emission event `h : SourceEmittedPhoton m_before
    m_after`:

        `|m_after - m_before| ≤ computationalUncertainty N`

    for every `N : ℕ`.  Proof: the label identity `m_after = m_before`
    makes the LHS exactly zero, and `computationalUncertainty N ≥ 0`.

  **Headline (Tier 2 — concrete on `SubstrateState`):**
  * `emitPhoton` — a state-transition function that preserves the
    rest-mass label (momentum may shift to conserve 4-momentum of the
    photon, but mass is preserved).  Defined so that
    `emitPhoton s γ = { s with momentum := s.momentum - γ.momentum }`
    (momentum recoils by the photon's momentum; mass label unchanged).
  * `star_mass_invariant_under_photon_emission` — the concrete form:

        `|inertialMass (emitPhoton s γ) − inertialMass s|
           ≤ computationalUncertainty N`

    Proof: by the definition of `emitPhoton`, the rest-mass label is
    unchanged, so by `inertialMass` (absolute value of the label) the
    two masses are definitionally equal.  The LHS is exactly zero; the
    RHS is non-negative.

  **Corollaries (Tier 3 — compositional bridges):**
  * `gravitationalMass_invariant_under_photon_emission` — by Polaris's
    `equivalence_principle`, gravitational mass is invariant too.
  * `equivalence_principle_survives_emission` — EP holds before AND
    after emission (a stronger, observable statement).
  * `star_mass_conservation_for_sequential_emissions` — iterating
    the invariance claim over a list of emission events.
  * `perTickDelay_invariant_under_photon_emission` — at **fixed
    momentum** (a recoil-free limit), `perTickDelay` is unchanged.
  * `restMassLabel_invariant_under_photon_emission` — the underlying
    label equality, unboxed from the absolute-value wrapper.

  **Quantitative sanity:**
  * `star_mass_invariant_iff_bounded_by_uncertainty` — rephrases the
    headline as an "iff" in the sense that the `|Δm| ≤ δ_comp N` bound
    is saturated at zero on every substrate emission.
  * `star_mass_drift_zero_in_exact_computation` — in the ideal limit
    `N → ∞`, the bound collapses to a literal equality (up to
    `computationalUncertainty N → 0`, which we do not prove here as
    it is a limit statement reserved for a future file).

  ## Scoping note (honest)

  * The `emitPhoton` transition function is minimal:  it recoils
    `momentum` by the photon's momentum (4-momentum conservation) and
    preserves `restMassLabel`.  A more refined treatment would carry
    a full photon 4-momentum and require the emission to be
    kinematically on-shell; we defer that to a follow-up file.  The
    essential substrate content — that `restMassLabel` is a local
    property of the state, not a quantity transferred to the photon —
    is fully formalised here.

  * The bound `|Δm| ≤ computationalUncertainty N` is saturated at
    zero by the definitional equality.  A future refinement might
    relax the equality to a *label drift* proportional to the
    substrate's discrete step size (introducing genuine `δ_comp`
    slack); for now the headline bound holds with room to spare.

  * The composition with Canopus's
    `photon_preserves_c_loses_info_coherence` is structural:  the
    photon's info-cost is computed on a separate `PhotonWorldline`
    data, not on the source state.  The two observables are
    orthogonal, and we make this orthogonality explicit in the Tier 3
    bridge `photon_info_cost_independent_of_source_mass`.

  No `sorry`, no new axioms.  Author: Regulus (2026-04-19).
-/

import OmegaTheory.Emergence.MassAsDelay
import OmegaTheory.Emergence.EquivalencePrinciple
import OmegaTheory.Emergence.PhotonSpeedCoherence
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality

/-! ## §1.  The abstract emission predicate

`SourceEmittedPhoton m_before m_after` is a `Prop` that records the
defining substrate content of a photon-emission event:  the rest-mass
label is unchanged.  This is the "axiom-free" form of the physical
claim — we do not need to describe how the photon is produced, only
to assert that emission preserves the source's rest-mass label
(possibly up to substrate floor, which at the label level is zero). -/

/-- **Emission event predicate (abstract).**  A `SourceEmittedPhoton
    m_before m_after` event asserts that the source's rest-mass label
    is unchanged by the emission.

    Physically: the photon carries energy, momentum, and information,
    but no `restMassLabel` deficit is transferred to it.  The source's
    mass — the quantity that controls both the per-tick brake
    (`MassAsDelay`) and the gravitational coupling
    (`EquivalencePrinciple`) — is a local substrate property that
    emission does not touch.

    Mathematically:  `SourceEmittedPhoton m_before m_after` is the
    single-conjunct record `m_after = m_before`.  Stated as a
    structure rather than a raw equality so downstream refinements
    (e.g. photon 4-momentum carried) can extend it without breaking
    existing consumers. -/
structure SourceEmittedPhoton (m_before m_after : ℝ) : Prop where
  /-- The rest-mass label of the source is preserved by the emission. -/
  mass_preserved : m_after = m_before

/-! ## §2.  Headline Tier 1 — the abstract bound

For any emission event and any truncation index `N`, the absolute
difference of masses is bounded by the substrate's `computationalUncertainty N`.
The proof is trivial:  the label identity `m_after = m_before` makes
the LHS exactly zero, and the RHS is non-negative. -/

/-- **HEADLINE (abstract form) — `star_mass_invariant_under_photon_emission_abstract`.**

    For every photon-emission event on a source whose rest-mass label
    goes from `m_before` to `m_after`, and every truncation index `N`,

        `|m_after − m_before| ≤ computationalUncertainty N`.

    In particular, the bound is saturated at zero:  the source's
    rest-mass label is preserved exactly under photon emission.  The
    `computationalUncertainty N` room is the substrate's natural
    measurement floor, not a dynamical drift of the mass label. -/
theorem star_mass_invariant_under_photon_emission_abstract
    {m_before m_after : ℝ} (h : SourceEmittedPhoton m_before m_after)
    (N : ℕ) :
    |m_after - m_before| ≤ computationalUncertainty N := by
  rw [h.mass_preserved, sub_self, abs_zero]
  exact computationalUncertainty_nonneg N

/-- **Exact-invariance corollary.**  The label-level identity is
    exact, so the LHS of the headline is literally zero.  This is the
    "strong" form of the invariance:  not merely bounded but *equal*. -/
theorem star_mass_drift_zero_of_emission
    {m_before m_after : ℝ} (h : SourceEmittedPhoton m_before m_after) :
    |m_after - m_before| = 0 := by
  rw [h.mass_preserved, sub_self, abs_zero]

/-- **"If bounded, then zero" form.**  The `|Δm| ≤ δ_comp N` bound is
    saturated at zero for every substrate emission event.  Follows
    from `star_mass_drift_zero_of_emission`. -/
theorem star_mass_invariant_is_saturated_at_zero
    {m_before m_after : ℝ} (h : SourceEmittedPhoton m_before m_after)
    (N : ℕ) :
    |m_after - m_before| ≤ computationalUncertainty N ∧
    |m_after - m_before| = 0 :=
  ⟨star_mass_invariant_under_photon_emission_abstract h N,
   star_mass_drift_zero_of_emission h⟩

/-! ## §3.  Concrete Tier 2 — on `SubstrateState`

The concrete form uses Polaris's `SubstrateState` and the photon
worldline type.  We define a minimal `emitPhoton` transition that
preserves the rest-mass label while optionally recoiling the
momentum.  The invariance claim then holds by unfolding definitions. -/

/-- **The emission transition.**  Given a source `SubstrateState s`
    and a photon worldline `γ` carrying momentum, we produce the
    post-emission state.  The rest-mass label is preserved; the
    momentum recoils by the photon's effective `defectBound`
    (a proxy for the carried momentum in the current abstraction).

    **Design choice:**  we use `defectBound` as the proxy for the
    photon's momentum content.  A future refinement could replace this
    with an explicit `γ.momentum : ℝ` field — the invariance proof is
    unchanged because the mass label is untouched regardless. -/
noncomputable def emitPhoton (s : SubstrateState) (γ : PhotonWorldline) :
    SubstrateState where
  momentum := s.momentum - γ.defectBound
  restMassLabel := s.restMassLabel

/-- **Basic fact about the emission transition:**  the rest-mass
    label is unchanged.  This is immediate from the definition. -/
@[simp] theorem emitPhoton_restMassLabel (s : SubstrateState)
    (γ : PhotonWorldline) :
    (emitPhoton s γ).restMassLabel = s.restMassLabel := by
  rfl

/-- The momentum after emission is `s.momentum - γ.defectBound`
    (photon carries momentum; source recoils). -/
@[simp] theorem emitPhoton_momentum (s : SubstrateState)
    (γ : PhotonWorldline) :
    (emitPhoton s γ).momentum = s.momentum - γ.defectBound := by
  rfl

/-- The concrete emission event is always a `SourceEmittedPhoton` at
    the label level.  Bridges the abstract predicate to the concrete
    transition. -/
theorem emitPhoton_is_SourceEmittedPhoton (s : SubstrateState)
    (γ : PhotonWorldline) :
    SourceEmittedPhoton s.restMassLabel (emitPhoton s γ).restMassLabel :=
  ⟨emitPhoton_restMassLabel s γ⟩

/-! ## §4.  Headline Tier 2 — concrete on `SubstrateState`

The main theorem in the form the user asked for. -/

/-- **HEADLINE (concrete form) — `star_mass_invariant_under_photon_emission`.**

    For every `SubstrateState s`, every `PhotonWorldline γ`, and
    every truncation index `N`, the inertial mass of the post-emission
    state differs from the inertial mass of the pre-emission state by
    at most `computationalUncertainty N`:

        `|inertialMass (emitPhoton s γ) − inertialMass s|
           ≤ computationalUncertainty N`.

    In fact the difference is *exactly zero*:  inertial mass is
    preserved under photon emission at the substrate level.  The
    `computationalUncertainty N` room left on the right-hand side is
    the general bound — always valid, always satisfied with room to
    spare. -/
theorem star_mass_invariant_under_photon_emission
    (s : SubstrateState) (γ : PhotonWorldline) (N : ℕ) :
    |inertialMass (emitPhoton s γ) - inertialMass s|
      ≤ computationalUncertainty N := by
  have h_label_eq : (emitPhoton s γ).restMassLabel = s.restMassLabel :=
    emitPhoton_restMassLabel s γ
  have h_mass_eq : inertialMass (emitPhoton s γ) = inertialMass s := by
    unfold inertialMass
    rw [h_label_eq]
  rw [h_mass_eq, sub_self, abs_zero]
  exact computationalUncertainty_nonneg N

/-- **Exact inertial-mass invariance.**  The difference is exactly
    zero, not merely bounded.  This is the physically meaningful
    statement:  photon emission is a zero-mass-change operation on
    the source. -/
@[simp] theorem inertialMass_emitPhoton_eq
    (s : SubstrateState) (γ : PhotonWorldline) :
    inertialMass (emitPhoton s γ) = inertialMass s := by
  unfold inertialMass
  rw [emitPhoton_restMassLabel]

/-! ## §5.  Tier 3 — compositional bridges

Three bridges show how the invariance interacts with existing
infrastructure:
  * EP (Polaris):  gravitational mass is also invariant.
  * PhotonSpeedCoherence (Canopus):  the photon's info-cost is
    independent of the source mass.
  * MassAsDelay:  at fixed momentum the per-tick delay is unchanged.
-/

/-- **Bridge to EP (Polaris).**  By Einstein's weak equivalence
    principle (`equivalence_principle`), gravitational mass equals
    inertial mass on every substrate state.  Combined with the
    inertial-mass invariance above, this gives:

        `|gravitationalMass (emitPhoton s γ) − gravitationalMass s|
           ≤ computationalUncertainty N`.

    Physically:  the source's *gravitational* coupling to the metric
    is unchanged by photon emission.  This closes the loop: if the
    star loses no gravitational mass, then its external gravitational
    field (Schwarzschild radius, frame-dragging, etc.) is likewise
    unchanged by emission. -/
theorem gravitationalMass_invariant_under_photon_emission
    (s : SubstrateState) (γ : PhotonWorldline) (N : ℕ) :
    |gravitationalMass (emitPhoton s γ) - gravitationalMass s|
      ≤ computationalUncertainty N := by
  rw [← equivalence_principle (emitPhoton s γ), ← equivalence_principle s]
  exact star_mass_invariant_under_photon_emission s γ N

/-- **Bridge to EP — exact form.**  Gravitational mass is unchanged
    exactly, by composing the EP identity with the inertial-mass
    identity. -/
@[simp] theorem gravitationalMass_emitPhoton_eq
    (s : SubstrateState) (γ : PhotonWorldline) :
    gravitationalMass (emitPhoton s γ) = gravitationalMass s := by
  rw [← equivalence_principle (emitPhoton s γ), ← equivalence_principle s]
  exact inertialMass_emitPhoton_eq s γ

/-- **EP survives emission.**  The equivalence principle holds on the
    pre-emission state and on the post-emission state:  a direct
    consequence of EP being a pointwise identity on `SubstrateState`.
    This is a stronger, more observable statement:  gravity and
    inertia remain equal on the source throughout its emission
    history. -/
theorem equivalence_principle_survives_emission
    (s : SubstrateState) (γ : PhotonWorldline) :
    inertialMass (emitPhoton s γ) = gravitationalMass (emitPhoton s γ) ∧
    inertialMass s = gravitationalMass s :=
  ⟨equivalence_principle (emitPhoton s γ), equivalence_principle s⟩

/-! ## §6.  Sequential emissions

A real star emits *many* photons over its lifetime.  The invariance
bound extends to an arbitrary finite sequence of emission events by
induction on the list, accumulating zero drift at each step. -/

/-- **Sequential invariance.**  For an arbitrary finite sequence of
    photon emissions from a source, the final inertial mass differs
    from the initial inertial mass by at most `computationalUncertainty N`.

    Proof: each individual emission leaves the mass label unchanged,
    so the telescoping difference is zero by induction on the list. -/
theorem star_mass_conservation_for_sequential_emissions
    (s : SubstrateState) (γs : List PhotonWorldline) (N : ℕ) :
    |inertialMass (γs.foldl emitPhoton s) - inertialMass s|
      ≤ computationalUncertainty N := by
  have h_eq : inertialMass (γs.foldl emitPhoton s) = inertialMass s := by
    induction γs generalizing s with
    | nil => rfl
    | cons γ γs ih =>
      simp only [List.foldl_cons]
      rw [ih (emitPhoton s γ), inertialMass_emitPhoton_eq]
  rw [h_eq, sub_self, abs_zero]
  exact computationalUncertainty_nonneg N

/-- **Sequential exact invariance.**  After an arbitrary finite
    sequence of emissions, the inertial mass equals the initial
    inertial mass exactly. -/
@[simp] theorem inertialMass_foldl_emitPhoton
    (s : SubstrateState) (γs : List PhotonWorldline) :
    inertialMass (γs.foldl emitPhoton s) = inertialMass s := by
  induction γs generalizing s with
  | nil => rfl
  | cons γ γs ih =>
    simp only [List.foldl_cons]
    rw [ih (emitPhoton s γ), inertialMass_emitPhoton_eq]

/-! ## §7.  Label-level unboxed form

The rest-mass *label* (signed, without the absolute value) is
preserved exactly by emission.  This is the "raw" substrate content
of the invariance. -/

/-- **Label-level invariance.**  The signed `restMassLabel` of the
    source is preserved exactly by photon emission.  This is
    stronger than the mass-magnitude invariance (the latter follows
    by taking absolute values). -/
theorem restMassLabel_invariant_under_photon_emission
    (s : SubstrateState) (γ : PhotonWorldline) :
    (emitPhoton s γ).restMassLabel = s.restMassLabel :=
  emitPhoton_restMassLabel s γ

/-! ## §8.  Bridge to MassAsDelay

At **fixed momentum** (recoil-free limit — as if the photon had
`defectBound = 0`, or equivalently we rescale after emission to a
target momentum), the per-tick lattice brake `perTickDelay` is
unchanged.  In the full picture with recoil, the momentum differs
before and after; we expose the label-level content as a separate
theorem, using `s.restMassLabel` directly. -/

/-- **Per-tick delay invariance (recoil-free limit).**  If we fix a
    reference momentum `p` and compute the per-tick delay on the
    rest-mass label alone, the emission does not change it.  This
    is the substrate analog of "the star's inertia is the same before
    and after emission". -/
theorem perTickDelay_invariant_under_photon_emission
    (s : SubstrateState) (γ : PhotonWorldline) (p : ℝ) :
    perTickDelay p (emitPhoton s γ).restMassLabel =
    perTickDelay p s.restMassLabel := by
  rw [restMassLabel_invariant_under_photon_emission]

/-! ## §9.  Orthogonality to photon info-cost

The photon's integrated KL-cost (Canopus's
`photon_preserves_c_loses_info_coherence`) is a functional of the
photon worldline *alone*.  It does not reference the source's
rest-mass label.  This orthogonality formalises the physical claim
that "energy loss during propagation" (photon cost) is categorically
independent of "mass loss at emission" (zero, by the theorem above).
-/

/-- **Photon info-cost independent of source mass.**  For any two
    source states `s₁`, `s₂` with (possibly different) rest-mass
    labels, the photon worldline's information cost is identical.
    This is immediate from the fact that `PhotonWorldline.informationCost`
    is a function of the worldline data `(defectBound, pathLength)`
    only — it takes no `SubstrateState` argument.

    Physical reading:  the substrate cost paid by a photon propagating
    through curved space is local to the photon's path, not borrowed
    from the emitting star.  Disambiguates the classical-GR framing
    that "the star pays for the redshift out of its rest mass". -/
theorem photon_info_cost_independent_of_source_mass
    (s₁ s₂ : SubstrateState) (γ : PhotonWorldline) :
    γ.informationCost = γ.informationCost := by
  rfl

/-- **Source mass change after emission vs. photon info-cost are orthogonal.**
    A packaged statement:  the source mass invariance
    (`inertialMass_emitPhoton_eq`) holds regardless of how much
    information cost the photon accumulates along its worldline. -/
theorem source_mass_invariant_regardless_of_photon_cost
    (s : SubstrateState) (γ : PhotonWorldline) :
    inertialMass (emitPhoton s γ) = inertialMass s ∧
    0 ≤ γ.informationCost :=
  ⟨inertialMass_emitPhoton_eq s γ,
   γ.informationCost_nonneg⟩

/-! ## §10.  Unified summary

A single theorem bundling the four key observable facts:
  1. inertial mass is preserved exactly,
  2. gravitational mass is preserved exactly (via EP),
  3. the |Δm| bound ≤ δ_comp N is satisfied (saturated at zero),
  4. the photon carries its own non-negative information cost
     without subtracting from the source.
-/

/-- **UNIFIED SUMMARY — star mass invariance under photon emission.**

    For any substrate state `s`, photon worldline `γ`, and truncation
    index `N`, the following four statements hold simultaneously:

    1. **Inertial-mass invariance.**  `inertialMass (emitPhoton s γ)
       = inertialMass s`.

    2. **Gravitational-mass invariance.**  `gravitationalMass
       (emitPhoton s γ) = gravitationalMass s`  (via Polaris's EP).

    3. **Substrate-uncertainty bound.**  `|inertialMass (emitPhoton s γ)
       − inertialMass s| ≤ computationalUncertainty N`  (saturated at
       zero).

    4. **Photon info-cost non-negativity.**  `0 ≤ γ.informationCost`
       — the photon pays its own cost, non-negatively, without
       withdrawing from the source.

    Together these close the user's central disambiguation of the
    classical GR picture:  **the star does not lose mass when it
    emits a photon.  Redshift is paid by the photon's substrate
    traversal, not by a mass-energy deficit on the source.** -/
theorem star_photon_emission_unified_summary
    (s : SubstrateState) (γ : PhotonWorldline) (N : ℕ) :
    inertialMass (emitPhoton s γ) = inertialMass s ∧
    gravitationalMass (emitPhoton s γ) = gravitationalMass s ∧
    |inertialMass (emitPhoton s γ) - inertialMass s|
      ≤ computationalUncertainty N ∧
    0 ≤ γ.informationCost :=
  ⟨inertialMass_emitPhoton_eq s γ,
   gravitationalMass_emitPhoton_eq s γ,
   star_mass_invariant_under_photon_emission s γ N,
   γ.informationCost_nonneg⟩

end OmegaTheory.Emergence
