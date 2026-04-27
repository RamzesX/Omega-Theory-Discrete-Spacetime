/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntegerInduction

  Cycle 62 (Pisces) Phase B Wave T-4b session 13 — Phase 3 power-sum
  induction.  For monic `f : ℤ[X]` and any `k : ℕ`, the k-th power sum
  of the complex roots `((f.aroots ℂ).map (·^k)).sum` is an integer.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  PROVES: For monic `f : ℤ[X]` and any `k : ℕ`:

      ∃ N : ℤ, ((f.aroots ℂ).map (· ^ k)).sum = (N : ℂ)

  Proof: strong induction on k.

  - **k = 0**: `((f.aroots ℂ).map (·^0)).sum = (f.aroots ℂ).card`
    (every term is 1).  The cardinality is `f.natDegree` for monic
    `f` (from session 12 `aroots_card_eq_natDegree`), an integer.
  - **k ≥ 1**: apply Multiset Newton's identity (session 11):

        psum k = (-1)^(k+1) * k * esymm k - ∑_a (-1)^a.1 * esymm a.1 * psum a.2

    where `a` ranges over `(antidiagonal k).filter (a.1 ∈ Ioo 0 k)`.
    Each ingredient is an integer:
    - `esymm k`, `esymm a.1` — by session 12 `aroots_esymm_is_integer_all`.
    - `psum a.2` — by IH (since `a.1 + a.2 = k` and `a.1 > 0`, `a.2 < k`).
    - `(-1)^*`, `(k : ℕ)`, `(a.1 : ℕ)` — primitive integers.

    A Z-valued combination of integers is integer, so `psum k` is integer.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS
  (no `Prop := True`, no `: True := trivial`, no `:= trivial` placeholder
  proofs of conditional Props).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntComplete

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntegerInduction

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumInt
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntComplete

/-! ## Phase 3 — power sums of aroots are integers for ALL k -/

/-- **Wave T4b session 13 Phase 3 — power sums of aroots are integers for ALL k.**

    For monic `f : ℤ[X]` and any `k : ℕ`:

      `∃ N : ℤ, ((f.aroots ℂ).map (·^k)).sum = (N : ℂ)`.

    Proof: strong induction on k.

    - **k = 0**: every term is 1 (since `z^0 = 1` for `z ∈ ℂ`), so
      `(map (·^0)).sum = card`, integer.
    - **k ≥ 1**: Multiset Newton (session 11):

          psum k = (-1)^(k+1) k (esymm k) - ∑_a (-1)^a.1 (esymm a.1) (psum a.2)

      Every ingredient is an integer (Vieta + esymm-all-k from session 12,
      IH on a.2 < k).  A ℤ-linear combination of integers is integer. -/
theorem aroots_psum_is_integer
    (f : Polynomial ℤ) (h_monic : f.Monic) :
    ∀ k : ℕ, ∃ N : ℤ, ((f.aroots ℂ).map (· ^ k)).sum = (N : ℂ) := by
  intro k
  induction k using Nat.strong_induction_on with
  | _ k ih =>
    by_cases hk : k = 0
    · -- Base case k = 0
      subst hk
      refine ⟨((f.aroots ℂ).card : ℤ), ?_⟩
      simp [pow_zero, Multiset.map_const', Multiset.sum_replicate]
    · -- Inductive case k > 0
      have hk_pos : 0 < k := Nat.pos_of_ne_zero hk
      -- Multiset Newton's identity from session 11
      have h_newton := multiset_newton_identity (f.aroots ℂ) k hk_pos
      -- esymm k is an integer (session 12)
      obtain ⟨E_k, hE_k⟩ := aroots_esymm_is_integer_all f h_monic k
      -- Pick an integer for esymm a.1 (any a.1)
      let pickEsymm : ℕ → ℤ := fun n =>
        Classical.choose (aroots_esymm_is_integer_all f h_monic n)
      have hPickEsymm : ∀ n, (f.aroots ℂ).esymm n = (pickEsymm n : ℂ) :=
        fun n => Classical.choose_spec (aroots_esymm_is_integer_all f h_monic n)
      -- Pick an integer for psum n when n < k (use IH)
      let pickPsum : ℕ → ℤ := fun n =>
        if h : n < k then Classical.choose (ih n h) else 0
      have hPickPsum : ∀ (n : ℕ) (hn : n < k),
          ((f.aroots ℂ).map (· ^ n)).sum = (pickPsum n : ℂ) := by
        intros n hn
        show ((f.aroots ℂ).map (· ^ n)).sum =
            ((if h : n < k then Classical.choose (ih n h) else 0 : ℤ) : ℂ)
        rw [dif_pos hn]
        exact Classical.choose_spec (ih n hn)
      -- The witness integer N
      refine ⟨(-1) ^ (k + 1) * (k : ℤ) * E_k -
        ∑ a ∈ (Finset.antidiagonal k).filter (fun a => a.1 ∈ Set.Ioo 0 k),
          (-1) ^ a.1 * pickEsymm a.1 * pickPsum a.2, ?_⟩
      -- Apply Newton, then rewrite each ingredient using its integer witness
      rw [h_newton, hE_k]
      push_cast
      -- Goal:
      -- (-1)^(k+1) * (k:ℂ) * (E_k:ℂ) - ∑ a, (-1)^a.1 * esymm(a.1) * psum(a.2)
      -- = (-1)^(k+1) * (k:ℂ) * (E_k:ℂ) - ∑ a, (-1)^a.1 * (pickEsymm a.1 : ℂ) * (pickPsum a.2 : ℂ)
      congr 1
      apply Finset.sum_congr rfl
      intros a ha
      rw [Finset.mem_filter, Finset.mem_antidiagonal, Set.mem_Ioo] at ha
      obtain ⟨ha_sum, ha_pos, _ha_lt⟩ := ha
      have h_a2_lt : a.2 < k := by omega
      rw [hPickEsymm a.1, hPickPsum a.2 h_a2_lt]

/-! ## Phase 3 headline -/

/-- **HEADLINE — Wave T4b session 13 Phase 3**.  Power sums of complex roots
    of monic `f : ℤ[X]` are integers for every k.  This is the key step
    enabling the Lindemann-Weierstrass argument: with both elementary
    symmetric (session 12) and power-sum (this session) symmetric functions
    landing as integers, an arbitrary polynomial of the roots is also an
    integer (linearity, Phase 4). -/
theorem session_13_phase_3_headline
    (f : Polynomial ℤ) (h_monic : f.Monic) (k : ℕ) :
    ∃ N : ℤ, ((f.aroots ℂ).map (· ^ k)).sum = (N : ℂ) :=
  aroots_psum_is_integer f h_monic k

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntegerInduction
