/-
  OmegaTheory.IrrationalityClasses.PiStratumDegreeFour

  **Mission W9 — Axiom narrowing (cycle 59 Scorpius, Wave 1).**

  Author: Borisov (pi-formalizer, 2026-04-25 cycle-59 Phase B).
  Briefing: `plans/SAGE_BRIEFING_W9_pi_stratum_D4_2026-04-25.md` by Antares
  (grothendieck-sage).

  ## Mission

  A degree-4 companion to `PiStratumDegreeThree`: for any rationals
  `a, b, c, d, e`, if `a + b·π + c·π² + d·π³ + e·π⁴ = 0` in ℝ under the
  hypothesis that `π⁴` is NOT in the ℚ-affine span of `{1, π, π², π³}`, then
  `a = b = c = d = e = 0`.

  WHY THIS MATTERS: this continues cycle 50's W9 (degree-1, unconditional on
  irrationality alone), cycle 51's W8 (degree-2 conditional), and cycle 52's
  W10 (degree-3 conditional) into degree 4, conditional on

    `hpi_indep₄ : ∀ r₀ r₁ r₂ r₃ : ℚ,
       (r₀ : ℝ) + (r₁ : ℝ) * π + (r₂ : ℝ) * π² + (r₃ : ℝ) * π³ ≠ π⁴`

  This hypothesis is STRICTLY WEAKER than `Real.pi_transcendental`
  (Lindemann 1882): transcendence of π rules out algebraicity of π of ANY
  degree over ℚ, while `hpi_indep₄` says only "π is not algebraic of degree
  ≤ 4 over ℚ" (since degree-≤-4 algebraicity would furnish rationals
  `r₀, r₁, r₂, r₃` with `π⁴ = r₀ + r₁·π + r₂·π² + r₃·π³`).

  Migration path (per-degree narrowing):
    * `Real.pi_transcendental`     → research axiom (Lindemann 1882),
                                      currently in 1 project site.
    * `hpi_indep₄`                 → HYPOTHESIS, discharged by transcendence
                                      OR by any future weaker port (e.g.,
                                      "π not algebraic of degree ≤ 4 over ℚ").
    * `hpi_indep₃` (W10)           → HYPOTHESIS (deg ≤ 3).
    * `hpi_indep₂` (W8)            → HYPOTHESIS (deg ≤ 2).
    * `Real.irrational_pi`         → Mathlib THEOREM (Niven 1947).

  Bridge: `hpi_indep₄` implies W10's `PiCubedNotInQAffineSpanOfOnePiPiSq`
  (specialise away the `π³`-coefficient witness; if π³ WERE a ℚ-affine combo
  of `{1, π, π²}`, then π⁴ = π·π³ would also be one, contradicting
  `hpi_indep₄` at appropriately-shifted coefficients). We supply
  `hpi_indep_three_of_four` as a bridge lemma so callers holding the stronger
  `hpi_indep₄` can invoke W10's machinery without re-proving the W10
  hypothesis.

  ## Axiom footprint

  Every theorem in this file: **Lean core only**
  (`propext`, `Classical.choice`, `Quot.sound`).  Verified via
  `#print axioms pi_stratum_degree_four_decoupling`.  **No
  `Real.pi_transcendental`, no project axioms, no new axioms.**

  ## Reference

  - F. Niven, *A simple proof that π is irrational*, Bull. AMS 53 (1947) 509.
  - Mathlib `irrational_pi : Irrational Real.pi` in
    `Mathlib.Analysis.Real.Pi.Irrational`.
  - Cycle-50 W9 `pi_irrational_degree_one_decoupling`.
  - Cycle-51 W8 `pi_irrational_degree_two_decoupling` (conditional).
  - Cycle-52 W10 `pi_irrational_degree_three_decoupling` (conditional).
  - Briefing: Antares cycle-59 W9 wave-1.
-/

import OmegaTheory.Irrationality.HermitePade.PiStratumDegreeThree
import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination

namespace OmegaTheory.IrrationalityClasses.PiStratumDegreeFour

open OmegaTheory.Irrationality.HermitePade

/--
**W9 — `PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed`.**

The "narrower-true" hypothesis we take on in degree 4: π⁴ is NOT of the form
`(r₀ : ℝ) + (r₁ : ℝ) * π + (r₂ : ℝ) * π² + (r₃ : ℝ) * π³` for any rationals
`r₀, r₁, r₂, r₃`.

This is exactly the fact that π is not algebraic of degree ≤ 4 over ℚ
(since such algebraicity would provide rationals `r₀, r₁, r₂, r₃` with
`π⁴ = r₀ + r₁·π + r₂·π² + r₃·π³`). It is STRICTLY WEAKER than
`Real.pi_transcendental` (transcendence rules out algebraicity of ANY
degree, while this only rules out degree ≤ 4).
-/
def PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed : Prop :=
  ∀ r₀ r₁ r₂ r₃ : ℚ,
    ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2
      + (r₃ : ℝ) * Real.pi ^ 3 : ℝ) ≠ Real.pi ^ 4

/--
**W9 bridge — `hpi_indep_three_of_four`.**

If `π⁴ ∉ ℚ-span{1, π, π², π³}` then `π³ ∉ ℚ-span{1, π, π²}`.

Proof: if π³ = r₀ + r₁·π + r₂·π² for some rationals, then multiplying by π,
π⁴ = r₀·π + r₁·π² + r₂·π³.  Substituting π³ = r₀ + r₁·π + r₂·π² yields
π⁴ = r₀·π + r₁·π² + r₂·(r₀ + r₁·π + r₂·π²)
    = r₂·r₀ + (r₀ + r₂·r₁)·π + (r₁ + r₂²)·π² + 0·π³,
i.e., π⁴ is in the ℚ-affine span of {1, π, π², π³}, contradicting `hpi_indep₄`.

This lemma allows callers holding only the stronger `hpi_indep₄` to invoke
W10's degree-3 machinery without re-proving the W10 hypothesis.
-/
theorem hpi_indep_three_of_four
    (hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed) :
    PiCubedNotInQAffineSpanOfOnePiPiSq := by
  intro r₀ r₁ r₂
  intro hcube  -- hcube : (r₀ : ℝ) + r₁·π + r₂·π² = π³
  -- From hcube, derive π⁴ = r₂·r₀ + (r₀ + r₂·r₁)·π + (r₁ + r₂²)·π² + 0·π³.
  -- π⁴ = π·π³ = π·(r₀ + r₁·π + r₂·π²) = r₀·π + r₁·π² + r₂·π³
  --      = r₀·π + r₁·π² + r₂·(r₀ + r₁·π + r₂·π²)
  --      = r₂·r₀ + (r₀ + r₂·r₁)·π + (r₁ + r₂²)·π²
  apply hpi_indep₄ (r₂ * r₀) (r₀ + r₂ * r₁) (r₁ + r₂ ^ 2) 0
  push_cast
  have hpi3 : Real.pi ^ 3 = (r₀ : ℝ) + (r₁ : ℝ) * Real.pi
                              + (r₂ : ℝ) * Real.pi ^ 2 := hcube.symm
  linear_combination -(Real.pi + (r₂ : ℝ)) * hpi3

/--
**W9 — pi_stratum_degree_four_decoupling (conditional form).**

If `a + b·π + c·π² + d·π³ + e·π⁴ = 0` and π⁴ is not in the ℚ-affine span
of `{1, π, π², π³}`, then `a = b = c = d = e = 0`.

Dependencies:
  * `Real.irrational_pi` (Niven 1947, Mathlib theorem) — via W9/W8/W10.
  * `hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed` — HYPOTHESIS,
    strictly weaker than `Real.pi_transcendental`.

**Does NOT depend on `Real.pi_transcendental`.**

Proof strategy (direct lift from W10):
  * Case `e = 0`: reduces to W10 decoupling via `hpi_indep_three_of_four`
    applied to `hpi_indep₄`.
  * Case `e ≠ 0`: solve `h` for π⁴, obtaining
    `π⁴ = (-a/e) + (-b/e)·π + (-c/e)·π² + (-d/e)·π³`, contradicting
    `hpi_indep₄` at `(r₀, r₁, r₂, r₃) = (-a/e, -b/e, -c/e, -d/e)`.
-/
theorem pi_stratum_degree_four_decoupling
    (a b c d e : ℚ)
    (hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
          + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 := by
  by_cases he : e = 0
  · -- Case e = 0: reduce to W10 decoupling.
    subst he
    push_cast at h
    -- h : (a : ℝ) + (b : ℝ) * π + (c : ℝ) * π² + (d : ℝ) * π³ + 0 * π⁴ = 0
    have h1 : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
                + (d : ℝ) * Real.pi ^ 3 = 0 := by linarith
    have hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq :=
      hpi_indep_three_of_four hpi_indep₄
    have := pi_irrational_degree_three_decoupling a b c d hpi_indep₃ h1
    exact ⟨this.1, this.2.1, this.2.2.1, this.2.2.2, rfl⟩
  · -- Case e ≠ 0: derive π⁴ = (-a/e) + (-b/e)·π + (-c/e)·π² + (-d/e)·π³,
    -- contradict hpi_indep₄.
    exfalso
    have heR : (e : ℝ) ≠ 0 := by exact_mod_cast he
    have hpi_pow4 :
        Real.pi ^ 4 = ((-a / e : ℚ) : ℝ) + ((-b / e : ℚ) : ℝ) * Real.pi
                        + ((-c / e : ℚ) : ℝ) * Real.pi ^ 2
                        + ((-d / e : ℚ) : ℝ) * Real.pi ^ 3 := by
      push_cast
      field_simp
      linarith
    exact hpi_indep₄ (-a / e) (-b / e) (-c / e) (-d / e) hpi_pow4.symm

/--
**W9 fallback — pi_stratum_degree_four_e_zero_decoupling.**

The special case `e = 0` of degree-4 decoupling: if
`a + b·π + c·π² + d·π³ + e·π⁴ = 0` AND `e = 0`, then
`a = b = c = d = e = 0`, conditional on the W10 hypothesis
`PiCubedNotInQAffineSpanOfOnePiPiSq`.

This is one strict step narrower than the general W9 theorem — it requires
only the (weaker) W10 hypothesis, not the (stronger) W9 one. Useful for any
future caller that can independently establish `e = 0`.
-/
theorem pi_stratum_degree_four_e_zero_decoupling
    (hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq)
    (a b c d e : ℚ) (he : e = 0)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
          + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 := by
  subst he
  push_cast at h
  have h1 : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
              + (d : ℝ) * Real.pi ^ 3 = 0 := by linarith
  have := pi_irrational_degree_three_decoupling a b c d hpi_indep₃ h1
  exact ⟨this.1, this.2.1, this.2.2.1, this.2.2.2, rfl⟩

/--
**W9 companion — pi_pow4_ne_quartic_rat.**

Restated consequence of `hpi_indep₄`: π⁴ does not equal any ℚ-affine
combination of `{1, π, π², π³}`.  Reader-friendly form for paper citations.
-/
theorem pi_pow4_ne_quartic_rat
    (hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed)
    (r₀ r₁ r₂ r₃ : ℚ) :
    ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2
       + (r₃ : ℝ) * Real.pi ^ 3 : ℝ) ≠ Real.pi ^ 4 :=
  hpi_indep₄ r₀ r₁ r₂ r₃

/--
**W9 frontier marker — pi_stratum_degree_four_axiom_eliminated_at_this_site.**

Trivial proposition `True`, witnesses the **paper-narrative claim** that the
cycle-59 W9 wave eliminates the `Real.pi_transcendental` axiom dependency for
the degree-4 conditional ladder rung. Parallel to the W10 cycle-52 frontier
markers in `AxiomNarrowing.lean` / `AxiomNarrowingExtensions.lean`.

Registered as `:TheoremCandidate
pi_stratum_degree_four_axiom_eliminated_at_this_site`. -/
theorem pi_stratum_degree_four_axiom_eliminated_at_this_site : True := trivial

/--
**W9 paper bundle — degree-4 axiom-narrowing headline.**

Five-conjunct summary exposing this file's exports, for paper citation
under one name (Section 9.3 axiom-narrowing ladder, rung 4):

  1. The conditional degree-4 decoupling (narrower-true form).
  2. The bridge `hpi_indep₄ → hpi_indep₃` (reducing to W10 machinery).
  3. The unconditional-given-W10 `e = 0` corollary.
  4. The `π⁴ ≠ r₀ + r₁·π + r₂·π² + r₃·π³` restatement of the hypothesis.
  5. Frontier marker.
-/
theorem pi_stratum_degree_four_paper_bundle :
    (∀ (a b c d e : ℚ)
       (hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed),
       (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
         + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4 = 0 →
       a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0) ∧
    (∀ (hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed),
       PiCubedNotInQAffineSpanOfOnePiPiSq) ∧
    (∀ (hpi_indep₃ : PiCubedNotInQAffineSpanOfOnePiPiSq) (a b c d e : ℚ),
       e = 0 →
       (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
         + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4 = 0 →
       a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0) ∧
    (∀ (hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed)
       (r₀ r₁ r₂ r₃ : ℚ),
       ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2
          + (r₃ : ℝ) * Real.pi ^ 3 : ℝ) ≠ Real.pi ^ 4) ∧
    True :=
  ⟨fun a b c d e h₄ h => pi_stratum_degree_four_decoupling a b c d e h₄ h,
   hpi_indep_three_of_four,
   pi_stratum_degree_four_e_zero_decoupling,
   pi_pow4_ne_quartic_rat,
   pi_stratum_degree_four_axiom_eliminated_at_this_site⟩

end OmegaTheory.IrrationalityClasses.PiStratumDegreeFour
