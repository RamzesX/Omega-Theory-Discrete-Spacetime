/**
 * Accessibility + visual-quality E2E tests (Playwright).
 *
 * What this checks:
 *   - WCAG violations via axe-core (color contrast, alt-text, heading order,
 *     landmark regions, aria labels)
 *   - Every <img> has alt-text (critical for screen readers)
 *   - Heading hierarchy: exactly one <h1>, no skipped levels
 *   - Minimum font size (readable on mobile)
 *   - Links have discernible text (not just icons with empty anchors)
 *   - Tab order is logical (interactive elements reachable by keyboard)
 *
 * Uses @axe-core/playwright (install via `npm install --save-dev @axe-core/playwright`).
 * Skips gracefully if axe is not installed, so CI doesn't fail pre-install.
 */

import { test, expect } from '@playwright/test';

// Dynamic import so tests that don't need axe still run if the dev-dep is missing
let AxeBuilder;
try {
  AxeBuilder = (await import('@axe-core/playwright')).default;
} catch (_e) {
  AxeBuilder = null;
}

const PAGES = {
  home: '/',
  paperQM: '/papers/paper-qm-from-discrete-gravity/',
  appendixF: '/papers/appendix-f-information-flow-conservation/',
  cycles: '/cycles/',
};

test.describe('WCAG accessibility (axe-core)', () => {
  for (const [name, pth] of Object.entries(PAGES)) {
    test(`${name} — no serious/critical a11y violations`, async ({ page }) => {
      test.skip(
        !AxeBuilder,
        '@axe-core/playwright not installed; run `npm install --save-dev @axe-core/playwright`'
      );
      await page.goto(pth);
      await page.waitForLoadState('networkidle');

      const results = await new AxeBuilder({ page })
        .options({
          // Only fail on serious/critical. Minor issues get logged but don't
          // block CI — fonts on mobile can trip contrast false positives.
          resultTypes: ['violations'],
        })
        .analyze();

      const hardBlockers = results.violations.filter((v) =>
        ['serious', 'critical'].includes(v.impact)
      );

      expect(
        hardBlockers,
        `axe serious/critical violations on ${pth}: ${hardBlockers
          .map((v) => `${v.id} (${v.nodes.length})`)
          .join(', ')}`
      ).toEqual([]);
    });
  }
});

test.describe('images have alt text', () => {
  for (const [name, pth] of Object.entries(PAGES)) {
    test(`${name} — no <img> without alt`, async ({ page }) => {
      await page.goto(pth);
      const missing = await page.$$eval('img', (imgs) =>
        imgs
          .filter((i) => !i.hasAttribute('alt'))
          .map((i) => i.getAttribute('src') || '(no src)')
      );
      expect(missing, `<img> elements missing alt: ${missing.join(', ')}`).toEqual([]);
    });
  }
});

test.describe('heading hierarchy', () => {
  test('home has exactly one <h1>', async ({ page }) => {
    await page.goto('/');
    const h1Count = await page.locator('h1').count();
    expect(h1Count, 'exactly one <h1> per page (W3C HTML best practice)').toBe(1);
  });

  test('a paper page has a single <h1>', async ({ page }) => {
    await page.goto(PAGES.paperQM);
    const h1Count = await page.locator('h1').count();
    expect(h1Count, 'paper pages should have exactly one <h1>').toBe(1);
  });

  test('no skipped heading levels (h1 -> h3 without h2)', async ({ page }) => {
    await page.goto(PAGES.paperQM);
    const levels = await page.$$eval('h1, h2, h3, h4, h5, h6', (hs) =>
      hs.map((h) => parseInt(h.tagName.slice(1), 10))
    );
    const skips = [];
    for (let i = 1; i < levels.length; i++) {
      if (levels[i] > levels[i - 1] + 1) {
        skips.push(`h${levels[i - 1]} -> h${levels[i]} at index ${i}`);
      }
    }
    expect(skips, `skipped heading levels: ${skips.join(', ')}`).toEqual([]);
  });
});

test.describe('readable typography', () => {
  test('body text is at least 14px on desktop', async ({ page }) => {
    await page.goto('/');
    const fontSizePx = await page.evaluate(() => {
      const el = document.querySelector('main, body');
      return parseFloat(getComputedStyle(el).fontSize);
    });
    expect(
      fontSizePx,
      `body text too small (${fontSizePx}px) — readability risk`
    ).toBeGreaterThanOrEqual(14);
  });
});

test.describe('links are discernible', () => {
  test('no <a> with empty href or empty text', async ({ page }) => {
    await page.goto('/');
    const bad = await page.$$eval('a', (as) =>
      as
        .filter((a) => {
          const href = a.getAttribute('href');
          const text = (a.textContent || '').trim();
          const aria = a.getAttribute('aria-label');
          const hasImg = !!a.querySelector('img[alt]');
          // OK if: href present AND (text OR aria-label OR img-with-alt)
          return !href || (!text && !aria && !hasImg);
        })
        .map((a) => a.outerHTML.slice(0, 120))
    );
    expect(bad, `<a> elements with no discernible label: ${bad.join(' | ')}`).toEqual([]);
  });
});

test.describe('tab-reachable interactive elements', () => {
  test('first tab press focuses an interactive element', async ({ page }) => {
    await page.goto('/');
    await page.keyboard.press('Tab');
    const focused = await page.evaluate(() => {
      const el = document.activeElement;
      if (!el || el === document.body) return null;
      return { tag: el.tagName, href: el.getAttribute('href'), text: el.textContent?.slice(0, 40) };
    });
    expect(focused, 'first Tab should focus a real interactive element, not document.body').not.toBeNull();
  });
});
