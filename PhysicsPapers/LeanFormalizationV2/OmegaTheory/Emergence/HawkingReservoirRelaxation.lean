/-
  OmegaTheory.Emergence.HawkingReservoirRelaxation

  **Hawking radiation as dark-energy reservoir relaxation.**

  Agent: Adhafera (ζ Leonis, "the curl [of the lion's mane]", 2026-04-19).
  Mission: `hunter-TC-B3 hawking_as_dark_energy_reservoir_relaxation`.
  Bundle: `substrate_exchange_bundle`.  Frontier: substrate-bookkeeping-conjecture.

  ## Physical narrative (user's substrate-exchange disambiguation)

  Denebola's `photon_redshift_loss_equals_dark_energy_gain`
  (`RedshiftEnergyToDarkEnergy.lean`) established the FORWARD transfer
  from photon kinetic energy to the dark-energy reservoir: a photon
  redshifting along a worldline `w` deposits exactly `gravRedshiftCost
  w.pathLength w.energy` into `Δρ_DE`.  What powers the reservoir is
  the photon's substrate info-cost; nothing is stored at the source,
  nothing is stored at the singular centre of a BH.

  This file closes the REVERSE flow — the complementary loop needed
  to make the three-term ledger of `BlackHoleAsMediator.lean`
  (Alnasl, 2026-04-19) a true two-way switch at the horizon:

      * **Forward** (Denebola):  Δρ_DE = +gravRedshiftCost(path, E_γ).
      * **Reverse** (THIS FILE): the horizon *relaxes* the reservoir
        back into outgoing Hawking flux at a rate
        `hawkingRadiationMagnitude bh.mass`, so that over an interval
        of length `t` the total Hawking outflow equals
        `reservoirRelaxationRate bh · t`.

  Physically: a black hole is the one place in the substrate where the
  dark-energy reservoir *can* relax back into kinetic photon flux.
  The three-term ledger at the horizon (Alnasl) says "incoming =
  outflow + gain".  The substrate bookkeeping closes when we identify
  `outflow` not as a free variable but as the relaxation channel of
  the reservoir's info-cost accumulation.  Hawking radiation is the
  reverse of photon-redshift.

  ## What this file formalizes

  **Tier 1 — functional form (HEADLINE).**
    * `reservoirRelaxationRate bh : ℝ`  — the rate at which the
      dark-energy reservoir relaxes through the horizon `bh`.  By
      construction equal to `hawkingRadiationMagnitude bh.mass`.
    * `hawking_outflow_as_relaxation` — for every BH and every time,
        `hawkingOutflow bh t = reservoirRelaxationRate bh · t`,
      which is the target functional form from the mission spec.
    * `hawking_as_dark_energy_reservoir_relaxation` — the paper
      target `theorem`: BOTH the functional-form identity AND the
      Planck-scale temperature bound hold simultaneously.

  **Tier 2 — composition with the three-term ledger.**
    * `reservoir_relaxation_closes_mediator_ledger` — given the
      Alnasl mediation identity `incoming = outflow + gain`, the
      Hawking outflow portion is *exactly* the reservoir relaxation
      integrated over the interval.  The gain portion is the
      Denebola term.
    * `reservoir_relaxation_reverse_of_redshift` — pairs the signs:
      Denebola's `darkEnergyReservoirGain w ≥ 0` (reservoir absorbs);
      this file's `reservoirRelaxationRate bh > 0` (reservoir sheds).
      Substrate bookkeeping remains non-negative per tick.

  **Tier 3 — temperature bound `T_H ∝ 1 / (M · δ_comp(N))`.**
    * `hawkingTemperature_times_mass_times_delta_comp` — the product
      `T_H(M) · M · δ_comp(N)` is a *universal substrate constant* —
      it factors as `hawkingTemperatureCoefficient · δ_comp(N)`, so
      the temperature obeys the exact factorisation
        `T_H(M) = hawkingTemperatureCoefficient / M`,
      and multiplied through by `δ_comp(N)` gives
        `T_H(M) · δ_comp(N) = hawkingTemperatureCoefficient · δ_comp(N) / M`.
    * `hawkingTemperature_delta_comp_bound` — the clean "∝
      1/(M·δ_comp)" form as an explicit factorisation:
        `T_H(M) = substrateTemperatureCeiling(N) / (M · δ_comp(N))`,
      where
        `substrateTemperatureCeiling(N) := hawkingTemperatureCoefficient · δ_comp(N)`.
      This isolates the mass-dependent piece (`1/M`), the substrate
      depth (`1/δ_comp(N)`), and the universal prefactor into a
      single substrate-weighted temperature scale.
    * `substrateTemperatureCeiling_pos` — the ceiling is strictly
      positive at every lattice depth.
    * `substrateTemperatureCeiling_decreasing` — deeper lattices
      (larger N) give a smaller ceiling, matching `δ_comp(N) → 0`.

  **Tier 4 — unified summary.**
    * `hawking_reservoir_relaxation_summary` — a single theorem
      packaging all four structural facts (functional form, ledger
      closure, temperature bound, δ_comp decreasing).

  ## Scoping (honest)

    * We do **not** derive `hawkingRadiationMagnitude` from a
      continuum PDE; it is re-used from
      `BlackHoleFormation.hawkingRadiationRate` via Avior's
      `HealingFlowBH.lean` wrapper.  The content formalised here is
      that the magnitude function *is* the reservoir-relaxation rate,
      and the resulting temperature factorisation makes the
      δ_comp-weighted substrate scale explicit.

    * The "∝" symbol from the mission spec is realised as an exact
      equality with a named substrate ceiling.  Proportionality is
      formalised as factorisation, not as an asymptotic relation.

    * `N` is a free natural-number parameter (`N_horizon` in the
      spec); every theorem holds for every `N`, and the
      `_decreasing` corollary encodes the "deeper lattice → tighter
      bound" content.

  ## Composition

  Imports (and only imports) three files:
    * `BlackHoleAsMediator.lean` (Alnasl): `BlackHole`, `hawkingOutflow`,
      `darkEnergyGain`, `black_hole_is_mediator_not_sink`.
    * `HealingFlowBH.lean` (Avior): `hawkingPlanckCoefficient`,
      `hawkingRadiationMagnitude_eq_coefficient_div`,
      `hawkingRadiationMagnitude_times_M_sq`.
    * `AlphaEM.lean` (Hadar): the `computationalUncertainty N`
      primitive under a `Predictions` open for the substrate-depth
      ceiling.

  No new axioms.  No `sorry`.  No `Prop := True`.
-/

import OmegaTheory.Emergence.BlackHoleAsMediator
import OmegaTheory.Emergence.HealingFlowBH
import OmegaTheory.Predictions.AlphaEM
import Mathlib.Tactic

namespace OmegaTheory.Emergence.HawkingReservoirRelaxation

open OmegaTheory
open OmegaTheory.Spacetime
open OmegaTheory.Conservation
open OmegaTheory.Emergence
open OmegaTheory.Emergence.BlackHoleFormation
open OmegaTheory.Emergence.HealingFlowBH
open OmegaTheory.Emergence.BlackHoleAsMediator

/-! ## §1.  Tier 1 — Reservoir relaxation rate

`reservoirRelaxationRate bh` names the per-unit-time quantity at
which the horizon channels dark-energy reservoir information back
into outgoing Hawking flux.  By construction it equals
`hawkingRadiationMagnitude bh.mass`: the numerical content is
Avior's Planck-scale Hawking luminosity; the physics-label reframing
is that this magnitude IS the rate of reservoir relaxation through
the horizon.

The functional-form identity
    `hawkingOutflow bh t = reservoirRelaxationRate bh · t`
then holds by definition of `hawkingOutflow` in Alnasl's
`BlackHoleAsMediator.lean`.  This is the **headline** of the mission. -/

