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

const convqmath = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/convqmath' }),
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),
    order: z.number().optional(),
  }),
});

export const collections = { papers, convqmath };
