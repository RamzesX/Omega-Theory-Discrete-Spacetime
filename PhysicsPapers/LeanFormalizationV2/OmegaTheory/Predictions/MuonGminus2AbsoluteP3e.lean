/-
  OmegaTheory.Predictions.MuonGminus2AbsoluteP3e

  **Wave P3e** (hand-written by session lead) — muon g-2 BNL/FNAL absolute-
  value certification closing Menkent Atlas v7 top candidate
  `muon_g_minus_2_BNL_FNAL_substrate_fit_numerical_absolute_paper_bundle`
  (HIGH priority, 55 downstream_unblocks).

  ## Physical claim

  BNL E821 + Fermilab E989 combined 2025:
     `a_μ^{exp} − a_μ^{SM}  ≈  (249 ± 48) × 10⁻¹¹  ≈  2.51 × 10⁻⁹`
  at **4.2 σ**.

  Megrez's `MuonGminus2SubstrateFit.lean` already derived the substrate
  fit `substrateMuonShift N := C_muon_fit · muonFitBase N` with
  `substrateMuonShift 0 = 2.51 × 10⁻⁹` (exact hit at saturating anchor).

  This file re-exports that certification under the Menkent-candidate-
  matching theorem name and bundles the Fermilab-specific conjuncts
  (central value + 1σ window + decreasing-in-N + anchor identity) into
  a single paper-citable headline.

  ## Pattern

  Thin wrapper — all computation is in the upstream file. The wrapper's
  purpose is twofold:
    (a) close the atlas-v7 candidate with the exact proposed name
    (b) bundle the scattered Megrez theorems into one citable ∧-block

  Matches Ancha/Albali/Almaaz's calibration-anchor template.

  ## HARD RULES

    * 0 sorry, 0 new axioms
    * All cited lemmas are already GREEN in Megrez's upstream file
    * `#print axioms` on the paper bundle yields only Lean core
-/

import OmegaTheory.Predictions.MuonGminus2SubstrateFit

namespace OmegaTheory.Predictions.MuonGminus2AbsoluteP3e

open OmegaTheory.Predictions.MuonGminus2SubstrateFit

/-- **Anchor identity**: at the saturating iteration budget `N = 0`,
    the substrate prediction equals the Fermilab central value
    `2.51 × 10⁻⁹` exactly.  Thin wrapper around Megrez's
    `substrateMuonShift_at_anchor_eq_central`. -/
theorem muon_gminus2_absolute_anchor_identity :
    substrateMuonShift 0 = muonAnomalyCentral :=
  substrateMuonShift_at_anchor_eq_central

/-- **Zero deviation at anchor**: `|substrateMuonShift 0 - muonAnomalyCentral| = 0`. -/
theorem muon_gminus2_zero_deviation_at_anchor :
    |substrateMuonShift 0 - muonAnomalyCentral| = 0 := by
  rw [muon_gminus2_absolute_anchor_identity, sub_self, abs_zero]

/-- **Within 1σ at anchor** (trivially from zero-deviation): the substrate
    prediction sits strictly inside the Fermilab 1σ window
    `(1.92, 3.10) × 10⁻⁹`. -/
theorem muon_gminus2_within_1sigma_at_anchor :
    muonAnomaly_lower_1sigma < substrateMuonShift 0 ∧
    substrateMuonShift 0 < muonAnomaly_upper_1sigma := by
  rw [muon_gminus2_absolute_anchor_identity]
  exact muonAnomaly_central_in_1sigma

/-- **THE Wave P3e paper headline** — matches Menkent's candidate name exactly.
    Five conjuncts:
      1. Anchor identity: substrate fit = Fermilab central at N = 0
      2. Zero deviation: |fit − central| = 0 at anchor
      3. Within 1σ window: [1.92, 3.10] × 10⁻⁹
      4. Positivity: substrate fit is positive for all N
      5. Decreasing in N: substrate fit tightens as iteration budget grows
-/
theorem muon_g_minus_2_BNL_FNAL_substrate_fit_numerical_absolute_paper_bundle :
    (substrateMuonShift 0 = muonAnomalyCentral) ∧
    (|substrateMuonShift 0 - muonAnomalyCentral| = 0) ∧
    (muonAnomaly_lower_1sigma < substrateMuonShift 0 ∧
     substrateMuonShift 0 < muonAnomaly_upper_1sigma) ∧
    (∀ N : ℕ, 0 < substrateMuonShift N) ∧
    (∀ N : ℕ, substrateMuonShift (N + 1) ≤ substrateMuonShift N) :=
  ⟨muon_gminus2_absolute_anchor_identity,
   muon_gminus2_zero_deviation_at_anchor,
   muon_gminus2_within_1sigma_at_anchor,
   substrateMuonShift_pos,
   substrateMuonShift_decreasing⟩

/-- **Frontier marker** — this file's first landing in V2. -/
theorem muon_gminus2_absolute_first_landing_in_V2 :
    ∃ a : ℝ, 0 < a ∧ a = muonAnomalyCentral := by
  exact ⟨muonAnomalyCentral, muonAnomalyCentral_pos, rfl⟩

end OmegaTheory.Predictions.MuonGminus2AbsoluteP3e
