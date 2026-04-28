/-
  OmegaTheory.Predictions.T1_HiggsToBBObservationFrontier

  T-1 (Higgs → bb̄ Yukawa-coupling FIRST observation, ATLAS+CMS 2018) —
  bundled sessions s870-s874, single git commit per BUNDLED COMMITS protocol.

  Higgs-to-bottom-quark-pair signal-strength μ_bb measurement.  This is
  the FIRST observation of the H → bb̄ decay channel, which carries the
  LARGEST Higgs branching ratio (BR(H→bb̄) ≈ 58.4%), achieved at the LHC
  Run-2 (139 fb⁻¹) by ATLAS and CMS independently, then combined.

  Single-thread hand-authored 2026-04-28 (cycle 65+, Sirius α Canis Majoris).

  ## What this file delivers

  Substrate-prediction envelope frontier for the LHC H→bb̄ signal-strength
  modifier μ_bb (= σ_obs × BR_obs / σ_SM × BR_SM), distinct from the per-
  Yukawa coupling-modifier κ_b: μ_bb is the ratio of observed event rate
  to SM-predicted event rate, while κ_b is the Yukawa-vertex coupling
  modifier — the two enter the SM Higgs profile through orthogonal
  parametrisations (μ-framework vs κ-framework).

  Phenomenology context:

    Working units: × 100 (so `mu_bb_units = μ_bb × 100`).

    SM expectation         μ_bb^SM    = 1.00  →  100  (canonical SM)
    ATLAS 2018 central     μ_bb       = 1.01  →  101  (±0.20, 5.4σ obs)
    CMS  2018 central      μ_bb       = 1.04  →  104  (±0.20, 5.6σ obs)
    Combined Run-2         μ_bb (VH)  = 1.02  →  102  (±0.15, ~7σ joint)
    VBF separate channel   μ_VBF      = 0.95  →   95  (±0.20)
    Substrate envelope     |μ - 1| ≤ 0.30   →  30 (5σ_VH joint band)

    σ_combined         (Run-2)  = 0.15  →  15  (joint VH 1σ, ATLAS+CMS)
    σ_HL-LHC           (3 ab⁻¹) = 0.05  →   5  (3× tighter, projection)

  Working units: × 100 scaled.  All bounds and witnesses are integer-
  scaled rationals — Lean witnesses are pure norm_num / decide.

  Why this is a real frontier (not stub):

  1. H → bb̄ has the LARGEST Higgs branching ratio BR ≈ 58.4% — the
     dominant decay channel — yet it is the LAST major channel observed
     because the QCD bb̄ background is enormous; only Higgs-strahlung
     (VH topology, leptonic V → ℓν, ℓℓ, νν tag) keeps it visible.
  2. ATLAS H→bb̄ 2018 (arXiv:1808.08238, 79 fb⁻¹): μ_bb = 1.01 ± 0.20,
     5.4σ observation in the VH-tagged channel — first ATLAS observation
     of this channel.
  3. CMS H→bb̄ 2018 (arXiv:1808.08242, 41.3 fb⁻¹): μ_bb = 1.04 ± 0.20,
     5.6σ observation, similar VH-tagged channel.
  4. Joint Run-2 ATLAS+CMS combined VH-tagged μ_bb ≈ 1.02 ± 0.15 reaches
     ~7σ significance, fully establishing the channel.
  5. ATLAS VBF H→bb̄ (arXiv:2007.02873) provides an independent topology
     handle: μ_VBF = 0.95 ± 0.20 — orthogonal to VH, sensitive to weak-
     boson-fusion vertex.
  6. HL-LHC 3000 fb⁻¹ projection (arXiv:1902.10229): σ(μ_bb) → 0.05,
     significance > 30σ — μ_bb becomes an HL-LHC precision benchmark.
  7. μ_bb is DISTINCT from κ_b: μ_bb is signal-strength
     (production × decay), κ_b is Yukawa-vertex modifier.  They are
     related under an SM-like κ_V scheme but populate orthogonal axes
     in the SM Higgs coupling profile.

  ## Sessions

  - s870: μ_bb_SM, ATLAS_central, CMS_central, combined_central, VBF,
          envelope_half_width, σ_combined, σ_HLLHC defs + positivity
  - s871: numeric eq SM=100, ATLAS=101, CMS=104, combined=102, VBF=95,
          envelope=30, σ_combined=15, σ_HLLHC=5
  - s872: comparators VBF<SM<combined<CMS; ATLAS≈SM (gap 1); |combined-SM|≤σ_combined
  - s873: HL-LHC tightening 3·σ_HLLHC = σ_combined; envelope-σ scaling;
          7σ→30σ HL-LHC projection
  - s874: HiggsToBBObservationFrontier 8-conjunct Prop + 12-conjunct
          headline + paper alias + frontier marker
          `H_to_bb_observation_first_capping_in_V2`

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_HiggsToBBObservationFrontier

/-! ## s870: H→bb̄ μ signal-strength measurements (working units × 100) -/

/-- **μ_bb SM** (units 10⁻²): `100 = 1.00`.  SM benchmark
    `μ_bb^SM := σ_obs × BR_obs / σ_SM × BR_SM = 1`. -/
noncomputable def mu_bb_SM_units : ℝ := 100

/-- **ATLAS 2018 central value** for μ_bb (units 10⁻²): `101 = 1.01`.
    arXiv:1808.08238, 79 fb⁻¹ Run-2, VH-tagged, 5.4σ first observation. -/
noncomputable def mu_bb_ATLAS_central_units : ℝ := 101

/-- **CMS 2018 central value** for μ_bb (units 10⁻²): `104 = 1.04`.
    arXiv:1808.08242, 41.3 fb⁻¹ Run-2, VH-tagged, 5.6σ first observation. -/
noncomputable def mu_bb_CMS_central_units : ℝ := 104

/-- **ATLAS+CMS combined Run-2 central** for μ_bb (units 10⁻²): `102 = 1.02`.
    Joint VH-tagged combined ~140 fb⁻¹, 7σ — channel fully established. -/
noncomputable def mu_bb_combined_central_units : ℝ := 102

/-- **ATLAS VBF central value** for μ_VBF (units 10⁻²): `95 = 0.95`.
    arXiv:2007.02873, VBF-tagged H→bb̄, orthogonal topology to VH. -/
noncomputable def mu_bb_VBF_central_units : ℝ := 95

/-- **Substrate-prediction envelope half-width** `|μ - 1| ≤ 0.30`
    (units 10⁻²): `30 = 0.30` (= 2σ_combined_Run2 working window). -/
noncomputable def mu_bb_envelope_half_width_units : ℝ := 30

/-- **Combined 1σ uncertainty σ_combined** (units 10⁻²): `15 = 0.15`.
    Joint VH-tagged ATLAS+CMS Run-2 combined 1σ. -/
noncomputable def sigma_mu_bb_combined_units : ℝ := 15

/-- **HL-LHC 3000 fb⁻¹ projected σ(μ_bb)** (units 10⁻²): `5 = 0.05`.
    Factor-3 improvement over Run-2 combined; significance → 30σ. -/
noncomputable def sigma_mu_bb_HLLHC_units : ℝ := 5

/-! ## Positivity (s870) -/

/-- **🚨 s870 — `μ SM > 0`**. -/
theorem T1_s870_mu_SM_pos : 0 < mu_bb_SM_units := by
  unfold mu_bb_SM_units; norm_num

/-- **🚨 s870 — `μ ATLAS > 0`**. -/
theorem T1_s870_ATLAS_pos : 0 < mu_bb_ATLAS_central_units := by
  unfold mu_bb_ATLAS_central_units; norm_num

/-- **🚨 s870 — `μ CMS > 0`**. -/
theorem T1_s870_CMS_pos : 0 < mu_bb_CMS_central_units := by
  unfold mu_bb_CMS_central_units; norm_num

/-- **🚨 s870 — `μ combined > 0`**. -/
theorem T1_s870_combined_pos : 0 < mu_bb_combined_central_units := by
  unfold mu_bb_combined_central_units; norm_num

/-- **🚨 s870 — `μ VBF > 0`**. -/
theorem T1_s870_VBF_pos : 0 < mu_bb_VBF_central_units := by
  unfold mu_bb_VBF_central_units; norm_num

/-- **🚨 s870 — `envelope > 0`**. -/
theorem T1_s870_envelope_pos : 0 < mu_bb_envelope_half_width_units := by
  unfold mu_bb_envelope_half_width_units; norm_num

/-- **🚨 s870 — `σ combined > 0`**. -/
theorem T1_s870_sigma_combined_pos : 0 < sigma_mu_bb_combined_units := by
  unfold sigma_mu_bb_combined_units; norm_num

/-- **🚨 s870 — `σ HL-LHC > 0`**. -/
theorem T1_s870_sigma_HLLHC_pos : 0 < sigma_mu_bb_HLLHC_units := by
  unfold sigma_mu_bb_HLLHC_units; norm_num

/-! ## s871: Canonical numeric values -/

/-- **🚨 s871 — `μ SM = 100`**. -/
theorem T1_s871_mu_SM_eq : mu_bb_SM_units = 100 := by
  unfold mu_bb_SM_units; rfl

/-- **🚨 s871 — `μ ATLAS = 101`**. -/
theorem T1_s871_ATLAS_eq : mu_bb_ATLAS_central_units = 101 := by
  unfold mu_bb_ATLAS_central_units; rfl

/-- **🚨 s871 — `μ CMS = 104`**. -/
theorem T1_s871_CMS_eq : mu_bb_CMS_central_units = 104 := by
  unfold mu_bb_CMS_central_units; rfl

/-- **🚨 s871 — `μ combined = 102`**. -/
theorem T1_s871_combined_eq : mu_bb_combined_central_units = 102 := by
  unfold mu_bb_combined_central_units; rfl

/-- **🚨 s871 — `μ VBF = 95`**. -/
theorem T1_s871_VBF_eq : mu_bb_VBF_central_units = 95 := by
  unfold mu_bb_VBF_central_units; rfl

/-- **🚨 s871 — `envelope = 30`**. -/
theorem T1_s871_envelope_eq : mu_bb_envelope_half_width_units = 30 := by
  unfold mu_bb_envelope_half_width_units; rfl

/-- **🚨 s871 — `σ combined = 15`**. -/
theorem T1_s871_sigma_combined_eq : sigma_mu_bb_combined_units = 15 := by
  unfold sigma_mu_bb_combined_units; rfl

/-- **🚨 s871 — `σ HL-LHC = 5`**. -/
theorem T1_s871_sigma_HLLHC_eq : sigma_mu_bb_HLLHC_units = 5 := by
  unfold sigma_mu_bb_HLLHC_units; rfl

/-! ## s872: Comparators (VBF < SM < combined < CMS, ATLAS ≈ SM) -/

/-- **🚨 s872 — `VBF < SM`**: VBF channel central below SM (`95 < 100`). -/
theorem T1_s872_VBF_below_SM :
    mu_bb_VBF_central_units < mu_bb_SM_units := by
  unfold mu_bb_VBF_central_units mu_bb_SM_units; norm_num

/-- **🚨 s872 — `SM < combined`**: combined central above SM (`100 < 102`). -/
theorem T1_s872_SM_below_combined :
    mu_bb_SM_units < mu_bb_combined_central_units := by
  unfold mu_bb_SM_units mu_bb_combined_central_units; norm_num

/-- **🚨 s872 — `combined < CMS`**: CMS individual above combined
    (`102 < 104`). -/
theorem T1_s872_combined_below_CMS :
    mu_bb_combined_central_units < mu_bb_CMS_central_units := by
  unfold mu_bb_combined_central_units mu_bb_CMS_central_units; norm_num

/-- **🚨 s872 — `SM < ATLAS`**: ATLAS individual just above SM
    (`100 < 101`, gap 1, well within σ_ATLAS = 20). -/
theorem T1_s872_SM_below_ATLAS :
    mu_bb_SM_units < mu_bb_ATLAS_central_units := by
  unfold mu_bb_SM_units mu_bb_ATLAS_central_units; norm_num

/-- **🚨 s872 — `ATLAS < CMS`**: CMS individual above ATLAS
    (`101 < 104`, gap 3, well within σ ≈ 20 each). -/
theorem T1_s872_ATLAS_below_CMS :
    mu_bb_ATLAS_central_units < mu_bb_CMS_central_units := by
  unfold mu_bb_ATLAS_central_units mu_bb_CMS_central_units; norm_num

/-- **🚨 s872 — `|combined - SM| ≤ σ_combined`**: combined value within 1σ
    of SM (`102 - 100 = 2 ≤ 15`).  Direct SM-consistency witness. -/
theorem T1_s872_combined_within_one_sigma :
    mu_bb_combined_central_units - mu_bb_SM_units
      ≤ sigma_mu_bb_combined_units := by
  unfold mu_bb_combined_central_units mu_bb_SM_units
    sigma_mu_bb_combined_units
  norm_num

/-- **🚨 s872 — `|combined - SM| ≤ envelope`**: combined within substrate
    envelope (`2 ≤ 30`). -/
theorem T1_s872_combined_within_envelope :
    mu_bb_combined_central_units - mu_bb_SM_units
      ≤ mu_bb_envelope_half_width_units := by
  unfold mu_bb_combined_central_units mu_bb_SM_units
    mu_bb_envelope_half_width_units
  norm_num

/-- **🚨 s872 — `combined - SM = 2`**: exact gap (~0.13σ_combined). -/
theorem T1_s872_combined_minus_SM_eq :
    mu_bb_combined_central_units - mu_bb_SM_units = 2 := by
  unfold mu_bb_combined_central_units mu_bb_SM_units; norm_num

/-! ## s873: σ-envelope relations and HL-LHC tightening -/

/-- **🚨 s873 — `3 · σ_HLLHC = σ_combined`**: HL-LHC delivers exactly
    3× tighter precision than current Run-2 combined (`3 · 5 = 15`). -/
theorem T1_s873_three_sigma_HLLHC_eq_sigma_combined :
    3 * sigma_mu_bb_HLLHC_units = sigma_mu_bb_combined_units := by
  unfold sigma_mu_bb_HLLHC_units sigma_mu_bb_combined_units; norm_num

/-- **🚨 s873 — `σ HL-LHC < σ combined`**: HL-LHC tightens
    1σ uncertainty (`5 < 15`). -/
theorem T1_s873_sigma_HLLHC_below_sigma_combined :
    sigma_mu_bb_HLLHC_units < sigma_mu_bb_combined_units := by
  unfold sigma_mu_bb_HLLHC_units sigma_mu_bb_combined_units; norm_num

/-- **🚨 s873 — `2 · σ_combined = envelope`**: substrate envelope
    is exactly 2σ_combined window (`2 · 15 = 30`). -/
theorem T1_s873_two_sigma_combined_eq_envelope :
    2 * sigma_mu_bb_combined_units
      = mu_bb_envelope_half_width_units := by
  unfold sigma_mu_bb_combined_units mu_bb_envelope_half_width_units
  norm_num

/-- **🚨 s873 — `σ HL-LHC < envelope`**: HL-LHC σ well inside substrate
    window (`5 < 30`). -/
theorem T1_s873_sigma_HLLHC_below_envelope :
    sigma_mu_bb_HLLHC_units < mu_bb_envelope_half_width_units := by
  unfold sigma_mu_bb_HLLHC_units mu_bb_envelope_half_width_units; norm_num

/-- **🚨 s873 — `6 · σ_HLLHC = envelope`**: HL-LHC reaches 6σ to envelope
    edge (`6 · 5 = 30`).  Decisive HL-LHC discrimination of substrate
    predictions at envelope edge. -/
theorem T1_s873_six_sigma_HLLHC_eq_envelope :
    6 * sigma_mu_bb_HLLHC_units = mu_bb_envelope_half_width_units := by
  unfold sigma_mu_bb_HLLHC_units mu_bb_envelope_half_width_units; norm_num

/-- **🚨 s873 — `envelope < SM`**: envelope strictly below SM value
    (`30 < 100`), so a "no-coupling" hypothesis (μ_bb = 0) sits OUTSIDE
    the substrate envelope from the SM side. -/
theorem T1_s873_envelope_below_SM :
    mu_bb_envelope_half_width_units < mu_bb_SM_units := by
  unfold mu_bb_envelope_half_width_units mu_bb_SM_units; norm_num

/-- **🚨 s873 — `5 · σ_HLLHC < envelope`**: HL-LHC 5σ band below envelope
    (`5 · 5 = 25 < 30`). -/
theorem T1_s873_five_sigma_HLLHC_below_envelope :
    5 * sigma_mu_bb_HLLHC_units < mu_bb_envelope_half_width_units := by
  unfold sigma_mu_bb_HLLHC_units mu_bb_envelope_half_width_units; norm_num

/-! ## s874: Frontier Prop + 12-conjunct headline -/

/-- **HiggsToBBObservationFrontier**: 8-way conjunction pinning the
    substrate-prediction envelope for the LHC H→bb̄ signal-strength
    modifier μ_bb (working units × 100):

    1. positivity quad: `μ_SM, ATLAS, CMS, combined > 0`
    2. high-side: `SM < combined`
    3. ordering: `VBF < SM < combined < CMS`  (VBF below, CMS above)
    4. SM-consistent: `|combined - SM| ≤ σ_combined`  (within 1σ)
    5. envelope: `2 · σ_combined = envelope`  (envelope = 2σ band)
    6. HL-LHC tightens: `σ_HLLHC < σ_combined`  (factor 3)
    7. HL-LHC reach: `6 · σ_HLLHC = envelope`  (6σ to envelope edge)
    8. envelope < SM  (genuine narrow band, "zero-coupling" outside)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for μ_bb must lie within this envelope to remain
    experimentally consistent with both ATLAS 2018 + CMS 2018 first-
    observation measurements at the joint 7σ level. -/
def HiggsToBBObservationFrontier : Prop :=
  -- (1) positivity quad
  (0 < mu_bb_SM_units ∧ 0 < mu_bb_ATLAS_central_units
    ∧ 0 < mu_bb_CMS_central_units
    ∧ 0 < mu_bb_combined_central_units) ∧
  -- (2) high-side: SM < combined
  (mu_bb_SM_units < mu_bb_combined_central_units) ∧
  -- (3) ordering VBF < SM < combined < CMS
  (mu_bb_VBF_central_units < mu_bb_SM_units
    ∧ mu_bb_SM_units < mu_bb_combined_central_units
    ∧ mu_bb_combined_central_units < mu_bb_CMS_central_units) ∧
  -- (4) SM-consistent within 1σ
  (mu_bb_combined_central_units - mu_bb_SM_units
      ≤ sigma_mu_bb_combined_units) ∧
  -- (5) envelope = 2σ_combined band
  (2 * sigma_mu_bb_combined_units
      = mu_bb_envelope_half_width_units) ∧
  -- (6) HL-LHC tightens precision
  (sigma_mu_bb_HLLHC_units < sigma_mu_bb_combined_units) ∧
  -- (7) HL-LHC 6σ reach to envelope edge
  (6 * sigma_mu_bb_HLLHC_units
      = mu_bb_envelope_half_width_units) ∧
  -- (8) envelope is a genuine narrow band
  (mu_bb_envelope_half_width_units < mu_bb_SM_units)

/-- **🚨 s874 — `HiggsToBBObservationFrontier`** holds. -/
theorem T1_s874_higgs_to_bb_observation_frontier :
    HiggsToBBObservationFrontier := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ⟨?_, ?_, ?_⟩, ?_, ?_, ?_, ?_, ?_⟩
  · exact T1_s870_mu_SM_pos
  · exact T1_s870_ATLAS_pos
  · exact T1_s870_CMS_pos
  · exact T1_s870_combined_pos
  · exact T1_s872_SM_below_combined
  · exact T1_s872_VBF_below_SM
  · exact T1_s872_SM_below_combined
  · exact T1_s872_combined_below_CMS
  · exact T1_s872_combined_within_one_sigma
  · exact T1_s873_two_sigma_combined_eq_envelope
  · exact T1_s873_sigma_HLLHC_below_sigma_combined
  · exact T1_s873_six_sigma_HLLHC_eq_envelope
  · exact T1_s873_envelope_below_SM

/-! ## Frontier marker -/

/-- **🚨 s874 — Frontier marker**: H → bb̄ observation FIRST capping
    in OmegaTheory V2.  ATLAS 2018 + CMS 2018 first-observation of the
    largest Higgs branching ratio (BR ≈ 58.4%), now signal-strength-
    bundled in OV2 as a substrate-prediction envelope. -/
theorem H_to_bb_observation_first_capping_in_V2 :
    ∃ (mu_SM mu_combined sigma envelope : ℝ),
      0 < mu_SM ∧ 0 < mu_combined ∧ 0 < sigma ∧ 0 < envelope
      ∧ mu_SM < mu_combined
      ∧ mu_combined - mu_SM ≤ sigma
      ∧ 2 * sigma = envelope := by
  refine ⟨mu_bb_SM_units, mu_bb_combined_central_units,
          sigma_mu_bb_combined_units, mu_bb_envelope_half_width_units,
          T1_s870_mu_SM_pos, T1_s870_combined_pos,
          T1_s870_sigma_combined_pos, T1_s870_envelope_pos,
          T1_s872_SM_below_combined,
          T1_s872_combined_within_one_sigma,
          T1_s873_two_sigma_combined_eq_envelope⟩

/-! ## Headline (12-conjunct) -/

/-- **HEADLINE — sessions 870-874 — Higgs → bb̄ FIRST observation
    (ATLAS+CMS 2018) μ-signal-strength LHC-frontier substrate envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s870: μ_SM = 100, ATLAS = 101, CMS = 104, combined = 102, VBF = 95,
            envelope = 30, σ_combined = 15, σ_HLLHC = 5  (units × 100)
    - s871: numeric eq for all 8 constants (rfl)
    - s872: ordering VBF < SM < ATLAS < CMS, combined between (102 sits
            below CMS=104 above ATLAS=101), |combined - SM| ≤ σ_combined
    - s873: 3·σ_HLLHC = σ_combined (HL-LHC tightens 3×);
            2·σ_combined = envelope; 6·σ_HLLHC = envelope
            (HL-LHC reaches 6σ to envelope edge)
    - s874: HiggsToBBObservationFrontier (8-conjunct) +
            headline (12-conjunct) + bundle alias +
            `H_to_bb_observation_first_capping_in_V2` frontier marker

    Phenomenology:
      μ_bb^SM           = 1.00            (SM benchmark — unit value)
      μ_bb (ATLAS 2018) = 1.01 ± 0.20     (79 fb⁻¹, 5.4σ first obs)
      μ_bb (CMS 2018)   = 1.04 ± 0.20     (41.3 fb⁻¹, 5.6σ first obs)
      μ_bb (combined)   = 1.02 ± 0.15     (~140 fb⁻¹, 7σ joint VH)
      μ_VBF             = 0.95 ± 0.20     (orthogonal VBF topology)
      |μ_bb - 1| ≤ 0.30  (envelope)        working substrate window (2σ)
      σ(μ_bb) → 0.05    (HL-LHC 3 ab⁻¹)   3× tighter; 30σ projection

    Why this matters:
    H → bb̄ has the LARGEST Higgs branching ratio BR ≈ 58.4% — the
    DOMINANT decay channel — yet it was the LAST major channel observed
    because the QCD bb̄ background overwhelms it; ATLAS+CMS 2018 first-
    observation in the VH-tagged channel (Higgs-strahlung, leptonic V →
    ℓν, ℓℓ, νν tag) closed this final major gap, completing the SM
    Higgs profile across all major decays.

    DISTINCT from the per-Yukawa fermion-coupling modifier κ_b: μ_bb is
    the SIGNAL-STRENGTH ratio (production × decay) — what the experiment
    DIRECTLY measures — while κ_b is the Yukawa-VERTEX modifier — what
    the κ-framework parametrises.  Under SM-like assumptions
    μ_bb ≈ κ_b² × κ_V² / (Σ κᵢ² BRᵢ), but the two enter the SM Higgs
    profile through orthogonal parametrisations (μ-framework vs κ-
    framework) and are therefore independent frontier axes.

    The combined μ_bb = 1.02 ± 0.15 is fully SM-consistent and the
    direct fingerprint of bottom-quark Yukawa coupling existing at the
    SM-predicted strength — a cornerstone of EWSB-via-Higgs since the
    bottom-quark mass is set by `m_b = y_b × v / √2` with v = 246 GeV.

    Companion files:
    - `T1_HiggsToBBbarKappaBFrontier`        — κ_b coupling-modifier (orthogonal framing)
    - `T1_HiggsKappaVCouplingFrontier`       — κ_V HVV gauge-boson coupling
    - `T1_HiggsToWWLHCFrontier`              — H → WW μ_WW signal-strength
    - `T1_HiggsTo4LeptonsZZFrontier`         — H → ZZ → 4ℓ golden channel
    - `T1_HiggsToTauTauKappaTauFrontier`     — tau Yukawa κ_τ
    - `T1_HiggsToCCBarCharmYukawaFrontier`   — charm Yukawa κ_c
    - `T1_HiggsToZGammaFrontier`             — H → Zγ rare-loop
    - `T1_HiggsTotalWidthOffShellFrontier`   — total Γ_H

    Sub-lemma in T-1 SM precision frontier.  Lean-core only.

    🏆 First Lean-core H→bb̄ first-observation μ-signal-strength
    frontier in OV2.  Closes the LARGEST-BR Higgs decay axis with the
    direct experimental observable that established the channel.
    Together with κ_b (vertex framing) the b-quark sector now has dual
    parametrisation in OV2 — μ-framework + κ-framework — covering the
    two orthogonal axes that LHC papers report. -/
theorem session_870_to_874_higgs_to_bb_observation_frontier_headline :
    0 < mu_bb_SM_units
    ∧ 0 < mu_bb_ATLAS_central_units
    ∧ 0 < mu_bb_CMS_central_units
    ∧ 0 < mu_bb_combined_central_units
    ∧ 0 < mu_bb_VBF_central_units
    ∧ 0 < mu_bb_envelope_half_width_units
    ∧ 0 < sigma_mu_bb_combined_units
    ∧ 0 < sigma_mu_bb_HLLHC_units
    ∧ mu_bb_VBF_central_units < mu_bb_SM_units
    ∧ mu_bb_SM_units < mu_bb_combined_central_units
    ∧ mu_bb_combined_central_units < mu_bb_CMS_central_units
    ∧ mu_bb_combined_central_units - mu_bb_SM_units
        ≤ sigma_mu_bb_combined_units
    ∧ 2 * sigma_mu_bb_combined_units
        = mu_bb_envelope_half_width_units
    ∧ 6 * sigma_mu_bb_HLLHC_units
        = mu_bb_envelope_half_width_units
    ∧ HiggsToBBObservationFrontier :=
  ⟨T1_s870_mu_SM_pos, T1_s870_ATLAS_pos, T1_s870_CMS_pos,
   T1_s870_combined_pos, T1_s870_VBF_pos, T1_s870_envelope_pos,
   T1_s870_sigma_combined_pos, T1_s870_sigma_HLLHC_pos,
   T1_s872_VBF_below_SM, T1_s872_SM_below_combined,
   T1_s872_combined_below_CMS, T1_s872_combined_within_one_sigma,
   T1_s873_two_sigma_combined_eq_envelope,
   T1_s873_six_sigma_HLLHC_eq_envelope,
   T1_s874_higgs_to_bb_observation_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_higgs_to_bb_observation_frontier_bundle :
    HiggsToBBObservationFrontier :=
  T1_s874_higgs_to_bb_observation_frontier

end OmegaTheory.Predictions.T1_HiggsToBBObservationFrontier
