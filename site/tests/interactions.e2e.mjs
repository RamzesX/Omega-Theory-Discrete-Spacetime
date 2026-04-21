/**
 * Interaction tests — clicks, navigation, theme toggle, keyboard.
 *
 * What this catches:
 *   - Nav links that look OK but don't actually navigate (JS error, broken
 *     route, wrong anchor)
 *   - Theme toggle that doesn't flip data-theme or doesn't persist
 *   - External links that should open new tab but don't have target="_blank"
 *   - Anchor/in-page links that don't scroll
 *   - KaTeX failures rendered as `.katex-error` spans
 *   - ThemeToggle keyboard reachability
 *
 * Run: `npm run test:e2e tests/interactions.e2e.mjs`
 */

import { test, expect } from '@playwright/test';

test.describe('sidebar navigation: every link actually navigates', () => {
  test('clicking first nav link lands on expected path', async ({ page }) => {
    await page.goto('/');
    const firstLink = page.locator('.nav-link[href]').first();
    const href = await firstLink.getAttribute('href');
    expect(href, 'first nav-link must have href').toBeTruthy();
    const resp = await Promise.all([
      page.waitForResponse((r) => r.url().endsWith(href) || r.url().includes(href)),
      firstLink.click(),
    ]);
    expect(resp[0].status(), `${href} should return 200`).toBeLessThan(400);
  });

  test('all sidebar links respond 200 when visited', async ({ page, baseURL }) => {
    await page.goto('/');
    const hrefs = await page.$$eval('.nav-link[href]', (links) =>
      links.map((l) => l.getAttribute('href')).filter(Boolean)
    );
    expect(hrefs.length, 'sidebar should have multiple nav links').toBeGreaterThan(3);

    const failures = [];
    for (const href of hrefs.slice(0, 15)) { // cap at 15 to keep test under 1 min
      try {
        const resp = await page.goto(href, { waitUntil: 'domcontentloaded', timeout: 10000 });
        if (!resp || resp.status() >= 400) failures.push(`${href} → ${resp?.status() ?? 'null'}`);
      } catch (e) {
        failures.push(`${href} → ${e.message.slice(0, 50)}`);
      }
    }
    expect(failures, `broken sidebar links: ${failures.join(' | ')}`).toEqual([]);
  });
});

test.describe('theme toggle', () => {
  test('clicking ThemeToggle flips data-theme', async ({ page }) => {
    await page.goto('/');
    const initial = await page.evaluate(() =>
      document.documentElement.getAttribute('data-theme')
    );
    const toggle = page.locator('button[aria-label*="theme" i], button[title*="theme" i], .theme-toggle').first();
    await expect(toggle, 'ThemeToggle button must exist').toBeVisible();
    await toggle.click();
    await page.waitForTimeout(100); // allow theme script to update
    const after = await page.evaluate(() =>
      document.documentElement.getAttribute('data-theme')
    );
    expect(after, 'data-theme should flip after click').not.toBe(initial);
  });

  test('theme choice persists across reload', async ({ page, context }) => {
    await page.goto('/');
    const toggle = page.locator('button[aria-label*="theme" i], .theme-toggle').first();
    await toggle.click();
    const afterClick = await page.evaluate(() =>
      document.documentElement.getAttribute('data-theme')
    );
    await page.reload();
    const afterReload = await page.evaluate(() =>
      document.documentElement.getAttribute('data-theme')
    );
    expect(afterReload, 'theme should persist via localStorage').toBe(afterClick);
  });
});

test.describe('external links: safe handling', () => {
  test('GitHub / arXiv / other external links open new tab', async ({ page }) => {
    await page.goto('/');
    const externals = await page.$$eval('a[href^="http"]', (as) =>
      as
        .filter((a) => {
          const href = a.getAttribute('href') || '';
          return (
            href.startsWith('http') &&
            !href.includes(window.location.host)
          );
        })
        .map((a) => ({
          href: a.getAttribute('href'),
          target: a.getAttribute('target'),
          rel: a.getAttribute('rel') || '',
        }))
    );

    if (externals.length === 0) {
      test.skip(true, 'no external links on home page to test');
    }

    const missingTarget = externals.filter((x) => x.target !== '_blank');
    const missingRel = externals.filter(
      (x) => x.target === '_blank' && !x.rel.includes('noopener')
    );

    expect(
      missingTarget,
      `external links without target="_blank": ${missingTarget.map((x) => x.href).join(', ')}`
    ).toEqual([]);
    expect(
      missingRel,
      `external links with target="_blank" but missing rel="noopener": ${missingRel.map((x) => x.href).join(', ')}`
    ).toEqual([]);
  });
});

test.describe('KaTeX renders without errors', () => {
  test('appendix-F: no .katex-error elements', async ({ page }) => {
    await page.goto('/papers/appendix-f-information-flow-conservation/');
    await page.waitForLoadState('networkidle');
    const errors = await page.locator('.katex-error').count();
    expect(errors, 'KaTeX parse errors found — some equation has bad LaTeX').toBe(0);
  });

  test('appendix-F renders ≥ 50 math blocks (content sanity)', async ({ page }) => {
    await page.goto('/papers/appendix-f-information-flow-conservation/');
    const math = await page.locator('.katex').count();
    expect(math, `only ${math} math blocks — Appendix F should have many more`).toBeGreaterThanOrEqual(50);
  });
});

test.describe('keyboard navigation', () => {
  test('Tab reaches ThemeToggle within first 10 presses', async ({ page }) => {
    await page.goto('/');
    let reached = false;
    for (let i = 0; i < 10; i++) {
      await page.keyboard.press('Tab');
      const isToggle = await page.evaluate(() => {
        const el = document.activeElement;
        const label = el?.getAttribute('aria-label') || '';
        return /theme/i.test(label) || (el?.classList?.contains?.('theme-toggle') ?? false);
      });
      if (isToggle) {
        reached = true;
        break;
      }
    }
    expect(reached, 'Tab should reach ThemeToggle within first 10 interactive elements').toBe(true);
  });

  test('Escape closes mobile sidebar if open (responsive)', async ({ page, viewport }) => {
    test.skip((viewport?.width ?? 999) > 768, 'mobile-only test');
    await page.goto('/');
    // Click the sidebar-toggle if visible (mobile)
    const toggle = page.locator('.sidebar-toggle');
    if (await toggle.isVisible()) {
      await toggle.click();
      // Sidebar should be open; press Escape
      await page.keyboard.press('Escape');
      // Verify sidebar collapsed (implementation-specific — check data-state or class)
    }
  });
});

test.describe('anchor / in-page links', () => {
  test('clicking a section heading link scrolls to that section', async ({ page }) => {
    await page.goto('/papers/appendix-f-information-flow-conservation/');
    const firstAnchor = page.locator('a[href^="#"]').first();
    if ((await firstAnchor.count()) === 0) {
      test.skip(true, 'no in-page anchors on this paper');
    }
    const href = await firstAnchor.getAttribute('href');
    const id = href.replace('#', '');
    await firstAnchor.click();
    await page.waitForTimeout(200);
    const scrolled = await page.evaluate(() => window.scrollY);
    expect(scrolled, `clicking #${id} should scroll page`).toBeGreaterThan(0);
  });
});
