# OmegaTheory V2 — Lean 4 Formalization

## Orchestrator MCP
`omega-orchestrator` exposes 22 tools (servers / graph / embed / inspect / jobs / wizard).
Live numbers via `cycle_state()` / `build_status()` / `axiom_audit()`. Hammers
(`omega_hammer_premise`, `propose_proof`) replace grep+exact? guesswork —
composite-scored fast path; `rerank` parameter removed 2026-04-25.

## Status (live snapshot — see `cycle_state()` for fresh)
- **1 canonical `:Axiom` node** (`Real.pi_transcendental`, sealed in HermitePade/).
- **Paper-headline capstones depend on `[propext, Classical.choice, Quot.sound]` ONLY** (Lean core).
- 0 axiom-declarations · 5 primitive-assumptions · 9 total-including-research (post-Lesath 2026-04-24).
- 0 physical-constant axiom declarations — c, ℏ, G_N, k_B as `noncomputable opaque {x:ℝ // 0 < x}` via `Classical.choice` (Lean core).
- Lean v4.29.0 + Mathlib v4.29.0.
- P3t (native_decide elim) CLOSED cycle-49; axiom-narrowing degree-1 ✅ cycle-50 W9, degree-2 conditional ✅ cycle-51 W8.

## Build (WSL-native, NO wsl.exe wrapper)
```bash
~/.elan/bin/lake build --log-level=error          # full project
~/.elan/bin/lake build OmegaTheory.Module --log-level=error  # single module
~/.elan/bin/lake exe cache get                     # Mathlib cache (do first)
```
For green-state checks during proof iteration, prefer
`mcp__omega-orchestrator__build_status()` over re-running `lake build`.

## HARD RULES for all agents

### 0. NO STUBS — SUPER IMPORTANT (LOCKED 2026-04-27)

**NO `sorry`. NO `: True := trivial`. NO `Prop := True` (or any `Prop`
declared as `True`). NO `:= trivial` proofs of placeholders.**

User mandate verbatim 2026-04-27: *"No trivial, no true, no sorry, those
are the rules"*.

If a step is genuinely beyond current scope: prove it via real Mathlib
API, defer the WHOLE file (don't ship partial), or reduce scope to what
IS provable. NEVER stub. Allowed: real theorems, real `Prop` defs with
non-trivial content, conditional theorems with NAMED real Prop hypotheses.

### 1. Other hard rules
1. **0 sorry** — absolutely never
2. **0 new axioms** — `0 axiom-declarations · 5 primitive-assumptions · 9 total-including-research` (post-Lesath 2026-04-24); see PhysicsPapers/CLAUDE.md HARD RULES for full breakdown
3. **Must compile GREEN** before reporting done
4. **Register new files** in `OmegaTheory/Basic.lean`
5. **Quality over speed** — take time, iterate on errors
6. **Speak the same language** — follow `STYLE_GUIDE.md` (shared primitives, naming, proof patterns)
7. **Connect don't duplicate** — `omega_hammer_premise` / `propose_proof` before writing new theorems
8. **NO SUBAGENTS for paper-grade Yoneda** (LOCKED 2026-04-26) — categorical Yoneda witnesses, double-witnesses, Structure-composition theorems, grand capstones MUST be single-thread hand-authored. Subagents systematically produce citation-only `Nonempty S` mass-batch stubs (field-access density 0.10–0.59/thm vs hand-authored 1.13–3.6/thm = 5–30× denser; zero `funext`/`rfl` round-trip identities). See `~/.claude/CLAUDE.md` §8a + chaos-shield `.claude/CLAUDE.md`. Reference exemplars: `Foundations/{CKMAngles,PMNSAngles,ErrorBound}CategoricalYonedaWitness.lean` (c62 hand-authored).

## Proof Automation — USE BEFORE manual proof
```lean
exact?       -- search 210K+ Mathlib lemmas (most powerful, 30s)
apply?       -- find applicable lemmas  
aesop        -- multi-step automated search
grind        -- SMT solver (Lean 4.22+)
positivity   -- auto-prove 0 < x
ring         -- ring equalities
field_simp   -- clear denominators
linarith     -- linear arithmetic
decide       -- exhaustive finite check
```

## Mathlib v4.29.0 name changes
- `div_le_iff₀` not `div_le_iff` (note ₀ suffix)
- `mul_div_cancel₀` not `mul_div_cancel`
- `Finset.not_mem_empty` not `Finset.mem_empty`

## What the theory derives (from 4 opaque-bundle constants — historical "8 constants" framing pre-Lesath)
- QM: 10 von Neumann postulates (grand_qm_emergence)
- GR: Einstein equations (7 regime witnesses, HPW axiom deleted)
- SM gauge: U(1)×SU(2)×SU(3) (from Connes A_F = ℂ⊕ℍ⊕M₃(ℂ))
- Dark energy: w = -1 from healing flow residual
- Inflation: healing flow → de Sitter → exit
- Big Bounce: spin-torsion negative pressure
- Higgs: δ_comp IS the Higgs field, symmetry restoration at high E
- 20 falsifiable predictions (1 verified: Diraq 2024)

## Custom agents available
- `omega-team-lead` — coordinates wizard + creative in pairs
- `lean-proof-wizard` — Lean 4 proof specialist (all tactics, all build commands)
- `quantum-physics-creative` — wild physics ideas + literature search
- `pi-irrationality-hunter` — Pi hunch specialist: π-truncation, transcendence, 3 generations
- `pi-formalizer` — Lean formalization of π properties + Hermite-Padé
- `pi-physics-bridge` — connects π math to physical predictions (masses, QM, generations)

## The Pi Hunch (central thesis)
**The irrationality of π produces quantum mechanics.**

- π irrational → truncation error `δ_comp(N) = ℓ_P·4/(2N+3)` (Leibniz series)
- δ_comp extends Heisenberg: `ℏ/2 + δ_comp > ℏ/2` → QM is NECESSARY
- 3 irrationals (π/e/√2) with 3 convergence rates → hypothesis: 3 particle generations

Key files:
- `Irrationality/Approximations.lean`, `BoundsLemmas.lean`, `Uncertainty.lean`
- `Irrationality/PredictionsBridge.lean` — π → QM chain
- `Irrationality/HermitePade/Decoupling.lean` — Theorem 4C.3 (0 sorry)
- `Probe/PiAndOmegaStructure.lean` — `irrationality_implies_quantum_uncertainty`

Open: replace `Real.pi_transcendental` axiom with Mathlib Lindemann-Weierstrass when upstream.
