/-
  OmegaTheory.Emergence.PhotonSpeedCoherence

  **Photon preserves c locally, loses information coherence globally.**

  ## Physical narrative (user's central thesis)

  A photon on the OmegaTheory substrate **does NOT slow down**.  At every
  lattice point the local propagation velocity is exactly `c`:  each
  Planck tick advances the photon by one spatial cell, no more, no less.
  This is the lattice content of "c is the substrate speed".

  Yet a photon traversing a region of non-zero healed-vacuum Ricci
  curvature (gravitational smoothness parameter `μ > 0`) acquires a
  **total information cost** along its worldline — the accumulated
  KL-divergence bound that the lattice spends to keep the photon
  consistent with the locally curved geometry.  At the bound level this
  total equals precisely `gravRedshiftCost w.pathLength w.energy`
  (Bellatrix 2026-04-19, `ProtonPhotonRedshift.lean`).

  The user's physical insight:
    **Energy loss (redshift) and information-shift (coherence drift)
      are two facets of the same substrate cost.**
    Speed invariance (local `v = c`) is preserved;
    global information coherence (the photon's reconstructed quantum
    state at the observer) is what pays the substrate cost.

  The two facets are unified in the single statement:

      (∀ p ∈ w.points, localPropagationVelocity w p = c)
        ∧ informationCost w = gravRedshiftCost w.pathLength w.energy

  Both conjuncts hold *simultaneously* for every photon worldline
  whose `defectBound` saturates the healed-vacuum Ricci ceiling
  `ℓ_P / (2·μ)`.  The first conjunct is trivial once the lattice
  definition is unfolded (`localPropagationVelocity := c`); the second
  is an algebraic identity that composes `PhotonWorldline.informationCost`
  with `vacuumResidualInformationCost` via the saturating choice of
  `defectBound`.

  ## What this file formalizes

  **Structure:**
  * `PhotonCoherenceWorldline` — a `PhotonWorldline` enriched with an
    `energy : ℝ` field (the local healed-vacuum smoothness `μ > 0`)
    and a list of `points` the photon passes through.  The key
    constraint `defectBound = ℓ_P / (2·energy)` saturates the Ricci
    bound along the worldline.

  **Headline:**
  * `photon_preserves_c_loses_info_coherence` (Tier 1) — the two
    conjuncts packaged as a single `And` statement:
      - `∀ p ∈ w.points, localPropagationVelocity w p = c`  (speed)
      - `w.informationCost = gravRedshiftCost w.pathLength w.energy`
                                                          (info-cost)

  **Corollaries (Tier 2, three explicit bridges):**
  * `photon_speed_invariance` — (a) speed invariance as a standalone
    fact.  Folds in the `c_pos` positivity for downstream use.
  * `photon_energy_info_duality` — (b) the second conjunct viewed as
    the substrate analog of Pound-Rebka: the photon's integrated
    information deficit equals the gravitational redshift cost.
  * `photon_info_cost_path_integrated` — (c) the redshift *is* a
    path-integrated substrate cost.  States explicitly that
    `informationCost w = (ℓ_P / (2·w.energy)) · w.pathLength`.

  **Tier 3 — flat-space sanity and scaling:**
  * `photon_coherence_flat_vacuum` — when `pathLength = 0` the
    information cost vanishes (consistent with no-propagation).
  * `photon_coherence_rate_scales_inverse_energy` — higher smoothness
    `μ` means smaller per-unit-path cost (the ceiling `ℓ_P/(2μ)`).

  ## Scoping (honest)

  * We model the photon worldline as a finite list of lattice points
    `points : List ℝ` (abstract positions along the path).  The
    `localPropagationVelocity` is defined as the constant `c`, which
    is the *definition* of "one spatial cell per Planck tick" — the
    lattice content of light-speed invariance.  A more refined
    definition that derives `v = c` from the underlying causal-lattice
    structure (`Spacetime.CausalLattice`) is a future refinement; the
    present definition is the one the mission spec literally requests.

  * The saturating constraint `defectBound = ℓ_P / (2·energy)` picks
    the specific worldline whose integrated KL-cost saturates the
    vacuum Ricci ceiling (the physically most-extended photon).  This
    matches `RedshiftFloor.vacuumWorldline` (Bellatrix) with
    `mu = energy`, `L = pathLength`.  For sub-saturating photons the
    second conjunct becomes an inequality (`≤` rather than `=`); we
    deliver the `=` form because the user's thesis is that the two
    facets are *the same cost*, not merely that one bounds the other.

  No `sorry`, no new axioms.
  Author: Canopus (2026-04-19).
