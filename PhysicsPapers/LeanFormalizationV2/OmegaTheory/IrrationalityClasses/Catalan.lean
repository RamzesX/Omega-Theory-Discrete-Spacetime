/-
  OmegaTheory.IrrationalityClasses.Catalan

  **Catalan's constant — numerical bounds**  (Alrescha α Piscium, 2026-04-21).

  Status: SCAFFOLDING ONLY — definition of `catalanG` and `catalanTerm` only.
  Full bounds proofs (`catalanG_pos`, `catalanG_lt_one`, four-way distinctness)
  are HANDED OFF to wizard wave Alrescha-A (see coordinator SendMessage).

  Rationale: the bounds use `Antitone.alternating_series_le_tendsto` +
  term-sequence antitonicity + term → 0 + Mathlib PSeries summability.
  This is a clean 5-10 theorem bundle for a lean-proof-wizard.

  Design reference: `05_catalan_G_class.md`, `12_graph_register.md`.
-/

import OmegaTheory.IrrationalityClasses.Basic
import Mathlib.Analysis.PSeries
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Tactic

namespace OmegaTheory.IrrationalityClasses

open Real BigOperators Finset

/-! ## Definition of Catalan's constant

We write the alternating series in Mathlib-canonical `(-1)^n * f n` form so
that `Antitone.alternating_series_le_tendsto` applies directly. -/

/-- Positive term sequence `aₙ = 1/(2n+1)²`. -/
noncomputable def catalanTerm (n : ℕ) : ℝ := 1 / ((2 * n + 1 : ℝ) ^ 2)

/-- Catalan's constant, Bradley alternating series
    `G := Σ' (-1)^n / (2n+1)²` in Mathlib's `∑' (-1)^n * f n` form. -/
noncomputable def catalanG : ℝ := ∑' n : ℕ, (-1 : ℝ) ^ n * catalanTerm n

/-! ## Non-negativity and antitonicity of the term sequence (sanity lemmas) -/

theorem catalanTerm_pos (n : ℕ) : 0 < catalanTerm n := by
  unfold catalanTerm
  positivity

theorem catalanTerm_nonneg (n : ℕ) : 0 ≤ catalanTerm n := (catalanTerm_pos n).le

/-- The term sequence `aₙ = 1/(2n+1)²` is antitone (decreasing). -/
theorem catalanTerm_antitone : Antitone catalanTerm := by
  intro m n hmn
  unfold catalanTerm
  apply one_div_le_one_div_of_le
  · positivity
  · have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hmn' : (m : ℝ) ≤ n := Nat.cast_le.mpr hmn
    nlinarith

end OmegaTheory.IrrationalityClasses
