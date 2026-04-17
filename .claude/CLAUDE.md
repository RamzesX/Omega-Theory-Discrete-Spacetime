# Claude Code Project Instructions - Chaos Shield / Omega-Theory

## System Specifications

```
Machine: AMD Ryzen 9 9950X (16 cores / 32 threads), 192GB RAM
WSL2:    160GB RAM, 32 processors, 32GB swap
```

## Lean 4 Build Commands (ALWAYS use WSL!)

### Quick Build (one-liner)
```bash
wsl.exe bash -c "cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalization && ~/.elan/bin/lake exe cache get && ~/.elan/bin/lake build --log-level=error 2>&1"
```

### Individual Commands

**Get Mathlib Cache (CRITICAL - do first, saves hours):**
```bash
wsl.exe bash -c "cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalization && ~/.elan/bin/lake exe cache get 2>&1"
```

**Build Project:**
```bash
wsl.exe bash -c "cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalization && ~/.elan/bin/lake build --log-level=error 2>&1"
```

**Clean Build:**
```bash
wsl.exe bash -c "cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalization && ~/.elan/bin/lake clean 2>&1"
```

## IMPORTANT: When to use `lake update` vs `lake build`

### `lake update` - ONLY when:
- Changing Mathlib VERSION in lakefile.lean (e.g., v4.13.0 → v4.14.0)
- Adding NEW DEPENDENCY to lakefile.lean
- After `lake update` → ALWAYS run `lake exe cache get`

### `lake build` - For everything else:
- Adding/changing imports from existing Mathlib
- Editing your own code
- New imports like `import Mathlib.Topology.MetricSpace.Basic` → just `lake build`
- Mathlib is already installed, just links the modules

### DO NOT run `lake update` when:
- Just adding new imports from already-installed Mathlib
- Just editing Lean files
- Fixing proofs

## Lake 5.0 Build Options

Lake 5.0 has **automatic parallelism** - no `-j` flag or `LAKE_JOBS` needed!

Useful options:
- `--log-level=error` - Only show errors (suppress warnings spam)
- `--log-level=warning` - Show warnings and errors
- `--quiet` - Hide info logs and progress indicator
- `--verbose` - Show trace logs

## Important Notes

1. **Never use PowerShell for Lean** - Profile errors and PATH issues
2. **Always use WSL bash** - elan/lake installed at `~/.elan/bin/`
3. **Parallelism is automatic** - Lake 5.0 uses all available cores
4. **MCP lean-lsp tools** - Have path issues mixing WSL/Windows paths; use direct bash instead
5. **Mathlib version** - v4.29.0, Lean v4.29.0 (check lakefile.lean)

## Project Structure

```
PhysicsPapers/
  LeanFormalization/          <- Lean 4 formalization
    DiscreteSpacetime/        <- Main module
      Basic/                  - Constants, Lattice, Operators
      Axioms/                 - Physical postulates
      Geometry/               - Metric, Connection, Curvature, Torsion
      Dynamics/               - Healing flow, Defects
      Conservation/           - Noether, FourthLaw, SpinInformation
      Torsion/                - SpinTorsion, BigBounce (Poplawski)
      Emergence/              - ContinuumLimit, Einstein
      Variational/            - GraphAction, DiscreteNoether, InfoGeodesics
    lakefile.lean             - Build config, Mathlib version
    BUILD.md                  - Build instructions
```

## MCP Tools Available

- `lean_loogle` - Search Mathlib by type signature (works!)
- `lean_leansearch` - Natural language search (works!)
- `lean_local_search` - Search local project
- `lean_diagnostic_messages` - Has path issues, use bash instead
- `lean_build` - Has path issues, use bash instead

## Agents for Lean Proofs

Use `OpusQuantumGravityLeanProofAssistant` agent for fixing Lean proofs.
Can spawn multiple in parallel for different files.

## Proof Automation Toolkit (USE THESE FIRST!)

```lean
-- SEARCH (find proofs automatically — 30s each, searches 210K+ lemmas)
exact?          -- find ANY matching proof from Mathlib + local theorems
apply?          -- find applicable lemmas
rw?             -- find rewrite targets
simp?           -- show which simp lemmas close the goal

-- AUTOMATED SOLVERS
aesop           -- white-box best-first proof search (multi-step)
grind           -- SMT-style (Lean 4.22+, Gröbner + cutsat)
omega           -- Presburger arithmetic (ℤ/ℕ)
norm_num        -- numeric normalization
linarith        -- linear arithmetic
nlinarith       -- nonlinear arithmetic
polyrith        -- polynomial arithmetic
positivity      -- auto-prove 0 < x or 0 ≤ x
ring            -- ring equalities
field_simp      -- clear denominators
decide          -- exhaustive finite check
native_decide   -- compiled exhaustive check

-- DOMAIN-SPECIFIC
fun_prop        -- continuity / differentiability
gcongr          -- generalized congruence (monotonicity)
push_cast       -- push coercions (ℕ → ℝ, ℤ → ℝ)
fin_cases       -- case split on Fin n
```

### Strategy: try automation BEFORE manual proof
1. `exact?` → finds existing lemma (30s search)
2. `aesop` or `grind` → multi-step automation
3. `simp [lemmas]` → rewriting
4. `positivity` → any ≥ 0 or > 0 goal
5. `ring` or `field_simp; ring` → algebraic identities
6. `linarith` / `nlinarith` → inequalities
7. `decide` → finite enumeration
8. Manual only when all above fail

### Common manual tactics
```lean
div_pos, mul_pos, pow_pos          -- positivity
div_le_iff₀, div_lt_iff₀          -- division (NOTE: ₀ suffix in v4.29!)
mul_div_cancel₀                    -- cancellation (needs ne_zero)
Finset.sum_nonneg, sq_nonneg       -- sums and squares
Real.sqrt_pos_of_pos               -- square root
```

## Mathlib Import Changes (v4.29.0)

Some modules were renamed/restructured:
- `Mathlib.Data.Int.Basic` → removed (Int is in Lean core)
- `Mathlib.Algebra.BigOperators.Group.Finset.Basic` → `Mathlib.Algebra.BigOperators.Group.Finset`
- `Mathlib.Data.Nat.Cast.Order` → `Mathlib.Data.Nat.Cast.Order.Basic`

Use `lean_loogle` to find correct module paths when imports fail.
