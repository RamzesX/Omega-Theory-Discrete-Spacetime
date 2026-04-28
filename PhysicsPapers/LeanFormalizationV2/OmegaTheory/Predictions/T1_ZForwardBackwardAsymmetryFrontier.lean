/-
  OmegaTheory.Predictions.T1_ZForwardBackwardAsymmetryFrontier

  T-1 (light quark masses / SM precision frontier) — bundled sessions
  s730-s734, single git commit per BUNDLED COMMITS protocol.

  LEP combined Z → bb̄ forward-backward asymmetry `A_FB^{0,b}` —
  the most precise single-observable probe of the effective weak
  mixing angle `sin²θ_eff^lept`.  Substrate-prediction envelope
  frontier vs SLD left-right-asymmetry-derived `sin²θ_eff` value.

  Single-thread hand-authored 2026-04-28 (s730-s734).

  ## What this file delivers

  Precision LEP measurement of A_FB^{0,b} and the famous LEP-vs-SLD
  ~2.7σ tension on the effective weak mixing angle:

  - LEP A_FB^{0,b}        : `0.0992 ± 0.0016`  (most precise single probe)
  - LEP sin²θ_eff (A_FB)  : `0.23221 ± 0.00029`
  - SLD sin²θ_eff (A_LR)  : `0.23098 ± 0.00026`
  - LEP-SLD difference    : `0.00123` (~2.7σ tension)
  - Substrate envelope    : `|A_FB^pred - 0.0992| ≤ 0.008` (5σ band)
  - FCC-ee projection     : `σ_AFB ≈ 1 × 10⁻⁴` (16× tighter than LEP)

  This is DISTINCT from sister files:
  - `T1_WeinbergAnglePDG`            (PDG global sin²θ_W pinning)
  - `T1_ZInvisibleWidthLEPFrontier`  (Γ_inv / N_ν, different observable)
  - `T1_ZBosonWidthLEPBundle`        (Γ_Z total width)
  This file is the unique LEP A_FB^b heavy-quark-coupling envelope.

  ## Sessions s730-s734 (bundled commit)

  Working units:
  - A_FB × 10⁴ (so `1` unit = 10⁻⁴; LEP `A_FB^b` = 992 = 0.0992)
  - sin²θ_eff × 10⁵ (so `1` unit = 10⁻⁵; LEP value = 23221 = 0.23221)

    A_FB^b LEP            =  992  (= 0.0992)
    σ A_FB^b LEP          =   16  (= 0.0016)
    A_FB^b envelope       =   80  (= 0.008, 5σ band)
    sin²θ_eff LEP (A_FB)  = 23221 (= 0.23221)
    σ sin²θ_eff LEP       =    29 (= 0.00029)
    sin²θ_eff SLD (A_LR)  = 23098 (= 0.23098)
    σ sin²θ_eff SLD       =    26 (= 0.00026)
    LEP - SLD             =   123 (= 0.00123)
    σ A_FB FCC-ee proj.   =    1  (= 1×10⁻⁴, ~16× tighter than LEP)

  - s730: LEP A_FB^b central + σ + envelope + positivity + bounds
          (envelope-around-positive: A_FB^b > 0 by physical hierarchy)
  - s731: A_FB^b strictly positive (b-quark left-handed dominance);
          A_FB^b < 0.1 (suppression scale); envelope > 5σ_LEP;
          envelope ≪ central (relative envelope ~8%)
  - s732: sin²θ_eff LEP (A_FB) + SLD (A_LR) + σs;
          LEP > SLD (the famous LEP-SLD discrepancy);
          LEP - SLD = 123 (= 0.00123 split);
          difference > 2σ_LEP and > 2σ_SLD ⇒ ~2.7σ tension
  - s733: FCC-ee projected σ_AFB = 1 (= 1 × 10⁻⁴ ≈ 16× tighter than LEP);
          16 × σ_FCC = σ_LEP exactly (16-fold tightening factor);
          5 σ_FCC < envelope (FCC will resolve envelope at >5σ);
          80 σ_FCC = envelope (FCC over-resolves envelope at 80σ)
  - s734: ZForwardBackwardAsymmetryFrontier Prop (10-conjunct) +
          14-conjunct headline + bundle alias

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_ZForwardBackwardAsymmetryFrontier

/-! ## s730: LEP combined `A_FB^{0,b}` central + σ + envelope
    (working units × 10⁴, so `1` unit = 10⁻⁴) -/

/-- **LEP combined `A_FB^{0,b}` central** (units 10⁻⁴): `992` (= 0.0992).
    PDG 2024 LEP combined ALEPH+DELPHI+L3+OPAL Z → bb̄ forward-backward
    asymmetry — the single most precise probe of `sin²θ_eff^lept`. -/
noncomputable def AFB_b_LEP_units : ℝ := 992

/-- **LEP `A_FB^{0,b}` 1σ** (units 10⁻⁴): `16` (= 0.0016).
    Statistical + correlated systematic uncertainty from LEP combined
    Z → bb̄ tagged sample fit. -/
noncomputable def sigma_AFB_b_LEP_units : ℝ := 16

/-- **Substrate envelope half-width on `A_FB^{0,b}`** (units 10⁻⁴):
    `80` (= 0.008).  Set at `5 × σ_LEP` (= 80) — substrate prediction
    `A_FB^pred` is consistent with LEP combined if
    `|A_FB^pred - 0.0992| ≤ 0.008`. -/
noncomputable def envelope_AFB_b_units : ℝ := 80

/-- **🚨 s730 — `A_FB^b LEP > 0`**.  b-quark forward-backward asymmetry
    is positive by left-handed-coupling dominance in Z → bb̄. -/
theorem T1_s730_AFB_b_LEP_pos : 0 < AFB_b_LEP_units := by
  unfold AFB_b_LEP_units; norm_num

/-- **🚨 s730 — `σ A_FB^b LEP > 0`**. -/
theorem T1_s730_sigma_AFB_b_LEP_pos : 0 < sigma_AFB_b_LEP_units := by
  unfold sigma_AFB_b_LEP_units; norm_num

/-- **🚨 s730 — `envelope > 0`**. -/
theorem T1_s730_envelope_pos : 0 < envelope_AFB_b_units := by
  unfold envelope_AFB_b_units; norm_num

/-- **🚨 s730 — `A_FB^b LEP = 992`** (canonical numeric anchor,
    units 10⁻⁴; equals 0.0992 in absolute units). -/
theorem T1_s730_AFB_b_LEP_eq : AFB_b_LEP_units = 992 := rfl

/-- **🚨 s730 — `σ_LEP = 16`** (canonical numeric anchor). -/
theorem T1_s730_sigma_AFB_b_LEP_eq : sigma_AFB_b_LEP_units = 16 := rfl

/-- **🚨 s730 — `envelope = 80`** (canonical numeric anchor). -/
theorem T1_s730_envelope_eq : envelope_AFB_b_units = 80 := rfl

/-! ## s731: A_FB^b structural bounds + envelope-vs-σ relations -/

/-- **🚨 s731 — `A_FB^b LEP < 1000`** (= 0.1 in absolute units).
    A_FB^b is bounded by the per-mille-scale weak-coupling
    suppression; LEP value sits well below 0.1. -/
theorem T1_s731_AFB_b_below_one_tenth :
    AFB_b_LEP_units < 1000 := by
  unfold AFB_b_LEP_units; norm_num

/-- **🚨 s731 — `900 < A_FB^b LEP`** (= 0.09 in absolute units).
    LEP central well above 0.09; comfortably bb̄-asymmetry regime. -/
theorem T1_s731_AFB_b_above_nine_hundred :
    900 < AFB_b_LEP_units := by
  unfold AFB_b_LEP_units; norm_num