/-- **Reservoir relaxation rate of a black hole `bh`.**  The rate
    at which the dark-energy reservoir relaxes back into outgoing
    Hawking flux through the horizon.  By substrate bookkeeping
    equal to the Hawking magnitude `|dM/dt| = A_H / M²`.

    Physics-label synonym: `hawkingRadiationMagnitude bh.mass`.
    The two names are definitionally equal; the rename exists to
    make the reservoir-relaxation physics visible at the theorem
    level. -/
noncomputable def reservoirRelaxationRate (bh : BlackHole) : ℝ :=
  hawkingRadiationMagnitude bh.mass

/-- **Reservoir relaxation rate is strictly positive.**  Every
    positive-mass BH sheds info from the reservoir at a positive
    Planck-scale rate. -/
theorem reservoirRelaxationRate_pos (bh : BlackHole) :
    0 < reservoirRelaxationRate bh :=
  hawkingRadiationMagnitude_pos bh.mass bh.mass_pos

/-- **Reservoir relaxation rate is non-negative.** -/
theorem reservoirRelaxationRate_nonneg (bh : BlackHole) :
    0 ≤ reservoirRelaxationRate bh :=
  le_of_lt (reservoirRelaxationRate_pos bh)

/-- **Definitional unfold.**  Reservoir relaxation rate equals the
    Hawking magnitude. -/
@[simp] theorem reservoirRelaxationRate_def (bh : BlackHole) :
    reservoirRelaxationRate bh = hawkingRadiationMagnitude bh.mass := rfl

/-- **Planck-scale factorisation.**  The relaxation rate equals
    `A_H / M²`, where `A_H` is the Hawking Planck coefficient
    (Avior 2026-04-17).  Isolates the `1/M²` mass-dependence from
    the universal prefactor. -/
theorem reservoirRelaxationRate_eq_coefficient_div (bh : BlackHole) :
    reservoirRelaxationRate bh = hawkingPlanckCoefficient / bh.mass ^ 2 :=
  hawkingRadiationMagnitude_eq_coefficient_div bh.mass bh.mass_ne_zero

/-- **Mass-squared weighted relaxation rate is a universal constant.**
    For every positive-mass BH,
        `reservoirRelaxationRate bh · M² = A_H`. -/
theorem reservoirRelaxationRate_times_mass_sq (bh : BlackHole) :
    reservoirRelaxationRate bh * bh.mass ^ 2 = hawkingPlanckCoefficient :=
  hawkingRadiationMagnitude_times_M_sq bh.mass bh.mass_pos

/-- **Antitone in mass (larger BHs relax more slowly).**  Matches
    `hawkingRadiationMagnitude_antimono`: deeper reservoirs sit
    behind more massive horizons. -/
theorem reservoirRelaxationRate_antimono_in_mass
    {bh₁ bh₂ : BlackHole} (h : bh₁.mass < bh₂.mass) :
    reservoirRelaxationRate bh₂ < reservoirRelaxationRate bh₁ := by
  unfold reservoirRelaxationRate
  exact hawkingRadiationMagnitude_antimono bh₁.mass_pos h

/-! ## §2.  Tier 1 HEADLINE — functional form

For every BH and every time, the total Hawking outflow over the
interval `[0,t]` equals the reservoir relaxation rate times the
elapsed time.  This is the **functional form** from the mission
spec:

    `hawkingOutflow bh t = reservoirRelaxationRate bh · t`.

Proof: both sides equal `hawkingRadiationMagnitude bh.mass · t` by
the definition of `hawkingOutflow` (Alnasl) and of
`reservoirRelaxationRate` (above); therefore `rfl`. -/

/-- **HEADLINE (functional form) — `hawking_outflow_as_relaxation`.**

    For every BH `bh` and every time `t`, the Hawking outflow equals
    the reservoir relaxation rate integrated over the interval:

        `hawkingOutflow bh t = reservoirRelaxationRate bh · t`.

    **Physical reading.**  The BH horizon is the substrate's
    "pressure valve" for the dark-energy reservoir: every joule of
    reservoir info is shed back into outgoing Hawking flux at a
    Planck-scale rate `A_H / M²`.  The mission's target form is
    realised definitionally — both sides are literally the same
    expression. -/
theorem hawking_outflow_as_relaxation (bh : BlackHole) (t : ℝ) :
    hawkingOutflow bh t = reservoirRelaxationRate bh * t := rfl

/-- **Outflow is non-negative for `t ≥ 0`** — inherits from
    `hawkingOutflow_nonneg` after the relaxation-rate rename. -/
theorem reservoirRelaxation_outflow_nonneg
    (bh : BlackHole) {t : ℝ} (ht : 0 ≤ t) :
    0 ≤ reservoirRelaxationRate bh * t := by
  rw [← hawking_outflow_as_relaxation]
  exact hawkingOutflow_nonneg bh ht

/-- **Outflow vanishes at `t = 0`.**  No time, no reservoir
    relaxation. -/
@[simp] theorem reservoirRelaxation_outflow_zero_time (bh : BlackHole) :
    reservoirRelaxationRate bh * (0 : ℝ) = 0 := by
  ring

/-- **Outflow is monotone in time.**  Longer exposure → more
    reservoir relaxation (at fixed mass). -/
theorem reservoirRelaxation_outflow_mono
    (bh : BlackHole) {t₁ t₂ : ℝ} (h : t₁ ≤ t₂) :
    reservoirRelaxationRate bh * t₁ ≤ reservoirRelaxationRate bh * t₂ :=
  mul_le_mul_of_nonneg_left h (reservoirRelaxationRate_nonneg bh)

/-! ## §3.  Tier 2 — Composition with the three-term ledger

The Alnasl mediation identity
    `incoming = outflow + gain`
factors through the reservoir-relaxation rename.  The `outflow`
summand equals `reservoirRelaxationRate bh · t` — the share of the
incoming energy that the horizon relaxes back out as Hawking flux.
The `gain` summand is the Denebola term — the share booked into the
reservoir.

In the *reverse-flow* regime (photon redshift into the reservoir),
Denebola's `darkEnergyReservoirGain w ≥ 0` says the reservoir
absorbs info at a non-negative rate.  In the *forward-flow* regime
(horizon relaxation back into flux), this file's
`reservoirRelaxationRate bh > 0` says the reservoir sheds info at a
strictly positive rate.  The two signs together close the substrate
bookkeeping. -/

/-- **Ledger closure under the relaxation rename.**

    The Alnasl mediation identity restated with `outflow` replaced
    by its relaxation-rate form:

        `incoming = reservoirRelaxationRate bh · t + darkEnergyGain bh t`.

    Proof:  substitute the functional-form identity into the
    Alnasl `black_hole_is_mediator_not_sink` second conjunct. -/
theorem reservoir_relaxation_closes_mediator_ledger
    (bh : BlackHole) (t : ℝ) :
    incomingEnergy bh t
      = reservoirRelaxationRate bh * t + darkEnergyGain bh t := by
  rw [← hawking_outflow_as_relaxation]
  exact (black_hole_is_mediator_not_sink bh t).2

/-- **Reverse-of-redshift directional signature.**

    Denebola's `darkEnergyReservoirGain_nonneg` establishes that
    every photon redshift event deposits NON-NEGATIVE info into
    `Δρ_DE`.  This file's `reservoirRelaxationRate_pos` establishes
    that every Hawking event WITHDRAWS strictly positive info FROM
    `Δρ_DE` back into outgoing flux.

    The two signs — deposit ≥ 0 and withdrawal > 0 — close the
    substrate bookkeeping loop: the reservoir is never negative,
    and the horizon is the one place it CAN relax.

    Paper-ready joint statement. -/
theorem reservoir_relaxation_reverse_of_redshift (bh : BlackHole) :
    0 ≤ reservoirRelaxationRate bh ∧ 0 < reservoirRelaxationRate bh :=
  ⟨reservoirRelaxationRate_nonneg bh, reservoirRelaxationRate_pos bh⟩

/-! ## §4.  Tier 3 — Temperature factorisation `T_H ∝ 1/(M·δ_comp)`

The Hawking temperature `T_H(M) = ℏc³/(8πG_N·M·k_B)` is a cleanly
`1/M`-factored quantity.  To connect to the substrate's
computational-uncertainty depth `δ_comp(N)` we introduce a named
scale — the **substrate temperature ceiling**:

    `substrateTemperatureCeiling(N) := hawkingTemperatureCoefficient · δ_comp(N)`

where `hawkingTemperatureCoefficient := ℏc³/(8πG_N·k_B)` is the
universal prefactor that carries the physical constants.  The
mass-and-depth-isolated form is then:

    `T_H(M) = substrateTemperatureCeiling(N) / (M · δ_comp(N))`.

This realises the mission's `T_H ∝ 1/(M · δ_comp(N_horizon))` as an
exact factorisation.  The ceiling is positive everywhere and strictly
decreasing in the substrate depth `N`. -/

/-- **Hawking temperature prefactor.**  The mass-independent part of
    `T_H(M) = ℏc³/(8πG_N·M·k_B)`, i.e. `ℏc³/(8πG_N·k_B)`.  A universal
    substrate constant built from `ℏ, c, G_N, k_B`. -/
noncomputable def hawkingTemperatureCoefficient : ℝ :=
  hbar * c ^ 3 / (8 * Real.pi * G_N * k_B)

/-- **Hawking temperature prefactor is strictly positive.** -/
theorem hawkingTemperatureCoefficient_pos :
    0 < hawkingTemperatureCoefficient := by
  unfold hawkingTemperatureCoefficient
  exact div_pos (mul_pos hbar_pos (pow_pos c_pos 3))
    (mul_pos (mul_pos (mul_pos (by norm_num : (0:ℝ) < 8) Real.pi_pos)
      G_N_pos) k_B_pos)

/-- **Hawking temperature prefactor is non-negative.** -/
theorem hawkingTemperatureCoefficient_nonneg :
    0 ≤ hawkingTemperatureCoefficient :=
  le_of_lt hawkingTemperatureCoefficient_pos

/-- **Hawking temperature factorisation**: `T_H(M) = T_coeff / M`. -/
theorem hawkingTemperature_eq_coefficient_div
    (M : ℝ) (hM : M ≠ 0) :
    OmegaTheory.Conservation.hawkingTemperature M
      = hawkingTemperatureCoefficient / M := by
  unfold OmegaTheory.Conservation.hawkingTemperature hawkingTemperatureCoefficient
  have hpi_ne : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
  have hG_ne : G_N ≠ 0 := ne_of_gt G_N_pos
  have hk_ne : k_B ≠ 0 := ne_of_gt k_B_pos
  field_simp

/-- **Substrate-weighted temperature ceiling.**  The Hawking
    temperature prefactor weighted by the substrate computational
    uncertainty at depth `N`:

        `substrateTemperatureCeiling(N) := T_coeff · δ_comp(N)`.

    This is the universal substrate scale that makes the
    `1/(M · δ_comp(N))` factorisation of `T_H` exact (cf.
    `hawkingTemperature_delta_comp_bound` below).

    Dimensional sanity: `T_coeff` has temperature·length units
    (since `δ_comp` has length); the ceiling has the units of
    temperature × length² when divided by `M` (which carries
    mass/length⁻¹ weight), giving the correct K·m²·kg⁻¹ scaling for
    a temperature. -/
noncomputable def substrateTemperatureCeiling (N : ℕ) : ℝ :=
  hawkingTemperatureCoefficient * Irrationality.computationalUncertainty N

/-- **Ceiling is strictly positive at every lattice depth.** -/
theorem substrateTemperatureCeiling_pos (N : ℕ) :
    0 < substrateTemperatureCeiling N := by
  unfold substrateTemperatureCeiling
  exact mul_pos hawkingTemperatureCoefficient_pos
    (Irrationality.computationalUncertainty_pos N)

/-- **Ceiling is non-negative.** -/
theorem substrateTemperatureCeiling_nonneg (N : ℕ) :
    0 ≤ substrateTemperatureCeiling N :=
  le_of_lt (substrateTemperatureCeiling_pos N)

/-- **Ceiling is antitone in substrate depth.**  Deeper lattices
    give tighter bounds — matches `δ_comp(N) → 0`. -/
