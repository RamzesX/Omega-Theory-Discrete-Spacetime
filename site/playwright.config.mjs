// Playwright config for chaos-shield / omega-theory site.
// Runs headless Chromium across desktop + mobile viewports, serving the built
// static site via Astro preview on port 4321.
//
// Usage:
//   npm run test:e2e          # full run
//   npm run test:e2e -- -g "home"  # filter by test name
//
// Baseline screenshots live at tests/visual/__screenshots__/ — commit them.
// On visual regression, Playwright writes -diff.png next to baseline.
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  testMatch: '**/*.e2e.mjs',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  workers: process.env.CI ? 2 : undefined,
  reporter: process.env.CI ? [['github'], ['html', { open: 'never' }]] : 'list',

  use: {
    baseURL: 'http://localhost:4321/chaos-shield',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'chromium-desktop',
      use: { ...devices['Desktop Chrome'], viewport: { width: 1440, height: 900 } },
    },
    {
      name: 'chromium-mobile',
      use: { ...devices['Pixel 7'] },
    },
  ],

  webServer: {
    command: 'node node_modules/astro/astro.js preview',
    url: 'http://localhost:4321/chaos-shield',
    reuseExistingServer: !process.env.CI,
    timeout: 60 * 1000,
  },

  expect: {
    // Allow tiny pixel drift on visual snapshots (fonts hint differently across renderers).
    toHaveScreenshot: { maxDiffPixelRatio: 0.02 },
  },
});
