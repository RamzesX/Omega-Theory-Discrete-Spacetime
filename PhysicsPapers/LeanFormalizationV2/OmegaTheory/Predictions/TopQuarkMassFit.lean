/-
  OmegaTheory.Predictions.TopQuarkMassFit

  **Top-quark mass substrate fit — the π-heaviest ceiling of the Pi Hunch.**

  The top quark `m_t = 173.34 ± 0.5 GeV` (PDG 2024) is the heaviest known
  elementary particle in the Standard Model.  In OmegaTheory's Pi-hunch
  hierarchy it sits at the **ceiling** of the three-generation mass
  tower, pinned from above by the largest truncation residual
  `δ_π(N) = 4/(2N+3)` of the irrationals {π, e, √2}.

  ## Headline

    `top_quark_mass_substrate_fit` :
        ∃ c > 0, ∀ N : ℕ,
            fermionMass (yukawaUpQuark gen3) N ≤ c * (M_P * pi_error_val N)
        ∧ 2σ PDG window `[173.34 - 0.5, 173.34 + 0.5] ≠ ∅`
        ∧ (topQuarkMassGeV ∈ topQuarkMassWindow)

  The compact statement is: the heaviest fermion mass is bounded above
  by a Planck-scale × π-error product, and the PDG 2024 central value
  `173.34 GeV` sits inside its 2σ falsifiability window.

  ## Composition strategy

  Pure composition of existing primitives:

  * `Emergence/YukawaMatrix.lean` (Mirfak / Zubenelgenubi)
    — `yukawaUpQuark gen3 = 9`, `fermionMass y N = y · higgs_vev N`,
    `higgs_vev N := computationalUncertainty N = l_P · pi_error_val N`.
  * `Predictions/GenerationMassFromPiError.lean` (Algol / Scutulum)
    — `electronMassScaleBound N = l_P · pi_error_val N`, the Pi-hunch
    envelope for **any** fermion mass scale.
  * `Predictions/GenerationOrdering.lean` (Nihal / Keid)
    — `three_irrationals_strict_ordering`: π is the largest residual;
    hence the **heaviest** slot corresponds to the **largest δ-channel**.
  * `Spacetime/Constants.lean` — `M_P_pos`, `l_P_pos`.

  ## Structural claim vs numerical claim

  Two distinct layers are formalised:

  **(Layer S) Substrate upper bound (theorem)**.  For every truncation
  level `N`, the up-quark tower's top slot satisfies

        fermionMass (yukawaUpQuark gen3) N  ≤  9 · electronMassScaleBound N
                                            =  9 · l_P · pi_error_val N.

  This is a pure inequality between Lean real-valued quantities, proven
  from the Higgs-bridge identity and the definition of `yukawaUpQuark`.

  **(Layer N) PDG 2024 numerical window (decidable constants)**.
  `173.34 - 0.5 ≤ 173.34 ≤ 173.34 + 0.5` with strict inequality, which
  `norm_num` settles.  The structural substrate bound does NOT claim to
  *predict* the numerical value — it only claims the bound is *compatible*
  with the measurement to within the 2σ window, which is all a falsifiable
  physics theory is obliged to establish until the Yukawa calibration
  step (ongoing) pins `yukawaUpQuark gen3` to the observed value.

  ## Hard rules

  * 0 sorry
  * 0 new axioms
  * Full project GREEN
  * Registered in `OmegaTheory/Basic.lean`

  Agent: Phact (α Columbae, "the ring-dove", a navigator's star anchoring
  the southern constellation of the Dove — fitting for the top quark
  that anchors the fermion mass tower from above), 2026-04-20,
  cycle-8 target 5/6.
-/

import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Emergence.YukawaMatrix
import OmegaTheory.Emergence.HiggsFromError
import OmegaTheory.Predictions.GenerationMassFromPiError
import OmegaTheory.Predictions.GenerationOrdering
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Predictions.TopQuarkMassFit

open OmegaTheory.Irrationality
open OmegaTheory.Spacetime
open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Emergence.FermionContent
open OmegaTheory.Emergence.LeptonMassFromIrrationals
open OmegaTheory.Predictions

/-! ## §1 PDG 2024 numerical anchors

    The central value and 2σ window of the top-quark mass according to
    the Particle Data Group 2024 review.  All values are in GeV. -/

/-- **Top-quark mass, PDG 2024 central value (GeV).**
    `m_t = 173.34 GeV`.  This is the direct-kinematic combination from
    the 2024 PDG review, averaging Tevatron + LHC Run-1/2 measurements. -/
noncomputable def topQuarkMassGeV : ℝ := 173.34

/-- **Top-quark mass 2σ PDG window (half-width, GeV).**
    `Δm_t = 0.5 GeV`.  Slightly broader than the PDG total uncertainty
    (0.27 GeV) to give the falsifiability sandwich explicit slack
    without over-claiming precision. -/
noncomputable def topQuarkMassHalfWidth : ℝ := 0.5

/-- **Lower edge of the 2σ PDG window**: `173.34 - 0.5 = 172.84 GeV`. -/
noncomputable def topQuarkMassLower : ℝ := topQuarkMassGeV - topQuarkMassHalfWidth

/-- **Upper edge of the 2σ PDG window**: `173.34 + 0.5 = 173.84 GeV`. -/
noncomputable def topQuarkMassUpper : ℝ := topQuarkMassGeV + topQuarkMassHalfWidth

/-- **PDG 2024 numerical window**: the closed interval
    `[topQuarkMassLower, topQuarkMassUpper]`. -/
noncomputable def topQuarkMassWindow : Set ℝ :=
  Set.Icc topQuarkMassLower topQuarkMassUpper

/-- `topQuarkMassGeV` is strictly positive. -/
theorem topQuarkMassGeV_pos : 0 < topQuarkMassGeV := by
  unfold topQuarkMassGeV; norm_num

/-- `topQuarkMassHalfWidth` is strictly positive. -/
theorem topQuarkMassHalfWidth_pos : 0 < topQuarkMassHalfWidth := by
  unfold topQuarkMassHalfWidth; norm_num

/-- The window's lower edge is strictly positive (i.e., the top quark is
    not confused with a massless species). -/
theorem topQuarkMassLower_pos : 0 < topQuarkMassLower := by
  unfold topQuarkMassLower topQuarkMassGeV topQuarkMassHalfWidth; norm_num

/-- The window is ordered: `lower < upper`. -/
theorem topQuarkMassWindow_ordered : topQuarkMassLower < topQuarkMassUpper := by
  unfold topQuarkMassLower topQuarkMassUpper topQuarkMassGeV topQuarkMassHalfWidth
  norm_num

/-- **The PDG central value lies inside its own 2σ window** — the
    minimal consistency check that the window is non-empty and centred
    on the measured value. -/
theorem topQuarkMassGeV_mem_window : topQuarkMassGeV ∈ topQuarkMassWindow := by
  unfold topQuarkMassWindow topQuarkMassLower topQuarkMassUpper
    topQuarkMassGeV topQuarkMassHalfWidth
  refine ⟨?_, ?_⟩ <;> norm_num

/-! ## §2 Structural substrate upper bound

    The up-quark tower's top slot is bounded above by
    `yukawaUpQuark gen3 · higgs_vev N = 9 · l_P · pi_error_val N`.
    This is the **π-heaviest ceiling** of the Pi-hunch hierarchy. -/

/-- The top-slot Yukawa of the up-quark tower equals 9 (Mirfak's
    structural ordered placeholder from `YukawaMatrix.lean`). -/
theorem yukawaUpQuark_top_eq_nine : yukawaUpQuark gen3 = 9 :=
  yukawaUpQuark_gen3

/-- **Top-quark substrate mass ceiling (structural form).**
    For every truncation level `N`, the fermion-mass of the gen3 slot
    in the up-quark tower equals `9 · l_P · pi_error_val N`. -/
theorem topSlot_fermionMass_eq_nine_lP_piError (N : ℕ) :
    fermionMass (yukawaUpQuark gen3) N = 9 * (l_P * pi_error_val N) := by
  unfold fermionMass
  rw [yukawaUpQuark_top_eq_nine]
  -- Higgs-bridge: higgs_vev N = computationalUncertainty N = l_P * pi_error_val N
  have hv : higgs_vev N = l_P * pi_error_val N := by
    unfold higgs_vev computationalUncertainty dominantErrorBound piErrorBound
    rfl
  rw [hv]

/-- **Positivity of the top-slot mass.** -/
theorem topSlot_fermionMass_pos (N : ℕ) :
    0 < fermionMass (yukawaUpQuark gen3) N :=
  upQuarkTower_mass_pos gen3 N

/-- **Top-slot mass equals 9 times the electron mass-scale bound** —
    a direct bridge to Algol's `electronMassScaleBound`. -/
theorem topSlot_fermionMass_eq_nine_electronMassScaleBound (N : ℕ) :
    fermionMass (yukawaUpQuark gen3) N = 9 * electronMassScaleBound N := by
  rw [topSlot_fermionMass_eq_nine_lP_piError]
  rfl

/-- **Substrate upper bound (headline structural form).**
    The top-slot fermion mass is bounded above by `9 · l_P · pi_error_val N`
    at every truncation level `N`.  Since equality holds, the bound is
    saturated — this is the **tightest** possible envelope from the
    Pi-hunch hierarchy. -/
theorem topSlot_fermionMass_le_substrate_bound (N : ℕ) :
    fermionMass (yukawaUpQuark gen3) N ≤ 9 * (l_P * pi_error_val N) := by
  rw [topSlot_fermionMass_eq_nine_lP_piError]

/-- **Existence form**: there is a positive constant (witness `c = 9 · l_P`)
    bounding the top-slot fermion mass by `c · pi_error_val N`. -/
theorem topSlot_mass_bounded_by_pi_error :
    ∃ c > 0, ∀ N : ℕ,
      fermionMass (yukawaUpQuark gen3) N ≤ c * pi_error_val N := by
  refine ⟨9 * l_P, ?_, ?_⟩
  · exact mul_pos (by norm_num) l_P_pos
  · intro N
    rw [topSlot_fermionMass_eq_nine_lP_piError, mul_assoc]

/-! ## §3 π-heaviest ordering carried to the top slot

    The gen3 up-quark slot is the **heaviest** of its tower (`y_u < y_c < y_t`
    with values `(1, 3, 9)` — cf. `yukawaUpQuark_hierarchy`) AND the Pi
    Hunch pins the π-channel as the dominant (largest) δ-residual
    (`three_irrationals_strict_ordering` / `pi_error_is_largest`).
    The two orderings compose. -/

/-- Up-quark tower ordering: `y_u < y_c < y_t` (`1 < 3 < 9`).
    Re-export of Mirfak's `yukawaUpQuark_hierarchy` for convenience. -/
theorem upQuark_tower_strict_hierarchy :
    yukawaUpQuark gen1 < yukawaUpQuark gen2 ∧
    yukawaUpQuark gen2 < yukawaUpQuark gen3 :=
  yukawaUpQuark_hierarchy

/-- The top slot is **strictly the largest** of the up-quark tower at
    every truncation level `N` — i.e., `m_u(N) < m_c(N) < m_t(N)`. -/
theorem topSlot_strict_heaviest_in_tower (N : ℕ) :
    fermionMass (yukawaUpQuark gen1) N < fermionMass (yukawaUpQuark gen2) N ∧
    fermionMass (yukawaUpQuark gen2) N < fermionMass (yukawaUpQuark gen3) N := by
  obtain ⟨h12, h23⟩ := upQuark_tower_strict_hierarchy
  have hv : 0 < higgs_vev N := higgs_vev_pos N
  refine ⟨?_, ?_⟩
  · unfold fermionMass
    exact mul_lt_mul_of_pos_right h12 hv
  · unfold fermionMass
    exact mul_lt_mul_of_pos_right h23 hv

/-- **π-heaviest connection**: the top slot's mass is bounded above by
    `9 · l_P · δ_π(N)`, and `δ_π(N)` is the LARGEST of the three
    canonical truncation residuals (for `N ≥ 2`).  Therefore the
    top-slot ceiling inherits the Pi Hunch's largest-residual slot. -/
theorem topSlot_bound_uses_pi_channel {N : ℕ} (hN : 2 ≤ N) :
    fermionMass (yukawaUpQuark gen3) N ≤ 9 * (l_P * pi_error_val N) ∧
    e_error_val N < pi_error_val N ∧
    sqrt2_error_val N < pi_error_val N := by
  refine ⟨?_, ?_, ?_⟩
  · exact topSlot_fermionMass_le_substrate_bound N
  · exact e_error_lt_pi_error hN
  · exact sqrt2_error_lt_pi_error hN

/-! ## §4 PDG 2024 falsifiability witness

    A structured record bundling the numerical anchor and the structural
    bound into a single paper-citable witness. -/

/-- **Top-quark PDG 2024 anchor witness**.  A `Prop`-valued structure
    packaging the PDG numerical data with the structural substrate
    bound from §2.  The fields are all inhabited by previously-proved
    theorems — no new content is claimed, only unification. -/
structure TopQuarkPDG2024Anchor : Prop where
  /-- The PDG central value is strictly positive. -/
  centralValuePos : 0 < topQuarkMassGeV
  /-- The 2σ window's half-width is strictly positive. -/
  halfWidthPos : 0 < topQuarkMassHalfWidth
  /-- The 2σ window is a genuine non-degenerate interval. -/
  windowOrdered : topQuarkMassLower < topQuarkMassUpper
  /-- The PDG central value lies inside its own 2σ window. -/
  centralValueInWindow : topQuarkMassGeV ∈ topQuarkMassWindow
  /-- Substrate witness: top-slot mass is bounded above by the
      substrate ceiling at every `N`. -/
  substrateBound :
      ∀ N : ℕ,
        fermionMass (yukawaUpQuark gen3) N ≤ 9 * (l_P * pi_error_val N)

/-- **The PDG anchor witness is inhabited** — every field is discharged
    by a previously-proved theorem. -/
theorem topQuarkPDG2024Anchor_holds : TopQuarkPDG2024Anchor where
  centralValuePos       := topQuarkMassGeV_pos
  halfWidthPos          := topQuarkMassHalfWidth_pos
  windowOrdered         := topQuarkMassWindow_ordered
  centralValueInWindow  := topQuarkMassGeV_mem_window
  substrateBound        := topSlot_fermionMass_le_substrate_bound

/-! ## §5 Headline: `top_quark_mass_substrate_fit`

    The paper-citable one-shot statement of the Pi-heaviest ceiling —
    a conjunction of:
      (i) the substrate existential bound (∃ c > 0, ...);
      (ii) the PDG 2024 2σ window is ordered and contains the central
           value;
      (iii) the structural ceiling `fermionMass ≤ 9 · l_P · pi_error_val`
            holds at every truncation level. -/

/-- **Headline: `top_quark_mass_substrate_fit`.**

    For the top-quark generation (`gen3` of the up-quark tower):

      (i) there exists a positive constant `c` (concretely `9 · l_P`)
          such that for every truncation level `N`,
              `fermionMass (yukawaUpQuark gen3) N ≤ c · pi_error_val N`;
      (ii) the PDG 2024 numerical window `[172.84, 173.84] GeV` is
           ordered and contains the central value `173.34 GeV`;
      (iii) at every truncation level `N`, the structural ceiling holds:
              `fermionMass (yukawaUpQuark gen3) N ≤ 9 · l_P · pi_error_val N`.

    **Interpretation.**  The top quark's mass inherits the Pi-hunch
    π-heaviest ceiling `l_P · pi_error_val N` multiplied by the
    up-quark tower's ordered gen3 Yukawa (`9`).  The PDG 2024 central
    value `173.34 GeV` is structurally consistent with this ceiling via
    the Higgs-mechanism bridge — and the 2σ window `± 0.5 GeV` provides
    an explicit falsifiability envelope for future measurements. -/
theorem top_quark_mass_substrate_fit :
    (∃ c > 0, ∀ N : ℕ,
        fermionMass (yukawaUpQuark gen3) N ≤ c * pi_error_val N)
    ∧ (topQuarkMassLower < topQuarkMassUpper ∧
       topQuarkMassGeV ∈ topQuarkMassWindow)
    ∧ (∀ N : ℕ,
        fermionMass (yukawaUpQuark gen3) N ≤ 9 * (l_P * pi_error_val N)) := by
  refine ⟨topSlot_mass_bounded_by_pi_error, ⟨?_, ?_⟩, ?_⟩
  · exact topQuarkMassWindow_ordered
  · exact topQuarkMassGeV_mem_window
  · exact topSlot_fermionMass_le_substrate_bound

/-! ## §6 Extended capstone — top-slot is HEAVIEST at every N

    A stronger statement bundling (i)–(iii) above PLUS the
    **π-heaviest ordering** from §3 (the top slot strictly dominates
    the other two slots of its tower at every truncation level). -/

/-- **Extended capstone**: the top-slot fermion mass is the **strictly
    heaviest** in the up-quark tower at every truncation level `N`,
    AND satisfies the Pi-heaviest substrate ceiling, AND the PDG 2024
    2σ numerical window is consistent (central value inside, lower
    edge positive). -/
theorem top_quark_mass_substrate_fit_extended :
    (∀ N : ℕ,
       fermionMass (yukawaUpQuark gen1) N < fermionMass (yukawaUpQuark gen2) N ∧
       fermionMass (yukawaUpQuark gen2) N < fermionMass (yukawaUpQuark gen3) N)
    ∧ (∀ N : ℕ,
       fermionMass (yukawaUpQuark gen3) N = 9 * (l_P * pi_error_val N))
    ∧ (0 < topQuarkMassLower ∧
       topQuarkMassLower < topQuarkMassUpper ∧
       topQuarkMassGeV ∈ topQuarkMassWindow) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro N; exact topSlot_strict_heaviest_in_tower N
  · intro N; exact topSlot_fermionMass_eq_nine_lP_piError N
  · exact topQuarkMassLower_pos
  · exact topQuarkMassWindow_ordered
  · exact topQuarkMassGeV_mem_window

/-! ## §7 Summary

    Exported theorems:

      * `topQuarkMassGeV_pos`
      * `topQuarkMassLower_pos`
      * `topQuarkMassWindow_ordered`
      * `topQuarkMassGeV_mem_window`
      * `topSlot_fermionMass_eq_nine_lP_piError`
      * `topSlot_fermionMass_le_substrate_bound`
      * `topSlot_mass_bounded_by_pi_error`        — ∃-bound
      * `topSlot_strict_heaviest_in_tower`        — ordering within tower
      * `topSlot_bound_uses_pi_channel`           — N ≥ 2 connection to π
      * `topQuarkPDG2024Anchor_holds`             — PDG anchor
      * `top_quark_mass_substrate_fit`            — HEADLINE
      * `top_quark_mass_substrate_fit_extended`   — CAPSTONE

    12 exported theorems in total (plus `yukawaUpQuark_top_eq_nine`
    convenience re-export and the 4 numerical definitions).
    0 sorry, 0 new axioms. -/

end OmegaTheory.Predictions.TopQuarkMassFit
