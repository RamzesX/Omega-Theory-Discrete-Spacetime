/**
 * Remark plugin to rewrite relative links in markdown
 * to absolute paths for Astro content collections.
 *
 * This fixes the issue where relative links like [text](other-paper)
 * resolve to /current-paper/other-paper instead of /papers/other-paper/
 */

import { visit } from 'unist-util-visit';

export function remarkRewritePaperLinks(options = {}) {
  const base = options.base || '';

  return (tree, file) => {
    visit(tree, 'link', (node) => {
      const href = node.url;

      // Skip external links
      if (href.startsWith('http://') || href.startsWith('https://')) {
        return;
      }

      // Skip anchors (same-page links)
      if (href.startsWith('#')) {
        return;
      }

      // Skip already-absolute paths
      if (href.startsWith('/')) {
        return;
      }

      // Skip mailto and other protocols
      if (href.includes(':')) {
        return;
      }

      // Handle anchor links within relative paths (e.g., "other-paper#section")
      const [path, anchor] = href.split('#');

      // Rewrite relative paper links to absolute
      // e.g., "unified-theory-diagram" -> "/Omega-Theory-Discrete-Spacetime/papers/unified-theory-diagram/"
      const newPath = `${base}/papers/${path}/`;
      node.url = anchor ? `${newPath}#${anchor}` : newPath;
    });
  };
}

export default remarkRewritePaperLinks;
