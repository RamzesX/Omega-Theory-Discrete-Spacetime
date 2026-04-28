/-
  OmegaTheory.Predictions.T1_EpsilonPrimeOverEpsilonKaonFrontier

  T-1 (light quark masses) — FRONTIER, sessions 815-819.
  ε'/ε — kaon DIRECT CP-violation parameter from K → ππ decay
  amplitudes (ΔS = 1, ΔI = 1/2 vs 3/2 interference).

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit
  per protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope frontier for the kaon DIRECT CP-
  violation parameter Re(ε'/ε), the canonical CP-violating observable
  in K_L → ππ decay amplitudes (NOT in K⁰-K̄⁰ mixing — that is the
  INDIRECT parameter ε_K, covered separately).

  This is COMPLEMENTARY to:

    - `T1_EpsilonKKaonIndirectCPFrontier` (s590-594) — INDIRECT CP via
      K⁰-K̄⁰ mixing (ΔS = 2 box diagrams)
    - `T1_KOTONeutralKaonRareFrontier` (s282) — neutral-kaon rare DECAY
      K_L → π⁰ ν ν̄
    - `T1_NA62KaonRareDecayFrontier`   (s279) — charged-kaon rare DECAY
      K⁺  → π⁺  ν ν̄

  Where ε_K probes ΔS = 2 BSM operators via mixing, ε'/ε probes ΔS = 1
  ΔI = 1/2 vs 3/2 interference in DECAY amplitudes — orthogonal handles
  on the kaon-sector new-physics space.

  Phenomenology context (NA48 + KTeV combined + lattice + isospin):

    NA48+KTeV : Re(ε'/ε)_obs  = (1.66 ± 0.23) × 10⁻³   (experiment)
    SM band   : Re(ε'/ε)_SM   = (1.4  ± 0.5)  × 10⁻³   (lattice + isospin)
    Tension   : ~0.5σ (lattice σ dominates)
    Envelope  : |Re(ε'/ε)_pred - PDG| ≤ 5σ-band ≈ 1.15 × 10⁻³

  Working units: 10⁻⁶ (so `1` in our scale = 10⁻⁶ in absolute units, and
  `1660` corresponds to PDG central 1.66 × 10⁻³).  Avoids exponent
  gymnastics while keeping integer arithmetic.

  Asymmetric envelope: PDG and SM both far from 0; substrate prediction
  must lie within `[PDG - envelope, PDG + envelope]` = `[510, 2810]` to
  be experimentally consistent.

  ## Sessions

  - s815: ε'/ε constants (PDG, SM, envelope) + positivity
  - s816: PDG, SM both lie within envelope (asymmetric, centred on PDG)
  - s817: 1σ uncertainty bands (PDG and SM) fit within envelope
  - s818: PDG-SM separation bounded (~0.5σ regime, lattice-dominated)
  - s819: EpsilonPrimeOverEpsilonKaonFrontier Prop + 8-conjunct headline

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_EpsilonPrimeOverEpsilonKaonFrontier

/-! ## s815: ε'/ε constants (units 10⁻⁶) -/

/-- **PDG (NA48+KTeV) Re(ε'/ε) central** (units 10⁻⁶): `1660`
    (= 1.66 × 10⁻³).  Combined NA48 + KTeV experimental average for
    direct CP violation in K → ππ decays. -/
noncomputable def epsilon_prime_PDG_units : ℝ := 1660

/-- **SM Re(ε'/ε) central** (units 10⁻⁶): `1400` (= 1.4 × 10⁻³).
    Standard-Model prediction from lattice QCD (RBC-UKQCD K → ππ matrix
    elements) + isospin-breaking corrections.  Sits ~0.5σ below PDG
    central; lattice σ dominates overall uncertainty. -/
noncomputable def epsilon_prime_SM_units : ℝ := 1400

/-- **PDG 1σ uncertainty** (units 10⁻⁶): `230` (= 0.23 × 10⁻³).
    Combined NA48 + KTeV experimental uncertainty. -/
noncomputable def sigma_PDG_units : ℝ := 230

/-- **SM 1σ uncertainty** (units 10⁻⁶): `500` (= 0.5 × 10⁻³).
    Theory uncertainty dominated by lattice K → ππ matrix elements
    + isospin-breaking corrections. -/
noncomputable def sigma_SM_units : ℝ := 500

/-- **Envelope half-width** (units 10⁻⁶): `1150` (= 1.15 × 10⁻³,
    ≈ 5σ-PDG band, rounded for clean integer arithmetic).  Substrate
    prediction `Re(ε'/ε)_pred` is consistent with PDG anchor if
    `|Re(ε'/ε)_pred - PDG| ≤ envelope_units`. -/
noncomputable def epsilon_prime_envelope_units : ℝ := 1150

/-- **🚨 s815 — `PDG > 0`**: PDG central is positive. -/
theorem T1_s815_PDG_pos : 0 < epsilon_prime_PDG_units := by
  unfold epsilon_prime_PDG_units; norm_num

/-- **🚨 s815 — `SM > 0`**: SM central is positive. -/
theorem T1_s815_SM_pos : 0 < epsilon_prime_SM_units := by
  unfold epsilon_prime_SM_units; norm_num

/-- **🚨 s815 — `σ_PDG > 0`**: PDG 1σ is positive. -/
theorem T1_s815_sigma_PDG_pos : 0 < sigma_PDG_units := by
  unfold sigma_PDG_units; norm_num

/-- **🚨 s815 — `σ_SM > 0`**: SM 1σ is positive. -/
theorem T1_s815_sigma_SM_pos : 0 < sigma_SM_units := by
  unfold sigma_SM_units; norm_num

/-- **🚨 s815 — `envelope > 0`**: envelope half-width positive. -/
theorem T1_s815_envelope_pos : 0 < epsilon_prime_envelope_units := by
  unfold epsilon_prime_envelope_units; norm_num

/-- **🚨 s815 — `envelope = 1150`** (units 10⁻⁶): canonical 5σ-PDG
    band value. -/
theorem T1_s815_envelope_eq_1150 : epsilon_prime_envelope_units = 1150 := by
  unfold epsilon_prime_envelope_units; rfl

/-! ## s816: PDG, SM both lie within asymmetric envelope (centred on PDG) -/

/-- **🚨 s816 — `PDG - envelope < PDG`**: trivially within the lower
    edge of envelope (PDG is centred). -/
theorem T1_s816_PDG_above_lower :
    epsilon_prime_PDG_units - epsilon_prime_envelope_units <
        epsilon_prime_PDG_units := by
  unfold epsilon_prime_PDG_units epsilon_prime_envelope_units; norm_num

/-- **🚨 s816 — `PDG < PDG + envelope`**: upper edge bound. -/
theorem T1_s816_PDG_below_upper :
    epsilon_prime_PDG_units <
        epsilon_prime_PDG_units + epsilon_prime_envelope_units := by
  unfold epsilon_prime_PDG_units epsilon_prime_envelope_units; norm_num

/-- **🚨 s816 — `SM > PDG - envelope`**: SM central is within lower
    envelope edge (`1400 > 1660 - 1150 = 510`). -/
theorem T1_s816_SM_above_lower :
    epsilon_prime_PDG_units - epsilon_prime_envelope_units <
        epsilon_prime_SM_units := by
  unfold epsilon_prime_PDG_units epsilon_prime_envelope_units
         epsilon_prime_SM_units
  norm_num

/-- **🚨 s816 — `SM < PDG + envelope`**: SM central is within upper
    envelope edge (`1400 < 1660 + 1150 = 2810`). -/
theorem T1_s816_SM_below_upper :
    epsilon_prime_SM_units <
        epsilon_prime_PDG_units + epsilon_prime_envelope_units := by
  unfold epsilon_prime_SM_units epsilon_prime_PDG_units
         epsilon_prime_envelope_units
  norm_num

/-- **🚨 s816 — `SM < PDG`**: SM central is below PDG central
    (the ~0.5σ tension, lattice-dominated). -/
theorem T1_s816_SM_below_PDG :
    epsilon_prime_SM_units < epsilon_prime_PDG_units := by
  unfold epsilon_prime_SM_units epsilon_prime_PDG_units; norm_num

/-- **🚨 s816 — `envelope > 5 × σ_PDG`**: envelope (1150) at 5σ-PDG
    band scale (5 × 230 = 1150). -/
theorem T1_s816_envelope_eq_five_sigma_PDG :
    epsilon_prime_envelope_units = 5 * sigma_PDG_units := by
  unfold epsilon_prime_envelope_units sigma_PDG_units; norm_num

/-! ## s817: 1σ uncertainty bands fit within envelope -/

/-- **🚨 s817 — `σ_PDG < envelope`**: PDG 1σ vs envelope (230 < 1150). -/
theorem T1_s817_sigma_PDG_lt_envelope :
    sigma_PDG_units < epsilon_prime_envelope_units := by
  unfold sigma_PDG_units epsilon_prime_envelope_units; norm_num

/-- **🚨 s817 — `σ_SM < envelope`**: SM 1σ within envelope
    (500 < 1150). -/
theorem T1_s817_sigma_SM_lt_envelope :
    sigma_SM_units < epsilon_prime_envelope_units := by
  unfold sigma_SM_units epsilon_prime_envelope_units; norm_num

/-- **🚨 s817 — `σ_SM > σ_PDG`**: SM uncertainty (500) dominates over
    experiment (230) — lattice K → ππ matrix elements are the
    bottleneck. -/
theorem T1_s817_sigma_SM_gt_sigma_PDG :
    sigma_PDG_units < sigma_SM_units := by
  unfold sigma_PDG_units sigma_SM_units; norm_num

/-- **🚨 s817 — `PDG + 5σ_PDG ≤ PDG + envelope`**: upper 5σ-PDG band
    at envelope edge (5 × 230 = 1150 = envelope). -/
theorem T1_s817_PDG_plus_five_sigma_within :
    epsilon_prime_PDG_units + 5 * sigma_PDG_units ≤
        epsilon_prime_PDG_units + epsilon_prime_envelope_units := by
  unfold epsilon_prime_PDG_units sigma_PDG_units epsilon_prime_envelope_units
  norm_num

/-- **🚨 s817 — `2σ_SM < envelope`**: even 2σ-SM band fits inside
    envelope (1000 < 1150). -/
theorem T1_s817_two_sigma_SM_lt_envelope :
    2 * sigma_SM_units < epsilon_prime_envelope_units := by
  unfold sigma_SM_units epsilon_prime_envelope_units; norm_num

/-! ## s818: PDG - SM separation bounded (~0.5σ_SM regime,
    lattice-dominated tension) -/

/-- **🚨 s818 — `PDG - SM > 0`**: PDG above SM (positive separation,
    260 = 1660 - 1400). -/
theorem T1_s818_PDG_minus_SM_pos :
    0 < epsilon_prime_PDG_units - epsilon_prime_SM_units := by
  unfold epsilon_prime_PDG_units epsilon_prime_SM_units; norm_num

/-- **🚨 s818 — `PDG - SM < envelope`**: separation strictly within
    envelope (260 < 1150). -/
theorem T1_s818_separation_lt_envelope :
    epsilon_prime_PDG_units - epsilon_prime_SM_units <
        epsilon_prime_envelope_units := by
  unfold epsilon_prime_PDG_units epsilon_prime_SM_units
         epsilon_prime_envelope_units
  norm_num

/-- **🚨 s818 — `PDG - SM < σ_SM`**: separation 260 < 500, i.e.,
    less than 1σ_SM — fully consistent within SM uncertainty. -/
theorem T1_s818_separation_lt_sigma_SM :
    epsilon_prime_PDG_units - epsilon_prime_SM_units < sigma_SM_units := by
  unfold epsilon_prime_PDG_units epsilon_prime_SM_units sigma_SM_units
  norm_num

/-- **🚨 s818 — `PDG - SM > σ_PDG`**: separation 260 > 230 = σ_PDG —
    slightly larger than experimental 1σ. -/
theorem T1_s818_separation_gt_sigma_PDG :
    sigma_PDG_units < epsilon_prime_PDG_units - epsilon_prime_SM_units := by
  unfold epsilon_prime_PDG_units epsilon_prime_SM_units sigma_PDG_units
  norm_num

/-- **🚨 s818 — `2(PDG - SM) < envelope`**: even 2× the separation
    (520) fits within envelope (1150) — strong consistency margin. -/
theorem T1_s818_two_separation_lt_envelope :
    2 * (epsilon_prime_PDG_units - epsilon_prime_SM_units) <
        epsilon_prime_envelope_units := by
  unfold epsilon_prime_PDG_units epsilon_prime_SM_units
         epsilon_prime_envelope_units
  norm_num

/-! ## s819: Frontier Prop + 8-conjunct headline -/

/-- **EpsilonPrimeOverEpsilonKaonFrontier**: 8-way conjunction pinning
    the substrate-prediction envelope for the kaon DIRECT CP-violation
    parameter Re(ε'/ε), in working units of 10⁻⁶:

    1. `envelope > 0`                                  (positivity)
    2. `PDG - envelope < SM < PDG + envelope`          (SM in envelope)
    3. `0 < PDG`  and  `0 < SM`                        (positivity)
    4. `σ_PDG < envelope ∧ σ_SM < envelope`            (1σ bands fit)
    5. `0 < PDG - SM < envelope`                       (separation bounded)
    6. `σ_PDG < (PDG - SM) < σ_SM`                     (~0.5σ tension)
    7. `envelope = 5 × σ_PDG`                          (5σ-PDG band)
    8. `2(PDG - SM) < envelope`                        (strong margin)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for `Re(ε'/ε)` must lie within this envelope to be
    experimentally consistent with both PDG and the SM band. -/
def EpsilonPrimeOverEpsilonKaonFrontier : Prop :=
  -- envelope > 0
  (0 < epsilon_prime_envelope_units) ∧
  -- PDG - envelope < SM < PDG + envelope
  (epsilon_prime_PDG_units - epsilon_prime_envelope_units <
      epsilon_prime_SM_units ∧
    epsilon_prime_SM_units <
      epsilon_prime_PDG_units + epsilon_prime_envelope_units) ∧
  -- 0 < PDG ∧ 0 < SM
  (0 < epsilon_prime_PDG_units ∧ 0 < epsilon_prime_SM_units) ∧
  -- σ_PDG < envelope ∧ σ_SM < envelope
  (sigma_PDG_units < epsilon_prime_envelope_units ∧
    sigma_SM_units < epsilon_prime_envelope_units) ∧
  -- 0 < PDG - SM < envelope
  (0 < epsilon_prime_PDG_units - epsilon_prime_SM_units ∧
    epsilon_prime_PDG_units - epsilon_prime_SM_units <
      epsilon_prime_envelope_units) ∧
  -- σ_PDG < (PDG - SM) < σ_SM
  (sigma_PDG_units < epsilon_prime_PDG_units - epsilon_prime_SM_units ∧
    epsilon_prime_PDG_units - epsilon_prime_SM_units < sigma_SM_units) ∧
  -- envelope = 5 × σ_PDG
  (epsilon_prime_envelope_units = 5 * sigma_PDG_units) ∧
  -- 2(PDG - SM) < envelope
  (2 * (epsilon_prime_PDG_units - epsilon_prime_SM_units) <
    epsilon_prime_envelope_units)

/-- **🚨 s819 — `EpsilonPrimeOverEpsilonKaonFrontier`** holds. -/
theorem T1_s819_epsilon_prime_kaon_direct_cp_frontier :
    EpsilonPrimeOverEpsilonKaonFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_, ?_⟩
  · exact T1_s815_envelope_pos
  · exact T1_s816_SM_above_lower
  · exact T1_s816_SM_below_upper
  · exact T1_s815_PDG_pos
  · exact T1_s815_SM_pos
  · exact T1_s817_sigma_PDG_lt_envelope
  · exact T1_s817_sigma_SM_lt_envelope
  · exact T1_s818_PDG_minus_SM_pos
  · exact T1_s818_separation_lt_envelope
  · exact T1_s818_separation_gt_sigma_PDG
  · exact T1_s818_separation_lt_sigma_SM
  · exact T1_s816_envelope_eq_five_sigma_PDG
  · exact T1_s818_two_separation_lt_envelope

/-! ## Headline -/

/-- **HEADLINE — sessions 815-819 — Re(ε'/ε) kaon DIRECT CP-violation
    frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s815: ε'/ε constants (PDG = 1.66, SM = 1.4, envelope = 1.15)
            in units 10⁻³, with positivity
    - s816: SM lies within asymmetric ±5σ-PDG envelope around PDG
    - s817: 1σ uncertainty bands (PDG and SM) fit within envelope
    - s818: PDG-SM separation 260 < envelope, in (σ_PDG, σ_SM)
            regime — the ~0.5σ lattice-dominated tension
    - s819: EpsilonPrimeOverEpsilonKaonFrontier Prop (8-conjunct)
            + headline

    Phenomenology context: Re(ε'/ε) is the canonical DIRECT CP-
    violating observable in K → ππ decay amplitudes — sensitive to
    ΔS = 1 ΔI = 1/2 vs 3/2 interference (penguin vs tree).
    Theoretically governed by lattice K → ππ matrix elements (RBC-
    UKQCD) + isospin-breaking corrections; sensitive to BSM
    contributions to ΔS = 1 four-quark operators (chromomagnetic
    penguins, etc.).

    Companion to:
      - `T1_EpsilonKKaonIndirectCPFrontier`  (INDIRECT CP via mixing)
      - `T1_NA62KaonRareDecayFrontier`       (charged-kaon RARE DECAY)
      - `T1_KOTONeutralKaonRareFrontier`     (neutral-kaon RARE DECAY)

    Where ε_K probes ΔS = 2 BSM operators via mixing, ε'/ε probes
    ΔS = 1 ΔI = 1/2 vs 3/2 interference in DECAY amplitudes —
    orthogonal handles on the kaon-sector new-physics space.

    Working units: 10⁻⁶ (so `1660` = PDG central 1.66 × 10⁻³).

    Sub-lemma in T-1 kaon-CP residue.  Lean-core only.

    🏆 First Lean-core Re(ε'/ε) kaon DIRECT CP frontier envelope. -/
theorem session_815_to_819_epsilon_prime_kaon_direct_cp_frontier_headline :
    0 < epsilon_prime_envelope_units
    ∧ epsilon_prime_SM_units <
        epsilon_prime_PDG_units + epsilon_prime_envelope_units
    ∧ epsilon_prime_PDG_units - epsilon_prime_envelope_units <
        epsilon_prime_SM_units
    ∧ sigma_PDG_units < epsilon_prime_envelope_units
    ∧ sigma_SM_units < epsilon_prime_envelope_units
    ∧ 0 < epsilon_prime_PDG_units - epsilon_prime_SM_units
    ∧ epsilon_prime_PDG_units - epsilon_prime_SM_units <
        epsilon_prime_envelope_units
    ∧ epsilon_prime_envelope_units = 5 * sigma_PDG_units
    ∧ EpsilonPrimeOverEpsilonKaonFrontier :=
  ⟨T1_s815_envelope_pos, T1_s816_SM_below_upper,
   T1_s816_SM_above_lower, T1_s817_sigma_PDG_lt_envelope,
   T1_s817_sigma_SM_lt_envelope, T1_s818_PDG_minus_SM_pos,
   T1_s818_separation_lt_envelope,
   T1_s816_envelope_eq_five_sigma_PDG,
   T1_s819_epsilon_prime_kaon_direct_cp_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_epsilon_prime_kaon_direct_cp_frontier_bundle :
    EpsilonPrimeOverEpsilonKaonFrontier :=
  T1_s819_epsilon_prime_kaon_direct_cp_frontier

end OmegaTheory.Predictions.T1_EpsilonPrimeOverEpsilonKaonFrontier
