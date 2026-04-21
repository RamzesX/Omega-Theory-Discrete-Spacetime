// Build-time loader for cycle-index.json.
//
// The authoritative JSON lives at
//   PhysicsPapers/LeanFormalizationV2/cycle-index.json
// and is the canonical catalogue of OmegaTheory V2 cycles (see the adjacent
// cycle-index.schema.md). We keep a mirrored copy at
//   site/src/data/cycle-index.json
// so Vite/Astro's bundler can statically import it (Node's fs.readFileSync
// breaks once the module is bundled into dist/.prerender/chunks/). The
// mirror is kept in sync by `site/scripts/copy-cycle-index.mjs`, which
// runs as part of the `npm run build` prebuild step.

import index from './cycle-index.json' with { type: 'json' };

if (!index || !Array.isArray(index.cycles)) {
  throw new Error('cycle-index.json: missing `cycles` array');
}

// Sort by cycle number so order is deterministic regardless of JSON order.
const sortedCycles = [...index.cycles].sort((a, b) => a.cycle - b.cycle);

// Partition into "full detail" cycles (have `rows`) and "summary" cycles
// (have `detail === "summary"`). The Astro page renders them differently.
export const cyclesFull = sortedCycles.filter(
  (c) => Array.isArray(c.rows) && c.detail !== 'summary'
);
export const cyclesSummary = sortedCycles.filter(
  (c) => c.detail === 'summary' || !Array.isArray(c.rows)
);

export const allCycles = sortedCycles;

export const CYCLE_INDEX_META = Object.freeze({
  updated: index.updated ?? 'unknown',
  total: sortedCycles.length,
  firstCycle: sortedCycles[0]?.cycle ?? null,
  lastCycle: sortedCycles[sortedCycles.length - 1]?.cycle ?? null,
  fullDetailCount: cyclesFull.length,
  summaryCount: cyclesSummary.length,
  totalRows: cyclesFull.reduce((n, c) => n + (c.rows?.length ?? 0), 0),
});

// Channel metadata (colors, labels). Exposed so the page can render legend
// chips + per-row channel chips from a single source.
export const channelStyle = Object.freeze(
  index.channels ?? {
    pi:       { label: 'π',  tooltip: 'Pi-channel',    bg: 'rgba(255,82,82,.15)',  fg: '#ff8585', border: '#ff5252' },
    e:        { label: 'e',  tooltip: 'e-channel',     bg: 'rgba(255,215,64,.15)', fg: '#ffd740', border: '#ffd740' },
    s2:       { label: '√2', tooltip: 'Sqrt2-channel', bg: 'rgba(0,230,118,.15)',  fg: '#00e676', border: '#00e676' },
    catalan:  { label: 'G',  tooltip: 'Catalan-G',     bg: 'rgba(255,138,101,.15)','fg': '#ff8a65', border: '#ff5722' },
    composed: { label: 'π·e','tooltip': 'Composed',    bg: 'rgba(124,77,255,.15)', fg: '#b47cff', border: '#7c4dff' },
    derived:  { label: 'id', tooltip: 'Structural id', bg: 'rgba(0,212,255,.15)',  fg: '#7fe5ff', border: '#00d4ff' },
  }
);
