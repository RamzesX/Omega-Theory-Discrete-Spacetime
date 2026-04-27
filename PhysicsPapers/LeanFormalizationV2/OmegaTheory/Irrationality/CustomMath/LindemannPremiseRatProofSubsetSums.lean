/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 15 — subset-sum
  machinery for Lindemann–Weierstrass closure.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Provides the Multiset binomial expansion for the orbit-product:

      ∏_{α ∈ s} (1 + e^α) = ∑_{T ⊆ s} exp(σ_T)   where σ_T := Σ_{α ∈ T} α.

  Key contributions:

    1. **`subsetSums (s : Multiset ℂ) : Multiset ℂ := s.powerset.map Multiset.sum`**
       — the multiset of all subset-sums of `s`.

    2. **`card_subsetSums (s : Multiset ℂ) : (subsetSums s).card = 2^s.card`**
       — there are exactly 2^|s| subsets.

    3. **`prod_one_add_eq_sum_powerset_prod`** — Multiset binomial expansion
       at the level of arbitrary commutative semirings (helper).

    4. **`prod_one_add_exp_eq_sum_exp_subsetSums`** — the orbit-product
       expansion: `(s.map (fun α => 1 + Complex.exp α)).prod = (subsetSums s).map Complex.exp |>.sum`.

    5. **`sum_exp_subsetSums_eq_zero_of_iPi_mem`** — when iπ ∈ s, the
       subset-sum exponential sum is 0 (since one factor is `1 + e^{iπ} = 0`).

  This is the entry point for L-W closure: the orbit-product expansion
  expresses ∏(1+e^α) as ∑ exp(σ_S), and combined with `1+e^{iπ}=0`
  gives ∑ exp(σ_S) = 0, the algebraic identity that drives the
  contradiction in cycles 63-65.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS
  (no `Prop := True`, no `: True := trivial`, no `:= trivial` placeholders).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalIntSum
import Mathlib.Data.Multiset.Powerset
import Mathlib.Algebra.BigOperators.Ring.Multiset
import Mathlib.Analysis.Complex.Exponential
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitProduct

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation

/-! ## Subset-sum definition -/

/-- **subsetSums s** : the multiset of all subset-sums of `s : Multiset ℂ`.

    For each subset `T ⊆ s` (with multiplicity preserved), `T.sum` is a
    complex number; collecting these gives `subsetSums s`.  Cardinality
    is `2^s.card`. -/
noncomputable def subsetSums (s : Multiset ℂ) : Multiset ℂ := s.powerset.map Multiset.sum

/-- Cardinality of `subsetSums s` is exactly `2^s.card`. -/
theorem card_subsetSums (s : Multiset ℂ) : (subsetSums s).card = 2 ^ s.card := by
  unfold subsetSums
  rw [Multiset.card_map, Multiset.card_powerset]

/-! ## Generic Multiset binomial expansion (any commutative semiring) -/

/-- **Multiset binomial expansion** — for any commutative semiring `R`,
    Multiset `s : Multiset α`, and function `f : α → R`:

      `(s.map (fun a => 1 + f a)).prod = (s.powerset.map (fun T => (T.map f).prod)).sum`.

    Proof: Multiset induction on `s`.  Base: empty s gives `1 = 1`.  Cons
    step: distribute `(1 + f a) = 1 + f a` over the IH, use
    `Multiset.powerset_cons` to split powerset into "without a" + "with a"
    branches, factor `f a` out via `Multiset.sum_map_mul_left`. -/
theorem multiset_prod_one_add_eq_sum_powerset_prod
    {α R : Type*} [CommSemiring R] (s : Multiset α) (f : α → R) :
    (s.map (fun a => 1 + f a)).prod = (s.powerset.map (fun T => (T.map f).prod)).sum := by
  induction s using Multiset.induction with
  | empty =>
      simp [Multiset.powerset_zero]
  | cons a s ih =>
      simp only [Multiset.map_cons, Multiset.prod_cons, ih]
      -- LHS: (1 + f a) * (s.powerset.map (fun T => (T.map f).prod)).sum
      rw [Multiset.powerset_cons]
      -- (a ::ₘ s).powerset = s.powerset + s.powerset.map (Multiset.cons a)
      simp only [Multiset.map_add, Multiset.sum_add]
      rw [Multiset.map_map]
      -- (s.powerset.map ((fun T => (T.map f).prod) ∘ Multiset.cons a)).sum
      -- ((Multiset.cons a x).map f).prod = (f a ::ₘ x.map f).prod = f a * (x.map f).prod
      have h_eq : ∀ x : Multiset α,
          ((fun T => (T.map f).prod) ∘ Multiset.cons a) x =
            f a * (x.map f).prod := by
        intro x
        simp [Function.comp, Multiset.map_cons, Multiset.prod_cons]
      rw [show (s.powerset.map ((fun T => (T.map f).prod) ∘ Multiset.cons a))
            = (s.powerset.map (fun x => f a * (x.map f).prod)) by
          apply Multiset.map_congr rfl
          intros x _
          exact h_eq x]
      rw [Multiset.sum_map_mul_left]
      ring

/-! ## Orbit-product expansion specialised to `1 + Complex.exp α` -/

/-- **Orbit-product expansion** — for any Multiset `s : Multiset ℂ`:

      `(s.map (fun α => 1 + Complex.exp α)).prod = ((subsetSums s).map Complex.exp).sum`.

    Proof: apply the generic Multiset binomial expansion with `f := Complex.exp`,
    then convert each `(T.map exp).prod = exp T.sum` via Mathlib
    `Complex.exp_multiset_sum`. -/
theorem prod_one_add_exp_eq_sum_exp_subsetSums (s : Multiset ℂ) :
    (s.map (fun α => 1 + Complex.exp α)).prod
      = ((subsetSums s).map Complex.exp).sum := by
  rw [multiset_prod_one_add_eq_sum_powerset_prod s Complex.exp]
  -- LHS: (s.powerset.map (fun T => (T.map Complex.exp).prod)).sum
  -- RHS: ((subsetSums s).map Complex.exp).sum = ((s.powerset.map Multiset.sum).map Complex.exp).sum
  unfold subsetSums
  rw [Multiset.map_map]
  -- Now: (s.powerset.map (fun T => (T.map exp).prod)).sum
  --    = (s.powerset.map (Complex.exp ∘ Multiset.sum)).sum
  congr 1
  apply Multiset.map_congr rfl
  intros T _
  -- Goal: (T.map Complex.exp).prod = (Complex.exp ∘ Multiset.sum) T
  -- (Complex.exp ∘ Multiset.sum) T = Complex.exp T.sum
  -- (T.map Complex.exp).prod = Complex.exp T.sum  (Mathlib `Complex.exp_multiset_sum`)
  simp only [Function.comp]
  exact (Complex.exp_multiset_sum T).symm

/-! ## Composition with iπ orbit-product = 0 (s5) -/

/-- **Wave T4b session 15 composition with s5**: when `iπ ∈ s`, the
    subset-sum exponential sum is 0.

    Proof: by `prod_one_add_exp_eq_sum_exp_subsetSums`, the sum equals
    the orbit-product `(s.map (1 + e·)).prod`.  By session 5's
    `orbit_product_eq_zero_of_iPi_mem`, this product is 0. -/
theorem sum_exp_subsetSums_eq_zero_of_iPi_mem
    (s : Multiset ℂ) (h : (Complex.I * (Real.pi : ℂ)) ∈ s) :
    ((subsetSums s).map Complex.exp).sum = 0 := by
  rw [← prod_one_add_exp_eq_sum_exp_subsetSums]
  exact OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitProduct.orbit_product_eq_zero_of_iPi_mem
    s h

/-! ## Headline + paper bundle -/

/-- **HEADLINE — Wave T4b session 15 subset-sum machinery**.  Single
    4-conjunct showing the subset-sum content:

      1. `subsetSums` definition + cardinality `2^card`.
      2. Generic Multiset binomial expansion (any CommSemiring).
      3. Specialised to `1 + Complex.exp α`: orbit-product = subset-sum
         exponential sum.
      4. When iπ ∈ s, the subset-sum exponential sum is 0. -/
theorem session_15_subset_sum_headline :
    (∀ s : Multiset ℂ, (subsetSums s).card = 2 ^ s.card)
      ∧ (∀ {α R : Type*} [CommSemiring R] (s : Multiset α) (f : α → R),
          (s.map (fun a => 1 + f a)).prod
            = (s.powerset.map (fun T => (T.map f).prod)).sum)
      ∧ (∀ s : Multiset ℂ,
          (s.map (fun α => 1 + Complex.exp α)).prod
            = ((subsetSums s).map Complex.exp).sum)
      ∧ (∀ (s : Multiset ℂ), (Complex.I * (Real.pi : ℂ)) ∈ s →
          ((subsetSums s).map Complex.exp).sum = 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact card_subsetSums
  · intros α R _ s f
    exact multiset_prod_one_add_eq_sum_powerset_prod s f
  · exact prod_one_add_exp_eq_sum_exp_subsetSums
  · exact sum_exp_subsetSums_eq_zero_of_iPi_mem

/-- **W-T4b session 15 paper bundle** — citation marker. -/
theorem session_15_subset_sum_paper_bundle :
    ((∀ s : Multiset ℂ, (subsetSums s).card = 2 ^ s.card)
        ∧ (∀ s : Multiset ℂ,
            (s.map (fun α => 1 + Complex.exp α)).prod
              = ((subsetSums s).map Complex.exp).sum)
        ∧ (∀ (s : Multiset ℂ), (Complex.I * (Real.pi : ℂ)) ∈ s →
            ((subsetSums s).map Complex.exp).sum = 0))
    ∧ (∀ s : Multiset ℂ, Complex.exp s.sum = (s.map Complex.exp).prod) := by
  refine ⟨?_, ?_⟩
  · exact ⟨card_subsetSums,
            prod_one_add_exp_eq_sum_exp_subsetSums,
            sum_exp_subsetSums_eq_zero_of_iPi_mem⟩
  · exact Complex.exp_multiset_sum

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
