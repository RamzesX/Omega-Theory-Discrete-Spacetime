/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForNegPhi

  T-5 (Roth's theorem) — **Phase 7 ext #70: CONCRETE WITNESS — Roth
  for `-φ` (UNCONDITIONAL via quadratic-α discharge with same min poly
  as 1/φ)**, sub session 559kkkkk — STRICT critical-path #316 (T-5)
  Phase 7 ext #70.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Concrete UNCONDITIONAL Roth witness for `-φ` (negative golden ratio).

  Specifically:
  - α = -φ. (Min poly substitution: X ↦ -Y in φ's poly Y² - Y - 1 = 0
    gives Y² + Y - 1 = 0.)
  - Same min poly as 1/φ (= φ-1, ext #67): X² + X - 1.
  - α irrational (φ irrational + Irrational.neg).
  - aeval (-φ) (X² + X - 1) = φ² - φ - 1 = 0 ✓ (using φ² = φ+1).
  - Apply ext #44 quadratic discharge.

  Single derivation (uses polyXSqPlusXMinusOne from ext #67):
  1. `T5_roth_for_neg_phi`: RothBoundExists (-φ).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #70 — concrete witness Roth for `-φ`.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenInverse
import Mathlib.NumberTheory.Real.GoldenRatio

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForNegPhi

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenInverse
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial
open scoped goldenRatio

/-! ## -φ is irrational + aeval = 0 -/

/-- **🚨 Wave T5 session 559kkkkk — `-φ` is irrational**. -/
theorem T5_neg_phi_irrational : Irrational (-Real.goldenRatio) := by
  exact Real.goldenRatio_irrational.neg

/-- **🚨 Wave T5 session 559kkkkk — `aeval (-φ) (X² + X - 1) = 0`**. -/
theorem T5_polyXSqPlusXMinusOne_aeval_neg_phi_eq_zero :
    Polynomial.aeval (-Real.goldenRatio) polyXSqPlusXMinusOne = 0 := by
  unfold polyXSqPlusXMinusOne
  rw [map_sub, map_add, map_pow, Polynomial.aeval_X, Polynomial.aeval_C]
  rw [show ((algebraMap ℤ ℝ) 1 : ℝ) = (1 : ℝ) from by simp]
  -- Goal: (-φ)² + (-φ) - 1 = 0
  -- = φ² - φ - 1 = (φ+1) - φ - 1 = 0
  have h_phi_sq : Real.goldenRatio ^ 2 = Real.goldenRatio + 1 := Real.goldenRatio_sq
  nlinarith [h_phi_sq]

/-! ## Concrete Roth bound for -φ -/

/-- **🚨 Wave T5 session 559kkkkk — UNCONDITIONAL Roth for `-φ`**. -/
theorem T5_roth_for_neg_phi : RothBoundExists (-Real.goldenRatio) :=
  T5_quadratic_roth_via_liouville_bound
    (-Real.goldenRatio)
    T5_neg_phi_irrational
    polyXSqPlusXMinusOne
    T5_polyXSqPlusXMinusOne_ne_zero
    T5_polyXSqPlusXMinusOne_aeval_neg_phi_eq_zero
    T5_polyXSqPlusXMinusOne_natDegree

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559kkkkk — T-5 Phase 7 ext #70:
    UNCONDITIONAL Roth for `-φ`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #70.

    🏆 Pell quadratic family complete: φ + ψ + 1/φ + (-φ) all UNCONDITIONALLY
    proved.

    Number-theoretic note: `-φ` and `1/φ = φ - 1` are the two roots of
    X² + X - 1 (paired under inversion in the quadratic ring).

    Mathlib usage: `Real.goldenRatio_irrational.neg`, polyXSqPlusXMinusOne
    (from ext #67), `nlinarith` with `Real.goldenRatio_sq`.

    Sub-lemma 263/N in T-1 (T-5 Phase 7 ext #70).  Lean-core only. -/
theorem session_559kkkkk_T5_phase7_roth_for_neg_phi_headline :
    RothBoundExists (-Real.goldenRatio) :=
  T5_roth_for_neg_phi

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForNegPhi
