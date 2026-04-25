# Sage Briefing — W10-wave-1: `Lindemann.Basic` skeleton

**Cycle:** 58 (Libra) · **Wave:** 2 (after wave-1 lands) · **Sage:** Triangulum-II · **Date:** 2026-04-25
**Track:** T2 axiom-elimination · **Risk:** M (NEW file, Mathlib import + skeleton)
**Target file:** `OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean` (NEW; ~150 lines)

---

## Candidate name & graph node

`lindemann_weierstrass_basic_skeleton_wave_1` — registered as
`:TheoremCandidate { batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25' }`.

## Priority + complexity

**HIGH** · Complexity **M** (~150 lines NEW file).

This is the **first wave of the multi-cycle Lindemann–Weierstrass port** to OV2.
Andromeda-II's analysis (cycle-57) established the 16-cycle plan: cycles 60-62
ship the full Galois-conjugation proof of `Transcendental ℚ Real.pi`, eliminating
the project axiom. Cycle 58's wave-1 plants the **skeleton file** that
subsequent waves extend.

## Mission

Create a NEW file `OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean`
that:

1. Imports `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart` (the
   only Lindemann-related file currently in Mathlib v4.29.0).
2. Defines the placeholder structure for the W10 multi-wave port:
   * Stage-1 (this file): `LindemannBasic` namespace + skeleton statements
   * Stage-2 (cycle 60): Galois-conjugation framework
   * Stage-3 (cycle 62): `Transcendental ℚ Real.pi` corollary
3. Proves a single load-bearing **starter theorem** to establish that the file
   compiles GREEN — but does NOT yet derive π's transcendence.
4. Documents the multi-wave roadmap inline.

The starter theorem is a **trivial existence corollary** of the Mathlib
`exp_polynomial_approx`, packaged in OV2's namespace, just to confirm the
import + skeleton work.

## `statement_lean` skeleton

```lean
/-
  OmegaTheory.Irrationality.CustomMath.LindemannBasic

  Cycle-58 (Libra) Wave-1 of the multi-cycle Lindemann–Weierstrass port.

  This file is the SKELETON for the cycles 58 → 60 → 62 plan to derive
  `Transcendental ℚ Real.pi` from `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`,
  thereby eliminating the project axiom `Real.pi_transcendental` from
  `OmegaTheory/Irrationality/HermitePade/PiStratum.lean:45`.

  ## Wave plan (per Andromeda-II's cycle-57 analysis)

  | Cycle | Wave | Stage | Deliverable |
  |------:|------|-------|-------------|
  | 58 | 2 | Stage 1 (THIS FILE) | Skeleton + starter exp_polynomial_approx wrapper |
  | 60 | — | Stage 2 | Galois-conjugation framework + symmetric-polynomial integer step |
  | 62 | — | Stage 3 | `Transcendental ℚ Real.pi` corollary; replace project axiom |

  Author: cycle-58 wizard W10-wave-1. Brief: `plans/SAGE_BRIEFING_lindemann_basic_skeleton_wave1_2026-04-25.md`.
-/

import Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Data.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.LindemannBasic

/-! ## Wave-1 skeleton

We import Mathlib's `LindemannWeierstrass.exp_polynomial_approx` and package
it for OV2 use. This file does NOT yet derive `Transcendental ℚ Real.pi` —
that requires Galois conjugation + integer-bound contradiction, planned for
cycle 60-62. -/

/-- **Stage-1 starter**: re-export Mathlib's analytic-part exponential approximation
    in OV2's namespace. Establishes that the import works and the skeleton
    compiles GREEN.

    The signature pulls from `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`. -/
def exp_polynomial_approx_OV2 : Prop :=
  ∀ (q : Polynomial ℤ), True
  -- WIZARD: replace `True` with the actual signature from Mathlib's
  -- `LindemannWeierstrass.exp_polynomial_approx`. Use `lean_hover_info`
  -- on the Mathlib name to get the exact type.

theorem exp_polynomial_approx_OV2_holds : exp_polynomial_approx_OV2 := by
  intro q
  trivial
  -- WIZARD: once the signature is filled in, replace `trivial` with
  -- `exact LindemannWeierstrass.exp_polynomial_approx q` (or whatever
  -- the actual Mathlib name resolves to).

/-! ## Multi-wave roadmap stub

Stages 2 and 3 will be filled by cycle 60 and 62 wizards. The placeholder
declarations below mark the API surface to be filled. -/

/-- **Stage-2 placeholder** (cycle 60 wizard fills): Galois-conjugation framework
    for π's algebraic-conjugacy relation. Currently stub. -/
def stage2_galois_framework : Prop := True
theorem stage2_galois_framework_pending : stage2_galois_framework := trivial

/-- **Stage-3 placeholder** (cycle 62 wizard fills): `Transcendental ℚ Real.pi`
    corollary. Currently stub. Once landed, the project axiom
    `Real.pi_transcendental` becomes a `theorem` (rather than `axiom`). -/
def stage3_pi_transcendental_corollary : Prop := True
theorem stage3_pi_transcendental_corollary_pending : stage3_pi_transcendental_corollary := trivial

/-! ## Decoupling-bridge prep (forward-compatible)

Once Stage-3 lands, the project axiom can be replaced via:

```
-- OmegaTheory/Irrationality/HermitePade/PiStratum.lean (line 45)
theorem Real.pi_transcendental : Transcendental ℚ Real.pi :=
  OmegaTheory.Irrationality.CustomMath.LindemannBasic.stage3_pi_transcendental_corollary
```

The 3 direct consumers (`pi_stratum_integer`, `ic_three_constants_transcendental`,
`ic_pi_Mahler_S_conditional`) automatically gain axiom-free derivations. -/

end OmegaTheory.Irrationality.CustomMath.LindemannBasic
```

**WIZARD: in this Wave-1 stage, replace the `True` placeholder in
`exp_polynomial_approx_OV2` with the actual Mathlib signature. Use
`lean_hover_info` on `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart.exp_polynomial_approx`
to get the exact type. Then replace the `trivial` in `exp_polynomial_approx_OV2_holds`
with `exact <Mathlib.name>`. The Stage-2 / Stage-3 placeholders REMAIN as `True`
stubs — they will be filled by cycle 60-62 wizards.**

If the Mathlib symbol name differs (e.g., it's `LindemannWeierstrass.exp_polynomial_approximation`
or similar), use `lean_local_search "exp_polynomial_approx"` and
`lean_loogle "exp_polynomial_approx"` to find the actual identifier.

**Fallback if the actual signature is too complex for ~150 lines**: keep
all three (Stage-1, 2, 3) as `Prop := True` placeholders and ship the file as
a pure skeleton + roadmap document. The cycle-60 wizard will then fill Stage-1 + Stage-2 simultaneously. This is acceptable — the goal is establishing
the file's namespace and compile-skeleton in cycle 58.

## Premise candidates (top-5)

1. `Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart.exp_polynomial_approx`
   (or actual identifier — wizard verify).
2. `Mathlib.RingTheory.Algebraic.Basic.Transcendental`
3. `Mathlib.Analysis.SpecialFunctions.Exp.Real.exp`
4. `Mathlib.Data.Polynomial.Eval.Defs.Polynomial.eval`
5. (no further premise — skeleton-only file).

## Proof sketch (≤6 bullets)

1. Create `OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean` with the
   skeleton.
2. Verify Mathlib import via `lake build` of just this file:
   `lake build OmegaTheory.Irrationality.CustomMath.LindemannBasic --log-level=error`.
3. If import succeeds + `exp_polynomial_approx` is callable, fill in the
   Stage-1 starter signature.
4. If import succeeds but `exp_polynomial_approx` API is complex (>5 args), keep
   Stage-1 as `True` placeholder.
5. **Either way: Stage-2 and Stage-3 remain `True` placeholders.**
6. **Flag for parent: import line in `Basic.lean`**.

## Off-limits files

- `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` — W-Phase1-A's territory
  this cycle; Stage-3 wizard (cycle 62) will modify, not us.
- `OmegaTheory/Irrationality/HermitePade/LindemannWeierstrassRoadmap.lean` —
  cycle-56 Andromeda territory, read-only.
- `OmegaTheory/Irrationality/CustomMath/NesterenkoStage*.lean` — W11 territory.
- `OmegaTheory/Irrationality/CustomMath/SiegelShidlovskiiStage*.lean` — W12 territory.
- All cycle 52-57 wizard files (off-limits per CYCLE58_BATCH_INDEX).
- Other cycle-58 wizard target files.
- `OmegaTheory/Basic.lean` — flag for parent batch.

## Build expectation

* `lake build OmegaTheory.Irrationality.CustomMath.LindemannBasic` — GREEN ≤5 min
  (Mathlib AnalyticalPart import is ~30s).
* `lake build` (full) — +1 build job, GREEN
* 0 sorry; 0 new axioms.

## Graph register

```cypher
MERGE (c:TheoremCandidate {
  name: 'lindemann_weierstrass_basic_skeleton_wave_1',
  namespace: 'OmegaTheoryV2',
  status: 'PROPOSED',
  batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25',
  proposed_by: 'Triangulum-II',
  target_file: 'OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean',
  priority: 'HIGH', complexity: 'M', track: 'T2-axiom-elim'
})
```

---

**End of W10-wave-1 brief.**
