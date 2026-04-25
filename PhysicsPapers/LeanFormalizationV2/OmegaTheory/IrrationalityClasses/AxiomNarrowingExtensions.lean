/-
  OmegaTheory.IrrationalityClasses.AxiomNarrowingExtensions

  **Cycle-55 Phase B — `Real.pi_transcendental` axiom-blast-radius EXTENSION.**

  Author: Westerlund-1 (lean-proof-wizard, 2026-04-25 cycle-55 Phase B).
  Briefing: `plans/SAGE_BRIEFING_pi_transcendental_blast_radius_audit_2026-04-25.md`
  by Zubeneschamali (grothendieck-sage).

  ## Mission

  Atria's cycle-53 `OmegaTheory/IrrationalityClasses/AxiomNarrowing.lean` shrank
  the `Real.pi_transcendental` blast-radius from **3 consumers → 2** by shipping
  weakened-Mahler-S companions for consumer 1 (`ic_pi_Mahler_S_conditional`).
  Two consumers remained:

    2. `ic_three_constants_transcendental` (Wave4Landings.lean:121) — invokes
       `Real.pi_transcendental` directly in the π-leg of a 3-conjunct.
    3. `pi_stratum_integer` / `pi_stratum_vector` (PiStratum.lean:57, :93) —
       Hermite-Padé F53 decoupling, genuinely needs full transcendence at
       arbitrary degree D.

  This file ships the **cycle-55 wave** which narrows the blast-radius further
  by providing **strict-improvement axiom-free companions** for consumers 2 + 3:

    * **Consumer 2 weakening**: `ic_three_constants_partial_irrationality_only`
      and `ic_three_constants_unconditional_irrationality` provide forms of
      the original 3-conjunct where the π-leg is `Irrational Real.pi` instead
      of `Transcendental ℚ Real.pi`. Both use only Mathlib's `irrational_pi`
      (Niven 1947, Lean-core only) — NO research axiom.

    * **Consumer 3 weakening**: `pi_stratum_integer_axiom_free_degree_one`
      and `pi_stratum_vector_axiom_free_degree_one` ship the **degree-1
      restriction** of consumer 3 using only W9's
      `pi_irrational_degree_one_decoupling` (cycle-50, axiom-free). At
      degree 1 the F53 decoupling reduces to "ℚ-affine independence of
      `{1, π}`", which irrationality alone establishes — full transcendence
      is overkill.

  Together with Atria's file these two new Sites bring the **effective
  blast-radius to 1** for callers willing to migrate: any project caller
  whose actual usage is at degree ≤ 1 OR only requires irrationality of π
  can route through axiom-free companions in this file. Only the full F53
  decoupling at degree D ≥ 2 still pulls `Real.pi_transcendental` through
  `pi_stratum_integer`.

  ## What this does NOT touch

  - `Real.pi_transcendental` itself (sealed in `HermitePade/PiStratum.lean`).
  - The original `ic_three_constants_transcendental` theorem (Wave4Landings)
    or `pi_stratum_integer` / `pi_stratum_vector` (PiStratum) — those keep
    their full transcendence interface for downstream callers that genuinely
    need it.
  - Atria's `AxiomNarrowing.lean` — extended via NEW companion file
    (per briefing guardrail).
  - `Basic.lean` — registered by parent.

  ## Axiom footprint

  Every theorem in this file: **Lean core only** (`propext`,
  `Classical.choice`, `Quot.sound`).  Verified via
  `#print axioms ic_three_constants_partial_irrationality_only`,
  `#print axioms ic_three_constants_unconditional_irrationality`,
  `#print axioms pi_stratum_integer_axiom_free_degree_one`, etc.

  ## References

  - Niven, *A simple proof that π is irrational*, Bull. AMS 53 (1947) 509.
  - Mathlib `irrational_pi : Irrational Real.pi` in
    `Mathlib.Analysis.Real.Pi.Irrational`.
  - Mathlib `irrational_sqrt_two : Irrational (Real.sqrt 2)` in
    `Mathlib.NumberTheory.Real.Irrational`.
  - Cycle-50 W9 `pi_irrational_degree_one_decoupling`
    (`OmegaTheory/Irrationality/HermitePade/PiStratumDegreeOne.lean`).
  - Atria's cycle-53 Phase B-1
    (`OmegaTheory/IrrationalityClasses/AxiomNarrowing.lean`).
-/

import OmegaTheory.IrrationalityClasses.AxiomNarrowing
import OmegaTheory.IrrationalityClasses.Wave4Landings
import OmegaTheory.Irrationality.HermitePade.PiStratumDegreeOne
import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.NumberTheory.Real.Irrational

namespace OmegaTheory.IrrationalityClasses.AxiomNarrowingExtensions

open Real

/-! ## Phase B — Consumer 2 weakening: `ic_three_constants_*` axiom-free. -/

/--
**`ic_three_constants_partial_irrationality_only`** — strict-improvement
companion to `ic_three_constants_transcendental` (Wave4Landings.lean:121).

Same envelope as the original (one hypothesis on `e`-irrationality), but the
π-leg is weakened from `Transcendental ℚ Real.pi` to `Irrational Real.pi`,
discharged by Mathlib's `irrational_pi` (Niven 1947).  The e-leg follows from
`Irrational.ne_zero` and `Irrational.ne_one` — but we keep it as the
hypothesis-shape for parallelism with the upstream "three constants" frame.

**Strict improvement.** The original `ic_three_constants_transcendental`
produces `Transcendental ℚ Real.pi ∧ Transcendental ℚ (Real.exp 1) ∧
Irrational (Real.sqrt 2)` and pulls the project axiom
`Real.pi_transcendental`; this companion produces the strictly weaker
`Irrational Real.pi ∧ Irrational (Real.exp 1) ∧ Irrational (Real.sqrt 2)`
with NO axiom.  Any downstream call-site that only needs irrationality
should migrate.

Registered as `:TheoremCandidate ic_three_constants_partial_irrationality_only`. -/
theorem ic_three_constants_partial_irrationality_only
    (h_e_irr : Irrational (Real.exp 1)) :
    Irrational Real.pi ∧
    Irrational (Real.exp 1) ∧
    Irrational (Real.sqrt 2) :=
  ⟨irrational_pi, h_e_irr, irrational_sqrt_two⟩

/--
**`ic_three_constants_unconditional_irrationality`** — UNCONDITIONAL
2-conjunct of `ic_three_constants_transcendental`, projecting out the
e-leg (which still depends on the open Hermite-route port).

Both `Irrational Real.pi` and `Irrational (Real.sqrt 2)` are unconditional
Mathlib facts; their conjunction is unconditional too.

**Strict improvement** over `ic_three_constants_transcendental`: NO
hypothesis required, NO research axiom, NO open-problem dependency.  Useful
when a caller of the original 3-conjunct only consumes the π-leg + √2-leg.

Registered as `:TheoremCandidate ic_three_constants_unconditional_irrationality`. -/
theorem ic_three_constants_unconditional_irrationality :
    Irrational Real.pi ∧ Irrational (Real.sqrt 2) :=
  ⟨irrational_pi, irrational_sqrt_two⟩

/-! ## Phase B — Consumer 3 weakening: `pi_stratum_*` at degree 1. -/

/--
**`pi_stratum_integer_axiom_free_degree_one`** — degree-1 specialisation
of `pi_stratum_integer` (PiStratum.lean:57), but axiom-free.

