// Copies PhysicsPapers/LeanFormalizationV2/cycle-index.json into
// site/src/data/ so Vite can statically import it. Run as a `prebuild`
// hook in package.json, so it always runs before `astro build` and
// keeps the site mirror in sync with the canonical JSON.
//
// If the source is missing (e.g. deleted during restructuring), the hook
// writes a minimal stub at the destination so the build can still complete
// instead of exiting 1. A warning is printed so the author can restore the
// canonical source.

import { copyFileSync, readFileSync, existsSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, resolve } from 'node:path';

const src  = resolve('../PhysicsPapers/LeanFormalizationV2/cycle-index.json');
const dest = resolve('./src/data/cycle-index.json');

mkdirSync(dirname(dest), { recursive: true });

if (!existsSync(src)) {
  console.warn(`[copy-cycle-index] WARN: source not found: ${src}`);
  if (!existsSync(dest)) {
    const stub = {
      _stub: true,
      _reason: 'source cycle-index.json not found; prebuild hook wrote this placeholder',
      cycles: [],
      updated_at: new Date().toISOString(),
    };
    writeFileSync(dest, JSON.stringify(stub, null, 2));
    console.warn(`[copy-cycle-index] wrote stub to ${dest}`);
  } else {
    console.warn(`[copy-cycle-index] keeping existing ${dest} (no source to overwrite with)`);
  }
  process.exit(0);
}

// Validate JSON parses (catches corrupt edits before the build fails deeper).
try {
  JSON.parse(readFileSync(src, 'utf8'));
} catch (e) {
  console.error(`[copy-cycle-index] source JSON is invalid: ${e.message}`);
  process.exit(1);
}

copyFileSync(src, dest);
console.log(`[copy-cycle-index] ${src} → ${dest}`);
