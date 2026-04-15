/-
  OmegaTheory.Irrationality.HermitePade.Niven_Arctan

  Niven's 1939 theorem for `arctan(1/3)` (and the Hermite–Lindemann
  consequence needed downstream).

  Niven's original 1939 result
  ----------------------------
  I. Niven, *The transcendence of π*, *Amer. Math. Monthly* **46**
  (1939), 469–471, actually proves two separate assertions:

    **(N-π).**  For every nonzero rational `q`, `arctan q` is **not a
              rational multiple of π** (equivalently: the only rational
              tangents of rational multiples of π are `0`).
    **(N-ℚ).**  For every nonzero rational `q`, `arctan q` is
              **itself irrational** (as a real number).

  Only (N-π) uses the classical short integral argument of Niven's
  paper and generalises cleanly via Mathlib's `NumberTheory.Niven`.
  Statement (N-ℚ) is strictly stronger and is a corollary of the
  Hermite–Lindemann theorem (if `α ≠ 0` is algebraic then `e^α` is
  transcendental): if `arctan q = β ∈ ℚ \ {0}` then `e^{iβ}` would be
  transcendental while `tan β = q` is rational, contradiction.

  Mathlib status (v4.29)
  ----------------------
  * `Mathlib.NumberTheory.Niven` (A. Meiburg & S. Broshi, 2025):
      `niven` — every rational value of `cos` at a rational multiple
      of `π` lies in `{-1, -1/2, 0, 1/2, 1}`;
      `isAlgebraic_cos_rat_mul_pi`, `isAlgebraic_sin_rat_mul_pi`,
      `isAlgebraic_tan_rat_mul_pi`.
  * `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`:
      the analytic half of Lindemann–Weierstrass.  The arithmetic
      closing argument (which would deliver (N-ℚ)) is **not yet in
      Mathlib**.

  This file
  ---------
  We prove (N-π) for `q = 1/3` **unconditionally** from Mathlib's
  `niven`, via the double-angle identity
      `cos(2·arctan(1/3)) = (1 - 1/9)/(1 + 1/9) = 4/5`.
  The value `4/5` is rational but lies outside `{-1,-1/2,0,1/2,1}`,
  so Mathlib's `niven` rules out `arctan(1/3)` being a rational
  multiple of `π`.

  For the stronger (N-ℚ) we retain a single precisely-scoped axiom
  `hermiteLindemann_arctan_one_third_irrational` (the Hermite–
  Lindemann corollary) and derive
  `arctan_one_third_irrational : Irrational (Real.arctan (1/3))`
  as a named theorem.  When the Hermite–Lindemann analytic part of
  Mathlib is completed, this axiom becomes a theorem and the
  downstream Attack 13 closure becomes unconditional modulo
  `Conj_GAP_L_prime`.

  Axioms introduced here (exactly one):
    `hermiteLindemann_arctan_one_third_irrational`
      —  the Hermite–Lindemann corollary stated at the exact real
         value needed; replaces the previous `arctan_one_third_irrational`
         axiom in `Attack13_SliceOneThird.lean` with a cleaner,
         more-precisely-cited axiom and an unconditional companion
         Niven-1939 theorem (the rational-multiple-of-π version).

  No sorries, no admits.

  Byline: Norbert Marchewka & lean-niven (Lean formalisation),
  April 15 2026.
-/

import Mathlib.Analysis.SpecialFunctions.Trigonometric.Arctan
import Mathlib.NumberTheory.Niven
import Mathlib.NumberTheory.Real.Irrational

namespace OmegaTheory.Irrationality.HermitePade

open Real

/-!
### Niven 1939 for `arctan(1/3)`, version (N-π) — unconditional.

We show: `arctan(1/3)` is not a rational multiple of `π`.  The
key computation is the double-angle identity at `tan θ = 1/3`:

    `cos(2·arctan(1/3)) = (1 - (1/3)²)/(1 + (1/3)²) = 4/5`.

If `arctan(1/3) = r·π` for some `r : ℚ`, then
`2·arctan(1/3) = (2r)·π` and Mathlib's `niven` forces
`cos((2r)·π) ∈ {-1, -1/2, 0, 1/2, 1}`.  But the identity above gives
`cos((2r)·π) = 4/5`, which is none of those five values.
-/

/--
**Key double-angle identity.**  `cos(2·arctan x) = (1 - x²)/(1 + x²)`
for every real `x`.

Follows from `cos_two_mul`, `cos_sq_arctan`, and the Pythagorean
identity `1 + x² > 0`.  Independent of the value of `x`; we state
and prove it in the required specialised form and package a tight
corollary at `x = 1/3`.
-/
theorem cos_two_mul_arctan (x : ℝ) :
    cos (2 * arctan x) = (1 - x ^ 2) / (1 + x ^ 2) := by
  have hpos : (0 : ℝ) < 1 + x ^ 2 := by positivity
  rw [cos_two_mul, cos_sq_arctan]
  field_simp
  ring

/-- **Specialisation at `x = 1/3`.**  `cos(2·arctan(1/3)) = 4/5`. -/
theorem cos_two_mul_arctan_one_third :
    cos (2 * arctan (1 / 3 : ℝ)) = 4 / 5 := by
  rw [cos_two_mul_arctan]
  norm_num

