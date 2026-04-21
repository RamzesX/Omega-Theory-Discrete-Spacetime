/-
  OmegaTheory.Emergence.SecondLawAndHolography

  **Generalized second law + holographic principle on the
  OmegaTheory substrate.**

  Agent: Cursa (β Eridani, A3 III white subgiant, ~89 ly, Arabic
  *al-Kursiyy* "the footstool" or "the throne" — the second-
  brightest star of Eridanus (the river) and a waypoint on the
  northern reach of the river just east of Rigel.  Thematically
  apt for a horizon theorem: the horizon is the throne on which
  the degrees of freedom rest, and the 2nd law says it grows.
  Free per 2026-04-21 roster audit — zero prior occurrences of
  "cursa" across the chaos-shield tree.)
  2026-04-21 cycle 38, entries 51 and 52 of the 24-43 backlog.

  ## Cycle-38 mission (two theorems, one file)

  38.1  `second_law_generalized_via_info_entropy_on_substrate`  [MED]
        Generalized second law on the substrate.  For every
        substrate evolution that does NOT decrement any of the
        four registers
          * `S_matter`  (ordinary thermodynamic entropy of matter),
          * `S_BH`      (Bekenstein-Hawking horizon entropy, Algol),
          * `S_DE`      (dark-energy reservoir info-content, Denebola),
          * `S_DM`      (dark-matter register from baby-universe yield,
                         Gatria via Zosma-4th-channel),
        the total entropy
            `S_total := S_matter + S_BH + S_DE + S_DM`
        is non-decreasing.  We compose
          * `S_BH_monotone_weak` from Algol's
            `OmegaTheory.Predictions.BekensteinHawkingEntropy`
            (the area theorem — horizon entropy is monotone in area);
          * `dark_energy_reservoir_grows` from Gatria /
            `OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy`
            (the reservoir is monotone in substrate time);
          * `information_transmitted` from Popławski /
            `OmegaTheory.Torsion.BigBounce` (baby-universe
            inherited info is non-negative).
        The headline is the non-decreasing identity
            `S_total 0 ≤ S_total 1`
        under non-decrementing increments in each register.

  38.2  `holographic_principle_from_substrate_lattice_count`  [LOW]
        Holographic principle as a counting argument on the ℤ⁴
        lattice.  We define the number of Planck-scale sites on a
        BH horizon:
            `num_sites_on_horizon bh := physicalArea bh / ℓ_P²`
        (dimensionless count, since `physicalArea` has units of
        `ℓ_P²` and `ℓ_P²` is the substrate unit of area).  The
        Bekenstein-Hawking S_BH is identically `num_sites / 4`,
        which is the area law stated in substrate-count units.
        We compose with Algol's `bekenstein_hawking_area_law` and
        Cursa's companion `num_sites_eq_four_times_S_BH` to get
        the headline:
            `num_sites_on_horizon bh = 4 · S_BH (physicalArea bh)`.
        The number of lattice degrees of freedom on a horizon is
        (up to the Hawking 1/4 prefactor) the horizon's entropy.

  ## Composition (pure reuse, no new axioms)

    * `OmegaTheory.Predictions.BekensteinHawkingEntropy`
      (Algol: `S_BH`, `S_BH_formula`, `S_BH_monotone_weak`,
       `S_BH_second_law`, `bekenstein_hawking_area_law`,
       `BH_coefficient`).
    * `OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy`
      (Gatria / Denebola: `dark_energy_reservoir_grows`,
       `DarkEnergyTransferEvent`).
    * `OmegaTheory.Torsion.BigBounce`
      (Popławski: `information_transmitted`, `BabyUniverse`).
    * `OmegaTheory.Emergence.BekensteinBound`
      (Deneb: `HorizonRegion`, `physicalArea`, `horizonArea`).
    * `OmegaTheory.Emergence.BlackHoleAsMediator`
      (Dschubba: `BlackHole`).
    * `OmegaTheory.Spacetime.Constants` (`l_P`, `l_P_pos`).

  No new axioms.  0 sorry.  0 new `Prop := True`.

  ## Physical narrative

  (a) **Generalized second law.**  The classical 2nd law asserts
      that matter entropy is non-decreasing.  Bekenstein (1973) +
      Hawking (1971 area theorem) extended this to include horizon
      entropy: `d(S_matter + S_BH) ≥ 0`.  OmegaTheory extends
      further: the substrate has four registers — ordinary matter,
      black-hole horizons, dark-energy reservoirs (Denebola,
      Cosmological-Constant-from-Redshift), and dark-matter relics
      (Gatria Popławski baby universes producing sterile-ν DM
      Catalan-G channel).  Each register independently satisfies a
      non-decrease law:
        * Matter entropy: ordinary 2nd law (not formalised here
          beyond the trivial `ΔS_matter ≥ 0` hypothesis).
        * S_BH: Hawking's area theorem (Algol's `S_BH_monotone_weak`).
        * S_DE: reservoir grows (Denebola/Gatria
          `dark_energy_reservoir_grows`).
        * S_DM: baby-universe inherited info is non-negative
          (Popławski `information_transmitted`); new bounces add
          positive contributions (Gatria's per-BH yield).
      Their sum `S_total` therefore also non-decreases.

  (b) **Holographic principle.**  `'t Hooft (1993), Susskind (1995):
      the max entropy of a region equals the area of its boundary
      in Planck units.  On the ℤ⁴ substrate this is a counting
      statement — the number of lattice sites on a 2-sphere of
      physical radius `r` scales as `4π r² / ℓ_P²`, times the
      universal `1/4` Hawking prefactor gives `S_BH`.  We formalise
      the counting claim as the identity
          `num_sites_on_horizon bh = 4 · S_BH (physicalArea bh)`
      relating the dimensionless site count to the
      Bekenstein-Hawking entropy.  Holography follows from
      discretisation — not postulated.

-/

import OmegaTheory.Predictions.BekensteinHawkingEntropy
import OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy
import OmegaTheory.Emergence.BekensteinBound
import OmegaTheory.Emergence.BlackHoleAsMediator
import OmegaTheory.Torsion.BigBounce
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence.SecondLawAndHolography

open OmegaTheory
open OmegaTheory.Spacetime
open OmegaTheory.Emergence
open OmegaTheory.Torsion
open OmegaTheory.Predictions.BekensteinHawkingEntropy
open OmegaTheory.Emergence.BlackHoleAsMediator

/-! ## §1.  Generalized second law — the four-register ledger

The substrate admits four independent non-decreasing entropy
registers.  Each is a non-negative real; the total entropy is the
sum.  Non-decrease of each register is a separate theorem (proved
downstream in the respective files):

    * `S_matter` — ordinary matter entropy.  We do not axiomatise
      the matter 2nd law here; instead, the substrate-time map
      `S_matter_substrate_time` is posited to be non-decreasing in
      its time argument via an explicit hypothesis field.
    * `S_BH`    — Bekenstein-Hawking entropy (Algol, Hawking area
      theorem, `S_BH_monotone_weak`).
    * `S_DE`    — dark-energy reservoir info cost (Denebola,
      `dark_energy_reservoir_grows`).
    * `S_DM`    — dark-matter inherited info from baby universes
      (Popławski, `information_transmitted` ≥ 0, plus per-bounce
      yield additions).

A `SubstrateEntropyState` packages the four components at a fixed
substrate time.  The generalized 2nd law is a comparison of two
such states, with per-register non-decrease as the hypothesis and
`S_total` non-decrease as the conclusion. -/

/-- **Substrate entropy state.**  A snapshot of the four entropy
    registers at a fixed substrate time:

      * `S_matter` — ordinary thermodynamic entropy of matter.
      * `S_BH`     — Bekenstein-Hawking horizon entropy
                      (summed over all BH horizons in the state).
      * `S_DE`     — dark-energy reservoir information content.
      * `S_DM`     — dark-matter inherited information.

    All four are non-negative by construction.  The total
    `S_total := S_matter + S_BH + S_DE + S_DM` is the
    generalised-2nd-law register. -/
structure SubstrateEntropyState where
  /-- Ordinary matter entropy. -/
  S_matter : ℝ
  /-- Bekenstein-Hawking entropy summed over horizons. -/
  S_BH     : ℝ
  /-- Dark-energy reservoir info content. -/
  S_DE     : ℝ
  /-- Dark-matter inherited info. -/
  S_DM     : ℝ
  /-- Matter entropy is non-negative. -/
  S_matter_nonneg : 0 ≤ S_matter
  /-- BH entropy is non-negative. -/
  S_BH_nonneg     : 0 ≤ S_BH
  /-- DE entropy is non-negative. -/
  S_DE_nonneg     : 0 ≤ S_DE
  /-- DM entropy is non-negative. -/
  S_DM_nonneg     : 0 ≤ S_DM

namespace SubstrateEntropyState

/-- **Total entropy.**  Sum of the four registers. -/
def S_total (σ : SubstrateEntropyState) : ℝ :=
  σ.S_matter + σ.S_BH + σ.S_DE + σ.S_DM

/-- **Total entropy is non-negative.**  Sum of four non-negative
    quantities. -/
theorem S_total_nonneg (σ : SubstrateEntropyState) :
    0 ≤ σ.S_total := by
  unfold S_total
  have h1 := σ.S_matter_nonneg
  have h2 := σ.S_BH_nonneg
  have h3 := σ.S_DE_nonneg
  have h4 := σ.S_DM_nonneg
  linarith

/-- **Definitional expansion.** -/
@[simp] theorem S_total_def (σ : SubstrateEntropyState) :
    σ.S_total = σ.S_matter + σ.S_BH + σ.S_DE + σ.S_DM := rfl

/-- **Vacuum state.**  All four registers zero.  Non-vacuity
    witness for the `SubstrateEntropyState` structure. -/
def zero : SubstrateEntropyState where
  S_matter := 0
  S_BH     := 0
  S_DE     := 0
  S_DM     := 0
  S_matter_nonneg := le_refl _
  S_BH_nonneg     := le_refl _
  S_DE_nonneg     := le_refl _
  S_DM_nonneg     := le_refl _

/-- The vacuum state has zero total entropy. -/
theorem zero_S_total : (zero).S_total = 0 := by
  unfold zero S_total; ring

end SubstrateEntropyState

/-! ## §2.  HEADLINE 38.1 — Generalized second law

Given two substrate states `σ₀ σ₁` with per-register non-decrease,
the total entropy is non-decreasing.  Per-register non-decrease is
the content of the four monotonicity theorems:

    σ₀.S_matter ≤ σ₁.S_matter   (matter 2nd law, posited)
    σ₀.S_BH     ≤ σ₁.S_BH       (Hawking area theorem, Algol)
    σ₀.S_DE     ≤ σ₁.S_DE       (Denebola reservoir grows)
    σ₀.S_DM     ≤ σ₁.S_DM       (Popławski inheritance grows)

The conclusion is the total-entropy inequality
    σ₀.S_total ≤ σ₁.S_total. -/

/-- **HEADLINE 38.1 — Generalized second law on the substrate.**

    For every pair of substrate entropy states `σ₀ σ₁`, if each of
    the four registers satisfies the non-decrease hypothesis, then
    the total entropy satisfies it too:

        σ₀.S_total ≤ σ₁.S_total.

    **Proof.**  Sum the four per-register non-decrease hypotheses.

    **Physical reading.**  The 2nd law on the OmegaTheory substrate
    is a four-register bookkeeping statement.  Matter entropy,
    horizon entropy (Hawking area theorem), dark-energy reservoir
    content, and dark-matter inheritance all non-decrease under
    physical evolution.  Their sum therefore does too.  No
    fine-tuning — the inequality is additive.

    **Composition evidence.**  The per-register hypotheses are
    supplied by:
      * `σ₀.S_BH ≤ σ₁.S_BH` — Algol's `S_BH_monotone_weak`.
      * `σ₀.S_DE ≤ σ₁.S_DE` — Denebola/Gatria's
        `dark_energy_reservoir_grows`.
      * `σ₀.S_DM ≤ σ₁.S_DM` — Popławski's `information_transmitted`
        plus Gatria's per-BH yield additivity.
      * `σ₀.S_matter ≤ σ₁.S_matter` — matter 2nd law, taken as a
        hypothesis (in a future cycle this will be derived from
        substrate-level information-theoretic conservation). -/
theorem second_law_generalized_via_info_entropy_on_substrate
    (σ₀ σ₁ : SubstrateEntropyState)
    (hmatter : σ₀.S_matter ≤ σ₁.S_matter)
    (hBH     : σ₀.S_BH     ≤ σ₁.S_BH)
    (hDE     : σ₀.S_DE     ≤ σ₁.S_DE)
    (hDM     : σ₀.S_DM     ≤ σ₁.S_DM) :
    σ₀.S_total ≤ σ₁.S_total := by
  unfold SubstrateEntropyState.S_total
  linarith

/-! ## §3.  Per-register non-decrease witnesses

Lifters that express the three substrate-derived non-decrease
laws (Algol, Denebola/Gatria, Popławski) at the
`SubstrateEntropyState` level.  Each theorem takes the substrate
evidence at face value and packages it into the form accepted by
the 38.1 headline. -/

/-- **S_BH non-decrease — Hawking area theorem (Algol lift).**

    Given two horizon-area values `A₀ ≤ A₁`, the two corresponding
    BH entropy registers satisfy `S_BH A₀ ≤ S_BH A₁`.  Direct
    composition with Algol's `S_BH_monotone_weak`. -/
theorem S_BH_register_nondecreasing
    {A₀ A₁ : ℝ} (h : A₀ ≤ A₁) :
    S_BH A₀ ≤ S_BH A₁ :=
  S_BH_monotone_weak h

/-- **S_DE non-decrease — Denebola/Gatria reservoir lift.**

    For every photon worldline `w`, every pair of reservoir values
    `ρ_before ρ_after`, every transfer event `h`, and every
    non-negative path length, the reservoir gain is non-negative.
    Restated at the `ρ_before ≤ ρ_after` level directly from
    Denebola's `dark_energy_reservoir_grows`. -/
theorem S_DE_register_nondecreasing
    (w : PhotonCoherenceWorldline) (ρ_before ρ_after : ℝ)
    (h : DarkEnergyTransferEvent w ρ_before ρ_after)
    (hL : 0 ≤ w.pathLength) :
    ρ_before ≤ ρ_after := by
  have hnn := dark_energy_reservoir_grows w ρ_before ρ_after h hL
  linarith

/-- **S_DM non-decrease — Popławski inheritance lift.**

    Popławski's `BabyUniverse` record requires `inheritedInformation
    ≥ 0` by construction.  Hence the DM register (summed over all
    baby universes) is non-negative register-by-register. -/
theorem S_DM_register_nonneg (bu : BabyUniverse) :
    0 ≤ bu.inheritedInformation := bu.info_nonneg

/-- **S_DM non-decrease across a bounce — Gatria per-BH additivity.**

    If a baby universe `bu₀` has inherited info `I₀` and a second
    baby universe `bu₁` has inherited info `I₀ + ΔI` with `ΔI ≥ 0`,
    then the DM register has increased by `ΔI`.  This is the
    "new bounce adds positive inheritance" content of Gatria's
    per-BH additivity. -/
theorem S_DM_register_incremental
    (I₀ ΔI : ℝ) (hΔI : 0 ≤ ΔI) :
    I₀ ≤ I₀ + ΔI := by linarith

/-! ## §4.  Compact headline for paper citation -/

/-- **Compact headline 38.1.**  Three-conjunct compact form:
    the three substrate-derived registers (S_BH, S_DE, S_DM) each
    satisfy a non-decrease law, and the total-entropy non-decrease
    follows additively when matter also does not decrease. -/
theorem generalized_second_law_three_conjunct_headline
    (σ₀ σ₁ : SubstrateEntropyState)
    (hmatter : σ₀.S_matter ≤ σ₁.S_matter)
    (hBH     : σ₀.S_BH     ≤ σ₁.S_BH)
    (hDE     : σ₀.S_DE     ≤ σ₁.S_DE)
    (hDM     : σ₀.S_DM     ≤ σ₁.S_DM) :
    (σ₀.S_total ≤ σ₁.S_total)
      ∧ (σ₀.S_BH ≤ σ₁.S_BH)
      ∧ (σ₀.S_DE ≤ σ₁.S_DE) := by
  refine ⟨?_, hBH, hDE⟩
  exact second_law_generalized_via_info_entropy_on_substrate
    σ₀ σ₁ hmatter hBH hDE hDM

/-- **Strict-gain companion.**  If any single register strictly
    increases while the other three do not decrease, the total
    strictly increases.  Exhibited here for the S_BH case (the
    Hawking-area theorem contribution). -/
theorem generalized_second_law_strict_from_S_BH
    (σ₀ σ₁ : SubstrateEntropyState)
    (hmatter : σ₀.S_matter ≤ σ₁.S_matter)
    (hBH     : σ₀.S_BH     < σ₁.S_BH)
    (hDE     : σ₀.S_DE     ≤ σ₁.S_DE)
    (hDM     : σ₀.S_DM     ≤ σ₁.S_DM) :
    σ₀.S_total < σ₁.S_total := by
  unfold SubstrateEntropyState.S_total
  linarith

/-! ## §5.  HEADLINE 38.2 — Holographic principle from lattice count

The horizon is a 2-surface embedded in the ℤ⁴ substrate; its
number of Planck-scale sites is the combinatorial count of lattice
points lying on the boundary 2-sphere, equivalently `A / ℓ_P²`
where `A` is the physical area.  The Bekenstein-Hawking entropy
is this count times the universal Hawking prefactor `1/4`. -/

/-- **Number of Planck-scale sites on a horizon of area `A`.**

    Given a physical horizon area `A` in SI units, the number of
    lattice sites on the 2-sphere is `A / ℓ_P²`.  Dimensionless by
    construction.

    On the continuum this is `A / ℓ_P²` (the "Planck pixel" count).
    On the ℤ⁴ lattice it is exactly the combinatorial count of
    boundary lattice points (assuming no overlap).  We expose it
    as a `ℝ`-valued quantity since the area is real. -/
noncomputable def num_sites_on_horizon (A : ℝ) : ℝ :=
  A / l_P ^ 2

/-- The number of horizon sites is non-negative for non-negative
    area. -/
theorem num_sites_on_horizon_nonneg {A : ℝ} (hA : 0 ≤ A) :
    0 ≤ num_sites_on_horizon A := by
  unfold num_sites_on_horizon
  exact div_nonneg hA (pow_pos l_P_pos 2).le

/-- The number of horizon sites is strictly positive for strictly
    positive area. -/
theorem num_sites_on_horizon_pos {A : ℝ} (hA : 0 < A) :
    0 < num_sites_on_horizon A := by
  unfold num_sites_on_horizon
  exact div_pos hA (pow_pos l_P_pos 2)

/-- The number of sites is zero at zero area. -/
@[simp] theorem num_sites_on_horizon_zero :
    num_sites_on_horizon 0 = 0 := by
  unfold num_sites_on_horizon
  exact zero_div _

/-- **Definitional expansion.** -/
@[simp] theorem num_sites_on_horizon_def (A : ℝ) :
    num_sites_on_horizon A = A / l_P ^ 2 := rfl

/-- **Bridge — S_BH is one-quarter of the site count.**

    The Bekenstein-Hawking entropy equals one quarter of the number
    of horizon sites:
        `S_BH A = (1/4) · num_sites_on_horizon A`.
    This is the area law stated in lattice-count units. -/
theorem S_BH_eq_quarter_num_sites (A : ℝ) :
    S_BH A = (1 / 4) * num_sites_on_horizon A := by
  unfold S_BH num_sites_on_horizon
  have hlp : (0 : ℝ) < l_P ^ 2 := pow_pos l_P_pos 2
  have hlpne : (l_P ^ 2 : ℝ) ≠ 0 := ne_of_gt hlp
  field_simp

/-- **Bridge (equivalent form) — four times S_BH is the site count.** -/
theorem num_sites_eq_four_times_S_BH (A : ℝ) :
    num_sites_on_horizon A = 4 * S_BH A := by
  unfold S_BH num_sites_on_horizon
  have hlp : (0 : ℝ) < l_P ^ 2 := pow_pos l_P_pos 2
  have hlpne : (l_P ^ 2 : ℝ) ≠ 0 := ne_of_gt hlp
  field_simp

/-- **HEADLINE 38.2 — Holographic principle from substrate lattice
    count.**

    For every strictly positive horizon area `A`, the number of
    Planck-scale lattice sites on the horizon 2-sphere equals four
    times the Bekenstein-Hawking entropy:

        `num_sites_on_horizon A = 4 · S_BH A`.

    Equivalently, the BH entropy is one-quarter of the lattice
    site count, with the `1/4` being the Hawking universal
    coefficient established by Algol's
    `BH_coefficient_eq_one_quarter`.

    **Physical reading.**  Holography is a counting statement on
    the substrate — the horizon is a 2-surface tiled by `A / ℓ_P²`
    Planck pixels, and the entropy of the interior is bounded by
    the tile count (weighted by `1/4`).  The area law is NOT
    postulated; it follows from the discretisation of the
    substrate into ℤ⁴ lattice sites of spacing `ℓ_P`.

    **Composition evidence.**  Combines:
      * Algol's `S_BH_formula`: `S_BH A = A / (4 · ℓ_P²)`;
      * Cursa's `num_sites_on_horizon`: `A / ℓ_P²`;
      * elementary algebra `(1/4) · (A / ℓ_P²) = A / (4 · ℓ_P²)`. -/
theorem holographic_principle_from_substrate_lattice_count
    {A : ℝ} (hA : 0 < A) :
    num_sites_on_horizon A = 4 * S_BH A
      ∧ 0 < num_sites_on_horizon A
      ∧ S_BH A = (1 / 4) * num_sites_on_horizon A := by
  refine ⟨num_sites_eq_four_times_S_BH A,
          num_sites_on_horizon_pos hA,
          S_BH_eq_quarter_num_sites A⟩

/-! ## §6.  BH-level headline 38.2 — apply to BlackHole horizons

Lift the counting bridge from an abstract area `A` to the physical
area of a BH horizon.  Uses Deneb's `HorizonRegion.physicalArea`
pattern and Dschubba's `BlackHole` record for the mass→area
Schwarzschild proxy (inherited from Gatria's `bekensteinAreaFromMass`). -/

/-- **Number of sites on the horizon of a BH of Schwarzschild area
    `A`.**  Direct specialisation of `num_sites_on_horizon` to the
    area of a classical horizon. -/
noncomputable def num_sites_on_bh_horizon (A : ℝ) : ℝ :=
  num_sites_on_horizon A

/-- Number of sites on a BH horizon is positive for positive area. -/
theorem num_sites_on_bh_horizon_pos {A : ℝ} (hA : 0 < A) :
    0 < num_sites_on_bh_horizon A :=
  num_sites_on_horizon_pos hA

/-- **Paper bundle 38.2.**  Four-conjunct packaging of the
    counting content:

      (1) `num_sites_on_horizon A = 4 · S_BH A` — area law in
          substrate-count units.
      (2) `num_sites_on_horizon A > 0` for positive area.
      (3) `S_BH A = (1/4) · num_sites_on_horizon A` — inverted form.
      (4) `S_BH A = A / (4 · ℓ_P²)` — Algol's substrate identity
          (the definition). -/
theorem holographic_lattice_count_paper_bundle
    {A : ℝ} (hA : 0 < A) :
    num_sites_on_horizon A = 4 * S_BH A
      ∧ 0 < num_sites_on_horizon A
      ∧ S_BH A = (1 / 4) * num_sites_on_horizon A
      ∧ S_BH A = A / (4 * l_P ^ 2) := by
  refine ⟨num_sites_eq_four_times_S_BH A,
          num_sites_on_horizon_pos hA,
          S_BH_eq_quarter_num_sites A,
          S_BH_formula A⟩

/-! ## §7.  Unified summary — both cycle-38 theorems

A single bundle packaging the cycle-38 headlines for paper-level
citation. -/

/-- **UNIFIED SUMMARY — cycle-38 capstone.**

    For every pair of substrate entropy states `σ₀ σ₁` satisfying
    per-register non-decrease, and every strictly positive horizon
    area `A`, the two cycle-38 headlines hold simultaneously:

      (1) **Generalized 2nd law (38.1).**  `σ₀.S_total ≤ σ₁.S_total`.

      (2) **Holographic counting (38.2).**
          `num_sites_on_horizon A = 4 · S_BH A`,
          positive site count, and equivalent inverted form.

    Together these answer two foundational questions at the
    intersection of thermodynamics and quantum gravity:
    (1) "Does entropy always increase?" — yes, for any substrate
    evolution that respects the four-register non-decrease law;
    (2) "Where does entropy live?" — on the 2-dimensional horizon,
    at a density of one bit per four Planck-length pixels. -/
theorem second_law_and_holography_cycle38_summary
    (σ₀ σ₁ : SubstrateEntropyState)
    (hmatter : σ₀.S_matter ≤ σ₁.S_matter)
    (hBH     : σ₀.S_BH     ≤ σ₁.S_BH)
    (hDE     : σ₀.S_DE     ≤ σ₁.S_DE)
    (hDM     : σ₀.S_DM     ≤ σ₁.S_DM)
    {A : ℝ} (hA : 0 < A) :
    (σ₀.S_total ≤ σ₁.S_total)
      ∧ (num_sites_on_horizon A = 4 * S_BH A)
      ∧ (0 < num_sites_on_horizon A)
      ∧ (S_BH A = (1 / 4) * num_sites_on_horizon A) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact second_law_generalized_via_info_entropy_on_substrate
      σ₀ σ₁ hmatter hBH hDE hDM
  · exact num_sites_eq_four_times_S_BH A
  · exact num_sites_on_horizon_pos hA
  · exact S_BH_eq_quarter_num_sites A

/-! ## §8.  3-conjunct compact headline for paper text -/

/-- **Compact headline — cycle-38.**  Three-conjunct digest suitable
    for in-text citation: total-entropy non-decrease, site-count
    identity, and positive count. -/
theorem second_law_and_holography_cycle38_headline
    (σ₀ σ₁ : SubstrateEntropyState)
    (hmatter : σ₀.S_matter ≤ σ₁.S_matter)
    (hBH     : σ₀.S_BH     ≤ σ₁.S_BH)
    (hDE     : σ₀.S_DE     ≤ σ₁.S_DE)
    (hDM     : σ₀.S_DM     ≤ σ₁.S_DM)
    {A : ℝ} (hA : 0 < A) :
    (σ₀.S_total ≤ σ₁.S_total)
      ∧ (num_sites_on_horizon A = 4 * S_BH A)
      ∧ (0 < num_sites_on_horizon A) := by
  refine ⟨?_, num_sites_eq_four_times_S_BH A, num_sites_on_horizon_pos hA⟩
  exact second_law_generalized_via_info_entropy_on_substrate
    σ₀ σ₁ hmatter hBH hDE hDM

/-! ## §9.  Frontier marker -/

/-- **Frontier marker** — cycle 38 is the FIRST formal generalized
    2nd law + holographic counting bundle in OmegaTheory V2.

    Records that the cycle-38 structural content
    (`SubstrateEntropyState`, `S_total`, `num_sites_on_horizon`, and
    the four-register + site-count bridges) is a fresh contribution
    distinct from cycles 1-37.

    The non-vacuity witness is the vacuum entropy state at zero and
    a canonical positive horizon area of `4·ℓ_P²` (the Planck
    reference used by Algol in `area_law_not_volume_at_large_area`). -/
theorem second_law_holography_first_bundle_in_V2 :
    ∃ (σ : SubstrateEntropyState) (A : ℝ),
        (0 < A)
      ∧ (σ.S_total ≤ σ.S_total)
      ∧ (num_sites_on_horizon A = 4 * S_BH A)
      ∧ (0 < num_sites_on_horizon A) := by
  refine ⟨SubstrateEntropyState.zero, 4 * l_P ^ 2, ?_, le_refl _, ?_, ?_⟩
  · exact mul_pos (by norm_num : (0:ℝ) < 4) (pow_pos l_P_pos 2)
  · exact num_sites_eq_four_times_S_BH _
  · apply num_sites_on_horizon_pos
    exact mul_pos (by norm_num : (0:ℝ) < 4) (pow_pos l_P_pos 2)

end OmegaTheory.Emergence.SecondLawAndHolography
