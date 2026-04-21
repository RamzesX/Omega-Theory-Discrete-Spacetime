# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: accessibility.e2e.mjs >> links are discernible >> no <a> with empty href or empty text
- Location: tests/accessibility.e2e.mjs:123:3

# Error details

```
TimeoutError: page.goto: Timeout 20000ms exceeded.
Call log:
  - navigating to "http://127.0.0.1:4321/", waiting until "load"

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
  24  |   AxeBuilder = null;
  25  | }
  26  | 
  27  | const PAGES = {
  28  |   home: '/',
  29  |   paperQM: '/papers/paper-qm-from-discrete-gravity/',
  30  |   appendixF: '/papers/appendix-f-information-flow-conservation/',
  31  |   cycles: '/cycles/',
  32  | };
  33  | 
  34  | test.describe('WCAG accessibility (axe-core)', () => {
  35  |   for (const [name, pth] of Object.entries(PAGES)) {
  36  |     test(`${name} — no serious/critical a11y violations`, async ({ page }) => {
  37  |       test.skip(
  38  |         !AxeBuilder,
  39  |         '@axe-core/playwright not installed; run `npm install --save-dev @axe-core/playwright`'
  40  |       );
  41  |       await page.goto(pth);
  42  |       await page.waitForLoadState('networkidle');
  43  | 
  44  |       const results = await new AxeBuilder({ page })
  45  |         .options({
  46  |           // Only fail on serious/critical. Minor issues get logged but don't
  47  |           // block CI — fonts on mobile can trip contrast false positives.
  48  |           resultTypes: ['violations'],
  49  |         })
  50  |         .analyze();
  51  | 
  52  |       const hardBlockers = results.violations.filter((v) =>
  53  |         ['serious', 'critical'].includes(v.impact)
  54  |       );
  55  | 
  56  |       expect(
  57  |         hardBlockers,
  58  |         `axe serious/critical violations on ${pth}: ${hardBlockers
  59  |           .map((v) => `${v.id} (${v.nodes.length})`)
  60  |           .join(', ')}`
  61  |       ).toEqual([]);
  62  |     });
  63  |   }
  64  | });
  65  | 
  66  | test.describe('images have alt text', () => {
  67  |   for (const [name, pth] of Object.entries(PAGES)) {
  68  |     test(`${name} — no <img> without alt`, async ({ page }) => {
  69  |       await page.goto(pth);
  70  |       const missing = await page.$$eval('img', (imgs) =>
  71  |         imgs
  72  |           .filter((i) => !i.hasAttribute('alt'))
  73  |           .map((i) => i.getAttribute('src') || '(no src)')
  74  |       );
  75  |       expect(missing, `<img> elements missing alt: ${missing.join(', ')}`).toEqual([]);
  76  |     });
  77  |   }
  78  | });
  79  | 
  80  | test.describe('heading hierarchy', () => {
  81  |   test('home has exactly one <h1>', async ({ page }) => {
  82  |     await page.goto('/');
  83  |     const h1Count = await page.locator('h1').count();
  84  |     expect(h1Count, 'exactly one <h1> per page (W3C HTML best practice)').toBe(1);
  85  |   });
  86  | 
  87  |   test('a paper page has a single <h1>', async ({ page }) => {
  88  |     await page.goto(PAGES.paperQM);
  89  |     const h1Count = await page.locator('h1').count();
  90  |     expect(h1Count, 'paper pages should have exactly one <h1>').toBe(1);
  91  |   });
  92  | 
  93  |   test('no skipped heading levels (h1 -> h3 without h2)', async ({ page }) => {
  94  |     await page.goto(PAGES.paperQM);
  95  |     const levels = await page.$$eval('h1, h2, h3, h4, h5, h6', (hs) =>
  96  |       hs.map((h) => parseInt(h.tagName.slice(1), 10))
  97  |     );
  98  |     const skips = [];
  99  |     for (let i = 1; i < levels.length; i++) {
  100 |       if (levels[i] > levels[i - 1] + 1) {
  101 |         skips.push(`h${levels[i - 1]} -> h${levels[i]} at index ${i}`);
  102 |       }
  103 |     }
  104 |     expect(skips, `skipped heading levels: ${skips.join(', ')}`).toEqual([]);
  105 |   });
  106 | });
  107 | 
  108 | test.describe('readable typography', () => {
  109 |   test('body text is at least 14px on desktop', async ({ page }) => {
  110 |     await page.goto('/');
  111 |     const fontSizePx = await page.evaluate(() => {
  112 |       const el = document.querySelector('main, body');
  113 |       return parseFloat(getComputedStyle(el).fontSize);
  114 |     });
  115 |     expect(
  116 |       fontSizePx,
  117 |       `body text too small (${fontSizePx}px) — readability risk`
  118 |     ).toBeGreaterThanOrEqual(14);
  119 |   });
  120 | });
  121 | 
  122 | test.describe('links are discernible', () => {
  123 |   test('no <a> with empty href or empty text', async ({ page }) => {
> 124 |     await page.goto('/');
      |                ^ TimeoutError: page.goto: Timeout 20000ms exceeded.
  125 |     const bad = await page.$$eval('a', (as) =>
  126 |       as
  127 |         .filter((a) => {
  128 |           const href = a.getAttribute('href');
  129 |           const text = (a.textContent || '').trim();
  130 |           const aria = a.getAttribute('aria-label');
  131 |           const hasImg = !!a.querySelector('img[alt]');
  132 |           // OK if: href present AND (text OR aria-label OR img-with-alt)
  133 |           return !href || (!text && !aria && !hasImg);
  134 |         })
  135 |         .map((a) => a.outerHTML.slice(0, 120))
  136 |     );
  137 |     expect(bad, `<a> elements with no discernible label: ${bad.join(' | ')}`).toEqual([]);
  138 |   });
  139 | });
  140 | 
  141 | test.describe('tab-reachable interactive elements', () => {
  142 |   test('first tab press focuses an interactive element', async ({ page }) => {
  143 |     await page.goto('/');
  144 |     await page.keyboard.press('Tab');
  145 |     const focused = await page.evaluate(() => {
  146 |       const el = document.activeElement;
  147 |       if (!el || el === document.body) return null;
  148 |       return { tag: el.tagName, href: el.getAttribute('href'), text: el.textContent?.slice(0, 40) };
  149 |     });
  150 |     expect(focused, 'first Tab should focus a real interactive element, not document.body').not.toBeNull();
  151 |   });
  152 | });
  153 | 
```