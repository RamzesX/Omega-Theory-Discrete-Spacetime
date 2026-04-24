/-
  OmegaTheory.Predictions.TauMassAbsoluteP3m

  **Wave P3m** (hand-written by session lead, cycle-48) — tau lepton
  absolute-mass certification, closing Grothendieck-proposed
  :TheoremCandidate `tauMass_MeV_absolute_within_1pct_PDG` (MED
  difficulty per Atlas v7 graph, 0 new axioms).

  ## Physical claim

  PDG 2024 central value for the tau lepton mass:

      `m_τ = 1776.86 MeV`     (from B-factory kinematic fits)

  OmegaTheory's **Koide quadratic** gives a substrate-derived tau-mass
  prediction (`Emergence.KoideRelation.koidePredictedTau`) using the
  PDG electron and muon masses plus the Koide invariant `Q = 2/3`.
  The prediction sits:

      `koidePredictedTau ∈ (1776.961 MeV, 1776.984 MeV)`

  which is within **0.11 MeV** (~`6 × 10⁻⁵`, i.e. `0.006%`) of the
  PDG central value.  **This is ~160× tighter than the 1% bracket**
  the Grothendieck atlas asked for.

  ## Paper bundle

  Packaged in the Menkent absolute-template pattern with 5 conjuncts:

    1. Absolute tightness: `|m_τ - koidePredictedTau| < 0.5 MeV` (Koide
       quadratic prediction, Giza — already in `KoideRelation.lean`)
    2. Stronger PDG-window: `|m_τ - koidePredictedTau| < 1% · m_τ`
       (i.e. `|m_τ - koidePredictedTau| < 17.76 MeV`) — the form
       requested by the Grothendieck candidate
    3. Positivity of the predicted tau mass
    4. PDG hierarchy preservation: `m_e < m_μ < m_τ` held for both
       PDG central values AND the Koide-predicted tau
    5. Existence packaging — there is a strictly-positive substrate
       tau-mass prediction matching PDG to 1%

  ## Pattern

  Thin wrapper around `KoideRelation.lean` — all computation already
  GREEN upstream.  This file's value is closing the Grothendieck-flagged
  candidate name and bundling the scattered Koide theorems into a single
  paper-citable headline matching the Menkent Wave P3 template.

  ## Agent / wave

  Hand-written by session lead, cycle-48 /loop build, Wave P3m.

  ## HARD RULES

    * 0 sorry
    * 0 NEW axioms (reuses `KoideRelation`)
    * Footprint: Lean core + whatever Koide relation uses
-/

import OmegaTheory.Emergence.KoideRelation

namespace OmegaTheory.Predictions.TauMassAbsoluteP3m

open OmegaTheory.Emergence.KoideRelation
open OmegaTheory.Emergence

/-! ## §1. Re-export the Koide tau prediction -/

/-- **Tau mass prediction** — re-export of Koide's quadratic
    substrate-derived value. -/
noncomputable def substrateTauMass : ℝ := koidePredictedTau

/-- The predicted tau mass is positive. -/
theorem substrateTauMass_pos : 0 < substrateTauMass :=
  koidePredictedTau_pos

/-! ## §2. Absolute tightness (0.5 MeV Koide bracket) -/

/-- **Tight bracket**: substrate prediction within 0.5 MeV of PDG
    central `m_τ = 1776.86 MeV`. -/
theorem tauMass_within_half_MeV_of_PDG :
    |m_τ - substrateTauMass| < (1 : ℝ) / 2 :=
  tau_mass_predicted_from_koide

/-! ## §3. 1% PDG-window (the Grothendieck candidate form) -/

/-- **1% PDG bracket** — the form requested by the Grothendieck
    :TheoremCandidate `tauMass_MeV_absolute_within_1pct_PDG`.
    Follows immediately from the tighter 0.5 MeV bracket since
    1% of `m_τ = 1776.86 MeV` is ~17.76 MeV >> 0.5 MeV. -/
theorem tauMass_within_1pct_of_PDG :
    |m_τ - substrateTauMass| < m_τ / 100 := by
  have h05 := tauMass_within_half_MeV_of_PDG
  have h_bound : (1 : ℝ) / 2 ≤ m_τ / 100 := by
    show (1 : ℝ) / 2 ≤ m_τ / 100
    unfold m_τ; norm_num
  linarith

/-! ## §4. PDG hierarchy preservation — Koide-predicted τ still heaviest -/

/-- **Hierarchy preserved**: `m_e < m_μ < m_τ` still holds with the
    Koide-predicted τ replacing the PDG τ.  The predicted value is
    ~0.11 MeV above PDG central, so the inequality tightens rather
    than inverts. -/
theorem charged_lepton_hierarchy_preserved_with_substrate_tau :
    m_e < m_μ ∧ m_μ < substrateTauMass := by
  refine ⟨?_, ?_⟩
  · -- m_e = 0.51099895 < m_μ = 105.6583745
    unfold m_e m_μ; norm_num
  · -- m_μ < koidePredictedTau, from m_μ < lb ≤ koidePredictedTau
    show m_μ < substrateTauMass
    unfold substrateTauMass
    have hlb := koidePredictedTau_lb
    have hlb_val : ((42154020 : ℝ) / 1000000) ^ 2
        = (1776961402160400 : ℝ) / 10 ^ 12 := by norm_num
    have hm_μ_lt_lb : m_μ < ((42154020 : ℝ) / 1000000) ^ 2 := by
      rw [hlb_val]; unfold m_μ; norm_num
    linarith

/-! ## §5. Paper bundle — 5-conjunct headline -/

/-- **THE Wave P3m paper headline** — closes the Grothendieck-
    proposed Atlas-v7 :TheoremCandidate
    `tauMass_MeV_absolute_within_1pct_PDG`.

    Five conjuncts:
      1. `|m_τ - substrateTauMass| < 0.5 MeV` (Koide tight bracket)
      2. `|m_τ - substrateTauMass| < m_τ / 100` (the 1% form requested)
      3. `0 < substrateTauMass` (positivity)
      4. Hierarchy `m_e < m_μ < substrateTauMass` preserved
      5. Existence-form packaging: `∃ m : ℝ, 0 < m ∧ |m_τ - m| < 0.5` -/
theorem tauMass_MeV_absolute_within_1pct_PDG_paper_bundle :
    (|m_τ - substrateTauMass| < (1 : ℝ) / 2) ∧
    (|m_τ - substrateTauMass| < m_τ / 100) ∧
    (0 < substrateTauMass) ∧
    (m_e < m_μ ∧ m_μ < substrateTauMass) ∧
    (∃ m : ℝ, 0 < m ∧ |m_τ - m| < (1 : ℝ) / 2) :=
  ⟨tauMass_within_half_MeV_of_PDG,
   tauMass_within_1pct_of_PDG,
   substrateTauMass_pos,
   charged_lepton_hierarchy_preserved_with_substrate_tau,
   ⟨substrateTauMass, substrateTauMass_pos, tauMass_within_half_MeV_of_PDG⟩⟩

/-- **Frontier marker**: this is the first tau-mass **absolute**
    (named-witness) landing in V2 — electron/muon absolute pending. -/
theorem tauMass_absolute_first_landing_in_V2 :
    ∃ m : ℝ, 0 < m ∧ m = substrateTauMass :=
  ⟨substrateTauMass, substrateTauMass_pos, rfl⟩

end OmegaTheory.Predictions.TauMassAbsoluteP3m
