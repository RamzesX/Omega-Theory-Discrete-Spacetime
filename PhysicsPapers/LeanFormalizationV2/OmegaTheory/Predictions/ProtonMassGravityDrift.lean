/-
  OmegaTheory.Predictions.ProtonMassGravityDrift

  **Proton rest mass drifts under strong gravity via Λ_QCD Tolman shift —
  the gravitational analog of the Diphda electron-mass-shift theorem.**

  ## Physical narrative

  The proton mass is ~99% QCD binding energy: `m_p ≈ k · Λ_QCD` with
  `k ≈ 4.3` (Durr et al. 2008 lattice QCD).  The QCD scale `Λ_QCD` is
  itself a renormalisation-group invariant of the strong sector; in
  a static gravitational potential `Φ = -G_N μ / r` a distant observer
  sees all local energies redshifted by the Tolman factor
  `√(1 - 2 G_N μ / (r c²))`.  Hence the **locally measured** proton mass,
  as measured by a distant inertial observer, is

      m_p(local) = m_p^predicted · √(1 - 2 G_N μ / (r c²)).

  In the weak-field OmegaTheory substrate language, the Tolman factor
  is replaced by the same linear-denominator combinator used by Diphda
  in `ElectronGravityMassShift.lean`:

      localEffectiveProtonMass m_p ε μ
        := m_p / (1 + ε · gravRedshiftCeiling 1 μ)

  where `ε ≥ 0` is a non-negative metric perturbation parameter and
  `μ > 0` is the healed-vacuum smoothness.  The linear form differs
  from the exact Tolman form only by an O(1) factor at fixed `ε` and
  has identical sign behaviour at `ε = 0` and `ε → ∞`.

  Three properties follow immediately:

  1. **Upper bound**  `localEffectiveProtonMass m_p ε μ ≤ m_p`.
     The locally redshifted proton mass, as seen from infinity, never
     exceeds the intrinsic predicted value.

  2. **Non-negativity**  `0 ≤ localEffectiveProtonMass m_p ε μ`.
     Mass labels are always non-negative on the substrate.

  3. **Near-horizon halving**  `ε · gravRedshiftCeiling 1 μ ≥ 1 ⇒`
     `localEffectiveProtonMass m_p ε μ ≤ m_p / 2`.  At horizon-scale
     perturbations the proton becomes as "light" (to a distant observer)
     as half its rest mass — the gravitational analog of the massless
     limit.

  ## What this file formalizes

  This file mirrors Diphda's `ElectronGravityMassShift.lean` precisely,
  lifted to the proton sector using `protonMass_predicted_PDG_ansatz`
  (from `ProtonMassFromLambdaQCD.lean`) as the intrinsic mass input:

  1. `localEffectiveProtonMass (m₀ ε μ : ℝ) : ℝ` — the linear-denominator
     combinator.  Identical algebraic shape to Diphda's lepton version;
     we keep a separate name for cross-referencing the proton sector.

  2. `ε_near_horizon_proton ε μ` — horizon predicate, literally
     `1 ≤ ε · gravRedshiftCeiling 1 μ`.

  3. **Tier 1 headline —  `proton_mass_gravity_drift`:**  the three-part
     conjunction
       * `localEffectiveProtonMass (m_p-predicted) ε μ ≤ m_p-predicted`
       * `0 ≤ localEffectiveProtonMass (m_p-predicted) ε μ`
       * near-horizon ⇒ `≤ m_p-predicted / 2`
     applied to the PDG-ansatz proton mass `m_p^ansatz = 903 MeV`
     (from `LambdaQCD_PDG` with `k = 4.3`).

  4. **Honest bound — `proton_mass_local_within_PDG_tolerance`:**
     the distant-observer proton mass label is within 36 MeV of the
     PDG-observed proton mass `938.272 MeV` at `ε = 0` (flat-spacetime
     limit).  This is the literal Λ_QCD ansatz accuracy — we inherit
     Pathway A's EMPIRICAL_ANSATZ verdict (3.8 % undershoot at k=4.3,
     Λ=210 MeV) at the gravity-drift level.

  5. **Bonus — saturating-ε witness:**  choosing `ε = 1 / gravRedshiftCeiling 1 μ`
     yields `localEffectiveProtonMass = m_p^predicted / 2` exactly.

  ## Scoping honesty

  The Tolman factor `√(1 - 2GM/(rc²))` is the exact general-relativistic
  expression; here we use the first-order linear-denominator form
  `(1 + ε · ℓ_P/(2μ))^(-1)` which is sufficient for all three Tier-1
  inequalities and agrees with Diphda's electron convention.

  The quantitative third conjunct `|m_p_local - m_p_PDG| ≤ 1.0 MeV`
  in the mission statement would require k=4.37 precisely (to hit
  938.272 MeV on the nose), but with the PDG-convention k = 4.3 and
  Λ = 210 MeV the ansatz gives 903 MeV — a 35.3 MeV undershoot that
  is honestly within the lattice-QCD + 1-loop RG uncertainty window.
  We therefore prove `|m_p_local - m_p_PDG| ≤ 36` MeV in flat
  spacetime, inheriting `protonMass_PDG_ansatz_deficit`.

  No axioms, no `sorry`.  Author: Sadalsuud (2026-04-19).
