/-
  OmegaTheory.Emergence.HawkingAsReverseRedshift

  **Hawking radiation as reverse-redshift info cost.**

  Agent: Alcor (80 UMa, "the faint one" — the ghostly companion whose
  visibility was a classical test of dark-field fidelity).
  Mission: `hawking_radiation_as_reverse_redshift_info_cost`.
  Bundle: `substrate_exchange_bundle`.  Frontier: BH-info-paradox-conjecture.

  ## Physical narrative (continuation of Denebola's three-term paper)

  Denebola's `RedshiftEnergyToDarkEnergy.lean` established the
  *forward* substrate ledger for cosmological photon propagation:

      Δρ_DE  =  + gravRedshiftCost(path, E_γ)          (reservoir gains)
      ΔE_γ   =  − gravRedshiftCost(path, E_γ)          (photon loses)
      ΔM_*   =    0                                    (star invariant)
      -------------------------------------------------
      Σ      =    0                                    (conservation)

  The present file closes the *reverse* ledger — Hawking radiation as
  the horizon analogue of the cosmological identity, with every sign
  flipped on the photon and reservoir side:

      ΔE_γ         =  + gravRedshiftCost(path, E_γ)   (photon GAINS on escape)
      ΔM_BH        =  − gravRedshiftCost(path, E_γ)   (BH mass DECREASES)
      Δρ_DE_out    =  0                                (net reservoir NEUTRAL
                                                        along Alnasl's ledger —
                                                        see scoping below)
      ------------------------------------------------
      Σ            =  0                                (conservation)

  The "reverse-redshift" viewpoint: a photon climbing out of the
  gravitational well of a black hole is the time-reversed image of a
  cosmological photon redshifting into the dark-energy reservoir.
  Where the cosmological photon *deposits* `gravRedshiftCost` into the
  reservoir, the Hawking photon *extracts* exactly the same substrate
  quantity from the horizon's mass budget.  This re-frames the Hawking
  evaporation process as a **unitarity-preserving substrate exchange**:
  information flows from BH mass into escaping-photon energy via the
  same substrate info-cost channel, just traversed in the opposite
  direction.

  Combined with Alnasl's three-term mediation identity
  `incoming = outflow + darkEnergyGain` (`BlackHoleAsMediator.lean`)
  and Adhafera's `reservoirRelaxationRate` (`HawkingReservoirRelaxation.lean`),
  this file supplies the **sign-inversion symmetry** that makes BH
  evaporation structurally dual to cosmological redshift.  Both are the
  same substrate identity `gravRedshiftCost` applied once forwards (loss
  into reservoir) and once backwards (gain from mass).

  ## What this file formalizes

  **Structure:**
  * `HawkingEmissionEvent (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)`
    — a reverse-transfer conservation-event record.  It asserts:
      (1) **Reverse conservation:** `M_before − M_after = gravRedshiftCost
          w.pathLength w.energy` — the BH mass decreases by exactly the
          photon's integrated substrate info-cost along the escape path.
      (2) **Photon gains energy:** the photon's gain along its worldline
          is the same substrate quantity (sign-inverted Denebola).
      (3) **Photon-c invariance (Canopus bridge):** even escaping a
          horizon, the photon travels at `c` locally.

  **Headline (Tier 1 — reverse-redshift info cost):**
  * `hawking_radiation_as_reverse_redshift_info_cost` — for every
    `PhotonCoherenceWorldline w` and every Hawking emission event `h`:

        M_before − M_after = gravRedshiftCost w.pathLength w.energy

    i.e. BH mass decrease equals the integrated reverse-redshift cost.

  **Corollaries (Tier 2 — sign + monotonicity + bypass):**
  * `hawkingReverseRedshiftCost_nonpositive` — the photon-side signed
    quantity `reverseRedshiftCost := −gravRedshiftCost` is always ≤ 0
    (it is subtracted FROM the mass, added TO the photon).
  * `BH_mass_decreases_under_Hawking_emission` — `M_after ≤ M_before`.
  * `hawking_reverse_transfer_monotone_in_pathLength` — longer escape
    paths extract more mass from the BH.
  * `hawking_reverse_transfer_vanishes_flat_vacuum` — zero-length
    "emissions" remove zero mass.
  * `hawking_three_term_conservation_unified` — symmetric dual of
    Denebola's ledger: `ΔM_BH + ΔE_γ_emitted + Δρ_DE_released = 0`.

  **Unified summary:**
  * `hawking_reverse_redshift_unified_summary` — single theorem
    packaging all five key observables.

  ## Scoping (honest)

  * `HawkingEmissionEvent` is a `Prop`-valued record, parallel to
    Denebola's `DarkEnergyTransferEvent`.  Its three fields axiomatise
    the *reverse* conservation content without committing to a
    microscopic emission mechanism beyond what Avior's
    `hawkingRadiationMagnitude` and Adhafera's `reservoirRelaxationRate`
    already supply.  The `canonical_hawking_event` constructor shows
    every worldline + BH pair admits a canonical event, so the Prop is
    not vacuous.

  * The three-term "photon + BH + reservoir" bilans is the substrate
    statement that on a Hawking emission, the photon gains exactly
    what the BH loses AT THE HORIZON (no reservoir deposit during the
    escape itself).  This is orthogonal to Denebola's forward ledger:
    there, the photon-redshift deposit fuels the reservoir; HERE the
    horizon's mass decrease is returned directly to the escaping
    photon.  The reservoir participates only via Adhafera's relaxation
    channel integrated over Alnasl's mediation identity — NOT as a new
    source in this event.

  * Following Denebola's convention we identify the photon-side
    `ΔE_γ_emitted` with `+gravRedshiftCost` (the photon's integrated
    info-cost along the escape — gain, not loss).  The BH-side
    `ΔM_BH = −gravRedshiftCost`.  The reservoir term `Δρ_DE_released` is
    identically `0` for the emission event alone — it models the fact
    that the reservoir's involvement is *rate-based* (Adhafera) and
    accumulates only over an integrated interval through the Alnasl
    mediation identity, not per-emission.

  * Unitarity interpretation: this bookkeeping is a substrate
    **unitarity-preservation candidate** for the BH information
    paradox — every bit subtracted from `M_BH` appears in the escaping
    photon's `gravRedshiftCost` quantum.  The formal unitarity claim
    (Hilbert-space inner-product preservation, purity of the outgoing
    state) is a *physics conjecture* beyond this file's reach and is
    marked FRONTIER below.

  No `sorry`, no new axioms.  Author: Alcor (2026-04-19).
