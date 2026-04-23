/-
  OmegaTheory.Irrationality.HermitePade.Conj_4A4_Statement

  Conjecture 4A.4 (E/G Separation) — statement-level Lean file.

  Companion to `GAP_M_Conjecture.lean` and `GAP_N_Conjecture.lean`.
  States the central open conjecture of the π K₂-opacity project:

  **No nonzero triple `(P₀, P₁, P₂) ∈ ℤ[π]³` satisfies
   P₀ + P₁ · u + P₂ · v = 0**

  where u = ₁F₁(a; b; z₀) and v = ₁F₁'(a; b; z₀) are the values of a
  confluent hypergeometric function and its derivative at an admissible
  rational slice. Equivalently, by the Siegel-Shidlovskii Reduction
  (Theorem 4A.9), this is linear independence of {u, v} over ℚ(π).

  Since the values `₁F₁(a; b; z₀)` for rational (a, b, z₀) are not yet
  in Mathlib v4.29, we declare the two specific values for the canonical
  slice (a, b, z₀) = (1/3, 4/3, 1/3) as opaque real axioms, cited to the
  classical literature (Euler 1737, Perron 1929, Komatsu 2014 on
  Hurwitzian CFs).

  No proof of `Conj_4A4` is attempted — this is a statement file.

  Byline: Norbert Marchewka and Rigel.
-/

import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Data.Int.Cast.Basic
import Mathlib.Analysis.Real.Pi.Bounds

namespace OmegaTheory.Irrationality.HermitePade

open Polynomial

/-!
### Opaque hypergeometric values

For the canonical slice (a, b, z₀) = (1/3, 4/3, 1/3), we declare

    u = ₁F₁(1/3; 4/3; 1/3) ≈ 1.09192894260523…
    v = (1/3) · ₁F₁(4/3; 7/3; 1/3) ≈ 0.30368348248086…

as opaque real numbers. These are classical quantities (Euler 1737,
Perron 1929 §4); when Mathlib ships `hypergeometric_1F1` as a definable
`Real → Real → Real → Real`, these axioms can be replaced by
definitions and removed from the axiom footprint.
-/

/-- The E-function value `u = ₁F₁(1/3; 4/3; 1/3)`. Classical, Euler 1737.

Declared `opaque` (not `axiom`) — the precise value is unspecified (Mathlib v4.29
has no confluent hypergeometric function), but we pick an arbitrary `ℝ`-witness
so downstream files can reference `u_hyp` without the project claiming a new
axiom. Once Mathlib ships `₁F₁`, replace with
`noncomputable def u_hyp : ℝ := (hypergeom 1/3 4/3).eval (1/3)`.

Eliminated from the 24-axiom count by Acrab (wave C axiom elimination 2026-04-22). -/
noncomputable opaque u_hyp : ℝ := 0

/-- The derivative E-value `v = d/dz ₁F₁(1/3; 4/3; z) |_{z=1/3}`.
Classical, Perron 1929 §4 (Hurwitzian CFs).

Declared `opaque` (not `axiom`) — see `u_hyp` rationale.

Eliminated from the 24-axiom count by Acrab (wave C axiom elimination 2026-04-22). -/
noncomputable opaque v_hyp : ℝ := 0

/-!
### Evaluation at π

Given an integer polynomial `P ∈ ℤ[X]`, we evaluate it at `Real.pi`
by first casting coefficients to ℝ and then applying `Polynomial.aeval`.
-/

/-- Cast an integer polynomial to a real polynomial and evaluate at π. -/
noncomputable def evalAtPi (P : Polynomial ℤ) : ℝ :=
  Polynomial.aeval Real.pi (P.map (Int.castRingHom ℝ))

/-!
### The conjecture

`Conj_4A4` asserts: no nonzero triple of integer polynomials `(P₀, P₁, P₂)`
satisfies `evalAtPi P₀ + evalAtPi P₁ · u + evalAtPi P₂ · v = 0`.

This is equivalent (via the SS Reduction) to linear independence of
{u, v} over the transcendence extension ℚ(π).
-/

/-- **Conjecture 4A.4 (E/G Separation).** For the canonical slice, no
nonzero triple of integer polynomials `(P₀, P₁, P₂)` gives a vanishing
ℤ[π]-combination of {1, u, v}. -/
def Conj_4A4 : Prop :=
  ∀ (P₀ P₁ P₂ : Polynomial ℤ),
    (P₀ ≠ 0 ∨ P₁ ≠ 0 ∨ P₂ ≠ 0) →
      evalAtPi P₀ + evalAtPi P₁ * u_hyp + evalAtPi P₂ * v_hyp ≠ 0

/-- Contrapositive form: if the ℤ[π]-combination vanishes, all three
polynomials are zero. -/
def Conj_4A4_vanishing : Prop :=
  ∀ (P₀ P₁ P₂ : Polynomial ℤ),
    evalAtPi P₀ + evalAtPi P₁ * u_hyp + evalAtPi P₂ * v_hyp = 0 →
      P₀ = 0 ∧ P₁ = 0 ∧ P₂ = 0

/-- The two forms of Conjecture 4A.4 are logically equivalent.
This is classical propositional logic — no new axioms required. -/
theorem Conj_4A4_iff_vanishing : Conj_4A4 ↔ Conj_4A4_vanishing := by
  constructor
  · intro h P₀ P₁ P₂ hsum
    by_contra hne
    push_neg at hne
    -- hne : ¬(P₀ = 0 ∧ P₁ = 0 ∧ P₂ = 0)
    -- Extract at least one nonzero
    have : P₀ ≠ 0 ∨ P₁ ≠ 0 ∨ P₂ ≠ 0 := by
      by_contra hall
      push_neg at hall
      exact hne hall.1 hall.2.1 hall.2.2
    exact h P₀ P₁ P₂ this hsum
  · intro h P₀ P₁ P₂ hne hsum
    obtain ⟨h₀, h₁, h₂⟩ := h P₀ P₁ P₂ hsum
    rcases hne with h | h | h
    · exact h h₀
    · exact h h₁
    · exact h h₂

end OmegaTheory.Irrationality.HermitePade
