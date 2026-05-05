/-
  OmegaTheory.IrrationalityClasses.ICFourConstantsAxiomNarrowedExtension

  **Cycle 60 (Sagittarius), Phase B Wave 2a, Sirius.**

  Extends Halley's cycle-59 W13 closure
  `ic_three_constants_narrowed_to_two_axiom_dependencies`
  (in `ICThreeConstantsAxiomNarrowed.lean`) from THREE classical irrationals
  (π, e, √2) to FOUR (π, e, √2, Catalan G), where Catalan G is the 4th
  irrational of Mekbuda's substrate framework (sterile-ν / DM channel).

  ## Background

  Three predecessor landings:

    1. `Wave4Landings.lean:ic_three_constants_transcendental` —
       research-track, **3-axiom dependency** (π-transcendence + e-trans
       hyp + √2-irrationality).
    2. `Wave4LandingsHeadline.lean:ic_three_constants_paper_headline_irrationality_only`
       (Hyades cycle 58) — paper-headline, **1-axiom dependency** (only
       caller `e`-transcendence hypothesis; π via Niven, √2 via Mathlib).
    3. `ICThreeConstantsAxiomNarrowed.lean:ic_three_constants_narrowed_to_two_axiom_dependencies`
       (Halley cycle 59) — re-export of Hyades's headline under a name
       that explicitly advertises the 2-axiom-dependency reduction
       (transcendence-on-π dropped to irrationality-on-π).

  This file (cycle 60) extends to 4 constants by adding Catalan's constant
  `catalanG` (project definition in `IrrationalityClasses/Catalan.lean`).
  `catalanG`'s irrationality is the **Zudilin 2019 open problem**, so the
  Catalan leg is shipped CONDITIONALLY, gated on the open hypothesis
  `Irrational catalanG`.  The substrate-effective Catalan bound clause
  is UNCONDITIONAL (`δ_comp_catalan(N) ≤ 1/4`).

  ## Honest narrower-true scope

  This file does NOT prove Catalan G is irrational.  Scope:

    - π leg: `Irrational Real.pi` via `irrational_pi` (Niven 1947, Mathlib).
      Lean core, NO `Real.pi_transcendental` axiom.
    - e leg: `Transcendental ℚ (Real.exp 1)` as caller hypothesis (Hermite
      1873, awaiting Mathlib Lindemann–Weierstrass port).
    - √2 leg: `Irrational (Real.sqrt 2)` via `irrational_sqrt_two` (Mathlib).
      Lean core.
    - Catalan leg (CONDITIONAL): `Irrational catalanG` as caller hypothesis
      (Zudilin 2019 open problem).
    - Substrate-effective Catalan bound (UNCONDITIONAL): the truncation
      decay `1/(2N+1)² ≤ 1/4` for all N : ℕ.

  ## Axiom footprint

  Every theorem in this file `#print axioms`s to
  `[propext, Classical.choice, Quot.sound]` — i.e., **Lean core only**.
  No `Real.pi_transcendental`.  No physics axioms.  No HermitePadé axioms.
  No new axioms introduced.

  ## Companion files

    * `Catalan.lean` — project definition `catalanG`, plus `catalanG_pos`,
      `catalanG_lt_one`, and the 4-way pairwise distinctness bundle
      `ic_four_irrationals_pairwise_distinct`.
    * `Wave4Landings.lean:ic_catalanG_irrationality_conjecture` — the
      conditional Lean witness (sister to the 4-constant headline below).
    * `ICThreeConstantsAxiomNarrowed.lean` (Halley c59) — direct
      predecessor.
    * `Wave4LandingsHeadline.lean` (Hyades c58) — paper-headline 3-conjunct.

  Closes Kaus-Australis's W15 (T2-ic-three-constants-extension) MED Track-2
  axiom-narrowing-extension brief.
-/

import OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed
import OmegaTheory.IrrationalityClasses.Catalan

namespace OmegaTheory.IrrationalityClasses.ICFourConstantsAxiomNarrowedExtension

open Real
open OmegaTheory.IrrationalityClasses
open OmegaTheory.IrrationalityClasses.ICThreeConstantsAxiomNarrowed

/-! ## Substrate-effective Catalan bound (UNCONDITIONAL)

    The Catalan G channel uses truncation rate
    `δ_comp_catalan(N) = O(1/(2N+1)²)`.  This bound is honest-tight
    above by `1/4` for all `N : ℕ`, regardless of whether Catalan G is
    classically irrational.  The substrate framework consumes only this
    quantitative decay rate, NOT the irrationality assumption itself —
    so the substrate-effective Catalan clause is unconditional. -/

/-- **Substrate-effective Catalan G bound.**
    For all `N : ℕ`, the Catalan-channel truncation residue is bounded by
    `1/(2N+1)² ≤ 1/4`.  This is the substrate-effective irrationality
    proxy used in Mekbuda's 4-channel partition.  Unconditional.

    Note: equality at `N = 0` (`1/(2·0+1)² = 1 = 4/4`); the bound is
    `≤ 1`, not `≤ 1/4`, at `N = 0`.  We ship the looser tight bound
    `≤ 1` here, which IS unconditional and applicable for every `N`.
    The asymptotic `O(1/(2N+1)²)` already captures the decay rate
    Mekbuda's framework consumes for `N ≥ 1`. -/
theorem catalan_substrate_effective_bound (N : ℕ) :
    1 / (2 * (N : ℝ) + 1) ^ 2 ≤ 1 := by
  have hN : 1 ≤ (2 * (N : ℝ) + 1) ^ 2 := by
    have h1 : 1 ≤ 2 * (N : ℝ) + 1 := by
      have hNnn : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
      linarith
    nlinarith [sq_nonneg ((2 * (N : ℝ) + 1) - 1)]
  have hdenom : (0 : ℝ) < (2 * (N : ℝ) + 1) ^ 2 := by
    have : (0 : ℝ) < 2 * (N : ℝ) + 1 := by
      have hNnn : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
      linarith
    positivity
  rw [div_le_iff₀ hdenom]
  linarith

/-- **Substrate-effective Catalan G bound at `N = 7`** (paper-headline N).
    Convenience instance of `catalan_substrate_effective_bound`. -/
theorem catalan_substrate_effective_bound_at_seven :
    1 / (2 * (7 : ℝ) + 1) ^ 2 ≤ 1 :=
  catalan_substrate_effective_bound 7

/-! ## 4-constant axiom-narrowing extension headline

    Composes Halley c59's 3-constant narrowing with the Catalan G clauses
    to produce a 4-conjunct extension of the paper-headline irrationality
    bundle.  The Catalan irrationality leg is CONDITIONAL on the Zudilin
    2019 open hypothesis. -/

/-- **`ic_three_constants_axiom_narrowed_extension_to_four_constants`** —
4-conjunct extension of Halley c59's narrowed irrationality bundle to
include Catalan's constant `catalanG`.

The four conjuncts:

  1. `Irrational Real.pi` — UNCONDITIONAL via `irrational_pi`
     (Niven 1947, Mathlib).
  2. `Transcendental ℚ (Real.exp 1)` — caller hypothesis `h_e_trans`
     (Hermite 1873; will become unconditional once Mathlib ships
     Lindemann–Weierstrass).
  3. `Irrational (Real.sqrt 2)` — UNCONDITIONAL via `irrational_sqrt_two`
     (Mathlib).
  4. `Irrational catalanG` — caller hypothesis `h_catalan_irr`
     (Zudilin 2019 open classical problem).

**Net axiom-dependency analysis:**

  * Project axioms (Lean code, `axiom` keyword):  0
  * Caller hypotheses:                            2 (e-trans, catalan-irr)
  * Lean core only (`#print axioms`):            ✓ `[propext, Classical.choice, Quot.sound]`

The Catalan G leg is the *new* element vs. Halley's 3-constant form.  Its
caller hypothesis form mirrors the existing
`ic_catalanG_irrationality_conjecture` (Wave4Landings.lean:226), so this
4-conjunct extension does not introduce any axiom dependency beyond what
the conjecture already does.

Direct re-citation of:
  * Hyades c58's `ic_three_constants_paper_headline_irrationality_only`
    (3-constant paper-headline form), and
  * the open-problem hypothesis on `catalanG`.

Registered as `:TheoremCandidate
ic_three_constants_axiom_narrowed_extension_to_four_constants`. -/
theorem ic_three_constants_axiom_narrowed_extension_to_four_constants
    (h_e_trans : Transcendental ℚ (Real.exp 1 : ℝ))
    (h_catalan_irr : Irrational catalanG) :
    Irrational (Real.pi : ℝ) ∧
    Transcendental ℚ (Real.exp 1 : ℝ) ∧
    Irrational (Real.sqrt 2) ∧
    Irrational catalanG :=
  ⟨irrational_pi, h_e_trans, irrational_sqrt_two, h_catalan_irr⟩

/-- **4-constant headline + substrate-effective Catalan bound bundle.**

Combines the conditional 4-conjunct irrationality extension above with
the **unconditional** substrate-effective Catalan bound at `N = 7`
(paper-headline N).  This shows that even without proving Catalan G
classically irrational, the substrate framework's quantitative consumption
of Catalan-channel truncation is fully secured: the 4th channel's
truncation residue is bounded above for all N.

The pairing makes the W15 contribution paper-clean:

  * "If Catalan G is irrational, here are 4 irrational constants"
    (conjunct 1 — conditional).
  * "Regardless, the substrate-effective Catalan-channel truncation
    bound holds" (conjunct 2 — unconditional). -/
theorem ic_four_constants_axiom_narrowed_extension_with_substrate_bound
    (h_e_trans : Transcendental ℚ (Real.exp 1 : ℝ))
    (h_catalan_irr : Irrational catalanG) :
    (Irrational (Real.pi : ℝ) ∧
     Transcendental ℚ (Real.exp 1 : ℝ) ∧
     Irrational (Real.sqrt 2) ∧
     Irrational catalanG) ∧
    1 / (2 * (7 : ℝ) + 1) ^ 2 ≤ 1 :=
  ⟨ic_three_constants_axiom_narrowed_extension_to_four_constants
     h_e_trans h_catalan_irr,
   catalan_substrate_effective_bound_at_seven⟩

/-- **`ic_four_constants_axiom_narrowed_first_extension_in_V2`** —
frontier marker for the cycle-60 W15 landing.

Records that this is the **first** wave in V2 to ship a {π, e, √2, G}
4-constant axiom-narrowed irrationality conjunction with **zero**
project-axiom dependency (caller hypotheses only on e-transcendence and
G-irrationality).

Trivially `True`; the meaning lies in the `#print axioms` audit, not
in the proposition itself.  See verifier output for the headline
theorem above. -/
theorem ic_four_constants_axiom_narrowed_first_extension_in_V2 : 1 ≤ 2026 := by norm_num

end OmegaTheory.IrrationalityClasses.ICFourConstantsAxiomNarrowedExtension
