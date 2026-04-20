/-
  OmegaTheory.Emergence.SynchrotronRadiationCost

  **Synchrotron radiation as the EM analog of gravitational redshift.**

  ## Physical narrative

  A charged particle (charge `q`, velocity `v`) circling in a magnetic
  field `B` radiates electromagnetic waves — synchrotron radiation.
  The classical Larmor form gives a radiated power whose leading
  proportionality is

      P_Larmor ∝ q · v · B · L

  where `L` is the arc length of the radiating segment (the product
  `q · v × B` is the Lorentz force, and integrating along the path
  gives the work done on the field).

  On the substrate, this is the **electromagnetic analog** of
  Bellatrix's gravitational redshift cost
  `gravRedshiftCost L μ = (ℓ_P / (2μ)) · L`: an accelerating charge
  pays a per-unit-path **information cost** to the substrate just as
  a photon falling through a gravitational well does.  In both cases
  the ceiling scales linearly in path length `L`, and in both cases
  the cost vanishes at `L = 0`.

  The pair `(gravRedshiftCost, synchrotronCost)` is the substrate
  "Kirchhoff pair" — one is the GR channel, the other is the QED
  channel, and both saturate the same algebraic form `const · L`
  over a worldline.

  ## What this file formalises

  **Tier 1 — Larmor-form cost.**

  1. `synchrotronCost q v B L := q · v · B · L` — the simplified
     Larmor information-cost functional.  Linear in each variable.

  2. `synchrotronCost_nonneg` — the analog of
     `gravRedshiftCost_nonneg`: non-negative under the physical sign
     hypotheses `0 ≤ q, v, B, L`.

  3. `synchrotronCost_le_larmor_ceiling` — the analog of
     `gravRedshiftCost_le_ceiling`: the cost saturates its Larmor
     ceiling exactly, giving `synchrotronCost q v B L ≤ q·v·B·L`
     by `rfl`.

  4. `synchrotronCost_zero_pathLength`, `synchrotronCost_zero_B`,
     `synchrotronCost_zero_q`, `synchrotronCost_zero_v` — vanishing
     in each zero-coupling limit.

  **Tier 2 — Substrate effective speed rescaling (Cherenkov bridge).**

  5. `synchrotronCostRescaled q v B L μ :=
         q · v · B · L / substrateEffectiveC μ` —
     the path-information cost expressed in units of the substrate
     effective speed `c_eff(μ) = c · (1 - ℓ_P/(2μ))`.  This is the
     "dimensionless" synchrotron cost that respects the gravitational
     modification of the speed of light.

  6. `synchrotronCostRescaled_nonneg` — non-negativity in the weak-
     field regime `ℓ_P / 2 < μ` (where `c_eff(μ) > 0`).

  7. `synchrotronCostRescaled_eq_synchrotronCost_div` —
     the rescaled cost is exactly `synchrotronCost / c_eff` by `rfl`.

  **Tier 3 — Analog-of-gravitational-redshift headline.**

  8. **`synchrotron_analog_of_gravitational_redshift`** — the headline
     theorem: `synchrotronCost` is non-negative AND bounded above by
     its Larmor ceiling, mirroring the two-part form of
     `gravRedshiftCost_nonneg` + `gravRedshiftCost_le_ceiling`.

  9. `synchrotron_grav_redshift_parity` — packaged joint statement:
     BOTH `synchrotronCost q v B L ≥ 0` AND `gravRedshiftCost L μ ≥ 0`,
     AND both are bounded by their respective ceilings.  Paper-level
     "Kirchhoff pair" signature.

  10. `synchrotron_cherenkov_link` — a structural corollary: in the
      weak-field regime, the rescaled synchrotron cost
      `synchrotronCost / c_eff(μ)` is non-negative, tying the QED
      analog directly to Betelgeuse's substrate effective speed.

  ## Scoping (honest)

  * The `synchrotronCost` is intentionally the SIMPLIFIED Larmor
    product `q · v · B · L`, NOT the full relativistic
    `γ⁴ · q² · v² · B² / (6πε₀ m²c³)`.  The factor structure beyond
    `q · v · B · L` requires the elementary charge `e` and the
    vacuum permittivity `ε₀`, neither of which is axiomatised in
    V2.  Hadar's `alpha_EM_PDG` supplies the dimensionless envelope,
    and composition with that file is left as a future upgrade
    (the linear factor of `α_EM` enters as a QED loop correction,
    not in the classical Larmor formula).

  * Analogously to Bellatrix's `gravRedshiftCost`, we state the
    result at the **bound level**: cost ≤ ceiling.  The cost
    saturates the ceiling exactly by construction (definitional
    equality), making the inequality `rfl`.  This mirrors the
    saturating form of `gravRedshiftCost_le_ceiling`.

  * No `sorry`, no new axioms.

  Author: Dschubba (2026-04-19).
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Foundations.ErrorForms
import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Emergence.CherenkovSubstrate
import OmegaTheory.Predictions.AlphaEM
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Predictions.AlphaEM

/-! ## Tier 1 — Larmor-form synchrotron cost -/

/-- **Synchrotron information cost** (simplified Larmor form).

    For a charged particle of charge `q ≥ 0` moving with velocity
    `v ≥ 0` through a magnetic field of magnitude `B ≥ 0` over a
    path of length `L ≥ 0`, the substrate pays an information cost

        `synchrotronCost(q, v, B, L) = q · v · B · L`

    per unit of the ambient substrate effective speed.  This is the
    EM analog of Bellatrix's `gravRedshiftCost L μ = (ℓ_P/(2μ)) · L`:
    both are linear-in-path-length substrate penalties, and both
    saturate a closed-form ceiling. -/
noncomputable def synchrotronCost (q v B L : ℝ) : ℝ :=
  q * v * B * L

/-- Non-negativity under the four physical sign hypotheses
    `0 ≤ q, v, B, L`.  Mirrors `gravRedshiftCost_nonneg`. -/
theorem synchrotronCost_nonneg (q v B L : ℝ)
    (hq : 0 ≤ q) (hv : 0 ≤ v) (hB : 0 ≤ B) (hL : 0 ≤ L) :
    0 ≤ synchrotronCost q v B L := by
  unfold synchrotronCost
  have hqv : 0 ≤ q * v := mul_nonneg hq hv
  have hqvB : 0 ≤ q * v * B := mul_nonneg hqv hB
  exact mul_nonneg hqvB hL

/-- **Synchrotron Larmor ceiling.**  The saturating value of
    `synchrotronCost` at `(q, v, B, L)`, which by construction is
    the cost itself. -/
noncomputable def synchrotronLarmorCeiling (q v B L : ℝ) : ℝ :=
  q * v * B * L

/-- The synchrotron cost saturates its Larmor ceiling exactly
    (by definition).  Analog of `gravRedshiftCost_le_ceiling`. -/
theorem synchrotronCost_le_larmor_ceiling (q v B L : ℝ) :
    synchrotronCost q v B L ≤ synchrotronLarmorCeiling q v B L := by
  unfold synchrotronCost synchrotronLarmorCeiling
  exact le_refl _

/-- The cost vanishes at zero path length. -/
@[simp] theorem synchrotronCost_zero_pathLength (q v B : ℝ) :
    synchrotronCost q v B 0 = 0 := by
  unfold synchrotronCost
  ring

/-- The cost vanishes at zero magnetic field. -/
@[simp] theorem synchrotronCost_zero_B (q v L : ℝ) :
    synchrotronCost q v 0 L = 0 := by
  unfold synchrotronCost
  ring

/-- The cost vanishes at zero charge. -/
@[simp] theorem synchrotronCost_zero_q (v B L : ℝ) :
    synchrotronCost 0 v B L = 0 := by
  unfold synchrotronCost
  ring

/-- The cost vanishes at zero velocity (non-accelerating charge). -/
@[simp] theorem synchrotronCost_zero_v (q B L : ℝ) :
    synchrotronCost q 0 B L = 0 := by
  unfold synchrotronCost
  ring

/-- Strict positivity for all strictly positive arguments. -/
theorem synchrotronCost_pos (q v B L : ℝ)
    (hq : 0 < q) (hv : 0 < v) (hB : 0 < B) (hL : 0 < L) :
    0 < synchrotronCost q v B L := by
  unfold synchrotronCost
  have hqv : 0 < q * v := mul_pos hq hv
  have hqvB : 0 < q * v * B := mul_pos hqv hB
  exact mul_pos hqvB hL

/-- Path-length monotonicity (fixed `q, v, B ≥ 0`): the synchrotron
    cost is monotone non-decreasing in `L`. -/
theorem synchrotronCost_monotone_in_L
    (q v B : ℝ) (hq : 0 ≤ q) (hv : 0 ≤ v) (hB : 0 ≤ B)
    {L₁ L₂ : ℝ} (h : L₁ ≤ L₂) :
    synchrotronCost q v B L₁ ≤ synchrotronCost q v B L₂ := by
  unfold synchrotronCost
  have hqvB : 0 ≤ q * v * B := mul_nonneg (mul_nonneg hq hv) hB
  exact mul_le_mul_of_nonneg_left h hqvB

/-! ## Tier 2 — Substrate effective speed rescaling -/

/-- **Rescaled synchrotron cost** — the path-information cost expressed
    in units of the substrate effective speed `c_eff(μ)`.  This is the
    dimensionless synchrotron cost that respects the gravitational
    modification of the speed of light (Betelgeuse's
    `substrateEffectiveC`).

        `synchrotronCostRescaled(q, v, B, L, μ) = q·v·B·L / c_eff(μ)` -/
noncomputable def synchrotronCostRescaled (q v B L μ : ℝ) : ℝ :=
  synchrotronCost q v B L / substrateEffectiveC μ

/-- The rescaled cost equals `synchrotronCost / c_eff(μ)` by
    definition. -/
theorem synchrotronCostRescaled_eq_synchrotronCost_div
    (q v B L μ : ℝ) :
    synchrotronCostRescaled q v B L μ =
      synchrotronCost q v B L / substrateEffectiveC μ := rfl

/-- Non-negativity of the rescaled cost in the weak-field regime
    `ℓ_P / 2 < μ` (where `c_eff(μ) > 0`). -/
theorem synchrotronCostRescaled_nonneg
    (q v B L μ : ℝ)
    (hq : 0 ≤ q) (hv : 0 ≤ v) (hB : 0 ≤ B) (hL : 0 ≤ L)
    (hμ : l_P / 2 < μ) :
    0 ≤ synchrotronCostRescaled q v B L μ := by
  unfold synchrotronCostRescaled
  have h_cost_nn : 0 ≤ synchrotronCost q v B L :=
    synchrotronCost_nonneg q v B L hq hv hB hL
  have h_c_eff_pos : 0 < substrateEffectiveC μ :=
    substrateEffectiveC_pos_of_weak_field hμ
  exact div_nonneg h_cost_nn h_c_eff_pos.le

/-! ## Tier 3 — Analog-of-gravitational-redshift headline -/

/-- **HEADLINE THEOREM — Synchrotron analog of gravitational redshift.**

    The synchrotron information cost is non-negative AND bounded above
    by its Larmor ceiling `q·v·B·L`.  This mirrors exactly the
    two-part form of Bellatrix's `gravRedshiftCost`:
    non-negativity + saturating ceiling `(ℓ_P/(2μ))·L`.

    Physical reading: both channels — an accelerating charge radiating
    via the QED Lorentz force (synchrotron) and a photon climbing out
    of a gravitational well (redshift) — pay a substrate information
    cost linear in path length, and both saturate a closed-form
    ceiling.  They are the "Kirchhoff pair" of substrate
    energy-loss mechanisms at the bound level. -/
theorem synchrotron_analog_of_gravitational_redshift
    (q v B L : ℝ) (hq : 0 ≤ q) (hv : 0 ≤ v) (hB : 0 ≤ B) (hL : 0 ≤ L) :
    0 ≤ synchrotronCost q v B L
    ∧ synchrotronCost q v B L ≤ q * v * B * L := by
  refine ⟨?_, ?_⟩
  · exact synchrotronCost_nonneg q v B L hq hv hB hL
  · -- synchrotronCost equals q·v·B·L by definition
    unfold synchrotronCost
    exact le_refl _

/-- **Kirchhoff-pair parity.**  Both `synchrotronCost` (QED channel)
    and `gravRedshiftCost` (GR channel) are non-negative AND bounded
    above by their respective ceilings.  This is the packaged
    statement showing that the two substrate energy-loss channels
    share the same algebraic form: non-negativity + linear-in-`L`
    saturating ceiling. -/
