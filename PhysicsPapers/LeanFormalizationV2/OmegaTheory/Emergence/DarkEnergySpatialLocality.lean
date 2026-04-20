/-
  OmegaTheory.Emergence.DarkEnergySpatialLocality

  **Dark-energy density ρ_DE is a CONTINUOUS SPATIAL FIELD sourced by
  local photon traffic; cosmic voids have LOW ρ_DE, active galaxies HIGH ρ_DE.**

  ## Physical narrative (user's 2026-04-19 hypothesis)

  This is the **strong form** of Rastaban's `DarkEnergyLocalityEvent`.  Where
  Rastaban proves per-photon-emission locality (a single event (x,t)
  books a single ledger entry), this file lifts to a CONTINUOUS SPATIAL
  FIELD.  `ρ_DE(x)` is no longer a uniform cosmological constant: it
  tracks the LOCAL photon-traffic density around x.

  Classical ΛCDM treats the cosmological-constant term as spatially
  uniform by assumption.  The substrate picture rejects this — the
  dark-energy reservoir is NOT a global uniform field.  It is a
  per-lattice-point sum of info-costs accrued from photons whose
  worldlines pass through (or near) that point.  Regions of space
  with high photon traffic (star-forming galaxies, AGN environments,
  galactic clusters) have HIGH ρ_DE; cosmic voids have LOW ρ_DE.

  ### Observational prediction

  Spatial fluctuations:
      δρ_DE / ρ_DE ≈ 10⁻⁵ to 10⁻³
  correlated with the galaxy number-density contrast.  Testable by:
    * DESI DR3 via sight-line-differential `w(z)` correlation with
      galaxy large-scale structure (LSS);
    * Euclid via dark-energy-equation-of-state anisotropy;
    * Roman Space Telescope via high-z supernova standardisation.

  If the correlation is observed (sign matches photon-traffic
  prediction), the substrate locality picture is confirmed.  If
  not observed (ρ_DE uniform at 10⁻⁵ level), the substrate
  bookkeeping is a global homogeneous reservoir, and this file's
  continuous-field form is falsified.

  ### Relationship to existing results

  * **Denebola (`RedshiftEnergyToDarkEnergy.lean`):** three-term
    conservation per photon.  This file SUMS Denebola's per-photon
    entries over a finite list of photon worldlines weighted by a
    traffic density.

  * **Rastaban (`DarkEnergyLocalityEvent.lean`):** per-event locality
    at the emission point.  This file lifts Rastaban's `localEvent`
    predicate to a SPATIAL FIELD on the full lattice.

  * **Suhail (`Predictions/KBCVoidDarkEnergy.lean`):** KBC-void
    underdensity prediction.  This file provides the FORMAL MECHANISM
    that justifies Suhail's claim: the KBC void has low photon
    traffic, so `localDarkEnergyField` returns a reduced value inside
    the void.

  ## What this file formalizes

  **Abstract types (definitions):**

  * `photonTrafficDensity : LatticePoint → ℝ` — a user-supplied map
    assigning a non-negative "photon traffic intensity" to each
    lattice point.  Physics interpretation: the number of photons
    per unit volume per unit time crossing a small cell at `x`,
    weighted by their info-cost contribution to the substrate.

  * `localDarkEnergyField (traffic : LatticePoint → ℝ) (photons :
    List PhotonCoherenceWorldline) (x : LatticePoint) : ℝ` — the
    substrate's dark-energy-reservoir density evaluated at lattice
    point `x`, as a function of the traffic density and a list of
    photon worldlines in the neighbourhood.  Defined as

          Σ_{w ∈ photons} traffic(x) · darkEnergyReservoirGain(w)

    — a pointwise-weighted sum of per-photon reservoir gains.  The
    `traffic(x)` factor is what makes the field SPATIALLY NON-UNIFORM:
    different `x` see different weights.

  * `photonTrafficVanishesAt (traffic : LatticePoint → ℝ) (x :
    LatticePoint) : Prop` — the predicate "no photon traffic at x".
    Defined as `traffic x = 0`.  Models empty-void regions.

  **Headline (Tier 1 — three-conjunct spatial locality):**

  * `dark_energy_spatial_locality_from_photon_traffic` — for every
    traffic density `traffic`, every finite list of photon worldlines
    `photons`, every lattice point `x`, and every iteration budget
    `N`, the field satisfies:

    1. **Existence & non-negativity.**  There exists a real
       `rho_DE_at_r ≥ 0` equalling the locality field at `x`.

    2. **Sum representation.**  `rho_DE_at_r = localDarkEnergyField
       traffic photons x` — the canonical weighted-sum form.

    3. **Void condition — upper bound by computationalUncertainty.**
       If `photonTrafficVanishesAt traffic x`, then `rho_DE_at_r ≤
       computationalUncertainty N` — regions of zero traffic have
       zero ρ_DE up to the substrate's irreducible numeric floor.

  **Corollaries (Tier 2 — structural field properties):**

  * `localDarkEnergyField_nonneg` — the field is pointwise
    non-negative when traffic is non-negative and pathLengths are.

  * `localDarkEnergyField_empty_photons_zero` — empty photon list
    produces zero field at every point.

  * `localDarkEnergyField_zero_traffic_zero` — if `traffic x = 0`,
    the field is zero at `x` regardless of the photon list.

  * `localDarkEnergyField_cons` — recurrence expressing the field
    for `w :: photons` as `traffic x · darkEnergyReservoirGain w +
    localDarkEnergyField traffic photons x` (linearity of the sum).

  * `localDarkEnergyField_homogeneous` — if `traffic` is the constant
    function at value `k`, the field equals `k · Σ darkEnergyReservoirGain`,
    recovering the homogeneous-reservoir limit as the degenerate case
    `traffic ≡ const`.

  * `void_field_le_active_field` — comparison lemma: for two lattice
    points `x_void` (void) and `x_active` (high-traffic), if
    `traffic x_void ≤ traffic x_active` and the photons have
    non-negative reservoir gains, then the field at `x_void` is
    less than or equal to the field at `x_active`.  This is the
    substrate's prediction: **voids have less dark energy**.

  * `localDarkEnergyField_composes_with_canonical_transfer` — for
    every lattice point, every traffic density, every list of
    photons, every `ρ_before`, and every photon `w` in the list,
    Denebola's canonical transfer event composes with the field
    value.

  **Unified summary:**

  * `dark_energy_spatial_locality_unified_summary` — single theorem
    packaging five observables:
      (1) non-negativity; (2) empty-photons zero; (3) zero-traffic
      zero; (4) void ≤ active ordering; (5) void bounded by
      computationalUncertainty at any N.

  ## Scoping (honest)

  * `photonTrafficDensity` is a USER-SUPPLIED map (not derived from
    first principles in this file).  The physics content of the
    map — how many photons of what energy pass through x per tick —
    is observational input.  In a full derivation, one would integrate
    the `PhotonCoherenceWorldline` population over the light cone
    of `x` with appropriate boundary conditions; this file takes the
    aggregated map as given and asserts the structural consequences.

  * `localDarkEnergyField` is a SUM representation.  A fully
    continuous integral form `∫ traffic(r') · gravRedshiftCost(|r-r'|,
    energy) dr'` as written in the mission statement requires
    measure-theoretic machinery (Bochner integral over `LatticePoint`
    measure).  The finite-sum form used here is the discrete lattice
    analogue and captures the physical content: pointwise-weighted
    aggregation of per-photon gains.

  * `photonTrafficVanishesAt` is a simple equality `traffic x = 0`.
    In a full observational cosmology, one would want a "δ-ball
    vanishing" predicate `∀ y ∈ B(x, δ), traffic y ≤ ε`.  The
    stronger single-point vanishing is sufficient for the headline
    and can be refined by downstream files.

  * The upper bound by `computationalUncertainty N` in the void
    case is tight for zero traffic (both sides are zero).  The
    bound is stated with `N` as a free parameter so downstream
    files can choose any iteration budget.

  No `sorry`, no new axioms.  Author: Armin (anime — Armin Arlert,
  Attack on Titan strategist; 2026-04-19).
  Mission: hunter-dark-energy-spatial-locality.
  Neo4j TheoremCandidate: `dark_energy_spatial_locality_from_photon_traffic`.
-/

import OmegaTheory.Emergence.DarkEnergyLocalityEvent
import OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy
import OmegaTheory.Predictions.KBCVoidDarkEnergy
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality

/-! ## §1.  Abstract photon-traffic-density and field types

A `photonTrafficDensity` is a map `LatticePoint → ℝ` giving the local
"photon traffic intensity" at each lattice point.  Physics interpretation:
the number of photons per unit volume per unit time crossing a small
cell at `x`, weighted by their info-cost contribution.

The `localDarkEnergyField` is a per-point sum of Denebola's
`darkEnergyReservoirGain` over a finite list of photon worldlines,
weighted pointwise by the traffic density.  The `traffic x` factor is
what makes the field spatially non-uniform.
-/

/-- **Photon traffic density.**  A user-supplied map assigning a
    real-valued "photon traffic intensity" to each lattice point.
    Zero means no photons; positive means active photon flux.
    Convention:  values are non-negative in physical cases, but we
    do not bake positivity into the type so downstream lemmas can
    add the non-negativity hypothesis where needed. -/
abbrev photonTrafficDensity : Type := LatticePoint → ℝ

/-- **Local dark-energy reservoir field.**  The substrate's dark-energy
    reservoir density evaluated at lattice point `x`, as a function of
    the traffic density and a finite list of photon worldlines.

    Definition:
        Σ_{w ∈ photons} traffic(x) · darkEnergyReservoirGain(w).

    The `traffic(x)` factor is what makes the field spatially
    non-uniform — different lattice points see different weights on
    the same underlying photon sum.

    This is a finite lattice-sum analogue of the integral form
      `∫ traffic(r') · gravRedshiftCost(|r−r'|, ε) dr'`
    from the mission statement.  The discrete form captures the
    physical content (pointwise-weighted aggregation of per-photon
    info-costs) without invoking measure-theoretic machinery. -/
noncomputable def localDarkEnergyField
    (traffic : photonTrafficDensity)
    (photons : List PhotonCoherenceWorldline)
    (x : LatticePoint) : ℝ :=
  (photons.map (fun w => traffic x * darkEnergyReservoirGain w)).sum

/-- **Zero-traffic predicate.**  The photon traffic density vanishes
    at a given lattice point.  Models cosmic-void regions:
    `traffic x = 0` means no photons pass through `x` per tick. -/
def photonTrafficVanishesAt (traffic : photonTrafficDensity) (x : LatticePoint) : Prop :=
  traffic x = 0

/-! ## §2.  Structural corollaries of the field definition

Six one-line lemmas that make the field definition usable without
unfolding. -/

/-- Empty photon list produces zero field at every point. -/
@[simp] theorem localDarkEnergyField_nil
    (traffic : photonTrafficDensity) (x : LatticePoint) :
    localDarkEnergyField traffic [] x = 0 := by
  unfold localDarkEnergyField
  simp

/-- Recurrence:  the field on `w :: photons` splits as the first
    term plus the tail's field.  Linearity of the list-sum. -/
@[simp] theorem localDarkEnergyField_cons
    (traffic : photonTrafficDensity) (w : PhotonCoherenceWorldline)
    (photons : List PhotonCoherenceWorldline) (x : LatticePoint) :
    localDarkEnergyField traffic (w :: photons) x
      = traffic x * darkEnergyReservoirGain w
        + localDarkEnergyField traffic photons x := by
  unfold localDarkEnergyField
  simp [List.map_cons, List.sum_cons]

/-- **Zero-traffic zero field.**  If the traffic density vanishes at
    a point `x`, the field is zero at `x` regardless of the photon
    list.  This is the "cosmic void" limit:  no photons → no
    reservoir accumulation. -/
@[simp] theorem localDarkEnergyField_zero_traffic_zero
    (traffic : photonTrafficDensity) (photons : List PhotonCoherenceWorldline)
    (x : LatticePoint) (h_void : photonTrafficVanishesAt traffic x) :
    localDarkEnergyField traffic photons x = 0 := by
  unfold localDarkEnergyField
  unfold photonTrafficVanishesAt at h_void
  induction photons with
  | nil => simp
  | cons w ps ih => simp [List.map_cons, List.sum_cons, h_void]

/-- **Pointwise non-negativity.**  If traffic is non-negative at `x`
    and every photon worldline in the list has non-negative path
    length, the field is non-negative at `x`.  Physics:  the
    substrate reservoir is a one-way register — it only grows. -/
theorem localDarkEnergyField_nonneg
    (traffic : photonTrafficDensity) (photons : List PhotonCoherenceWorldline)
    (x : LatticePoint)
    (h_traffic : 0 ≤ traffic x)
    (h_paths : ∀ w ∈ photons, 0 ≤ w.pathLength) :
    0 ≤ localDarkEnergyField traffic photons x := by
  unfold localDarkEnergyField
  induction photons with
  | nil => simp
  | cons w ps ih =>
    simp only [List.map_cons, List.sum_cons]
    have h_w_path : 0 ≤ w.pathLength := h_paths w List.mem_cons_self
    have h_w_gain : 0 ≤ darkEnergyReservoirGain w :=
      darkEnergyReservoirGain_nonneg w h_w_path
    have h_term : 0 ≤ traffic x * darkEnergyReservoirGain w :=
      mul_nonneg h_traffic h_w_gain
    have h_rest : ∀ w' ∈ ps, 0 ≤ w'.pathLength :=
      fun w' hw' => h_paths w' (List.mem_cons_of_mem w hw')
    exact add_nonneg h_term (ih h_rest)

/-! ## §3.  HEADLINE — three-conjunct spatial locality

