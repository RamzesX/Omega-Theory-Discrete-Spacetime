/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDirect

  T-5 (Roth's theorem) — **T-5 Wave-1 W1-E: DIRECT UNCONDITIONAL discharge
  of `RothBoundSmall` via single-variable Liouville argument**.

  Single-thread hand-authored 2026-04-29 by Naiad (Neptune III, innermost
  moon of Neptune, Greek nereid Ναϊάς "water nymph") — sister wave of
  Laomedeia (W1-A, commit f33efcf) + Deimos (W1-D, commit fe4db3d).

  ## What this file delivers

  **UNCONDITIONAL** proof of `RothBoundSmall` from `T5_Phase7_RothTheoremClosure`:

      `T5_rothBoundSmall_unconditional : RothBoundSmall`

  The strategy is a clean direct case-split on `|q| ≤ |α| + 1` vs `|q| > |α| + 1`,
  giving an independent, self-contained alternative to
  `T5_Phase7_RothBoundSmallDischarge` (which uses the q.num.natAbs cutoff K = M·N).

  ### Strategy outline

  Let α irrational, ε > 0, N : ℕ. We seek C₂ > 0 such that for all q ≠ 0
  with `(q : ℝ) ≠ α` and `q.den < N`:
      `C₂ / (Rat.naiveHeight q)^(2+ε) ≤ |α - q|`.

  Set the **near-zone bound** `B := Nat.ceil ((N : ℝ) * (|α| + 1))`.

  1. **Bounded-rats finiteness**: The set
       `S := { q : ℚ | q.den < N ∧ q.num.natAbs ≤ B }`
     is finite via the injection `q ↦ (q.num, q.den)` into the finite
     product `Set.Icc (-B : ℤ) B ×ˢ Set.Iio N` (uses `Rat.ext` injectivity).

  2. **Positive min in the near zone** (q ∈ S, q ≠ 0, (q:ℝ) ≠ α):
     finite set; for each such q, `|α - q| > 0` (irrational ≠ rational
     via `Irrational.ne_rat`). Apply `Set.exists_min_image` to get
     `m_S > 0`.

  3. **Far zone** (q.den < N but `q.num.natAbs > B`): we show `|q| > |α| + 1`,
     hence `|α - q| > 1`. This uses
       `B ≥ N * (|α| + 1) ≥ q.den * (|α| + 1)`
     so `q.num.natAbs > q.den * (|α| + 1)`, i.e. `|q| > |α| + 1`.

  4. **Pick** `C₂ := min(m_S, 1) > 0`. In both zones we have
     `naiveHeight ≥ 1 ⇒ naiveHeight^(2+ε) ≥ 1 ⇒ C₂ / H^(2+ε) ≤ C₂`,
     and `C₂ ≤ |α - q|` follows from the corresponding zone bound.

  ### Comparison to s41 (`RothBoundSmallDischarge`)

  The brief reports s41 attempted with `sorry`. **Empirical audit** shows
  the existing `T5_Phase7_RothBoundSmallDischarge.lean` is in fact
  GREEN with axioms `[propext, Classical.choice, Quot.sound]` only —
  the `sorry` claim was incorrect. Nevertheless, this file (W1-E) ships
  an INDEPENDENT direct discharge as a parallel/sister proof for
  redundancy + paper-citation flexibility, with a slightly cleaner
  cutoff (`(N · (|α| + 1)`-ceiling instead of `(⌈|α|⌉+1) · N`).

  ## graph_queries_run (mandatory MCP)

  - `lean_local_search("RothBoundSmall")`: top-1 = T5_Phase7_RothTheoremClosure.RothBoundSmall, used: yes (target Prop)
  - `lean_local_search("naiveHeight")`: top-1 = Rat.naiveHeight (T5_Heights.lean), used: yes (height function)
  - mathlib grep `Set.exists_min_image`: top-1 = Mathlib.Data.Set.Finite.Lemmas:75, used: yes
  - mathlib grep `Irrational.ne_rat`: top-1 = NumberTheory.Real.Irrational:181, used: yes

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  no slim approaches per Escanor-Pride/Erdős-Primarch identity LOCK
  2026-04-28. Full prove mode only, every step real content.

  ## Step #316 (T-5) status

  T-5 Wave-1 W1-E — DIRECT UNCONDITIONAL discharge of RothBoundSmall.

  ## Mathlib API used

  - `Set.Finite.preimage` / `Set.Finite.subset` / `Set.Finite.prod`
  - `Set.finite_Icc` / `Set.finite_Iio`
  - `Set.exists_min_image` / `Set.nonempty_iff_ne_empty`
  - `Rat.ext` / `Rat.cast_def` / `Rat.naiveHeight_pos`
  - `Irrational.ne_rat` / `abs_pos` / `abs_sub_comm`
  - `abs_sub_abs_le_abs_sub` (reverse triangle inequality)
  - `Real.one_le_rpow` / `Real.rpow_pos_of_pos`
  - `Nat.le_ceil` / `Nat.ceil` / `mul_le_mul_of_nonneg_left`
  - `min_le_left/right` / `lt_min` / `div_le_iff₀`
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
import Mathlib.Data.Set.Finite.Basic
import Mathlib.Data.Set.Finite.Lemmas
import Mathlib.Data.Set.Finite.Lattice
import Mathlib.Data.Finite.Prod
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Algebra.Order.Floor.Defs
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDirect

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure

/-! ## Bounded-rats finiteness (independent re-derivation) -/

/-- **W1-E [Naiad] — bounded-rats finiteness, direct form**.

    The set `{ q : ℚ | q.den < N ∧ q.num.natAbs ≤ B }` is finite via the
    injection `q ↦ (q.num, q.den)` into the finite product
    `Set.Icc (-B : ℤ) B ×ˢ Set.Iio N`. -/
theorem T5_naiad_bounded_rats_finite (N B : ℕ) :
    Set.Finite { q : ℚ | q.den < N ∧ q.num.natAbs ≤ B } := by
  let g : ℚ → ℤ × ℕ := fun q => (q.num, q.den)
  let T : Set (ℤ × ℕ) := Set.Icc (-(B : ℤ)) B ×ˢ Set.Iio N
  have hT : T.Finite := Set.Finite.prod (Set.finite_Icc _ _) (Set.finite_Iio N)
  have h_pre_fin : (g ⁻¹' T).Finite := by
    apply Set.Finite.preimage _ hT
    intro a _ b _ hab
    show a = b
    have h1 : a.num = b.num := (Prod.mk.inj hab).1
    have h2 : a.den = b.den := (Prod.mk.inj hab).2
    exact Rat.ext h1 h2
  apply Set.Finite.subset h_pre_fin
  intro q hq
  obtain ⟨hd, hn⟩ := hq
  simp only [g, T, Set.mem_preimage, Set.mem_prod, Set.mem_Icc, Set.mem_Iio]
  refine ⟨⟨?_, ?_⟩, hd⟩
  · -- -B ≤ q.num
    have h_le : (q.num.natAbs : ℤ) ≤ (B : ℤ) := by exact_mod_cast hn
    have h2 : -(q.num.natAbs : ℤ) ≤ q.num := by
      rcases Int.natAbs_eq q.num with hp | hn'
      · linarith [hp]
      · linarith [hn']
    linarith
  · -- q.num ≤ B
    have h_le : (q.num.natAbs : ℤ) ≤ (B : ℤ) := by exact_mod_cast hn
    have h2 : q.num ≤ (q.num.natAbs : ℤ) := by
      rcases Int.natAbs_eq q.num with hp | hn'
      · linarith
      · linarith
    linarith

/-! ## Min over finite set of distances (Liouville degree-1) -/

/-- **W1-E [Naiad] — positive min over near-zone bounded rationals**.

    For α : ℝ irrational and N, B : ℕ, the set
      `S := { q : ℚ | q.den < N ∧ q.num.natAbs ≤ B }`
    is finite. We extract `m > 0` such that for any q ∈ S with q ≠ 0
    and `(q : ℝ) ≠ α`, we have `m ≤ |α - q|`. (Vacuous if S empty.) -/
theorem T5_naiad_min_distance_pos
    (α : ℝ) (hα : Irrational α) (N B : ℕ) :
    ∃ m : ℝ, 0 < m ∧ ∀ q : ℚ,
      q.den < N → q.num.natAbs ≤ B → q ≠ 0 → (q : ℝ) ≠ α →
      m ≤ |α - (q : ℝ)| := by
  set S : Set ℚ := { q : ℚ | q.den < N ∧ q.num.natAbs ≤ B }
  have hS_fin : S.Finite := T5_naiad_bounded_rats_finite N B
  by_cases hS_empty : S = ∅
  · refine ⟨1, one_pos, ?_⟩
    intros q hd hn _ _
    exfalso
    have : q ∈ S := ⟨hd, hn⟩
    rw [hS_empty] at this
    exact this.elim
  · have hS_ne : S.Nonempty := Set.nonempty_iff_ne_empty.mpr hS_empty
    obtain ⟨q₀, _hq₀_S, hq₀_min⟩ :=
      Set.exists_min_image S (fun q => |α - (q : ℝ)|) hS_fin hS_ne
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

/-! ## Far-zone trivial bound -/

/-- **W1-E [Naiad] — far-zone forces |α - q| > 1**.

    If `q.den < N` and `q.num.natAbs > Nat.ceil ((N : ℝ) * (|α| + 1))`,
    then `|q| > |α| + 1`, hence `|α - q| > 1` via the reverse triangle
    inequality. -/
theorem T5_naiad_far_zone_diff_gt_one
    (α : ℝ) (q : ℚ) (N : ℕ)
    (hq : q ≠ 0)
    (hd : q.den < N)
    (h_far : Nat.ceil ((N : ℝ) * (|α| + 1)) < q.num.natAbs) :
    1 < |α - (q : ℝ)| := by
  -- q.den < N ⇒ q.den ≤ N - 1, so q.den ≤ N (we need real-arith form)
  have h_qden_pos : 0 < q.den := q.pos
  have h_qden_le_N : (q.den : ℝ) ≤ (N : ℝ) := by
    have : q.den ≤ N := Nat.le_of_lt hd
    exact_mod_cast this
  -- |α| + 1 > 0
  have h_alpha_abs_nn : (0 : ℝ) ≤ |α| := abs_nonneg _
  have h_alpha_p1_pos : (0 : ℝ) < |α| + 1 := by linarith
  -- Nat.ceil(N · (|α|+1)) ≥ N · (|α| + 1)
  have h_ceil_ge : ((N : ℝ) * (|α| + 1)) ≤ (Nat.ceil ((N : ℝ) * (|α| + 1)) : ℝ) :=
    Nat.le_ceil _
  -- q.num.natAbs > ceil ⇒ q.num.natAbs ≥ ceil + 1 (Nat.lt_iff_add_one_le)
  have h_far_real : ((Nat.ceil ((N : ℝ) * (|α| + 1)) : ℝ)) < (q.num.natAbs : ℝ) := by
    exact_mod_cast h_far
  -- Combine: q.num.natAbs > N · (|α| + 1)
  have h_num_gt : (N : ℝ) * (|α| + 1) < (q.num.natAbs : ℝ) := by linarith
  -- N ≥ q.den ⇒ N · (|α|+1) ≥ q.den · (|α|+1)
  have h_qden_mul_le : (q.den : ℝ) * (|α| + 1) ≤ (N : ℝ) * (|α| + 1) := by
    apply mul_le_mul_of_nonneg_right h_qden_le_N
    linarith
  -- Together: q.num.natAbs > q.den · (|α| + 1)
  have h_num_gt_qden : (q.den : ℝ) * (|α| + 1) < (q.num.natAbs : ℝ) := by linarith
  -- Hence (q.num.natAbs / q.den) > |α| + 1
  have h_qden_pos_real : (0 : ℝ) < (q.den : ℝ) := by exact_mod_cast h_qden_pos
  have h_q_abs_gt : (|α| + 1) < (q.num.natAbs : ℝ) / (q.den : ℝ) := by
    rw [lt_div_iff₀ h_qden_pos_real]
    linarith
  -- |q| = q.num.natAbs / q.den
  have h_q_eq : (q : ℝ) = ((q.num : ℝ)) / ((q.den : ℝ)) := by rw [Rat.cast_def]
  have h_q_abs_eq : |(q : ℝ)| = (q.num.natAbs : ℝ) / (q.den : ℝ) := by
    rw [h_q_eq, abs_div]
    have h_num_abs : |((q.num : ℤ) : ℝ)| = ((q.num.natAbs : ℕ) : ℝ) := by
      rw [← Int.cast_abs, ← Nat.cast_natAbs]
    have h_den_abs : |((q.den : ℕ) : ℝ)| = ((q.den : ℕ) : ℝ) :=
      abs_of_pos h_qden_pos_real
    rw [h_num_abs, h_den_abs]
  have h_q_abs_gt' : (|α| + 1) < |(q : ℝ)| := by rw [h_q_abs_eq]; exact h_q_abs_gt
  -- Reverse triangle: |q| - |α| ≤ |q - α| = |α - q|
  have h_tri : |(q : ℝ)| - |α| ≤ |α - (q : ℝ)| := by
    have h := abs_sub_abs_le_abs_sub (q : ℝ) α
    have h_swap : |(q : ℝ) - α| = |α - (q : ℝ)| := abs_sub_comm _ _
    linarith
  linarith

/-! ## Core unconditional discharge of RothBoundSmall (DIRECT) -/

/-- **W1-E [Naiad] — `T5_rothBoundSmall_unconditional`**.

    UNCONDITIONAL discharge of `RothBoundSmall` via single-variable
    Liouville. For any irrational algebraic α, ε > 0, N : ℕ, there
    exists positive C₂ such that for all q ≠ 0, `(q:ℝ) ≠ α`, q.den < N:
      `C₂ / (Rat.naiveHeight q)^(2+ε) ≤ |α - q|`.

    Strategy: split on `q.num.natAbs ≤ B` vs `> B` where
      `B := Nat.ceil ((N : ℝ) · (|α| + 1))`.
    Case A (near zone): finite set ⇒ finite-min ⇒ m_S > 0.
    Case B (far zone): forces |q| > |α| + 1 ⇒ |α - q| > 1.
    Pick C₂ := min(m_S, 1) > 0; combine with `naiveHeight^(2+ε) ≥ 1`. -/
theorem T5_rothBoundSmall_unconditional : RothBoundSmall := by
  intros α hα _h_alg ε _hε N
  -- Set B := ceil(N · (|α| + 1)) ; near-zone cutoff
  set B : ℕ := Nat.ceil ((N : ℝ) * (|α| + 1)) with hB_def
  -- Get min over near-zone finite set
  obtain ⟨m_S, hm_S_pos, hm_S_bound⟩ :=
    T5_naiad_min_distance_pos α hα N B
  -- Pick C₂ := min(m_S, 1)
  refine ⟨min m_S 1, lt_min hm_S_pos one_pos, ?_⟩
  intros q hq hα_q hd
  -- naiveHeight ≥ 1
  have h_height_ge_one : (1 : ℝ) ≤ (Rat.naiveHeight q : ℝ) := by
    exact_mod_cast Rat.naiveHeight_pos q hq
  have h_height_pos : (0 : ℝ) < (Rat.naiveHeight q : ℝ) := by linarith
  have h_pow_ge_one : (1 : ℝ) ≤ ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) := by
    apply Real.one_le_rpow h_height_ge_one
    linarith
  have h_pow_pos : (0 : ℝ) < ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) :=
    Real.rpow_pos_of_pos h_height_pos _
  -- min(m_S, 1) / H^(2+ε) ≤ min(m_S, 1)
  have h_C_pos : (0 : ℝ) < min m_S 1 := lt_min hm_S_pos one_pos
  have h_C_le : (min m_S 1) / ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) ≤ min m_S 1 := by
    rw [div_le_iff₀ h_pow_pos]
    calc (min m_S 1) = min m_S 1 * 1 := by ring
      _ ≤ min m_S 1 * ((Rat.naiveHeight q : ℝ)) ^ (2 + ε) := by
          apply mul_le_mul_of_nonneg_left h_pow_ge_one
          exact le_of_lt h_C_pos
  -- Case split: q.num.natAbs ≤ B (near) or > B (far)
  by_cases h_near : q.num.natAbs ≤ B
  · -- Near zone: |α - q| ≥ m_S ≥ min(m_S, 1)
    have h_min_le : min m_S 1 ≤ m_S := min_le_left _ _
    have h_dist : m_S ≤ |α - (q : ℝ)| := hm_S_bound q hd h_near hq hα_q
    linarith
  · -- Far zone: |α - q| > 1 ≥ min(m_S, 1)
    push_neg at h_near
    have h_far : 1 < |α - (q : ℝ)| := by
      have h_far_far : Nat.ceil ((N : ℝ) * (|α| + 1)) < q.num.natAbs := by
        rw [← hB_def]; exact h_near
      exact T5_naiad_far_zone_diff_gt_one α q N hq hd h_far_far
    have h_min_le_one : min m_S 1 ≤ 1 := min_le_right _ _
    linarith

