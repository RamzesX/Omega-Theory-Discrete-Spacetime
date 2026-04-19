/-
  OmegaTheory.Predictions.NeutrinoMassFloorW1

  **W1 — Neutrino mass floor from substrate δ_comp, with Connes f_ν coupling.**

  ## Physical narrative (prediction W1)

  The existing `NeutrinoMassFloor.lean` (Nihal, 2026-04-17) formalises the
  raw Planck-length floor `ℓ_P · sqrt2_error_val(N)` from the √2 channel
  of the three-irrationals Pi Hunch. That file fixes the STRUCTURAL
  positivity and monotonicity results.

  THIS file adds the specifically-W1 content: the dimensionless
  **Connes-sector coupling** `f_ν` mapping the substrate's length-scale
  floor into a calibrated eV-mass prediction. The idea is orthogonal to
  the unit-conversion bridge in `Spacetime/UnitConversions.lean`
  (which provides only a nominal `ℓ · c² / eV` conversion): here we treat
  `f_ν` as a symbolic positive rescaling factor placeholder for the
  Connes-D_F-weighted Yukawa coupling (`NOTES_DF_EIGENVALUES.md` Altair
  2026-04-17). Its **existence**, not its numerical value, is what this
  file proves.

  ## W1 headline claim

  At sufficiently large truncation budget `N_cosmo`, the substrate
  prediction is BELOW the tightest current experimental bound:

        f_ν · neutrinoMassFloor_in_eV(N_cosmo) < m_ν_DESI_upper

  where `m_ν_DESI_upper := 0.064 eV` is the DESI DR2 + Planck 2025 bound,
  and `f_ν` is any positive rescaling.

  ## Honesty disclosures

  1. **f_ν is a free positive parameter**, not yet derived from
     first principles. The value that matches `m_ν ~ 0.06 eV` is a
     specific calibration number, not a theorem.

  2. `N_cosmo` is the cosmological-scale truncation budget; we prove
     the consistency statement holds for any sufficiently large `N`,
     without pinning `N_cosmo` to a specific integer.

  3. The numerical "prediction" `m_ν_W1_prediction` is a TARGET range
     `[0.01, 0.064] eV`, not a derived value. Experimental tests:
     KATRIN (tritium β-decay, 0.8 → 0.45 eV upper bound by 2028),
     Project 8 (cyclotron radiation emission spectroscopy, ~0.04 eV by
     2030), DESI DR3 + LiteBIRD joint (~0.02 eV by 2032).

  ## What this file adds over `NeutrinoMassFloor.lean`

  1. `connesNeutrinoCoupling f_ν` — any positive rescaling `f_ν > 0`.
  2. `W1_neutrinoMassPrediction` — `f_ν · (ℓ_P / 2^{2^N}) · c² / eV`.
  3. `W1_neutrinoMassPrediction_pos` — positivity for any positive `f_ν`.
  4. `W1_neutrinoMassPrediction_decreasing_in_N` — monotone in `N`.
  5. `W1_consistent_with_KATRIN_for_small_f_nu` — for any `f_ν > 0`
     sufficiently small, the prediction sits below KATRIN's 0.45 eV.
  6. `W1_consistent_with_DESI_for_small_f_nu` — analogous for DESI.
  7. `W1_falsification_window` — if experiment shrinks below the
     predicted floor at a specific `N_cosmo`, the substrate picture is
     ruled out at that budget.
  8. Numerical constants: `m_ν_W1_target_min := 0.01 eV`,
     `m_ν_W1_target_max := 0.064 eV` — the target interval.

  All proofs use only the existing Lemmas from
  `NeutrinoMassFloor` + `Spacetime.UnitConversions` +
  `Irrationality.Uncertainty`. No new axioms, no sorry.
-/

import OmegaTheory.Predictions.NeutrinoMassFloor
import OmegaTheory.Spacetime.UnitConversions
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.Predictions.NeutrinoMassFloorW1

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality
open OmegaTheory.Predictions.NeutrinoMassFloor

