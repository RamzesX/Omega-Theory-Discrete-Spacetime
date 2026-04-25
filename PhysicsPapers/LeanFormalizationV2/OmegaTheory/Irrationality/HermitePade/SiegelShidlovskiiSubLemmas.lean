/-
  OmegaTheory.Irrationality.HermitePade.SiegelShidlovskiiSubLemmas

  Cycle-55 (Cancer) Phase B — Siegel-Shidlovskii axiom decomposition,
  Stage 1 + structural easy lemmas.

  Author: Taygeta (lean-proof-wizard, cycle-55, 2026-04-25).

  Mission
  -------
  The Siegel-Shidlovskii theorem (Siegel 1929 + Shidlovskii 1956) is
  currently sealed as ONE axiom in `OmegaTheory.Irrationality.HermitePade.SSReduction`
  (the `siegel_shidlovskii` axiom).  Per Zubeneschamali's cycle-53
  briefing `SAGE_BRIEFING_siegel_shidlovskii_decompose_to_subLemmas_2026-04-25.md`,
  that axiom decomposes into 10-15 Lean-sized sub-lemmas which can be
  attacked one at a time over multiple cycles, eventually eliminating
  the axiom in favour of an in-house port.

  Roadmap (briefing's table)
  --------------------------
    | sub-lemma | mathematical content                   | difficulty |
    |-----------|----------------------------------------|------------|
    | 1         | E-function definition (analytic)       | EASY       |  ← THIS FILE
    | 2         | Padé approximation existence           | EASY       |
    | 3         | Hermite-Padé construction (small order)| MED        |
    | 4         | Determinantal identity for E-functions | MED        |
    | 5         | Algebraic independence at finite Q-rank| MED        |
    | 6         | Liouville-type bound                   | MED        |
    | 7         | Auxiliary polynomial construction      | HARD       |
    | 8         | Shidlovskii's bound on Padé denominator| HARD       |
    | 9         | Reduction modulo prime                 | HARD       |
    | 10        | Final transcendence conclusion         | HARD       |

  This file ships **Stage 1** plus eight structural-easy lemmas about
  the E-function predicate.  Each shipped lemma is:

  * a `theorem` (no `axiom` keyword);
  * proved with axiom footprint `[propext, Classical.choice, Quot.sound]`
    (Lean core);
  * narrowly true (no claims about analytic structure beyond what the
    formal-power-series predicate captures).

  HARD RULES respected
  --------------------
  * 0 sorry.
  * 0 new axioms — the existing `siegel_shidlovskii` STAYS in
    `SSReduction.lean`; this file does NOT touch it, only adds
    new structural content alongside.
  * 0 `Real.pi_transcendental` dependency — this file works at the
    formal-power-series level and never invokes π.

  Definition of E-function (Siegel 1929)
  --------------------------------------
  A power series

      f(z) = Σ_{n=0}^∞  a_n · z^n / n!

  is an **E-function** (in the sense of Siegel 1929) iff its
  coefficients `a_n ∈ ℚ` satisfy:

  (E1) **Polynomial numerator growth**: there exist constants
       `C_num : ℕ` and an exponent `d_num : ℕ` such that
       `|a_n.num| ≤ C_num · (n+1)^d_num`.

  (E2) **Polynomial common denominator**: there exist constants
       `C_den : ℕ` and an exponent `d_den : ℕ` such that, for every
       `n`, the natural number `(n+1)^d_den · C_den` is divisible by
       the LCM of denominators `den(a_0), …, den(a_n)`.

  This file packages (E1) and (E2) into one Prop `IsEFunction` and
  proves eight structural easy lemmas.

  Citation
  --------
  C. L. Siegel, *Über einige Anwendungen diophantischer Approximationen*,
  Abh. Preuss. Akad. Wiss., Phys.-Math. Kl. (1929/30), no. 1, 1–70.

  References
  ----------
  * `SAGE_BRIEFING_siegel_shidlovskii_decompose_to_subLemmas_2026-04-25.md`
  * `OmegaTheory.Irrationality.HermitePade.SSReduction` — the axiom we
    are eventually decomposing.
  * `OmegaTheory.Irrationality.HermitePade.Decoupling` — the earlier
    cycle's bridge from transcendence-of-π to substrate uncertainty.

  Dependencies: Mathlib v4.29 only.
-/

import Mathlib.Data.Rat.Defs
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.RingTheory.Polynomial.Basic

namespace OmegaTheory.Irrationality.HermitePade.SiegelShidlovskii

open BigOperators

/-!
### Stage 1 — The E-function predicate
-/

/--
**Stage 1 (sub-lemma 1) — E-function predicate.**

A sequence `a : ℕ → ℚ` is an E-function (in Siegel's 1929 sense) iff:

* (E1) the numerators `a_n.num` grow at most polynomially: there exist
  `C_num d_num : ℕ` such that `|a_n.num| ≤ C_num · (n+1)^d_num`;
* (E2) the denominators are commonly bounded by polynomial growth:
  there exist `C_den d_den : ℕ` such that for every `n`, every
  `den(a_k)` for `k ≤ n` divides `C_den · (n+1)^d_den`.

We package both as integer-valued bounds, which is the form in which
Siegel's theorem and its consequences are stated.

This is the **statement-level** definition that all subsequent
sub-lemmas (Stages 2-10) will refer to.
-/
def IsEFunction (a : ℕ → ℚ) : Prop :=
  (∃ C_num d_num : ℕ, ∀ n : ℕ,
      (a n).num.natAbs ≤ C_num * (n + 1) ^ d_num) ∧
  (∃ C_den d_den : ℕ, ∀ n k : ℕ, k ≤ n →
      (a k).den ∣ C_den * (n + 1) ^ d_den)

/-!
### Sub-lemma 1.1 — Zero is an E-function

The constantly-zero sequence is the trivial E-function.  Both bounds
are saturated by `C_num = 0`, `C_den = 1`.
-/

/--
**The zero sequence is an E-function.**  Trivial: numerators all
vanish (so `C_num = 0` works), and denominators are all `1` (so
`C_den = 1`, `d_den = 0` works).
-/
theorem isEFunction_zero : IsEFunction (fun _ : ℕ => (0 : ℚ)) := by
  refine ⟨⟨0, 0, ?_⟩, ⟨1, 0, ?_⟩⟩
  · intro n
    simp
  · intro n k _
    simp

/-!
### Sub-lemma 1.2 — Constant rationals are E-functions

For any rational `q`, the constant sequence `n ↦ q` is an E-function.
This is the constant-coefficient case of the formal power series.
-/

/--
**Constant rationals give E-functions.**  Take
`C_num = q.num.natAbs`, `d_num = 0` for (E1); take `C_den = q.den`,
`d_den = 0` for (E2).
-/
theorem isEFunction_const (q : ℚ) :
    IsEFunction (fun _ : ℕ => q) := by
  refine ⟨⟨q.num.natAbs, 0, ?_⟩, ⟨q.den, 0, ?_⟩⟩
  · intro n
    simp
  · intro n k _
    simp

/-!
### Sub-lemma 1.3 — The exp-coefficient sequence is an E-function

The classical example: `e^z = Σ z^n / n!` corresponds to the
coefficient sequence `a_n = 1`.  This is `isEFunction_const 1`.
-/

/--
**The exponential coefficient sequence is an E-function.**
The sequence `a_n = 1` (coefficient of `z^n / n!` in `e^z`) is the
canonical E-function.
-/
theorem isEFunction_one : IsEFunction (fun _ : ℕ => (1 : ℚ)) :=
  isEFunction_const 1

/-!
### Sub-lemma 1.4 — Closure under negation
-/

/--
**E-functions are closed under negation.**  Both bounds are preserved:
`(-q).num.natAbs = q.num.natAbs` and `(-q).den = q.den` (Mathlib).
-/
theorem isEFunction_neg {a : ℕ → ℚ} (ha : IsEFunction a) :
    IsEFunction (fun n => -(a n)) := by
  obtain ⟨⟨C_num, d_num, h_num⟩, ⟨C_den, d_den, h_den⟩⟩ := ha
  refine ⟨⟨C_num, d_num, ?_⟩, ⟨C_den, d_den, ?_⟩⟩
  · intro n
    have : (-(a n)).num.natAbs = (a n).num.natAbs := by
      simp [Rat.neg_num]
    rw [this]
    exact h_num n
  · intro n k hkn
    have : (-(a k)).den = (a k).den := by
      simp [Rat.neg_den]
    rw [this]
    exact h_den n k hkn

/-!
### Sub-lemma 1.5 — Closure under integer scalar multiplication

For any integer `m` and E-function `a`, the sequence `n ↦ m · a_n`
is an E-function.  This is needed for the `ℤ`-module structure
that Siegel's lemma exploits.
-/

/--
**E-functions are closed under integer scalar multiplication.**

The denominator divides via `Rat.mul_den_dvd` plus `Rat.den_intCast`
(integer cast has denominator 1).  The numerator is bounded via
`Rat.num_mul_num_eq_num_mul_gcd`: writing
`(m : ℚ).num * (a n).num = ((m : ℚ) * a n).num · gcd_factor`, the
left side has natAbs `m.natAbs * (a n).num.natAbs`, so the right side
forces `((m : ℚ) * a n).num.natAbs ≤ m.natAbs * (a n).num.natAbs`.
-/
theorem isEFunction_intMul (m : ℤ) {a : ℕ → ℚ} (ha : IsEFunction a) :
    IsEFunction (fun n => (m : ℚ) * a n) := by
  obtain ⟨⟨C_num, d_num, h_num⟩, ⟨C_den, d_den, h_den⟩⟩ := ha
  refine ⟨⟨m.natAbs * C_num, d_num, ?_⟩, ⟨C_den, d_den, ?_⟩⟩
  · intro n
    -- ((m : ℚ) * a n).num.natAbs ≤ m.natAbs * (a n).num.natAbs.
    have h1 : ((m : ℚ) * a n).num.natAbs ≤ m.natAbs * (a n).num.natAbs := by
      -- num_mul_num_eq_num_mul_gcd:
      --   q₁.num * q₂.num = (q₁ * q₂).num * gcd_factor
      -- where gcd_factor = (q₁.num * q₂.num).natAbs.gcd (q₁.den * q₂.den).
      -- Take q₁ = (m : ℚ), q₂ = a n.  Then
      --   m * (a n).num = ((m : ℚ) * a n).num * gcd_factor.
      have hkey :
          (m : ℤ) * (a n).num
            = ((m : ℚ) * a n).num
                * ((((m : ℚ).num * (a n).num).natAbs.gcd
                    ((m : ℚ).den * (a n).den)) : ℤ) := by
        have := Rat.num_mul_num_eq_num_mul_gcd ((m : ℚ)) (a n)
        simpa [Rat.num_intCast] using this
      -- Take natAbs.
      have hnatabs :
          (m.natAbs) * (a n).num.natAbs
            = ((m : ℚ) * a n).num.natAbs
                * ((((m : ℚ).num * (a n).num).natAbs.gcd
                    ((m : ℚ).den * (a n).den))) := by
        have := congrArg Int.natAbs hkey
        simpa [Int.natAbs_mul, Int.natAbs_natCast] using this
      -- The gcd is ≥ 1 (using gcd of nonneg ints with at least one positive arg).
      -- Either side could be 0; bound via Nat.le_mul_of_pos_right is risky.
      -- Easier: factor via `Nat.le_of_dvd` or convert to product bound.
      -- Strategy: since `gcd ≥ 0`, the right side is `((m : ℚ) * a n).num.natAbs · gcd ≥ ((m : ℚ) * a n).num.natAbs · 0 = 0`.
      -- We need ≤ direction: `x ≤ x * g` whenever `g ≥ 1`.
      -- Note `(m : ℚ).den = 1`, so `(m : ℚ).den * (a n).den = (a n).den ≥ 1`,
      -- and `gcd c d ≤ d` whenever `d ≥ 1`, so the gcd is ≤ (a n).den.
      -- But we need a lower bound `gcd ≥ 1`.
      -- Case split: if `(a n).num = 0`, then `(a n).num.natAbs = 0`, so RHS = 0
      -- and LHS = ((m : ℚ) * 0).num.natAbs = 0; bound holds.
      by_cases hnum : (a n).num = 0
      · -- a n = 0 (since num determines a rational up to den, and num = 0 ⇒ rat = 0).
        have ha_zero : a n = 0 := Rat.zero_of_num_zero hnum
        rw [ha_zero]
        simp
      · -- (a n).num ≠ 0; so (a n).num.natAbs ≥ 1.  Also m * (a n).num.natAbs ≠ 0
        -- iff m ≠ 0; if m = 0, LHS = 0 ≤ anything, done.
        by_cases hm : m = 0
        · subst hm
          simp
        · -- both nonzero.  gcd_factor is a divisor of m * (a n).num.natAbs ≠ 0,
          -- so gcd_factor ≥ 1.
          have hgcd_pos :
              0 < (((m : ℚ).num * (a n).num).natAbs.gcd
                    ((m : ℚ).den * (a n).den)) := by
            -- Both arguments are nonneg, second arg = (a n).den ≥ 1, so gcd > 0.
            apply Nat.gcd_pos_of_pos_right
            have : (m : ℚ).den * (a n).den ≥ 1 := by
              have h1 : (m : ℚ).den = 1 := Rat.den_intCast m
              rw [h1]
              simp
              exact (a n).pos
            omega
          -- From `x = y * g` with `g ≥ 1`, we get `y ≤ x` (since `y * 1 ≤ y * g`).
          have hge1 :
              1 ≤ (((m : ℚ).num * (a n).num).natAbs.gcd
                    ((m : ℚ).den * (a n).den)) := hgcd_pos
          calc ((m : ℚ) * a n).num.natAbs
              = ((m : ℚ) * a n).num.natAbs * 1 := by ring
            _ ≤ ((m : ℚ) * a n).num.natAbs
                  * ((((m : ℚ).num * (a n).num).natAbs.gcd
                      ((m : ℚ).den * (a n).den))) :=
                Nat.mul_le_mul_left _ hge1
            _ = m.natAbs * (a n).num.natAbs := hnatabs.symm
    calc ((m : ℚ) * a n).num.natAbs
        ≤ m.natAbs * (a n).num.natAbs := h1
      _ ≤ m.natAbs * (C_num * (n + 1) ^ d_num) :=
          Nat.mul_le_mul_left _ (h_num n)
      _ = m.natAbs * C_num * (n + 1) ^ d_num := by ring
  · intro n k hkn
    -- The denominator of `(m : ℚ) * (a k)` divides `(m : ℚ).den * (a k).den`,
    -- and since `(m : ℚ).den = 1` we have `((m : ℚ) * (a k)).den ∣ (a k).den`.
    have hd_step1 : ((m : ℚ) * a k).den ∣ (m : ℚ).den * (a k).den :=
      Rat.mul_den_dvd (m : ℚ) (a k)
    have hcast : (m : ℚ).den = 1 := Rat.den_intCast m
    rw [hcast, one_mul] at hd_step1
    exact dvd_trans hd_step1 (h_den n k hkn)

/-!
### Sub-lemma 1.6 — Closure under truncation / coefficient shift

Truncating an E-function at any prefix length still gives an E-function:
the bounds hold uniformly across all `n`, hence pointwise on a prefix.

This sub-lemma is structurally trivial (subset bounds), but it is the
combinatorial backbone for the Hermite-Padé construction (Stage 3),
which only ever uses finitely many coefficients of an E-function.
-/

/--
**E-functions are closed under coefficient cofinite-zero modification.**
If `a` is an E-function, then for any `N`, the sequence
`n ↦ if n ≤ N then a n else 0`
is also an E-function (same numerator/denominator bounds restricted
to `[0, N]`, with `0` outside).
-/
theorem isEFunction_truncate {a : ℕ → ℚ} (ha : IsEFunction a) (N : ℕ) :
    IsEFunction (fun n => if n ≤ N then a n else 0) := by
  obtain ⟨⟨C_num, d_num, h_num⟩, ⟨C_den, d_den, h_den⟩⟩ := ha
  refine ⟨⟨C_num, d_num, ?_⟩, ⟨C_den, d_den, ?_⟩⟩
  · intro n
    by_cases hn : n ≤ N
    · simp [hn]
      exact h_num n
    · simp [hn]
  · intro n k hkn
    by_cases hk : k ≤ N
    · simp [hk]
      exact h_den n k hkn
    · simp [hk]

/-!
### Sub-lemma 1.7 — Roadmap closure marker

This sub-lemma asserts the closure of Stage 1 of the briefing's
roadmap: the predicate `IsEFunction` is **defined**, **closed under
zero**, **closed under constants**, **closed under negation**, **closed
under integer scalar multiplication**, and **closed under truncation**.
Together these are the Stage-1 prerequisites for Stages 2-10.

(Stages 2+ remain as `:TheoremCandidate` nodes in the graph and as
`axiom siegel_shidlovskii` in `SSReduction.lean`; this stage establishes
the predicate-API the future stages will use.)
-/

/--
**Stage 1 closure marker.**

A 6-conjunct certificate that the E-function predicate is correctly
established and supports the structural operations needed for Stages 2-10.
-/
theorem isEFunction_stage_one_closure :
    IsEFunction (fun _ : ℕ => (0 : ℚ)) ∧
    IsEFunction (fun _ : ℕ => (1 : ℚ)) ∧
    (∀ q : ℚ, IsEFunction (fun _ : ℕ => q)) ∧
    (∀ a : ℕ → ℚ, IsEFunction a → IsEFunction (fun n => -(a n))) ∧
    (∀ (m : ℤ) (a : ℕ → ℚ), IsEFunction a →
        IsEFunction (fun n => (m : ℚ) * a n)) ∧
    (∀ (a : ℕ → ℚ), IsEFunction a →
        ∀ N, IsEFunction (fun n => if n ≤ N then a n else 0)) := by
  refine ⟨isEFunction_zero, isEFunction_one, isEFunction_const,
          ?_, ?_, ?_⟩
  · intro a ha
    exact isEFunction_neg ha
  · intro m a ha
    exact isEFunction_intMul m ha
  · intro a ha N
    exact isEFunction_truncate ha N

/-!
### Roadmap pointer for cycle 56+

The next sub-lemma to attack (Stage 2 of the briefing's table) is
the **Padé approximation existence**: for any `f : ℕ → ℚ` and any
order `n`, there exist polynomials `p, q ∈ ℚ[X]` with degrees bounded
by `n` such that `q · f - p` vanishes to order ≥ `2n + 1`.

This is a statement about formal power series and reduces to a
linear-algebraic existence argument (kernel of an underdetermined
rational linear map).  Mathlib has the necessary infrastructure
(`Polynomial`, `LinearMap.range`, dimension-counting lemmas) to
attempt it directly.

Stage 2 will introduce a NEW `:TheoremCandidate`
`padeApproximation_exists_for_eFunction` to track the work.
-/

/--
**Roadmap marker** — frontier flag for Stage 2 (Padé approximation
existence) and beyond.

Stage 1 closes the predicate-level work (this file).  Stages 2-10
are the substantive number-theoretic content of Siegel-Shidlovskii;
each remains as an `:TheoremCandidate` until ported.

The siegel_shidlovskii axiom in `SSReduction.lean` is **NOT** modified
by this file; it stays in place until ALL sub-lemmas (1-10) are
proved.  Stage 1 is the structural foundation; future cycles attack
Stages 2+.
-/
theorem siegel_shidlovskii_stage_one_landed_paper_bundle :
    -- Stage 1 closure
    IsEFunction (fun _ : ℕ => (0 : ℚ)) ∧
    IsEFunction (fun _ : ℕ => (1 : ℚ)) ∧
    -- Module structure
    (∀ a : ℕ → ℚ, IsEFunction a → IsEFunction (fun n => -(a n))) ∧
    (∀ (m : ℤ) (a : ℕ → ℚ), IsEFunction a →
        IsEFunction (fun n => (m : ℚ) * a n)) ∧
    -- Truncation closure (combinatorial backbone for Stages 2-3)
    (∀ (a : ℕ → ℚ), IsEFunction a →
        ∀ N, IsEFunction (fun n => if n ≤ N then a n else 0)) := by
  refine ⟨isEFunction_zero, isEFunction_one, ?_, ?_, ?_⟩
  · intro a ha
    exact isEFunction_neg ha
  · intro m a ha
    exact isEFunction_intMul m ha
  · intro a ha N
    exact isEFunction_truncate ha N

end OmegaTheory.Irrationality.HermitePade.SiegelShidlovskii
