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
- **Clifford off-diagonal**: 12 cases hypothesized, not verified

## The Pi Hunch (central thesis)
OmegaTheory's deepest claim: **the irrationality of π produces quantum mechanics**.

Chain: π irrational → can't be computed exactly → per-tick truncation error `δ_comp(N) = ℓ_P·4/(2N+3)` from Leibniz series → extended Heisenberg `ℏ/2 + δ_comp > ℏ/2` → QM is NECESSARY.

- **π-truncation**: dominant (slowest convergence, `O(1/N)`) → heavy generation?
- **e-truncation**: factorial (`O(1/N!)`) → middle generation?
- **√2-truncation**: super-exponential (`O(2^{-2^N})`) → light generation?
- **3 irrationals → 3 generations** (speculative but testable by mass-ratio fit)

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
