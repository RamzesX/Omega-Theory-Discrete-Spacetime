/**
 * Theme + sidebar contrast regression tests.
 *
 * Catches the bugs that showed up in live visual audit 2026-04-21:
 *
 *   1. Site loaded with `data-theme="light"` on headless Chromium (because
 *      the theme script read `prefers-color-scheme: light` as the system
 *      default). The light-theme sidebar override was scoped and didn't
 *      apply; nav text rendered `rgb(10, 14, 26)` (dark) on the dark
 *      `rgba(10,14,26,0.98)` sidebar bg — ~1:1 contrast, invisible.
 *   2. Paper pages had `document.documentElement.scrollWidth >
 *      clientWidth` on 1440-wide desktop — horizontal overflow.
 *
 * These tests are the regression guards so we never ship that again.
 */

import { test, expect } from '@playwright/test';

/** sRGB → relative luminance (WCAG 2.1). Input: "rgb(R, G, B)" or "rgba(...)". */
function luminance(rgbStr) {
  const m = rgbStr.match(/\d+(\.\d+)?/g);
  if (!m || m.length < 3) return null;
  const [r, g, b] = m.slice(0, 3).map((v) => {
    const x = Number(v) / 255;
    return x <= 0.03928 ? x / 12.92 : Math.pow((x + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/** WCAG contrast ratio (1..21). */
function contrastRatio(a, b) {
  const la = luminance(a);
  const lb = luminance(b);
  if (la === null || lb === null) return null;
  const [lo, hi] = la < lb ? [la, lb] : [lb, la];
  return (hi + 0.05) / (lo + 0.05);
}

/** Composite a semi-transparent color over a known opaque bg. */
function composite(top, bottom) {
  const mt = top.match(/\d+(\.\d+)?/g);
  const mb = bottom.match(/\d+(\.\d+)?/g);
  if (!mt || !mb) return top;
  const [tr, tg, tb, ta = 1] = mt.map(Number);
  const [br, bg, bb] = mb.map(Number);
  const a = ta;
  const r = Math.round(tr * a + br * (1 - a));
  const g = Math.round(tg * a + bg * (1 - a));
  const b = Math.round(tb * a + bb * (1 - a));
  return `rgb(${r}, ${g}, ${b})`;
}

/** Canonical page-bg for contrast calc (dark theme cobalt void). */
const PAGE_BG = 'rgb(7, 9, 15)'; // --color-void

test.describe('theme default: dark on headless / fresh visits', () => {
  test('home: data-theme is "dark" on first visit (no localStorage)', async ({ page, context }) => {
    // Fresh context — no stored theme preference
    await context.clearCookies();
    await page.addInitScript(() => {
      // Force system pref to LIGHT to catch the auto-detection bug
      Object.defineProperty(window, 'matchMedia', {
        writable: true,
        value: (query) => ({
          matches: query.includes('prefers-color-scheme: light'),
          media: query,
          addEventListener: () => {},
          removeEventListener: () => {},
        }),
      });
    });
    await page.goto('/');
    const theme = await page.evaluate(() =>
      document.documentElement.getAttribute('data-theme')
    );
    expect(theme, 'theme should default to "dark" even when system prefers light').toBe('dark');
  });
});

test.describe('sidebar contrast (WCAG AA = 4.5:1 min for normal text)', () => {
  const PAGES = ['/', '/cycles/', '/lean/', '/papers/paper-qm-from-discrete-gravity/'];

  for (const path of PAGES) {
    test(`${path} — .nav-link text contrast ≥ 4.5:1`, async ({ page }) => {
      await page.goto(path);
      const m = await page.evaluate(() => {
        const link = document.querySelector('.nav-link:not(.active)');
        const sidebar = document.querySelector('.sidebar');
        if (!link || !sidebar) return null;
        return {
          fg: getComputedStyle(link).color,
          bg: getComputedStyle(sidebar).backgroundColor,
        };
      });
      expect(m, 'page must have .nav-link and .sidebar elements').not.toBeNull();
      const bg = m.bg.includes('rgba') ? composite(m.bg, PAGE_BG) : m.bg;
      const ratio = contrastRatio(m.fg, bg);
      expect(
        ratio,
        `nav-link color=${m.fg} on composited bg=${bg}: contrast=${ratio?.toFixed(2)}`
      ).toBeGreaterThanOrEqual(4.5);
    });

    test(`${path} — .nav-section-title text contrast ≥ 4.5:1`, async ({ page }) => {
      await page.goto(path);
      const m = await page.evaluate(() => {
        const t = document.querySelector('.nav-section-title');
        const sidebar = document.querySelector('.sidebar');
        if (!t || !sidebar) return null;
        return {
          fg: getComputedStyle(t).color,
          bg: getComputedStyle(sidebar).backgroundColor,
        };
      });
      expect(m, 'page must have .nav-section-title and .sidebar').not.toBeNull();
      const bg = m.bg.includes('rgba') ? composite(m.bg, PAGE_BG) : m.bg;
      const ratio = contrastRatio(m.fg, bg);
      expect(
        ratio,
        `nav-section-title color=${m.fg} on bg=${bg}: contrast=${ratio?.toFixed(2)}`
      ).toBeGreaterThanOrEqual(4.5);
    });
  }
});

test.describe('body text contrast on paper pages (AA, normal text)', () => {
  test('appendix-F paragraph contrast ≥ 4.5:1', async ({ page }) => {
    await page.goto('/papers/appendix-f-information-flow-conservation/');
    const m = await page.evaluate(() => {
      const p = document.querySelector('main p');
      if (!p) return null;
      const html = document.documentElement;
      return {
        fg: getComputedStyle(p).color,
        bg: getComputedStyle(html).backgroundColor,
      };
    });
    expect(m).not.toBeNull();
    const ratio = contrastRatio(m.fg, m.bg);
    expect(ratio, `paragraph fg=${m.fg} vs bg=${m.bg}: ratio=${ratio?.toFixed(2)}`).toBeGreaterThanOrEqual(4.5);
  });
});

test.describe('no horizontal overflow on desktop viewport', () => {
  const PAGES = [
    '/',
    '/cycles/',
    '/lean/',
    '/papers/paper-qm-from-discrete-gravity/',
    '/papers/paper-dark-energy-preview-v1/',
    '/papers/appendix-f-information-flow-conservation/',
    '/papers/main-paper-postulates/',
  ];
  for (const path of PAGES) {
    test(`${path} — no horizontal scroll at 1440×900`, async ({ page }) => {
      test.skip(
        test.info().project.name === 'chromium-mobile',
        'mobile-overflow is a separate test'
      );
      await page.setViewportSize({ width: 1440, height: 900 });
      await page.goto(path);
      await page.waitForLoadState('networkidle');
      const overflow = await page.evaluate(() => ({
        sw: document.documentElement.scrollWidth,
        cw: document.documentElement.clientWidth,
      }));
      expect(
        overflow.sw,
        `${path}: scrollWidth=${overflow.sw} exceeds clientWidth=${overflow.cw} — content overflows viewport`
      ).toBeLessThanOrEqual(overflow.cw + 1);
    });
  }
});

test.describe('light theme (forced via toggle) remains readable', () => {
  test('after setting localStorage theme=light: nav contrast still ≥ 4.5:1', async ({ page }) => {
    // Inject theme=light BEFORE page script runs
    await page.addInitScript(() => {
      localStorage.setItem('theme', 'light');
    });
    await page.goto('/');
    const m = await page.evaluate(() => {
      const theme = document.documentElement.getAttribute('data-theme');
      const link = document.querySelector('.nav-link:not(.active)');
      const sidebar = document.querySelector('.sidebar');
      if (!link || !sidebar) return { theme };
      return {
        theme,
        fg: getComputedStyle(link).color,
        bg: getComputedStyle(sidebar).backgroundColor,
      };
    });
    expect(m.theme, 'localStorage override should take effect').toBe('light');
    if (m.fg && m.bg) {
      const bg = m.bg.includes('rgba') ? composite(m.bg, 'rgb(250, 251, 253)') : m.bg;
      const ratio = contrastRatio(m.fg, bg);
      expect(
        ratio,
        `light theme nav fg=${m.fg} bg=${bg}: contrast=${ratio?.toFixed(2)}`
      ).toBeGreaterThanOrEqual(4.5);
    }
  });
});