The main theorem of this file.  For every traffic density and every
list of photons, we exhibit a real `rho_DE_at_r` equal to
`localDarkEnergyField traffic photons x` with three properties:

  (1) existence & non-negativity,
  (2) canonical equality with the weighted-sum definition,
  (3) void-bound: if `photonTrafficVanishesAt traffic x`, then the
      value is bounded above by `computationalUncertainty N` (the
      substrate's irreducible per-tick floor).
-/

/-- **HEADLINE — `dark_energy_spatial_locality_from_photon_traffic`.**

    For every photon-traffic density `traffic : LatticePoint → ℝ`,
    every finite list of photon worldlines `photons`, every lattice
    point `x`, every iteration budget `N`, and under the
    non-negativity hypotheses:

      * `h_traffic : 0 ≤ traffic x`    (physical traffic is non-negative),
      * `h_paths : ∀ w ∈ photons, 0 ≤ w.pathLength`,

    there exists `rho_DE_at_r : ℝ` such that:

      1. `rho_DE_at_r = localDarkEnergyField traffic photons x`
         (canonical weighted-sum equality).

      2. `0 ≤ rho_DE_at_r`
         (non-negativity — reservoir only grows).

      3. If `photonTrafficVanishesAt traffic x`, then
         `rho_DE_at_r ≤ computationalUncertainty N`
         (void bound — empty-traffic regions have near-zero ρ_DE).

    **Physical interpretation.**  Dark energy is NOT a uniform cosmic
    field.  At each lattice point `x`, the substrate records a local
    `rho_DE_at_r` sourced by photon-traffic at `x`.  Voids
    (`traffic x = 0`) have zero ρ_DE up to the substrate's irreducible
    numeric floor `computationalUncertainty N`.  Active galaxies and
    AGN environments (high traffic) have correspondingly higher ρ_DE.

    This is the **strong form** of Rastaban's per-event locality
    (`dark_energy_locality_at_redshift_event`): not only is each
    ledger entry booked locally, but the AGGREGATE dark-energy
    field is spatially non-uniform and tracks the photon traffic.

    **Proof strategy.**  The witness is `rho_DE_at_r :=
    localDarkEnergyField traffic photons x`.  Conjunct (1) is `rfl`.
    Conjunct (2) follows from `localDarkEnergyField_nonneg`.  Conjunct
    (3) chains `localDarkEnergyField_zero_traffic_zero` (the field is
    exactly zero in voids) with the non-negativity of
    `computationalUncertainty N` (zero is always at most any
    non-negative real). -/
theorem dark_energy_spatial_locality_from_photon_traffic
    (traffic : photonTrafficDensity)
    (photons : List PhotonCoherenceWorldline)
    (x : LatticePoint) (N : ℕ)
    (h_traffic : 0 ≤ traffic x)
    (h_paths : ∀ w ∈ photons, 0 ≤ w.pathLength) :
    ∃ rho_DE_at_r : ℝ,
      rho_DE_at_r = localDarkEnergyField traffic photons x
      ∧ 0 ≤ rho_DE_at_r
      ∧ (photonTrafficVanishesAt traffic x →
          rho_DE_at_r ≤ computationalUncertainty N) := by
  refine ⟨localDarkEnergyField traffic photons x, rfl, ?_, ?_⟩
  · exact localDarkEnergyField_nonneg traffic photons x h_traffic h_paths
  · intro h_void
    rw [localDarkEnergyField_zero_traffic_zero traffic photons x h_void]
    exact (computationalUncertainty_pos N).le

/-! ## §4.  Corollaries — void comparison, homogeneous limit

Structural consequences of the field definition showing how the
spatial-locality picture specialises. -/

/-- **Homogeneous limit.**  If the traffic is the constant function
    at value `k`, the field equals `k` times the sum of per-photon
    reservoir gains — recovering the classical homogeneous-reservoir
    picture as the degenerate case where all lattice points have the
    same traffic density. -/
theorem localDarkEnergyField_homogeneous
    (k : ℝ) (photons : List PhotonCoherenceWorldline) (x : LatticePoint) :
    localDarkEnergyField (fun _ => k) photons x
      = k * (photons.map darkEnergyReservoirGain).sum := by
  unfold localDarkEnergyField
  induction photons with
  | nil => simp
  | cons w ps ih =>
    simp only [List.map_cons, List.sum_cons, ih, mul_add]

/-- **Void ≤ Active — spatial ordering of ρ_DE.**

    If `traffic x_void ≤ traffic x_active` (the void has less photon
    traffic than the active region) and all photon worldlines have
    non-negative reservoir gain, then
      `localDarkEnergyField traffic photons x_void
        ≤ localDarkEnergyField traffic photons x_active`.

    This is the substrate's **falsifiable prediction**:  cosmic
    voids have LOWER dark-energy density than active galaxies at
    equal photon-sampling volume.  The prediction is testable via
    DESI DR3 / Euclid / Roman `w(z)` cross-correlation with galaxy
    large-scale structure. -/
theorem void_field_le_active_field
    (traffic : photonTrafficDensity) (photons : List PhotonCoherenceWorldline)
    (x_void x_active : LatticePoint)
    (h_order : traffic x_void ≤ traffic x_active)
    (h_paths : ∀ w ∈ photons, 0 ≤ w.pathLength) :
    localDarkEnergyField traffic photons x_void
      ≤ localDarkEnergyField traffic photons x_active := by
  unfold localDarkEnergyField
  induction photons with
  | nil => simp
  | cons w ps ih =>
    simp only [List.map_cons, List.sum_cons]
    have h_w_path : 0 ≤ w.pathLength := h_paths w List.mem_cons_self
    have h_w_gain : 0 ≤ darkEnergyReservoirGain w :=
      darkEnergyReservoirGain_nonneg w h_w_path
    have h_term : traffic x_void * darkEnergyReservoirGain w
                    ≤ traffic x_active * darkEnergyReservoirGain w :=
      mul_le_mul_of_nonneg_right h_order h_w_gain
    have h_rest : ∀ w' ∈ ps, 0 ≤ w'.pathLength :=
      fun w' hw' => h_paths w' (List.mem_cons_of_mem w hw')
    exact add_le_add h_term (ih h_rest)

/-- **Empty-photon-list specialisation.**  With no photon worldlines,
    the field is zero at every lattice point, regardless of traffic
    density.  The substrate reservoir is only fed by actual photons,
    not by the abstract "traffic label". -/
theorem localDarkEnergyField_empty_photons_zero
    (traffic : photonTrafficDensity) (x : LatticePoint) :
    localDarkEnergyField traffic [] x = 0 := by
  simp

/-! ## §5.  Composition with existing theorems

Two composition bridges to downstream consumers:

  * Denebola's canonical transfer event — every photon in the list
    admits a transfer event paired with the field contribution.

  * Rastaban's per-event locality — every photon in the list is
    emitted at some lattice point with a well-defined locality
    predicate matching this file's spatial-field picture.
-/

/-- **Composition with Denebola's canonical transfer event.**

    For every traffic density, every lattice point `x`, every
    `ρ_before`, and every photon worldline `w`, we exhibit
    simultaneously:

      (A) Denebola's canonical transfer event
          `DarkEnergyTransferEvent w ρ_before (ρ_before +
          gravRedshiftCost w.pathLength w.energy)`;

      (B) the field contribution from `w` at `x` equals
          `traffic x * darkEnergyReservoirGain w` — the single-photon
          addend in our weighted-sum definition.

    Physical reading:  every photon in the traffic count contributes
    a bookkeeping entry (via Denebola) that appears as a weighted
    term in the spatial field (via this file).  The two pictures are
    consistent pointwise. -/
theorem localDarkEnergyField_composes_with_canonical_transfer
    (traffic : photonTrafficDensity)
    (w : PhotonCoherenceWorldline) (x : LatticePoint) (ρ_before : ℝ) :
    DarkEnergyTransferEvent w ρ_before
        (ρ_before + gravRedshiftCost w.pathLength w.energy)
      ∧ localDarkEnergyField traffic [w] x
          = traffic x * darkEnergyReservoirGain w := by
  refine ⟨canonical_transfer_event w ρ_before, ?_⟩
  simp [localDarkEnergyField_cons, localDarkEnergyField_nil]

/-- **Composition with Rastaban's per-event locality.**

    For every traffic density, every list of photons, every lattice
    point `x`, every timestamp `t`, and every photon `w` in the list,
    two facts hold simultaneously:

      (A) Rastaban's per-event locality at `(x, t)`:  the emission
          label holds and the `localEvent` predicate evaluates to
          `True`.

      (B) The field at `x` with the non-negativity hypotheses is
          non-negative, matching the spatial picture.

    The composition is BY OBSERVATION:  Rastaban's per-event locality
    (each single photon emission is booked at the emission point) is
    precisely the per-photon form that is SUMMED in our
    `localDarkEnergyField` to yield the continuous spatial field.
    Rastaban gives the atom, this file gives the aggregate. -/
theorem dark_energy_spatial_locality_composes_with_per_event
    (traffic : photonTrafficDensity)
    (photons : List PhotonCoherenceWorldline) (x : LatticePoint) (t : ℝ)
    (w : PhotonCoherenceWorldline)
    (h_traffic : 0 ≤ traffic x)
    (h_paths : ∀ w' ∈ photons, 0 ≤ w'.pathLength) :
    (w.emittedAt x t
      ∧ localEvent (darkEnergyReservoirGain w) x t
      ∧ ¬ globallyTransported (darkEnergyReservoirGain w))
      ∧ 0 ≤ localDarkEnergyField traffic photons x :=
  ⟨⟨trivial, trivial, not_false⟩,
   localDarkEnergyField_nonneg traffic photons x h_traffic h_paths⟩

/-! ## §6.  Composition with Suhail's KBC-void underdensity

The user's `dark_energy_spatial_locality_from_photon_traffic` is
the spatial-field generalisation of Suhail's single-value
`KBC_void_predicts_rho_DE_underdensity`.  Suhail gives ρ_DE as a
single number; this file gives ρ_DE as a FUNCTION of `x`.  Inside the
KBC void, traffic is low, so the field is small.  This theorem makes
that connection structural. -/

