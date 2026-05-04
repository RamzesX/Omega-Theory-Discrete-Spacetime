---
title: "grothendieck predictions.schema"

category: "Graph Research · Neo4j"

---

<!-- orig-frontmatter: name: grothendieck-predictions.schema.md -->
<!-- orig-frontmatter: type: schema + update procedure for grothendieck-predictions.json -->
<!-- orig-frontmatter: updated: 2026-04-21 -->
# `grothendieck-predictions.json` — schema

↑ [chaos-shield root](../../README.md) · [PhysicsPapers](../README.md) · [OmegaTheoryAlgebra](README.md)

## Purpose

Live tracking of the **8-pass Grothendieck Math Puzzle** ([`GROTHENDIECK_MATH_PUZZLE.md`](GROTHENDIECK_MATH_PUZZLE.md)).
Each MP pass predicts 1–3 Lean theorem signatures that the graph analysis says
are missing from the corpus. This JSON enumerates them so the Astro site at
[`/algebra/`](../../site/src/pages/algebra.astro) can render a live dashboard.

**Status is auto-detected at build time** by `site/scripts/build-grothendieck-status.mjs`
which greps `PhysicsPapers/LeanFormalizationV2/OmegaTheory/**/*.lean` for each
predicted theorem name. If the name appears as `theorem NAME` or `lemma NAME`
at top level in any Lean file, it is marked **LANDED** automatically.

Agents do not need to edit this JSON when closing a prediction — the grep
detector handles it. You only touch this file to:

- **Add** a new prediction (when a new MP pass or refinement produces one)
- **Revise** a claim string or tag if the literature / empirical picture shifts
- **Bump** `updated` when you make any change

## Top-level shape

```json
{
  "updated": "YYYY-MM-DD",
  "tags": { /* tag-code → {label, color, meaning} */ },
  "passes": [ /* 8 MP entries */ ]
}
```

## Pass entry

```json
{
  "id": "MP-1",
  "title": "Categorical structure of OmegaTheory",
  "question": "What categorical species does OmegaTheory inhabit? ...",
  "predictions": [
    { "name": "omega_theory_is_fibered_category",
      "claim": "short English description of what the theorem says",
      "tag": "EVIDENCE" }
  ]
}
```

### Field rules

- `name` — the exact Lean identifier you expect the theorem to have. This is
  what the grep detector searches for. Use snake_case following OmegaTheoryV2 style.
- `claim` — one-sentence description. Avoid LaTeX — this renders in a chip cell
  on the site, plain UTF-8 is fine.
- `tag` — one of: `LOAD_BEARING`, `EVIDENCE`, `SPECULATIVE`, `LITERATURE_ANCHORED_GAP`.
  The runtime status `LANDED` is auto-assigned by the grep detector and overrides
  this field for display purposes (keep the original tag in the JSON).

## Tag semantics

| Tag | Colour | Meaning |
|---|---|---|
| `LOAD_BEARING`            | jade        | supported by existing Lean files; theorem already substantially anchored |
| `EVIDENCE`                | azure       | backed by graph computation or empirical spectrum but not yet Lean-proved |
| `SPECULATIVE`             | magenta     | suggestive pattern, requires more data / literature work |
| `LITERATURE_ANCHORED_GAP` | amber       | standard literature construct (Connes, Kempf) not yet in OmegaTheory source |
| `LANDED` *(runtime)*      | jade-strong | theorem now exists in Lean corpus (auto-detected) |

## How the site renders this

At build time (`npm run build`):

1. `scripts/build-grothendieck-status.mjs` reads this JSON.
2. Walks `PhysicsPapers/LeanFormalizationV2/OmegaTheory/` collecting every
   `theorem`/`lemma` declaration (~4,000+ as of cycle 43).
3. For each prediction, checks if its `name` matches a declared theorem.
4. Writes `site/src/data/grothendieck-status.json` with:
   ```json
   {
     "updated": "ISO-date",
     "summary": { "totalPredictions": 19, "totalLanded": 0, "percentLanded": 0, ... },
     "perPass": [ { "id": "MP-1", "landed_count": 0, "total_count": 3, "predictions": [...] }, ... ]
   }
   ```
5. `/algebra/` page imports the status JSON and renders a dashboard with:
   - Headline % closed
   - Per-MP accordion, open by default if `landed_count > 0`
   - Per-prediction: name (linked to Lean source if landed), tag chip, claim
   - Progress bar that grows as predictions land

## Closing a prediction

1. Write the theorem in a Lean file under `OmegaTheory/` with the **exact name**
   from this JSON. Example:
   ```lean
   theorem omega_base_site_has_four_generators : ∃ S : SmallSite, ... := by
     -- proof
   ```
2. Commit. On next push, GitHub Actions builds the site. The build script
   greps and finds the new theorem. Dashboard updates automatically.

That's it. No JSON edit required.

## Adding a new prediction

When a new MP pass or a refinement produces a new predicted theorem:

1. Open this JSON.
2. Either append to an existing pass's `predictions` array, or append a new
   pass entry to the `passes` array (keeping the id-ordering convention
   MP-1, MP-2, ...).
3. Provide `name`, `claim`, and initial `tag`.
4. Bump top-level `updated`.
5. Commit. Dashboard updates on next build.

## Related files

- [`GROTHENDIECK_MATH_PUZZLE.md`](GROTHENDIECK_MATH_PUZZLE.md) — the long-form 969-line research memo (source of the predictions)
- [`ACHIEVEMENTS.md`](ACHIEVEMENTS.md) — empirical foundation
- [`../../site/scripts/build-grothendieck-status.mjs`](../../site/scripts/build-grothendieck-status.mjs) — build-time detector
- [`../../site/src/pages/algebra.astro`](../../site/src/pages/algebra.astro) — dashboard render
- [`../LeanFormalizationV2/cycle-index.json`](../LeanFormalizationV2/cycle-index.json) — sibling dynamic-JSON for cycles

## Amendments

- **2026-04-21** — File created. Seeded with 19 predictions across MP-1 through MP-8 extracted from Navi's `GROTHENDIECK_MATH_PUZZLE.md`.
