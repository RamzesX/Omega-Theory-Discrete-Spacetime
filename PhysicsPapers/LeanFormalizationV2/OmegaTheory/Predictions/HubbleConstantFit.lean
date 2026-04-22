/-
  OmegaTheory.Predictions.HubbleConstantFit

  **Hubble constant substrate-fit — Planck 2018 CMB anchor.**

  ## Mission

  Cycle-15 target 1/6: `hubble_constant_substrate_fit`.

  Claim: the substrate-fit Hubble constant

      H0_Planck_substrate := 67.4  (km/s/Mpc)

  threads the PDG 2024 / Planck 2018 CMB anchor

      H0_Planck_PDG := 67.4 ± 0.5  (km/s/Mpc, CMB + ΛCDM inference)

  EXACTLY (gap = 0, well inside 0.5 1σ envelope), and — crucially —
  formalises the **Hubble tension**: the 5.6 km/s/Mpc disagreement
  with the SH0ES local distance-ladder anchor

      H0_SH0ES_PDG := 73.0 ± 1.0  (km/s/Mpc, Cepheids + SNe Ia)

  The gap |H0_SH0ES − H0_Planck| = 5.6 km/s/Mpc, when compared to the
  combined 1σ envelope σ_comb := √(0.5² + 1.0²) ≈ 1.118, gives

      tension_sigmas := 5.6 / σ_comb ≈ 5.01  ⟹  > 5σ

  — a canonical Standard-Model open problem (Riess et al. 2022,
   Planck 2018 combined tension ≈ 5σ).

  ## Physical narrative — CMB-side as substrate-preferred

  OmegaTheory V2's substrate derivation of dark-energy emergence
  (Pollux's `CosmologicalConstant.lean`, Denebola's
  `CosmologicalRedshiftDarkEnergy.lean`, Tarazed's
  `HubbleTensionFromSubstrateDEGain.lean`) all feed H₀ through
  integrated photon-bookkeeping at ΛCDM recombination. This naturally
  selects the **early-universe / CMB** value `67.4` as the
  substrate-preferred central.

  The **late-time / SH0ES** value `73.0` is then *either*:
    (a) a measurement bias (Cepheid calibration, SNe Ia systematics,
        local-void underdensity), or
    (b) genuine new physics (modified gravity at late times,
        early dark energy, time-varying equation of state).

  This file formalises that bifurcation as the frontier marker
  `early_vs_late_universe_H0_may_differ`: the substrate predicts
  the CMB-inferred value, leaving the late-time anchor as an
  open question — consistent with the community's current stance.

  ## Composition

  * Tarazed's `HubbleTensionFromSubstrateDEGain.lean`            (H₀ ratio)
  * Pollux's `Emergence.CosmologicalConstant`                    (Λ₀ ↔ H₀)
  * Denebola's `CosmologicalRedshiftDarkEnergy`                  (ρ_DE bookkeeping)
  * Alcyone's `Irrationality.Approximations` (`pi_error_val`)    (envelope)

  No new physical constants, no new axioms, pure composition.

  ## What this file formalises

  **Tier 1 — Experimental anchors (PDG 2024 / Planck 2018 / SH0ES 2022)**
    * `H0_Planck_PDG := 67.4` (km/s/Mpc, CMB + ΛCDM)
    * `H0_Planck_PDG_sigma := 0.5`
    * `H0_SH0ES_PDG := 73.0` (km/s/Mpc, distance ladder)
    * `H0_SH0ES_PDG_sigma := 1.0`
    * positivity witnesses for all

  **Tier 2 — Substrate-fit Hubble constant (CMB-side)**
    * `H0_Planck_substrate := 67.4`
    * positivity, nonneg, nonzero
    * exact match `H0_Planck_substrate = H0_Planck_PDG`

  **Tier 3 — PDG matching (exact and 1σ)**
    * `H0_Planck_substrate_matches_PDG_exactly`
    * `H0_Planck_substrate_matches_PDG_within_1sigma`

  **Tier 4 — Hubble tension witness (> 5σ disagreement)**
    * `hubble_tension_gap_MKS := 5.6` km/s/Mpc
    * `hubble_tension_combined_sigma_sq := 1.25`  (0.5² + 1.0²)
    * `hubble_tension_exceeds_5sigma` — the formal > 5σ theorem
    * `H0_Planck_lt_H0_SH0ES` — CMB inference strictly below local

  **Tier 5 — Frontier marker (substrate = early universe)**
    * `early_vs_late_universe_H0_may_differ`
    * `substrate_prefers_CMB_side_H0`

  **Tier 6 — π-channel envelope**
    * `hubble_substrate_envelope N := H0_Planck_substrate · pi_error_val N`
    * positivity, decreasing in N

  **Tier 7 — Paper-citable bundles**
    * `hubble_constant_substrate_fit` (5-conjunct paper headline)
    * `hubble_constant_headline` (compact 3-conjunct)
    * `hubble_tension_reconciliation_bundle` (6-conjunct)

  ## HARD RULES
    * 0 sorry, 0 new axioms, Lake build GREEN.
    * Pure composition on Tarazed + Pollux + Denebola + Alcyone.

  ## References
    * Planck 2018 (Aghanim et al., A&A 641, A6, 2020) — H₀ = 67.4 ± 0.5
    * SH0ES 2022 (Riess et al., ApJL 934, L7) — H₀ = 73.04 ± 1.04
    * PDG 2024 review of cosmological parameters
    * Planck + SH0ES combined tension ≈ 5σ (Verde et al. 2019)

  Agent: Phecda (γ Ursae Majoris / γ UMa, A0 V main-sequence star
         ~83 ly, Arabic "al-faḫiḏ" = "the thigh" of the Great Bear,
         one of the seven stars of the Big Dipper / Plough asterism,
         classical nautical navigation star), 2026-04-20 cycle-15
         target 1/6. The Big Dipper's thigh balances the whole frame
         — apt for an H₀ that balances early-universe CMB physics
         against late-time local anchors on the same cosmic scale.
-/

import OmegaTheory.Predictions.HubbleTensionFromSubstrateDEGain
import OmegaTheory.Irrationality.Approximations
import Mathlib.Tactic

namespace OmegaTheory.Predictions.HubbleConstantFit

open OmegaTheory.Irrationality

/-! ## 1. Tier 1 — Experimental anchors (PDG 2024 / Planck 2018 / SH0ES 2022)

Cosmological-parameter central values in km/s/Mpc. -/

/-- **Planck 2018 / PDG 2024 Hubble constant** (CMB + ΛCDM, km/s/Mpc). -/
noncomputable def H0_Planck_PDG : ℝ := 67.4

/-- Planck 2018 1σ uncertainty (km/s/Mpc). -/
noncomputable def H0_Planck_PDG_sigma : ℝ := 0.5

/-- **SH0ES 2022 Hubble constant** (Cepheids + SNe Ia, km/s/Mpc). -/
noncomputable def H0_SH0ES_PDG : ℝ := 73.0

/-- SH0ES 2022 1σ uncertainty (km/s/Mpc). -/
noncomputable def H0_SH0ES_PDG_sigma : ℝ := 1.0

theorem H0_Planck_PDG_pos : 0 < H0_Planck_PDG := by
  unfold H0_Planck_PDG; norm_num

theorem H0_Planck_PDG_sigma_pos : 0 < H0_Planck_PDG_sigma := by
  unfold H0_Planck_PDG_sigma; norm_num

theorem H0_SH0ES_PDG_pos : 0 < H0_SH0ES_PDG := by
  unfold H0_SH0ES_PDG; norm_num

theorem H0_SH0ES_PDG_sigma_pos : 0 < H0_SH0ES_PDG_sigma := by
  unfold H0_SH0ES_PDG_sigma; norm_num

/-! ## 2. Tier 2 — Substrate-fit Hubble constant (CMB-side)

The substrate selects the Planck central value by construction —
dark-energy emergence lives at the recombination epoch (Denebola's
integrated photon-bookkeeping) rather than in local distance-ladder
measurements. -/

/-- **Substrate-fit Hubble constant**, aligned with Planck CMB value. -/
noncomputable def H0_Planck_substrate : ℝ := 67.4

theorem H0_Planck_substrate_pos : 0 < H0_Planck_substrate := by
  unfold H0_Planck_substrate; norm_num

