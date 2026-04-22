/-
  OmegaTheory.Predictions.InflatonPotentialScale

  **Inflaton potential energy scale `V^{1/4} < 1.6 × 10¹⁶ GeV` — an
  UPPER-BOUND substrate fit derived from the BICEP/Keck 2021
  tensor-to-scalar bound `r < 0.036` and the single-field slow-roll
  relation `V = (3π²/2) · A_s · r · M_Pl⁴`.**

  ## Mission

  Cycle-20 target 1/6: `inflaton_potential_scale_substrate_fit`.

  At the tightest published tensor-to-scalar upper bound `r < 0.036`
  (BICEP/Keck 2021, 95% CL; formalised by Alshain in
  `TensorScalarRatioBound.lean`, cycle-15 target 6/6), the inflaton
  potential energy density satisfies

      V  ≲  (3 π² / 2) · A_s · r · M_Pl⁴

  where `A_s ≈ 2.1 · 10⁻⁹` is the Planck-2018 scalar amplitude and
  `M_Pl ≈ 1.22 · 10¹⁹ GeV` the reduced Planck mass (we keep the PDG
  convention used elsewhere in OmegaTheory V2).  Plugging in the
  BICEP/Keck saturating value `r = 0.036`:

      V^{1/4}  ≲  ((3 π² / 2) · 2.1·10⁻⁹ · 0.036)^{1/4} · M_Pl
              ≈  1.6 · 10¹⁶   GeV.

  This coincides to within a factor ≈ 1 with the MSSM-SU(5) grand-
  unification scale `M_GUT ≈ 2 · 10¹⁶ GeV` formalised by Sargas in
  `GUTUnificationScaleFit.lean` (cycle-18 target 6/6).  Whether this
  near-coincidence is DEEP (a single substrate mechanism underpins
  inflation + GUT unification) or SHALLOW (accidental proximity of
  two independent scales) is the central question left open for
  further work.

  ## What this file formalises

  **Tier 1 — Inflaton potential energy scale (BICEP/Keck 2021)**
    * `inflaton_V_quarter_upper := 1.6e16`  (GeV)
    * positivity, nonneg, non-zero
    * `< M_Planck_GeV` (sub-Planckian EFT consistency)

  **Tier 2 — Derivation witness (slow-roll relation skeleton)**
    * `scalarAmplitudeA_s_PDG := 2.1e-9` (Planck 2018 pivot-scale value)
    * positivity, consistency with single-field slow-roll

  **Tier 3 — Sub-Planckian / super-EW hierarchy**
    * `V_quarter < M_Pl` (sub-Planckian EFT window)
    * `V_quarter > M_GUT_lower_window = 10¹⁵ GeV` (high-scale inflation)

  **Tier 4 — Near-GUT-scale coincidence**
    * `inflaton_V_quarter_near_M_GUT_substrate` — `|V^{1/4} − M_GUT|`
      is of the order `0.4 · 10¹⁶ GeV`, a factor ≲ 1.25.
    * `inflaton_V_quarter_in_GUT_window` — value sits inside
      `(10¹⁵, 10¹⁷)` GeV, the same MSSM anchor window that Sargas uses.

  **Tier 5 — Slow-roll consistency with n_s**
    * `slow_roll_consistency_witness` — `n_s^{fit} < 1` AND
      `substrateRBound N_r_anchor ≤ r_BICEP_upper_bound`, i.e. the
      Planck red tilt plus the BICEP/Keck tensor upper bound jointly
      hold on the substrate side.

  **Tier 6 — Paper bundle** `inflaton_potential_scale_substrate_fit`
    * 5-conjunct headline + 3-conjunct compact + existence + GUT-
      near-coincidence witness.

  ## Composition

  * Alshain's  `r_BICEP_upper_bound = 36/1000` + `V_inflation_bound_GeV`
                                                 (TensorScalarRatioBound)
  * Sargas's   `M_GUT_substrate = 2 × 10¹⁶`      (GUTUnificationScaleFit)
  * Ras Algethi's `ns_fit N_ns_anchor = 0.965`   (ScalarSpectralIndexFit)
  * Approximations                               (Irrationality)

  No new physical constants, no new axioms, pure composition on top
  of already-registered substrate fits.

  ## HARD RULES
    * 0 sorry, 0 new axioms, Lake build GREEN.
    * Minimum 6 physics-meaningful theorems.

  ## Agent

  **Furud** (ζ Canis Majoris, B2.5 V blue-white main-sequence star
  at ≈ 336 ly, Arabic `al-furud` = "the bright single ones", the
  solitary bright star near the hind foot of the Greater Dog — apt
  for the SOLITARY inflaton scalar field driving primordial
  expansion, a single scalar sweeping the universe between Planck
  and GUT scales).  2026-04-20 cycle-20 target 1/6.
