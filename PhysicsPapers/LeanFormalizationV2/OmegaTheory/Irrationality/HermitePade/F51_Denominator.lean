/-
  OmegaTheory.Irrationality.HermitePade.F51_Denominator

  F51 — Common-denominator bound for a Padé-type rational family
  (Module 04 / 10, π K₂-opacity diary, Attack 19).

  Informal statement
  ------------------
  The Type II `[n; n, n]` simultaneous Padé coefficients of
  `(1, f, g) = (1, ₂F₁(a, b; c; z), ₂F₁(a', b'; c'; z))` expand as
  ℚ-linear combinations of Pochhammer / factorial ratios of the form

      x_k  =  (a)_k · (b)_k  /  ((c)_k · k!)       (0 ≤ k ≤ N).

  Each individual `x_k` has denominator dividing `(c)_k · k!`.  Hence
  the **common denominator** of the entire family `{x_0, …, x_N}`
  divides

      D_N  :=  lcm { (c)_k · k!  :  k = 0 … N }.

  In the π-diary this is the input used to control the height of the
  Hermite–Padé remainder numerators; the denominator blow-up is
  precisely `D_N`.

  Scope of this file
  ------------------
  Per task spec, we scope F51 to its **clean algebraic core** and avoid
  the Pochhammer-specific gymnastics.  Specifically we prove, in
  Mathlib's `Finset.lcm` / `Rat.den` language, the **universal**
  common-denominator bound:

  • `common_denom_divides_finset_lcm` — if a finite family of rationals
    `x : Fin (N + 1) → ℚ` has per-term denominator bounds
    `∀ k, (x k).den ∣ D k`, then `Finset.lcm (range (N+1)) D` is a
    common denominator for the whole family.

  • `common_denom_clears_to_int` — packaging the same bound as "the
    product `L · x_k` is a (cast of an) integer", the form directly
    used by Siegel-style height calculations.

  • `F51_Pade_denominator_bound` — the Pochhammer specialisation:
    taking `D k = (c)_k · k!` (no need to unfold Pochhammer — the
    hypothesis `(x k).den ∣ (c)_k · k!` is given).  This matches the
    F51 statement line-for-line once the Padé expansion is plugged in.

  Dependencies: Mathlib v4.29 (`Finset.lcm`, `Rat.den_dvd`,
  `Finset.dvd_lcm`, `Rat.num_div_den`).  No sorries, no axioms beyond
  Mathlib.
-/

import Mathlib.Algebra.GCDMonoid.Finset
import Mathlib.Data.Rat.Lemmas
import Mathlib.Data.Rat.Cast.Defs
import Mathlib.Data.Nat.GCD.BigOperators
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FieldSimp

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/--
**F51 core — common-denominator bound.**

Let `x : Fin (N + 1) → ℚ` be a finite family of rationals, and suppose
each `x k` has denominator dividing a given `D k : ℕ`.  Then the
`Finset.lcm` over `k ∈ range (N+1)` of the bounds `D k` is a common
denominator for the family:

    `∀ k, (x k).den ∣ Finset.lcm (range (N + 1)) D`.

Proof.  For each `k`, `(x k).den ∣ D k` by hypothesis and
`D k ∣ Finset.lcm (range (N+1)) D` by `Finset.dvd_lcm`.  Transitivity
of divisibility closes the goal.

Indexing subtlety.  `Fin (N+1)` is in bijection with `range (N+1)`; we
use the `ℕ`-indexed form `Finset.lcm (range (N+1)) (D ∘ (Fin.mk · h))`
by composing with the embedding `k : Fin (N+1) ↦ (k : ℕ)`.
-/
theorem common_denom_divides_finset_lcm
    {N : ℕ} (x : Fin (N + 1) → ℚ) (D : Fin (N + 1) → ℕ)
    (hbound : ∀ k, (x k).den ∣ D k) :
    ∀ k, (x k).den ∣ (Finset.univ : Finset (Fin (N + 1))).lcm D := by
  intro k
  have h1 : (x k).den ∣ D k := hbound k
  have h2 : D k ∣ (Finset.univ : Finset (Fin (N + 1))).lcm D :=
    Finset.dvd_lcm (Finset.mem_univ k)
  exact h1.trans h2

/--
**F51 — integer-clearance form.**

The same bound, phrased multiplicatively: if every `x k` has
denominator dividing `D k`, then `L := Finset.lcm univ D` clears every
`x k` to an integer, i.e., there is an integer `n_k` with
`(L : ℚ) * x k = (n_k : ℚ)`.

This is the form the Hermite–Padé height calculation consumes: apply
`L`, which is *independent of `k`*, to every coefficient of the Padé
remainder simultaneously, and the whole thing becomes an integer
linear combination.

Proof sketch.  From `(x k).den ∣ L` (the previous theorem) and
`x k = (x k).num / (x k).den`, multiplying by `L` leaves a numerator
divisible by `(x k).den`, hence an integer after cancellation.
-/
theorem common_denom_clears_to_int
    {N : ℕ} (x : Fin (N + 1) → ℚ) (D : Fin (N + 1) → ℕ)
    (hbound : ∀ k, (x k).den ∣ D k) :
    let L : ℕ := (Finset.univ : Finset (Fin (N + 1))).lcm D
    ∀ k, ∃ n : ℤ, (L : ℚ) * x k = (n : ℚ) := by
  intro L k
  -- The core fact: denominator of `x k` divides `L`.
  have hdvd : (x k).den ∣ L :=
    common_denom_divides_finset_lcm x D hbound k
  -- From divisibility `(x k).den ∣ L`, get a natural `m` with `L = m * den`.
  obtain ⟨m, hm⟩ := hdvd
  -- Witness: `n = m * (x k).num`.
  refine ⟨(m : ℤ) * (x k).num, ?_⟩
  -- Strategy: show the equation `(L : ℚ) * x k = m * (x k).num` in ℚ.
  -- From `hm : L = (x k).den * m` we get `(L : ℚ) = (x k).den * m`.
  -- Then `(x k).den * m * x k = m * ((x k).den * x k) = m * (x k).num`,
  -- using `((x k).den : ℚ) * x k = (x k).num` (a standard Rat identity).
  have hden_eq_num : ((x k).den : ℚ) * x k = ((x k).num : ℚ) := by
    have hnd : ((x k).num : ℚ) / ((x k).den : ℚ) = x k := Rat.num_div_den (x k)
    have hden_ne : ((x k).den : ℚ) ≠ 0 := by exact_mod_cast (x k).den_ne_zero
    have : ((x k).den : ℚ) * (((x k).num : ℚ) / ((x k).den : ℚ)) = ((x k).num : ℚ) := by
      field_simp
    rw [← hnd]; exact this
  have hLcast : (L : ℚ) = ((x k).den : ℚ) * (m : ℚ) := by
    have := congrArg (fun n : ℕ => (n : ℚ)) hm
    simpa [Nat.cast_mul] using this
  calc (L : ℚ) * x k
      = (((x k).den : ℚ) * (m : ℚ)) * x k := by rw [hLcast]
    _ = (m : ℚ) * (((x k).den : ℚ) * x k) := by ring
    _ = (m : ℚ) * ((x k).num : ℚ) := by rw [hden_eq_num]
    _ = (((m : ℤ) * (x k).num : ℤ) : ℚ) := by push_cast; ring

/--
**F51 — Padé-coefficient specialisation.**

Concrete form matching the π-diary Module 10 statement: if the Padé
coefficient family `x : Fin (N+1) → ℚ` satisfies the per-term
denominator control

    `(x k).den ∣ (c)_k · k!`        for every `k ≤ N`,

supplied here via an explicit natural-valued bound
`boundPoch k := (cPoch k) * (k.factorial)`, then the integer

    `L_N  :=  Finset.lcm univ boundPoch`

is a common denominator for the whole family.  This is the "F51
common-denominator bound" used by Attack 19.

The Pochhammer / factorial identities are *not* unfolded here; the
hypothesis `(x k).den ∣ (cPoch k) * k!` is stated abstractly, because
in the rest of the diary this input is provided by direct computation
at fixed `a, b, c` rather than by a general Pochhammer lemma.
-/
theorem F51_Pade_denominator_bound
    {N : ℕ} (x : Fin (N + 1) → ℚ) (cPoch : Fin (N + 1) → ℕ)
    (hbound : ∀ k, (x k).den ∣ (cPoch k) * ((k : ℕ).factorial)) :
    ∀ k, (x k).den ∣
      (Finset.univ : Finset (Fin (N + 1))).lcm
        (fun k => (cPoch k) * ((k : ℕ).factorial)) :=
  common_denom_divides_finset_lcm x
    (fun k => (cPoch k) * ((k : ℕ).factorial)) hbound

/-!
### Axiom audit

All theorems depend only on Lean's core axioms plus Mathlib's standard
classical axioms (`propext`, `Classical.choice`, `Quot.sound`) — no
invocation of `Real.pi_transcendental` (this file is purely ℚ-denominator
arithmetic).
-/
-- #print axioms common_denom_divides_finset_lcm
-- #print axioms common_denom_clears_to_int
-- #print axioms F51_Pade_denominator_bound

end OmegaTheory.Irrationality.HermitePade
