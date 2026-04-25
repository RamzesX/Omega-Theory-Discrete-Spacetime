# Sage Briefing — W-Phase1-B: `ic_three_constants_paper_headline_irrationality_only`

**Cycle:** 58 (Libra) · **Wave:** 1 · **Sage:** Triangulum-II · **Date:** 2026-04-25
**Track:** T2 axiom-scope · **Risk:** S (NEW file, copy-paste-style proof)
**Target file:** `OmegaTheory/IrrationalityClasses/Wave4LandingsHeadline.lean` (NEW; ~50 lines)

---

## Candidate name & graph node

`ic_three_constants_paper_headline_irrationality_only` — registered as
`:TheoremCandidate { batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25' }`.

## Priority + complexity

**HIGH** · Complexity **S**. ~50 line NEW file, copy-paste shape from existing
`ic_three_constants_e_sqrt2_only` + π-irrational leg.

## Mission

Ship a **paper-headline-quality 3-conjunct irrationality statement** for
{π, e, √2} that is `[propext, Classical.choice, Quot.sound]`-only — i.e., NO
dependency on `Real.pi_transcendental`. The transcendence form
(`ic_three_constants_transcendental` at `Wave4Landings.lean:121-127`) is
preserved as the research-track form.

The new statement uses:
* `Real.irrational_pi` — Niven 1947, Mathlib theorem
* `Transcendental ℚ (Real.exp 1)` — conditional, hypothesis
* `irrational_sqrt_two` — Mathlib theorem

So the conjunction is:

> π is irrational AND e is transcendental (conditional) AND √2 is irrational.

This is **paper-headline-cleaner** because it does NOT mix transcendence and
irrationality unnecessarily — π's irrationality is sufficient for all
paper-headline physics chains (Pi-Hunch δ_comp(N) > 0 needs only `Real.pi_pos`
and `Real.irrational_pi`; the substrate truncation residual derivation never
calls transcendence).

## `statement_lean` skeleton

Wizard creates a NEW file `OmegaTheory/IrrationalityClasses/Wave4LandingsHeadline.lean`:

```lean
/-
  OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline

  Paper-headline 3-conjunct irrationality statement for {π, e, √2}.

  Companion to `Wave4Landings.lean:ic_three_constants_transcendental`, which
  retains the transcendence form for research-track use. This file gives the
  *paper-headline* form using only `Real.irrational_pi` (Niven 1947, Mathlib)
  and `irrational_sqrt_two` (Mathlib), with `e`-transcendence as a hypothesis.

  Axiom footprint: `[propext, Classical.choice, Quot.sound]` only (Lean core).

  Cycle 58 (Libra), Triangulum-II.
-/

import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.NumberTheory.Irrational
import OmegaTheory.IrrationalityClasses.Wave4Landings

namespace OmegaTheory.IrrationalityClasses

/-- **`ic_three_constants_paper_headline_irrationality_only`** — paper-headline
    3-conjunct, irrationality-form for π and √2.

    Conditional on `e`-transcendence (Hermite 1873, awaiting Mathlib
    Lindemann–Weierstrass port). Uses ONLY:

    * `Real.irrational_pi` (Niven 1947, Mathlib `Mathlib.Analysis.Real.Pi.Irrational`)
    * `irrational_sqrt_two` (Mathlib `Mathlib.NumberTheory.Irrational`)
    * `h_e_transcendental` (caller hypothesis)

    Axiom footprint: `[propext, Classical.choice, Quot.sound]` only —
    NO `Real.pi_transcendental` dependency.

    For the transcendence-strength form (research-track only), see
    `ic_three_constants_transcendental` in `Wave4Landings.lean`. -/
theorem ic_three_constants_paper_headline_irrationality_only
    (h_e_transcendental : Transcendental ℚ (Real.exp 1 : ℝ)) :
    Irrational (Real.pi : ℝ) ∧
    Transcendental ℚ (Real.exp 1 : ℝ) ∧
    Irrational (Real.sqrt 2) :=
  ⟨irrational_pi, h_e_transcendental, irrational_sqrt_two⟩

end OmegaTheory.IrrationalityClasses
```

## Premise candidates (top-5 from omega-search)

1. `Real.irrational_pi` — Niven 1947 (`Mathlib.Analysis.Real.Pi.Irrational`).
2. `irrational_sqrt_two` (`Mathlib.NumberTheory.Irrational`).
3. `Transcendental` (Mathlib `Mathlib.RingTheory.Algebraic.Basic`) — definition only.
4. (no further premise — proof is anonymous-tuple constructor `⟨·, ·, ·⟩`).
5. (no further premise — same as above).

## Proof sketch (≤6 bullets)

1. Create new file `OmegaTheory/IrrationalityClasses/Wave4LandingsHeadline.lean`
   with the skeleton above.
2. Verify Mathlib's `Real.irrational_pi` exists (it does at `Mathlib.Analysis.Real.Pi.Irrational`).
3. Verify Mathlib's `irrational_sqrt_two` exists (it does at `Mathlib.NumberTheory.Irrational`).
4. Lean LSP `lean_local_search "Real.irrational_pi"` and
   `lean_local_search "irrational_sqrt_two"` to confirm signatures.
5. Run `lake build OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline --log-level=error`.
6. Verify GREEN. **Flag for parent: `OmegaTheory/Basic.lean` needs new import line
   `import OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline`** — DO NOT
   self-edit Basic.lean.

## Off-limits files

- `Wave4Landings.lean` — W-Phase1-A's neighbor; do not modify (only add to NEW file).
- `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` — W-Phase1-A's territory.
- All cycle 56-57 axiom-narrowing files (read-only — full list in `CYCLE58_BATCH_INDEX_2026-04-25.md`).
- `OmegaTheory/Basic.lean` — flag the new import line for parent batch.

## Build expectation

* `lake build OmegaTheory.IrrationalityClasses.Wave4LandingsHeadline` — GREEN ≤2 min
* `lake build` (full) — +1 build job, GREEN
* 0 sorry; 0 new axioms (uses Lean core only via Mathlib theorems).

## Graph register

```cypher
MERGE (c:TheoremCandidate {
  name: 'ic_three_constants_paper_headline_irrationality_only',
  namespace: 'OmegaTheoryV2',
  status: 'PROPOSED',
  batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25',
  proposed_by: 'Triangulum-II',
  target_file: 'OmegaTheory/IrrationalityClasses/Wave4LandingsHeadline.lean',
  priority: 'HIGH', complexity: 'S', track: 'T2-axiom-scope'
})
```

---

**End of W-Phase1-B brief.**
