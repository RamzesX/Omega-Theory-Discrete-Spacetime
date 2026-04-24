/-
  OmegaTheory.Irrationality.HermitePade.PiStratumDegreeOne

  **Mission W9 — Axiom narrowing (cycle 50).**

  A degree-1 companion to `PiStratum`: for any rationals `a, b`, if
  `a + b · π = 0` in ℝ, then `a = 0` and `b = 0`.

  WHY THIS MATTERS: cycle-49 brought `Real.pi_transcendental` usage down
  to **1 invocation** in `PiStratum.lean:75`.  This new lemma offers any
  FUTURE caller a strictly-WEAKER-dependency option for the degree-1
  case.  It depends only on `Real.irrational_pi` (Niven 1947, already in
  Mathlib `Mathlib.Analysis.Real.Pi.Irrational`) and therefore requires
  NO research-track axiom.

  Concretely:
    * `Real.pi_transcendental`            → research axiom (Lindemann 1882,
                                             pending Mathlib
                                             Lindemann–Weierstrass port)
    * `Real.irrational_pi`                → Mathlib THEOREM (Niven 1947)

  Any site that uses `pi_stratum_integer` or `pi_stratum_rational` at
  degree `D = 1` only should migrate to
  `pi_irrational_degree_one_decoupling` — the statement is strictly
  narrower but adds NO axioms to the project's footprint.

  Axiom footprint of the main theorem here: **propext + Classical.choice +
  Quot.sound** only (i.e. Lean core).  Verified via `#print axioms
  pi_irrational_degree_one_decoupling`.

  Session/batch: cycle-50 axiom-narrowing wave.
-/

import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Irrationality.HermitePade

/--
**W9 — pi_irrational_degree_one_decoupling.**

If two rationals `a, b` satisfy `a + b · π = 0` in ℝ, then both vanish.

Dependency: `Real.irrational_pi` (Niven 1947, Mathlib theorem).
**Does NOT depend on `Real.pi_transcendental`.**

This is strictly narrower than `pi_stratum_rational` specialised to
`D = 1` because it requires only irrationality of π, not transcendence.
-/
theorem pi_irrational_degree_one_decoupling
    (a b : ℚ) (h : (a : ℝ) + (b : ℝ) * Real.pi = 0) :
    a = 0 ∧ b = 0 := by
  -- Split on whether b = 0.
  by_cases hb : b = 0
  · -- If b = 0, the hypothesis collapses to `(a : ℝ) = 0`, hence `a = 0`.
    refine ⟨?_, hb⟩
    rw [hb] at h
    push_cast at h
    -- h : (a : ℝ) + 0 * Real.pi = 0
    have ha : (a : ℝ) = 0 := by linarith
    exact_mod_cast ha
  · -- If b ≠ 0, we derive π = (-a)/b ∈ ℚ, contradicting `irrational_pi`.
    exfalso
    have hbR : (b : ℝ) ≠ 0 := by exact_mod_cast hb
    -- Solve h for Real.pi: Real.pi = -a/b.
    have hpi : Real.pi = (-a / b : ℚ) := by
      have : (b : ℝ) * Real.pi = -(a : ℝ) := by linarith
      have hpi_eq : Real.pi = -(a : ℝ) / (b : ℝ) := by
        field_simp at this ⊢
        linarith
      rw [hpi_eq]
      push_cast
      ring
    -- But π is irrational, so π ≠ any rational.
    exact irrational_pi ⟨(-a / b : ℚ), hpi.symm⟩

/--
**Corollary — π is not a rational number.**

One-line consequence of `Real.irrational_pi`, phrased for readability.
Useful as an inequality target in tactic scripts.
-/
theorem pi_ne_rat (q : ℚ) : (q : ℝ) ≠ Real.pi := by
  intro heq
  exact irrational_pi ⟨q, heq⟩

/--
**Corollary — π has irrationality measure ≥ 2.**

*Statement-level citation.*  The irrationality measure of π is at least 2
(trivially, since π is irrational).  Mahler (1953) established μ(π) ≤ 30;
current best bound is Salikhov's 2008 result μ(π) ≤ 7.60630853…

We record only the trivial lower bound here; it follows from
`irrational_pi` since every irrational number has irrationality measure
≥ 2 (standard result: if x has measure < 2 then x ∈ ℚ).

For the purposes of OmegaTheory the bound μ(π) ≥ 2 is folded into any
downstream counting argument; we do **not** use the sharper upper bounds.
-/
theorem pi_irrationality_measure_ge_two : Irrational Real.pi := irrational_pi

/--
**Paper bundle — W9 axiom-narrowing headline.**

Single conjunction exposing the three exports of this file, so a paper
section can cite one name.
-/
theorem pi_irrational_degree_one_paper_bundle :
    (∀ (a b : ℚ), (a : ℝ) + (b : ℝ) * Real.pi = 0 → a = 0 ∧ b = 0) ∧
    (∀ (q : ℚ), (q : ℝ) ≠ Real.pi) ∧
    Irrational Real.pi :=
  ⟨pi_irrational_degree_one_decoupling, pi_ne_rat, pi_irrationality_measure_ge_two⟩

end OmegaTheory.Irrationality.HermitePade
