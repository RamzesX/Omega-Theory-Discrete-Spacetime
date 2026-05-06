/-
  OmegaTheory.Foundations.HiggsGellMannNishijima

  **Phase B step 3 (2026-05-06)**:
  *Extend the Gell-Mann–Nishijima relation `Q = T_3 + Y` to the
  two components of the Higgs doublet H⁺ (charged) and H⁰ (neutral),
  using the doublet structure shipped in `HiggsDoubletStructure.lean`
  + `Y_H = +1/2` (Phase B step 1's missing assignment).*

  ## Why this file

  Phase 6.5v (`Foundations/GellMannNishijimaRelation.lean`, 2026-05-06)
  shipped GMN for all 8 SM fermion species but EXPLICITLY OMITTED the
  Higgs (the Higgs is not a fermion).  Phase B step 1 supplied the
  missing `higgsHypercharge = 1/2` assignment and the `HiggsT3 :
  Fin 2 → WeakIsospin` map.  This file closes the GMN extension:

      Q(H⁺) = T_3(H⁺) + Y_H = (+1/2) + (+1/2) = +1   (charged)
      Q(H⁰) = T_3(H⁰) + Y_H = (-1/2) + (+1/2) =  0   (neutral)

  After EW SSB, the neutral component H⁰ remains as the physical
  Higgs `h` (with Q = 0), while the charged H⁺ and the imaginary
  part of H⁰ are absorbed as the 3 Goldstone modes eaten by W⁺,
  W⁻, Z (formalized in `HiggsGoldstoneIdentification.lean` —
  Phase B step 4, deferred).

  ## What this file ships

  | Property                          | Theorem                              |
  |-----------------------------------|--------------------------------------|
  | T_3 of H⁺ as ℚ                    | `T3_higgs_plus_eq` (rational form)   |
  | T_3 of H⁰ as ℚ                    | `T3_higgs_zero_eq` (rational form)   |
  | Q(H⁺) = +1                        | `GMN_higgs_plus`                     |
  | Q(H⁰) = 0                         | `GMN_higgs_zero`                     |
  | Distinct charges                  | `higgs_components_distinct_charge`   |
  | Headline                          | `higgs_GMN_report` (4-conjunct)      |

  ## Honest scope

  Pure rational arithmetic.  Reuses `HiggsT3`, `higgsHypercharge`
  from `HiggsDoubletStructure.lean`.  Pattern-matches the existing
  `GellMannNishijimaRelation.lean` proofs.  No new axioms.

  ## Author

  Single-thread Opus 4.7 [1M context].  Phase B step 3 of the
  full-mode plan (2026-05-06).
-/

import OmegaTheory.Foundations.HiggsDoubletStructure
import OmegaTheory.Foundations.GellMannNishijimaRelation
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.HiggsGellMannNishijima

open OmegaTheory.Foundations.HiggsDoubletStructure
open OmegaTheory.Foundations.GellMannNishijimaRelation
open OmegaTheory.Emergence.FermionContent

/-! ## 1. T_3 values for Higgs components as rationals

    `HiggsT3 0 = WeakIsospin.plusHalf` (T_3 = +1/2),
    `HiggsT3 1 = WeakIsospin.minusHalf` (T_3 = -1/2).
    We express them as ℚ for arithmetic with `higgsHypercharge`. -/

/-- **T_3 of upper Higgs component as ℚ**: `T_3(H⁺) = +1/2`. -/
def T3_higgs_plus : ℚ := 1 / 2

/-- **T_3 of lower Higgs component as ℚ**: `T_3(H⁰) = -1/2`. -/
def T3_higgs_zero : ℚ := -1 / 2

/-- **`T3_higgs_plus = 1/2`** — definitional. -/
theorem T3_higgs_plus_eq : T3_higgs_plus = 1 / 2 := rfl

/-- **`T3_higgs_zero = -1/2`** — definitional. -/
theorem T3_higgs_zero_eq : T3_higgs_zero = -1 / 2 := rfl

/-! ## 2. Electric charges of Higgs components

    Q(H⁺) = +1 (charged), Q(H⁰) = 0 (neutral). -/

/-- **Electric charge of charged upper Higgs component** = +1. -/
def Q_higgs_plus : ℚ := 1

/-- **Electric charge of neutral lower Higgs component** = 0. -/
def Q_higgs_zero : ℚ := 0

/-! ## 3. Gell-Mann–Nishijima `Q = T_3 + Y` for Higgs

    With `higgsHypercharge = +1/2` (Phase B step 1):

      Q(H⁺) = T_3(H⁺) + Y_H = (+1/2) + (+1/2) = +1    ✓ charged
      Q(H⁰) = T_3(H⁰) + Y_H = (-1/2) + (+1/2) =  0    ✓ neutral -/

/-- **GMN for charged Higgs** `H⁺`: `Q(H⁺) = T_3(H⁺) + Y_H = +1`. -/
theorem GMN_higgs_plus :
    Q_higgs_plus = T3_higgs_plus + higgsHypercharge := by
  unfold Q_higgs_plus T3_higgs_plus higgsHypercharge
  norm_num

/-- **GMN for neutral Higgs** `H⁰`: `Q(H⁰) = T_3(H⁰) + Y_H = 0`. -/
theorem GMN_higgs_zero :
    Q_higgs_zero = T3_higgs_zero + higgsHypercharge := by
  unfold Q_higgs_zero T3_higgs_zero higgsHypercharge
  norm_num

/-- **Distinct charges**: `Q(H⁺) ≠ Q(H⁰)` (charged vs neutral). -/
theorem higgs_components_distinct_charge :
    Q_higgs_plus ≠ Q_higgs_zero := by
  unfold Q_higgs_plus Q_higgs_zero; norm_num

/-! ## 4. Headline composite -/

/-- **Phase B step 3 headline — Gell-Mann–Nishijima for the Higgs.**

    Four-conjunct composite establishing `Q = T_3 + Y` for both
    components of the Higgs doublet:

    1. **GMN for charged Higgs**: `Q(H⁺) = T_3(H⁺) + Y_H = +1`.
       The `H⁺` component carries unit positive charge before EW SSB.

    2. **GMN for neutral Higgs**: `Q(H⁰) = T_3(H⁰) + Y_H = 0`.
       The `H⁰` component is electrically neutral; after EW SSB
       its real radial mode IS the physical Higgs `h`.

    3. **Distinct charges**: `Q(H⁺) ≠ Q(H⁰)`.
       The two components are physically distinguishable.

    4. **Higgs hypercharge is the missing piece**: `Y_H = +1/2`
       (the assignment supplied in Phase B step 1).

    Together with `Foundations/GellMannNishijimaRelation.lean` (the
    8 fermion families), this closes GMN for the entire SM scalar +
    fermion sector. -/
theorem higgs_GMN_report :
    Q_higgs_plus = T3_higgs_plus + higgsHypercharge ∧
    Q_higgs_zero = T3_higgs_zero + higgsHypercharge ∧
    Q_higgs_plus ≠ Q_higgs_zero ∧
    higgsHypercharge = 1 / 2 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact GMN_higgs_plus
  · exact GMN_higgs_zero
  · exact higgs_components_distinct_charge
  · exact higgsHypercharge_eq_one_half

end OmegaTheory.Foundations.HiggsGellMannNishijima
