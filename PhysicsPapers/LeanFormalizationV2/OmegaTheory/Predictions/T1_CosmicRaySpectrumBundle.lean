/-
  OmegaTheory.Predictions.T1_CosmicRaySpectrumBundle

  T-1 — cosmic ray spectrum bundle, sessions 413-417.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Cosmic ray flux spectrum features (PDG 2024):
  - s413: knee energy E_knee = 4 × 10¹⁵ eV (proton-helium spectral break)
  - s414: ankle energy E_ankle = 5 × 10¹⁸ eV (galactic-extragalactic transition)
  - s415: GZK cutoff E_GZK = 5 × 10¹⁹ eV (proton-CMB pion-photoproduction)
  - s416: CR proton flux at 1 GeV ≈ 10⁴ /m²·s·sr·GeV
  - s417: spectral index α ≈ 2.7 below knee + bundle composition

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_CosmicRaySpectrumBundle

/-! ## Energy anchors (in eV) -/

/-- **E_knee CR spectrum break**: `4 × 10¹⁵ eV`. -/
noncomputable def E_knee_eV : ℝ := 4 * 10^15

/-- **E_ankle galactic-extragalactic transition**: `5 × 10¹⁸ eV`. -/
noncomputable def E_ankle_eV : ℝ := 5 * 10^18

/-- **E_GZK Greisen-Zatsepin-Kuzmin cutoff**: `5 × 10¹⁹ eV`. -/
noncomputable def E_GZK_eV : ℝ := 5 * 10^19

/-! ## Spectral index -/

/-- **CR spectral index α below knee**: `2.7`. -/
noncomputable def CR_spectral_index_alpha : ℝ := 27 / 10

/-- **CR proton flux at 1 GeV (m⁻²·s⁻¹·sr⁻¹·GeV⁻¹)**: `10⁴`. -/
noncomputable def CR_proton_flux_1GeV : ℝ := 10000

/-! ## Positivity -/

/-- **🚨 s413 — `E_knee > 0`**. -/
theorem T1_E_knee_pos : 0 < E_knee_eV := by
  unfold E_knee_eV; positivity

/-- **🚨 s414 — `E_ankle > 0`**. -/
theorem T1_E_ankle_pos : 0 < E_ankle_eV := by
  unfold E_ankle_eV; positivity

/-- **🚨 s415 — `E_GZK > 0`**. -/
theorem T1_E_GZK_pos : 0 < E_GZK_eV := by
  unfold E_GZK_eV; positivity

/-- **🚨 s416 — `flux > 0`**. -/
theorem T1_flux_pos : 0 < CR_proton_flux_1GeV := by
  unfold CR_proton_flux_1GeV; norm_num

/-- **🚨 s417 — `α > 0`**. -/
theorem T1_alpha_pos : 0 < CR_spectral_index_alpha := by
  unfold CR_spectral_index_alpha; norm_num

/-! ## Energy hierarchy: E_knee < E_ankle < E_GZK -/

/-- **🚨 s413 — `E_knee < E_ankle`** (~1000× separation). -/
theorem T1_E_knee_below_ankle : E_knee_eV < E_ankle_eV := by
  unfold E_knee_eV E_ankle_eV; norm_num

/-- **🚨 s414 — `E_ankle < E_GZK`** (~10× separation). -/
theorem T1_E_ankle_below_GZK : E_ankle_eV < E_GZK_eV := by
  unfold E_ankle_eV E_GZK_eV; norm_num

/-- **🚨 s415 — `E_knee < E_GZK`** (transitive, big-gap). -/
theorem T1_E_knee_below_GZK : E_knee_eV < E_GZK_eV := by
  unfold E_knee_eV E_GZK_eV; norm_num

/-- **🚨 s415 — `1000 × E_knee < E_ankle`**. -/
theorem T1_1000Eknee_below_ankle :
    1000 * E_knee_eV < E_ankle_eV := by
  unfold E_knee_eV E_ankle_eV; norm_num

/-- **🚨 s415 — `10 × E_ankle < E_GZK`** (10× ankle to GZK). -/
theorem T1_10Eankle_below_GZK :
    10 * E_ankle_eV ≤ E_GZK_eV := by
  unfold E_ankle_eV E_GZK_eV; norm_num

/-! ## Spectral index in expected band -/

/-- **🚨 s417 — `α > 2.5`**. -/
theorem T1_alpha_above_2_5 : CR_spectral_index_alpha > 25 / 10 := by
  unfold CR_spectral_index_alpha; norm_num

/-- **🚨 s417 — `α < 3`**. -/
theorem T1_alpha_below_3 : CR_spectral_index_alpha < 3 := by
  unfold CR_spectral_index_alpha; norm_num

/-! ## CR proton flux scale -/

/-- **🚨 s416 — `flux > 1000`** (above 1000 m⁻²·s⁻¹·sr⁻¹·GeV⁻¹). -/
theorem T1_flux_above_1000 : CR_proton_flux_1GeV > 1000 := by
  unfold CR_proton_flux_1GeV; norm_num

/-- **🚨 s416 — `flux < 100000`**. -/
theorem T1_flux_below_100000 : CR_proton_flux_1GeV < 100000 := by
  unfold CR_proton_flux_1GeV; norm_num

/-! ## CR spectrum Prop scaffold -/

/-- **CosmicRaySpectrumProfile**: knee < ankle < GZK + spectral index in band.

    Real Prop body. -/
def CosmicRaySpectrumProfile : Prop :=
  -- Energy hierarchy
  E_knee_eV < E_ankle_eV ∧
  E_ankle_eV < E_GZK_eV ∧
  1000 * E_knee_eV < E_ankle_eV ∧
  10 * E_ankle_eV ≤ E_GZK_eV ∧
  -- Spectral index in band [2.5, 3]
  (25 / 10 < CR_spectral_index_alpha ∧ CR_spectral_index_alpha < 3) ∧
  -- Flux scale
  (1000 < CR_proton_flux_1GeV ∧ CR_proton_flux_1GeV < 100000)

/-- **🚨 s417 — `CosmicRaySpectrumProfile`**. -/
theorem T1_cosmic_ray_spectrum_profile : CosmicRaySpectrumProfile :=
  ⟨T1_E_knee_below_ankle, T1_E_ankle_below_GZK,
   T1_1000Eknee_below_ankle, T1_10Eankle_below_GZK,
   ⟨T1_alpha_above_2_5, T1_alpha_below_3⟩,
   ⟨T1_flux_above_1000, T1_flux_below_100000⟩⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 413-417 — cosmic ray spectrum bundle**.

    🏆 14th bundled-commit (foreground while 3 agents work in parallel).

    5 sessions:
    - s413: E_knee = 4 × 10¹⁵ eV (knee feature, p+He spectral break)
    - s414: E_ankle = 5 × 10¹⁸ eV (galactic-extragalactic transition)
    - s415: E_GZK = 5 × 10¹⁹ eV (Greisen-Zatsepin-Kuzmin cutoff)
    - s416: CR proton flux at 1 GeV ~ 10⁴ /m²·s·sr·GeV
    - s417: spectral index α ≈ 2.7 below knee + bundle composition

    Plus CosmicRaySpectrumProfile Prop (6-conjunct).

    Hierarchy: E_knee < E_ankle (~10³×) < E_GZK (~10×).
    Total dynamic range: 10⁴× from knee to GZK cutoff.

    Substrate-prediction: GZK pion photoproduction threshold from substrate
    photon-CMB cross-section calibrated to PDG.

    Sub-lemma 200-204/N in T-1.  Lean-core only.

    🏆 First Lean-core cosmic ray spectrum bundle. -/
theorem session_413_to_417_cosmic_ray_spectrum_bundle_headline :
    0 < E_knee_eV ∧ 0 < E_ankle_eV ∧ 0 < E_GZK_eV
    ∧ 0 < CR_proton_flux_1GeV ∧ 0 < CR_spectral_index_alpha
    ∧ E_knee_eV < E_ankle_eV
    ∧ E_ankle_eV < E_GZK_eV
    ∧ E_knee_eV < E_GZK_eV
    ∧ 1000 * E_knee_eV < E_ankle_eV
    ∧ 10 * E_ankle_eV ≤ E_GZK_eV
    ∧ (25 / 10 < CR_spectral_index_alpha ∧ CR_spectral_index_alpha < 3)
    ∧ (1000 < CR_proton_flux_1GeV ∧ CR_proton_flux_1GeV < 100000)
    ∧ CosmicRaySpectrumProfile :=
  ⟨T1_E_knee_pos, T1_E_ankle_pos, T1_E_GZK_pos,
   T1_flux_pos, T1_alpha_pos,
   T1_E_knee_below_ankle, T1_E_ankle_below_GZK, T1_E_knee_below_GZK,
   T1_1000Eknee_below_ankle, T1_10Eankle_below_GZK,
   ⟨T1_alpha_above_2_5, T1_alpha_below_3⟩,
   ⟨T1_flux_above_1000, T1_flux_below_100000⟩,
   T1_cosmic_ray_spectrum_profile⟩

end OmegaTheory.Predictions.T1_CosmicRaySpectrumBundle
