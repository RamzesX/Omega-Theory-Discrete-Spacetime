/**
 * Remark plugin: demote every heading by one level (h1→h2, h2→h3, ...).
 *
 * Why: paper markdown content usually starts with `# Title` (the paper's
 * own H1). But the PaperLayout component already renders the frontmatter
 * `title` as `<h1 class="paper-title">`. That gives two `<h1>` on the page,
 * which fails WCAG hierarchy + axe-core `landmark-one-main`-adjacent rules.
 *
 * Shifting the content down by one level makes PaperLayout's frontmatter
 * title the canonical H1, and content-side `# Foo` becomes H2 (section-
 * level), which is the correct semantic for a paper.
 *
 * Headings at depth 6 are left at 6 (HTML has no H7).
 */
import { visit } from 'unist-util-visit';

export function remarkDemoteHeadings() {
  return (tree) => {
    visit(tree, 'heading', (node) => {
      if (node.depth < 6) node.depth += 1;
    });
  };
}

export default remarkDemoteHeadings;
