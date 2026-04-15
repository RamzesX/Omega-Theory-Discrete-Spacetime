/-
  OmegaTheory.Irrationality.HermitePade.BridgeTheorem_Frequencies

  Bridge Theorem 4A.1, clause (d) — CF-digit frequency rationality for
  K₂-predictable reals, **positional polynomial predictor** flavour
  (Paper-K2 §2.1, Module 04A §4A.1).

  Setup
  -----
  A K₂-predictable continued-fraction sequence of period `p` is given
  by `p` polynomials `f₀, f₁, …, f_{p-1} ∈ ℤ[x]` and the rule

      aₙ  =  f_{n mod p}(⌊n / p⌋)      (n : ℕ)

  Per-offset behaviour:
    • if `f_i = C v_i` is constant, the slot produces `v_i` on every
      block — density `1/p` for digit `v_i`;
    • if `f_i ≠ C k`, then `(f_i − C k)` is a nonzero polynomial in
      ℤ[x] whose root set is finite, so digit `k` is hit only finitely
      often from this slot.

  Adding across the `p` offsets, the asymptotic frequency of digit `k`
  is exactly

      δ_k(P) = (#{ i | f_i = C k }) / p,

  a rational with denominator dividing `p`.

  Lemmas
  ------
    • `digit_count_eq` — exact decomposition: window count
      `= N · c  +  errorTerm`, where `c = #constant slots` and
      `errorTerm` is the sum of finite hit-counts on non-constant slots.
    • `errorTerm_bounded` — `∃ C, ∀ N, errorTerm ≤ C` (uniform bound).
    • `predictor_frequency_rational` — main theorem: the asymptotic
      frequency is a rational `r` with `r.den ∣ p`.
-/

import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Rat.Lemmas
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset Polynomial

/-! ### The predictor and its derived quantities -/

/--
**Periodic polynomial predictor.**  A K₂ predictor of period `p` is a
family of `p` integer polynomials, indexed by residues mod `p`.  The
optional `D` parameter is the maximum allowed degree (used only for
documentation / type-level annotation).
-/
def PeriodicPolynomialPredictor (p : ℕ) (_D : ℕ := 0) : Type :=
  Fin p → Polynomial ℤ

/--
**n-th predicted continued-fraction term.**  For period `p ≥ 1`,
`predict P n = (P (n mod p)).eval (n / p : ℤ)`.
-/
noncomputable def predict {p D : ℕ} (hp : 1 ≤ p)
    (P : PeriodicPolynomialPredictor p D) (n : ℕ) : ℤ :=
  (P ⟨n % p, Nat.mod_lt _ hp⟩).eval ((n / p : ℕ) : ℤ)

/-- **Constant slots.**  The set `{ i : Fin p | P i = C k }`. -/
noncomputable def constantSlots {p D : ℕ}
    (P : PeriodicPolynomialPredictor p D) (k : ℤ) : Finset (Fin p) :=
  (Finset.univ : Finset (Fin p)).filter (fun i => P i = Polynomial.C k)

/-- **Window count.**  Number of `n < N · p` with `predict P n = k`. -/
noncomputable def digitCount {p D : ℕ} (hp : 1 ≤ p)
    (P : PeriodicPolynomialPredictor p D) (k : ℤ) (N : ℕ) : ℕ :=
  ((Finset.range (N * p)).filter (fun n => predict hp P n = k)).card

/-- **Error term.**  Sum, over non-constant slots, of the slot's
hit count in the first `N` blocks. -/
noncomputable def errorTerm {p D : ℕ}
    (P : PeriodicPolynomialPredictor p D) (k : ℤ) (N : ℕ) : ℕ :=
  ∑ i ∈ (Finset.univ \ constantSlots P k),
    ((Finset.range N).filter
      (fun m => (P i).eval ((m : ℕ) : ℤ) = k)).card

/-! ### Decomposition lemma -/

/--
**Main decomposition.**  `digitCount = N · c + errorTerm`,
where `c = (constantSlots P k).card`.
-/
theorem digit_count_eq {p D : ℕ} (hp : 1 ≤ p)
    (P : PeriodicPolynomialPredictor p D) (k : ℤ) (N : ℕ) :
    digitCount hp P k N
      = N * (constantSlots P k).card + errorTerm P k N := by
  classical
  -- Reindex `range (N·p)` by `(m,i) ∈ range N ×ˢ univ` with `n = m*p + i`.
  have hbij :
      digitCount hp P k N
        = ∑ mi ∈ ((Finset.range N) ×ˢ (Finset.univ : Finset (Fin p))),
            (if (P mi.2).eval ((mi.1 : ℕ) : ℤ) = k then 1 else 0) := by
    unfold digitCount
    rw [Finset.card_filter]
    refine Finset.sum_nbij'
      (i := fun n => (n / p, (⟨n % p, Nat.mod_lt _ hp⟩ : Fin p)))
      (j := fun mi => mi.1 * p + mi.2.1)
      ?_ ?_ ?_ ?_ ?_
    · intro n hn
      have hn' : n < N * p := Finset.mem_range.mp hn
      simp only [Finset.mem_product, Finset.mem_range, Finset.mem_univ, and_true]
      exact (Nat.div_lt_iff_lt_mul hp).mpr hn'
    · rintro ⟨m, i⟩ hmi
      simp only [Finset.mem_product, Finset.mem_range, Finset.mem_univ, and_true] at hmi
      simp only [Finset.mem_range]
      have hi : (i : ℕ) < p := i.isLt
      calc m * p + i.1 < m * p + p := by omega
        _ = (m + 1) * p := by ring
        _ ≤ N * p := Nat.mul_le_mul_right p hmi
    · intro n _
      show (n / p) * p + n % p = n
      rw [Nat.mul_comm (n / p) p]
      exact Nat.div_add_mod n p
    · rintro ⟨m, i⟩ _
      have hi : (i : ℕ) < p := i.isLt
      have hr : (m * p + i.1) % p = i.1 := by
        rw [Nat.mul_comm m p, Nat.mul_add_mod]
        exact Nat.mod_eq_of_lt hi
      have hq : (m * p + i.1) / p = m := by
        rw [Nat.mul_comm m p, Nat.add_comm, Nat.add_mul_div_left _ _ hp,
            Nat.div_eq_of_lt hi, Nat.zero_add]
      ext
      · show (m * p + i.1) / p = m
        exact hq
      · show (m * p + i.1) % p = i.1
        exact hr
    · intro n _
      show (if predict hp P n = k then (1:ℕ) else 0)
          = (if (P _).eval ((n / p : ℕ) : ℤ) = k then (1:ℕ) else 0)
      rfl
  rw [hbij, Finset.sum_product]
  -- Goal: ∑ m ∈ range N, ∑ i : Fin p, (if (P i).eval m = k then 1 else 0)
  --       = N * (constantSlots P k).card + errorTerm P k N
  -- Swap sums and split by constant vs non-constant slots.
  rw [Finset.sum_comm]
  have hsplit : (Finset.univ : Finset (Fin p))
      = constantSlots P k ∪ (Finset.univ \ constantSlots P k) :=
    (Finset.union_sdiff_of_subset (fun i _ => Finset.mem_univ i)).symm
  rw [hsplit, Finset.sum_union Finset.disjoint_sdiff]
  -- Constant slots: each contributes N hits.
  have hconst :
      ∀ i ∈ constantSlots P k,
        (∑ m ∈ Finset.range N,
          (if (P i).eval ((m : ℕ) : ℤ) = k then 1 else 0)) = N := by
    intro i hi
    have hi' : P i = Polynomial.C k := (Finset.mem_filter.mp hi).2
    simp [hi', Finset.sum_const, Finset.card_range]
  rw [Finset.sum_congr rfl hconst]
  -- `∑ i ∈ constantSlots, N = (constantSlots).card • N`
  rw [Finset.sum_const]
  -- `card • N = card * N` (in ℕ)
  rw [smul_eq_mul]
  rw [Nat.mul_comm _ N]
  -- Unfold errorTerm and turn if-sum into filter card.
  unfold errorTerm
  congr 1
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.card_filter]

/-! ### Uniform bound on the error term -/

/--
**Error term is uniformly bounded.**  There exists a finite constant
`C : ℕ` such that `errorTerm P k N ≤ C` for every `N`.
-/
theorem errorTerm_bounded {p D : ℕ} (hp : 1 ≤ p)
    (P : PeriodicPolynomialPredictor p D) (k : ℤ) :
    ∃ C : ℕ, ∀ N : ℕ, errorTerm P k N ≤ C := by
  classical
  -- The bound: sum over non-constant slots of the (finite) full hit count on ℕ.
  -- For each non-constant slot, the full hit set is finite (root set of nonzero poly).
  -- We exhibit it via choice from the finite-set witness.
  -- Concretely: sum of the toFinset-cardinalities of the hit sets.
  have key : ∀ i ∈ (Finset.univ \ constantSlots P k : Finset (Fin p)),
      ∃ Ci : ℕ, ∀ N : ℕ,
        ((Finset.range N).filter
          (fun m => (P i).eval ((m : ℕ) : ℤ) = k)).card ≤ Ci := by
    intro i hi
    have hi_nc : i ∉ constantSlots P k := (Finset.mem_sdiff.mp hi).2
    have hne : P i ≠ Polynomial.C k := by
      intro h
      exact hi_nc (Finset.mem_filter.mpr ⟨Finset.mem_univ i, h⟩)
    -- (P i - C k) is nonzero ⇒ root set is finite.
    have hq_ne : (P i - Polynomial.C k) ≠ 0 := by
      intro hqz
      exact hne (sub_eq_zero.mp hqz)
    have hroots_fin : {z : ℤ | IsRoot (P i - Polynomial.C k) z}.Finite :=
      Polynomial.finite_setOf_isRoot hq_ne
    -- Pull back via ℕ → ℤ.
    have hhits_fin :
        {m : ℕ | (P i).eval ((m : ℕ) : ℤ) = k}.Finite := by
      have hrewrite :
          {m : ℕ | (P i).eval ((m : ℕ) : ℤ) = k}
            = ((↑) : ℕ → ℤ) ⁻¹' {z : ℤ | IsRoot (P i - Polynomial.C k) z} := by
        ext m
        simp [IsRoot, Polynomial.eval_sub, Polynomial.eval_C, sub_eq_zero]
      rw [hrewrite]
      exact hroots_fin.preimage (fun _ _ _ _ h => by exact_mod_cast h)
    refine ⟨hhits_fin.toFinset.card, fun N => ?_⟩
    have hsub : ((Finset.range N).filter
              (fun m => (P i).eval ((m : ℕ) : ℤ) = k))
            ⊆ hhits_fin.toFinset := by
      intro m hm
      rcases Finset.mem_filter.mp hm with ⟨_, hmk⟩
      exact (Set.Finite.mem_toFinset _).mpr hmk
    exact Finset.card_le_card hsub
  -- Choose a uniform Ci for each i, then sum.
  choose Ci hCi using key
  refine ⟨∑ i ∈ (Finset.univ \ constantSlots P k).attach, Ci i.1 i.2, fun N => ?_⟩
  unfold errorTerm
  rw [← Finset.sum_attach]
  exact Finset.sum_le_sum (fun i _ => hCi i.1 i.2 N)

/-! ### Main rationality theorem -/

/--
**Bridge Theorem 4A.1 clause (d) — predictor version.**

For a K₂-predictable continued-fraction sequence with period `p ≥ 1`
described by a polynomial predictor `P : Fin p → Polynomial ℤ`, and
any target digit `k : ℤ`, the asymptotic digit frequency is a rational
number `r` with denominator dividing `p`.

Concretely, with `c = (#constant slots giving value k)` and the count
in the window `range (N · p)` denoted `digitCount hp P k N`, we have:

  `r = (c : ℚ) / (p : ℚ)`,  `r.den ∣ p`,
and there exists a uniform bound `C : ℕ` such that for every `N`,

  `digitCount hp P k N  =  N * c  +  E(N)`  with  `E(N) ≤ C`.

In particular `digitCount hp P k N / (N · p) → r` as `N → ∞`.
-/
theorem predictor_frequency_rational {p D : ℕ} (hp : 1 ≤ p)
    (P : PeriodicPolynomialPredictor p D) (k : ℤ) :
    ∃ (r : ℚ) (c C : ℕ),
      r = (c : ℚ) / (p : ℚ) ∧
      r.den ∣ p ∧
      c = (constantSlots P k).card ∧
      (∀ N : ℕ,
        digitCount hp P k N = N * c + errorTerm P k N
        ∧ errorTerm P k N ≤ C) := by
  classical
  set c : ℕ := (constantSlots P k).card with hc_def
  obtain ⟨C, hC⟩ := errorTerm_bounded hp P k
  refine ⟨(c : ℚ) / (p : ℚ), c, C, rfl, ?_, rfl, ?_⟩
  · -- r.den ∣ p.  Use Rat.den_dvd : ((a /. b).den : ℤ) ∣ b.
    have h1 : (c : ℚ) / (p : ℚ) = Rat.divInt (c : ℤ) (p : ℤ) := by
      have h0 := Rat.intCast_div_eq_divInt (c : ℤ) (p : ℤ)
      push_cast at h0
      exact h0
    rw [h1]
    have hZ : (((Rat.divInt (c : ℤ) (p : ℤ)).den : ℤ) ∣ (p : ℤ)) :=
      Rat.den_dvd (c : ℤ) (p : ℤ)
    exact_mod_cast hZ
  · intro N
    refine ⟨?_, hC N⟩
    exact digit_count_eq hp P k N

/-! ### Axiom audit -/

#print axioms digit_count_eq
#print axioms errorTerm_bounded
#print axioms predictor_frequency_rational

end OmegaTheory.Irrationality.HermitePade
