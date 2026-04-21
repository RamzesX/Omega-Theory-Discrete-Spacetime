import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

// Astro 6 Content Layer API — migrated from legacy `src/content/config.ts`.
// See: https://docs.astro.build/en/reference/content-loader-reference/
const papers = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/papers' }),
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),
    date: z.string().optional(),
    category: z.string().optional(),
    order: z.number().optional(),
    draft: z.boolean().optional().default(false),
  }),
});

// NOTE: the previous `convqmath` collection was removed 2026-04-21 because its
// base directory `./src/content/convqmath` never existed — a dead schema.
// ConvQMath essays live at the repo root `/ConvQMath/` and are surfaced via
// the hand-written `src/pages/convqmath.astro` page. To restore a data-driven
// collection, extend `site/scripts/copy-content.js` to mirror `/ConvQMath/*.md`
// into `./src/content/convqmath/` at build time, then re-add the defineCollection
// block here.

export const collections = { papers };
