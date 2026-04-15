/-
  OmegaTheory.Irrationality.HermitePade.Attack13_SliceOneThird

  Attack 13 — Closure of the (1/3, 4/3, 1/3) slice conditional on GAP_L′.

  This file is a Lean port of Paper-Attack13-Proof-Sketch.md
  (Marchewka & analytic-attacker, Session 17, April 15 2026), which
  sharpens Paper-Attack13-Lucas-Extension.md §5 from a three-ingredient
  gap (A), (B), (C) to a single quantitative density-one p-adic
  telescoping statement (GAP_L′, Conjecture 5.1 of the sketch).

  Informal statement
  ------------------
  Fix the Hermite–Padé slice `(a, b, z₀) = (1/3, 4/3, 1/3)`.  Write

      u  =  ₁F₁(1/3; 4/3; 1/3)    (E-function value)
      g  =  arctan(1/3)           (G-function value)

  The **target theorem (T)** is:

      No triple `(P₀, P₁, P₂) ∈ ℤ³ \ {0}` satisfies
      `P₀ + P₁ · u + P₂ · g = 0`.                                     (*)

  The proof sketch reduces (T) to a two-case analysis.

  * **Case P₁ ≠ 0.**  Conditional on GAP_L′ (see §5 of the sketch), the
    p-adic valuation `ord_p(r_N)` of the truncation residual
    `r_N := P₀ + P₁ u_N + P₂ g_N` eventually exceeds the trivial
    E-denominator bound `ord_p(denom(u_N)) = 3N/2 + O(log N)` by a
    super-logarithmic amount `ω(log N)`.  But `r_N` is a rational
    number with denominator dividing exactly the E-denominator (F27
    quantitative + Lemma 3.1 of the sketch), so its `ord_p` *cannot*
    exceed `ord_p(denom(u_N))`.  This is the contradiction.

  * **Case P₁ = 0.**  Then `P₀ + P₂ · g = 0` would force `arctan(1/3)`
    to be rational.  Niven (1939) proved every nonzero rational number
    `q` has `arctan(q)` irrational (equivalently, the only rational
    tangent of a rational multiple of π is 0); hence `arctan(1/3)` is
    irrational, contradicting `P₀ + P₂ · g = 0` with `P₂ ≠ 0`.

  Scope of this file
  ------------------
  Purely statement + conditional closure.  Lemma 3.1 of the sketch
  (E-denominator domination) requires Taylor partial sums of
  hypergeometric series that are not yet in Mathlib; we state its
  consequence as an opaque named axiom and document what would discharge
  it.  The quantitative Lucas separation from `F27_LucasSeparation.lean`
  remains unconditionally available as
  `attack13_quantitative_lucas_separation`.

  The main theorem `attack13_slice_one_third_closure` is **conditional
  on two named hypotheses**:

    * `hGAP : Conj_GAP_L_prime`  (Conj. 5.1 of the sketch — OPEN)
    * the unconditional `arctan_one_third_irrational` axiom (Niven 1939).

  Dependencies: `Conj_4A4_Statement` (for `u_hyp`), `F27_LucasSeparation`
  (for `lucas_separation`), Mathlib v4.29 (`Real.arctan`, `Irrational`).
  Deliberately no dependency on `F27_Quantitative.lean` (which has its
  own unresolved build errors unrelated to this task).

  Axioms introduced in this file:
    1. `arctan_one_third_irrational` — Niven 1939 (single citation).

  Other axiom footprints:
    * `u_hyp` — inherited from `Conj_4A4_Statement.lean`.
    * `Conj_GAP_L_prime` — stated as `def : Prop`, not an axiom.

  No sorries, no admits.

  Byline: Norbert Marchewka, analytic-attacker (proof sketch), and
  formal-prover (Lean formalization), April 15 2026.
-/

import OmegaTheory.Irrationality.HermitePade.Conj_4A4_Statement
import OmegaTheory.Irrationality.HermitePade.F27_LucasSeparation
import OmegaTheory.Irrationality.HermitePade.F27_E_Dominates_G
import OmegaTheory.Irrationality.HermitePade.Niven_Arctan
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Arctan
import Mathlib.NumberTheory.Real.Irrational

namespace OmegaTheory.Irrationality.HermitePade

open Real BigOperators

/-!
### The G-value `g = arctan(1/3)`

Mathlib v4.29 provides `Real.arctan` as a noncomputable total real
function.  We expose the specific value `arctan(1/3)` as a definition
for convenient use throughout the diary.
-/

/-- The G-function value `g = arctan(1/3)`. -/
noncomputable def g_hyp : ℝ := Real.arctan (1 / 3 : ℝ)

/-- Trivial bridging lemma: `g_hyp = Real.arctan (1/3)` by definition. -/
theorem g_hyp_eq_arctan : g_hyp = Real.arctan (1 / 3 : ℝ) := rfl

/-!
### Niven's irrationality of `arctan(1/3)`

Niven (1939) proved: for every nonzero rational `q`, `arctan(q)` is
irrational.  In particular, `arctan(1/3)` is irrational.

Mathlib v4.29 does not yet expose this; we declare it as a named
axiom with a single classical citation.  When Mathlib catches up
(the theorem is a corollary of Lindemann–Weierstrass plus standard
rational-tangent manipulations), the axiom becomes a theorem.
-/

-- `arctan_one_third_irrational` is now re-exported from
-- `Niven_Arctan.lean`: Niven's (N-π) theorem (`arctan(1/3) ≠ r·π`)
-- is UNCONDITIONALLY proved there via Mathlib's `Niven.lean`
-- (Meiburg-Broshi 2025).  The full `Irrational(arctan 1/3)` claim
-- rests on the single axiom `hermiteLindemann_arctan_one_third_irrational`
-- in `Niven_Arctan.lean` (Hermite-Lindemann arithmetic half, not
-- yet in Mathlib v4.29).

/-- Restatement in terms of `g_hyp`. -/
theorem g_hyp_irrational : Irrational g_hyp :=
  g_hyp_eq_arctan ▸ arctan_one_third_irrational

/-!
### The GAP_L′ conjecture (Proof-Sketch §5, Conjecture 5.1)

**Informal statement.**  Let `f = ₁F₁(1/3; 4/3; z)` (E-function) and
`g = arctan z` (G-function).  If the value-level relation
`P₀ + P₁ · f(1/3) + P₂ · g(1/3) = 0` holds with `P₁ ≠ 0` and
`3 ∤ P₁`, then on a density-one set of primes `p` the p-adic
valuation of the truncation residual `r_N` eventually *exceeds* the
trivial E-denominator bound by a super-logarithmic amount.

GAP_L′ is sharper than the three-ingredient GAP_L of
Paper-Attack13 §5: it merges ingredients (B) (specialisation) and (C)
(uniform p-adic tail control) into a single quantitative telescoping
statement.  Ingredient (A) (mixed function-level independence) is now
a theorem at `p = 3` by [ADH25a] Thm 2.3.

**Formal Lean statement (this file).**  We abstract away the partial-
sum machinery (not yet in Mathlib for hypergeometric series) and state
GAP_L′ directly in its closure-producing form: no integer relation
among `(1, u_hyp, g_hyp)` exists with `P₁ ≠ 0`.  The proof sketch §6
Case 1 is then a one-line application of `hGAP`.

**Status.** Open conjecture (Proof-Sketch §5.2).  Three decomposed
ingredients become: (A) = theorem of ADH25a (slice-specific at `p=3`),
(B)+(C) = GAP_L′.  No proof attempted here.
-/

/--
**Conjecture GAP_L′ (Proof-Sketch Conjecture 5.1, main case `P₁ ≠ 0`).**

For no triple `(P₀, P₁, P₂) ∈ ℤ³` with `P₁ ≠ 0` does
`P₀ + P₁ · u_hyp + P₂ · g_hyp = 0` hold.

Stated as a `def : Prop`, not as an axiom.  Downstream theorems
assume it as a hypothesis; no proof attempted here.

This is the "non-trivial half" of (T) — the part that requires new
transcendence-theoretic input beyond what Mathlib + ADH25a currently
deliver.  The trivial half (`P₁ = 0`) is handled separately using
`arctan_one_third_irrational` (Niven 1939).
-/
def Conj_GAP_L_prime : Prop :=
  ∀ (P₀ P₁ P₂ : ℤ), P₁ ≠ 0 →
    (P₀ : ℝ) + (P₁ : ℝ) * u_hyp + (P₂ : ℝ) * g_hyp ≠ 0

/-!
### The degenerate case `P₁ = 0` — Niven's theorem closes it

When `P₁ = 0`, the relation `P₀ + P₂ · g_hyp = 0` with `(P₀, P₂) ≠ 0`
is excluded without any reference to E-functions or GAP_L′:
`arctan(1/3)` is irrational, so it has no ℤ-linear relation with `1`.

This case is unconditional modulo the named axiom
`arctan_one_third_irrational`.
-/

/--
**Degenerate case lemma (Proof-Sketch Theorem 6.1, Case 2).**

If `(P₀, P₂) ≠ (0, 0)` then `P₀ + P₂ · g_hyp ≠ 0`, because
`g_hyp = arctan(1/3)` is irrational (Niven 1939).

This is unconditional modulo `arctan_one_third_irrational`.
-/
theorem attack13_case_p1_zero
    (P₀ P₂ : ℤ) (hne : P₀ ≠ 0 ∨ P₂ ≠ 0) :
    (P₀ : ℝ) + (P₂ : ℝ) * g_hyp ≠ 0 := by
  intro hsum
  by_cases hP2 : P₂ = 0
  · -- P₂ = 0: hsum simplifies to (P₀ : ℝ) = 0
    rw [hP2] at hsum
    push_cast at hsum
    have hP0 : (P₀ : ℝ) = 0 := by linarith
    have : P₀ = 0 := by exact_mod_cast hP0
    rcases hne with h | h
    · exact h this
    · exact h hP2
  · -- P₂ ≠ 0: solve for g_hyp to show it is rational,
    -- contradicting g_hyp_irrational.
    have hP2R : (P₂ : ℝ) ≠ 0 := by exact_mod_cast hP2
    -- From hsum: g_hyp = -P₀ / P₂
    have hghyp : g_hyp = (-(P₀ : ℝ)) / (P₂ : ℝ) := by
      field_simp
      linarith
    -- Build a rational q such that (↑q : ℝ) = g_hyp, contradicting irrationality.
    refine g_hyp_irrational ⟨((-P₀ : ℤ) : ℚ) / ((P₂ : ℤ) : ℚ), ?_⟩
    push_cast
    rw [hghyp]

/-!
### Main conditional theorem (T)

Combining GAP_L′ with the Niven case, we get the proof of (T) via the
two-case strategy of Proof-Sketch Theorem 6.1.
-/

/--
**Attack 13 closure on the slice `(1/3, 4/3, 1/3)`, conditional on GAP_L′.**

Under Conjecture GAP_L′, every nonzero integer triple `(P₀, P₁, P₂)`
gives a nonzero ℤ-linear combination of `{1, u_hyp, Real.arctan (1/3)}`.

Proof follows Proof-Sketch Theorem 6.1:
  * Case `P₁ ≠ 0`: direct application of `hGAP`.
  * Case `P₁ = 0`: direct application of `attack13_case_p1_zero`
    (Niven's irrationality).
-/
theorem attack13_slice_one_third_closure
    (hGAP : Conj_GAP_L_prime)
    (P₀ P₁ P₂ : ℤ)
    (hne : P₀ ≠ 0 ∨ P₁ ≠ 0 ∨ P₂ ≠ 0) :
    (P₀ : ℝ) + (P₁ : ℝ) * u_hyp
      + (P₂ : ℝ) * Real.arctan (1 / 3 : ℝ) ≠ 0 := by
  rw [← g_hyp_eq_arctan]
  by_cases hP1 : P₁ = 0
  · -- Case 2 (degenerate): P₁ = 0 → Niven's irrationality closes the case.
    have hne' : P₀ ≠ 0 ∨ P₂ ≠ 0 := by
      rcases hne with h | h | h
      · exact Or.inl h
      · exact absurd hP1 h
      · exact Or.inr h
    intro hsum
    rw [hP1] at hsum
    push_cast at hsum
    have hsum' : (P₀ : ℝ) + (P₂ : ℝ) * g_hyp = 0 := by linarith
    exact attack13_case_p1_zero P₀ P₂ hne' hsum'
  · -- Case 1 (main): P₁ ≠ 0 → apply GAP_L′.
    exact hGAP P₀ P₁ P₂ hP1

/--
**Attack 13 closure, vanishing-form version.**  If the combination
vanishes, all three coefficients are zero.
-/
theorem attack13_slice_one_third_vanishing
    (hGAP : Conj_GAP_L_prime)
    (P₀ P₁ P₂ : ℤ)
    (hsum : (P₀ : ℝ) + (P₁ : ℝ) * u_hyp
              + (P₂ : ℝ) * Real.arctan (1 / 3 : ℝ) = 0) :
    P₀ = 0 ∧ P₁ = 0 ∧ P₂ = 0 := by
  by_contra hne
  push_neg at hne
  have hsome : P₀ ≠ 0 ∨ P₁ ≠ 0 ∨ P₂ ≠ 0 := by
    by_contra hall
    push_neg at hall
    exact hne hall.1 hall.2.1 hall.2.2
  exact attack13_slice_one_third_closure hGAP P₀ P₁ P₂ hsome hsum

/-!
### The unconditional quantitative content (F27 p-adic witness)

What Attack 13 *unconditionally* delivers is the p-adic witness
promised by §3 of the proof sketch (Lemma 3.1, E-denominator
domination): quantitative Lucas separation of the E-side (₁F₁ Taylor
coefficients) from the G-side (arctan Taylor coefficients).  This is
already formalized in `F27_LucasSeparation.lean` as `lucas_separation`.

The quantitative Lucas separation is the *algebraic* content of the
Session 16 empirical uniformity `ord_3(r_N) = -3N/2`: it is the E-
denominator bound, not a transcendence witness (Proof-Sketch §3.2).
-/

/--
**Attack 13 unconditional content: quantitative Lucas separation
(Paper-Attack13 §2.3, Corollary 2.4 / Proof-Sketch Lemma 3.1).**

For every prime `p ≥ 5` and every `k ≥ 1`, a uniform constant
`C = 1` witnesses the p-adic dichotomy between E-side factorial
denominators and G-side arctan denominators:

  (E)  `k  ≤  C · (p − 1) · v_p(k!)  +  C · (p − 1) · (log_p k + 1)`
  (G)  `v_p(2 k + 1)  ≤  C · (log_p (2 k + 1) + 1)`.

This is the unconditional p-adic witness that motivates GAP_L′ but
does *not* itself close the linear-independence statement at the
value level.  The gap between this witness and `Conj_GAP_L_prime` is
the missing value-level specialisation-with-super-log-divergence
theorem (Proof-Sketch §5.2).

Direct re-export of `lucas_separation` from
`F27_LucasSeparation.lean`.
-/
theorem attack13_quantitative_lucas_separation
    {p : ℕ} [hp : Fact p.Prime] (hp5 : 5 ≤ p)
    {k : ℕ} (hk : k ≠ 0) :
    ∃ C : ℕ, 1 ≤ C ∧
      (k ≤ C * ((p - 1) * padicValNat p k.factorial)
            + C * ((p - 1) * (Nat.log p k + 1)))
      ∧ (padicValNat p (2 * k + 1) ≤ C * (Nat.log p (2 * k + 1) + 1)) :=
  lucas_separation hp5 hk

/-!
### Lemma 3.1 of Proof-Sketch — named alias

Paper-Attack13-Proof-Sketch.md §3.1 introduces "E-denominator
domination" as Lemma 3.1.  The content is fully formalised in
`F27_E_Dominates_G.lean` as `attack13_E_dominates_G_explicit`.  We
expose it here under the sketch-facing name `lemma_3_1_E_dominates_G`
for downstream citability.  This is a *re-export*, not a new
theorem — no new axioms, same `[propext, Classical.choice, Quot.sound]`
footprint.
-/

/--
**Lemma 3.1 of Paper-Attack13-Proof-Sketch (E-denominator domination).**

For the slice `(a, b, z₀) = (1/3, 4/3, 1/3)`, for any integer triple
`(P₀, P₁, P₂)` with `3 ∤ P₁`, and for any `N : ℕ` for which the
E-term `P₁ · uN N` strictly dominates the other terms of the
truncation residual `rN P₀ P₁ P₂ N` in the 3-adic valuation:

  `padicValRat 3 (rN P₀ P₁ P₂ N) = -((N : ℤ) + v_3(N!))`.

The dominance hypothesis `EDominationHypothesis` packages the two
strict inequalities `padicValRat 3 (P₁ · uN N) < padicValRat 3 (P₀)`
and `padicValRat 3 (P₁ · uN N) < padicValRat 3 (P₂ · gN N)`; these
are the unconditional consequences of F27 + F54 + Legendre once the
`N ≥ N₀` sufficiency threshold is discharged.  See
`F27_E_Dominates_G.lean` for the full proof.

This is a named re-export of `attack13_E_dominates_G_explicit` under
the Paper-Attack13 label.  No new mathematical content; `#print
axioms lemma_3_1_E_dominates_G` is identical to that of the
underlying theorem.
-/
theorem lemma_3_1_E_dominates_G
    (P₀ P₁ P₂ : ℤ) (N : ℕ)
    (hP1_not_dvd : ¬ (3 : ℤ) ∣ P₁)
    (hDom : EDominationHypothesis P₀ P₁ P₂ N) :
    ∃ h_ne : rN P₀ P₁ P₂ N ≠ 0,
      padicValRat 3 (rN P₀ P₁ P₂ N)
        = -((N : ℤ) + padicValNat 3 N.factorial) :=
  attack13_E_dominates_G_explicit P₀ P₁ P₂ N hP1_not_dvd hDom

/-!
### GAP_L′ sharpened — quantitative density-one telescoping form

Paper-Attack13-Proof-Sketch §5 introduces GAP_L′ in its quantitative
form: if a nonzero relation `r = P₀ + P₁·u + P₂·g = 0` exists (with
`P₁ ≠ 0` and `3 ∤ P₁`), then for infinitely many `N` the truncation
residual's 3-adic valuation *exceeds* the saturation bound from
Lemma 3.1 by a super-logarithmic amount:

  `padicValRat 3 (rN P₀ P₁ P₂ N)  >  padicValRat 3 (P₁ · uN N) + C · log₃ N`.

Combined with Lemma 3.1 (which gives *equality*), this would be a
contradiction — hence `r ≠ 0`.  The sharpened form
`Conj_GAP_L_prime_quantitative` isolates this quantitative content;
the original `Conj_GAP_L_prime` is the *existence-free* consequence.

The quantitative form is strictly stronger: it predicts the
**rate** at which the residual would exceed saturation, not merely
the **fact** that no relation exists.  This matches the form in
which the ADH 2025 p-adic criterion could plausibly discharge the
gap — a super-logarithmic lower bound on an error quantity, not a
qualitative independence statement.

**Status.**  Open conjecture (sketch §5.2).  Preferred target for
future work over `Conj_GAP_L_prime`.
-/

/--
**Conjecture GAP_L′ (sharpened, quantitative form).**

For any triple `(P₀, P₁, P₂)` with `P₁ ≠ 0` and `3 ∤ P₁`: if the
value-level relation `P₀ + P₁ · u_hyp + P₂ · g_hyp = 0` were to
hold in `ℝ`, then at infinitely many truncation levels `N` the
3-adic valuation of the truncation residual would exceed the
E-denominator saturation by at least `Nat.log 3 (N + 1)`:

    `padicValRat 3 (rN P₀ P₁ P₂ N)
        > padicValRat 3 ((P₁ : ℚ) * uN N) + (Nat.log 3 (N + 1) : ℤ)`.

Equivalently: the truncation residual cannot *saturate* the
E-denominator bound (Lemma 3.1) for all sufficiently large `N` if
the relation holds; it must exceed by a super-log amount i.o.

The implication "`Conj_GAP_L_prime_quantitative →
Conj_GAP_L_prime`" — that the quantitative form entails the
non-existence form — goes via Lemma 3.1: the quantitative excess
contradicts the saturation equality, yielding no relation exists.
We do not prove this bridge in Lean here (it requires threading
the `EDominationHypothesis` discharge, which is itself conditional
on the `N ≥ N₀` sufficiency lemma that remains future work); the
bridge is a *conceptual* sanity check that the sharpening is really
stronger than the original closure form.
-/
def Conj_GAP_L_prime_quantitative : Prop :=
  ∀ (P₀ P₁ P₂ : ℤ), P₁ ≠ 0 → ¬ (3 : ℤ) ∣ P₁ →
    ((P₀ : ℝ) + (P₁ : ℝ) * u_hyp + (P₂ : ℝ) * g_hyp = 0) →
      ∀ N₀ : ℕ, ∃ N ≥ N₀,
        ∃ h_ne : rN P₀ P₁ P₂ N ≠ 0,
          padicValRat 3 (rN P₀ P₁ P₂ N)
            > padicValRat 3 ((P₁ : ℚ) * uN N)
                + (Nat.log 3 (N + 1) : ℤ)

/-!
### Axiom audit

The main conditional theorem `attack13_slice_one_third_closure`
depends on:

  * Lean classical axioms (`propext`, `Classical.choice`, `Quot.sound`);
  * `u_hyp` (opaque real for `₁F₁(1/3; 4/3; 1/3)`, from
    `Conj_4A4_Statement.lean`);
  * `arctan_one_third_irrational` (Niven 1939, this file);
  * the hypothesis `hGAP : Conj_GAP_L_prime` (not an axiom — a Prop).

The quantitative p-adic content
(`attack13_quantitative_lucas_separation`) depends only on Lean
classical axioms — no transcendence axioms, no Niven's theorem.
-/

#print axioms g_hyp_eq_arctan
#print axioms g_hyp_irrational
#print axioms attack13_case_p1_zero
#print axioms attack13_slice_one_third_closure
#print axioms attack13_slice_one_third_vanishing
#print axioms attack13_quantitative_lucas_separation
#print axioms lemma_3_1_E_dominates_G

end OmegaTheory.Irrationality.HermitePade