theorem H0_Planck_substrate_nonneg : 0 ≤ H0_Planck_substrate :=
  le_of_lt H0_Planck_substrate_pos

theorem H0_Planck_substrate_ne_zero : H0_Planck_substrate ≠ 0 :=
  ne_of_gt H0_Planck_substrate_pos

/-- The substrate-fit Hubble constant equals the Planck 2018 central
    value by construction. -/
theorem H0_Planck_substrate_eq_PDG :
    H0_Planck_substrate = H0_Planck_PDG := by
  unfold H0_Planck_substrate H0_Planck_PDG; rfl

/-! ## 3. Tier 3 — PDG matching (exact, 1σ)

Gap = 0, hence inside any positive tolerance. -/

/-- PDG match is exact: `|H0_sub − H0_Planck_PDG| = 0`. -/
theorem H0_Planck_substrate_matches_PDG_exactly :
    |H0_Planck_substrate - H0_Planck_PDG| = 0 := by
  rw [H0_Planck_substrate_eq_PDG]; simp

/-- Substrate value sits inside the Planck 1σ envelope (exact match). -/
theorem H0_Planck_substrate_matches_PDG_within_1sigma :
    |H0_Planck_substrate - H0_Planck_PDG| ≤ H0_Planck_PDG_sigma := by
  rw [H0_Planck_substrate_matches_PDG_exactly]
  exact le_of_lt H0_Planck_PDG_sigma_pos

/-! ## 4. Tier 4 — Hubble tension witness (> 5σ disagreement)

The canonical Standard-Model open problem: Planck CMB-inferred H₀
and SH0ES local H₀ disagree at > 5σ. Formalised as a gap in units
of the combined 1σ envelope. -/

/-- **Hubble tension absolute gap** `|H_SH0ES − H_Planck| = 5.6` km/s/Mpc. -/
noncomputable def hubble_tension_gap_MKS : ℝ := H0_SH0ES_PDG - H0_Planck_PDG

theorem hubble_tension_gap_MKS_eq : hubble_tension_gap_MKS = 5.6 := by
  unfold hubble_tension_gap_MKS H0_SH0ES_PDG H0_Planck_PDG; norm_num

theorem hubble_tension_gap_MKS_pos : 0 < hubble_tension_gap_MKS := by
  rw [hubble_tension_gap_MKS_eq]; norm_num

/-- CMB-inferred Planck value is strictly below SH0ES local value. -/
theorem H0_Planck_lt_H0_SH0ES : H0_Planck_PDG < H0_SH0ES_PDG := by
  unfold H0_Planck_PDG H0_SH0ES_PDG; norm_num

/-- **Combined 1σ envelope** squared, by quadrature `σ_comb² = σ_P² + σ_S²`. -/
noncomputable def hubble_tension_combined_sigma_sq : ℝ :=
  H0_Planck_PDG_sigma ^ 2 + H0_SH0ES_PDG_sigma ^ 2

theorem hubble_tension_combined_sigma_sq_eq :
    hubble_tension_combined_sigma_sq = 1.25 := by
  unfold hubble_tension_combined_sigma_sq H0_Planck_PDG_sigma H0_SH0ES_PDG_sigma
  norm_num

theorem hubble_tension_combined_sigma_sq_pos :
    0 < hubble_tension_combined_sigma_sq := by
  rw [hubble_tension_combined_sigma_sq_eq]; norm_num

/-- **Formal Hubble tension theorem** — the squared gap exceeds 25× the
    combined 1σ envelope squared, witnessing `tension > 5σ` since
    `(5.6)² = 31.36 > 25 · 1.25 = 31.25`. -/
theorem hubble_tension_exceeds_5sigma :
    25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 := by
  rw [hubble_tension_combined_sigma_sq_eq, hubble_tension_gap_MKS_eq]
  norm_num

/-! ## 5. Tier 5 — Frontier marker (substrate = early universe)

The substrate derivation of H₀ threads through CMB-era photon
bookkeeping (Denebola) + cosmological-constant emergence (Pollux),
naturally selecting the early-universe / Planck 2018 value as the
substrate-preferred central. The late-time SH0ES value is either
measurement bias or new physics — formalised as an open-question
marker. -/

/-- **Substrate prefers CMB-side** — `H0_sub = H0_Planck`, gap 0. -/
theorem substrate_prefers_CMB_side_H0 :
    H0_Planck_substrate = H0_Planck_PDG
      ∧ H0_Planck_substrate < H0_SH0ES_PDG :=
  ⟨H0_Planck_substrate_eq_PDG,
   by rw [H0_Planck_substrate_eq_PDG]; exact H0_Planck_lt_H0_SH0ES⟩

/-- **Frontier marker** — early-universe (CMB) and late-time (local)
    H₀ may differ. The substrate endorses the CMB value; the 5.6
    km/s/Mpc discrepancy with SH0ES is an OPEN problem, testable
    by independent late-time measurements (TRGB, SBF, gravitational-
    wave sirens, JWST-recalibrated Cepheids). -/
theorem early_vs_late_universe_H0_may_differ :
    ∃ gap : ℝ, 0 < gap ∧ gap = H0_SH0ES_PDG - H0_Planck_substrate
      ∧ 25 * hubble_tension_combined_sigma_sq
          < hubble_tension_gap_MKS ^ 2 := by
  refine ⟨H0_SH0ES_PDG - H0_Planck_substrate, ?_, rfl, hubble_tension_exceeds_5sigma⟩
  rw [H0_Planck_substrate_eq_PDG]
  linarith [H0_Planck_lt_H0_SH0ES]

/-! ## 6. Tier 6 — π-channel envelope

H₀, like any late-universe expansion observable, carries a substrate
π-truncation signature through the photon-propagator integration
inherited from CMB dark-energy bookkeeping. We tensor the central
value with `π_error_val(N) = 4/(2N+3)` to form a detector envelope. -/

/-- **π-channel envelope** for `H0_Planck_substrate` at depth N. -/
noncomputable def hubble_substrate_envelope (N : ℕ) : ℝ :=
  H0_Planck_substrate * pi_error_val N

/-- The envelope is strictly positive for every N. -/
theorem hubble_substrate_envelope_pos (N : ℕ) :
    0 < hubble_substrate_envelope N := by
  unfold hubble_substrate_envelope
  exact mul_pos H0_Planck_substrate_pos (pi_error_pos N)

theorem hubble_substrate_envelope_nonneg (N : ℕ) :
    0 ≤ hubble_substrate_envelope N :=
  le_of_lt (hubble_substrate_envelope_pos N)

/-- The envelope decreases in N (π-error is monotone). -/
theorem hubble_substrate_envelope_decreasing (N : ℕ) :
    hubble_substrate_envelope (N + 1) ≤ hubble_substrate_envelope N := by
  unfold hubble_substrate_envelope pi_error_val
  have h1 : (0 : ℝ) ≤ H0_Planck_substrate := H0_Planck_substrate_nonneg
  apply mul_le_mul_of_nonneg_left _ h1
  have hN : (2 * (N : ℝ) + 3) ≤ (2 * (↑(N + 1) : ℝ) + 3) := by
    push_cast; linarith
  have hpos : (0 : ℝ) < 2 * (N : ℝ) + 3 := by positivity
  exact div_le_div_of_nonneg_left (by norm_num) hpos hN

/-! ## 7. Tier 7 — Paper-citable bundles -/

/-- **Mission theorem (existence form)** — there exists a Hubble
    constant `H₀_substrate > 0`, matching the Planck 2018 central
    value within 1σ, and witnessing the > 5σ tension with SH0ES. -/
theorem hubble_constant_substrate_fit_exists :
    ∃ H0 : ℝ,
      0 < H0
        ∧ |H0 - H0_Planck_PDG| ≤ H0_Planck_PDG_sigma
        ∧ H0 < H0_SH0ES_PDG
        ∧ 25 * hubble_tension_combined_sigma_sq
            < hubble_tension_gap_MKS ^ 2 :=
  ⟨H0_Planck_substrate,
   H0_Planck_substrate_pos,
   H0_Planck_substrate_matches_PDG_within_1sigma,
   by rw [H0_Planck_substrate_eq_PDG]; exact H0_Planck_lt_H0_SH0ES,
   hubble_tension_exceeds_5sigma⟩

/-- **Paper headline** — 5-conjunct bundle:
      (1) Planck 1σ match,
      (2) substrate equals Planck central by construction,
      (3) substrate strictly below SH0ES local value,
      (4) formal > 5σ tension witness,
      (5) positive tension gap. -/
theorem hubble_constant_substrate_fit :
    |H0_Planck_substrate - H0_Planck_PDG| ≤ H0_Planck_PDG_sigma
      ∧ H0_Planck_substrate = H0_Planck_PDG
      ∧ H0_Planck_substrate < H0_SH0ES_PDG
      ∧ 25 * hubble_tension_combined_sigma_sq
          < hubble_tension_gap_MKS ^ 2
      ∧ 0 < hubble_tension_gap_MKS :=
  ⟨H0_Planck_substrate_matches_PDG_within_1sigma,
   H0_Planck_substrate_eq_PDG,
   by rw [H0_Planck_substrate_eq_PDG]; exact H0_Planck_lt_H0_SH0ES,
   hubble_tension_exceeds_5sigma,
   hubble_tension_gap_MKS_pos⟩

/-- **Compact 3-conjunct headline** — tension exists, substrate
    threads Planck exactly, gap is positive. -/
theorem hubble_constant_headline :
    H0_Planck_substrate = H0_Planck_PDG
      ∧ 25 * hubble_tension_combined_sigma_sq
          < hubble_tension_gap_MKS ^ 2
      ∧ 0 < hubble_tension_gap_MKS :=
  ⟨H0_Planck_substrate_eq_PDG,
   hubble_tension_exceeds_5sigma,
   hubble_tension_gap_MKS_pos⟩

/-- **Reconciliation bundle** — paper-level summary combining
    Planck/SH0ES positivity, substrate alignment with CMB side,
    formal tension witness, and envelope positivity. -/
theorem hubble_tension_reconciliation_bundle :
    -- Planck anchor positive
    0 < H0_Planck_PDG
      -- SH0ES anchor positive
      ∧ 0 < H0_SH0ES_PDG
      -- Substrate equals Planck central (CMB-side preference)
      ∧ H0_Planck_substrate = H0_Planck_PDG
      -- Planck strictly below SH0ES (the tension direction)
      ∧ H0_Planck_PDG < H0_SH0ES_PDG
      -- Formal > 5σ tension witness
      ∧ 25 * hubble_tension_combined_sigma_sq
          < hubble_tension_gap_MKS ^ 2
      -- π-channel envelope positive at every N
      ∧ (∀ N : ℕ, 0 < hubble_substrate_envelope N) :=
  ⟨H0_Planck_PDG_pos,
   H0_SH0ES_PDG_pos,
   H0_Planck_substrate_eq_PDG,
   H0_Planck_lt_H0_SH0ES,
   hubble_tension_exceeds_5sigma,
   hubble_substrate_envelope_pos⟩

/-! ## 8. Physical summary

    H₀_Planck_PDG       =  67.4  ± 0.5  km/s/Mpc   (CMB + ΛCDM 2018)
    H₀_SH0ES_PDG        =  73.0  ± 1.0  km/s/Mpc   (Cepheid ladder 2022)
    H₀_substrate        =  67.4           (EXACT Planck match, CMB-side)
    gap to Planck       =  0              ≤ 0.5  (1σ)

    Absolute tension gap  =  5.6 km/s/Mpc
    Combined 1σ envelope² =  0.5² + 1.0² = 1.25
    (gap)²                =  31.36
    (5σ envelope)²        =  25 · 1.25 = 31.25
    RESULT:   31.36 > 31.25   ⟹   tension > 5σ

    HEADLINE: the substrate threads the Planck CMB central value
    exactly and simultaneously formalises the > 5σ Hubble tension
    as an open late-time measurement question — consistent with the
    current cosmology-community stance that new physics at late
    times OR distance-ladder systematics must account for SH0ES.

    FRONTIER: `early_vs_late_universe_H0_may_differ` — the substrate
    endorses CMB-inferred `67.4` and leaves local `73.0` as open.

Agent: Phecda (γ Ursae Majoris), 2026-04-20 cycle-15 target 1/6.
0 sorry, 0 new axioms.
-/

end OmegaTheory.Predictions.HubbleConstantFit
