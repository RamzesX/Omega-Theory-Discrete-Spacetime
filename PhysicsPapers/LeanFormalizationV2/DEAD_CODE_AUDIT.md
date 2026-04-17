# DEAD CODE AUDIT — OmegaTheory V2

**Date:** 2026-04-17
**Auditor:** Ruchbah (δ Cassiopeiae)
**Scope:** every `.lean` under `OmegaTheory/` (193 files total)
**Reachability root:** `OmegaTheory.lean` → `OmegaTheory/Basic.lean`

---

## Executive summary

| Metric | Count |
|---|---|
| Total `.lean` files under `OmegaTheory/` | 193 |
| Imported transitively from `Basic.lean` | ~151 |
| **Orphan files (NOT reachable from `Basic.lean`)** | **48** |
| Real `sorry` occurrences | **0** (clean) |
| `axiom` declarations outside `Spacetime/Constants.lean` | 14 (ALL in orphan `HermitePade/` subtree) |
| Duplicate imports in Basic.lean | 1 (`FermionContent` imported twice) |
| Deprecated Mathlib names (e.g., `div_le_iff` without `₀`) | 0 (clean) |
| Live `exact?` / `apply?` in production | 0 (only in `Probe/` comments) |

**Headline finding:** the entire `OmegaTheory/Irrationality/HermitePade/` subtree (33 files)
and a large slice of `Emergence/` + `Predictions/` + `Probe/` (15 files) are
**disconnected from the build root**.  Lake does not compile them by default,
they do not contribute to the "3475 jobs GREEN" count, and their theorems
are not available to downstream files via transitive import.

Many orphan files are **finished work** (0 sorry, 0 axioms, clear docstrings).
They look like wave-3/wave-4 deliverables that were completed but never wired
into `Basic.lean`.  A mechanical "append imports" pass would recover them.

---

## Section 1 — Orphan files (not reachable from Basic.lean)

### 1A. `OmegaTheory/Irrationality/HermitePade/` — ENTIRE SUBTREE orphan (33 files)

`Basic.lean` imports `OmegaTheory.Irrationality.{Approximations, ActionDensity,
Uncertainty, BoundsLemmas, PredictionsBridge}`.  **No `HermitePade.*` appears
in `Basic.lean`.**  Every `HermitePade/*.lean` file is only imported by other
`HermitePade/*.lean` files — it is a closed, disconnected island.

All 33 files:

```
Attack13_SliceOneThird.lean         F27_TaylorPartialSum.lean
BridgeTheorem.lean                  F49_Existence.lean
BridgeTheorem_Frequencies.lean      F50_Cauchy.lean
Conj_4A4_Statement.lean             F50_Contour_Integral.lean
Decoupling.lean                     F50_Decay.lean
F26_MahlerEquation.lean             F51_Denominator.lean
F26_MahlerEquation_convergent.lean  F51_Effective_Denominator.lean
F27_E_Denominator.lean              F52_P3_Rescue.lean
F27_E_Dominates_G.lean              F54_AlphaSlope.lean
F27_G_Denominator.lean              F54_AlphaSlope_ClosedForm.lean
F27_LegendreSlope.lean              F54_Parity.lean
F27_LucasSeparation.lean            F54_SlicePrime.lean
F27_Quantitative.lean               F56_StokesClosedForm.lean
GAP_M_Conjecture.lean               SSReduction.lean
GAP_N_Conjecture.lean               UniversalSiegelBarrier.lean
Niven_Arctan.lean                   PiStratum.lean
```

**Inside-island leaves** (imported by nobody — orphans even within HermitePade):
`Attack13_SliceOneThird.lean`, `BridgeTheorem.lean`, `BridgeTheorem_Frequencies.lean`,
`F49_Existence.lean`, `F50_Cauchy.lean`, `F50_Contour_Integral.lean`,
`F50_Decay.lean`, `F56_StokesClosedForm.lean`, `GAP_M_Conjecture.lean`,
`GAP_N_Conjecture.lean`, `Niven_Arctan.lean` (imported only by also-orphan
`Attack13_SliceOneThird`), `PiStratum.lean`, `SSReduction.lean`,
`UniversalSiegelBarrier.lean`, `F26_MahlerEquation_convergent.lean`,
`F27_Quantitative.lean`, `F51_Effective_Denominator.lean`,
`F52_P3_Rescue.lean`, `F54_AlphaSlope_ClosedForm.lean`,
`F54_Parity.lean`, `F54_AlphaSlope.lean`, `F27_E_Dominates_G.lean`,
`F27_E_Denominator.lean`, `F27_G_Denominator.lean`, `F27_LucasSeparation.lean`,
`F51_Denominator.lean`, `F27_LegendreSlope.lean`, `F27_TaylorPartialSum.lean`,
`F54_SlicePrime.lean`, `Decoupling.lean`, `F26_MahlerEquation.lean`,
`Conj_4A4_Statement.lean`.

**CRITICAL:** these files contain **14 axiom declarations** (SSReduction,
PiStratum's `Real.pi_transcendental`, Niven_Arctan, GAP_N_Conjecture,
GAP_M_Conjecture, Conj_4A4_Statement).  The project's public claim of
"8 axioms" holds **only because these files are not built**.

**Classification:** INVESTIGATE — this is the π Hunch formalization chain.
The user has memorialized this as a live research track (Pi Session 7).
Decision needed from user: wire into `Basic.lean` (accepts the axioms as
conditional assumptions), keep as "working directory", or relocate to a
separate `PiResearch/` sublibrary with its own lakefile target.

### 1B. Emergence/ orphans (6 files)

| File | Imported by | Theorem count | Notes |
|---|---|---|---|
| `Emergence/OmegaGrandEmergence.lean` | nobody | 8 | "META-CAPSTONE" bundles GR+QM+KG; author Orion, 2026-04-15 |
| `Emergence/DarkMatter.lean` | nobody | 14 | Eltanin, 2026-04-15; `dark_matter_is_information` headline |
| `Emergence/Inflation.lean` | nobody | 8 | Ankaa, 2026-04-15; slow-roll inflation via healing flow |
| `Emergence/HpwCreativeAttack.lean` | nobody | 8 | Rastaban, 2026-04-15; Lyapunov bypass for HPW G/H |
| `Emergence/HpwTotalTruncation.lean` | nobody | 9 | Ingredient-I re-export hub |
| `Emergence/DiracOptional.lean` | only by `OmegaGrandEmergence` (orphan) | 2 | Dirac stub; transitively orphan |

**Classification:** all six are substantive, finished (0 sorry, 0 new axioms).
KEEP and WIRE IN — these are genuine wave-3 deliverables that someone forgot
to register in `Basic.lean`.  Each adds headline physics (dark matter,
inflation, meta-capstone, Lyapunov HPW bypass) that the paper arguably
should cite.

### 1C. HealingFlow/ + Conservation/ orphans (2 files)

| File | Imported by | Notes |
|---|---|---|
| `HealingFlow/LaSalle.lean` | only by `Conservation/LaSalleKLBridge` (orphan) | LaSalle equivalence loop; 2026-04-15 |
| `Conservation/LaSalleKLBridge.lean` | nobody | Bridges LaSalle to KL; 2026-04-15 |

**Classification:** pair; WIRE IN together or relocate both.  The first
`DEAD_CODE_AUDIT` mention flagged these by name; they remain orphans.

### 1D. Predictions/ orphan (1 file)

