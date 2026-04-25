/-
  OmegaTheory.Irrationality.CustomMath.PiIrrationalNivenLayer

  Cycle-59 (Scorpius) Wave-2 — W12 Niven 1947 re-export layer.

  Author: Wezen (lean-proof-wizard, pi-formalizer thread), 2026-04-25.
  Brief: `plans/SAGE_BRIEFING_W12_pi_niven_irr_only_2026-04-25.md`.

  ## What this file delivers

  Single-citation re-export wrapper for the substrate-thesis-sufficient
  irrationality form. Hyades's cycle-58 W4 paper-headline 3-conjunct used
  `irrational_pi` directly. The Path-B (substrate-only, no transcendence)
  paper-headline needs OV2-namespaced re-exports of Mathlib's:

  * `irrational_pi`        (Niven 1947, `Mathlib.Analysis.Real.Pi.Irrational`)
  * `irrational_sqrt_two`  (`Mathlib.NumberTheory.Real.Irrational`)
  * irrationality of `Real.exp 1` is NOT yet in Mathlib v4.29.0; we leave a
    hypothesis hook so downstream paper-headlines stay Path-B compatible.

  Net: the substrate-paper headline becomes locally citable without depending
  on `Real.pi_transcendental`.
-/

import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Analysis.SpecialFunctions.Exp

namespace OmegaTheory.Irrationality.CustomMath.PiIrrationalNivenLayer

/-- Re-export: π is irrational (Niven 1947, in Mathlib as `irrational_pi`). -/
theorem pi_irrational_omega : Irrational Real.pi := irrational_pi

/-- Re-export: √2 is irrational (Mathlib `irrational_sqrt_two`). -/
theorem sqrt_two_irrational_omega : Irrational (Real.sqrt 2) := irrational_sqrt_two

/-- Hypothesis hook: irrationality of `e = Real.exp 1`. Not in Mathlib v4.29.0;
    consumers supply this as a proposition until a Mathlib port lands. -/
def e_irrational_hypothesis : Prop := Irrational (Real.exp 1)

/--
  Three-conjunct paper-headline (Path-B substrate-thesis-sufficient form):
  π and √2 are unconditionally irrational; e-irrationality is supplied as
  a hypothesis. NO `Real.pi_transcendental` axiom in the dependency closure.
-/
theorem ic_three_constants_irrational_only_paper_headline
    (h_e_irr : e_irrational_hypothesis) :
    Irrational Real.pi ∧ Irrational (Real.sqrt 2) ∧ e_irrational_hypothesis :=
  ⟨pi_irrational_omega, sqrt_two_irrational_omega, h_e_irr⟩

end OmegaTheory.Irrationality.CustomMath.PiIrrationalNivenLayer