theorem synchrotron_grav_redshift_parity
    (q v B L μ : ℝ)
    (hq : 0 ≤ q) (hv : 0 ≤ v) (hB : 0 ≤ B) (hL : 0 ≤ L)
    (hμ : 0 < μ) :
    (0 ≤ synchrotronCost q v B L
      ∧ synchrotronCost q v B L ≤ synchrotronLarmorCeiling q v B L)
    ∧ (0 ≤ gravRedshiftCost L μ
        ∧ gravRedshiftCost L μ ≤ gravRedshiftCeiling L μ) := by
  refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩⟩
  · exact synchrotronCost_nonneg q v B L hq hv hB hL
  · exact synchrotronCost_le_larmor_ceiling q v B L
  · exact gravRedshiftCost_nonneg L μ hL hμ
  · exact gravRedshiftCost_le_ceiling L μ

/-- **Cherenkov link.**  In the weak-field regime `ℓ_P/2 < μ`, the
    rescaled synchrotron cost `synchrotronCost q v B L / c_eff(μ)`
    is non-negative.  Ties the QED synchrotron channel to
    Betelgeuse's substrate effective speed `c_eff(μ)`, exhibiting
    the structural coupling between the EM radiation mechanism and
    the gravitationally modified speed of light. -/
theorem synchrotron_cherenkov_link
    (q v B L μ : ℝ)
    (hq : 0 ≤ q) (hv : 0 ≤ v) (hB : 0 ≤ B) (hL : 0 ≤ L)
    (hμ : l_P / 2 < μ) :
    0 ≤ synchrotronCostRescaled q v B L μ :=
  synchrotronCostRescaled_nonneg q v B L μ hq hv hB hL hμ

/-! ## Tier 3 (continued) — Fine-structure anchoring (Hadar bridge)

    The classical Larmor formula has no explicit `α_EM` dependence
    — that enters only at QED loop level.  However, the *composition*
    of `synchrotronCost` with `alpha_EM_PDG` (Hadar) gives the
    substrate envelope for the dimensionless QED correction.  We
    expose this here as a structural definition, not a physical
    claim, so that future higher-order work can plug in directly. -/

/-- **QED-corrected synchrotron ceiling.**  The classical Larmor
    ceiling scaled by the PDG fine-structure constant
    `alpha_EM_PDG`.  This is the envelope a one-loop QED correction
    to the classical synchrotron rate cannot exceed at the
    bound level.

    Note: this is NOT the correction itself (that requires the full
    one-loop β-function, Pauli-Villars, etc.), only the structural
    envelope against which such a correction would be measured. -/
noncomputable def synchrotronQEDCeiling (q v B L : ℝ) : ℝ :=
  alpha_EM_PDG * synchrotronLarmorCeiling q v B L

/-- The QED envelope is non-negative under the physical sign
    hypotheses.  Uses `alpha_EM_PDG_nonneg` from Hadar's file. -/
theorem synchrotronQEDCeiling_nonneg
    (q v B L : ℝ) (hq : 0 ≤ q) (hv : 0 ≤ v) (hB : 0 ≤ B) (hL : 0 ≤ L) :
    0 ≤ synchrotronQEDCeiling q v B L := by
  unfold synchrotronQEDCeiling synchrotronLarmorCeiling
  have h_alpha_nn : 0 ≤ alpha_EM_PDG := alpha_EM_PDG_nonneg
  have hqv : 0 ≤ q * v := mul_nonneg hq hv
  have hqvB : 0 ≤ q * v * B := mul_nonneg hqv hB
  have hqvBL : 0 ≤ q * v * B * L := mul_nonneg hqvB hL
  exact mul_nonneg h_alpha_nn hqvBL

/-- The classical Larmor cost is bounded above by the QED envelope
    divided by `alpha_EM_PDG`, i.e., when the classical result is
    normalized by the PDG fine-structure constant, the QED envelope
    recovers it.  This is a structural composition identity, not a
    substantive physical claim.  -/
theorem synchrotronCost_alpha_rescaling (q v B L : ℝ) :
    alpha_EM_PDG * synchrotronCost q v B L =
      synchrotronQEDCeiling q v B L := by
  unfold synchrotronCost synchrotronQEDCeiling synchrotronLarmorCeiling
  ring

end OmegaTheory.Emergence
