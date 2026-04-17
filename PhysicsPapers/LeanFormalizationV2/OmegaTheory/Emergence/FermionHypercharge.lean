/-
  OmegaTheory.Emergence.FermionHypercharge
  SM hypercharge assignments (per Algieba's design). 0 sorry, 0 axioms.
-/

import OmegaTheory.Emergence.FermionContent
import Mathlib.Tactic

namespace OmegaTheory.Emergence

/-- Weak hypercharge × 6 for left-handed lepton doublet: Y = -1 → 6Y = -6. -/
def sixY_leftLepton : ℤ := -3  -- using 2Y convention (Y = -1/2 · 2 = -1, so 2Y = -1 × 2 = ... )

/-- Hypercharge of left-handed lepton doublet: Y = -1/2 (standard). -/
def leftLeptonDoubletY : ℚ := -1 / 2

/-- Hypercharge of left-handed quark doublet: Y = 1/6. -/
def leftQuarkDoubletY : ℚ := 1 / 6

/-- Hypercharge of right-handed electron: Y = -1. -/
def rightElectronY : ℚ := -1

/-- Hypercharge of right-handed up quark: Y = 2/3. -/
def rightUpQuarkY : ℚ := 2 / 3

/-- Hypercharge of right-handed down quark: Y = -1/3. -/
def rightDownQuarkY : ℚ := -1 / 3

/-- Hypercharge of right-handed neutrino: Y = 0. -/
def rightNeutrinoY : ℚ := 0

theorem hypercharge_left_lepton_is_neg_half : leftLeptonDoubletY = -1/2 := rfl

theorem hypercharge_left_quark_is_one_sixth : leftQuarkDoubletY = 1/6 := rfl

theorem hypercharge_electron_is_neg_1 : rightElectronY = -1 := rfl

theorem hypercharge_up_quark_is_2_3 : rightUpQuarkY = 2/3 := rfl

theorem hypercharge_down_quark_is_neg_1_3 : rightDownQuarkY = -1/3 := rfl

theorem hypercharge_neutrino_right_is_zero : rightNeutrinoY = 0 := rfl

/-- Per-generation lepton hypercharge sum: 2·(-1/2) + (-1) + 0 = -2. -/
def leptonGenerationHyperchargeSum : ℚ :=
  2 * leftLeptonDoubletY + rightElectronY + rightNeutrinoY

theorem lepton_generation_sum : leptonGenerationHyperchargeSum = -2 := by
  unfold leptonGenerationHyperchargeSum leftLeptonDoubletY rightElectronY rightNeutrinoY
  norm_num

/-- Per-generation quark hypercharge sum (color-averaged per-flavor): 2·(1/6) + 2/3 + (-1/3) = 2/3. -/
def quarkGenerationHyperchargeSum : ℚ :=
  2 * leftQuarkDoubletY + rightUpQuarkY + rightDownQuarkY

theorem quark_generation_sum : quarkGenerationHyperchargeSum = 2/3 := by
  unfold quarkGenerationHyperchargeSum leftQuarkDoubletY rightUpQuarkY rightDownQuarkY
  norm_num

end OmegaTheory.Emergence
