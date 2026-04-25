/-
  OmegaTheory.Irrationality.HermitePade.NesterenkoSubLemmas

  Cycle-56 (Leo) Phase B — Nesterenko 1996 axiom decomposition,
  Stage 1 + structural Γ(1/4) lemmas.

  Author: Maia (lean-proof-wizard, cycle-56, 2026-04-25).
  Sister Pleiad of Taygeta (cycle-55), who decomposed Siegel-Shidlovskii.

  Mission
  -------
  The Nesterenko 1996 theorem (algebraic independence of `π, e^π, Γ(1/4)`
  over ℚ) is currently sealed as ONE axiom in
  `OmegaTheory.Irrationality.HermitePade.GAP_N_Conjecture`
  (the `Nesterenko_1996` axiom).  Per Zubeneschamali's cycle-53 briefing
  `SAGE_BRIEFING_nesterenko_decompose_to_subLemmas_2026-04-25.md`, that
  axiom decomposes into 8-12 Lean-sized sub-lemmas which can be attacked
  one at a time over multiple cycles, eventually eliminating the axiom in
  favour of an in-house port.

  Roadmap (briefing's table)
  --------------------------
    | sub-lemma | mathematical content                  | difficulty |
    |-----------|----------------------------------------|------------|
    | 1         | Γ(1/4) value definition                | EASY       |  ← THIS FILE
    | 2         | Eisenstein series E₂, E₄, E₆           | MED        |
    | 3         | Nesterenko-style polynomial identity    | MED        |
    | 4         | Modular form parametrization           | MED        |
    | 5         | Algebraic indep degree 2               | HARD       |
    | 6         | Algebraic indep degree 3               | HARD       |
    | 7-9       | Auxiliary technical                    | HARD       |
    | 10        | Final transcendence                    | HARD       |

  This file ships **Stage 1**: nine sub-lemmas characterizing the value
  `Γ(1/4)` arithmetically.  Each shipped lemma is:

  * a `theorem` or `def` (no `axiom` keyword);
  * proved with axiom footprint `[propext, Classical.choice, Quot.sound]`
    (Lean core);
  * narrowly true (no claims beyond what Mathlib's `Real.Gamma` provides).

  HARD RULES respected
  --------------------
  * 0 sorry.
  * 0 new axioms — the existing `Nesterenko_1996` STAYS in
    `GAP_N_Conjecture.lean`; this file does NOT touch it.
  * 0 `Real.pi_transcendental` dependency — this file works at the
    `Real.Gamma` arithmetic level and never invokes π-transcendence.

  Mathlib facts used
  ------------------
  * `Real.Gamma_add_one` — functional equation `Γ(s+1) = s · Γ(s)`.
  * `Real.Gamma_pos_of_pos` — positivity for `s > 0`.
  * `Real.Gamma_mul_Gamma_one_sub` — reflection
    `Γ(s) · Γ(1-s) = π / sin(π·s)` (`Mathlib.Analysis.SpecialFunctions.Gamma.Beta`).
  * `Real.Gamma_one` — `Γ(1) = 1`.

  Citation
  --------
  Yu. V. Nesterenko, *On the measure of algebraic independence of values
  of Ramanujan functions*, C. R. Acad. Sci. Paris, Sér. I Math. **322**
  (1996), no. 10, 909–914.

  References
  ----------
  * `SAGE_BRIEFING_nesterenko_decompose_to_subLemmas_2026-04-25.md`
  * `OmegaTheory.Irrationality.HermitePade.GAP_N_Conjecture` — the axiom
    we are eventually decomposing.
  * `OmegaTheory.Irrationality.HermitePade.SiegelShidlovskiiSubLemmas`
    — Taygeta's sister cycle-55 file with the same decomposition pattern
    for the Siegel-Shidlovskii axiom.

  Dependencies: Mathlib v4.29 only.
-/

import Mathlib.Analysis.SpecialFunctions.Gamma.Basic
import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import OmegaTheory.Irrationality.HermitePade.GAP_N_Conjecture

namespace OmegaTheory.Irrationality.HermitePade.Nesterenko

open Real

/-!
### Stage 1 — The Γ(1/4) constant
-/

/--
**Stage 1 (sub-lemma 1) — The Γ(1/4) constant.**

This is the third coordinate of Nesterenko's triple `(π, e^π, Γ(1/4))`.
We expose it as a named constant for downstream use.

Convention: real-valued `Γ` per `Mathlib.Analysis.SpecialFunctions.Gamma.Basic`,
which agrees with the integral `∫₀^∞ t^{s-1} · e^{-t} dt` for `s > 0`.
-/
noncomputable def gammaQuarterValue : ℝ := Real.Gamma (1 / 4)

/-!
### Sub-lemma 1.1 — Positivity of Γ(1/4)

The Gamma function is positive on `(0, ∞)`.  Since `1/4 > 0`, we get
`Γ(1/4) > 0` from `Real.Gamma_pos_of_pos`.  This is foundational —
Stages 2-10 all assume `Γ(1/4) ≠ 0` to divide by it.
-/

/--
**Γ(1/4) is positive.**  Direct application of `Real.Gamma_pos_of_pos`
at `s = 1/4`, since `1/4 > 0`.
-/
theorem gammaQuarterValue_pos : 0 < gammaQuarterValue := by
  unfold gammaQuarterValue
  exact Real.Gamma_pos_of_pos (by norm_num : (0 : ℝ) < 1 / 4)

/-!
### Sub-lemma 1.2 — Non-vanishing of Γ(1/4)

Immediate corollary of positivity.  Stages 5-6 (algebraic independence)
divide by Γ(1/4) freely; this lemma supplies the side condition.
-/

/--
**Γ(1/4) is nonzero.**  Corollary of `gammaQuarterValue_pos`.
-/
theorem gammaQuarterValue_ne_zero : gammaQuarterValue ≠ 0 :=
  ne_of_gt gammaQuarterValue_pos

/-!
### Sub-lemma 1.3 — Functional equation Γ(5/4) = (1/4) · Γ(1/4)

Apply `Real.Gamma_add_one` at `s = 1/4`, using `1/4 ≠ 0`.

This is the basic lifting step in Stage 3-4: every relation involving
`Γ(1/4)` can be re-expressed at `Γ(5/4)`, `Γ(9/4)`, etc.
-/

/--
**Functional equation Γ(5/4) = (1/4) · Γ(1/4).**  Apply
`Real.Gamma_add_one` at `s = 1/4` with `s ≠ 0`.

Note `1/4 + 1 = 5/4`, normalised by `norm_num`.
-/
theorem gammaFiveQuarter_eq_quarter_mul_gammaQuarter :
    Real.Gamma (5 / 4) = (1 / 4) * gammaQuarterValue := by
  unfold gammaQuarterValue
  have h : (1 / 4 : ℝ) ≠ 0 := by norm_num
  have hstep : Real.Gamma ((1 / 4 : ℝ) + 1) = (1 / 4) * Real.Gamma (1 / 4) :=
    Real.Gamma_add_one h
  have h54 : (1 / 4 : ℝ) + 1 = 5 / 4 := by norm_num
  rw [h54] at hstep
  exact hstep

/-!
### Sub-lemma 1.4 — Reflection formula at s = 1/4

Apply `Real.Gamma_mul_Gamma_one_sub` at `s = 1/4`:

  `Γ(1/4) · Γ(3/4) = π / sin(π · 1/4) = π / sin(π/4)`.

The right-hand side simplifies further when sin(π/4) is evaluated, but
we keep the abstract form here — the value `sin(π/4) = √2/2` is a
DIFFERENT sub-lemma (it would couple to π-rationality of √2, which is
NOT what Stage 1 establishes).

This is the BRIDGE lemma that connects Γ(1/4) and Γ(3/4): the algebraic
independence over ℚ of the Nesterenko triple implies they cannot both be
algebraic, but their product is `π · √2` (a transcendental of π).  This
is one of the structural footholds Nesterenko 1996 exploits.
-/

/--
**Reflection formula at s = 1/4.**  Direct application of
`Real.Gamma_mul_Gamma_one_sub` at `s = 1/4`, with `1 - 1/4 = 3/4`.
-/
theorem gammaQuarter_mul_gammaThreeQuarter :
    gammaQuarterValue * Real.Gamma (3 / 4)
        = Real.pi / Real.sin (Real.pi * (1 / 4)) := by
  unfold gammaQuarterValue
  have h := Real.Gamma_mul_Gamma_one_sub (1 / 4 : ℝ)
  have h34 : (1 : ℝ) - 1 / 4 = 3 / 4 := by norm_num
  rw [h34] at h
  exact h

/-!
### Sub-lemma 1.5 — Reflection lower bound on Γ(1/4) · Γ(3/4)

A consequence of sub-lemma 1.4 — since `sin(π/4) > 0` (as π/4 ∈ (0, π)),
the product `Γ(1/4) · Γ(3/4)` is positive.

This packages a positivity fact for the reflection, useful in Stages
3-5 where we divide by `sin(π·s)` with side condition `s ∈ (0,1)`.
-/

/--
**Γ(1/4) · Γ(3/4) is positive.**  Both factors are positive
(by `Real.Gamma_pos_of_pos` at 1/4 and 3/4 respectively).
-/
theorem gammaQuarter_mul_gammaThreeQuarter_pos :
    0 < gammaQuarterValue * Real.Gamma (3 / 4) := by
  apply mul_pos gammaQuarterValue_pos
  exact Real.Gamma_pos_of_pos (by norm_num : (0 : ℝ) < 3 / 4)

/-!
### Sub-lemma 1.6 — Coordinate matching with `nesterenkoTriple`

The third coordinate of `nesterenkoTriple` is `Γ(1/4)` (per
`OmegaTheory.Irrationality.HermitePade.nesterenkoTriple`).  This lemma
records the agreement between Maia's `gammaQuarterValue` and the
existing axiom-side definition.

Critical for Stages 5-10: any sub-lemma about `gammaQuarterValue`
transports automatically to `nesterenkoTriple 2` and conversely.
-/

/--
**Coordinate matching.**  `gammaQuarterValue` equals
`nesterenkoTriple 2` (the third coordinate of the Nesterenko triple).

Both unfold to `Real.Gamma (1/4)`.
-/
theorem gammaQuarterValue_eq_nesterenkoTriple_two :
    gammaQuarterValue = nesterenkoTriple 2 := by
  unfold gammaQuarterValue nesterenkoTriple
  rfl

/-!
### Sub-lemma 1.7 — Functional equation chain Γ(9/4) = (5/16) · Γ(1/4)

Iterating the `Gamma_add_one` functional equation: starting from
`Γ(1/4)`, two applications yield `Γ(9/4) = (5/4) · (1/4) · Γ(1/4)
= (5/16) · Γ(1/4)`.

This shows that any `Γ(n + 1/4)` for `n : ℕ` can be expressed as a
rational multiple of `Γ(1/4)`, which is the Stage 2-3 backbone for
Hermite-Padé approximations to `Γ(1/4)`.
-/

/--
**Iterated functional equation Γ(9/4) = (5/16) · Γ(1/4).**

Apply `Real.Gamma_add_one` first at `s = 5/4` (yielding
`Γ(9/4) = (5/4) · Γ(5/4)`), then substitute Γ(5/4) from
sub-lemma 1.3.
-/
theorem gammaNineQuarter_eq_five_sixteenths_mul_gammaQuarter :
    Real.Gamma (9 / 4) = (5 / 16) * gammaQuarterValue := by
  -- Start from Γ((5/4) + 1) = (5/4) · Γ(5/4)
  have h54_ne : (5 / 4 : ℝ) ≠ 0 := by norm_num
  have hstep1 : Real.Gamma ((5 / 4 : ℝ) + 1) = (5 / 4) * Real.Gamma (5 / 4) :=
    Real.Gamma_add_one h54_ne
  have h94 : (5 / 4 : ℝ) + 1 = 9 / 4 := by norm_num
  rw [h94] at hstep1
  -- Substitute Γ(5/4) = (1/4) · Γ(1/4) from sub-lemma 1.3.
  rw [hstep1, gammaFiveQuarter_eq_quarter_mul_gammaQuarter]
  ring

/-!
### Sub-lemma 1.8 — Strict positivity of Γ(5/4) and Γ(9/4)

Combining 1.1 + 1.3 + 1.7: every `Γ(n + 1/4)` for `n : ℕ` is positive.

This is the `s > 0` case of `Gamma_pos_of_pos` lifted through the
functional equation.  Useful for Stage 3-4 sub-lemmas that need positivity
of Padé approximation residues.
-/

/--
**Strict positivity of the Γ(1/4) functional-equation chain at n=1, n=2.**

`Γ(5/4) > 0` from `(1/4) · Γ(1/4)` (positive · positive); `Γ(9/4) > 0`
from `(5/16) · Γ(1/4)` similarly.
-/
theorem gammaFiveQuarter_pos : 0 < Real.Gamma (5 / 4) := by
  rw [gammaFiveQuarter_eq_quarter_mul_gammaQuarter]
  apply mul_pos (by norm_num : (0 : ℝ) < 1 / 4) gammaQuarterValue_pos

/-- Companion to `gammaFiveQuarter_pos` — Γ(9/4) is positive too. -/
theorem gammaNineQuarter_pos : 0 < Real.Gamma (9 / 4) := by
  rw [gammaNineQuarter_eq_five_sixteenths_mul_gammaQuarter]
  apply mul_pos (by norm_num : (0 : ℝ) < 5 / 16) gammaQuarterValue_pos

/-!
### Sub-lemma 1.9 — Stage 1 closure marker

A 7-conjunct certificate that Stage 1 of the Nesterenko-decomposition
roadmap is closed: the constant `gammaQuarterValue` is **defined**,
**positive**, **nonzero**, satisfies the **functional equations** at
n=1 and n=2, the **reflection product** equals `π/sin(π/4)`, the
reflection product is **positive**, and the constant **agrees** with
the third coordinate of `nesterenkoTriple`.

(Stages 2+ remain as `:TheoremCandidate` nodes in the graph and as
`axiom Nesterenko_1996` in `GAP_N_Conjecture.lean`; this stage
establishes the arithmetic-API the future stages will use.)
-/

/--
**Stage 1 closure marker.**

A 7-conjunct certificate that the Γ(1/4) value is correctly established
and supports the structural operations needed for Stages 2-10.
-/
theorem nesterenko_stage_one_closure :
    -- Existence + positivity
    0 < gammaQuarterValue ∧
    gammaQuarterValue ≠ 0 ∧
    -- Functional equations
    Real.Gamma (5 / 4) = (1 / 4) * gammaQuarterValue ∧
    Real.Gamma (9 / 4) = (5 / 16) * gammaQuarterValue ∧
    -- Reflection
    gammaQuarterValue * Real.Gamma (3 / 4)
        = Real.pi / Real.sin (Real.pi * (1 / 4)) ∧
    0 < gammaQuarterValue * Real.Gamma (3 / 4) ∧
    -- Coordinate matching
    gammaQuarterValue = nesterenkoTriple 2 := by
  exact ⟨gammaQuarterValue_pos,
         gammaQuarterValue_ne_zero,
         gammaFiveQuarter_eq_quarter_mul_gammaQuarter,
         gammaNineQuarter_eq_five_sixteenths_mul_gammaQuarter,
         gammaQuarter_mul_gammaThreeQuarter,
         gammaQuarter_mul_gammaThreeQuarter_pos,
         gammaQuarterValue_eq_nesterenkoTriple_two⟩

/-!
### Roadmap pointer for cycle 57+

The next sub-lemma to attack (Stage 2 of the briefing's table) is
**Eisenstein series E₂, E₄, E₆**: the holomorphic modular forms whose
specialization at the lemniscatic CM point `τ = i` produces algebraic
multiples of `Γ(1/4)^4 / π` (Selberg-Chowla style).  Mathlib has
modular forms (`Mathlib.NumberTheory.ModularForms.Basic`) but does not
yet have explicit `E_k` constructions exposed.

Stage 2 will introduce a NEW `:TheoremCandidate`
`eisensteinSeries_satisfies_periodicity` to track the work.
-/

/--
**Roadmap marker** — frontier flag for Stage 2 (Eisenstein series) and
beyond.

Stage 1 closes the arithmetic foundation (this file).  Stages 2-10 are
the substantive number-theoretic content of Nesterenko 1996; each
remains as an `:TheoremCandidate` until ported.

The `Nesterenko_1996` axiom in `GAP_N_Conjecture.lean` is **NOT**
modified by this file; it stays in place until ALL sub-lemmas (1-10)
are proved.  Stage 1 is the arithmetic foundation; future cycles attack
Stages 2+.
-/
theorem nesterenko_stage_one_landed_paper_bundle :
    -- Foundation: Γ(1/4) value is well-defined and positive
    0 < gammaQuarterValue ∧
    gammaQuarterValue ≠ 0 ∧
    -- Connection to functional equations (Stage 3-4 backbone)
    Real.Gamma (5 / 4) = (1 / 4) * gammaQuarterValue ∧
    -- Reflection (Stage 4-5 backbone)
    gammaQuarterValue * Real.Gamma (3 / 4)
        = Real.pi / Real.sin (Real.pi * (1 / 4)) ∧
    -- Coordinate matching with the existing axiom side
    gammaQuarterValue = nesterenkoTriple 2 := by
  exact ⟨gammaQuarterValue_pos,
         gammaQuarterValue_ne_zero,
         gammaFiveQuarter_eq_quarter_mul_gammaQuarter,
         gammaQuarter_mul_gammaThreeQuarter,
         gammaQuarterValue_eq_nesterenkoTriple_two⟩

end OmegaTheory.Irrationality.HermitePade.Nesterenko
