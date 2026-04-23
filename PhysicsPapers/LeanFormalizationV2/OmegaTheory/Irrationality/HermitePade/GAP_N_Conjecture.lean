/-
  OmegaTheory.Irrationality.HermitePade.GAP_N_Conjecture

  Attack 21 — Nesterenko (1996) + the effective sharpening conjecture GAP_N.

  Scope
  -----
  Pure statement-level file.  Two kinds of content:

  1. Nesterenko's 1996 algebraic independence theorem for the triple
     `(π, e^π, Γ(1/4))` is STATED AS AN AXIOM, cited below.  This is
     the only place in V2 where this axiom is introduced; every other
     Lean file remains axiom-clean.

  2. The conjecture **GAP_N** (effective Liouville-style lower bound
     for non-zero integer polynomials in `π, e^π, Γ(1/4)`) is stated as
     a `def` of type `Prop`.  It is *not* proved — that is the open
     problem the π-irrationality diary is attacking.  Only the formal
     statement lives here, so the rest of V2 may cite it by name.

  Citation (axiom)
  ----------------
  Yu. V. Nesterenko,
  *On the measure of algebraic independence of values of Ramanujan
  functions*,
  C. R. Acad. Sci. Paris, Sér. I Math. **322** (1996), no. 10, 909–914.
  (Algebraic independence of `π, e^π, Γ(1/4)` — transcendence degree 3.)

  Citation (conjecture)
  ---------------------
  Diary Module 21 (Attack 21), formulated by Marchewka in 2025–2026 as
  the *effective* Nesterenko-Liouville sharpening needed to force
  `μ(π) ≤ 3 + ε`; see `Paper-Attack21-Nesterenko-modular.md`.

  Dependencies: Mathlib v4.29
    (`Real.pi`, `Real.exp`, `Real.Gamma`, `IsAlgebraic`,
     `AlgebraicIndependent`, `MvPolynomial`).

  Byline: N. Marchewka (author of Ω-Theory), formalization by agent Rigel.
  No sorries.  One named axiom (`Nesterenko_1996`).  No further
  obligations in this file.
-/

import Mathlib.RingTheory.AlgebraicIndependent.Defs
import Mathlib.RingTheory.AlgebraicIndependent.Transcendental
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Analysis.SpecialFunctions.Gamma.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Algebra.MvPolynomial.CommRing

namespace OmegaTheory.Irrationality.HermitePade

open Real

/--
The Nesterenko triple `(π, e^π, Γ(1/4))`, as a family indexed by
`Fin 3`.  Packaging the three constants into a single indexed family
is the form required by `AlgebraicIndependent` (which takes a map
`ι → A`, not a tuple).
-/
noncomputable def nesterenkoTriple : Fin 3 → ℝ
  | ⟨0, _⟩ => Real.pi
  | ⟨1, _⟩ => Real.exp Real.pi
  | ⟨2, _⟩ => Real.Gamma (1 / 4)

/--
**Axiom (Nesterenko 1996).**  The three real numbers `π`, `e^π`, and
`Γ(1/4)` are *algebraically independent* over `ℚ`.

This is the main theorem of

  Yu. V. Nesterenko, *On the measure of algebraic independence of
  values of Ramanujan functions*, C. R. Acad. Sci. Paris, Sér. I
  Math. **322** (1996), no. 10, 909–914.

Equivalently: the canonical evaluation map
`MvPolynomial (Fin 3) ℚ → ℝ` sending the `i`-th generator to
`nesterenkoTriple i` has trivial kernel.

In particular, each of `π`, `e^π`, `Γ(1/4)` is transcendental over ℚ,
and any two of them are algebraically independent — all consequences
of this single algebraic-independence statement.

Status in Mathlib v4.29: the Lindemann–Weierstrass apparatus
(`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`) is
present but does not yet reach Nesterenko-level statements about
`e^π` and `Γ(1/4)`.  Hence this is stated as an axiom.  When Mathlib
catches up, replace `axiom` with `theorem` and cite the Mathlib proof.
-/
axiom Nesterenko_1996 : AlgebraicIndependent ℚ nesterenkoTriple

/--
**Corollary of `Nesterenko_1996` (transcendence statements).**

Each of `π`, `e^π`, `Γ(1/4)` is transcendental over ℚ — equivalently,
not algebraic over ℚ.  This is the weaker form sometimes quoted
alongside the algebraic-independence statement; we expose it here for
convenient downstream use.

Derived from `Nesterenko_1996` via `AlgebraicIndependent.transcendental`
(Mathlib v4.29 `Mathlib.RingTheory.AlgebraicIndependent.Transcendental`).

**Eliminated as an axiom 2026-04-22 by Acrab (wave C).** Previously
stated as a separate axiom; now a theorem.  The *named* axiom
bearing Nesterenko's name is exactly the algebraic-independence
statement and nothing weaker; individual transcendence is a
corollary. -/
theorem Nesterenko_1996_transcendence :
    ¬ IsAlgebraic ℚ (Real.pi : ℝ) ∧
    ¬ IsAlgebraic ℚ (Real.exp Real.pi) ∧
    ¬ IsAlgebraic ℚ (Real.Gamma (1 / 4 : ℝ)) := by
  -- Use `AlgebraicIndependent.transcendental` at each coordinate of the triple.
  -- `nesterenkoTriple 0 = π`, `... 1 = e^π`, `... 2 = Γ(1/4)`.
  have h0 : Transcendental ℚ (Real.pi : ℝ) := by
    have := Nesterenko_1996.transcendental (0 : Fin 3)
    simp [nesterenkoTriple] at this
    exact this
  have h1 : Transcendental ℚ (Real.exp Real.pi) := by
    have := Nesterenko_1996.transcendental (1 : Fin 3)
    simp [nesterenkoTriple] at this
    exact this
  have h2 : Transcendental ℚ (Real.Gamma (1 / 4 : ℝ)) := by
    have := Nesterenko_1996.transcendental (2 : Fin 3)
    simp only [nesterenkoTriple, show ((1 : ℝ) / 4) = (4 : ℝ)⁻¹ by norm_num] at this ⊢
    exact this
  exact ⟨h0, h1, h2⟩

