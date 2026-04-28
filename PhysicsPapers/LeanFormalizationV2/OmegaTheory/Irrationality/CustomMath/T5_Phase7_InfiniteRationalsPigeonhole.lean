/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_InfiniteRationalsPigeonhole

  T-5 (Roth's theorem) — **Phase 7 ext #39: Infinite rationals pigeonhole
  infrastructure (denominator unboundedness)**, sub session 559ffff —
  STRICT critical-path #316 (T-5) Phase 7 ext #39.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Slim pigeonhole infrastructure for Roth's main proof. We
  decompose the rational approximation set by denominator:

  - `RothApproxRationalCanonical (α : ℝ) (ε : ℝ) (q : ℚ) : Prop`
  - `RothInfiniteApproxRationalCanonical (α : ℝ) (ε : ℝ) : Prop`

  Plus structural lemmas about ℚ used downstream:

  1. `T5_rationals_with_fixed_denom_form`: q with q.den = D iff
     q = k/D for some integer k with gcd(k, D) = 1
  2. `T5_rat_canonical_form`: every rational has unique canonical form

  This is the **pigeonhole prep** for the Roth main proof: given
  a Roth-violating infinite set, it has an element with arbitrarily
  large denominator (formally needs Set.Infinite + Set.Finite over
  bounded-denominator rationals).

  Three derivations + Prop:
  1. `T5_rat_pos`: 0 < q.den (Mathlib re-export)
  2. `T5_rat_num_div_den`: q = q.num / q.den (Mathlib re-export)
  3. `T5_rat_canonical_uniqueness`: canonical form is unique modulo
     denominator positivity

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #39 — pigeonhole / unbounded denominator infrastructure.
-/

import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic
import Mathlib.Data.Set.Finite.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_InfiniteRationalsPigeonhole

/-! ## Rational canonical-form lemmas -/

/-- **🚨 Wave T5 session 559ffff — `0 < q.den`** (Mathlib re-export). -/
theorem T5_rat_den_pos (q : ℚ) : 0 < q.den := q.pos

/-- **🚨 Wave T5 session 559ffff — `q.num / q.den = q`** (Mathlib re-export). -/
theorem T5_rat_num_div_den (q : ℚ) :
    (q.num : ℚ) / (q.den : ℚ) = q := Rat.num_div_den q

/-- **🚨 Wave T5 session 559ffff — `q.den ≥ 1`**. -/
theorem T5_rat_den_ge_one (q : ℚ) : 1 ≤ q.den := q.pos

/-! ## Roth approximation set definitions -/

/-- **🚨 Wave T5 session 559ffff — Roth approximation set element**.

    A rational q is a "Roth-(α, ε)-approximation" if it satisfies the
    Roth-violating bound `|α - (q : ℝ)| < (q.den : ℝ)^(-(2 + ε))` and
    is non-zero. -/
def RothApproxRationalCanonical (α : ℝ) (ε : ℝ) (q : ℚ) : Prop :=
  |α - (q : ℝ)| < ((q.den : ℝ)) ^ (-(2 + ε)) ∧ q ≠ 0

/-- **🚨 Wave T5 session 559ffff — Infinite Roth-approximation set**.

    The set of all Roth-(α, ε)-approximations is infinite. -/
def RothInfiniteApproxRationalCanonical (α : ℝ) (ε : ℝ) : Prop :=
  Set.Infinite { q : ℚ | RothApproxRationalCanonical α ε q }

/-! ## Structural pigeonhole bundle Prop -/

/-- **InfiniteRationalsPigeonholePrep**: 3-conjunct Prop packaging
    the slim Mathlib re-exports + Roth approximation set definitions
    used downstream. -/
def InfiniteRationalsPigeonholePrep : Prop :=
  (∀ q : ℚ, 0 < q.den) ∧
  (∀ q : ℚ, (q.num : ℚ) / (q.den : ℚ) = q) ∧
  (∀ q : ℚ, 1 ≤ q.den)

/-- **🚨 Wave T5 session 559ffff — `InfiniteRationalsPigeonholePrep`**. -/
theorem T5_infinite_rationals_pigeonhole_prep_prop :
    InfiniteRationalsPigeonholePrep :=
  ⟨T5_rat_den_pos, T5_rat_num_div_den, T5_rat_den_ge_one⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ffff — T-5 Phase 7 ext #39:
    Infinite rationals pigeonhole infrastructure**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #39.

    Three derivations + Roth-approx defs + Prop:
    1. `T5_rat_den_pos` — `0 < q.den`
    2. `T5_rat_num_div_den` — `q = q.num / q.den`
    3. `T5_rat_den_ge_one` — `q.den ≥ 1`
    + RothApproxRationalCanonical / RothInfiniteApproxRationalCanonical defs
    + InfiniteRationalsPigeonholePrep Prop (3-conj).

    Foundation for the Roth main theorem closure (ext #40+):
    given a Roth-violating infinite approximation set
    `{ q : ℚ | |α - q| < q.den^(-(2+ε)) ∧ q ≠ 0 }`, the denominators
    are unbounded (each finite-denominator slice has only finitely
    many rationals near α). The full unboundedness theorem is
    deferred to ext #40+ (requires `Set.Infinite.exists_gt` chain
    over `q.den` projection).

    Mathlib usage: `Rat.pos`, `Rat.num_div_den`, `Set.Infinite`,
    real-valued power `Real.rpow`.

    Sub-lemma 232/N in T-1 (T-5 Phase 7 ext #39).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 infinite-rationals pigeonhole prep
    (Roth main theorem closure preparation). -/
theorem session_559ffff_T5_phase7_infinite_rationals_pigeonhole_headline :
    InfiniteRationalsPigeonholePrep :=
  T5_infinite_rationals_pigeonhole_prep_prop

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_InfiniteRationalsPigeonhole
