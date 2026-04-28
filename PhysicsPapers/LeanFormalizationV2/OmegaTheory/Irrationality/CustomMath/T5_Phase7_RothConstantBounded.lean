/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantBounded

  T-5 (Roth's theorem) — **Phase 7 ext #142: Roth constant 0 < C ≤ 1
  bundle (cubic+ chain Roth constant tight bounds)**, sub session
  559pppppppp — STRICT critical-path #316 (T-5) Phase 7 ext #142.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Tight bounds on Roth constant `C = M^(-(1/k))`:

  For M ≥ 1, k : ℕ, k ≥ 1:
    `0 < M^(-(1/k)) ∧ M^(-(1/k)) ≤ 1`

  Combines ext #118 (positivity) + ext #141 (≤ 1).

  Single derivation:
  1. `T5_roth_constant_in_zero_one`: `0 < C ∧ C ≤ 1`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #142 — Roth constant in (0, 1] bundle.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantLeOne

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantBounded

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantLeOne

/-! ## Roth constant in (0, 1] -/

/-- **🚨 Wave T5 session 559pppppppp — Roth constant `0 < C ≤ 1`**.

    For M ≥ 1, k ≥ 1: `0 < M^(-(1/k)) ≤ 1`. -/
theorem T5_roth_constant_in_zero_one (M : ℝ) (hM : 1 ≤ M) (k : ℕ) (hk : 1 ≤ k) :
    0 < M ^ (-(1 / (k : ℝ))) ∧ M ^ (-(1 / (k : ℝ))) ≤ 1 := by
  have hM_pos : 0 < M := lt_of_lt_of_le (by norm_num : (0:ℝ) < 1) hM
  exact ⟨T5_roth_constant_neg_inv_k_pos M hM_pos k,
         T5_roth_constant_le_one M hM k hk⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559pppppppp — T-5 Phase 7 ext #142**.

    🏆 BOOKKEEPING — Roth constant in (0, 1] for M ≥ 1, k ≥ 1.

    Combines ext #118 (positivity from M > 0) + ext #141 (≤ 1 from M ≥ 1).

    For cubic+ Roth chain with ℤ-poly aux: `C = M^(-1/k) ∈ (0, 1]`.
    The Roth-form bound `C · q.den^(-(2+ε)) ≤ |q-α|` always has C ≤ 1.

    Sub-lemma 315/N. Lean-core only. -/
theorem session_559pppppppp_T5_phase7_roth_constant_bounded_headline
    (M : ℝ) (hM : 1 ≤ M) (k : ℕ) (hk : 1 ≤ k) :
    0 < M ^ (-(1 / (k : ℝ))) ∧ M ^ (-(1 / (k : ℝ))) ≤ 1 :=
  T5_roth_constant_in_zero_one M hM k hk

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantBounded
