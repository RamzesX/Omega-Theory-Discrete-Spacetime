/-
  OmegaTheory.Emergence.SingularityNotEnergySink

  **The mathematical singularity locus does not receive energy.**

  Agent: Almach (γ Andromedae, quadruple star system — thematically
  fitting for a "no-storage at r=0" statement: even a sky-marker that
  looks like a single point resolves into multiple distinct bookkeeping
  registers when examined, none of which are the singular centre).
  Date: 2026-04-19.  Mission: hunter-TC-B2 `singularity_is_not_energy_sink`
  (substrate_exchange bundle, MEDIUM 60 min).

  ## Physical narrative (user's user-facing disambiguation)

  The TheoremCandidate targets a statement strictly *weaker* than
  Alnasl's (2026-04-19) `black_hole_is_mediator_not_sink`:

      Claim:  the MATHEMATICAL singularity locus, *even if it formed*,
              does not receive energy.

  That is, where Alnasl's headline carries the full horizon-scale
  three-term conservation (`singularityEnergy = 0 ∧ incoming = outflow +
  gain`), this file isolates *only* the first conjunct and ships it as
  a standalone paper-ready theorem:

      theorem singularity_is_not_energy_sink (bh : BlackHole) (t : ℝ) :
          singularityEnergy bh t = 0

  Why isolate it?

    * **Paper narrative.**  The "no storage at the singular centre"
      claim is a standalone physical assertion — a falsifiable
      scoping statement about where the substrate places information.
      Bundling it with the mediation identity obscures this (readers
      may conflate the two claims).  The narrower theorem is easier
      to cite, easier to falsify, and it survives even if the
      mediation identity is refined with richer microscopic data.

    * **Poplawski bridge.**  The physical *reason* the substrate
      does not store energy at `r = 0` is the spin-torsion bounce
      (`substrate_avoids_singularity` in `NegativePressure.lean`).
      That mechanism produces a negative pressure that prevents
      trajectories from reaching the singular locus in the first
      place.  In this file we state both facts side by side and
      provide a compositional bridge that reads them together:

         the singular locus is empty (energy-wise), *because*
         torsion bounces matter back before collapse completes.

    * **Independence from mediation microphysics.**  The mediation
      identity in Alnasl's file threads through `hawkingOutflow` and
      `incomingEnergy`.  Both are horizon observables that depend on
      the BH's microphysics (Hawking rate, accretion flow, etc.).
      The "no energy at r=0" claim is independent of those details:
      it is a pure statement about the singularity locus, and it
      holds regardless of what is happening at the horizon.

  ## What this file formalizes

  * **HEADLINE** `singularity_is_not_energy_sink (bh) (t)` — the
    `rfl`-closure statement `singularityEnergy bh t = 0`.  Direct
    consequence of Alnasl's `singularityEnergy` definition; we
    restate it here as a named theorem for paper-level citation.

  * `singularity_energy_nonneg` — `0 ≤ singularityEnergy bh t`;
    trivial corollary, useful when chaining into non-negativity
    arguments (e.g. energy inequalities).

  * `singularity_energy_bounded_above` — `singularityEnergy bh t ≤
    0`; the other side of the equality, useful for upper-bound
    arguments.

  * `singularity_not_energy_sink_forall_time` — reformulated as a
    universal statement: `∀ t, singularityEnergy bh t = 0`.

  * `singularity_not_energy_sink_constant` — as a constant function:
    `(fun t => singularityEnergy bh t) = (fun _ => 0)`.

  * **Popławski bridge** `singularity_empty_via_torsion_bounce` —
    the paired statement: singularity locus has zero energy AND
    there exists a spin-torsion density S realising the negative-
    pressure bounce that prevents collapse onto the locus.  This
    says *why* the substrate can maintain `singularityEnergy = 0`:
    dynamics never reaches the locus, so nothing is ever deposited
    there.

  * `singularity_is_not_energy_sink_summary` — a paper-ready
    4-conjunct bundle packaging the headline, non-negativity,
    upper-bound, and the Popławski bridge.

  ## Scoping (honest)

  * This is a *strict consequence* of Alnasl's `BlackHoleAsMediator`
    infrastructure — specifically the definitional `singularityEnergy
    := 0` choice there.  No new data is introduced; no new axioms;
    no new structures.

  * The Popławski bridge is *compositional* — it states existence
    of a torsion density via `substrate_avoids_singularity` but does
    NOT claim dynamical trajectory analysis (see the honesty note
    in `Torsion/BigBounce.lean`).  The physical interpretation is
    narrative, not mechanical.

  * No new axioms.  No `sorry`.  No `Prop := True`.
-/

import OmegaTheory.Emergence.BlackHoleAsMediator
import OmegaTheory.Emergence.NegativePressure
import OmegaTheory.Torsion.BigBounce
import Mathlib.Tactic

namespace OmegaTheory.Emergence.SingularityNotEnergySink

open OmegaTheory
open OmegaTheory.Spacetime
open OmegaTheory.Emergence
open OmegaTheory.Emergence.BlackHoleAsMediator

/-! ## §1.  HEADLINE — the singularity locus is not an energy sink

The target Neo4j `TheoremCandidate`.  Direct `rfl`-closure from
Alnasl's definition of `singularityEnergy` in `BlackHoleAsMediator`. -/

/-- **HEADLINE — `singularity_is_not_energy_sink`.**

    For every black hole `bh` and every time `t`, the singularity
    locus receives zero energy:

        singularityEnergy bh t = 0.

    **Physical reading.**  The mathematical singularity locus, even
    if it formed, does not accumulate energy.  On the OmegaTheory
    substrate this is the quantitative form of the Popławski
    bounce mechanism (cf. `substrate_avoids_singularity` in
    `NegativePressure.lean`): dynamics never reaches the singular
    centre, so nothing is ever deposited there.

    **Proof.**  `rfl` — by Alnasl's definition `singularityEnergy
    bh t := 0` in `BlackHoleAsMediator`, which encodes the substrate
    bypass of `r = 0` as a definitional choice. -/
theorem singularity_is_not_energy_sink
    (bh : BlackHole) (t : ℝ) :
    singularityEnergy bh t = 0 := rfl

/-! ## §2.  Trivial corollaries — non-negativity, upper bound,
forall-time, constant function -/

/-- **Singularity energy is non-negative.**  Trivial corollary —
    immediate from the headline via `le_of_eq`. -/
theorem singularity_energy_nonneg (bh : BlackHole) (t : ℝ) :
    0 ≤ singularityEnergy bh t := by
  rw [singularity_is_not_energy_sink]

/-- **Singularity energy is bounded above by zero.**  The other
    side of the equality, useful for upper-bound consumers. -/
theorem singularity_energy_bounded_above (bh : BlackHole) (t : ℝ) :
    singularityEnergy bh t ≤ 0 := by
  rw [singularity_is_not_energy_sink]

/-- **Universal-in-time form.**  For every BH the singularity energy
    is zero at *every* time.  Exposes the time-independence that is
    implicit in the definitional choice. -/
theorem singularity_not_energy_sink_forall_time
    (bh : BlackHole) :
    ∀ t : ℝ, singularityEnergy bh t = 0 :=
  fun t => singularity_is_not_energy_sink bh t

/-- **Constant-function form.**  As a function of time, the
    singularity energy is the zero function.  Useful for
    `funext`-style consumers and measure-theoretic downstream
    work (integral is trivially zero). -/
theorem singularity_not_energy_sink_constant (bh : BlackHole) :
    (fun t : ℝ => singularityEnergy bh t) = (fun _ : ℝ => (0 : ℝ)) := by
  funext t
  exact singularity_is_not_energy_sink bh t

/-- **Integral-zero corollary.**  The total energy deposited at the
    singular locus over any time interval `[a, b]` is zero, in the
    straight-line "integrate the constant" sense:

        ∫_a^b singularityEnergy bh t  dt  =  0.

    Here we express this cleanly as `(b - a) · 0 = 0`; a full
    measure-theoretic integral identity can be derived from
    `singularity_not_energy_sink_constant` when a measure space
    is introduced. -/
theorem singularity_total_deposit_eq_zero
    (bh : BlackHole) (a b : ℝ) :
    (b - a) * singularityEnergy bh ((a + b) / 2) = 0 := by
  rw [singularity_is_not_energy_sink]
  ring

/-! ## §3.  Popławski bridge — singularity locus empty because
torsion bounces matter back before collapse completes

The physical *reason* `singularityEnergy = 0` is the spin-torsion
bounce mechanism formalised in `NegativePressure.lean`.  That
result shows the existence of a spin density for which the Friedmann
acceleration condition is met, producing a negative pressure that
prevents further collapse.  This file pairs the "empty singularity"
fact with the "torsion bounces" existence theorem for the paper
narrative. -/

/-- **Popławski bridge — singularity empty because torsion bounces
    matter back.**

    For every black hole `bh`, every time `t`, and every positive
    energy density `rho > 0`, the following paired facts hold:

      (A) `singularityEnergy bh t = 0` — the singularity locus
          receives zero energy;
      (B) `∃ S ≠ 0, spinTorsionPressure S + rho·c²/3 < 0` — there
          is a spin density `S` whose torsion pressure triggers the
          Friedmann acceleration bounce (Popławski 2012 mechanism,
          formalised in `substrate_avoids_singularity`).

    **Physical reading.**  The substrate never deposits energy at
    the singular centre *because* dynamics never reaches the singular
    centre.  Torsion pressure is the mechanism preventing collapse
    from completing; emptiness of `singularityEnergy` is the
    bookkeeping consequence.  Together they give a paper-level
    answer to "where does the mass go?": it never arrives.

    **Proof.**  (A) is the headline `rfl`.  (B) is a direct call
    to `substrate_avoids_singularity` from `NegativePressure.lean`. -/
theorem singularity_empty_via_torsion_bounce
    (bh : BlackHole) (t rho : ℝ) (hrho : 0 < rho) :
    singularityEnergy bh t = 0
      ∧ (∃ S : ℝ, S ≠ 0 ∧
          spinTorsionPressure S + rho * c ^ 2 / 3 < 0) := by
  refine ⟨singularity_is_not_energy_sink bh t, ?_⟩
  exact substrate_avoids_singularity rho hrho

/-- **Sign-level bounce bridge.**  At non-zero fermion density the
    torsion pressure is strictly negative.  Paired with the headline
    it gives a two-line Popławski-style narrative: singularity empty,
    torsion pressure negative.  This is the weaker (sign-only)
    companion to `singularity_empty_via_torsion_bounce`, using
    `Torsion.bounce_prevents_singularity`. -/
theorem singularity_empty_via_torsion_sign
    (bh : BlackHole) (t : ℝ) {n : ℝ} (hn : n ≠ 0) :
    singularityEnergy bh t = 0
      ∧ OmegaTheory.Torsion.torsionPressure n < 0 := by
  refine ⟨singularity_is_not_energy_sink bh t, ?_⟩
  exact OmegaTheory.Torsion.bounce_prevents_singularity n hn

/-! ## §4.  Alnasl consistency bridge — this file's headline is the
first conjunct of `black_hole_is_mediator_not_sink`

A definitional sanity check: extracting the first conjunct of
Alnasl's headline yields *exactly* this file's headline (as a
proof term).  Confirms the two theorems are not contradictory but
are telescoped — Alnasl's ships both conjuncts, ours ships only the
first. -/

/-- **Consistency with Alnasl's mediation identity.**  Extracting
    the first conjunct of `black_hole_is_mediator_not_sink` yields
    `singularity_is_not_energy_sink`.  Establishes that this file's
    narrower headline is a *consequence* of Alnasl's broader one,
    with no new mathematical content introduced — only a cleaner
    paper-level labelling. -/
theorem singularity_not_energy_sink_from_mediator
    (bh : BlackHole) (t : ℝ) :
    singularityEnergy bh t = 0 :=
  (black_hole_is_mediator_not_sink bh t).1

/-- **The two headlines agree.**  `singularity_is_not_energy_sink`
    and the first conjunct of `black_hole_is_mediator_not_sink` are
    the same real equality.  This is a `True` statement after
    `rfl`, but it serves as a documentation anchor: *this file does
    not invent new content*. -/
theorem headline_matches_alnasl_first_conjunct
    (bh : BlackHole) (t : ℝ) :
    singularity_is_not_energy_sink bh t
      = (black_hole_is_mediator_not_sink bh t).1 := rfl

/-! ## §5.  Unified summary

One paper-ready 4-conjunct bundle packaging the headline, trivial
corollaries, and the Popławski bridge. -/

/-- **UNIFIED SUMMARY — the singularity locus is not an energy
    sink.**

    For every black hole `bh`, every time `t`, and every positive
    energy density `rho > 0`, four structural facts hold:

    1. **Headline.**  `singularityEnergy bh t = 0` — the singularity
       locus receives zero energy.
    2. **Non-negativity.**  `0 ≤ singularityEnergy bh t`.
    3. **Upper bound.**  `singularityEnergy bh t ≤ 0`.
    4. **Popławski bridge.**  `∃ S ≠ 0, spinTorsionPressure S +
       rho·c²/3 < 0` — there exists a spin density whose torsion
       pressure triggers the Friedmann acceleration bounce,
       explaining *why* the singularity is empty.

    Together these package the paper-level claim: the mathematical
    singularity locus, even if it formed, does not store energy —
    and the mechanism preventing storage is the spin-torsion bounce.
-/
theorem singularity_is_not_energy_sink_summary
    (bh : BlackHole) (t rho : ℝ) (hrho : 0 < rho) :
    (singularityEnergy bh t = 0)
      ∧ (0 ≤ singularityEnergy bh t)
      ∧ (singularityEnergy bh t ≤ 0)
      ∧ (∃ S : ℝ, S ≠ 0 ∧
          spinTorsionPressure S + rho * c ^ 2 / 3 < 0) :=
  ⟨singularity_is_not_energy_sink bh t,
   singularity_energy_nonneg bh t,
   singularity_energy_bounded_above bh t,
   substrate_avoids_singularity rho hrho⟩

end OmegaTheory.Emergence.SingularityNotEnergySink
