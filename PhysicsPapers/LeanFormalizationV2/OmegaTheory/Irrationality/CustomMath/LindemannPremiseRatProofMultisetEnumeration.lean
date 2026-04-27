/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultisetEnumeration

  Cycle 63→64 Phase B Wave T-4b session 47 — Multiset enumeration
  via Fin function.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Generic existence: for any `Multiset ℂ` `s` with `Multiset.card s = n`,
  there exists `α : Fin n → ℂ` such that
  `((Finset.univ : Finset (Fin n)).val.map α) = s`.

  Proof: use `Multiset.toList` + `Fin.univ_val_map` + `List.ofFn_get`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Multiset.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.List.OfFn
import Mathlib.Data.Complex.Basic

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultisetEnumeration

open Complex

/-! ## Multiset enumeration via Fin function -/

/-- **Wave T4b session 47 — Multiset enumeration**.

    For any Multiset s of ℂ, there exists a function `α : Fin (Multiset.card s) → ℂ`
    such that `(Finset.univ).val.map α = s`.

    Proof: use `s.toList.get` after a `Fin.cast` along `length_toList`. -/
theorem exists_enumeration_of_card (s : Multiset ℂ) (n : ℕ) (hn : Multiset.card s = n) :
    ∃ α : Fin n → ℂ, ((Finset.univ : Finset (Fin n)).val.map α) = s := by
  -- Step 1: get cardinality of toList
  have h_len : s.toList.length = n := by
    rw [Multiset.length_toList]
    exact hn
  -- Step 2: define α : Fin n → ℂ via Fin.cast
  refine ⟨fun i : Fin n => s.toList.get ⟨i.val, by rw [h_len]; exact i.isLt⟩, ?_⟩
  -- Step 3: prove the multiset equality
  rw [Fin.univ_val_map]
  -- Goal: ↑(List.ofFn (fun i => s.toList.get ⟨i.val, _⟩)) = s
  -- Strategy: show List.ofFn (...) = s.toList, then use coe_toList
  have h_ofFn : List.ofFn (fun i : Fin n => s.toList.get ⟨i.val, by rw [h_len]; exact i.isLt⟩) =
                s.toList := by
    -- Convert the function to s.toList.get via Fin.cast
    have h_eq : (fun i : Fin n => s.toList.get ⟨i.val, by rw [h_len]; exact i.isLt⟩) =
                s.toList.get ∘ Fin.cast h_len.symm := by
      funext i
      rfl
    rw [h_eq]
    -- Now: List.ofFn (s.toList.get ∘ Fin.cast h_len.symm) = s.toList
    -- Use ofFn_congr to flip the cast, then ofFn_get to close
    have h_ofFn_cast : List.ofFn (s.toList.get ∘ Fin.cast h_len.symm) =
                       List.ofFn s.toList.get :=
      (List.ofFn_congr h_len s.toList.get).symm
    rw [h_ofFn_cast]
    exact List.ofFn_get s.toList
  rw [h_ofFn]
  exact Multiset.coe_toList s

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 47**.  Existence of an enumeration
    of any Multiset of ℂ via a function from Fin n where n is the
    multiset's cardinality.

    This is needed to apply s46 (formal coefficient eval rational) to
    `f.aroots ℂ` for any nonzero `f : ℤ[X]`. -/
theorem session_47_multiset_enumeration_headline
    (s : Multiset ℂ) (n : ℕ) (hn : Multiset.card s = n) :
    ∃ α : Fin n → ℂ, ((Finset.univ : Finset (Fin n)).val.map α) = s :=
  exists_enumeration_of_card s n hn

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultisetEnumeration
