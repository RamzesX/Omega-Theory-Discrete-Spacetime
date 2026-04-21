# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: links.e2e.mjs >> internal link crawl — every reachable page returns 200
- Location: tests/links.e2e.mjs:27:1

# Error details

```
Error: 8 broken internal links: /Omega-Theory-Discrete-Spacetime/papers/keyinsight-irrationals-action-thresholds — status 404 | /Omega-Theory-Discrete-Spacetime/papers/research/LEAN_VERIFIED_CLAIMS.md/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/ROADMAP_CYCLES_24_43.md/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses// — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses/06_separation_theorem.md/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses/11_master_plan_skeleton.md/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/Predictions/OmegaTheoryGrandCapstoneV2.lean/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/Predictions/OmegaTheoryGrandCapstone.lean/ — status 404

expect(received).toEqual(expected) // deep equality

- Expected  -  1
+ Received  + 10

- Array []
+ Array [
+   "/Omega-Theory-Discrete-Spacetime/papers/keyinsight-irrationals-action-thresholds — status 404",
+   "/Omega-Theory-Discrete-Spacetime/papers/research/LEAN_VERIFIED_CLAIMS.md/ — status 404",
+   "/Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/ROADMAP_CYCLES_24_43.md/ — status 404",
+   "/Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses// — status 404",
+   "/Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses/06_separation_theorem.md/ — status 404",
+   "/Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses/11_master_plan_skeleton.md/ — status 404",
+   "/Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/Predictions/OmegaTheoryGrandCapstoneV2.lean/ — status 404",
+   "/Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/Predictions/OmegaTheoryGrandCapstone.lean/ — status 404",
+ ]
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
        - generic [ref=e83]: "404"
        - heading "Worldline not in the lattice" [level=1] [ref=e84]
        - paragraph [ref=e85]: The requested coordinate has no corresponding vertex in our ℤ⁴ Planck lattice. Either the URL truncated below resolution, or the page recently decayed into an off-shell fluctuation.
        - generic [ref=e86]:
          - generic [ref=e87]: No event at
          - generic [ref=e88]: /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/O…
          - generic [ref=e89]:
            - text: If you arrived via a link, please
            - link "file an issue ↗" [ref=e90] [cursor=pointer]:
              - /url: https://github.com/RamzesX/chaos-shield/issues/new
            - text: .
        - generic [ref=e91]:
          - link "Return to origin" [ref=e92] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/
            - generic [ref=e93]: Return to origin
            - img [ref=e94]
          - link "Browse the 14 cycles" [ref=e96] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/cycles/
          - link "Read the main paper" [ref=e97] [cursor=pointer]:
            - /url: /Omega-Theory-Discrete-Spacetime/papers/main-paper-postulates/
        - paragraph [ref=e98]:
          - generic [ref=e99]: "status: Planck-scale truncation error"
          - generic [ref=e100]:
            - text: δ
            - subscript [ref=e101]: comp
            - text: (N→∞) = 0
```

# Test source

```ts
  1   | /**
  2   |  * Link crawl — ensure every internal link resolves on the running site.
  3   |  *
  4   |  * Visits the home page, collects every internal href, visits each, checks
  5   |  * status 200 and zero 4xx/5xx on assets. Skips external links and fragment-
  6   |  * only hashes. Limits to 40 pages so CI doesn't run forever.
  7   |  *
  8   |  * Complements Makefile / check_links.py (which is static) with actual runtime
  9   |  * verification — catches cases where a link exists in dist/ but Astro's
  10  |  * trailing-slash config makes it 404 at request time.
  11  |  */
  12  | 
  13  | import { test, expect } from '@playwright/test';
  14  | 
  15  | const MAX_PAGES = 40;
  16  | const STARTING_URLS = ['/', '/cycles/', '/lean/', '/convqmath/'];
  17  | 
  18  | function isInternal(href, origin) {
  19  |   try {
  20  |     const u = new URL(href, origin);
  21  |     return u.origin === origin;
  22  |   } catch {
  23  |     return false;
  24  |   }
  25  | }
  26  | 
  27  | test('internal link crawl — every reachable page returns 200', async ({ page, baseURL }) => {
  28  |   const origin = new URL(baseURL).origin;
  29  |   const basePath = new URL(baseURL).pathname.replace(/\/$/, ''); // /Omega-Theory-Discrete-Spacetime
  30  |   const toVisit = new Set(STARTING_URLS);
  31  |   const visited = new Set();
  32  |   const failures = [];
  33  | 
  34  |   while (toVisit.size > 0 && visited.size < MAX_PAGES) {
  35  |     const next = toVisit.values().next().value;
  36  |     toVisit.delete(next);
  37  |     if (visited.has(next)) continue;
  38  |     visited.add(next);
  39  | 
  40  |     let response;
  41  |     try {
  42  |       response = await page.goto(next, { waitUntil: 'domcontentloaded', timeout: 15000 });
  43  |     } catch (e) {
  44  |       failures.push(`${next} — navigation error: ${e.message}`);
  45  |       continue;
  46  |     }
  47  | 
  48  |     if (!response || response.status() >= 400) {
  49  |       failures.push(`${next} — status ${response?.status() ?? 'null'}`);
  50  |       continue;
  51  |     }
  52  | 
  53  |     // Collect internal hrefs on this page for continued crawl
  54  |     const hrefs = await page.$$eval('a[href]', (as) =>
  55  |       as.map((a) => a.getAttribute('href')).filter(Boolean)
  56  |     );
  57  |     for (const h of hrefs) {
  58  |       if (h.startsWith('#') || h.startsWith('mailto:')) continue;
  59  |       if (!isInternal(h, origin)) continue;
  60  |       const url = new URL(h, origin);
  61  |       const pathOnly = url.pathname + url.search;
  62  |       // Skip paths outside base (e.g. absolute GitHub links in content)
  63  |       if (basePath && !pathOnly.startsWith(basePath)) continue;
  64  |       if (!visited.has(pathOnly)) toVisit.add(pathOnly);
  65  |     }
  66  |   }
  67  | 
  68  |   expect(
  69  |     failures,
  70  |     `${failures.length} broken internal links: ${failures.slice(0, 10).join(' | ')}${
  71  |       failures.length > 10 ? ` (+${failures.length - 10} more)` : ''
  72  |     }`
> 73  |   ).toEqual([]);
      |     ^ Error: 8 broken internal links: /Omega-Theory-Discrete-Spacetime/papers/keyinsight-irrationals-action-thresholds — status 404 | /Omega-Theory-Discrete-Spacetime/papers/research/LEAN_VERIFIED_CLAIMS.md/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/ROADMAP_CYCLES_24_43.md/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses// — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses/06_separation_theorem.md/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/IrrationalityClasses/11_master_plan_skeleton.md/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/Predictions/OmegaTheoryGrandCapstoneV2.lean/ — status 404 | /Omega-Theory-Discrete-Spacetime/papers/LeanFormalizationV2/OmegaTheory/Predictions/OmegaTheoryGrandCapstone.lean/ — status 404
  74  | 
  75  |   expect(
  76  |     visited.size,
  77  |     'crawl should visit at least a few pages (home + cycles + lean + convqmath = 4+)'
  78  |   ).toBeGreaterThanOrEqual(4);
  79  | });
  80  | 
  81  | test('zero 4xx/5xx responses during crawl (assets + nav)', async ({ page, baseURL }) => {
  82  |   const origin = new URL(baseURL).origin;
  83  |   const failures = [];
  84  | 
  85  |   page.on('response', (r) => {
  86  |     const u = r.url();
  87  |     // Only track same-origin (the deployed site)
  88  |     if (!u.startsWith(origin)) return;
  89  |     if (r.status() >= 400) failures.push(`${r.status()} ${u}`);
  90  |   });
  91  | 
  92  |   for (const url of ['/', '/cycles/', '/papers/paper-qm-from-discrete-gravity/']) {
  93  |     await page.goto(url);
  94  |     await page.waitForLoadState('networkidle');
  95  |   }
  96  | 
  97  |   expect(
  98  |     failures,
  99  |     `HTTP errors during crawl: ${failures.slice(0, 10).join(' | ')}`
  100 |   ).toEqual([]);
  101 | });
  102 | 
```