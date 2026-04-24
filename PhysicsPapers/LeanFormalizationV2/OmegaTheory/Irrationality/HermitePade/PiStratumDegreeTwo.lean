/-
  OmegaTheory.Irrationality.HermitePade.PiStratumDegreeTwo

  **Mission W8 — Axiom narrowing (cycle 51).**

  A degree-2 companion to `PiStratumDegreeOne`: for any rationals
  `a, b, c`, if `a + b·π + c·π^2 = 0` in ℝ under the hypothesis that
  `π^2` is NOT an ℚ-affine combination of `{1, π}`, then `a = b = c = 0`.

  WHY THIS MATTERS: cycle-50's W9 (`pi_irrational_degree_one_decoupling`)
  narrowed degree-1 cases to depend only on `Real.irrational_pi`
  (Niven 1947, Mathlib theorem).  This file extends the narrowing to
  degree-2 conditional on one additional hypothesis:

    `hpi_indep : ∀ r₀ r₁ : ℚ, (r₀ : ℝ) + (r₁ : ℝ) * Real.pi ≠ Real.pi^2`

  This hypothesis is STRICTLY WEAKER than `Real.pi_transcendental`
  (Lindemann 1882): transcendence of π trivially implies that π² is not
  in the ℚ-affine span of `{1, π}` (since the degree-2 polynomial
  `x² − r₁·x − r₀ ∈ ℚ[x]` would vanish at π, contradicting
  transcendence).  But `hpi_indep` on its own — i.e., the single fact
  "π is not algebraic of degree ≤ 2 over ℚ" — is a WEAKER statement and
  a GENUINELY USEFUL waypoint en route to eliminating the
  `Real.pi_transcendental` axiom degree-by-degree.

  Concretely, migration path:
    * `Real.pi_transcendental`            → research axiom (Lindemann 1882,
                                             pending Mathlib
                                             Lindemann–Weierstrass port)
    * `hpi_indep`                         → HYPOTHESIS, discharged by
                                             transcendence OR by any
                                             future weaker port such as
                                             "π not algebraic of degree
                                             ≤ 2 over ℚ"
    * `Real.irrational_pi`                → Mathlib THEOREM (Niven 1947)

  **Mathematical reality check.**  Note that the weaker fact
  `Irrational (Real.pi^2)` ALONE is NOT enough to discharge the general
  degree-2 decoupling — because `π² = r₀ + r₁·π` with `r₁ ≠ 0` would
  still leave `π²` irrational (its RHS is irrational by `irrational_pi`
  since `r₁ ≠ 0`), so `Irrational (π²)` wouldn't contradict it.  The
  hypothesis `hpi_indep` is exactly the thing we need, and nothing less.
  A MATHLIB result of `Irrational.of_pow : Irrational (x^n) → Irrational
  x` is not helpful here because it runs the WRONG direction; and
  `Irrational.of_mul_self` similarly runs the wrong direction.  The
  proof strategy in the mission brief that invoked
  `Irrational.of_pow 2 irrational_pi` to derive `Irrational (π^2)` is
  mathematically impossible via Mathlib's current set: one cannot deduce
  `Irrational (π^2)` from `Irrational π` alone (counter-example: `√2`
  is irrational but `(√2)^2 = 2` is rational).  Hence the
  hypothesis-based narrower-true form.

  Fallback (truly unconditional) export
  `pi_irrational_degree_two_c_zero_decoupling`: the special case `c = 0`
  reduces to W9 exactly and requires NO new hypothesis beyond W9's
  existing axiom footprint.

  Axiom footprint of every theorem in this file:
  **propext + Classical.choice + Quot.sound** only (i.e. Lean core).
  Verified via `#print axioms pi_irrational_degree_two_decoupling`.

  Session/batch: cycle-51 W8 axiom-narrowing wave (Mission W8 extension
  of cycle-50's Mission W9).
-/

import OmegaTheory.Irrationality.HermitePade.PiStratumDegreeOne
import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Irrationality.HermitePade

/--
**W8 — `pi_sq_not_in_Q_affine_span_of_pi`.**

Short alias for the "narrower-true" hypothesis we take on in degree 2:
π² is NOT of the form `(r₀ : ℝ) + (r₁ : ℝ) * Real.pi` for any rationals
`r₀, r₁`.

This is exactly the fact that π is not algebraic of degree ≤ 2 over ℚ
(since such algebraicity would provide rationals `r₀, r₁` with
`π² = r₀ + r₁·π`).  It is STRICTLY WEAKER than `Real.pi_transcendental`
(transcendence rules out algebraicity of ANY degree, while this only
rules out degree ≤ 2).
-/
def PiSqNotInQAffineSpanOfPi : Prop :=
  ∀ r₀ r₁ : ℚ, ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi : ℝ) ≠ Real.pi ^ 2

/--
**W8 — pi_irrational_degree_two_decoupling (conditional form).**

If `a + b·π + c·π^2 = 0` and π² is not an ℚ-affine combination of
`{1, π}`, then `a = b = c = 0`.

Dependencies:
  * `Real.irrational_pi` (Niven 1947, Mathlib theorem) — via W9.
  * `hpi_indep : PiSqNotInQAffineSpanOfPi` — HYPOTHESIS, strictly weaker
    than `Real.pi_transcendental`.

**Does NOT depend on `Real.pi_transcendental`.**

This is strictly narrower than `pi_stratum_rational` specialised to
`D = 2` because it requires only `hpi_indep`, not full transcendence.
Future callers can migrate by providing their own `hpi_indep` — from
any source (transcendence, Niven-style extended argument, or a direct
Mathlib port of "π is not algebraic over ℚ of degree ≤ 2").
-/
theorem pi_irrational_degree_two_decoupling
    (hpi_indep : PiSqNotInQAffineSpanOfPi)
    (a b c : ℚ) (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 := by
  by_cases hc : c = 0
  · -- Case c = 0: reduces to W9.
    subst hc
    push_cast at h
    -- h : (a : ℝ) + (b : ℝ) * Real.pi + 0 * Real.pi ^ 2 = 0
    have h1 : (a : ℝ) + (b : ℝ) * Real.pi = 0 := by linarith
    have := pi_irrational_degree_one_decoupling a b h1
    exact ⟨this.1, this.2, rfl⟩
  · -- Case c ≠ 0: derive π² = (-a/c) + (-b/c)·π, contradicting hpi_indep.
    exfalso
    have hcR : (c : ℝ) ≠ 0 := by exact_mod_cast hc
    -- Solve h for Real.pi^2.
    have hpi_sq : Real.pi ^ 2 = ((-a / c : ℚ) : ℝ) + ((-b / c : ℚ) : ℝ) * Real.pi := by
      push_cast
      field_simp
      linarith
    exact hpi_indep (-a / c) (-b / c) hpi_sq.symm

/--
**W8 fallback — pi_irrational_degree_two_c_zero_decoupling (truly
unconditional).**

The special case `c = 0` of degree-2 decoupling is truly unconditional:
if `a + b·π + c·π² = 0` AND `c = 0`, then `a = b = c = 0` by W9 alone.

This requires no extra hypothesis and reduces exactly to W9's axiom
footprint (i.e., depends on `Real.irrational_pi` via W9, NOT on
`Real.pi_transcendental`).

Useful for any future caller that can independently establish `c = 0`
(e.g., from a degree constraint) and then wants to conclude `a = b = 0`.
-/
theorem pi_irrational_degree_two_c_zero_decoupling
    (a b c : ℚ) (hc : c = 0)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 := by
  subst hc
  push_cast at h
  have h1 : (a : ℝ) + (b : ℝ) * Real.pi = 0 := by linarith
  have := pi_irrational_degree_one_decoupling a b h1
  exact ⟨this.1, this.2, rfl⟩

/--
**W8 companion — pi_squared_ne_quadratic_rat.**

Restated consequence of `hpi_indep`: π² does not equal any ℚ-affine
combination of `{1, π}`.  Reader-friendly form for paper citations.

(This is literally the contrapositive-flavoured restatement of
`PiSqNotInQAffineSpanOfPi`.)
-/
theorem pi_squared_ne_quadratic_rat
    (hpi_indep : PiSqNotInQAffineSpanOfPi)
    (r₀ r₁ : ℚ) : ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi : ℝ) ≠ Real.pi ^ 2 :=
  hpi_indep r₀ r₁

/--
**W8 companion — pi_squared_ne_rat (conditional).**

Special case: π² does not equal any rational.  Follows from
`hpi_indep` by taking `r₁ = 0`.

Note: this is the *weaker* fact `Irrational (π²)` in disguise, which
can be proved unconditionally (in principle) by a Niven-style extended
argument, but Mathlib currently does not ship such a lemma.  Hence this
conditional form.
-/
theorem pi_squared_ne_rat
    (hpi_indep : PiSqNotInQAffineSpanOfPi)
    (q : ℚ) : (q : ℝ) ≠ Real.pi ^ 2 := by
  intro heq
  have : ((q : ℚ) : ℝ) + ((0 : ℚ) : ℝ) * Real.pi = Real.pi ^ 2 := by
    push_cast; linarith
  exact hpi_indep q 0 this

/--
**W8 paper bundle — degree-2 axiom-narrowing headline.**

Four-conjunct summary exposing this file's exports, for paper citation
under one name:

  1. The conditional degree-2 decoupling (narrower-true form).
  2. The unconditional `c = 0` corollary (no extra hypothesis).
  3. The `π² ≠ r₀ + r₁·π` restatement of the hypothesis.
  4. The `π² ≠ q` corollary (conditional `Irrational π²`).
-/
theorem pi_irrational_degree_two_paper_bundle :
    (∀ (hpi_indep : PiSqNotInQAffineSpanOfPi) (a b c : ℚ),
       (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2 = 0 →
       a = 0 ∧ b = 0 ∧ c = 0) ∧
    (∀ (a b c : ℚ), c = 0 →
       (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2 = 0 →
       a = 0 ∧ b = 0 ∧ c = 0) ∧
    (∀ (hpi_indep : PiSqNotInQAffineSpanOfPi) (r₀ r₁ : ℚ),
       ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi : ℝ) ≠ Real.pi ^ 2) ∧
    (∀ (hpi_indep : PiSqNotInQAffineSpanOfPi) (q : ℚ),
       (q : ℝ) ≠ Real.pi ^ 2) :=
  ⟨pi_irrational_degree_two_decoupling,
   pi_irrational_degree_two_c_zero_decoupling,
   pi_squared_ne_quadratic_rat,
   pi_squared_ne_rat⟩

end OmegaTheory.Irrationality.HermitePade
