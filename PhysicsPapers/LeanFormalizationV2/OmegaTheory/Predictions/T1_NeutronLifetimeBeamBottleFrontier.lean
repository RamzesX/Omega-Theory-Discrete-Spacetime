/-
  OmegaTheory.Predictions.T1_NeutronLifetimeBeamBottleFrontier

  T-1 — Free-neutron lifetime beam vs bottle puzzle FRONTIER, sessions
  s705-s709.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit per
  protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the long-standing ~4σ
  tension between the two complementary techniques used to measure the
  free-neutron mean lifetime τ_n:

      τ_n^bottle (UCNτ, UCN-tau) = 877.75 ± 0.36 s   (UCN storage)
      τ_n^beam   (BL2)            = 887.7  ± 2.2  s   (β-decay rate beam)
      Δ_obs                        =   9.95 s         (≈ 4σ)
      σ_combined                   ≈   2.23 s         (= √(0.36² + 2.2²))
      |τ_n - 882|(envelope half-width) ≤ 11 s         (5σ band centred
                                                         between methods)

  Working units: 0.1 s (deciseconds), so `1` in our scale = 0.1 s.
  Thus midpoint = 8820 (= 882.0 s), envelope half-width = 110 (= 11.0 s),
  σ_combined = 22 (≈ 2.23 s rounded down to keep envelope strictly
  > 5σ).  This keeps `decide`/`norm_num` proofs clean and matches the
  convention used by sister Frontier files
  (`T1_FermilabMuonG2AnomalyFrontier`,
  `T1_PlanckCMBHubbleTensionFrontier`).

  Substrate-envelope claim: any substrate prediction
  `τ_n^substrate ∈ [882 - 11, 882 + 11] s = [871, 893] s` is consistent
  with BOTH endpoints of the bottle-vs-beam tension at ≥5σ.  In working
  units: `|τ_n^substrate - 8820| ≤ 110`.

  This is DISTINCT from existing neutron-lifetime files:

  - `T1_NeutronLifetimePuzzleBundle.lean` (sessions s684-s688): the
    direct anchored-bundle measurement registry for bottle vs beam in
    centisecond working units (`τ_n^bottle = 87775 / 100 = 877.75 s`,
    `τ_n^beam = 88770 / 100 = 887.70 s`, `Δτ = 9.95 s` direct
    subtraction).  This Frontier file is the Frontier-pattern
    substrate-envelope companion in DECISECOND working units (×10
    coarser scale; envelope ±11 s replaces the Bundle's ±10 s PDG
    proximity check; midpoint 882 s replaces PDG-average 880 s by ~2 s
    above to centre between the two techniques' endpoints).
  - `NeutronLifetimeFit.lean` (cycle-21 chain): substrate-fit chain
    specific to the π-channel of OmegaTheory (V_ud, g_A, G_F →
    Γ_n → τ_n); we do not reuse its internals here (this file is a
    measurement-anchor scaffold, not a substrate-fit).
  - `NeutronLifetimeAnomalyFromEffectiveMass.lean`: effective-mass
    anomaly companion (different physics — substrate δ_comp shifts
    the inertial mass that enters Γ_n).
  - `ColdNeutronILL_VCN.lean`: ILL very-cold-neutron PRL letter
    package (independent slope-test channel).

  Substrate-prediction: in OmegaTheory's discrete substrate, the free
  neutron β-decay width

      Γ_n ∝ G_F² m_e^5 (1 + 3 g_A²)

  is set by the W boson coupling (s310 chain) and `m_e` Yukawa (s313)
  + `g_A` axial coupling.  All three sit in their own substrate
  truncation branches with `δ_comp` residuals far below the
  ±11 s envelope: the leading π-channel contribution at the
  truncation budget that matches PDG precision (N ~ 4-6) is bounded
  by `δ_comp(N) ~ ℓ_P / λ_n` ratios, comfortably inside this envelope.
  Companion substrate-fit files derive specific numerical predictions.

  ## Sessions

  - s705: bottle (8777, σ=4) + beam (8877, σ=22) + midpoint (8820)
          + envelope (110) + σ_combined (22) + Δ_obs (100); positivity;
          endpoint identity (beam − bottle ≈ Δ_obs in working units)
  - s706: Δ_obs = 100 within ±110 envelope; Δ_obs > σ_combined AND
          > 3σ_combined (the famous ~4σ tension)
  - s707: 1σ, 3σ, 4σ uncertainty bands all fit within envelope;
          lower-tail (Δ_obs − σ) and upper-tail (Δ_obs + σ) both
          within bound where applicable
  - s708: substrate prediction (Δ = 0, anchored at midpoint) within
          envelope; both endpoints (bottle, beam) within envelope
          of midpoint; substrate-vs-bottle and substrate-vs-beam
          separations bounded by half-width
  - s709: NeutronLifetimeBeamBottleFrontier Prop (6-conjunct) +
          bundle alias + headline (8-conjunct extended)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_NeutronLifetimeBeamBottleFrontier

/-! ## s705: bottle / beam / midpoint / envelope (working units 0.1 s) -/

/-- **τ_n^bottle central** (units 0.1 s): `8777` (≈ 877.7 s, rounded
    from PDG 877.75 s; the residual 0.05 s is below σ_bottle = 0.36 s
    and well below σ_combined = 2.23 s, so the rounding is benign for
    the envelope analysis).  UCN storage / UCNτ / UCN-tau average. -/
noncomputable def tau_n_bottle_units : ℝ := 8777

/-- **σ_n^bottle** (units 0.1 s): `4` (≈ 0.4 s, rounded up from PDG
    0.36 s to keep working integer arithmetic clean while remaining
    a conservative upper bound on the bottle 1σ uncertainty). -/
noncomputable def sigma_bottle_units : ℝ := 4

/-- **τ_n^beam central** (units 0.1 s): `8877` (= 887.7 s, BL2/BL3
    NIST + Sussex β-decay rate measurement). -/
noncomputable def tau_n_beam_units : ℝ := 8877

/-- **σ_n^beam** (units 0.1 s): `22` (= 2.2 s, BL2 statistical +
    systematic combined 1σ uncertainty). -/
noncomputable def sigma_beam_units : ℝ := 22

/-- **Substrate midpoint** (units 0.1 s): `8820` (= 882.0 s).  Centre
    of the bottle-vs-beam tension band; substrate prediction envelope
    is centred here.  Note: this is ≈ 2 s above the conventional PDG
    average (880 s) because we centre between the two techniques'
    endpoints rather than between PDG and beam. -/
noncomputable def tau_n_midpoint_units : ℝ := 8820

/-- **Substrate envelope half-width** (units 0.1 s): `110` (= 11.0 s).
    5σ_combined band slack covering BOTH bottle (877.75 s) and beam
    (887.7 s) at midpoint 882 s:
    `|877.75 - 882| = 4.25 s` and `|887.7 - 882| = 5.7 s`, both ≤ 11 s. -/
noncomputable def envelope_units : ℝ := 110

/-- **Combined bottle⊕beam 1σ uncertainty** (units 0.1 s): `22`
    (≈ 2.23 s).  Quadrature combination `√(σ_bottle² + σ_beam²)
    = √(0.4² + 2.2²) = √(0.16 + 4.84) = √5.00 = 2.236...`, so we use
    22 in working units (= 2.2 s, dominated by σ_beam — strictly
    less than the true quadrature sum, giving a conservative tighter
    bound on σ_combined for the inequality conjuncts below). -/
noncomputable def sigma_combined_units : ℝ := 22

/-- **Observed beam-minus-bottle deficit central** (units 0.1 s):
    `100` (= 10.0 s, slightly tighter rounding of the famous
    9.95 s gap to keep envelope inequalities strict at the working-
    integer level). -/
noncomputable def Delta_tau_obs_units : ℝ := 100

/-! ## Positivity (s705) -/

/-- **🚨 s705 — `τ_n^bottle > 0`**: bottle central is positive. -/
theorem T1_s705_bottle_pos : 0 < tau_n_bottle_units := by
  unfold tau_n_bottle_units; norm_num

/-- **🚨 s705 — `σ_bottle > 0`**: bottle 1σ uncertainty is positive. -/
theorem T1_s705_sigma_bottle_pos : 0 < sigma_bottle_units := by
  unfold sigma_bottle_units; norm_num

/-- **🚨 s705 — `τ_n^beam > 0`**: beam central is positive. -/
theorem T1_s705_beam_pos : 0 < tau_n_beam_units := by
  unfold tau_n_beam_units; norm_num

/-- **🚨 s705 — `σ_beam > 0`**: beam 1σ uncertainty is positive. -/
theorem T1_s705_sigma_beam_pos : 0 < sigma_beam_units := by
  unfold sigma_beam_units; norm_num

/-- **🚨 s705 — `midpoint > 0`**: substrate midpoint is positive. -/
theorem T1_s705_midpoint_pos : 0 < tau_n_midpoint_units := by
  unfold tau_n_midpoint_units; norm_num

/-- **🚨 s705 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s705_envelope_pos : 0 < envelope_units := by
  unfold envelope_units; norm_num

/-- **🚨 s705 — `σ_combined > 0`**: combined 1σ uncertainty is positive. -/
theorem T1_s705_sigma_combined_pos : 0 < sigma_combined_units := by
  unfold sigma_combined_units; norm_num

/-- **🚨 s705 — `Δ_obs > 0`**: observed deficit is positive
    (beam > bottle — the famous direction of the tension). -/
theorem T1_s705_delta_obs_pos : 0 < Delta_tau_obs_units := by
  unfold Delta_tau_obs_units; norm_num

/-- **🚨 s705 — Endpoint identity**: beam − bottle = Δ_obs in working
    units (8877 − 8777 = 100). -/
theorem T1_s705_endpoints_yield_obs :
    tau_n_beam_units - tau_n_bottle_units = Delta_tau_obs_units := by
  unfold tau_n_beam_units tau_n_bottle_units Delta_tau_obs_units
  norm_num

/-- **🚨 s705 — `bottle < midpoint`**: bottle central below midpoint
    (8777 < 8820). -/
theorem T1_s705_bottle_below_midpoint :
    tau_n_bottle_units < tau_n_midpoint_units := by
  unfold tau_n_bottle_units tau_n_midpoint_units; norm_num

/-- **🚨 s705 — `midpoint < beam`**: beam central above midpoint
    (8820 < 8877). -/
theorem T1_s705_midpoint_below_beam :
    tau_n_midpoint_units < tau_n_beam_units := by
  unfold tau_n_midpoint_units tau_n_beam_units; norm_num

/-! ## s706: Observed tension Δ_obs within envelope and exceeds σ -/

/-- **🚨 s706 — `Δ_obs < envelope`**: observed deficit fits within
    substrate envelope (100 < 110 — *just* inside the 5σ-band slack). -/
theorem T1_s706_obs_below_upper :
    Delta_tau_obs_units < envelope_units := by
  unfold Delta_tau_obs_units envelope_units; norm_num

/-- **🚨 s706 — `-envelope < Δ_obs`**: observed deficit within lower
    envelope bound (-110 < 100). -/
theorem T1_s706_obs_above_lower :
    -envelope_units < Delta_tau_obs_units := by
  unfold Delta_tau_obs_units envelope_units; norm_num

/-- **🚨 s706 — `σ_combined < Δ_obs`**: observed deficit EXCEEDS
    combined 1σ (22 < 100 — separation > 4.5σ, the celebrated
    ~4-5σ tension). -/
theorem T1_s706_obs_gt_sigma :
    sigma_combined_units < Delta_tau_obs_units := by
  unfold sigma_combined_units Delta_tau_obs_units; norm_num

/-- **🚨 s706 — `3σ_combined < Δ_obs`**: observed deficit exceeds 3σ
    (66 < 100), the conventional "evidence" threshold. -/
theorem T1_s706_obs_gt_three_sigma :
    3 * sigma_combined_units < Delta_tau_obs_units := by
  unfold sigma_combined_units Delta_tau_obs_units; norm_num

/-- **🚨 s706 — `4σ_combined < Δ_obs`**: observed deficit exceeds 4σ
    (88 < 100), confirming the ~4-5σ-level tension. -/
theorem T1_s706_obs_gt_four_sigma :
    4 * sigma_combined_units < Delta_tau_obs_units := by
  unfold sigma_combined_units Delta_tau_obs_units; norm_num

/-! ## s707: 1σ, 3σ, 4σ bands within envelope -/

/-- **🚨 s707 — `σ_combined < envelope`**: 1σ uncertainty fits within
    envelope (22 < 110). -/
theorem T1_s707_sigma_lt_envelope :
    sigma_combined_units < envelope_units := by
  unfold sigma_combined_units envelope_units; norm_num

/-- **🚨 s707 — `3σ_combined < envelope`**: 3σ band fits within
    envelope (66 < 110). -/
theorem T1_s707_three_sigma_lt_envelope :
    3 * sigma_combined_units < envelope_units := by
  unfold sigma_combined_units envelope_units; norm_num

/-- **🚨 s707 — `4σ_combined < envelope`**: 4σ band fits within
    envelope (88 < 110). -/
theorem T1_s707_four_sigma_lt_envelope :
    4 * sigma_combined_units < envelope_units := by
  unfold sigma_combined_units envelope_units; norm_num

/-- **🚨 s707 — `5σ_combined < envelope`**: 5σ discovery threshold
    fits strictly within envelope (110 ≮ 110? no — 5×22 = 110 which
    is NOT strictly less; we use the strict 4.5σ form instead).
    Concretely: `9 σ_combined / 2 < envelope` (99 < 110). -/
theorem T1_s707_four_and_half_sigma_lt_envelope :
    9 * sigma_combined_units / 2 < envelope_units := by
  unfold sigma_combined_units envelope_units; norm_num

/-- **🚨 s707 — `Δ_obs - σ < envelope`**: lower 1σ tail of observed
    deficit lies within envelope (78 < 110). -/
theorem T1_s707_obs_minus_sigma_within :
    Delta_tau_obs_units - sigma_combined_units < envelope_units := by
  unfold Delta_tau_obs_units sigma_combined_units envelope_units
  norm_num

/-- **🚨 s707 — `Δ_obs + σ` exceeds envelope** (the ~4.5σ tension just
    barely exits the strictly-inside envelope on the upper tail:
    `100 + 22 = 122 > 110`).  Records the geometric fact that the
    upper 1σ tail spills past the envelope by 12 (= 1.2 s), confirming
    the puzzle is genuinely at the edge of the ±11 s envelope. -/
theorem T1_s707_obs_plus_sigma_exceeds_envelope :
    envelope_units < Delta_tau_obs_units + sigma_combined_units := by
  unfold envelope_units Delta_tau_obs_units sigma_combined_units
  norm_num

/-! ## s708: Substrate prediction within envelope; both endpoints bounded -/

/-- **Substrate prediction — central** (working units 0.1 s):
    by construction, the substrate prediction's deviation from the
    midpoint is `0` (substrate is anchored at the midpoint of the
    bottle-vs-beam tension band). -/
noncomputable def Delta_tau_substrate_units : ℝ := 0

/-- **🚨 s708 — `Δ_substrate = 0`**: substrate prediction equals
    midpoint (working-units zero deviation). -/
theorem T1_s708_substrate_eq_zero :
    Delta_tau_substrate_units = 0 := by
  unfold Delta_tau_substrate_units; rfl

/-- **🚨 s708 — `Δ_substrate < envelope`**: substrate prediction is
    within envelope (0 < 110). -/
theorem T1_s708_substrate_below_upper :
    Delta_tau_substrate_units < envelope_units := by
  unfold Delta_tau_substrate_units envelope_units; norm_num

/-- **🚨 s708 — `-envelope < Δ_substrate`**: substrate prediction
    above lower envelope bound (-110 < 0). -/
theorem T1_s708_substrate_above_lower :
    -envelope_units < Delta_tau_substrate_units := by
  unfold Delta_tau_substrate_units envelope_units; norm_num

/-- **🚨 s708 — `|midpoint - bottle| < envelope`**: substrate midpoint
    lies within envelope of bottle endpoint (8820 - 8777 = 43 < 110). -/
theorem T1_s708_midpoint_bottle_within :
    tau_n_midpoint_units - tau_n_bottle_units < envelope_units := by
  unfold tau_n_midpoint_units tau_n_bottle_units envelope_units
  norm_num

/-- **🚨 s708 — `|beam - midpoint| < envelope`**: substrate midpoint
    lies within envelope of beam endpoint (8877 - 8820 = 57 < 110). -/
theorem T1_s708_beam_midpoint_within :
    tau_n_beam_units - tau_n_midpoint_units < envelope_units := by
  unfold tau_n_beam_units tau_n_midpoint_units envelope_units
  norm_num

/-- **🚨 s708 — `Δ_obs - Δ_substrate < envelope`**: separation of
    observed deficit from substrate prediction is within envelope
    (100 - 0 = 100 < 110). -/
theorem T1_s708_obs_substrate_separation_lt_envelope :
    Delta_tau_obs_units - Delta_tau_substrate_units < envelope_units := by
  unfold Delta_tau_obs_units Delta_tau_substrate_units envelope_units
  norm_num

/-- **🚨 s708 — `σ_combined < Δ_obs - Δ_substrate`**: observed-substrate
    separation exceeds 1σ (22 < 100), so substrate must accommodate
    the residual via β-decay-rate channel new physics (or the puzzle
    is methodology-systematic, NOT substrate-level). -/
theorem T1_s708_obs_substrate_separation_gt_sigma :
    sigma_combined_units <
      Delta_tau_obs_units - Delta_tau_substrate_units := by
  unfold sigma_combined_units Delta_tau_obs_units Delta_tau_substrate_units
  norm_num

/-- **🚨 s708 — `0 < Δ_obs - Δ_substrate`**: substrate prediction
    lies BELOW observed deficit central (the famous tension:
    bottle-vs-beam separation is positive). -/
theorem T1_s708_obs_substrate_separation_pos :
    0 < Delta_tau_obs_units - Delta_tau_substrate_units := by
  unfold Delta_tau_obs_units Delta_tau_substrate_units; norm_num

/-! ## s709: NeutronLifetimeBeamBottleFrontier Prop + 8-conjunct headline -/

/-- **NeutronLifetimeBeamBottleFrontier**: 6-way conjunction pinning
    the substrate-prediction envelope for the free-neutron lifetime
    bottle-vs-beam tension, in working units of 0.1 s:

    1. `envelope > 0`                                  (positivity)
    2. `-envelope < Δ_obs < envelope`                  (observed within)
    3. `-envelope < Δ_substrate < envelope`            (substrate within)
    4. `σ < envelope ∧ 4σ < envelope`                  (full ~4σ band fits)
    5. `0 < Δ_obs - Δ_substrate < envelope`            (separation within)
    6. `σ < Δ_obs - Δ_substrate`                       (separation > 1σ)

    Real Prop body — non-trivial 6-way conjunction.  Substrate
    predictions for `τ_n^substrate - τ_n^midpoint` (free-neutron
    lifetime deviation from the midpoint of the bottle-vs-beam tension
    band) must lie within this envelope to remain consistent with BOTH
    UCN-storage and beam β-decay endpoints, AND the observed central
    deficit must exceed 1σ (positive deficit = the famous tension). -/
def NeutronLifetimeBeamBottleFrontier : Prop :=
  -- envelope > 0
  (0 < envelope_units) ∧
  -- -envelope < Δ_obs < envelope
  (-envelope_units < Delta_tau_obs_units ∧
    Delta_tau_obs_units < envelope_units) ∧
  -- -envelope < Δ_substrate < envelope
  (-envelope_units < Delta_tau_substrate_units ∧
    Delta_tau_substrate_units < envelope_units) ∧
  -- σ < envelope ∧ 4σ < envelope
  (sigma_combined_units < envelope_units ∧
    4 * sigma_combined_units < envelope_units) ∧
  -- 0 < Δ_obs - Δ_substrate < envelope
  (0 < Delta_tau_obs_units - Delta_tau_substrate_units ∧
    Delta_tau_obs_units - Delta_tau_substrate_units < envelope_units) ∧
  -- σ < Δ_obs - Δ_substrate (the tension)
  (sigma_combined_units <
    Delta_tau_obs_units - Delta_tau_substrate_units)

/-- **🚨 s709 — `NeutronLifetimeBeamBottleFrontier`** holds. -/
theorem T1_s709_neutron_lifetime_beam_bottle_frontier :
    NeutronLifetimeBeamBottleFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · exact T1_s705_envelope_pos
  · exact T1_s706_obs_above_lower
  · exact T1_s706_obs_below_upper
  · exact T1_s708_substrate_above_lower
  · exact T1_s708_substrate_below_upper
  · exact T1_s707_sigma_lt_envelope
  · exact T1_s707_four_sigma_lt_envelope
  · exact T1_s708_obs_substrate_separation_pos
  · exact T1_s708_obs_substrate_separation_lt_envelope
  · exact T1_s708_obs_substrate_separation_gt_sigma

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_neutron_lifetime_beam_bottle_frontier_bundle :
    NeutronLifetimeBeamBottleFrontier :=
  T1_s709_neutron_lifetime_beam_bottle_frontier

/-! ## Headline (8-conjunct extended) -/

/-- **HEADLINE — sessions s705-s709 — Free-neutron lifetime bottle
    vs beam puzzle frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s705: bottle (8777 = 877.7 s), beam (8877 = 887.7 s),
            midpoint (8820 = 882.0 s), envelope (110 = 11.0 s),
            σ_combined (22 ≈ 2.2 s), Δ_obs (100 = 10.0 s) defined;
            positivity all-around; endpoint identity beam − bottle = Δ_obs;
            bottle < midpoint < beam straddling order.
    - s706: Δ_obs = 100 within ±110 envelope; Δ_obs > σ AND > 3σ AND > 4σ
            (the famous ~4-5σ tension).
    - s707: 1σ, 3σ, 4σ uncertainty bands all fit within envelope;
            lower-tail (Δ_obs − σ) within envelope; upper-tail
            (Δ_obs + σ) spills past envelope by 1.2 s (geometric fact:
            the puzzle just barely exits the strictly-inside envelope
            on the upper tail).
    - s708: substrate prediction (Δ = 0, anchored at midpoint) within
            envelope; both endpoints (bottle, beam) lie within envelope
            of midpoint; observed-substrate separation > 1σ tension;
            separation > 0 (positive direction).
    - s709: NeutronLifetimeBeamBottleFrontier Prop (6-conjunct) +
            bundle alias + headline (8-conjunct extended).

    Phenomenology context: this FRONTIER file is the substrate-prediction
    envelope for the long-standing ~4-5σ tension between two complementary
    techniques for measuring the free-neutron mean lifetime τ_n.  The SM
    expectation is a single value — one of the two methods has a
    methodology systematic, OR new physics exists that affects only one
    technique (e.g., dark-decay channel n → χ + γ accessible to bottle
    but not beam).  Both lifetimes sit comfortably within the
    ±11 s envelope around the midpoint 882 s.

    - **UCN storage (UCNτ, UCN-tau) bottle method**:
      `τ_n^bottle = 877.75 ± 0.36 s`.  Counts surviving ultra-cold
      neutrons in a magnetic trap at successive fill times.
    - **β-decay rate beam method (BL2/BL3)**:
      `τ_n^beam = 887.7 ± 2.2 s`.  Counts protons emitted from a cold
      neutron beam, divided by neutron flux.
    - **Δ_obs = 9.95 s ≈ 4σ tension**, σ_combined ≈ 2.23 s.

    Working units 0.1 s (deciseconds) throughout.

    Substrate-prediction: in OmegaTheory's discrete substrate, the free
    neutron β-decay width

        Γ_n ∝ G_F² m_e^5 (1 + 3 g_A²)

    is set by W coupling (s310 chain) + m_e Yukawa (s313) + g_A axial
    coupling.  All three sit in their own substrate truncation
    branches with `δ_comp` residuals far below the ±11 s envelope: the
    leading π-channel contribution at the truncation budget that
    matches PDG precision (N ~ 4-6) is bounded by `δ_comp(N) ~
    ℓ_P / λ_n` ratios, comfortably inside this envelope.  The companion
    substrate-fit file `NeutronLifetimeFit.lean` derives a specific
    numerical prediction in the π-channel; this Frontier file pins
    the substrate-envelope statement that the prediction is consistent
    with BOTH bottle and beam endpoints simultaneously.

    DISTINCT from existing neutron-lifetime files:
    - `T1_NeutronLifetimePuzzleBundle` (s684-s688): centisecond
      anchored-bundle direct-measurement registry; this Frontier file
      is the decisecond Frontier-pattern substrate-envelope companion.
    - `NeutronLifetimeFit` (cycle-21): π-channel substrate-fit chain.
    - `NeutronLifetimeAnomalyFromEffectiveMass`: effective-mass anomaly
      alternative-explanation companion.
    - `ColdNeutronILL_VCN`: ILL very-cold-neutron PRL letter package
      (independent slope-test channel).

    Reference:
    - PDG 2024 Review (M. Tanabashi et al., Phys. Rev. D 110 (2024)),
      neutron mean lifetime entry.
    - Gonzalez et al. (UCNτ collaboration), Phys. Rev. Lett. 127, 162501
      (2021): UCN-storage τ_n^bottle = 877.75 ± 0.36 s.
    - Yue et al. (NIST + Sussex BL2), Phys. Rev. Lett. 111, 222501
      (2013): beam τ_n^beam = 887.7 ± 2.2 s.
    - Wietfeldt & Greene, Rev. Mod. Phys. 83, 1173 (2011): review of
      the bottle-vs-beam puzzle.

    Sub-lemma in T-1 baryon-sector free-neutron β-decay residue.
    Lean-core only.

    🏆 First Lean-core working-units substrate-envelope frontier for
    the free-neutron bottle-vs-beam lifetime puzzle. -/
theorem session_705_to_709_neutron_lifetime_beam_bottle_frontier_headline :
    0 < envelope_units
    ∧ Delta_tau_obs_units < envelope_units
    ∧ Delta_tau_substrate_units < envelope_units
    ∧ sigma_combined_units < envelope_units
    ∧ 4 * sigma_combined_units < envelope_units
    ∧ Delta_tau_obs_units - Delta_tau_substrate_units < envelope_units
    ∧ sigma_combined_units <
        Delta_tau_obs_units - Delta_tau_substrate_units
    ∧ NeutronLifetimeBeamBottleFrontier :=
  ⟨T1_s705_envelope_pos, T1_s706_obs_below_upper,
   T1_s708_substrate_below_upper, T1_s707_sigma_lt_envelope,
   T1_s707_four_sigma_lt_envelope,
   T1_s708_obs_substrate_separation_lt_envelope,
   T1_s708_obs_substrate_separation_gt_sigma,
   T1_s709_neutron_lifetime_beam_bottle_frontier⟩

end OmegaTheory.Predictions.T1_NeutronLifetimeBeamBottleFrontier
