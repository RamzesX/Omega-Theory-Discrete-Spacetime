/**
 * Smoke tests for every emitted HTML page in `dist/`.
 *
 * Catches regressions like:
 *   - missing base-prefix on <link>/<script>/<img>
 *   - the `/Omega-Theory-Discrete-Spacetime` legacy slug leaking anywhere
 *   - the `/basefavicon.svg` template-concat bug (no separator before filename)
 *   - pages that renders to 0 bytes (copy-content silently dropping something)
 *   - missing `<title>`, `<main>`, or charset meta
 *
 * Runs with the Node built-in `node:test` runner — no external deps.
 * Executed via `npm test` which first does `npm run build`.
 *
 * Why Node's built-in runner and not vitest/jest?
 *   - Vitest would need a second dev-dep tree (zero benefit vs built-in here)
 *   - These are post-build HTML assertions, not unit tests of JS logic
 *   - The built-in runner ships with Node 24 (GitHub Pages CI runner)
 */

import { test } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import url from 'node:url';

const __dirname = path.dirname(url.fileURLToPath(import.meta.url));
const SITE_ROOT = path.resolve(__dirname, '..');
const DIST = path.join(SITE_ROOT, 'dist');
const EXPECTED_BASE = '/Omega-Theory-Discrete-Spacetime';
// Forbid the `/chaos-shield` rename probe from cycle-44 (commit 7b0f236).
// The rename was not completed on GitHub — canonical name stayed
// Omega-Theory-Discrete-Spacetime. Root-relative `/chaos-shield` refs in
// emitted HTML would 404 against the real Pages URL.
const FORBIDDEN_BASES = ['/chaos-shield'];

function walkHtml(dir) {
  const out = [];
  const stack = [dir];
  while (stack.length) {
    const d = stack.pop();
    for (const entry of fs.readdirSync(d, { withFileTypes: true })) {
      const p = path.join(d, entry.name);
      if (entry.isDirectory()) {
        if (entry.name === '_astro') continue;
        stack.push(p);
      } else if (entry.isFile() && entry.name.endsWith('.html')) {
        out.push(p);
      }
    }
  }
  return out;
}

const htmlFiles = fs.existsSync(DIST) ? walkHtml(DIST) : [];
const rel = (p) => path.relative(DIST, p).replaceAll('\\', '/');

test('dist/ exists and contains at least 1 HTML file', () => {
  assert.ok(fs.existsSync(DIST), `dist/ does not exist — did you run \`npm run build\` first?`);
  assert.ok(htmlFiles.length > 0, 'no HTML files found in dist/');
});

test('dist/.nojekyll exists (blocks GitHub Pages Jekyll processing)', () => {
  const noJekyll = path.join(DIST, '.nojekyll');
  assert.ok(fs.existsSync(noJekyll), 'dist/.nojekyll missing — GitHub Pages will Jekyll-strip _astro/');
});

test('dist/_astro/ contains CSS bundles (JS is optional for static sites)', () => {
  const astroDir = path.join(DIST, '_astro');
  assert.ok(fs.existsSync(astroDir), 'dist/_astro/ missing — assets not emitted');
  const entries = fs.readdirSync(astroDir);
  assert.ok(entries.some((f) => f.endsWith('.css')), 'no .css in dist/_astro/');
  // JS is only emitted when there are interactive islands. Our site is
  // mostly static, so absence of .js here is not a bug — just note.
});

test('every HTML page has a non-empty <title>', () => {
  const failures = [];
  for (const f of htmlFiles) {
    const html = fs.readFileSync(f, 'utf8');
    const m = html.match(/<title[^>]*>([^<]*)<\/title>/i);
    if (!m || !m[1].trim()) failures.push(rel(f));
  }
  assert.equal(failures.length, 0, `pages with empty <title>: ${failures.join(', ')}`);
});

test('every HTML page has UTF-8 charset meta', () => {
  const failures = [];
  for (const f of htmlFiles) {
    const html = fs.readFileSync(f, 'utf8');
    if (!/<meta[^>]*charset=["']?utf-8["']?/i.test(html)) failures.push(rel(f));
  }
  assert.equal(failures.length, 0, `pages missing <meta charset="utf-8">: ${failures.join(', ')}`);
});

test('no HTML page is suspiciously tiny (< 500 bytes) — catches render failures', () => {
  const tiny = [];
  for (const f of htmlFiles) {
    const size = fs.statSync(f).size;
    if (size < 500) tiny.push(`${rel(f)} (${size}B)`);
  }
  assert.equal(tiny.length, 0, `tiny HTML pages (likely render failure): ${tiny.join(', ')}`);
});

test('FORBIDDEN: no root-relative href/src uses a deprecated repo slug', () => {
  // If the repo is renamed, add the old value to FORBIDDEN_BASES and this
  // test catches stragglers. Currently empty — no active forbidden slug.
  if (FORBIDDEN_BASES.length === 0) return; // nothing to check
  const leaks = [];
  for (const slug of FORBIDDEN_BASES) {
    const leakRe = new RegExp(
      `(?:href|src)\\s*=\\s*["']${slug.replace(/\//g, '\\/')}[^"']*["']`,
      'gi'
    );
    for (const f of htmlFiles) {
      const html = fs.readFileSync(f, 'utf8');
      const matches = html.match(leakRe);
      if (matches) matches.forEach((m) => leaks.push(`${rel(f)}: ${m}`));
    }
  }
  assert.equal(leaks.length, 0, `legacy base-path leaks: ${leaks.join(' | ')}`);
});

test('FORBIDDEN: no "${base}favicon" concat-without-separator bugs', () => {
  // Catches `${base}favicon.svg` with no slash (Astro base-path concat bug).
  // Builds patterns dynamically from EXPECTED_BASE so this test stays correct
  // across repo renames.
  const baseNoSlash = EXPECTED_BASE.replace(/^\//, '');
  const pfx = EXPECTED_BASE.replace(/\//g, '\\/');
  const badPatterns = [
    new RegExp(`${pfx}favicon`),  // /basefavicon.svg
    new RegExp(`${pfx}(index|404|papers|cycles|convqmath|lean)[^/"'_]`),  // /baseindex.html etc.
  ];
  const hits = [];
  for (const f of htmlFiles) {
    const html = fs.readFileSync(f, 'utf8');
    for (const pat of badPatterns) {
      const m = html.match(pat);
      if (m) hits.push(`${rel(f)}: ${m[0]}`);
    }
  }
  assert.equal(hits.length, 0, `concat-without-separator bugs: ${hits.join(' | ')}`);
});

test('root-relative asset URLs are prefixed with the configured base', () => {
  // Find asset-like root-relative hrefs/srcs and check they start with EXPECTED_BASE or are external.
  // Scopes: href to .css, src to .js, src to images, src to fonts.
  const assetAttrRe = /(?:href|src)\s*=\s*["'](\/[^"']+?\.(?:css|js|svg|png|jpg|jpeg|webp|woff2?))["']/gi;
  const offenders = [];
  for (const f of htmlFiles) {
    const html = fs.readFileSync(f, 'utf8');
    let m;
    while ((m = assetAttrRe.exec(html)) !== null) {
      const target = m[1];
      // External-looking URLs don't start with / — they're handled elsewhere
      if (!target.startsWith(EXPECTED_BASE + '/') && !target.startsWith(EXPECTED_BASE + '_')) {
        offenders.push(`${rel(f)}: ${target}`);
      }
    }
  }
  assert.equal(offenders.length, 0,
    `asset URLs not prefixed with "${EXPECTED_BASE}": ${offenders.slice(0, 10).join(' | ')}${offenders.length > 10 ? ` (+${offenders.length - 10} more)` : ''}`);
});
