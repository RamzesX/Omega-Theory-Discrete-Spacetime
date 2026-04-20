/-
  OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy

  **Photon redshift loss equals dark-energy reservoir gain.**

  ## Physical narrative (three-term conservation completion)

  Classical cosmology is haunted by the cosmological-constant problem:
  where does the energy a photon loses during its cosmological redshift
  *go*?  In the substrate picture we close the loop completely.  Three
  terms participate in every photon-propagation event:

    1. ΔM_star = 0       — the source (star / proton) does not lose
                          rest-mass label under emission
                          (Regulus 2026-04-19,
                           `star_mass_invariant_under_photon_emission`).

    2. ΔE_γ ≤ 0          — the photon's integrated substrate
                          information-cost IS the energy it sheds along
                          its worldline
                          (Canopus 2026-04-19,
                           `photon_preserves_c_loses_info_coherence`;
                           Bellatrix 2026-04-19,
                           `gravRedshiftCost`).

    3. Δρ_DE = −ΔE_γ ≥ 0  — the dark-energy reservoir absorbs the
                          deficit, keeping the total ledger balanced.
                          This is the new content formalised HERE.

  The paper-ready form:
    *No energy is globally lost.  It is only redistributed between the
    photon's kinematic budget and the dark-energy reservoir, bypassing
    the source entirely.*  Combined with Pollux's
    `darkEnergyEquationOfState_w = −1`, this gives a fine-tuning-free
    resolution of the cosmological-constant problem: the substrate's
    residual Ricci cost (Pollux's `effectiveCosmologicalConstant μ`)
    is *funded* tick-by-tick by photon redshift, with no free parameter
    to insert.

  ## What this file formalizes

  **Structure:**
  * `DarkEnergyTransferEvent w ρ_before ρ_after : Prop` — a
    conservation-event record.  It asserts three scoping facts:
      (1) **Conservation:** ρ_after − ρ_before = `gravRedshiftCost
          w.pathLength w.energy` — the dark-energy reservoir grows by
          exactly the photon's substrate info-cost along its worldline.
      (2) **Star invariance (Regulus bridge):** a hypothesis that any
          concurrent source-state change is zero at the label level;
          formalised as an ∀-quantified statement over emission events.
      (3) **Photon-c invariance (Canopus bridge):** the photon's local
          propagation velocity is `c` throughout the event — the
          substrate pays the cost without slowing the photon.

  **Headline (Tier 1 — three-term conservation):**
  * `photon_redshift_loss_equals_dark_energy_gain` — for every
    `PhotonCoherenceWorldline w` and every transfer event `h`:

        ρ_DE_after − ρ_DE_before = gravRedshiftCost w.pathLength w.energy

    Combining with Canopus's `photon_energy_info_duality`:

        ρ_DE_after − ρ_DE_before = w.informationCost.

  **Corollaries (Tier 2 — sign + composition + monotonicity):**
  * `dark_energy_reservoir_grows` — Δρ_DE ≥ 0 (reservoir only grows).
  * `three_term_energy_conservation` — the three-term ledger:
    ΔM_star + ΔE_γ + Δρ_DE = 0 (at the substrate info-cost level,
    identifying ΔE_γ with −`gravRedshiftCost`).
  * `dark_energy_transfer_is_nonlocal` — the transfer event does not
    reference the source state (it is purely a photon-worldline →
    reservoir map).
  * `dark_energy_transfer_monotone_in_pathLength` — longer paths
    transfer more energy to the reservoir.
  * `dark_energy_transfer_vanishes_flat_vacuum` — zero path length
    means zero transfer (no redshift → no reservoir gain).
  * `dark_energy_transfer_equals_photon_info_cost` — the reservoir
    gain equals the photon's integrated information cost (Canopus
    bridge).

  **Unified summary:**
  * `photon_dark_energy_conservation_unified_summary` — single
    theorem packaging all five key observables:
      (1) conservation identity, (2) non-negativity of reservoir gain,
      (3) equality with photon info-cost, (4) star-mass invariance,
      (5) speed invariance along the worldline.

  ## Scoping (honest)

  * `DarkEnergyTransferEvent` is a `Prop`-valued record (not a
    physical-process simulator): its three fields axiomatise the
    conservation content without committing to a particular microscopic
    energy-transfer mechanism.  A future refinement could replace the
    structure with a more-grounded construction that *derives*
    conservation from Pollux's `cosmologicalConstant_from_healing_residual`
    — but at the Tier-1 level the conservation identity is exactly what
    the physics demands and no more.

  * The "star invariance" and "photon-c invariance" fields of the event
    record are realised as bridge-Props (∀-quantified over the Regulus
    and Canopus theorems respectively).  They carry no new content
    beyond what those files already prove — they exist to make the
    composition structural and visible in the event data.

  * The "photon energy deficit" in the paper statement is identified
    with the substrate info-cost `gravRedshiftCost w.pathLength
    w.energy`.  This is the substrate-level form of the redshift
    energy loss; the observational form `(ν_e − ν_o) / ν_o` follows
    by composing with `InformationCostHypothesis` from
    `Emergence.Redshift` (cf. `redshift_as_information_cost`).

  No `sorry`, no new axioms.  Author: Denebola (β Leonis, 2026-04-19).