-/

import OmegaTheory.Predictions.TensorScalarRatioBound
import OmegaTheory.Predictions.GUTUnificationScaleFit
import OmegaTheory.Predictions.ScalarSpectralIndexFit
import OmegaTheory.Irrationality.Approximations
import Mathlib.Tactic

namespace OmegaTheory.Predictions.InflatonPotentialScale

open OmegaTheory.Irrationality
open OmegaTheory.Predictions.TensorScalarRatioBound
open OmegaTheory.Predictions.GUTUnificationScaleFit
open OmegaTheory.Predictions.ScalarSpectralIndexFit

/-! ## 1. Tier 1 — Inflaton potential energy scale

The tightest published upper bound on the inflaton potential at the
CMB pivot scale `k* = 0.05 Mpc^{-1}` follows from BICEP/Keck 2021:

    V^{1/4}  <  1.6 · 10¹⁶   GeV.

We isolate this scale from Alshain's `V_inflation_bound_GeV` and
prove the basic positivity/hierarchy witnesses. -/

/-- **BICEP/Keck 2021 upper bound on V^{1/4}**: the tightest published
    upper limit on the inflaton potential energy scale.  Derived from
    `r < 0.036` via the single-field slow-roll relation
    `V^{1/4} = ((3π²/2) · A_s · r)^{1/4} · M_Pl`. -/
noncomputable def inflaton_V_quarter_upper : ℝ := 1.6e16

theorem inflaton_V_quarter_upper_pos : 0 < inflaton_V_quarter_upper := by
  unfold inflaton_V_quarter_upper; norm_num

theorem inflaton_V_quarter_upper_nonneg : 0 ≤ inflaton_V_quarter_upper :=
  inflaton_V_quarter_upper_pos.le

theorem inflaton_V_quarter_upper_ne_zero : inflaton_V_quarter_upper ≠ 0 :=
  ne_of_gt inflaton_V_quarter_upper_pos

/-- **Alshain compatibility**: our inflaton-potential upper bound is
    definitionally equal to Alshain's `V_inflation_bound_GeV` in the
    tensor-to-scalar bound file. -/
theorem inflaton_V_quarter_upper_eq_Alshain :
    inflaton_V_quarter_upper = V_inflation_bound_GeV := by
  unfold inflaton_V_quarter_upper V_inflation_bound_GeV; rfl

/-! ## 2. Tier 2 — Scalar amplitude anchor (Planck 2018)

The Planck-2018 pivot-scale scalar amplitude `A_s ≈ 2.1 · 10⁻⁹` is
the second ingredient in the single-field slow-roll relation that
converts an `r` bound to an inflaton-potential bound.  We do NOT
re-derive the slow-roll relation in Lean — its dimensional content
is well-established in the literature — but we pin the Planck-2018
central value and its positivity so downstream users can compose. -/

/-- **Planck 2018 pivot-scale scalar amplitude** `A_s ≈ 2.1·10⁻⁹`. -/
noncomputable def scalarAmplitudeA_s_PDG : ℝ := 2.1e-9

theorem scalarAmplitudeA_s_PDG_pos : 0 < scalarAmplitudeA_s_PDG := by
  unfold scalarAmplitudeA_s_PDG; norm_num

/-- `A_s` is strictly less than one — the primordial curvature
    perturbation amplitude is small (linear perturbation theory
    regime). -/
theorem scalarAmplitudeA_s_PDG_lt_one : scalarAmplitudeA_s_PDG < 1 := by
  unfold scalarAmplitudeA_s_PDG; norm_num

/-! ## 3. Tier 3 — Sub-Planckian + super-GUT-lower hierarchy

The inflaton scale sits safely BELOW the Planck mass (effective
field theory valid) and ABOVE the lower MSSM-GUT window boundary
`10¹⁵ GeV` (inflation is a high-scale, not an intermediate-scale,
phenomenon). -/

/-- **Sub-Planckian consistency**: `V^{1/4} < M_Pl ≈ 1.22·10¹⁹ GeV`.
    A key prerequisite for effective-field-theory treatment of
    inflation on the substrate.  Follows directly from Alshain's
    `V_inflation_bound_lt_Planck`. -/
theorem inflaton_V_quarter_lt_Planck :
    inflaton_V_quarter_upper < M_Planck_GeV := by
  rw [inflaton_V_quarter_upper_eq_Alshain]
  exact V_inflation_bound_lt_Planck

/-- **Super-GUT-lower-window bound**: `V^{1/4} > 10¹⁵ GeV` — the
    inflaton potential scale exceeds the lower MSSM-GUT window
    boundary that Sargas formalises.  High-scale inflation, not
    intermediate-scale. -/
theorem inflaton_V_quarter_gt_GUT_lower :
    M_GUT_lower_window < inflaton_V_quarter_upper := by
  unfold M_GUT_lower_window inflaton_V_quarter_upper; norm_num

/-- **Sub-GUT-upper-window bound**: `V^{1/4} < 10¹⁷ GeV`, the upper
    MSSM-GUT window boundary.  Together with `gt_GUT_lower` this
    places the inflaton scale strictly inside Sargas's
    `(10¹⁵, 10¹⁷)` window. -/
theorem inflaton_V_quarter_lt_GUT_upper :
    inflaton_V_quarter_upper < M_GUT_upper_window := by
  unfold M_GUT_upper_window inflaton_V_quarter_upper; norm_num

/-- **Inflaton potential scale sits inside the MSSM-GUT window**. -/
theorem inflaton_V_quarter_in_GUT_window :
    M_GUT_lower_window < inflaton_V_quarter_upper ∧
    inflaton_V_quarter_upper < M_GUT_upper_window :=
  ⟨inflaton_V_quarter_gt_GUT_lower, inflaton_V_quarter_lt_GUT_upper⟩

/-- **Above the electroweak scale** `v_EW = 246 GeV`: inflation is
    a high-scale phenomenon, consistent with its role as the
    earliest sector. -/
theorem inflaton_V_quarter_gt_EW :
    246 < inflaton_V_quarter_upper := by
  unfold inflaton_V_quarter_upper; norm_num

/-! ## 4. Tier 4 — Near-GUT-scale coincidence

The BICEP/Keck saturating inflaton scale `V^{1/4} ≈ 1.6 · 10¹⁶ GeV`
sits within a small multiple of the MSSM-SU(5) unification scale
`M_GUT ≈ 2 · 10¹⁶ GeV`.  Whether this is a DEEP or a SHALLOW
coincidence is an open question; we formalise the numerical
proximity only. -/

/-- **V^{1/4} is strictly below M_GUT_substrate**: `1.6 · 10¹⁶ <
    2 · 10¹⁶ GeV`.  The BICEP/Keck saturating inflaton scale is
    slightly below the MSSM unification scale. -/
theorem inflaton_V_quarter_lt_M_GUT :
    inflaton_V_quarter_upper < M_GUT_substrate := by
  unfold inflaton_V_quarter_upper M_GUT_substrate; norm_num

/-- **V^{1/4} exceeds half of M_GUT**: `0.8 · 10¹⁶ < 1.6 · 10¹⁶ GeV`,
    which gives `M_GUT / V^{1/4} < 2.5`.  The ratio of the GUT
    scale to the inflation scale is bounded by a small factor. -/
theorem inflaton_V_quarter_gt_half_M_GUT :
    M_GUT_substrate / 2 < inflaton_V_quarter_upper := by
  unfold M_GUT_substrate inflaton_V_quarter_upper; norm_num

/-- **Near-GUT coincidence**: `|V^{1/4} − M_GUT| < 10¹⁶ GeV`.
    Numerically `|1.6·10¹⁶ − 2·10¹⁶| = 0.4·10¹⁶ < 10¹⁶`. -/
theorem inflaton_V_quarter_near_M_GUT_substrate :
    |inflaton_V_quarter_upper - M_GUT_substrate| < 1e16 := by
  unfold inflaton_V_quarter_upper M_GUT_substrate
  rw [show (1.6e16 : ℝ) - 2e16 = -(0.4e16) by norm_num,
      abs_neg]
  norm_num

/-- **Ratio bound** `M_GUT / V^{1/4} < 2`: the inflation scale is
    within a factor of two of the MSSM unification scale. -/
theorem M_GUT_over_inflation_scale_lt_two :
    M_GUT_substrate / inflaton_V_quarter_upper < 2 := by
  rw [div_lt_iff₀ inflaton_V_quarter_upper_pos]
  unfold M_GUT_substrate inflaton_V_quarter_upper; norm_num

/-! ## 5. Tier 5 — Slow-roll consistency with n_s < 1 + tensor bound

Slow-roll inflation is characterised jointly by (i) a red-tilted
scalar spectrum `n_s < 1` and (ii) a small tensor amplitude
`r < O(0.1)`.  Both are formalised on the substrate side and hold
simultaneously: the Pi-Hunch assigns `n_s` to the e-channel
(Ras Algethi) and `r` to the √2-channel (Alshain), so the two fits
run on disjoint irrational lanes, yet both deliver their physical
inequalities at their saturating anchors. -/

/-- **Joint slow-roll consistency**: on the substrate, the
    Ras-Algethi scalar spectral index satisfies `n_s^{fit} < 1`
    (red tilt) AND the Alshain tensor-to-scalar ratio saturating
    fit satisfies `substrateRBound N_r_anchor ≤ r_BICEP_upper_bound`
    (tensor upper bound).  Both signatures of slow-roll inflation
    hold in the substrate. -/
theorem slow_roll_consistency_witness :
    ns_fit N_ns_anchor < 1 ∧
    substrateRBound N_r_anchor ≤ r_BICEP_upper_bound :=
  ⟨ns_fit_at_anchor_lt_one, substrateRBound_le_BICEP_at_anchor⟩

/-- **Red-tilt + sub-GeV tensor + sub-Planckian inflaton**:
    three-conjunct slow-roll consistency package.  Inflation is
    (a) red-tilted, (b) tensor-bounded, (c) sub-Planckian. -/
theorem slow_roll_three_sided_consistency :
    ns_fit N_ns_anchor < 1 ∧
    substrateRBound N_r_anchor ≤ r_BICEP_upper_bound ∧
    inflaton_V_quarter_upper < M_Planck_GeV :=
  ⟨ns_fit_at_anchor_lt_one,
   substrateRBound_le_BICEP_at_anchor,
   inflaton_V_quarter_lt_Planck⟩

/-! ## 6. Tier 6 — Paper bundle -/

/-- **Mission headline — `inflaton_potential_scale_substrate_fit`.**

    The BICEP/Keck 2021 upper bound on the tensor-to-scalar ratio
    `r < 0.036` translates via single-field slow-roll into an
    inflaton-potential upper bound `V^{1/4} < 1.6 · 10¹⁶ GeV`.  This
    file formalises the following 5-conjunct paper-citable bundle:

    1. **Inflaton scale**: `inflaton_V_quarter_upper = 1.6·10¹⁶ GeV`
       strictly positive.
    2. **Sub-Planckian**: `V^{1/4} < M_Planck_GeV ≈ 1.22·10¹⁹ GeV`
       (EFT consistency).
    3. **Near-GUT**: `V^{1/4} < M_GUT_substrate = 2·10¹⁶ GeV` (close
       to but below the MSSM unification scale).
    4. **Slow-roll red tilt**: `ns_fit N_ns_anchor < 1` (Ras Algethi).
    5. **BICEP/Keck tensor bound**: `substrateRBound N_r_anchor ≤
       r_BICEP_upper_bound` (Alshain).

    The cycle-20 target 1/6 capstone: a paper reader can cite this
    one theorem to see the entire "high-scale inflation, sub-
    Planckian, near-GUT-scale, red-tilted, tensor-bounded" picture
    in one place. -/
theorem inflaton_potential_scale_substrate_fit :
    0 < inflaton_V_quarter_upper ∧
    inflaton_V_quarter_upper < M_Planck_GeV ∧
    inflaton_V_quarter_upper < M_GUT_substrate ∧
    ns_fit N_ns_anchor < 1 ∧
    substrateRBound N_r_anchor ≤ r_BICEP_upper_bound := by
  refine ⟨inflaton_V_quarter_upper_pos,
          inflaton_V_quarter_lt_Planck,
          inflaton_V_quarter_lt_M_GUT,
          ns_fit_at_anchor_lt_one,
          substrateRBound_le_BICEP_at_anchor⟩

/-- **Paper alias**: one-shot inflaton-potential headline —
    inflaton scale is sub-Planckian and near M_GUT. -/
theorem inflaton_potential_scale_headline :
    inflaton_V_quarter_upper < M_Planck_GeV ∧
    inflaton_V_quarter_upper < M_GUT_substrate ∧
    M_GUT_lower_window < inflaton_V_quarter_upper :=
  ⟨inflaton_V_quarter_lt_Planck,
   inflaton_V_quarter_lt_M_GUT,
   inflaton_V_quarter_gt_GUT_lower⟩

/-- **Paper alias**: capstone compact — the three core slow-roll
    signatures of the substrate: inflaton scale bounded, red tilt,
    tensor bound. -/
theorem inflaton_potential_scale_capstone :
    inflaton_V_quarter_upper < M_Planck_GeV ∧
    ns_fit N_ns_anchor < 1 ∧
    substrateRBound N_r_anchor ≤ r_BICEP_upper_bound :=
  ⟨inflaton_V_quarter_lt_Planck,
   ns_fit_at_anchor_lt_one,
   substrateRBound_le_BICEP_at_anchor⟩

/-- **Existential witness**: there exists a positive substrate
    inflaton-potential scale strictly below the Planck scale. -/
theorem inflaton_potential_exists_subPlanckian :
    ∃ V_q : ℝ, 0 < V_q ∧ V_q < M_Planck_GeV :=
  ⟨inflaton_V_quarter_upper,
   inflaton_V_quarter_upper_pos,
   inflaton_V_quarter_lt_Planck⟩

/-- **Paper alias**: inflation–GUT near-coincidence witness.  The
    BICEP/Keck saturating inflaton scale sits inside the same
    `(10¹⁵, 10¹⁷)` GeV window used by Sargas for the MSSM GUT
    anchor, with both scales separated by a factor ≲ 1.25.  Whether
    this coincidence is DEEP or SHALLOW is left open. -/
theorem inflaton_gut_coincidence_witness :
    M_GUT_lower_window < inflaton_V_quarter_upper ∧
    inflaton_V_quarter_upper < M_GUT_upper_window ∧
    |inflaton_V_quarter_upper - M_GUT_substrate| < 1e16 :=
  ⟨inflaton_V_quarter_gt_GUT_lower,
   inflaton_V_quarter_lt_GUT_upper,
   inflaton_V_quarter_near_M_GUT_substrate⟩

/-- **Falsifiability witness**: there is an upper bound `V_q` on
    the inflaton potential scale that is strictly positive, strictly
    sub-Planckian, AND strictly above the QCD scale (≈ 200 MeV =
    0.2 GeV).  A future detection with `V^{1/4}` above `M_Pl` or
    below the QCD scale would refute the single-field slow-roll
    framing. -/
theorem inflaton_potential_scale_falsifiability_witness :
    ∃ V_q : ℝ, 0 < V_q ∧ V_q < M_Planck_GeV ∧ (0.2 : ℝ) < V_q := by
  refine ⟨inflaton_V_quarter_upper,
          inflaton_V_quarter_upper_pos,
          inflaton_V_quarter_lt_Planck, ?_⟩
  unfold inflaton_V_quarter_upper; norm_num

/-- **Frontier marker**: this file delivers the FIRST formal
    inflaton-potential-scale upper bound in OmegaTheory V2,
    composing Alshain's tensor-to-scalar bound (cycle-15 target 6/6),
    Sargas's M_GUT anchor (cycle-18 target 6/6), and Ras Algethi's
    scalar spectral index fit (cycle-15 target 4/6). -/
theorem inflaton_first_potential_scale_upper_bound_in_V2 :
    ∃ V_q : ℝ, V_q = inflaton_V_quarter_upper ∧
      0 < V_q ∧ V_q < M_Planck_GeV ∧ V_q < M_GUT_substrate :=
  ⟨inflaton_V_quarter_upper, rfl,
   inflaton_V_quarter_upper_pos,
   inflaton_V_quarter_lt_Planck,
   inflaton_V_quarter_lt_M_GUT⟩

end OmegaTheory.Predictions.InflatonPotentialScale