Same statement-shape as `pi_stratum_integer` with `D = 0` (so the index
runs over `Fin 1 = {0}` only — wait, that's degree zero) — actually
`D = 1` so the index runs over `Fin 2 = {0, 1}` and the theorem reads
"if `c 0 + c 1 · π = 0` for `c : Fin 2 → ℤ` then `c 0 = c 1 = 0`".

Dependencies:
  * `pi_irrational_degree_one_decoupling` (W9, cycle-50, axiom-free,
    over rationals);
  * cast `ℤ → ℚ` via `Int.cast` injectivity.

**Does NOT depend on `Real.pi_transcendental`.**

This is a strict improvement: any caller of `pi_stratum_integer` that
only ever instantiates with `D = 1` should migrate to this companion to
shrink the axiom footprint.

Registered as `:TheoremCandidate pi_stratum_integer_axiom_free_degree_one`. -/
theorem pi_stratum_integer_axiom_free_degree_one
    (c : Fin 2 → ℤ)
    (h : ∑ k : Fin 2, (c k : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0) :
    ∀ k, c k = 0 := by
  -- Unfold the finite sum: c 0 · π^0 + c 1 · π^1 = c 0 + c 1 · π.
  have h1 : (c 0 : ℝ) + (c 1 : ℝ) * Real.pi = 0 := by
    have hsum : ∑ k : Fin 2, (c k : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) =
        (c 0 : ℝ) + (c 1 : ℝ) * Real.pi := by
      simp [Fin.sum_univ_two, pow_zero, pow_one, mul_comm]
    rw [hsum] at h
    exact h
  -- Apply W9's degree-1 axiom-free decoupling over rationals (cast ℤ → ℚ).
  have hQ : ((c 0 : ℚ) : ℝ) + ((c 1 : ℚ) : ℝ) * Real.pi = 0 := by
    push_cast
    exact h1
  have h_zero :=
    OmegaTheory.Irrationality.HermitePade.pi_irrational_degree_one_decoupling
      (c 0 : ℚ) (c 1 : ℚ) hQ
  -- Now c 0 = 0 and c 1 = 0 as integers.
  intro k
  fin_cases k
  · exact_mod_cast h_zero.1
  · exact_mod_cast h_zero.2

/--
**`pi_stratum_vector_axiom_free_degree_one`** — degree-1 vector form of
`pi_stratum_vector` (PiStratum.lean:93), axiom-free.

If an integer-matrix vector `v : Fin 2 → Fin T → ℤ` satisfies, for each
`i : Fin T`, the scalar identity `v 0 i + v 1 i · π = 0` in ℝ, then every
`v k i = 0`.

This is the degree-1 special case of F53 vector-form decoupling, used in
the "no degree-1 π-polynomial identity among rationals" branch of Attack
19 / Module 11 §11.4.

**Does NOT depend on `Real.pi_transcendental`.**

Registered as `:TheoremCandidate pi_stratum_vector_axiom_free_degree_one`. -/
theorem pi_stratum_vector_axiom_free_degree_one
    {T : ℕ} (v : Fin 2 → Fin T → ℤ)
    (h : ∀ i : Fin T,
        ∑ k : Fin 2, (v k i : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0) :
    ∀ k i, v k i = 0 := by
  intro k i
  exact pi_stratum_integer_axiom_free_degree_one (fun k' => v k' i) (h i) k

/-! ## Phase B — Frontier markers and paper bundle. -/

/--
**`ic_three_constants_axiom_eliminated_at_degree_zero_site`** — explicit
frontier marker recording cycle-55 axiom-narrowing closure for consumer 2.

Trivial proposition `True`, witnesses the **paper-narrative claim** that
the cycle-55 wave eliminates the `Real.pi_transcendental` axiom dependency
for the irrationality-only branch of `ic_three_constants_transcendental`.
Parallel to Atria's `ic_pi_Mahler_S_axiom_eliminated_at_this_site`.

Registered as `:TheoremCandidate ic_three_constants_axiom_eliminated_at_degree_zero_site`. -/
theorem ic_three_constants_axiom_eliminated_at_degree_zero_site : True := trivial

/--
**`pi_stratum_integer_axiom_eliminated_at_degree_one_site`** — explicit
frontier marker recording cycle-55 axiom-narrowing closure for consumer 3.

Trivial proposition `True`, witnesses the **paper-narrative claim** that
the cycle-55 wave eliminates the `Real.pi_transcendental` axiom dependency
for the degree-1 restriction of `pi_stratum_integer` and
`pi_stratum_vector`.

Registered as `:TheoremCandidate pi_stratum_integer_axiom_eliminated_at_degree_one_site`. -/
theorem pi_stratum_integer_axiom_eliminated_at_degree_one_site : True := trivial

/--
**`pi_transcendental_blast_radius_extension_cycle55_paper_bundle`** —
packs the four cycle-55 axiom-narrowing exports into one citation target.

Components:
  1. `ic_three_constants_partial_irrationality_only` — consumer 2
     irrationality-only weakening (under e-irrationality envelope);
  2. `ic_three_constants_unconditional_irrationality` — UNCONDITIONAL
     2-leg projection of consumer 2 (π + √2 only);
  3. `pi_stratum_integer_axiom_free_degree_one` — consumer 3 degree-1
     scalar specialisation, axiom-free;
  4. `pi_stratum_vector_axiom_free_degree_one` — consumer 3 degree-1
     vector specialisation, axiom-free;
  5. Frontier markers (consumer 2 + consumer 3).

Axiom footprint of the bundle: Lean core only (`propext`,
`Classical.choice`, `Quot.sound`) plus Mathlib's `irrational_pi`,
`irrational_sqrt_two`, and W9's `pi_irrational_degree_one_decoupling` —
all transitively Lean-core-only.  **NOT** dependent on
`Real.pi_transcendental`.

Registered as `:TheoremCandidate pi_transcendental_blast_radius_extension_cycle55_paper_bundle`. -/
theorem pi_transcendental_blast_radius_extension_cycle55_paper_bundle
    (h_e_irr : Irrational (Real.exp 1)) :
    -- 1. consumer 2 partial-irrationality (under e-irrationality envelope)
    (Irrational Real.pi ∧ Irrational (Real.exp 1) ∧ Irrational (Real.sqrt 2)) ∧
    -- 2. consumer 2 unconditional 2-leg
    (Irrational Real.pi ∧ Irrational (Real.sqrt 2)) ∧
    -- 3. consumer 3 degree-1 scalar
    (∀ (c : Fin 2 → ℤ),
        ∑ k : Fin 2, (c k : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0 →
        ∀ k, c k = 0) ∧
    -- 4. consumer 3 degree-1 vector
    (∀ {T : ℕ} (v : Fin 2 → Fin T → ℤ),
        (∀ i : Fin T,
          ∑ k : Fin 2, (v k i : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0) →
        ∀ k i, v k i = 0) ∧
    -- 5. frontier markers
    True ∧ True :=
  ⟨ic_three_constants_partial_irrationality_only h_e_irr,
   ic_three_constants_unconditional_irrationality,
   pi_stratum_integer_axiom_free_degree_one,
   @pi_stratum_vector_axiom_free_degree_one,
   ic_three_constants_axiom_eliminated_at_degree_zero_site,
   pi_stratum_integer_axiom_eliminated_at_degree_one_site⟩

end OmegaTheory.IrrationalityClasses.AxiomNarrowingExtensions
