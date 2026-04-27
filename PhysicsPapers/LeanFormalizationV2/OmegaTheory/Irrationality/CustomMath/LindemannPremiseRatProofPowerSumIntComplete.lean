/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntComplete

  Cycle 62 (Pisces) Phase B Wave T-4b session 12 — esymm = integer for ALL k
  (extending Phase 1 to k > natDegree case via empty powersetCard).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  PROVES: For monic `f : ℤ[X]` and ANY `n : ℕ` (no upper bound):

      ∃ M : ℤ, (f.aroots ℂ).esymm n = (M : ℂ)

  Extends Phase 1 (session 10) which only covered `n ≤ f.natDegree`.
  For `n > f.natDegree`, the (n)-element power-set is empty, so
  `s.esymm n = 0` (an integer).

  Also proves the cardinality lemma `(f.aroots ℂ).card = f.natDegree`
  for monic `f`, used in the case split.

  This is the foundation for the Phase 3 power-sum-integer-ness
  induction (next session): for that induction, we need esymm
  values for ALL k, not just k ≤ natDegree.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumInt

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntComplete

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSymmetricSum

/-! ## aroots cardinality = natDegree (for monic f : ℤ[X]) -/

/-- For monic `f : ℤ[X]`, `(f.aroots ℂ).card = f.natDegree`.

    Proof: `f.map ℤ → ℂ` is monic (preserves leading coeff), so its
    natDegree equals f.natDegree.  ℂ is algebraically closed, so the
    mapped polynomial splits, hence `roots.card = natDegree`. -/
theorem aroots_card_eq_natDegree
    (f : Polynomial ℤ) (h_monic : f.Monic) :
    (f.aroots ℂ).card = f.natDegree := by
  let fC : Polynomial ℂ := Polynomial.map (Int.castRingHom ℂ) f
  have h_fC_monic : fC.Monic := h_monic.map _
  have h_splits : fC.Splits := IsAlgClosed.splits fC
  have h_natDegree : fC.natDegree = f.natDegree := h_monic.natDegree_map _
  have h_card : fC.roots.card = fC.natDegree :=
    Polynomial.splits_iff_card_roots.mp h_splits
  show fC.roots.card = f.natDegree
  rw [h_card, h_natDegree]

/-! ## esymm = integer for ALL k (extending Phase 1) -/

/-- **Extension of Phase 1**: for monic `f : ℤ[X]` and any `n : ℕ`,
    `(f.aroots ℂ).esymm n` is an integer.

    For `n ≤ f.natDegree`: use Phase 1 (Vieta).
    For `n > f.natDegree`: by `aroots_card_eq_natDegree`,
      `aroots.card < n`, so `powersetCard n aroots = 0` (Mathlib
      `Multiset.powersetCard_eq_empty`).  Hence esymm = 0 (integer). -/
theorem aroots_esymm_is_integer_all
    (f : Polynomial ℤ) (h_monic : f.Monic) (n : ℕ) :
    ∃ M : ℤ, (f.aroots ℂ).esymm n = (M : ℂ) := by
  by_cases h_le : n ≤ f.natDegree
  · exact aroots_esymm_is_integer_direct f h_monic n h_le
  · push_neg at h_le
    refine ⟨0, ?_⟩
    have h_card_lt : (f.aroots ℂ).card < n := by
      rw [aroots_card_eq_natDegree f h_monic]
      exact h_le
    unfold Multiset.esymm
    rw [Multiset.powersetCard_eq_empty n h_card_lt]
    simp

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPowerSumIntComplete
