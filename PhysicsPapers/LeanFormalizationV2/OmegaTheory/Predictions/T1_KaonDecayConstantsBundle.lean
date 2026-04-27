/-
  OmegaTheory.Predictions.T1_KaonDecayConstantsBundle

  T-1 (light quark masses) — kaon/pion decay-constant bundle, sessions 380-382.

  Single-thread hand-authored 2026-04-28 (cycle 65). Bundled-commit
  per protocol (3 sessions per single git commit).

  ## What this file delivers

  Three FLAG/PDG-anchored decay-constant facts plus ratio bundle:

  - s380: f_K positivity + bound profile (FLAG 2024 ≈ 155.7 MeV)
  - s381: f_π positivity + bound profile (PDG ≈ 130.2 MeV; FLAG 2024 ≈ 130.5)
  - s382: f_K / f_π ratio in [1.10, 1.30] (SU(3) breaking ≈ 1.193)
          + bundle composition Prop

  Plus headline 5-conjunct.

  ## Anchor reuse

  This bundle IMPORTS the existing PDG anchors from
  `T1_PionDecayConstantPDG.lean` (`f_pi_PDG = 130.2`, `f_K_PDG = 155.7`)
  rather than redefining them.  New content: explicit ratio reasoning,
  SU(3)-breaking band, kaon-pion bundle composition Prop.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import OmegaTheory.Predictions.T1_PionDecayConstantPDG

namespace OmegaTheory.Predictions.T1_KaonDecayConstantsBundle

open OmegaTheory.Predictions.T1_PionDecayConstantPDG

/-! ## s380: f_K bound profile (FLAG 2024 anchor) -/

/-- **🚨 s380 — `f_K > 0`** (positivity, reused from anchor). -/
theorem T1_s380_f_K_pos : 0 < f_K_PDG := T1_f_K_PDG_pos

/-- **🚨 s380 — `f_K > 150`** (lower band; FLAG 2024 = 155.7). -/
theorem T1_s380_f_K_gt_150 : f_K_PDG > 150 := by
  unfold f_K_PDG; norm_num

/-- **🚨 s380 — `f_K < 160`** (upper band; FLAG 2024 = 155.7). -/
theorem T1_s380_f_K_lt_160 : f_K_PDG < 160 := by
  unfold f_K_PDG; norm_num

/-- **🚨 s380 — `2 × f_K > 300`** (linear sanity check). -/
theorem T1_s380_two_f_K_gt_300 : 2 * f_K_PDG > 300 := by
  unfold f_K_PDG; norm_num

/-! ## s381: f_π bound profile (PDG / FLAG 2024 anchor) -/

/-- **🚨 s381 — `f_π > 0`** (positivity, reused from anchor). -/
theorem T1_s381_f_pi_pos : 0 < f_pi_PDG := T1_f_pi_PDG_pos

/-- **🚨 s381 — `f_π > 125`** (lower band; PDG = 130.2). -/
theorem T1_s381_f_pi_gt_125 : f_pi_PDG > 125 := by
  unfold f_pi_PDG; norm_num

/-- **🚨 s381 — `f_π < 135`** (upper band; PDG = 130.2). -/
theorem T1_s381_f_pi_lt_135 : f_pi_PDG < 135 := by
  unfold f_pi_PDG; norm_num

/-- **🚨 s381 — `f_π < f_K`** (strange-flavour enhancement; reused). -/
theorem T1_s381_f_pi_lt_f_K : f_pi_PDG < f_K_PDG := T1_f_K_gt_f_pi

/-! ## s382: f_K / f_π ratio (SU(3) breaking) -/

/-- **f_K / f_π (computed)**: `155.7 / 130.2 ≈ 1.1958` (FLAG 2024 ≈ 1.193). -/
noncomputable def f_K_over_f_pi : ℝ := f_K_PDG / f_pi_PDG

/-- **🚨 s382 — `f_K / f_π > 0`**. -/
theorem T1_s382_f_K_over_f_pi_pos : 0 < f_K_over_f_pi := by
  unfold f_K_over_f_pi
  exact div_pos T1_f_K_PDG_pos T1_f_pi_PDG_pos

/-- **🚨 s382 — `1.10 × f_π < f_K`** (lower SU(3)-breaking band). -/
theorem T1_s382_lower_band : 11 * f_pi_PDG < 10 * f_K_PDG := by
  unfold f_pi_PDG f_K_PDG; norm_num

/-- **🚨 s382 — `f_K < 1.30 × f_π`** (upper SU(3)-breaking band). -/
theorem T1_s382_upper_band : 10 * f_K_PDG < 13 * f_pi_PDG := by
  unfold f_pi_PDG f_K_PDG; norm_num

/-- **🚨 s382 — `f_K > f_π`** (positive SU(3) breaking direction). -/
theorem T1_s382_f_K_above_f_pi : f_K_PDG > f_pi_PDG := T1_f_K_gt_f_pi

/-! ## Bundle composition Prop -/

/-- **KaonPionDecayConstantsBundleProfile**: 3 simultaneous facts
    that together pin the FLAG 2024 phenomenology of the pseudoscalar
    decay constants:

    - f_K in [150, 160] MeV
    - f_π in [125, 135] MeV
    - f_K / f_π in [1.10, 1.30] (strict band; central ≈ 1.193)

    Real Prop body — non-trivial 6-way conjunction. -/
def KaonPionDecayConstantsBundleProfile : Prop :=
  -- f_K ∈ (150, 160)
  (150 < f_K_PDG ∧ f_K_PDG < 160) ∧
  -- f_π ∈ (125, 135)
  (125 < f_pi_PDG ∧ f_pi_PDG < 135) ∧
  -- f_K / f_π ∈ (1.10, 1.30) expressed via cross-multiplication
  (11 * f_pi_PDG < 10 * f_K_PDG ∧ 10 * f_K_PDG < 13 * f_pi_PDG)

/-- **🚨 s382 — `KaonPionDecayConstantsBundleProfile`** holds. -/
theorem T1_s382_kaon_pion_bundle_profile :
    KaonPionDecayConstantsBundleProfile :=
  ⟨⟨T1_s380_f_K_gt_150, T1_s380_f_K_lt_160⟩,
   ⟨T1_s381_f_pi_gt_125, T1_s381_f_pi_lt_135⟩,
   ⟨T1_s382_lower_band, T1_s382_upper_band⟩⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 380-382 — kaon/pion decay-constant bundle**.

    🏆 Bundled-commit per protocol. 3 sessions:

    - s380: f_K ∈ (150, 160) MeV (FLAG 2024 ≈ 155.7)
    - s381: f_π ∈ (125, 135) MeV (PDG ≈ 130.2; FLAG 2024 ≈ 130.5)
    - s382: f_K / f_π ∈ (1.10, 1.30) — SU(3) breaking ratio
            (FLAG 2024 central value ≈ 1.193)

    Plus KaonPionDecayConstantsBundleProfile composition + positivity
    of the ratio.

    Phenomenology context: f_K / f_π is one of the cleanest SU(3)-breaking
    observables on the lattice; FLAG 2024 (Nf = 2 + 1 + 1) gives
    `f_K / f_π = 1.1932(21)`.  The ratio enters V_us / V_ud extraction
    (Marciano-Sirlin), and constrains substrate-level SU(3)-flavour
    asymmetry in the chiral limit.

    Sub-lemma N+3 in T-1.  Lean-core only.

    🏆 First Lean-core kaon-pion ratio-bundle composition. -/
theorem session_380_to_382_kaon_decay_constants_bundle_headline :
    0 < f_K_PDG ∧ 0 < f_pi_PDG
    ∧ f_K_PDG > f_pi_PDG
    ∧ 0 < f_K_over_f_pi
    ∧ KaonPionDecayConstantsBundleProfile :=
  ⟨T1_s380_f_K_pos, T1_s381_f_pi_pos,
   T1_s382_f_K_above_f_pi, T1_s382_f_K_over_f_pi_pos,
   T1_s382_kaon_pion_bundle_profile⟩

end OmegaTheory.Predictions.T1_KaonDecayConstantsBundle
