/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultiRootSum

  Cycle 62 (Pisces) Phase B Wave T-4b session 8 — multi-root sum norm bound.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers (Wave T4b session 8)

  This file extends Wave T4b session 6 by summing the per-root analytical
  bound across the orbit (Multiset of roots).  Specifically:

  Given a Multiset orbit and a function `f : ℂ → ℂ` with per-element bound
  `‖f(r)‖ ≤ B` for each `r ∈ orbit`, the sum norm is bounded:

    ‖∑_{r ∈ orbit} f(r)‖ ≤ orbit.card · B

  via the standard `Multiset.norm_sum_le` + uniform bound.

  Specialized to the L-W setting: with `f(r) := n·exp(r) - p·aeval(r) gp`
  and `B := c^p / (p-1)!`, the orbit-sum is bounded by
  `orbit.card · c^p / (p-1)!`, which → 0 as p → ∞.

  Key contributions:

    1. **`norm_multiset_sum_le_card_mul_bound`** — generic Multiset uniform
       sum-norm bound.

    2. **`orbit_sum_lindemann_bound`** — applied to the L-W per-root
       analytical bound.

    3. **`orbit_sum_bound_decay_to_zero`** — corollary: as p → ∞, the
       orbit-sum norm bound → 0.

  ## Honest narrower-true scope (binding)

  The orbit-sum norm bound is the analytical-side ingredient of the
  L-W contradiction.  The complementary ingredient (orbit-sum = some
  specific integer ≠ 0) requires the symmetric-polynomial fundamental
  theorem (cycle 65+).  Together they yield the integer ∧ |·| < 1 ∧ ≠ 0
  → False contradiction.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build — this file
  carries 0 sorry, 0 new axioms (Lean core only on every theorem).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofRationalAnnihilator
import Mathlib.Algebra.BigOperators.Ring.Multiset
import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Topology.Algebra.Order.Floor

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultiRootSum

open Polynomial Complex

/-! ## Phase 1 — Generic Multiset sum-norm bound -/

/-- **Wave T4b session 8 — Multiset uniform sum-norm bound**.

    For a Multiset `s : Multiset E` (with `E` a normed group) and a
    function `f : E → ℂ`, if every element satisfies `‖f(e)‖ ≤ B`, then
    the sum norm is bounded by `s.card · B`.

    This is a Multiset specialization of the standard finite-sum norm
    bound. -/
theorem norm_multiset_sum_le_card_mul_bound
    (s : Multiset ℂ) (f : ℂ → ℂ) (B : ℝ) (_hB : 0 ≤ B)
    (h_uniform : ∀ x ∈ s, ‖f x‖ ≤ B) :
    ‖(s.map f).sum‖ ≤ s.card * B := by
  -- Use Multiset.sum_le_card_mul_iSup-type bound + triangle inequality
  -- Lift via induction on s
  induction s using Multiset.induction with
  | empty =>
    simp
  | cons a t ih =>
    simp only [Multiset.map_cons, Multiset.sum_cons, Multiset.card_cons]
    have h_a : ‖f a‖ ≤ B := h_uniform a (Multiset.mem_cons_self a t)
    have h_t : ∀ x ∈ t, ‖f x‖ ≤ B := fun x hx =>
      h_uniform x (Multiset.mem_cons_of_mem hx)
    have h_t_bound : ‖(t.map f).sum‖ ≤ t.card * B := ih h_t
    calc ‖f a + (t.map f).sum‖
        ≤ ‖f a‖ + ‖(t.map f).sum‖ := norm_add_le _ _
      _ ≤ B + t.card * B := add_le_add h_a h_t_bound
      _ = (1 + t.card) * B := by ring
      _ = (↑(t.card + 1) : ℝ) * B := by push_cast; ring

/-! ## Phase 2 — Specialized to the L-W per-root analytical bound -/

/-- **Wave T4b session 8 — L-W orbit-sum analytical bound**.

    Given an orbit (Multiset of roots), an integer `n`, prime `p`,
    polynomial `gp : ℤ[X]`, and a per-root bound
    `‖n·exp(r) - p·aeval(r) gp‖ ≤ B`, the orbit-sum is bounded by
    `orbit.card · B`. -/
theorem orbit_sum_lindemann_bound
    (orbit : Multiset ℂ) (n : ℤ) (p : ℕ) (gp : Polynomial ℤ) (B : ℝ)
    (hB : 0 ≤ B)
    (h_per_root : ∀ r ∈ orbit,
        ‖(n : ℂ) • Complex.exp r - (p : ℂ) • Polynomial.aeval r gp‖ ≤ B) :
    ‖(orbit.map (fun r =>
        (n : ℂ) • Complex.exp r - (p : ℂ) • Polynomial.aeval r gp)).sum‖
      ≤ orbit.card * B :=
  norm_multiset_sum_le_card_mul_bound orbit
    (fun r => (n : ℂ) • Complex.exp r - (p : ℂ) • Polynomial.aeval r gp)
    B hB h_per_root

/-! ## Phase 3 — Decay to zero (PROVEN via Mathlib factorial-exp comparison) -/

/-- **Wave T4b session 8 — orbit-sum bound decay to zero (PROVEN)**.

    For any `orbit_card : ℕ` and `c : ℝ`, the orbit-sum bound
    `orbit_card * c^p / (p-1)!` tends to 0 as `p → ∞`.

    Proof: direct application of Mathlib's
    `FloorSemiring.tendsto_mul_pow_div_factorial_sub_atTop` with
    `a := orbit_card`, `c := c`, `d := 1`. Factorial dominates
    exponential, so `c^p / (p-1)! → 0` and multiplying by constant
    preserves the limit.

    This is the analytical-side ingredient: as p increases, the bound
    on the orbit sum's norm shrinks below any positive ε.  Combined
    with the symmetric-sum integer witness (cycle 65+), the orbit sum
    is forced to be 0 for large p, contradicting non-zero. -/
theorem orbit_sum_bound_tendsto_zero
    (orbit_card : ℕ) (c : ℝ) :
    Filter.Tendsto
      (fun p : ℕ => (orbit_card : ℝ) * c ^ p / ((p - 1).factorial : ℝ))
      Filter.atTop (nhds 0) :=
  FloorSemiring.tendsto_mul_pow_div_factorial_sub_atTop (orbit_card : ℝ) c 1

/-! ## Phase 4 — Headline + paper bundle + frontier marker -/

/-- **HEADLINE — Wave T4b session 8 multi-root sum norm bound + decay**.

    Single 3-conjunct showing the analytical content:

      1. **Generic Multiset sum-norm bound**: `‖∑_x∈s, f(x)‖ ≤ s.card · B`
         for `‖f(x)‖ ≤ B`.
      2. **L-W orbit-sum specialized**: applied to the per-root analytical
         bound.
      3. **Decay to zero (PROVEN)**: `orbit.card · c^p / (p-1)! → 0` as
         `p → ∞`. -/
theorem lindemann_premise_rat_proof_w_t4b_session_8_headline :
    (∀ (s : Multiset ℂ) (f : ℂ → ℂ) (B : ℝ), 0 ≤ B →
        (∀ x ∈ s, ‖f x‖ ≤ B) →
        ‖(s.map f).sum‖ ≤ s.card * B)
      ∧ (∀ (orbit : Multiset ℂ) (n : ℤ) (p : ℕ) (gp : Polynomial ℤ)
          (B : ℝ), 0 ≤ B →
          (∀ r ∈ orbit,
              ‖(n : ℂ) • Complex.exp r - (p : ℂ) • Polynomial.aeval r gp‖ ≤ B) →
          ‖(orbit.map (fun r =>
              (n : ℂ) • Complex.exp r - (p : ℂ) • Polynomial.aeval r gp)).sum‖
            ≤ orbit.card * B)
      ∧ (∀ (orbit_card : ℕ) (c : ℝ),
          Filter.Tendsto
            (fun p : ℕ => (orbit_card : ℝ) * c ^ p / ((p - 1).factorial : ℝ))
            Filter.atTop (nhds 0)) := by
  refine ⟨?_, ?_, ?_⟩
  · exact norm_multiset_sum_le_card_mul_bound
  · exact orbit_sum_lindemann_bound
  · exact orbit_sum_bound_tendsto_zero

/-- **W-T4b session 8 paper bundle** — citation marker. -/
theorem lindemann_premise_rat_proof_w_t4b_session_8_paper_bundle :
    ((∀ (s : Multiset ℂ) (f : ℂ → ℂ) (B : ℝ), 0 ≤ B →
          (∀ x ∈ s, ‖f x‖ ≤ B) →
          ‖(s.map f).sum‖ ≤ s.card * B)
        ∧ (∀ (orbit : Multiset ℂ) (n : ℤ) (p : ℕ) (gp : Polynomial ℤ)
            (B : ℝ), 0 ≤ B →
            (∀ r ∈ orbit,
                ‖(n : ℂ) • Complex.exp r - (p : ℂ) • Polynomial.aeval r gp‖ ≤ B) →
            ‖(orbit.map (fun r =>
                (n : ℂ) • Complex.exp r - (p : ℂ) • Polynomial.aeval r gp)).sum‖
              ≤ orbit.card * B)
        ∧ (∀ (orbit_card : ℕ) (c : ℝ),
            Filter.Tendsto
              (fun p : ℕ => (orbit_card : ℝ) * c ^ p / ((p - 1).factorial : ℝ))
              Filter.atTop (nhds 0)))
    ∧ (∀ (a b : ℂ), ‖a + b‖ ≤ ‖a‖ + ‖b‖) := by
  refine ⟨?_, ?_⟩
  · exact lindemann_premise_rat_proof_w_t4b_session_8_headline
  · exact norm_add_le

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultiRootSum
