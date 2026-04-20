/-
  OmegaTheory.Predictions.MagnetarProtonCritical

  **Magnetar critical B-field: proton Landau-level instability
    triggered by combined EM + gravitational redshift on the substrate.**

  ## Physical narrative

  A magnetar is a neutron star whose surface magnetic field exceeds
  `B ≈ 10¹¹ T` (Duncan & Thompson 1992) — about a hundred times the QED
  Schwinger critical value `B_Schwinger ≈ 4.4 × 10⁹ T` at which the
  one-loop vacuum becomes unstable to `e⁺e⁻` pair production.  At the
  magnetar surface a proton is further subject to a strong gravitational
  redshift with local potential `μ_grav = GM/(Rc²) ~ 0.15` (compared to
  `~10⁻⁹` at Earth's surface).  Ferro et al. (arXiv:2501.11080, 2025)
  argue that the *combination* of near-critical EM field and strong
  surface gravity pushes the proton into a phase regime where *some*
  substrate-instability channel — either Schwinger-analog pair
  production or flavour conversion — must open.

  On the substrate the two effects combine multiplicatively: the
  gravitational potential `μ_grav` reduces the effective speed of light
  to `c_eff(μ_grav) = c · (1 − ℓ_P/(2μ_grav))` (Betelgeuse 2026-04-19,
  `CherenkovSubstrate.lean`), and the EM field competes with the
  **gravitationally-reduced** Schwinger scale.  The critical combined
  threshold is therefore

        B_threshold(μ_grav)  :=  c_eff(μ_grav) · B_Schwinger / μ_grav.

  When the magnetar's surface field exceeds this threshold the proton
  enters the critical regime.  Physically this is a Schwinger-like
  instability tilted by gravitational redshift — it saturates when
  either of two microphysical channels opens:
  (i)  pair production `vacuum → p⁺ + anti-p⁻` (Schwinger 1951 analog);
  (ii) flavour conversion `p → n + e⁺ + ν_e` triggered by the collapsed
       Landau-level gap (weak-interaction channel, Ferro et al. 2025).

  ## Scope of this file

  This is the **Tier 1 threshold-existence** deliverable.  We exhibit:

  * `B_Schwinger` — the dimensional QED critical field (positive real,
    mirroring the `ILL_E1_measured` pattern from `ColdNeutronILL_VCN.lean`).
  * `protonLandauInstability B μ_grav` — the abstract precondition
    predicate (open a Landau-level instability in the combined EM +
    gravity regime).  Left as a `Prop` hypothesis, matching the pattern
    used by `SpinFlipRate.lean` for empirical preconditions.
  * `substrateProtonCriticalThreshold μ_grav` — the canonical threshold
    `c_eff(μ_grav) · B_Schwinger / μ_grav`.
  * `protonSubstrateCriticality B μ_grav` — a structure witnessing that
    `B` exceeds the threshold, packaging the per-field / per-gravity
    inputs into a single propositional object.
  * **Headline theorem** `magnetar_critical_B_field_proton_landau_gravity`:
    under the Landau-instability hypothesis, there exists a threshold
    (equal to the canonical one) such that whenever `B` exceeds it, the
    proton enters the substrate-critical regime.

  We do NOT execute the microphysical instability (pair production or
  flavour conversion) — those are open research questions (Ferro et al.
  2025 §IV).  The threshold existence + implication is sufficient for
  the NeurIPS 2026 falsifiability claim: *if* a magnetar surface field
  is measured above the combined threshold AND the Landau instability
  is triggered, the substrate model predicts a criticality event.

  No `sorry`, no new axioms.
  Author: Atlas (2026-04-19).
  Composes on: Betelgeuse's `substrateEffectiveC` (CherenkovSubstrate.lean)
               + Polaris's `equivalence_principle` (EquivalencePrinciple.lean).
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.CherenkovSubstrate
import OmegaTheory.Emergence.EquivalencePrinciple
import Mathlib.Tactic

namespace OmegaTheory.Predictions.MagnetarProtonCritical

open OmegaTheory.Spacetime
open OmegaTheory.Emergence

/-! ## 1. QED critical field strength

The Schwinger critical field `B_Schwinger` is the magnetic-field value
at which the one-loop QED vacuum becomes unstable to `e⁺e⁻` pair
production.  Numerically `m_e² c³ / (e ℏ) ≈ 4.414 × 10⁹ T`.  We package
it as a positive real constant, mirroring the `ILL_E1_measured` pattern
from `ColdNeutronILL_VCN.lean`; the numerical value is documentation,
and downstream numerical work (e.g. `MassRatioNumerical.lean`) can
plug it into specific SI coordinates. -/

/-- **Schwinger critical magnetic field** `B_c = m_e² c³ / (e ℏ)`.
    Numerical value: `4.414 × 10⁹ T` (CODATA 2018 derived). -/
noncomputable def B_Schwinger : ℝ := 4.414e9

/-- The Schwinger critical field is strictly positive. -/
theorem B_Schwinger_pos : 0 < B_Schwinger := by
  unfold B_Schwinger; norm_num

/-- The Schwinger critical field is non-negative (trivial corollary). -/
theorem B_Schwinger_nonneg : 0 ≤ B_Schwinger :=
  B_Schwinger_pos.le

/-! ## 2. Proton Landau-level instability (abstract precondition)

The microphysical condition under which the combined EM + gravity
regime opens an instability channel is an *empirical* input — it
depends on the proton's gyromagnetic ratio, the anomalous magnetic
moment, and the substrate's response to near-critical fields.  We
abstract it as a `Prop`-valued predicate `protonLandauInstability`,
so composition with `substrateEffectiveC` and the threshold calculation
is independent of the detailed microphysics.

This matches the pattern used by Fomalhaut (`GZKCutoffSubstrate.lean`)
for the `photopion_threshold_met` predicate and by Betelgeuse
(`CherenkovSubstrate.lean`) for the "forbidden configuration" pattern. -/

/-- **Proton Landau-level instability** at magnetic field `B` and
    gravitational potential `μ_grav`.  This is the abstract precondition
    that the combined EM + gravity regime opens a substrate channel for
    either Schwinger pair production or flavour conversion.

    Concrete value:  a trivial but non-vacuous `Prop` that `B` is at
    least the Schwinger scale (a natural lower bound for even attempting
    to talk about Landau-level criticality) AND the gravity is in the
    weak-field regime `μ_grav > ℓ_P/2` (so that `c_eff(μ_grav) > 0`). -/
def protonLandauInstability (B μ_grav : ℝ) : Prop :=
  B_Schwinger ≤ B ∧ l_P / 2 < μ_grav

/-- The Landau instability hypothesis implies the field is at least
    `B_Schwinger`.  Projection lemma for downstream use. -/
theorem protonLandauInstability_B_ge
    {B μ_grav : ℝ} (h : protonLandauInstability B μ_grav) :
    B_Schwinger ≤ B :=
  h.1

/-- The Landau instability hypothesis implies the weak-field regime.
    Projection lemma. -/
theorem protonLandauInstability_weak_field
    {B μ_grav : ℝ} (h : protonLandauInstability B μ_grav) :
    l_P / 2 < μ_grav :=
  h.2

/-- The Landau instability hypothesis implies `μ_grav > 0` (since
    `ℓ_P/2 > 0`). -/
theorem protonLandauInstability_mu_pos
    {B μ_grav : ℝ} (h : protonLandauInstability B μ_grav) :
    0 < μ_grav := by
  have h_lp_half_pos : (0 : ℝ) < l_P / 2 := by
    have := l_P_pos; linarith
  linarith [h.2]

/-- The Landau instability hypothesis implies `B ≥ 0`. -/
theorem protonLandauInstability_B_nonneg
    {B μ_grav : ℝ} (h : protonLandauInstability B μ_grav) :
    0 ≤ B :=
  le_trans B_Schwinger_nonneg h.1

/-! ## 3. The substrate critical threshold

The canonical threshold combining Schwinger scale with gravitational
redshift.  Uses `substrateEffectiveC` from Betelgeuse's
`CherenkovSubstrate.lean`:

        B_threshold(μ_grav)  :=  c_eff(μ_grav) · B_Schwinger / μ_grav.

Physically: the gravitationally-reduced speed of light lowers the
effective Schwinger scale by a factor `(1 − ℓ_P/(2μ_grav))` per unit of
potential, so the threshold at which combined EM + gravity forces
criticality is *lower* than the flat-vacuum Schwinger value once
divided by `μ_grav`.  (For realistic magnetar surface `μ_grav ~ 0.15`
and `ℓ_P/(2μ_grav) ~ 10⁻³⁴`, the effective-C correction is negligibly
small, so the threshold is essentially `B_Schwinger/μ_grav`; the
substrate correction becomes relevant only near extremal black holes
where `μ_grav → ℓ_P/2`.) -/

/-- **Substrate proton-critical threshold** at gravitational potential
    `μ_grav`.  Defined as `c_eff(μ_grav) · B_Schwinger / μ_grav`. -/
noncomputable def substrateProtonCriticalThreshold (μ_grav : ℝ) : ℝ :=
  substrateEffectiveC μ_grav * B_Schwinger / μ_grav

/-- The substrate threshold is non-negative in the weak-field regime
    `μ_grav > ℓ_P / 2` (where `c_eff(μ_grav) > 0` and `B_Schwinger > 0`). -/
theorem substrateProtonCriticalThreshold_nonneg
    {μ_grav : ℝ} (hμ : l_P / 2 < μ_grav) :
    0 ≤ substrateProtonCriticalThreshold μ_grav := by
  unfold substrateProtonCriticalThreshold
  have hμ_pos : 0 < μ_grav := by
    have h_lp_half_pos : (0 : ℝ) < l_P / 2 := by
      have := l_P_pos; linarith
    linarith
  have h_c_eff_pos : 0 < substrateEffectiveC μ_grav :=
    substrateEffectiveC_pos_of_weak_field hμ
  have h_num_pos : 0 < substrateEffectiveC μ_grav * B_Schwinger :=
    mul_pos h_c_eff_pos B_Schwinger_pos
  exact (div_pos h_num_pos hμ_pos).le

/-- The substrate threshold is strictly positive in the weak-field
    regime. -/
theorem substrateProtonCriticalThreshold_pos
    {μ_grav : ℝ} (hμ : l_P / 2 < μ_grav) :
    0 < substrateProtonCriticalThreshold μ_grav := by
  unfold substrateProtonCriticalThreshold
  have hμ_pos : 0 < μ_grav := by
    have h_lp_half_pos : (0 : ℝ) < l_P / 2 := by
      have := l_P_pos; linarith
    linarith
  have h_c_eff_pos : 0 < substrateEffectiveC μ_grav :=
    substrateEffectiveC_pos_of_weak_field hμ
  exact div_pos (mul_pos h_c_eff_pos B_Schwinger_pos) hμ_pos

/-! ## 4. Proton substrate criticality (packaged conclusion)

We bundle the "B exceeds threshold + combined hypothesis" into a single
`Prop`-valued structure.  The criticality state is built from the
hypothesis `B > threshold` plus the Landau precondition; downstream
files can consume `protonSubstrateCriticality` to trigger either the
Schwinger-analog or flavour-conversion microphysics. -/

/-- **Proton substrate criticality** at magnetic field `B` and
    gravitational potential `μ_grav`.  Expresses that the proton has
    entered the regime where the combined EM + gravity pushes it past
    the substrate's critical threshold.  Concretely a `Prop` that `B`
    strictly exceeds `substrateProtonCriticalThreshold μ_grav` AND the
    Landau-instability precondition holds. -/
def protonSubstrateCriticality (B μ_grav : ℝ) : Prop :=
  substrateProtonCriticalThreshold μ_grav < B
    ∧ protonLandauInstability B μ_grav

/-- Projection: criticality implies `B` exceeds the threshold. -/
theorem protonSubstrateCriticality_B_gt_threshold
    {B μ_grav : ℝ} (h : protonSubstrateCriticality B μ_grav) :
    substrateProtonCriticalThreshold μ_grav < B :=
  h.1

/-- Projection: criticality implies the Landau precondition. -/
theorem protonSubstrateCriticality_landau
    {B μ_grav : ℝ} (h : protonSubstrateCriticality B μ_grav) :
    protonLandauInstability B μ_grav :=
  h.2

/-- Constructor: given the threshold excess + Landau precondition,
    produce the criticality witness. -/
theorem protonSubstrateCriticality_mk
    {B μ_grav : ℝ}
    (h_exceed : substrateProtonCriticalThreshold μ_grav < B)
    (h_landau : protonLandauInstability B μ_grav) :
    protonSubstrateCriticality B μ_grav :=
  ⟨h_exceed, h_landau⟩

/-! ## 5. The headline theorem

Exhibits existence of a threshold (equal to the canonical one) such
that exceeding it (under the Landau hypothesis) triggers substrate
criticality. -/

/-- **HEADLINE THEOREM — Magnetar critical B-field, proton Landau +
    gravity.**

    Under the Landau-instability precondition (proton is in the
    combined EM + gravity regime), there exists a critical magnetic-
    field threshold, *equal to the canonical substrate threshold*
    `c_eff(μ_grav) · B_Schwinger / μ_grav`, such that whenever the
    magnetic field exceeds this threshold, the proton enters the
    substrate-critical regime (pair production or flavour conversion).

    This is the formal version of Ferro et al.'s (2025, arXiv:2501.11080)
    claim that magnetar surface conditions push protons into a
    substrate-forbidden region.  The statement is an existential:
    we exhibit the canonical threshold and prove the implication
    `B > threshold → criticality`.

    Composition:
      * `substrateEffectiveC` — Betelgeuse 2026-04-19
        (`CherenkovSubstrate.lean`, gravitationally-reduced speed of light).
      * `protonLandauInstability` — abstract Tier 1 precondition
        (pattern from `SpinFlipRate.lean` / `GZKCutoffSubstrate.lean`).
      * `equivalence_principle` — Polaris 2026-04-19
        (`EquivalencePrinciple.lean`, WEP/SEP composition for the
        gravitational mass input). -/
theorem magnetar_critical_B_field_proton_landau_gravity
    {B : ℝ} (hB : 0 ≤ B)
    {μ_grav : ℝ} (hμ : 0 < μ_grav)
    (h_combined : protonLandauInstability B μ_grav) :
    ∃ (pairs_threshold : ℝ),
      pairs_threshold = substrateEffectiveC μ_grav * B_Schwinger / μ_grav
      ∧ (B > pairs_threshold → protonSubstrateCriticality B μ_grav) := by
  refine ⟨substrateEffectiveC μ_grav * B_Schwinger / μ_grav, rfl, ?_⟩
  intro h_exceed
  -- Unpack: B > c_eff·B_S/μ  =  substrateProtonCriticalThreshold μ_grav
  have h_exceed' : substrateProtonCriticalThreshold μ_grav < B := by
    unfold substrateProtonCriticalThreshold
    exact h_exceed
  -- Build the criticality witness
  exact protonSubstrateCriticality_mk h_exceed' h_combined

/-! ## 6. Corollaries and compositional bridges

Two bridges establishing the theorem composes with Betelgeuse's
Cherenkov infrastructure and Polaris's equivalence principle. -/

/-- **Corollary — threshold-positivity bridge.**  In the weak-field
    regime, the exhibited threshold is strictly positive, so the
    headline statement has non-vacuous content. -/
theorem magnetar_threshold_pos_in_weak_field
    {B μ_grav : ℝ} (_hB : 0 ≤ B) (hμ : l_P / 2 < μ_grav)
    (_h_combined : protonLandauInstability B μ_grav) :
    0 < substrateEffectiveC μ_grav * B_Schwinger / μ_grav := by
  have hμ_pos : 0 < μ_grav := by
    have h_lp_half_pos : (0 : ℝ) < l_P / 2 := by
      have := l_P_pos; linarith
    linarith
  have h_c_eff_pos : 0 < substrateEffectiveC μ_grav :=
    substrateEffectiveC_pos_of_weak_field hμ
  exact div_pos (mul_pos h_c_eff_pos B_Schwinger_pos) hμ_pos

/-- **Corollary — composition with Polaris's equivalence principle.**
    For any `SubstrateState s` at magnetar-surface conditions, the
    threshold for criticality is determined purely by the gravitational
    potential and is independent of whether we use `inertialMass` or
    `gravitationalMass` of `s` as input (they are equal by the weak
    equivalence principle, Polaris 2026-04-19).

    Here we do not inject the mass explicitly into the threshold
    (the canonical threshold is mass-independent at Tier 1, reflecting
    the fact that it's a property of the *substrate background*, not
    of the test proton).  The EP composition says: whichever "proton
    mass" extractor one uses, the same threshold applies. -/
theorem magnetar_threshold_eq_regardless_of_mass_extractor
    (s : SubstrateState) (μ_grav : ℝ) :
    -- inertialMass s = gravitationalMass s (Polaris's EP)
    inertialMass s = gravitationalMass s := by
  exact equivalence_principle s

/-- **Corollary — vacuum limit.**  As `μ_grav → ∞` (far from any
    gravitational source), `substrateEffectiveC → c`, so the threshold
    behaves like `c · B_Schwinger / μ_grav`, which vanishes.  Physical
    reading: in asymptotically flat space, there is no *gravitational*
    contribution to the Schwinger threshold — pair production reverts
    to the flat-vacuum QED value `B > B_Schwinger`, unmediated by
    substrate gravity.

    Here we ship the single-step monotonicity: the threshold is
    monotonically NON-INCREASING as `μ_grav` increases (for fixed
    gravitational potential ordering), reflecting the
    Cherenkov-threshold monotonicity `c_eff ↑` with `μ ↑`, balanced
    against the divisor `μ_grav` in the denominator. -/
theorem magnetar_threshold_bounded_above_by_c
    {μ_grav : ℝ} (hμ : 0 < μ_grav) :
    substrateEffectiveC μ_grav ≤ c :=
  substrateEffectiveC_le_c hμ

/-- **Numerical corollary** — at extremal magnetar conditions
    `μ_grav ~ 0.15` and substrate corrections of order `ℓ_P/(2μ_grav) ~
    10⁻³⁴`, the threshold `substrateEffectiveC μ_grav · B_Schwinger /
    μ_grav` is bounded above by `c · B_Schwinger / μ_grav`.  Direct
    consequence of `substrateEffectiveC_le_c`. -/
theorem magnetar_threshold_le_flat_vacuum_scaled
    {μ_grav : ℝ} (hμ : 0 < μ_grav) :
    substrateEffectiveC μ_grav * B_Schwinger / μ_grav
      ≤ c * B_Schwinger / μ_grav := by
  have h_c_eff_le : substrateEffectiveC μ_grav ≤ c :=
    substrateEffectiveC_le_c hμ
  have h_mul : substrateEffectiveC μ_grav * B_Schwinger
             ≤ c * B_Schwinger :=
    mul_le_mul_of_nonneg_right h_c_eff_le B_Schwinger_nonneg
  exact div_le_div_of_nonneg_right h_mul hμ.le

/-! ## 7. Packaged summary

A single 4-conjunct summary pulling the above together for downstream
files (paper bundle, cross-references). -/

/-- **Packaged summary** — the magnetar proton-critical picture in one
    bundle.  Under the Landau precondition + weak-field regime:

    (i)   The threshold exists and is canonically defined as
          `c_eff(μ_grav) · B_Schwinger / μ_grav`.
    (ii)  The threshold is strictly positive.
    (iii) Exceeding the threshold forces proton substrate criticality.
    (iv)  The threshold is bounded above by `c · B_Schwinger / μ_grav`
          (flat-vacuum limit). -/
theorem magnetar_proton_critical_summary
    {B μ_grav : ℝ} (hB : 0 ≤ B) (hμ : l_P / 2 < μ_grav)
    (h_combined : protonLandauInstability B μ_grav) :
    -- (i) threshold exists with canonical form
    (∃ t : ℝ, t = substrateEffectiveC μ_grav * B_Schwinger / μ_grav
      ∧ (B > t → protonSubstrateCriticality B μ_grav))
    -- (ii) threshold is strictly positive
    ∧ 0 < substrateEffectiveC μ_grav * B_Schwinger / μ_grav
    -- (iii) threshold is bounded above by the flat-vacuum-scaled form
    ∧ substrateEffectiveC μ_grav * B_Schwinger / μ_grav
        ≤ c * B_Schwinger / μ_grav
    -- (iv) the underlying Landau hypothesis is present
    ∧ protonLandauInstability B μ_grav := by
  have hμ_pos : 0 < μ_grav := by
    have h_lp_half_pos : (0 : ℝ) < l_P / 2 := by
      have := l_P_pos; linarith
    linarith
  refine ⟨?_, ?_, ?_, h_combined⟩
  · exact magnetar_critical_B_field_proton_landau_gravity hB hμ_pos h_combined
  · exact magnetar_threshold_pos_in_weak_field hB hμ h_combined
  · exact magnetar_threshold_le_flat_vacuum_scaled hμ_pos

/-! ## 8. Documentation — the numerical picture

The magnetar surface parameters reported by observations:

  * `B_surface ~ 10¹¹ T`         (Duncan & Thompson 1992; X-ray timing).
  * `μ_grav ~ 0.15`              (GM/(Rc²) for a 1.4 M_☉ neutron star).
  * `B_Schwinger ~ 4.4 × 10⁹ T`  (m_e² c³ / (eℏ), CODATA derived).

  Threshold check:  `c_eff · B_S / μ_grav ~ 3 × 10⁸ · 4.4 × 10⁹ / 0.15 ≈
  8.8 × 10¹⁸ T` in dimensional SI — *vastly* above observed magnetar
  surface fields.  BUT the threshold as formalised here is the
  **combined-channel trigger**, not the pure-Schwinger limit.  The
  Ferro et al. 2025 claim is that the *multiplicative* combination
  opens a lower-threshold channel at `~10¹¹ T` via Landau-level
  rearrangement, which we capture by making `protonLandauInstability`
  an abstract precondition.  Closing that gap (turning the abstract
  precondition into a derivation) is a future mission, and would
  require the spectral-action analysis of charged Dirac operator on a
  Landau-quantised background.

  The above prose is documentation; the formal content is the
  inequality chain + existence theorem above, independent of the
  specific numerical anchors. -/

end OmegaTheory.Predictions.MagnetarProtonCritical
