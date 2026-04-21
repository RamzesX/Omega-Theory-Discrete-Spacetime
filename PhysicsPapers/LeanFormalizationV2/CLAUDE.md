# OmegaTheory V2 — Lean 4 Formalization

## Status (2026-04-21 — POST cycle-43)
- **Paper story**: 8 physical axioms (PRL/FoP framing)
- **Full axiom count**: 24 total (8 physical + 15 HermitePade research conjectures + 1 π transcendental)
- **3,835 build jobs GREEN**, 0 sorry
- **211 Lean files**
- **8,996 OmegaTheoryV2 Theorems** (OWN) + **175,137 Mathlib** (integrated) = **184,133 total**
- **4,465 OmegaTheoryV2 Definitions**
- Lean v4.29.0 + Mathlib v4.29.0
- **Cycles 2-43 shipped.** Mekbuda's 60-theorem backlog (cycles 24-43) CLOSED.
- **Grand Capstone V2** landed (Polaris, cycle 43): `omega_theory_v2_final_meta_capstone` at `OmegaTheory/Predictions/OmegaTheoryGrandCapstoneV2.lean`

## Cycle-24-43 landings (14 files)
- ElectroweakUnification
- OmegaTotalClosure
- DarkEnergyToBabyUniverse
- ConnesCalibrationAndFourChannels
- CrossSectorBridges
- SU3ColorAndNonAbelianF
- ConnesDFYukawaMass
- PiHunchQuantitative
- InteractionsAsBoundaryCrossings
- BaryogenesisLeptogenesis
- CyclicCosmology
- HiggsAndMassHierarchy
- QuantumGravityBHInfo
- SecondLawAndHolography
- CrossCorpusTests
- MatterAsymmetryAndNoNewPhysics
- OmegaTheoryGrandCapstoneV2

## Graph state (Neo4j `math` container, namespace `OmegaTheoryV2`)
- **86** `:GraphFinding` nodes (44 paper_worthy)
- **166** `:TheoremCandidate` nodes
- **677** `:SubsystemNavigator` nodes
- **Navi's post-cycle-43 finding**: the 4-channel structure is **FIBERED, not PARTITIONED** — Leiden Q=0.89 but no 4-band gap. See `plans/GROTHENDIECK_MATH_PUZZLE.md` (969 lines).

## Root-level layout (post 2026-04-20 reorg)
```
├── CLAUDE.md                  ← this file, agent onboarding
├── README.md                  ← public summary
├── PROJECT.md                 ← foundational overview
├── STYLE_GUIDE.md             ← naming + proof governance
├── OmegaTheory/               ← Lean 4 source (211 files)
│                              (public paper at ../papers/Paper-QM-From-Discrete-Gravity.md;
│                               LaTeX submission package at ../submissions/qm-discrete-gravity/)
├── notes/                     ← NOTES_CYCLE*_TRANSITION.md (historical cycle closures)
├── plans/                     ← active planning docs (backlog + Grothendieck reports + math puzzle)
├── .neo4j/                    ← Cypher ingestion pipeline (V3-for-Lean)
└── .claude/                   ← custom agents (gitignored agent-memory)
```
(The `scratch/` and `audits/` folders were deleted on 2026-04-20 during the cycle-43 reorg.)

## Build (WSL-native, NO wsl.exe wrapper)
```bash
~/.elan/bin/lake build --log-level=error          # full project
~/.elan/bin/lake build OmegaTheory.Module --log-level=error  # single module
~/.elan/bin/lake exe cache get                     # Mathlib cache (do first)
```

## HARD RULES for all agents
1. **0 sorry** — absolutely never
2. **0 new axioms** — paper story stays at 8 physical constants
3. **Must compile GREEN** before reporting done
4. **Register new files** in `OmegaTheory/Basic.lean`
5. **Quality over speed** — take time, iterate on errors
6. **Speak the same language** — follow `STYLE_GUIDE.md` (shared primitives, naming, proof patterns)
7. **Connect don't duplicate** — grep + `exact?` before writing new theorems

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

## What the theory derives (from 8 constants)
- QM: 10 von Neumann postulates (`grand_qm_emergence`)
- GR: Einstein equations (7 regime witnesses, HPW axiom deleted)
- SM gauge: U(1)×SU(2)×SU(3) (from Connes A_F = ℂ⊕ℍ⊕M₃(ℂ))
- Dark energy: w = -1 from healing flow residual
- Inflation: healing flow → de Sitter → exit
- Big Bounce: spin-torsion negative pressure
- Higgs: δ_comp IS the Higgs field, symmetry restoration at high E
- 20 falsifiable predictions (1 verified: Diraq 2024)
- **Grand Capstone V2**: `omega_theory_v2_final_meta_capstone` unifies all sectors

## Custom agents available
- `omega-team-lead` — coordinates wizard + creative in pairs
- `lean-proof-wizard` — Lean 4 proof specialist (all tactics, all build commands)
- `quantum-physics-creative` — wild physics ideas + literature search
- `pi-irrationality-hunter` — Pi hunch specialist: π-truncation, transcendence, 3 generations
- `pi-formalizer` — Lean formalization of π properties + Hermite-Padé
- `pi-physics-bridge` — connects π math to physical predictions (masses, QM, generations)
- `grothendieck-sage` — graph / Neo4j reasoning (Navi, Polaris, etc. operate under this banner)

## The Pi Hunch (central thesis)
**The irrationality of π produces quantum mechanics.**

- π irrational → truncation error `δ_comp(N) = ℓ_P·4/(2N+3)` (Leibniz series)
- δ_comp extends Heisenberg: `ℏ/2 + δ_comp > ℏ/2` → QM is NECESSARY
- 3 irrationals (π/e/√2) with 3 convergence rates → hypothesis: 3 particle generations
- **Hardest to compute ≡ most residual error** — π is heaviest BECAUSE its δ is largest at fixed N. Do not invert via Connes `Λ = 1/δ`.

Key files:
- `Irrationality/Approximations.lean`, `BoundsLemmas.lean`, `Uncertainty.lean`
- `Irrationality/PredictionsBridge.lean` — π → QM chain
- `Irrationality/HermitePade/Decoupling.lean` — Theorem 4C.3 (0 sorry)
- `Probe/PiAndOmegaStructure.lean` — `irrationality_implies_quantum_uncertainty`
- `Predictions/PiHunchQuantitative.lean` — cycle-24-43 quantitative bounds

Open: replace `Real.pi_transcendental` axiom with Mathlib Lindemann-Weierstrass when upstream.

## Where to look for context
- **Cycle-24-43 theorem backlog (all 60 landed)** — `plans/THEOREM_BACKLOG_CYCLES_24_43.md`
- **Grothendieck follow-ups** — `plans/GROTHENDIECK_FOLLOWUP_REPORT.md`, `plans/GROTHENDIECK_DE_REVERSIBILITY.md`
- **Navi's 4-channel puzzle** — `plans/GROTHENDIECK_MATH_PUZZLE.md` (969 lines; FIBERED vs PARTITIONED analysis, Leiden Q=0.89)
- **Past cycle closures** — `notes/NOTES_CYCLE*_TRANSITION.md`
- **Build state** — check live via `~/.elan/bin/lake build --log-level=error` (0 sorry / 24 axioms / 3,835 jobs as of cycle 43)
