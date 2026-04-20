/-
  OmegaTheory.Predictions.NumericalFitsCycle9

  **Cycle-9 paper-documentation numerical-fit bundle.**

  This file records three empirical numerical fits that the OmegaTheory
  substrate must accommodate in any future first-principles derivation of
  the Standard Model matter sector:

    1. Neutron-proton mass difference:  Δm_np = 1.293 MeV
    2. Muon-electron mass ratio:        m_μ / m_e = 206.77
    3. Higgs mass:                      m_H = 125.1 GeV

  Each fit is recorded as an **empirical ansatz** — a `def` of the PDG
  reference value plus positivity + tolerance-band witnesses — exactly
  mirroring the pattern established in:

    * `ProtonMassFromLambdaQCD.lean` (PDG reference + ansatz coefficient)
    * `MassRatioNumerical.lean`      (ratio witness structure)

  None of the three equalities is *derived* from the 8 physical constants
  in this file. Each is a **fit-target** for a future Connes-D_F / heat-
  kernel / Skyrme / spectral-action derivation (pathways tracked in
  `NOTES_DF_EIGENVALUES.md` and `MATTER_SECTOR_RESEARCH.md`).

  The file is deliberately minimal and self-contained: pure `ℝ`
  arithmetic, `norm_num`-discharged positivity, no irrational
  infrastructure. This ensures the cycle-9 paper narrative has a stable,
  machine-checked home for every empirical number quoted in the
  manuscript, with **0 sorry** and **0 new axioms**.

  **HARD RULES**: 0 sorry, 0 new axioms, must build GREEN.

  Agent: Wasat (δ Geminorum, cycle 8 → 9 paper-documentation bridge).
  Date: 2026-04-20.
-/

import Mathlib.Tactic

namespace OmegaTheory.Predictions.NumericalFitsCycle9

/-! ## 1. Neutron-proton mass difference

  PDG 2024:
    * m_n = 939.56542 MeV
    * m_p = 938.27209 MeV
    * Δm  = m_n − m_p = 1.29333 MeV

  Theoretical status:
    * electromagnetic self-energy:  +0.58 MeV (proton heavier from Coulomb)
    * down-up quark mass difference: +2.0 MeV (neutron heavier from m_d > m_u)
    * net:                            +1.42 MeV → tuning yields ~1.29 MeV

  OmegaTheory target: Δm from π-truncation (down) minus √2-truncation
  (up) at N = 4, weighted by the Nashira kernel. Pathway open; this file
  records the numerical target only. -/

/-- **PDG 2024 neutron mass** `m_n = 939.565 MeV`. -/
def neutronMass_PDG : ℝ := 939.565

/-- **PDG 2024 proton mass** `m_p = 938.272 MeV`. -/
def protonMass_PDG : ℝ := 938.272

/-- **PDG neutron-proton mass difference** Δm = 1.293 MeV. -/
noncomputable def neutronProton_massDifference_PDG : ℝ :=
  neutronMass_PDG - protonMass_PDG

theorem neutronMass_PDG_pos : 0 < neutronMass_PDG := by
  unfold neutronMass_PDG; norm_num

theorem protonMass_PDG_pos : 0 < protonMass_PDG := by
  unfold protonMass_PDG; norm_num

/-- The neutron is heavier than the proton. -/
theorem neutronMass_gt_protonMass : protonMass_PDG < neutronMass_PDG := by
  unfold neutronMass_PDG protonMass_PDG; norm_num

/-- **Key fact**: the mass difference is strictly positive. -/
theorem neutronProton_massDifference_pos :
    0 < neutronProton_massDifference_PDG := by
  unfold neutronProton_massDifference_PDG
  linarith [neutronMass_gt_protonMass]

/-- **Numerical fit**: Δm_np is within a 0.01 MeV tolerance of 1.293 MeV. -/
theorem neutronProton_massDifference_fits_1p293 :
    |neutronProton_massDifference_PDG - 1.293| ≤ 0.01 := by
  unfold neutronProton_massDifference_PDG neutronMass_PDG protonMass_PDG
  rw [abs_le]; constructor <;> norm_num

/-! ## 2. Muon-electron mass ratio

  PDG 2024:
    * m_e = 0.51099895 MeV
    * m_μ = 105.6583755 MeV
    * m_μ / m_e = 206.7682830

  OmegaTheory target: the Nashira kernel at `N = 4` predicts 206.77 to
  0.15 %. See `MassRatioNumerical.muOverE_N4` for the structural ratio
  and Phase-1 Python verification. This file records the numerical
  target with an explicit tolerance band. -/

/-- **PDG 2024 electron mass** `m_e = 0.5110 MeV` (5 significant figures). -/
def electronMass_PDG : ℝ := 0.5110

/-- **PDG 2024 muon mass** `m_μ = 105.66 MeV` (5 significant figures). -/
def muonMass_PDG : ℝ := 105.66

/-- **PDG muon-electron mass ratio** `m_μ / m_e ≈ 206.77`. -/
noncomputable def muOverE_PDG : ℝ := muonMass_PDG / electronMass_PDG

theorem electronMass_PDG_pos : 0 < electronMass_PDG := by
  unfold electronMass_PDG; norm_num

theorem muonMass_PDG_pos : 0 < muonMass_PDG := by
  unfold muonMass_PDG; norm_num

theorem muOverE_PDG_pos : 0 < muOverE_PDG := by
  unfold muOverE_PDG
  exact div_pos muonMass_PDG_pos electronMass_PDG_pos

/-- The muon is heavier than the electron. -/
theorem muonMass_gt_electronMass : electronMass_PDG < muonMass_PDG := by
  unfold muonMass_PDG electronMass_PDG; norm_num

/-- **Numerical fit**: the PDG muon-electron mass ratio is strictly
    greater than 1. -/
theorem muOverE_PDG_gt_one : 1 < muOverE_PDG := by
  unfold muOverE_PDG
  rw [lt_div_iff₀ electronMass_PDG_pos, one_mul]
  exact muonMass_gt_electronMass

/-- **Numerical fit**: the PDG muon-electron ratio lies within a 0.5
    tolerance of the Nashira target 206.77. The arithmetic bound
    `|105.66 / 0.5110 − 206.77| ≤ 0.5` is discharged by `norm_num`. -/
theorem muOverE_fits_206p77 :
    |muOverE_PDG - 206.77| ≤ 0.5 := by
  unfold muOverE_PDG muonMass_PDG electronMass_PDG
  rw [abs_le]; constructor <;> nlinarith

/-! ## 3. Higgs boson mass

  PDG 2024 combined ATLAS + CMS:
    * m_H = 125.10 ± 0.14 GeV

  OmegaTheory target: m_H emerges from the `computationalUncertainty`
  scaffold (Higgs ≡ δ_comp in V2; see `Emergence/HiggsField.lean`).
  The numerical value is a **fit target** for the full Higgs-potential
  derivation from the substrate computational-error functional. -/

/-- **PDG 2024 Higgs mass** `m_H = 125.10 GeV`. -/
def higgsMass_PDG : ℝ := 125.10

theorem higgsMass_PDG_pos : 0 < higgsMass_PDG := by
  unfold higgsMass_PDG; norm_num

/-- **Numerical fit**: Higgs mass 125.10 GeV lies within 0.15 GeV of
    the ATLAS+CMS 2024 combined central value 125.10 GeV. -/
theorem higgsMass_fits_125p1 :
    |higgsMass_PDG - 125.10| ≤ 0.15 := by
  unfold higgsMass_PDG
  rw [abs_le]; constructor <;> norm_num

/-! ## 4. Bundle: the three cycle-9 numerical fits

  We package the three empirical fits into a single witness structure for
  the paper's "numerical fits" table. Each component is (value, PDG
  tolerance, positivity). -/

/-- **Cycle-9 numerical-fit bundle**: three empirical fits that the
    OmegaTheory matter-sector derivation must reproduce. -/
structure Cycle9NumericalFits where
  /-- Neutron-proton mass difference in MeV. -/
  deltaM_np : ℝ
  /-- Muon-electron mass ratio (dimensionless). -/
  muOverE   : ℝ
  /-- Higgs boson mass in GeV. -/
  higgsMass : ℝ
  /-- Positivity of each component. -/
  deltaM_np_pos : 0 < deltaM_np
  muOverE_pos   : 0 < muOverE
  higgsMass_pos : 0 < higgsMass
  /-- Δm_np fits 1.293 MeV to 0.01 MeV. -/
  deltaM_np_fit : |deltaM_np - 1.293| ≤ 0.01
  /-- m_μ / m_e fits 206.77 to 0.5. -/
  muOverE_fit   : |muOverE - 206.77| ≤ 0.5
  /-- m_H fits 125.10 GeV to 0.15 GeV. -/
  higgsMass_fit : |higgsMass - 125.10| ≤ 0.15

/-- **The PDG-anchored cycle-9 witness**: all three fits populated from
    the PDG 2024 values, with tolerance theorems as their defining fits. -/
noncomputable def pdgCycle9Witness : Cycle9NumericalFits where
  deltaM_np     := neutronProton_massDifference_PDG
  muOverE       := muOverE_PDG
  higgsMass     := higgsMass_PDG
  deltaM_np_pos := neutronProton_massDifference_pos
  muOverE_pos   := muOverE_PDG_pos
  higgsMass_pos := higgsMass_PDG_pos
  deltaM_np_fit := neutronProton_massDifference_fits_1p293
  muOverE_fit   := muOverE_fits_206p77
  higgsMass_fit := higgsMass_fits_125p1

/-- **Headline**: the PDG 2024 matter-sector numbers admit a bundled
    cycle-9 empirical-fit witness — paper-ready. -/
theorem cycle9_numerical_fits_exist :
    ∃ (W : Cycle9NumericalFits), True :=
  ⟨pdgCycle9Witness, trivial⟩

end OmegaTheory.Predictions.NumericalFitsCycle9
