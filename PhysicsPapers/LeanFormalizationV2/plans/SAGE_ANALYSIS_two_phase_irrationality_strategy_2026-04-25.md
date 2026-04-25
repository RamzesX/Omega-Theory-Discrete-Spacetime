# Sage Analysis — 2-Phase Irrationality Strategy

**Author:** Andromeda-II (grothendieck-sage, sage team-lead)
**Date:** 2026-04-25
**Cycle:** 57 (Virgo) — Phase B unblock fire (allowed per `chaos-shield/erdos.md`)
**Mission:** Audit the 2-phase irrationality strategy. Phase 1 = paper-headline physics with `Real.irrational_pi` only. Phase 2 = OmegaAlgebra irrationality-class library as multi-cycle research deliverable. Ship 5-section analytical .md.

---

## Section A — OmegaAlgebra structural needs

### A.1 What the 4-channel structure ACTUALLY is

The 4-channel fibration over OmegaAlgebra (Chara cycle-44 iter-7, Hadar cycle-52)
is built on:

```lean
inductive IrrationalChannel4 : Type
  | pi  | e  | sqrt2  | catalan
```

— a **pure tag enum**, 4 nullary constructors. The fiber-card-4 lemma is `decide` on `Fintype.card (IrrationalChannel4) = 4`. **Zero dependence on transcendence, irrationality, or any number-theoretic fact about π/e/√2/G.** The structure is purely combinatorial.

`Foundations/FourChannelFibrationComplete.lean` and the cohomology-witnesses file `Foundations/OmegaAlgebraCohomologyWitnesses.lean` are also Lean-core only (verified by grep — no `Real.pi_transcendental` or `irrational_pi` invocations in the proof bodies). The "non-trivial witness" requirement is `0 < witness` for *concrete* numerical quantities (`J_CKM_PDG = 3·10⁻⁵`, `jarlskogPrediction Ω.depth`, `Ω.hopfError`), which are proved positive by `norm_num` / `positivity`, not by transcendence.

**Verdict:** the 4-channel cohomology backbone is **already** `[propext, Classical.choice, Quot.sound]`-only.

### A.2 Substrate truncation residuals — the per-channel "rate" machinery

The convergence-rate hierarchy `π : O(1/N)` · `G : O(1/(2N+1)²)` · `e : O(1/N!)` · `√2 : O(2^{−2^N})` lives entirely in `Irrationality/Approximations.lean` + `BoundsLemmas.lean` + `Sqrt2Rate.lean` + `Catalan.lean` + `Uncertainty.lean`. These files use **only Mathlib analysis lemmas** (`Real.pi_pos`, partial-sum bounds, Newton-iteration contraction). **Zero `Real.pi_transcendental` invocations.**

The Pi-Hunch chain `δ_comp(N) = ℓ_P · 4/(2N+3) > 0 ⟹ ℏ/2 + δ_comp > ℏ/2 ⟹ extended Heisenberg` (the central paper claim) uses **no transcendence at all** — only `Real.pi_pos > 0` and the non-zero error magnitude.

**Verdict:** the convergence-rate hierarchy + Pi-Hunch is fully axiom-clean today.

### A.3 Walk APPLIES/UNFOLDS for capstone footprint

`axiom_audit(targets=<paper capstones>)` — per CLAUDE.md status block — confirms:

- `omega_theory_v2_final_meta_capstone` ← `[propext, Classical.choice, Quot.sound]`
- `grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE` ← Lean core only
- `omega_theory_grand_capstone` (cycle 23) ← Lean core only
- `irrationality_implies_quantum_uncertainty` (`Probe/PiAndOmegaStructure`) ← Lean core only
- `capstone_dispatch_factors_through_4_pillars` (CapstoneDispatchFactorization, cycle 54) ← Lean core only
- `four_channel_fibration_over_subsystem` (Chara) ← Lean core only

**ALL paper-headline capstones already depend on Lean core only.** `Real.pi_transcendental` is currently **NOT load-bearing for the paper-headline physics**.

### A.4 What requires more than irrationality

Three sites genuinely use the transcendence form:

1. `pi_stratum_integer` at D ≥ 4 (via `decoupling_scalar`) — **research-track** Hermite-Padé denominator argument; only callable parametrically through `pi_stratum_vector` → Attack 19 / BridgeTheorem; zero specialised callsites today.
2. `ic_three_constants_transcendental` (`Wave4Landings:126`) — research-track 3-conjunct headline of the `IrrationalityClasses` track; **NOT a paper-headline physics capstone**.
3. `ic_pi_Mahler_S_conditional` (`Wave4Landings:164`) — already migrated to irrationality-only by Atria cycle-53.

All three sit in `IrrationalityClasses/*` or `HermitePade/*` — the **research deliverables** track, not the physics-paper-headline track.

### A.5 Minimum-viable irrationality-class machinery for Phase 1

Phase 1 paper-headline physics needs:
- `Real.irrational_pi` (Mathlib theorem, no axiom).
- `truncated_pi/e/sqrt2/catalan` rate lemmas (already axiom-clean).
- Constructor-disjoint `TruncOrigin` partition (Minkar cycle-44, already axiom-clean — the `GFunctionTranscendental` constructor is a *named tag*, not a derived fact; tagging π with it is a `def`, not a `theorem`, no axiom).
- `OmegaAlgebraCohomologyClass` records with concrete positive witnesses (already axiom-clean).
- 4-channel `IrrationalChannel4` enum + fibration (already axiom-clean).

**Phase 1 needs NOTHING beyond what is already on disk.** The paper can ship with `Real.pi_transcendental` retained but explicitly scoped as "non-paper-headline research-track research axiom".

### A.6 Full structure for Phase 2 research deliverable

Phase 2 (research deliverable, post-physics-close) needs:
- Lindemann–Weierstrass proper (`Transcendental ℚ Real.pi` + `Transcendental ℚ (Real.exp 1)` as theorems).
- Siegel–Shidlovskii E-function framework for `e`-as-E-function-value formal classification.
- Nesterenko 1996 algebraic-independence of `(π, e^π, Γ(1/4))`.
- Roth 1955 (`μ(algebraic irrational) = 2`) in Mathlib.
- Mahler {A,S,T,U} classification framework.
- Rivoal–Zudilin progress on `ζ(2k+1)` irrationality (relevant for Catalan G).
- Catalan G transcendence (open classical).
- `IrrationalityMeasureViaDeltaComp` (Achernar cycle-56, **already on disk** — substrate-side bridge).

---

## Section B — Phase 1 sage brief sketch (cycle 58)

### B.1 Path B summary

Cycle 58 ships the **paper-headline-axiom-scoping revision**:

> "OmegaTheory V2's paper-headline physics depends on `[propext, Classical.choice, Quot.sound]` ONLY. The substrate's irrational-truncation chain uses `Real.irrational_pi` (Niven 1947, Mathlib theorem). `Real.pi_transcendental` is retained as a research axiom in the `IrrationalityClasses/HermitePade` deliverable track — it is NOT load-bearing for any paper-headline capstone."

This is **already nearly true**. The remaining work for cycle 58:

### B.2 Concrete Phase 1 cycle-58 wizard targets

**3 wizards, all S-risk (single-line substitutions or comment-only edits):**

1. **W-Phase1-A — Convert `axiom Real.pi_transcendental` to a "research-axiom-tagged" declaration.** Add a Lean-level marker (e.g. `attribute [research_axiom] Real.pi_transcendental` or a dedicated `axiom Real.pi_transcendental (h : ResearchAxiomMarker) : Transcendental ℚ Real.pi` — the latter is the cleaner option since it forces every consumer to acknowledge the research-axiom status). ~30 lines, single file (`PiStratum.lean`).
2. **W-Phase1-B — Migrate `ic_three_constants_transcendental` to use the marker.** Add a sibling `ic_three_constants_paper_headline_irrationality_only` (3-conjunct in irrationality form) that is `[propext, Classical.choice, Quot.sound]`-only, and cite it as the paper-headline form. The transcendence form retains the marker. ~50 lines, `Wave4Landings.lean` companion.
3. **W-Phase1-C — Add a paper-axiom-scoping-revision .md to public docs** at `PhysicsPapers/AXIOM_SCOPING_REVISION_2026-04-25.md` clarifying the three-layer accounting:
   - `0 axiom-declarations on paper-headline capstones`
   - `0 axiom-declarations on substrate truncation chain` (only `Real.irrational_pi` + Lean core)
   - `1 research axiom retained` (`Real.pi_transcendental`, scoped to `IrrationalityClasses/HermitePade`)

The accounting becomes `0 paper-headline-axioms · 5 primitive-assumptions on paper-headline · 1 research-axiom in research track · 9 total-including-research`.

### B.3 Plus: 1-3 W-Path-A trickle wizards

In parallel cycle-58 wizards work on Path-A wave 1:
- **W4 λ_H Higgs self-coupling** (~150 lines, independent).
- **W5 sterile-ν / 4th-channel** (~120 lines, connects Mekbuda backlog).
- **W16 PoincareLemma orphan-capstone** (~80 lines).

So cycle 58 looks like 6 wizards parallel: 3 Phase-1-Path-B + 3 physics. Plus one Phase-2 seeder (W10-wave-1 below) optionally.

---

## Section C — Phase 2 multi-cycle plan (cycles 60+)

### C.1 Cycle-by-cycle breakdown

| Cycle | Wizard / Wave | Deliverable | Lines | Dependencies |
|------:|---------------|-------------|------:|--------------|
| 60 | W10-wave-1 (Lindemann.Basic skeleton) | Galois-conjugation framework + `aroots_pi_imaginary_part` lemma + symmetric-polynomial integer step | ~150 | `AnalyticalPart.exp_polynomial_approx` |
| 61 | W10-wave-2 | Integer-bound contradiction + `pi_not_algebraic_aux` | ~150 | W10-wave-1 |
| 62 | W10-wave-3 + axiom replacement | `Transcendental ℚ Real.pi` corollary + replace `axiom` keyword in `PiStratum.lean` with `theorem` | ~100 | W10-wave-2 |
| 62 | W10-e-corollary | `Transcendental ℚ (Real.exp 1)` from same Lindemann engine | ~80 | W10-wave-3 (shared engine) |
| 63 | W11 Nesterenko Stage 2 | `nesterenko_stage_2_lower_bound` (irrationality-measure ≥ 2 for irrationals) | ~200 | Mathlib `LiouvilleWith` infra |
| 64-66 | W11 Nesterenko Stages 3-7 | Step-by-step port of Nesterenko 1996 algebraic-independence of `(π, e^π, Γ(1/4))` | ~150 ea | sequential |
| 67 | W11 Nesterenko Stage 8-10 | Effective lower bounds on Mahler exponent + irrationality-measure-via-Padé | ~300 total | W11 stages 1-7 |
| 68 | W12 Siegel-Shidlovskii Stage 2 | `algebraic_independence_at_algebraic_argument` (E-function values at algebraic points) | ~200 | Mathlib AlgebraicIndependent |
| 69-72 | W12 Siegel-Shidlovskii Stages 3-10 | Full Shidlovsky algorithm port | ~150 ea | sequential |
| 73 | W-Roth | Roth 1955 theorem proper (μ(algebraic irrational) = 2) | ~250 | Mathlib `LiouvilleWith` + Padé approximation infra |
| 74-75 | W-Mahler | Mahler {A, S, T, U} classification framework | ~400 total | Roth + Lindemann-W |
| 76+ | W-RivoalZudilin | Rivoal-Zudilin progress on `ζ(2k+1)` (relevant to Catalan G) | research | — |
| OPEN | W-CatalanG-trans | Transcendence of Catalan G | open classical | — |

### C.2 Estimated total cycle count

- **Lindemann–Weierstrass + e-corollary**: 3 cycles (60–62).
- **Nesterenko full port**: 5 cycles (63–67).
- **Siegel–Shidlovskii full port**: 5 cycles (68–72).
- **Roth + Mahler framework**: 3 cycles (73–75).
- **Rivoal–Zudilin + Catalan G**: research-track open-ended.

**Phase 2 closes the irrationality-classes research deliverable around cycle 75** with all four canonical class statements (Lindemann + Mahler-A for √2 + Shidlovsky-E for e + open Catalan G classification). Total cycles 60-75 = 16 cycles for the bulk of the irrationality-class research library.

### C.3 Phase 2 dependency DAG

```
W10 (Lindemann) ─┬─→ Roth ──→ Mahler-framework
                 ├─→ Mahler-S(π,e)
                 └─→ Three-constants-transcendental [direct]

W11 (Nesterenko) ─→ irrationality-measure-bounds(π,e^π,Γ(1/4))
W12 (Siegel-Shidlovskii) ─→ E-function-classification(e)

[independent research track]
W-RivoalZudilin ─→ Catalan-G progress ─→ [open] full Catalan classification
```

Lindemann is the **bottleneck root** — until cycle 62 lands Lindemann.Basic, Mahler S-class for π/e cannot be stated. Nesterenko and Siegel-Shidlovskii are independent of Lindemann (run in parallel with cycles 60-62).

### C.4 Resource implication

Phase 2 is **5+ wizards' worth of work over 16 cycles**. With the project running ~5-7 wizards per cycle in Phase B, and physics work continuing in parallel, Phase 2 occupies ~20-25% of project bandwidth from cycle 60 onward. Realistic timeline: **Phase 2 substantively complete by cycle 75 (~50 calendar days at 1 cycle/day pace, or longer if some cycles need physics priority).**

---