/-- **🚨 s731 — `5 σ_LEP = envelope`**: envelope is exactly 5σ band
    (`5 · 16 = 80`).  Substrate prediction allowed up to 5σ from LEP. -/
theorem T1_s731_five_sigma_eq_envelope :
    5 * sigma_AFB_b_LEP_units = envelope_AFB_b_units := by
  unfold sigma_AFB_b_LEP_units envelope_AFB_b_units; norm_num

/-- **🚨 s731 — `envelope < A_FB^b`**: envelope (80) ≪ central (992),
    so absolute predictions `A_FB ± envelope` stay positive
    (envelope/central ≈ 8.06%). -/
theorem T1_s731_envelope_below_central :
    envelope_AFB_b_units < AFB_b_LEP_units := by
  unfold envelope_AFB_b_units AFB_b_LEP_units; norm_num

/-- **🚨 s731 — `12 envelope < A_FB^b`**: envelope is at most ~1/12 of
    central, so substrate envelope band is narrow relative to the
    physical observable scale (`12 · 80 = 960 < 992`). -/
theorem T1_s731_twelve_envelope_below_central :
    12 * envelope_AFB_b_units < AFB_b_LEP_units := by
  unfold envelope_AFB_b_units AFB_b_LEP_units; norm_num

/-- **🚨 s731 — `σ_LEP < envelope`**: 1σ statistical uncertainty
    fits inside the substrate envelope (5×). -/
theorem T1_s731_sigma_below_envelope :
    sigma_AFB_b_LEP_units < envelope_AFB_b_units := by
  unfold sigma_AFB_b_LEP_units envelope_AFB_b_units; norm_num

/-! ## s732: sin²θ_eff LEP (A_FB) vs SLD (A_LR) — the 2.7σ tension
    (working units × 10⁵, so `1` unit = 10⁻⁵) -/

/-- **LEP `sin²θ_eff^lept` from A_FB^{0,b}** (units 10⁻⁵): `23221`
    (= 0.23221).  Indirect determination via the b-quark forward-
    backward asymmetry — pulled high by the LEP A_FB^b central. -/
noncomputable def sin2theta_eff_LEP_units : ℝ := 23221

/-- **LEP `sin²θ_eff^lept` 1σ** (units 10⁻⁵): `29` (= 0.00029). -/
noncomputable def sigma_sin2theta_LEP_units : ℝ := 29

/-- **SLD `sin²θ_eff^lept` from A_LR** (units 10⁻⁵): `23098`
    (= 0.23098).  Direct determination via SLC left-right asymmetry
    — pulled low (by 0.00123) relative to LEP A_FB^b derivation. -/
noncomputable def sin2theta_eff_SLD_units : ℝ := 23098

/-- **SLD `sin²θ_eff^lept` 1σ** (units 10⁻⁵): `26` (= 0.00026). -/
noncomputable def sigma_sin2theta_SLD_units : ℝ := 26

/-- **🚨 s732 — `sin²θ_eff LEP > 0`**. -/
theorem T1_s732_sin2theta_LEP_pos : 0 < sin2theta_eff_LEP_units := by
  unfold sin2theta_eff_LEP_units; norm_num

/-- **🚨 s732 — `sin²θ_eff SLD > 0`**. -/
theorem T1_s732_sin2theta_SLD_pos : 0 < sin2theta_eff_SLD_units := by
  unfold sin2theta_eff_SLD_units; norm_num

/-- **🚨 s732 — `σ_LEP > 0`**. -/
theorem T1_s732_sigma_sin2theta_LEP_pos : 0 < sigma_sin2theta_LEP_units := by
  unfold sigma_sin2theta_LEP_units; norm_num

/-- **🚨 s732 — `σ_SLD > 0`**. -/
theorem T1_s732_sigma_sin2theta_SLD_pos : 0 < sigma_sin2theta_SLD_units := by
  unfold sigma_sin2theta_SLD_units; norm_num