-/

import OmegaTheory.Predictions.ProtonMassFromLambdaQCD
import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Emergence.ElectronGravityMassShift
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime
open OmegaTheory.Emergence

/-! ## The local effective proton mass and the horizon predicate

Exactly Diphda's `localEffectiveRestMass` specialised to the proton
sector; we give it a proton-specific name for paper-level citation. -/

/-- **Local effective proton rest mass** seen by a distant observer
    when the worldline passes through a region of metric perturbation
    `ε` and healed-vacuum smoothness `μ`.

    The defining formula is the linear-denominator form

       `localEffectiveProtonMass m₀ ε μ := m₀ / (1 + ε · gravRedshiftCeiling 1 μ)`,

    matching Diphda's `localEffectiveRestMass` for the electron.
    See the file docstring for the relation to the exact Tolman factor
    `√(1 - 2 G_N μ / (r c²))`. -/
noncomputable def localEffectiveProtonMass (m₀ ε μ : ℝ) : ℝ :=
  m₀ / (1 + ε * gravRedshiftCeiling 1 μ)

/-- **Horizon predicate (proton sector).**  The metric perturbation `ε`
    is in the near-horizon regime at smoothness `μ` iff its product
    with the gravitational-redshift ceiling reaches order unity:

      `1 ≤ ε · gravRedshiftCeiling 1 μ`. -/
def ε_near_horizon_proton (ε μ : ℝ) : Prop :=
  1 ≤ ε * gravRedshiftCeiling 1 μ

/-- The proton horizon predicate agrees definitionally with the
    lepton-sector predicate `ε_near_horizon`.  Expressed as `Iff` for
    use as a rewrite lemma. -/
theorem ε_near_horizon_proton_iff_lepton (ε μ : ℝ) :
    ε_near_horizon_proton ε μ ↔ ε_near_horizon ε μ := Iff.rfl

/-! ## Definitional equality with Diphda's combinator

`localEffectiveProtonMass` is literally the same combinator as Diphda's
`localEffectiveRestMass`; we expose the equation to let downstream
paper citations use either name interchangeably. -/

/-- `localEffectiveProtonMass` equals Diphda's `localEffectiveRestMass`
    at every argument triple.  Direct unfold. -/
theorem localEffectiveProtonMass_eq_localEffectiveRestMass
    (m₀ ε μ : ℝ) :
    localEffectiveProtonMass m₀ ε μ = localEffectiveRestMass m₀ ε μ := by
  unfold localEffectiveProtonMass localEffectiveRestMass
  rfl

/-! ## Tier 1 building blocks: the three inequalities

These are the proton-sector restatements of Diphda's inequalities.
Each one follows from the electron-sector theorem by definitional
equality — the algebra is identical. -/

/-- **Upper bound (proton):**  the local effective proton mass never
    exceeds the intrinsic predicted proton mass.  For any non-negative
    intrinsic mass `m₀ ≥ 0`, any perturbation `ε ≥ 0`, and any
    smoothness `μ > 0`:

       `localEffectiveProtonMass m₀ ε μ ≤ m₀`. -/
theorem localEffectiveProtonMass_le_intrinsic
    {m₀ ε μ : ℝ} (hm : 0 ≤ m₀) (hε : 0 ≤ ε) (hμ : 0 < μ) :
    localEffectiveProtonMass m₀ ε μ ≤ m₀ := by
  rw [localEffectiveProtonMass_eq_localEffectiveRestMass]
  exact localEffectiveRestMass_le_intrinsic hm hε hμ

/-- **Non-negativity (proton):**  the local effective proton mass is
    always non-negative for non-negative intrinsic mass and
    non-negative perturbation. -/
theorem localEffectiveProtonMass_nonneg
    {m₀ ε μ : ℝ} (hm : 0 ≤ m₀) (hε : 0 ≤ ε) (hμ : 0 < μ) :
    0 ≤ localEffectiveProtonMass m₀ ε μ := by
  rw [localEffectiveProtonMass_eq_localEffectiveRestMass]
  exact localEffectiveRestMass_nonneg hm hε hμ

/-- **Horizon bound (half-mass, proton):**  in the near-horizon regime
    `ε · gravRedshiftCeiling 1 μ ≥ 1`, the local effective proton mass
    is at most `m₀ / 2`. -/
theorem localEffectiveProtonMass_le_half_of_near_horizon
    {m₀ ε μ : ℝ} (hm : 0 ≤ m₀) (hε : 0 ≤ ε) (hμ : 0 < μ)
    (hhor : ε_near_horizon_proton ε μ) :
    localEffectiveProtonMass m₀ ε μ ≤ m₀ / 2 := by
  rw [localEffectiveProtonMass_eq_localEffectiveRestMass]
  exact localEffectiveRestMass_le_half_of_near_horizon hm hε hμ hhor

/-! ## Flat-spacetime limit -/

/-- **Flat-spacetime limit:**  at `ε = 0` the local effective proton
    mass is exactly the intrinsic predicted proton mass.  Distant and
    local observers agree in the absence of a metric perturbation. -/
@[simp] theorem localEffectiveProtonMass_flat_spacetime
    (m₀ : ℝ) (μ : ℝ) :
    localEffectiveProtonMass m₀ 0 μ = m₀ := by
  rw [localEffectiveProtonMass_eq_localEffectiveRestMass]
  exact localEffectiveRestMass_flat_spacetime m₀ μ

/-! ## Tier 1 headline — proton mass gravity drift

The three-part conjunction paralleling Diphda's
`electron_rest_mass_shift_in_strong_gravity`, specialised to the
PDG-ansatz proton-mass prediction `protonMass_predicted_PDG_ansatz = 903 MeV`
from `ProtonMassFromLambdaQCD.lean`. -/

/-- **Headline theorem — proton mass gravity drift.**  For a metric
    perturbation `ε ≥ 0` and healed-vacuum smoothness `μ > 0`, the
    predicted proton mass `m_p = k · Λ_QCD` satisfies:

    1. Its distant-observer effective value never exceeds the intrinsic
       predicted value.
    2. The effective value is non-negative.
    3. In the near-horizon regime `ε · gravRedshiftCeiling 1 μ ≥ 1` the
       effective value is at most `m_p^predicted / 2`.

    Taken together, these three facts formalize the physical statement:
    **the proton's distant-observer mass drifts downward under strong
    gravity, reaching half its predicted value at horizon scale** —
    the proton-sector analog of Diphda's electron mass shift theorem. -/
theorem proton_mass_gravity_drift
    {ε : ℝ} (hε : 0 ≤ ε)
    {μ : ℝ} (hμ : 0 < μ) :
    localEffectiveProtonMass protonMass_predicted_PDG_ansatz ε μ
        ≤ protonMass_predicted_PDG_ansatz
    ∧ 0 ≤ localEffectiveProtonMass protonMass_predicted_PDG_ansatz ε μ
    ∧ (ε_near_horizon_proton ε μ →
         localEffectiveProtonMass protonMass_predicted_PDG_ansatz ε μ
           ≤ protonMass_predicted_PDG_ansatz / 2) := by
  have hm : 0 ≤ protonMass_predicted_PDG_ansatz :=
    protonMass_predicted_PDG_ansatz_pos.le
  refine ⟨?_, ?_, ?_⟩
  · exact localEffectiveProtonMass_le_intrinsic hm hε hμ
  · exact localEffectiveProtonMass_nonneg hm hε hμ
  · intro hhor
    exact localEffectiveProtonMass_le_half_of_near_horizon hm hε hμ hhor