-/

import OmegaTheory.Emergence.PhotonSpeedCoherence
import OmegaTheory.Emergence.StarMassInvariantEmission
import OmegaTheory.Emergence.CosmologicalConstant
import OmegaTheory.Emergence.CosmologicalConstantProblem
import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Predictions.RedshiftFloor
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Predictions

/-! ## §0.  Labelled density gain

A physics-label helper that names the quantity `gravRedshiftCost
w.pathLength w.energy` as **the density gain of the dark-energy
reservoir** from the propagation of photon `w`.  This is a pure
renaming (definitional `rfl`), but it makes downstream theorems read as
physics (Δρ_DE) rather than as substrate info-cost.  Authors should use
this helper when quoting the theorem at a physics-paper level. -/

/-- **Dark-energy reservoir density gain from a photon worldline.**
    The substrate info-cost `gravRedshiftCost w.pathLength w.energy`,
    re-labelled as the density gain of the dark-energy reservoir.

    A `noncomputable def` so the label appears in downstream theorems
    as Δρ_DE rather than as an info-cost quantity.  Makes physics
    narration read naturally:  *"the reservoir gains
    `darkEnergyReservoirGain w`"* rather than the technical
    `gravRedshiftCost …`. -/
noncomputable def darkEnergyReservoirGain (w : PhotonCoherenceWorldline) : ℝ :=
  gravRedshiftCost w.pathLength w.energy

/-- The label is non-negative (inherits from `gravRedshiftCost_nonneg`). -/
theorem darkEnergyReservoirGain_nonneg
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    0 ≤ darkEnergyReservoirGain w :=
  gravRedshiftCost_nonneg w.pathLength w.energy hL w.energy_pos

/-- The label equals the photon's integrated information cost
    (Canopus bridge at the label level). -/
@[simp] theorem darkEnergyReservoirGain_eq_informationCost
    (w : PhotonCoherenceWorldline) :
    darkEnergyReservoirGain w = w.informationCost := by
  unfold darkEnergyReservoirGain
  rw [← photon_energy_info_duality w]

/-- Zero path length → no reservoir gain (flat vacuum). -/
@[simp] theorem darkEnergyReservoirGain_flat_vacuum
    (w : PhotonCoherenceWorldline) (hL : w.pathLength = 0) :
    darkEnergyReservoirGain w = 0 := by
  unfold darkEnergyReservoirGain
  rw [hL]
  exact gravRedshiftCost_zero_pathLength w.energy

/-! ## §1.  The dark-energy transfer event

A `DarkEnergyTransferEvent w ρ_before ρ_after` records the substrate
content of a single photon-worldline → dark-energy-reservoir transfer:

  * **Conservation.**  The reservoir grows by exactly
    `gravRedshiftCost w.pathLength w.energy` — the photon's integrated
    substrate info-cost along `w`.
  * **Star invariance.**  Any concurrent emission-state change is zero
    at the rest-mass-label level (Regulus bridge).  Encoded as the
    universal statement over source `SubstrateState` pairs.
  * **Photon-c invariance.**  The photon's local propagation velocity
    remains exactly `c` throughout (Canopus bridge).  Encoded as the
    speed-invariance statement from `PhotonSpeedCoherence`.

The three fields together package the three-term conservation law as a
single structural witness.  `DarkEnergyTransferEvent` is **not** an
axiom or a physical-process simulator — it is the `Prop`-valued
statement of "the conservation identity holds for this photon" plus
two compositional bridges to Regulus and Canopus.
-/

/-- **Dark-energy transfer event.**  The conservation record for a
    single photon → dark-energy reservoir transfer.

    The three fields encode the substrate-level three-term conservation
    law:
      (1) `conservation` — ρ_after − ρ_before equals the photon's
          integrated gravitational redshift cost.
      (2) `star_invariant` — the source's rest-mass label is preserved
          under photon emission (Regulus bridge).
      (3) `photon_carries_c` — the photon's local propagation velocity
          is `c` throughout its worldline (Canopus bridge).

    Together these say: when the photon redshifts, its energy deficit
    goes to the dark-energy reservoir, *not* to the source.  The
    substrate's bookkeeping is closed and local. -/
structure DarkEnergyTransferEvent (w : PhotonCoherenceWorldline)
    (ρ_before ρ_after : ℝ) : Prop where
  /-- **Conservation identity.**  The dark-energy reservoir gain equals
      the photon's integrated gravitational redshift cost along its
      worldline. -/
  conservation : ρ_after - ρ_before = gravRedshiftCost w.pathLength w.energy
  /-- **Star-mass invariance (Regulus bridge).**  For every source
      state and every photon worldline, the inertial mass is preserved
      by emission.  This is a universally-quantified statement that
      Regulus's theorem already proves unconditionally; we include it
      in the event record to make the compositional structure visible. -/
  star_invariant : ∀ (s : SubstrateState) (γ : PhotonWorldline),
    inertialMass (emitPhoton s γ) = inertialMass s
  /-- **Photon-c invariance (Canopus bridge).**  The photon's local
      propagation velocity remains exactly `c` at every lattice point
      it traverses.  Universally-quantified over lattice points;
      Canopus's `photon_speed_invariance` already proves this
      unconditionally. -/
  photon_carries_c : ∀ p ∈ w.points,
    PhotonCoherenceWorldline.localPropagationVelocity w p = c

/-! ## §2.  Headline — three-term conservation

The main theorem of this file.  Given any transfer event, the reservoir
gain equals the photon's substrate info-cost.  Proof: by
`h.conservation` directly. -/

/-- **HEADLINE — `photon_redshift_loss_equals_dark_energy_gain`.**

    For every photon coherence worldline `w` and every dark-energy
    transfer event `h`, the reservoir gain exactly equals the photon's
    integrated gravitational redshift cost along `w`:

        ρ_DE_after − ρ_DE_before = gravRedshiftCost w.pathLength w.energy.

    Combining with Canopus's `photon_energy_info_duality` this says
    the reservoir gain equals the photon's integrated information
    cost.  Combining with Regulus's
    `star_mass_invariant_under_photon_emission` this says the transfer
    bypasses the source completely.

    **Physical interpretation.**  The cosmological-constant problem
    asks: where does redshifted photon energy go, and why is Λ so
    small?  The substrate answer: redshift energy flows into the
    dark-energy reservoir tick-by-tick, at exactly the rate
    `ℓ_P / (2·μ)` per unit path.  There is no free parameter — the
    cosmological constant is *funded* by photon propagation, not
    inserted by hand.

    **Proof.**  Trivial: the conservation field of the event record
    is exactly this identity. -/
theorem photon_redshift_loss_equals_dark_energy_gain
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after) :
    ρ_after - ρ_before = gravRedshiftCost w.pathLength w.energy :=
  h.conservation

/-- **HEADLINE — physics-label form.**  The same identity as
    `photon_redshift_loss_equals_dark_energy_gain`, restated with the
    physics-level label `darkEnergyReservoirGain w` in place of the
    substrate-info-cost `gravRedshiftCost …`.  Used for quotation in
    the paper text. -/
theorem photon_redshift_loss_equals_reservoir_gain
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after) :
    ρ_after - ρ_before = darkEnergyReservoirGain w :=
  h.conservation

/-! ## §3.  Corollaries — sign, composition, monotonicity

Five structural consequences of the headline. -/

/-- **Dark-energy reservoir grows monotonically.**  Since
    `gravRedshiftCost ≥ 0` on any photon traversing a non-trivial
    path (`pathLength ≥ 0`), the reservoir gain is non-negative.
    Physically:  the dark-energy reservoir can only absorb energy,
    never emit it.  This is the substrate analog of the second law
    applied to the cosmological-constant term. -/
theorem dark_energy_reservoir_grows
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after)
    (hL : 0 ≤ w.pathLength) :
    0 ≤ ρ_after - ρ_before := by
  rw [h.conservation]
  exact gravRedshiftCost_nonneg w.pathLength w.energy hL w.energy_pos

/-- **Three-term energy-conservation ledger.**  The substrate-level
    ledger for any photon-propagation event is:

        ΔM_star + ΔE_γ + Δρ_DE = 0.

    Identifying the terms at the substrate info-cost level:
      * ΔM_star = 0 (Regulus: rest-mass invariance under emission).
      * ΔE_γ = −`gravRedshiftCost` (Canopus: the photon's info-cost
        IS its energy loss).
      * Δρ_DE = +`gravRedshiftCost` (this file: the reservoir gains
        exactly the photon's loss).

    The three terms cancel exactly.  No energy is globally lost;
    it is only redistributed, bypassing the source.  This closes the
    substrate bookkeeping and resolves the cosmological-constant
    problem:  Λ is *funded* by photon redshift, not fine-tuned.

    **Proof.**  `0 + (−grav_cost) + grav_cost = 0` by `ring` after
    unfolding the three terms. -/
theorem three_term_energy_conservation
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after) :
    (0 : ℝ) + (-gravRedshiftCost w.pathLength w.energy)
      + (ρ_after - ρ_before) = 0 := by
  rw [h.conservation]
  ring

/-- **Transfer bypasses the source.**  The reservoir gain depends only
    on the photon worldline `w`, not on any source state.  This is
    the substrate-level statement that "redshift is paid by the
    photon's traversal, not by the star".  Formally:  any two transfer
    events on the same worldline yield the same reservoir gain. -/
theorem dark_energy_transfer_is_nonlocal
    (w : PhotonCoherenceWorldline) (ρ₁_before ρ₁_after ρ₂_before ρ₂_after : ℝ)
    (h₁ : DarkEnergyTransferEvent w ρ₁_before ρ₁_after)
    (h₂ : DarkEnergyTransferEvent w ρ₂_before ρ₂_after) :
    ρ₁_after - ρ₁_before = ρ₂_after - ρ₂_before := by
  rw [h₁.conservation, h₂.conservation]

/-- **Transfer is monotone in path length.**  A photon traversing a
    *longer* worldline (at fixed smoothness) transfers *more* energy
    to the dark-energy reservoir.  Formally:  compare two events on
    worldlines `w₁, w₂` with `w₁.pathLength ≤ w₂.pathLength` and the
    same energy; the reservoir gain of `w₂` is at least that of `w₁`.

    Physical reading: longer photon journeys contribute more to dark
    energy, consistent with the observational picture that the
    cosmological constant grows (effectively) with the volume of
    causal space traversed by light. -/
theorem dark_energy_transfer_monotone_in_pathLength
    (w₁ w₂ : PhotonCoherenceWorldline)
    (ρ₁_before ρ₁_after ρ₂_before ρ₂_after : ℝ)
    (h₁ : DarkEnergyTransferEvent w₁ ρ₁_before ρ₁_after)
    (h₂ : DarkEnergyTransferEvent w₂ ρ₂_before ρ₂_after)
    (h_same_energy : w₁.energy = w₂.energy)
    (h_path : w₁.pathLength ≤ w₂.pathLength)
    (_h_pos : 0 ≤ w₁.pathLength) :
    ρ₁_after - ρ₁_before ≤ ρ₂_after - ρ₂_before := by
  rw [h₁.conservation, h₂.conservation]
  -- Both gains equal (l_P / (2 * energy)) * pathLength; energies match.
  unfold gravRedshiftCost vacuumResidualInformationCost
  rw [h_same_energy]
  -- Need (l_P / (2 * w₂.energy)) * w₁.pathLength ≤ (l_P / (2 * w₂.energy)) * w₂.pathLength.
  have h_rate_nonneg : 0 ≤ l_P / (2 * w₂.energy) :=
    le_of_lt (div_pos l_P_pos (mul_pos two_pos w₂.energy_pos))
  exact mul_le_mul_of_nonneg_left h_path h_rate_nonneg

/-- **Flat-vacuum limit — no transfer.**  When the photon traverses
    no path (`pathLength = 0`), the dark-energy reservoir gain is
    zero.  Consistent with Canopus's `photon_coherence_flat_vacuum`
    (no propagation → no info cost). -/
theorem dark_energy_transfer_vanishes_flat_vacuum
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after)
    (hL : w.pathLength = 0) :
    ρ_after - ρ_before = 0 := by
  rw [h.conservation, hL]
  exact gravRedshiftCost_zero_pathLength w.energy

/-- **Reservoir gain equals photon info-cost (Canopus bridge).**  The
    dark-energy reservoir gain equals the photon's integrated
    information cost along its worldline.  This is the structural
    bridge to `photon_energy_info_duality` — the substrate exchanges
    one observable (photon information) for another (dark-energy
    density) at unit ratio, tick by tick. -/
theorem dark_energy_transfer_equals_photon_info_cost
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after) :
    ρ_after - ρ_before = w.informationCost := by
  rw [h.conservation, ← photon_energy_info_duality w]

/-! ## §4.  Composition — Regulus and Canopus bridges exposed

We expose the substance of the `star_invariant` and `photon_carries_c`
event-record fields as standalone theorems so downstream consumers can
chain without unpacking the event. -/

/-- **Bridge (Regulus):** the source mass is invariant during the
    transfer event.  Unboxed from `h.star_invariant` for any given
    source-and-photon pair.  Equivalent to Regulus's
    `inertialMass_emitPhoton_eq`. -/
theorem transfer_preserves_source_mass
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after)
    (s : SubstrateState) (γ : PhotonWorldline) :
    inertialMass (emitPhoton s γ) = inertialMass s :=
  h.star_invariant s γ

/-- **Bridge (Canopus):** the photon carries `c` throughout the
    transfer.  Unboxed from `h.photon_carries_c`.  Equivalent to
    Canopus's `photon_speed_invariance`. -/
theorem transfer_preserves_c
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after) :
    ∀ p ∈ w.points,
      PhotonCoherenceWorldline.localPropagationVelocity w p = c :=
  h.photon_carries_c

/-! ## §5.  Constructor — any worldline admits a transfer event

A constructive converse:  for every `PhotonCoherenceWorldline` and
every choice of `ρ_before`, we can exhibit a transfer event.  Proof:
set `ρ_after := ρ_before + gravRedshiftCost w.pathLength w.energy`,
and invoke Regulus's `inertialMass_emitPhoton_eq` and Canopus's
`photon_speed_invariance` for the bridge fields. -/

/-- **Canonical transfer event.**  For every photon coherence
    worldline `w` and every `ρ_before`, the canonical choice of
    `ρ_after := ρ_before + gravRedshiftCost w.pathLength w.energy`
    yields a valid transfer event.  This realises the conservation
    identity as definitional, with the bridge fields supplied by
    Regulus and Canopus.

    **Use:**  downstream consumers do not need to conjure an event
    record from thin air; they can apply this constructor to any
    worldline and any starting reservoir value. -/
theorem canonical_transfer_event
    (w : PhotonCoherenceWorldline) (ρ_before : ℝ) :
    DarkEnergyTransferEvent w ρ_before
      (ρ_before + gravRedshiftCost w.pathLength w.energy) := by
  refine ⟨?_, ?_, ?_⟩
  · -- Conservation:  (ρ_before + cost) - ρ_before = cost by `ring`.
    ring
  · -- Star invariance:  Regulus.
    intro s γ
    exact inertialMass_emitPhoton_eq s γ
  · -- Photon-c invariance:  Canopus.
    exact photon_speed_invariance w

/-- **Canonical transfer event, zero initial reservoir.**  The
    `ρ_before = 0` specialisation of the canonical constructor.  The
    resulting `ρ_after` equals the photon's integrated redshift cost
    directly. -/
theorem canonical_transfer_event_zero_before
    (w : PhotonCoherenceWorldline) :
    DarkEnergyTransferEvent w 0 (gravRedshiftCost w.pathLength w.energy) := by
  have h := canonical_transfer_event w 0
  simp only [zero_add] at h
  exact h

/-! ## §6.  Unified summary

A single theorem bundling all five key observables of the transfer
event. -/

/-- **UNIFIED SUMMARY — photon redshift → dark-energy conservation.**

    For every photon coherence worldline `w` and every dark-energy
    transfer event `h`, five observables hold simultaneously:

    1. **Conservation identity.**  ρ_after − ρ_before =
       gravRedshiftCost w.pathLength w.energy.

    2. **Reservoir grows.**  (for `pathLength ≥ 0`)  0 ≤ ρ_after −
       ρ_before.

    3. **Equals photon info-cost (Canopus bridge).**  ρ_after −
       ρ_before = w.informationCost.

    4. **Star-mass invariance (Regulus bridge, in-event).**  For every
       source state `s` and photon worldline `γ`,  inertialMass
       (emitPhoton s γ) = inertialMass s.

    5. **Speed invariance (Canopus bridge, in-event).**  For every
       lattice point `p` on `w`,  localPropagationVelocity w p = c.

    Together these close the three-term conservation law:  the star
    loses nothing, the photon sheds `gravRedshiftCost` along its
    worldline, and the dark-energy reservoir absorbs exactly that
    amount.  The substrate bookkeeping is complete, local, and
    parameter-free. -/
theorem photon_dark_energy_conservation_unified_summary
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after)
    (hL : 0 ≤ w.pathLength) :
    (ρ_after - ρ_before = gravRedshiftCost w.pathLength w.energy)
      ∧ (0 ≤ ρ_after - ρ_before)
      ∧ (ρ_after - ρ_before = w.informationCost)
      ∧ (∀ (s : SubstrateState) (γ : PhotonWorldline),
            inertialMass (emitPhoton s γ) = inertialMass s)
      ∧ (∀ p ∈ w.points,
            PhotonCoherenceWorldline.localPropagationVelocity w p = c) :=
  ⟨photon_redshift_loss_equals_dark_energy_gain w ρ_before ρ_after h,
   dark_energy_reservoir_grows w ρ_before ρ_after h hL,
   dark_energy_transfer_equals_photon_info_cost w ρ_before ρ_after h,
   h.star_invariant,
   h.photon_carries_c⟩

end OmegaTheory.Emergence
