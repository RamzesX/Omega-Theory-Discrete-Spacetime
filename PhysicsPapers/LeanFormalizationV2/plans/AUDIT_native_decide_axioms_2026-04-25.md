# AUDIT — `native_decide`-derived axioms in OmegaTheory V2

**Author**: Beid (omicron¹ Eridani K2III, lean-proof-wizard cycle-54 Phase B)
**Date**: 2026-04-25
**Mandate**: Zubeneschamali briefing
`plans/SAGE_BRIEFING_native_decide_axiom_elim_via_decide_2026-04-25.md`
**Outcome**: **CLOSED-AS-NO-OP** — already eliminated by cycle-49 P3t (Almach²,
April 17, 2026). This memo documents the audit, verification, and graph-hygiene.

---

## 1. Briefing premise

> The graph contains 2 `:TheoremCandidate` with
> `status=AUTO_GENERATED_NATIVE_DECIDE`. These are leftover from the cycle-49
> P3t closure's `native_decide` tactics — each `native_decide` use registers
> an axiom `_native_decide_ax_*` in the kernel.
>
> We replace `native_decide` with `decide` where the proposition is genuinely
> decidable in fewer kernel reductions, OR factor through a non-native_decide
> path.

— Zubeneschamali briefing, lines 12–20.

## 2. Codebase audit

### 2.1 Project-wide grep for `native_decide` tactic invocations

```bash
grep -rEn 'by\s+native_decide|^\s*native_decide\b' \
   /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/OmegaTheory/
```

**Result**: 0 matches.

### 2.2 Project-wide grep for the bare token `native_decide`

```bash
grep -rEn 'native_decide' \
   /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/OmegaTheory/
```

**Result**: 16 matches, **all** of which are inside comments or docstrings.
Inventory:

| File | Line | Context |
|------|------|---------|
| `Conservation/SpinInformation.lean` | 28 | docstring |
| `Emergence/StructureConstantsJacobiAbstract.lean` | 5 | docstring |
| `Emergence/SU3GellMannMatrixEmbedding.lean` | 6, 100 | docstring |
| `Emergence/SU3JacobiDefs.lean` | 6, 13 | docstring |
| `Emergence/SU3JacobiFull.lean` | 12, 15, 211 | docstring (`## P3t — native_decide elimination`) |
| `Emergence/SU3JacobiIdentity.lean` | 12, 354 | docstring |
| `Emergence/SU3JacobiViaMatrix.lean` | 4, 21, 237, 252 | docstring |
| `Probe/AmbitiousProofs.lean` | 18 | docstring |

**Every single hit** documents the *absence* of `native_decide`, not its use.

### 2.3 Mathlib package directory

`grep` reports 16 hits inside `.lake/packages/mathlib/MathlibTest/...`. These
are upstream Mathlib test files that are not part of our build target and not
imported by any OmegaTheory module. Out of scope.

## 3. Lean env-level axiom verification

Ran `#print axioms` on the four headline theorems in
`OmegaTheory.Emergence.SU3JacobiFull`:

```
'OmegaTheory.Emergence.SU3JacobiFull.jacobi_rat_zero'
    depends on axioms: [propext, Classical.choice, Quot.sound]

'OmegaTheory.Emergence.SU3JacobiFull.jacobi_sqrt3_zero'
    depends on axioms: [propext, Classical.choice, Quot.sound]

'OmegaTheory.Emergence.SU3JacobiFull.su3f_jacobi_sum_zero'
    depends on axioms: [propext, Classical.choice, Quot.sound]

'OmegaTheory.Emergence.SU3JacobiFull.su3Bracket_jacobi_basis_all'
    depends on axioms: [propext, Classical.choice, Quot.sound]
```

All four show **Lean core only**. No `Lean.ofReduceBool` axiom present.

## 4. Closure mechanism — cycle-49 P3t (recap)

The current proofs route through:

```
SU3JacobiViaMatrix.jacobi_rat_zero_via_matrix
SU3JacobiViaMatrix.jacobi_sqrt3_zero_via_matrix
```

which apply `structure_constant_jacobi_of_linear_independent` (the abstract
Jacobi-from-bracket helper) to the `gellMann_commutator` Lie-bracket data
under the {1, √3} ℚ-linear-independence split. No `native_decide` enters the
chain at any point. Documented in `SU3JacobiViaMatrix.lean` lines 1–25 and
`SU3JacobiFull.lean` lines 12–26.

## 5. Why the briefing premise was stale