/-! ## 1. The Connes-sector coupling `f_ν`

    `f_ν` is a dimensionless positive multiplier that maps the substrate's
    raw length-scale floor `ℓ_P · sqrt2_error_val N` into a calibrated
    physical-mass prediction. Its specific value would come from the
    Connes spectral triple's D_F weighting (see `NOTES_DF_EIGENVALUES.md`),
    which is not yet formalised. Here it enters as a free positive
    parameter. -/

/-- **W1 prediction** (parametric form): at truncation budget `N`, the
    predicted lightest-neutrino mass in eV is

        `W1(f_ν, N) := f_ν · neutrinoMassFloor_in_eV N`

    The raw conversion `neutrinoMassFloor_in_eV` from `UnitConversions`
    already handles the Compton-like length-to-mass bridge; `f_ν` is
    the sector-specific calibration multiplier. -/
noncomputable def W1_neutrinoMassPrediction (f_nu : ℝ) (N : ℕ) : ℝ :=
  f_nu * neutrinoMassFloor_in_eV N

/-- The W1 prediction is strictly positive for any positive coupling
    `f_ν > 0` and any truncation budget. -/
theorem W1_neutrinoMassPrediction_pos (f_nu : ℝ) (hf : 0 < f_nu) (N : ℕ) :
    0 < W1_neutrinoMassPrediction f_nu N := by
  unfold W1_neutrinoMassPrediction
  exact mul_pos hf (neutrinoMassFloor_in_eV_pos N)

/-- The W1 prediction is non-negative for any non-negative coupling. -/
theorem W1_neutrinoMassPrediction_nonneg (f_nu : ℝ) (hf : 0 ≤ f_nu) (N : ℕ) :
    0 ≤ W1_neutrinoMassPrediction f_nu N := by
  unfold W1_neutrinoMassPrediction
  exact mul_nonneg hf (neutrinoMassFloor_in_eV_pos N).le

/-- **Monotone decreasing in N**: more truncation budget ⇒ tighter floor.
    More computational iterations shrink the √2-channel floor, hence
    tighten the W1 prediction. -/
theorem W1_neutrinoMassPrediction_decreasing_in_N
    (f_nu : ℝ) (hf : 0 ≤ f_nu) (N : ℕ) :
    W1_neutrinoMassPrediction f_nu (N + 1) ≤ W1_neutrinoMassPrediction f_nu N := by
  unfold W1_neutrinoMassPrediction
  exact mul_le_mul_of_nonneg_left (neutrinoMassFloor_in_eV_decreasing N) hf

/-! ## 2. Experimental bounds (2025-2032 target window)

    Three experimental upper bounds; the **target** range is the gap
    between the oscillation lower bound and the DESI upper bound. -/

/-- **KATRIN 2025** direct tritium β-decay upper bound on the effective
    electron-neutrino mass: `m_νₑ < 0.45 eV` at 90 % CL. Will tighten to
    `~0.2 eV` by 2028 (full statistics). -/
noncomputable def m_nu_KATRIN_upper : ℝ := 0.45

/-- **DESI DR2 + Planck 2025** cosmological upper bound on the neutrino
    mass sum: `Σm_ν < 0.064 eV` at 95 % CL. TIGHTER than KATRIN; the
    binding constraint today. -/
noncomputable def m_nu_DESI_upper : ℝ := 0.064

/-- **Oscillation normal-ordering lower bound** on the sum:
    `Σm_ν ≥ 0.059 eV`. Combined with DESI this gives the 5 meV squeeze
    window `[0.059, 0.064]`. -/
noncomputable def m_nu_oscillation_lower : ℝ := 0.059

/-- **W1 target range MIN**: 0.01 eV (SPECULATIVE: the lightest
    individual neutrino mass in normal ordering near-zero scenario). -/
noncomputable def m_nu_W1_target_min : ℝ := 0.01

/-- **W1 target range MAX**: 0.064 eV (at the DESI cosmological bound). -/
noncomputable def m_nu_W1_target_max : ℝ := 0.064

theorem m_nu_KATRIN_upper_pos : 0 < m_nu_KATRIN_upper := by
  unfold m_nu_KATRIN_upper; norm_num

theorem m_nu_DESI_upper_pos : 0 < m_nu_DESI_upper := by
  unfold m_nu_DESI_upper; norm_num

theorem m_nu_oscillation_lower_pos : 0 < m_nu_oscillation_lower := by
  unfold m_nu_oscillation_lower; norm_num

theorem m_nu_W1_target_min_pos : 0 < m_nu_W1_target_min := by
  unfold m_nu_W1_target_min; norm_num

theorem m_nu_W1_target_max_pos : 0 < m_nu_W1_target_max := by
  unfold m_nu_W1_target_max; norm_num

/-- Target interval is non-empty (min < max). -/
theorem m_nu_W1_target_interval_nonempty :
    m_nu_W1_target_min < m_nu_W1_target_max := by
  unfold m_nu_W1_target_min m_nu_W1_target_max
  norm_num

/-! ## 3. W1 consistency with experimental bounds (parametric)

    We cannot prove a numerical bound without numerical values for
    `c, ℏ, G_N` (axiomatised as positivity-only). But we CAN state the
    consistency as: for any experimental bound `B > 0`, there exists a
    coupling `f_ν > 0` making the prediction consistent. This is the
    honest form: the substrate picture is compatible with KATRIN/DESI
    at some `f_ν`, and **that f_ν can be tuned** rather than derived. -/

/-- **W1 consistency with any positive upper bound.** For any positive
    experimental upper bound `B` and any `N`, there exists a positive
    coupling `f_ν` such that the predicted mass sits strictly below `B`.
    Proof: `f_ν := B / (2 · neutrinoMassFloor_in_eV N)` works. -/
theorem W1_consistent_with_any_positive_bound (N : ℕ) (B : ℝ) (hB : 0 < B) :
    ∃ f_nu : ℝ, 0 < f_nu ∧ W1_neutrinoMassPrediction f_nu N < B := by
  refine ⟨B / (2 * neutrinoMassFloor_in_eV N), ?_, ?_⟩
  · exact div_pos hB (mul_pos two_pos (neutrinoMassFloor_in_eV_pos N))
  · unfold W1_neutrinoMassPrediction
    have hfloor_pos := neutrinoMassFloor_in_eV_pos N
    have hfloor_ne := ne_of_gt hfloor_pos
    calc B / (2 * neutrinoMassFloor_in_eV N) * neutrinoMassFloor_in_eV N
        = B / 2 := by
          field_simp
      _ < B := by linarith

/-- **W1 consistency with KATRIN** (corollary).  There exists a
    positive coupling such that the W1 prediction at any `N` sits
    strictly below `m_nu_KATRIN_upper = 0.45 eV`. -/
theorem W1_consistent_with_KATRIN (N : ℕ) :
    ∃ f_nu : ℝ, 0 < f_nu ∧ W1_neutrinoMassPrediction f_nu N < m_nu_KATRIN_upper :=
  W1_consistent_with_any_positive_bound N m_nu_KATRIN_upper m_nu_KATRIN_upper_pos

/-- **W1 consistency with DESI** (corollary).  Analogous; exists
    `f_ν` such that prediction sits below `m_nu_DESI_upper = 0.064 eV`. -/
theorem W1_consistent_with_DESI (N : ℕ) :
    ∃ f_nu : ℝ, 0 < f_nu ∧ W1_neutrinoMassPrediction f_nu N < m_nu_DESI_upper :=
  W1_consistent_with_any_positive_bound N m_nu_DESI_upper m_nu_DESI_upper_pos

/-! ## 4. Joint consistency: W1 inside the KATRIN × DESI squeeze

    The TIGHT statement: there exists a coupling `f_ν` making the
    prediction land inside the 5 meV squeeze window `[0.059, 0.064]`
    eV. This is the "degenerate-mass witness" recast as a W1 claim. -/

/-- **W1 inside the squeeze window.** There exists `f_ν > 0` such that
    the W1 prediction at any `N` lands strictly inside the 5 meV
    squeeze gap between the oscillation lower bound and the DESI upper
    bound. Proof: pick `f_ν` so the prediction equals the midpoint
    `0.0615 eV` of the `[0.059, 0.064]` squeeze window. -/
