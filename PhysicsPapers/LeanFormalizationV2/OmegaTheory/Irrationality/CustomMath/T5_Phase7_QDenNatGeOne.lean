/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenNatGeOne

  T-5 (Roth's theorem) — **Phase 7 ext #153: q.den ≥ 1 in ℕ (cubic+
  chain bookkeeping)**, sub session 559aaaaaaaaa — STRICT critical-path
  #316 (T-5) Phase 7 ext #153.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Direct ℕ-level positivity for q.den:

  For q : ℚ:
    `1 ≤ q.den`
    `0 < q.den`

  Direct from `Rat.pos`. Useful as a Nat-level fact (without cast).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #153 — q.den ≥ 1 in ℕ.
-/

import Mathlib.Data.Rat.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenNatGeOne

/-! ## q.den ≥ 1 in ℕ -/

/-- **🚨 Wave T5 session 559aaaaaaaaa — `1 ≤ q.den` in ℕ**.

    For q : ℚ. -/
theorem T5_qden_nat_ge_one (q : ℚ) : 1 ≤ q.den := q.pos

/-- Companion: `0 < q.den` in ℕ. -/
theorem T5_qden_nat_pos (q : ℚ) : 0 < q.den := q.pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559aaaaaaaaa — T-5 Phase 7 ext #153**.

    🏆 BOOKKEEPING — `1 ≤ q.den` in ℕ (Nat-level positivity).

    Sub-lemma 326/N. Lean-core only. -/
theorem session_559aaaaaaaaa_T5_phase7_qden_nat_ge_one_headline (q : ℚ) :
    1 ≤ q.den ∧ 0 < q.den :=
  ⟨T5_qden_nat_ge_one q, T5_qden_nat_pos q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenNatGeOne
