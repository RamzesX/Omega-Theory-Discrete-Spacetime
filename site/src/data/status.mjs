// Single source of truth for corpus numbers, parsed at build time from
// PhysicsPapers/LeanFormalizationV2/STATUS.md.
//
// STATUS.md is the canonical file the Lean team edits after each cycle
// close. This module exposes the same numbers so every Astro page stays
// in sync without manual edits.
//
// If STATUS.md is missing at build time (dev preview in a pruned checkout),
// we fall back to the last known numbers. The real build path always has
// the file — the tree is checked in at a known relative location.

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const STATUS_PATH = join(
  __dirname,
  '../../../PhysicsPapers/LeanFormalizationV2/STATUS.md'
);

// Fallbacks kept static — only used if the STATUS.md parse fails.
// These are the last-known numbers; the parser below should always win.
const FALLBACK = {
  buildJobs: 3835,
  sorryCount: 0,
  physicalAxioms: 8,
  researchAxioms: 16,
  totalAxioms: 24,
  ownTheorems: 8996,
  ownDefinitions: 4465,
  mathlibTheorems: 175137,
  grandTotalTheorems: 184133,
  leanFiles: 294,
  cyclesShipped: 42,      // cycles 2..43 inclusive = 42 numbered cycles
  firstCycle: 2,
  lastCycle: 43,
  graphFindings: 88,
  graphFindingsPaperWorthy: 44,
  theoremCandidates: 166,
  subsystemNavigators: 677,
};

function parseInteger(raw) {
  if (!raw) return null;
  const digits = String(raw).replace(/[,\s]/g, '');
  const n = parseInt(digits, 10);
  return Number.isFinite(n) ? n : null;
}

function parseStatus() {
  let text;
  try {
    text = readFileSync(STATUS_PATH, 'utf8');
  } catch {
    return FALLBACK;
  }

  const out = { ...FALLBACK };

  // Regex-based extraction. Each `|` table row in STATUS.md looks like:
  //   | **Build jobs** | **3,835 GREEN** | ... |
  //   | **OmegaTheoryV2 Theorems (own)** | **8,996** | ... |
  //
  // We anchor on the human label and pull the first integer after it.
  const grab = (label) => {
    const re = new RegExp(
      `\\|\\s*\\**\\s*${label}[^|]*\\|\\s*\\**\\s*([\\d,]+)`,
      'i'
    );
    const m = text.match(re);
    return m ? parseInteger(m[1]) : null;
  };

  const n = {
    buildJobs: grab('Build jobs'),
    sorryCount: grab('Sorry count'),
    physicalAxioms: grab('Physical axioms'),
    researchAxioms: grab('Research-conjecture axioms'),
    totalAxioms: grab('Total declared axioms'),
    ownTheorems: grab('OmegaTheoryV2 Theorems \\(own\\)'),
    ownDefinitions: grab('OmegaTheoryV2 Definitions'),
    mathlibTheorems: grab('Mathlib Theorems \\(integrated\\)'),
    grandTotalTheorems: grab('Grand total'),
    leanFiles: grab('OmegaTheoryV2 LeanFile nodes'),
    graphFindings: grab(':GraphFinding.*total'),
    graphFindingsPaperWorthy: grab(':GraphFinding.*paper_worthy'),
    theoremCandidates: grab(':TheoremCandidate.*total'),
    subsystemNavigators: grab(':SubsystemNavigator'),
  };

  for (const [k, v] of Object.entries(n)) {
    if (Number.isFinite(v)) out[k] = v;
  }

  // "Cycles shipped | 2 – 43 (42 numbered cycles, ...)"
  const cycleRange = text.match(
    /Cycles shipped\s*\|\s*\**\s*(\d+)\s*[–-]\s*(\d+)\s*\**\s*\(\s*(\d+)\s+numbered/i
  );
  if (cycleRange) {
    out.firstCycle = parseInteger(cycleRange[1]) ?? out.firstCycle;
    out.lastCycle = parseInteger(cycleRange[2]) ?? out.lastCycle;
    out.cyclesShipped = parseInteger(cycleRange[3]) ?? out.cyclesShipped;
  }

  return out;
}

const status = parseStatus();

// Human-friendly formatters.
export const fmt = {
  int: (n) => new Intl.NumberFormat('en-US').format(n),
  thousands: (n) => {
    if (n >= 10_000) return `${(n / 1000).toFixed(1).replace(/\.0$/, '')}K`;
    return new Intl.NumberFormat('en-US').format(n);
  },
};

// Public API.
export const STATUS = Object.freeze(status);

// Convenience computed fields for page templates.
export const HEADLINES = Object.freeze({
  cyclesShipped: status.cyclesShipped,
  cyclesRange: `${status.firstCycle}–${status.lastCycle}`,
  ownTheorems: status.ownTheorems,
  ownTheoremsShort: fmt.thousands(status.ownTheorems),
  grandTotalTheorems: status.grandTotalTheorems,
  grandTotalTheoremsShort: fmt.thousands(status.grandTotalTheorems),
  buildJobs: status.buildJobs,
  buildJobsFmt: fmt.int(status.buildJobs),
  sorryCount: status.sorryCount,
  physicalAxioms: status.physicalAxioms,
  totalAxioms: status.totalAxioms,
  leanFiles: status.leanFiles,
});
