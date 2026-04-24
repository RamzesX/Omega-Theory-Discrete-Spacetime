# Handoff 4 — cycle-49 P3t mission (2026-04-24)

**User directive**: "this will be our goal to get this done, no matter what".

## The ONE Goal

Eliminate `native_decide` from `PhysicsPapers/LeanFormalizationV2/OmegaTheory/Emergence/SU3JacobiFull.lean:143-151` — lines:

```lean
-- Line 143-145
theorem jacobi_rat_zero (a b c d : Fin 8) : jacobiRatSum a b c d = 0 := by
  revert a b c d
  native_decide

-- Line 149-151
theorem jacobi_sqrt3_zero (a b c d : Fin 8) : jacobiSqrt3Sum a b c d = 0 := by
  revert a b c d
  native_decide
```

`native_decide` adds `Lean.ofReduceBool` to the axiom footprint. **Goal**: replace with elegant proof that reduces axioms to `[propext, Classical.choice, Quot.sound]` only.

## What's already shipped (cycle-48, all GREEN, committed on `main`)

### `OmegaTheory/Emergence/StructureConstantsJacobiAbstract.lean`
The abstract engine. Given ANY family `T : ι → L` in a `LieRing L` with:
- `LieAlgebra K L` over commutative `K`
- `StructureConstantSystem T` bundling `f : ι → ι → ι → K` + the identity `⁅T a, T b⁆ = ∑ c, f a b c • T c`
- `LinearIndependent K T`

Yields Jacobi for `f`:
```
theorem structure_constant_jacobi_of_linear_independent :
    ∑ e, (f b c e * f a e d
        + f c a e * f b e d
        + f a b e * f c e d) = 0
```

**Axiom footprint confirmed**: `[propext, Classical.choice, Quot.sound]` only.

### `OmegaTheory/Emergence/SU3GellMannMatrixEmbedding.lean`
Scaffold: 8 concrete Gell-Mann matrices `gellMann : Fin 8 → Matrix (Fin 3) (Fin 3) ℂ`, `gellMann_diagonal_zero`, `gellMann_antisym`, one example `gellMann_0_1_eq : ⁅λ₁, λ₂⁆ = 2i·λ₃`.

### Design memo
`PhysicsPapers/LeanFormalizationV2/plans/SU3_NATIVE_DECIDE_ELIM_PLAN_2026-04-24.md` — full architecture.

## What remains (3 concrete pieces)

### Piece 1: `gellMann_commutator` (64 pairs)

```lean
theorem gellMann_commutator (a b : Fin 8) :
    ⁅gellMann a, gellMann b⁆ =
      ∑ c, ((2 * I : ℂ) * ((su3f a b c : ℂ))) • gellMann c
```

**PROVEN WORKABLE** in cycle-48 via standalone `_gm_full.lean` test — the following tactic compiles GREEN in ~5 min at 40M heartbeats:

```lean
import OmegaTheory.Emergence.SU3GellMannMatrixEmbedding
import OmegaTheory.Emergence.ErrorGaugeSU3
import Mathlib.Algebra.BigOperators.Fin

open OmegaTheory.Emergence.SU3GellMannMatrixEmbedding
open OmegaTheory.Emergence.ErrorGaugeSU3 (su3f)
open Matrix Complex

set_option maxHeartbeats 40000000 in
example (a b : Fin 8) :
    ⁅gellMann a, gellMann b⁆ =
      ∑ c, ((2 * I : ℂ) * ((su3f a b c : ℂ))) • gellMann c := by
  ext i j
  fin_cases a <;> fin_cases b <;> fin_cases i <;> fin_cases j <;>
    (first
      | rfl
      | (unfold gellMann su3f;
         simp [Ring.lie_def, Matrix.mul_apply, Fin.sum_univ_three,
               Fin.sum_univ_eight, Matrix.smul_apply, Complex.I_sq];
         try ring)
      | (unfold gellMann su3f;
         simp [Ring.lie_def, Matrix.mul_apply, Fin.sum_univ_three,
               Fin.sum_univ_eight, Matrix.smul_apply, Complex.I_sq]))
```

**CRITICAL PARSER GOTCHA**: `set_option maxHeartbeats 40000000 in` must come **BEFORE** any docstring `/-- ... -/`, otherwise parser error `unexpected token 'set_option'; expected 'lemma'`. The sequence that works:
```
set_option maxHeartbeats 40000000 in
/-- docstring -/
theorem ...
```
does NOT work reliably. Put the `set_option` FIRST, then docstring, then `theorem` — OR use a `section` with persistent `set_option`:
```
section
set_option maxHeartbeats 40000000
/-- docstring -/
theorem gellMann_commutator ...
end
```

### Piece 2: `gellMann_linearIndependent`

```lean
theorem gellMann_linearIndependent : LinearIndependent ℂ gellMann
```

Approach: matrix-entry coordinates. Map each `gellMann i` to its 9-tuple of matrix entries `((i,j,k) ↦ gellMann i j k)` via `Fintype.linearIndependent_iff`:

```lean
theorem gellMann_linearIndependent : LinearIndependent ℂ gellMann := by
  rw [Fintype.linearIndependent_iff]
  intro g hsum i
  -- Extract: evaluate at specific matrix entries showing that g i = 0 for each i.
  -- Since different gellMann are supported on different entries (e.g. λ₁ has
  -- non-zero (0,1) and (1,0); λ₃ has non-zero (0,0) and (1,1); etc.), one entry
  -- per Gell-Mann uniquely identifies its coefficient.
  fin_cases i <;> [
    have := congrFun (congrFun hsum 0) 1;    -- g 0 at (0,1)-entry
    have := congrFun (congrFun hsum 0) 1;    -- g 1 at (0,1)-entry (imaginary)
    have := congrFun (congrFun hsum 0) 0;    -- g 2 at (0,0)-entry
    -- ... 8 cases total
  ] <;>
  (simp [gellMann, Finset.sum_apply, Matrix.smul_apply, ...] at *;
   linarith)  -- or linear_combination
```

Estimated ~100-150 lines. 1 session.

### Piece 3: Bridge to `jacobi_rat_zero` / `jacobi_sqrt3_zero`

Once pieces 1+2 land:

```lean
-- Create the structure-constant system.
noncomputable def su3GellMannSys : StructureConstantSystem gellMann where
  f := fun a b c => (2 * I : ℂ) * ((su3f a b c : ℂ))
  bracket_eq := by
    intro a b
    rw [gellMann_commutator]
    -- simp normalization
    sorry -- small algebra: pull 2i out

-- Apply abstract helper.
theorem su3f_jacobi_natural_convention (a b c d : Fin 8) :
    ∑ e, ((2*I * (su3f b c e : ℂ)) * (2*I * (su3f a e d : ℂ))
        + (2*I * (su3f c a e : ℂ)) * (2*I * (su3f b e d : ℂ))
        + (2*I * (su3f a b e : ℂ)) * (2*I * (su3f c e d : ℂ))) = 0 :=
  structure_constant_jacobi_of_linear_independent
    su3GellMannSys gellMann_linearIndependent a b c d

-- Convert to SU3JacobiFull's convention using su3f total antisymmetry.
-- Then split by ℚ-linear independence of {1, √3} over ℚ.
-- End result: jacobi_rat_zero and jacobi_sqrt3_zero WITHOUT native_decide.
```

Estimated 100-200 lines. 1 session.

## Verification

Post-closure, run:
```bash
cd /home/norbert/lean-v2
~/.elan/bin/lake build OmegaTheory.Emergence.SU3JacobiFull --log-level=error

echo 'import OmegaTheory.Emergence.SU3JacobiFull
#print axioms OmegaTheory.Emergence.SU3JacobiFull.jacobi_rat_zero
#print axioms OmegaTheory.Emergence.SU3JacobiFull.jacobi_sqrt3_zero' > /tmp/_axcheck.lean
~/.elan/bin/lake env lean /tmp/_axcheck.lean
```

**Expected**: `[propext, Classical.choice, Quot.sound]` (NO `Lean.ofReduceBool`).

## Working environment

- **Workdir**: `/home/norbert/lean-v2/` (native ext4, ~115× faster than `/mnt/c`)
- **Sync**: copy to `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/` at commit time
- **Commits**: committed tree is at `/mnt/c/...`, branch `main`
- **Services**: embedder + reranker KILLED for power saving; Neo4j live at bolt://localhost:7687 with heap 24G / pagecache 64G

## HARD rules

- 0 sorry
- 0 new axioms (including: NO `native_decide`, NO research axioms for this P3t)
- Builds GREEN
- Elegant over brute force, but per-pair matrix verification IS necessary per Wikipedia's definition of structure constants (no abstract shortcut for the specific `gellMann ↔ su3f` alignment).

## Last session state

Final commit `7dba962` — scaffold clean GREEN; P3t documentation + abstract-theorem ready; awaits cycle-49 to execute the 3 remaining pieces.

See memory files:
- `project_p3t_native_decide_elim_mission.md`
- `project_cycle_48_session_summary.md`
