// Copies PhysicsPapers/LeanFormalizationV2/cycle-index.json into
// site/src/data/ so Vite can statically import it. Run as a `prebuild`
// hook in package.json, so it always runs before `astro build` and
// keeps the site mirror in sync with the canonical JSON.

import { copyFileSync, readFileSync, existsSync } from 'node:fs';
import { resolve } from 'node:path';

const src  = resolve('../PhysicsPapers/LeanFormalizationV2/cycle-index.json');
const dest = resolve('./src/data/cycle-index.json');

if (!existsSync(src)) {
  console.error(`[copy-cycle-index] source not found: ${src}`);
  process.exit(1);
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