/-!
### Height function for integer multivariate polynomials

For the GAP_N statement we need a "naive height" on
`MvPolynomial (Fin 3) ℤ`.  We use the `ℓ^∞` norm on the coefficient
family, i.e. the largest absolute value of any coefficient.

We deliberately keep this definition elementary — no Mahler measure,
no Weil height — because GAP_N is a *statement-level* conjecture and
the height only enters through an inequality `|P(π, e^π, Γ(1/4))| ≥
H(P)^(-C)`.  Any reasonable height will do; the naive one is the
easiest to formalize.
-/

/--
Naive (ℓ^∞) height of an integer multivariate polynomial: the largest
absolute value of any coefficient, or `0` if the polynomial is zero.

`P.support.sup'` needs a nonempty support, so we split on
`P = 0`.
-/
noncomputable def naiveHeight (P : MvPolynomial (Fin 3) ℤ) : ℕ :=
  P.support.sup (fun m => (P.coeff m).natAbs)

/--
The canonical real-valued evaluation of an integer polynomial
`P ∈ ℤ[X₀, X₁, X₂]` at the Nesterenko triple `(π, e^π, Γ(1/4))`.

Implemented by first casting `ℤ → ℝ` (so that we land in an `ℝ`-algebra)
and then applying `MvPolynomial.aeval nesterenkoTriple`.
-/
noncomputable def evalAtNesterenko (P : MvPolynomial (Fin 3) ℤ) : ℝ :=
  MvPolynomial.aeval (R := ℤ) nesterenkoTriple P

/-!
### GAP_N — effective Nesterenko conjecture

**Informal statement.**  There exists an absolute constant `C > 0`
(the *effectivity exponent*) such that for every *non-zero* integer
polynomial `P ∈ ℤ[X₀, X₁, X₂]`,

  `|P(π, e^π, Γ(1/4))|  ≥  (max(H(P), 2))^(-C)`,

where `H(P)` is the naive height of `P`.

This is the *effective* sharpening of Nesterenko's qualitative
algebraic-independence theorem.  Nesterenko proved that the left-hand
side is non-zero; GAP_N predicts a quantitative Liouville-style lower
bound for it, polynomial in the height.  Such an effective statement
would (combined with the diary's Hermite–Padé construction) force the
irrationality measure `μ(π) ≤ 3 + ε`.

`max(H(P), 2)` is used in place of `H(P)` so the bound is meaningful
even for height-1 polynomials like `X₀ - 3` (whose value at π is `π - 3`).

**Status.**  Open conjecture (Attack 21 of the π-irrationality diary).
No proof is attempted in this file; only the formal statement.
-/

/--
**GAP_N conjecture (effective Nesterenko lower bound).**  Stated as a
`Prop`, not proved.

Downstream files may assume `GAP_N` as a hypothesis in theorems of the
form `GAP_N → μ(π) ≤ 3 + ε`, thereby reducing the open part of the
π-irrationality programme to a single named conjecture.
-/
def GAP_N : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ P : MvPolynomial (Fin 3) ℤ, P ≠ 0 →
      |evalAtNesterenko P| ≥ (max ((naiveHeight P : ℝ)) 2) ^ (-C)

/--
**GAP_N, variant with a fixed integer exponent.**

Some diary statements quote GAP_N with an integer effectivity exponent
`C ∈ ℕ` rather than a real one.  The two forms are equivalent up to
enlarging `C` by `⌈·⌉`, but we expose the integer variant because it
is the one used in the μ(π) reduction in Module 21.
-/
def GAP_N_integer : Prop :=
  ∃ C : ℕ, 1 ≤ C ∧
    ∀ P : MvPolynomial (Fin 3) ℤ, P ≠ 0 →
      |evalAtNesterenko P| ≥ (max ((naiveHeight P : ℝ)) 2) ^ (-(C : ℝ))

/--
**Structural companion: transcendence-degree statement.**

`trdeg_Q (π, e^π, Γ(1/4)) = 3` is the qualitative content of
`Nesterenko_1996`.  We record it here as a named proposition (not a
theorem — its proof follows from `Nesterenko_1996` but requires wiring
through `AlgebraicIndependent.transcendenceDegree`, which we defer to
a downstream file).

The name `trdeg_three` is referenced in Diary Module 21 as the
"qualitative half" that GAP_N aims to quantitatively strengthen.
-/
def trdeg_three : Prop :=
  AlgebraicIndependent ℚ nesterenkoTriple

/--
The qualitative half is literally `Nesterenko_1996` — recorded so
downstream code can cite `trdeg_three_holds` by name.
-/
theorem trdeg_three_holds : trdeg_three := Nesterenko_1996

end OmegaTheory.Irrationality.HermitePade
