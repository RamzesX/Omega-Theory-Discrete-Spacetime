/**
 * Appearance + behavior tests for the Astro site.
 *
 * What this checks (that smoke tests can't):
 *   - Pages actually render with CSS applied (computed styles, not just class names)
 *   - KaTeX math renders to MathML/HTML (critical for a physics site)
 *   - No broken asset requests (404s on CSS/JS/fonts)
 *   - No console errors / unhandled exceptions
 *   - Navigation works — links on the landing page resolve
 *   - Responsive layout: mobile viewport doesn't break structure
 *   - Visual regression snapshots for the key pages (home, a paper, cycles)
 *
 * Run: `npm run test:e2e`
 * Requires: `npm install` (Playwright devDep) + `npx playwright install chromium`
 */

import { test, expect } from '@playwright/test';

const PAGES = {
  home: '/',
  convqmath: '/convqmath/',
  cycles: '/cycles/',
  lean: '/lean/',
  paperQM: '/papers/paper-qm-from-discrete-gravity/',
  paperDE: '/papers/paper-dark-energy-preview-v1/',
  appendixA: '/papers/appendix-a-action-density-and-quantum-errors/',
  appendixF: '/papers/appendix-f-information-flow-conservation/',  // has lots of math
};

test.describe('page loads successfully', () => {
  for (const [name, path] of Object.entries(PAGES)) {
    test(`${name} (${path}) returns 200 and has content`, async ({ page }) => {
      const response = await page.goto(path);
      expect(response?.status(), `${path} should return 200`).toBe(200);

      const body = await page.locator('body').innerText();
      expect(body.length, `${path} body should not be empty`).toBeGreaterThan(100);
    });
  }
});

test.describe('no broken asset requests', () => {
  test('home page: zero 4xx/5xx on any asset', async ({ page }) => {
    const failures = [];
    page.on('response', (r) => {
      if (r.status() >= 400) failures.push(`${r.status()} ${r.url()}`);
    });
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    expect(failures, 'failed asset requests').toEqual([]);
  });

  test('a physics paper: CSS/JS/fonts all load', async ({ page }) => {
    const failures = [];
    page.on('response', (r) => {
      const u = r.url();
      const is_asset = /\.(css|js|woff2?|svg|png|jpg|webp|ico)(\?|$)/i.test(u);
      if (is_asset && r.status() >= 400) failures.push(`${r.status()} ${u}`);
    });
    await page.goto(PAGES.paperQM);
    await page.waitForLoadState('networkidle');
    expect(failures, 'failed asset requests').toEqual([]);
  });
});

test.describe('no console errors on key pages', () => {
  for (const [name, path] of Object.entries(PAGES).slice(0, 4)) {
    test(`${name} — no console errors`, async ({ page }) => {
      const errors = [];
      page.on('console', (msg) => {
        if (msg.type() === 'error') errors.push(msg.text());
      });
      page.on('pageerror', (err) => errors.push(err.message));
      await page.goto(path);
      await page.waitForLoadState('networkidle');
      expect(errors, `console errors on ${path}`).toEqual([]);
    });
  }
});

test.describe('CSS is actually applied', () => {
  test('home page has non-default body background', async ({ page }) => {
    await page.goto('/');
    const bg = await page.evaluate(() =>
      getComputedStyle(document.body).backgroundColor
    );
    // Astro + custom theme should not render as "rgba(0, 0, 0, 0)" (transparent = no CSS)
    expect(bg, 'body background should be set by CSS').not.toBe('rgba(0, 0, 0, 0)');
    expect(bg, 'body background should not be default white').not.toBe('rgb(255, 255, 255)');
  });

  test('home page has custom font (not Times New Roman default)', async ({ page }) => {
    await page.goto('/');
    const font = await page.evaluate(() =>
      getComputedStyle(document.body).fontFamily.toLowerCase()
    );
    // Anything non-default indicates our stylesheet loaded
    expect(font, 'body font should not be the browser default').not.toMatch(/^times/);
  });
});

test.describe('KaTeX math renders (physics paper)', () => {
  test('appendix F renders at least one MathML/KaTeX block', async ({ page }) => {
    await page.goto(PAGES.appendixF);
    await page.waitForLoadState('networkidle');
    // KaTeX injects either <span class="katex"> or MathML in rendered output.
    const katexCount = await page.locator('.katex').count();
    const mathmlCount = await page.locator('math').count();
    expect(katexCount + mathmlCount, 'no rendered math found — rehype-katex may be broken').toBeGreaterThan(0);
  });
});

test.describe('navigation works', () => {
  test('home page has at least one link to /papers/', async ({ page }) => {
    await page.goto('/');
    const count = await page.locator('a[href*="/papers/"]').count();
    expect(count, 'home should link to at least one paper').toBeGreaterThan(0);
  });

  test('clicking the first paper link lands on a 200 page', async ({ page }) => {
    await page.goto('/');
    const first = page.locator('a[href*="/papers/"]').first();
    const href = await first.getAttribute('href');
    const nav = page.waitForResponse((r) => r.url().includes(href));
    await first.click();
    const resp = await nav;
    expect(resp.status()).toBe(200);
  });
});

test.describe('responsive — mobile viewport does not break', () => {
  test('home on mobile: no horizontal overflow', async ({ page, viewport }) => {
    test.skip(viewport.width > 500, 'desktop-viewport project, skip');
    await page.goto('/');
    const overflow = await page.evaluate(() =>
      document.documentElement.scrollWidth > document.documentElement.clientWidth + 1
    );
    expect(overflow, 'mobile page has horizontal scroll — layout broken').toBe(false);
  });
});

test.describe('visual regression (baseline screenshots)', () => {
  test('home page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveScreenshot('home.png', { fullPage: true });
  });

  test('cycles page', async ({ page }) => {
    await page.goto('/cycles/');
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveScreenshot('cycles.png', { fullPage: false });
  });

  test('a paper page', async ({ page }) => {
    await page.goto(PAGES.appendixA);
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveScreenshot('paper-appendix-a.png', { fullPage: false });
  });
});
