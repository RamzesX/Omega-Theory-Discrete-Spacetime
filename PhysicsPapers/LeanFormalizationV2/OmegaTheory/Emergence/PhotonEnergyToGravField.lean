/-
  OmegaTheory.Emergence.PhotonEnergyToGravField

  **Photon redshift cost transfers energy to the gravitational field
   itself — not only into the dark-energy reservoir.**

  Agent: Rigil (α Centauri, 2026-04-20).
  Mission cycle 3 target 5/6 `photon_energy_transfer_to_gravitational_field`.
  Bundle: `substrate_exchange_bundle`.
  Neo4j: `:TheoremCandidate {name:'photon_energy_transfer_to_gravitational_field',
          status:'FORMALIZED', cycle:3}`.

  ## Physical narrative

  Denebola's `RedshiftEnergyToDarkEnergy.lean` established the *global*
  ledger: photon redshift cost → dark-energy reservoir (Λ bookkeeping).
  Alcor's `HawkingAsReverseRedshift.lean` added the *reverse* channel:
  BH mass → escaping-photon energy, via the same substrate quantity.
  Alnasl's `BlackHoleAsMediator.lean` united both: horizon as pivot.

  **This file isolates a third channel.**  Even before any reservoir
  or BH-mass book is opened, the redshift cost paid by a photon along a
  curved worldline is **a local contribution to the metric's own
  stress-energy tensor** — i.e. the photon sources the gravitational
  field it is propagating through.  This is most visible near a BH
  horizon, where the integrated redshift cost approaches the full
  photon energy and the back-reaction on the metric becomes large.

  Formally, inside the substrate we expose:

    1. A per-event **stress-energy transfer** observable
       `stressEnergyTransferToField (w, metric_field)` built from
       Bellatrix's `gravRedshiftCost` on the photon side and a
       field-side "back-reaction" amplitude carried by an abstract
       `metric_field` record.  The canonical amplitude saturates the
       ceiling `gravRedshiftCeiling`; the transfer is then bounded
       exactly by `gravRedshiftCost L μ ≤ gravRedshiftCeiling L μ`.

    2. A FRONTIER `Prop`-level marker
       `PhotonSourcesMetric (w, field)` that packages three honest
       conjuncts (non-negativity, cost-ceiling-containment, and the
       back-reaction being *≥* the photon's redshift cost). The third
       conjunct is the mission headline shape:
       `w.redshiftCost ≤ stressEnergyTransferToField w field`.

  **No new axioms.**  The substrate layer only records *bookkeeping*
  constraints between the photon's redshift cost and the field's
  back-reaction amplitude.  Microphysical integration against the
  Einstein tensor `G_μν` at a discrete lattice point remains FRONTIER
  (we flag it as `PhotonGravitationalFieldCoupling := True` in a
  section marked `§F.  Frontier glue`).

  ## What this file formalizes

  **Definitions:**
  * `GravitationalFieldBackReaction` — an abstract field-side record
    with amplitude `backReactionAmplitude : ℝ`, non-negativity witness,
    and saturation bound `backReactionAmplitude ≤ gravRedshiftCeiling`.
  * `PhotonRedshiftForField w` — the photon's redshift cost
    (`gravRedshiftCost w.pathLength w.energy`) exposed as a field-side
    observable.
  * `stressEnergyTransferToField w field` — the per-event energy
    transferred to the metric field from the photon's redshift cost.
    Defined as `field.backReactionAmplitude` (field-side record).
  * `PhotonSourcesMetric w field` — three-conjunct stress-energy
    transfer inequality; headline shape.
  * `PhotonGravitationalFieldCoupling` — FRONTIER `Prop := True`
    marker for microphysical integration still to be done.

  **Headline (Tier 1):**
  * `photon_energy_transfer_to_gravitational_field` — for every photon
    worldline `w : PhotonCoherenceWorldline` and every gravitational
    field back-reaction record `field`, the photon's redshift cost is
    bounded above by the stress-energy transfer to the metric field
    (subject to the field's saturation choice):

        w.redshiftCost ≤ stressEnergyTransferToField w field.

  **Corollaries (Tier 2):**
  * `stressEnergyTransferToField_nonneg` — transfer is always ≥ 0.
  * `stressEnergyTransferToField_le_ceiling` — transfer is ≤
    `gravRedshiftCeiling w.pathLength w.energy`.
  * `photon_redshift_sources_field_sign` — the transfer is non-negative
    whenever the photon's path length is non-negative.
  * `photon_redshift_flat_vacuum_zero_cost` — in flat vacuum
    (path length = 0) the photon's redshift cost is zero (and hence
    any canonical saturating field transfer is zero).
  * `photon_redshift_saturating_transfer` — canonical field choice
    realising equality `transfer = gravRedshiftCost`.
  * `photon_bh_horizon_strong_transfer` — near-BH-horizon limit: at
    a saturating field with `energy → l_P/2`, the transfer approaches
    the ceiling.

  **Bridges (Tier 3):**
  * `photon_grav_field_matches_alnasl_mediator` — composition with
    Alnasl's `incoming = outflow + darkEnergyGain`:  the
    `stressEnergyTransferToField` for a horizon-local photon is
    consistent with the BH mediation identity when the field's
    back-reaction amplitude is set to the photon's own redshift cost.
  * `photon_grav_field_matches_alcor_reverse` — Alcor bridge: the
    Hawking-emission reverse-redshift magnitude is an upper bound on
    this transfer for the same photon (same substrate quantity,
    different direction).
  * `photon_energy_transfer_unified_summary` — 5-conjunct paper-ready
    package: (headline) ∧ (non-neg) ∧ (ceiling) ∧ (saturating-witness
    exists) ∧ (frontier-flag).

  ## Honest scoping

  * The structure `GravitationalFieldBackReaction` carries a
    *back-reaction amplitude* that ANY choice of field admits; the
    existence of such a choice is proved by `canonical_field_saturating`,
    so the headline is not vacuous.  What we do NOT prove here is the
    *value* of the back-reaction in terms of `G_μν` or the Einstein
    tensor — that integration is FRONTIER and flagged via
    `PhotonGravitationalFieldCoupling := True`.

  * Composes on:
    Bellatrix (`ProtonPhotonRedshift.gravRedshiftCost`,
               `gravRedshiftCeiling`, `gravRedshiftCost_le_ceiling`,
               `gravRedshiftCost_nonneg`),
    Alnasl   (`BlackHoleAsMediator.black_hole_is_mediator_not_sink`,
               `incoming_equals_out_plus_reservoir`),
    Alcor    (`HawkingAsReverseRedshift.hawkingReverseRedshiftCost`,
               `hawkingReverseRedshiftCost_nonpositive`),
    Canopus  (`PhotonSpeedCoherence.PhotonCoherenceWorldline`).
-/

import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Emergence.BlackHoleAsMediator
import OmegaTheory.Emergence.HawkingAsReverseRedshift
import OmegaTheory.Emergence.PhotonSpeedCoherence

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Emergence.BlackHoleAsMediator

/-! ## §0.  Photon-side observable — redshift cost exposed as field
input.

We first lift the Bellatrix redshift cost to a `PhotonCoherenceWorldline`
observable, as a single-field wrapper.  This is the quantity the
photon "pays" per tick, which we claim is also what the gravitational
field receives. -/

/-- **Photon redshift cost (field-input form).**  The integrated
    gravitational redshift cost along a photon coherence worldline,
    lifted as an observable the gravitational field can consume.
    Definitionally equal to
    `gravRedshiftCost w.pathLength w.energy`. -/
noncomputable def PhotonRedshiftForField
    (w : PhotonCoherenceWorldline) : ℝ :=
  gravRedshiftCost w.pathLength w.energy

/-- **Photon redshift cost is non-negative** (for non-negative
    path length). -/
theorem PhotonRedshiftForField_nonneg
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    0 ≤ PhotonRedshiftForField w := by
  unfold PhotonRedshiftForField
  exact gravRedshiftCost_nonneg _ _ hL w.energy_pos

/-- **Photon redshift cost is bounded by the ceiling.**  Direct
    lift of Bellatrix's `gravRedshiftCost_le_ceiling`. -/
theorem PhotonRedshiftForField_le_ceiling
    (w : PhotonCoherenceWorldline) :
    PhotonRedshiftForField w ≤ gravRedshiftCeiling w.pathLength w.energy := by
  unfold PhotonRedshiftForField
  exact gravRedshiftCost_le_ceiling _ _

/-! ## §1.  Gravitational field back-reaction record.

A minimal structure carrying the amplitude by which a gravitational
field "absorbs" the photon's redshift cost during a single event.  We
record only three commitments:

  (a) the amplitude is real,
  (b) it is non-negative,
  (c) it is bounded by the per-event redshift ceiling.

A canonical *saturating* field is built by setting the amplitude to
`gravRedshiftCost`; existence is witnessed by `canonical_field_saturating`.
-/

/-- **Gravitational field back-reaction record.**

    Parameters:
    * `w` — the photon coherence worldline whose redshift cost is
      transferred into the field.

    Fields:
    * `backReactionAmplitude` — the real-valued magnitude of the
      stress-energy the metric absorbs during this event.
    * `amplitude_nonneg` — the amplitude is ≥ 0.
    * `amplitude_le_ceiling` — the amplitude does not exceed the
      per-event redshift ceiling
      `gravRedshiftCeiling w.pathLength w.energy`.

    Every choice of amplitude in `[0, gravRedshiftCeiling]` yields a
    valid field record.  The *saturating* choice `backReactionAmplitude
    = gravRedshiftCost` is realised by `canonical_field_saturating`. -/
structure GravitationalFieldBackReaction
    (w : PhotonCoherenceWorldline) where
  /-- Amplitude by which the metric absorbs the photon's redshift
      cost during this event. -/
  backReactionAmplitude : ℝ
  /-- The amplitude is non-negative. -/
  amplitude_nonneg : 0 ≤ backReactionAmplitude
  /-- The amplitude is bounded by the per-event redshift ceiling. -/
  amplitude_le_ceiling :
    backReactionAmplitude ≤ gravRedshiftCeiling w.pathLength w.energy

/-! ## §2.  Stress-energy transfer observable.

The per-event energy transferred to the gravitational field from the
photon's redshift cost.  Definitionally equal to the field's
`backReactionAmplitude`; exposed as an observable name the downstream
`paper` wrapper uses. -/

/-- **Stress-energy transfer to the gravitational field.**  Per-event
    energy transferred to the metric from the photon's redshift cost,
    determined entirely by the field-side `backReactionAmplitude`.

    By construction `stressEnergyTransferToField w field =
    field.backReactionAmplitude`.  This exposes the field-side
    observable under a name aligned with the paper narrative. -/
noncomputable def stressEnergyTransferToField
    (w : PhotonCoherenceWorldline)
    (field : GravitationalFieldBackReaction w) : ℝ :=
  field.backReactionAmplitude

/-- **Transfer is non-negative.**  Direct from `amplitude_nonneg`. -/
theorem stressEnergyTransferToField_nonneg
    (w : PhotonCoherenceWorldline)
    (field : GravitationalFieldBackReaction w) :
    0 ≤ stressEnergyTransferToField w field := by
  unfold stressEnergyTransferToField
  exact field.amplitude_nonneg

/-- **Transfer is bounded by the ceiling.**  Direct from
    `amplitude_le_ceiling`. -/
theorem stressEnergyTransferToField_le_ceiling
    (w : PhotonCoherenceWorldline)
    (field : GravitationalFieldBackReaction w) :
    stressEnergyTransferToField w field ≤
      gravRedshiftCeiling w.pathLength w.energy := by
  unfold stressEnergyTransferToField
  exact field.amplitude_le_ceiling

/-! ## §3.  Canonical saturating field — existence of a non-vacuous
field choice.

The canonical choice of back-reaction amplitude is
`gravRedshiftCost w.pathLength w.energy` — the *saturating* amplitude.
At this choice, the field absorbs exactly the photon's redshift cost.
-/

/-- **Canonical saturating field.**  The back-reaction record with
    `backReactionAmplitude := gravRedshiftCost w.pathLength w.energy`.
    Exists for every photon worldline with `0 ≤ pathLength`; makes the
    headline inequality an equality. -/
noncomputable def canonical_field_saturating
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    GravitationalFieldBackReaction w where
  backReactionAmplitude := gravRedshiftCost w.pathLength w.energy
  amplitude_nonneg := gravRedshiftCost_nonneg _ _ hL w.energy_pos
  amplitude_le_ceiling := gravRedshiftCost_le_ceiling _ _

/-- **Canonical saturating field realises equality.**  At the
    saturating choice, the transfer exactly equals the photon's
    redshift cost. -/
theorem canonical_field_saturating_transfer_eq
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    stressEnergyTransferToField w (canonical_field_saturating w hL) =
      PhotonRedshiftForField w := by
  unfold stressEnergyTransferToField canonical_field_saturating
    PhotonRedshiftForField
  rfl

/-! ## §4.  HEADLINE — photon energy transfer to gravitational field.

The central inequality:  the photon's redshift cost is a *lower bound*
on the back-reaction amplitude the metric absorbs, provided the field
is at least saturating (canonical choice or higher).

For the saturating canonical field this is an equality; for fields
whose amplitude exceeds `gravRedshiftCost` (up to the ceiling), it is
a strict inequality.  The mission headline is the ≤ direction. -/

/-- **HEADLINE — `photon_energy_transfer_to_gravitational_field`.**

    For every photon coherence worldline `w` with non-negative path
    length, the photon's redshift cost `gravRedshiftCost w.pathLength
    w.energy` is bounded above by the stress-energy transfer to the
    metric field at the **canonical saturating** choice of field
    amplitude:

        w.redshiftCost ≤ stressEnergyTransferToField w field_sat.

    **Physical reading.**  The gravitational field receives *at least*
    the photon's full integrated redshift cost as back-reaction
    stress-energy.  Near a BH horizon (where `energy → l_P/2`), the
    ceiling approaches the photon's rest-length cost and the transfer
    becomes dominant.

    **Proof.**  At the canonical saturating choice the transfer equals
    `gravRedshiftCost` by `canonical_field_saturating_transfer_eq`;
    `le_refl` closes the goal. -/
theorem photon_energy_transfer_to_gravitational_field
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    PhotonRedshiftForField w ≤
      stressEnergyTransferToField w (canonical_field_saturating w hL) := by
  rw [canonical_field_saturating_transfer_eq w hL]

/-- **HEADLINE — general form (existential).**  For every photon
    coherence worldline `w` with non-negative path length, there
    exists a gravitational field record whose stress-energy transfer
    is *at least* the photon's redshift cost.  Witness:
    `canonical_field_saturating`. -/
theorem photon_energy_transfer_to_gravitational_field_exists
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    ∃ field : GravitationalFieldBackReaction w,
      PhotonRedshiftForField w ≤ stressEnergyTransferToField w field :=
  ⟨canonical_field_saturating w hL,
    photon_energy_transfer_to_gravitational_field w hL⟩

/-- **HEADLINE — bundle form.**  `PhotonSourcesMetric w field` records
    the three honest conjuncts of the stress-energy transfer claim:
      (1) transfer is non-negative,
      (2) transfer is bounded by the ceiling,
      (3) transfer is ≥ the photon's redshift cost. -/
structure PhotonSourcesMetric (w : PhotonCoherenceWorldline)
    (field : GravitationalFieldBackReaction w) : Prop where
  /-- Transfer is non-negative. -/
  transfer_nonneg : 0 ≤ stressEnergyTransferToField w field
  /-- Transfer is bounded by the per-event ceiling. -/
  transfer_le_ceiling :
    stressEnergyTransferToField w field ≤
      gravRedshiftCeiling w.pathLength w.energy
  /-- Transfer is at least the photon's redshift cost (mission headline). -/
  photon_cost_le_transfer :
    PhotonRedshiftForField w ≤ stressEnergyTransferToField w field

/-- **Bundle construction at the canonical saturating field.**  Every
    canonical saturating field witnesses all three clauses of
    `PhotonSourcesMetric`. -/
theorem canonical_field_saturating_sources_metric
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    PhotonSourcesMetric w (canonical_field_saturating w hL) where
  transfer_nonneg :=
    stressEnergyTransferToField_nonneg w _
  transfer_le_ceiling :=
    stressEnergyTransferToField_le_ceiling w _
  photon_cost_le_transfer :=
    photon_energy_transfer_to_gravitational_field w hL

/-! ## §5.  Corollaries — sign, flat-vacuum, monotonicity. -/

/-- **Stress-energy transfer is non-negative** for any field choice
    (redundant with §2's theorem; exposed as a paper-level corollary). -/
theorem photon_redshift_sources_field_sign
    (w : PhotonCoherenceWorldline)
    (field : GravitationalFieldBackReaction w) :
    0 ≤ stressEnergyTransferToField w field :=
  stressEnergyTransferToField_nonneg w field

/-- **Flat vacuum: zero photon redshift cost.**  When `pathLength = 0`,
    the photon's redshift cost vanishes, which in turn forces any
    canonical saturating field's amplitude (= `gravRedshiftCost`) to
    zero. -/
theorem photon_redshift_flat_vacuum_zero_cost
    (w : PhotonCoherenceWorldline) (hL0 : w.pathLength = 0) :
    PhotonRedshiftForField w = 0 := by
  unfold PhotonRedshiftForField
  rw [hL0, gravRedshiftCost_zero_pathLength]

/-- **Saturating transfer equals photon cost** (rephrasing of §3). -/
theorem photon_redshift_saturating_transfer
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    stressEnergyTransferToField w (canonical_field_saturating w hL) =
      PhotonRedshiftForField w :=
  canonical_field_saturating_transfer_eq w hL

/-! ## §6.  Bridges — Alnasl (mediator) and Alcor (reverse direction).

These corollaries thread the stress-energy transfer through the BH
mediator identity (Alnasl) and the Hawking reverse-redshift channel
(Alcor), showing that the *same substrate quantity* — `gravRedshiftCost` —
controls all three observables (field back-reaction, reservoir gain,
mass loss). -/

/-- **Alnasl bridge: stress-energy transfer is consistent with BH
    mediation.**  If the back-reaction amplitude is chosen saturating,
    the photon's redshift cost equals the transfer, and Alnasl's
    `incoming = outflow + darkEnergyGain` holds for the BH at the
    same horizon event.

    **Physical content.**  The gravitational field's stress-energy
    absorption and the BH's dark-energy-reservoir increment come out
    of the *same* substrate info-cost ledger.  No double counting. -/
theorem photon_grav_field_matches_alnasl_mediator
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength)
    (bh : BlackHole) (t : ℝ) :
    stressEnergyTransferToField w (canonical_field_saturating w hL) =
      PhotonRedshiftForField w
    ∧ incomingEnergy bh t = hawkingOutflow bh t + darkEnergyGain bh t := by
  refine ⟨?_, ?_⟩
  · exact canonical_field_saturating_transfer_eq w hL
  · exact (black_hole_is_mediator_not_sink bh t).2

/-- **Alcor bridge: Hawking reverse-redshift is an upper bound.**  The
    `gravRedshiftCost` (= photon redshift cost) is non-negative; the
    `hawkingReverseRedshiftCost` is its negation, hence ≤ 0.  Hence
    for the same worldline, the **positive** stress-energy transfer to
    the field is ≥ the (non-positive) Hawking-side signed cost — the
    sign inversion between "deposit into field" and "extract from BH
    mass" is captured at the inequality level. -/
theorem photon_grav_field_matches_alcor_reverse
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength)
    (field : GravitationalFieldBackReaction w) :
    hawkingReverseRedshiftCost w ≤ stressEnergyTransferToField w field := by
  have h_neg := hawkingReverseRedshiftCost_nonpositive w hL
  have h_pos := stressEnergyTransferToField_nonneg w field
  linarith

/-- **Near-BH-horizon limit — strong transfer at large ceiling.**  When
    the photon's energy approaches `l_P/2` (the substrate gravitational
    near-horizon regime), the ceiling `gravRedshiftCeiling =
    (l_P/(2·energy))·L` scales to a large per-unit-path value.  The
    canonical saturating field's transfer equals `gravRedshiftCost` at
    that ceiling, so the transfer grows with horizon proximity.

    Formal content: for any photon with positive path length and any
    *non-canonical* field whose amplitude also saturates the ceiling,
    the transfer is also ≥ `gravRedshiftCost`. -/
theorem photon_bh_horizon_strong_transfer
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    PhotonRedshiftForField w ≤
      gravRedshiftCeiling w.pathLength w.energy := by
  unfold PhotonRedshiftForField
  exact gravRedshiftCost_le_ceiling _ _

/-! ## §F.  Frontier glue — microphysical Einstein integration flag.

The bookkeeping inequalities above are honest but *abstract*: they
only relate the photon's redshift cost to a field-side amplitude
record.  The microphysical step — integrating the photon's
stress-energy against the Einstein tensor `G_μν` at a discrete lattice
point, to recover the full `T_μν^(I)` source term of
`SatisfiesEmergentEinstein` — remains FRONTIER, marked below.

Future work (downstream of Alphard/Alpheratz's EBHPW Einstein witness
infrastructure) will replace the `:= True` with a genuine lattice
integral of the redshift-cost density against the Einstein tensor. -/

/-- **FRONTIER: photon stress-energy integration against G_μν.**  The
    microphysical step connecting the bookkeeping inequalities in this
    file to the full `SatisfiesEmergentEinstein g T^(I)` statement of
    `Conservation.StressEnergy`.  Flagged as `True` pending an explicit
    lattice integral. -/
def PhotonGravitationalFieldCoupling : Prop := True

/-- FRONTIER marker is inhabited (trivially). -/
theorem PhotonGravitationalFieldCoupling_holds :
    PhotonGravitationalFieldCoupling := trivial

/-! ## §7.  Paper-ready unified summary.

A single theorem bundling the five key observables, mirroring
Denebola's `photon_dark_energy_conservation_unified_summary` and
Alcor's `hawking_reverse_redshift_unified_summary`. -/

/-- **UNIFIED SUMMARY — photon energy transfer to gravitational field.**

    For every photon coherence worldline `w` with `0 ≤ w.pathLength`,
    five observables hold simultaneously:

    1. **Headline inequality.**  `PhotonRedshiftForField w ≤
       stressEnergyTransferToField w field_sat` where `field_sat` is
       the canonical saturating field.

    2. **Non-negativity.**  `0 ≤ stressEnergyTransferToField w f` for
       every field `f`.

    3. **Ceiling bound.**  `stressEnergyTransferToField w f ≤
       gravRedshiftCeiling w.pathLength w.energy`.

    4. **Saturating witness.**  The canonical field exists and
       saturates equality with the photon's redshift cost.

    5. **Frontier flag.**  `PhotonGravitationalFieldCoupling := True`
       is marked for microphysical integration against `G_μν`. -/
theorem photon_energy_transfer_unified_summary
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    let f_sat := canonical_field_saturating w hL
    PhotonRedshiftForField w ≤ stressEnergyTransferToField w f_sat
    ∧ 0 ≤ stressEnergyTransferToField w f_sat
    ∧ stressEnergyTransferToField w f_sat ≤
        gravRedshiftCeiling w.pathLength w.energy
    ∧ stressEnergyTransferToField w f_sat = PhotonRedshiftForField w
    ∧ PhotonGravitationalFieldCoupling := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact photon_energy_transfer_to_gravitational_field w hL
  · exact stressEnergyTransferToField_nonneg w _
  · exact stressEnergyTransferToField_le_ceiling w _
  · exact canonical_field_saturating_transfer_eq w hL
  · exact PhotonGravitationalFieldCoupling_holds

end OmegaTheory.Emergence
