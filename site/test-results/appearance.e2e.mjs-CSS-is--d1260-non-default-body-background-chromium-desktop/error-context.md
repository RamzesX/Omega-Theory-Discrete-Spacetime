# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: appearance.e2e.mjs >> CSS is actually applied >> home page has non-default body background
- Location: tests/appearance.e2e.mjs:82:3

# Error details

```
Error: body background should be set by CSS

expect(received).not.toBe(expected) // Object.is equality

Expected: not "rgba(0, 0, 0, 0)"
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
        - generic [ref=e82]:
          - generic [ref=e85]: Lean 4 verified · 0 sorry · 8 physical axioms
          - heading "mega-Theory" [level=1] [ref=e86]:
            - generic [ref=e87]: Ω
            - generic [ref=e88]: mega-Theory
          - paragraph [ref=e89]: Mass as geometric reshaping of a discrete ℤ⁴ Planck lattice.
          - paragraph [ref=e90]:
            - text: From a single postulate and three irrational constants (π,
            - emphasis [ref=e92]: e
            - text: ", √2) we derive the Standard Model mass hierarchy, CKM/PMNS mixing, Higgs sector, gravitational dynamics, and cosmological parameters."
            - strong [ref=e93]: Every claim is machine-verified.
          - generic [ref=e94]:
            - link "See 14 cycles · 84 predictions" [ref=e95] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/cycles/
              - generic [ref=e96]: See 14 cycles · 84 predictions
              - img [ref=e97]
            - link "Read the paper" [ref=e99] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/papers/main-paper-postulates/
        - figure [ref=e100]:
          - img [ref=e101]:
            - generic [ref=e190]:
              - generic [ref=e191]: π
              - generic [ref=e192]: e
              - generic [ref=e193]: √2
            - generic [ref=e194]:
              - generic [ref=e195]: gen 3 · heavy
              - generic [ref=e196]: gen 2 · middle
              - generic [ref=e197]: gen 1 · light
          - generic [ref=e198]:
            - generic [ref=e199]: Three irrationals → three generations.
            - generic [ref=e200]:
              - text: δ
              - subscript [ref=e201]: comp
              - text: (N) = ℓ
              - subscript [ref=e202]: P
              - text: · 4/(2N+3) · 3/(N+1)! · 2
              - superscript [ref=e203]: −2ᴺ
      - generic [ref=e204]:
        - generic [ref=e205]:
          - generic [ref=e206]: 3 819
          - generic [ref=e207]: build jobs
        - generic [ref=e208]:
          - generic [ref=e209]: "0"
          - generic [ref=e210]: sorry
        - generic [ref=e211]:
          - generic [ref=e212]: "8"
          - generic [ref=e213]: physical axioms
        - generic [ref=e214]:
          - generic [ref=e215]: 2 612
          - generic [ref=e216]: theorems
        - generic [ref=e217]:
          - generic [ref=e218]: "211"
          - generic [ref=e219]: Lean files
        - generic [ref=e220]:
          - generic [ref=e221]: v4.29
          - generic [ref=e222]: Lean / Mathlib
      - generic [ref=e224]:
        - generic [ref=e225]:
          - generic [ref=e226]: Signature theorem
          - heading "omega_theory_grand_capstone" [level=2] [ref=e227]:
            - code [ref=e228]: omega_theory_grand_capstone
          - paragraph [ref=e229]:
            - text: A single Lean statement bundling
            - strong [ref=e230]: 84 PDG-consistent predictions
            - text: across
            - strong [ref=e231]: 14 shipping cycles
            - text: ": Standard Model masses + CKM/PMNS mixing + Higgs sector + cosmological parameters — all derivable from 3 irrationals (π,"
            - emphasis [ref=e232]: e
            - text: ", √2) and healing-flow dynamics on the discrete ℤ⁴ lattice."
          - list [ref=e233]:
            - listitem [ref=e234]: 14 cycles shipped · cycles 9–23
            - listitem [ref=e235]: 84 headline substrate fits
            - listitem [ref=e236]: 3 819 build jobs GREEN · 0 sorry
            - listitem [ref=e237]: 8 physical axioms · 0 mathematical
          - generic [ref=e238]:
            - link "Open cycle catalogue" [ref=e239] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/cycles/
            - link "View Lean source" [ref=e240] [cursor=pointer]:
              - /url: https://github.com/RamzesX/chaos-shield/tree/main/PhysicsPapers/LeanFormalizationV2/OmegaTheory/Predictions
        - generic [ref=e242]:
          - generic [ref=e243]:
            - generic [ref=e244]: π
            - generic [ref=e245]:
              - strong [ref=e246]: heavy · gen 3
              - generic [ref=e247]: m_t · m_b · m_W · m_Z · λ_H
          - generic [ref=e248]:
            - generic [ref=e249]: e
            - generic [ref=e250]:
              - strong [ref=e251]: middle · gen 2
              - generic [ref=e252]: m_c · m_s · m_K · f_π · |V_cb|
          - generic [ref=e253]:
            - generic [ref=e254]: √2
            - generic [ref=e255]:
              - strong [ref=e256]: light · gen 1 + cosmo
              - generic [ref=e257]: m_u · m_d · m_ν · Λ · θ_QCD
          - generic [ref=e258]:
            - generic [ref=e259]: π·e
            - generic [ref=e260]:
              - strong [ref=e261]: composed
              - generic [ref=e262]: Jarlskog · λ_H · α_EM(m_Z)
          - generic [ref=e263]:
            - generic [ref=e264]: id
            - generic [ref=e265]:
              - strong [ref=e266]: identity
              - generic [ref=e267]: m_H² = 2λv² · unitarity triangle
      - generic [ref=e268]:
        - generic [ref=e269]:
          - generic [ref=e270]: § 01 · What makes this different
          - heading "One postulate → everything" [level=2] [ref=e271]
          - paragraph [ref=e272]: Unlike other quantum-gravity proposals, OmegaTheory starts from one postulate and derives the rest — mechanically checked.
        - generic [ref=e273]:
          - 'link "Single postulate From ''spacetime = discrete ℤ⁴ at Planck scale'' derive: cosmological constant, dark energy, black-hole entropy, SM masses, CKM/PMNS." [ref=e274] [cursor=pointer]':
            - /url: /Omega-Theory-Discrete-Spacetime/papers/main-paper-postulates/
            - generic [ref=e275]: ◇
            - generic [ref=e276]:
              - heading "Single postulate" [level=3] [ref=e277]
              - paragraph [ref=e278]: "From 'spacetime = discrete ℤ⁴ at Planck scale' derive: cosmological constant, dark energy, black-hole entropy, SM masses, CKM/PMNS."
            - img [ref=e280]
          - link "84 predictions Not philosophy — 14 cycles of substrate fits anchored to PDG central values. One already verified (gate fidelity scaling, Diraq 2024)." [ref=e282] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/cycles/
            - generic [ref=e283]: ◈
            - generic [ref=e284]:
              - heading "84 predictions" [level=3] [ref=e285]
              - paragraph [ref=e286]: Not philosophy — 14 cycles of substrate fits anchored to PDG central values. One already verified (gate fidelity scaling, Diraq 2024).
            - img [ref=e288]
          - link "Machine-verified Every claim is a Lean theorem. 3,819 build jobs, 0 sorry, 8 physical axioms. Run lake build and verify yourself." [ref=e290] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/lean/
            - generic [ref=e291]: ✓
            - generic [ref=e292]:
              - heading "Machine-verified" [level=3] [ref=e293]
              - paragraph [ref=e294]: Every claim is a Lean theorem. 3,819 build jobs, 0 sorry, 8 physical axioms. Run lake build and verify yourself.
            - img [ref=e296]
          - link "Chronology protection No time travel, proved as a mathematical theorem. Wormholes can exist; time travel cannot. Full derivation in Appendix S." [ref=e298] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/papers/appendix-s-stable-wormholes-and-chronology-protection/
            - generic [ref=e299]: ↯
            - generic [ref=e300]:
              - heading "Chronology protection" [level=3] [ref=e301]
              - paragraph [ref=e302]: No time travel, proved as a mathematical theorem. Wormholes can exist; time travel cannot. Full derivation in Appendix S.
            - img [ref=e304]
      - generic [ref=e306]:
        - generic [ref=e307]:
          - generic [ref=e308]: § 02 · The thesis
          - heading "The single postulate" [level=2] [ref=e309]
        - generic [ref=e310]:
          - generic [ref=e311]:
            - generic [ref=e312]: ◇
            - generic [ref=e313]: Postulate
          - paragraph [ref=e315]: Spacetime is fundamentally discrete — a four-dimensional integer lattice (ℤ⁴) with spacing at the Planck length (~10⁻³⁵ m).
        - paragraph [ref=e316]: "From this single assumption, the theory derives:"
        - list [ref=e317]:
          - listitem [ref=e318]:
            - text: →
            - strong [ref=e319]: Cosmological constant
            - text: Λ = 1.1×10⁻⁵² m⁻², on √2-channel at N≈10
            - code [ref=e320]: Lambda_CC_substrate_fit
          - listitem [ref=e321]:
            - text: →
            - strong [ref=e322]: Dark energy
            - text: w = −1 from photon-coherence reservoir
            - code [ref=e323]: darkEnergyEquationOfState_w
          - listitem [ref=e324]:
            - text: →
            - strong [ref=e325]: Black-hole entropy
            - text: S = A/4
            - code [ref=e326]: bh_entropy_bekenstein
          - listitem [ref=e327]:
            - text: →
            - strong [ref=e328]: Standard Model mass hierarchy
            - text: across 3 generations
            - code [ref=e329]: three_channel_partition_theorem
          - listitem [ref=e330]:
            - text: →
            - strong [ref=e331]: Fourth Noether law
            - text: — information conservation ∂
            - subscript [ref=e332]: μ
            - text: J
            - superscript [ref=e333]: μ
            - subscript [ref=e334]: I
            - text: = 0
            - code [ref=e335]: fourth_noether_law_harmonic
          - listitem [ref=e336]:
            - text: →
            - strong [ref=e337]: Strong-CP resolution
            - text: without axion (N = 6 beats experiment by 10 orders)
            - code [ref=e338]: strongCPThetaBound
      - generic [ref=e339]:
        - generic [ref=e340]:
          - generic [ref=e341]: § 03 · Empirical status
          - heading "Already confirmed" [level=2] [ref=e342]
        - generic [ref=e343]:
          - generic [ref=e344]:
            - generic [ref=e345]: ✓
            - generic [ref=e346]:
              - strong [ref=e347]: Gate fidelity scaling (2024)
              - paragraph [ref=e348]: Predicted F(T) = F₀/(1+αT) scaling confirmed by IBM / Google quantum-computer data. Temperature dependence matches discrete-spacetime thermal noise model.
              - generic [ref=e349]: Diraq · Nature 627, 772–777 (2024)
          - generic [ref=e350]:
            - generic [ref=e351]: ✓
            - generic [ref=e352]:
              - strong [ref=e353]: Dark-energy equation of state
              - paragraph [ref=e354]: Predicted w = −1 ± 0.03 from lattice geometry. DESI 2024 measures w = −0.99 ± 0.05 — inside predicted bounds.
              - generic [ref=e355]: DESI DR1 · 2024
      - generic [ref=e356]:
        - generic [ref=e357]:
          - generic [ref=e358]: § 04 · Where to start
          - heading "Reading guide" [level=2] [ref=e359]
        - list [ref=e360]:
          - listitem [ref=e361]:
            - link "01 Origin story Main paper · the single postulate and central thesis" [ref=e362] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/papers/main-paper-postulates/
              - generic [ref=e363]: "01"
              - generic [ref=e364]:
                - strong [ref=e365]: Origin story
                - generic [ref=e366]: Main paper · the single postulate and central thesis
          - listitem [ref=e367]:
            - link "02 Visual overview 11-level diagram showing how everything connects" [ref=e368] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/papers/unified-theory-diagram/
              - generic [ref=e369]: "02"
              - generic [ref=e370]:
                - strong [ref=e371]: Visual overview
                - generic [ref=e372]: 11-level diagram showing how everything connects
          - listitem [ref=e373]:
            - link "03 Complete framework Full technical treatment with all equations" [ref=e374] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/papers/complete-omega-theory-unified-framework/
              - generic [ref=e375]: "03"
              - generic [ref=e376]:
                - strong [ref=e377]: Complete framework
                - generic [ref=e378]: Full technical treatment with all equations
          - listitem [ref=e379]:
            - link "04 14 cycles · 84 predictions Cycle-by-cycle substrate fits with GitHub links to each Lean theorem" [ref=e380] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/cycles/
              - generic [ref=e381]: "04"
              - generic [ref=e382]:
                - strong [ref=e383]: 14 cycles · 84 predictions
                - generic [ref=e384]: Cycle-by-cycle substrate fits with GitHub links to each Lean theorem
          - listitem [ref=e385]:
            - link "05 Dark-energy preview paper Cosmological constant resolved via photon redshift reservoir" [ref=e386] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/papers/paper-dark-energy-preview-v1/
              - generic [ref=e387]: "05"
              - generic [ref=e388]:
                - strong [ref=e389]: Dark-energy preview paper
                - generic [ref=e390]: Cosmological constant resolved via photon redshift reservoir
          - listitem [ref=e391]:
            - link "06 Lean formalization Machine-verified capstone theorems · build instructions" [ref=e392] [cursor=pointer]:
              - /url: /Omega-Theory-Discrete-Spacetime/lean/
              - generic [ref=e393]: "06"
              - generic [ref=e394]:
                - strong [ref=e395]: Lean formalization
                - generic [ref=e396]: Machine-verified capstone theorems · build instructions
      - generic [ref=e397]:
        - heading "Explore the theory" [level=2] [ref=e398]
        - paragraph [ref=e399]: 25 papers · 14 cycles of formal predictions · 11K+ Lean declarations.
        - generic [ref=e400]:
          - link "See 14 cycles" [ref=e401] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/cycles/
          - link "Start reading" [ref=e402] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/papers/main-paper-postulates/
          - link "View on GitHub" [ref=e403] [cursor=pointer]:
            - /url: https://github.com/RamzesX/chaos-shield
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
  33  |       const response = await page.goto(path);
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
> 88  |     expect(bg, 'body background should be set by CSS').not.toBe('rgba(0, 0, 0, 0)');
      |                                                            ^ Error: body background should be set by CSS
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
  134 |     await page.goto('/');
  135 |     const overflow = await page.evaluate(() =>
  136 |       document.documentElement.scrollWidth > document.documentElement.clientWidth + 1
  137 |     );
  138 |     expect(overflow, 'mobile page has horizontal scroll — layout broken').toBe(false);
  139 |   });
  140 | });
  141 | 
  142 | test.describe('visual regression (baseline screenshots)', () => {
  143 |   test('home page', async ({ page }) => {
  144 |     await page.goto('/');
  145 |     await page.waitForLoadState('networkidle');
  146 |     await expect(page).toHaveScreenshot('home.png', { fullPage: true });
  147 |   });
  148 | 
  149 |   test('cycles page', async ({ page }) => {
  150 |     await page.goto('/cycles/');
  151 |     await page.waitForLoadState('networkidle');
  152 |     await expect(page).toHaveScreenshot('cycles.png', { fullPage: false });
  153 |   });
  154 | 
  155 |   test('a paper page', async ({ page }) => {
  156 |     await page.goto(PAGES.appendixA);
  157 |     await page.waitForLoadState('networkidle');
  158 |     await expect(page).toHaveScreenshot('paper-appendix-a.png', { fullPage: false });
  159 |   });
  160 | });
  161 | 
```