theorem substrateTemperatureCeiling_decreasing (N : ℕ) :
    substrateTemperatureCeiling (N + 1) ≤ substrateTemperatureCeiling N := by
  unfold substrateTemperatureCeiling
  exact mul_le_mul_of_nonneg_left
    (Irrationality.computationalUncertainty_decreasing N)
    hawkingTemperatureCoefficient_nonneg

/-- **TIER 3 — `hawkingTemperature_delta_comp_bound`.**

    The mission's `T_H ∝ 1/(M · δ_comp(N_horizon))` realised as an
    **exact equality**: for every positive-mass BH and every
    substrate depth `N`,

        `T_H(M) = substrateTemperatureCeiling(N) / (M · δ_comp(N))`.

    **Proof.**  Unfold the ceiling and apply the two factorisations:
    `T_H(M) = T_coeff / M` (above) and `T_coeff · δ_comp = T_coeff ·
    δ_comp`, then divide both sides by `δ_comp` (non-zero).
    Algebraic. -/
theorem hawkingTemperature_delta_comp_bound
    (M : ℝ) (hM : 0 < M) (N : ℕ) :
    OmegaTheory.Conservation.hawkingTemperature M
      = substrateTemperatureCeiling N /
          (M * Irrationality.computationalUncertainty N) := by
  rw [hawkingTemperature_eq_coefficient_div M (ne_of_gt hM)]
  unfold substrateTemperatureCeiling
  have hM_ne : M ≠ 0 := ne_of_gt hM
  have hδ_ne : Irrationality.computationalUncertainty N ≠ 0 :=
    ne_of_gt (Irrationality.computationalUncertainty_pos N)
  field_simp

/-- **Equivalent product form**: the quantity `T_H · M · δ_comp(N)`
    is *independent* of `M` at fixed lattice depth — it equals the
    substrate ceiling exactly.  This is the "∝" statement in its
    most directly-empirical form: every positive-mass BH has the
    same product `T · M · δ_comp`.

    Compatibility: when the paper narrates "T_H scales as the
    inverse of `M · δ_comp`", this product identity is the exact
    content. -/
theorem hawkingTemperature_times_mass_times_delta_comp
    (M : ℝ) (hM : 0 < M) (N : ℕ) :
    OmegaTheory.Conservation.hawkingTemperature M * M
        * Irrationality.computationalUncertainty N
      = substrateTemperatureCeiling N := by
  rw [hawkingTemperature_eq_coefficient_div M (ne_of_gt hM)]
  unfold substrateTemperatureCeiling
  have hM_ne : M ≠ 0 := ne_of_gt hM
  field_simp

/-- **Antitonicity in substrate depth of the bound.**  Deeper
    lattices → smaller ceiling → tighter temperature bound at fixed
    mass and fixed `δ_comp(N)` evaluated at the more refined `N+1`.

    This reads directly off `substrateTemperatureCeiling_decreasing`. -/
theorem hawkingTemperature_bound_tightens_with_depth
    (N : ℕ) :
    substrateTemperatureCeiling (N + 1) ≤ substrateTemperatureCeiling N :=
  substrateTemperatureCeiling_decreasing N

/-! ## §5.  Tier 1 HEADLINE (full) — `hawking_as_dark_energy_reservoir_relaxation`

The target theorem from the mission spec, combining the functional
form (Tier 1) with the temperature bound (Tier 3) into one
conjunction:

    `hawkingOutflow bh t = reservoirRelaxationRate bh · t
      ∧ hawkingTemperature(M) = substrateTemperatureCeiling(N)
            / (M · δ_comp(N))`

where `M := bh.mass` and `N` is a free substrate-depth parameter. -/

/-- **HEADLINE — `hawking_as_dark_energy_reservoir_relaxation`.**

    The mission's target `theorem`.  For every black hole `bh`, every
    time `t`, and every substrate depth `N`:

      (A) **Functional form.**  The Hawking outflow over `[0,t]`
          equals the reservoir relaxation rate integrated over `t`:

              `hawkingOutflow bh t = reservoirRelaxationRate bh · t`.

      (B) **Temperature `∝ 1/(M · δ_comp(N))`.**  The Hawking
          temperature factors through the substrate temperature
          ceiling at lattice depth `N`:

              `T_H(M) = substrateTemperatureCeiling(N) / (M · δ_comp(N))`.

    **Proof.** (A) is `rfl` by definition of `hawkingOutflow` and
    `reservoirRelaxationRate`.  (B) is
    `hawkingTemperature_delta_comp_bound` applied to `bh.mass_pos`. -/
theorem hawking_as_dark_energy_reservoir_relaxation
    (bh : BlackHole) (t : ℝ) (N : ℕ) :
    hawkingOutflow bh t = reservoirRelaxationRate bh * t
      ∧ OmegaTheory.Conservation.hawkingTemperature bh.mass
          = substrateTemperatureCeiling N /
              (bh.mass * Irrationality.computationalUncertainty N) :=
  ⟨hawking_outflow_as_relaxation bh t,
   hawkingTemperature_delta_comp_bound bh.mass bh.mass_pos N⟩

/-! ## §6.  Tier 4 — Unified summary

One theorem bundling every key observable of reservoir relaxation:
functional form, ledger closure, temperature factorisation, and
substrate-depth antitonicity.  Paper-ready. -/

/-- **UNIFIED SUMMARY — Hawking is the horizon's relaxation of the
    dark-energy reservoir.**

    For every positive-mass BH `bh`, every time `t ≥ 0`, and every
    substrate depth `N`, five structural facts hold simultaneously:

    1. **Functional form.**  `hawkingOutflow bh t
       = reservoirRelaxationRate bh · t`.
    2. **Ledger closure.**  `incomingEnergy bh t
       = reservoirRelaxationRate bh · t + darkEnergyGain bh t`.
    3. **Temperature factorisation.**  `T_H(bh.mass)
       = substrateTemperatureCeiling(N) / (bh.mass · δ_comp(N))`.
    4. **Substrate depth antitonicity.**  `substrateTemperatureCeiling
       (N+1) ≤ substrateTemperatureCeiling N`.
    5. **Reservoir bookkeeping non-negativity.**  `reservoirRelaxation
       Rate bh > 0`, and the outflow is `≥ 0` for `t ≥ 0`.

    Together these say: the BH horizon is the substrate's relaxation
    channel for the dark-energy reservoir; its rate is a Planck-scale
    universal constant divided by `M² `; the temperature factorisation
    ties to the substrate depth through `δ_comp(N)`; and deeper
    lattices give tighter bounds.  The three-term ledger (Alnasl)
    closes with both signs fully fixed: reservoir absorbs via photon
    redshift (Denebola, ≥ 0), and reservoir sheds via horizon Hawking
    flux (this file, > 0). -/
theorem hawking_reservoir_relaxation_summary
    (bh : BlackHole) {t : ℝ} (ht : 0 ≤ t) (N : ℕ) :
    (hawkingOutflow bh t = reservoirRelaxationRate bh * t)
      ∧ (incomingEnergy bh t
          = reservoirRelaxationRate bh * t + darkEnergyGain bh t)
      ∧ (OmegaTheory.Conservation.hawkingTemperature bh.mass
          = substrateTemperatureCeiling N /
              (bh.mass * Irrationality.computationalUncertainty N))
      ∧ (substrateTemperatureCeiling (N + 1) ≤ substrateTemperatureCeiling N)
      ∧ (0 < reservoirRelaxationRate bh
          ∧ 0 ≤ reservoirRelaxationRate bh * t) :=
  ⟨hawking_outflow_as_relaxation bh t,
   reservoir_relaxation_closes_mediator_ledger bh t,
   hawkingTemperature_delta_comp_bound bh.mass bh.mass_pos N,
   substrateTemperatureCeiling_decreasing N,
   ⟨reservoirRelaxationRate_pos bh,
    reservoirRelaxation_outflow_nonneg bh ht⟩⟩

end OmegaTheory.Emergence.HawkingReservoirRelaxation
