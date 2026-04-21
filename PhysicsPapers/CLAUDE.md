# OmegaTheory — Physics Papers & Lean Formalization

## Overview
OmegaTheory derives quantum mechanics, general relativity, and the Standard Model gauge group from 8 physical constants on a ℤ⁴ Planck lattice. The computational truncation of π, e, √2 produces bounded errors that ARE quantum uncertainty.

## Repository structure
```
PhysicsPapers/
├── LeanFormalizationV2/          ← Lean 4 formalization (v4.29.0 + Mathlib v4.29.0)
│   ├── OmegaTheory/              ← ~160 files, ~1750+ theorems, 0 sorry, 8 axioms
│   │   ├── Foundations/           ErrorAlgebra, ErrorLieAlgebra, ErrorForms, ErrorHopf
│   │   ├── Spacetime/            Lattice, Constants, Operators, CausalLattice
│   │   ├── Geometry/             Metric → Curvature → Maxwell → Hodge → Poincaré
│   │   ├── Emergence/            Einstein, QM, Higgs, Inflation, DarkMatter, Connes
│   │   ├── Predictions/          20 falsifiable predictions (1 verified: Diraq 2024)
│   │   ├── Conservation/         Information, Noether, StressEnergy, Correspondence
│   │   ├── HealingFlow/          Lyapunov, LaSalle, Convergence
│   │   ├── Torsion/              SpinTorsion, BigBounce (Popławski)
│   │   ├── Irrationality/        π/e/√2 truncation → δ_comp(N)
│   │   ├── Variational/          GraphAction, DiscreteNoether
│   │   ├── Paper/                Headline aliases for manuscript citation
│   │   └── Probe/                Proof search experiments
│   ├── .claude/agents/            Custom agents (lean-proof-wizard, quantum-physics-creative)
│   └── CLAUDE.md                  V2-specific instructions
├── Appendix-*.md                  Paper appendices (A through K)
├── Letter-ColdNeutron-*.md/.tex   PRL submission package
├── PAPER_DRAFT.md                 Main paper draft
├── NOTES_*.md                     Working notes
└── CLAUDE.md                      This file
```

## Lean 4 build (WSL-native, NEVER use wsl.exe wrapper)
```bash
~/.elan/bin/lake build --log-level=error                    # full project
~/.elan/bin/lake build OmegaTheory.Module --log-level=error # single module
~/.elan/bin/lake exe cache get                              # Mathlib cache
```

## Neo4j ingest pipeline — USE THESE SCRIPTS, DO NOT ROLL YOUR OWN

Full ground-truth pipeline lives in `~/lean-v2/.neo4j/`. See
`LeanFormalizationV2/.neo4j/CLAUDE.md` for details. Two Lean metaprograms
produce the env dumps; two Python loaders MERGE them into the `math` container
(bolt://localhost:7687, neo4j/omegatheory2026). Never regex-parse `.lean`
files for graph work — Mirfak measured the regex path drops 46 % of fresh
theorems.

```bash
cd ~/lean-v2
~/.elan/bin/lake build --log-level=error          # must be GREEN first
~/.elan/bin/lake exe dump_declarations --out .neo4j/declarations_from_env_v2.jsonl
~/.elan/bin/lake exe dump_arrows --out .neo4j/arrows_from_env_cycleN.jsonl --include-mathlib
cd .neo4j
python3 load_declarations_env_v2.py               # Naos: MERGE Theorem/Def/Axiom
python3 load_arrows_from_env_v2.py                # Rasalhague: APOC-batched arrows
python3 reembed_qwen3_delta.py                    # Qwen3-8B embeddings (:7999)
```

**Key files (never rewrite from scratch — extend them):**
- `OmegaTheory/Meta/DumpDeclarations.lean` (Schedar) — env declaration dumper
- `OmegaTheory/Meta/DumpArrows.lean` (Sheratan) — 12-arrow typed env extractor
- `.neo4j/load_declarations_env_v2.py` (Naos) — delta declaration loader
- `.neo4j/load_arrows_parallel.py` — **SOTA parallel loader** 16-worker × batched UNWIND (~500× faster than sequential; 10-17k edges/s)
- `.neo4j/load_arrows_from_env_v2.py` (Rasalhague) — legacy sequential APOC loader (slow, keep for debugging)
- `.neo4j/reembed_qwen3_delta.py` — Qwen3-Embedding-8B BF16 GPU embedder

**CRITICAL: nodes must use fully-qualified names** (`module + "." + short_name`) to match dump_arrows output. Post-hoc rename fix in `.neo4j/CLAUDE.md`.

**DO NOT use** `.neo4j/extractors/lean_arrow_extractor.py` (regex, deprecated)
for production graph work. It's kept for fallback when Lean env is broken.

Embedder endpoints:
- `http://localhost:7999/v1/embeddings` — Qwen3-8B BF16 GPU (dim 4096)
- `http://localhost:7997/rerank` — Qwen3-Reranker-8B CPU

## HARD RULES for all work
1. **0 sorry** in Lean — absolutely never
2. **0 new axioms** — project has exactly 8 physical constants
3. **Must compile GREEN** before reporting done
4. **Quality over speed** — iterate on errors until clean
5. **Narrower true theorem > false dressed-up claim**

## Proof automation — USE BEFORE manual proof
```lean
exact?       -- search 210K+ Mathlib lemmas + local theorems (30s, most powerful)
apply?       -- find applicable lemmas
aesop        -- white-box multi-step proof search
grind        -- SMT solver (Gröbner basis + cutsat, Lean 4.22+)
positivity   -- auto-prove 0 < x or 0 ≤ x
ring         -- ring equalities
field_simp   -- clear denominators then ring
linarith     -- linear arithmetic over ordered fields
nlinarith    -- nonlinear arithmetic
decide       -- exhaustive finite enumeration
omega        -- Presburger arithmetic (ℤ/ℕ)
norm_num     -- numeric normalization
push_cast    -- push coercions through expressions
fin_cases    -- case split on Fin n (exhaustive for small n)
fun_prop     -- continuity / differentiability
gcongr       -- generalized congruence (monotonicity)
```

## Mathlib v4.29.0 name changes (CRITICAL)
- `div_le_iff₀` NOT `div_le_iff` (note ₀ suffix)
- `div_lt_iff₀` NOT `div_lt_iff`
- `mul_div_cancel₀` NOT `mul_div_cancel` (needs ne_zero)
- `Finset.not_mem_empty` NOT `Finset.mem_empty`

## What the theory derives (from 8 constants only)
| Physics | Status | Key theorem |
|---------|--------|-------------|
| Quantum Mechanics (10 postulates) | ✅ | `grand_qm_emergence` |
| General Relativity | ✅ 7 regimes | `vacuum_einstein_emergence` |
| U(1) gauge (EM) | ✅ | `photonSubstrateMassBound_pos` |
| SU(2) gauge (weak) | ✅ | `weakCouplingConstant_from_substrate` |
| SU(3) gauge (strong) | ✅ | `strongCouplingConstant_from_substrate` |
| Higgs mechanism | ✅ | `HiggsField := computationalUncertainty` |
| Dark energy w=-1 | ✅ | `darkEnergyEquationOfState_w` |
| Inflation | ✅ | `healingFlow_drives_inflation` |
| Big Bounce | ✅ | `substrate_avoids_singularity` |
| Bell nonlocality | ✅ | `classical_CHSH_bound` + `substrate_CHSH_violation` |
| Path integral | ✅ | `pathIntegral_interference` |
| Λ problem resolved | ✅ | `cosmological_constant_problem_resolved` |
| 20 predictions | ✅ (1 verified) | See `Predictions/*.lean` |

## Current gaps (next frontiers)
- **Matter sector**: 0% — no quarks, leptons, Yukawa, CKM/PMNS
- **3 generations**: hypothesis: 3 irrationals (π/e/√2) → 3 generations
- **Particle masses**: pathway via Connes D_F eigenvalues (capstone goal)
- **su(3) Jacobi**: hypothesis, fixable with `fin_cases` at high heartbeats
- **Non-abelian F = dA + [A,A]**: all ingredients exist, not assembled
- **Clifford off-diagonal**: ~~12 cases hypothesized~~ **CLOSED** (Tureis, DiracEquation.lean:209 `gammaClifford_offDiagonal`, all 12 cases via 6 pair lemmas + `add_comm`, verified by Dubhe Apr-17)

## The Pi Hunch (central thesis)
OmegaTheory's deepest claim: **the irrationality of π produces quantum mechanics**.

Chain: π irrational → can't be computed exactly → per-tick truncation error `δ_comp(N) = ℓ_P·4/(2N+3)` from Leibniz series → extended Heisenberg `ℏ/2 + δ_comp > ℏ/2` → QM is NECESSARY.

- **π-truncation**: dominant (slowest convergence, `O(1/N)`, LARGEST residual δ) → heavy generation
- **e-truncation**: factorial (`O(1/N!)`, middle residual) → middle generation
- **√2-truncation**: super-exponential (`O(2^{-2^N})`, SMALLEST residual) → light generation
- **3 irrationals → 3 generations** (speculative but testable by mass-ratio fit)

### ⚠️ Convention correction (2026-04-17)
**"Hardest to compute" means MOST residual errors, not least.** π is hardest BECAUSE it has the largest δ at any fixed N. Do NOT invert the ordering via Connes `Λ = 1/δ`-style arguments — those conflate the UV spectral cutoff (gravity action strength) with the fermion mass scale (D_F eigenvalues / Yukawa). See `NOTES_PI_ORDERING_CORRECTION.md` for full analysis. The mapping `m = f(δ)` is likely non-linear (`m ∝ δ^α`, `m = a + b·δ`, or a Connes-weighted Yukawa kernel), but the **ordering stays: π heaviest, √2 lightest**.

Related infrastructure:
- `OmegaTheory/Irrationality/Approximations.lean` — truncated_pi/e/sqrt2
- `OmegaTheory/Irrationality/BoundsLemmas.lean` — error bounds
- `OmegaTheory/Irrationality/Uncertainty.lean` — δ_comp, iterationBudget
- `OmegaTheory/Irrationality/PredictionsBridge.lean` — π → QM chain
- `OmegaTheory/Irrationality/HermitePade/Decoupling.lean` — pi irrationality proof (Theorem 4C.3, 0 sorry)
- `Real.pi_transcendental` axiom — waits on Mathlib Lindemann-Weierstrass

The probe file `OmegaTheory/Probe/PiAndOmegaStructure.lean` attempts the thesis in one line:
`irrationality_implies_quantum_uncertainty : ℏ/2 < ℏ/2 + computationalUncertainty N`

## Custom agents
- `lean-proof-wizard` — Lean 4 specialist with all tactics
- `quantum-physics-creative` — wild physics ideas + literature search

## Key references
- Diraq: Huang et al., Nature 627, 772-777 (2024) — first verified prediction
- Connes: noncommutative geometry spectral action
- Similarity algebra: arXiv:2602.14075 (Feb 2026)
- ILL VCN: Ackermann et al., arXiv:2604.09312 (2026)
