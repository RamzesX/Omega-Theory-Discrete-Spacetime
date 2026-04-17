# Build Hygiene Audit — V2 (Achird, 2026-04-17)

Scope: 161 Lean files / ~2164 `theorem|lemma` / 190 namespaces. Report-only; no files
modified.

## Section 1 — Build performance

`set_option maxHeartbeats` occurrences (all justified, all in SU(3) / Whitney):

| File | Line | Value | Verdict |
|---|---|---|---|
| `Emergence/SU3JacobiHelper.lean` | 41, 49 | 1_000_000 | necessary — 512-case `fin_cases` × 3 on `Fin 8` |
| `Emergence/SU3JacobiFull.lean`   | 112    | 1_000_000 | necessary — 512-case `su3f_decomp` with `ring` |
| `Emergence/SU3JacobiFull.lean`   | 156    | 4_000_000 | necessary — kernel Jacobi lift Rat→ℝ via `linear_combination` |
| `Emergence/ErrorGaugeSU3.lean`   | 92     |   800_000 | necessary — `su3f_antisym` 512-case |
| `Emergence/SmoothInterpolant.lean` | 231  |   400_000 | necessary — `iteratedFDeriv` whnf on `MetricTensor` |

Hottest files (heartbeat + compute profile, likely > 100s each):
`SU3JacobiFull.lean`, `SU3JacobiHelper.lean`, `ErrorGaugeSU3.lean`,
`SmoothInterpolant.lean`, `ConnesBimodule.lean` (391 lines, heavy spectral imports).

`native_decide` uses — 6 total, two distinct regimes:

- `SU3JacobiFull.lean:145,151` — 4096-case rational Jacobi over `Fin 8⁴`.
  **Necessary**; `decide` will NOT finish in any reasonable time.
- `Conservation/SpinInformation.lean:177,181,185` — `isFermion/isBoson` on a
  single concrete `Nat`. **Overkill**; `decide` (or even `rfl`) suffices and
  skips the native-compile round-trip.

## Section 2 — Deprecated Mathlib v4.29 patterns

Grep for `div_le_iff`, `mul_div_cancel`, `pow_le_pow_left`, `Finset.mem_empty`
without the `₀` suffix / `not_` prefix: **zero hits**. Every site already uses
the v4.29 name (`div_le_iff₀`, `mul_div_cancel₀`, `mul_div_cancel_left₀`,
`pow_le_pow_left₀`). No stale imports detected. Clean.

## Section 3 — Import hygiene

- `import Mathlib.Tactic` (whole tactic blob) appears in **33 of 161 files**,
  concentrated in `Emergence/` (27 files) and `Predictions/` (8 files).
  This pulls the full tactic library even where `Mathlib.Tactic.Linarith` +
  `Mathlib.Tactic.FieldSimp` + `Mathlib.Tactic.Ring` would do. Net-new-files
  (`AnomalyCancellation`, `FermionHypercharge`, `SpinStatistics`,
  `ConnesBimodule`) all do it.
- `Probe/AmbitiousProofs.lean` imports **16 modules** (HilbertEmergence,
  CHSHBell, SpecialRelativity, KleinGordon, ErrorLieAlgebra, ErrorForms,
  ErrorHopfStructure, Uncertainty, Correspondence, 4× Mathlib heavy linalg
  + Spectrum + Tactic) — Probe exploration, not production, but its
  transitive closure is nearly the whole project.
- `ConnesBimodule.lean` (391 lines, untracked) — verify whether its
  spectral-algebra imports are actually used or were copy-pasted.

## Section 4 — Style-guide compliance

- Namespaces: 190/161 files have at least one `namespace` declaration — OK.
- Docstring density: most theorems have `/--` headers. Spot-check of the
  4 untracked files shows `AnomalyCancellation.lean` theorems have only
  inline one-line doc on the `def`s; theorems (lines 59–74) carry **no
  docstring** — violates STYLE_GUIDE §4. Same pattern in
  `FermionHypercharge.lean`.
- All new files correctly carry `namespace OmegaTheory.Emergence`.
- `Probe/AgentTest.lean` (6 lines) is a stub; no headline.

## Section 5 — Top 10 Performance Wins (actionable)

| # | File / Issue | Est. saved | 3-line fix |
|---|---|---|---|
| 1 | `Conservation/SpinInformation.lean` 177/181/185 — `native_decide` on 1-value `Nat.Odd/Even` | ~3–5 s native-compile overhead per build | replace `native_decide` → `decide` (or `by decide`) on all three |
| 2 | 33 files import full `Mathlib.Tactic` | ~10–20 s cold-build dependency closure | replace with `import Mathlib.Tactic.Linarith` / `.FieldSimp` / `.Ring` / `.Positivity` as needed per file |
| 3 | `Probe/AmbitiousProofs.lean` 16-wide import fan-in | ~30 s when Probe rebuilds | move file under `Probe/` only (already there), gate from `Basic.lean` with a build flag or drop Mathlib.InnerProductSpace.Spectrum if unused |
| 4 | `SU3JacobiHelper.lean` lines 41–53 — two 1M-heartbeat 512-case `fin_cases` for ik & jk antisymmetry | ~20 s | derive `su3f_antisym_ik`/`_jk` from existing `su3f_antisym` + one `su3f_antisym_ij`-compose — single fin_cases instead of two |
| 5 | `SU3JacobiFull.lean:156` 4M-heartbeat kernel lift | ~15 s if split | split `kernel_jacobi_zero` into per-summand lemmas, each at 500k; ring normalisation then runs on smaller goals |
| 6 | `SmoothInterpolant.lean:231` `iteratedFDeriv` whnf trap at 400k | ~5 s | pre-prove `contDiff_iteratedFDeriv_const_smul` as a dedicated lemma, then base theorem hits it with `exact` instead of `iteratedFDeriv_const_smul_apply'` chain |
| 7 | `ConnesBimodule.lean` (391 lines, untracked) — likely over-imports | unknown (new) | after first build, `lean --verbose` to trim unused `Mathlib.LinearAlgebra.*` imports |
| 8 | `AnomalyCancellation.lean` 4× `by decide` on integer sums | ~2 s | swap to `by rfl` if the sums reduce definitionally; otherwise `by norm_num [anomalyU1Cubed]` is ~½ the cost of generic `decide` on `Int` |
| 9 | `Probe/*.lean` all 5 files registered in `Basic.lean` as production | ~5–10 s | gate Probe/ behind a lake feature flag or a separate target; they are experiments, not load-bearing |
| 10 | `fin_cases i <;> fin_cases j <;> fin_cases k <;> simp_all` across SU3 family (3 files) | ~10 s if cached | extract common `su3f_unfold_simp_set` as `@[simp]` attribute so `simp_all` finds it pre-baked; reduces redundant unfolding |

## Summary

Build is hygienic on the Mathlib-rename front (clean). Primary wins are:
(a) killing 3 gratuitous `native_decide` calls, (b) trimming 33 blanket
`import Mathlib.Tactic`s, (c) refactoring the two `SU3Jacobi*` helpers so the
512-case hammer isn't invoked twice for trivially-related antisymmetries.
Estimated combined savings: ~1–2 minutes cold, ~30 s warm. Style gap:
untracked new files (Anomaly, FermionHypercharge) need theorem docstrings
per STYLE_GUIDE §4 before promotion from "new" to "registered".
