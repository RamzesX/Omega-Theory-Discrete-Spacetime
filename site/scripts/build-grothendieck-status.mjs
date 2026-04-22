// Computes live Grothendieck-puzzle status by:
//   1. Reading grothendieck-predictions.json
//   2. Grepping PhysicsPapers/LeanFormalizationV2/OmegaTheory/** for each
//      predicted theorem name as `theorem NAME` or `lemma NAME`
//   3. Writing grothendieck-status.json (mirror → site/src/data/) with
//      { landed: [names], open: [names], perPass: [{...}], summary: {...} }
//
// Runs as part of `npm run prebuild` so the /algebra/ page always has
// fresh status on build.

import { readFileSync, writeFileSync, existsSync, readdirSync, statSync } from 'node:fs';
import { join, resolve } from 'node:path';

const PREDICTIONS_SRC = resolve('../PhysicsPapers/OmegaTheoryAlgebra/grothendieck-predictions.json');
const LEAN_ROOT       = resolve('../PhysicsPapers/LeanFormalizationV2/OmegaTheory');
const STATUS_DEST     = resolve('./src/data/grothendieck-status.json');
const PREDICTIONS_DEST = resolve('./src/data/grothendieck-predictions.json');

if (!existsSync(PREDICTIONS_SRC)) {
  console.error(`[grothendieck-status] predictions source missing: ${PREDICTIONS_SRC}`);
  process.exit(1);
}

let predictions;
try {
  predictions = JSON.parse(readFileSync(PREDICTIONS_SRC, 'utf8'));
} catch (e) {
  console.error(`[grothendieck-status] predictions JSON invalid: ${e.message}`);
  process.exit(1);
}

// Mirror predictions into site/src/data/ for bundler-friendly import.
writeFileSync(PREDICTIONS_DEST, JSON.stringify(predictions, null, 2) + '\n');

// Collect all Lean declarations under OmegaTheory/ once. A light lexer:
// we look for lines that begin with `theorem NAME` or `lemma NAME` (optionally
// preceded by attributes/whitespace). This is deliberately conservative — we
// just want to mark a prediction as LANDED when its name appears as a top-level
// declaration anywhere in the source tree.
function walkLean(dir, out = []) {
  if (!existsSync(dir)) return out;
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    const s = statSync(full);
    if (s.isDirectory()) walkLean(full, out);
    else if (entry.endsWith('.lean')) out.push(full);
  }
  return out;
}

// Match top-level declarations: theorem/lemma (propositions) or def/abbrev
// (values/structure instantiations). Structural predictions like
// `spectralTriple_OmegaSubstrate` land as `def`, not `theorem`.
const declRegex = /^\s*(?:@\[[^\]]*\]\s*)*(?:noncomputable\s+)?(?:private\s+)?(?:protected\s+)?(theorem|lemma|def|abbrev)\s+([A-Za-z_][A-Za-z0-9_'.]*)/gm;

const declaredNames = new Set();
const declaredAt = new Map(); // name -> file:line
const leanFiles = walkLean(LEAN_ROOT);

for (const file of leanFiles) {
  const content = readFileSync(file, 'utf8');
  let m;
  declRegex.lastIndex = 0;
  while ((m = declRegex.exec(content)) !== null) {
    const name = m[2];
    declaredNames.add(name);
    if (!declaredAt.has(name)) {
      const lineNo = content.slice(0, m.index).split('\n').length;
      const rel = file.replace(LEAN_ROOT + '/', '');
      declaredAt.set(name, `${rel}:${lineNo}`);
    }
  }
}

// Mark each prediction's status.
const perPass = predictions.passes.map((p) => {
  const enriched = p.predictions.map((pred) => {
    const landed = declaredNames.has(pred.name);
    return {
      ...pred,
      landed,
      location: landed ? declaredAt.get(pred.name) : null,
      effectiveTag: landed ? 'LANDED' : pred.tag,
    };
  });
  return {
    id: p.id,
    title: p.title,
    question: p.question,
    predictions: enriched,
    landed_count: enriched.filter((x) => x.landed).length,
    total_count: enriched.length,
  };
});

const totalPred = perPass.reduce((n, p) => n + p.total_count, 0);
const totalLanded = perPass.reduce((n, p) => n + p.landed_count, 0);

const status = {
  updated: new Date().toISOString(),
  source: predictions.source_doc,
  summary: {
    totalPredictions: totalPred,
    totalLanded: totalLanded,
    totalOpen: totalPred - totalLanded,
    percentLanded: totalPred > 0 ? Math.round((totalLanded / totalPred) * 100) : 0,
    leanFilesScanned: leanFiles.length,
    totalDeclarationsIndexed: declaredNames.size,
  },
  perPass,
};

writeFileSync(STATUS_DEST, JSON.stringify(status, null, 2) + '\n');

console.log(
  `[grothendieck-status] ${totalLanded}/${totalPred} predictions landed (${status.summary.percentLanded}%); ` +
  `scanned ${leanFiles.length} Lean files, ${declaredNames.size} declarations`
);
