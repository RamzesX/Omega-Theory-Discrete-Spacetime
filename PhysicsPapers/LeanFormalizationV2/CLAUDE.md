# OmegaTheory V2 — Lean 4 Formalization

## Status (2026-04-17)
- **8 axioms** (physical constants only, ZERO mathematical axioms)
- **~3475 build jobs GREEN**, 0 sorry
- **~160 Lean files**, ~1750+ theorems
- Lean v4.29.0 + Mathlib v4.29.0

## Build (WSL-native, NO wsl.exe wrapper)
```bash
~/.elan/bin/lake build --log-level=error          # full project
~/.elan/bin/lake build OmegaTheory.Module --log-level=error  # single module
~/.elan/bin/lake exe cache get                     # Mathlib cache (do first)
```

## HARD RULES for all agents
1. **0 sorry** — absolutely never
2. **0 new axioms** — project has exactly 8 physical constants
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
