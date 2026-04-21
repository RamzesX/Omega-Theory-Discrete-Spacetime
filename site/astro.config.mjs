import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import { remarkRewritePaperLinks } from './src/plugins/remarkRewritePaperLinks.mjs';

// https://astro.build/config
export default defineConfig({
  site: 'https://ramzesx.github.io',
  base: '/Omega-Theory-Discrete-Spacetime',
  trailingSlash: 'always',

  integrations: [mdx()],

  markdown: {
    remarkPlugins: [
      remarkMath,
      [remarkRewritePaperLinks, { base: '/Omega-Theory-Discrete-Spacetime' }],
    ],
    rehypePlugins: [
      [
        rehypeKatex,
        {
          strict: false,
          trust: true,
          macros: {
            // Planck units
            '\\lP': '\\ell_P',
            '\\tP': 't_P',
            '\\mP': 'm_P',
            '\\EP': 'E_P',

            // Operators
            '\\Tr': '\\operatorname{Tr}',
            '\\tr': '\\operatorname{tr}',
            '\\sgn': '\\operatorname{sgn}',
            '\\Ric': '\\operatorname{Ric}',

            // Derivatives
            '\\dd': '\\mathrm{d}',
            '\\dv': '\\frac{\\mathrm{d} #1}{\\mathrm{d} #2}',
            '\\pdv': '\\frac{\\partial #1}{\\partial #2}',

            // Bra-ket
            '\\bra': '\\langle #1 |',
            '\\ket': '| #1 \\rangle',
            '\\braket': '\\langle #1 | #2 \\rangle',
            '\\expval': '\\langle #1 \\rangle',

            // Vectors
            '\\vb': '\\mathbf{#1}',
            '\\va': '\\vec{\\mathbf{#1}}',

            // Sets
            '\\RR': '\\mathbb{R}',
            '\\CC': '\\mathbb{C}',
            '\\ZZ': '\\mathbb{Z}',
            '\\NN': '\\mathbb{N}',
            '\\QQ': '\\mathbb{Q}',

            // Information current
            '\\JI': 'J^\\mu_I',
            '\\divJ': '\\partial_\\mu J^\\mu_I',

            // Common
            '\\half': '\\frac{1}{2}',
            '\\order': '\\mathcal{O}\\left(#1\\right)',
          },
        },
      ],
    ],
    // Shiki 3 / Astro 6 — tuned for dark physics aesthetic.
    shikiConfig: {
      theme: 'github-dark-dimmed',
      wrap: true,
      langs: [],
    },
  },

  vite: {
    ssr: {
      noExternal: ['katex'],
    },
  },
});
