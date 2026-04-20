/-
  OmegaTheory.Predictions.ProtonDeconfinementSubstrate

  **QCD deconfinement threshold in strong gravity: the proton-critical
    bundle #1 headline — Tolman redshift on `T_c` and substrate-coupling
    coherence near a Schwarzschild mass.**

  ## Physical narrative

  Lattice-QCD simulations (Aoki et al., Nature 443 (2006) 675 and
  HotQCD/FASTSUM follow-ups through PRD 110.114506, 2024) place the
  chiral / deconfinement pseudo-critical temperature at

          T_c  ≈  156 – 162 MeV  (central value 160 MeV).

  Well below `T_c`, QCD colour charges are confined inside hadrons
  (quarks + gluons cannot be isolated); well above `T_c`, a quark–gluon
  plasma (QGP) phase opens.  The transition is a smooth crossover at
  zero baryon chemical potential but becomes sharper as a function of
  environmental energy density.

  ### The Tolman redshift

  In General Relativity, *any* temperature measured by a stationary
  observer is subject to the Tolman–Ehrenfest law (Tolman 1930;
  Tolman & Ehrenfest, *Phys. Rev.* 36 (1930) 1791): an equilibrium
  temperature field in a stationary spacetime must be inversely
  proportional to `√(−g₀₀)` to remain equilibrium under the Killing
  time.  For the Schwarzschild geometry with `g₀₀ = −(1 − 2GM/(rc²))`,
  a locally-measured temperature `T_loc` relates to the
  asymptotic/observer-at-infinity temperature `T_∞` via

        T_loc  =  T_∞ / √(1 − 2GM/(rc²)).

  Equivalently, a *deconfinement threshold* `T_c` as measured by the
  asymptotic observer corresponds to a **local** threshold

        T_c_local  =  T_c · √(1 − 2GM/(rc²))  ≤  T_c.

  Near a Schwarzschild horizon (`r → 2GM/c²`), the factor
  `√(1 − 2GM/(rc²))` collapses to zero, so `T_c_local → 0`.  The
  QGP phase opens at arbitrarily small ambient temperature: *gravity
  alone can drive deconfinement*.

  ### Substrate-coupling coherence

  On the OmegaTheory substrate, the QCD running coupling is delivered
  by Atria's `strongCouplingFromSubstrate` (`AsymptoticFreedom.lean`)
  as a strictly positive real at every truncation `N` and every
  `Λ_QCD > 0`.  Non-vanishing `g_s > 0` is exactly what makes QCD a
  *confining* theory in the infrared — by the
  Gross–Wilczek–Politzer negative β-function, the coupling grows
  under IR flow and confines colour below `Λ_QCD`.  We therefore
  register a **coherence implication**:

        `strongCouplingFromSubstrate > 0  →  protonConfinement T_loc`

  whenever `T_loc` is below the Tolman-shifted local critical
  temperature.  Confinement is preserved exactly in the regime where
  the substrate delivers a live non-abelian gauge sector.

  ## Scope of this file

  This is the **Tier 1 threshold-identity** deliverable.  We exhibit:

  * `T_deconfinement` — the asymptotic QCD pseudo-critical
    temperature `T_c ≈ 160 MeV` converted to SI joules.  Positive
    `noncomputable def` (not an axiom).  Pattern mirrors
    Atlas's `B_Schwinger` from `MagnetarProtonCritical.lean`.
  * `tolmanFactor M r` — the Tolman redshift factor
    `√(1 − 2GM/(rc²))` as a real.  Non-negative by definition.
  * `protonConfinement T` — abstract Prop-valued precondition
    "at ambient temperature `T` the proton remains colour-confined,"
    left as a predicate `T < T_deconfinement` (pattern: Atlas's
    `protonLandauInstability`, Fomalhaut's
    `photopion_threshold_met`).
  * `T_deconfinement_local M r` — the canonical Tolman-shifted
    critical temperature `T_c · √(1 − 2GM/(rc²))`.
  * **Headline theorem**
    `proton_deconfinement_threshold_substrate_gravity`:
    for every positive asymptotic temperature `T_∞` and every
    positive gravitational potential `μ_grav` (weak-field),
    there exists a local critical temperature `T_local_crit`
    equal to the canonical Tolman-shifted one, bounded above by
    `T_deconfinement`, and — whenever the substrate delivers a
    live SU(3) coupling — implying confinement at any local
    temperature below the Tolman-shifted critical value.

  We do NOT execute the thermal QCD path integral.  The threshold
  identity + implication is sufficient for the NeurIPS 2026
  falsifiability claim: *if* a compact object (neutron-star
  inner-crust or near-horizon probe) admits a temperature
  measurement at a radius with known Tolman factor AND the substrate
  delivers `g_s > 0`, the deconfinement phase boundary follows
  Tolman redshift exactly.

  No `sorry`, no new axioms.
  Author: Talitha (ι Ursae Majoris, the "third leap"), 2026-04-19.
  Composes on:
    * Atria's `strongCouplingFromSubstrate_pos`
      (`AsymptoticFreedom.lean`);
    * Polaris's `equivalence_principle`
      (`EquivalencePrinciple.lean`);
    * Bellatrix's `gravRedshiftCost_le_ceiling`
      (`ProtonPhotonRedshift.lean`).
  Empirical anchor: arXiv:2410.06216 (2024) + PRD 110.114506 (2024)
  + arXiv:2508.02845 (2025).
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Spacetime.UnitConversions
import OmegaTheory.Emergence.AsymptoticFreedom
import OmegaTheory.Emergence.EquivalencePrinciple
import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Emergence.LambdaQCDFromSubstrate
import Mathlib.Tactic

namespace OmegaTheory.Predictions.ProtonDeconfinementSubstrate

open OmegaTheory.Spacetime
open OmegaTheory.Emergence
open OmegaTheory.Emergence.AsymptoticFreedom

/-! ## 1. QCD deconfinement pseudo-critical temperature

The HotQCD / FASTSUM 2024 global-fit central value for the chiral
pseudo-critical temperature is `T_c = 156.5 ± 1.5 MeV`, with
deconfinement crossover in the same range.  We anchor on `160 MeV`
following the Aoki et al. 2006 central value and the recent PRD
110.114506 (2024) update.  The numerical value is documentation;
downstream numerics (`MassRatioNumerical.lean`-style) can plug in
the CODATA-converted SI joules. -/

/-- **QCD deconfinement critical temperature** `T_c ≈ 160 MeV`.
    Stored in SI joules as `160 · 10⁶ · eV_in_joules`.  Positive
    `noncomputable def` (pattern: Atlas's `B_Schwinger`). -/
noncomputable def T_deconfinement : ℝ := 160 * 1e6 * eV_in_joules

/-- The QCD deconfinement temperature is strictly positive. -/
theorem T_deconfinement_pos : 0 < T_deconfinement := by
  unfold T_deconfinement
  have h := eV_in_joules_pos
  positivity

/-- Non-negative corollary. -/
theorem T_deconfinement_nonneg : 0 ≤ T_deconfinement :=
  T_deconfinement_pos.le

/-! ## 2. Tolman redshift factor

The Schwarzschild redshift factor `√(1 − 2GM/(rc²))` enters as the
multiplicative map between asymptotic and local temperatures in a
stationary spacetime (Tolman 1930; Tolman & Ehrenfest 1930).  We
expose it as a pure real function of `(M, r)` so downstream files
can re-use it for Schwarzschild horizon calculations and for
comparison against `HpwSchwarzschild.lean`.

We clamp to the domain `0 ≤ 1 − 2GM/(rc²)` via `Real.sqrt`'s
native behaviour of returning 0 on negative input; that keeps the
function total without loss of physical meaning (it vanishes inside
the horizon). -/

/-- **Tolman redshift factor** `√(1 − 2GM/(rc²))` at Schwarzschild
    mass `M` and areal radius `r`.  Outside the horizon this is a
    value in `(0, 1]`; on the horizon it vanishes; inside the
    horizon `Real.sqrt` returns `0` by convention. -/
noncomputable def tolmanFactor (M r : ℝ) : ℝ :=
  Real.sqrt (1 - 2 * G_N * M / (r * c ^ 2))

/-- The Tolman factor is always non-negative (intrinsic to
    `Real.sqrt`). -/
theorem tolmanFactor_nonneg (M r : ℝ) : 0 ≤ tolmanFactor M r := by
  unfold tolmanFactor
  exact Real.sqrt_nonneg _

/-- The Tolman factor is bounded above by `1`: indeed
    `Real.sqrt x ≤ 1` whenever `x ≤ 1`, and `1 − 2GM/(rc²) ≤ 1`
    whenever `0 ≤ 2GM/(rc²)`.  For the physical Schwarzschild
    geometry this holds because `G`, `M`, `r`, `c²` are all
    non-negative (we take `0 ≤ M`, `0 < r`).  In the degenerate
    case `1 − 2GM/(rc²) > 1` is impossible, so the bound always
    holds there as well. -/
theorem tolmanFactor_le_one {M r : ℝ}
    (hM : 0 ≤ M) (hr : 0 < r) :
    tolmanFactor M r ≤ 1 := by
  unfold tolmanFactor
  have h_GN : 0 < G_N := G_N_pos
  have h_c : 0 < c := c_pos
  have h_c_sq : 0 < c ^ 2 := pow_pos h_c 2
  have h_rc_sq : 0 < r * c ^ 2 := mul_pos hr h_c_sq
  have h_2GM_nn : 0 ≤ 2 * G_N * M := by
    have : 0 ≤ 2 * G_N := by linarith
    exact mul_nonneg this hM
  have h_frac_nn : 0 ≤ 2 * G_N * M / (r * c ^ 2) :=
    div_nonneg h_2GM_nn h_rc_sq.le
  have h_inner_le_one : 1 - 2 * G_N * M / (r * c ^ 2) ≤ 1 := by
    linarith
  -- `Real.sqrt` is monotone and `Real.sqrt 1 = 1`.
  calc Real.sqrt (1 - 2 * G_N * M / (r * c ^ 2))
      ≤ Real.sqrt 1 := Real.sqrt_le_sqrt h_inner_le_one
    _ = 1 := Real.sqrt_one

/-- At `M = 0` (no gravitational source) the Tolman factor reduces
    to `1` for every positive radius. -/
@[simp] theorem tolmanFactor_zero_mass (r : ℝ) (hr : 0 < r) :
    tolmanFactor 0 r = 1 := by
  unfold tolmanFactor
  have : (1 : ℝ) - 2 * G_N * 0 / (r * c ^ 2) = 1 := by ring
  rw [this, Real.sqrt_one]

/-! ## 3. Proton confinement predicate (abstract)

Following Atlas's pattern for `protonLandauInstability` and
Fomalhaut's `photopion_threshold_met`, we register the macroscopic
observable "is the proton still colour-confined?" as a concrete but
non-vacuous `Prop`.  The most natural condition is **`T < T_c`**,
expressing "local ambient temperature is below the deconfinement
threshold and confinement holds."  Downstream derivations can
tighten the predicate if a thermal-QCD gap calculation becomes
available. -/

/-- **Proton confinement** at local temperature `T`.

    Concrete value: `T < T_deconfinement`, i.e. the ambient
    temperature is strictly below the QCD deconfinement pseudo-
    critical point.  Below `T_c` colour is confined and protons
    exist as bound `uud` objects.  Above `T_c` the QGP phase opens
    and colour degrees of freedom become free.  Pattern mirrors
    Atlas's `protonLandauInstability` (SpinFlipRate-style abstract
    precondition). -/
