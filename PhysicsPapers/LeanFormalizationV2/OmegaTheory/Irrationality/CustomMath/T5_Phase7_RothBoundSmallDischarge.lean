/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDischarge

  T-5 (Roth's theorem) — **Phase 7 ext #41: UNCONDITIONAL discharge of
  `RothBoundSmall` via finite-set min over bounded denominator/numerator
  rationals**, sub session 559hhhh — STRICT critical-path #316 (T-5)
  Phase 7 ext #41.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **UNCONDITIONAL** proof of `RothBoundSmall` for any irrational α
  (algebraicity NOT required for the small-q.den case).

  Strategy:
  1. **Finiteness**: For any K, N : ℕ, the set
       `{ q : ℚ | q.den < N ∧ q.num.natAbs ≤ K }`
     is finite, via the injection `q ↦ (q.num, q.den)` into the
     finite product `Set.Icc (-K : ℤ) K ×ˢ Set.Iio N`.

  2. **Case-A min** (`q.num.natAbs ≤ K = (M+1) · N` with `M = ⌈|α|⌉`):
     finite set of candidates; for each q ∈ S, `|α - q| > 0` (from
     `Irrational.ne_rat`); `Set.exists_min_image` gives positive min m_A.

  3. **Case-B trivial bound** (`q.num.natAbs > K`): forces `|q| > M+1`,
     so `|α - q| ≥ |q| - |α| > 1`.

  4. **Pick** `C₂ := min(m_A, 1) > 0`. Both cases give the bound via
     `naiveHeight ≥ 1` ⇒ `naiveHeight^(2+ε) ≥ 1` ⇒ `C₂/naiveHeight^(2+ε)
     ≤ C₂ ≤ |α - q|`.

  This UNCONDITIONALLY discharges `RothBoundSmall` from
  `T5_Phase7_RothTheoremClosure`. After this lands, the conditional
  capstone reduces to a 1-conjunct conditional (only `RothBoundLarge`
  remains as named hypothesis).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  no slim approaches per Escanor-Pride/Erdős-Primarch identity LOCK.

  ## Step #316 (T-5) status

  Phase 7 ext #41 — UNCONDITIONAL discharge of RothBoundSmall.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
import Mathlib.Data.Set.Finite.Basic
import Mathlib.Data.Set.Finite.Lemmas
import Mathlib.Data.Set.Finite.Lattice
import Mathlib.Data.Finite.Prod
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Algebra.Order.Floor.Defs
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDischarge

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure

/-! ## Bounded-numerator-and-denominator finiteness lemma -/

/-- **🚨 Wave T5 session 559hhhh — bounded-rats finiteness**.

    The set `{ q : ℚ | q.den < N ∧ q.num.natAbs ≤ K }` is finite via
    the injection `q ↦ (q.num, q.den)` into the finite product
    `Set.Icc (-K : ℤ) K ×ˢ Set.Iio N`. -/
theorem T5_bounded_rats_finite (N K : ℕ) :
    Set.Finite { q : ℚ | q.den < N ∧ q.num.natAbs ≤ K } := by
  -- Use the injection q ↦ (q.num, q.den) and preimage of finite set
  let g : ℚ → ℤ × ℕ := fun q => (q.num, q.den)
  let T : Set (ℤ × ℕ) := Set.Icc (-(K : ℤ)) K ×ˢ Set.Iio N
  have hT : T.Finite := Set.Finite.prod (Set.finite_Icc _ _) (Set.finite_Iio N)
  -- g⁻¹(T) is finite via Finite.preimage + g injective
  have h_pre_fin : (g ⁻¹' T).Finite := by
    apply Set.Finite.preimage _ hT
    intro a _ b _ hab
    show a = b
    have h1 : a.num = b.num := (Prod.mk.inj hab).1
    have h2 : a.den = b.den := (Prod.mk.inj hab).2
    exact Rat.ext h1 h2
  -- The set is contained in g⁻¹(T)
  apply Set.Finite.subset h_pre_fin
  intro q hq
  obtain ⟨hd, hn⟩ := hq
  simp only [g, T, Set.mem_preimage, Set.mem_prod, Set.mem_Icc, Set.mem_Iio]
  refine ⟨⟨?_, ?_⟩, hd⟩
  · -- -K ≤ q.num
    have h_le : (q.num.natAbs : ℤ) ≤ (K : ℤ) := by exact_mod_cast hn
    have h2 : -(q.num.natAbs : ℤ) ≤ q.num := by
      rcases Int.natAbs_eq q.num with hp | hn
      · linarith [hp]
      · linarith [hn]
    linarith
  · -- q.num ≤ K
    have h_le : (q.num.natAbs : ℤ) ≤ (K : ℤ) := by exact_mod_cast hn
    have h2 : q.num ≤ (q.num.natAbs : ℤ) := by
      rcases Int.natAbs_eq q.num with hp | hn
      · linarith
      · linarith
    linarith

/-! ## Min over finite set of distances to irrational α -/

/-- **🚨 Wave T5 session 559hhhh — positive min over bounded rationals away from α**.

    For α : ℝ irrational and N, K : ℕ, define
      `S := { q : ℚ | q.den < N ∧ q.num.natAbs ≤ K }`
    (finite). Then `∃ m > 0, ∀ q ∈ S, q ≠ 0 → (q : ℝ) ≠ α →
                       m ≤ |α - q|`.

    If S is empty, the existential is vacuous (any m > 0 works). -/
theorem T5_min_distance_bounded_rats_pos
    (α : ℝ) (hα : Irrational α) (N K : ℕ) :
    ∃ m : ℝ, 0 < m ∧ ∀ q : ℚ,
      q.den < N → q.num.natAbs ≤ K → q ≠ 0 → (q : ℝ) ≠ α →
      m ≤ |α - (q : ℝ)| := by
  set S : Set ℚ := { q : ℚ | q.den < N ∧ q.num.natAbs ≤ K }
  have hS_fin : S.Finite := T5_bounded_rats_finite N K
  by_cases hS_empty : S = ∅
  · -- S empty: vacuous, pick m = 1
    refine ⟨1, one_pos, ?_⟩
    intros q hd hn _ _
    exfalso
    have : q ∈ S := ⟨hd, hn⟩
    rw [hS_empty] at this
    exact this.elim
  · -- S nonempty: use min image
    have hS_ne : S.Nonempty := Set.nonempty_iff_ne_empty.mpr hS_empty
    obtain ⟨q₀, hq₀⟩ := Set.exists_min_image S (fun q => |α - (q : ℝ)|) hS_fin hS_ne
    -- q₀ : ℚ with q₀ ∈ S and ∀ q ∈ S, |α - q₀| ≤ |α - q|
    obtain ⟨_hq₀_S, hq₀_min⟩ := hq₀
    -- |α - q₀| > 0 since (q₀ : ℝ) ≠ α (from Irrational.ne_rat)
    have h_q0_ne : (q₀ : ℝ) ≠ α := (hα.ne_rat q₀).symm
    have h_diff_pos : (0 : ℝ) < |α - (q₀ : ℝ)| := by
      apply abs_pos.mpr
      intro h_eq
      apply h_q0_ne
      linarith
    refine ⟨|α - (q₀ : ℝ)|, h_diff_pos, ?_⟩
    intros q hd hn _ _
    have h_in : q ∈ S := ⟨hd, hn⟩
    exact hq₀_min q h_in

/-! ## Core unconditional discharge of RothBoundSmall -/

/-- **🚨 Wave T5 session 559hhhh — `T5_roth_bound_small_unconditional`**.

    UNCONDITIONAL discharge of `RothBoundSmall`. For any irrational
    algebraic α, ε > 0, N : ℕ, there exists positive C₂ such that
    for all q ≠ 0, q ≠ α, q.den < N:
      `C₂ / (Rat.naiveHeight q)^(2+ε) ≤ |α - q|`.

    Strategy: case-split q.num.natAbs ≤ K vs > K where K := (⌈|α|⌉ + 1) · N.
    Case A: finite set, min |α - q| = m_A > 0 (positive min).
    Case B: |q| > ⌈|α|⌉ + 1 ≥ |α| + 1, so |α - q| > 1.
    Pick C₂ := min(m_A, 1) > 0; in both cases C₂/H^(2+ε) ≤ C₂ ≤ |α - q|. -/
theorem T5_roth_bound_small_unconditional : RothBoundSmall := by
  intros α hα _h_alg ε _hε N
  -- Set M := ⌈|α|⌉ + 1, K := M * N (bound for case-A)
  set M : ℕ := Nat.ceil |α| + 1 with hM_def
  set K : ℕ := M * N with hK_def
  -- Get min over case-A finite set
  obtain ⟨m_A, hm_A_pos, hm_A_bound⟩ :=
    T5_min_distance_bounded_rats_pos α hα N K
  -- Pick C₂ := min(m_A, 1)
  refine ⟨min m_A 1, lt_min hm_A_pos one_pos, ?_⟩
  intros q hq hα_q hd
  -- naiveHeight ≥ 1
  have h_height_ge_one : (1 : ℝ) ≤ (Rat.naiveHeight q : ℝ) := by
    exact_mod_cast Rat.naiveHeight_pos q hq
  have h_height_pos : (0 : ℝ) < (Rat.naiveHeight q : ℝ) := by linarith
  -- naiveHeight^(2+ε) ≥ 1
  have h_pow_ge_one : (1 : ℝ) ≤ ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) := by
    apply Real.one_le_rpow h_height_ge_one
    linarith
  have h_pow_pos : (0 : ℝ) < ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) := by
    exact Real.rpow_pos_of_pos h_height_pos _
  -- C₂ / H^(2+ε) ≤ C₂ since H^(2+ε) ≥ 1
  have h_C_pos : (0 : ℝ) < min m_A 1 := lt_min hm_A_pos one_pos
  have h_C_le : (min m_A 1) / ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) ≤ min m_A 1 := by
    rw [div_le_iff₀ h_pow_pos]
    calc (min m_A 1) = min m_A 1 * 1 := by ring
      _ ≤ min m_A 1 * ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) := by
          apply mul_le_mul_of_nonneg_left h_pow_ge_one
          exact le_of_lt h_C_pos
  -- Case split: q.num.natAbs ≤ K or > K
  by_cases h_caseA : q.num.natAbs ≤ K
  · -- Case A: q in bounded set, |α - q| ≥ m_A ≥ min(m_A, 1)
    have h_min_le : min m_A 1 ≤ m_A := min_le_left _ _
    have h_dist : m_A ≤ |α - (q : ℝ)| := hm_A_bound q hd h_caseA hq hα_q
    linarith
  · -- Case B: q.num.natAbs > K, force |α - q| > 1
    push_neg at h_caseA
    -- |α - q| > 1: need |q| > |α| + 1
    have h_M_ge_alpha_abs : |α| < (M : ℝ) := by
      have hM_eq : (M : ℝ) = (Nat.ceil |α| : ℝ) + 1 := by push_cast [hM_def]; ring
      rw [hM_eq]
      have h_ceil_ge : (|α| : ℝ) ≤ (Nat.ceil |α| : ℝ) := Nat.le_ceil _
      linarith
    -- |q.num| > K = M * N, q.den < N → |q| > M*N/N ... but careful with q.den
    have h_qden_pos : 0 < q.den := q.pos
    have h_qden_ge_one : 1 ≤ q.den := q.pos
    -- N must be ≥ 1 since q.den < N and q.den ≥ 1
    have h_N_pos : 0 < N := by
      have : 1 ≤ q.den := h_qden_ge_one
      linarith
    -- |q| = |q.num|/q.den; |q.num| > K = M*N ≥ M*q.den (since q.den < N → q.den+1 ≤ N → q.den ≤ N-1)
    -- Actually q.den < N gives q.den ≤ N - 1, so M * q.den ≤ M * (N - 1) < M * N = K < |q.num|
    -- Hence |q| > M
    have h_qnum_gt : (M : ℝ) * (q.den : ℝ) ≤ (K : ℝ) := by
      have h1 : (q.den : ℕ) ≤ N := Nat.le_of_lt_succ (by omega)
      have h2 : M * q.den ≤ M * N := Nat.mul_le_mul_left M h1
      have h3 : M * N = K := hK_def.symm
      have : M * q.den ≤ K := by omega
      exact_mod_cast this
    have h_qnum_abs : (K : ℝ) < (q.num.natAbs : ℝ) := by exact_mod_cast h_caseA
    have h_M_lt_q : (M : ℝ) < (q.num.natAbs : ℝ) / (q.den : ℝ) := by
      rw [lt_div_iff₀ (by exact_mod_cast h_qden_pos)]
      linarith
    -- |q| = |q.num|/q.den via Rat.cast_def
    have h_q_eq : (q : ℝ) = ((q.num : ℝ)) / ((q.den : ℝ)) := by
      rw [Rat.cast_def]
    have h_q_abs : |(q : ℝ)| = (q.num.natAbs : ℝ) / (q.den : ℝ) := by
      rw [h_q_eq, abs_div]
      -- Goal: |(q.num : ℝ)| / |(q.den : ℝ)| = (q.num.natAbs : ℝ) / (q.den : ℝ)
      have h_num_abs : |((q.num : ℤ) : ℝ)| = ((q.num.natAbs : ℕ) : ℝ) := by
        rw [← Int.cast_abs, ← Nat.cast_natAbs]
      have h_den_abs : |((q.den : ℕ) : ℝ)| = ((q.den : ℕ) : ℝ) :=
        abs_of_pos (by exact_mod_cast h_qden_pos)
      rw [h_num_abs, h_den_abs]
    -- |q| > M ≥ |α| + 1, so |α - q| ≥ |q| - |α| > M - |α| ≥ 1
    have h_q_gt_M : |(q : ℝ)| > (M : ℝ) := by
      rw [h_q_abs]; exact h_M_lt_q
    have h_diff_gt_one : |α - (q : ℝ)| > 1 := by
      -- |q| - |α| ≤ |q - α| = |α - q|
      have h_tri : |(q : ℝ)| - |α| ≤ |α - (q : ℝ)| := by
        have h := abs_sub_abs_le_abs_sub (q : ℝ) α
        have h_swap : |(q : ℝ) - α| = |α - (q : ℝ)| := abs_sub_comm _ _
        linarith
      have h_M_ge : (M : ℝ) ≥ |α| + 1 := by
        -- M = ceil + 1, and ceil ≥ |α|, so M ≥ |α| + 1
        have h_ceil_ge : (|α| : ℝ) ≤ (Nat.ceil |α| : ℝ) := Nat.le_ceil _
        have hM_eq : (M : ℝ) = (Nat.ceil |α| : ℝ) + 1 := by push_cast [hM_def]; ring
        linarith
      linarith
    have h_dist_ge_one : 1 ≤ |α - (q : ℝ)| := le_of_lt h_diff_gt_one
    have h_min_le_one : min m_A 1 ≤ 1 := min_le_right _ _
    linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559hhhh — T-5 Phase 7 ext #41:
    UNCONDITIONAL discharge of `RothBoundSmall`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #41.

    🏆 ONE OF TWO REMAINING NAMED HYPOTHESES DISCHARGED.

    Three derivations:
    1. `T5_bounded_rats_finite` — bounded rats finiteness
    2. `T5_min_distance_bounded_rats_pos` — positive min over case-A finite set
    3. `T5_roth_bound_small_unconditional` — full unconditional bound

    Mathematical strategy:
    - Case-A (q.num.natAbs ≤ M·N where M := ⌈|α|⌉+1): finite set →
      finite-set-min over positive distances |α - q| > 0
      (Irrational.ne_rat) → m_A > 0
    - Case-B (q.num.natAbs > M·N): forces |q| > M ≥ |α|+1, hence
      |α - q| > 1
    - C₂ := min(m_A, 1) > 0 satisfies the bound in both cases via
      naiveHeight ≥ 1 ⇒ naiveHeight^(2+ε) ≥ 1 ⇒
      C₂/naiveHeight^(2+ε) ≤ C₂ ≤ |α - q|.

    After this lands, `RothCompleteHypotheses` reduces from 2-conjunct
    to 1-conjunct (only `RothBoundLarge` remains). The conditional
    Roth capstone (ext #40) becomes:
    `T5_roth_bound_large_unconditional → RothTheorem` (one named
    hypothesis to discharge in s42-s50 Phase-7 chain).

    Mathlib usage: `Set.Finite.preimage`, `Set.Finite.prod`,
    `Set.finite_Icc`, `Set.finite_Iio`, `Set.exists_min_image`,
    `Irrational.ne_rat`, `Nat.ceil`, `Nat.le_ceil`,
    `Real.one_le_rpow`, `Real.rpow_pos_of_pos`, `Rat.ext`,
    `Int.natAbs_eq`, `abs_div`, `abs_of_pos`,
    `mul_le_mul_of_nonneg_left`, `min_le_left/right`, `lt_min`.

    Sub-lemma 234/N in T-1 (T-5 Phase 7 ext #41).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 UNCONDITIONAL discharge of one of
    the two NAMED hypotheses required for full Roth closure. Escanor
    Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559hhhh_T5_phase7_roth_bound_small_unconditional_headline :
    RothBoundSmall :=
  T5_roth_bound_small_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDischarge
