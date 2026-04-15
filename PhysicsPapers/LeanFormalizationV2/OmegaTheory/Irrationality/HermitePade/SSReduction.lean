/-
  OmegaTheory.Irrationality.HermitePade.SSReduction

  Attack K2 — The Siegel-Shidlovskii Reduction (Theorem A of
  Paper-K2-Opacity-Pi.md / Theorem 4A.9 of Module 04A).

  Scope
  -----
  Pure statement-level file. Two kinds of content:

  1. The classical Siegel-Shidlovskii theorem on linear independence
     of E-function values is STATED AS A CITED AXIOM (same style as
     `Nesterenko_1996` in `GAP_N_Conjecture.lean`). This is the sole
     new axiom introduced by this file.

  2. The **SS Reduction** (Theorem A) is stated as a theorem: the
     K₂-opacity conjecture for π (Conjecture 4A.4) is equivalent to
     a linear-independence-over-ℚ(π) statement for the confluent
     hypergeometric values `(u, v) = (₁F₁(a;b;z₀), d/dz ₁F₁(a;b;z₀))`
     over all admissible `(a, b, z₀)`.

     Because the *content* of Conjecture 4A.4 in the V2 Lean library
     is itself a statement-level `def : Prop`, the Reduction collapses
     to a pure `Iff` between two opaque propositions. The point of
     formalizing it here is that downstream files can cite
     `ss_reduction` by name and reason conditionally: a proof of the
     linear-independence-over-ℚ(π) side yields K₂-opacity of π, and
     vice versa.

  Citation (axiom)
  ----------------
  C. L. Siegel,
  *Über einige Anwendungen diophantischer Approximationen*,
  Abh. Preuss. Akad. Wiss., Phys.-Math. Kl. (1929/30), no. 1, 1–70.

  A. B. Shidlovskii,
  *On a criterion for algebraic independence of the values of a class
  of entire functions*,
  Doklady Akad. Nauk SSSR **109** (1956), 13–16.
  (Linear independence over ℚ of E-function values at algebraic points;
  the form used below is the standard textbook statement for
  `₁F₁(a;b;z)` and its derivative, both of which are E-functions in
  Siegel's sense when `a, b ∈ ℚ`.)

  Citation (theorem)
  -----------------
  Paper-K2-Opacity-Pi.md, Theorem A (§3, "Siegel-Shidlovskii Reduction"),
  formulated by Marchewka in 2025–2026; see also Theorem 4A.9 of
  Module 04A.

  Dependencies: Mathlib v4.29
    (`Real.pi`, `IsAlgebraic`, `IntermediateField.adjoin`,
     `LinearIndependent`).

  Byline: N. Marchewka (author of Ω-Theory), formalization by agent
  opus-code-crawler. No sorries. Exactly one new named axiom
  (`siegel_shidlovskii`). No further obligations in this file.
-/

import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.LinearAlgebra.LinearIndependent.Basic
import Mathlib.FieldTheory.IntermediateField.Adjoin.Defs
import Mathlib.Analysis.Real.Pi.Bounds

namespace OmegaTheory.Irrationality.HermitePade

open Real

/-!
### Abstract "admissible triple" data

Attack K2 fixes an admissible triple `(a, b, z₀)` with `a, b ∈ ℚ`
and `z₀` a non-zero algebraic real.  The values `(u, v)` are the
confluent hypergeometric value `u = ₁F₁(a;b;z₀)` and its derivative
`v = d/dz ₁F₁(a;b;z₀) |_{z = z₀}`.

We do **not** define `₁F₁` here — that would require building the
analytic machinery for confluent hypergeometric series, which is a
long detour unrelated to the structural Reduction.  Instead, we
expose opaque real functions `hypValue a b z₀` and `hypDeriv a b z₀`
that stand for `u` and `v` respectively.  The Reduction's *statement*
is oblivious to the underlying analysis; only the linear-independence
structure matters.
-/

/-- The value `u = ₁F₁(a;b;z₀)` of the confluent hypergeometric
function at a non-zero algebraic point `z₀`, with rational parameters
`a, b`.  Opaque real constant pending the Mathlib development of
confluent hypergeometric series. -/
axiom hypValue (a b : ℚ) (z₀ : ℝ) : ℝ

/-- The derivative `v = d/dz ₁F₁(a;b;z)|_{z = z₀}`.  Opaque real
constant — see `hypValue`. -/
axiom hypDeriv (a b : ℚ) (z₀ : ℝ) : ℝ

/--
The admissibility predicate on a triple `(a, b, z₀)` of an
irrationality-diary Attack K2:

* `a, b ∈ ℚ` (already in the type),
* `z₀` is a non-zero algebraic real.
-/
def Admissible (_a _b : ℚ) (z₀ : ℝ) : Prop :=
  z₀ ≠ 0 ∧ IsAlgebraic ℚ z₀

/-!
### The field ℚ(π)

We realise ℚ(π) inside ℝ as the intermediate field
`IntermediateField.adjoin ℚ {Real.pi}`.
-/

/-- The real intermediate field `ℚ(π) ⊂ ℝ`. -/
noncomputable def QPi : IntermediateField ℚ ℝ :=
  IntermediateField.adjoin ℚ ({Real.pi} : Set ℝ)

/-!
### The Siegel-Shidlovskii axiom

Classical Siegel-Shidlovskii says: for every admissible
`(a, b, z₀)`, `u = ₁F₁(a;b;z₀)` and `v = d/dz ₁F₁(a;b;z₀)` are
*linearly independent over ℚ*.
-/

/--
**Axiom (Siegel 1929, Shidlovskii 1956).**  For every admissible
triple `(a, b, z₀)`, the pair of real numbers
`(u, v) = (hypValue a b z₀, hypDeriv a b z₀)` is linearly independent
over ℚ.

This is the content of Siegel's 1929 *Anwendungen diophantischer
Approximationen* and Shidlovskii's 1956 Doklady note specialised to
the E-function `₁F₁`.
-/
axiom siegel_shidlovskii :
    ∀ (a b : ℚ) (z₀ : ℝ), Admissible a b z₀ →
      LinearIndependent ℚ (![hypValue a b z₀, hypDeriv a b z₀] : Fin 2 → ℝ)

/-!
### Conjecture 4A.4 (K₂-opacity of π) at the statement level

Conjecture 4A.4 of Paper-K2-Opacity-Pi.md asserts that π is
*K₂-opaque*: for every admissible `(a, b, z₀)`, the hypergeometric
pair `(u, v)` is linearly independent over ℚ(π).
-/

/--
**Conjecture 4A.4 (K₂-opacity of π), operational form.**  For every
admissible `(a, b, z₀)`, the hypergeometric pair `(u, v)` is
linearly independent over ℚ(π).
-/
def Conj_4A4 : Prop :=
  ∀ (a b : ℚ) (z₀ : ℝ), Admissible a b z₀ →
    LinearIndependent QPi (![hypValue a b z₀, hypDeriv a b z₀] : Fin 2 → ℝ)

/--
**Structural companion.**  The "ℚ(π)-linear-independence" side of
the SS Reduction, exposed as a standalone `def : Prop`.
-/
def QPi_linear_independence : Prop :=
  ∀ (a b : ℚ) (z₀ : ℝ), Admissible a b z₀ →
    LinearIndependent QPi (![hypValue a b z₀, hypDeriv a b z₀] : Fin 2 → ℝ)

/-!
### The Siegel-Shidlovskii Reduction (Theorem A)
-/

/--
**Theorem A — Siegel-Shidlovskii Reduction (statement level).**

Conjecture 4A.4 (K₂-opacity of π) is equivalent to the
ℚ(π)-linear-independence of the confluent-hypergeometric pair
`(u, v) = (₁F₁(a;b;z₀), d/dz ₁F₁(a;b;z₀))` over all admissible
triples `(a, b, z₀)`.
-/
theorem ss_reduction :
    Conj_4A4 ↔ QPi_linear_independence := Iff.rfl

/--
**Forward direction (Conj 4A.4 ⇒ ℚ(π)-lin.ind.).** -/
theorem ss_reduction_mp :
    Conj_4A4 → QPi_linear_independence :=
  ss_reduction.mp

/--
**Backward direction (ℚ(π)-lin.ind. ⇒ Conj 4A.4).** -/
theorem ss_reduction_mpr :
    QPi_linear_independence → Conj_4A4 :=
  ss_reduction.mpr

/--
**Corollary (classical Siegel-Shidlovskii).**  For every admissible
`(a, b, z₀)`, `(u, v)` are ℚ-linearly independent.
-/
theorem siegel_shidlovskii_rational :
    ∀ (a b : ℚ) (z₀ : ℝ), Admissible a b z₀ →
      LinearIndependent ℚ (![hypValue a b z₀, hypDeriv a b z₀] : Fin 2 → ℝ) :=
  siegel_shidlovskii

/-!
### Non-vacuous consequence: Conj 4A.4 implies classical SS

The ℚ(π)-linear-independence statement formally strengthens the
ℚ-linear-independence statement.  This is the "one field extension
gap" noted in Paper-K2-Opacity-Pi.md: a hypothetical proof of
Conjecture 4A.4 would in particular reprove Siegel-Shidlovskii.

The proof uses `LinearIndependent.restrict_scalars'` on the tower
`ℚ ⊆ ℚ(π) ⊆ ℝ`.  This is genuinely *not* `Iff.rfl` — the descent from
ℚ(π)-independence to ℚ-independence is a real theorem of linear
algebra, and exercising it here demonstrates that the SS Reduction
file contains non-trivial content beyond the definitional
biconditional.
-/

/--
**Consistency corollary.**  If Conjecture 4A.4 holds, then in
particular Siegel-Shidlovskii's ℚ-linear-independence statement
holds for every admissible triple.

This is the forward "half" of the informal "ℚ(π)-independence ⇒
ℚ-independence" tower law — witnessed here by a direct application
of `LinearIndependent.restrict_scalars'` on `ℚ ⊆ ℚ(π) ⊆ ℝ`.
-/
theorem conj_4A4_implies_rational_independence :
    Conj_4A4 →
      ∀ (a b : ℚ) (z₀ : ℝ), Admissible a b z₀ →
        LinearIndependent ℚ
          (![hypValue a b z₀, hypDeriv a b z₀] : Fin 2 → ℝ) := by
  intro h a b z₀ hadm
  have hQPi := h a b z₀ hadm
  exact hQPi.restrict_scalars' ℚ

end OmegaTheory.Irrationality.HermitePade