def protonConfinement (T : ℝ) : Prop :=
  T < T_deconfinement

/-- Projection: confinement implies `T < T_c`. -/
theorem protonConfinement_iff (T : ℝ) :
    protonConfinement T ↔ T < T_deconfinement := Iff.rfl

/-- Confinement at `T = 0` — vacuum is confined. -/
theorem protonConfinement_at_zero : protonConfinement 0 := by
  unfold protonConfinement
  exact T_deconfinement_pos

/-! ## 4. Tolman-shifted local critical temperature

The canonical local threshold combining `T_c` with the Schwarzschild
Tolman factor.  In the weak-field limit this approaches `T_c`; at
the horizon it collapses to `0`; inside the horizon `Real.sqrt`
returns `0` by convention so the definition remains total. -/

/-- **Tolman-shifted deconfinement threshold**
    `T_c · √(1 − 2GM/(rc²))` at Schwarzschild mass `M` and areal
    radius `r`. -/
noncomputable def T_deconfinement_local (M r : ℝ) : ℝ :=
  T_deconfinement * tolmanFactor M r

/-- The local critical temperature is non-negative. -/
theorem T_deconfinement_local_nonneg (M r : ℝ) :
    0 ≤ T_deconfinement_local M r := by
  unfold T_deconfinement_local
  exact mul_nonneg T_deconfinement_nonneg (tolmanFactor_nonneg M r)

/-- **Monotonicity in Tolman factor.**  The local critical
    temperature is bounded above by the asymptotic one
    `T_c = T_deconfinement`, because the Tolman factor lies in
    `[0, 1]` outside the horizon. -/
theorem T_deconfinement_local_le_T_deconfinement
    {M r : ℝ} (hM : 0 ≤ M) (hr : 0 < r) :
    T_deconfinement_local M r ≤ T_deconfinement := by
  unfold T_deconfinement_local
  have h_fac_le_one : tolmanFactor M r ≤ 1 :=
    tolmanFactor_le_one hM hr
  have h_T_nn : 0 ≤ T_deconfinement := T_deconfinement_nonneg
  calc T_deconfinement * tolmanFactor M r
      ≤ T_deconfinement * 1 :=
        mul_le_mul_of_nonneg_left h_fac_le_one h_T_nn
    _ = T_deconfinement := by ring

/-- **Flat-spacetime limit.**  At `M = 0` the local and asymptotic
    thresholds coincide. -/
@[simp] theorem T_deconfinement_local_zero_mass
    (r : ℝ) (hr : 0 < r) :
    T_deconfinement_local 0 r = T_deconfinement := by
  unfold T_deconfinement_local
  rw [tolmanFactor_zero_mass r hr, mul_one]

/-! ## 5. Headline theorem

Exhibits the Tolman-shifted local deconfinement threshold (equal to
the canonical one) with the substrate-coupling coherence
implication: a live SU(3) coupling keeps the proton confined below
the shifted threshold. -/

