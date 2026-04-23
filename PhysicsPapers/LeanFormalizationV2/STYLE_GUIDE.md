# OmegaTheory V2 — Style Guide (Same Language)

**Purpose**: all theorems, definitions, and proofs speak the SAME language so they compose cleanly.

---

## 1. Naming conventions

### Theorems
```
<entity>_<property>           e.g., computationalUncertainty_pos
<entity>_<property>_of_<hyp>  e.g., ricciSymmetric_of_weinbergIdentity
<predicate>_iff_<predicate>   e.g., isEquilibrium_iff_fixedPoint
<quantity>_eq_<closed_form>   e.g., repairQuantumEnergy_eq_log5_pi
<thing>_tendsto_<limit>       e.g., substrateHopfError_tendsto_zero
<thing>_decreasing / _pos / _nonneg  standard suffixes
```

### Structures
```
<Name>Data     — bundle of parameters (e.g., FRWScaleFactorData)
<Name>Bound    — upper/lower bound type (e.g., ErrorBound)
<Name>Hypothesis — Prop-valued assumption bundle (e.g., HpwHypothesis)
<Name>Class    — typeclass (e.g., ErrorLieBracket, ErrorLieAlgebra)
```

### Predictions
Every file in `Predictions/` follows:
```
<prediction>Substrate     — the substrate's formula
<prediction>StandardQM    — the SM/QM baseline (often = 0)
<prediction>_strictly_exceeds_standard_QM  — the distinguisher
<prediction>_pos / _nonneg / _monotone  — structural properties
<prediction>_closed_form  — explicit formula reminder
```

---

## 2. Shared primitives (USE these, don't re-invent)

| Concept | Primitive | File |
|---|---|---|
| Planck constants | `l_P`, `t_P`, `hbar`, `c`, `G_N`, `k_B`, `E_P`, `M_P` | `Spacetime/Constants.lean` |
| Positivity | `l_P_pos`, `t_P_pos`, `hbar_pos`, `c_pos`, `E_P_pos` | same |
| Nonnegativity | `l_P_nonneg`, etc. | same |
| Ne_zero | `l_P_ne_zero`, `c_ne_zero`, `t_P_ne_zero`, `hbar_ne_zero` | same |
| Substrate error | `computationalUncertainty N`, `dominantErrorBound N` | `Irrationality/Uncertainty.lean` |
| Error bound | `ErrorBound` (val + nonneg fields) | `Foundations/ErrorAlgebra.lean` |
| Lie bracket error | `substrateLieBracketError N` | `Foundations/ErrorLieAlgebra.lean` |
| Hopf error | `substrateHopfError N` | `Foundations/ErrorHopfStructure.lean` |
| Form error | `ErrorForm0/1/2/3` | `Foundations/ErrorForms.lean` |
| HPW bundle | `HpwHypothesis g` | `Emergence/HpwHypothesis.lean` |
| HPW regime class | `[HpwEliminableRegime g]` | `Emergence/HpwElimSummary.lean` |
| Smooth metric | `SmoothMetric` (Mizar) | `Geometry/SmoothMetric.lean` |
| Iteration budget | `iterationBudget T` | `Irrationality/Uncertainty.lean` |
| Mass-as-delay | `perTickDelay p m` | `Emergence/MassAsDelay.lean` |

**Rule**: if a primitive exists, USE it. Don't redefine under a new name.

---

## 3. Proof automation (try in order)

```lean
-- 1. First try AUTOMATED SEARCH
exact?              -- 30s Mathlib + local search
apply?              -- lemma application search
rw?                 -- rewrite search

-- 2. Then try MULTI-STEP automation
aesop               -- white-box best-first
grind               -- SMT solver (4.22+)
simp?               -- simp lemma discovery

-- 3. Then DOMAIN-SPECIFIC solvers
positivity          -- 0 < x or 0 ≤ x
ring                -- ring equalities
field_simp          -- clear denominators (then ring)
linarith            -- linear arithmetic
nlinarith           -- nonlinear
omega               -- integer arithmetic
decide              -- finite enumeration
native_decide       -- compiled enumeration
norm_num            -- numerics
push_cast           -- coercion pushing
fin_cases           -- case split on Fin n

-- 4. Only AFTER automation fails, manual proof
```

---

## 4. Docstring pattern

Every theorem has a docstring:

```lean
/-- **Name in words** (one sentence).

    Longer explanation if needed: 2-3 sentences about what it means,
    why it matters, and how it connects to other theorems in the project.

    Cites: [Predictions §N / Appendix-X §Y] if paper-referenced.
    No `sorry`, no new axioms. -/
theorem my_theorem ...
```

---

## 5. File header pattern

```lean
/-
  OmegaTheory.<Module>.<Name>

  **One-line headline**: what this file establishes.

  Background context (2-3 paragraphs).

  Theorems shipped:
    §1. `theorem_1` — one-liner
    §2. `theorem_2` — one-liner
    ...

  No `sorry`. No new axioms. Author: <star_name>, 2026-04-XX.
-/

import ...

namespace OmegaTheory.<Module>

open OmegaTheory.Spacetime
-- other opens
```

---

## 6. Registration discipline

Every new file MUST be registered in `OmegaTheory/Basic.lean` under the correct layer:

```
Layer 0: Foundations  (ErrorAlgebra, ErrorLieAlgebra, ErrorForms, ErrorHopf, TaylorBound)
Layer 1: Spacetime    (Lattice, Constants, Operators, CausalLattice)
Layer 2: Tensor       (ErrorTensor, Operations, ValuedGeometry, ValuedCurvature)
Layer 3: Geometry     (Metric, Connection, Curvature, DiscreteForms, ...)
Layer 5: Defects      (DefectTensor, Sparsity)
Layer 6: Conservation (Information, Noether, StressEnergy, Correspondence)
Layer 7: HealingFlow  (Functional, Flow, Lyapunov, Periodic, Convergence)
Layer 8: Emergence    (Einstein, HPW regimes, QM, Gauge theories, Cosmology)
Layer 9: Predictions  (falsifiable claims with specific formulas)
Layer 10: Torsion     (SpinTorsion, BigBounce)
Layer 11: Irrationality (Approximations, Uncertainty, PredictionsBridge)
Layer 12: Variational (GraphAction, DiscreteNoether)
Layer 13: Paper       (headline aliases for manuscript citation)
```

---

## 7. The "connect don't duplicate" rule

Before writing a new theorem:
1. **Grep** for similar names (`grep -rn "similar_name" OmegaTheory/`)
2. **exact?** search in a scratch Lean file
3. If already proven, CITE it. If close but not exact, COMPOSE.
4. Only write new if the gap is genuine.

---

## 8. Hard rules (enforced globally)

1. **0 sorry** — absolutely never
2. **0 new axioms** — the 8 physical constants are the complete axiom list
3. **Must compile GREEN** — `~/.elan/bin/lake build --log-level=error`
4. **Register in Basic.lean** — no orphan files
5. **Quality over speed** — iterate until clean
6. **Speak the same language** — use primitives from §2, naming from §1

---

*Team-lead, 2026-04-17. Update when new primitives emerge.*