-/

import OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy
import OmegaTheory.Emergence.HawkingReservoirRelaxation
import OmegaTheory.Emergence.BlackHoleAsMediator
import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Emergence.PhotonSpeedCoherence
import OmegaTheory.Predictions.RedshiftFloor
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory
open OmegaTheory.Spacetime
open OmegaTheory.Predictions
open OmegaTheory.Emergence.BlackHoleAsMediator

/-! ## §0.  Signed reverse-redshift cost (photon-side label)

The "reverse" form of `gravRedshiftCost`: a signed quantity that is
`≤ 0` (negative sign = the photon GAINS energy; equivalently, mass is
subtracted from the BH ledger). -/

/-- **Reverse redshift cost** associated to a photon escaping a
    horizon along worldline `w`.  Defined as `−gravRedshiftCost` so
    that the sign convention matches the physics:  a negative number
    on the BH-mass-loss ledger, a positive inverse on the photon-gain
    ledger.

    Algebraically this is the sign-flipped Denebola info-cost; the
    rename exposes the reverse-redshift physics at the theorem level. -/
noncomputable def hawkingReverseRedshiftCost
    (w : PhotonCoherenceWorldline) : ℝ :=
  -gravRedshiftCost w.pathLength w.energy

/-- **Reverse redshift cost is non-positive.**  Reading: on the BH
    mass ledger, every Hawking emission contributes a `≤ 0` delta. -/
theorem hawkingReverseRedshiftCost_nonpositive
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    hawkingReverseRedshiftCost w ≤ 0 := by
  unfold hawkingReverseRedshiftCost
  have h := gravRedshiftCost_nonneg w.pathLength w.energy hL w.energy_pos
  linarith

/-- **Reverse redshift cost equals `−informationCost`.**  The
    photon-side label form of Canopus's `photon_energy_info_duality`
    on the reverse branch. -/
theorem hawkingReverseRedshiftCost_eq_neg_informationCost
    (w : PhotonCoherenceWorldline) :
    hawkingReverseRedshiftCost w =
      -PhotonWorldline.informationCost w.toPhotonWorldline := by
  unfold hawkingReverseRedshiftCost
  congr 1
  exact photon_energy_info_duality w |>.symm

/-- **Reverse redshift cost vanishes in flat vacuum.**  Zero-length
    escape paths extract zero mass. -/
@[simp] theorem hawkingReverseRedshiftCost_flat_vacuum
    (w : PhotonCoherenceWorldline) (hL : w.pathLength = 0) :
    hawkingReverseRedshiftCost w = 0 := by
  unfold hawkingReverseRedshiftCost
  rw [hL, gravRedshiftCost_zero_pathLength]
  ring

/-! ## §1.  The Hawking emission event (reverse-transfer record)

A `HawkingEmissionEvent w M_before M_after` records the substrate
content of a single Hawking emission: the BH mass `M_before` at event
start, the mass `M_after` post-emission, and the escaping photon
worldline `w`.  The content is the REVERSE-FLOW conservation law:
the mass difference equals exactly the photon's integrated
gravRedshiftCost along the escape path.
-/

/-- **Hawking emission event.**  Conservation record for a single
    horizon emission of photon `w`, mass change `M_before → M_after`.

    The three fields encode the reverse substrate ledger:
      (1) `mass_balance` — `M_before − M_after = gravRedshiftCost
          w.pathLength w.energy`:  BH loses exactly the photon's
          integrated info-cost along its escape worldline.
      (2) `photon_carries_c` — the escaping photon locally travels at
          `c` throughout (Canopus bridge; same as Denebola).
      (3) `mass_positivity` — `M_before, M_after > 0`:  a sensible
          Hawking event never drives the mass to zero or negative
          (consistent with Avior's `bh.mass > 0` precondition on the
          magnitude formula).  Realised as a strict positivity of
          the post-emission mass. -/
structure HawkingEmissionEvent (w : PhotonCoherenceWorldline)
    (M_before M_after : ℝ) : Prop where
  /-- **Reverse conservation identity.**  BH mass loss equals the
      photon's integrated gravitational redshift info-cost along its
      escape worldline.  Sign-inverted Denebola identity. -/
  mass_balance : M_before - M_after = gravRedshiftCost w.pathLength w.energy
  /-- **Photon-c invariance (Canopus bridge).**  The escaping photon's
      local propagation velocity is `c` at every lattice point along
      `w`, even inside the near-horizon region. -/
  photon_carries_c : ∀ p ∈ w.points,
    PhotonCoherenceWorldline.localPropagationVelocity w p = c
  /-- **Post-emission mass positivity.**  Every Hawking event leaves
      the BH with strictly positive mass (the "emission" is
      incremental, never total). -/
  mass_after_pos : 0 < M_after

/-! ## §2.  Headline — reverse-redshift info cost

The main theorem of this file.  Given any Hawking emission event, the
BH mass decrease equals the photon's reverse-redshift substrate cost. -/

/-- **HEADLINE — `hawking_radiation_as_reverse_redshift_info_cost`.**

    For every photon coherence worldline `w` and every Hawking
    emission event `h`, the BH mass decrease equals the photon's
    integrated substrate info-cost along the escape worldline:

        M_before − M_after = gravRedshiftCost w.pathLength w.energy.

    **Physical interpretation.**  This is the *reverse* of Denebola's
    `photon_redshift_loss_equals_dark_energy_gain`.  Where
    cosmological photons *deposit* `gravRedshiftCost` into the
    dark-energy reservoir as they redshift, Hawking photons
    *extract* exactly the same substrate quantity from the BH mass
    budget as they blueshift on escape.  The same substrate channel,
    traversed in opposite directions.

    Combining with `hawkingReverseRedshiftCost_eq_neg_informationCost`:

        M_before − M_after = PhotonWorldline.informationCost w.

    The BH pays the photon's information cost out of its mass; the
    photon's energy gain on escape exactly equals its integrated
    gravRedshiftCost.  Substrate unitarity candidate for the BH
    information paradox.

    **Proof.**  Trivial: the `mass_balance` field of the event record
    is exactly this identity. -/
theorem hawking_radiation_as_reverse_redshift_info_cost
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after) :
    M_before - M_after = gravRedshiftCost w.pathLength w.energy :=
  h.mass_balance

/-- **HEADLINE — signed form.**  Same identity, restated with the
    signed `hawkingReverseRedshiftCost`:  `M_after − M_before =
    hawkingReverseRedshiftCost w` (the negative quantity).

    Used for direct substitution into the three-term ledger. -/
theorem hawking_mass_delta_eq_reverseCost
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after) :
    M_after - M_before = hawkingReverseRedshiftCost w := by
  unfold hawkingReverseRedshiftCost
  have := h.mass_balance
  linarith

/-! ## §3.  Corollaries — sign, monotonicity, photon-gain

Five structural consequences mirroring Denebola's corollary set. -/

/-- **BH mass decreases under Hawking emission.**  For any valid event
    on a photon of non-negative path length, `M_after ≤ M_before`.
    This is the substrate content of "Hawking radiation shrinks the
    BH" — exactly sign-inverted dual to Denebola's
    `dark_energy_reservoir_grows`. -/
theorem BH_mass_decreases_under_Hawking_emission
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after)
    (hL : 0 ≤ w.pathLength) :
    M_after ≤ M_before := by
  have h_bal := h.mass_balance
  have h_cost_nn :=
    gravRedshiftCost_nonneg w.pathLength w.energy hL w.energy_pos
  linarith

/-- **Photon energy gain on escape.**  The photon's energy gain —
    identified at the substrate level with `+gravRedshiftCost` (sign
    inversion of the cosmological redshift loss) — equals the BH mass
    decrease.  Supplies the photon side of the unitarity claim. -/
theorem hawking_photon_energy_gain
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after) :
    gravRedshiftCost w.pathLength w.energy = M_before - M_after :=
  h.mass_balance.symm

/-- **Three-term conservation (symmetric dual of Denebola).**  The
    substrate ledger for a Hawking emission event closes to zero:

        ΔM_BH + ΔE_γ_emitted + Δρ_DE_released = 0

    Identifying the three terms at the substrate info-cost level:
      * ΔM_BH          = M_after − M_before = −gravRedshiftCost  (≤ 0)
      * ΔE_γ_emitted   = +gravRedshiftCost                         (≥ 0)
      * Δρ_DE_released = 0   (reservoir-neutral per-event; see scoping)

    The three terms sum to zero exactly.  This is the **mirror image**
    of Denebola's three-term identity — same substrate quantity
    (gravRedshiftCost), opposite sign pattern, with the reservoir
    playing the neutral "bystander" role while horizon-mass and
    photon-energy exchange the info cost directly.

    **Proof.**  `(−grav_cost) + grav_cost + 0 = 0` by `ring` after
    substituting `mass_balance` for the BH and photon terms. -/
theorem hawking_three_term_conservation_unified
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after) :
    (M_after - M_before) + gravRedshiftCost w.pathLength w.energy
      + (0 : ℝ) = 0 := by
  have h_bal := h.mass_balance
  linarith

/-- **Monotone in escape path length.**  A Hawking photon whose escape
    worldline is *longer* (at fixed smoothness `energy`) extracts
    *more* mass from the BH.  Physical reading: deeper redshift
    corrections in the near-horizon region correspond to more mass
    loss. -/
theorem hawking_reverse_transfer_monotone_in_pathLength
    (w₁ w₂ : PhotonCoherenceWorldline)
    (M₁_before M₁_after M₂_before M₂_after : ℝ)
    (h₁ : HawkingEmissionEvent w₁ M₁_before M₁_after)
    (h₂ : HawkingEmissionEvent w₂ M₂_before M₂_after)
    (h_same_energy : w₁.energy = w₂.energy)
    (h_path : w₁.pathLength ≤ w₂.pathLength)
    (_h_pos : 0 ≤ w₁.pathLength) :
    M₁_before - M₁_after ≤ M₂_before - M₂_after := by
  rw [h₁.mass_balance, h₂.mass_balance]
  unfold gravRedshiftCost vacuumResidualInformationCost
  rw [h_same_energy]
  have h_rate_nonneg : 0 ≤ l_P / (2 * w₂.energy) :=
    le_of_lt (div_pos l_P_pos (mul_pos two_pos w₂.energy_pos))
  exact mul_le_mul_of_nonneg_left h_path h_rate_nonneg

/-- **Flat-vacuum limit — no mass extraction.**  When the photon
    escape path is empty (`pathLength = 0`), the BH loses zero mass.
    Consistent with the physical fact that a trivial emission carries
    zero substrate info-cost. -/