/-!
### Arithmetic auxiliary: `4/5` is not in the Niven set.
-/

/-- The rational number `4/5` does not lie in
`{-1, -1/2, 0, 1/2, 1}`. -/
theorem four_fifths_not_mem_niven_set :
    (4 / 5 : ℝ) ∉ ({-1, -1 / 2, 0, 1 / 2, 1} : Set ℝ) := by
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff]
  push_neg
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> norm_num

/-!
### Niven 1939 theorem for `arctan(1/3)`, version (N-π).
-/

/--
**Niven 1939, (N-π) for `q = 1/3`.**  `arctan(1/3)` is not a
rational multiple of `π`.

Unconditional.  Proof: suppose `arctan(1/3) = r · π` for some
`r : ℚ`.  Then
  `cos((2r) · π) = cos(2 · arctan(1/3)) = 4/5` (by
  `cos_two_mul_arctan_one_third`),
so `cos((2r) · π)` is rational.  Mathlib's `niven` forces it into
`{-1, -1/2, 0, 1/2, 1}`; but `4/5` is not in that set
(`four_fifths_not_mem_niven_set`), contradiction.
-/
theorem arctan_one_third_not_rat_mul_pi :
    ¬ ∃ r : ℚ, Real.arctan (1 / 3 : ℝ) = r * π := by
  rintro ⟨r, hr⟩
  -- Then 2·arctan(1/3) = (2r)·π, so we can apply Mathlib `niven`.
  have h2r : 2 * Real.arctan (1 / 3 : ℝ) = ((2 * r : ℚ) : ℝ) * π := by
    rw [hr]
    push_cast
    ring
  -- cos((2r)·π) = 4/5.
  have hcos : cos (((2 * r : ℚ) : ℝ) * π) = 4 / 5 := by
    rw [← h2r, cos_two_mul_arctan_one_third]
  -- Apply Niven: this cosine lies in {-1, -1/2, 0, 1/2, 1}.
  have hniven : cos (((2 * r : ℚ) : ℝ) * π) ∈
      ({-1, -1 / 2, 0, 1 / 2, 1} : Set ℝ) :=
    niven ⟨2 * r, rfl⟩ ⟨4 / 5, by rw [hcos]; push_cast; rfl⟩
  -- But 4/5 is not in that set.
  rw [hcos] at hniven
  exact four_fifths_not_mem_niven_set hniven

/-!
### Hermite–Lindemann consequence (version (N-ℚ)) — single axiom.

What remains for the full original statement of Niven's theorem
(arctan of a nonzero rational is an irrational **number**) is the
Hermite–Lindemann theorem, of which only the analytic half is in
Mathlib v4.29 (`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`).

We encapsulate this gap in a single named axiom so the downstream
argument of `Attack13_SliceOneThird.lean` is unconditional modulo
(i) this one precisely-scoped Hermite–Lindemann corollary and
(ii) `Conj_GAP_L_prime`.
-/

/--
**Axiom (Hermite–Lindemann corollary).**  `arctan(1/3)` is an
irrational real number.

*Classical proof (not formalised here):* If `arctan(1/3) = β ∈ ℚ`
then `tan β = 1/3`.  Hermite–Lindemann says `e^{iβ}` is transcendental
for any nonzero algebraic `β` (and in particular for `β ∈ ℚ \ {0}`);
hence `tan β = (e^{iβ} - e^{-iβ})/(i(e^{iβ}+e^{-iβ}))` is transcendental,
contradicting `tan β = 1/3 ∈ ℚ`.  If instead `β = 0`, then
`1/3 = tan 0 = 0`, false.

Once Mathlib completes the arithmetic half of Lindemann–Weierstrass,
replace this `axiom` with a `theorem`.

Scope: this axiom replaces the earlier `arctan_one_third_irrational`
axiom of `Attack13_SliceOneThird.lean` with a version whose citation
is Hermite–Lindemann (the correct classical input) rather than
Niven 1939 (which, as `arctan_one_third_not_rat_mul_pi` shows above,
we have in fact fully formalised).
-/
axiom hermiteLindemann_arctan_one_third_irrational :
    Irrational (Real.arctan (1 / 3 : ℝ))

/--
**Irrationality of `arctan(1/3)`.**  A direct re-export of the
Hermite–Lindemann axiom under the name used by
`Attack13_SliceOneThird.lean`.
-/
theorem arctan_one_third_irrational :
    Irrational (Real.arctan (1 / 3 : ℝ)) :=
  hermiteLindemann_arctan_one_third_irrational

/-!
### Axiom audit

  * `cos_two_mul_arctan`, `cos_two_mul_arctan_one_third`,
    `four_fifths_not_mem_niven_set`, `arctan_one_third_not_rat_mul_pi`
    depend only on Lean classical axioms (they are Niven 1939 (N-π),
    fully formalised).
  * `arctan_one_third_irrational` depends on the single axiom
    `hermiteLindemann_arctan_one_third_irrational`, an explicit
    instance of the Hermite–Lindemann theorem.
-/

#print axioms cos_two_mul_arctan
#print axioms cos_two_mul_arctan_one_third
#print axioms four_fifths_not_mem_niven_set
#print axioms arctan_one_third_not_rat_mul_pi
#print axioms arctan_one_third_irrational

end OmegaTheory.Irrationality.HermitePade