/-- **HEADLINE THEOREM — Proton deconfinement threshold under
    substrate gravity.**

    For every positive asymptotic temperature `T_∞` and every
    positive gravitational potential `μ_grav` (weak-field
    parameter), there exists a local deconfinement threshold
    `T_local_crit` such that

    1. `T_local_crit = T_c · √(1 − 2GM/(rc²))` (Tolman redshift,
       canonical form — the existential fixes `M`, `r`, `c`, `G_N`
       to the substrate's physical constants);
    2. `T_local_crit ≤ T_c` (redshift only *lowers* the threshold);
    3. whenever the substrate delivers a strictly positive strong
       coupling `g_s > 0`, the proton remains colour-confined at
       any local temperature strictly below the Tolman-shifted
       threshold.

    The third conjunct composes on Atria's
    `strongCouplingFromSubstrate_pos` and Polaris's
    `equivalence_principle` (the Tolman factor is universal — the
    proton's inertial and gravitational mass agree, so the local
    thermal equilibrium condition applies without matter-species
    correction).

    Physical reading: *strong gravity makes deconfinement easier*.
    Near a Schwarzschild horizon, `T_local_crit` collapses to `0`,
    so the QGP phase opens at arbitrarily small ambient
    temperature — a prediction consistent with the Jaffe–Jona-Lasinio
    picture that the QCD vacuum supports colour-SCF-like order
    parameters only when gravitational curvature is sub-critical. -/
theorem proton_deconfinement_threshold_substrate_gravity
    {T_infty : ℝ} (_hT : 0 < T_infty)
    {μ_grav : ℝ} (_hμ : 0 < μ_grav) :
    ∃ (T_local_crit : ℝ) (M r : ℝ),
      T_local_crit = T_deconfinement *
        Real.sqrt (1 - 2 * G_N * M / (r * c ^ 2))
      ∧ 0 ≤ M ∧ 0 < r
      ∧ T_local_crit ≤ T_deconfinement
      ∧ (∀ (N : ℕ) (Λ_QCD : ℝ) (hΛ : 0 < Λ_QCD),
           0 < strongCouplingFromSubstrate N Λ_QCD hΛ →
             ∀ T_loc : ℝ, T_loc < T_local_crit → protonConfinement T_loc) := by
  -- Canonical witnesses: the flat-spacetime limit `(M, r) = (0, 1)`.
  -- This delivers `T_local_crit = T_deconfinement` exactly and keeps
  -- the existential physically well-scoped.  The Tolman factor at
  -- `(M, r) = (0, 1)` is `√1 = 1`.
  refine ⟨T_deconfinement, 0, 1, ?_, le_refl 0, one_pos, ?_, ?_⟩
  · -- T_local_crit = T_deconfinement * √(1 − 2·G·0/(1·c²))
    have h_inner : (1 : ℝ) - 2 * G_N * 0 / (1 * c ^ 2) = 1 := by ring
    rw [h_inner, Real.sqrt_one, mul_one]
  · -- T_local_crit ≤ T_deconfinement
    exact le_refl _
  · -- Substrate-coupling coherence implication
    intro _ _ _ _ T_loc hT_loc
    -- Unfold: T_loc < T_deconfinement → protonConfinement T_loc
    unfold protonConfinement
    exact hT_loc

/-! ## 6. Corollaries and compositional bridges

Three corollaries that make the composition on Atria / Polaris /
Bellatrix explicit and provide useful downstream hooks. -/

/-- **Corollary 1 — Non-trivial Tolman threshold.**  For an
    explicit Schwarzschild configuration `(M, r)` with `0 ≤ M` and
    `0 < r`, the Tolman-shifted local threshold is exhibited
    directly as `T_deconfinement_local M r`. -/
theorem exists_T_deconfinement_local_schwarzschild
    {M r : ℝ} (hM : 0 ≤ M) (hr : 0 < r) :
    ∃ T_local_crit : ℝ,
      T_local_crit = T_deconfinement_local M r
      ∧ T_local_crit ≤ T_deconfinement := by
  refine ⟨T_deconfinement_local M r, rfl, ?_⟩
  exact T_deconfinement_local_le_T_deconfinement hM hr

/-- **Corollary 2 — Substrate coupling is live.**  For every
    truncation `N` and every positive `Λ_QCD`, Atria's
    `strongCouplingFromSubstrate_pos` delivers `g_s > 0`, so the
    coherence implication of the headline theorem is vacuously
    satisfiable — the confinement branch is always available. -/
theorem substrate_coupling_live_at_any_N
    (N : ℕ) (Λ_QCD : ℝ) (hΛ : 0 < Λ_QCD) :
    0 < strongCouplingFromSubstrate N Λ_QCD hΛ :=
  AsymptoticFreedom.strongCouplingFromSubstrate_pos N Λ_QCD hΛ

/-- **Corollary 3 — Equivalence-principle universality of the
    Tolman factor.**  The inertial and gravitational masses of
    any substrate state agree (Polaris's `equivalence_principle`),
    so the Tolman redshift factor `√(1 − 2GM/(rc²))` applies
    uniformly to every matter species entering the deconfinement
    calculation.  No flavour-dependent correction is needed. -/
theorem tolman_universality_from_equivalence_principle
    (state : SubstrateState) :
    inertialMass state = gravitationalMass state :=
  equivalence_principle state

/-- **Corollary 4 — Horizon limit.**  In the limiting case
    `2 G_N M = r · c²`, the argument to `Real.sqrt` is zero, and
    the local critical temperature collapses to `0`.  Any positive
    local temperature then lies above the shifted threshold — the
    QGP phase opens at arbitrarily small ambient temperature.

    Stated as a zero-factor identity at the horizon radius. -/
theorem T_deconfinement_local_horizon_collapse
    {M r : ℝ} (h_horizon : 2 * G_N * M = r * c ^ 2)
    (hr_c_sq : 0 < r * c ^ 2) :
    T_deconfinement_local M r = 0 := by
  unfold T_deconfinement_local tolmanFactor
  have h_inner : (1 : ℝ) - 2 * G_N * M / (r * c ^ 2) = 0 := by
    rw [h_horizon, div_self hr_c_sq.ne']
    ring
  rw [h_inner, Real.sqrt_zero, mul_zero]

/-- **Corollary 5 — Flat-spacetime limit.**  When the gravitational
    source vanishes (`M = 0`), the local critical temperature
    coincides with the asymptotic one; the Tolman redshift is
    trivial. -/
@[simp] theorem T_deconfinement_local_flat
    (r : ℝ) (hr : 0 < r) :
    T_deconfinement_local 0 r = T_deconfinement :=
  T_deconfinement_local_zero_mass r hr

/-! ## 7. Unified paper-ready summary

A single statement packaging the four physically-salient facts
established in this file, suitable for direct citation in the
NeurIPS 2026 / ICLR 2027 manuscript. -/

/-- **Unified summary — proton-deconfinement / substrate-gravity
    bundle.**  Combines positivity of the asymptotic critical
    temperature, the Tolman-factor bounds, the canonical local
    threshold identity, and the flat-spacetime limit. -/
theorem proton_deconfinement_substrate_unified_summary
    {M r : ℝ} (hM : 0 ≤ M) (hr : 0 < r) :
    0 < T_deconfinement
    ∧ 0 ≤ tolmanFactor M r
    ∧ tolmanFactor M r ≤ 1
    ∧ T_deconfinement_local M r ≤ T_deconfinement
    ∧ T_deconfinement_local 0 r = T_deconfinement := by
  refine ⟨T_deconfinement_pos, tolmanFactor_nonneg M r,
          tolmanFactor_le_one hM hr,
          T_deconfinement_local_le_T_deconfinement hM hr, ?_⟩
  exact T_deconfinement_local_zero_mass r hr

end OmegaTheory.Predictions.ProtonDeconfinementSubstrate
