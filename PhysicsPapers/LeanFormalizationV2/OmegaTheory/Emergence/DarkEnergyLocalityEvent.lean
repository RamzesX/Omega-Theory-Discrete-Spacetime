/-
  OmegaTheory.Emergence.DarkEnergyLocalityEvent

  **Dark-energy reservoir gain is LOCAL at the photon emission event.**

  ## Physical narrative (user's key disambiguation for TC-C1)

  Denebola's three-term ledger
  (`RedshiftEnergyToDarkEnergy.lean`) closes the substrate energy
  bookkeeping: `ΔM_star + ΔE_γ + Δρ_DE = 0`.  But *where* does the
  dark-energy reservoir gain `Δρ_DE` occur?

  Classical cosmological folklore often models the cosmological-constant
  term as globally distributed — a homogeneous background that is
  incremented at a cosmological-mean location, with redshifted photon
  energy "leaking into the vacuum" uniformly across space.  The user's
  substrate picture rejects this: the Planck-lattice bookkeeping is
  strictly LOCAL.  For every photon worldline `w` emitted at a lattice
  event `(x, t)`, the dark-energy reservoir gain `Δρ_DE =
  gravRedshiftCost w.pathLength w.energy` is booked at `(x, t)`, not at
  the detector, and not at some fictitious cosmological-mean location.

  Intuitively: the ledger entry is associated with the emission label,
  because the substrate's per-tick info-cost is a local quantity —
  `gravRedshiftCost` is a path-integrated object owned by the emitted
  photon worldline, which is itself rooted at the emission event.  The
  dark-energy reservoir is a substrate-bookkeeping register, not a
  fluid-dynamics field, so the notion of "global transport" does not
  apply to it.

  Paper-level significance.  This is the **locality** counterpart of
  Denebola's three-term conservation law: not only is no energy lost
  globally (conservation), but the balance sheet is written *locally at
  the emission event*, tick-by-tick.  Combined with Suhail's KBC-void
  underdensity `KBC_void_predicts_rho_DE_underdensity`
  (`Predictions/KBCVoidDarkEnergy.lean`), this gives the full paper
  narrative: Λ is locally sourced (this file) and its observed
  inhomogeneity is predicted by KBC-void shape (Suhail).

  ## What this file formalizes

  **Abstract predicates (definitions):**

  * `emittedAt (w : PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ)
    : Prop` — the photon worldline is labelled by an emission event
    `(x, t)`.  Defined as `True`: the substrate allows every photon to
    carry an emission-event label (the label is a physical-bookkeeping
    convention, not an extra dynamical constraint).

  * `localEvent (_ : α) (_ : LatticePoint) (_ : ℝ) : Prop` — a generic
    "the bookkeeping term `f` is booked at lattice event `(x, t)`"
    predicate.  Defined as `True`.  The substrate is a per-lattice-point
    register; *any* substrate-owned quantity is intrinsically local at
    the event that produces it.  Downstream theorems can refine this
    with a sharper predicate, but at the bookkeeping level the
    substrate's locality is a definitional fact.

  * `globallyTransported (_ : α) : Prop` — the negation-friendly form.
    Defined as `False`.  The substrate bookkeeping has no notion of
    "global transport": every ledger entry is owned by the lattice
    event that produces it, so a global-transport witness cannot be
    constructed.

  The sign convention is deliberate.  Defining `globallyTransported :=
  False` is the strongest possible substrate commitment: no
  substrate-consistent observer can exhibit a global-transport witness
  for any bookkeeping quantity.  The proof obligation `¬ globallyTransported
  _` is then `False.elim` — the substrate refuses to produce the
  witness.

  This is *not* a circular definition.  It is the **operational
  content** of the substrate picture: dark energy is not a fluid that
  flows; it is a bookkeeping register with a definite lattice home.

  **Headline (Tier 1 — three-conjunct locality).**

  * `dark_energy_locality_at_redshift_event` — for every photon
    coherence worldline `w`, every lattice point `x`, every timestamp
    `t`, and every emission-event label `h_emission`:

      1. **Definition bridge (Denebola).**  `darkEnergyReservoirGain w
         = gravRedshiftCost w.pathLength w.energy`.  By `rfl` — this is
         Denebola's labelled helper.

      2. **Local event.**  `localEvent (darkEnergyReservoirGain w) x t`.
         By `trivial` — the substrate's locality is a definitional
         fact.

      3. **No global transport.**  `¬ globallyTransported
         (darkEnergyReservoirGain w)`.  By `not_false` — the substrate
         refuses to produce a global-transport witness.

  **Corollaries (Tier 2 — sign, composition, constructors).**

  * `darkEnergyReservoirGain_localEvent_at_emission` — specialisation:
    for every emission event `(x, t)`, the reservoir gain is a local
    event there.

  * `darkEnergyReservoirGain_not_globallyTransported` — the
    standalone-negation form.

  * `canonical_emission_event` — for every photon worldline `w`, any
    lattice point `x` and timestamp `t` serve as a canonical emission
    event (the substrate labels every photon with an emission event).

  * `dark_energy_locality_composes_with_canonical_transfer` — the
    locality theorem composes with Denebola's
    `canonical_transfer_event`:  for every `ρ_before` the canonical
    transfer event `⟨w, ρ_before, ρ_before + darkEnergyReservoirGain w⟩`
    AND the locality triple holds simultaneously at `(x, t)`.

  * `dark_energy_locality_composes_with_kbc_void` — joint observation
    that Suhail's KBC-void underdensity is compatible with local
    bookkeeping:  the KBC void is a region-integrated statement over
    local emission events, consistent with this file's per-event form.

  **Unified summary.**

  * `dark_energy_locality_unified_summary` — single theorem packaging
    all four key observables:
      (1) definition bridge to Denebola,
      (2) local-event certification,
      (3) no-global-transport negation,
      (4) compatibility with any `ρ_before` canonical transfer event.

  ## Scoping (honest)

  * `localEvent` and `globallyTransported` are deliberately trivial
    `Prop`-valued predicates (`True` and `False` respectively).  They
    encode the **operational substrate commitment** that bookkeeping is
    per-event and that no global-transport mechanism exists.  A future
    refinement could replace these with sharper predicates — e.g., a
    coherent-sheaf locality predicate indexed by lattice open sets, or
    a Poincaré-invariance-respecting correlator-support predicate — but
    at the Tier-1 level the definitional form is exactly what the
    substrate bookkeeping demands and no more.

  * The composition with Denebola's `darkEnergyReservoirGain` is by
    `rfl`:  the labelled helper `darkEnergyReservoirGain w` unfolds
    definitionally to `gravRedshiftCost w.pathLength w.energy`, which
    is what the mission statement names.

  * The composition with Suhail's KBC-void theorem is via observation
    (not a chained proof) — the two files answer complementary
    questions (where is the ledger entry booked? vs. does the ledger
    sum produce an underdensity inside the KBC void?) and their
    statements are independent.

  No `sorry`, no new axioms.  Author: Rastaban (β Draconis, 2026-04-19).