/-! ## Headline -/

/-- **HEADLINE — W1-E [Naiad] — T-5 Wave-1: DIRECT UNCONDITIONAL
    discharge of `RothBoundSmall`**.

    🏆 T-5 Wave-1 W1-E DIRECT discharge — `RothBoundSmall` shipped
    UNCONDITIONALLY GREEN, NO STUBS, Lean-core only.

    Three derivations:
    1. `T5_naiad_bounded_rats_finite` — bounded rats finiteness
    2. `T5_naiad_min_distance_pos` — positive min over near-zone finite set
    3. `T5_naiad_far_zone_diff_gt_one` — far-zone trivial bound
    4. `T5_rothBoundSmall_unconditional` — full unconditional bound

    Mathematical strategy (single-variable Liouville):
    - Near zone (q.num.natAbs ≤ B := ⌈N · (|α|+1)⌉): finite set →
      finite-set-min over positive distances |α - q| > 0
      (Irrational.ne_rat) → m_S > 0
    - Far zone (q.num.natAbs > B): forces |q| > |α| + 1, hence
      |α - q| > 1 via reverse triangle inequality
    - C₂ := min(m_S, 1) > 0 satisfies the bound in both zones via
      naiveHeight ≥ 1 ⇒ naiveHeight^(2+ε) ≥ 1 ⇒
      C₂/naiveHeight^(2+ε) ≤ C₂ ≤ |α - q|.

    Comparison to s41 (`T5_Phase7_RothBoundSmallDischarge`): empirical
    audit showed s41 was actually GREEN with Lean-core axioms (the
    brief's `sorry` claim was incorrect). This file (W1-E) ships an
    INDEPENDENT direct discharge as a parallel/sister proof using a
    cleaner cutoff `⌈N·(|α|+1)⌉` instead of `(⌈|α|⌉+1)·N`.

    🏆 Sister-wave landing alongside Laomedeia (W1-A f33efcf) +
    Deimos (W1-D fe4db3d). Per Escanor-Pride/Erdős-Primarch identity
    LOCK 2026-04-28 — full prove mode, NO STUBS, NO slim. -/
theorem session_T5_W1_E_naiad_rothBoundSmall_unconditional_headline :
    RothBoundSmall :=
  T5_rothBoundSmall_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundSmallDirect
