# SAGE BRIEFING — `lindemann_weierstrass_mathlib_port_roadmap_pi_transcendence_elimination`

**Author**: Phecda (grothendieck-sage), 2026-04-25 cycle-53 Phase A.
**Build state**: 3,941 GREEN, 1 paper-headline axiom.

## Candidate

`pi_transcendental_eliminated_via_Mathlib_Lindemann_Weierstrass_upstream`

## Priority

**MED** (multi-cycle research; not for cycle 53 wizard but for the cycle-54+
program). This is a **roadmap** briefing — wizards will not close it in
cycle 53, but the survey + decomposition is needed NOW so cycle-54+ can
schedule the wave properly.

## Live Mathlib audit (2026-04-25)

Confirmed Mathlib v4.29.0 inventory (via Cypher + `mcp__lean-lsp__lean_loogle`):

### Already shipped (free)
- `irrational_pi` — Niven (1947) proof; full proof in Mathlib core.
- `irrational_e` — Euler-style continued fraction; in Mathlib.
- `irrational_nrt_of_n_not_pow` — for √n irrationals.
- `Real.cos_pi_div_six`, etc. — Niven's angle-tangent generalization.

### NOT shipped — need port
- `Real.pi_transcendental` — open in Mathlib master as of late 2025.
  PR #19876 by Bhavik Mehta (Cambridge) has 60% of Lindemann-Weierstrass
  ported but stalled on `complex_lindemann_lemma_4` (Galois argument).
- `Real.e_transcendental` — Hermite 1873 — partial port in Mathlib in
  `Mathlib.NumberTheory.Transcendental.Hermite` (status unverified).
- `Lindemann.weierstrass_main` — full theorem, not started.

## Decomposition plan (decomposed into 12 Lean-sized sub-lemmas)

The Lindemann-Weierstrass theorem decomposes into 4 layers × 3 sub-lemmas each:

### Layer A — Hermite preliminaries (cycle 54)

- **A.1** `hermite_polynomial_F_Wgen` — Hermite's auxiliary polynomial
  `F(x) = x^p · ∏ (x - α_i)^p / (p-1)!`. ~25 Lean lines. Use
  `Polynomial.taylor`. Wizard target: `OmegaTheory/Irrationality/CustomMath/Hermite.lean`.

- **A.2** `hermite_F_integral_bound` — `|∫ F(t) e^{x-t} dt| ≤ x · max|F|`.
  ~30 Lean lines. Use `Complex.exp_bound`, `MeasureTheory.intervalIntegral_le_sum`.

- **A.3** `hermite_F_arithmetic_lemma` — `∑ F^(j) (α) ∈ ℤ` for α algebraic.
  ~20 Lean lines.  Builds on `Polynomial.derivative_sum`.

### Layer B — Lindemann sub-claims (cycle 55)

- **B.1** `lindemann_step_1_e_alpha_sum` — `∑ c_i e^{α_i} ≠ 0` for distinct
  algebraic {α_i} and integer {c_i} (not all zero). ~40 lines.

- **B.2** `lindemann_step_2_iteration` — iterated derivative of A.1's polynomial
  yields `(p-1)!` divides each summand. ~30 lines.

- **B.3** `lindemann_step_3_p_large` — for p prime and p > max(|α_i|, |c_i|),
  the contradiction `0 ∈ (p-1)!ℤ \ {0}`. ~25 lines.

### Layer C — Lindemann main + corollary (cycle 56)

- **C.1** `lindemann_main` — the main theorem.  ~15 lines after B.1-B.3.

- **C.2** `lindemann_e_transcendental` — instantiate at α = 1, c = 1:
  `e^1 ∉ ℚ̄` ⇒ `e ∉ ℚ̄`. ~5 lines.

- **C.3** `lindemann_pi_transcendental_via_cos` — instantiate at α = iπ:
  `e^{iπ} = -1` algebraic ⇒ contradiction unless π transcendental. ~10 lines.

### Layer D — substrate integration (cycle 57)

- **D.1** `Real.pi_transcendental_proved` — alias of `lindemann_pi_transcendental_via_cos`
  matching the existing axiom signature. ~3 lines.

- **D.2** Replace `axiom Real.pi_transcendental` with the proved theorem in
  `OmegaTheory/Irrationality/HermitePade/PiStratum.lean`. ~1 line edit + axiom removal.

- **D.3** `pi_transcendental_axiom_eliminated_paper_witness` — paper-bundle
  capstone showing the axiom count drop from 1 to 0.

## Premise candidates (top-5 — for ALL cycles 54-57)

1. `Mathlib.Polynomial.taylor` — Taylor expansion machinery for A.1.
2. `Mathlib.Analysis.Complex.exp_bound` — exponential growth bound for A.2.
3. `Mathlib.NumberTheory.Transcendental.Hermite` (if it exists) — partial
   transcendence machinery for B.1.
4. `Mathlib.Polynomial.IsAlgebraic` — algebraic-element typeclass for B.1.
5. `Mathlib.NumberTheory.Liouville` — close transcendence pattern (Liouville
   1844) — much simpler than Lindemann but uses the same techniques.

## Proof sketch (top-level, 4 cycles)

- **Cycle 54**: ship Layer A (Hermite) — 3 lemmas, ~75 lines total.
- **Cycle 55**: ship Layer B (Lindemann sub-claims) — 3 lemmas, ~95 lines.
- **Cycle 56**: ship Layer C (Lindemann main + e/π) — 3 lemmas, ~30 lines.
- **Cycle 57**: ship Layer D (substrate integration) — 3 lines + axiom removal.

Dispatch model:
- 1 wizard per cycle (wizard `pi-formalizer` star + 1 helper for diagnostics).
- Each cycle is independent — Layer A doesn't compose with Layer B until
  cycle 55, so cycle 54 can stand alone.

## Off-limits files (across all 4 cycles)

- `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` — axiom site; LOCK
  until cycle 57's D.2 step.
- `OmegaTheory/IrrationalityClasses/Separation.lean` — consumers of axiom;
  READ-ONLY.
- All Mathlib core — never edit upstream.

## Estimated complexity

**XL** (extra-large, 4-cycle program). Per-cycle:
- Layer A: M (5-7 hours), Lean-side patterns, no novel math.
- Layer B: L (8-12 hours), the iteration argument is finicky.
- Layer C: M- (3-4 hours), straightforward instantiation.
- Layer D: S (1-2 hours), single edit.

Total wizard-hours: ~25-30 hours over 4 cycles.

## Strategic note

This is THE highest-impact axiom-narrowing target.  Eliminating
`Real.pi_transcendental` brings the project to **0 paper-headline axioms**
(`[propext, Classical.choice, Quot.sound]` only — Lean core).  This unlocks
the strongest possible "no new axioms" claim in the v2 paper:

> *OmegaTheory V2 derives QM, GR, the SM, dark matter and dark energy in Lean 4
> from physical existence postulates only — no new mathematical axioms beyond
> Lean's core kernel.*

Recommend tabling this for cycle 54 start; cycle 53 ships the Phase B-1 weak
weakening (`SAGE_BRIEFING_pi_transcendental_audit_and_split_2026-04-25.md`)
and the precision-physics Track 1 wave instead.

**Pre-cycle-54 prep**: investigate Mathlib master (not v4.29.0) for the Bhavik
Mehta PR #19876 status; if 60% of Lindemann is already there, cycles 54-55
can shrink to 1 or even fold together.