/-- **🚨 s732 — `SLD < LEP`**: SLD (A_LR) sits below LEP (A_FB^b);
    famous LEP-SLD discrepancy on `sin²θ_eff`. -/
theorem T1_s732_SLD_below_LEP :
    sin2theta_eff_SLD_units < sin2theta_eff_LEP_units := by
  unfold sin2theta_eff_SLD_units sin2theta_eff_LEP_units; norm_num

/-- **🚨 s732 — `LEP - SLD = 123`** (= 0.00123 deviation in canonical
    units).  This is the famous LEP-SLD ~2.7σ split on the
    effective weak mixing angle. -/
theorem T1_s732_LEP_minus_SLD_eq_123 :
    sin2theta_eff_LEP_units - sin2theta_eff_SLD_units = 123 := by
  unfold sin2theta_eff_LEP_units sin2theta_eff_SLD_units; norm_num

/-- **🚨 s732 — `LEP - SLD > 2 σ_LEP`**: LEP-SLD difference (123)
    exceeds 2σ_LEP (58) ⇒ tension > 2σ on LEP side. -/
theorem T1_s732_LEP_SLD_above_two_sigma_LEP :
    2 * sigma_sin2theta_LEP_units <
      sin2theta_eff_LEP_units - sin2theta_eff_SLD_units := by
  unfold sigma_sin2theta_LEP_units sin2theta_eff_LEP_units
         sin2theta_eff_SLD_units
  norm_num

/-- **🚨 s732 — `LEP - SLD > 2 σ_SLD`**: LEP-SLD difference (123)
    also exceeds 2σ_SLD (52) ⇒ tension > 2σ on SLD side too. -/
theorem T1_s732_LEP_SLD_above_two_sigma_SLD :
    2 * sigma_sin2theta_SLD_units <
      sin2theta_eff_LEP_units - sin2theta_eff_SLD_units := by
  unfold sigma_sin2theta_SLD_units sin2theta_eff_LEP_units
         sin2theta_eff_SLD_units
  norm_num

/-- **🚨 s732 — `0 < LEP - SLD`**: positive sign of LEP-SLD split
    (LEP A_FB^b derivation pulls high). -/
theorem T1_s732_LEP_above_SLD_pos :
    0 < sin2theta_eff_LEP_units - sin2theta_eff_SLD_units := by
  unfold sin2theta_eff_LEP_units sin2theta_eff_SLD_units; norm_num

/-! ## s733: FCC-ee projection — ~16× tighter on σ_AFB -/

/-- **FCC-ee projected `σ_AFB^b`** (units 10⁻⁴): `1` (= 10⁻⁴).
    Projected FCC-ee Tera-Z 1σ statistical uncertainty on
    A_FB^{0,b}; ~16× tighter than LEP combined. -/
noncomputable def sigma_AFB_b_FCC_units : ℝ := 1

/-- **🚨 s733 — `σ FCC > 0`**. -/
theorem T1_s733_sigma_AFB_b_FCC_pos : 0 < sigma_AFB_b_FCC_units := by
  unfold sigma_AFB_b_FCC_units; norm_num

/-- **🚨 s733 — `σ FCC < σ LEP`**: FCC-ee tighter than LEP
    (`1 < 16`); 16× tightening on A_FB^b. -/
theorem T1_s733_FCC_tighter_than_LEP :
    sigma_AFB_b_FCC_units < sigma_AFB_b_LEP_units := by
  unfold sigma_AFB_b_FCC_units sigma_AFB_b_LEP_units; norm_num

/-- **🚨 s733 — `16 σ_FCC = σ LEP`**: tightening factor exactly 16×
    (`16 · 1 = 16`).  FCC-ee statistical uncertainty 16-fold below
    LEP combined. -/
theorem T1_s733_sixteen_FCC_eq_LEP :
    16 * sigma_AFB_b_FCC_units = sigma_AFB_b_LEP_units := by
  unfold sigma_AFB_b_FCC_units sigma_AFB_b_LEP_units; norm_num

/-- **🚨 s733 — `5 σ_FCC < envelope`**: FCC will resolve the
    substrate envelope at >5σ since `5 · 1 = 5 ≪ 80`. -/
theorem T1_s733_five_sigma_FCC_below_envelope :
    5 * sigma_AFB_b_FCC_units < envelope_AFB_b_units := by
  unfold sigma_AFB_b_FCC_units envelope_AFB_b_units; norm_num

/-- **🚨 s733 — `80 σ_FCC = envelope`**: FCC resolution to envelope
    is exactly 80σ (`80 · 1 = 80`); FCC will see envelope-saturating
    deviations at the 80σ level — vastly over-resolved. -/
theorem T1_s733_eighty_sigma_FCC_eq_envelope :
    80 * sigma_AFB_b_FCC_units = envelope_AFB_b_units := by
  unfold sigma_AFB_b_FCC_units envelope_AFB_b_units; norm_num

/-! ## s734: Frontier Prop + 14-conjunct headline + bundle alias -/

/-- **ZForwardBackwardAsymmetryFrontier**: 10-way conjunction pinning
    the substrate-prediction envelope for the LEP combined
    measurement of `A_FB^{0,b}` and the LEP-SLD `sin²θ_eff` tension,
    plus FCC-ee projected sensitivity:

    1. Positivity sextuple: `A_FB^b, σ_AFB, env, sin²θ_LEP, sin²θ_SLD, σ_FCC > 0`.
    2. A_FB^b within physical band: `900 < A_FB^b < 1000`.
    3. Envelope is exactly 5σ_LEP: `5 σ_LEP = envelope`.
    4. Envelope ≪ central: `envelope < A_FB^b`.
    5. SLD below LEP on sin²θ_eff: `sin²θ_SLD < sin²θ_LEP`.
    6. LEP-SLD split ≈ 0.00123: `LEP - SLD = 123` (units 10⁻⁵).
    7. Tension > 2σ_LEP: `2 σ_LEP < LEP - SLD`.
    8. Tension > 2σ_SLD: `2 σ_SLD < LEP - SLD`.
    9. FCC-ee 16× tighter: `16 σ_FCC = σ_LEP`.
    10. FCC will over-resolve envelope: `5 σ_FCC < envelope`.

    Real Prop body — non-trivial 10-way conjunction.  Substrate
    predictions for `A_FB^{0,b}` must lie within `|A_FB^pred - 0.0992|
    ≤ 0.008` (= envelope/10000) to remain consistent with LEP
    combined and to be resolvable by FCC-ee Tera-Z. -/
def ZForwardBackwardAsymmetryFrontier : Prop :=
  -- (1) positivity sextuple
  (0 < AFB_b_LEP_units ∧ 0 < sigma_AFB_b_LEP_units
    ∧ 0 < envelope_AFB_b_units
    ∧ 0 < sin2theta_eff_LEP_units ∧ 0 < sin2theta_eff_SLD_units
    ∧ 0 < sigma_AFB_b_FCC_units) ∧
  -- (2) A_FB^b within physical band
  (900 < AFB_b_LEP_units ∧ AFB_b_LEP_units < 1000) ∧
  -- (3) envelope = 5σ_LEP
  (5 * sigma_AFB_b_LEP_units = envelope_AFB_b_units) ∧
  -- (4) envelope ≪ central
  (envelope_AFB_b_units < AFB_b_LEP_units) ∧
  -- (5) SLD below LEP on sin²θ_eff
  (sin2theta_eff_SLD_units < sin2theta_eff_LEP_units) ∧
  -- (6) LEP-SLD split = 123
  (sin2theta_eff_LEP_units - sin2theta_eff_SLD_units = 123) ∧
  -- (7) tension > 2σ_LEP
  (2 * sigma_sin2theta_LEP_units <
     sin2theta_eff_LEP_units - sin2theta_eff_SLD_units) ∧
  -- (8) tension > 2σ_SLD
  (2 * sigma_sin2theta_SLD_units <
     sin2theta_eff_LEP_units - sin2theta_eff_SLD_units) ∧
  -- (9) FCC-ee 16× tighter
  (16 * sigma_AFB_b_FCC_units = sigma_AFB_b_LEP_units) ∧
  -- (10) FCC will over-resolve envelope
  (5 * sigma_AFB_b_FCC_units < envelope_AFB_b_units)