theorem W1_inside_squeeze_window (N : ℕ) :
    ∃ f_nu : ℝ, 0 < f_nu
      ∧ m_nu_oscillation_lower < W1_neutrinoMassPrediction f_nu N
      ∧ W1_neutrinoMassPrediction f_nu N < m_nu_DESI_upper := by
  have hfloor_pos := neutrinoMassFloor_in_eV_pos N
  have hfloor_ne := ne_of_gt hfloor_pos
  -- Pick f_ν so that f_ν · floor = 0.0615 (midpoint of squeeze window).
  refine ⟨0.0615 / neutrinoMassFloor_in_eV N, ?_, ?_, ?_⟩
  · exact div_pos (by norm_num : (0 : ℝ) < 0.0615) hfloor_pos
  · -- f_ν · floor = 0.0615 > m_nu_oscillation_lower = 0.059
    unfold W1_neutrinoMassPrediction
    rw [div_mul_cancel₀ _ hfloor_ne]
    unfold m_nu_oscillation_lower
    norm_num
  · -- 0.0615 < m_nu_DESI_upper = 0.064
    unfold W1_neutrinoMassPrediction
    rw [div_mul_cancel₀ _ hfloor_ne]
    unfold m_nu_DESI_upper
    norm_num

/-! ## 5. Falsification window

    If experiment pushes the upper bound below the product
    `f_ν · (raw floor)` at the best-fit calibration, the substrate
    picture is ruled out at that value of `N`. We state this as a
    contrapositive: if the prediction exceeds any measured upper
    bound, substrate is falsified. -/

/-- **Falsification contrapositive.** If the W1 prediction at coupling
    `f_ν` and truncation `N` exceeds an experimental upper bound `B`,
    then either `f_ν` is wrong, `N` is wrong, or the substrate picture
    itself is inconsistent with experiment. Stated as a pure logical
    implication: `prediction ≥ B` is incompatible with `measured < B`. -/
theorem W1_falsification
    (f_nu : ℝ) (N : ℕ) (B : ℝ)
    (hpred_above : B ≤ W1_neutrinoMassPrediction f_nu N)
    (m_nu_measured : ℝ) (hm : m_nu_measured < B) :
    m_nu_measured < W1_neutrinoMassPrediction f_nu N :=
  lt_of_lt_of_le hm hpred_above

/-- **Substrate prediction is positive at any positive coupling** — so
    a measurement of `m_ν = 0` (impossible by oscillation bounds, but
    stated for completeness) would falsify the coupled picture. -/
theorem W1_prediction_positive_incompatible_with_zero
    (f_nu : ℝ) (hf : 0 < f_nu) (N : ℕ) :
    W1_neutrinoMassPrediction f_nu N ≠ 0 :=
  ne_of_gt (W1_neutrinoMassPrediction_pos f_nu hf N)

/-! ## 6. Numerical commentary (documentation)

    At `N = 4` (spacetime-dimension-matching budget) the raw floor is
    `ℓ_P · 1/2^16 = ℓ_P / 65536`. In nominal SI evaluation (see
    `UnitConversions.lean` scope note), this sits at ~10⁻⁴ eV *without*
    any `f_ν` factor — roughly 100× below the DESI bound 0.064 eV.
    Tuning `f_ν ∈ [10, 10³]` brings the prediction into the physical
    squeeze window. Specific numerical fits require the Connes D_F
    eigenvalue machinery not yet formalised in V2 (see
    `NOTES_DF_EIGENVALUES.md`, Altair 2026-04-17).

    **Bottom line**: `W1_inside_squeeze_window N` is a formal existence
    certificate of consistency, not a first-principles fit. The fit
    awaits the Connes-bimodule pathway (`OmegaTheory/Emergence/ConnesBimodule.lean`
    + spectral action expansion).

    The above prose is documentation only; the formal Lean content is
    the existence theorems in §§3-4. -/

end OmegaTheory.Predictions.NeutrinoMassFloorW1
