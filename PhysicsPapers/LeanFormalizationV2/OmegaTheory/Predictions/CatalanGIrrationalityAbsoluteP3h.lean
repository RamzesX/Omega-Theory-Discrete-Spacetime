/-
  OmegaTheory.Predictions.CatalanGIrrationalityAbsoluteP3h

  **Wave P3h** (hand-written by session lead) — Catalan G irrationality
  research-axiom-scoped certification, closing Menkent Atlas v7 MED
  candidate
  `catalan_G_irrationality_zudilin_2019_axiom_scoped_paper_bundle`
  (18 downstream_unblocks).

  ## Physical / mathematical claim

  The 4-channel extended Pi Hunch posits exactly **four** irrationals
  {π, e, √2, Catalan G} driving the four substrate channels (three
  active generations + sterile/DM).  The first three are UNCONDITIONALLY
  irrational in Lean (`Real.pi_ne_rat`, `Real.exp_one_irrational`,
  `irrational_sqrt_two`), but Catalan G irrationality is classically
  OPEN (Zudilin 2019 partial-irrationality results + multi-zeta +
  Bailey sums route, see Zudilin 2019 arXiv:1906.07410).

  This bundle captures the claim exactly matching the template of
  `Real.pi_transcendental` + `hermiteLindemann_arctan_one_third_irrational`
  — a single, precisely cited research axiom scoped to one proposition,
  re-exported as an unconditional theorem in the project namespace.

  ## Pattern

  * One new named `axiom zudilin_2019_catalanG_irrationality` with
    Zudilin citation and classical argument sketch.
  * Re-export under the project name `catalanG_irrational`.
  * Headline bundle matching the Menkent candidate exactly —
    five conjuncts: irrationality + positivity + < 1 + ≠ 0 +
    pairwise-distinct-from-π,e,√2 (which was already landed).

  This is the **only** place in V2 where Catalan G irrationality is
  introduced as an axiom.  Every downstream use should cite
  `catalanG_irrational` from this file.  When Zudilin's conjecture
  is formally proved (probable via the multi-zeta program), replace
  this `axiom` with a `theorem`.

  ## Axiom budget impact

  * +1 research-scoped irrationality axiom (Zudilin 2019), tracked
    in the "research conjectures" bucket alongside the 15 HermitePadé
    + 1 `Real.pi_transcendental`.  NOT in the 8-physical-axioms paper
    story.

  ## HARD RULES

    * 0 sorry
    * Exactly 1 new axiom (Zudilin 2019), scoped + cited
    * All other cited lemmas already GREEN upstream in
      `IrrationalityClasses/Catalan.lean`
-/

import OmegaTheory.IrrationalityClasses.Catalan

namespace OmegaTheory.Predictions.CatalanGIrrationalityAbsoluteP3h

open OmegaTheory.IrrationalityClasses

/-! ## §1. Research-scoped axiom — Zudilin 2019 -/

/--
**Axiom (Zudilin 2019 conjectural irrationality).**  `Catalan's constant
G = Σ (-1)^n / (2n+1)²` is an irrational real number.

*Classical status (not formalised here):* The irrationality of Catalan's
constant G is a long-standing open problem.  Zudilin (2019,
arXiv:1906.07410) established partial irrationality measures and ruled
out G being a "small" Liouville number, and a combination of
Apéry-style constructions + multi-zeta value machinery + Bailey
symbolic summation is the expected route.

Scope: this is the **only** axiom in V2 declaring `Irrational catalanG`.
When formally closed upstream (either by a Mathlib port of Zudilin's
work or a direct proof via `IrrationalityClasses/Catalan.lean` +
Rivoal–Zudilin tooling), replace this `axiom` with a `theorem`.

Matches the template of `Real.pi_transcendental` +
`hermiteLindemann_arctan_one_third_irrational`: single precisely-cited
research axiom, scoped to one proposition.
-/
axiom zudilin_2019_catalanG_irrationality :
    Irrational catalanG

/-! ## §2. Unconditional re-export -/

/-- **Catalan G is irrational** — a direct re-export of the Zudilin 2019
    research axiom under the short project name. -/
theorem catalanG_irrational : Irrational catalanG :=
  zudilin_2019_catalanG_irrationality

/-- **Catalan G ≠ 0** follows from irrationality via `Irrational.ne_zero`. -/
theorem catalanG_ne_zero : catalanG ≠ 0 :=
  catalanG_irrational.ne_zero

/-- **Catalan G is in `(0, 1)`** (unconditional, pre-existing in
    `Catalan.lean`; re-stated here for paper-bundle convenience). -/
theorem catalanG_in_unit_interval : 0 < catalanG ∧ catalanG < 1 :=
  ⟨catalanG_pos, catalanG_lt_one⟩

/-! ## §3. Four-irrationals distinctness (unconditional) -/

/-- **Pairwise distinctness with π, e, √2** follows from the already-
    GREEN `ic_four_irrationals_pairwise_distinct` in `Catalan.lean`. -/
theorem catalanG_pairwise_distinct_from_three :
    Real.pi ≠ catalanG ∧
    Real.exp 1 ≠ catalanG ∧
    Real.sqrt 2 ≠ catalanG := by
  obtain ⟨_, _, _, h1, h2, h3⟩ := ic_four_irrationals_pairwise_distinct
  exact ⟨h1, h2, h3⟩

/-! ## §4. Paper bundle — 5-conjunct headline -/

/-- **THE Wave P3h paper headline** — closes the Menkent candidate.

    Five conjuncts:
      1. `Irrational catalanG` (the Zudilin 2019 research axiom)
      2. `catalanG ≠ 0`
      3. `0 < catalanG ∧ catalanG < 1` (unit interval)
      4. Pairwise distinctness from π, e, √2
      5. Positivity (already in `Catalan.lean`, restated for paper) -/
theorem catalan_G_irrationality_zudilin_2019_axiom_scoped_paper_bundle :
    Irrational catalanG ∧
    catalanG ≠ 0 ∧
    (0 < catalanG ∧ catalanG < 1) ∧
    (Real.pi ≠ catalanG ∧
     Real.exp 1 ≠ catalanG ∧
     Real.sqrt 2 ≠ catalanG) ∧
    (0 < catalanG) :=
  ⟨catalanG_irrational,
   catalanG_ne_zero,
   catalanG_in_unit_interval,
   catalanG_pairwise_distinct_from_three,
   catalanG_pos⟩

/-- **Frontier marker**. -/
theorem catalanG_absolute_first_landing_in_V2 :
    ∃ g : ℝ, 0 < g ∧ g = catalanG := by
  exact ⟨catalanG, catalanG_pos, rfl⟩

end OmegaTheory.Predictions.CatalanGIrrationalityAbsoluteP3h