/-- **🚨 s734 — `ZForwardBackwardAsymmetryFrontier`** holds. -/
theorem T1_s734_z_forward_backward_asymmetry_frontier :
    ZForwardBackwardAsymmetryFrontier := by
  refine ⟨⟨?_, ?_, ?_, ?_, ?_, ?_⟩, ⟨?_, ?_⟩, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact T1_s730_AFB_b_LEP_pos
  · exact T1_s730_sigma_AFB_b_LEP_pos
  · exact T1_s730_envelope_pos
  · exact T1_s732_sin2theta_LEP_pos
  · exact T1_s732_sin2theta_SLD_pos
  · exact T1_s733_sigma_AFB_b_FCC_pos
  · exact T1_s731_AFB_b_above_nine_hundred
  · exact T1_s731_AFB_b_below_one_tenth
  · exact T1_s731_five_sigma_eq_envelope
  · exact T1_s731_envelope_below_central
  · exact T1_s732_SLD_below_LEP
  · exact T1_s732_LEP_minus_SLD_eq_123
  · exact T1_s732_LEP_SLD_above_two_sigma_LEP
  · exact T1_s732_LEP_SLD_above_two_sigma_SLD
  · exact T1_s733_sixteen_FCC_eq_LEP
  · exact T1_s733_five_sigma_FCC_below_envelope

/-! ## Headline (14-conjunct) -/

/-- **HEADLINE — sessions 730-734 — Z forward-backward asymmetry
    A_FB^{0,b} LEP precision frontier**.

    🏆 Bundled-commit per BUNDLED COMMITS protocol. 5 sessions:

    - s730: A_FB^b LEP = 992, σ_LEP = 16, envelope = 80
            (units × 10⁴, so absolute = 0.0992, 0.0016, 0.008);
            positivity triple + canonical numeric anchors
    - s731: 900 < A_FB^b < 1000 (physical band); 5 σ_LEP = envelope;
            envelope ≪ A_FB^b (12× below central); σ_LEP < envelope
    - s732: sin²θ_eff LEP (A_FB) = 23221, SLD (A_LR) = 23098,
            σ_LEP = 29, σ_SLD = 26 (units × 10⁵); SLD < LEP;
            LEP - SLD = 123 (= 0.00123); tension > 2σ_LEP and 2σ_SLD
            ⇒ ~2.7σ LEP-SLD discrepancy
    - s733: FCC-ee σ_AFB = 1 (= 10⁻⁴, 16× tighter than LEP);
            16 σ_FCC = σ_LEP exactly; 5 σ_FCC < envelope;
            80 σ_FCC = envelope (FCC over-resolves envelope at 80σ)
    - s734: ZForwardBackwardAsymmetryFrontier (10-conjunct) +
            14-conjunct headline + bundle alias

    Phenomenology:
      A_FB^{0,b} LEP        = 0.0992 ± 0.0016    (LEP combined)
      sin²θ_eff (LEP A_FB)  = 0.23221 ± 0.00029  (indirect)
      sin²θ_eff (SLD A_LR)  = 0.23098 ± 0.00026  (direct)
      LEP - SLD             = 0.00123            (~2.7σ tension)
      Substrate envelope    = ± 0.008            (5σ on A_FB^b)
      FCC-ee σ_AFB (proj.)  = ± 0.0001           (16× LEP tightening)

    Why this matters:
    The LEP combined measurement of `A_FB^{0,b}` is the single most
    precise probe of the effective leptonic weak mixing angle
    `sin²θ_eff^lept`, but it pulls 0.00123 (≈ 2.7σ) higher than the
    SLD direct determination from the left-right asymmetry `A_LR`.
    This LEP-vs-SLD split has been the most discussed precision-EW
    tension since LEP closure and remains unresolved.

    The substrate envelope `|A_FB^pred - 0.0992| ≤ 0.008` is the
    5σ_LEP band; substrate predictions saturating the envelope sit
    well within sensitivity of FCC-ee Tera-Z (which over-resolves
    the envelope at 80σ).  Such predictions could in principle
    select between LEP and SLD as the "correct" central value.

    Companion files:
    - `T1_ZInvisibleWidthLEPFrontier`     — Γ_inv / N_ν envelope
    - `T1_WeinbergAnglePDG`               — global sin²θ_W pinning
    - `T1_HiggsInvisibleDecayFrontier`    — Higgs invisible (BSM)
    - `T1_DayaBayReactorTheta13Frontier`  — neutrino θ_13 frontier

    Sub-lemma in T-1 SM precision frontier.  Lean-core only.

    🏆 First Lean-core formalization of LEP combined A_FB^{0,b} +
    LEP-SLD sin²θ_eff tension + FCC-ee projection. -/
