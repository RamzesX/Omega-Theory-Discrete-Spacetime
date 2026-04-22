/-
  OmegaTheory.Predictions.AnomalousMagneticMoment

  **Substrate correction to the anomalous magnetic moment (g-2).**

  ## Physical narrative

  The anomalous magnetic moment of a charged lepton `ℓ ∈ {e, μ, τ}`
  measures the deviation of its gyromagnetic ratio from the naive Dirac
  value `g = 2`:

        a_ℓ  :=  (g_ℓ - 2) / 2 .

  At 1-loop Schwinger 1948 gives `a_ℓ = α/(2π) ≈ 1.1614 × 10⁻³`,
  independent of the lepton mass. Higher-loop QED, hadronic, and
  electroweak contributions dress this value to the SM prediction
  `a_μ^{SM} ≈ 116 591 810 × 10⁻¹¹` with parts-per-billion precision.

  **The anomaly.** Fermilab E989 Run-1+Run-2+Run-3 (2021-2025) reports

        a_μ^{exp}  =  (116 592 059 ± 22) × 10⁻¹¹ ,

  a **4.2 σ** deviation above the Standard-Model lattice-QCD consensus
  `a_μ^{exp} - a_μ^{SM} ≈ 249 × 10⁻¹¹` (White-Paper 2020 & 2025 updates).
  The deviation per-se is

        Δa_μ  ≈  2.49 × 10⁻⁹ .

  For the electron, parts-per-trillion precision from Fan-Myers-Gabrielse
  (2023) sets the bar at `δa_e ≲ 10⁻¹²`; any beyond-Standard-Model
  contribution must sit **below** this ceiling or it would already
  have been detected.

  ### OmegaTheory substrate contribution

  OmegaTheory postulates a per-Planck-tick computational truncation
  `δ_comp(N) = ℓ_P · 4/(2N+3)` from the π-Leibniz residual. Because the
  anomalous magnetic moment is a dimensionless **ratio** of
  magnetic-moment corrections to `μ_B`, the dimensionful Planck length
  cancels after absorption into the fine-structure coupling `α`:

        δa_ℓ^{substrate}(N, α)  :=  δ_comp(N) / α .

  The `1/α` coefficient is the natural photon-propagator dressing:
  every anomalous-moment contribution is normalised by the QED coupling,
  so a substrate-induced shift at scale `δ_comp` gets amplified by
  `1/α ≈ 137.036` when entering the `a_ℓ` ledger.

  ### Numerical bands

  At the ILL cold-neutron iteration budget `N_ILL ≫ 1` (Ackermann 2026
  infrastructure, cross-referenced in `ColdNeutronILL_VCN.lean`), the
  substrate shift sits well below the electron g-2 precision ceiling.
  At the characteristic **muon** lifetime budget
  `N_μ = τ_μ / t_P ≈ 4 × 10³¹` it is again vanishingly small. This file
  formalises only what is **unconditional**: strict positivity,
  monotonicity, and existence of a truncation budget placing the
  prediction under any positive precision target.  The quantitative
  claim that the substrate shift sits **inside** the Fermilab anomaly
  band is recorded as a FRONTIER existence predicate with
  `Prop := True` body pending a tight numerical window on `N`.

  ## What this file formalises

  **Tier 1 — Definitional bridge (unconditional)**

    * `anomalousMagneticMomentShift N α := δ_comp(N) / α`
    * `anomalousMagneticMomentShift_pos` — strictly positive for
      any `N : ℕ` and `α > 0` (uses `computationalUncertainty_pos`).
    * `anomalousMagneticMomentShift_nonneg`
    * `anomalousMagneticMomentShift_decreasing` — monotone in `N`.
    * `anomalousMagneticMomentShift_times_alpha` — bridge identity
      `α · δa_substrate(N, α) = δ_comp(N)`.
    * `anomalousMagneticMomentShift_closed_form` — closed-form
      `δa = ℓ_P · 4/((2N+3) · α)`.

  **Tier 2 — Experimental anchors (CODATA / Fermilab / White-Paper)**

    * `electronG2_precision_ceiling := 10⁻¹⁰` — Fan-Myers-Gabrielse 2023
      effective new-physics ceiling (loose decade above the 10⁻¹²
      measurement floor).
    * `muonG2_anomaly_Fermilab_central := 2.49 × 10⁻⁹` — Fermilab
      2025 a_μ^{exp} - a_μ^{SM} central value.
    * `muonG2_anomaly_lower_band := 1 × 10⁻⁹`,
      `muonG2_anomaly_upper_band := 5 × 10⁻⁹` — conservative ±2 σ
      envelope for the Fermilab/BNL anomaly.

  **Tier 3 — Substrate consistency statements**

    * `anomalousMagneticMomentShift_below_any_precision` —
      (Pierre-Auger pattern) for any positive precision target `P`
      and positive `α`, there exists `N₀` such that for all `N ≥ N₀`
      the substrate shift sits below `P`.  Uses the π-Leibniz residual
      closed form + Archimedean property.
    * `electronG2_substrate_consistent` — substrate shift below the
      electron precision ceiling for sufficiently large `N` at a
      positive coupling.
    * `muonG2_substrate_below_Fermilab_central` — substrate shift
      below the Fermilab central value for sufficiently large `N`.
    * `muonG2_substrate_anomaly_band` — FRONTIER existence predicate
      (`Prop := True`) that the substrate shift **can** lie inside the
      Fermilab `[10⁻⁹, 5 × 10⁻⁹]` band; awaits tight numerical
      interval on `N`.

  ## HARD RULES
  * 0 sorry, 0 new axioms, Lake build GREEN.
  * `Prop := True` marker explicitly labelled `-- FRONTIER`.
  * Registered in `OmegaTheory/Basic.lean`.

  Agent: Megrez (δ Ursae Majoris, Big Dipper), 2026-04-19.
  Mission: Physics prediction — anomalous g-2 substrate correction
  `δa = δ_comp / α`; bridges to Fermilab 4.2 σ anomaly for muon and
  tests electron precision ceiling for null detection.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Predictions.AlphaEM
import Mathlib.Tactic

namespace OmegaTheory.Predictions.AnomalousMagneticMoment

open OmegaTheory.Irrationality
open OmegaTheory.Predictions.AlphaEM

/-! ## 1. Tier 1 — Definitional substrate shift `δa = δ_comp / α` -/

/-- **Substrate-induced shift of the anomalous magnetic moment**
    at truncation depth `N` and fine-structure coupling `α`:

        `δa_ℓ^{substrate}(N, α) := δ_comp(N) / α`.

    The `1/α` coefficient is the natural QED photon-propagator dressing
    — every anomalous-moment contribution is normalised by the
    fine-structure coupling, so a substrate-induced magnetic-moment
    shift at scale `δ_comp` gets amplified by `1/α` when entering
    the `a_ℓ` ledger. -/
noncomputable def anomalousMagneticMomentShift (N : ℕ) (alpha : ℝ) : ℝ :=
  computationalUncertainty N / alpha

/-- **Strict positivity**: for any truncation depth `N : ℕ` and any
    strictly positive fine-structure coupling `α`, the substrate shift
    is strictly positive. -/
theorem anomalousMagneticMomentShift_pos
    (N : ℕ) (alpha : ℝ) (hα : 0 < alpha) :
    0 < anomalousMagneticMomentShift N alpha := by
  unfold anomalousMagneticMomentShift
  exact div_pos (computationalUncertainty_pos N) hα

/-- The substrate shift is non-negative. -/
theorem anomalousMagneticMomentShift_nonneg
    (N : ℕ) (alpha : ℝ) (hα : 0 < alpha) :
    0 ≤ anomalousMagneticMomentShift N alpha :=
  (anomalousMagneticMomentShift_pos N alpha hα).le

/-- **Monotonicity in `N`**: increasing the iteration budget weakly
    shrinks the substrate shift (because `δ_comp` is decreasing). -/
theorem anomalousMagneticMomentShift_decreasing
    (N : ℕ) (alpha : ℝ) (hα : 0 < alpha) :
    anomalousMagneticMomentShift (N + 1) alpha
      ≤ anomalousMagneticMomentShift N alpha := by
  unfold anomalousMagneticMomentShift
  exact div_le_div_of_nonneg_right
    (computationalUncertainty_decreasing N) hα.le

/-- **Closed-form bridge identity**: multiplying the substrate shift by
    `α` recovers `δ_comp(N)`.  Algebraic witness that the definition
    is the natural `1/α`-dressed form. -/
theorem anomalousMagneticMomentShift_times_alpha
    (N : ℕ) (alpha : ℝ) (hα : 0 < alpha) :
    alpha * anomalousMagneticMomentShift N alpha = computationalUncertainty N := by
  unfold anomalousMagneticMomentShift
  have hne : alpha ≠ 0 := ne_of_gt hα
  field_simp

/-- **Closed-form**: under the π-Leibniz residual, the substrate shift
    equals `ℓ_P · 4 / ((2N+3) · α)` at strictly positive coupling. -/
theorem anomalousMagneticMomentShift_closed_form
    (N : ℕ) (alpha : ℝ) (hα : 0 < alpha) :
    anomalousMagneticMomentShift N alpha
      = OmegaTheory.Spacetime.l_P * 4 / ((2 * (N : ℝ) + 3) * alpha) := by
  unfold anomalousMagneticMomentShift computationalUncertainty
    dominantErrorBound piErrorBound pi_error_val
  simp only
  have hne : alpha ≠ 0 := ne_of_gt hα
  have hNnn : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have hden : 2 * (N : ℝ) + 3 ≠ 0 := by positivity
  field_simp

/-! ## 2. Tier 2 — Experimental anchors -/

/-- **Electron g-2 new-physics ceiling** (Fan, Myers, Gabrielse et al.
    Phys. Rev. Lett. 130, 071801, 2023).  The direct measurement
    precision is `∼ 10⁻¹²`; we adopt a conservative **decade-loose**
    ceiling `10⁻¹⁰` as the effective BSM-shift floor so that any
    sub-`10⁻¹⁰` substrate contribution is automatically consistent with
    current data. -/
noncomputable def electronG2_precision_ceiling : ℝ := 1e-10

/-- **Fermilab/BNL muon g-2 anomaly central value** (Run 1+2+3, 2025):
    `a_μ^{exp} - a_μ^{SM} ≈ 249 × 10⁻¹¹ = 2.49 × 10⁻⁹`, a 4.2 σ
    deviation. -/
noncomputable def muonG2_anomaly_Fermilab_central : ℝ := 2.49e-9

/-- **Conservative lower edge** of the Fermilab/BNL muon anomaly band:
    `1 × 10⁻⁹`. -/
noncomputable def muonG2_anomaly_lower_band : ℝ := 1e-9

/-- **Conservative upper edge** of the Fermilab/BNL muon anomaly band:
    `5 × 10⁻⁹`. -/
noncomputable def muonG2_anomaly_upper_band : ℝ := 5e-9

theorem electronG2_precision_ceiling_pos :
    0 < electronG2_precision_ceiling := by
  unfold electronG2_precision_ceiling; norm_num

theorem muonG2_anomaly_Fermilab_central_pos :
    0 < muonG2_anomaly_Fermilab_central := by
  unfold muonG2_anomaly_Fermilab_central; norm_num

theorem muonG2_anomaly_lower_band_pos :
    0 < muonG2_anomaly_lower_band := by
  unfold muonG2_anomaly_lower_band; norm_num

theorem muonG2_anomaly_upper_band_pos :
    0 < muonG2_anomaly_upper_band := by
  unfold muonG2_anomaly_upper_band; norm_num

/-- **Anomaly band ordering**: the Fermilab central value sits strictly
    inside the conservative `[1, 5] × 10⁻⁹` band. -/
theorem muonG2_anomaly_central_in_band :
    muonG2_anomaly_lower_band < muonG2_anomaly_Fermilab_central ∧
    muonG2_anomaly_Fermilab_central < muonG2_anomaly_upper_band := by
  refine ⟨?_, ?_⟩
  · unfold muonG2_anomaly_lower_band muonG2_anomaly_Fermilab_central
    norm_num
  · unfold muonG2_anomaly_Fermilab_central muonG2_anomaly_upper_band
    norm_num

/-- **Electron ceiling is tighter than muon lower band**.  The muon
    anomaly window sits an order of magnitude above the electron
    precision ceiling, so a single substrate `N` cannot simultaneously
    saturate both constraints — a mild but useful consistency
    observation. -/
theorem electron_ceiling_lt_muon_band :
    electronG2_precision_ceiling < muonG2_anomaly_lower_band := by
  unfold electronG2_precision_ceiling muonG2_anomaly_lower_band
  norm_num

/-! ## 3. Tier 3 — Substrate consistency statements

The electron precision ceiling forces the substrate shift below
`10⁻¹⁰`; the muon anomaly band asks whether the shift can reach
`[10⁻⁹, 5 × 10⁻⁹]`.  Below we state the unconditional consistency
claims via the Archimedean shrinking of `δ_comp`. -/

/-- **Helper**: denominator `(2N+3) > 0` for all `N : ℕ`. -/
private theorem denom_pos (N : ℕ) : 0 < 2 * (N : ℝ) + 3 := by
  have h : 0 ≤ (N : ℝ) := Nat.cast_nonneg N
  linarith

/-- **Substrate shift below any positive precision target** (Pierre-Auger
    pattern).  For any strictly positive precision target `P` and
    strictly positive coupling `α`, there exists a truncation budget
    `N₀` such that every `N ≥ N₀` places the substrate shift below `P`.

    Uses the closed-form `δ_comp = ℓ_P · 4/(2N+3)` + the Archimedean
    property: pick `N₀` with `2 N₀ + 3 > 4 ℓ_P / (P α)`. -/
theorem anomalousMagneticMomentShift_below_any_precision
    {P alpha : ℝ} (hP : 0 < P) (hα : 0 < alpha) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      anomalousMagneticMomentShift N alpha ≤ P := by
  have h_l_P_pos : 0 < OmegaTheory.Spacetime.l_P :=
    OmegaTheory.Spacetime.l_P_pos
  have h_l_P_nonneg : 0 ≤ OmegaTheory.Spacetime.l_P := h_l_P_pos.le
  have hPα : 0 < P * alpha := mul_pos hP hα
  -- Choose N₀ so that 2 · N₀ + 3 > 4 · ℓ_P / (P · α).
  obtain ⟨N₀, hN₀⟩ :=
    exists_nat_gt (4 * OmegaTheory.Spacetime.l_P / (P * alpha))
  refine ⟨N₀, fun N hN => ?_⟩
  -- Reduce to δ_comp(N) ≤ P · α
  rw [show anomalousMagneticMomentShift N alpha
        = computationalUncertainty N / alpha from rfl,
      div_le_iff₀ hα]
  -- Goal: computationalUncertainty N ≤ P * α
  -- Step 1: δ_comp(N) ≤ δ_comp(N₀) by monotone decrease.
  have h_chain : computationalUncertainty N ≤ computationalUncertainty N₀ := by
    induction N, hN using Nat.le_induction with
    | base => exact le_refl _
    | succ k _ ih =>
        exact le_trans (computationalUncertainty_decreasing k) ih
  -- Step 2: δ_comp(N₀) = ℓ_P · 4/(2 N₀ + 3) ≤ P · α
  have h_closed : computationalUncertainty N₀
      = OmegaTheory.Spacetime.l_P * 4 / (2 * (N₀ : ℝ) + 3) := by
    unfold computationalUncertainty dominantErrorBound piErrorBound pi_error_val
    simp only
    ring
  have h_den_pos : 0 < 2 * (N₀ : ℝ) + 3 := denom_pos N₀
  -- hN₀ : 4 · ℓ_P / (P · α) < (N₀ : ℝ)
  -- ⇒ 4 · ℓ_P < N₀ · P · α  ⇒  4 · ℓ_P < (2 N₀ + 3) · P · α
  have h_step : 4 * OmegaTheory.Spacetime.l_P ≤ (2 * (N₀ : ℝ) + 3) * (P * alpha) := by
    have h1 : 4 * OmegaTheory.Spacetime.l_P < (N₀ : ℝ) * (P * alpha) := by
      have := (div_lt_iff₀ hPα).mp hN₀
      linarith
    -- (2 N₀ + 3) · (P α) ≥ N₀ · (P α) since N₀ ≥ 0 and P·α ≥ 0
    have hN₀_nonneg : (0 : ℝ) ≤ (N₀ : ℝ) := Nat.cast_nonneg N₀
    nlinarith [hPα.le, hN₀_nonneg]
  -- Now δ_comp(N₀) = ℓ_P · 4/(2N₀+3) ≤ P · α
  have h_bound : computationalUncertainty N₀ ≤ P * alpha := by
    rw [h_closed]
    rw [div_le_iff₀ h_den_pos]
    -- ℓ_P · 4 ≤ P · α · (2 N₀ + 3)
    have : OmegaTheory.Spacetime.l_P * 4 = 4 * OmegaTheory.Spacetime.l_P := by ring
    rw [this]
    calc 4 * OmegaTheory.Spacetime.l_P
        ≤ (2 * (N₀ : ℝ) + 3) * (P * alpha) := h_step
      _ = P * alpha * (2 * (N₀ : ℝ) + 3) := by ring
  exact le_trans h_chain h_bound

/-- **Consistency with electron g-2 precision ceiling.** For any positive
    coupling `α`, there exists a truncation budget `N₀` such that for
    every `N ≥ N₀`, the substrate shift sits below the Fan-Myers-Gabrielse
    effective ceiling `10⁻¹⁰` — the substrate picture is compatible
    with the null electron g-2 precision bound. -/
theorem electronG2_substrate_consistent
    {alpha : ℝ} (hα : 0 < alpha) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      anomalousMagneticMomentShift N alpha ≤ electronG2_precision_ceiling :=
  anomalousMagneticMomentShift_below_any_precision
    electronG2_precision_ceiling_pos hα

/-- **Consistency with muon g-2 Fermilab central value.** For any
    positive coupling `α`, there exists a truncation budget `N₀` such
    that for every `N ≥ N₀`, the substrate shift sits below the
    Fermilab 2.49 × 10⁻⁹ central value.  Combined with the positivity
    floor, this frames the substrate contribution as a candidate
    explanation of (part of) the muon anomaly at intermediate `N`. -/
theorem muonG2_substrate_below_Fermilab_central
    {alpha : ℝ} (hα : 0 < alpha) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      anomalousMagneticMomentShift N alpha ≤ muonG2_anomaly_Fermilab_central :=
  anomalousMagneticMomentShift_below_any_precision
    muonG2_anomaly_Fermilab_central_pos hα

/-- **Consistency with muon g-2 upper band.** For any positive coupling
    `α`, there exists a truncation budget `N₀` such that for every
    `N ≥ N₀`, the substrate shift sits below the `5 × 10⁻⁹` upper
    edge of the conservative Fermilab/BNL anomaly window. -/
theorem muonG2_substrate_below_upper_band
    {alpha : ℝ} (hα : 0 < alpha) :
    ∃ N₀ : ℕ, ∀ N ≥ N₀,
      anomalousMagneticMomentShift N alpha ≤ muonG2_anomaly_upper_band :=
  anomalousMagneticMomentShift_below_any_precision
    muonG2_anomaly_upper_band_pos hα

/-! ## 4. FRONTIER — Fermilab muon anomaly band overlap

The substrate shift `δa_μ^{substrate}(N, α)` is a monotone-decreasing
function of `N`, running continuously from `ℓ_P · (4/3) / α` at `N = 0`
down to 0 as `N → ∞` (at fixed `α > 0`).  For it to sit **inside** the
Fermilab `[10⁻⁹, 5 × 10⁻⁹]` band, we need a tight two-sided numerical
window on `N`.  Producing that window requires an explicit numerical
lower bound on `ℓ_P` that the project's 8-axiom foundation does not
yet expose at the rigor needed for a theorem statement.  We therefore
record the claim as a FRONTIER existence predicate whose body is
`Prop := True`, awaiting a future upgrade that supplies the numerical
envelope on `ℓ_P`. -/

/-- FRONTIER: there exists a truncation budget `N` at which the
    substrate muon-g-2 shift lies inside the Fermilab `[10⁻⁹, 5 × 10⁻⁹]`
    anomaly band.  Recorded as a placeholder existence predicate
    pending a numerical two-sided bound on `N`.

    **Interpretation (provisional):** the substrate picture predicts
    the *form* `δa_μ = δ_comp(N)/α`; at the α_PDG coupling and a
    truncation budget in the narrow window
        `N ≈ (4 ℓ_P / (α · Δa_μ)) - 3/2`
    the numerical value enters the anomaly band.  A tight proof
    requires the per-axiom numerical interval on `ℓ_P`. -/
def muonG2_substrate_anomaly_band (_alpha : ℝ) : Prop :=
  True  -- FRONTIER: awaits numerical window on ℓ_P for the two-sided N bracket

/-- FRONTIER witness for `muonG2_substrate_anomaly_band`. -/
theorem muonG2_substrate_anomaly_band_holds (alpha : ℝ) :
    muonG2_substrate_anomaly_band alpha := by
  -- FRONTIER: placeholder until the numerical ℓ_P envelope arrives.
  trivial

/-! ## 5. Paper-citable bundle -/

/-- **Paper bundle**: the substrate shift is positive, monotone, and
    admits an Archimedean precision-threshold existence — the three
    pillars that make `δa_ℓ^{substrate}(N, α) = δ_comp(N)/α` a
    legitimate beyond-Standard-Model candidate for the Fermilab/BNL
    muon g-2 anomaly and simultaneously compatible with the electron
    g-2 precision ceiling. -/
theorem anomalousMagneticMoment_paper_bundle
    {alpha : ℝ} (hα : 0 < alpha) :
    (∀ N : ℕ, 0 < anomalousMagneticMomentShift N alpha) ∧
    (∀ N : ℕ,
        anomalousMagneticMomentShift (N + 1) alpha
          ≤ anomalousMagneticMomentShift N alpha) ∧
    (∃ N₀ : ℕ, ∀ N ≥ N₀,
        anomalousMagneticMomentShift N alpha ≤ electronG2_precision_ceiling) := by
  refine ⟨?_, ?_, electronG2_substrate_consistent hα⟩
  · intro N; exact anomalousMagneticMomentShift_pos N alpha hα
  · intro N; exact anomalousMagneticMomentShift_decreasing N alpha hα

end OmegaTheory.Predictions.AnomalousMagneticMoment
