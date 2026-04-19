/-
  OmegaTheory.Predictions.QuarkMassRatioNumerical

  **Second numerical falsifiability test of the Nashira mass-ratio
  predictions against PDG 2024, this time for the QUARK sectors (up-type
  and down-type).**

  Companion file to `Predictions/MassRatioNumerical.lean` (lepton sector,
  mass-ratio-validate, commit 07fe6ab), which showed that the Nashira
  kernel `f(δ) = δ^(4/7) / (-ln δ)` evaluated at the three per-target
  truncation errors `(δ_π(4), δ_e(4), δ_√2(4))` matches PDG lepton mass
  ratios to ≤ 0.15 %.

  This file records the *structural* quark-sector predictions of the
  extended Nashira kernels

        f_u(δ)  =  δ^(3/7) · (−ln δ)^(−3)           (up-type)
        f_d(δ)  =         1 · (−ln δ)^(−3)           (down-type)

  at `N = 4`, and connects them to the PDG 2024 up-quark and down-quark
  mass ratios.

  **The choice of β = −3 is an explicit empirical ansatz** (Nashira
  §4.2: `β = −N_color` with `N_c = 3` for colored quarks, `N_c = 1` for
  colorless leptons — a 2-datum pattern, NOT a first-principles derivation).
  This file marks that with `quark_ratios_status`, so the repository
  carries a machine-checkable record of the ansatz status.

  **Honest Phase-1 Python verdict** (companion `quark_ratios_scan.py`):

      N = 4:
        m_c/m_u predicted = 648.3   (PDG 587.96 ± 30%,  err  +10.3%)     WITHIN PDG
        m_t/m_c predicted = 152.7   (PDG 136.03 ± 1.6%, err  +12.3%)     OUTSIDE PDG
        m_s/m_d predicted = 27.17   (PDG 20.00  ± 14%,  err  +35.9%)     OUTSIDE PDG
        m_b/m_s predicted = 48.5    (PDG 44.75  ± 9.2%, err   +8.3%)     WITHIN PDG

  Best-fit N is `4 = dim(ℤ⁴)` (total |err| 66.8 %), as for leptons.
  Other integer N ∈ {2,3,5,6} produce much larger deviations (≥ 230 %).

  **Verdict: PARTIAL_MATCH (2/4 within PDG uncertainty).** The match is
  weaker than the lepton sector (≤ 0.15 %) — this is physics-consistent:
  QCD renormalization-scale running of quark masses introduces an extra
  source of theoretical uncertainty not present for leptons, and the
  `β = −N_color` pattern is a 2-datum empirical ansatz rather than a
  derivation.

  **What this file formalizes.**

    1. Closed-form definitions of the four main predicted quark ratios at
       N = 4: `mcOverMu_N4`, `mtOverMc_N4`, `msOverMd_N4`, `mbOverMs_N4`,
       plus the derived products `mtOverMu_N4` and `mbOverMd_N4`.
    2. Positivity theorems for each.
    3. Consistency identities `m_t/m_u = (m_t/m_c)(m_c/m_u)` and
       `m_b/m_d = (m_b/m_s)(m_s/m_d)`.
    4. Strict ordering: `1 < m_c/m_u < m_t/m_u` and `1 < m_s/m_d < m_b/m_d`,
       mirroring the observed hierarchies u < c < t and d < s < b.
    5. `QuarkEmpiricalAnsatz` structure packaging the four ratios and
       their structural properties into a single honest witness.
    6. `PDG2024Quarks` reference data structure with the PDG central
       ratios.
    7. `quark_nashira_pdg_bracket_exists` — the existential falsifiability
       sandwich theorem.
    8. `quark_ratios_status : String` — machine-readable honest status.

  **HARD RULES**: 0 sorry, 0 new axioms.

  Agent: quark-ratios (second falsifiability theorem). 2026-04-19.
-/

import OmegaTheory.Emergence.QuarkMassFromIrrationals
import OmegaTheory.Predictions.MassRatioNumerical
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic

namespace OmegaTheory.Predictions.QuarkMassRatioNumerical

open OmegaTheory.Irrationality
open OmegaTheory.Emergence.LeptonMassFromIrrationals
open OmegaTheory.Emergence.QuarkMassFromIrrationals
open OmegaTheory.Predictions.MassRatioNumerical

/-! ## 1. Helper lemmas reusable across both sectors -/

/-- All three δ-values at `N = 4` lie in the interior `(0, 1)`.
    (Duplicate of `delta_vals_lt_one_at_4` from the lepton file, kept
    local for direct use by quark theorems that do not want to import
    the implicit lepton machinery.) -/
theorem delta_vals_pos_lt_one_at_4_q :
    0 < pi_error_val 4 ∧ pi_error_val 4 < 1 ∧
    0 < e_error_val 4 ∧ e_error_val 4 < 1 ∧
    0 < sqrt2_error_val 4 ∧ sqrt2_error_val 4 < 1 := by
  refine ⟨pi_error_pos 4, pi_error_lt_one (by norm_num),
          e_error_pos 4, e_error_lt_one (by norm_num),
          sqrt2_error_pos 4, sqrt2_error_lt_one (by norm_num)⟩

/-- All three up-quark kernel values at `N = 4` are strictly positive. -/
theorem upQuarkKernel_vals_pos_at_4 :
    0 < upQuarkKernel (pi_error_val 4) ∧
    0 < upQuarkKernel (e_error_val 4) ∧
    0 < upQuarkKernel (sqrt2_error_val 4) := by
  obtain ⟨hp_pos, hp_lt, he_pos, he_lt, hs_pos, hs_lt⟩ :=
    delta_vals_pos_lt_one_at_4_q
  exact ⟨upQuarkKernel_pos hp_pos hp_lt,
         upQuarkKernel_pos he_pos he_lt,
         upQuarkKernel_pos hs_pos hs_lt⟩

/-- All three down-quark kernel values at `N = 4` are strictly positive. -/
theorem downQuarkKernel_vals_pos_at_4 :
    0 < downQuarkKernel (pi_error_val 4) ∧
    0 < downQuarkKernel (e_error_val 4) ∧
    0 < downQuarkKernel (sqrt2_error_val 4) := by
  obtain ⟨hp_pos, hp_lt, he_pos, he_lt, hs_pos, hs_lt⟩ :=
    delta_vals_pos_lt_one_at_4_q
  exact ⟨downQuarkKernel_pos hp_pos hp_lt,
         downQuarkKernel_pos he_pos he_lt,
         downQuarkKernel_pos hs_pos hs_lt⟩

/-! ## 2. The four Nashira-predicted quark mass ratios at N = 4

    Each ratio is the ratio of extended-Nashira kernel values at the
    three per-target `δ(4)`'s. Higgs-vev cancellation is automatic. -/

/-- Predicted `m_c / m_u` at `N = 4`, via the up-quark Nashira kernel. -/
noncomputable def mcOverMu_N4 : ℝ :=
  upQuarkKernel (e_error_val 4) / upQuarkKernel (sqrt2_error_val 4)

/-- Predicted `m_t / m_c` at `N = 4`, via the up-quark Nashira kernel. -/
noncomputable def mtOverMc_N4 : ℝ :=
  upQuarkKernel (pi_error_val 4) / upQuarkKernel (e_error_val 4)

/-- Predicted `m_t / m_u` at `N = 4`, via the up-quark Nashira kernel. -/
noncomputable def mtOverMu_N4 : ℝ :=
  upQuarkKernel (pi_error_val 4) / upQuarkKernel (sqrt2_error_val 4)

/-- Predicted `m_s / m_d` at `N = 4`, via the down-quark Nashira kernel. -/
noncomputable def msOverMd_N4 : ℝ :=
  downQuarkKernel (e_error_val 4) / downQuarkKernel (sqrt2_error_val 4)

/-- Predicted `m_b / m_s` at `N = 4`, via the down-quark Nashira kernel. -/
noncomputable def mbOverMs_N4 : ℝ :=
  downQuarkKernel (pi_error_val 4) / downQuarkKernel (e_error_val 4)

/-- Predicted `m_b / m_d` at `N = 4`, via the down-quark Nashira kernel. -/
noncomputable def mbOverMd_N4 : ℝ :=
  downQuarkKernel (pi_error_val 4) / downQuarkKernel (sqrt2_error_val 4)

/-! ## 3. Positivity of the six ratios -/

/-- The predicted charm-to-up mass ratio is strictly positive. -/
theorem mcOverMu_N4_pos : 0 < mcOverMu_N4 := by
  unfold mcOverMu_N4
  obtain ⟨_, hep, hsp⟩ := upQuarkKernel_vals_pos_at_4
  exact div_pos hep hsp

/-- The predicted top-to-charm mass ratio is strictly positive. -/
theorem mtOverMc_N4_pos : 0 < mtOverMc_N4 := by
  unfold mtOverMc_N4
  obtain ⟨hpp, hep, _⟩ := upQuarkKernel_vals_pos_at_4
  exact div_pos hpp hep

/-- The predicted top-to-up mass ratio is strictly positive. -/
theorem mtOverMu_N4_pos : 0 < mtOverMu_N4 := by
  unfold mtOverMu_N4
  obtain ⟨hpp, _, hsp⟩ := upQuarkKernel_vals_pos_at_4
  exact div_pos hpp hsp

/-- The predicted strange-to-down mass ratio is strictly positive. -/
theorem msOverMd_N4_pos : 0 < msOverMd_N4 := by
  unfold msOverMd_N4
  obtain ⟨_, hep, hsp⟩ := downQuarkKernel_vals_pos_at_4
  exact div_pos hep hsp

/-- The predicted bottom-to-strange mass ratio is strictly positive. -/
theorem mbOverMs_N4_pos : 0 < mbOverMs_N4 := by
  unfold mbOverMs_N4
  obtain ⟨hpp, hep, _⟩ := downQuarkKernel_vals_pos_at_4
  exact div_pos hpp hep

/-- The predicted bottom-to-down mass ratio is strictly positive. -/
theorem mbOverMd_N4_pos : 0 < mbOverMd_N4 := by
  unfold mbOverMd_N4
  obtain ⟨hpp, _, hsp⟩ := downQuarkKernel_vals_pos_at_4
  exact div_pos hpp hsp

/-! ## 4. Algebraic consistency identities

    The predicted ratios satisfy
        m_t/m_u = (m_t/m_c)(m_c/m_u)
        m_b/m_d = (m_b/m_s)(m_s/m_d)
    as pure algebraic identities of positive reals. These are necessary
    conditions for any triplet of mass predictions — they do NOT depend
    on the choice of kernel. -/

/-- **Up-type consistency**: `m_t/m_u = (m_t/m_c)(m_c/m_u)` at N = 4. -/
theorem up_ratios_consistent :
    mtOverMu_N4 = mtOverMc_N4 * mcOverMu_N4 := by
  unfold mtOverMu_N4 mtOverMc_N4 mcOverMu_N4
  obtain ⟨hpp, hep, hsp⟩ := upQuarkKernel_vals_pos_at_4
  field_simp

/-- **Down-type consistency**: `m_b/m_d = (m_b/m_s)(m_s/m_d)` at N = 4. -/
theorem down_ratios_consistent :
    mbOverMd_N4 = mbOverMs_N4 * msOverMd_N4 := by
  unfold mbOverMd_N4 mbOverMs_N4 msOverMd_N4
  obtain ⟨hpp, hep, hsp⟩ := downQuarkKernel_vals_pos_at_4
  field_simp

/-! ## 5. Strict ordering: both sectors predict the heavier > lighter tower

    For both sectors, the kernel is strictly increasing on `(0, 1)` (proved
    in `QuarkMassFromIrrationals.lean` as `upQuarkKernel_strictMono` and
    `downQuarkKernel_strictMono`), and the three `δ(4)`'s are strictly
    ordered `δ_√2(4) < δ_e(4) < δ_π(4)`. Hence both ratio triples form
    strictly ordered multiplets, realizing the "heavy / middle / light"
    quark-mass hierarchy. -/

/-- `m_c/m_u > 1` at `N = 4`: the charm quark is predicted heavier than
    the up quark. -/
theorem mcOverMu_gt_one : 1 < mcOverMu_N4 := by
  unfold mcOverMu_N4
  obtain ⟨_, hep, hsp⟩ := upQuarkKernel_vals_pos_at_4
  obtain ⟨_, _, _, _, hs_pos, _⟩ := delta_vals_pos_lt_one_at_4_q
  have h_sqrt_lt_e : sqrt2_error_val 4 < e_error_val 4 :=
    sqrt2_error_lt_e_error (by norm_num)
  have h_e_lt_1 : e_error_val 4 < 1 := e_error_lt_one (by norm_num)
  have h_kernel_lt : upQuarkKernel (sqrt2_error_val 4) <
                     upQuarkKernel (e_error_val 4) :=
    upQuarkKernel_strictMono hs_pos h_sqrt_lt_e h_e_lt_1
  rw [lt_div_iff₀ hsp, one_mul]
  exact h_kernel_lt

/-- `m_t/m_c > 1` at `N = 4`: the top quark is predicted heavier than
    the charm quark. -/
theorem mtOverMc_gt_one : 1 < mtOverMc_N4 := by
  unfold mtOverMc_N4
  obtain ⟨hpp, hep, _⟩ := upQuarkKernel_vals_pos_at_4
  obtain ⟨_, _, he_pos, _, _, _⟩ := delta_vals_pos_lt_one_at_4_q
  have h_e_lt_pi : e_error_val 4 < pi_error_val 4 :=
    e_error_lt_pi_error (by norm_num)
  have h_pi_lt_1 : pi_error_val 4 < 1 := pi_error_lt_one (by norm_num)
  have h_kernel_lt : upQuarkKernel (e_error_val 4) <
                     upQuarkKernel (pi_error_val 4) :=
    upQuarkKernel_strictMono he_pos h_e_lt_pi h_pi_lt_1
  rw [lt_div_iff₀ hep, one_mul]
  exact h_kernel_lt

/-- `m_t/m_u > m_c/m_u` at `N = 4`: the top quark is heavier than the
    charm quark in up-quark units. -/
theorem mtOverMu_gt_mcOverMu : mcOverMu_N4 < mtOverMu_N4 := by
  rw [up_ratios_consistent]
  have h1 : 1 < mtOverMc_N4 := mtOverMc_gt_one
  have h2 : 0 < mcOverMu_N4 := mcOverMu_N4_pos
  calc mcOverMu_N4 = 1 * mcOverMu_N4 := by ring
    _ < mtOverMc_N4 * mcOverMu_N4 := mul_lt_mul_of_pos_right h1 h2

/-- `m_s/m_d > 1` at `N = 4`: the strange quark is predicted heavier than
    the down quark. -/
theorem msOverMd_gt_one : 1 < msOverMd_N4 := by
  unfold msOverMd_N4
  obtain ⟨_, hep, hsp⟩ := downQuarkKernel_vals_pos_at_4
  obtain ⟨_, _, _, _, hs_pos, _⟩ := delta_vals_pos_lt_one_at_4_q
  have h_sqrt_lt_e : sqrt2_error_val 4 < e_error_val 4 :=
    sqrt2_error_lt_e_error (by norm_num)
  have h_e_lt_1 : e_error_val 4 < 1 := e_error_lt_one (by norm_num)
  have h_kernel_lt : downQuarkKernel (sqrt2_error_val 4) <
                     downQuarkKernel (e_error_val 4) :=
    downQuarkKernel_strictMono hs_pos h_sqrt_lt_e h_e_lt_1
  rw [lt_div_iff₀ hsp, one_mul]
  exact h_kernel_lt

/-- `m_b/m_s > 1` at `N = 4`: the bottom quark is predicted heavier than
    the strange quark. -/
theorem mbOverMs_gt_one : 1 < mbOverMs_N4 := by
  unfold mbOverMs_N4
  obtain ⟨hpp, hep, _⟩ := downQuarkKernel_vals_pos_at_4
  obtain ⟨_, _, he_pos, _, _, _⟩ := delta_vals_pos_lt_one_at_4_q
  have h_e_lt_pi : e_error_val 4 < pi_error_val 4 :=
    e_error_lt_pi_error (by norm_num)
  have h_pi_lt_1 : pi_error_val 4 < 1 := pi_error_lt_one (by norm_num)
  have h_kernel_lt : downQuarkKernel (e_error_val 4) <
                     downQuarkKernel (pi_error_val 4) :=
    downQuarkKernel_strictMono he_pos h_e_lt_pi h_pi_lt_1
  rw [lt_div_iff₀ hep, one_mul]
  exact h_kernel_lt

/-- `m_b/m_d > m_s/m_d` at `N = 4`: bottom quark is heavier than the
    strange quark in down-quark units. -/
theorem mbOverMd_gt_msOverMd : msOverMd_N4 < mbOverMd_N4 := by
  rw [down_ratios_consistent]
  have h1 : 1 < mbOverMs_N4 := mbOverMs_gt_one
  have h2 : 0 < msOverMd_N4 := msOverMd_N4_pos
  calc msOverMd_N4 = 1 * msOverMd_N4 := by ring
    _ < mbOverMs_N4 * msOverMd_N4 := mul_lt_mul_of_pos_right h1 h2

/-! ## 6. Empirical-ansatz structure

    As in the lepton file, we package the four main ratios and their
    structural properties into a single witness, documenting that the
    N=4 Nashira quark prediction is an empirical ansatz (the `β = −3`
    integer is hypothesized from the `β = −N_color` 2-datum pattern,
    not derived). -/

/-- The structural **Nashira quark empirical-ansatz** at N = 4: all four
    main quark mass ratios are concrete, strictly positive closed-form
    expressions in `rpow` and `log`, and they satisfy the algebraic
    consistency identities plus strict ordering

        1 < m_c/m_u < m_t/m_u      (up-type)
        1 < m_s/m_d < m_b/m_d      (down-type) . -/
structure QuarkEmpiricalAnsatz where
  /-- m_c / m_u at N = 4. -/
  mcOverMu : ℝ
  /-- m_t / m_c at N = 4. -/
  mtOverMc : ℝ
  /-- m_t / m_u at N = 4. -/
  mtOverMu : ℝ
  /-- m_s / m_d at N = 4. -/
  msOverMd : ℝ
  /-- m_b / m_s at N = 4. -/
  mbOverMs : ℝ
  /-- m_b / m_d at N = 4. -/
  mbOverMd : ℝ
  /-- Each ratio is strictly positive. -/
  mc_mu_pos : 0 < mcOverMu
  mt_mc_pos : 0 < mtOverMc
  mt_mu_pos : 0 < mtOverMu
  ms_md_pos : 0 < msOverMd
  mb_ms_pos : 0 < mbOverMs
  mb_md_pos : 0 < mbOverMd
  /-- Consistency: `m_t/m_u = (m_t/m_c)(m_c/m_u)`. -/
  up_consistent : mtOverMu = mtOverMc * mcOverMu
  /-- Consistency: `m_b/m_d = (m_b/m_s)(m_s/m_d)`. -/
  down_consistent : mbOverMd = mbOverMs * msOverMd
  /-- All four base ratios are > 1 (the heavier / lighter ordering). -/
  mc_mu_gt_1 : 1 < mcOverMu
  mt_mc_gt_1 : 1 < mtOverMc
  ms_md_gt_1 : 1 < msOverMd
  mb_ms_gt_1 : 1 < mbOverMs

/-- **The substrate's concrete N=4 Nashira quark ansatz**: package the
    six predicted ratios together with their structural properties into
    a single witness. -/
noncomputable def nashiraQuarkN4Witness : QuarkEmpiricalAnsatz where
  mcOverMu := mcOverMu_N4
  mtOverMc := mtOverMc_N4
  mtOverMu := mtOverMu_N4
  msOverMd := msOverMd_N4
  mbOverMs := mbOverMs_N4
  mbOverMd := mbOverMd_N4
  mc_mu_pos := mcOverMu_N4_pos
  mt_mc_pos := mtOverMc_N4_pos
  mt_mu_pos := mtOverMu_N4_pos
  ms_md_pos := msOverMd_N4_pos
  mb_ms_pos := mbOverMs_N4_pos
  mb_md_pos := mbOverMd_N4_pos
  up_consistent := up_ratios_consistent
  down_consistent := down_ratios_consistent
  mc_mu_gt_1 := mcOverMu_gt_one
  mt_mc_gt_1 := mtOverMc_gt_one
  ms_md_gt_1 := msOverMd_gt_one
  mb_ms_gt_1 := mbOverMs_gt_one

/-- **Existence of the Nashira quark ansatz**. The second falsifiability
    existential: the substrate admits at least one self-consistent set
    of six quark-mass ratio predictions that satisfy both up-type and
    down-type hierarchies expected of (u, c, t) and (d, s, b). -/
theorem nashira_quark_ansatz_exists : ∃ (_ : QuarkEmpiricalAnsatz), True :=
  ⟨nashiraQuarkN4Witness, trivial⟩

/-! ## 7. PDG falsifiability sandwich (existential form)

    As in the lepton file, we state the N=4 Nashira quark ratios lie in
    narrow intervals around PDG 2024 central values. The existential is
    technically vacuous (every real is within some ε of another), but
    it records the commitment in Lean form. The non-trivial content is
    the sign / ordering / consistency content above, plus the Phase-1
    Python verification that specific numeric values match PDG 2024 up
    to experimental uncertainty bounds (summarized in §8). -/

/-- A PDG quark-mass reference triplet: four central ratios from the
    Particle Data Group 2024 (plus two derived products). -/
structure PDGQuarkRatios where
  /-- Central m_c / m_u from PDG 2024 (large uncertainty from m_u). -/
  mcOverMu : ℝ
  /-- Central m_t / m_c from PDG 2024. -/
  mtOverMc : ℝ
  /-- Central m_t / m_u (derived product). -/
  mtOverMu : ℝ
  /-- Central m_s / m_d from PDG 2024. -/
  msOverMd : ℝ
  /-- Central m_b / m_s from PDG 2024. -/
  mbOverMs : ℝ
  /-- Central m_b / m_d (derived product). -/
  mbOverMd : ℝ
  mc_mu_pos : 0 < mcOverMu
  mt_mc_pos : 0 < mtOverMc
  mt_mu_pos : 0 < mtOverMu
  ms_md_pos : 0 < msOverMd
  mb_ms_pos : 0 < mbOverMs
  mb_md_pos : 0 < mbOverMd
  /-- PDG up-type ratios satisfy `m_t/m_u = (m_t/m_c)(m_c/m_u)` exactly. -/
  up_consistent : mtOverMu = mtOverMc * mcOverMu
  /-- PDG down-type ratios satisfy `m_b/m_d = (m_b/m_s)(m_s/m_d)`. -/
  down_consistent : mbOverMd = mbOverMs * msOverMd

/-- **PDG 2024 quark-ratio data (central values).**

    Up-sector (MS-bar at 2 GeV for m_u, m_c(m_c), pole for m_t):
      m_u ≈ 2.16 MeV (±~22%),   m_c ≈ 1.27 GeV (±~1.6%),  m_t ≈ 172.76 GeV (±~0.2%)
      m_c/m_u ≈ 587.96   (large err because of m_u)
      m_t/m_c ≈ 136.03
      m_t/m_u ≈ 79981.48 (derived)

    Down-sector (MS-bar at 2 GeV for m_d, m_s, m_b(m_b)):
      m_d ≈ 4.67 MeV (±~10%),   m_s ≈ 93.4 MeV (±~9%),    m_b ≈ 4.18 GeV (±~0.7%)
      m_s/m_d ≈ 20.00  (±~14%)
      m_b/m_s ≈ 44.75  (±~9%)
      m_b/m_d ≈ 895.07 (derived)

    For the struct to be well-typed, the derived products are stored as
    `mt_mc * mc_mu` and `mb_ms * ms_md`, not the nominal-PDG products
    (which are identical to the rounded values anyway). -/
noncomputable def PDG2024Quarks : PDGQuarkRatios :=
  { mcOverMu := (587.96 : ℝ),
    mtOverMc := (136.03 : ℝ),
    mtOverMu := (136.03 : ℝ) * (587.96 : ℝ),
    msOverMd := (20 : ℝ),
    mbOverMs := (44.75 : ℝ),
    mbOverMd := (44.75 : ℝ) * (20 : ℝ),
    mc_mu_pos := by norm_num,
    mt_mc_pos := by norm_num,
    mt_mu_pos := by positivity,
    ms_md_pos := by norm_num,
    mb_ms_pos := by norm_num,
    mb_md_pos := by positivity,
    up_consistent := by ring,
    down_consistent := by ring }

/-- **Headline falsifiability sandwich (quark sector).** There exists a
    positive tolerance `ε` such that each Nashira-predicted N=4 quark
    ratio lies in `[PDG - ε, PDG + ε]` around the corresponding PDG
    central value.

    Informally, Phase-1 verifies:
      - `m_c/m_u`: within PDG 30% uncertainty (err +10.3%)
      - `m_t/m_c`: 12.3% off, larger than PDG 1.6% uncertainty
      - `m_s/m_d`: 35.9% off, larger than PDG 14% uncertainty
      - `m_b/m_s`: within PDG 9.2% uncertainty (err +8.3%)

    We state the existential without committing to a particular `ε` —
    the non-trivial content is the **sign pattern**, **ordering**, and
    **algebraic consistency** of the prediction, all proved in §3–§5.

    A tight Lean certificate would require machine evaluation of
    `rpow (4/11) (3/7) / (-log(4/11))^3` etc., which Mathlib v4.29
    cannot currently deliver; the Phase-1 Python script
    `services/quark_ratios_scan.py` supplies that numerical witness. -/
theorem quark_nashira_pdg_bracket_exists :
    ∃ (ε : ℝ), 0 < ε ∧
    |mcOverMu_N4 - PDG2024Quarks.mcOverMu| ≤ ε ∧
    |mtOverMc_N4 - PDG2024Quarks.mtOverMc| ≤ ε ∧
    |msOverMd_N4 - PDG2024Quarks.msOverMd| ≤ ε ∧
    |mbOverMs_N4 - PDG2024Quarks.mbOverMs| ≤ ε := by
  set d1 := |mcOverMu_N4 - PDG2024Quarks.mcOverMu|
  set d2 := |mtOverMc_N4 - PDG2024Quarks.mtOverMc|
  set d3 := |msOverMd_N4 - PDG2024Quarks.msOverMd|
  set d4 := |mbOverMs_N4 - PDG2024Quarks.mbOverMs|
  refine ⟨d1 + d2 + d3 + d4 + 1, ?_, ?_, ?_, ?_, ?_⟩
  · linarith [abs_nonneg (mcOverMu_N4 - PDG2024Quarks.mcOverMu),
              abs_nonneg (mtOverMc_N4 - PDG2024Quarks.mtOverMc),
              abs_nonneg (msOverMd_N4 - PDG2024Quarks.msOverMd),
              abs_nonneg (mbOverMs_N4 - PDG2024Quarks.mbOverMs)]
  · linarith [abs_nonneg (mtOverMc_N4 - PDG2024Quarks.mtOverMc),
              abs_nonneg (msOverMd_N4 - PDG2024Quarks.msOverMd),
              abs_nonneg (mbOverMs_N4 - PDG2024Quarks.mbOverMs)]
  · linarith [abs_nonneg (mcOverMu_N4 - PDG2024Quarks.mcOverMu),
              abs_nonneg (msOverMd_N4 - PDG2024Quarks.msOverMd),
              abs_nonneg (mbOverMs_N4 - PDG2024Quarks.mbOverMs)]
  · linarith [abs_nonneg (mcOverMu_N4 - PDG2024Quarks.mcOverMu),
              abs_nonneg (mtOverMc_N4 - PDG2024Quarks.mtOverMc),
              abs_nonneg (mbOverMs_N4 - PDG2024Quarks.mbOverMs)]
  · linarith [abs_nonneg (mcOverMu_N4 - PDG2024Quarks.mcOverMu),
              abs_nonneg (mtOverMc_N4 - PDG2024Quarks.mtOverMc),
              abs_nonneg (msOverMd_N4 - PDG2024Quarks.msOverMd)]

/-! ## 8. The Phase-1 numerical verdict (documentation only)

    External numerical witness for the PDG fit, computed in Python with
    `math.pow` and `math.log` at double precision (~16 significant
    digits). The companion Python script `services/quark_ratios_scan.py`
    is the source of truth for these numerical values.

    ```
    N = 4:
      m_c/m_u predicted = 648.3    (PDG 587.96, err +10.26%)  WITHIN PDG ±22-30%
      m_t/m_c predicted = 152.7    (PDG 136.03, err +12.29%)  OUTSIDE PDG ±1.6%
      m_s/m_d predicted = 27.17    (PDG 20.00,  err +35.87%)  OUTSIDE PDG ±14%
      m_b/m_s predicted = 48.49    (PDG 44.75,  err  +8.35%)  WITHIN PDG ±9.2%
      Total |err|       = 66.76 %

      m_t/m_u predicted = 9.902e4  (PDG 7.998e4 derived)
      m_b/m_d predicted = 1.318e3  (PDG 8.951e2 derived)
    ```

    At other integer N in [2, 6], total |err| is ≥ 230 %, with N=5 and
    N=6 producing ratios that diverge by ORDERS of magnitude. This
    establishes that the N=4 = dim(ℤ⁴) sweet spot is universal across
    lepton AND quark sectors, though the *magnitude* of the fit is
    looser for quarks (physics-consistent: quark masses run with energy
    scale under QCD, and the `β = −N_color` integer ansatz is a 2-datum
    empirical pattern from just lepton+quark data, NOT a derivation).

    **Honest verdict: `PARTIAL_MATCH` — 2/4 quark ratios within PDG
    uncertainty bands at N = 4; 2/4 outside (m_t/m_c, m_s/m_d).**

    The quark-sector kernels `f_u(δ) = δ^(3/7)/(-ln δ)^3` and
    `f_d(δ) = 1/(-ln δ)^3` are **empirical ansätze**: the exponents `3/7`
    and `−3` and the `β = −N_color` pattern are fit parameters, NOT
    derivations from first principles. A Connes D_F / heat-kernel
    pathway that would derive them is documented in
    `NOTES_DF_EIGENVALUES.md` and remains open research.
-/

/-- **First-principles caveat statement** for the quark sector (a formal
    disclosure, not a theorem about OmegaTheory's axioms). The quark
    Nashira kernels are *empirical* ansätze: this proposition is stated
    as a `def` returning a `String` so that the project carries an
    explicit machine-checkable record of the ansatz status. -/
def quark_ratios_status : String :=
  "Empirical ansatz: up-kernel f_u(δ) = δ^(3/7)/(-ln δ)^3, " ++
  "down-kernel f_d(δ) = 1/(-ln δ)^3; " ++
  "β = -3 is a 2-datum empirical pattern (β = -N_color), NOT derived; " ++
  "N = 4 matches PDG 2024 partially: 2/4 within PDG uncertainty " ++
  "(m_c/m_u +10.3% vs ±30%, m_b/m_s +8.3% vs ±9.2% — both within), " ++
  "2/4 outside PDG (m_t/m_c +12.3% vs ±1.6%, m_s/m_d +35.9% vs ±14%); " ++
  "verdict = PARTIAL_MATCH; first-principles derivation from Connes D_F: open."

/-! ## 9. Link to the parent Nashira lepton ansatz

    We record that the substrate's N=4 Nashira witness exists for both
    leptons (where it matches PDG to 0.15 %) and quarks (where it matches
    partially, as discussed above). The combined existence statement
    documents that OmegaTheory's `δ_comp` machinery admits a single
    witness-triple (leptons, up-quarks, down-quarks) that realises the
    observed mass hierarchies, albeit with sector-dependent accuracy. -/

/-- **Combined lepton + quark N=4 Nashira witness existence**: the
    substrate admits a self-consistent N=4 prediction for ALL three
    charged-fermion sectors (leptons, up-type quarks, down-type quarks)
    that satisfies the observed generation mass hierarchy in each.

    The *magnitude* of the PDG agreement is sector-dependent (leptons
    to 0.15 %, quarks to 8–36 %), recorded in the respective
    `nashira_status` / `quark_ratios_status` strings. -/
theorem combined_nashira_N4_witness_exists :
    (∃ (_ : NashiraEmpiricalAnsatz), True) ∧
    (∃ (_ : QuarkEmpiricalAnsatz), True) :=
  ⟨nashira_ansatz_exists, nashira_quark_ansatz_exists⟩

end OmegaTheory.Predictions.QuarkMassRatioNumerical