-/

import OmegaTheory.Emergence.Redshift
import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Predictions.RedshiftFloor
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Predictions

/-! ## §1.  The enriched worldline structure

We attach to a `PhotonWorldline` the two extra pieces of data the
mission statement asks about:
  * `points : List ℝ` — the sequence of lattice positions the photon
    visits.  Abstract; only its membership relation is used.
  * `energy : ℝ` — the healed-vacuum smoothness parameter `μ > 0` of
    the region the photon traverses.  Named "energy" in the mission
    spec because the gravitational redshift's leading-order magnitude
    scales as `ℓ_P / (2·μ)` per unit path, which is the per-photon
    energy-loss rate.

We add the structural constraint that the `defectBound` along the
worldline equals `ℓ_P / (2·energy)`:  the photon saturates the Ricci
ceiling at every tick.  This is the "extended" (physically most-costly)
photon of the worldline family.
-/

/-- A `PhotonWorldline` enriched with a list of lattice `points` and a
    healed-vacuum `energy` (smoothness `μ > 0`), carrying the
    saturating constraint `defectBound = ℓ_P / (2·energy)`. -/
structure PhotonCoherenceWorldline extends PhotonWorldline where
  /-- Lattice points visited by the photon along its worldline. -/
  points : List ℝ
  /-- Healed-vacuum smoothness parameter (`μ > 0`).  Named `energy` in
      the mission spec because the per-unit-path information cost
      scales as `ℓ_P / (2·energy)`, which is the photon's
      gravitational energy-loss rate. -/
  energy : ℝ
  /-- The smoothness parameter is positive. -/
  energy_pos : 0 < energy
  /-- Saturating constraint:  the defect bound realises the vacuum
      Ricci ceiling `ℓ_P / (2·energy)` at every tick along the
      worldline.  This selects the physically most-extended photon
      of the worldline family. -/
  defectBound_saturates : defectBound = l_P / (2 * energy)

namespace PhotonCoherenceWorldline

/-- **Local propagation velocity of a photon at a lattice point.**
    On the OmegaTheory substrate, each Planck tick advances the photon
    by exactly one spatial cell.  The local propagation velocity is
    therefore the constant `c` (the definition of "substrate speed of
    light"), independent of the lattice point `p`.

    This is the lattice content of special-relativistic light-speed
    invariance:  photons do NOT slow down, whether the local geometry
    is flat or curved.  Curvature enters through the *information cost*
    paid by the substrate to keep the photon consistent (see
    `informationCost`), not through the velocity. -/
noncomputable def localPropagationVelocity
    (_w : PhotonCoherenceWorldline) (_p : ℝ) : ℝ :=
  c

/-- `localPropagationVelocity` is positive (inherits `c_pos`). -/
theorem localPropagationVelocity_pos
    (w : PhotonCoherenceWorldline) (p : ℝ) :
    0 < localPropagationVelocity w p := by
  unfold localPropagationVelocity
  exact c_pos

/-- `localPropagationVelocity` is independent of the lattice point.
    (Speed invariance: same `c` at every `p`.) -/
theorem localPropagationVelocity_constant
    (w : PhotonCoherenceWorldline) (p q : ℝ) :
    localPropagationVelocity w p = localPropagationVelocity w q := by
  rfl

end PhotonCoherenceWorldline

/-! ## §2.  Headline theorem — speed invariance AND info-coherence loss

The central statement of this file.  Both conjuncts are provable by
unfolding:
  * speed invariance:  `localPropagationVelocity w p = c` is `rfl`
    for every `p`, so the universally-quantified conjunct is trivial.
  * info-coherence loss:  `informationCost w = defectBound * pathLength`
    by definition, and `defectBound = ℓ_P / (2·energy)` by the
    saturating constraint, matching the definition of
    `gravRedshiftCost` as `(ℓ_P / (2·mu)) · L`.
-/

/-- **HEADLINE — `photon_preserves_c_loses_info_coherence`.**

    For every `PhotonCoherenceWorldline` `w`:

    1. At every lattice point `p ∈ w.points`, the local propagation
       velocity is exactly `c` (**photons do NOT slow down**).

    2. The total information cost `w.informationCost` equals the
       gravitational redshift cost
       `gravRedshiftCost w.pathLength w.energy` (**energy loss and
       info-coherence shift are two facets of the same substrate
       cost**).

    Both facts hold simultaneously.  The first is speed invariance at
    the lattice level; the second is Pound-Rebka at the information-
    cost level.  Unifying the two: **photons preserve `c` but lose
    information coherence, and the information deficit equals the
    gravitational energy loss.** -/
theorem photon_preserves_c_loses_info_coherence
    (w : PhotonCoherenceWorldline) :
    (∀ p ∈ w.points, PhotonCoherenceWorldline.localPropagationVelocity w p = c)
      ∧ w.informationCost = gravRedshiftCost w.pathLength w.energy := by
  refine ⟨?_, ?_⟩
  · -- Speed invariance:  `localPropagationVelocity` is the constant `c`.
    intro p _
    rfl
  · -- Info cost = gravitational redshift cost.
    -- By definition:  informationCost = defectBound * pathLength.
    -- By the saturating constraint:  defectBound = l_P / (2 * energy).
    -- By definition:  gravRedshiftCost L μ = vacuumResidualInformationCost L μ
    --                                     = (l_P / (2 * μ)) * L.
    unfold PhotonWorldline.informationCost gravRedshiftCost
      vacuumResidualInformationCost
    rw [w.defectBound_saturates]

/-! ## §3.  Corollaries — the three explicit bridges

We split the two conjuncts into standalone theorems and record a third
explicit identity:  the information cost *is* the product
`(ℓ_P / (2·energy)) · pathLength`.
-/

/-- **Corollary (a) — speed invariance, standalone.**  The photon's
    local propagation velocity is `c` at every point of its worldline.

    This is the pure-speed half of the headline, exposed without the
    info-cost conjunct for downstream composition. -/
theorem photon_speed_invariance
    (w : PhotonCoherenceWorldline) :
    ∀ p ∈ w.points,
      PhotonCoherenceWorldline.localPropagationVelocity w p = c := by
  intro p _
  rfl

/-- **Corollary (a') — speed invariance at the level of positivity.**
    A restatement of (a) that makes the `c > 0` content explicit,
    useful as a hypothesis for downstream composition. -/
theorem photon_speed_positive
    (w : PhotonCoherenceWorldline) :
    ∀ p ∈ w.points,
      0 < PhotonCoherenceWorldline.localPropagationVelocity w p := by
  intro p _
  exact PhotonCoherenceWorldline.localPropagationVelocity_pos w p

/-- **Corollary (b) — energy-info duality.**  The information cost
    equals the gravitational redshift cost.

    Two distinct substrate observables (the KL-bound integrated along
    the worldline vs. the Ricci-ceiling integrated along the same
    path) coincide exactly.  This is the user's central physics
    intuition:  *energy loss and info-shift are the same cost.* -/
theorem photon_energy_info_duality
    (w : PhotonCoherenceWorldline) :
    w.informationCost = gravRedshiftCost w.pathLength w.energy :=
  (photon_preserves_c_loses_info_coherence w).2

/-- **Corollary (c) — redshift as path-integrated cost.**  The
    information cost is the explicit product
    `(ℓ_P / (2·energy)) · pathLength`.

    This is the fully-unfolded form of corollary (b):  the substrate
    cost is *linear* in the path length, with slope equal to the
    Ricci-ceiling-per-unit-path `ℓ_P / (2·μ)`.  Gravity shows up as a
    per-tick tax on photon coherence. -/
theorem photon_info_cost_path_integrated
    (w : PhotonCoherenceWorldline) :
    w.informationCost = (l_P / (2 * w.energy)) * w.pathLength := by
  rw [photon_energy_info_duality w]
  unfold gravRedshiftCost vacuumResidualInformationCost
  rfl

/-! ## §4.  Consistency — flat vacuum and non-negativity

The headline theorem must be consistent with the limiting cases. -/

/-- **Flat-vacuum limit.**  When the photon traverses no distance
    (`pathLength = 0`), the information cost vanishes.  This is the
    substrate analog of "no propagation, no redshift." -/
theorem photon_coherence_flat_vacuum
    (w : PhotonCoherenceWorldline) (hL : w.pathLength = 0) :
    w.informationCost = 0 := by
  rw [photon_info_cost_path_integrated w, hL, mul_zero]

/-- **Non-negativity.**  The information cost is always non-negative
    (it is a bound on a KL-divergence, which is itself non-negative). -/
theorem photon_coherence_nonneg
    (w : PhotonCoherenceWorldline) :
    0 ≤ w.informationCost :=
  w.toPhotonWorldline.informationCost_nonneg

/-- **Per-unit-path scaling.**  In a region of higher smoothness
    `energy`, the information cost per unit path is smaller
    (`ℓ_P/(2·energy)` is antitone in `energy`).  Physically:  a more
    slowly-varying gravitational field exacts a lower per-tick tax on
    photon coherence. -/
theorem photon_coherence_rate_scales_inverse_energy
    (w : PhotonCoherenceWorldline) (hL : 0 < w.pathLength) :
    w.informationCost / w.pathLength = l_P / (2 * w.energy) := by
  rw [photon_info_cost_path_integrated w]
  field_simp

/-! ## §5.  Bridge theorems — composition with upstream infrastructure

We expose explicit bridges to `gravRedshiftCost_nonneg`,
`gravRedshiftCost_pos`, and `gravRedshiftCost_zero_pathLength` from
`ProtonPhotonRedshift.lean` so downstream consumers can chain via the
saturating-worldline identity. -/

/-- **Bridge to `gravRedshiftCost_nonneg`.**  The photon's information
    cost inherits non-negativity from the gravitational redshift cost. -/
theorem photon_coherence_via_gravRedshiftCost_nonneg
    (w : PhotonCoherenceWorldline) (hL : 0 ≤ w.pathLength) :
    0 ≤ w.informationCost := by
  rw [photon_energy_info_duality w]
  exact gravRedshiftCost_nonneg w.pathLength w.energy hL w.energy_pos

/-- **Bridge to `gravRedshiftCost_pos`.**  For any photon traversing a
    non-trivial path (`pathLength > 0`) in a region of positive
    smoothness, the information cost is strictly positive.  Gravity
    *always* costs coherence on a non-empty worldline. -/
theorem photon_coherence_via_gravRedshiftCost_pos
    (w : PhotonCoherenceWorldline) (hL : 0 < w.pathLength) :
    0 < w.informationCost := by
  rw [photon_energy_info_duality w]
  exact gravRedshiftCost_pos w.pathLength w.energy hL w.energy_pos

/-- **Bridge to `gravRedshiftCost_zero_pathLength`.**  Zero path length
    forces zero information cost via the gravitational-redshift
    identity. -/
@[simp] theorem photon_coherence_zero_pathLength_of_gravRedshift
    (w : PhotonCoherenceWorldline) (hL : w.pathLength = 0) :
    w.informationCost = gravRedshiftCost 0 w.energy := by
  rw [photon_energy_info_duality w, hL]

/-! ## §6.  The unified summary

A single theorem that packages speed invariance, the energy-info
duality, non-negativity, and the explicit path-integral form.  This is
the "one-stop" reference for consumers who need all four facts about
a photon's coherence along a curved-space worldline. -/

/-- **UNIFIED SUMMARY — photon substrate coherence.**  For any
    photon coherence worldline `w`:

    1. **Speed invariance.**  `localPropagationVelocity w p = c` for
       every `p ∈ w.points` — photons do not slow down.

    2. **Energy-info duality.**  `informationCost w =
       gravRedshiftCost w.pathLength w.energy` — the KL-information
       deficit equals the gravitational redshift cost.

    3. **Path-integrated form.**  `informationCost w =
       (ℓ_P / (2·w.energy)) · w.pathLength` — gravity taxes photon
       coherence linearly in path length, at the Ricci-ceiling rate
       per unit path.

    4. **Non-negativity.**  `0 ≤ informationCost w` — coherence can
       only be *lost*, never gained (a substrate analog of the second
       law of information).

    All four facts are consequences of the saturating constraint
    `defectBound = ℓ_P / (2·energy)` and the upstream infrastructure
    of `PhotonWorldline.informationCost` and `gravRedshiftCost`. -/
theorem photon_coherence_unified_summary
    (w : PhotonCoherenceWorldline) :
    (∀ p ∈ w.points, PhotonCoherenceWorldline.localPropagationVelocity w p = c)
      ∧ w.informationCost = gravRedshiftCost w.pathLength w.energy
      ∧ w.informationCost = (l_P / (2 * w.energy)) * w.pathLength
      ∧ 0 ≤ w.informationCost :=
  ⟨photon_speed_invariance w,
   photon_energy_info_duality w,
   photon_info_cost_path_integrated w,
   photon_coherence_nonneg w⟩

end OmegaTheory.Emergence
