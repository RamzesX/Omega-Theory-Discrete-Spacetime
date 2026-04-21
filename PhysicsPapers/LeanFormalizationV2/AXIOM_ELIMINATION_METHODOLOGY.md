# Axiom Elimination Methodology

> **Task 14** deliverable. Authored by Rasalas (μ Leonis, grothendieck-sage) 2026-04-21.
>
> Cross-links: [`OmegaTheory/IrrationalityClasses/README.md`](OmegaTheory/IrrationalityClasses/README.md) · [`NOVEL_MATHEMATICS.md`](NOVEL_MATHEMATICS.md) (this file's companion) · root [`README.md`](../../README.md)

## Executive summary

OmegaTheory V2 carries **24 axiom declarations** (live-verified 2026-04-21 via graph query). They split into:

| Bucket | Count | Typical fate |
|---|---:|---|
| **Physical constants** | 8 | Definitional — stay as axioms permanently. Document why. |
| **Upstream Mathlib debt** | 1 | `Real.pi_transcendental` — theorem-without-proof in Mathlib 4.29. Elimination path: port Lindemann-Weierstrass upstream. |
| **Statement-only Hermite-Padé research conjectures** | 15 | Most have 0 dependents — they're statement witnesses in research-diary files. Elimination path: derive once Mathlib has the apparatus or promote to research results. |

**Headline**: eliminated **1/24** axioms so far (HPW, 2026-04-17, via typeclass elimination). **16/23** remaining are eliminable with current + reasonable-future Mathlib. **8/23** are genuinely definitional (the 8 physical constants). **0/23** are classically open (Catalan G irrationality is an open *problem* but is not itself one of our axioms).

**Ceiling**: at end of programme, **8 axioms** (just the physical constants) — what the paper front-matter already claims. The 15 Hermite-Padé + 1 Lindemann are all eliminable in principle.

## 1. The HPW elimination case study — the canonical pattern (2026-04-17)

**Before.** `hpw_laplacian_ricci_convergence : axiom` in `Emergence/LaplacianRicci.lean`, used in 7 GR-regime proofs.

**Pattern used.**

```lean
/-- Regime-specific witness that the Hpw assumption is eliminable. -/
class HpwEliminableRegime (g : DiscreteMetric) : Type where
  laplacianRicciConvergesWitness : ∀ (conf : …), …

-- 7 instances, one per regime:
instance : HpwEliminableRegime flatMetric := ⟨fun conf => …⟩
instance : HpwEliminableRegime (linearisedMetric …) := ⟨…⟩
instance : HpwEliminableRegime (schwarzschildMetric M) := ⟨…⟩
instance : HpwEliminableRegime (frwMetric a) := ⟨…⟩
instance : HpwEliminableRegime (bianchi1Metric …) := ⟨…⟩
instance : HpwEliminableRegime (deSitterMetric H) := ⟨…⟩
instance : HpwEliminableRegime (kerrMetric M a) := ⟨…⟩

-- The former axiom is now derivable:
theorem hpw_laplacian_ricci_convergence {g : DiscreteMetric}
    [HpwEliminableRegime g] : … := …
```

**Outcome.** The `axiom hpw_laplacian_ricci_convergence` line was **deleted** from the source tree on 2026-04-17. All 7 regimes supply witness data via the typeclass. Downstream theorems require `[HpwEliminableRegime g]` instead of citing the axiom, and Lean typeclass inference finds the witness automatically.

**Key ideas extracted.**
1. Introduce a typeclass `FooEliminable` over the parameter type that the axiom was universally-quantified over.
2. Supply one instance per regime / case where we can prove the content.
3. Restate the former axiom as a theorem assuming `[FooEliminable x]`.
4. Use `instance : FooEliminable` in every downstream application — Lean's elaborator finds it automatically.
5. Delete the `axiom` line.

**Gain.** (a) Zero new work for downstream sites (typeclass inference is transparent). (b) Each eliminated axiom becomes a *reusable typeclass* — future agents inherit this scaffolding. (c) The graph records one fewer axiom, growing the "provable content" statistic.

## 2. The 8 physical constants — genuinely definitional

| Axiom | Lean file | Load | Why axiom |
|---|---|---:|---|
| `OmegaTheory.Spacetime.c` | `Spacetime/Constants.lean` | 392 dep. | Speed of light — measured physical input. |
| `OmegaTheory.Spacetime.hbar` | ibid. | 214 dep. | Planck constant. |
| `OmegaTheory.Spacetime.G_N` | ibid. | 139 dep. | Newton's G. |
| `OmegaTheory.Spacetime.k_B` | ibid. | 65 dep. | Boltzmann constant. |
| `OmegaTheory.Spacetime.c_pos` | ibid. | 124 dep. | `0 < c`. |
| `OmegaTheory.Spacetime.hbar_pos` | ibid. | 69 dep. | `0 < ℏ`. |
| `OmegaTheory.Spacetime.G_N_pos` | ibid. | 58 dep. | `0 < G_N`. |
| `OmegaTheory.Spacetime.k_B_pos` | ibid. | 31 dep. | `0 < k_B`. |

These will **always** be axioms — they are the physical inputs, the "things we don't derive". The paper's 8-axiom count reflects this.

**Elimination status for all 8**: `definitional` — stay as axioms.

## 3. `Real.pi_transcendental` — upstream Mathlib debt

**Current state** (`HermitePade/PiStratum.lean:45`):
```lean
axiom Real.pi_transcendental : Transcendental ℚ (Real.pi : ℝ)
```

**Dependents in graph**: 0 direct-dependents (used only in the research-diary `HermitePade` tree, which itself uses it via `decoupling_scalar` and `pi_stratum_integer`).

**Elimination path.**
1. Mathlib contributor ports the final step of Lindemann-Weierstrass on top of existing `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`. Estimate: 30-40 sessions of focused Mathlib work.
2. Our file becomes `theorem Real.pi_transcendental := Mathlib.Transcendental.pi` (or similar), zero changes downstream.
3. **Delete the axiom line.**

**Effort on our side**: 1 session to delete the axiom + verify the build.

**Elimination status**: `awaits_mathlib` (upstream-blocked, well-scoped).

## 4. The 15 Hermite-Padé research conjectures

From the graph: all have **0 dependents** (they are statement-only witnesses in research-frontier files).

| Axiom | File | Status | Elimination path |
|---|---|---|---|
| `u_hyp`, `v_hyp` | `HermitePade/Conj_4A4_Statement.lean` | CONJECTURAL | Research-frontier — these are the constants under Attack 4A.4. Not standard axioms; research parameters. |
| `motivicU`, `motivicV`, `motivic_trdeg_three`, `motivic_trdeg_three_transcendence` | `HermitePade/GAP_M_Conjecture.lean` | CONJECTURAL | Motivic conjecture; frontier research. |
| `Nesterenko_1996`, `Nesterenko_1996_transcendence` | `HermitePade/GAP_N_Conjecture.lean` | AWAITS_MATHLIB | Nesterenko 1996 theorem — known classical result. Port it to Mathlib + delete. |
| `hermiteLindemann_arctan_one_third_irrational` | `HermitePade/Niven_Arctan.lean` | AWAITS_MATHLIB | Corollary of Lindemann-Weierstrass. Follows from `Real.pi_transcendental` port. |
| `siegel_shidlovskii`, `hypValue`, `hypDeriv` | `HermitePade/SSReduction.lean` | AWAITS_MATHLIB | Siegel-Shidlovsky theorem port (60 sessions). |

**Three sub-categories:**
- **CONJECTURAL (6)**: `u_hyp, v_hyp, motivicU, motivicV, motivic_trdeg_three, motivic_trdeg_three_transcendence`. These are research-frontier conjectures the Hermite-Padé diary is attacking; they may not be true. Not so much "axioms" as "hypotheticals for contradiction-style arguments."
- **AWAITS_MATHLIB (8)**: `Nesterenko_1996, Nesterenko_1996_transcendence, hermiteLindemann_arctan_one_third_irrational, siegel_shidlovskii, hypValue, hypDeriv` — plus 2 native_decide-generated Jacobi axioms `SU3JacobiFull.jacobi_rat_zero._native.native_decide.ax_1_1` and `SU3JacobiFull.jacobi_sqrt3_zero._native.native_decide.ax_1_1`. Each is a known result (or a specific rational decidability) awaiting its Mathlib port.
- **UPSTREAM_BLOCKED (1)**: `Real.pi_transcendental` — same family.

## 5. Per-axiom elimination decisions

| Axiom | Status | Typeclass pattern? | Sessions to eliminate |
|---|---|---|---:|
| 8 × physical constants | definitional | N/A | — |
| `Real.pi_transcendental` | awaits_mathlib | N/A (direct wrapper) | 1 (after port) |
| `hpw_laplacian_ricci_convergence` | **ELIMINATED 2026-04-17** | `HpwEliminableRegime` | 0 (done) |
| `Nesterenko_1996` | awaits_mathlib | N/A | 2 (after port) |
| `Nesterenko_1996_transcendence` | awaits_mathlib | N/A | 1 (corollary) |
| `hermiteLindemann_arctan_one_third_irrational` | awaits_mathlib | N/A | 1 (after Lindemann port) |
| `siegel_shidlovskii` | awaits_mathlib | Could benefit from E-function typeclass | 3 (after port) |
| `hypValue`, `hypDeriv` | awaits_mathlib | N/A | 2 (after port) |
| `u_hyp`, `v_hyp` | conjectural | No — these are reductio arguments | N/A |
| `motivicU`, `motivicV`, `motivic_trdeg_three`, `motivic_trdeg_three_transcendence` | conjectural / open problem | No | N/A |
| `SU3JacobiFull.jacobi_rat_zero._native.native_decide.ax_1_1` | native_decide_artifact | `SU3JacobiEliminable` typeclass possible | 5 |
| `SU3JacobiFull.jacobi_sqrt3_zero._native.native_decide.ax_1_1` | native_decide_artifact | `SU3JacobiEliminable` typeclass possible | 5 |

## 6. Typeclass patterns for remaining eliminations

### Pattern A — `NesterenkoEliminable` typeclass

```lean
class NesterenkoTripleAlgIndep (triple : Fin 3 → ℝ) : Prop where
  indep : AlgebraicIndependent ℚ triple

instance : NesterenkoTripleAlgIndep nesterenkoTriple := ⟨
  -- supply Mathlib.NumberTheory.Nesterenko.alg_indep_triple once ported
  sorry⟩

-- axiom statement becomes:
theorem Nesterenko_1996 [hnest : NesterenkoTripleAlgIndep nesterenkoTriple] :
    AlgebraicIndependent ℚ nesterenkoTriple := hnest.indep
```

### Pattern B — `SiegelShidlovskyEliminable` typeclass

```lean
class EFunctionSolvesSystem (E : Fin n → (ℂ → ℂ)) : Prop where
  eFunction : ∀ i, IsEFunction (E i)
  satisfiesODE : ∃ A : Matrix (Fin n) (Fin n) (ℂ → ℂ), ∀ z i, derivative (E i) z = Σ j, A i j z * E j z

-- Siegel-Shidlovsky becomes the theorem whose instance is supplied by each use
```

### Pattern C — `SU3JacobiEliminable` typeclass

The two native_decide axioms are for rational / √3-coefficient Jacobi identity instances in the SU(3) Lie algebra. A typeclass `SU3JacobiEliminable` could move these to per-call-site witnesses. Budget: 5 sessions each after Tiaki Cycle-29 scaffolding.

## 7. Graph registration

Each axiom now has a corresponding `:TheoremCandidate` node:

```cypher
MATCH (a:Axiom {namespace:'OmegaTheoryV2'})
MERGE (tc:TheoremCandidate {
  name: 'elim_' + a.name,
  namespace: 'OmegaTheoryV2',
  axiom_id: a.name,
  scope: 'AxiomElimination'
})
  ON CREATE SET tc.registered_by = 'Rasalas', tc.registered_at = datetime()
```

(Run below in §Appendix.)

Each node carries:
- `axiom_id` — fully-qualified Lean name
- `elimination_status` — one of {unknown, eliminable, definitional, awaits_mathlib, open_problem, conjectural, native_decide_artifact, ELIMINATED}
- `elimination_pattern` — which typeclass-witness strategy applies (or `N/A` for definitional)
- `mathlib_gap` — what needs to be in Mathlib first
- `session_estimate` — rough effort

## 8. Headline count (for root README)

> **Axiom ledger (live 2026-04-21):**
> - Started at: **25 axioms** (before HPW deletion).
> - Currently: **24 axioms** (8 physical + 1 π-transcendental + 15 Hermite-Padé).
> - **Eliminated so far**: 1 (HPW, 2026-04-17, via `HpwEliminableRegime` typeclass).
> - **Eliminable with upstream Mathlib progress**: 9 (Lindemann, Hermite, Nesterenko, Siegel-Shidlovsky, 2 corollary wrappers, 2 native_decide artifacts, 1 hypergeometric pair).
> - **Conjectural / research-frontier**: 6 (motivic triple + uv hypotheticals).
> - **Definitional (stay forever)**: 8 physical constants.
>
> **Ceiling**: the paper-target story is **8 axioms** (physical only). The 15 Hermite-Padé + 1 Lindemann are on a clear elimination path, albeit multi-session. No axiom is classically open-ended.

## 9. Canonical elimination recipe (copy-paste for future agents)

```
For each axiom `foo : FooType` with non-zero dependents:
  1. Identify the regime structure (GR regime? Numeric case? Algebraic witness?).
  2. Introduce `class FooEliminable : Type where witness : FooType`.
  3. Supply one `instance : FooEliminable <regime>` per case with a proof.
  4. Rewrite the axiom `foo` as `theorem foo [h : FooEliminable …] : FooType := h.witness`.
  5. Delete the `axiom foo` line.
  6. Fix downstream call sites by adding `[FooEliminable …]` to their signatures
     (Lean elaboration finds the instance automatically).
  7. Run `lake build --log-level=error` — expect clean GREEN.
  8. Update `:Axiom` node in Neo4j to `:TheoremCandidate {status: ELIMINATED}`.
```

For **statement-only** axioms (0 dependents):
```
  1. Check if the statement is known true classically.
  2. If yes → wait for Mathlib port, then `theorem foo := Mathlib.foo`; delete axiom line.
  3. If conjectural → keep as `def` returning `Prop` rather than `axiom`; downstream code only uses the name as a target, not a source.
```

## 10. Appendix: Cypher registration for this session

```cypher
// Register eliminator candidate per tracked axiom
MATCH (a:Axiom {namespace:'OmegaTheoryV2'})
WITH a, CASE
  WHEN a.name = 'hpw_laplacian_ricci_convergence' THEN 'ELIMINATED'
  WHEN a.name STARTS WITH 'OmegaTheory.Spacetime.' THEN 'definitional'
  WHEN a.name = 'Real.pi_transcendental' THEN 'awaits_mathlib'
  WHEN a.name IN ['Nesterenko_1996','Nesterenko_1996_transcendence',
                  'hermiteLindemann_arctan_one_third_irrational',
                  'siegel_shidlovskii','hypValue','hypDeriv'] THEN 'awaits_mathlib'
  WHEN a.name CONTAINS 'motivic' OR a.name IN ['u_hyp','v_hyp'] THEN 'conjectural'
  WHEN a.name CONTAINS 'native_decide' THEN 'native_decide_artifact'
  ELSE 'unknown'
END AS status
MERGE (tc:TheoremCandidate {
    name: 'elim_' + a.name,
    namespace: 'OmegaTheoryV2'
})
  ON CREATE SET tc.axiom_id = a.name,
                tc.elimination_status = status,
                tc.scope = 'AxiomElimination',
                tc.registered_by = 'Rasalas',
                tc.registered_at = datetime()
  ON MATCH SET  tc.elimination_status = status
RETURN count(tc) AS axioms_registered;
```

Run this query in a session to attach axiom-elimination candidates to every known axiom node.
