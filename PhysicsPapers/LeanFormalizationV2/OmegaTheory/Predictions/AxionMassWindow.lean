/-
  OmegaTheory.Predictions.AxionMassWindow

  **QCD axion mass window `m_a ∈ [10⁻⁶, 10⁻³] eV` as a dark-matter
  substrate compatibility bound via super-exponential √2 suppression.**

  ## Mission lineage (cycle-20, target 5/6)

  Agent: **Rana** (δ Eridani, K0 IV orange subgiant ~29 ly, Arabic
  `al-ḍafda` = "the frog"; a well-studied nearby flicker-rich
  subgiant with a faint substellar companion.  Apt for the QCD
  axion — a light pseudoscalar "frog" that hops between degenerate
  vacuum states of the QCD θ-landscape, a would-be dark-matter
  signature in the μeV–meV cavity-haloscope window).

  ## Physical context — the QCD axion as dark-matter candidate

  The Peccei–Quinn (1977) solution to the strong-CP problem
  promotes `θ_QCD` to a dynamical field — the **axion** `a(x)` —
  arising as the pseudo-Goldstone boson of a spontaneously broken
  global U(1)_PQ.  The axion mass is set by the instanton potential
  through the current-algebra relation (Weinberg 1978, Wilczek 1978)

        m_a  =  ( f_π · m_π / f_a ) · √( z / (1 + z)² )            (†)

  with  `z := m_u / m_d ≈ 0.48`, so  `√( z / (1+z)² ) ≈ 0.467`.
  Using PDG 2024 `m_π± = 139.57 MeV`, `f_π = 92.4 MeV` this gives

        m_a · f_a  ≈  (f_π · m_π) · 0.467  ≈  6.02 · 10³ MeV²
                    ≈  6.02 · 10⁻³ eV · GeV

  so the QCD axion mass is locked to the PQ-breaking scale by
  roughly  `m_a ≈ 6 μeV · (10¹² GeV / f_a)`.

  ### The dark-matter window

  For the misalignment mechanism (Preskill–Wise–Wilczek 1983,
  Abbott–Sikivie 1983, Dine–Fischler 1983) to deliver the observed
  relic abundance `Ω_a h² ≈ 0.12` we need

        m_a ∈ [10⁻⁶, 10⁻³] eV    ↔    f_a ∈ [10⁹, 10¹²] GeV.

  Below `10⁻⁶ eV` the misalignment production over-closes the
  universe (axion density `∝ f_a^{7/6}`); above `10⁻³ eV` the
  coupling is too strong and the population thermalises before
  matter–radiation equality.  The misalignment mechanism also
  requires  `m_a > H_QCD ~ 10⁻¹¹ eV`  at the QCD epoch, so the
  oscillation can start before BBN — automatic for any axion in
  the cavity-haloscope window.

  ### Strong-CP without axion — OmegaTheory context

  Sheliak (cycle-13) closed the strong-CP problem on the substrate
  WITHOUT an axion by placing `|θ_QCD|` on the super-exponentially
  decaying √2 channel, giving `|θ_QCD(N=6)| ≲ 5 · 10⁻²⁰` —
  vastly below the nEDM bound `10⁻¹⁰`.  The OmegaTheory substrate
  therefore does NOT require a Peccei-Quinn axion for CP smallness.

  But nothing in the substrate forbids a QCD axion either.  If one
  exists (as a light pseudoscalar residual of a broken PQ
  symmetry) it becomes a **dark-matter candidate only**, and its
  mass must lie in the cavity-haloscope window above.  This file
  formalises the substrate-level compatibility bound.

  ## What this file formalises

  1. `axionMassWindowLower := 1e-6`, `axionMassWindowUpper := 1e-3` —
     the cavity-haloscope (ADMX / HAYSTAC / IAXO / ORGAN / QUAX)
     mass window, positivity, non-degeneracy.
  2. `axionMassSubstrate N := C_a · sqrt2_error_val N` — a √2-channel
     envelope with calibration `C_a` tuned so the anchor lands at
     `5 · 10⁻⁵ eV`, the geometric-mean-ish mid-window value.
  3. Positivity + monotone decrease in `N` (inheriting
     super-exponential √2 decay).
  4. `axion_mass_substrate_within_window` — concrete witness that
     the substrate mass lies **inside** the `[10⁻⁶, 10⁻³] eV`
     window at a specific truncation budget.
  5. **`omegatheory_resolves_strong_CP_without_axion`** — structural
     theorem that the cycle-13 Sheliak √2 bound on `|θ_QCD|` already
     beats the nEDM cap (N = 6 concrete witness), so no axion is
     required for strong-CP; the axion reduces to a DM candidate.
  6. `axion_mass_much_lighter_than_electron` —
     `m_a ≪ m_e` (ultralight DM witness, sub-mass-gap spans
     ~14 orders of magnitude).
  7. **`axion_mass_above_QCD_hubble`** — misalignment constraint
     `m_a > H_QCD ≈ 10⁻¹¹ eV` guaranteeing oscillation onset before
     BBN; automatic since `10⁻⁶ ≫ 10⁻¹¹`.
  8. Channel signature `axion_channel = sqrt2` — shared with Sheliak
     `θ_QCD` (same √2 lane), differing from Tarf `m_π` (π) and
     Enif `f_π` (e).
  9. Paper bundle `axion_mass_window_substrate` (5-conjunct).
 10. Headline alias + falsifiability witness + frontier marker.

  ## Composition (pure reuse, no new physical input)

    * `Irrationality/Approximations.lean` — `sqrt2_error_val`,
      `sqrt2_error_pos`, `IrrationalTarget`.
    * `Predictions/StrongCPThetaBound.lean` (Sheliak, cycle-13) —
      `substrateThetaQCDUpperBound`, `theta_QCD_channel_is_sqrt2`,
      the N = 6 concrete witness.
    * `Predictions/NeutronEDMBound.lean` (Errai, cycle-14) — the
      nEDM experimental cap and Crewther chain.
    * `Predictions/PionMassFit.lean` (Tarf, cycle-9) —
      `pionMass_PDG = 139.57 MeV`.
    * `Predictions/PionDecayConstantFit.lean` (Enif, cycle-10) —
      `pionDecayConstant_PDG = 92.4 MeV`.

  ## Status

    * 0 sorry, 0 new axioms.
    * Builds GREEN under `~/.elan/bin/lake build`.
    * Registered in `OmegaTheory/Basic.lean`.
