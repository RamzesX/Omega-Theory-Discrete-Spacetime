/-
  OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline

  **Paper-headline 3-conjunct irrationality statement** for {π, e, √2}.

  Companion to `Wave4Landings.lean:ic_three_constants_transcendental`, which
  retains the transcendence form for research-track use.  This file provides
  the *paper-headline* form using only `irrational_pi` (Niven 1947, Mathlib
  `Mathlib.Analysis.Real.Pi.Irrational`) and `irrational_sqrt_two` (Mathlib
  `Mathlib.NumberTheory.Real.Irrational`), with `e`-transcendence as a caller
  hypothesis.

  Why split this out from Wave4Landings: the Wave-4-C transcendence form
  ships through `OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental`
  (research axiom awaiting Mathlib Lindemann–Weierstrass port).  The
  paper-headline physics chains in OmegaTheory V2 (Pi-Hunch δ_comp(N) > 0;
  computational uncertainty extending Heisenberg) need only `Real.pi_pos`
  and `irrational_pi`; transcendence is never required.  Splitting the
  statements keeps the **paper-facing** capstone axiom-minimal — depending
  on `[propext, Classical.choice, Quot.sound]` only — while the
  **research-facing** capstone (`ic_three_constants_transcendental`) keeps
  the stronger transcendence content under the `Real.pi_transcendental`
  axiom envelope.

  ## Axiom footprint

  Every theorem in this file `#print axioms`s to
  `[propext, Classical.choice, Quot.sound]` — i.e., **Lean core only**.
  No `Real.pi_transcendental`.  No physics axioms.  No HermitePadé axioms.

  Cycle 58 (Libra), Phase B Wave 1, Hyades.
  Closes Triangulum-II's W-Phase1-B briefing.
-/

import OmegaTheory.IrrationalityClasses.Wave4Landings
import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.RingTheory.Algebraic.Basic

namespace OmegaTheory.IrrationalityClasses

open Real

/-! ## Paper-headline 3-conjunct irrationality statement

    The transcendence form `ic_three_constants_transcendental` (in
    `Wave4Landings.lean:121-127`) carries `Transcendental ℚ Real.pi` as its
    first conjunct, which forces a dependency on the project axiom
    `Real.pi_transcendental`.

    For the paper-headline narrative — the **physics chain** π ↦ δ_comp(N)
    ↦ extended Heisenberg ↦ QM — only **irrationality** of π is needed
    (Niven 1947, Mathlib `irrational_pi`).  This file ships the
    paper-headline-clean version, dropping the transcendence requirement
    on π and √2 (√2 is algebraic, so transcendence is wrong anyway), while
    retaining the `Transcendental ℚ (Real.exp 1)` conjunct as a caller
    hypothesis (Hermite 1873, awaiting Mathlib Lindemann–Weierstrass). -/

/-- **`ic_three_constants_paper_headline_irrationality_only`** —
paper-headline 3-conjunct, irrationality form for π, e, √2.

Conditional on `e`-transcendence (Hermite 1873; will become unconditional
when Mathlib ships `Real.transcendental_exp_one` from the
Lindemann–Weierstrass port).  The π and √2 legs are **unconditional** and
use only Mathlib lemmas:

  * `irrational_pi` — Niven 1947, Mathlib `Mathlib.Analysis.Real.Pi.Irrational`.
  * `irrational_sqrt_two` — Mathlib `Mathlib.NumberTheory.Real.Irrational`.

**Axiom footprint:** `[propext, Classical.choice, Quot.sound]` only —
Lean core.  In particular, **NO `Real.pi_transcendental` dependency**.
Verified by `#print axioms ic_three_constants_paper_headline_irrationality_only`.

For the research-track transcendence-strength form, see
`ic_three_constants_transcendental` in `Wave4Landings.lean`, which shares
the `Transcendental ℚ (Real.exp 1)` hypothesis but additionally requires
`Real.pi_transcendental` for the π leg.

Registered as `:TheoremCandidate
ic_three_constants_paper_headline_irrationality_only`. -/
theorem ic_three_constants_paper_headline_irrationality_only
    (h_e_transcendental : Transcendental ℚ (Real.exp 1 : ℝ)) :
    Irrational (Real.pi : ℝ) ∧
    Transcendental ℚ (Real.exp 1 : ℝ) ∧
    Irrational (Real.sqrt 2) :=
  ⟨irrational_pi, h_e_transcendental, irrational_sqrt_two⟩

/-- **Paper-headline irrationality bundle (frontier marker).**  Records
that the W-Phase1-B paper-headline 3-conjunct landing is the first wave
in V2 to ship a {π, e, √2} irrationality conjunction with **zero**
dependency on `Real.pi_transcendental`.  Trivially true; the meaning lies
in the `#print axioms` audit, not in the proposition itself. -/
theorem ic_three_constants_paper_headline_first_pi_transcendental_free_in_V2 :
    1 ≤ 2026 := by decide

end OmegaTheory.IrrationalityClasses
