# SU(3) `native_decide` elimination — design memo

**Target**: eliminate `native_decide` from `OmegaTheory/Emergence/SU3JacobiFull.lean:143-151` (theorems `jacobi_rat_zero` and `jacobi_sqrt3_zero`). Menkent v8 candidate `su3Jacobi_sqrt3_eliminate_native_decide_axiom` (P3t).

**Author**: session-lead + lean-proof-wizard agent, cycle-48 (2026-04-24).

**Status**: proper Matrix-Lie-algebra engineering PATH chosen over brute-force `decide` on 4096 cases.

## Failed paths (exhaustively tried)

| attempt | tactic | result |
|---|---|---|
| v1 | `revert; decide` | stuck on `Finset.univ` kernel reduction |
| v2 | `show (forall form); decide` | `show` not definitionally equal |
| v3 | `simp [jacobiRatSum] + decide` | decide sees expanded form, stuck on `Decidable` instance for ℚ |
| v4 | `decide` directly on ∀-form | same stuck reduction |
| v5 | `rw [Fin.sum_univ_eight] + decide` | progress! sum unfolds but `su3f_rat` abstract indices not reduced |
| v6 | `+ fin_cases × 4 + decide` | `decide` can't reduce `su3f_rat 0 0 0` because it's `if`-cascade |
| v7 | `+ simp only [su3f_rat, su3f_sqrt3] + rfl` | killed (too slow, 4096 rfl calls × 50-if unfold each) |
| v9 | `+ simp [...] + decide; try norm_num; try ring` | killed by user to pivot |

**Verdict**: any purely-tactical route has same fundamental cost as `native_decide` minus the compiled-code speedup. To genuinely avoid `Lean.ofReduceBool`, need the Matrix-Lie-algebra theoretical route.

## Chosen path — Matrix-Lie-algebra embedding

### Architecture

```
 Mathlib.Algebra.Lie.OfAssociative  ←  instance LieRing.ofAssociativeRing : LieRing R (ring R)
                   ↓                     auto-derives lie_jacobi from ⁅x,y⁆ = x*y - y*x
 Mathlib.Algebra.Lie.Basic          ←  instance LieAlgebra K L + lie_smul, smul_lie
                   ↓
 Mathlib.LinearAlgebra.LinearIndependent
                   ↓                     Fintype.linearIndependent_iff: LI ↔ scalars-of-zero-combo-are-zero
                                                       
 StructureConstantsJacobiAbstract.lean  ←  ABSTRACT: T : ι → L, f : ι → ι → ι → K, bracket_eq hypothesis + LI hypothesis → Jacobi for f
                   ↓
 SU3GellMannMatrixEmbedding.lean        ←  CONCRETE: 8 Gell-Mann matrices on Matrix (Fin 3) (Fin 3) ℂ,
                                                     64 per-pair commutator identity proofs,
                                                     linear independence of the 8
                   ↓
 SU3JacobiFull.lean (rewrite)           ←  su3f_jacobi_sum_zero DERIVED from embedding (no native_decide),
                                           then split via ℚ-LI of {1, √3} to get jacobi_rat_zero and jacobi_sqrt3_zero
```

### Abstract theorem (in progress)

```lean
theorem structure_constant_jacobi_of_linear_independent
    {ι : Type*} [Fintype ι]
    {K : Type*} [CommRing K]
    {L : Type*} [LieRing L] [LieAlgebra K L] [Module K L]
    {T : ι → L} (sys : StructureConstantSystem K T)
    (hLI : LinearIndependent K T)
    (a b c d : ι) :
    ∑ e, (sys.f a b e * sys.f e c d
        + sys.f b c e * sys.f e a d
        + sys.f c a e * sys.f e b d) = 0
```

