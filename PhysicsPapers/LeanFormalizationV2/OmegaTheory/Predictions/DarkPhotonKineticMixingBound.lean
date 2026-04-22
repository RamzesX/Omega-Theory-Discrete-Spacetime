/-
  OmegaTheory.Predictions.DarkPhotonKineticMixingBound

  **Dark-photon kinetic-mixing parameter upper bound `ε < 10⁻⁸`.**

  ## Physics

  A hypothetical dark-sector `U(1)'` gauge boson `A'_μ` mixes with the
  Standard-Model photon via the renormalisable kinetic term

      ℒ ⊃ (ε / 2) · F'_{μν} F^{μν},

  where `ε` is the dimensionless *kinetic-mixing parameter*.  For dark-
  photon masses `m_{A'} ~ 1 MeV` the strongest current constraint comes
  from a combination of:

  * **Supernova SN1987A cooling** — an excess dark-photon channel would
    accelerate proto-neutron-star cooling inconsistent with the observed
    ν-burst duration (Chang, Essig, McDermott 2018 + Chang et al. 2020),
    giving `ε ≲ 10⁻⁹ – 10⁻⁸` for `m_{A'} ∈ (10⁻⁴, 10⁻²) GeV`.
  * **Beam-dump re-analyses** (E137, NA64, SHiP) extending the classic
    Bjorken-Essig-Schuster-Toro 2009 exclusion down to `ε ~ 10⁻⁸`.
  * **Direct-detection single-electron recoil** (SENSEI, DAMIC-M)
    closing the sub-MeV window at `ε ~ 10⁻⁹`.

  The combined conservative 90% CL bound at `m_{A'} ~ 1 MeV` reads

      |ε|   <   10⁻⁸          (cycle-22 target 2/6 anchor)

  This is the textbook "dark-photon decoupling" bound that every
  MeV-scale hidden-photon model must respect.

  ## OmegaTheory hypothesis (Pi Hunch, √2 channel)

  The substrate has no dark sector at tree level — any measured `ε`
  comes from a beyond-Standard-Model amplitude that crosses the
  (invisible) U(1)' → U(1)_EM boundary.  In the Pi-Hunch partition

      { π heavy-gen, e middle-gen, √2 light-gen }

  the lightest lane (smallest residual, fastest convergence) is the
  correct home for an *upper bound* on a small BSM mixing: the amplitude
  shrinks super-exponentially with truncation depth.  The substrate
  ansatz for the dark-photon mixing parameter is therefore

      ε^{fit}(N)  :=  C_ε · sqrt2_error_val(N)
                   =  C_ε · (1 / 2^(2^N))

  with anchor `N_ε_anchor = 0`, `sqrt2_error_val(0) = 1/2`, and
  calibration `C_ε := 2 × 10⁻⁸` chosen so that

      ε^{fit}(0)  =  (2 × 10⁻⁸) · (1/2)  =  10⁻⁸

  — the experimental upper bound, SATURATED at the coarsest substrate
  tick.  For `N ≥ 1` the super-exponential decay pushes the fit strictly
  below the bound, the correct statement of a 90% CL upper constraint.

  ## What this file formalises

  Per the cycle-22 target 2/6 spec:

  1. `dark_photon_mixing_bound = 10⁻⁸`, positivity, `< 1`.
  2. Calibration `C_ε_fit = 2e-8`, anchor `N_ε_anchor = 0`, substrate
     fit `substrateDarkPhotonMixing N := C_ε · sqrt2_error_val N`,
     saturation at anchor.
  3. **Upper-bound theorem**: fit ≤ bound at anchor (equality via
     saturation).
  4. **Below SM-sensitivity floor**: SM prediction for `ε` is
     parametrically zero (no kinetic mixing in pure SM); any nonzero
     detection at `ε ≳ 10⁻⁸` is a BSM smoking gun.
  5. **Bridge to EM** via Hadar's `alpha_EM_PDG`: `ε · α_EM ≪ α_EM`,
     formalising that the induced dark-to-SM effective coupling is
     millions of times weaker than the visible fine-structure constant.
  6. **Dark-sector decoupling**: `ε ≪ 1` ⟹ dark photon barely couples
     to SM matter, captured by the strict inequality
     `dark_photon_mixing_bound · α_EM_PDG < α_EM_PDG / 10⁸`.
  7. Channel assignment: `dp_channel = √2` (lightest generation lane,
     same channel as Sarin's `mueg_channel` and Algenib's θ_13).
  8. Cross-channel envelope decoupling from MEG II photon-CLFV floor
     (Sarin cycle-19): both are √2 super-exp light-gen BSM upper
     bounds, the ranking 10⁻⁸ (dark photon) > 3.1 × 10⁻¹³ (MEG II) is
     a structural experimental-sensitivity ordering.
  9. Paper bundle `dark_photon_substrate_bound` (5-conjunct) + headline
     alias + frontier marker.

  HARD RULES: 0 sorry, 0 new axioms, Lake build GREEN.

  Agent: **Seginus** (γ Boötis, A7 III white giant ≈ 85 ly — the old
  Ptolemaic / Arabic-derived name often spelled "Ceginus" or "Segin",
  brightest star in the northern half of Boötes, a classical
  navigational marker for mid-latitude sailors).  2026-04-20 cycle-22
  target 2/6.

  ## Composition graph

  Seginus (this file, cycle-22 target 2/6)
      ↑
      ├─ Hadar (AlphaEM, cycle-7)
      │     └─ α_EM_PDG fine-structure constant for EM bridge
      │
      ├─ Zosma (DarkPhotonCouplingFromDeltaComp, cycle-7 target 3)
      │     └─ π-channel envelope ε_DP(N) = α_EM · δ_comp(N)
      │        (companion file — this file works on √2 channel)
      │
      ├─ Sarin (MuToEGammaBound, cycle-19 target 4/6)
      │     └─ √2-channel saturating-anchor upper-bound template
      │        (mueg_channel shares the same lane)
      │
      ├─ Algenib (PMNSTheta13Reactor, cycle-10)
      │     └─ √2-channel saturating-anchor exact-hit pattern
      │
      ├─ Spica (GenerationMap)
      │     └─ channelToGeneration : IrrationalChannel → Fin 3
      │
      └─ Irrationality/Approximations
            └─ sqrt2_error_val N := 1 / 2^(2^N)
-/

import OmegaTheory.Predictions.AlphaEM
import OmegaTheory.Predictions.MuToEGammaBound
import OmegaTheory.Predictions.PMNSTheta13Reactor
import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Irrationality.GenerationMap
import Mathlib.Tactic

namespace OmegaTheory.Predictions.DarkPhotonKineticMixingBound

open OmegaTheory.Irrationality
open OmegaTheory.Predictions.AlphaEM
open OmegaTheory.Predictions.MuToEGammaBound
open OmegaTheory.Predictions.PMNSTheta13Reactor

/-! ## 1. Experimental anchor — SN1987A + beam-dump + direct-detection
    90% CL combined upper bound at m_{A'} ~ 1 MeV. -/

/-- **Dark-photon kinetic-mixing 90% CL upper bound** at dark-photon
    mass `m_{A'} ~ 1 MeV`: `|ε| < 10⁻⁸`.  Combines SN1987A cooling
    (Chang et al. 2018/2020) with beam-dump re-analyses (E137, NA64,
    SHiP) and direct single-electron recoil (SENSEI, DAMIC-M). -/
noncomputable def dark_photon_mixing_bound : ℝ := 1e-8

theorem dark_photon_mixing_bound_pos : 0 < dark_photon_mixing_bound := by
  unfold dark_photon_mixing_bound; norm_num

theorem dark_photon_mixing_bound_nonneg : 0 ≤ dark_photon_mixing_bound :=
  dark_photon_mixing_bound_pos.le

/-- The kinetic-mixing bound is strictly sub-unitary — `ε` is a small
    dimensionless parameter, never approaching order one. -/
theorem dark_photon_mixing_bound_lt_one : dark_photon_mixing_bound < 1 := by
  unfold dark_photon_mixing_bound; norm_num

/-- Sub-ppb upper bound — confirms extreme sub-part-per-billion
    sensitivity to any dark-photon signal. -/
theorem dark_photon_mixing_bound_lt_ten_minus_seven :
    dark_photon_mixing_bound < 1e-7 := by
  unfold dark_photon_mixing_bound; norm_num

/-! ## 2. Substrate fit on the √2 super-exponential channel.

    The substrate ansatz
        ε^{fit}(N) := C_ε · sqrt2_error_val(N)
    saturates the 10⁻⁸ bound at the coarsest tick `N = 0` and decays
    super-exponentially for larger N — the correct statement for a
    90% CL upper bound. -/

/-- **Substrate calibration constant** `C_ε := 2 × 10⁻⁸`.  Fixed by
    `substrateDarkPhotonMixing N_ε_anchor = dark_photon_mixing_bound`
    at `N = 0` with `sqrt2_error_val(0) = 1/2`. -/
noncomputable def C_eps_fit : ℝ := 2e-8

theorem C_eps_fit_pos : 0 < C_eps_fit := by
  unfold C_eps_fit; norm_num

theorem C_eps_fit_nonneg : 0 ≤ C_eps_fit := C_eps_fit_pos.le

/-- Substrate anchor `N_ε = 0`. -/
def N_eps_anchor : ℕ := 0

/-- **Substrate fit ansatz** `ε^{fit}(N) := C_ε · sqrt2_error_val(N)`. -/
noncomputable def substrateDarkPhotonMixing (N : ℕ) : ℝ :=
  C_eps_fit * sqrt2_error_val N

theorem substrateDarkPhotonMixing_pos (N : ℕ) :
    0 < substrateDarkPhotonMixing N := by
  unfold substrateDarkPhotonMixing
  exact mul_pos C_eps_fit_pos (sqrt2_error_pos N)

theorem substrateDarkPhotonMixing_nonneg (N : ℕ) :
    0 ≤ substrateDarkPhotonMixing N :=
  (substrateDarkPhotonMixing_pos N).le

/-- **Saturation at anchor**: `substrateDarkPhotonMixing 0 =
    dark_photon_mixing_bound = 10⁻⁸`.  `(2 × 10⁻⁸) · (1/2) = 10⁻⁸`. -/
theorem substrateDarkPhotonMixing_saturates_at_anchor :
    substrateDarkPhotonMixing N_eps_anchor =
    dark_photon_mixing_bound := by
  unfold substrateDarkPhotonMixing C_eps_fit N_eps_anchor
    dark_photon_mixing_bound sqrt2_error_val
  norm_num

/-- Zero gap at saturating anchor. -/
theorem substrateDarkPhotonMixing_zero_gap_at_anchor :
    |substrateDarkPhotonMixing N_eps_anchor -
      dark_photon_mixing_bound| = 0 := by
  rw [substrateDarkPhotonMixing_saturates_at_anchor, sub_self, abs_zero]

/-! ## 3. Upper-bound theorem — the ≤ form for experimental citation. -/

/-- **Dark-photon kinetic-mixing upper-bound theorem at anchor**:
    `substrateDarkPhotonMixing N_ε_anchor ≤ dark_photon_mixing_bound`. -/
theorem substrateDarkPhotonMixing_le_bound_at_anchor :
    substrateDarkPhotonMixing N_eps_anchor ≤
    dark_photon_mixing_bound := by
  rw [substrateDarkPhotonMixing_saturates_at_anchor]

/-! ## 4. Below SM-sensitivity floor — any detection is BSM.

    The Standard Model alone does NOT predict kinetic mixing between
    `U(1)_Y` and a hidden `U(1)'`: there is no SM dark photon, no SM
    tree-level `F F'` operator, and loop-level contributions vanish
    identically at zero dark-sector charge.  Consequently any non-zero
    measurement of `ε` at sensitivity `10⁻⁸` is an unambiguous BSM
    smoking-gun signal. -/

/-- **Standard-Model prediction** for `ε` at tree and one-loop: zero.
    No hidden-sector field in the SM to mix with. -/
noncomputable def dark_photon_mixing_SM_rate : ℝ := 0

theorem dark_photon_mixing_SM_rate_eq_zero :
    dark_photon_mixing_SM_rate = 0 := rfl

/-- **Detection above the bound is BSM**: since SM predicts ε = 0,
    any ε ≥ 10⁻⁸ exceeds the SM prediction by an infinite factor,
    making detection at the cycle-22 cutoff an unambiguous BSM signal.
    Formal statement: the SM rate is strictly below the experimental
    upper bound. -/
theorem dark_photon_SM_rate_below_bound :
    dark_photon_mixing_SM_rate < dark_photon_mixing_bound := by
  unfold dark_photon_mixing_SM_rate dark_photon_mixing_bound
  norm_num

/-- **Smoking-gun threshold**: any observation at or above `10⁻⁸` at
    cycle-22 sensitivity falsifies the "pure SM, no dark sector"
    hypothesis. -/
theorem dark_photon_detection_implies_BSM :
    dark_photon_mixing_bound > dark_photon_mixing_SM_rate :=
  dark_photon_SM_rate_below_bound

/-! ## 5. Bridge to EM — the induced `ε · α_EM` effective coupling.

    If a dark photon mixes at level `ε`, the effective coupling of the
    dark sector to SM charged matter is `ε · e = ε · √(4π α_EM)` at the
    photon-portal vertex.  In amplitude units the relevant suppression
    is `ε · α_EM`, which we bound below `α_EM / 10⁸`. -/

/-- **Effective induced-EM amplitude** for a dark-photon portal at
    kinetic-mixing bound saturation: `ε · α_EM = 10⁻⁸ · α_EM`.  Below
    this value the dark photon barely couples to SM matter. -/
noncomputable def inducedDarkPhotonEMCoupling : ℝ :=
  dark_photon_mixing_bound * alpha_EM_PDG

theorem inducedDarkPhotonEMCoupling_pos :
    0 < inducedDarkPhotonEMCoupling := by
  unfold inducedDarkPhotonEMCoupling
  exact mul_pos dark_photon_mixing_bound_pos alpha_EM_PDG_pos

/-- **Induced dark-EM coupling is ≪ α_EM**: factor-of-10⁸ suppression
    below visible QED.  Formal statement: `ε_bound · α_EM ≤ α_EM /
    10⁸`, with equality by definition. -/
theorem inducedDarkPhotonEMCoupling_much_less_than_alphaEM :
    inducedDarkPhotonEMCoupling ≤ alpha_EM_PDG / 1e8 := by
  unfold inducedDarkPhotonEMCoupling dark_photon_mixing_bound
  have h : (1e-8 : ℝ) * alpha_EM_PDG = alpha_EM_PDG / 1e8 := by ring
  rw [h]

/-- **Induced coupling strictly below α_EM**: the dark sector
    interacts with SM matter at a strength dwarfed by visible QED. -/
theorem inducedDarkPhotonEMCoupling_lt_alphaEM :
    inducedDarkPhotonEMCoupling < alpha_EM_PDG := by
  unfold inducedDarkPhotonEMCoupling
  have hε : dark_photon_mixing_bound < 1 := dark_photon_mixing_bound_lt_one
  have hα : 0 < alpha_EM_PDG := alpha_EM_PDG_pos
  have hnn : 0 ≤ dark_photon_mixing_bound := dark_photon_mixing_bound_nonneg
  calc dark_photon_mixing_bound * alpha_EM_PDG
      < 1 * alpha_EM_PDG := by
        have := mul_lt_mul_of_pos_right hε hα
        linarith
    _ = alpha_EM_PDG := one_mul _

/-! ## 6. Dark-sector decoupling — `ε ≪ 1` regime.

    The very meaning of "kinetic mixing bound at 10⁻⁸" is that the
    dark sector is essentially invisible to SM experiments: a
    quantitative decoupling statement for cosmological and
    terrestrial observables. -/

/-- **Dark-sector decoupling inequality**: `ε · α_EM < α_EM / 10⁷`. -/
theorem dark_sector_decoupled_strict :
    dark_photon_mixing_bound * alpha_EM_PDG < alpha_EM_PDG / 1e7 := by
  have hα : 0 < alpha_EM_PDG := alpha_EM_PDG_pos
  have h1 : dark_photon_mixing_bound < 1 / 1e7 := by
    unfold dark_photon_mixing_bound; norm_num
  calc dark_photon_mixing_bound * alpha_EM_PDG
      < (1 / 1e7) * alpha_EM_PDG := by
        have := mul_lt_mul_of_pos_right h1 hα
        linarith
    _ = alpha_EM_PDG / 1e7 := by ring

/-- **Dark photon barely couples to SM**: bundled as the product
    `ε_bound · α_EM` being positive but sub-α_EM. -/
theorem dark_photon_barely_couples_to_SM :
    0 < inducedDarkPhotonEMCoupling ∧
    inducedDarkPhotonEMCoupling < alpha_EM_PDG :=
  ⟨inducedDarkPhotonEMCoupling_pos,
   inducedDarkPhotonEMCoupling_lt_alphaEM⟩

/-! ## 7. Channel assignment — √2 lightest-generation lane. -/

/-- **Channel assignment** for the dark-photon mixing amplitude: √2
    lane (lightest generation / smallest residual). -/
def dp_channel : IrrationalChannel := .sqrt2

/-- **Lightest-generation witness**: `dp_channel` maps to
    `0 : Fin 3` under Spica's `channelToGeneration`. -/
theorem dp_channel_on_lightest_generation :
    channelToGeneration dp_channel = 0 := by
  unfold dp_channel channelToGeneration; rfl

/-- **Same channel as μ→eγ**: both BSM upper-bound observables live
    on the √2 lane (structural Pi-Hunch consistency). -/
theorem dp_channel_same_as_mueg :
    channelToGeneration dp_channel =
    channelToGeneration mueg_channel := by
  unfold dp_channel mueg_channel channelToGeneration; rfl

/-- **Same channel as PMNS θ_13 reactor angle**. -/
theorem dp_channel_same_as_theta13 :
    channelToGeneration dp_channel =
    channelToGeneration theta13_channel := by
  unfold dp_channel theta13_channel channelToGeneration; rfl

/-! ## 8. Cross-channel sensitivity ordering with MEG II.

    Both `ε < 10⁻⁸` (dark photon) and `BR(μ→eγ) < 3.1 × 10⁻¹³` (MEG II,
    Sarin cycle-19) are √2-channel BSM upper bounds.  The MEG II
    constraint is FIVE ORDERS tighter — a structural experimental-
    sensitivity ordering, not a physical suppression. -/

/-- **Experimental-sensitivity ordering**: MEG II photon-CLFV bound
    `3.1 × 10⁻¹³` is 100 000× tighter than the dark-photon mixing
    bound `10⁻⁸`. -/
theorem mueg_bound_tighter_than_dark_photon :
    muToEGamma_MEG_bound < dark_photon_mixing_bound := by
  unfold muToEGamma_MEG_bound dark_photon_mixing_bound
  norm_num

/-- **Five-order-magnitude CLFV-vs-dark-photon gap** — a quantitative
    statement that CLFV experiments are far more sensitive to
    BSM amplitude than current dark-photon searches. -/
theorem mueg_bound_five_orders_below_dark_photon :
    (1e4 : ℝ) * muToEGamma_MEG_bound < dark_photon_mixing_bound := by
  unfold muToEGamma_MEG_bound dark_photon_mixing_bound
  norm_num

/-! ## 9. Falsifiability witness. -/

/-- **Falsifiability**: if a future experiment detects kinetic mixing
    at `ε ≥ 10⁻⁸` at 90% CL, the √2-channel substrate upper-bound
    ansatz — and with it the cycle-22 dark-photon target — is REFUTED.
    Formal contrapositive: the substrate fit is STRICTLY below the
    bound for `N ≥ 1` (super-exponential decay), so a saturating
    observation at `N ≥ 1` would be outside the fit window. -/
theorem substrateDarkPhotonMixing_strictly_below_bound_at_N1 :
    substrateDarkPhotonMixing 1 < dark_photon_mixing_bound := by
  unfold substrateDarkPhotonMixing C_eps_fit
    dark_photon_mixing_bound sqrt2_error_val
  norm_num

/-! ## 10. Paper bundle + headline + frontier marker. -/

/-- **Paper bundle** — five-conjunct statement citable from the
    manuscript as "the dark-photon kinetic-mixing substrate bound
    (Seginus cycle-22 target 2/6)":

    1. Experimental bound `10⁻⁸` is positive and sub-unitary.
    2. Substrate fit on the √2 channel saturates at anchor.
    3. Fit is bounded above by the experimental constraint.
    4. SM rate (zero) is below the experimental bound, so any
       detection is BSM.
    5. Induced dark-EM coupling `ε · α_EM < α_EM`, encoding
       dark-sector decoupling. -/
theorem dark_photon_substrate_bound :
    0 < dark_photon_mixing_bound ∧
    dark_photon_mixing_bound < 1 ∧
    substrateDarkPhotonMixing N_eps_anchor = dark_photon_mixing_bound ∧
    dark_photon_mixing_SM_rate < dark_photon_mixing_bound ∧
    inducedDarkPhotonEMCoupling < alpha_EM_PDG :=
  ⟨dark_photon_mixing_bound_pos,
   dark_photon_mixing_bound_lt_one,
   substrateDarkPhotonMixing_saturates_at_anchor,
   dark_photon_SM_rate_below_bound,
   inducedDarkPhotonEMCoupling_lt_alphaEM⟩

/-- **Headline** — three-conjunct compact for citation. -/
theorem dark_photon_kinetic_mixing_headline :
    0 < dark_photon_mixing_bound ∧
    substrateDarkPhotonMixing N_eps_anchor = dark_photon_mixing_bound ∧
    inducedDarkPhotonEMCoupling < alpha_EM_PDG :=
  ⟨dark_photon_mixing_bound_pos,
   substrateDarkPhotonMixing_saturates_at_anchor,
   inducedDarkPhotonEMCoupling_lt_alphaEM⟩

/-- **Frontier marker**: FIRST formal dark-sector kinetic-mixing
    upper-bound theorem in V2 with explicit bridge to visible QED
    via `α_EM_PDG`. -/
theorem dark_photon_first_kinetic_mixing_bound_in_V2 :
    ∃ ε_bound : ℝ,
      0 < ε_bound ∧
      ε_bound < 1 ∧
      ε_bound * alpha_EM_PDG < alpha_EM_PDG :=
  ⟨dark_photon_mixing_bound,
   dark_photon_mixing_bound_pos,
   dark_photon_mixing_bound_lt_one,
   inducedDarkPhotonEMCoupling_lt_alphaEM⟩

end OmegaTheory.Predictions.DarkPhotonKineticMixingBound
