#!/usr/bin/env node
/**
 * audit-dist.js — regression tests for dist/ produced by `astro build`.
 *
 * Runs in CI (.github/workflows/astro.yml) AFTER `astro build` and BEFORE
 * `upload-pages-artifact` so a broken deploy is caught before it ships.
 *
 * Also runnable locally:
 *   node scripts/audit-dist.js
 *
 * Exit 0 = all checks passed.
 * Exit 1 = at least one regression found; message printed to stderr.
 *
 * Checks:
 *   1. dist/.nojekyll exists (prevents GitHub Pages Jekyll processing
 *      which would strip the _astro/ directory).
 *   2. dist/_astro/ is non-empty.
 *   3. dist/index.html contains <meta name="generator" content="Astro ...">
 *      (not Jekyll; sanity-check the build was Astro and not something
 *      else that happened to produce an index.html).
 *   4. dist/index.html has ≥1 <link rel="stylesheet" href="BASE/_astro/...">
 *      with the configured base prefix.
 *   5. No stray Jekyll artefacts (no <meta name="generator" content="Jekyll").
 *   6. Internal hrefs/src all start with the configured base (or are
 *      external / anchor / data URIs). This catches base-path drift where
 *      raw `/foo/` links would 404 on GitHub Pages.
 *   7. No unexpected `integrity=` on CDN <link> tags outside a whitelist
 *      (SRI hashes are known-breaky; BaseLayout already removed the KaTeX
 *      one — this prevents reintroduction).
 *   8. Regression guard: no root-relative href/src pointing to the legacy
 *      sibling-repo base `/Omega-Theory-Discrete-Spacetime` appears anywhere
 *      in dist HTML (walked recursively). Substring-level check so even a
 *      template-concat bug like `/Omega-Theory-Discrete-Spacetimefavicon.svg`
 *      is caught. Legitimate external URLs
 *      (https://github.com/RamzesX/Omega-Theory-Discrete-Spacetime) are
 *      whitelisted because the check only matches leading-slash forms.
 *
 * Node stdlib only — no npm deps.
 */

import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
import { join, resolve, dirname } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const siteDir = resolve(__dirname, '..');
const distDir = join(siteDir, 'dist');

const errors = [];
const warnings = [];

function fail(msg) {
  errors.push(msg);
}
function warn(msg) {
  warnings.push(msg);
}

// --- Load configured base from astro.config.mjs ---------------------------
// Dynamic import so we parse exactly what the build uses.
let expectedBase = '';
try {
  const cfgUrl = pathToFileURL(join(siteDir, 'astro.config.mjs')).href;
  const cfgModule = await import(cfgUrl);
  const cfg =
    typeof cfgModule.default === 'function'
      ? cfgModule.default
      : cfgModule.default;
  // defineConfig returns the config object directly.
  expectedBase = cfg?.base ?? '';
  if (!expectedBase) {
    warn('astro.config.mjs has no `base` — skipping base-prefix checks.');
  }
} catch (err) {
  fail(`Could not import astro.config.mjs: ${err.message}`);
}

// Normalise base: ensure leading `/` and no trailing `/`.
if (expectedBase && !expectedBase.startsWith('/')) {
  expectedBase = '/' + expectedBase;
}
if (expectedBase.endsWith('/') && expectedBase.length > 1) {
  expectedBase = expectedBase.slice(0, -1);
}

// --- Check 1: dist/ exists -----------------------------------------------
if (!existsSync(distDir)) {
  fail(`dist/ not found at ${distDir}. Did \`astro build\` run?`);
  report();
}

// --- Check 2: dist/.nojekyll exists --------------------------------------
if (!existsSync(join(distDir, '.nojekyll'))) {
  fail(
    'dist/.nojekyll missing. GitHub Pages will run Jekyll on the artefact ' +
      'and strip the _astro/ directory, serving the site completely unstyled. ' +
      'Fix: create an empty file at site/public/.nojekyll (Astro copies ' +
      'public/* to dist/).'
  );
}

// --- Check 3: dist/_astro/ non-empty -------------------------------------
const astroAssetsDir = join(distDir, '_astro');
if (!existsSync(astroAssetsDir)) {
  fail('dist/_astro/ missing. Astro build output is broken.');
} else {
  const assetEntries = readdirSync(astroAssetsDir);
  if (assetEntries.length === 0) {
    fail('dist/_astro/ is empty. Astro produced no bundled assets.');
  } else {
    const hasCss = assetEntries.some((f) => f.endsWith('.css'));
    if (!hasCss) {
      warn(
        'dist/_astro/ has no .css files. Is styling actually emitted?'
      );
    }
  }
}

// --- Check 4/5/6/7: parse index.html -------------------------------------
const indexHtmlPath = join(distDir, 'index.html');
if (!existsSync(indexHtmlPath)) {
  fail('dist/index.html missing.');
} else {
  const html = readFileSync(indexHtmlPath, 'utf8');

  // 4. <meta name="generator" content="Astro ...">
  const generatorMatch = html.match(
    /<meta[^>]*name=["']generator["'][^>]*content=["']([^"']*)["']/i
  );
  if (!generatorMatch) {
    fail(
      'dist/index.html has no <meta name="generator"> tag. BaseLayout.astro ' +
        'should emit {Astro.generator}.'
    );
  } else if (!generatorMatch[1].toLowerCase().startsWith('astro')) {
    fail(
      `dist/index.html generator is "${generatorMatch[1]}", expected "Astro ...". ` +
        'Is another site source (Jekyll?) also writing to dist/?'
    );
  }
  if (/content=["']Jekyll/i.test(html)) {
    fail('dist/index.html contains Jekyll generator tag. Source conflict.');
  }

  // 5. ≥1 <link rel="stylesheet" href="BASE/_astro/...">
  const styleLinkRe =
    /<link[^>]*rel=["']stylesheet["'][^>]*href=["']([^"']+)["'][^>]*>/gi;
  const styleHrefs = [];
  let m;
  while ((m = styleLinkRe.exec(html)) !== null) {
    styleHrefs.push(m[1]);
  }
  if (styleHrefs.length === 0) {
    fail('dist/index.html has no <link rel="stylesheet"> tags at all.');
  }
  const localCssHrefs = styleHrefs.filter(
    (h) => !h.startsWith('http://') && !h.startsWith('https://')
  );
  if (localCssHrefs.length === 0) {
    fail(
      'dist/index.html has no local _astro/*.css stylesheet. Only external ' +
        'CDN styles will load; component styling will be missing.'
    );
  }
  if (expectedBase) {
    const wrongBaseCss = localCssHrefs.filter(
      (h) => !h.startsWith(expectedBase + '/')
    );
    if (wrongBaseCss.length > 0) {
      fail(
        `Local stylesheet hrefs do not start with base "${expectedBase}/": ` +
          wrongBaseCss.join(', ') +
          '. Every asset will 404 on GitHub Pages.'
      );
    }
    const hasAstroCss = localCssHrefs.some((h) =>
      h.startsWith(`${expectedBase}/_astro/`)
    );
    if (!hasAstroCss) {
      fail(
        `dist/index.html has no <link rel="stylesheet" href="${expectedBase}/_astro/*.css">. ` +
          'Astro bundled CSS is not being linked.'
      );
    }
  }

  // 6. Internal hrefs/srcs all start with base.
  if (expectedBase) {
    const attrRe =
      /(?:href|src)=["']([^"']+)["']/gi;
    const bad = new Set();
    let am;
    while ((am = attrRe.exec(html)) !== null) {
      const v = am[1];
      if (!v) continue;
      if (
        v.startsWith('http://') ||
        v.startsWith('https://') ||
        v.startsWith('//') ||
        v.startsWith('#') ||
        v.startsWith('data:') ||
        v.startsWith('mailto:') ||
        v.startsWith('tel:') ||
        v.startsWith(expectedBase + '/') ||
        v === expectedBase ||
        v === expectedBase + '/'
      ) {
        continue;
      }
      if (v.startsWith('/')) {
        bad.add(v);
      }
    }
    if (bad.size > 0) {
      fail(
        `Found ${bad.size} root-relative hrefs/srcs not prefixed with base "${expectedBase}": ` +
          [...bad].slice(0, 5).join(', ') +
          (bad.size > 5 ? `, ... (+${bad.size - 5} more)` : '') +
          '. These will 404 on GitHub Pages.'
      );
    }
  }

  // 7. No `integrity=` on CDN <link> tags (we removed the KaTeX one because
  //    the hash was corrupted and blocked the stylesheet). Regression guard.
  const cdnIntegrityRe =
    /<link[^>]*href=["']https:\/\/cdn\.jsdelivr\.net\/[^"']+["'][^>]*integrity=["']([^"']+)["']/gi;
  let im;
  while ((im = cdnIntegrityRe.exec(html)) !== null) {
    fail(
      `Regression: <link> to CDN (cdn.jsdelivr.net) has integrity="${im[1]}". ` +
        'BaseLayout removed that because the SRI hash was corrupted. Either ' +
        'use a verified hash or omit the integrity attribute.'
    );
  }
}

// --- Check 8: Legacy-base regression guard (walks every emitted .html) ---
// Commit 7b0f236 moved `base` from `/Omega-Theory-Discrete-Spacetime` (the
// sibling Jekyll repo's slug) to `/chaos-shield`. Any reappearance of the old
// slug as a ROOT-RELATIVE href/src means either a template regressed to a
// hardcoded path OR a concat bug produced `/<base><file>` with no separator.
// Legitimate external URLs like `https://github.com/RamzesX/Omega-Theory-...`
// are allowed — we only forbid the leading-slash form.
const FORBIDDEN_BASE = '/Omega-Theory-Discrete-Spacetime';
function walkHtml(dir) {
  const out = [];
  for (const entry of readdirSync(dir)) {
    const p = join(dir, entry);
    const st = statSync(p);
    if (st.isDirectory()) {
      // Skip _astro/ — it contains hashed CSS/JS, no markup.
      if (entry === '_astro') continue;
      out.push(...walkHtml(p));
    } else if (entry.endsWith('.html')) {
      out.push(p);
    }
  }
  return out;
}
try {
  const htmlFiles = walkHtml(distDir);
  const leakRe =
    /(?:href|src)\s*=\s*["']\/Omega-Theory-Discrete-Spacetime[^"']*["']/gi;
  const leaks = new Map(); // file -> Set<url>
  for (const file of htmlFiles) {
    const body = readFileSync(file, 'utf8');
    let lm;
    while ((lm = leakRe.exec(body)) !== null) {
      const url = lm[0].match(/["']([^"']+)["']/)[1];
      if (!leaks.has(file)) leaks.set(file, new Set());
      leaks.get(file).add(url);
    }
  }
  if (leaks.size > 0) {
    const lines = [];
    let total = 0;
    for (const [file, urls] of leaks) {
      const rel = file.slice(distDir.length + 1);
      for (const u of urls) {
        lines.push(`    ${rel}: ${u}`);
        total++;
      }
    }
    fail(
      `Regression: ${total} root-relative href/src pointing to legacy base ` +
        `"${FORBIDDEN_BASE}" (the old sibling-repo slug). Every one will 404. ` +
        `Fix: use \`${'${baseUrl}<path>'}\` with baseUrl from import.meta.env.BASE_URL, ` +
        'or absolute https:// URLs for external targets. Offending hrefs:\n' +
        lines.slice(0, 30).join('\n') +
        (lines.length > 30 ? `\n    ... (+${lines.length - 30} more)` : '')
    );
  }
} catch (err) {
  fail(`Legacy-base scan failed: ${err.message}`);
}

// --- Report ---------------------------------------------------------------
function report() {
  if (warnings.length > 0) {
    for (const w of warnings) console.warn('  WARN: ' + w);
  }
  if (errors.length > 0) {
    console.error('\naudit-dist.js FAILED:');
    for (const e of errors) console.error('  - ' + e);
    console.error(
      '\nSee site/scripts/audit-dist.js for what each check verifies.'
    );
    process.exit(1);
  }
  console.log(
    `audit-dist.js OK (base="${expectedBase}", ${warnings.length} warning${warnings.length === 1 ? '' : 's'})`
  );
  process.exit(0);
}

report();