**Proof outline** (currently being completed by lean-proof-wizard):
1. `lie_jacobi (T a) (T b) (T c) = 0` (from `LieRing L`)
2. Expand `⁅T a, ⁅T b, T c⁆⁆` using:
   - `sys.bracket_eq b c` replacing the inner bracket with `∑ e, f b c e • T e`
   - `lie_sum` pushing outer bracket through finite sum
   - `lie_smul` (works because K is commutative and L is a `LieAlgebra K`): `⁅T a, k • T e⁆ = k • ⁅T a, T e⁆`
3. Apply `sys.bracket_eq a e` on the remaining `⁅T a, T e⁆` to get `∑ d, f a e d • T d`
4. Combined result: `⁅T a, ⁅T b, T c⁆⁆ = ∑ e ∑ d, (f b c e * f a e d) • T d`
5. Cyclic application + `Finset.sum_comm` rearranges ∑_e ∑_d → ∑_d ∑_e
6. Additivity collapses three cyclic terms into one ∑_d with combined coefficient
7. `Fintype.linearIndependent_iff.mp hLI` extracts coefficient-zero per d

### Concrete SU(3) instantiation (cycle-49)

**Gell-Mann matrix definitions** — 8 concrete 3×3 complex matrices λ₀, ..., λ₇. Physics convention (Fin 8 indexing):
- λ₀ at index 0 corresponds to physics λ₁ (indices shifted by 1)
- Explicit entries from [Wikipedia: Gell-Mann matrices](https://en.wikipedia.org/wiki/Gell-Mann_matrices)

**Commutator identity** (to prove, 64 cases):
```lean
theorem gellMann_bracket (a b : Fin 8) :
    ⁅gellMann a, gellMann b⁆ =
      ∑ c, (2 * Complex.I * (su3f a b c : ℂ)) • gellMann c
```
Per-case (a, b) is a concrete 3×3 matrix equality; each closable by `decide` or `rfl` after `Matrix.mul_apply` unfolding + `Complex.ext`.

**Linear independence** — the 8 Gell-Mann matrices are linearly independent in the 9-dim `Matrix (Fin 3) (Fin 3) ℂ` (they span the 8-dim traceless subspace). Prove via matrix-entry-coordinate argument or cite from Mathlib if available.

### Final connection

```
su3f_jacobi_sum_zero (a b c k : Fin 8)       -- free from Matrix Jacobi + LI
         ↓
split via ℚ-LI of {1, √3} over ℚ              -- irrational_sqrt_two from Mathlib
         ↓
jacobi_rat_zero (a b c d : Fin 8)             -- no native_decide!
jacobi_sqrt3_zero (a b c d : Fin 8)           -- no native_decide!
```

## Estimated engineering effort

- Abstract theorem (StructureConstantsJacobiAbstract): **1 session** (in progress by agent)
- Gell-Mann + bracket identity (64 cases via `decide`): **1 session**
- Linear independence of Gell-Mann: **0.5 session**
- ℚ-LI split + final connection: **0.5 session**
- **Total**: 3 session equivalents (matches user's "~1 day engineering" estimate)

## Deliverables

1. `StructureConstantsJacobiAbstract.lean` — abstract theorem (this session)
2. `SU3GellMannMatrixEmbedding.lean` — concrete matrices + bracket + LI (cycle-49)
3. Patched `SU3JacobiFull.lean` — two `native_decide` uses replaced (cycle-49)

## Follow-up

When all three deliverables land:
- Run `lean_verify` on `jacobi_rat_zero` and `jacobi_sqrt3_zero`
- Confirm axiom footprint = Lean core only (no `Lean.ofReduceBool`)
- Menkent v8 P3t officially CLOSED

**Axiom-budget impact**: −1 Lean-core-compilation axiom (`Lean.ofReduceBool`). No change to physical/research axiom count.

---

*Hand-written by session-lead 2026-04-24. Subagent `a242f415d4beca194` (lean-proof-wizard) is currently completing the abstract theorem in `/home/norbert/lean-v2/OmegaTheory/Emergence/StructureConstantsJacobiAbstract.lean`.*
