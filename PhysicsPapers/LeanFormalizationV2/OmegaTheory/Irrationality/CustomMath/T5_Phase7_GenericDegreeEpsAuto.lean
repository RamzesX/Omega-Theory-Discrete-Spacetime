/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeEpsAuto

  T-5 (Roth's theorem) — **Phase 7 ext #180: Generic-degree ε > 0
  auto-derivation from ε > n-2 (n ≥ 2)**, sub session 559bbbbbbbbbb
  — STRICT critical-path #316 (T-5) Phase 7 ext #180.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Auto-derivation of ε > 0 from ε > n-2 when n ≥ 2:

  For n : ℕ with n ≥ 2 and ε : ℝ with ε > (n : ℝ) - 2:
    `0 < ε`

  Strategy: ε > n - 2 ≥ 0 (since n ≥ 2).

  This eliminates the redundant `0 < ε` hypothesis in generic-degree
  Roth theorems for n ≥ 2.

  Single derivation:
  1. `T5_generic_degree_eps_auto`: ε > 0 from ε > n-2 + n ≥ 2.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #180 — Generic ε > 0 auto from ε > n-2 + n ≥ 2.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeEpsAuto

/-! ## ε > 0 auto-derivation -/

/-- **🚨 Wave T5 session 559bbbbbbbbbb — `ε > 0` from `ε > n-2 + n ≥ 2`**. -/
theorem T5_generic_degree_eps_auto (n : ℕ) (hn : 2 ≤ n) (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    0 < ε := by
  have hn_real : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  linarith

/-- Companion: same with hypothesis n ≥ 1 + ε > n-2 (where n-2 may be negative
    for n=1, requires explicit ε > 0). -/
theorem T5_generic_degree_eps_n_one (ε : ℝ) (hε : ((1 : ℝ) - 2) < ε) :
    -- n = 1 case: ε > -1, doesn't auto-give ε > 0
    -1 < ε := by linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559bbbbbbbbbb — T-5 Phase 7 ext #180**.

    🏆 BOOKKEEPING — `ε > 0` automatic from `ε > n-2 + n ≥ 2`.

    Sub-lemma 353/N. Lean-core only. -/
theorem session_559bbbbbbbbbb_T5_phase7_generic_degree_eps_auto_headline
    (n : ℕ) (hn : 2 ≤ n) (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    0 < ε :=
  T5_generic_degree_eps_auto n hn ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeEpsAuto
