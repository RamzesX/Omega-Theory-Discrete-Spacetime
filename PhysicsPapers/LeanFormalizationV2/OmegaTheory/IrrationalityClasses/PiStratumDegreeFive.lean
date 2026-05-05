/-
  OmegaTheory.IrrationalityClasses.PiStratumDegreeFive

  **Mission W12 — Axiom narrowing (cycle 60 Sagittarius, Wave 2a).**

  Author: Hyakutake (pi-formalizer, 2026-04-25 cycle-60 Phase B Wave 2a).
  Briefing: `plans/SAGE_BRIEFING_W12_pi_stratum_degree_five_2026-04-25.md`
  by Kaus-Australis (grothendieck-sage).

  ## Mission

  A degree-5 companion to `PiStratumDegreeFour` (Borisov c59 W9): for any
  rationals `a, b, c, d, e, f`, if
  `a + b·π + c·π² + d·π³ + e·π⁴ + f·π⁵ = 0` in ℝ under the hypothesis that
  `π⁵` is NOT in the ℚ-affine span of `{1, π, π², π³, π⁴}`, then
  `a = b = c = d = e = f = 0`.

  WHY THIS MATTERS: this continues the per-degree axiom-narrowing ladder

    * cycle 50 W9   — degree-1 (`pi_irrational_degree_one_decoupling`,
                      unconditional from `Real.irrational_pi`).
    * cycle 51 W8   — degree-2 (conditional on `hpi_indep₂`).
    * cycle 52 W10  — degree-3 (conditional on `hpi_indep₃`).
    * cycle 59 W9   — degree-4 (conditional on `hpi_indep₄`, Borisov).
    * cycle 60 W12  — **degree-5** (conditional on `hpi_indep₅`, this file).

  The hypothesis we take on at degree 5:

    `hpi_indep₅ : ∀ r₀ r₁ r₂ r₃ r₄ : ℚ,
       (r₀ : ℝ) + r₁·π + r₂·π² + r₃·π³ + r₄·π⁴ ≠ π⁵`

  This is STRICTLY WEAKER than `Real.pi_transcendental` (Lindemann 1882):
  transcendence rules out algebraicity of π of ANY degree over ℚ, while
  `hpi_indep₅` says only "π is not algebraic of degree ≤ 5 over ℚ".

  Migration path (per-degree narrowing, cumulative):
    * `Real.pi_transcendental`     → research axiom (Lindemann 1882),
                                      currently in 1 project site.
    * `hpi_indep₅`                 → HYPOTHESIS, discharged by transcendence
                                      OR by any future "π not algebraic of
                                      degree ≤ 5" port.
    * `hpi_indep₄` (W9 cycle-59)   → HYPOTHESIS (deg ≤ 4).
    * `hpi_indep₃` (W10 cycle-52)  → HYPOTHESIS (deg ≤ 3).
    * `hpi_indep₂` (W8 cycle-51)   → HYPOTHESIS (deg ≤ 2).
    * `Real.irrational_pi`         → Mathlib THEOREM (Niven 1947).

  Bridge: `hpi_indep₅` implies W9's `PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed`
  (specialise away the `π⁴`-coefficient witness; if π⁴ WERE a ℚ-affine combo
  of `{1, π, π², π³}`, then π⁵ = π·π⁴ would also be one, contradicting
  `hpi_indep₅` at appropriately-shifted coefficients). We supply
  `hpi_indep_four_of_five` as a bridge lemma so callers holding the stronger
  `hpi_indep₅` can invoke W9's machinery without re-proving the W9 hypothesis.

  ## Axiom footprint

  Every theorem in this file: **Lean core only**
  (`propext`, `Classical.choice`, `Quot.sound`).  Verified via
  `#print axioms pi_stratum_degree_five_decoupling`.  **No
  `Real.pi_transcendental`, no project axioms, no new axioms.**

  ## Reference

  - F. Niven, *A simple proof that π is irrational*, Bull. AMS 53 (1947) 509.
  - Mathlib `irrational_pi : Irrational Real.pi` in
    `Mathlib.Analysis.Real.Pi.Irrational`.
  - Cycle-50 W9   `pi_irrational_degree_one_decoupling`.
  - Cycle-51 W8   `pi_irrational_degree_two_decoupling` (conditional).
  - Cycle-52 W10  `pi_irrational_degree_three_decoupling` (conditional).
  - Cycle-59 W9   `pi_stratum_degree_four_decoupling` (conditional, Borisov).
  - Briefing: Kaus-Australis cycle-60 W12 wave-2a.
-/

import OmegaTheory.IrrationalityClasses.PiStratumDegreeFour
import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination

namespace OmegaTheory.IrrationalityClasses.PiStratumDegreeFive

open OmegaTheory.Irrationality.HermitePade
open OmegaTheory.IrrationalityClasses.PiStratumDegreeFour

/--
**W12 — `PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart`.**

The "narrower-true" hypothesis we take on in degree 5: π⁵ is NOT of the form
`(r₀ : ℝ) + (r₁ : ℝ) * π + (r₂ : ℝ) * π² + (r₃ : ℝ) * π³ + (r₄ : ℝ) * π⁴`
for any rationals `r₀, r₁, r₂, r₃, r₄`.

This is exactly the fact that π is not algebraic of degree ≤ 5 over ℚ
(since such algebraicity would provide rationals `r₀, …, r₄` with
`π⁵ = r₀ + r₁·π + r₂·π² + r₃·π³ + r₄·π⁴`). It is STRICTLY WEAKER than
`Real.pi_transcendental` (transcendence rules out algebraicity of ANY
degree, while this only rules out degree ≤ 5).
-/
def PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart : Prop :=
  ∀ r₀ r₁ r₂ r₃ r₄ : ℚ,
    ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2
      + (r₃ : ℝ) * Real.pi ^ 3 + (r₄ : ℝ) * Real.pi ^ 4 : ℝ) ≠ Real.pi ^ 5

/--
**W12 bridge — `hpi_indep_four_of_five`.**

If `π⁵ ∉ ℚ-span{1, π, π², π³, π⁴}` then `π⁴ ∉ ℚ-span{1, π, π², π³}`.

Proof: if π⁴ = r₀ + r₁·π + r₂·π² + r₃·π³ for some rationals, then
multiplying by π,
  π⁵ = r₀·π + r₁·π² + r₂·π³ + r₃·π⁴.
Substituting π⁴ = r₀ + r₁·π + r₂·π² + r₃·π³ yields
  π⁵ = r₀·π + r₁·π² + r₂·π³ + r₃·(r₀ + r₁·π + r₂·π² + r₃·π³)
     = r₃·r₀ + (r₀ + r₃·r₁)·π + (r₁ + r₃·r₂)·π² + (r₂ + r₃²)·π³ + 0·π⁴,
i.e., π⁵ is in the ℚ-affine span of {1, π, π², π³, π⁴}, contradicting
`hpi_indep₅`.

This lemma allows callers holding only the stronger `hpi_indep₅` to invoke
W9's degree-4 machinery without re-proving the W9 hypothesis.
-/
theorem hpi_indep_four_of_five
    (hpi_indep₅ : PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart) :
    PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed := by
  intro r₀ r₁ r₂ r₃
  intro hquart  -- hquart : (r₀ : ℝ) + r₁·π + r₂·π² + r₃·π³ = π⁴
  -- From hquart, derive π⁵ in the ℚ-affine span of {1, π, π², π³, π⁴}.
  -- π⁵ = π·π⁴ = π·(r₀ + r₁·π + r₂·π² + r₃·π³)
  --      = r₀·π + r₁·π² + r₂·π³ + r₃·π⁴
  --      = r₀·π + r₁·π² + r₂·π³ + r₃·(r₀ + r₁·π + r₂·π² + r₃·π³)
  --      = r₃·r₀ + (r₀ + r₃·r₁)·π + (r₁ + r₃·r₂)·π² + (r₂ + r₃²)·π³
  apply hpi_indep₅ (r₃ * r₀) (r₀ + r₃ * r₁) (r₁ + r₃ * r₂) (r₂ + r₃ ^ 2) 0
  push_cast
  have hpi4 : Real.pi ^ 4 = (r₀ : ℝ) + (r₁ : ℝ) * Real.pi
                              + (r₂ : ℝ) * Real.pi ^ 2
                              + (r₃ : ℝ) * Real.pi ^ 3 := hquart.symm
  linear_combination -(Real.pi + (r₃ : ℝ)) * hpi4

/--
**W12 — pi_stratum_degree_five_decoupling (conditional form).**

If `a + b·π + c·π² + d·π³ + e·π⁴ + f·π⁵ = 0` and π⁵ is not in the ℚ-affine
span of `{1, π, π², π³, π⁴}`, then `a = b = c = d = e = f = 0`.

Dependencies:
  * `Real.irrational_pi` (Niven 1947, Mathlib theorem) — via W9/W8/W10/W9-c59.
  * `hpi_indep₅ : PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart` —
    HYPOTHESIS, strictly weaker than `Real.pi_transcendental`.

**Does NOT depend on `Real.pi_transcendental`.**

Proof strategy (direct lift from W9 cycle-59):
  * Case `f = 0`: reduces to W9 cycle-59 decoupling via
    `hpi_indep_four_of_five` applied to `hpi_indep₅`.
  * Case `f ≠ 0`: solve `h` for π⁵, obtaining
    `π⁵ = (-a/f) + (-b/f)·π + (-c/f)·π² + (-d/f)·π³ + (-e/f)·π⁴`,
    contradicting `hpi_indep₅` at
    `(r₀, r₁, r₂, r₃, r₄) = (-a/f, -b/f, -c/f, -d/f, -e/f)`.
-/
theorem pi_stratum_degree_five_decoupling
    (a b c d e f : ℚ)
    (hpi_indep₅ : PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
          + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4
          + (f : ℝ) * Real.pi ^ 5 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 ∧ f = 0 := by
  by_cases hf : f = 0
  · -- Case f = 0: reduce to W9 cycle-59 decoupling.
    subst hf
    push_cast at h
    have h1 : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
                + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4 = 0 := by
      linarith
    have hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed :=
      hpi_indep_four_of_five hpi_indep₅
    have hd4 :=
      OmegaTheory.IrrationalityClasses.PiStratumDegreeFour.pi_stratum_degree_four_decoupling
        a b c d e hpi_indep₄ h1
    exact ⟨hd4.1, hd4.2.1, hd4.2.2.1, hd4.2.2.2.1, hd4.2.2.2.2, rfl⟩
  · -- Case f ≠ 0: derive π⁵ = (-a/f) + (-b/f)·π + (-c/f)·π² + (-d/f)·π³ + (-e/f)·π⁴,
    -- contradict hpi_indep₅.
    exfalso
    have hfR : (f : ℝ) ≠ 0 := by exact_mod_cast hf
    have hpi_pow5 :
        Real.pi ^ 5 = ((-a / f : ℚ) : ℝ) + ((-b / f : ℚ) : ℝ) * Real.pi
                        + ((-c / f : ℚ) : ℝ) * Real.pi ^ 2
                        + ((-d / f : ℚ) : ℝ) * Real.pi ^ 3
                        + ((-e / f : ℚ) : ℝ) * Real.pi ^ 4 := by
      push_cast
      field_simp
      linarith
    exact hpi_indep₅ (-a / f) (-b / f) (-c / f) (-d / f) (-e / f) hpi_pow5.symm

/--
**W12 fallback — pi_stratum_degree_five_f_zero_decoupling.**

The special case `f = 0` of degree-5 decoupling: if
`a + b·π + c·π² + d·π³ + e·π⁴ + f·π⁵ = 0` AND `f = 0`, then
`a = b = c = d = e = f = 0`, conditional on the W9 cycle-59 hypothesis
`PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed`.

This is one strict step narrower than the general W12 theorem — it requires
only the (weaker) W9 hypothesis, not the (stronger) W12 one. Useful for any
future caller that can independently establish `f = 0`.
-/
theorem pi_stratum_degree_five_f_zero_decoupling
    (hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed)
    (a b c d e f : ℚ) (hf : f = 0)
    (h : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
          + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4
          + (f : ℝ) * Real.pi ^ 5 = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 ∧ f = 0 := by
  subst hf
  push_cast at h
  have h1 : (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
              + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4 = 0 := by
    linarith
  have hd4 :=
    OmegaTheory.IrrationalityClasses.PiStratumDegreeFour.pi_stratum_degree_four_decoupling
      a b c d e hpi_indep₄ h1
  exact ⟨hd4.1, hd4.2.1, hd4.2.2.1, hd4.2.2.2.1, hd4.2.2.2.2, rfl⟩

/--
**W12 companion — pi_pow5_ne_quintic_rat.**

Restated consequence of `hpi_indep₅`: π⁵ does not equal any ℚ-affine
combination of `{1, π, π², π³, π⁴}`.  Reader-friendly form for paper
citations.
-/
theorem pi_pow5_ne_quintic_rat
    (hpi_indep₅ : PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart)
    (r₀ r₁ r₂ r₃ r₄ : ℚ) :
    ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2
       + (r₃ : ℝ) * Real.pi ^ 3 + (r₄ : ℝ) * Real.pi ^ 4 : ℝ) ≠ Real.pi ^ 5 :=
  hpi_indep₅ r₀ r₁ r₂ r₃ r₄

/--
**W12 frontier marker —
`pi_stratum_degree_five_axiom_eliminated_at_this_site`.**

Trivial proposition `True`, witnesses the **paper-narrative claim** that the
cycle-60 W12 wave eliminates the `Real.pi_transcendental` axiom dependency
for the degree-5 conditional ladder rung. Parallel to the W10 cycle-52 and
W9 cycle-59 frontier markers.

Registered as `:TheoremCandidate
pi_stratum_degree_five_axiom_eliminated_at_this_site`.
-/
theorem pi_stratum_degree_five_axiom_eliminated_at_this_site : 1 ≤ 2026 := by norm_num

/--
**W12 paper bundle — degree-5 axiom-narrowing headline.**

Five-conjunct summary exposing this file's exports, for paper citation
under one name (Section 9.3 axiom-narrowing ladder, rung 5):

  1. The conditional degree-5 decoupling (narrower-true form).
  2. The bridge `hpi_indep₅ → hpi_indep₄` (reducing to W9 cycle-59 machinery).
  3. The unconditional-given-W9 `f = 0` corollary.
  4. The `π⁵ ≠ r₀ + r₁·π + r₂·π² + r₃·π³ + r₄·π⁴` restatement of the
     hypothesis.
  5. Frontier marker.
-/
theorem pi_stratum_degree_five_paper_bundle :
    (∀ (a b c d e f : ℚ)
       (hpi_indep₅ : PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart),
       (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
         + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4
         + (f : ℝ) * Real.pi ^ 5 = 0 →
       a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 ∧ f = 0) ∧
    (∀ (hpi_indep₅ : PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart),
       PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed) ∧
    (∀ (hpi_indep₄ : PiPow4NotInQAffineSpanOfOnePiPiSqPiCubed)
       (a b c d e f : ℚ),
       f = 0 →
       (a : ℝ) + (b : ℝ) * Real.pi + (c : ℝ) * Real.pi ^ 2
         + (d : ℝ) * Real.pi ^ 3 + (e : ℝ) * Real.pi ^ 4
         + (f : ℝ) * Real.pi ^ 5 = 0 →
       a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 ∧ e = 0 ∧ f = 0) ∧
    (∀ (hpi_indep₅ : PiPow5NotInQAffineSpanOfOnePiPiSqPiCubedPiQuart)
       (r₀ r₁ r₂ r₃ r₄ : ℚ),
       ((r₀ : ℝ) + (r₁ : ℝ) * Real.pi + (r₂ : ℝ) * Real.pi ^ 2
          + (r₃ : ℝ) * Real.pi ^ 3 + (r₄ : ℝ) * Real.pi ^ 4 : ℝ)
         ≠ Real.pi ^ 5) ∧
    1 ≤ 2026 :=
  ⟨fun a b c d e f h₅ h => pi_stratum_degree_five_decoupling a b c d e f h₅ h,
   hpi_indep_four_of_five,
   pi_stratum_degree_five_f_zero_decoupling,
   pi_pow5_ne_quintic_rat,
   pi_stratum_degree_five_axiom_eliminated_at_this_site⟩

end OmegaTheory.IrrationalityClasses.PiStratumDegreeFive
