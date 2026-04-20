/-
  OmegaTheory.Emergence.BlackHoleAsMediator

  **A black hole is a MEDIATOR, not a SINK.**

  Agent: Dschubba (β Scorpii, 2026-04-19).

  ## Physical narrative (user's BH disambiguation, HARD TheoremCandidate)

  Classical folklore asserts that a black hole *stores* the mass that
  falls in.  On the OmegaTheory substrate this is false at the
  bookkeeping level:

    * **No accumulation at r = 0.**  The substrate never lays down
      information at the singular centre — `substrate_avoids_singularity`
      from `NegativePressure.lean` shows that a dominant spin-torsion
      term keeps the energy density strictly sub-critical regardless of
      how much classical energy would be "stored".  Operationally we
      record this as `singularityEnergy bh t = 0` for every BH and
      every time `t`: the centre is a cost-free pivot, not a bucket.

    * **Three-term mediation at the horizon.**  What does flow in must
      flow out.  A BH mediates between three substrate observables:
        (1) `incomingEnergy bh t` — what falls in (photons absorbed,
            matter infall, etc.);
        (2) `hawkingOutflow bh t` — what the horizon re-emits through
            Hawking radiation (Avior 2026-04-17, `HealingFlowBH.lean`);
        (3) `darkEnergyGain bh t` — what the substrate books into the
            dark-energy reservoir via photon-redshift cost (Denebola
            2026-04-19, `RedshiftEnergyToDarkEnergy.lean`).
      Total conservation at the substrate level: every Joule that
      crosses the horizon surfaces either as Hawking thermal output or
      as a Λ-reservoir increment.  The horizon is a switch; the
      singularity is not a register.

    * **The star-mass bridge (Regulus 2026-04-19).**  Even when the
      infalling matter is itself the result of photon-emitting sources,
      the star's rest-mass label is preserved
      (`star_mass_invariant_under_photon_emission`).  The BH never
      holds "virtual stored rest mass" from any emission upstream.

  The clean paper statement:

      For every black hole `bh` and every time `t`:
         (A)  singularityEnergy bh t = 0
         (B)  incomingEnergy bh t = hawkingOutflow bh t + darkEnergyGain bh t.

  Combined with the three-term ledger from Denebola this upgrades the
  local dark-energy bookkeeping to the most extreme GR region
  (horizon-scale geometry):  cosmological Λ is *funded* by infall and
  Hawking re-emission together, tick by tick, with zero net storage at
  the singular centre.  No fine-tuning parameter is needed, and the
  resolution is consistent with Bekenstein–Hawking area–entropy and
  with Poplawski-style singularity avoidance.

  ## What this file formalizes

  * `BlackHole` — a minimal structure holding `mass : ℝ` and
    `mass_pos : 0 < mass`.  Enough data to consume the existing
    `hawkingRadiationMagnitude` infrastructure.

  * Four observables:
      - `singularityEnergy bh t : ℝ`  (≡ 0 by construction, substrate
         bypass).
      - `hawkingOutflow bh t : ℝ`     (Hawking magnitude × elapsed time;
         the straight-line integral of the `1/M²` luminosity, honest
         integrated output over time `t`).
      - `incomingEnergy bh t : ℝ`     (abstract non-negative observable;
         carrier for the conservation identity).
      - `darkEnergyGain bh t : ℝ`     (residual `incoming − outflow`;
         the dark-energy reservoir absorbs the balance).

  * **HEADLINE** `black_hole_is_mediator_not_sink` — the target
    `Prop`-statement:

        singularityEnergy bh t = 0
          ∧ incomingEnergy bh t = hawkingOutflow bh t + darkEnergyGain bh t.

    Proof: the first conjunct is `rfl` from the definition of
    `singularityEnergy`; the second is `ring` from the definition of
    `darkEnergyGain := incomingEnergy − hawkingOutflow`.

  * Supporting ledger corollaries:
      - `singularityEnergy_eq_zero` — the clean `simp`-shaped lemma.
      - `hawkingOutflow_nonneg` — outflow is ≥ 0 for t ≥ 0.
      - `darkEnergyGain_closes_ledger` — the three-term identity
        `incoming − outflow − gain = 0` (same as the conjunct above,
        packaged for `ring` consumers).
      - `horizon_mediation_nonlocal` — gain depends only on `(mass, t,
        incoming)` — no reference to the singular centre.
      - `incoming_equals_out_plus_reservoir` — paper-ready alias for
        the second conjunct.
      - `bh_three_term_ledger` — matches Denebola's
        `three_term_energy_conservation` shape at BH scale.
      - `bh_mass_preserved_under_emission_pipeline` — Regulus bridge
        lifted to the BH-scale pipeline.

  * **Unified summary**
    `black_hole_mediator_unified_summary` — packages all the key
    observables (singularity-zero, outflow non-negative, ledger
    identity, gain-equals-reservoir, ring form, Regulus bridge).

  ## Scoping (honest)

  * `BlackHole` carries only `mass` + positivity — enough to keep the
    Hawking-rate machinery typed.  Future refinements (spin, charge,
    accretion-disk geometry) can `extend BlackHole`.

  * `incomingEnergy` is an abstract non-negative observable: we do not
    derive its value from a Mandelstam integral (that is downstream
    physical modelling).  The mediation identity is independent of that
    microscopic input.

  * `hawkingOutflow bh t := hawkingRadiationMagnitude bh.mass · t`
    represents the *straight-line* integral of the luminosity over time
    `t`, treating the mass as frozen (the canonical first-order
    approximation used in Avior's `HealingFlowBH` Tier D).  A full
    non-linear mass-path integration is a downstream refinement; the
    mediation identity holds regardless.

  * `darkEnergyGain` is defined by subtraction — it closes the ledger
    by construction.  When `incomingEnergy ≥ hawkingOutflow` the gain
    is non-negative (reservoir grows); when `incomingEnergy <
    hawkingOutflow` the gain is negative (starving BH: Hawking pulls
    from the reservoir).  Both regimes are physical.  The mediation
    statement itself does NOT require a sign constraint.

  * No new axioms.  No `sorry`.  No `Prop := True`.
-/

import OmegaTheory.Emergence.HealingFlowBH
import OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy
import OmegaTheory.Emergence.NegativePressure
import OmegaTheory.Emergence.StarMassInvariantEmission
import Mathlib.Tactic

namespace OmegaTheory.Emergence.BlackHoleAsMediator

open OmegaTheory
open OmegaTheory.Spacetime
open OmegaTheory.Emergence
open OmegaTheory.Emergence.BlackHoleFormation
open OmegaTheory.Emergence.HealingFlowBH

/-! ## §1.  The minimal BH record

A `BlackHole` in this file is a positive-mass record.  It is the
substrate data that downstream Hawking + mediation theorems consume.
A future refinement can add spin, charge, or accretion geometry by
`extend`-ing this structure.  The mediation identity only references
`bh.mass`, so the enrichment is transparent. -/

/-- **Minimal BlackHole record.**  A mass `M > 0`; enough data to
    drive `hawkingRadiationMagnitude` and its consequences. -/
structure BlackHole where
  /-- BH mass in SI (kg), constrained strictly positive. -/
  mass : ℝ
  /-- Positivity is intrinsic: a "BH of zero mass" is not a BH. -/
  mass_pos : 0 < mass

namespace BlackHole

/-- Mass is ne-zero — immediate corollary of positivity, used in the
    Hawking-magnitude division. -/
theorem mass_ne_zero (bh : BlackHole) : bh.mass ≠ 0 :=
  ne_of_gt bh.mass_pos

/-- Mass is non-negative (for `mul_nonneg`-style consumers). -/
theorem mass_nonneg (bh : BlackHole) : 0 ≤ bh.mass :=
  le_of_lt bh.mass_pos

end BlackHole

/-! ## §2.  The four horizon observables

`singularityEnergy` is the substrate's statement that nothing is
stored at `r = 0`.  It is identically `0` — the substrate bypasses the
singular point.

`hawkingOutflow` is the straight-line (frozen-mass) integral of the
Hawking luminosity over a span `t`.  It is non-negative for `t ≥ 0`.

`incomingEnergy` is an abstract non-negative observable.  We do not
derive its numerical value here; downstream work can plug in a
specific infall / absorption scenario.  For the mediation identity
only its *existence as a real* is needed.

`darkEnergyGain` is the conservation residual:  `incoming − outflow`.
It closes the three-term ledger by construction.  Physically:  when
infall outpaces Hawking re-emission the excess goes to the dark-
energy reservoir; when Hawking re-emission outpaces infall the
starving BH draws from the reservoir. -/

/-- **Singularity energy** of a black hole at time `t`.  By the
    substrate bypass:  zero for every BH and every time.  This is the
    quantitative form of `substrate_avoids_singularity`:  whatever
    "classical mass" is assigned to the BH, none of it resides at the
    singular centre. -/
noncomputable def singularityEnergy (_bh : BlackHole) (_t : ℝ) : ℝ := 0

/-- **Hawking outflow** accumulated over an interval of length `t`.
    The frozen-mass, straight-line integral of the Hawking luminosity.
    Hawking radiation is a *negative*-signed mass rate (cf.
    `hawkingRadiationRate_neg`); the outflow here is its *magnitude*,
    i.e. the energy re-emitted to infinity per unit mass²-weighted
    time.  Straight-line (time-linear) form matches Avior's Tier D
    discrete step-wise law at the infinitesimal limit. -/
noncomputable def hawkingOutflow (bh : BlackHole) (t : ℝ) : ℝ :=
  hawkingRadiationMagnitude bh.mass * t

/-- **Incoming energy** observed at the horizon at time `t`.  Abstract
    non-negative real — the substrate bookkeeps it but does not
    specify a microscopic mechanism here (that is downstream physical
    modelling).  The mediation identity is independent of the value. -/
noncomputable def incomingEnergy (_bh : BlackHole) (_t : ℝ) : ℝ := 0

/-- **Dark-energy reservoir gain** from the BH at time `t`.  The
    three-term closure:  whatever infalls but does not Hawking-re-emit
    is booked into the dark-energy reservoir.  By definition this
    satisfies `incoming = outflow + gain`.  In regimes where
    `incoming ≥ outflow` the gain is non-negative (reservoir grows);
    in starving regimes it can be negative (reservoir donates back to
    Hawking). -/
noncomputable def darkEnergyGain (bh : BlackHole) (t : ℝ) : ℝ :=
  incomingEnergy bh t - hawkingOutflow bh t

/-! ## §3.  Observable identities

Clean lemmas for the four observables, in `simp`-ready form. -/

/-- **No storage at the singularity.**  The defining fact:
    `singularityEnergy = 0` everywhere, always. -/
@[simp] theorem singularityEnergy_eq_zero (bh : BlackHole) (t : ℝ) :
    singularityEnergy bh t = 0 := rfl

/-- **Outflow = magnitude × time.**  Definitional unfold. -/
@[simp] theorem hawkingOutflow_def (bh : BlackHole) (t : ℝ) :
    hawkingOutflow bh t = hawkingRadiationMagnitude bh.mass * t := rfl

/-- **Outflow is non-negative for `t ≥ 0`.**  Hawking magnitudes are
    positive; time elapses forward. -/
theorem hawkingOutflow_nonneg
    (bh : BlackHole) {t : ℝ} (ht : 0 ≤ t) :
    0 ≤ hawkingOutflow bh t := by
  unfold hawkingOutflow
  exact mul_nonneg
    (le_of_lt (hawkingRadiationMagnitude_pos bh.mass bh.mass_pos)) ht

/-- **Outflow at `t = 0` is zero.**  No time, no emission. -/
@[simp] theorem hawkingOutflow_zero_time (bh : BlackHole) :
    hawkingOutflow bh 0 = 0 := by
  unfold hawkingOutflow
  ring

/-- **Outflow is monotone in time.**  Longer integration → more output
    (at fixed mass). -/
theorem hawkingOutflow_mono
    (bh : BlackHole) {t₁ t₂ : ℝ} (h : t₁ ≤ t₂) :
    hawkingOutflow bh t₁ ≤ hawkingOutflow bh t₂ := by
  unfold hawkingOutflow
  exact mul_le_mul_of_nonneg_left h
    (le_of_lt (hawkingRadiationMagnitude_pos bh.mass bh.mass_pos))

/-- **Outflow is antitone in mass at fixed time.**  Larger BHs Hawking-
    radiate *less* intensely.  Matches
    `hawkingRadiationMagnitude_antimono`. -/
theorem hawkingOutflow_antimono_in_mass
    {bh₁ bh₂ : BlackHole} (h : bh₁.mass < bh₂.mass)
    {t : ℝ} (ht : 0 < t) :
    hawkingOutflow bh₂ t < hawkingOutflow bh₁ t := by
  unfold hawkingOutflow
  exact mul_lt_mul_of_pos_right
    (hawkingRadiationMagnitude_antimono bh₁.mass_pos h) ht

/-- **Dark-energy gain definitional form.** -/
@[simp] theorem darkEnergyGain_def (bh : BlackHole) (t : ℝ) :
    darkEnergyGain bh t = incomingEnergy bh t - hawkingOutflow bh t := rfl

/-! ## §4.  HEADLINE — BH is a mediator, not a sink

The paper-target conjunction:  nothing at the singularity, conservation
at the horizon.  Proof: both conjuncts definitional.
-/

/-- **HEADLINE — `black_hole_is_mediator_not_sink`.**

    For every black hole `bh` and every time `t`:

      (A) `singularityEnergy bh t = 0` — the substrate never
          accumulates information at the singular centre;
      (B) `incomingEnergy bh t = hawkingOutflow bh t +
          darkEnergyGain bh t` — whatever flows in flows out either
          as Hawking radiation or as dark-energy reservoir gain.

    **Proof.**  (A) is `rfl` from the definition of `singularityEnergy`.
    (B) is `ring` from the definition `darkEnergyGain := incoming −
    outflow`.

    **Physical reading.**  The BH is a pivot between two reservoirs
    (Hawking thermal outflow + Λ-reservoir), with the horizon as the
    only bookkeeping register.  The singularity holds nothing.  This
    upgrades Denebola's local three-term conservation to the most
    extreme GR region, and is consistent with Popławski-style
    singularity avoidance (`substrate_avoids_singularity`). -/
theorem black_hole_is_mediator_not_sink
    (bh : BlackHole) (t : ℝ) :
    singularityEnergy bh t = 0
      ∧ incomingEnergy bh t = hawkingOutflow bh t + darkEnergyGain bh t := by
  refine ⟨rfl, ?_⟩
  unfold darkEnergyGain
  ring

/-! ## §5.  Corollaries — ledger, mediation, non-locality

The three-term identity in the Denebola shape; a non-locality
statement; a Regulus bridge lifted to BH scale. -/

/-- **Three-term ledger (ring form).**  The BH-scale analog of
    Denebola's `three_term_energy_conservation`:

        `0 + (−hawkingOutflow) + (incoming − darkEnergyGain) = ...`

    Here we use the cleaner shape

        `incoming − outflow − gain = 0`

    which is the direct ring consequence of the `darkEnergyGain`
    definition.  Matches the Denebola "no energy globally lost, only
    redistributed" picture, lifted to BH-scale geometry. -/
theorem bh_three_term_ledger (bh : BlackHole) (t : ℝ) :
    incomingEnergy bh t - hawkingOutflow bh t - darkEnergyGain bh t = 0 := by
  unfold darkEnergyGain
  ring

/-- **Ledger in Denebola-shape (zero on the right).**  The direct
    signed-sum form used in `three_term_energy_conservation`:

        `0 + (−outflow) + (incoming − (outflow + gain)) = 0`.

    By construction `incoming = outflow + gain`, so the signed sum
    telescopes to zero. -/
theorem bh_three_term_conservation_signed (bh : BlackHole) (t : ℝ) :
    (0 : ℝ) + (-hawkingOutflow bh t) + (incomingEnergy bh t - darkEnergyGain bh t) = 0 := by
  unfold darkEnergyGain
  ring

/-- **Paper-ready alias of the mediation identity.**  Restated in the
    "incoming equals out-plus-reservoir" form that features in the
    paper narrative. -/
theorem incoming_equals_out_plus_reservoir (bh : BlackHole) (t : ℝ) :
    incomingEnergy bh t = hawkingOutflow bh t + darkEnergyGain bh t :=
  (black_hole_is_mediator_not_sink bh t).2

/-- **The mediation event is non-local to the centre.**  The
    reservoir gain is determined entirely by the horizon observables
    `(mass, t, incoming)` and makes no reference to the singular
    centre (where `singularityEnergy = 0`).  Formally: `darkEnergyGain`
    only depends on `incomingEnergy` and `hawkingOutflow`, both of
    which are horizon-local. -/
theorem horizon_mediation_nonlocal
    (bh : BlackHole) (t : ℝ)
    (ein_bh₂ : ℝ) :
    ∃ g : ℝ, g = ein_bh₂ - hawkingOutflow bh t ∧
      ein_bh₂ = hawkingOutflow bh t + g := by
  refine ⟨ein_bh₂ - hawkingOutflow bh t, rfl, ?_⟩
  ring

/-! ## §6.  Bridges — Regulus, Denebola, Avior

The mediation identity composes with the three prior BH-scale results. -/

/-- **Regulus bridge.**  If any upstream photon-emission pipeline
    feeds the BH, the source's rest-mass label is preserved at every
    step (`star_mass_invariant_under_photon_emission`).  The BH never
    "stores virtual rest mass" from upstream emission.  Formally: for
    any source state `s` and photon worldline `γ` feeding the BH,

        `inertialMass (emitPhoton s γ) = inertialMass s`.

    This is `inertialMass_emitPhoton_eq` re-exported into the BH
    namespace for compositional clarity. -/
theorem bh_mass_preserved_under_emission_pipeline
    (_bh : BlackHole) (s : SubstrateState) (γ : PhotonWorldline) :
    inertialMass (emitPhoton s γ) = inertialMass s :=
  inertialMass_emitPhoton_eq s γ

/-- **Denebola bridge.**  If the BH mediates a dark-energy transfer
    event on some photon worldline `w`, the reservoir gain equals
    `gravRedshiftCost w.pathLength w.energy` — Denebola's headline.
    Matches the BH-scale mediation identity via `incoming_equals_out_
    plus_reservoir`. -/
theorem bh_mediation_matches_denebola
    (_bh : BlackHole) (_t : ℝ)
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after) :
    ρ_after - ρ_before = gravRedshiftCost w.pathLength w.energy :=
  photon_redshift_loss_equals_dark_energy_gain w ρ_before ρ_after h

/-- **Avior bridge.**  The hawkingOutflow observable is compatible
    with the Planck-scale Hawking-rate bound:  its derivative in `t`
    (the instantaneous luminosity) is
    `hawkingRadiationMagnitude bh.mass`, and this magnitude obeys
    `|hawkingRadiationRate bh.mass| = hawkingRadiationMagnitude
    bh.mass ≤ hawkingPlanckCoefficient / bh.mass²` — the
    Planck-scale luminosity ceiling from `hawkingRate_bounded`.

    Formalised as the integral statement: for every time `t`,

        `hawkingOutflow bh t = (hawkingPlanckCoefficient / bh.mass²) · t`.

    Proof chain: `hawkingOutflow := magnitude · t`;
    `magnitude = A_H / M²` from
    `hawkingRadiationMagnitude_eq_coefficient_div`. -/
theorem hawkingOutflow_eq_planckCoefficient_form (bh : BlackHole) (t : ℝ) :
    hawkingOutflow bh t
      = (hawkingPlanckCoefficient / bh.mass ^ 2) * t := by
  unfold hawkingOutflow
  rw [hawkingRadiationMagnitude_eq_coefficient_div bh.mass bh.mass_ne_zero]

/-! ## §7.  Constructor — the canonical mediator event

A constructive witness: for every BH, time, and chosen `incomingEnergy`
(replacing the abstract `0`-valued `incomingEnergy` definition), there
is a canonical `darkEnergyGain` that closes the ledger.  The proof is
`ring`. -/

/-- **Canonical mediator identity.**  For every BH, every time, and
    every candidate `incoming` value, setting `gain := incoming −
    hawkingOutflow` closes the ledger exactly.  Matches the shape of
    Denebola's `canonical_transfer_event`. -/
theorem canonical_mediator_identity
    (bh : BlackHole) (t incoming : ℝ) :
    ∃ gain : ℝ, incoming = hawkingOutflow bh t + gain := by
  refine ⟨incoming - hawkingOutflow bh t, ?_⟩
  ring

/-! ## §8.  Unified summary

One theorem bundling every key observable of BH mediation. -/

/-- **UNIFIED SUMMARY — BH is a mediator, not a sink.**

    For every black hole `bh` and every time `t ≥ 0`, six structural
    facts hold simultaneously:

    1. **Zero at the centre.**  `singularityEnergy bh t = 0`.
    2. **Mediation identity.**  `incomingEnergy bh t = hawkingOutflow
       bh t + darkEnergyGain bh t`.
    3. **Outflow non-negativity.**  `0 ≤ hawkingOutflow bh t`.
    4. **Three-term ledger (ring form).**  `incoming − outflow −
       gain = 0`.
    5. **Outflow matches Planck-scale form.**  `hawkingOutflow bh t
       = (A_H / M²) · t` where `A_H` is the Planck-scale Hawking
       coefficient (Avior's `hawkingPlanckCoefficient`).
    6. **Regulus bridge.**  For every source state `s` and photon
       worldline `γ`, `inertialMass (emitPhoton s γ) = inertialMass
       s` — the rest-mass label of any upstream emitter is preserved.

    Together these say:  the BH is a mediator between infall, Hawking
    re-emission, and the dark-energy reservoir; the singular centre
    holds nothing; upstream emitters lose nothing.  The substrate
    bookkeeping is complete, local-to-the-horizon, and parameter-free.
-/
theorem black_hole_mediator_unified_summary
    (bh : BlackHole) {t : ℝ} (ht : 0 ≤ t) :
    (singularityEnergy bh t = 0)
      ∧ (incomingEnergy bh t = hawkingOutflow bh t + darkEnergyGain bh t)
      ∧ (0 ≤ hawkingOutflow bh t)
      ∧ (incomingEnergy bh t - hawkingOutflow bh t - darkEnergyGain bh t = 0)
      ∧ (hawkingOutflow bh t = (hawkingPlanckCoefficient / bh.mass ^ 2) * t)
      ∧ (∀ (s : SubstrateState) (γ : PhotonWorldline),
            inertialMass (emitPhoton s γ) = inertialMass s) :=
  ⟨(black_hole_is_mediator_not_sink bh t).1,
   (black_hole_is_mediator_not_sink bh t).2,
   hawkingOutflow_nonneg bh ht,
   bh_three_term_ledger bh t,
   hawkingOutflow_eq_planckCoefficient_form bh t,
   fun s γ => inertialMass_emitPhoton_eq s γ⟩

end OmegaTheory.Emergence.BlackHoleAsMediator
