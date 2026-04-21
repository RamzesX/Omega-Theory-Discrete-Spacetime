# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: appearance.e2e.mjs >> page loads successfully >> convqmath (/convqmath/) returns 200 and has content
- Location: tests/appearance.e2e.mjs:32:5

# Error details

```
TimeoutError: page.goto: Timeout 20000ms exceeded.
Call log:
  - navigating to "http://127.0.0.1:4321/convqmath/", waiting until "load"

```

# Page snapshot

```yaml
- generic [active] [ref=e1]:
  - link "Skip to main content" [ref=e2] [cursor=pointer]:
    - /url: "#main"
  - generic [ref=e3]:
    - complementary "Primary" [ref=e4]:
      - generic [ref=e5]:
        - link "Omega-Theory home" [ref=e6] [cursor=pointer]:
          - /url: /Omega-Theory-Discrete-Spacetime/
          - generic [ref=e7]: Ω
          - generic [ref=e8]:
            - generic [ref=e9]: Omega-Theory
            - generic [ref=e10]: discrete spacetime · Lean 4
        - button "Toggle theme" [ref=e11] [cursor=pointer]:
          - img [ref=e12]
      - navigation "Site sections" [ref=e14]:
        - generic [ref=e15]:
          - button "Getting Started" [expanded] [ref=e16] [cursor=pointer]:
            - generic [ref=e17]: Getting Started
            - img [ref=e18]
          - list [ref=e20]:
            - listitem [ref=e21]:
              - link "Overview" [ref=e22] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/
            - listitem [ref=e23]:
              - link "Main Paper" [ref=e24] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/papers/main-paper-postulates/
            - listitem [ref=e25]:
              - link "Visual Summary" [ref=e26] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/papers/unified-theory-diagram/
        - generic [ref=e27]:
          - button "Predictions" [expanded] [ref=e28] [cursor=pointer]:
            - generic [ref=e29]: Predictions
            - img [ref=e30]
          - list [ref=e32]:
            - listitem [ref=e33]:
              - link "14 Cycles · 84 Predictions" [ref=e34] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/cycles/
            - listitem [ref=e35]:
              - link "Lean Formalization" [ref=e36] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/lean/
            - listitem [ref=e37]:
              - 'link "Appendix I: Experimental Tests" [ref=e38] [cursor=pointer]':
                - /url: /Omega-Theory-Discrete-Spacetime/papers/appendix-i-experimental-tests/
            - listitem [ref=e39]:
              - 'link "Appendix J: Experimental Catalog" [ref=e40] [cursor=pointer]':
                - /url: /Omega-Theory-Discrete-Spacetime/papers/appendix-j-experimental-catalog-consolidated/
            - listitem [ref=e41]:
              - 'link "Appendix K: Irrationality Genesis" [ref=e42] [cursor=pointer]':
                - /url: /Omega-Theory-Discrete-Spacetime/papers/appendix-k-irrationality-genesis-of-predictions/
            - listitem [ref=e43]:
              - link "Cold-Neutron Letter (PRL)" [ref=e44] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/papers/letter-coldneutron-executivesummary/
        - generic [ref=e45]:
          - button "Core Theory" [expanded] [ref=e46] [cursor=pointer]:
            - generic [ref=e47]: Core Theory
            - img [ref=e48]
          - list [ref=e50]:
            - listitem [ref=e51]:
              - link "Complete Framework" [ref=e52] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/papers/complete-omega-theory-unified-framework/
            - listitem [ref=e53]:
              - 'link "Key Insight: Irrationals" [ref=e54] [cursor=pointer]':
                - /url: /Omega-Theory-Discrete-Spacetime/papers/keyinsight-irrationals-action-thresholds/
            - listitem [ref=e55]:
              - link "Dark Energy Preview Paper" [ref=e56] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/papers/paper-dark-energy-preview-v1/
            - listitem [ref=e57]:
              - link "Erdős Lagrangian" [ref=e58] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/papers/erdoslagrangianunification/
        - button "Appendices" [ref=e60] [cursor=pointer]:
          - generic [ref=e61]: Appendices
          - img [ref=e62]
        - generic [ref=e64]:
          - button "Notes" [expanded] [ref=e65] [cursor=pointer]:
            - generic [ref=e66]: Notes
            - img [ref=e67]
          - list [ref=e69]:
            - listitem [ref=e70]:
              - link "Continued-Fraction Channels" [ref=e71] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/papers/note-continued-fraction-information-channels/
            - listitem [ref=e72]:
              - link "Structure-Preserving Lattice Curvature" [ref=e73] [cursor=pointer]:
                - /url: /Omega-Theory-Discrete-Spacetime/papers/note-structure-preserving-lattice-curvature/
      - generic [ref=e74]:
        - link "github.com/RamzesX/chaos-shield" [ref=e75] [cursor=pointer]:
          - /url: https://github.com/RamzesX/chaos-shield
          - img [ref=e76]
          - generic [ref=e78]: github.com/RamzesX/chaos-shield
        - paragraph [ref=e79]: © 2024–2026 Norbert Marchewka · CC-BY 4.0
    - main [ref=e80]:
      - generic [ref=e81]:
        - heading "Constructive Quantum Mathematics" [level=1] [ref=e82]
        - paragraph [ref=e83]: 16 essays exploring constructive mathematics—where existence means computability, and proofs become algorithms. These essays form the mathematical foundation for the computable aspects of Omega-Theory.
      - generic [ref=e84]:
        - heading "Why Constructive?" [level=2] [ref=e85]
        - paragraph [ref=e86]:
          - text: In classical mathematics, you can prove something exists without ever showing how to find it. In
          - strong [ref=e87]: constructive mathematics
          - text: ", every existence proof contains an algorithm."
        - paragraph [ref=e88]:
          - text: "For physics, this matters: if spacetime is discrete, physical quantities must be"
          - emphasis [ref=e89]: computable
          - text: . Classical real numbers include non-computable quantities—but discrete spacetime physics needs only constructive reals.
      - generic [ref=e90]:
        - heading "The Essays" [level=2] [ref=e91]
        - generic [ref=e92]:
          - generic [ref=e93]:
            - generic [ref=e94]: "00"
            - generic [ref=e95]:
              - heading "The Genesis Problem" [level=3] [ref=e96]
              - paragraph [ref=e97]: Why constructive mathematics matters
          - generic [ref=e98]:
            - generic [ref=e99]: "01"
            - generic [ref=e100]:
              - heading "Numbers That Build Themselves" [level=3] [ref=e101]
              - paragraph [ref=e102]: Constructive real numbers
          - generic [ref=e103]:
            - generic [ref=e104]: "02"
            - generic [ref=e105]:
              - heading "The Dance of Decimals" [level=3] [ref=e106]
              - paragraph [ref=e107]: Infinite series and convergence
          - generic [ref=e108]:
            - generic [ref=e109]: "03"
            - generic [ref=e110]:
              - heading "Measuring the Unmeasurable" [level=3] [ref=e111]
              - paragraph [ref=e112]: Constructive measure theory
          - generic [ref=e113]:
            - generic [ref=e114]: "04"
            - generic [ref=e115]:
              - heading "Functions That Compute" [level=3] [ref=e116]
              - paragraph [ref=e117]: Computable analysis
          - generic [ref=e118]:
            - generic [ref=e119]: "05"
            - generic [ref=e120]:
              - heading "Spaces of Possibility" [level=3] [ref=e121]
              - paragraph [ref=e122]: Constructive topology
          - generic [ref=e123]:
            - generic [ref=e124]: "06"
            - generic [ref=e125]:
              - heading "The Algebra of Certainty" [level=3] [ref=e126]
              - paragraph [ref=e127]: Constructive algebra
          - generic [ref=e128]:
            - generic [ref=e129]: "07"
            - generic [ref=e130]:
              - heading "Probability Without Paradox" [level=3] [ref=e131]
              - paragraph [ref=e132]: Constructive probability
          - generic [ref=e133]:
            - generic [ref=e134]: "08"
            - generic [ref=e135]:
              - heading "Integration Revisited" [level=3] [ref=e136]
              - paragraph [ref=e137]: Constructive integration
          - generic [ref=e138]:
            - generic [ref=e139]: "09"
            - generic [ref=e140]:
              - heading "The Fourier Revolution" [level=3] [ref=e141]
              - paragraph [ref=e142]: Constructive harmonic analysis
          - generic [ref=e143]:
            - generic [ref=e144]: "10"
            - generic [ref=e145]:
              - heading "Differential Equations Done Right" [level=3] [ref=e146]
              - paragraph [ref=e147]: Constructive ODEs
          - generic [ref=e148]:
            - generic [ref=e149]: "11"
            - generic [ref=e150]:
              - heading "Complex Numbers Constructed" [level=3] [ref=e151]
              - paragraph [ref=e152]: Constructive complex analysis
          - generic [ref=e153]:
            - generic [ref=e154]: "12"
            - generic [ref=e155]:
              - heading "Topology for Physicists" [level=3] [ref=e156]
              - paragraph [ref=e157]: Applied constructive topology
          - generic [ref=e158]:
            - generic [ref=e159]: "13"
            - generic [ref=e160]:
              - heading "The Logic Underneath" [level=3] [ref=e161]
              - paragraph [ref=e162]: Foundations of constructive math
          - generic [ref=e163]:
            - generic [ref=e164]: "14"
            - generic [ref=e165]:
              - heading "Arbitrary Precision Operator" [level=3] [ref=e166]
              - paragraph [ref=e167]: Computing irrationals exactly
          - generic [ref=e168]:
            - generic [ref=e169]: "15"
            - generic [ref=e170]:
              - heading "Computational Debt" [level=3] [ref=e171]
              - paragraph [ref=e172]: Why deferred computation matters
      - generic [ref=e173]:
        - 'heading "Key Insight: The Arbitrary Precision Operator" [level=2] [ref=e174]'
        - generic [ref=e175]:
          - paragraph [ref=e176]:
            - text: Essay 14 introduces the
            - strong [ref=e177]: APO (Arbitrary Precision Operator)
            - text: "—a way to represent irrational numbers constructively:"
          - code [ref=e179]: APO(f, ε) → q ∈ ℚ such that |f - q| < ε
          - paragraph [ref=e180]: This connects directly to Omega-Theory's treatment of irrational action thresholds. In discrete spacetime, we don't need "actual" irrationals—only finite approximations to any required precision.
          - link "→ See how this applies in physics" [ref=e181] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/papers/keyinsight-irrationals-action-thresholds
      - generic [ref=e182]:
        - paragraph [ref=e183]: The full essays are available in the repository's ConvQMath directory.
        - link "View ConvQMath on GitHub" [ref=e184] [cursor=pointer]:
          - /url: https://github.com/RamzesX/Omega-Theory-Discrete-Spacetime/tree/main/ConvQMath
```

# Test source

```ts
  1   | /**
  2   |  * Appearance + behavior tests for the Astro site.
  3   |  *
  4   |  * What this checks (that smoke tests can't):
  5   |  *   - Pages actually render with CSS applied (computed styles, not just class names)
  6   |  *   - KaTeX math renders to MathML/HTML (critical for a physics site)
  7   |  *   - No broken asset requests (404s on CSS/JS/fonts)
  8   |  *   - No console errors / unhandled exceptions
  9   |  *   - Navigation works — links on the landing page resolve
  10  |  *   - Responsive layout: mobile viewport doesn't break structure
  11  |  *   - Visual regression snapshots for the key pages (home, a paper, cycles)
  12  |  *
  13  |  * Run: `npm run test:e2e`
  14  |  * Requires: `npm install` (Playwright devDep) + `npx playwright install chromium`
  15  |  */
  16  | 
  17  | import { test, expect } from '@playwright/test';
  18  | 
  19  | const PAGES = {
  20  |   home: '/',
  21  |   convqmath: '/convqmath/',
  22  |   cycles: '/cycles/',
  23  |   lean: '/lean/',
  24  |   paperQM: '/papers/paper-qm-from-discrete-gravity/',
  25  |   paperDE: '/papers/paper-dark-energy-preview-v1/',
  26  |   appendixA: '/papers/appendix-a-action-density-and-quantum-errors/',
  27  |   appendixF: '/papers/appendix-f-information-flow-conservation/',  // has lots of math
  28  | };
  29  | 
  30  | test.describe('page loads successfully', () => {
  31  |   for (const [name, path] of Object.entries(PAGES)) {
  32  |     test(`${name} (${path}) returns 200 and has content`, async ({ page }) => {
> 33  |       const response = await page.goto(path);
      |                                   ^ TimeoutError: page.goto: Timeout 20000ms exceeded.
  34  |       expect(response?.status(), `${path} should return 200`).toBe(200);
  35  | 
  36  |       const body = await page.locator('body').innerText();
  37  |       expect(body.length, `${path} body should not be empty`).toBeGreaterThan(100);
  38  |     });
  39  |   }
  40  | });
  41  | 
  42  | test.describe('no broken asset requests', () => {
  43  |   test('home page: zero 4xx/5xx on any asset', async ({ page }) => {
  44  |     const failures = [];
  45  |     page.on('response', (r) => {
  46  |       if (r.status() >= 400) failures.push(`${r.status()} ${r.url()}`);
  47  |     });
  48  |     await page.goto('/');
  49  |     await page.waitForLoadState('networkidle');
  50  |     expect(failures, 'failed asset requests').toEqual([]);
  51  |   });
  52  | 
  53  |   test('a physics paper: CSS/JS/fonts all load', async ({ page }) => {
  54  |     const failures = [];
  55  |     page.on('response', (r) => {
  56  |       const u = r.url();
  57  |       const is_asset = /\.(css|js|woff2?|svg|png|jpg|webp|ico)(\?|$)/i.test(u);
  58  |       if (is_asset && r.status() >= 400) failures.push(`${r.status()} ${u}`);
  59  |     });
  60  |     await page.goto(PAGES.paperQM);
  61  |     await page.waitForLoadState('networkidle');
  62  |     expect(failures, 'failed asset requests').toEqual([]);
  63  |   });
  64  | });
  65  | 
  66  | test.describe('no console errors on key pages', () => {
  67  |   for (const [name, path] of Object.entries(PAGES).slice(0, 4)) {
  68  |     test(`${name} — no console errors`, async ({ page }) => {
  69  |       const errors = [];
  70  |       page.on('console', (msg) => {
  71  |         if (msg.type() === 'error') errors.push(msg.text());
  72  |       });
  73  |       page.on('pageerror', (err) => errors.push(err.message));
  74  |       await page.goto(path);
  75  |       await page.waitForLoadState('networkidle');
  76  |       expect(errors, `console errors on ${path}`).toEqual([]);
  77  |     });
  78  |   }
  79  | });
  80  | 
  81  | test.describe('CSS is actually applied', () => {
  82  |   test('home page has non-default body background', async ({ page }) => {
  83  |     await page.goto('/');
  84  |     const bg = await page.evaluate(() =>
  85  |       getComputedStyle(document.body).backgroundColor
  86  |     );
  87  |     // Astro + custom theme should not render as "rgba(0, 0, 0, 0)" (transparent = no CSS)
  88  |     expect(bg, 'body background should be set by CSS').not.toBe('rgba(0, 0, 0, 0)');
  89  |     expect(bg, 'body background should not be default white').not.toBe('rgb(255, 255, 255)');
  90  |   });
  91  | 
  92  |   test('home page has custom font (not Times New Roman default)', async ({ page }) => {
  93  |     await page.goto('/');
  94  |     const font = await page.evaluate(() =>
  95  |       getComputedStyle(document.body).fontFamily.toLowerCase()
  96  |     );
  97  |     // Anything non-default indicates our stylesheet loaded
  98  |     expect(font, 'body font should not be the browser default').not.toMatch(/^times/);
  99  |   });
  100 | });
  101 | 
  102 | test.describe('KaTeX math renders (physics paper)', () => {
  103 |   test('appendix F renders at least one MathML/KaTeX block', async ({ page }) => {
  104 |     await page.goto(PAGES.appendixF);
  105 |     await page.waitForLoadState('networkidle');
  106 |     // KaTeX injects either <span class="katex"> or MathML in rendered output.
  107 |     const katexCount = await page.locator('.katex').count();
  108 |     const mathmlCount = await page.locator('math').count();
  109 |     expect(katexCount + mathmlCount, 'no rendered math found — rehype-katex may be broken').toBeGreaterThan(0);
  110 |   });
  111 | });
  112 | 
  113 | test.describe('navigation works', () => {
  114 |   test('home page has at least one link to /papers/', async ({ page }) => {
  115 |     await page.goto('/');
  116 |     const count = await page.locator('a[href*="/papers/"]').count();
  117 |     expect(count, 'home should link to at least one paper').toBeGreaterThan(0);
  118 |   });
  119 | 
  120 |   test('clicking the first paper link lands on a 200 page', async ({ page }) => {
  121 |     await page.goto('/');
  122 |     const first = page.locator('a[href*="/papers/"]').first();
  123 |     const href = await first.getAttribute('href');
  124 |     const nav = page.waitForResponse((r) => r.url().includes(href));
  125 |     await first.click();
  126 |     const resp = await nav;
  127 |     expect(resp.status()).toBe(200);
  128 |   });
  129 | });
  130 | 
  131 | test.describe('responsive — mobile viewport does not break', () => {
  132 |   test('home on mobile: no horizontal overflow', async ({ page, viewport }) => {
  133 |     test.skip(viewport.width > 500, 'desktop-viewport project, skip');
```