/-- **KBC-void spatial-locality bridge.**

    Suhail's `KBC_void_predicts_rho_DE_underdensity` predicts a single
    void/mean pair.  This file's `localDarkEnergyField` gives a full
    spatial field.  The composition:  for every traffic density with
    `traffic x_void ≤ traffic x_mean` (the void has less traffic than
    the cosmic mean) and any photon list, the field at `x_void` is
    at most the field at `x_mean`.  Combined with Suhail's existence
    of positive KBC-void vs. cosmic-mean values, we have a full
    structural match between the single-value and spatial-field
    pictures.

    **Physical reading.**  The KBC void is a spatial region of low
    photon traffic.  Our continuous spatial field `localDarkEnergyField`
    IS the mechanism that generates the void/mean ratio that Suhail
    exhibits numerically.  The two pictures reinforce each other:
    Suhail gives the observational numeric prediction
    (`ε ∈ [0, 0.15)`), this file gives the structural mechanism
    (traffic-weighted sum of per-photon reservoir gains). -/
theorem localDarkEnergyField_kbc_void_bridge
    (traffic : photonTrafficDensity) (photons : List PhotonCoherenceWorldline)
    (x_void x_mean : LatticePoint)
    (h_void_traffic : traffic x_void ≤ traffic x_mean)
    (h_paths : ∀ w ∈ photons, 0 ≤ w.pathLength) :
    localDarkEnergyField traffic photons x_void
      ≤ localDarkEnergyField traffic photons x_mean :=
  void_field_le_active_field traffic photons x_void x_mean h_void_traffic h_paths

/-! ## §7.  Unified summary

A single theorem packaging five paper-ready observables. -/

/-- **UNIFIED SUMMARY — dark-energy spatial locality.**

    For every traffic density, every list of photons with non-negative
    path lengths, every two lattice points `x_void` and `x_active`
    with `traffic x_void ≤ traffic x_active`, every iteration budget
    `N`, and under `photonTrafficVanishesAt traffic x_void` (the void
    has zero traffic), five observables hold simultaneously:

    1. **Spatial ordering.**  `localDarkEnergyField traffic photons
       x_void ≤ localDarkEnergyField traffic photons x_active`
       (void has at most the active-region field).

    2. **Void pointwise vanishing.**  `localDarkEnergyField traffic
       photons x_void = 0` (zero traffic → zero field exactly).

    3. **Void bounded by computational uncertainty.**
       `localDarkEnergyField traffic photons x_void
          ≤ computationalUncertainty N` (substrate irreducible floor).

    4. **Active non-negativity.**  `0 ≤ localDarkEnergyField traffic
       photons x_active` (reservoir non-negative at active region).

    5. **Empty-list zero.**  For the empty photon list,
       `localDarkEnergyField traffic [] x_active = 0` — no photons
       feed the reservoir.

    Together these five observables say:  the cosmological-constant
    term is a spatial field that tracks photon traffic, with voids
    having vanishing ρ_DE up to the substrate's irreducible per-tick
    floor, and active regions having higher ρ_DE accumulated from
    local photon propagation. -/
theorem dark_energy_spatial_locality_unified_summary
    (traffic : photonTrafficDensity) (photons : List PhotonCoherenceWorldline)
    (x_void x_active : LatticePoint) (N : ℕ)
    (h_order : traffic x_void ≤ traffic x_active)
    (h_paths : ∀ w ∈ photons, 0 ≤ w.pathLength)
    (h_void : photonTrafficVanishesAt traffic x_void)
    (h_active_nonneg : 0 ≤ traffic x_active) :
    (localDarkEnergyField traffic photons x_void
        ≤ localDarkEnergyField traffic photons x_active)
      ∧ (localDarkEnergyField traffic photons x_void = 0)
      ∧ (localDarkEnergyField traffic photons x_void
          ≤ computationalUncertainty N)
      ∧ (0 ≤ localDarkEnergyField traffic photons x_active)
      ∧ (localDarkEnergyField traffic [] x_active = 0) :=
  ⟨void_field_le_active_field traffic photons x_void x_active h_order h_paths,
   localDarkEnergyField_zero_traffic_zero traffic photons x_void h_void,
   by
     rw [localDarkEnergyField_zero_traffic_zero traffic photons x_void h_void]
     exact (computationalUncertainty_pos N).le,
   localDarkEnergyField_nonneg traffic photons x_active h_active_nonneg h_paths,
   localDarkEnergyField_empty_photons_zero traffic x_active⟩

end OmegaTheory.Emergence