| File | Imported by | Notes |
|---|---|---|
| `Predictions/PhotonMassSandwich.lean` | nobody | team-lead, 2026-04-17; `0 < m_γ ≤ m_γ_PDG` (today's work) |

**Classification:** WIRE IN — this is today's headline photon-mass sandwich
theorem and clearly should be registered.

### 1E. Probe/ orphans (5 files, by design)

| File | Notes |
|---|---|
| `Probe/AgentTest.lean` | smoke test |
| `Probe/AmbitiousProofs.lean` | live exact?/apply? probe |
| `Probe/PiAndOmegaStructure.lean` | The Pi Hunch in one line |
| `Probe/StressTest1.lean` | stress test |
| `Probe/StressTest2.lean` | stress test |

**Classification:** KEEP as orphans — by design these are experimental and
should not be in the default build.  However, `Probe/` imports
`Emergence/HilbertEmergence` and `Emergence/KleinGordon` which ARE
transitively in Basic via `QuantumMechanicsCapstone` — good.

### 1F. Additional Emergence files reachable through non-Basic import chains

- `Emergence/HilbertEmergence.lean` — imported by `QuantumMechanicsCapstone` (in Basic) → **reachable**
- `Emergence/KleinGordon.lean` — imported by `QuantumMechanicsCapstone` (in Basic) → **reachable**
- `Emergence/MassAsDelay.lean` — imported by `UHECRDispersion`/`PMNSMatrix`/`StochasticTeleportation` (in Basic) → **reachable**
- `Emergence/Redshift.lean` — imported by `RedshiftFloor` (in Basic) → **reachable**
- `Emergence/DiracEquation.lean` — imported by `DiracLagrangian` (in Basic) → **reachable**

These look missing from Basic.lean but are transitively brought in.
No action needed, but adding explicit imports in Basic.lean for clarity
would not hurt (docstring wants Basic.lean to be the "table of contents").

---

## Section 2 — Unused theorems / definitions

Given ~1750+ theorems across 193 files, exhaustive theorem-by-theorem
grepping is impractical in one sweep.  Instead this audit flags **orphan
*files*** as the proxy for "everything declared inside is unused" — any
theorem in an orphan file is, by definition, unused outside that orphan
subtree.

### High-priority unused-theorem pockets (by file orphan status)

All theorems in these files have **zero call sites outside their own file**:

| File | Theorems inside | Disposition |
|---|---|---|
| `Emergence/OmegaGrandEmergence.lean` | 8 | KEEP (paper-citable meta-capstone) |
| `Emergence/DarkMatter.lean` | 14 | KEEP (headline prediction) |
| `Emergence/Inflation.lean` | 8 | KEEP (headline physics) |
| `Emergence/HpwCreativeAttack.lean` | 8 | INVESTIGATE (may duplicate `HpwElimSummary`) |
| `Emergence/HpwTotalTruncation.lean` | 9 | INVESTIGATE (explicitly documents itself as re-exporting from `RicciComparison`) |
| `Predictions/PhotonMassSandwich.lean` | 5 | KEEP (today's deliverable) |
| `Conservation/LaSalleKLBridge.lean` | ~6 | KEEP (LaSalle → KL bridge) |
| `HealingFlow/LaSalle.lean` | ~8 | KEEP (LaSalle equivalences) |

### Spot-checked likely-duplicates / redundant re-exports

- `Emergence/HpwTotalTruncation.lean` **self-documents** as a re-export hub:
  "the re-exports are `:=` aliases … no new mathematics is added here".
  Lines 23–31 list four lemmas it aliases from `RicciComparison.lean`.
  This file is redundant if the originals are already cited by consumers;
  its sole value is the named-handle mapping for the Neo4j graph's
  `ProofIngredient {name: 'total_truncation_bound'}` node.
  **Classification:** INVESTIGATE.  If the Neo4j workflow doesn't hit it,
  delete.  If it does, wire it in.

- `Niven_Arctan.lean` (HermitePade) self-documents as a replacement for an
  axiom in `Attack13_SliceOneThird.lean`: "replaces the previous
  `arctan_one_third_irrational` axiom … with a cleaner, more-precisely-cited
  axiom".  Both files coexist — the newer may have been meant to supersede
  the older.  **Classification:** INVESTIGATE; probably one of them can go.

### Paper/ re-export layer — intentional KEEP

- `Paper/GeometricRelativistic.lean` — 2 theorems, pure `:=` re-exports.
  Docstring explicit: "Zero new axioms, zero new proofs."  KEEP.
- `Paper/QuantumFoundations.lean` — same pattern.  KEEP.

---

## Section 3 — Duplicate / redundant definitions

### 3.1 Duplicate import in `Basic.lean`
```
Line 144: import OmegaTheory.Emergence.FermionContent
Line 158: import OmegaTheory.Emergence.FermionContent
```
Harmless to Lean (Lake deduplicates), but tidy-up recommended.

### 3.2 Named-handle re-export duplication
- `HpwTotalTruncation.lean` re-exports `RicciComparison.lean` lemmas under
  ingredient-I aliases (see Section 2 note above).
- `Paper/*.lean` re-exports `Emergence/*.lean` theorems under paper aliases.
  These are intentional by design.

### 3.3 No meaningful structural duplicates detected
No two files define structures with overlapping field signatures at the
level audited here; each `HpwXxx.lean` (Schwarzschild, FRW, BianchiI,
DeSitter, Kerr, Minkowski, Linearised) is an instance of the shared
`HpwEliminableRegime` class → intentional typeclass resolution.

---

## Section 4 — Deprecated patterns

### 4.1 `sorry`
**0 real `sorry` occurrences.**  All 113 grep hits for `sorry` are inside
documentation comments (string literal `"0 sorry"`, `"sorries"`, etc.).
Clean.

### 4.2 Axioms outside `Spacetime/Constants.lean`
**14 declarations, ALL inside `HermitePade/` orphan subtree:**

| File | Axiom |
|---|---|
| `HermitePade/SSReduction.lean` | `hypValue`, `hypDeriv`, `siegel_shidlovskii` |
| `HermitePade/PiStratum.lean` | `Real.pi_transcendental` |
| `HermitePade/Niven_Arctan.lean` | `hermiteLindemann_arctan_one_third_irrational` |
| `HermitePade/GAP_N_Conjecture.lean` | `Nesterenko_1996`, `Nesterenko_1996_transcendence` |
| `HermitePade/GAP_M_Conjecture.lean` | `motivicU`, `motivicV`, `motivic_trdeg_three`, `motivic_trdeg_three_transcendence` |
| `HermitePade/Conj_4A4_Statement.lean` | `u_hyp`, `v_hyp` |

Because the entire `HermitePade/` subtree is orphaned (§1A), these axioms
do not appear in the reachable build.  **Policy consequence:** the
"8 axioms" claim is correct **only under the current orphan status**.
If any `HermitePade/*.lean` file is ever added to `Basic.lean`, the axiom
count will jump.

### 4.3 Mathlib v4.29 name-changes
**Clean.**
- All 16 uses of `div_le_iff`/`div_lt_iff`/`mul_div_cancel` have the `₀` suffix.
- No imports of removed module `Mathlib.Data.Int.Basic`.
- `Mathlib.Algebra.BigOperators.Group.Finset.Basic` is used pervasively and
  the build is GREEN — this path still resolves in v4.29 despite the note
  in `chaos-shield/.claude/CLAUDE.md` (that note is stale).

### 4.4 `Classical.choice`
**Clean.**  All 20 `Classical.choice` mentions are in docstrings inside
`HermitePade/` asserting "no axioms beyond Mathlib's standard trio
(`propext`, `Classical.choice`, `Quot.sound`)" — i.e., documentation that
the file does NOT use extra Classical.  No live `Classical.choice` invocation
in proof bodies.

---

## Section 5 — Top 10 SAFE DELETIONS

### Ranked by reward-per-risk

**None of these are truly "safe to delete now" without a decision from
the author.**  Every orphan flagged below is either finished, substantive
work OR a deliberate experimental probe.  The correct action is almost
always "wire in" rather than "delete".  The list below is the
**lowest-regret deletion candidates** if the project decides to trim.

| # | Candidate | Location | Reason safe-ish | Consumer to update |
|---|---|---|---|---|
| 1 | `Emergence/HpwTotalTruncation.lean` | orphan + self-documents as re-export hub of `RicciComparison.lean` (no new math) | 9 theorems are `:=` aliases; direct callers can use originals | Neo4j ProofIngredient node, if any |
| 2 | Orphan HermitePade leaves with *only* axioms + orphan downstream (`SSReduction.lean`, `GAP_N_Conjecture.lean`, `GAP_M_Conjecture.lean`, `Conj_4A4_Statement.lean`) | Island files introducing axioms that aren't reachable | Removes 11/14 off-book axioms | None (nothing outside island imports them) |
| 3 | `Probe/AgentTest.lean` | orphan smoke-test | `import OmegaTheory.Irrationality.Uncertainty` + nothing else | None |
| 4 | `HermitePade/BridgeTheorem_Frequencies.lean` | orphan even within HermitePade | Not cited by `BridgeTheorem.lean` or anything else | None |
| 5 | `HermitePade/F50_Cauchy.lean` + `F50_Contour_Integral.lean` + `F50_Decay.lean` | 3 orphan files inside orphan island, not cited by anything | Lives as exploration; F51_* and F52_* are the "rescue" files actually referenced in the chain | None |
| 6 | `HermitePade/Attack13_SliceOneThird.lean` + `Niven_Arctan.lean` pair | Newer (Niven_Arctan) explicitly "replaces the previous axiom" in older (Attack13) → one is obsolete | Pick ONE to keep; delete the other | None |
| 7 | `Probe/StressTest1.lean` + `Probe/StressTest2.lean` + `Probe/AmbitiousProofs.lean` | orphan experimental probes; commented-out `exact?` calls | If no longer running these manually, delete | None |
| 8 | Duplicate `import OmegaTheory.Emergence.FermionContent` at Basic.lean line 158 | Exact same import already at line 144 | Harmless edit | None |
| 9 | `HermitePade/F26_MahlerEquation_convergent.lean` alongside `F26_MahlerEquation.lean` | Second file imports + extends the first; if only original is needed downstream (it isn't), both go | The only consumer is the file itself | None |
| 10 | `HermitePade/F56_StokesClosedForm.lean` | orphan-in-orphan, not cited | Exploratory F56 work; F54_AlphaSlope_ClosedForm.lean is the one referenced | None |

**Stronger recommendation:** instead of deletion, add a line to
`Basic.lean` importing the finished orphan files (§1B–1D) and either
delete the `HermitePade/` island entirely or move it to a separate
`OmegaTheoryPi/` lake library with its own axiom ledger.

---

## Appendix A — Orphan file inventory (48 files)

**Fully orphan (no one imports them, they are not in Basic.lean):**
- `Emergence/OmegaGrandEmergence.lean`
- `Emergence/DarkMatter.lean`
- `Emergence/Inflation.lean`
- `Emergence/HpwCreativeAttack.lean`
- `Emergence/HpwTotalTruncation.lean`
- `Predictions/PhotonMassSandwich.lean`
- `Conservation/LaSalleKLBridge.lean`
- `Probe/AgentTest.lean`, `AmbitiousProofs.lean`, `PiAndOmegaStructure.lean`, `StressTest1.lean`, `StressTest2.lean`
- All 33 `HermitePade/*.lean`
- `Emergence/DiracOptional.lean` (imported only by orphan)
- `HealingFlow/LaSalle.lean` (imported only by orphan)

**Not in Basic.lean but transitively reachable:**
- `Emergence/HilbertEmergence.lean` (via QuantumMechanicsCapstone)
- `Emergence/KleinGordon.lean` (via QuantumMechanicsCapstone, DiracEquation)
- `Emergence/MassAsDelay.lean` (via UHECRDispersion, PMNSMatrix, StochasticTeleportation)
- `Emergence/Redshift.lean` (via RedshiftFloor)
- `Emergence/DiracEquation.lean` (via DiracLagrangian)

---

## Appendix B — recommended first-pass fix

```lean
-- Append to OmegaTheory/Basic.lean:

-- Apr 15 wave-3 deliverables (were orphan, wire in):
import OmegaTheory.Emergence.DarkMatter
import OmegaTheory.Emergence.Inflation
import OmegaTheory.Emergence.HpwCreativeAttack
import OmegaTheory.Emergence.HpwTotalTruncation
import OmegaTheory.Emergence.DiracOptional
import OmegaTheory.Emergence.OmegaGrandEmergence
import OmegaTheory.HealingFlow.LaSalle
import OmegaTheory.Conservation.LaSalleKLBridge

-- Apr 17 wave-4 deliverable:
import OmegaTheory.Predictions.PhotonMassSandwich

-- Explicit re-import for clarity (transitively already in, but Basic.lean
-- serves as table of contents):
import OmegaTheory.Emergence.HilbertEmergence
import OmegaTheory.Emergence.KleinGordon
import OmegaTheory.Emergence.MassAsDelay
import OmegaTheory.Emergence.Redshift
import OmegaTheory.Emergence.DiracEquation

-- Remove the duplicate at line 158:
-- import OmegaTheory.Emergence.FermionContent     ← DELETE THIS LINE
```

Expected consequences:
- Adds ~65 new theorems to the reachable build surface.
- Does NOT change axiom count (0 axioms in the files being wired in; confirmed).
- Basic.lean becomes an accurate table of contents.

For the `HermitePade/` island (separate decision):
- Option A: add `import OmegaTheory.Irrationality.HermitePade.Decoupling`
  (or whichever is the apex result) → accepts the 14 axioms as part of
  the π formalization research track, updating the "8 axioms" claim to
  "8 axioms + N π-research axioms".
- Option B: relocate `HermitePade/` to a separate `OmegaTheoryPi/` lake
  library with its own axiom ledger, decoupling π research from the
  main "0 new axioms" promise.
- Option C: leave as-is (current state), and document in README that
  `HermitePade/` is a staging area for the π Hunch research track.
