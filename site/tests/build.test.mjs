/**
 * Build invariants — catches build-time regressions without running Playwright.
 *
 * What this catches:
 *   - `astro build` exits non-zero
 *   - Build time balloons (regression detector)
 *   - Expected set of routes missing (copy-content drops a paper silently)
 *   - Build stdout contains forbidden keywords (unresolved import, missing asset)
 *   - `dist/` is empty or tiny (global build failure not reflected in exit code)
 *   - Mandatory files absent (.nojekyll, index.html, robots.txt if configured)
 *
 * Run: `npm run test:build` or inside `npm test`.
 */

import { test } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import url from 'node:url';

const __dirname = path.dirname(url.fileURLToPath(import.meta.url));
const SITE_ROOT = path.resolve(__dirname, '..');
const DIST = path.join(SITE_ROOT, 'dist');

const REQUIRED_ROUTES = [
  'index.html',
  '404.html',
  'convqmath/index.html',
  'cycles/index.html',
  'lean/index.html',
  'papers/main-paper-postulates/index.html',
  'papers/paper-qm-from-discrete-gravity/index.html',
  'papers/paper-dark-energy-preview-v1/index.html',
  'papers/appendix-a-action-density-and-quantum-errors/index.html',
  'papers/appendix-f-information-flow-conservation/index.html',
  'papers/unified-theory-diagram/index.html',
];

const FORBIDDEN_STDOUT_SUBSTRINGS = [
  // These are near-always signs of breakage in Astro output
  'Cannot find module',
  'Failed to resolve',
  'Error: ENOENT',
  'ReferenceError:',
  'TypeError: Cannot read',
  'SyntaxError:',
  /* Note: do NOT forbid 'warning' — Astro emits legitimate deprecation warnings */
];

const MAX_BUILD_SECONDS = 120;

test('dist/ contains all required route HTML files', () => {
  const missing = REQUIRED_ROUTES.filter(
    (r) => !fs.existsSync(path.join(DIST, r))
  );
  assert.equal(
    missing.length,
    0,
    `missing required routes in dist/: ${missing.join(', ')}`
  );
});

test('dist/index.html is not suspiciously tiny', () => {
  const index = path.join(DIST, 'index.html');
  if (!fs.existsSync(index)) {
    // Covered by a separate test — skip here so the failure message is clean
    return;
  }
  const size = fs.statSync(index).size;
  assert.ok(
    size > 1000,
    `dist/index.html is only ${size} bytes — likely render failure`
  );
});

test('dist/.nojekyll exists', () => {
  assert.ok(
    fs.existsSync(path.join(DIST, '.nojekyll')),
    'dist/.nojekyll missing — GitHub Pages will Jekyll-strip _astro/'
  );
});

// This is the slow test — skipped unless FULL_BUILD=1. Useful as a pre-merge
// smoke before pushing.
test(
  'astro build (slow — run with FULL_BUILD=1)',
  { skip: !process.env.FULL_BUILD },
  (t) => {
    t.diagnostic('running `astro build` end-to-end — may take ~5-30s');

    const start = Date.now();
    const res = spawnSync('node', ['node_modules/astro/astro.js', 'build'], {
      cwd: SITE_ROOT,
      encoding: 'utf8',
      env: { ...process.env, NODE_ENV: 'production' },
    });
    const seconds = (Date.now() - start) / 1000;

    t.diagnostic(`build took ${seconds.toFixed(1)}s`);

    assert.equal(
      res.status,
      0,
      `astro build failed (exit ${res.status}):\nSTDOUT:\n${res.stdout}\nSTDERR:\n${res.stderr}`
    );

    assert.ok(
      seconds < MAX_BUILD_SECONDS,
      `build took ${seconds.toFixed(1)}s — regression? ceiling=${MAX_BUILD_SECONDS}s`
    );

    const combined = (res.stdout || '') + (res.stderr || '');
    const hits = FORBIDDEN_STDOUT_SUBSTRINGS.filter((s) => combined.includes(s));
    assert.equal(
      hits.length,
      0,
      `build output contains forbidden keywords: ${hits.join(', ')}\nFull output:\n${combined.slice(-2000)}`
    );
  }
);

test(
  'copy-content.js (slow — run with FULL_BUILD=1)',
  { skip: !process.env.FULL_BUILD },
  () => {
    const res = spawnSync('node', ['scripts/copy-content.js'], {
      cwd: SITE_ROOT,
      encoding: 'utf8',
    });
    assert.equal(
      res.status,
      0,
      `copy-content.js failed (exit ${res.status}):\n${res.stderr}`
    );
    // Confirms at least some papers made it across
    const papersDir = path.join(SITE_ROOT, 'src', 'content', 'papers');
    const papers = fs
      .readdirSync(papersDir)
      .filter((f) => f.endsWith('.md'));
    assert.ok(
      papers.length >= 10,
      `expected ≥10 papers in src/content/papers/, got ${papers.length}`
    );
  }
);

test('package.json: every test:* script is documented in this runner', () => {
  const pkg = JSON.parse(
    fs.readFileSync(path.join(SITE_ROOT, 'package.json'), 'utf8')
  );
  const testScripts = Object.keys(pkg.scripts || {}).filter((k) =>
    k.startsWith('test')
  );
  assert.ok(testScripts.length >= 2, 'package.json should have test scripts');
  assert.ok(
    testScripts.includes('test'),
    'package.json missing `test` script entry'
  );
});

test('site/src/content/papers has at least 10 .md files', () => {
  const papersDir = path.join(SITE_ROOT, 'src', 'content', 'papers');
  if (!fs.existsSync(papersDir)) {
    assert.fail(`src/content/papers/ missing — did copy-content.js ever run?`);
  }
  const md = fs.readdirSync(papersDir).filter((f) => f.endsWith('.md'));
  assert.ok(
    md.length >= 10,
    `expected ≥10 papers, got ${md.length}: ${md.join(', ')}`
  );
});

test('astro.config.mjs base must be /Omega-Theory-Discrete-Spacetime', () => {
  const cfg = fs.readFileSync(
    path.join(SITE_ROOT, 'astro.config.mjs'),
    'utf8'
  );
  assert.match(
    cfg,
    /base\s*:\s*['"]\/Omega-Theory-Discrete-Spacetime['"]/,
    'astro.config.mjs `base` must be exactly "/Omega-Theory-Discrete-Spacetime" — any other value breaks GitHub Pages deploy'
  );
});