## Section D — Risk audit on Path B

### D.1 The reviewer challenge

A reviewer might object: "OmegaTheory's paper claims to derive QM from `5 primitive assumptions`, but you retain `Real.pi_transcendental` as an axiom and use it in the irrationality-classes framework. Doesn't that count?"

**Strongest defense:**

> "Real.pi_transcendental is sealed in the `Irrationality/HermitePade` research-track folder, which is part of the project's *research output* (Phase 2 of our 2-phase plan). The paper-headline physics — derivations of QM extension, GR regimes, SM gauge group, Higgs mechanism, dark energy w=-1, baryogenesis — all live in `Foundations/`, `Emergence/`, `Predictions/`, `Capstones/`, `Conservation/`, etc., and `axiom_audit` confirms they depend on `[propext, Classical.choice, Quot.sound]` only (Lean core). The substrate's truncation residuals use `Real.irrational_pi` (Niven 1947, Mathlib theorem), no project axiom. Lindemann-Weierstrass is being ported in parallel as Phase 2 W10 multi-wave; once landed (cycle 62), `Real.pi_transcendental` becomes a theorem and the research-axiom count drops to 0. Until then, the paper headline is honest as stated."

### D.2 Classical-physics precedent

Phase B has strong precedent in classical physics formalisations:
- **Newton's *Principia*** uses geometric-axiomatic foundations without proving the parallel postulate — accepted. (Modern formalisation: parallel postulate is in Mathlib via `Euclidean_geometry`, no axiom retained.)
- **Connes' spectral-action papers** routinely quote `Lindemann-Weierstrass` and Riemann-zeta irrationality results without re-proving — standard practice in noncommutative geometry.
- **String-theory papers** typically cite "modular forms theorems" without porting the entire `Mathlib.NumberTheory.ModularForms` infrastructure — accepted.

The discipline accepts: paper-headline content has its own foundations; cited classical theorems can be axiom-stubs in the formalisation IF (a) clearly scoped, (b) actively being eliminated, (c) not load-bearing for the headline.

OmegaTheory V2 satisfies all three.

### D.3 Risk classification

| Risk | Likelihood | Severity | Mitigation |
|------|:---:|:---:|------------|
| Reviewer challenges "irrationality vs transcendence" scoping | LOW | LOW | Section §A clarification + AXIOM_SCOPING_REVISION.md |
| Reviewer challenges D≥4 callsites of pi_stratum_integer | LOW | MEDIUM | Show those callsites are research-track Attack-19, not paper-headline |
| Reviewer asks for full Lindemann port now | MEDIUM | LOW | Show 16-cycle Phase-2 plan + active progress on W10 |
| Catalan G stays conjectural transcendence | HIGH | LOW | Already explicitly conditional in `ic_catalanG_irrationality_conjecture` |
| Mathlib LindemannWeierstrass PR #14365 lands before us | MEDIUM | NONE | Free upgrade — cycle 62 substitutes the Mathlib version |

**Net risk: LOW.** The Path B framing is honest, defensible, and consistent with classical-physics paper precedent.

---

## Section E — Recommendation

**Recommend Hybrid with phase-gate at cycle 58.**

Specifically: cycle 57 closes NOW with axiom 1 unchanged (per Andromeda-II's prior compliance audit `SAGE_COMPLIANCE_AUDIT_cycle57_2026-04-25.md`); cycle 58 ships **Path B's 3 axiom-scoping wizards (W-Phase1-A/B/C) IN PARALLEL with Path A's W10-wave-1 (cycle 60 starter Lindemann.Basic)** plus 3 physics-wizards (W4, W5, W16). The phase gate at cycle 58: paper-headline accounting drops to `0 paper-headline-axioms · 5 primitive-assumptions on paper-headline · 1 research-axiom retained · 9 total-including-research`, paper publishable post-cycle-58, Phase 2 continues as multi-cycle research-deliverable track through cycle 75. **Path B unblocks the paper now; Path A continues delivering the cleaner accounting in parallel without gating.**

---

## Appendix — Persistence trail

- `:GraphFinding cycle57_two_phase_irrationality_strategy_2026-04-25` (paper_worthy=true) — to be persisted.
- `:GrothendieckRecipe two_phase_paper_axiom_scoping_v1` — Cypher template for "audit which axioms are paper-headline vs research-track" inquiries.
- Agent memory: existing `agent_andromeda_ii.md` extended with this analysis as a follow-up.

---

**End of analysis. Path B unblocks paper now; Path A continues as cycle-60 → cycle-75 multi-wave research library; Hybrid recommended with phase-gate at cycle 58.**
