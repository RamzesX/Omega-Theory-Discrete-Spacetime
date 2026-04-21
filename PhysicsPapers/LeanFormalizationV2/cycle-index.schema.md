---
name: cycle-index.schema.md
type: schema documentation for cycle-index.json
updated: 2026-04-21
authority: Lean agents close each cycle by appending a new cycle entry to cycle-index.json
---

# `cycle-index.json` — schema for agents

↑ [chaos-shield root](../../README.md) · [PhysicsPapers](../README.md) · [LeanFormalizationV2](README.md)

## Purpose

`cycle-index.json` is the **canonical list of OmegaTheory V2 formalization cycles**.
The Astro site at [`/cycles/`](../../site/src/pages/cycles.astro) renders from it at
build time via [`site/src/data/cycles.mjs`](../../site/src/data/cycles.mjs).
Hardcoded counts like "14 cycles" are gone — the site now shows whatever this file says.

**When you close a cycle, update this file.** That is the single action that keeps
the public /cycles/ catalogue in sync with reality.

## Top-level shape

```json
{
  "updated": "YYYY-MM-DD",
  "source_of_truth": "short reminder string",
  "channels": { "pi": {...}, "e": {...}, ... },
  "cycles": [ /* array of cycle entries, one per shipped cycle */ ]
}
```

Bump `updated` to today's date when you edit the file. CI + the site build will
notice and refresh.

## Cycle entry

Two flavours. Use **full** when you have tabular row data for each theorem; use
**summary** when all you have is prose + a single capstone theorem.

### Full entry (preferred — gives a rich per-theorem table on the /cycles/ page)

```json
{
  "cycle": 24,
  "title": "Electroweak unification",
  "hook": "One-sentence paper-worthy claim (appears in page title area).",
  "summary": "2-3 sentence narrative. PDG anchors + channel + key identity.",
  "note_file": "notes/NOTES_CYCLE24_ELECTROWEAK.md",   // optional, path from LeanFormalizationV2/
  "agent": "Mesarthim",                                // star-name of the cycle lead agent
  "star": "γ Arietis",
  "rows": [
    {
      "name": "substrate_electroweak_unification_theorem",  // Lean theorem name, copy from source
      "observable": "SU(2)_L × U(1)_Y",                     // what's being predicted
      "pdg": "unification",                                  // PDG 2024 target value or "structural"
      "tol": "structural",                                   // tolerance bound, or "exact", "bound", "identity"
      "channel": "derived",                                  // one of: pi, e, s2, catalan, composed, derived
      "agent": "Mesarthim",                                  // per-row agent (may differ from cycle lead)
      "star": "γ Arietis",
      "file": "ElectroweakUnification.lean"                  // file in OmegaTheory/Predictions/ (or nested subdir)
    }
    // one row per headline theorem (typically 3-6)
  ]
}
```

### Summary entry (for cycles without structured row data — e.g. cycles 2-8, 24-43)

```json
{
  "cycle": 3,
  "title": "Substrate bridges + vacuum physics",
  "detail": "summary",            // marker — renders as a 1-row summary block
  "hook": "One-sentence paper-worthy claim.",
  "summary": "2-3 sentence narrative.",
  "dir": "Emergence"              // directory under OmegaTheory/ the cycle mostly landed in
}
```

The page renders summary entries as a compact "no detail table, see `OmegaTheory/{dir}/`
on GitHub" block with the title + hook + summary + dir link.

## Channel codes

| Code       | Label  | Meaning                                                |
|------------|--------|--------------------------------------------------------|
| `pi`       | π      | Pi-channel, heavy generation, Leibniz O(1/N) residual  |
| `e`        | e      | e-channel, middle generation, factorial O(1/N!)        |
| `s2`       | √2     | Sqrt2-channel, light generation, super-exp O(2^{-2^N}) |
| `catalan`  | G      | Catalan-G channel, sterile / dark sector, O(1/N²)      |
| `composed` | π·e    | Composed channel (cross-product of two)                |
| `derived`  | id     | Pure structural identity (0 free parameters)           |

Channels `catalan` and `derived` are available post-cycle-26. Earlier cycles
only use `pi`/`e`/`s2`/`composed`/`derived`.

## How to add a new cycle (template)

When cycle N closes:

1. Open `cycle-index.json`.
2. Bump top-level `updated`.
3. Append a new entry at the end of the `cycles` array (must be sorted by `cycle`).
4. If you have row-level theorem data (PDG targets, Lean file names, agent
   attribution per theorem), use the **full** entry shape. Otherwise use the
   **summary** shape.
5. Commit. The site will pick it up on next build.

For `note_file`, point to the `NOTES_CYCLEN_*.md` memo if one exists.

## Validation

Run `cd site && node scripts/validate-cycle-index.mjs` to check:

- Monotonic `cycle` numbers (no duplicates, no gaps unless a cycle was skipped —
  e.g. cycle 36 / 38-42 were skipped).
- Every `channel` value matches one of the 6 codes above.
- Every `file` path is plausible (`.lean` extension).

## Related files

- [`STATUS.md`](STATUS.md) — corpus-scale numbers (8,996 theorems / 3,835 jobs / 8 axioms). Referenced from `site/src/data/status.mjs`.
- [`notes/NOTES_CYCLE*.md`](notes/README.md) — prose memos for cycles 24-43.
- [`site/src/data/cycles.mjs`](../../site/src/data/cycles.mjs) — Astro build-time loader.
- [`site/src/pages/cycles.astro`](../../site/src/pages/cycles.astro) — public render.

## Why not parse NOTES_CYCLE*.md directly?

Short answer: prose memos are unstructured. The schema here is lossy-but-stable.
If we parsed `NOTES_CYCLE*.md` at build time we'd couple the site to a memo
author's prose style. `cycle-index.json` is the authoritative projection —
small enough to hand-edit, big enough to drive the whole public /cycles/ page.

## Amendments

- **2026-04-21** — File created. Seeded with cycles 2-43 (cycles 9-23 full; rest summary).
  Replaces the hardcoded array previously inline in `site/src/pages/cycles.astro`.
