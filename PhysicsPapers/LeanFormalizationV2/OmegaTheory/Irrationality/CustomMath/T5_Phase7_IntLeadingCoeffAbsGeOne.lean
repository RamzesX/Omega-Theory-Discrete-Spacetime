/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntLeadingCoeffAbsGeOne

  T-5 (Roth's theorem) — **Phase 7 ext #139: |leadingCoeff cast| ≥ 1
  for non-zero ℤ-poly (cubic+ chain bookkeeping)**, sub session
  559mmmmmmmm — STRICT critical-path #316 (T-5) Phase 7 ext #139.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Integer-coefficient strength: for p ∈ ℤ[X] with p ≠ 0:
    `1 ≤ |((p.leadingCoeff : ℤ) : ℝ)|`

  Used in cubic+ chain to show M ≥ 1 (Roth constant ≤ 1).

  Strategy: p.leadingCoeff ≠ 0 (in ℤ) → |p.leadingCoeff| ≥ 1 (Int.one_le_abs)
  → |(p.leadingCoeff : ℝ)| ≥ 1 via cast.

  Single derivation:
  1. `T5_int_leadingCoeff_abs_ge_one`: `1 ≤ |(p.leadingCoeff : ℝ)|`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #139 — |leadingCoeff cast| ≥ 1 for non-zero ℤ-poly.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Algebra.Polynomial.Degree.Lemmas
import Mathlib.Data.Real.Basic
import Mathlib.Data.Int.Cast.Lemmas

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntLeadingCoeffAbsGeOne

open Polynomial

/-! ## leadingCoeff cast abs ≥ 1 -/

/-- **🚨 Wave T5 session 559mmmmmmmm — `1 ≤ |(p.leadingCoeff : ℝ)|`**.

    For p ∈ ℤ[X] with p ≠ 0. -/
theorem T5_int_leadingCoeff_abs_ge_one (p : Polynomial ℤ) (hp_ne : p ≠ 0) :
    (1 : ℝ) ≤ |((p.leadingCoeff : ℤ) : ℝ)| := by
  have h_lead_ne : p.leadingCoeff ≠ 0 := Polynomial.leadingCoeff_ne_zero.mpr hp_ne
  have h_natAbs_pos : 0 < p.leadingCoeff.natAbs := Int.natAbs_pos.mpr h_lead_ne
  have h_natAbs_ge_one : 1 ≤ p.leadingCoeff.natAbs := h_natAbs_pos
  -- |((n : ℤ) : ℝ)| = (n.natAbs : ℝ)
  have h_abs_cast : |((p.leadingCoeff : ℤ) : ℝ)| = (p.leadingCoeff.natAbs : ℝ) := by
    rw [show ((p.leadingCoeff : ℤ) : ℝ) = ((p.leadingCoeff : ℝ)) from rfl]
    exact_mod_cast (Int.cast_natAbs p.leadingCoeff).symm
  rw [h_abs_cast]
  exact_mod_cast h_natAbs_ge_one

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559mmmmmmmm — T-5 Phase 7 ext #139**.

    🏆 BOOKKEEPING — `1 ≤ |(p.leadingCoeff : ℝ)|` for p ∈ ℤ[X], p ≠ 0.

    Strategy: p.leadingCoeff ≠ 0 in ℤ → |p.leadingCoeff| ≥ 1 (Int.one_le_abs)
    → cast to ℝ preserves.

    Used in cubic+ chain to show M ≥ 1 → Roth constant `M^(-1/k) ≤ 1`.

    Sub-lemma 312/N. Lean-core only. -/
theorem session_559mmmmmmmm_T5_phase7_int_leadingCoeff_abs_ge_one_headline
    (p : Polynomial ℤ) (hp_ne : p ≠ 0) :
    (1 : ℝ) ≤ |((p.leadingCoeff : ℤ) : ℝ)| :=
  T5_int_leadingCoeff_abs_ge_one p hp_ne

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntLeadingCoeffAbsGeOne
