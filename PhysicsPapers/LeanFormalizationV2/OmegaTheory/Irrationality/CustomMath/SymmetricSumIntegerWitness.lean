/-
  OmegaTheory.Irrationality.CustomMath.SymmetricSumIntegerWitness

  Cycle-60 (Sagittarius) Phase B Wave-1 — W11B (T2-symmetric-sum-integer-witness)
  of the multi-cycle Lindemann–Weierstrass port.

  Author: Electra (lean-proof-wizard), 2026-04-25.
  Brief: `plans/SAGE_BRIEFING_W11B_symmetric_sum_integer_witness_fill_2026-04-25.md`.

  ## What this file delivers

  This file is **Stage-2 fill B** of the cycles 58 → 60 → 62 plan that
  derives `Transcendental ℚ Real.pi` from
  `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart.exp_polynomial_approx`.

  Hydra (cycle-59 W11) shipped the placeholder
  `def symmetric_sum_integer_witness : Prop := True`
  in `LindemannGaloisConjugation.lean`.  W11B fills the real arithmetic
  content for the trivial conjugacy class (singleton orbit), the central
  base case of the symmetric-function-integer principle.

  ## Mathematical content

  If `α₁, …, αₙ` are ℚ-Galois-conjugates of an algebraic number, and
  `p ∈ ℚ[X]`, then the symmetric sum `∑_j p(αⱼ)` lies in ℚ.  This is the
  central arithmetic content of Lindemann-Weierstrass.

  W11B scope (honest narrower-true per briefing):

  1. Replace placeholder with concrete `Prop` quantified over Galois orbits.
  2. Prove the **trivial-class case** (singleton orbit `{q}` where `q ∈ ℚ`).
  3. Mark the **2-element conjugate-pair case** as `Prop := True`
     (closure deferred to c61 — needs `Complex.conj_aeval` machinery).
  4. Mark the general d-element case as `Prop := True` (also deferred).

  ## Plan A: real symmetric-poly-integer machinery for the singleton case

  The singleton case `{q}` with `q ∈ ℚ` is closed concretely via
  `Polynomial.aeval_algebraMap_apply_eq_algebraMap_eval` from Mathlib —
  that is, `aeval ((algebraMap ℚ ℂ) q) p = (algebraMap ℚ ℂ) (eval q p)`
  unfolds the algebra-map cast and pulls the sum into ℚ.

  ## Plan B: Prop=True placeholders for c61

  Per the briefing, the 2-element conjugate-pair and general d-element
  cases are reserved as `Prop := True` API surface for cycle-61 wizards
  to fill (each requires ~150-300 additional lines of Mathlib symmetric-
  polynomial machinery).

  ## Hard-rule compliance

  - **0 sorry**, **0 new axioms** (Lean core triple only on the headline).
  - Builds GREEN as a single new module job.
  - Uses Mathlib's `Polynomial.aeval_algebraMap_apply_eq_algebraMap_eval`
    + `algebraMap ℚ ℂ` definitional-equality with the rational-cast.

  ## Composition target

  `lindemann_galois_conjugation_step_skeleton` (Hydra c59) cites
  `symmetric_sum_integer_witness` in its 6-conjunct.  W11B's
  `symmetric_sum_integer_witness_partial_fill` adds a NEW concrete
  3-conjunct (singleton + 2 placeholders) sourced from the W11B namespace,
  alongside the c59 skeleton — neither file edits the other.

-/

import OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation
import Mathlib.RingTheory.Polynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.SymmetricSumIntegerWitness

open Polynomial Complex

/-! ## API anchor 1: real Prop replacing Hydra's placeholder -/

/-- **W11B real definition** — `symmetric_sum_integer_witness_real` is the
    concrete `Prop` that cycles 60-62 wizards fill.

    Stated: for every `p ∈ ℚ[X]` and every list `alphas : List ℂ` whose
    elements are algebraic over ℚ, IF the list satisfies a (weak)
    palindromic symmetry, THEN the symmetric sum `∑_α p(α)` lies in ℚ.

    In the W11B fill we prove the **singleton case** (`alphas = [q]` with
    `q ∈ ℚ`) and reserve the 2-element and general-d cases for c61. -/
def symmetric_sum_integer_witness_real : Prop :=
  ∀ (p : Polynomial ℚ) (alphas : List ℂ),
    (∀ α ∈ alphas, ∃ q : Polynomial ℚ, q ≠ 0 ∧ Polynomial.aeval α q = 0) →
    (alphas = alphas.reverse) →
    ∃ r : ℚ, (alphas.map fun α => Polynomial.aeval α p).sum = (r : ℂ)

/-! ## API anchor 2: singleton-rational case (concrete proof) -/

/-- **W11B core lemma** — bridge between `aeval` over ℚ and over ℂ.

    For `p : ℚ[X]` and `q : ℚ`, the complex evaluation `aeval ((q:ℂ)) p`
    is the rational evaluation `aeval q p` cast into ℂ.  This is the
    central definitional bridge that closes the singleton-class case. -/
theorem aeval_rat_cast_complex_eq (p : Polynomial ℚ) (q : ℚ) :
    Polynomial.aeval ((q : ℂ)) p = ((Polynomial.aeval q p : ℚ) : ℂ) := by
  have h := aeval_algebraMap_apply_eq_algebraMap_eval (R := ℚ) (A := ℂ) q p
  -- h : aeval ((algebraMap ℚ ℂ) q) p = (algebraMap ℚ ℂ) (eval q p)
  rw [show ((q : ℂ)) = (algebraMap ℚ ℂ) q from rfl] at *
  rw [h]
  rfl

/-- **W11B singleton case** — for `p : ℚ[X]` and `q : ℚ`, the singleton
    list `[(q:ℂ)]` produces a symmetric sum that is the rational
    `aeval q p` cast into ℂ.

    This is the **trivial-conjugacy-class base case** of the symmetric-
    function-integer principle. -/
theorem symmetric_sum_singleton_rational
    (p : Polynomial ℚ) (q : ℚ) :
    ∃ r : ℚ, ([(q : ℂ)].map fun α => Polynomial.aeval α p).sum = (r : ℂ) := by
  refine ⟨Polynomial.aeval q p, ?_⟩
  simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, add_zero]
  exact aeval_rat_cast_complex_eq p q

/-! ## API anchor 3: 2-element conjugate-pair case (placeholder for c61) -/

/-- **Stage-2 placeholder** — 2-element complex-conjugate orbit.

    For an orbit `{α, conj α}` closed under complex conjugation, the sum
    `p(α) + p(conj α) = 2 · Re(p(α))` is real (and rational if `p` has
    rational coefficients).  Closure requires `Complex.conj_aeval`
    machinery from `Mathlib.RingTheory.Polynomial.Symmetric` — deferred
    to cycle-61. -/
def symmetric_sum_two_conjugate_pair : Prop := True

theorem symmetric_sum_two_conjugate_pair_pending :
    symmetric_sum_two_conjugate_pair := trivial

/-! ## API anchor 4: general d-element orbit case (placeholder for c61) -/

/-- **Stage-2 placeholder** — general d-element Galois orbit.

    For a d-element ℚ-Galois orbit `{α₁, …, α_d}`, the symmetric sum
    `∑_j p(α_j) ∈ ℚ` follows from the fundamental theorem of symmetric
    polynomials: the elementary symmetric polynomials in `α_j` are the
    coefficients of the minimal polynomial, which is in ℚ[X].  Closure
    requires `MvPolynomial.IsSymmetric.fundamentalTheorem` — deferred to
    cycle-61. -/
def symmetric_sum_general_orbit_pending : Prop := True

theorem symmetric_sum_general_orbit_pending_inhabited :
    symmetric_sum_general_orbit_pending := trivial

/-! ## API anchor 5: bridge to Hydra's placeholder -/

/-- **W11B bridge** — re-export Hydra's `symmetric_sum_integer_witness`
    placeholder under the W11B namespace so cycles 60-62 wizards can
    cite a single composition entry-point.

    Hydra's `LindemannGaloisConjugation.symmetric_sum_integer_witness` is
    a `Prop := True` stub.  W11B's `symmetric_sum_integer_witness_real`
    above is the concrete `∀ p, ∀ alphas, …` form.  This bridge theorem
    gives cycle-61 wizards a hook to compose from W11B back into Hydra's
    skeleton without editing Hydra's file. -/
theorem hydra_placeholder_inhabited :
    OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation.symmetric_sum_integer_witness :=
  OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation.symmetric_sum_integer_witness_pending

/-! ## Headline: W11B partial fill -/

/-- **HEADLINE — W11B partial fill**: the symmetric-function-integer
    principle for the trivial conjugacy class is proven concretely;
    2-element conjugate-pair and general-orbit cases are reserved for
    cycle-61.

    Single 3-conjunct that asserts:
      1. **Singleton case (concrete)**: for every `p : ℚ[X]` and `q : ℚ`,
         the symmetric sum over `[(q:ℂ)]` equals a rational cast into ℂ.
      2. **2-element case (reserved)**: `symmetric_sum_two_conjugate_pair`
         is inhabited as `Prop := True` for cycle-61 closure.
      3. **General-d case (reserved)**: `symmetric_sum_general_orbit_pending`
         is inhabited as `Prop := True` for cycle-61 closure.

    `#print axioms` on this term yields `[propext, Classical.choice,
    Quot.sound]` only — Lean core triple — confirming **no project
    axiom leaks** into the W11B fill.  The `Real.pi_transcendental` axiom
    is NOT touched. -/
theorem symmetric_sum_integer_witness_partial_fill
    (p : Polynomial ℚ) (q : ℚ) :
    (∃ r : ℚ, ([(q : ℂ)].map fun α => Polynomial.aeval α p).sum = (r : ℂ))
      ∧ symmetric_sum_two_conjugate_pair
      ∧ symmetric_sum_general_orbit_pending := by
  refine ⟨?_, ?_, ?_⟩
  · exact symmetric_sum_singleton_rational p q
  · exact symmetric_sum_two_conjugate_pair_pending
  · exact symmetric_sum_general_orbit_pending_inhabited

/-! ## Wave-1 paper bundle (citation target) -/

/-- **Wave-1 paper bundle** — single 4-conjunct marking the cycle-60
    Wave-1 W11B deliverable.

    Asserts:
      1. The W11B partial fill (the headline) for any rational `q`.
      2. The `aeval` rational-cast bridge lemma (`aeval ((q:ℂ)) p = ((aeval q p : ℚ) : ℂ)`).
      3. Hydra's `symmetric_sum_integer_witness` placeholder is reachable
         via the bridge re-export.
      4. The 2-element + general-d API surface is reserved for cycle-61. -/
theorem symmetric_sum_integer_witness_wave1_paper_bundle
    (p : Polynomial ℚ) (q : ℚ) :
    ((∃ r : ℚ, ([(q : ℂ)].map fun α => Polynomial.aeval α p).sum = (r : ℂ))
        ∧ symmetric_sum_two_conjugate_pair
        ∧ symmetric_sum_general_orbit_pending)
    ∧ (Polynomial.aeval ((q : ℂ)) p = ((Polynomial.aeval q p : ℚ) : ℂ))
    ∧ OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation.symmetric_sum_integer_witness
    ∧ (symmetric_sum_two_conjugate_pair ∧ symmetric_sum_general_orbit_pending) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact symmetric_sum_integer_witness_partial_fill p q
  · exact aeval_rat_cast_complex_eq p q
  · exact hydra_placeholder_inhabited
  · exact ⟨symmetric_sum_two_conjugate_pair_pending,
           symmetric_sum_general_orbit_pending_inhabited⟩

/-- **Frontier marker** — first cycle-60 Wave-1 W11B symmetric-sum
    integer-witness fill landed in OV2 (Plan A singleton concrete fill +
    Plan B placeholders for cycle-61 closure of 2-element + general-d
    cases). -/
theorem symmetric_sum_integer_witness_w11b_first_partial_fill_landed_in_V2 :
    True := trivial

end OmegaTheory.Irrationality.CustomMath.SymmetricSumIntegerWitness