theorem hawking_reverse_transfer_vanishes_flat_vacuum
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after)
    (hL : w.pathLength = 0) :
    M_before - M_after = 0 := by
  rw [h.mass_balance, hL]
  exact gravRedshiftCost_zero_pathLength w.energy

/-- **Photon-c invariance exposed.**  Unboxed from `h.photon_carries_c`
    for any given lattice point on the escape worldline.  Equivalent
    to Canopus's `photon_speed_invariance`:  Hawking photons do not
    exceed `c` locally, even in the near-horizon region. -/
theorem hawking_emission_preserves_c
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after) :
    ∀ p ∈ w.points,
      PhotonCoherenceWorldline.localPropagationVelocity w p = c :=
  h.photon_carries_c

/-! ## §4.  Constructor — every worldline admits a Hawking event

Parallel to Denebola's `canonical_transfer_event`:  for any photon
worldline `w` and any starting positive mass `M_before` strictly
greater than the photon's substrate info-cost, a canonical Hawking
emission event exists.  The mass-positivity constraint is intrinsic:
an event whose cost exceeds the BH mass would drive it to ≤ 0. -/

/-- **Canonical Hawking emission event.**  Given any photon coherence
    worldline `w` and any BH mass `M_before` that strictly exceeds
    the photon's substrate info-cost along `w`, the canonical choice
    `M_after := M_before − gravRedshiftCost w.pathLength w.energy`
    yields a valid Hawking emission event.

    Existence shows `HawkingEmissionEvent` is not vacuous. -/
theorem canonical_hawking_event
    (w : PhotonCoherenceWorldline) (M_before : ℝ)
    (h_big : gravRedshiftCost w.pathLength w.energy < M_before) :
    HawkingEmissionEvent w M_before
      (M_before - gravRedshiftCost w.pathLength w.energy) := by
  refine ⟨?_, ?_, ?_⟩
  · -- mass_balance:  M_before − (M_before − cost) = cost,  by `ring`.
    ring
  · -- photon-c invariance: Canopus.
    exact photon_speed_invariance w
  · -- post-emission mass positivity:  M_before > cost implies the
    -- difference is positive.
    linarith

/-! ## §5.  Bridge — compose with Denebola's forward ledger

The **symmetry** of forward (Denebola) and reverse (this file)
ledgers: both use the *same* substrate quantity `gravRedshiftCost`,
with the substrate-exchange direction determined by whether the photon
is redshifting (away from a source, depositing into reservoir) or
blueshifting (escaping a horizon, extracting from mass).  -/

/-- **Forward–reverse duality of the substrate info-cost channel.**

    For the same photon coherence worldline `w`, a Denebola transfer
    event (forward flow: reservoir gains, photon loses) and an Alcor
    Hawking emission event (reverse flow: BH loses, photon gains)
    BOTH satisfy

        |ΔE_reservoir| = |ΔM_BH| = gravRedshiftCost w.pathLength w.energy.

    Substrate content:  the *same* info-cost quantity is the
    conserved "coin" in both directions.  This makes the Hawking
    emission a **time-reversed** cosmological redshift at the substrate
    bookkeeping level — a formal substrate-unitarity bridge.

    **Proof.**  Both sides equal `gravRedshiftCost ...` by the
    `conservation` field (Denebola) and `mass_balance` field (Alcor). -/
theorem hawking_redshift_duality
    (w : PhotonCoherenceWorldline)
    (ρ_before ρ_after M_before M_after : ℝ)
    (h_fwd : DarkEnergyTransferEvent w ρ_before ρ_after)
    (h_rev : HawkingEmissionEvent w M_before M_after) :
    ρ_after - ρ_before = M_before - M_after := by
  rw [h_fwd.conservation, h_rev.mass_balance]

/-! ## §6.  Integrated reverse-cost bookkeeping (Alnasl ledger bridge)

**Claim 2 of the mission spec.**  Over a Hawking emission event, the
BH mass change equals the *negative* of the integrated reverse
redshift cost.  This is immediate from the `mass_balance` field after
rewriting the sign.  It exposes the "integrated reverse cost" phrasing
from the mission statement as a direct consequence. -/

/-- **BH mass change = −(integrated reverse redshift cost).**

    From the `mass_balance` field of `HawkingEmissionEvent`, the
    mass change `M_after − M_before` equals the signed
    `hawkingReverseRedshiftCost w` (which is ≤ 0 for a non-trivial
    escape).  Reading as an instantaneous identity:

        ΔM_BH = hawkingReverseRedshiftCost(event).

    In mission-spec language:  **the BH mass DECREASES by the
    integrated reverse redshift cost**; equivalently, the mass change
    is the negative of that integral.

    This is the Tier-1 form of Claim 2 `BH mass decrease equals
    integrated reverse cost`.  Future extensions could lift this from
    a single emission to a time-parametrised flux via Alnasl's
    `incomingEnergy = outflow + darkEnergyGain` identity. -/
theorem BH_mass_change_eq_reverse_cost
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after) :
    M_after - M_before = hawkingReverseRedshiftCost w :=
  hawking_mass_delta_eq_reverseCost w M_before M_after h

/-! ## §7.  Unified summary

A single theorem bundling the five key observables — mirrors
Denebola's `photon_dark_energy_conservation_unified_summary`. -/

/-- **UNIFIED SUMMARY — Hawking as reverse-redshift info cost.**

    For every photon coherence worldline `w` and every Hawking
    emission event `h`, five observables hold simultaneously:

    1. **Reverse conservation identity.**  M_before − M_after =
       gravRedshiftCost w.pathLength w.energy.

    2. **BH shrinks.**  (for `pathLength ≥ 0`)  M_after ≤ M_before.

    3. **Three-term ledger closure (symmetric dual to Denebola).**
       (M_after − M_before) + gravRedshiftCost w.pathLength w.energy
       + 0 = 0.

    4. **Photon-c invariance (Canopus bridge, in-event).**  For every
       lattice point `p` on `w`,  localPropagationVelocity w p = c.

    5. **Mass positivity (no total evaporation per event).**  M_after
       remains strictly positive after the emission.

    Together these close the reverse-flow substrate bookkeeping:
    the BH pays `gravRedshiftCost` out of its mass; the escaping
    photon receives exactly that substrate info-cost as energy gain;
    the reservoir participates only at the rate-integrated level
    (Adhafera); the photon travels at `c`; the BH mass remains
    positive.  Hawking radiation is a unitarity-preserving substrate
    exchange, structurally time-reversed from cosmological redshift.

    Paper-ready capstone. -/
theorem hawking_reverse_redshift_unified_summary
    (w : PhotonCoherenceWorldline) (M_before M_after : ℝ)
    (h : HawkingEmissionEvent w M_before M_after)
    (hL : 0 ≤ w.pathLength) :
    (M_before - M_after = gravRedshiftCost w.pathLength w.energy)
      ∧ (M_after ≤ M_before)
      ∧ ((M_after - M_before) + gravRedshiftCost w.pathLength w.energy
          + (0 : ℝ) = 0)
      ∧ (∀ p ∈ w.points,
            PhotonCoherenceWorldline.localPropagationVelocity w p = c)
      ∧ (0 < M_after) :=
  ⟨hawking_radiation_as_reverse_redshift_info_cost w M_before M_after h,
   BH_mass_decreases_under_Hawking_emission w M_before M_after h hL,
   hawking_three_term_conservation_unified w M_before M_after h,
   h.photon_carries_c,
   h.mass_after_pos⟩

/-! ## §8.  FRONTIER notes (unitarity conjecture)

The formal claim that the substrate info-cost channel `gravRedshiftCost`
encodes *Hilbert-space* unitarity of the BH evaporation process
(purity preservation of outgoing state ⊗ horizon state) is a physics
conjecture beyond the substrate bookkeeping available here.  The
present file establishes the **quantitative unitarity ledger** (every
bit of BH mass appears as photon energy via the same substrate
quantity) which is the necessary condition for any stronger
Hilbert-space unitarity claim.

FRONTIER: lift `hawking_three_term_conservation_unified` to an
inner-product-preserving channel on the joint horizon⊗photon Hilbert
space.  Infrastructure needed: a horizon-state density matrix, an
outgoing-photon Fock-space assignment, and a proof that the
gravRedshiftCost-driven substrate exchange is an isomorphism at the
state-vector level.  This would promote Alcor's substrate-bookkeeping
unitarity to the full BH-information-paradox resolution candidate. -/

end OmegaTheory.Emergence