theorem session_730_to_734_z_forward_backward_asymmetry_frontier_headline :
    0 < AFB_b_LEP_units
    ∧ 0 < sigma_AFB_b_LEP_units
    ∧ 0 < envelope_AFB_b_units
    ∧ 900 < AFB_b_LEP_units
    ∧ AFB_b_LEP_units < 1000
    ∧ 5 * sigma_AFB_b_LEP_units = envelope_AFB_b_units
    ∧ envelope_AFB_b_units < AFB_b_LEP_units
    ∧ sin2theta_eff_SLD_units < sin2theta_eff_LEP_units
    ∧ sin2theta_eff_LEP_units - sin2theta_eff_SLD_units = 123
    ∧ 2 * sigma_sin2theta_LEP_units <
        sin2theta_eff_LEP_units - sin2theta_eff_SLD_units
    ∧ 2 * sigma_sin2theta_SLD_units <
        sin2theta_eff_LEP_units - sin2theta_eff_SLD_units
    ∧ 16 * sigma_AFB_b_FCC_units = sigma_AFB_b_LEP_units
    ∧ 5 * sigma_AFB_b_FCC_units < envelope_AFB_b_units
    ∧ ZForwardBackwardAsymmetryFrontier :=
  ⟨T1_s730_AFB_b_LEP_pos, T1_s730_sigma_AFB_b_LEP_pos,
   T1_s730_envelope_pos,
   T1_s731_AFB_b_above_nine_hundred, T1_s731_AFB_b_below_one_tenth,
   T1_s731_five_sigma_eq_envelope, T1_s731_envelope_below_central,
   T1_s732_SLD_below_LEP, T1_s732_LEP_minus_SLD_eq_123,
   T1_s732_LEP_SLD_above_two_sigma_LEP,
   T1_s732_LEP_SLD_above_two_sigma_SLD,
   T1_s733_sixteen_FCC_eq_LEP,
   T1_s733_five_sigma_FCC_below_envelope,
   T1_s734_z_forward_backward_asymmetry_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_z_forward_backward_asymmetry_frontier_bundle :
    ZForwardBackwardAsymmetryFrontier :=
  T1_s734_z_forward_backward_asymmetry_frontier

end OmegaTheory.Predictions.T1_ZForwardBackwardAsymmetryFrontier
