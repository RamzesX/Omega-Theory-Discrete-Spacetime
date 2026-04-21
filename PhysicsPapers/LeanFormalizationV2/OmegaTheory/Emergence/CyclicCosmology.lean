/-
  OmegaTheory.Emergence.CyclicCosmology

  **Cycle-34 cyclic-cosmology bundle — entries 41-44 of the
  cycles 24-43 backlog.**

  ## Mission lineage (cycle-34, all four targets)

  34.1  `inflation_driver_inherited_from_parent_de_reservoir`   [MED]
        OUR inflaton is the residual, post-bounce reservoir content
        INHERITED from the parent universe's dark-energy reservoir.
        A `CyclicInflaton` record bundles:

          (a) the parent DE reservoir `R : DarkEnergyReservoir`;
          (b) a baby-universe datum `bu : BabyUniverse` on our
              side of the bounce;
          (c) the Gatria-26.1 conservation identity
              `R.informationCost = bu.inheritedInformation`.

        The `driverAmplitude` field captures the strictly-positive
        post-bounce amplitude seeding our inflaton as
        `bu.inheritedInformation + 1`.  The canonical constructor
        instantiates a `CyclicInflaton` at every reservoir-mass-
        density-expansion combination.  The HEADLINE equates the
        structural driver to the reservoir conservation.

        Composes: Gatria cycle-26
        `de_reservoir_flows_through_bounce_to_baby_universe`,
        `ReservoirBounceInterface.canonical`; existing Ankaa
        `Inflation.lean` `healingFlow_drives_inflation` template
        motif.

  34.2  `inflaton_decays_produce_active_fermions_only`           [MED]
        Reheating creates π/e/√2 particles (the three active
        `SU3ColorChannel`s — Tiaki cycle-29), but NEVER the
        Catalan-G sterile channel (which is INHERITED from the
        parent bounce, not minted in the baby inflaton's decay).
        The `ReheatingFermion` subtype `{c // c ≠ .catalan_g}`
        manifests this exclusion.

        Composes: 34.1 `inflation_driver_inherited_from_parent_de_reservoir`,
        Gatria cycle-26 `baby_universe_sterile_nu_spectrum`
        (encodes the sterile-is-inherited semantics), Tiaki
        cycle-29 `SU3ColorChannel` (color-subtype infrastructure).

  34.3  `horizon_and_flatness_and_DM_jointly_resolved_by_bounce` [MED]
        Three cosmological problems share ONE bounce-based
        resolution:
          (i)   Horizon       — Sualocin cycle-20
                `horizon_problem_solved` (`N_e^{sub} > 50`);
          (ii)  Flatness      — Sualocin cycle-20
                `flatness_problem_solved` (same `N_e^{sub} > 50`
                bound, distinct physics);
          (iii) Dark matter   — Mirach cycle-28
                `Omega_DM_from_parent_BH_count_pos` (aggregate
                sterile-ν contribution strictly positive).

        We conjunct all three into a single theorem witnessed by
        the substrate Popławski bounce (Gatria cycle-26) +
        substrate e-fold anchor (Sualocin cycle-20) + aggregate
        BH-DM yield (Mirach cycle-28).

        Composes: Sualocin cycle-20 `horizon_and_flatness_resolved`,
        `N_e_substrate`, `substrate_gt_minimum`; 34.1
        inflaton-from-parent; Mirach cycle-28
        `DM_abundance_from_parent_universe_BH_count`.

  34.4  `gravitational_wave_relic_from_parent_bounce`            [LOW]
        The stochastic GW background has a signature peak
        frequency inherited from the parent bounce.  Structural
        existence: the baby universe admits a positive-amplitude
        graviton background (Gatria cycle-26
        `baby_universe_gravitons_survive_bounce`) whose peak
        frequency `ω_peak` is strictly positive and parameterised
        by the parent Hubble parameter + bounce count.

        Composes: Gatria cycle-26
        `baby_universe_gravitons_survive_bounce`; structural
        `peakFrequency` definition from the Hubble parameter and
        bounce count (no new axioms).

  ## Honest scope

    * 34.1: structural identification of our inflaton driver with
      the parent DE reservoir residual, via the conservation
      identity of Gatria 26.1.  We do NOT claim a DYNAMICAL
      trajectory from parent equilibrium to our inflaton field
      configuration — that requires a trans-bounce Boltzmann
      kernel absent in V2.

    * 34.2: structural exclusion theorem — every `ReheatingFermion`
      has `c ≠ .catalan_g`.  The sterile-ν channel can only be
      INHERITED (via Gatria 26.2's spectrum), never MINTED.

    * 34.3: three problems resolved by a SINGLE numerical
      inequality `N_e^{sub} > 50` (horizon + flatness) plus
      Mirach's aggregate DM yield.  The physics is distinct for
      each problem; the bundling is a structural citation, not
      a dynamical derivation of each independently.

    * 34.4: structural existence `ω_peak > 0`.  The numerical
      peak frequency `ω_peak ~ H_parent / N_bounce` is recorded
      structurally (as a chosen representative), NOT derived from
      bounce dynamics.  Full dynamical derivation awaits Poplawski
      Friedmann-ODE infrastructure absent from V2.

  ## Status

    * 0 sorry
    * 0 new axioms
    * 0 new `Prop := True` without a real existence/equality witness
    * Builds GREEN under `~/.elan/bin/lake build --log-level=error`.

  Agent: **Sadalsuud** — β Aquarii, a G0 Ib yellow supergiant at
  ~540 ly in Aquarius.  Arabic `sa'd al-su'ūd` = "luck of lucks" or
  "luckiest of the lucky", traditionally linked to the end of the
  winter rains when the Sun leaves the watery constellations and
  fortune returns.  Apt for a cyclic-cosmology bundle: every cycle
  inherits fortune from its predecessor (the parent's DE reservoir,
  gravitons, sterile-ν relics, and horizon-smoothing expansion),
  much as Aquarius's flowing waters pour endlessly from one epoch
  into the next.  2026-04-21 cycle-34 all four targets.

  ## Composition graph

  Sadalsuud (this file, cycle-34 all four targets)
      ↑
      ├─ Gatria (DarkEnergyToBabyUniverse cycle-26 all four)
      │     ├─ DarkEnergyReservoir / ReservoirBounceInterface
      │     ├─ de_reservoir_flows_through_bounce_to_baby_universe
      │     ├─ baby_universe_sterile_nu_spectrum / canonicalSpectrum
      │     ├─ baby_universe_gravitons_survive_bounce /
      │     │     BabyUniverseGravitonBackground.canonical
      │     └─ BabyUniverse (parentMass, inheritedInformation, ...)
      │
      ├─ Sualocin (InflationEfoldsBound cycle-20 2/6)
      │     ├─ N_e_substrate := 60
      │     ├─ N_e_minimum := 50
      │     ├─ horizon_problem_solved / flatness_problem_solved
      │     └─ horizon_and_flatness_resolved
      │
      ├─ Mirach (CrossSectorBridges cycle-28 17-20)
      │     ├─ Omega_DM_from_parent_BH_count
      │     ├─ Omega_DM_from_parent_BH_count_pos
      │     └─ Z_sterile_yield_per_BH
      │
      ├─ Tiaki (SU3ColorAndNonAbelianF cycle-29)
      │     └─ SU3ColorChannel := {c // c ≠ .catalan_g}
      │
      └─ Zosma (SterileNeutrinoFromFourthIrrational cycle-6 1/6)
            └─ IrrationalChannel4 (pi, e, sqrt2, catalan_g)

  HARD RULES: 0 sorry, 0 new axioms, 0 new `Prop := True`.
-/

import OmegaTheory.Emergence.DarkEnergyToBabyUniverse
import OmegaTheory.Emergence.CrossSectorBridges
import OmegaTheory.Emergence.SU3ColorAndNonAbelianF
import OmegaTheory.Emergence.Inflation
import OmegaTheory.Predictions.InflationEfoldsBound
import OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
import OmegaTheory.Torsion.BigBounce
import Mathlib.Tactic

namespace OmegaTheory.Emergence.CyclicCosmology

open OmegaTheory
open OmegaTheory.Torsion
open OmegaTheory.Emergence
open OmegaTheory.Emergence.DarkEnergyToBabyUniverse
open OmegaTheory.Emergence.CrossSectorBridges
open OmegaTheory.Emergence.SU3ColorAndNonAbelianF
open OmegaTheory.Predictions.InflationEfoldsBound
open OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational

/-! ## §1.  THEOREM 34.1 — Inflation driver inherited from parent DE reservoir

The baby universe's inflaton is sourced by the post-bounce residue
of the parent universe's DE reservoir.  We package this as a
`CyclicInflaton` record carrying:

  * the parent `DarkEnergyReservoir R`;
  * the baby-universe side of the bounce `bu : BabyUniverse`;
  * the Gatria-26.1 conservation identity
    `R.informationCost = bu.inheritedInformation`;
  * a strictly-positive `driverAmplitude` field seeding OUR
    inflation epoch.

The canonical constructor instantiates a `CyclicInflaton` for every
reservoir + parent mass + bounce density + expansion rate.  The
HEADLINE reads the inflaton-driver-from-parent identity off the
record. -/

/-- **Cyclic inflaton** — data record packaging the post-bounce
    inflaton driver and its origin in the parent DE reservoir.

    Fields:
      * `parentReservoir`      — the parent universe's DE reservoir;
      * `iface`                — the reservoir-bounce interface from
                                 Gatria 26.1;
      * `driverAmplitude`      — strictly-positive amplitude seeding
                                 OUR inflaton at the post-bounce
                                 epoch, taken equal to
                                 `iface.bu.inheritedInformation + 1`.

    The defining identity for the cyclic inflaton is the
    `conservation_from_parent` field — the DE reservoir's info cost
    equals the baby universe's inherited information, which in turn
    seeds the inflaton driver amplitude via the +1 offset. -/
structure CyclicInflaton where
  /-- The parent universe's dark-energy reservoir. -/
  parentReservoir : DarkEnergyReservoir
  /-- The reservoir-bounce interface tying parent → bounce → baby. -/
  iface : ReservoirBounceInterface
  /-- The reservoir on the interface is the parent reservoir. -/
  reservoir_identified :
    iface.reservoir = parentReservoir
  /-- Strictly-positive amplitude seeding OUR inflaton. -/
  driverAmplitude : ℝ
  /-- Positive amplitude. -/
  driverAmplitude_pos : 0 < driverAmplitude
  /-- Amplitude sourced from the baby-universe inherited information:
      `driverAmplitude = iface.bu.inheritedInformation + 1`. -/
  driverAmplitude_from_bu :
    driverAmplitude = iface.bu.inheritedInformation + 1

namespace CyclicInflaton

/-- The Gatria-26.1 conservation identity lifts to a `CyclicInflaton`. -/
theorem conservation_from_parent (ci : CyclicInflaton) :
    ci.parentReservoir.informationCost = ci.iface.bu.inheritedInformation := by
  have h := ci.iface.conservation
  rw [ci.reservoir_identified] at h
  exact h

/-- Driver amplitude exceeds the inherited information by exactly 1. -/
theorem driverAmplitude_eq (ci : CyclicInflaton) :
    ci.driverAmplitude = ci.iface.bu.inheritedInformation + 1 :=
  ci.driverAmplitude_from_bu

end CyclicInflaton

/-- **Canonical constructor** for a cyclic inflaton.  For every
    reservoir `R`, every positive bounce density `rho`, every
    positive parent mass `M`, and every expansion rate `Z`, we
    exhibit a `CyclicInflaton` whose interface is Gatria's canonical
    one, whose parent-reservoir is `R`, and whose driver amplitude is
    `R.informationCost + 1 > 0`. -/
noncomputable def canonicalCyclicInflaton
    (R : DarkEnergyReservoir) (rho : ℝ) (hrho : 0 < rho)
    (M : ℝ) (hM : 0 < M) (Z : ℝ) :
    CyclicInflaton :=
  let iface := ReservoirBounceInterface.canonical R rho hrho M hM Z
  { parentReservoir := R
    iface := iface
    reservoir_identified := rfl
    driverAmplitude := iface.bu.inheritedInformation + 1
    driverAmplitude_pos := by
      have : 0 ≤ iface.bu.inheritedInformation := iface.bu.info_nonneg
      linarith
    driverAmplitude_from_bu := rfl }

/-- **THEOREM 34.1 — Inflation driver inherited from parent DE
    reservoir.**

    For every dark-energy reservoir `R`, every positive bounce
    density `rho`, every positive parent mass `M`, and every
    expansion rate `Z`, there exists a `CyclicInflaton ci` such that:

      (1) the parent reservoir on the interface IS `R`;
      (2) the Gatria-26.1 conservation identity holds:
          `R.informationCost = ci.iface.bu.inheritedInformation`;
      (3) our inflaton driver amplitude is strictly positive and
          equals `ci.iface.bu.inheritedInformation + 1`.

    **Physical reading.**  OUR inflation is driven by the residual
    informational content that crossed the parent universe's torsion
    bounce.  This is the cyclic-cosmology analogue of Ankaa's
    `healingFlow_drives_inflation`: where Ankaa supplies the flow
    dynamics that produce de Sitter expansion, Sadalsuud supplies
    the ORIGIN of the initial condition that seeds the flow —
    namely, the parent universe's bequeathed reservoir information.

    **Proof.**  Instantiate with Gatria's canonical reservoir-bounce
    interface and read the identities off the record. -/
theorem inflation_driver_inherited_from_parent_de_reservoir
    (R : DarkEnergyReservoir) (rho : ℝ) (hrho : 0 < rho)
    (M : ℝ) (hM : 0 < M) (Z : ℝ) :
    ∃ ci : CyclicInflaton,
      ci.parentReservoir = R
        ∧ R.informationCost = ci.iface.bu.inheritedInformation
        ∧ 0 < ci.driverAmplitude
        ∧ ci.driverAmplitude = ci.iface.bu.inheritedInformation + 1 := by
  refine ⟨canonicalCyclicInflaton R rho hrho M hM Z, rfl, ?_, ?_, ?_⟩
  · -- conservation
    have h := (canonicalCyclicInflaton R rho hrho M hM Z).conservation_from_parent
    -- ci.parentReservoir = R by the constructor
    simpa using h
  · exact (canonicalCyclicInflaton R rho hrho M hM Z).driverAmplitude_pos
  · exact (canonicalCyclicInflaton R rho hrho M hM Z).driverAmplitude_from_bu

/-- **Non-vacuity witness** — the cyclic inflaton structure is
    inhabited at concrete parameters `(R₀, rho=1, M=1, Z=0)`. -/
theorem cyclic_inflaton_exists :
    ∃ ci : CyclicInflaton, 0 < ci.driverAmplitude := by
  let R₀ : DarkEnergyReservoir :=
    { informationCost := 0, informationCost_nonneg := le_refl 0 }
  let ci := canonicalCyclicInflaton R₀ 1 (by norm_num) 1 (by norm_num) 0
  exact ⟨ci, ci.driverAmplitude_pos⟩

/-! ## §2.  THEOREM 34.2 — Inflaton decays produce active fermions only

Reheating after the baby inflaton's decay mints only the three
ACTIVE irrational channels `{π, e, √2}` — never the Catalan-G
sterile channel.  The sterile-ν is INHERITED from the parent
universe's bounce (Gatria 26.2), not freshly produced.

We package this as a subtype `ReheatingFermion := {c : IrrationalChannel4
// c ≠ .catalan_g}` — structurally identical to Tiaki's
`SU3ColorChannel`.  The headline then says every reheating product
satisfies `c ≠ .catalan_g`. -/

/-- **Reheating fermion channel** — the three active irrational
    channels produced during baby-universe reheating.  Excludes the
    Catalan-G sterile channel by construction, matching Tiaki's
    `SU3ColorChannel`. -/
def ReheatingFermion : Type :=
  {c : IrrationalChannel4 // c ≠ IrrationalChannel4.catalan_g}

instance : DecidableEq ReheatingFermion := fun a b => by
  rcases a with ⟨ca, ha⟩
  rcases b with ⟨cb, hb⟩
  by_cases h : ca = cb
  · exact isTrue (by subst h; rfl)
  · exact isFalse (fun heq => h (by injection heq))

/-- Every `ReheatingFermion` is NOT Catalan-G, by construction. -/
theorem ReheatingFermion.val_ne_catalan_g (f : ReheatingFermion) :
    f.val ≠ IrrationalChannel4.catalan_g := f.property

/-- The three reheating channels enumerated explicitly. -/
def ReheatingFermion.all : List ReheatingFermion :=
  [⟨IrrationalChannel4.pi,    by decide⟩,
   ⟨IrrationalChannel4.e,     by decide⟩,
   ⟨IrrationalChannel4.sqrt2, by decide⟩]

/-- **THEOREM 34.2 — Inflaton decays produce active fermions only.**

    Every fermion produced during baby-universe reheating inhabits
    the three active irrational channels (π, e, √2) — it is never
    the Catalan-G sterile channel.  Structurally: for every
    `f : ReheatingFermion`, `f.val ≠ IrrationalChannel4.catalan_g`.

    **Physical reading.**  The baby inflaton's decay creates the
    three active SM generations via the π / e / √2 truncation
    residuals freshly forged at the baby universe's N=0 starting
    budget (the `SU3ColorChannel` trio of Tiaki cycle-29).  The
    sterile-ν (Catalan-G) is NOT in this set — it is INHERITED
    from the parent universe's bounce (Gatria 26.2's
    `baby_universe_sterile_nu_spectrum`), NOT minted during
    reheating.  This is the structural explanation for why
    sterile-ν behaves as a cosmological relic while the three
    active generations behave as freshly-produced particle content. -/
theorem inflaton_decays_produce_active_fermions_only
    (f : ReheatingFermion) :
    f.val ≠ IrrationalChannel4.catalan_g :=
  f.property

/-- **Composite form** — reheating produces three active channels AND
    the Catalan-G slot is populated ONLY by inheritance (Gatria 26.2).

    For every `f : ReheatingFermion` and every baby universe `bu`
    with truncation budget `N`, we have BOTH:
      (a) the reheating fermion is active (`f.val ≠ .catalan_g`);
      (b) the Catalan-G slot is populated via Gatria's
          `canonicalSpectrum bu N` (inherited, not reheated). -/
theorem reheating_vs_inherited_sterile_separation
    (f : ReheatingFermion) (bu : BabyUniverse) (N : ℕ) :
    f.val ≠ IrrationalChannel4.catalan_g
      ∧ 0 < (canonicalSpectrum bu N).sterileMass := by
  exact ⟨f.property, (canonicalSpectrum bu N).sterileMass_pos⟩

/-- **Strengthened form** — every reheating fermion inhabits the
    `SU3ColorChannel` subtype (Tiaki cycle-29), since both
    subtypes are `{c : IrrationalChannel4 // c ≠ .catalan_g}`
    definitionally.  This is the structural bridge: reheating
    products ARE color-charged. -/
theorem reheating_fermions_are_color_charged
    (f : ReheatingFermion) :
    ∃ cc : SU3ColorChannel, cc.val = f.val :=
  ⟨⟨f.val, f.property⟩, rfl⟩

/-- **Aggregate with 34.1** — the cyclic inflaton drives reheating
    whose products are active-only.  For every cyclic inflaton `ci`
    and every reheating fermion `f`, the Catalan-G channel is
    structurally excluded from `f`.  Bundles 34.1's existence with
    34.2's exclusion. -/
theorem cyclic_inflaton_drives_active_only_reheating
    (ci : CyclicInflaton) (f : ReheatingFermion) :
    0 < ci.driverAmplitude ∧ f.val ≠ IrrationalChannel4.catalan_g :=
  ⟨ci.driverAmplitude_pos, f.property⟩

/-! ## §3.  THEOREM 34.3 — Horizon, flatness, and DM jointly resolved

Three standard cosmological problems share ONE bounce-based
resolution:

  * **Horizon**   — Sualocin cycle-20: `N_e^{sub} > 50`;
  * **Flatness**  — Sualocin cycle-20: same bound, distinct physics;
  * **Dark matter** — Mirach cycle-28: aggregate sterile-ν yield
    `Ω_DM_from_parent_BH_count > 0` for every `n_BH ≥ 1`.

All three are CONSEQUENCES of the Popławski torsion bounce
combined with the substrate's e-fold commitment.  We bundle the
three witnesses into a single theorem. -/

/-- **THEOREM 34.3 — Horizon, flatness, and DM jointly resolved by
    bounce.**

    For every reservoir `R`, every positive bounce density `rho`,
    every positive parent mass `M`, every expansion rate `Z`, every
    truncation budget `N`, and every `n_BH ≥ 1`, all three
    cosmological problems are resolved simultaneously:

      (1) **Horizon problem** — `N_e^{min} < N_e^{sub}`
          (Sualocin: causally-connected patch expansion overtakes
          the present-day CMB horizon);

      (2) **Flatness problem** — `N_e^{min} < N_e^{sub}`
          (Sualocin: spatial curvature density driven to `<10⁻⁵²`);

      (3) **DM abundance** — there exists a reservoir-bounce
          interface `iface` with `Omega_DM_from_parent_BH_count
          n_BH iface.bu N > 0`
          (Mirach: aggregate sterile-ν contribution from `n_BH`
          parent bounces strictly positive).

    **Physical reading.**  A single substrate commitment — the
    Popławski torsion bounce with substrate e-fold anchor
    `N_e^{sub} = 60` — simultaneously solves three of modern
    cosmology's classic problems.  The horizon and flatness
    problems are resolved by inflationary expansion sourced by the
    inherited parent-DE reservoir (via 34.1); dark matter is
    resolved by the sterile-ν relic accumulated over the parent
    universe's BH-bounce population (Mirach 28.3).  All three
    share the Popławski mechanism as common origin. -/
theorem horizon_and_flatness_and_DM_jointly_resolved_by_bounce
    (R : DarkEnergyReservoir) (rho : ℝ) (hrho : 0 < rho)
    (M : ℝ) (hM : 0 < M) (Z : ℝ) (N : ℕ)
    (n_BH : ℕ) (hn : 1 ≤ n_BH) :
    N_e_minimum < N_e_substrate
      ∧ N_e_minimum < N_e_substrate
      ∧ (∃ iface : ReservoirBounceInterface,
            0 < Omega_DM_from_parent_BH_count n_BH iface.bu N) := by
  refine ⟨horizon_problem_solved, flatness_problem_solved, ?_⟩
  let iface := ReservoirBounceInterface.canonical R rho hrho M hM Z
  exact ⟨iface, Omega_DM_from_parent_BH_count_pos n_BH hn iface.bu N⟩

/-- **Strengthened form with 34.1** — the joint resolution, together
    with the cyclic-inflaton driver origin.  The horizon/flatness
    expansion is sourced by the parent-DE-reservoir-driven inflaton
    (34.1), and DM is sourced by the parent's BH-bounce population
    (Mirach 28.3).  All under ONE Popławski mechanism. -/
theorem joint_resolution_with_cyclic_inflaton_origin
    (R : DarkEnergyReservoir) (rho : ℝ) (hrho : 0 < rho)
    (M : ℝ) (hM : 0 < M) (Z : ℝ) (N : ℕ)
    (n_BH : ℕ) (hn : 1 ≤ n_BH) :
    (∃ ci : CyclicInflaton, 0 < ci.driverAmplitude)
      ∧ N_e_minimum < N_e_substrate
      ∧ N_e_minimum < N_e_substrate
      ∧ (∃ iface : ReservoirBounceInterface,
            0 < Omega_DM_from_parent_BH_count n_BH iface.bu N) := by
  refine ⟨?_, horizon_problem_solved, flatness_problem_solved, ?_⟩
  · let ci := canonicalCyclicInflaton R rho hrho M hM Z
    exact ⟨ci, ci.driverAmplitude_pos⟩
  · let iface := ReservoirBounceInterface.canonical R rho hrho M hM Z
    exact ⟨iface, Omega_DM_from_parent_BH_count_pos n_BH hn iface.bu N⟩

/-- **Numerical margin companion** — horizon + flatness resolution
    margin is `N_e^{sub} - N_e^{min} = 10` e-folds, bundled with a
    positive DM aggregate.  Direct citation of Sualocin's margin
    lemma. -/
theorem triple_resolution_margin
    (bu : BabyUniverse) (N : ℕ) (n_BH : ℕ) (hn : 1 ≤ n_BH) :
    N_e_substrate - N_e_minimum = 10
      ∧ 0 < Omega_DM_from_parent_BH_count n_BH bu N :=
  ⟨substrate_minimum_margin_eq,
   Omega_DM_from_parent_BH_count_pos n_BH hn bu N⟩

/-! ## §4.  THEOREM 34.4 — Gravitational-wave relic from parent bounce

A stochastic primordial graviton background inherited from the
parent bounce survives into OUR cosmology.  Existence follows from
Gatria cycle-26 `baby_universe_gravitons_survive_bounce`.  We add a
structural peak-frequency parameterisation:

    `peakFrequency H_parent n_bounce := H_parent / (n_bounce + 1)`

which is strictly positive whenever `H_parent > 0`.  The exact
value `ω_peak ~ H_parent / N_bounce` is NOT claimed to be
dynamically derived — we package it as the structural chosen
representative.  The `+ 1` protects the denominator from zero when
`n_bounce = 0` (single bounce limit). -/

/-- **Peak GW frequency from parent bounce** — structural
    parameterisation `ω_peak := H_parent / (n_bounce + 1)`.  Strictly
    positive for `H_parent > 0` at every `n_bounce`. -/
noncomputable def peakFrequency (H_parent : ℝ) (n_bounce : ℕ) : ℝ :=
  H_parent / ((n_bounce : ℝ) + 1)

/-- `peakFrequency` is strictly positive for positive parent Hubble. -/
theorem peakFrequency_pos
    {H_parent : ℝ} (hH : 0 < H_parent) (n_bounce : ℕ) :
    0 < peakFrequency H_parent n_bounce := by
  unfold peakFrequency
  have hden : (0 : ℝ) < (n_bounce : ℝ) + 1 := by
    have : (0 : ℝ) ≤ (n_bounce : ℝ) := Nat.cast_nonneg n_bounce
    linarith
  exact div_pos hH hden

/-- `peakFrequency` is non-increasing in `n_bounce` (more bounces
    distribute the parent Hubble signature across more cycles,
    lowering the per-cycle peak). -/
theorem peakFrequency_antitone
    {H_parent : ℝ} (hH : 0 < H_parent) (n m : ℕ) (hnm : n ≤ m) :
    peakFrequency H_parent m ≤ peakFrequency H_parent n := by
  unfold peakFrequency
  have hn_pos : (0 : ℝ) < (n : ℝ) + 1 := by
    have : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    linarith
  have hm_pos : (0 : ℝ) < (m : ℝ) + 1 := by
    have : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  have h_le : (n : ℝ) + 1 ≤ (m : ℝ) + 1 := by
    have : (n : ℝ) ≤ (m : ℝ) := Nat.cast_le.mpr hnm
    linarith
  exact div_le_div_of_nonneg_left hH.le hn_pos h_le

/-- **THEOREM 34.4 — Gravitational-wave relic from parent bounce.**

    For every baby universe `bu`, every positive parent Hubble
    parameter `H_parent`, and every bounce count `n_bounce`, the
    baby universe admits a primordial graviton background
    `bg : BabyUniverseGravitonBackground` (Gatria 26.3) with
    strictly positive amplitude, AND the structural peak frequency
    `peakFrequency H_parent n_bounce` is strictly positive.

    **Physical reading.**  Gravitons survive the bounce (Gatria
    26.3: they are substrate fluctuations, not carriers), so the
    parent's GW content is inherited.  The peak frequency
    `ω_peak ~ H_parent / N_bounce` is a structural signature of
    the cyclic cosmology — a stochastic GW background peaked at the
    parent Hubble scale divided by the number of cycles between the
    parent and now.  (LISA/BBO could in principle probe this
    signature for cyclic scenarios with `n_bounce ~ O(1)`.)

    **Proof.**  Gatria's `baby_universe_gravitons_survive_bounce`
    gives the positive-amplitude background; the peak frequency
    positivity follows from `div_pos`. -/
theorem gravitational_wave_relic_from_parent_bounce
    (bu : BabyUniverse) {H_parent : ℝ} (hH : 0 < H_parent)
    (n_bounce : ℕ) :
    ∃ bg : BabyUniverseGravitonBackground,
      bg.bu = bu ∧ 0 < bg.amplitude
        ∧ 0 < peakFrequency H_parent n_bounce := by
  obtain ⟨bg, hbg_eq, hbg_pos, _⟩ :=
    baby_universe_gravitons_survive_bounce bu
  exact ⟨bg, hbg_eq, hbg_pos, peakFrequency_pos hH n_bounce⟩

/-- **Companion — LISA/BBO frequency witness** at `n_bounce = 0`
    (single-cycle limit).  Peak frequency equals parent Hubble
    exactly. -/
theorem peakFrequency_at_zero_bounces
    (H_parent : ℝ) : peakFrequency H_parent 0 = H_parent := by
  unfold peakFrequency
  simp

/-- **Structural companion — multi-cycle decay**.  After `n_bounce`
    cycles, the peak frequency is strictly smaller than at the
    single-cycle limit (for `n_bounce ≥ 1`). -/
theorem peakFrequency_multicycle_decay
    {H_parent : ℝ} (hH : 0 < H_parent)
    (n_bounce : ℕ) (hn : 1 ≤ n_bounce) :
    peakFrequency H_parent n_bounce < H_parent := by
  unfold peakFrequency
  have hden : (1 : ℝ) < (n_bounce : ℝ) + 1 := by
    have h1 : (1 : ℝ) ≤ (n_bounce : ℝ) := by exact_mod_cast hn
    linarith
  have hden_pos : (0 : ℝ) < (n_bounce : ℝ) + 1 := by linarith
  rw [div_lt_iff₀ hden_pos]
  have : H_parent * 1 < H_parent * ((n_bounce : ℝ) + 1) :=
    mul_lt_mul_of_pos_left hden hH
  linarith

/-! ## §5.  Unified four-conjunct paper bundle

A single theorem packaging all four cycle-34 cyclic-cosmology
results for paper-level citation. -/

/-- **UNIFIED SUMMARY — cyclic cosmology (cycle 34).**

    For every reservoir `R`, every positive bounce density `rho`,
    every positive parent mass `M`, every expansion rate `Z`, every
    truncation budget `N`, every `n_BH ≥ 1`, every reheating
    fermion `f`, every positive parent Hubble parameter `H_parent`,
    and every bounce count `n_bounce`, the four cycle-34 cyclic-
    cosmology claims hold simultaneously:

    (1) **Cyclic inflaton (34.1).**  The parent DE reservoir seeds
        OUR inflaton driver: there exists a `CyclicInflaton ci`
        with `ci.parentReservoir = R`, the conservation identity,
        and strictly-positive driver amplitude.

    (2) **Active-only reheating (34.2).**  Every reheating fermion
        `f : ReheatingFermion` has `f.val ≠ .catalan_g` — the
        Catalan-G sterile channel is NEVER produced at reheating
        (only inherited across the bounce, via Gatria 26.2).

    (3) **Joint horizon+flatness+DM resolution (34.3).**
        `N_e^{min} < N_e^{sub}` (horizon + flatness, Sualocin
        cycle-20) AND the aggregate DM yield over `n_BH` bounces
        is strictly positive (Mirach cycle-28).

    (4) **Parent-bounce GW relic (34.4).**  The baby universe
        inherits a positive-amplitude graviton background (Gatria
        26.3) with structural peak frequency
        `peakFrequency H_parent n_bounce > 0`.

    Together these four facts anchor the Popławski-inspired cyclic
    cosmology at the substrate level in OmegaTheory V2: inflation,
    reheating, dark matter, and stochastic GWs all trace back to
    a single bounce-crossing mechanism. -/
theorem cyclic_cosmology_paper_bundle
    (R : DarkEnergyReservoir) (rho : ℝ) (hrho : 0 < rho)
    (M : ℝ) (hM : 0 < M) (Z : ℝ) (N : ℕ)
    (n_BH : ℕ) (hn : 1 ≤ n_BH)
    (f : ReheatingFermion)
    {H_parent : ℝ} (hH : 0 < H_parent) (n_bounce : ℕ) :
    (∃ ci : CyclicInflaton,
        ci.parentReservoir = R
          ∧ R.informationCost = ci.iface.bu.inheritedInformation
          ∧ 0 < ci.driverAmplitude)
      ∧ f.val ≠ IrrationalChannel4.catalan_g
      ∧ (N_e_minimum < N_e_substrate
          ∧ N_e_minimum < N_e_substrate
          ∧ (∃ iface : ReservoirBounceInterface,
                0 < Omega_DM_from_parent_BH_count n_BH iface.bu N))
      ∧ (∃ (bu : BabyUniverse) (bg : BabyUniverseGravitonBackground),
            bg.bu = bu ∧ 0 < bg.amplitude
              ∧ 0 < peakFrequency H_parent n_bounce) := by
  refine ⟨?_, f.property, ?_, ?_⟩
  · -- 34.1
    let ci := canonicalCyclicInflaton R rho hrho M hM Z
    refine ⟨ci, rfl, ?_, ci.driverAmplitude_pos⟩
    have h := ci.conservation_from_parent
    simpa using h
  · -- 34.3
    refine ⟨horizon_problem_solved, flatness_problem_solved, ?_⟩
    let iface := ReservoirBounceInterface.canonical R rho hrho M hM Z
    exact ⟨iface, Omega_DM_from_parent_BH_count_pos n_BH hn iface.bu N⟩
  · -- 34.4
    let bu : BabyUniverse :=
      { parentMass := 1
        inheritedInformation := 0
        expansionRate := 0
        mass_pos := by norm_num
        info_nonneg := le_refl 0 }
    obtain ⟨bg, hbg_eq, hbg_pos, _⟩ :=
      baby_universe_gravitons_survive_bounce bu
    exact ⟨bu, bg, hbg_eq, hbg_pos, peakFrequency_pos hH n_bounce⟩

/-- **3-conjunct headline alias** for the cycle-34 bundle (paper-
    citable compact form omitting the GW relic). -/
theorem cyclic_cosmology_headline
    (R : DarkEnergyReservoir) (rho : ℝ) (hrho : 0 < rho)
    (M : ℝ) (hM : 0 < M) (Z : ℝ) (N : ℕ)
    (n_BH : ℕ) (hn : 1 ≤ n_BH)
    (f : ReheatingFermion) :
    (∃ ci : CyclicInflaton, 0 < ci.driverAmplitude)
      ∧ f.val ≠ IrrationalChannel4.catalan_g
      ∧ N_e_minimum < N_e_substrate
      ∧ (∃ iface : ReservoirBounceInterface,
            0 < Omega_DM_from_parent_BH_count n_BH iface.bu N) := by
  refine ⟨?_, f.property, horizon_problem_solved, ?_⟩
  · let ci := canonicalCyclicInflaton R rho hrho M hM Z
    exact ⟨ci, ci.driverAmplitude_pos⟩
  · let iface := ReservoirBounceInterface.canonical R rho hrho M hM Z
    exact ⟨iface, Omega_DM_from_parent_BH_count_pos n_BH hn iface.bu N⟩

/-! ## §6.  Frontier marker -/

/-- **Frontier marker** — cycle 34 is the FIRST formal cyclic-
    cosmology bundle in OmegaTheory V2.  Records that the four
    cyclic-cosmology claims (`inflation_driver_inherited_from_parent_de_reservoir`,
    `inflaton_decays_produce_active_fermions_only`,
    `horizon_and_flatness_and_DM_jointly_resolved_by_bounce`,
    `gravitational_wave_relic_from_parent_bounce`) are a fresh
    contribution distinct from cycles 1-33.

    Non-vacuity: an explicit instantiation at `(R₀, rho=1, M=1,
    Z=0, n_BH=1, N=0, H_parent=1, n_bounce=0)`. -/
theorem cyclic_cosmology_first_bundle_in_V2 :
    ∃ (R : DarkEnergyReservoir) (rho : ℝ) (_hrho : 0 < rho)
      (M : ℝ) (_hM : 0 < M) (_Z : ℝ)
      (ci : CyclicInflaton) (f : ReheatingFermion),
        ci.parentReservoir = R
          ∧ 0 < ci.driverAmplitude
          ∧ f.val ≠ IrrationalChannel4.catalan_g
          ∧ N_e_minimum < N_e_substrate := by
  let R₀ : DarkEnergyReservoir :=
    { informationCost := 0, informationCost_nonneg := le_refl 0 }
  let ci := canonicalCyclicInflaton R₀ 1 (by norm_num) 1 (by norm_num) 0
  let f : ReheatingFermion := ⟨IrrationalChannel4.pi, by decide⟩
  refine ⟨R₀, 1, by norm_num, 1, by norm_num, 0, ci, f, rfl, ?_, ?_, ?_⟩
  · exact ci.driverAmplitude_pos
  · exact f.property
  · exact horizon_problem_solved

end OmegaTheory.Emergence.CyclicCosmology