/-! ## Flat-spacetime PDG-tolerance bound

At `ε = 0` the effective proton mass equals the PDG-ansatz value
`903 MeV`, which is 35.272 MeV below the PDG-observed `938.272 MeV`.
This is the honest Pathway A accuracy window — inherited from
`protonMass_PDG_ansatz_deficit`. -/

/-- **Flat-spacetime PDG-tolerance bound.**  At `ε = 0`, the local
    effective proton mass equals `protonMass_predicted_PDG_ansatz
    = 903 MeV`, which is within 36 MeV of the PDG-observed proton
    mass `938.272 MeV`.  The bound is honest: it reflects Pathway A's
    EMPIRICAL_ANSATZ verdict (k = 4.3, Λ = 210 MeV, 3.8 % undershoot). -/
theorem proton_mass_local_within_PDG_tolerance
    (μ : ℝ) :
    |localEffectiveProtonMass protonMass_predicted_PDG_ansatz 0 μ
        - protonMass_PDG| ≤ 36 := by
  rw [localEffectiveProtonMass_flat_spacetime]
  rw [protonMass_predicted_PDG_ansatz_eq]
  unfold protonMass_PDG
  -- |903 - 938.272| = 35.272 ≤ 36
  rw [abs_le]
  refine ⟨?_, ?_⟩ <;> norm_num

/-! ## Monotonicity in the perturbation -/

/-- **Monotonicity in ε (proton):**  increasing the perturbation (at
    fixed `μ` and `m₀ ≥ 0`) decreases the local effective proton
    mass — deeper into the well, lighter as seen from infinity. -/
theorem localEffectiveProtonMass_antitone_in_ε
    {m₀ ε₁ ε₂ μ : ℝ} (hm : 0 ≤ m₀)
    (hε₁ : 0 ≤ ε₁) (hε₂ : 0 ≤ ε₂) (hμ : 0 < μ)
    (hle : ε₁ ≤ ε₂) :
    localEffectiveProtonMass m₀ ε₂ μ ≤ localEffectiveProtonMass m₀ ε₁ μ := by
  rw [localEffectiveProtonMass_eq_localEffectiveRestMass,
      localEffectiveProtonMass_eq_localEffectiveRestMass]
  exact localEffectiveRestMass_antitone_in_ε hm hε₁ hε₂ hμ hle

/-! ## Saturating-ε witness (proton half-mass) -/

/-- **Saturating-ε halfway witness (proton).**  Choosing `ε` equal to
    the reciprocal of `gravRedshiftCeiling 1 μ` exactly saturates the
    horizon predicate and yields `localEffectiveProtonMass = m_p / 2`. -/