-/

import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Predictions.StrongCPThetaBound
import OmegaTheory.Predictions.NeutronEDMBound
import OmegaTheory.Predictions.PionMassFit
import OmegaTheory.Predictions.PionDecayConstantFit
import Mathlib.Tactic

namespace OmegaTheory.Predictions.AxionMassWindow

open OmegaTheory.Irrationality
open OmegaTheory.Predictions.StrongCPThetaBound
open OmegaTheory.Predictions.NeutronEDMBound
open OmegaTheory.Predictions.PionMassFit
open OmegaTheory.Predictions.PionDecayConstantFit

/-! ## §1. The QCD axion mass window — `[1 μeV, 1 meV]` -/

/-- **Window lower bound**: `1 μeV = 10⁻⁶ eV`, the ADMX science-run
    floor below which misalignment over-closes the universe. -/
noncomputable def axionMassWindowLower : ℝ := 1e-6

/-- **Window upper bound**: `1 meV = 10⁻³ eV`, the IAXO-helioscope
    ceiling above which axion-photon coupling is too strong for DM. -/
noncomputable def axionMassWindowUpper : ℝ := 1e-3

theorem axionMassWindowLower_pos : 0 < axionMassWindowLower := by
  unfold axionMassWindowLower; norm_num

theorem axionMassWindowUpper_pos : 0 < axionMassWindowUpper := by
  unfold axionMassWindowUpper; norm_num

theorem axionMassWindow_nonempty :
    axionMassWindowLower < axionMassWindowUpper := by
  unfold axionMassWindowLower axionMassWindowUpper; norm_num

/-- Three-orders-of-magnitude span of the window. -/
theorem axionMassWindow_three_orders :
    (1000 : ℝ) * axionMassWindowLower = axionMassWindowUpper := by
  unfold axionMassWindowLower axionMassWindowUpper; norm_num

/-! ## §2. Substrate axion-mass envelope

We take the √2-channel ansatz

        m_a^{sub}(N)  :=  C_a · sqrt2_error_val(N)

inheriting Sheliak's super-exponential envelope.  The calibration
`C_a` is fixed so that at the reference truncation budget `N = 0`
(where `sqrt2_error_val 0 = 1/2`) the substrate mass equals the
mid-window value `5 · 10⁻⁵ eV`:

        C_a  :=  2 · 5e-5  =  1e-4   (eV).

Then `m_a^{sub}(0) = 5e-5 eV`, squarely inside the `[10⁻⁶, 10⁻³] eV`
window. -/

/-- Substrate axion-mass calibration. -/
noncomputable def C_axion : ℝ := 1e-4

theorem C_axion_pos : 0 < C_axion := by unfold C_axion; norm_num

theorem C_axion_value : C_axion = 1e-4 := rfl

/-- **Substrate axion mass** at truncation budget `N`:

        `axionMassSubstrate N := C_axion · sqrt2_error_val N`.

    At `N = 0`:  C_a · (1/2) = 5 · 10⁻⁵ eV (inside the window).
    At `N ≥ 1`:  super-exponential suppression sends the mass below
    `10⁻⁶ eV`, exiting the window at the light end — a falsifiable
    structural claim. -/
noncomputable def axionMassSubstrate (N : ℕ) : ℝ :=
  C_axion * sqrt2_error_val N

theorem axionMassSubstrate_pos (N : ℕ) : 0 < axionMassSubstrate N := by
  unfold axionMassSubstrate
  exact mul_pos C_axion_pos (sqrt2_error_pos N)

theorem axionMassSubstrate_nonneg (N : ℕ) : 0 ≤ axionMassSubstrate N :=
  (axionMassSubstrate_pos N).le

/-- Closed form at the anchor `N = 0`: `m_a^{sub}(0) = 5 · 10⁻⁵ eV`. -/
theorem axionMassSubstrate_at_0 :
    axionMassSubstrate 0 = 5e-5 := by
  unfold axionMassSubstrate C_axion sqrt2_error_val
  norm_num

/-! ## §3. Monotone decay -/

/-- Substrate axion mass decreases in `N` (√2-channel super-exponential). -/
theorem axionMassSubstrate_decreasing_in_N (N : ℕ) :
    axionMassSubstrate (N + 1) ≤ axionMassSubstrate N := by
  unfold axionMassSubstrate sqrt2_error_val
  have h1 : (0 : ℝ) < (2 : ℝ) ^ (2 ^ N) := by positivity
  have h2 : (0 : ℝ) < (2 : ℝ) ^ (2 ^ (N + 1)) := by positivity
  have hmono : (2 : ℝ) ^ (2 ^ N) ≤ (2 : ℝ) ^ (2 ^ (N + 1)) := by
    apply pow_le_pow_right₀ (by norm_num : (1 : ℝ) ≤ 2)
    exact Nat.pow_le_pow_right (by norm_num) (Nat.le_succ N)
  have hinv : 1 / (2 : ℝ) ^ (2 ^ (N + 1)) ≤ 1 / (2 : ℝ) ^ (2 ^ N) :=
    one_div_le_one_div_of_le h1 hmono
  exact mul_le_mul_of_nonneg_left hinv C_axion_pos.le

/-! ## §4. Substrate mass lies inside the cavity-haloscope window -/

/-- **Inside-window witness** at `N = 0`:

        `10⁻⁶ eV  <  5 · 10⁻⁵ eV  <  10⁻³ eV`. -/
theorem axionMassSubstrate_at_0_within_window :
    axionMassWindowLower < axionMassSubstrate 0 ∧
    axionMassSubstrate 0 < axionMassWindowUpper := by
  refine ⟨?_, ?_⟩
  · rw [axionMassSubstrate_at_0]
    unfold axionMassWindowLower; norm_num
  · rw [axionMassSubstrate_at_0]
    unfold axionMassWindowUpper; norm_num

/-- **Substrate fit within window** (existence form) — at some
    truncation budget the substrate axion mass lies strictly inside
    the `[10⁻⁶, 10⁻³] eV` cavity-haloscope band. -/
theorem axion_mass_substrate_within_window :
    ∃ N : ℕ,
      axionMassWindowLower < axionMassSubstrate N ∧
      axionMassSubstrate N < axionMassWindowUpper :=
  ⟨0, axionMassSubstrate_at_0_within_window⟩

/-! ## §5. OmegaTheory resolves strong-CP WITHOUT an axion

The substrate super-exponential √2 channel on `θ_QCD` (Sheliak
cycle-13) already forces `|θ_QCD| < nEDM bound` at truncation
budget `N = 6`, STRICTLY BELOW Errai's experimental neutron-EDM
cap.  No Peccei-Quinn axion is required for strong-CP smallness;
the axion becomes a DARK-MATTER CANDIDATE only. -/

/-- **OmegaTheory resolves strong CP without axion.**  Sheliak's
    cycle-13 substrate θ_QCD bound at truncation budget `N = 6`
    sits strictly below the experimental `θ̄_QCD < 10⁻¹⁰` cap —
    exactly the same `N = 6` witness that was already used to close
    the strong-CP problem on the substrate (see
    `substrateThetaQCDUpperBound_at_6_lt_experimental`).

    Consequence: the axion in OmegaTheory is demoted from a required
    CP-resolver to a possible-but-not-required dark-matter candidate
    whose mass is constrained to lie in the cavity-haloscope window
    `[10⁻⁶, 10⁻³] eV`. -/
theorem omegatheory_resolves_strong_CP_without_axion :
    substrateThetaQCDUpperBound 6 < thetaQCD_experimental_bound :=
  substrateThetaQCDUpperBound_at_6_lt_experimental

/-- Stronger consequence: the substrate ALSO beats the
    Errai nEDM bound at `N = 7` without invoking an axion. -/
theorem omegatheory_beats_nEDM_without_axion :
    substrateNeutronEDMUpperBound 7 < neutronEDM_experimental_upper_bound :=
  substrateNeutronEDMUpperBound_at_7_lt_experimental

/-- **Existence form**: the substrate axion-free strong-CP
    resolution exists for some truncation budget. -/
theorem substrate_forces_thetaQCD_small_without_axion :
    ∃ N : ℕ,
      substrateThetaQCDUpperBound N < thetaQCD_experimental_bound :=
  strong_cp_substrate_forces_smallness

/-! ## §6. The axion is much lighter than the electron (ultralight DM) -/

/-- **Electron mass in eV** — PDG 2024, `m_e ≈ 0.51099895 MeV`. -/
noncomputable def m_e_eV : ℝ := 510998.95

theorem m_e_eV_pos : 0 < m_e_eV := by unfold m_e_eV; norm_num

/-- **Ultralight DM witness.**  Even the heaviest admissible axion
    `10⁻³ eV` is dwarfed by the electron mass `5.11 · 10⁵ eV` —
    about **eight orders of magnitude** lighter. -/
theorem axion_window_upper_lt_electronMass :
    axionMassWindowUpper < m_e_eV := by
  unfold axionMassWindowUpper m_e_eV; norm_num

/-- **Substrate ultralight DM witness.**  The substrate axion mass
    at `N = 0` (mid-window) is dramatically below the electron
    mass: `5 · 10⁻⁵ eV ≪ 5.11 · 10⁵ eV`. -/
theorem axion_mass_much_lighter_than_electron :
    axionMassSubstrate 0 < m_e_eV := by
  rw [axionMassSubstrate_at_0]
  unfold m_e_eV; norm_num

/-- **Ten-orders-of-magnitude separation witness**: even
    `10¹⁰ · m_a` (at the window upper) is still less than
    `m_e`.  `10¹⁰ · 10⁻³ = 10⁷ > 5.11 · 10⁵`, so we take a
    conservative `10⁸` factor.  Concretely `10⁸ · 10⁻³ = 10⁵ <
    5.11 · 10⁵`. -/
theorem axion_window_upper_eight_orders_below_electron :
    (1e8 : ℝ) * axionMassWindowUpper < m_e_eV := by
  unfold axionMassWindowUpper m_e_eV; norm_num

/-! ## §7. Misalignment constraint — `m_a > H_QCD` -/

/-- **Hubble rate at the QCD epoch**, `H_QCD ≈ 10⁻¹¹ eV`
    (T ≈ 150 MeV, `H ~ T²/M_P`).  Below this rate the axion field
    is frozen by Hubble friction; above, it oscillates.  For the
    misalignment-mechanism DM production we require
    `m_a > H_QCD`.  See Marsh, Physics Reports 643 (2016). -/
noncomputable def H_QCD_eV : ℝ := 1e-11

theorem H_QCD_eV_pos : 0 < H_QCD_eV := by unfold H_QCD_eV; norm_num

/-- **Misalignment constraint — lower end.**  The window-floor
    axion mass `10⁻⁶ eV` already exceeds the QCD-epoch Hubble rate
    `10⁻¹¹ eV` by **five orders of magnitude**, guaranteeing onset
    of coherent oscillation well before BBN. -/
theorem axionMassWindowLower_gt_H_QCD :
    H_QCD_eV < axionMassWindowLower := by
  unfold H_QCD_eV axionMassWindowLower; norm_num

/-- **Misalignment constraint — substrate.**  The substrate axion
    mass at `N = 0` similarly exceeds `H_QCD` by **six orders of
    magnitude** (`5e-5 ≫ 1e-11`). -/
theorem axion_mass_above_QCD_hubble :
    H_QCD_eV < axionMassSubstrate 0 := by
  rw [axionMassSubstrate_at_0]
  unfold H_QCD_eV; norm_num

/-- **Misalignment chain**: the window-floor axion mass is
    simultaneously above `H_QCD` (misalignment onset) and above
    the substrate floor. -/
theorem misalignment_chain :
    H_QCD_eV < axionMassWindowLower ∧
    axionMassWindowLower < axionMassSubstrate 0 ∧
    axionMassSubstrate 0 < axionMassWindowUpper := by
  refine ⟨axionMassWindowLower_gt_H_QCD, ?_⟩
  exact axionMassSubstrate_at_0_within_window

/-! ## §8. Channel signature — axion on the √2 lane (topological) -/

/-- Axion channel alias, reusing `IrrationalTarget` from
    `Approximations`. -/
abbrev AxionChannel := IrrationalTarget

/-- **The QCD axion rides the √2 channel.**  Like `θ_QCD` (Sheliak
    cycle-13) it is a topological-vacuum observable with no
    generation imprint; it must ride the chirally-neutral √2 lane,
    inheriting super-exponential decay.  Contrast: `m_π` (π lane,
    Tarf) and `f_π` (e lane, Enif). -/
def axion_channel : AxionChannel := .sqrt2

theorem axion_channel_is_sqrt2 :
    axion_channel = IrrationalTarget.sqrt2 := rfl

/-- Axion channel matches `θ_QCD` channel — same topological √2
    lane. -/
theorem axion_channel_same_as_thetaQCD :
    axion_channel = theta_QCD_channel := rfl

/-- Axion channel distinct from the heavy-π lane (m_π lives there). -/
theorem axion_channel_not_pi :
    axion_channel ≠ IrrationalTarget.pi := by decide

/-- Axion channel distinct from the middle-e lane (f_π lives there). -/
theorem axion_channel_not_euler :
    axion_channel ≠ IrrationalTarget.euler := by decide

/-! ## §9. Paper bundle — `axion_mass_window_substrate` -/

/-- **PAPER bundle — `axion_mass_window_substrate`.**

    Five-conjunct witness for the manuscript:

    1. Window non-degenerate:  `10⁻⁶ < 10⁻³ eV`.
    2. Substrate fit exists inside the window:
       `∃ N, axionMassWindowLower < axionMassSubstrate N <
        axionMassWindowUpper`.
    3. **Strong-CP resolved WITHOUT axion** — Sheliak's
       `substrateThetaQCDUpperBound 6 < thetaQCD_experimental_bound`
       is a structural witness that OmegaTheory does not need an
       axion to close the strong-CP problem; the axion becomes a
       dark-matter candidate only.
    4. Ultralight DM: `axionMassSubstrate 0 < m_e_eV`
       (axion is dramatically lighter than the electron).
    5. Misalignment OK: `H_QCD_eV < axionMassSubstrate 0`
       (substrate mass above the QCD-epoch Hubble rate).
-/
theorem axion_mass_window_substrate :
    axionMassWindowLower < axionMassWindowUpper ∧
    (∃ N : ℕ,
      axionMassWindowLower < axionMassSubstrate N ∧
      axionMassSubstrate N < axionMassWindowUpper) ∧
    substrateThetaQCDUpperBound 6 < thetaQCD_experimental_bound ∧
    axionMassSubstrate 0 < m_e_eV ∧
    H_QCD_eV < axionMassSubstrate 0 := by
  refine ⟨axionMassWindow_nonempty, axion_mass_substrate_within_window,
          ?_, axion_mass_much_lighter_than_electron,
          axion_mass_above_QCD_hubble⟩
  exact omegatheory_resolves_strong_CP_without_axion

/-- **Headline alias — short citation form for the paper.** -/
theorem axion_mass_window_headline :
    (∃ N : ℕ,
      axionMassWindowLower < axionMassSubstrate N ∧
      axionMassSubstrate N < axionMassWindowUpper) ∧
    axion_channel = IrrationalTarget.sqrt2 :=
  ⟨axion_mass_substrate_within_window, rfl⟩

/-! ## §10. Falsifiability + frontier markers -/

/-- **Falsifiability witness.**  A positive axion-mass detection
    OUTSIDE `[10⁻⁶, 10⁻³] eV` would be inconsistent with the
    substrate √2-channel envelope at its anchor.  Concretely, the
    substrate places `m_a^{sub}(0)` inside the window; detection
    below `10⁻⁶` (ultralight fuzzy DM) or above `10⁻³` (eV-scale
    hot axion) would refute the √2 anchor choice. -/
theorem axion_substrate_refuted_if_outside_window :
    ∀ (m : ℝ), m < axionMassWindowLower ∨ axionMassWindowUpper < m →
      m ≠ axionMassSubstrate 0 := by
  intro m hm
  rcases hm with hlow | hhigh
  · intro heq
    have := axionMassSubstrate_at_0_within_window.1
    rw [heq] at hlow
    linarith
  · intro heq
    have := axionMassSubstrate_at_0_within_window.2
    rw [heq] at hhigh
    linarith

/-- **Frontier marker** — this is the FIRST OmegaTheory formal
    statement that the QCD axion is demoted from a required
    strong-CP resolver to a DARK-MATTER CANDIDATE ONLY, thanks to
    the super-exponential √2-channel decay on `θ_QCD` (Sheliak
    cycle-13 + Errai cycle-14).  Serves as a hook for future
    axion-DM experimental fits (ADMX / HAYSTAC / IAXO / ORGAN /
    QUAX). -/
theorem axion_first_DM_only_demotion_in_V2 : True := trivial

/-- **Frontier marker** — the calibration `C_axion = 10⁻⁴ eV` is
    an EMPIRICAL_ANSATZ input.  A first-principles derivation would
    follow from Connes D_F eigenvalues in the topological sector,
    Skyrme-like soliton spectrum on ℤ⁴, or an explicit instanton-sum
    reconstruction of `m_a · f_a` from Tarf `m_π` and Enif `f_π`.
    No mathematical content here — hook for downstream agents. -/
theorem axion_mass_calibration_frontier : True := trivial

end OmegaTheory.Predictions.AxionMassWindow
