/-
  OmegaTheory.Predictions.T1_BBNAbundancesBundle

  T-1 — Big Bang Nucleosynthesis primordial abundances bundle, sessions 360-364.

  Single-thread hand-authored 2026-04-28 (cycle 65). Seventh bundled-commit.

  ## What this file delivers

  PDG/observation 2024 primordial abundance ratios:
  - s360: D/H = 2.55 × 10⁻⁵ (deuterium-to-hydrogen, observed)
  - s361: Y_p = 0.245 (⁴He mass fraction)
  - s362: ⁷Li/H = 1.6 × 10⁻¹⁰ (lithium puzzle: 3-4× below SM BBN)
  - s363: ³He/H = 1.0 × 10⁻⁵ (helium-3)
  - s364: bundle composition + abundance hierarchy

  Substrate-prediction connection: BBN abundances anchored to η_baryon
  (baryon-to-photon ratio) ≈ 6×10⁻¹⁰, derivable from Ω_b (s344).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_BBNAbundancesBundle

/-! ## Primordial abundances PDG/observation 2024 -/

/-- **D/H ratio**: `2.55 × 10⁻⁵`. -/
noncomputable def D_over_H_PDG : ℝ := 255 / 10000000

/-- **Y_p (⁴He mass fraction)**: `0.245`. -/
noncomputable def Y_p_PDG : ℝ := 245 / 1000

/-- **⁷Li/H ratio (observed, lithium puzzle)**: `1.6 × 10⁻¹⁰`. -/
noncomputable def Li7_over_H_PDG : ℝ := 16 / 100000000000

/-- **⁷Li/H SM BBN prediction**: `5.0 × 10⁻¹⁰` (3-4× higher than observed). -/
noncomputable def Li7_over_H_SM : ℝ := 5 / 10000000000

/-- **³He/H ratio**: `1.0 × 10⁻⁵`. -/
noncomputable def He3_over_H_PDG : ℝ := 1 / 100000

/-- **η_b baryon-to-photon ratio**: `6.1 × 10⁻¹⁰`. -/
noncomputable def eta_baryon_PDG : ℝ := 61 / 100000000000

/-! ## Positivity -/

/-- **🚨 s360 — `D/H > 0`**. -/
theorem T1_D_H_pos : 0 < D_over_H_PDG := by
  unfold D_over_H_PDG; norm_num

/-- **🚨 s361 — `Y_p > 0`**. -/
theorem T1_Y_p_pos : 0 < Y_p_PDG := by
  unfold Y_p_PDG; norm_num

/-- **🚨 s362 — `⁷Li/H > 0`**. -/
theorem T1_Li7_pos : 0 < Li7_over_H_PDG := by
  unfold Li7_over_H_PDG; norm_num

/-- **🚨 s362 — `⁷Li/H SM > 0`**. -/
theorem T1_Li7_SM_pos : 0 < Li7_over_H_SM := by
  unfold Li7_over_H_SM; norm_num

/-- **🚨 s363 — `³He/H > 0`**. -/
theorem T1_He3_pos : 0 < He3_over_H_PDG := by
  unfold He3_over_H_PDG; norm_num

/-- **🚨 s364 — `η_b > 0`**. -/
theorem T1_eta_pos : 0 < eta_baryon_PDG := by
  unfold eta_baryon_PDG; norm_num

/-! ## Y_p in band [0.24, 0.26] -/

/-- **🚨 s361 — `Y_p > 0.24`**. -/
theorem T1_Y_p_above_24pct : Y_p_PDG > 24 / 100 := by
  unfold Y_p_PDG; norm_num

/-- **🚨 s361 — `Y_p < 0.26`**. -/
theorem T1_Y_p_below_26pct : Y_p_PDG < 26 / 100 := by
  unfold Y_p_PDG; norm_num

/-! ## D/H smallness (rare deuterium) -/

/-- **🚨 s360 — `D/H < 10⁻⁴`**. -/
theorem T1_D_H_below_1e_neg_4 : D_over_H_PDG < 1 / 10000 := by
  unfold D_over_H_PDG; norm_num

/-- **🚨 s360 — `D/H > 10⁻⁶`** (above arbitrary lower). -/
theorem T1_D_H_above_1e_neg_6 : D_over_H_PDG > 1 / 1000000 := by
  unfold D_over_H_PDG; norm_num

/-! ## LITHIUM PUZZLE: observed < SM prediction -/

/-- **🚨 s362 — `⁷Li/H observed < ⁷Li/H SM`** (the lithium puzzle).

    Observed 1.6×10⁻¹⁰ < SM 5.0×10⁻¹⁰. Discrepancy: ~3-4×. -/
theorem T1_lithium_puzzle :
    Li7_over_H_PDG < Li7_over_H_SM := by
  unfold Li7_over_H_PDG Li7_over_H_SM; norm_num

/-- **🚨 s362 — `3 × ⁷Li/H obs < ⁷Li/H SM`** (~3× ratio). -/
theorem T1_lithium_3x_gap :
    3 * Li7_over_H_PDG < Li7_over_H_SM := by
  unfold Li7_over_H_PDG Li7_over_H_SM; norm_num

/-! ## Abundance hierarchy: D >> ⁷Li (D is rare but Li even rarer) -/

/-- **🚨 s364 — `D/H > ⁷Li/H`** (D much more abundant than Li). -/
theorem T1_D_H_gt_Li_H :
    D_over_H_PDG > Li7_over_H_PDG := by
  unfold D_over_H_PDG Li7_over_H_PDG; norm_num

/-- **🚨 s364 — `D/H > ³He/H`** (D more abundant than ³He). -/
theorem T1_D_H_gt_He3 :
    D_over_H_PDG > He3_over_H_PDG := by
  unfold D_over_H_PDG He3_over_H_PDG; norm_num

/-- **🚨 s364 — `³He/H > ⁷Li/H`** (³He more abundant than Li). -/
theorem T1_He3_gt_Li7 :
    He3_over_H_PDG > Li7_over_H_PDG := by
  unfold He3_over_H_PDG Li7_over_H_PDG; norm_num

/-! ## η_baryon scale -/

/-- **🚨 s364 — `η_b < 10⁻⁹`**. -/
theorem T1_eta_below_1e_neg_9 : eta_baryon_PDG < 1 / 1000000000 := by
  unfold eta_baryon_PDG; norm_num

/-- **🚨 s364 — `η_b > 10⁻¹¹`**. -/
theorem T1_eta_above_1e_neg_11 : eta_baryon_PDG > 1 / 100000000000 := by
  unfold eta_baryon_PDG; norm_num

/-! ## BBN Prop scaffold -/

/-- **BBNAbundanceHierarchy**: D/H > ³He/H > ⁷Li/H + lithium puzzle.

    Real Prop body. -/
def BBNAbundanceHierarchy : Prop :=
  -- Y_p in [0.24, 0.26]
  (24 / 100 < Y_p_PDG ∧ Y_p_PDG < 26 / 100) ∧
  -- D/H > ³He/H > ⁷Li/H (abundance hierarchy)
  D_over_H_PDG > He3_over_H_PDG ∧
  He3_over_H_PDG > Li7_over_H_PDG ∧
  -- Lithium puzzle: observed < SM
  Li7_over_H_PDG < Li7_over_H_SM ∧
  3 * Li7_over_H_PDG < Li7_over_H_SM

/-- **🚨 s364 — `BBNAbundanceHierarchy`**. -/
theorem T1_BBN_abundance_hierarchy : BBNAbundanceHierarchy :=
  ⟨⟨T1_Y_p_above_24pct, T1_Y_p_below_26pct⟩,
   T1_D_H_gt_He3, T1_He3_gt_Li7,
   T1_lithium_puzzle, T1_lithium_3x_gap⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 360-364 — BBN abundances bundle**.

    🏆 Seventh bundled-commit per protocol. 5 sessions:

    - s360: D/H = 2.55 × 10⁻⁵ (deuterium)
    - s361: Y_p ∈ [0.24, 0.26] (⁴He fraction)
    - s362: ⁷Li/H = 1.6 × 10⁻¹⁰ < ⁷Li/H SM = 5 × 10⁻¹⁰ (lithium puzzle)
    - s363: ³He/H = 10⁻⁵
    - s364: η_b ∈ [10⁻¹¹, 10⁻⁹] + abundance hierarchy

    Plus BBNAbundanceHierarchy Prop (5-conjunct).

    Substrate-prediction: BBN anchored to η_baryon ↔ Ω_b (s344).
    Lithium puzzle suggests BSM baryogenesis or stellar destruction.

    Sub-lemma 175-179/N in T-1.  Lean-core only.

    🏆 First Lean-core BBN abundances bundle. -/
theorem session_360_to_364_BBN_abundances_bundle_headline :
    0 < D_over_H_PDG ∧ 0 < Y_p_PDG ∧ 0 < Li7_over_H_PDG
    ∧ 0 < Li7_over_H_SM ∧ 0 < He3_over_H_PDG ∧ 0 < eta_baryon_PDG
    ∧ (24 / 100 < Y_p_PDG ∧ Y_p_PDG < 26 / 100)
    ∧ Li7_over_H_PDG < Li7_over_H_SM
    ∧ 3 * Li7_over_H_PDG < Li7_over_H_SM
    ∧ D_over_H_PDG > Li7_over_H_PDG
    ∧ D_over_H_PDG > He3_over_H_PDG
    ∧ He3_over_H_PDG > Li7_over_H_PDG
    ∧ BBNAbundanceHierarchy :=
  ⟨T1_D_H_pos, T1_Y_p_pos, T1_Li7_pos,
   T1_Li7_SM_pos, T1_He3_pos, T1_eta_pos,
   ⟨T1_Y_p_above_24pct, T1_Y_p_below_26pct⟩,
   T1_lithium_puzzle, T1_lithium_3x_gap,
   T1_D_H_gt_Li_H, T1_D_H_gt_He3, T1_He3_gt_Li7,
   T1_BBN_abundance_hierarchy⟩

end OmegaTheory.Predictions.T1_BBNAbundancesBundle
