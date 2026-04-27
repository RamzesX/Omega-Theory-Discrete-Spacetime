/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSymmetricSum

  Cycle 62 (Pisces) Phase B Wave T-4b session 10 — symmetric-sum integer
  witness, Phase 1: elementary symmetric polynomials in aroots are integers.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers (Wave T4b session 10 — Phase 1)

  PROVES: For monic `f : ℤ[X]`, the elementary symmetric polynomials
  evaluated at the complex roots of `f` are integers.

  Specifically: `(f.aroots ℂ).esymm n = (M : ℂ)` for some `M : ℤ`.

  Proof: `Polynomial.coeff_eq_esymm_roots_of_card` (Vieta's formula)
  +  `IsAlgClosed.splits` (ℂ is algebraically closed) + monic property.

  This is the foundation for the full symmetric-sum integer witness
  (later phases extend to power sums via Newton's identity, then to
  arbitrary polynomial functions via linearity).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build — this file
  carries 0 sorry, 0 new axioms (Lean core only on every theorem).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerExtraction
import Mathlib.RingTheory.Polynomial.Vieta
import Mathlib.Algebra.Polynomial.Splits
import Mathlib.FieldTheory.IsAlgClosed.Basic
import Mathlib.Analysis.Complex.Polynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSymmetricSum

open Polynomial Complex

/-! ## Phase 1 helpers -/

/-- Helper: `(-1)^n * (-1)^n = 1` in ℂ. -/
private theorem neg_one_pow_mul_self (n : ℕ) :
    ((-1 : ℂ))^n * ((-1 : ℂ))^n = 1 := by
  rw [← pow_add, show n + n = 2 * n from (two_mul n).symm, pow_mul]
  simp

/-- Helper: `((-1)^n) * ((-1)^n * x) = x` in ℂ. -/
private theorem neg_one_pow_double_cancel (n : ℕ) (x : ℂ) :
    ((-1 : ℂ))^n * (((-1 : ℂ))^n * x) = x := by
  rw [← mul_assoc, neg_one_pow_mul_self, one_mul]

/-! ## Phase 1 — Vieta gives elementary symmetric polynomials = integers -/

/-- **Wave T4b session 10 Phase 1 — esymm via Vieta**.

    For monic `f : ℤ[X]` and any `k ≤ f.natDegree`, the
    `(f.natDegree - k)`-th elementary symmetric polynomial in
    `f.aroots ℂ` is an integer:

      `(f.aroots ℂ).esymm (f.natDegree - k) = ((-1)^(natDeg - k) * f.coeff k : ℂ)`

    Proof: `Polynomial.coeff_eq_esymm_roots_of_card` (Vieta) gives
    `fC.coeff k = (-1)^(natDeg-k) * esymm`.  Multiplying both sides
    by `(-1)^(natDeg-k)` (whose square is 1) inverts to
    `esymm = (-1)^(natDeg-k) * fC.coeff k = (-1)^(natDeg-k) * (f.coeff k : ℂ)`,
    which equals `((-1)^(natDeg-k) * f.coeff k : ℤ) : ℂ` by integer
    arithmetic. -/
theorem aroots_esymm_is_integer
    (f : Polynomial ℤ) (h_monic : f.Monic)
    (k : ℕ) (hk : k ≤ f.natDegree) :
    (f.aroots ℂ).esymm (f.natDegree - k)
      = (((-1) ^ (f.natDegree - k) * f.coeff k : ℤ) : ℂ) := by
  -- Set up the image polynomial in ℂ[X]
  let fC : Polynomial ℂ := Polynomial.map (Int.castRingHom ℂ) f
  have h_fC_monic : fC.Monic := h_monic.map _
  -- Splits in ℂ since ℂ is algebraically closed
  have h_splits : fC.Splits := IsAlgClosed.splits fC
  -- aroots = roots of mapped poly
  have h_aroots_eq : f.aroots ℂ = fC.roots := rfl
  -- Degree preservation (monic ⇒ natDegree preserved)
  have h_natDegree : fC.natDegree = f.natDegree := h_monic.natDegree_map _
  -- Cardinality of roots = natDegree (since splits over alg closed field)
  have h_card : fC.roots.card = fC.natDegree :=
    (Polynomial.splits_iff_card_roots.mp h_splits)
  -- Apply Vieta
  have h_vieta : fC.coeff k =
      fC.leadingCoeff * (-1) ^ (fC.natDegree - k) *
        fC.roots.esymm (fC.natDegree - k) := by
    apply Polynomial.coeff_eq_esymm_roots_of_card h_card
    rw [h_natDegree]; exact hk
  -- Monic: leadingCoeff = 1
  rw [h_fC_monic.leadingCoeff, one_mul] at h_vieta
  -- Coefficient cast
  have h_coeff_cast : fC.coeff k = ((f.coeff k : ℤ) : ℂ) := by
    show (Polynomial.map (Int.castRingHom ℂ) f).coeff k = _
    rw [Polynomial.coeff_map]; rfl
  rw [h_coeff_cast] at h_vieta
  -- h_vieta : ((f.coeff k : ℤ) : ℂ) = (-1)^(fC.natDegree - k) * fC.roots.esymm (fC.natDegree - k)
  -- Multiply both sides by (-1)^(fC.natDegree - k) and use neg_one_pow_mul_self
  have h_natDeg_eq : fC.natDegree - k = f.natDegree - k := by rw [h_natDegree]
  rw [h_aroots_eq, ← h_natDeg_eq]
  -- Want: fC.roots.esymm (fC.natDegree - k) = ((-1)^(fC.natDegree - k) * f.coeff k : ℂ)
  push_cast
  -- Multiply h_vieta from left by (-1)^(fC.natDegree - k):
  have h_mult : (-1 : ℂ)^(fC.natDegree - k) * ((f.coeff k : ℤ) : ℂ) =
                (-1 : ℂ)^(fC.natDegree - k) *
                  ((-1 : ℂ)^(fC.natDegree - k) *
                    fC.roots.esymm (fC.natDegree - k)) := by
    rw [h_vieta]
  rw [neg_one_pow_double_cancel] at h_mult
  -- h_mult : (-1)^(fC.natDegree - k) * ((f.coeff k : ℤ) : ℂ) = fC.roots.esymm (fC.natDegree - k)
  -- After ← h_mult, goal becomes (-1)^(...) * (f.coeff k : ℂ) = ((-1)^(...) * f.coeff k : ℤ → ℂ),
  -- which is reflexive after the cast.
  rw [← h_mult]

/-! ## Phase 1 — General elementary symmetric is integer -/

/-- **Direct corollary**: `(f.aroots ℂ).esymm n` is an integer for any
    `n ≤ f.natDegree`, given monic `f : ℤ[X]`.  Sets `k := f.natDegree - n`. -/
theorem aroots_esymm_is_integer_direct
    (f : Polynomial ℤ) (h_monic : f.Monic)
    (n : ℕ) (hn : n ≤ f.natDegree) :
    ∃ M : ℤ, (f.aroots ℂ).esymm n = (M : ℂ) := by
  -- Use n = f.natDegree - k, so k = f.natDegree - n
  refine ⟨(-1) ^ n * f.coeff (f.natDegree - n), ?_⟩
  have hk : f.natDegree - n ≤ f.natDegree := Nat.sub_le _ _
  have h_aux := aroots_esymm_is_integer f h_monic (f.natDegree - n) hk
  have h_n_eq : f.natDegree - (f.natDegree - n) = n := Nat.sub_sub_self hn
  rw [h_n_eq] at h_aux
  exact h_aux

/-! ## Phase 1 headline -/

/-- **HEADLINE — Wave T4b session 10 Phase 1**.  Foundational result for
    L-W: elementary symmetric polynomials in `f.aroots ℂ` are integers
    for monic `f : ℤ[X]`. -/
theorem session_10_phase_1_headline :
    ∀ (f : Polynomial ℤ) (h_monic : f.Monic) (n : ℕ) (hn : n ≤ f.natDegree),
        ∃ M : ℤ, (f.aroots ℂ).esymm n = (M : ℂ) :=
  aroots_esymm_is_integer_direct

/-! ## Phase 2 — Power sums (k=0, k=1 cases proven) -/

/-- **Wave T4b session 10 Phase 2 — power sum k=0**.

    For any Multiset `s : Multiset ℂ`, `(s.map (·^0)).sum = s.card`.
    For aroots of monic `f : ℤ[X]` over ℂ, the cardinality equals
    `f.natDegree` (since ℂ is algebraically closed). Both are integers.

    PROVEN unconditionally — `(·^0) = 1` constant function. -/
theorem aroots_psum_zero_is_integer
    (f : Polynomial ℤ) (_h_monic : f.Monic) :
    ∃ M : ℤ, ((f.aroots ℂ).map (fun _ => (1 : ℂ))).sum = (M : ℂ) := by
  refine ⟨(f.aroots ℂ).card, ?_⟩
  -- (map (fun _ => 1) s).sum = s.card * 1 = s.card
  rw [Multiset.map_const', Multiset.sum_replicate]
  simp [Multiset.card]

/-! ## Phase 2 — Power sum k=1 (sum of roots, integer via esymm 1) -/

/-- Helper: for any Multiset over a CommSemiring, `esymm s 1 = s.sum`.
    Proof via `Multiset.powersetCard_one` (singleton subsets) +
    `Multiset.prod_singleton`. -/
private theorem multiset_esymm_one_eq_sum {R : Type*} [CommSemiring R]
    (s : Multiset R) :
    s.esymm 1 = s.sum := by
  unfold Multiset.esymm
  rw [Multiset.powersetCard_one, Multiset.map_map]
  -- Goal: (s.map (prod ∘ singleton)).sum = s.sum
  -- prod ∘ singleton = id (every singleton's product is itself)
  simp only [Function.comp_apply, Multiset.prod_singleton, Multiset.map_id']

/-- **Wave T4b session 10 Phase 2 — power sum k=1**.

    For monic `f : ℤ[X]`, the sum of complex roots `(f.aroots ℂ).sum`
    equals `(f.aroots ℂ).esymm 1` (via `multiset_esymm_one_eq_sum`),
    which is an integer by Phase 1.  Requires `1 ≤ f.natDegree`. -/
theorem aroots_psum_one_is_integer
    (f : Polynomial ℤ) (h_monic : f.Monic) (h_pos : 1 ≤ f.natDegree) :
    ∃ M : ℤ, (f.aroots ℂ).sum = (M : ℂ) := by
  obtain ⟨M, hM⟩ := aroots_esymm_is_integer_direct f h_monic 1 h_pos
  refine ⟨M, ?_⟩
  rw [← multiset_esymm_one_eq_sum]
  exact hM

/-! ## Phase 2 headline (k=0 case) -/

/-- **HEADLINE — Wave T4b session 10 Phase 2 partial**.  Power sum for
    `k = 0` is integer (it's `aroots.card`).  The general `k ≥ 1` case
    follows from Newton's identity (Mathlib
    `MvPolynomial.psum_eq_mul_esymm_sub_sum`) via Multiset-level
    evaluation; deferred to follow-up Phase 2 expansion. -/
theorem session_10_phase_2_partial_headline
    (f : Polynomial ℤ) (h_monic : f.Monic) :
    ∃ M : ℤ, ((f.aroots ℂ).map (fun _ => (1 : ℂ))).sum = (M : ℂ) :=
  aroots_psum_zero_is_integer f h_monic

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSymmetricSum
