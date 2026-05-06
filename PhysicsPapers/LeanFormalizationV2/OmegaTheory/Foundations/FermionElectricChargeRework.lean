/-
  OmegaTheory.Foundations.FermionElectricChargeRework

  **Lion's-Pride Phase 6.5u (2026-05-06)**:
  *Honest electric-charge encoding for the Standard Model fermion
  content.  Replaces the `twoQ : ℤ` placeholder-zero for quarks
  in `Emergence/FermionContent.lean` with a proper `sixQ : ℤ`
  (six times the electric charge) that captures fractional quark
  charges without leaving ℤ.*

  ## Why this file

  Audit of `OmegaTheory/Emergence/FermionContent.lean` (lines 256-264)
  identified a gap: the `twoQ : ℤ` field for `RightHandedSinglet`
  uses `0` as placeholder for up-quark and down-quark species because
  their electric charges (`+2/3, -1/3`) are NOT integers when doubled.
  The file's own comment admits "placeholder (fractional)".

  The honest fix: encode `sixQ : ℤ` (six times electric charge):
    • leptons: charged ↔ -6, neutral ↔ 0
    • quarks:  up-type ↔ +4, down-type ↔ -2
  All values are integers, the encoding is exact, and the
  Gell-Mann–Nishijima relation `Q = T₃ + Y/2` is bookkeeping-
  consistent.

  ## What this file ships

  | Property                                          | Theorem                                    |
  |---------------------------------------------------|--------------------------------------------|
  | `sixQ_chargedLepton := -6` (electron family)       | (definition)                              |
  | `sixQ_neutrino := 0`                              | (definition)                              |
  | `sixQ_upQuark := +4`                              | (definition: 6·(+2/3))                   |
  | `sixQ_downQuark := -2`                            | (definition: 6·(-1/3))                   |
  | `sixQ_singlet : RightHandedSinglet → ℤ`            | (the corrected charge function)            |
  | Distinct species → distinct charges                | `sixQ_singlet_speciesDistinct`              |
  | Quark charges sum to 2 per generation              | `sixQ_quarks_per_gen_sum_eq_two`            |
  | Lepton + neutrino sum = -6 per generation          | `sixQ_leptons_per_gen_sum_eq_neg_six`       |
  | Headline 4-conjunct                                | `fermion_electric_charge_rework_report`    |

  ## Honest scope

  This file ships the rigorous `sixQ : ℤ` electric-charge encoding
  for right-handed singlets, with explicit numerical values for all
  four species.  It does NOT modify the existing `FermionContent`
  file (non-breaking enhancement); the original `twoQ` placeholder
  is retained for backward compatibility, while `sixQ` is the
  HONEST encoding for downstream physics.

  This file does NOT ship:
  * Hyperchharge `Y` derivation from anomaly cancellation (that is
    `Emergence/AnomalyCancellation.lean`, already shipped).
  * Gell-Mann–Nishijima relation `Q = T₃ + Y/2` algebraic verification
    for all fermions (Phase 6.5u-cont, ~150 LOC tractable).

  What it DOES ship: integer-valued correct electric charges for
  all four singlet species, plus consistency checks (distinctness,
  per-generation sums).

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure structural enhancement of existing FermionContent. Closes
  the "placeholder (fractional)" honest gap with a proper integer
  encoding via 6× scaling.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Emergence.FermionContent
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.FermionElectricChargeRework

open OmegaTheory.Emergence.FermionContent

/-! ## 1. SixQ values per singlet species

    Six times the electric charge in units of `e`. The factor 6
    keeps everything in ℤ:
      Q(lepton)         = -1          → sixQ = -6
      Q(neutrino)       =  0          → sixQ =  0
      Q(up-type quark)  = +2/3        → sixQ = +4
      Q(down-type quark)= -1/3        → sixQ = -2 -/

/-- **Six times electric charge for charged lepton (e, μ, τ)**:
    `sixQ = -6` (Q = -1·e). -/
def sixQ_chargedLepton : ℤ := -6

/-- **Six times electric charge for neutrino (ν_e, ν_μ, ν_τ)**:
    `sixQ = 0` (electrically neutral). -/
def sixQ_neutrino : ℤ := 0

/-- **Six times electric charge for up-type quark (u, c, t)**:
    `sixQ = +4` (Q = +2/3·e). -/
def sixQ_upQuark : ℤ := 4

/-- **Six times electric charge for down-type quark (d, s, b)**:
    `sixQ = -2` (Q = -1/3·e). -/
def sixQ_downQuark : ℤ := -2

/-! ## 2. SixQ as a function on singlets -/

/-- **SixQ for right-handed singlets**: maps each species to its
    integer-valued (×6) electric charge. -/
def sixQ_singlet (s : RightHandedSinglet) : ℤ :=
  match s.species with
  | SingletSpecies.chargedLepton => sixQ_chargedLepton
  | SingletSpecies.neutrino      => sixQ_neutrino
  | SingletSpecies.upQuark       => sixQ_upQuark
  | SingletSpecies.downQuark     => sixQ_downQuark

/-! ## 3. Distinct charges for distinct species -/

/-- **All four species have distinct sixQ values** — no charge
    degeneracy across species (proved by `decide` on integer
    inequalities). -/
theorem sixQ_singlet_speciesDistinct :
    sixQ_chargedLepton ≠ sixQ_neutrino ∧
    sixQ_chargedLepton ≠ sixQ_upQuark ∧
    sixQ_chargedLepton ≠ sixQ_downQuark ∧
    sixQ_neutrino ≠ sixQ_upQuark ∧
    sixQ_neutrino ≠ sixQ_downQuark ∧
    sixQ_upQuark ≠ sixQ_downQuark := by
  unfold sixQ_chargedLepton sixQ_neutrino sixQ_upQuark sixQ_downQuark
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> decide

/-! ## 4. Per-generation charge sums -/

/-- **Up-type + down-type quarks per generation sum to +2 (sixfold)**:
    `sixQ_upQuark + sixQ_downQuark = 4 - 2 = 2 = 6·(1/3)`. Reflects
    `Q_up + Q_down = +2/3 - 1/3 = +1/3`. -/
theorem sixQ_quarks_per_gen_sum_eq_two :
    sixQ_upQuark + sixQ_downQuark = 2 := by
  unfold sixQ_upQuark sixQ_downQuark; decide

/-- **Charged lepton + neutrino per generation sum to -6 (sixfold)**:
    `sixQ_chargedLepton + sixQ_neutrino = -6 + 0 = -6 = 6·(-1)`.
    Reflects `Q_e + Q_ν = -1 + 0 = -1`. -/
theorem sixQ_leptons_per_gen_sum_eq_neg_six :
    sixQ_chargedLepton + sixQ_neutrino = -6 := by
  unfold sixQ_chargedLepton sixQ_neutrino; decide

/-! ## 5. Sum-with-color: total charge of full quark color triplet

    Each quark species comes in 3 colors. The total charge contribution
    to the universe is `3 · sixQ`:
      3 · sixQ_upQuark   = 12   (Q_total = 2)
      3 · sixQ_downQuark = -6   (Q_total = -1)
    Sum per generation including all colors:
      3·(+4) + 3·(-2) = 12 - 6 = 6 = 6·1   (Q_total quarks = +1) -/

/-- **Total quark charge per generation (with colors)**:
    `3·sixQ_upQuark + 3·sixQ_downQuark = 6 = 6·(+1)`. -/
theorem sixQ_quarks_per_gen_with_color :
    3 * sixQ_upQuark + 3 * sixQ_downQuark = 6 := by
  unfold sixQ_upQuark sixQ_downQuark; decide

/-- **Total fermion charge per generation (lepton + ν + 3·u + 3·d)**:
    `(-6) + 0 + 3·4 + 3·(-2) = -6 + 0 + 12 - 6 = 0`.  This is the
    famous SM anomaly-cancellation requirement: per generation, the
    total electric charge sums to zero. -/
theorem sixQ_total_fermion_per_gen_eq_zero :
    sixQ_chargedLepton + sixQ_neutrino +
      3 * sixQ_upQuark + 3 * sixQ_downQuark = 0 := by
  unfold sixQ_chargedLepton sixQ_neutrino sixQ_upQuark sixQ_downQuark
  decide

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 6.5u headline — fermion electric charge rework.**

    1. **All four species have distinct sixQ values** — no degeneracy.

    2. **Quarks per generation sum to +2 (sixfold)**:
       `sixQ_upQuark + sixQ_downQuark = 2`.

    3. **Leptons per generation sum to -6 (sixfold)**:
       `sixQ_chargedLepton + sixQ_neutrino = -6`.

    4. **Total fermion charge per generation = 0** (with quark colors).
       This is the famous SM anomaly-cancellation requirement:
       `(-6) + 0 + 3·(+4) + 3·(-2) = 0`. -/
theorem fermion_electric_charge_rework_report :
    (sixQ_chargedLepton ≠ sixQ_neutrino ∧
     sixQ_chargedLepton ≠ sixQ_upQuark ∧
     sixQ_chargedLepton ≠ sixQ_downQuark ∧
     sixQ_neutrino ≠ sixQ_upQuark ∧
     sixQ_neutrino ≠ sixQ_downQuark ∧
     sixQ_upQuark ≠ sixQ_downQuark) ∧
    sixQ_upQuark + sixQ_downQuark = 2 ∧
    sixQ_chargedLepton + sixQ_neutrino = -6 ∧
    sixQ_chargedLepton + sixQ_neutrino +
      3 * sixQ_upQuark + 3 * sixQ_downQuark = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact sixQ_singlet_speciesDistinct
  · exact sixQ_quarks_per_gen_sum_eq_two
  · exact sixQ_leptons_per_gen_sum_eq_neg_six
  · exact sixQ_total_fermion_per_gen_eq_zero

end OmegaTheory.Foundations.FermionElectricChargeRework
