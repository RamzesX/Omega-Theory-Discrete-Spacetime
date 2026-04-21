↑ [chaos-shield root](../../README.md) · [site](../)

# site/tests — Astro test suite

Three layers of tests, each catching a different regression class:

| Layer | File | Deps | Runtime | What it catches |
|---|---|---|---|---|
| 1 · Smoke (structural) | [`smoke.test.mjs`](smoke.test.mjs) | none (`node:test`) | ~1 s | Missing routes, missing `.nojekyll`, tiny pages, base-path leaks, concat-without-separator bugs |
| 1 · Build invariants | [`build.test.mjs`](build.test.mjs) | none (`node:test`) | ~1 s (120 s with `FULL_BUILD=1`) | Required routes present, `astro.config.mjs` base correct, `package.json` scripts sane, optionally full `astro build` end-to-end |
| 1 · Dist audit | [`../scripts/audit-dist.js`](../scripts/audit-dist.js) | none | ~2 s | 8 structural checks incl. forbidden `/Omega-Theory-Discrete-Spacetime` slug + `favicon` concat bug |
| 2 · Appearance (E2E) | [`appearance.e2e.mjs`](appearance.e2e.mjs) | `@playwright/test` | ~30 s | Pages render, no console errors, no broken assets, KaTeX math renders, CSS actually applied, responsive layout, visual regression snapshots |
| 2 · Accessibility | [`accessibility.e2e.mjs`](accessibility.e2e.mjs) | `@playwright/test` + `@axe-core/playwright` | ~15 s | WCAG serious/critical violations, `<img>` alt text, heading hierarchy, font size, discernible links, tab order |
| 2 · Link crawl | [`links.e2e.mjs`](links.e2e.mjs) | `@playwright/test` | ~60 s | Every internal link resolves 200, zero 4xx/5xx on any asset during crawl |

## Three ways to run the E2E tests

Pick the one that fits where you are in the dev loop.

### A · Against the live GitHub Pages site (zero local setup)

Fastest way — no build, no server, no browser download on the server side.

```bash
cd site
BASE_URL=https://ramzesx.github.io/chaos-shield npx playwright test
```

Useful when you just pushed to `main` and want to confirm the live deploy isn't broken. Runs in ~2 min (network-bound).

### B · Against the local `dist/` (default, CI-friendly)

```bash
cd site
npm run build              # emit dist/
npm run test:e2e           # webServer spawns scripts/static-server.mjs
```

The Playwright config auto-starts `scripts/static-server.mjs` (a ~40-line Node http server mimicking GitHub Pages' `/chaos-shield` base path). Tears it down when tests finish.

### C · Against an already-running dev server (hot reload, iterative)

```bash
cd site
npm run dev &             # in one terminal
BASE_URL=http://localhost:4321/chaos-shield USE_DEV=1 npx playwright test
```

Playwright skips the webServer entirely — assumes the URL is already serving. Use when you're editing `src/` and re-running specific tests.

## First-time setup

```bash
cd site
npm install                                # installs @playwright/test + @axe-core/playwright
npx playwright install chromium --with-deps
```

`--with-deps` pulls the Linux system libs (libnss3, libatk, etc). On macOS / WSL it's a no-op. Chromium download is ~140 MB.

## Fast tests — no Playwright needed

```bash
npm test                     # smoke + build + audit, ~4 s
npm run test:build:full      # also runs `astro build` end-to-end, ~30 s
```

`npm test` is the gate every PR should pass. Runs in seconds, catches the most common regressions (the 29-leak class, missing routes, concat bugs).

## Visual regression snapshots

Baseline screenshots land at `tests/appearance.e2e.mjs-snapshots/`. Commit them.

```bash
# First time or intentional UI change:
npm run test:e2e:update-snapshots

# Subsequent CI runs:
npm run test:e2e             # will fail if rendering drifts >2% pixel ratio
```

The 2 % tolerance (`maxDiffPixelRatio: 0.02` in `playwright.config.mjs`) absorbs cross-OS font-hinting differences without letting real regressions slip through. Per [Playwright 2026 best practices](https://bug0.com/knowledge-base/playwright-visual-regression-testing), snapshots disable animations automatically.

## Local CI parity — run the full GitHub Actions workflow

[`act`](https://github.com/nektos/act) runs the whole `.github/workflows/astro.yml` in a Docker container mimicking GitHub's ubuntu-latest runner.

```bash
# install once:
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# run (needs gh auth for the Pages step):
cd ..   # repo root
act -W .github/workflows/astro.yml -j build -s GITHUB_TOKEN="$(gh auth token)"
```

Alternative: `npm run ci:local` from `site/` does the same.

## Which test catches what?

Trouble shooting matrix — when something breaks, which test would have caught it:

| Regression | Caught by |
|---|---|
| 29 leaked `/Omega-Theory-Discrete-Spacetime` hrefs | `smoke.test.mjs` (Check 7) + `audit-dist.js` Check 8 |
| `/chaos-shieldfavicon.svg` concat bug | `smoke.test.mjs` (Check 8) |
| A paper's markdown gets dropped by `copy-content.js` | `build.test.mjs` (REQUIRED_ROUTES check) |
| `astro.config.mjs` base silently changed to wrong value | `build.test.mjs` (base check) + `smoke.test.mjs` (asset-URL check) |
| KaTeX stops rendering math | `appearance.e2e.mjs` (KaTeX test) |
| Stylesheet 404 in production | `appearance.e2e.mjs` (asset-requests test) + `links.e2e.mjs` (crawl) |
| Mobile viewport breaks horizontal scroll | `appearance.e2e.mjs` (responsive test) |
| Design change breaks the home page look | Visual snapshot in `appearance.e2e.mjs` |
| `<img>` loses its `alt` in a content edit | `accessibility.e2e.mjs` (alt-text test) |
| Link in a paper points to a page that no longer exists | `links.e2e.mjs` (crawl) |
| WCAG contrast violation introduced | `accessibility.e2e.mjs` (axe-core audit) |
| Dead intra-repo .md link (docs outside `dist/`) | `make check-links` at repo root (different tool, different scope) |

## References

- [Astro — Testing](https://docs.astro.build/en/guides/testing/) — official Astro testing guide (mentions Playwright as the recommended E2E framework)
- [Playwright — Best Practices](https://playwright.dev/docs/best-practices) — official
- [Bug0 — Playwright Visual Regression 2026](https://bug0.com/knowledge-base/playwright-visual-regression-testing) — current best practices (disable animations, wait for fonts, mask dynamic regions)
- [BrowserStack — Playwright Snapshot Testing 2026](https://www.browserstack.com/guide/playwright-snapshot-testing)
- [axe-core](https://github.com/dequelabs/axe-core) — accessibility rules engine used by `@axe-core/playwright`
- [nektos/act](https://github.com/nektos/act) — local GitHub Actions runner

---

*Return to: [site/](..) · [chaos-shield root](../../README.md)*
