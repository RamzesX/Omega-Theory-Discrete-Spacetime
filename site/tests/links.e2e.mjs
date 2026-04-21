/**
 * Link crawl — ensure every internal link resolves on the running site.
 *
 * Visits the home page, collects every internal href, visits each, checks
 * status 200 and zero 4xx/5xx on assets. Skips external links and fragment-
 * only hashes. Limits to 40 pages so CI doesn't run forever.
 *
 * Complements Makefile / check_links.py (which is static) with actual runtime
 * verification — catches cases where a link exists in dist/ but Astro's
 * trailing-slash config makes it 404 at request time.
 */

import { test, expect } from '@playwright/test';

const MAX_PAGES = 40;
const STARTING_URLS = ['/', '/cycles/', '/lean/', '/convqmath/'];

function isInternal(href, origin) {
  try {
    const u = new URL(href, origin);
    return u.origin === origin;
  } catch {
    return false;
  }
}

test('internal link crawl — every reachable page returns 200', async ({ page, baseURL }) => {
  const origin = new URL(baseURL).origin;
  const basePath = new URL(baseURL).pathname.replace(/\/$/, ''); // /Omega-Theory-Discrete-Spacetime
  const toVisit = new Set(STARTING_URLS);
  const visited = new Set();
  const failures = [];

  while (toVisit.size > 0 && visited.size < MAX_PAGES) {
    const next = toVisit.values().next().value;
    toVisit.delete(next);
    if (visited.has(next)) continue;
    visited.add(next);

    let response;
    try {
      response = await page.goto(next, { waitUntil: 'domcontentloaded', timeout: 15000 });
    } catch (e) {
      failures.push(`${next} — navigation error: ${e.message}`);
      continue;
    }

    if (!response || response.status() >= 400) {
      failures.push(`${next} — status ${response?.status() ?? 'null'}`);
      continue;
    }

    // Collect internal hrefs on this page for continued crawl
    const hrefs = await page.$$eval('a[href]', (as) =>
      as.map((a) => a.getAttribute('href')).filter(Boolean)
    );
    for (const h of hrefs) {
      if (h.startsWith('#') || h.startsWith('mailto:')) continue;
      if (!isInternal(h, origin)) continue;
      const url = new URL(h, origin);
      const pathOnly = url.pathname + url.search;
      // Skip paths outside base (e.g. absolute GitHub links in content)
      if (basePath && !pathOnly.startsWith(basePath)) continue;
      if (!visited.has(pathOnly)) toVisit.add(pathOnly);
    }
  }

  expect(
    failures,
    `${failures.length} broken internal links: ${failures.slice(0, 10).join(' | ')}${
      failures.length > 10 ? ` (+${failures.length - 10} more)` : ''
    }`
  ).toEqual([]);

  expect(
    visited.size,
    'crawl should visit at least a few pages (home + cycles + lean + convqmath = 4+)'
  ).toBeGreaterThanOrEqual(4);
});

test('zero 4xx/5xx responses during crawl (assets + nav)', async ({ page, baseURL }) => {
  const origin = new URL(baseURL).origin;
  const failures = [];

  page.on('response', (r) => {
    const u = r.url();
    // Only track same-origin (the deployed site)
    if (!u.startsWith(origin)) return;
    if (r.status() >= 400) failures.push(`${r.status()} ${u}`);
  });

  for (const url of ['/', '/cycles/', '/papers/paper-qm-from-discrete-gravity/']) {
    await page.goto(url);
    await page.waitForLoadState('networkidle');
  }

  expect(
    failures,
    `HTTP errors during crawl: ${failures.slice(0, 10).join(' | ')}`
  ).toEqual([]);
});
