/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 17 — D-scaled
  Phase-4a generalisation for non-monic h : ℤ[X].

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  PROVES: For any nonzero `h : Polynomial ℤ` (NOT necessarily monic) with
  leading coefficient `D := h.leadingCoeff`, and any `g : ℤ[X]`:

      ∃ N : ℤ, D ^ g.natDegree * ((h.aroots ℂ).map (fun α => g.aeval α)).sum = (N : ℂ).

  This is the **D-scaled** generalisation of session 14's Phase 4a (which
  required monic f).  For non-monic h, the symmetric polynomial factors
  in the roots are rational with denominator-power D, and multiplying by
  D^k clears denominators uniformly.

  Construction (parallel to s10 → s12 → s13 → s14, with D-factor tracked):

  1. **`aroots_card_eq_natDegree_general`**: For any nonzero `h : ℤ[X]`,
     `(h.aroots ℂ).card = h.natDegree`.

  2. **`aroots_esymm_D_scaled_is_integer`**: For `k ≤ natDeg`, by Vieta
     (non-monic version), `D · (h.aroots ℂ).esymm (natDeg-k) = (-1)^(natDeg-k) · h.coeff k ∈ ℤ`.
     Hence `D · esymm k ∈ ℤ` for any k (k > natDeg → esymm = 0).

  3. **`aroots_psum_D_scaled_is_integer`**: By strong induction on k, using
     Multiset Newton's identity (s11) and the D-scaled esymm result.
     `D^k · ((h.aroots ℂ).map (·^k)).sum ∈ ℤ`.

  4. **`aroots_aeval_sum_D_scaled_is_integer`**: For any `g : ℤ[X]`,
     `D^{g.natDeg} · ((h.aroots ℂ).map (fun α => g.aeval α)).sum ∈ ℤ`.

  ## Why this matters for L-W

  The integer polynomial `h` from session 16 is non-monic (after
  `IsLocalization.integerNormalization`).  To use it in the L-W
  contradiction integer construction (session 18), we need the symmetric
  function values evaluated at h.aroots to be integer (after D-scaling).
  This file provides exactly that.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalIntSum
import Mathlib.Algebra.Polynomial.Degree.Lemmas

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumInt
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSymmetricSum

/-! ## Step 1 — Cardinality of aroots for non-monic h -/

/-- For any nonzero `h : ℤ[X]`, `(h.aroots ℂ).card = h.natDegree`. -/
theorem aroots_card_eq_natDegree_general
    (h : Polynomial ℤ) (h_ne : h ≠ 0) :
    (h.aroots ℂ).card = h.natDegree := by
  let hC : Polynomial ℂ := Polynomial.map (Int.castRingHom ℂ) h
  have h_hC_ne : hC ≠ 0 := by
    show Polynomial.map (Int.castRingHom ℂ) h ≠ 0
    rwa [Polynomial.map_ne_zero_iff (Int.castRingHom ℂ).injective_int]
  have h_splits : hC.Splits := IsAlgClosed.splits hC
  have h_natDegree : hC.natDegree = h.natDegree :=
    Polynomial.natDegree_map_eq_of_injective (Int.castRingHom ℂ).injective_int h
  have h_card : hC.roots.card = hC.natDegree :=
    Polynomial.splits_iff_card_roots.mp h_splits
  show hC.roots.card = h.natDegree
  rw [h_card, h_natDegree]

/-! ## Step 2 — D-scaled esymm via non-monic Vieta -/

/-- **Non-monic Vieta**: for non-monic `h : ℤ[X]` and `k ≤ natDeg`,
    `(h.aroots ℂ).esymm (natDeg-k) = (-1)^(natDeg-k) · h.coeff k / h.leadingCoeff (in ℂ)`.

    Multiplied by `h.leadingCoeff`:
    `h.leadingCoeff · (h.aroots ℂ).esymm (natDeg-k) = (-1)^(natDeg-k) · h.coeff k ∈ ℤ`. -/
theorem aroots_esymm_D_scaled_via_vieta
    (h : Polynomial ℤ) (h_ne : h ≠ 0)
    (k : ℕ) (hk : k ≤ h.natDegree) :
    (h.leadingCoeff : ℂ) * (h.aroots ℂ).esymm (h.natDegree - k)
      = (((-1) ^ (h.natDegree - k) * h.coeff k : ℤ) : ℂ) := by
  let hC : Polynomial ℂ := Polynomial.map (Int.castRingHom ℂ) h
  have h_hC_ne : hC ≠ 0 := by
    show Polynomial.map (Int.castRingHom ℂ) h ≠ 0
    rwa [Polynomial.map_ne_zero_iff (Int.castRingHom ℂ).injective_int]
  have h_splits : hC.Splits := IsAlgClosed.splits hC
  have h_aroots_eq : h.aroots ℂ = hC.roots := rfl
  have h_natDegree : hC.natDegree = h.natDegree :=
    Polynomial.natDegree_map_eq_of_injective (Int.castRingHom ℂ).injective_int h
  have h_card : hC.roots.card = hC.natDegree :=
    Polynomial.splits_iff_card_roots.mp h_splits
  -- Vieta's formula (non-monic version)
  have h_vieta : hC.coeff k =
      hC.leadingCoeff * (-1) ^ (hC.natDegree - k) *
        hC.roots.esymm (hC.natDegree - k) := by
    apply Polynomial.coeff_eq_esymm_roots_of_card h_card
    rw [h_natDegree]; exact hk
  -- Coefficient cast: hC.coeff k = ((h.coeff k : ℤ) : ℂ)
  have h_coeff_cast : hC.coeff k = ((h.coeff k : ℤ) : ℂ) := by
    show (Polynomial.map (Int.castRingHom ℂ) h).coeff k = _
    rw [Polynomial.coeff_map]; rfl
  -- Leading coefficient cast: hC.leadingCoeff = (h.leadingCoeff : ℂ)
  have h_lc_cast : hC.leadingCoeff = (h.leadingCoeff : ℂ) := by
    show (Polynomial.map (Int.castRingHom ℂ) h).leadingCoeff = _
    unfold Polynomial.leadingCoeff
    rw [h_natDegree]
    rw [Polynomial.coeff_map]
    rfl
  rw [h_coeff_cast, h_lc_cast] at h_vieta
  -- h_vieta : ((h.coeff k : ℤ) : ℂ) = (h.leadingCoeff : ℂ) * (-1)^(hC.natDeg-k) * esymm
  have h_natDeg_eq : hC.natDegree - k = h.natDegree - k := by rw [h_natDegree]
  rw [h_natDeg_eq] at h_vieta
  rw [h_aroots_eq]
  -- Goal: (h.leadingCoeff : ℂ) * hC.roots.esymm (h.natDegree - k)
  --     = (((-1)^(h.natDegree - k) * h.coeff k : ℤ) : ℂ)
  -- Strategy: multiply h_vieta by (-1)^(h.natDegree - k) to invert.
  have h_neg_sq : ((-1 : ℂ))^(h.natDegree - k) * ((-1 : ℂ))^(h.natDegree - k) = 1 := by
    rw [← pow_add, ← two_mul, pow_mul, neg_one_sq, one_pow]
  push_cast
  -- Goal: (h.leadingCoeff : ℂ) * hC.roots.esymm (h.natDegree - k)
  --     = (-1)^(h.natDegree - k) * (h.coeff k : ℂ)
  have h_step : ((-1 : ℂ))^(h.natDegree - k) * ((h.coeff k : ℤ) : ℂ)
              = (h.leadingCoeff : ℂ) * hC.roots.esymm (h.natDegree - k) := by
    rw [h_vieta]
    -- (-1)^k * (D * (-1)^k * esymm) = D * esymm
    rw [show ((-1 : ℂ))^(h.natDegree - k) * ((h.leadingCoeff : ℂ) * (-1)^(h.natDegree - k) *
              hC.roots.esymm (h.natDegree - k))
          = (h.leadingCoeff : ℂ) *
            (((-1 : ℂ))^(h.natDegree - k) * ((-1 : ℂ))^(h.natDegree - k)) *
            hC.roots.esymm (h.natDegree - k) from by ring]
    rw [h_neg_sq]
    ring
  push_cast at h_step
  exact h_step.symm

/-- **D-scaled esymm integer for k ≤ natDeg**: For nonzero `h : ℤ[X]` and
    `k ≤ natDeg`, `D · (h.aroots ℂ).esymm k ∈ ℤ`. -/
theorem aroots_esymm_D_scaled_is_integer_le
    (h : Polynomial ℤ) (h_ne : h ≠ 0)
    (k : ℕ) (hk : k ≤ h.natDegree) :
    ∃ M : ℤ, (h.leadingCoeff : ℂ) * (h.aroots ℂ).esymm k = (M : ℂ) := by
  refine ⟨(-1) ^ k * h.coeff (h.natDegree - k), ?_⟩
  have hk' : h.natDegree - k ≤ h.natDegree := Nat.sub_le _ _
  have h_aux := aroots_esymm_D_scaled_via_vieta h h_ne (h.natDegree - k) hk'
  have h_n_eq : h.natDegree - (h.natDegree - k) = k := Nat.sub_sub_self hk
  rw [h_n_eq] at h_aux
  exact h_aux

/-- **D-scaled esymm integer for ALL k**.  Extension via case split. -/
theorem aroots_esymm_D_scaled_is_integer_all
    (h : Polynomial ℤ) (h_ne : h ≠ 0) (k : ℕ) :
    ∃ M : ℤ, (h.leadingCoeff : ℂ) * (h.aroots ℂ).esymm k = (M : ℂ) := by
  by_cases hk : k ≤ h.natDegree
  · exact aroots_esymm_D_scaled_is_integer_le h h_ne k hk
  · push_neg at hk
    refine ⟨0, ?_⟩
    have h_card_lt : (h.aroots ℂ).card < k := by
      rw [aroots_card_eq_natDegree_general h h_ne]
      exact hk
    unfold Multiset.esymm
    rw [Multiset.powersetCard_eq_empty k h_card_lt]
    simp

/-! ## Step 3 — D-scaled power sum integer via strong induction -/

/-- **D-scaled power sum integer for ALL k**.  By strong induction on k,
    using Multiset Newton's identity (s11) + D-scaled esymm (Step 2). -/
theorem aroots_psum_D_scaled_is_integer
    (h : Polynomial ℤ) (h_ne : h ≠ 0) :
    ∀ k : ℕ, ∃ N : ℤ,
      (h.leadingCoeff : ℂ) ^ k * ((h.aroots ℂ).map (· ^ k)).sum = (N : ℂ) := by
  intro k
  induction k using Nat.strong_induction_on with
  | _ k ih =>
    by_cases hk : k = 0
    · subst hk
      refine ⟨(h.aroots ℂ).card, ?_⟩
      simp [pow_zero, Multiset.map_const', Multiset.sum_replicate]
    · have hk_pos : 0 < k := Nat.pos_of_ne_zero hk
      have h_newton := multiset_newton_identity (h.aroots ℂ) k hk_pos
      -- Pick D-scaled esymm integer
      let pickEsymm : ℕ → ℤ := fun n =>
        Classical.choose (aroots_esymm_D_scaled_is_integer_all h h_ne n)
      have hPickEsymm : ∀ n,
          (h.leadingCoeff : ℂ) * (h.aroots ℂ).esymm n = (pickEsymm n : ℂ) :=
        fun n => Classical.choose_spec
          (aroots_esymm_D_scaled_is_integer_all h h_ne n)
      -- Pick D-scaled psum integer for n < k via IH
      let pickPsum : ℕ → ℤ := fun n =>
        if hl : n < k then Classical.choose (ih n hl) else 0
      have hPickPsum : ∀ (n : ℕ) (hn : n < k),
          (h.leadingCoeff : ℂ) ^ n * ((h.aroots ℂ).map (· ^ n)).sum
            = (pickPsum n : ℂ) := by
        intros n hn
        show _ = ((if hl : n < k then Classical.choose (ih n hl) else 0 : ℤ) : ℂ)
        rw [dif_pos hn]
        exact Classical.choose_spec (ih n hn)
      -- The integer N
      refine ⟨(-1) ^ (k + 1) * (k : ℤ) * (h.leadingCoeff^(k-1) * pickEsymm k) -
        ∑ a ∈ (Finset.antidiagonal k).filter (fun a => a.1 ∈ Set.Ioo 0 k),
          (-1) ^ a.1 * (h.leadingCoeff^(a.1-1) * pickEsymm a.1) * pickPsum a.2, ?_⟩
      -- LHS expansion: D^k * psum k = D^k * (Newton RHS)
      rw [mul_comm ((h.leadingCoeff : ℂ)^k) _]
      rw [show ((h.aroots ℂ).map (·^k)).sum * (h.leadingCoeff : ℂ)^k
            = (h.leadingCoeff : ℂ)^k * ((h.aroots ℂ).map (·^k)).sum from mul_comm _ _]
      rw [h_newton]
      -- Distribute D^k over the Newton RHS
      rw [mul_sub, Finset.mul_sum]
      push_cast
      -- First term: D^k * ((-1)^(k+1) * k * esymm k)
      -- = (-1)^(k+1) * k * (D^k * esymm k) = (-1)^(k+1) * k * (D^{k-1} * (D * esymm k))
      -- = (-1)^(k+1) * k * (D^{k-1} * pickEsymm k)
      congr 1
      · -- First term equality
        rw [show (h.leadingCoeff : ℂ)^k * ((-1)^(k+1) * (k : ℂ) * (h.aroots ℂ).esymm k)
              = (-1)^(k+1) * (k : ℂ) *
                ((h.leadingCoeff : ℂ)^(k-1) *
                 ((h.leadingCoeff : ℂ) * (h.aroots ℂ).esymm k)) by
          have hk_pred : (h.leadingCoeff : ℂ)^k =
              (h.leadingCoeff : ℂ)^(k-1) * (h.leadingCoeff : ℂ) := by
            rw [← pow_succ, Nat.sub_add_cancel hk_pos]
          rw [hk_pred]
          ring]
        rw [hPickEsymm k]
      · -- Sum term equality
        apply Finset.sum_congr rfl
        intros a ha
        rw [Finset.mem_filter, Finset.mem_antidiagonal, Set.mem_Ioo] at ha
        obtain ⟨ha_sum, ha_pos, _⟩ := ha
        have h_a2_lt : a.2 < k := by omega
        have h_a1_pos : 0 < a.1 := ha_pos
        -- Term: D^k * ((-1)^a.1 * esymm a.1 * psum a.2)
        --     = (-1)^a.1 * (D^{a.1-1} * (D * esymm a.1)) * (D^{a.2} * psum a.2)
        --     using D^k = D^{a.1 + a.2} = D^{a.1-1} * D * D^{a.2}
        have hk_split : (h.leadingCoeff : ℂ) ^ k =
            (h.leadingCoeff : ℂ)^(a.1 - 1) * (h.leadingCoeff : ℂ) *
              (h.leadingCoeff : ℂ)^a.2 := by
          have : k = (a.1 - 1) + 1 + a.2 := by omega
          rw [this]
          rw [pow_add, pow_add, pow_one]
        rw [hk_split]
        rw [show ((h.leadingCoeff : ℂ)^(a.1 - 1) * (h.leadingCoeff : ℂ) *
                   (h.leadingCoeff : ℂ)^a.2) *
                  ((-1)^a.1 * (h.aroots ℂ).esymm a.1 *
                   ((h.aroots ℂ).map (·^a.2)).sum)
              = (-1)^a.1 *
                ((h.leadingCoeff : ℂ)^(a.1 - 1) *
                  ((h.leadingCoeff : ℂ) * (h.aroots ℂ).esymm a.1)) *
                ((h.leadingCoeff : ℂ)^a.2 *
                  ((h.aroots ℂ).map (·^a.2)).sum) by ring]
        rw [hPickEsymm a.1, hPickPsum a.2 h_a2_lt]

/-! ## Step 4 — D-scaled aeval-sum integer -/

/-- Helper: swap of (Multiset map of Finset.sum) and (Finset.sum of Multiset map).
    Reproduced from session 14 helper for self-containment. -/
private theorem multiset_map_finset_sum_swap'
    {α β M : Type*} [AddCommMonoid M]
    (s : Multiset α) (T : Finset β) (F : α → β → M) :
    (s.map (fun a => ∑ b ∈ T, F a b)).sum = ∑ b ∈ T, (s.map (fun a => F a b)).sum := by
  induction s using Multiset.induction with
  | empty => simp
  | cons a s ih =>
      simp only [Multiset.map_cons, Multiset.sum_cons, ih]
      rw [Finset.sum_add_distrib]

/-- **D-scaled aeval-sum integer**: For nonzero `h : ℤ[X]` and any `g : ℤ[X]`,
    `D^{g.natDeg} · ((h.aroots ℂ).map (g.aeval ·)).sum ∈ ℤ`. -/
theorem aroots_aeval_sum_D_scaled_is_integer
    (h : Polynomial ℤ) (h_ne : h ≠ 0) (g : Polynomial ℤ) :
    ∃ N : ℤ, (h.leadingCoeff : ℂ) ^ g.natDegree *
      ((h.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum = (N : ℂ) := by
  -- Pick D-scaled psum integer for each j
  let pickPsum : ℕ → ℤ := fun j =>
    Classical.choose (aroots_psum_D_scaled_is_integer h h_ne j)
  have hPickPsum : ∀ j,
      (h.leadingCoeff : ℂ) ^ j * ((h.aroots ℂ).map (· ^ j)).sum = (pickPsum j : ℂ) :=
    fun j => Classical.choose_spec (aroots_psum_D_scaled_is_integer h h_ne j)
  -- Construct N as ∑_i g.coeff i · D^{g.natDeg - i} · pickPsum i
  refine ⟨∑ i ∈ Finset.range (g.natDegree + 1),
      g.coeff i * h.leadingCoeff^(g.natDegree - i) * pickPsum i, ?_⟩
  -- Expand g.aeval α via eval₂_eq_sum_range
  have h_aeval_expand : ∀ α : ℂ, Polynomial.aeval α g
      = ∑ i ∈ Finset.range (g.natDegree + 1), (g.coeff i : ℂ) * α ^ i := by
    intro α
    rw [Polynomial.aeval_def, Polynomial.eval₂_eq_sum_range]
    rfl
  -- Substitute and swap
  have h_lhs_eq :
      ((h.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum
      = ((h.aroots ℂ).map
            (fun α => ∑ i ∈ Finset.range (g.natDegree + 1),
              (g.coeff i : ℂ) * α ^ i)).sum := by
    apply congrArg Multiset.sum
    apply Multiset.map_congr rfl
    intros α _
    exact h_aeval_expand α
  rw [h_lhs_eq, multiset_map_finset_sum_swap']
  -- Now: D^{deg g} * ∑ i, ((h.aroots ℂ).map (fun α => g.coeff i * α^i)).sum
  --    = ∑ i, g.coeff i * D^{deg g - i} * pickPsum i (cast)
  rw [Finset.mul_sum]
  -- After push_cast both sides distribute; align term-by-term
  push_cast
  apply Finset.sum_congr rfl
  intros i hi
  rw [Finset.mem_range] at hi
  -- term i: D^{deg g} * ((h.aroots).map (g.coeff i * ·^i)).sum
  --       = D^{deg g} * g.coeff i * ((h.aroots).map (·^i)).sum
  --       = g.coeff i * D^{deg g - i} * (D^i * ((h.aroots).map (·^i)).sum)
  --       = g.coeff i * D^{deg g - i} * pickPsum i
  rw [Multiset.sum_map_mul_left]
  have h_split : (h.leadingCoeff : ℂ) ^ g.natDegree =
      (h.leadingCoeff : ℂ) ^ (g.natDegree - i) * (h.leadingCoeff : ℂ) ^ i := by
    rw [← pow_add, Nat.sub_add_cancel (Nat.le_of_lt_succ hi)]
  rw [h_split]
  -- Goal: D^{deg g - i} * D^i * (g.coeff i : ℂ) * (h.aroots ℂ).map (·^i) |>.sum
  --     = (g.coeff i : ℂ) * (D^{deg g - i} : ℂ) * (pickPsum i : ℂ)
  rw [show (h.leadingCoeff : ℂ) ^ (g.natDegree - i) * (h.leadingCoeff : ℂ) ^ i *
         ((g.coeff i : ℂ) * ((h.aroots ℂ).map (·^i)).sum)
       = (g.coeff i : ℂ) * (h.leadingCoeff : ℂ) ^ (g.natDegree - i) *
         ((h.leadingCoeff : ℂ) ^ i * ((h.aroots ℂ).map (·^i)).sum) from by ring]
  rw [hPickPsum i]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 17 D-scaled Phase 4a**.

    For any nonzero `h : ℤ[X]` (NOT necessarily monic) with leading coeff
    `D := h.leadingCoeff`, and any `g : ℤ[X]`:
    `D^{g.natDeg} · ((h.aroots ℂ).map (g.aeval ·)).sum ∈ ℤ`.

    This generalises session 14 (which required monic f) to the non-monic
    case via D-tracking through the symmetric polynomial machinery. -/
theorem session_17_D_scaled_aeval_sum_headline
    (h : Polynomial ℤ) (h_ne : h ≠ 0) (g : Polynomial ℤ) :
    ∃ N : ℤ, (h.leadingCoeff : ℂ) ^ g.natDegree *
      ((h.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum = (N : ℂ) :=
  aroots_aeval_sum_D_scaled_is_integer h h_ne g

/-- **W-T4b session 17 paper bundle** — citation marker. -/
theorem session_17_D_scaled_paper_bundle :
    (∀ (h : Polynomial ℤ), h ≠ 0 → (h.aroots ℂ).card = h.natDegree)
    ∧ (∀ (h : Polynomial ℤ), h ≠ 0 → ∀ (k : ℕ),
        ∃ M : ℤ, (h.leadingCoeff : ℂ) * (h.aroots ℂ).esymm k = (M : ℂ))
    ∧ (∀ (h : Polynomial ℤ), h ≠ 0 → ∀ (k : ℕ),
        ∃ N : ℤ, (h.leadingCoeff : ℂ) ^ k *
          ((h.aroots ℂ).map (· ^ k)).sum = (N : ℂ))
    ∧ (∀ (h : Polynomial ℤ), h ≠ 0 → ∀ (g : Polynomial ℤ),
        ∃ N : ℤ, (h.leadingCoeff : ℂ) ^ g.natDegree *
          ((h.aroots ℂ).map (fun α => Polynomial.aeval α g)).sum = (N : ℂ)) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact aroots_card_eq_natDegree_general
  · exact aroots_esymm_D_scaled_is_integer_all
  · exact aroots_psum_D_scaled_is_integer
  · exact aroots_aeval_sum_D_scaled_is_integer

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum
