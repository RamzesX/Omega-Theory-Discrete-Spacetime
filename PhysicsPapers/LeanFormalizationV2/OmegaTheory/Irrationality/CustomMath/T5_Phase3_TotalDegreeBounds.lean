/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeBounds

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 127.
  totalDegree bounds via support / sums.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's totalDegree bounds:

  1. **`T5_le_totalDegree`** : if `s ∈ p.support`, then
     `s.sum (·) ≤ p.totalDegree`.
  2. **`T5_totalDegree_finsetSum_le`** : if all `f i` have totalDegree
     ≤ d, so does `∑ i ∈ s, f i`.
  3. **`T5_totalDegree_finset_sum`** : `(∑ f).totalDegree ≤ sup totalDegree`.
  4. **`T5_exists_degree_lt`** : if `f.totalDegree < n * card σ`, then
     for any `d ∈ f.support`, some `i` has `d i < n`.

  Found via `mcp__omega-orchestrator__omega_hammer_premise` on
  totalDegree-support relation goals.

  Used in T-5 polynomial-index calculus where bounded total degree of
  the auxiliary polynomial gives bounds on individual variable degrees
  — crucial for Roth's gap principle.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Degrees

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeBounds

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## totalDegree from support members -/

/-- **Wave T5 session 127 — degree of support member ≤ totalDegree**.

    `(s.sum (fun _ e => e)) ≤ p.totalDegree` for `s ∈ p.support`. -/
theorem T5_le_totalDegree
    {p : MvPolynomial σ R} {s : σ →₀ ℕ} (h : s ∈ p.support) :
    (s.sum fun _ e => e) ≤ totalDegree p :=
  MvPolynomial.le_totalDegree h

/-! ## totalDegree of finite sums -/

/-- **Wave T5 session 127 — totalDegree of bounded finsetSum**. -/
theorem T5_totalDegree_finsetSum_le
    {ι : Type*} {s : Finset ι} {f : ι → MvPolynomial σ R} {d : ℕ}
    (hf : ∀ i ∈ s, (f i).totalDegree ≤ d) :
    (s.sum f).totalDegree ≤ d :=
  MvPolynomial.totalDegree_finsetSum_le hf

/-- **Wave T5 session 127 — totalDegree of finset_sum is bounded by sup**. -/
theorem T5_totalDegree_finset_sum
    {ι : Type*} (s : Finset ι) (f : ι → MvPolynomial σ R) :
    (s.sum f).totalDegree ≤ Finset.sup s fun i => (f i).totalDegree :=
  MvPolynomial.totalDegree_finset_sum s f

/-! ## Existential — some variable degree is small -/

/-- **Wave T5 session 127 — when totalDegree small, some var-degree is too**.

    If `f.totalDegree < n * card σ`, then for any `d ∈ f.support`,
    some `i` has `d i < n`. -/
theorem T5_exists_degree_lt
    [Fintype σ] (f : MvPolynomial σ R) (n : ℕ)
    (h : f.totalDegree < n * Fintype.card σ)
    {d : σ →₀ ℕ} (hd : d ∈ f.support) :
    ∃ i, d i < n :=
  MvPolynomial.exists_degree_lt f n h hd

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 127 — totalDegree bounds via support**.

    Four foundational facts:
    1. `s ∈ p.support → s.sum ≤ p.totalDegree`.
    2. `(∀ i ∈ s, (f i).td ≤ d) → (∑ f).td ≤ d`.
    3. `(s.sum f).td ≤ sup of td over s`.
    4. `f.td < n * card σ → ∀ d ∈ f.support, ∃ i, d i < n`.

    Sub-lemma 16/N in T-5 Phase 3.  Lean-core only.

    Found via `mcp__omega-orchestrator__omega_hammer_premise`.

    Used in Roth's polynomial-index calculus where bounded total
    degree of the auxiliary polynomial constrains individual variable
    degrees — key for the gap principle. -/
theorem session_127_total_degree_bounds_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) support member bound
    (∀ {p : MvPolynomial σ R} {s : σ →₀ ℕ},
        s ∈ p.support → (s.sum fun _ e => e) ≤ totalDegree p)
    -- (2) finsetSum bounded
    ∧ (∀ {ι : Type*} {s : Finset ι} {f : ι → MvPolynomial σ R} {d : ℕ},
        (∀ i ∈ s, (f i).totalDegree ≤ d) →
        (s.sum f).totalDegree ≤ d)
    -- (3) finset_sum sup bound
    ∧ (∀ {ι : Type*} (s : Finset ι) (f : ι → MvPolynomial σ R),
        (s.sum f).totalDegree ≤ Finset.sup s fun i => (f i).totalDegree) := by
  refine ⟨?_, ?_, ?_⟩
  · intros p s h; exact T5_le_totalDegree h
  · intros ι s f d hf; exact T5_totalDegree_finsetSum_le hf
  · exact T5_totalDegree_finset_sum

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_TotalDegreeBounds
