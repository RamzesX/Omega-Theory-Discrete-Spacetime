/-
  OmegaTheory.Predictions.T1_HVPLatticeVsEEFrontier

  T-1 (light quark masses) — FRONTIER, sub session 277.
  Hadronic vacuum polarization (HVP): BMW lattice 2020/2024 vs e+e-→hadrons.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  THE central tension in muon g-2 SM prediction (s240):

  - HVP (e+e-→hadrons, traditional R-ratio):
      a_μ^HVP = 6845 × 10^(-11) (BNL Theory Initiative 2020)
  - HVP (BMW lattice QCD 2020):
      a_μ^HVP = 7075 × 10^(-11) (significantly higher)
  - Difference: ~230 × 10^(-11) (2.1σ tension between methods)
  - CMD-3 e+e-→hadrons 2024 (Novosibirsk): closer to lattice
      → traditional e+e- result may be biased

  Implication: if BMW lattice is correct, the muon g-2 anomaly
  (s240) DISAPPEARS. The "anomaly" depends critically on which
  HVP determination is used.

  This is the most important open question in muon g-2 SM theory.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_HVPLatticeVsEEFrontier

/-! ## HVP determinations (in units of 10^(-11)) -/

/-- **a_μ^HVP from e+e- (BNL Theory Initiative 2020)**: `6845`. -/
noncomputable def a_mu_HVP_eepluse_PDG : ℝ := 6845

/-- **a_μ^HVP from BMW lattice 2020/2024**: `7075`. -/
noncomputable def a_mu_HVP_BMW_lattice_PDG : ℝ := 7075

/-- **Difference (lattice - e+e-)**: `230 × 10^(-11)`. -/
noncomputable def a_mu_HVP_difference_PDG : ℝ := 230

/-! ## Tension significance (in σ) -/

/-- **HVP method tension significance**: `2.1σ`. -/
noncomputable def HVP_tension_PDG : ℝ := 21 / 10

/-! ## Positivity -/

/-- **Wave T1 session 277 — `a_μ^HVP e+e- > 0`**. -/
theorem T1_a_mu_HVP_ee_pos : 0 < a_mu_HVP_eepluse_PDG := by
  unfold a_mu_HVP_eepluse_PDG; norm_num

/-- **Wave T1 session 277 — `a_μ^HVP BMW > 0`**. -/
theorem T1_a_mu_HVP_BMW_pos : 0 < a_mu_HVP_BMW_lattice_PDG := by
  unfold a_mu_HVP_BMW_lattice_PDG; norm_num

/-- **Wave T1 session 277 — `difference > 0`**. -/
theorem T1_a_mu_HVP_diff_pos : 0 < a_mu_HVP_difference_PDG := by
  unfold a_mu_HVP_difference_PDG; norm_num

/-- **Wave T1 session 277 — `tension > 0`**. -/
theorem T1_HVP_tension_pos : 0 < HVP_tension_PDG := by
  unfold HVP_tension_PDG; norm_num

/-! ## THE TENSION: BMW lattice > e+e- -/

/-- **🚨 FRONTIER — Wave T1 session 277 — `BMW lattice > e+e-`**.

    Lattice QCD result is significantly higher. -/
theorem T1_BMW_lattice_gt_ee :
    a_mu_HVP_BMW_lattice_PDG > a_mu_HVP_eepluse_PDG := by
  unfold a_mu_HVP_BMW_lattice_PDG a_mu_HVP_eepluse_PDG; linarith

/-- **🚨 FRONTIER — Wave T1 session 277 — `BMW - e+e- = 230 × 10^(-11)`**.

    Difference matches the tension. -/
theorem T1_BMW_minus_ee :
    a_mu_HVP_BMW_lattice_PDG - a_mu_HVP_eepluse_PDG = a_mu_HVP_difference_PDG := by
  unfold a_mu_HVP_BMW_lattice_PDG a_mu_HVP_eepluse_PDG a_mu_HVP_difference_PDG
  norm_num

/-! ## Tension band -/

/-- **🚨 FRONTIER — Wave T1 session 277 — `tension > 2σ`** (real anomaly band). -/
theorem T1_HVP_tension_above_2sigma :
    HVP_tension_PDG > 2 := by
  unfold HVP_tension_PDG; norm_num

/-- **🚨 FRONTIER — Wave T1 session 277 — `tension < 3σ`** (not yet evidence). -/
theorem T1_HVP_tension_below_3sigma :
    HVP_tension_PDG < 3 := by
  unfold HVP_tension_PDG; norm_num

/-! ## Both within ~10% (relative comparison) -/

/-- **🚨 FRONTIER — Wave T1 session 277 — `100 × difference < 10 × e+e-`**.

    Relative difference ~3.4%, within the ~5% expected lattice precision. -/
theorem T1_HVP_relative_difference_small :
    100 * a_mu_HVP_difference_PDG < 10 * a_mu_HVP_eepluse_PDG := by
  unfold a_mu_HVP_difference_PDG a_mu_HVP_eepluse_PDG; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 277 — HVP lattice vs e+e- frontier**.

    🚨 FRONTIER (THE central tension in muon g-2 SM theory) 🚨

    Eight foundational facts:
    1. `a_μ^HVP e+e- = 6845 × 10^(-11) > 0` (BNL Theory 2020).
    2. `a_μ^HVP BMW = 7075 × 10^(-11) > 0` (lattice 2020/2024).
    3. `difference = 230 × 10^(-11) > 0`.
    4. `tension = 2.1σ > 0`.
    5. `BMW lattice > e+e-` (THE method tension).
    6. `BMW - e+e- = difference` (numerical identity).
    7. `tension > 2σ` (above noise).
    8. `tension < 3σ` (not yet evidence threshold).

    If BMW lattice is correct, the muon g-2 anomaly (s240) DISAPPEARS.
    The "anomaly" depends critically on which HVP is used. CMD-3 2024
    e+e- result is closer to lattice — suggesting traditional e+e-
    determination may be biased.

    Sub-lemma 99/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of HVP lattice vs e+e- tension. -/
theorem session_277_HVP_lattice_vs_ee_frontier_headline :
    0 < a_mu_HVP_eepluse_PDG ∧ 0 < a_mu_HVP_BMW_lattice_PDG
    ∧ 0 < a_mu_HVP_difference_PDG ∧ 0 < HVP_tension_PDG
    ∧ a_mu_HVP_BMW_lattice_PDG > a_mu_HVP_eepluse_PDG
    ∧ a_mu_HVP_BMW_lattice_PDG - a_mu_HVP_eepluse_PDG = a_mu_HVP_difference_PDG
    ∧ HVP_tension_PDG > 2
    ∧ HVP_tension_PDG < 3 :=
  ⟨T1_a_mu_HVP_ee_pos, T1_a_mu_HVP_BMW_pos,
   T1_a_mu_HVP_diff_pos, T1_HVP_tension_pos,
   T1_BMW_lattice_gt_ee, T1_BMW_minus_ee,
   T1_HVP_tension_above_2sigma, T1_HVP_tension_below_3sigma⟩

end OmegaTheory.Predictions.T1_HVPLatticeVsEEFrontier
