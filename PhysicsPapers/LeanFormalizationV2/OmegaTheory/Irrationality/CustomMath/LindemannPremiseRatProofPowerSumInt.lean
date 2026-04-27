/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumInt

  Cycle 62 (Pisces) Phase B Wave T-4b session 11 — aeval bridge for
  `MvPolynomial.psum`.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  PROVES the **aeval bridge** for power-sum polynomials:

    `aeval f (MvPolynomial.psum σ R k) = ∑_{i:σ} (f i)^k`

  This is the analog of Mathlib's `aeval_esymm_eq_multiset_esymm` for
  power sums.  Bridges the MvPolynomial-level Newton's identity
  `psum_eq_mul_esymm_sub_sum` to value-level identities at any point,
  which is the foundation for the Multiset-level Newton identity (Phase 2,
  follow-up).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS
  (no `Prop := True`, no `: True := trivial`).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSymmetricSum
import Mathlib.RingTheory.MvPolynomial.Symmetric.NewtonIdentities

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumInt

open Polynomial Complex MvPolynomial

/-! ## aeval bridge for psum -/

/-- **Bridge lemma**: evaluating `MvPolynomial.psum σ R k` at `f : σ → S`
    yields `∑_{i : σ} (f i)^k`.

    Proof: `psum σ R k := ∑ i, X i ^ k` (definition); apply `aeval`
    distributing over sum and pow; `aeval f (X i) = f i`. -/
theorem aeval_psum_eq_sum_pow
    {σ : Type*} (R : Type*) {S : Type*}
    [Fintype σ] [CommSemiring R] [CommSemiring S] [Algebra R S]
    (f : σ → S) (k : ℕ) :
    (MvPolynomial.aeval f) (MvPolynomial.psum σ R k) = ∑ i, (f i)^k := by
  unfold MvPolynomial.psum
  rw [map_sum]
  congr 1
  funext i
  rw [map_pow, MvPolynomial.aeval_X]

/-- **Multiset form** of `aeval_psum_eq_sum_pow`: equivalent expression
    via Multiset map sum (the form used by L-W to express `(s.map (·^k)).sum`
    where `s` is the multiset image of `f`).  Uses
    `Finset.sum_eq_multiset_sum`. -/
theorem aeval_psum_eq_multiset_map_pow_sum
    {σ : Type*} (R : Type*) {S : Type*}
    [Fintype σ] [CommSemiring R] [CommSemiring S] [Algebra R S]
    (f : σ → S) (k : ℕ) :
    (MvPolynomial.aeval f) (MvPolynomial.psum σ R k) =
      ((Multiset.map f Finset.univ.val).map (· ^ k)).sum := by
  rw [aeval_psum_eq_sum_pow R f k]
  -- ∑ i, (f i)^k = ((Multiset.map f Finset.univ.val).map (·^k)).sum
  -- via Multiset.map_map: the RHS = (Finset.univ.val.map ((·^k) ∘ f)).sum
  rw [Multiset.map_map]
  -- (Finset.univ.val.map ((·^k) ∘ f)).sum = ∑ i ∈ Finset.univ, (f i)^k
  exact (Finset.sum_eq_multiset_sum Finset.univ (fun i => (f i)^k)).symm

/-! ## Multiset = Fin function image lemma -/

/-- **Multiset is the image of some `Fin n → R`**: every Multiset of
    cardinality `n` arises as `Multiset.map f Finset.univ.val` for some
    `f : Fin n → R`.  Concretely, `f := s.toList.get`. -/
theorem multiset_exists_fin_function_image
    {R : Type*} (s : Multiset R) :
    ∃ (f : Fin s.card → R), Multiset.map f (Finset.univ : Finset (Fin s.card)).val = s := by
  -- Use s.toList; convert via List.ofFn_get + Multiset.coe_toList
  let h_len : s.card = s.toList.length := (Multiset.length_toList s).symm
  let f : Fin s.card → R := fun i =>
    s.toList.get ⟨i.val, h_len ▸ i.is_lt⟩
  refine ⟨f, ?_⟩
  -- Multiset.map f Finset.univ.val = ↑(List.ofFn f) by Fin.univ_val_map
  rw [Fin.univ_val_map]
  -- ↑(List.ofFn f) = ↑s.toList (via List.ofFn_get applied to a re-indexed list)
  have h_ofFn : List.ofFn f = s.toList := by
    -- f i = s.toList.get ⟨i.val, ...⟩, so List.ofFn f reconstructs s.toList
    -- via List.ofFn_get applied with appropriate Fin reindexing
    apply List.ext_get
    · rw [List.length_ofFn]
      exact h_len
    · intro i h_i_left h_i_right
      rw [List.get_ofFn]
      rfl
  rw [h_ofFn]
  -- ↑s.toList = s
  exact Multiset.coe_toList s

/-! ## Multiset Newton's identity -/

/-- **Multiset Newton's identity** — for any Multiset `s` over a CommRing `R`
    and any `k > 0`:

      `(s.map (·^k)).sum = (-1)^(k+1) · k · s.esymm k -
          ∑ a ∈ {(i,k-i) : 0 < i < k}, (-1)^a.1 · s.esymm a.1 · (s.map (·^a.2)).sum`

    Derived from MvPolynomial Newton's identity by aeval'ing at any
    function `f : Fin s.card → R` whose multiset image is `s` (existence
    via `multiset_exists_fin_function_image`). -/
theorem multiset_newton_identity
    {R : Type*} [CommRing R] (s : Multiset R) (k : ℕ) (hk : 0 < k) :
    (s.map (· ^ k)).sum =
      (-1) ^ (k + 1) * (k : R) * s.esymm k -
        ∑ a ∈ (Finset.antidiagonal k).filter (fun a => a.1 ∈ Set.Ioo 0 k),
          (-1) ^ a.1 * s.esymm a.1 * (s.map (· ^ a.2)).sum := by
  obtain ⟨f, h_f_image⟩ := multiset_exists_fin_function_image s
  -- Apply MvPolynomial Newton + aeval at f
  have h_mv := MvPolynomial.psum_eq_mul_esymm_sub_sum (Fin s.card) R k hk
  have h_aeval := congrArg (MvPolynomial.aeval f) h_mv
  -- Simplify LHS via aeval_psum_eq_multiset_map_pow_sum
  rw [aeval_psum_eq_multiset_map_pow_sum R f k] at h_aeval
  rw [h_f_image] at h_aeval
  -- Simplify RHS using aeval distributing over operations + bridge lemmas
  simp only [map_sub, map_mul, map_pow, map_neg, map_one, map_natCast,
      MvPolynomial.aeval_esymm_eq_multiset_esymm,
      aeval_psum_eq_multiset_map_pow_sum, h_f_image, map_sum] at h_aeval
  exact h_aeval

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumInt
