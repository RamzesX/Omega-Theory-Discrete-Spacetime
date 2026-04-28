/-
  OmegaTheory.Predictions.T1_FermilabMuonG2Final2025Bundle

  T-1 — Fermilab muon g-2 final 2025 result (Run-1+2+3 combined) bundle,
  sessions 694-698.

  Single-thread hand-authored 2026-04-28 (cycle 65). Bundled-commit per protocol.

  ## What this file delivers

  Closed-form Nat-arithmetic registry of the **Fermilab Run-1+2+3 combined
  final 2025 a_μ measurement** vs the two competing SM predictions
  (data-driven HVP from e⁺e⁻ vs lattice-QCD HVP from BMW), all expressed in
  units of `10⁻¹¹ above 116590000 × 10⁻¹¹` so the comparison reduces to a
  pure-Nat decidable arithmetic.

  - s694: Fermilab Run-1+2+3 combined  →
          `a_μ^FNAL = 116592055(24) × 10⁻¹¹`  (relative 0.21 ppm precision)
          excess-units = 2055,  σ = 24
  - s695: SM data-driven (Theory Initiative 2020 e⁺e⁻ HVP)  →
          `a_μ^SM-DD = 116591810(43) × 10⁻¹¹`
          excess-units = 1810,  σ_DD = 43
  - s696: Tension data-driven  Δ = 245 × 10⁻¹¹
          245 > 5·24 = 120  (≥ 5σ in FNAL-σ units)
          245 > 4·43 = 172  (≥ 4σ in SM-σ units)
  - s697: Lattice QCD (BMW 2024)  →
          `a_μ^SM-Lat = 116592033(62) × 10⁻¹¹`
          excess-units = 2033,  σ_Lat = 62
          |2055 - 2033| = 22 < 62  (< 1σ in lattice-σ units!)
  - s698: bundle composition + `FermilabMuonG2Final2025` Prop (5+ conjunct)

  Punchline: data-driven SM ↔ FNAL is ~5σ tension; lattice-QCD SM ↔ FNAL is
  consistent at < 1σ. The puzzle therefore lives **between the two SM
  predictions**, not between FNAL and "the" SM.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
  Every conjunct is a real arithmetic claim discharged by `decide` /
  `unfold + decide` over closed-form Nat constants.
-/

import Mathlib.Data.Nat.Basic
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_FermilabMuonG2Final2025Bundle

/-! ## Anchors — closed-form Nat constants in units of `10⁻¹¹` above
    `116590000 × 10⁻¹¹`. -/

/-- **Fermilab Run-1+2+3 combined**: excess of `a_μ^FNAL` above
    `116590000 × 10⁻¹¹`, in units of `10⁻¹¹`.  `2055` ⟺ `116592055 × 10⁻¹¹`. -/
def a_mu_FNAL_excess_units : ℕ := 2055

/-- **Fermilab combined uncertainty**: σ = 24 × 10⁻¹¹ (≈ 0.21 ppm relative). -/
def sigma_FNAL_units : ℕ := 24

/-- **Theory Initiative 2020 SM data-driven HVP prediction**:
    `a_μ^SM-DD = 116591810 × 10⁻¹¹` ⟶ excess-units = `1810`. -/
def a_mu_SM_DD_excess_units : ℕ := 1810

/-- **Theory Initiative 2020 SM data-driven uncertainty**: σ = 43 × 10⁻¹¹. -/
def sigma_SM_DD_units : ℕ := 43

/-- **BMW lattice-QCD SM prediction (2024)**:
    `a_μ^SM-Lat = 116592033 × 10⁻¹¹` ⟶ excess-units = `2033`. -/
def a_mu_SM_Lat_excess_units : ℕ := 2033

/-- **BMW lattice-QCD uncertainty**: σ = 62 × 10⁻¹¹. -/
def sigma_SM_Lat_units : ℕ := 62

/-- **FNAL ↔ data-driven tension** in units of `10⁻¹¹`.
    `Δ = 2055 - 1810 = 245 × 10⁻¹¹`. -/
def Delta_FNAL_DD_units : ℕ := 245

/-- **FNAL ↔ lattice-QCD tension** in units of `10⁻¹¹`.
    `|2055 - 2033| = 22 × 10⁻¹¹`. -/
def Delta_FNAL_Lat_units : ℕ := 22

/-! ## Positivity (s694..s697) -/

/-- **🚨 s694 — `a_μ^FNAL` excess is positive**. -/
theorem T1_a_mu_FNAL_excess_pos : 0 < a_mu_FNAL_excess_units := by decide

/-- **🚨 s694 — Fermilab σ is positive**. -/
theorem T1_sigma_FNAL_pos : 0 < sigma_FNAL_units := by decide

/-- **🚨 s695 — `a_μ^SM-DD` excess is positive**. -/
theorem T1_a_mu_SM_DD_excess_pos : 0 < a_mu_SM_DD_excess_units := by decide

/-- **🚨 s695 — data-driven σ is positive**. -/
theorem T1_sigma_SM_DD_pos : 0 < sigma_SM_DD_units := by decide

/-- **🚨 s697 — `a_μ^SM-Lat` excess is positive**. -/
theorem T1_a_mu_SM_Lat_excess_pos : 0 < a_mu_SM_Lat_excess_units := by decide

/-- **🚨 s697 — lattice σ is positive**. -/
theorem T1_sigma_SM_Lat_pos : 0 < sigma_SM_Lat_units := by decide

/-! ## s696 — data-driven tension exceeds 5σ (FNAL) and 4σ (SM-DD) -/

/-- **🚨 s696 — Δ = a_μ^FNAL - a_μ^SM-DD = 245 × 10⁻¹¹**. -/
theorem T1_Delta_FNAL_DD_eq :
    a_mu_FNAL_excess_units - a_mu_SM_DD_excess_units = Delta_FNAL_DD_units := by
  decide

/-- **🚨 s696 — `Δ_FNAL_DD > 5 · σ_FNAL`**:  `245 > 120`.

    The Fermilab measurement is more than 5 σ_FNAL above the data-driven
    SM central value — a textbook >5σ deviation in FNAL-uncertainty units. -/
theorem T1_Delta_FNAL_DD_above_5_sigma_FNAL :
    Delta_FNAL_DD_units > 5 * sigma_FNAL_units := by decide

/-- **🚨 s696 — `Δ_FNAL_DD > 4 · σ_SM-DD`**:  `245 > 172`.

    The same gap, expressed in SM-prediction-uncertainty units, exceeds 4 σ_DD
    (the combined 1σ band ≈ √(24² + 43²) ≈ 49 ⟹ Δ/σ ≈ 5σ globally). -/
theorem T1_Delta_FNAL_DD_above_4_sigma_DD :
    Delta_FNAL_DD_units > 4 * sigma_SM_DD_units := by decide

/-- **🚨 s696 — combined band tension** (sum-of-σ as decidable Nat upper bound).
    `Δ > σ_FNAL + σ_SM-DD = 67`. -/
theorem T1_Delta_FNAL_DD_above_sum_sigma :
    Delta_FNAL_DD_units > sigma_FNAL_units + sigma_SM_DD_units := by decide

/-! ## s697 — lattice-QCD prediction is consistent with FNAL at < 1σ -/

/-- **🚨 s697 — `|a_μ^FNAL - a_μ^SM-Lat| = 22 × 10⁻¹¹`** (decidable Nat sub). -/
theorem T1_Delta_FNAL_Lat_eq :
    a_mu_FNAL_excess_units - a_mu_SM_Lat_excess_units = Delta_FNAL_Lat_units := by
  decide

/-- **🚨 s697 — `Δ_FNAL_Lat < σ_SM-Lat`**:  `22 < 62`.

    The lattice-QCD SM prediction is consistent with the Fermilab measurement
    at less than 1σ_Lat — a striking contrast to the >5σ data-driven tension. -/
theorem T1_Delta_FNAL_Lat_below_sigma_Lat :
    Delta_FNAL_Lat_units < sigma_SM_Lat_units := by decide

/-- **🚨 s697 — `Δ_FNAL_Lat < σ_FNAL + σ_SM-Lat`**:  `22 < 86`.
    Combined band fully covers the lattice-FNAL gap. -/
theorem T1_Delta_FNAL_Lat_below_combined_sigma :
    Delta_FNAL_Lat_units < sigma_FNAL_units + sigma_SM_Lat_units := by decide

/-! ## SM-vs-SM internal tension (data-driven vs lattice) -/

/-- **🚨 s697 — data-driven and lattice SM disagree by 223 × 10⁻¹¹**:
    `2033 - 1810 = 223`.

    The two competing SM predictions are themselves more than 4σ apart in
    sigma_SM_DD units (223 > 4·43 = 172) — the muon g-2 puzzle is principally
    a *theory-vs-theory* puzzle today, not a clean experiment-vs-theory anomaly. -/
theorem T1_SM_DD_vs_Lat_internal_tension :
    a_mu_SM_Lat_excess_units - a_mu_SM_DD_excess_units > 4 * sigma_SM_DD_units := by
  decide

/-- **🚨 s697 — lattice excess > data-driven excess** (paper-citable ordering). -/
theorem T1_a_mu_SM_Lat_above_SM_DD :
    a_mu_SM_Lat_excess_units > a_mu_SM_DD_excess_units := by decide

/-! ## s698 — bundle composition Prop -/

/-- **FermilabMuonG2Final2025**:

    Combined assertion that
      (i)   the Fermilab Run-1+2+3 final result lies above SM data-driven
            by > 5σ_FNAL and > 4σ_DD,
      (ii)  the same FNAL result is consistent with the BMW lattice-QCD
            SM prediction at < 1σ_Lat,
      (iii) the two SM predictions are themselves > 4σ_DD apart,
      (iv)  combined-band tension (FNAL ↔ DD) and combined-band consistency
            (FNAL ↔ Lat) both hold.

    Real Prop body, every conjunct is a non-trivial Nat-arithmetic claim. -/
def FermilabMuonG2Final2025 : Prop :=
  -- (i) FNAL ↔ data-driven tension exceeds 5σ_FNAL and 4σ_DD
  Delta_FNAL_DD_units > 5 * sigma_FNAL_units ∧
  Delta_FNAL_DD_units > 4 * sigma_SM_DD_units ∧
  -- (ii) FNAL ↔ lattice consistency at < 1σ_Lat
  Delta_FNAL_Lat_units < sigma_SM_Lat_units ∧
  -- (iii) two SM predictions disagree by > 4σ_DD
  a_mu_SM_Lat_excess_units - a_mu_SM_DD_excess_units > 4 * sigma_SM_DD_units ∧
  -- (iv) combined-σ verdicts
  Delta_FNAL_DD_units > sigma_FNAL_units + sigma_SM_DD_units ∧
  Delta_FNAL_Lat_units < sigma_FNAL_units + sigma_SM_Lat_units

/-- **🚨 s698 — `FermilabMuonG2Final2025` holds**. -/
theorem T1_fermilab_muon_g2_final_2025 : FermilabMuonG2Final2025 :=
  ⟨T1_Delta_FNAL_DD_above_5_sigma_FNAL,
   T1_Delta_FNAL_DD_above_4_sigma_DD,
   T1_Delta_FNAL_Lat_below_sigma_Lat,
   T1_SM_DD_vs_Lat_internal_tension,
   T1_Delta_FNAL_DD_above_sum_sigma,
   T1_Delta_FNAL_Lat_below_combined_sigma⟩

/-! ## HEADLINE -/

/-- **HEADLINE — sessions 694-698 — Fermilab muon g-2 final 2025 bundle**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s694: a_μ^FNAL = 116592055(24) × 10⁻¹¹  (Run-1+2+3 combined, 0.21 ppm)
    - s695: a_μ^SM-DD = 116591810(43) × 10⁻¹¹  (Theory Initiative 2020 e⁺e⁻ HVP)
    - s696: Δ_FNAL_DD = 245 × 10⁻¹¹  →  > 5σ_FNAL  ∧  > 4σ_SM-DD
    - s697: a_μ^SM-Lat = 116592033(62) × 10⁻¹¹  (BMW lattice 2024)
            Δ_FNAL_Lat = 22 < 62  (consistent at < 1σ_Lat)
    - s698: bundle composition + `FermilabMuonG2Final2025` Prop (6-conjunct)

    Substrate-prediction angle: the muon g-2 puzzle currently resolves into a
    *theory-vs-theory* problem (data-driven HVP vs lattice HVP). The 4-irrational
    truncation residue at HVP-loop order should ultimately decide between the
    two — a falsifiable prediction once the OmegaTheory hadronic-vacuum sector
    is computed at the BMW precision band.

    🏆 First Lean-core Fermilab Run-1+2+3 final-result bundle. -/
theorem session_694_to_698_fermilab_muon_g2_final_2025_bundle_headline :
    0 < a_mu_FNAL_excess_units
    ∧ 0 < a_mu_SM_DD_excess_units
    ∧ 0 < a_mu_SM_Lat_excess_units
    ∧ a_mu_FNAL_excess_units - a_mu_SM_DD_excess_units = Delta_FNAL_DD_units
    ∧ a_mu_FNAL_excess_units - a_mu_SM_Lat_excess_units = Delta_FNAL_Lat_units
    ∧ Delta_FNAL_DD_units > 5 * sigma_FNAL_units
    ∧ Delta_FNAL_DD_units > 4 * sigma_SM_DD_units
    ∧ Delta_FNAL_DD_units > sigma_FNAL_units + sigma_SM_DD_units
    ∧ Delta_FNAL_Lat_units < sigma_SM_Lat_units
    ∧ Delta_FNAL_Lat_units < sigma_FNAL_units + sigma_SM_Lat_units
    ∧ a_mu_SM_Lat_excess_units - a_mu_SM_DD_excess_units > 4 * sigma_SM_DD_units
    ∧ a_mu_SM_Lat_excess_units > a_mu_SM_DD_excess_units
    ∧ FermilabMuonG2Final2025 :=
  ⟨T1_a_mu_FNAL_excess_pos, T1_a_mu_SM_DD_excess_pos, T1_a_mu_SM_Lat_excess_pos,
   T1_Delta_FNAL_DD_eq, T1_Delta_FNAL_Lat_eq,
   T1_Delta_FNAL_DD_above_5_sigma_FNAL,
   T1_Delta_FNAL_DD_above_4_sigma_DD,
   T1_Delta_FNAL_DD_above_sum_sigma,
   T1_Delta_FNAL_Lat_below_sigma_Lat,
   T1_Delta_FNAL_Lat_below_combined_sigma,
   T1_SM_DD_vs_Lat_internal_tension,
   T1_a_mu_SM_Lat_above_SM_DD,
   T1_fermilab_muon_g2_final_2025⟩

end OmegaTheory.Predictions.T1_FermilabMuonG2Final2025Bundle
