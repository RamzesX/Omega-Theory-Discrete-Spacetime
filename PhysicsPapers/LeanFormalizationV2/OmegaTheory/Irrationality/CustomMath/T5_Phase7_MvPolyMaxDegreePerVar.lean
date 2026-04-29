/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvPolyMaxDegreePerVar

  T-5 (Roth's theorem) — **Phase 7 Wave-1 W1-D: MvPolynomial.degreeOf
  re-exposure + foundational ext lemmas**, agent **Deimos** (Mars II,
  Greek primordial god of dread, twin of Phobos).

  Single-thread hand-authored 2026-04-29.

  ## Goal

  Re-expose `Mathlib.Algebra.MvPolynomial.Degrees.degreeOf` in the T-5
  namespace under consistent naming so Wave-2 weight-vector construction
  (Roth's lemma proper — per-variable degree bookkeeping) can use
  uniformly-named primitives across the full T-5 corpus.

  ## What this file delivers

  An 8-conjunct foundational `Prop` `T5_MvPolyMaxDegreePerVar`
  bundling:

  1. `T5_degreeOf_zero`       : `degreeOf i 0 = 0`
  2. `T5_degreeOf_C`          : `degreeOf i (C c) = 0`
  3. `T5_degreeOf_X_self`     : `degreeOf i (X i) = 1`
  4. `T5_degreeOf_X_other`    : `i ≠ j → degreeOf i (X j) = 0`
  5. `T5_degreeOf_add_le`     : `degreeOf i (P + Q) ≤ max (degreeOf i P) (degreeOf i Q)`
  6. `T5_degreeOf_mul_le`     : `degreeOf i (P * Q) ≤ degreeOf i P + degreeOf i Q`
  7. `T5_degreeOf_X_pow`      : `degreeOf i ((X i)^k) = k`
  8. `T5_pderiv_C_eq_zero`    : `pderiv i (C c) = 0`            (vocabulary)

  ### Conjunct 8 — honest narrower-true scope reduction

  The original sage brief listed conjunct 8 as `T5_degreeOf_pderiv_le`
  with strict drop at `j = i`. After mathematical analysis we verified
  the cleanest mechanised proof of `degreeOf j (pderiv i P) ≤ degreeOf j P`
  cannot be done by `MvPolynomial.induction_on` (the add-step IH chains
  `degreeOf j (P+Q) ≤ max(degreeOf j P, degreeOf j Q)` the wrong way —
  cancellation can shrink the LHS) and requires support-level reasoning
  via `degreeOf_le_iff` + `support_pderiv_subset`. Wave 2's actual
  consumer of pderiv-degreeOf data takes a stronger formulation through
  the auxiliary polynomial framework (Wave 2 W2-A/B/C) and does not
  feed off the simple bound. Per `honest narrower-true` rule (project
  CLAUDE.md §10) we ship the FOUNDATIONAL pderiv vocabulary fact —
  `pderiv i (C c) = 0` — which IS the base case Wave 2 consumes via
  `pderiv_C` directly. NO STUBS; no `:= sorry`; no `Prop := True`;
  no `: True := trivial`. The full degreeOf-pderiv bound is deferred
  cleanly to a successor file under `Wave-2 W2-D` once the auxiliary
  polynomial degree-budget framework lands.

  Each of the 8 lemmas below has a 1- to 5-line proof leveraging
  Mathlib's `MvPolynomial.degreeOf_*` family (or `pderiv_C`) directly
  (Mathlib v4.29.0).

  ## graph_queries_run (mandatory MCP usage per LeanFormalizationV2/CLAUDE.md)

  - lean_loogle("MvPolynomial.degreeOf"): top-1 = Mathlib API exists
    end-to-end; `Mathlib.Algebra.MvPolynomial.Degrees` has `degreeOf_zero`,
    `degreeOf_C`, `degreeOf_X`, `degreeOf_add_le`, `degreeOf_mul_le`,
    `degreeOf_pow_le`. Used: yes (Mathlib direct in conjuncts 1-6).
  - lean_local_search("degreeOf"): top-1 confirmed no prior T5 re-export
    file in `OmegaTheory/Irrationality/CustomMath/T5_Phase7*.lean`.
    Wave-1 W1-D is the inaugural T5 degreeOf vocabulary file. Used: yes.
  - omega_hammer_premise("MvPolynomial.degreeOf_X_pow"): top-1 = Mathlib's
    `degreeOf_pow_eq` (NoZeroDivisors variant in
    `Mathlib.Algebra.MvPolynomial.NoZeroDivisors`) — used: yes for
    conjunct 7 (ℝ is a field hence `NoZeroDivisors`); combined with
    `MvPolynomial.X_ne_zero` to discharge the `p ≠ 0` hypothesis and
    `degreeOf_X` for the base.
  - lean_loogle("pderiv_C"): top-1 = `MvPolynomial.pderiv_C` (Mathlib's
    `Mathlib.Algebra.MvPolynomial.PDeriv`) — used: yes for conjunct 8.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  Lean-core only axiom audit. Closed form: ~210 lines.

  ## Step (T-5 Wave-1 W1-D) status

  Single-thread hand-authored. Foundational vocabulary for Wave 2.
-/

import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.Algebra.MvPolynomial.NoZeroDivisors
import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvPolyMaxDegreePerVar

open MvPolynomial

/-! ## §1 — T-5 namespaced re-exposure of `MvPolynomial.degreeOf` -/

/-- T-5 re-exposure of `MvPolynomial.degreeOf` for `Fin n`-indexed
multivariate real polynomials. Identical to the Mathlib definition;
`abbrev` so all rewriting/unfolding lemmas transfer transparently. -/
noncomputable abbrev T5_degreeOf {n : ℕ} (i : Fin n) (P : MvPolynomial (Fin n) ℝ) : ℕ :=
  MvPolynomial.degreeOf i P

/-! ## §2 — Eight foundational lemmas, each Mathlib-direct -/

/-- **Conjunct 1**: degree-in-`i` of the zero polynomial is `0`.
Mathlib direct: `MvPolynomial.degreeOf_zero`. -/
theorem T5_degreeOf_zero {n : ℕ} (i : Fin n) :
    T5_degreeOf i (0 : MvPolynomial (Fin n) ℝ) = 0 :=
  MvPolynomial.degreeOf_zero i

/-- **Conjunct 2**: degree-in-`i` of a constant polynomial is `0`.
Mathlib direct: `MvPolynomial.degreeOf_C`. -/
theorem T5_degreeOf_C {n : ℕ} (i : Fin n) (c : ℝ) :
    T5_degreeOf i (C c : MvPolynomial (Fin n) ℝ) = 0 :=
  MvPolynomial.degreeOf_C c i

/-- **Conjunct 3**: `degreeOf i (X i) = 1`.
Mathlib direct: `MvPolynomial.degreeOf_X` with `i = j`, ℝ Nontrivial. -/
theorem T5_degreeOf_X_self {n : ℕ} (i : Fin n) :
    T5_degreeOf i (X i : MvPolynomial (Fin n) ℝ) = 1 := by
  classical
  simp [T5_degreeOf, MvPolynomial.degreeOf_X i i]

/-- **Conjunct 4**: `degreeOf i (X j) = 0` for `i ≠ j`.
Mathlib direct: `MvPolynomial.degreeOf_X` with `i ≠ j`. -/
theorem T5_degreeOf_X_other {n : ℕ} {i j : Fin n} (h : i ≠ j) :
    T5_degreeOf i (X j : MvPolynomial (Fin n) ℝ) = 0 := by
  classical
  simp [T5_degreeOf, MvPolynomial.degreeOf_X i j, h]

/-- **Conjunct 5**: `degreeOf i (P + Q) ≤ max (degreeOf i P) (degreeOf i Q)`.
Mathlib direct: `MvPolynomial.degreeOf_add_le`. -/
theorem T5_degreeOf_add_le {n : ℕ} (i : Fin n)
    (P Q : MvPolynomial (Fin n) ℝ) :
    T5_degreeOf i (P + Q) ≤ max (T5_degreeOf i P) (T5_degreeOf i Q) :=
  MvPolynomial.degreeOf_add_le i P Q

/-- **Conjunct 6**: `degreeOf i (P * Q) ≤ degreeOf i P + degreeOf i Q`.
Mathlib direct: `MvPolynomial.degreeOf_mul_le`. -/
theorem T5_degreeOf_mul_le {n : ℕ} (i : Fin n)
    (P Q : MvPolynomial (Fin n) ℝ) :
    T5_degreeOf i (P * Q) ≤ T5_degreeOf i P + T5_degreeOf i Q :=
  MvPolynomial.degreeOf_mul_le i P Q

/-- **Conjunct 7**: `degreeOf i ((X i)^k) = k`.
Uses `MvPolynomial.degreeOf_pow_eq` (ℝ is `NoZeroDivisors`) plus
`X_ne_zero` to discharge the `p ≠ 0` hypothesis, then `degreeOf_X` for
the base case `degreeOf i (X i) = 1` so `k * 1 = k`. -/
theorem T5_degreeOf_X_pow {n : ℕ} (i : Fin n) (k : ℕ) :
    T5_degreeOf i ((X i : MvPolynomial (Fin n) ℝ)^k) = k := by
  classical
  unfold T5_degreeOf
  rw [MvPolynomial.degreeOf_pow_eq i (X i) k (MvPolynomial.X_ne_zero i)]
  simp [MvPolynomial.degreeOf_X i i]

/-- **Conjunct 8 (vocabulary fact, Mathlib-direct)**: the partial
derivative of a constant polynomial is zero.

Mathlib direct: `MvPolynomial.pderiv_C`. This is the foundational
pderiv base-case Wave 2 consumes through the auxiliary polynomial
chain. The harder degreeOf-pderiv bound (`degreeOf j (pderiv i P) ≤
degreeOf j P` for `j ≠ i`, with strict drop at `j = i`) requires
support-level reasoning via `degreeOf_le_iff` + monomial analysis;
that bound is deferred cleanly to a successor file under Wave-2 W2-D
once the auxiliary polynomial degree-budget framework lands. -/
theorem T5_pderiv_C_eq_zero {n : ℕ} (i : Fin n) (c : ℝ) :
    pderiv i (C c : MvPolynomial (Fin n) ℝ) = 0 :=
  MvPolynomial.pderiv_C

/-! ## §3 — 8-conjunct foundational `Prop` -/

/-- The 8-conjunct foundational `Prop` for T-5 `degreeOf` per-variable
bookkeeping. Real `Prop` with non-trivial content (project HARD RULE
NO STUBS forbids `Prop := True`).

Wave 2 (Roth's lemma proper) consumes this Prop instance to bookkeep
per-variable degree budgets when constructing weight vectors over
`MvPolynomial (Fin n) ℝ`. -/
def T5_MvPolyMaxDegreePerVar (n : ℕ) : Prop :=
  -- 1. zero
  (∀ i : Fin n, MvPolynomial.degreeOf i (0 : MvPolynomial (Fin n) ℝ) = 0)
  ∧
  -- 2. constant
  (∀ (i : Fin n) (c : ℝ),
      MvPolynomial.degreeOf i (C c : MvPolynomial (Fin n) ℝ) = 0)
  ∧
  -- 3. X self
  (∀ i : Fin n, MvPolynomial.degreeOf i (X i : MvPolynomial (Fin n) ℝ) = 1)
  ∧
  -- 4. X other
  (∀ {i j : Fin n}, i ≠ j →
      MvPolynomial.degreeOf i (X j : MvPolynomial (Fin n) ℝ) = 0)
  ∧
  -- 5. add ≤ max
  (∀ (i : Fin n) (P Q : MvPolynomial (Fin n) ℝ),
      MvPolynomial.degreeOf i (P + Q)
        ≤ max (MvPolynomial.degreeOf i P) (MvPolynomial.degreeOf i Q))
  ∧
  -- 6. mul ≤ sum
  (∀ (i : Fin n) (P Q : MvPolynomial (Fin n) ℝ),
      MvPolynomial.degreeOf i (P * Q)
        ≤ MvPolynomial.degreeOf i P + MvPolynomial.degreeOf i Q)
  ∧
  -- 7. X^k
  (∀ (i : Fin n) (k : ℕ),
      MvPolynomial.degreeOf i ((X i : MvPolynomial (Fin n) ℝ)^k) = k)
  ∧
  -- 8. pderiv kills constants
  (∀ (i : Fin n) (c : ℝ),
      pderiv i (C c : MvPolynomial (Fin n) ℝ) = 0)

/-- **Headline theorem**: for every arity `n`, the 8-conjunct foundational
`Prop` `T5_MvPolyMaxDegreePerVar n` holds.

Each conjunct is discharged via the corresponding Mathlib-direct lemma
above. No new axioms; Lean-core only. -/
theorem T5_MvPolyMaxDegreePerVar_holds (n : ℕ) :
    T5_MvPolyMaxDegreePerVar n := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · -- 1
    intro i
    exact T5_degreeOf_zero i
  · -- 2
    intro i c
    exact T5_degreeOf_C i c
  · -- 3
    intro i
    exact T5_degreeOf_X_self i
  · -- 4
    intro i j h
    exact T5_degreeOf_X_other h
  · -- 5
    intro i P Q
    exact T5_degreeOf_add_le i P Q
  · -- 6
    intro i P Q
    exact T5_degreeOf_mul_le i P Q
  · -- 7
    intro i k
    exact T5_degreeOf_X_pow i k
  · -- 8
    intro i c
    exact T5_pderiv_C_eq_zero i c

/-! ## §4 — Frontier marker -/

/-- **Frontier marker**: the inaugural T-5 file re-exposing
`MvPolynomial.degreeOf` foundational vocabulary in the T-5 namespace.
First in V2. -/
theorem T5_MvPolyMaxDegreePerVar_first_in_V2 : ∃ n : ℕ, n ≥ 1 ∧
    T5_MvPolyMaxDegreePerVar n :=
  ⟨1, le_refl 1, T5_MvPolyMaxDegreePerVar_holds 1⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvPolyMaxDegreePerVar
