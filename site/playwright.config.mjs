// Playwright config for chaos-shield / omega-theory site.
//
// Three modes — pick via env var:
//
//   # A) LIVE (default, simplest — zero local setup)
//   # Tests run against the deployed GitHub Pages site
//   BASE_URL=https://ramzesx.github.io/chaos-shield npx playwright test
//
//   # B) LOCAL DIST (fast, no dev server — serves site/dist/ via Node)
//   npx playwright test
//   # Uses webServer below: `node scripts/static-server.mjs`
//
//   # C) LOCAL DEV (hot reload — for tests while iterating on Astro source)
//   BASE_URL=http://localhost:4321/chaos-shield USE_DEV=1 npx playwright test
//   # Start `npm run dev` in another terminal first
//
// Environment variables:
//   BASE_URL    — explicit base URL (mode A or C). Overrides the webServer launch.
//   USE_DEV=1   — skip webServer (assume dev server is running elsewhere).
//
// Updating visual snapshots: `npx playwright test --update-snapshots`
// (commit the PNG files under tests/appearance.e2e.mjs-snapshots/).
import { defineConfig, devices } from '@playwright/test';

const EXPLICIT_BASE = process.env.BASE_URL;
const BASE_URL = EXPLICIT_BASE || 'http://127.0.0.1:4321/chaos-shield';
const USE_DEV = process.env.USE_DEV === '1';
const LOCAL_WEBSERVER = !EXPLICIT_BASE && !USE_DEV;

export default defineConfig({
  testDir: './tests',
  testMatch: '**/*.e2e.mjs',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 2 : undefined,
  reporter: process.env.CI
    ? [['github'], ['html', { open: 'never' }]]
    : 'list',

  use: {
    baseURL: BASE_URL,
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    // Be patient with GitHub Pages latency in LIVE mode
    navigationTimeout: 20_000,
    actionTimeout: 10_000,
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

  // Only spin up a webServer in mode B (LOCAL DIST). Modes A / C use the
  // already-running URL (live deploy or dev server).
  webServer: LOCAL_WEBSERVER
    ? {
        command: 'node scripts/static-server.mjs',
        url: BASE_URL,
        reuseExistingServer: !process.env.CI,
        timeout: 30 * 1000,
        stdout: 'pipe',
        stderr: 'pipe',
      }
    : undefined,

  expect: {
    // Allow tiny pixel drift on visual snapshots (fonts hint differently
    // across CI runners, OS font renderers, and browser versions).
    toHaveScreenshot: { maxDiffPixelRatio: 0.02 },
  },
});