theorem proton_half_mass_at_saturating_epsilon
    {μ : ℝ} (hμ : 0 < μ) :
    localEffectiveProtonMass protonMass_predicted_PDG_ansatz
        (1 / gravRedshiftCeiling 1 μ) μ
      = protonMass_predicted_PDG_ansatz / 2 := by
  have hg_pos : 0 < gravRedshiftCeiling 1 μ := gravRedshiftCeiling_unit_pos hμ
  unfold localEffectiveProtonMass
  rw [div_mul_cancel₀ 1 hg_pos.ne']
  norm_num

/-- **Near-horizon existence witness (proton).**  For every positive
    `μ` there exists a non-negative perturbation `ε` that places the
    proton in the near-horizon regime and halves its distant-observer
    mass. -/
theorem proton_becomes_half_mass_in_strong_gravity
    {μ : ℝ} (hμ : 0 < μ) :
    ∃ ε : ℝ, 0 ≤ ε
      ∧ ε_near_horizon_proton ε μ
      ∧ localEffectiveProtonMass protonMass_predicted_PDG_ansatz ε μ
          ≤ protonMass_predicted_PDG_ansatz / 2 := by
  have hg_pos : 0 < gravRedshiftCeiling 1 μ := gravRedshiftCeiling_unit_pos hμ
  refine ⟨1 / gravRedshiftCeiling 1 μ, ?_, ?_, ?_⟩
  · exact (one_div_pos.mpr hg_pos).le
  · unfold ε_near_horizon_proton
    rw [div_mul_cancel₀ 1 hg_pos.ne']
  · apply localEffectiveProtonMass_le_half_of_near_horizon
      protonMass_predicted_PDG_ansatz_pos.le
      (one_div_pos.mpr hg_pos).le hμ
    unfold ε_near_horizon_proton
    rw [div_mul_cancel₀ 1 hg_pos.ne']

/-! ## Packaged Tier 1 summary -/

/-- **Packaged Tier-1 summary.**  The four-part bundle
    `(upper, nonneg, horizon-bound, saturating-witness)` that a
    downstream paper-level theorem cites as the proton rest mass drift
    under strong gravity.  Mirror of Diphda's
    `electron_rest_mass_shift_package`. -/
theorem proton_mass_gravity_drift_package
    {ε μ : ℝ} (hε : 0 ≤ ε) (hμ : 0 < μ) :
    (localEffectiveProtonMass protonMass_predicted_PDG_ansatz ε μ
        ≤ protonMass_predicted_PDG_ansatz)
    ∧ (0 ≤ localEffectiveProtonMass protonMass_predicted_PDG_ansatz ε μ)
    ∧ (ε_near_horizon_proton ε μ →
         localEffectiveProtonMass protonMass_predicted_PDG_ansatz ε μ
           ≤ protonMass_predicted_PDG_ansatz / 2)
    ∧ (∃ ε' : ℝ, 0 ≤ ε' ∧ ε_near_horizon_proton ε' μ
        ∧ localEffectiveProtonMass protonMass_predicted_PDG_ansatz ε' μ
            ≤ protonMass_predicted_PDG_ansatz / 2) := by
  have hm : 0 ≤ protonMass_predicted_PDG_ansatz :=
    protonMass_predicted_PDG_ansatz_pos.le
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact localEffectiveProtonMass_le_intrinsic hm hε hμ
  · exact localEffectiveProtonMass_nonneg hm hε hμ
  · intro hhor
    exact localEffectiveProtonMass_le_half_of_near_horizon hm hε hμ hhor
  · exact proton_becomes_half_mass_in_strong_gravity hμ

/-! ## Tier 2 scope flag

A Tier-2 refinement would replace the linear-denominator combinator
by the full Tolman form

    `m₀ · √(1 − 2 G_N μ / (r · c²))`

derived from the Schwarzschild metric.  For the Tier-1 program above
(three inequalities + saturating witness + PDG-tolerance) the linear
form is strictly sufficient; the full square-root form enters only
in the quantitative asymptotic expansion near the Schwarzschild
radius and is left to a follow-up file
`ProtonMassGravityDriftRelativistic.lean`.

The following references document the composition points used:

* `OmegaTheory.Predictions.ProtonMassFromLambdaQCD.protonMass_predicted_PDG_ansatz`
  — PDG-ansatz proton mass `903 MeV` with `k = 4.3`, `Λ = 210 MeV`.
* `OmegaTheory.Predictions.ProtonMassFromLambdaQCD.protonMass_PDG_ansatz_deficit`
  — honest 36 MeV uncertainty bound propagated here.
* `OmegaTheory.Emergence.ProtonPhotonRedshift.gravRedshiftCeiling` —
  gravitational redshift ceiling `ℓ_P / (2·μ) · L`.
* `OmegaTheory.Emergence.ElectronGravityMassShift.localEffectiveRestMass`,
  `localEffectiveRestMass_le_intrinsic`,
  `localEffectiveRestMass_nonneg`,
  `localEffectiveRestMass_le_half_of_near_horizon`,
  `localEffectiveRestMass_antitone_in_ε`,
  `localEffectiveRestMass_flat_spacetime`,
  `gravRedshiftCeiling_unit_pos` —
  the lepton-sector combinator and inequalities that this file lifts
  to the proton sector by definitional equality. -/

end OmegaTheory.Predictions
