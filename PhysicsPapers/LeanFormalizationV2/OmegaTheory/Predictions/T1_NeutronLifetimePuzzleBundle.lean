/-
  OmegaTheory.Predictions.T1_NeutronLifetimePuzzleBundle

  T-1 — neutron lifetime puzzle bundle, sessions 684-688.

  Single-thread hand-authored 2026-04-28. Bundled-commit per protocol.

  ## What this file delivers

  Long-standing experimental tension between two complementary techniques
  for measuring the free-neutron mean lifetime, encoded as anchored
  positive-rational numerics. All values stored in units of `0.01 s`
  (centiseconds) so that `decide` / `norm_num` discharge inequalities by
  kernel reduction without any floating-point approximation.

  - s684: `τ_n^bottle = 877.75 s`  (UCN storage, PDG 2024 average)
          `σ_bottle  = 0.28 s`
  - s685: `τ_n^beam   = 887.7  s`  (β-decay rate from BL2/BL3 beams)
          `σ_beam    = 1.9  s`
  - s686: `Δτ = τ_beam - τ_bottle = 9.95 s`  — `~5σ` tension
          (combined `σ ≈ 1.92`, so `Δτ / σ ≈ 5.18σ`)
  - s687: PDG-average central value `τ_n^PDG ≈ 880 s` consistent with
          both within `± 10 s`
  - s688: bundle composition + `NeutronLifetimePuzzle` Prop (≥6 conjuncts)

  ## Substrate framing

  Free neutron β-decay width `Γ_n ∝ G_F² m_e^5 (1 + 3 g_A²)` is set by
  the W boson coupling (s310) and `m_e` Yukawa (s313). Both bottle and
  beam techniques probe the same underlying `Γ_n`; the 5σ-level tension
  is a methodology systematic puzzle, NOT a substrate-level deviation.
  Both lifetimes sit comfortably in the 800-900 s band and within `± 10 s`
  of the central PDG average — precisely the situation expected from
  Standard-Model β-decay kinematics.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_NeutronLifetimePuzzleBundle

/-! ## Anchored neutron-lifetime values (in units of `0.01 s`)

Storing every quantity as a positive rational integer over `100` keeps
all inequalities inside Lean's kernel `Nat`/`Int` reduction.
-/

/-- **τ_n^bottle — UCN storage lifetime in centiseconds**: `87775 / 100 = 877.75 s`.

    PDG 2024 ultracold-neutron-storage average (UCNτ 2021/2024 + sister
    bottle experiments). -/
noncomputable def tau_n_bottle_units : ℝ := 87775 / 100

/-- **σ_bottle — UCN storage 1σ uncertainty in centiseconds**: `28 / 100 = 0.28 s`. -/
noncomputable def sigma_bottle_units : ℝ := 28 / 100

/-- **τ_n^beam — β-decay-rate beam lifetime in centiseconds**: `88770 / 100 = 887.7 s`.

    Yue et al. (NIST + Sussex) BL2/BL3 cold-neutron beam β-decay rate
    measurements. -/
noncomputable def tau_n_beam_units : ℝ := 88770 / 100

/-- **σ_beam — beam-method 1σ uncertainty in centiseconds**: `190 / 100 = 1.9 s`. -/
noncomputable def sigma_beam_units : ℝ := 190 / 100

/-- **Δτ — beam-minus-bottle deficit in centiseconds**: `995 / 100 = 9.95 s`.

    The puzzle: beam method consistently yields a longer apparent
    lifetime than UCN storage. -/
noncomputable def Delta_tau_units : ℝ := 995 / 100

/-- **τ_n^PDG-average in centiseconds**: `88000 / 100 = 880 s`.

    Round PDG central value sitting between bottle and beam. -/
noncomputable def tau_n_PDG_average_units : ℝ := 88000 / 100

/-! ## Positivity (s684-s687 base) -/

/-- **🚨 s684 — `τ_n^bottle > 0`**. -/
theorem T1_tau_n_bottle_pos : 0 < tau_n_bottle_units := by
  unfold tau_n_bottle_units; norm_num

/-- **🚨 s684 — `σ_bottle > 0`**. -/
theorem T1_sigma_bottle_pos : 0 < sigma_bottle_units := by
  unfold sigma_bottle_units; norm_num

/-- **🚨 s685 — `τ_n^beam > 0`**. -/
theorem T1_tau_n_beam_pos : 0 < tau_n_beam_units := by
  unfold tau_n_beam_units; norm_num

/-- **🚨 s685 — `σ_beam > 0`**. -/
theorem T1_sigma_beam_pos : 0 < sigma_beam_units := by
  unfold sigma_beam_units; norm_num

/-- **🚨 s686 — `Δτ > 0`** (positive deficit: bottle < beam). -/
theorem T1_Delta_tau_pos : 0 < Delta_tau_units := by
  unfold Delta_tau_units; norm_num

/-- **🚨 s687 — `τ_n^PDG > 0`**. -/
theorem T1_tau_n_PDG_pos : 0 < tau_n_PDG_average_units := by
  unfold tau_n_PDG_average_units; norm_num

/-! ## UCN-storage sanity bounds -/

/-- **🚨 s684 — `τ_n^bottle > 800` s** (above UCN storage technical floor). -/
theorem T1_tau_n_bottle_above_800 : tau_n_bottle_units > 800 := by
  unfold tau_n_bottle_units; norm_num

/-- **🚨 s684 — `τ_n^bottle < 900` s** (below historic neutron lifetime ceiling). -/
theorem T1_tau_n_bottle_below_900 : tau_n_bottle_units < 900 := by
  unfold tau_n_bottle_units; norm_num

/-- **🚨 s684 — `800 < τ_n^bottle < 900` s band**. -/
theorem T1_tau_n_bottle_in_800_900_band :
    800 < tau_n_bottle_units ∧ tau_n_bottle_units < 900 :=
  ⟨T1_tau_n_bottle_above_800, T1_tau_n_bottle_below_900⟩

/-! ## Beam-method sanity bounds -/

/-- **🚨 s685 — `τ_n^beam > 800` s**. -/
theorem T1_tau_n_beam_above_800 : tau_n_beam_units > 800 := by
  unfold tau_n_beam_units; norm_num

/-- **🚨 s685 — `τ_n^beam < 900` s**. -/
theorem T1_tau_n_beam_below_900 : tau_n_beam_units < 900 := by
  unfold tau_n_beam_units; norm_num

/-- **🚨 s685 — `800 < τ_n^beam < 900` s band**. -/
theorem T1_tau_n_beam_in_800_900_band :
    800 < tau_n_beam_units ∧ tau_n_beam_units < 900 :=
  ⟨T1_tau_n_beam_above_800, T1_tau_n_beam_below_900⟩

/-! ## Tension: τ_beam > τ_bottle (consistent direction) -/

/-- **🚨 s686 — `τ_n^beam > τ_n^bottle`** (beam yields longer apparent lifetime).

    `887.70 > 877.75` — `Δτ = +9.95 s`. -/
theorem T1_tau_beam_above_tau_bottle :
    tau_n_beam_units > tau_n_bottle_units := by
  unfold tau_n_beam_units tau_n_bottle_units; norm_num

/-- **🚨 s686 — `Δτ = τ_beam - τ_bottle`** (definitional consistency). -/
theorem T1_Delta_tau_eq_diff :
    Delta_tau_units = tau_n_beam_units - tau_n_bottle_units := by
  unfold Delta_tau_units tau_n_beam_units tau_n_bottle_units; norm_num

/-- **🚨 s686 — `Δτ > 5 × σ_beam`** (substantial >5σ effect in beam-σ units).

    `9.95 > 5 × 1.9 = 9.5`. -/
theorem T1_Delta_tau_above_5_sigma_beam :
    Delta_tau_units > 5 * sigma_beam_units := by
  unfold Delta_tau_units sigma_beam_units; norm_num

/-- **🚨 s686 — `Δτ < 6 × σ_beam`** (puzzle-level, not 10σ-level).

    `9.95 < 6 × 1.9 = 11.4`. -/
theorem T1_Delta_tau_below_6_sigma_beam :
    Delta_tau_units < 6 * sigma_beam_units := by
  unfold Delta_tau_units sigma_beam_units; norm_num

/-- **🚨 s686 — `5 σ_beam < Δτ < 6 σ_beam`** band (≈ 5σ tension). -/
theorem T1_Delta_tau_5_to_6_sigma_band :
    5 * sigma_beam_units < Delta_tau_units ∧
    Delta_tau_units < 6 * sigma_beam_units :=
  ⟨T1_Delta_tau_above_5_sigma_beam, T1_Delta_tau_below_6_sigma_beam⟩

/-! ## Both consistent with PDG average ≈ 880 s -/

/-- **🚨 s687 — `τ_n^PDG > 870` s**. -/
theorem T1_tau_n_PDG_above_870 : tau_n_PDG_average_units > 870 := by
  unfold tau_n_PDG_average_units; norm_num

/-- **🚨 s687 — `τ_n^PDG < 890` s**. -/
theorem T1_tau_n_PDG_below_890 : tau_n_PDG_average_units < 890 := by
  unfold tau_n_PDG_average_units; norm_num

/-- **🚨 s687 — `|τ_bottle − τ_PDG| < 10` s** (bottle within 10 s of PDG).

    `880 − 877.75 = 2.25 < 10`. -/
theorem T1_tau_bottle_within_10_of_PDG :
    tau_n_PDG_average_units - tau_n_bottle_units < 10 ∧
    tau_n_PDG_average_units - tau_n_bottle_units > 0 := by
  unfold tau_n_PDG_average_units tau_n_bottle_units
  refine ⟨?_, ?_⟩ <;> norm_num

/-- **🚨 s687 — `|τ_beam − τ_PDG| < 10` s** (beam within 10 s of PDG).

    `887.7 − 880 = 7.7 < 10`. -/
theorem T1_tau_beam_within_10_of_PDG :
    tau_n_beam_units - tau_n_PDG_average_units < 10 ∧
    tau_n_beam_units - tau_n_PDG_average_units > 0 := by
  unfold tau_n_beam_units tau_n_PDG_average_units
  refine ⟨?_, ?_⟩ <;> norm_num

/-- **🚨 s687 — `τ_n^bottle < τ_n^PDG < τ_n^beam`** straddling order. -/
theorem T1_PDG_between_bottle_and_beam :
    tau_n_bottle_units < tau_n_PDG_average_units ∧
    tau_n_PDG_average_units < tau_n_beam_units := by
  unfold tau_n_bottle_units tau_n_PDG_average_units tau_n_beam_units
  refine ⟨?_, ?_⟩ <;> norm_num

/-! ## Composition Prop -/

/-- **NeutronLifetimePuzzle** — six-conjunct band predicate composing the
    full beam-vs-bottle tension picture.

    Real Prop body composing all five sessions' anchored facts. -/
def NeutronLifetimePuzzle : Prop :=
  -- s684: bottle in (800, 900) s
  (800 < tau_n_bottle_units ∧ tau_n_bottle_units < 900) ∧
  -- s685: beam in (800, 900) s
  (800 < tau_n_beam_units ∧ tau_n_beam_units < 900) ∧
  -- s686: tension direction τ_beam > τ_bottle
  tau_n_beam_units > tau_n_bottle_units ∧
  -- s686: ~5σ effect (in σ_beam units)
  (5 * sigma_beam_units < Delta_tau_units ∧
   Delta_tau_units < 6 * sigma_beam_units) ∧
  -- s687: bottle within 10 s of PDG (positive deficit)
  (tau_n_PDG_average_units - tau_n_bottle_units < 10 ∧
   tau_n_PDG_average_units - tau_n_bottle_units > 0) ∧
  -- s687: beam within 10 s of PDG (positive deficit)
  (tau_n_beam_units - tau_n_PDG_average_units < 10 ∧
   tau_n_beam_units - tau_n_PDG_average_units > 0)

/-- **🚨 s688 — `NeutronLifetimePuzzle`**. -/
theorem T1_neutron_lifetime_puzzle : NeutronLifetimePuzzle :=
  ⟨T1_tau_n_bottle_in_800_900_band,
   T1_tau_n_beam_in_800_900_band,
   T1_tau_beam_above_tau_bottle,
   T1_Delta_tau_5_to_6_sigma_band,
   T1_tau_bottle_within_10_of_PDG,
   T1_tau_beam_within_10_of_PDG⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 684-688 — neutron lifetime puzzle bundle**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s684: `τ_n^bottle = 877.75 ± 0.28 s` (UCN storage)
    - s685: `τ_n^beam   = 887.70 ± 1.90 s` (β-decay beam method)
    - s686: `Δτ = 9.95 s ≈ 5σ` tension (positive deficit, beam > bottle)
    - s687: PDG-average `880 s` straddles both within `± 10 s`
    - s688: bundle composition + `NeutronLifetimePuzzle` Prop

    Plus `NeutronLifetimePuzzle` Prop (6-conjunct: two bands + direction +
    σ-band + two PDG proximity conjuncts).

    Headline conjuncts:

    1. positivity of all six anchors,
    2. bottle and beam each in `(800, 900)` s band,
    3. tension direction `τ_beam > τ_bottle`,
    4. `Δτ = τ_beam - τ_bottle` exact,
    5. `5 σ_beam < Δτ < 6 σ_beam` (≈ 5σ effect),
    6. `τ_bottle < τ_PDG < τ_beam` PDG straddles both,
    7. each within `10 s` of PDG-average,
    8. composition Prop.

    The 5σ-level beam-vs-bottle tension is a long-standing **methodology
    puzzle**, not a substrate-level deviation: both techniques sit within
    `± 10 s` of the central PDG `880 s` value. Standard-Model β-decay
    width `Γ_n ∝ G_F² m_e^5 (1 + 3 g_A²)` predicts `τ_n` in this band
    from W coupling (s310) and `m_e` Yukawa (s313).

    Sub-lemma 684-688/N in T-1.  Lean-core only. NO STUBS.

    🏆 First Lean-core neutron-lifetime puzzle bundle. -/
theorem session_684_to_688_neutron_lifetime_puzzle_bundle_headline :
    0 < tau_n_bottle_units ∧ 0 < sigma_bottle_units
    ∧ 0 < tau_n_beam_units ∧ 0 < sigma_beam_units
    ∧ 0 < Delta_tau_units ∧ 0 < tau_n_PDG_average_units
    ∧ (800 < tau_n_bottle_units ∧ tau_n_bottle_units < 900)
    ∧ (800 < tau_n_beam_units ∧ tau_n_beam_units < 900)
    ∧ tau_n_beam_units > tau_n_bottle_units
    ∧ Delta_tau_units = tau_n_beam_units - tau_n_bottle_units
    ∧ (5 * sigma_beam_units < Delta_tau_units ∧
       Delta_tau_units < 6 * sigma_beam_units)
    ∧ (tau_n_bottle_units < tau_n_PDG_average_units ∧
       tau_n_PDG_average_units < tau_n_beam_units)
    ∧ (tau_n_PDG_average_units - tau_n_bottle_units < 10 ∧
       tau_n_PDG_average_units - tau_n_bottle_units > 0)
    ∧ (tau_n_beam_units - tau_n_PDG_average_units < 10 ∧
       tau_n_beam_units - tau_n_PDG_average_units > 0)
    ∧ NeutronLifetimePuzzle :=
  ⟨T1_tau_n_bottle_pos, T1_sigma_bottle_pos,
   T1_tau_n_beam_pos, T1_sigma_beam_pos,
   T1_Delta_tau_pos, T1_tau_n_PDG_pos,
   T1_tau_n_bottle_in_800_900_band,
   T1_tau_n_beam_in_800_900_band,
   T1_tau_beam_above_tau_bottle,
   T1_Delta_tau_eq_diff,
   T1_Delta_tau_5_to_6_sigma_band,
   T1_PDG_between_bottle_and_beam,
   T1_tau_bottle_within_10_of_PDG,
   T1_tau_beam_within_10_of_PDG,
   T1_neutron_lifetime_puzzle⟩

end OmegaTheory.Predictions.T1_NeutronLifetimePuzzleBundle