The 2 `:TheoremCandidate` graph nodes
- `elim_OmegaTheory.Emergence.SU3JacobiFull.jacobi_rat_zero._native.native_decide.ax_1_1`
- `elim_OmegaTheory.Emergence.SU3JacobiFull.jacobi_sqrt3_zero._native.native_decide.ax_1_1`

are artifacts of a pre-cycle-49 graph snapshot, when those theorems still went
through `native_decide` and the kernel registered synthetic axioms named
`_native_decide_ax_*`. After the cycle-49 matrix-Lie-algebra rewrite, those
axioms vanished from the env but the candidate-tracking nodes were not pruned.

The briefing's reference to
`OmegaTheory.Algebra.GellMann.LinearIndependence` using `native_decide` for
the 64-pair commutator computation is also obsolete. The current
`gellMann_commutator` route (in `SU3GellMannMatrixEmbedding.lean` and
`SU3GellMannLinearIndependent.lean`) does not use `native_decide` — it uses
`decide` for `(3 : ℕ).Prime` and matrix-algebra computation for the
commutators.

## 6. Deliverables

### 6.1 Defensive Lean module (regression sentinel)

`OmegaTheory/Probe/NativeDecideAxiomElimAudit.lean` (NEW, 1 file, ~120 lines)

Five top-level declarations (4 audit aliases + 1 conjunction summary):

- `audit_jacobi_rat_zero`
- `audit_jacobi_sqrt3_zero`
- `audit_su3f_jacobi_sum_zero`
- `audit_su3Bracket_jacobi_basis_all`
- `native_decide_axiom_elim_audit_pure_decide` (5-conjunct master)

All five verified via `#print axioms` to carry
`[propext, Classical.choice, Quot.sound]` only.

**Build outcome**: 3,304/3,304 jobs GREEN; +1 file vs. baseline 3,303 (the
SU3JacobiFull dependency closure). `Basic.lean` not modified — file lives in
`Probe/` which is not auto-imported (parent owns `Basic.lean`).

### 6.2 Graph hygiene (Neo4j)

Two stale `:TheoremCandidate` nodes flipped from `AUTO_GENERATED_NATIVE_DECIDE`
to `CLOSED_BY_NATIVE_DECIDE_ELIM`, with `closed_by='Beid'` and
`closed_via='cycle-49 P3t Almach² matrix-Lie-algebra route — verified by Beid 2026-04-25'`.

The proposed `native_decide_axiom_elim_via_pure_decide` candidate flipped to
`CLOSED_BY_NO_OP_AUDIT`.

### 6.3 This memo (`plans/AUDIT_native_decide_axioms_2026-04-25.md`)

You are reading it.

## 7. Recommendations forward

- **Keep** `OmegaTheory/Probe/NativeDecideAxiomElimAudit.lean` in tree as a
  permanent regression sentinel. If a future refactor accidentally
  re-introduces `native_decide` anywhere in the closure of the four headlines,
  the resulting `Lean.ofReduceBool` axiom will surface in
  `#print axioms native_decide_axiom_elim_audit_pure_decide` and be caught by
  any `axiom_audit` run.
- **Consider** wiring the `axiom_audit` MCP tool to assert that the audit
  module's five declarations carry exactly `[propext, Classical.choice, Quot.sound]`
  on every Phase C close.
- **Stretch goal** (`pi_transcendental_blast_radius_audit`): not attempted in
  this session — context budget consumed by audit verification + memo writing.
  Atria's cycle-53 work (`OmegaTheory/IrrationalityClasses/AxiomNarrowing.lean`)
  is the right foundation; a follow-up wizard can extend it.

## 8. Axiom-count delta

| Metric | BEFORE Beid | AFTER Beid |
|---|---|---|
| `axiom` declarations on physical constants | 0 | 0 |
| Primitive assumptions (paper-headline) | 1 (`Real.pi_transcendental`) | 1 (unchanged) |
| Total inc. research (HermitePadé) | 5 | 5 (unchanged) |
| `:TheoremCandidate AUTO_GENERATED_NATIVE_DECIDE` (graph) | 2 | 0 |
| `Lean.ofReduceBool` axiom in dependency closure of 4 SU3 Jacobi headlines | 0 | 0 (re-verified) |

**Net impact**: 0 new axioms, 0 axioms removed (since they were already gone),
+1 audit module preventing regression, 2 stale graph candidates flipped to
closed.

---

*End of audit. Beid (omicron¹ Eridani K2III), 2026-04-25.*
