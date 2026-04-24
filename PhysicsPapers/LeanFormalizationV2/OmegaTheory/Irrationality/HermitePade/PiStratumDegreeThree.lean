/-
  OmegaTheory.Irrationality.HermitePade.PiStratumDegreeThree

  **Mission W10 — Axiom narrowing (cycle 52).**

  A degree-3 companion to `PiStratumDegreeTwo`: for any rationals
  `a, b, c, d`, if `a + b·π + c·π² + d·π³ = 0` in ℝ under the hypothesis
  that `π³` is NOT in the ℚ-affine span of `{1, π, π²}`, then
  `a = b = c = d = 0`.

  WHY THIS MATTERS: this continues cycle 50's W9 (degree-1, unconditional
  on irrationality alone) and cycle 51's W8 (degree-2 conditional on
  `PiSqNotInQAffineSpanOfPi`) into degree 3, conditional on

    `hpi_indep₃ : ∀ r₀ r₁ r₂ : ℚ,
       (r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi^2 ≠ Real.pi^3`

  This hypothesis is STRICTLY WEAKER than `Real.pi_transcendental`
  (Lindemann 1882): transcendence of π rules out algebraicity of π of
  ANY degree over ℚ, while `hpi_indep₃` says only "π is not algebraic of
  degree ≤ 3 over ℚ" (since degree-≤-3 algebraicity would furnish
  rationals `r₀, r₁, r₂` with `π³ = r₀ + r₁·π + r₂·π²`).

  Migration path (per-degree narrowing):
    * `Real.pi_transcendental`    → research axiom (Lindemann 1882),
                                     currently in 1 project site.
    * `hpi_indep₃`                → HYPOTHESIS, discharged by
                                     transcendence OR by any future
                                     weaker port (e.g., "π not algebraic
                                     of degree ≤ 3 over ℚ").
    * `hpi_indep₂` (W8)           → HYPOTHESIS (deg ≤ 2).
    * `Real.irrational_pi`        → Mathlib THEOREM (Niven 1947).

  Bridge: `hpi_indep₃` implies W8's `PiSqNotInQAffineSpanOfPi`
  (specialise `r₂ = 0` — IF π² WERE a ℚ-affine combo of `{1, π}`, then
  π³ = π·π² would also be one, contradicting `hpi_indep₃` at `r₂ = 0`);
  this reduction, however, is not a direct instantiation — instead we
  supply `hpi_indep_two_of_three` as a companion lemma for callers that
  want to factor through W8's machinery when `d = 0`.

  Axiom footprint of every theorem in this file:
  **propext + Classical.choice + Quot.sound** only (i.e. Lean core).
  Verified via `#print axioms pi_irrational_degree_three_decoupling`.

  Session/batch: cycle-52 W10 axiom-narrowing wave (Mission W10
  extension of cycle-51's Mission W8 and cycle-50's Mission W9).
-/

import OmegaTheory.Irrationality.HermitePade.PiStratumDegreeTwo
import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Irrationality.HermitePade

/--
**W10 — `PiCubedNotInQAffineSpanOfOnePiPiSq`.**

Short alias for the "narrower-true" hypothesis we take on in degree 3:
π³ is NOT of the form `(r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi^2`
for any rationals `r₀, r₁, r₂`.

This is exactly the fact that π is not algebraic of degree ≤ 3 over ℚ
(since such algebraicity would provide rationals `r₀, r₁, r₂` with
`π³ = r₀ + r₁·π + r₂·π²`).  It is STRICTLY WEAKER than
`Real.pi_transcendental` (transcendence rules out algebraicity of ANY
degree, while this only rules out degree ≤ 3).
-/
def PiCubedNotInQAffineSpanOfOnePiPiSq : Prop :=
  ∀ r₀ r₁ r₂ : ℚ,
    ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2 : ℝ) ≠ Real.pi ^ 3

/--
**W10 bridge — `hpi_indep_two_of_three`.**

If `π³ ∉ ℚ-span{1, π, π²}` then `π² ∉ ℚ-span{1, π}`.

Proof: if π² = r₀ + r₁·π for some rationals, then multiplying by π,
π³ = r₀·π + r₁·π².  Substituting back π² = r₀ + r₁·π yields
π³ = r₀·π + r₁·(r₀ + r₁·π) = r₁·r₀ + (r₀ + r₁²)·π + 0·π², i.e., π³
is in the ℚ-affine span of {1, π, π²}, contradicting `hpi_indep₃`.

This lemma allows callers holding only the stronger `hpi_indep₃` to
invoke W8's degree-2 machinery without re-proving the degree-2
hypothesis.
-/
theorem hpi_indep_two_of_three
    (hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq) :
    PiSqNotInQAffineSpanOfPi := by
  intro r₀ r₁
  intro hsq  -- hsq : (r₀ : ℝ) + (r₁ : ℝ) * Real.pi = Real.pi ^ 2
  -- From hsq, derive π³ = r₀·r₁ + (r₀ + r₁²)·π + 0·π².
  -- π^3 = π·π^2 = π·(r₀ + r₁·π) = r₀·π + r₁·π² = r₀·π + r₁·(r₀ + r₁·π)
  --     = r₁·r₀ + (r₀ + r₁²)·π
  apply hpi_indep₃ (r₁ * r₀) (r₀ + r₁ ^ 2) 0
  push_cast
  have hpi2 : Real.pi ^ 2 = (r₀ : ℝ) + (r₁ : ℝ) * Real.pi := hsq.symm
  linear_combination -(Real.pi + (r₁ : ℝ)) * hpi2

/--
**W10 — pi_irrational_degree_three_decoupling (conditional form).**

If `a + b·π + c·π² + d·π³ = 0` and π³ is not in the ℚ-affine span of
`{1, π, π²}`, then `a = b = c = d = 0`.

Dependencies:
  * `Real.irrational_pi` (Niven 1947, Mathlib theorem) — via W9/W8.
  * `hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq` — HYPOTHESIS,
    strictly weaker than `Real.pi_transcendental`.

**Does NOT depend on `Real.pi_transcendental`.**

Proof strategy (direct lift from W8):
  * Case `d = 0`: reduces to W8 decoupling via
    `hpi_indep_two_of_three` applied to `hpi_indep₃`.
  * Case `d ≠ 0`: solve `h` for π³, obtaining
    `π³ = (-a/d) + (-b/d)·π + (-c/d)·π²`, contradicting `hpi_indep₃`
    at `(r₀, r₁, r₂) = (-a/d, -b/d, -c/d)`.
-/
theorem pi_irrational_degree_three_decoupling
    (a b c d : ℚ)
    (hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
          + (d : ℝ) * Real.pi ^ 3 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 := by
  by_cases hd : d = 0
  · -- Case d = 0: reduce to W8 decoupling.
    subst hd
    push_cast at h
    -- h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2 + 0 * Real.pi ^ 3 = 0
    have h1 : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2 = 0 := by linarith
    have hpi_indep₂ : PiSqNotInQAffineSpanOfPi := hpi_indep_two_of_three hpi_indep₃
    have := pi_irrational_degree_two_decoupling hpi_indep₂ a b c h1
    exact ⟨this.1, this.2.1, this.2.2, rfl⟩
  · -- Case d ≠ 0: derive π³ = (-a/d) + (-b/d)·π + (-c/d)·π², contradict hpi_indep₃.
    exfalso
    have hdR : (d : ℝ) ≠ 0 := by exact_mod_cast hd
    have hpi_cube :
        Real.pi ^ 3 = ((-a / d : ℚ) : ℝ) + ((-b / d : ℚ) : ℝ) * Real.pi
                        + ((-c / d : ℚ) : ℝ) * Real.pi ^ 2 := by
      push_cast
      field_simp
      linarith
    exact hpi_indep₃ (-a / d) (-b / d) (-c / d) hpi_cube.symm

/--
**W10 fallback — pi_irrational_degree_three_d_zero_decoupling.**

The special case `d = 0` of degree-3 decoupling: if `a + b·π + c·π² +
d·π³ = 0` AND `d = 0`, then `a = b = c = d = 0`, conditional on the W8
hypothesis `PiSqNotInQAffineSpanOfPi`.

This is one strict step narrower than the general W10 theorem — it
requires only the (weaker) W8 hypothesis, not the (stronger) W10 one.
Useful for any future caller that can independently establish `d = 0`.
-/
theorem pi_irrational_degree_three_d_zero_decoupling
    (hpi_indep₂ : PiSqNotInQAffineSpanOfPi)
    (a b c d : ℚ) (hd : d = 0)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
          + (d : ℝ) * Real.pi ^ 3 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 := by
  subst hd
  push_cast at h
  have h1 : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2 = 0 := by linarith
  have := pi_irrational_degree_two_decoupling hpi_indep₂ a b c h1
  exact ⟨this.1, this.2.1, this.2.2, rfl⟩

/--
**W10 companion — pi_cubed_ne_cubic_rat.**

Restated consequence of `hpi_indep₃`: π³ does not equal any ℚ-affine
combination of `{1, π, π²}`.  Reader-friendly form for paper citations.
-/
theorem pi_cubed_ne_cubic_rat
    (hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq)
    (r₀ r₁ r₂ : ℚ) :
    ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2 : ℝ)
      ≠ Real.pi ^ 3 :=
  hpi_indep₃ r₀ r₁ r₂

/--
**W10 paper bundle — degree-3 axiom-narrowing headline.**

Four-conjunct summary exposing this file's exports, for paper citation
under one name:

  1. The conditional degree-3 decoupling (narrower-true form).
  2. The bridge `hpi_indep₃ → hpi_indep₂` (reducing to W8 machinery).
  3. The unconditional-given-W8 `d = 0` corollary.
  4. The `π³ ≠ r₀ + r₁·π + r₂·π²` restatement of the hypothesis.
-/
theorem pi_irrational_degree_three_paper_bundle :
    (∀ (a b c d : ℚ) (hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq),
       (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
         + (d : ℝ) * Real.pi ^ 3 = 0 →
       a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0) ∧
    (∀ (hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq),
       PiSqNotInQAffineSpanOfPi) ∧
    (∀ (hpi_indep₂ : PiSqNotInQAffineSpanOfPi) (a b c d : ℚ), d = 0 →
       (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
         + (d : ℝ) * Real.pi ^ 3 = 0 →
       a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0) ∧
    (∀ (hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq) (r₀ r₁ r₂ : ℚ),
       ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2 : ℝ)
         ≠ Real.pi ^ 3) :=
  ⟨fun a b c d h₃ h => pi_irrational_degree_three_decoupling a b c d h₃ h,
   hpi_indep_two_of_three,
   pi_irrational_degree_three_d_zero_decoupling,
   pi_cubed_ne_cubic_rat⟩

end OmegaTheory.Irrationality.HermitePade