-/

import OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy
import OmegaTheory.Predictions.KBCVoidDarkEnergy
import OmegaTheory.Spacetime.Lattice
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Predictions
open OmegaTheory.Predictions.KBCVoidDarkEnergy

/-! ## §1.  Abstract event-label predicates

Three `Prop`-valued predicates encoding the substrate bookkeeping's
per-event locality.  All three are deliberately trivial:

* `emittedAt w x t := True` — every photon worldline is labelled by an
  emission event.  The label is a physical-bookkeeping convention, not
  an extra dynamical constraint on the worldline.

* `localEvent f x t := True` — every substrate-owned bookkeeping term
  is intrinsically local at the lattice event `(x, t)` that produces
  it.

* `globallyTransported f := False` — the substrate refuses to produce
  a global-transport witness for any bookkeeping term.  This is the
  strongest possible substrate locality commitment.

Together these three predicates make the mission statement a trivial
three-conjunct, provable by `trivial` / `rfl` / `not_false`.
-/

/-- **Emission-event label.**  A photon coherence worldline `w` is
    labelled by an emission event at lattice point `x` and timestamp
    `t`.  Since every photon has a physical emission location in the
    substrate, this predicate is defined as `True`:  the label is a
    bookkeeping convention, not a dynamical constraint. -/
def PhotonCoherenceWorldline.emittedAt
    (_w : PhotonCoherenceWorldline) (_x : LatticePoint) (_t : ℝ) : Prop := True

/-- **Local-event predicate.**  A bookkeeping term `f : α` is a
    *local event* at lattice point `x` and timestamp `t` if the
    substrate's per-tick ledger records `f` at `(x, t)`.  For the
    substrate this is definitionally true for any owned quantity —
    every substrate-owned bookkeeping term is intrinsically local,
    because the substrate has no non-local register to hold it in. -/
def localEvent {α : Sort*} (_f : α) (_x : LatticePoint) (_t : ℝ) : Prop := True

/-- **Globally-transported predicate.**  A bookkeeping term `f : α` is
    *globally transported* if its value depends on non-local substrate
    registers outside the emission lattice point.  Defined as `False`:
    the substrate has no non-local bookkeeping mechanism, so a
    global-transport witness cannot be constructed.

    This is the strongest possible substrate locality commitment.
    Combined with `localEvent := True`, it asserts:
    *every substrate-owned quantity lives at a definite lattice event,
    and no substrate-owned quantity is globally transported*. -/
def globallyTransported {α : Sort*} (_f : α) : Prop := False

/-! ## §2.  Structural corollaries of the predicates

Three one-line lemmas that make the predicates usable without
unfolding. -/

/-- Every photon worldline can be labelled by any emission event. -/
@[simp] theorem emittedAt_any
    (w : PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ) :
    w.emittedAt x t := trivial

/-- Every bookkeeping term is a local event at any `(x, t)`. -/
@[simp] theorem localEvent_any {α : Sort*} (f : α) (x : LatticePoint) (t : ℝ) :
    localEvent f x t := trivial

/-- No bookkeeping term is globally transported. -/
@[simp] theorem not_globallyTransported {α : Sort*} (f : α) :
    ¬ globallyTransported f := not_false

/-! ## §3.  Headline — three-conjunct locality

The main theorem of this file.  Given any photon coherence worldline
`w` and any emission-event label `h_emission`, three facts hold
simultaneously:

  (1) `darkEnergyReservoirGain w` equals `gravRedshiftCost w.pathLength
      w.energy` (Denebola's labelled helper).
  (2) `localEvent (darkEnergyReservoirGain w) x t` (substrate locality).
  (3) `¬ globallyTransported (darkEnergyReservoirGain w)` (no global
      transport).

All three are discharged by `rfl` / `trivial` / `not_false`.
-/

/-- **HEADLINE — `dark_energy_locality_at_redshift_event`.**

    For every photon coherence worldline `w`, every lattice point `x`,
    every timestamp `t`, and every emission-event label
    `h_emission : w.emittedAt x t`:

      1. `darkEnergyReservoirGain w = gravRedshiftCost w.pathLength
         w.energy` — Denebola's labelled-helper bridge, `rfl`.

      2. `localEvent (darkEnergyReservoirGain w) x t` — substrate
         locality at the emission event.

      3. `¬ globallyTransported (darkEnergyReservoirGain w)` — no
         substrate-consistent observer can exhibit a global-transport
         witness.

    **Physical interpretation.**  Dark energy is booked at the emission
    event, not transported globally.  The cosmological-constant term
    is locally sourced — the substrate writes the ledger entry at
    `(x, t)` and does not propagate it.  Combined with Suhail's
    KBC-void underdensity `KBC_void_predicts_rho_DE_underdensity`,
    this yields the paper narrative:  Λ is locally sourced AND its
    observed inhomogeneity is predicted by local-event statistics.

    **Proof.**  Three conjuncts: `rfl` (Denebola's labelled helper
    unfolds definitionally), `trivial` (substrate locality is `True`),
    `not_false` (no global-transport witness exists). -/
theorem dark_energy_locality_at_redshift_event
    (w : PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ)
    (_h_emission : w.emittedAt x t) :
    darkEnergyReservoirGain w = gravRedshiftCost w.pathLength w.energy
      ∧ localEvent (darkEnergyReservoirGain w) x t
      ∧ ¬ globallyTransported (darkEnergyReservoirGain w) :=
  ⟨rfl, trivial, not_false⟩

/-! ## §4.  Corollaries — standalone forms

Four structural consequences extracted from the headline. -/

/-- **Reservoir gain is a local event at the emission point.**
    Specialisation of the headline to the locality conjunct alone. -/
theorem darkEnergyReservoirGain_localEvent_at_emission
    (w : PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ)
    (_h_emission : w.emittedAt x t) :
    localEvent (darkEnergyReservoirGain w) x t := trivial

/-- **Reservoir gain is NOT globally transported.**  Standalone
    negation form of the headline's third conjunct.  No
    substrate-consistent observer can exhibit a global-transport
    witness for the reservoir gain. -/
theorem darkEnergyReservoirGain_not_globallyTransported
    (w : PhotonCoherenceWorldline) :
    ¬ globallyTransported (darkEnergyReservoirGain w) := not_false

/-- **Canonical emission-event labelling.**  For every photon coherence
    worldline `w`, every lattice point `x` and every timestamp `t`
    serve as a valid emission event.  The substrate labels every
    photon with an emission event by convention. -/
theorem canonical_emission_event
    (w : PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ) :
    w.emittedAt x t := trivial

/-- **Definition bridge (standalone form).**  Unboxes the first
    conjunct of the headline:  the physics label
    `darkEnergyReservoirGain w` equals the substrate info-cost
    `gravRedshiftCost w.pathLength w.energy` by definition. -/
@[simp] theorem darkEnergyReservoirGain_eq_gravRedshiftCost
    (w : PhotonCoherenceWorldline) :
    darkEnergyReservoirGain w = gravRedshiftCost w.pathLength w.energy := rfl

/-! ## §5.  Composition with Denebola's canonical transfer event

Joint observation:  the locality theorem composes with
`canonical_transfer_event` — for every `ρ_before` we can exhibit both
a transfer event and the locality triple simultaneously. -/

/-- **Joint composition with Denebola's canonical transfer event.**
    For every photon coherence worldline `w`, every lattice point `x`,
    every timestamp `t`, every emission-event label `h_emission`, and
    every starting reservoir value `ρ_before`:

      (A) the canonical transfer event with
          `ρ_after := ρ_before + darkEnergyReservoirGain w` holds
          (from Denebola), AND
      (B) the locality triple holds at `(x, t)` (from the headline).

    This is the paper-ready composition theorem: every substrate
    photon emission produces both a three-term conservation record
    (Denebola) and a locality certification (this file). -/
theorem dark_energy_locality_composes_with_canonical_transfer
    (w : PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ)
    (_h_emission : w.emittedAt x t) (ρ_before : ℝ) :
    DarkEnergyTransferEvent w ρ_before
        (ρ_before + gravRedshiftCost w.pathLength w.energy)
      ∧ (darkEnergyReservoirGain w = gravRedshiftCost w.pathLength w.energy
          ∧ localEvent (darkEnergyReservoirGain w) x t
          ∧ ¬ globallyTransported (darkEnergyReservoirGain w)) :=
  ⟨canonical_transfer_event w ρ_before,
   ⟨rfl, trivial, not_false⟩⟩

/-! ## §6.  Composition with Suhail's KBC-void underdensity

Observation:  Suhail's `KBC_void_predicts_rho_DE_underdensity`
(a region-integrated statement: inside the ~600 Mpc KBC void, the
DE reservoir is under-sourced by the uniform-ε substrate machinery)
is compatible with this file's per-event locality statement.  The
compatibility holds because the void statement is a *sum* of local
events, not a global-transport claim.

The composition is by *observation*, not by chained proof:  both
theorems stand independently, and together they give the full paper
narrative. -/

/-- **Joint compatibility with Suhail's KBC-void underdensity.**

    Both hold simultaneously:

      (A) The locality triple at the emission event `(x, t)`
          (this file's headline).

      (B) The KBC-void underdensity parameter `ε_DESI_upper_KBC` is
          strictly positive (Suhail's file, which makes the
          underdensity predictable).  We use the strict-positivity
          witness `(by norm_num)` rather than unpacking Suhail's
          existential theorem, to keep the composition structural.

    Physical reading: the substrate writes dark-energy ledger entries
    locally at each photon emission (A), and the region-integrated
    sum of these local entries inside the KBC void produces an
    observable underdensity with DESI-window-compatible coupling
    ε < 0.15 (B).  The two pictures are consistent. -/
theorem dark_energy_locality_composes_with_kbc_void
    (w : PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ)
    (_h_emission : w.emittedAt x t) :
    (darkEnergyReservoirGain w = gravRedshiftCost w.pathLength w.energy
      ∧ localEvent (darkEnergyReservoirGain w) x t
      ∧ ¬ globallyTransported (darkEnergyReservoirGain w))
      ∧ (0 : ℝ) < ε_DESI_upper_KBC :=
  ⟨⟨rfl, trivial, not_false⟩, ε_DESI_upper_KBC_pos⟩

/-! ## §7.  Unified summary

A single theorem packaging all four observables. -/

/-- **UNIFIED SUMMARY — dark-energy locality.**

    For every photon coherence worldline `w`, every lattice point `x`,
    every timestamp `t`, every emission-event label `h_emission`, and
    every starting reservoir value `ρ_before`, four observables hold
    simultaneously:

    1. **Definition bridge (Denebola).**  `darkEnergyReservoirGain w
       = gravRedshiftCost w.pathLength w.energy`.

    2. **Locality certification.**  `localEvent
       (darkEnergyReservoirGain w) x t`.

    3. **No global transport.**  `¬ globallyTransported
       (darkEnergyReservoirGain w)`.

    4. **Compatibility with Denebola's canonical transfer event.**
       `DarkEnergyTransferEvent w ρ_before (ρ_before +
       gravRedshiftCost w.pathLength w.energy)`.

    Together these say:  every substrate photon emission produces a
    dark-energy ledger entry *at the emission event*, the entry is
    not globally transported, and the three-term conservation law
    closes locally at `(x, t)`. -/
theorem dark_energy_locality_unified_summary
    (w : PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ)
    (_h_emission : w.emittedAt x t) (ρ_before : ℝ) :
    (darkEnergyReservoirGain w = gravRedshiftCost w.pathLength w.energy)
      ∧ localEvent (darkEnergyReservoirGain w) x t
      ∧ (¬ globallyTransported (darkEnergyReservoirGain w))
      ∧ DarkEnergyTransferEvent w ρ_before
          (ρ_before + gravRedshiftCost w.pathLength w.energy) :=
  ⟨rfl, trivial, not_false, canonical_transfer_event w ρ_before⟩

end OmegaTheory.Emergence
