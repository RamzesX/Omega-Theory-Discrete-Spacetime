/**
 * Copy physics papers to Astro content directory
 * Adds frontmatter where needed
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const rootDir = path.resolve(__dirname, '../..');

const papersSourceDir = path.join(rootDir, 'PhysicsPapers');
const papersDestDir = path.join(__dirname, '../src/content/papers');

// Paper metadata - updated to match actual files
const papersMeta = {
  // Core Theory
  'Main-Paper-Postulates.md': {
    title: 'Main Paper: How This Started',
    description: 'The origin story and central thesis of Omega-Theory',
    category: 'Core Theory',
    order: 1,
  },
  'unified-theory-diagram.md': {
    title: 'Visual Summary: The Complete Causal Architecture',
    description: '11-level diagram showing how everything connects',
    category: 'Core Theory',
    order: 2,
  },
  'Complete-Omega-Theory-Unified-Framework.md': {
    title: 'Complete Omega-Theory Unified Framework',
    description: 'Full technical treatment with all equations',
    category: 'Core Theory',
    order: 3,
  },
  'KeyInsight-Irrationals-Action-Thresholds.md': {
    title: 'Key Insight: Irrationals and Action Thresholds',
    description: 'The core mechanism of discrete spacetime',
    category: 'Core Theory',
    order: 4,
  },

  // Appendices (actual files)
  'Appendix-A-Action-Density-and-Quantum-Errors.md': {
    title: 'Appendix A: Action Density and Quantum Errors',
    description: 'Connecting action density to quantum error rates',
    category: 'Appendices',
    order: 10,
  },
  'Appendix-B-Quantum-Computing-Temperature-Limits.md': {
    title: 'Appendix B: Quantum Computing Temperature Limits',
    description: 'Temperature constraints on quantum computation',
    category: 'Appendices',
    order: 11,
  },
  'Appendix-C-Catalog-of-Evolution-Functionals.md': {
    title: 'Appendix C: Catalog of Evolution Functionals',
    description: 'Mathematical catalog of evolution operators',
    category: 'Appendices',
    order: 12,
  },
  'Appendix-D-Topological-Surgery-And-Information-Healing.md': {
    title: 'Appendix D: Topological Surgery and Information Healing',
    description: 'The mathematical backbone of the theory',
    category: 'Appendices',
    order: 13,
  },
  'Appendix-E-Quantum-Entanglement-Dimensional-Theory.md': {
    title: 'Appendix E: Quantum Entanglement Dimensional Theory',
    description: 'Entanglement and dimensional reduction',
    category: 'Appendices',
    order: 14,
  },
  'appendix-E-visual-diagrams.md': {
    title: 'Appendix E: Visual Diagrams',
    description: 'Visual representations of key concepts',
    category: 'Appendices',
    order: 15,
  },
  'Appendix-F-Information-Flow-Conservation.md': {
    title: 'Appendix F: Information Flow Conservation',
    description: 'The Fourth Noether Law',
    category: 'Appendices',
    order: 16,
  },
  'Appendix-G-Graviton-Predictions.md': {
    title: 'Appendix G: Graviton Predictions',
    description: 'Predictions for graviton properties',
    category: 'Appendices',
    order: 17,
  },
  'Appendix-H-Renormalization-Correspondence.md': {
    title: 'Appendix H: Renormalization Correspondence',
    description: 'Connecting discrete and continuous renormalization',
    category: 'Appendices',
    order: 18,
  },
  'Appendix-I-Experimental-Tests.md': {
    title: 'Appendix I: Experimental Tests',
    description: '21 testable predictions',
    category: 'Appendices',
    order: 19,
  },
  'Appendix-LorentzDopplerEquivalence.md': {
    title: 'Appendix L: Lorentz-Doppler Equivalence',
    description: 'Connecting Lorentz transformations and Doppler effects',
    category: 'Appendices',
    order: 21,
  },
  'Appendix-P-Einstein-Cartan-Torsion-Integration.md': {
    title: 'Appendix P: Einstein-Cartan Torsion Integration',
    description: 'Integrating torsion into the framework',
    category: 'Appendices',
    order: 25,
  },
  'Appendix-S-Stable-Wormholes-And-Chronology-Protection.md': {
    title: 'Appendix S: Stable Wormholes and Chronology Protection',
    description: 'Why time travel is impossible',
    category: 'Appendices',
    order: 28,
  },

  // Advanced
  'ErdosLagrangianUnification.md': {
    title: 'Erdős Lagrangian Unification',
    description: 'Unifying physics through Lagrangian formalism',
    category: 'Advanced',
    order: 50,
  },

  // Cycle 9+ additions (2026-04)
  'Paper-Dark-Energy-Preview-v1.md': {
    title: 'Paper: Dark Energy from Photon Redshift Reservoir',
    description: 'Preview manuscript deriving w = -1 and Lambda from substrate healing flow; includes cycle-9 numerical fits addendum',
    category: 'Current Work',
    order: 5,
  },
  'Paper-QM-From-Discrete-Gravity.md': {
    title: 'Paper: Quantum Mechanics from Discrete-Gravity Healing Dynamics',
    description: 'Machine-checked derivation of 7 QM pillars (Schrödinger, Born, 2-slit, Heisenberg, collapse, CHSH, non-relativistic limit) from the substrate; Lean 4 + Mathlib v4.29; target PRL / Nature Physics / Foundations of Physics',
    category: 'Current Work',
    order: 6,
  },
  'Appendix-DE-Dark-Energy-Reservoir-From-Photon-Redshift.md': {
    title: 'Appendix DE: Dark Energy Reservoir From Photon Redshift',
    description: 'The photon-coherence accumulator identifies Lambda as the integrated gravitational redshift cost',
    category: 'Appendices',
    order: 20,
  },
  'Appendix-J-Experimental-Catalog-Consolidated.md': {
    title: 'Appendix J: Experimental Catalog (Consolidated)',
    description: 'Unified table of all falsifiable predictions with PDG-comparable target values',
    category: 'Appendices',
    order: 22,
  },
  'Appendix-K-Irrationality-Genesis-Of-Predictions.md': {
    title: 'Appendix K: Irrationality Genesis of Predictions',
    description: 'How pi / e / sqrt2 truncation channels generate the three-generation fermion mass hierarchy',
    category: 'Appendices',
    order: 23,
  },

  // Research notes and open problems (public-facing)
  'Letter-ColdNeutron-ExecutiveSummary.md': {
    title: 'Letter: Cold Neutron Slope Test (Executive Summary)',
    description: 'PRL submission package executive summary for the cold-neutron g-time-dilation experiment',
    category: 'Letters',
    order: 60,
  },
  'Note-Continued-Fraction-Information-Channels.md': {
    title: 'Note: Continued Fraction Information Channels',
    description: 'Structural link between continued-fraction expansions and substrate information channels',
    category: 'Notes',
    order: 70,
  },
  'Note-Structure-Preserving-Lattice-Curvature.md': {
    title: 'Note: Structure-Preserving Lattice Curvature',
    description: 'How discrete lattice curvature maps to continuum Riemann tensor components',
    category: 'Notes',
    order: 71,
  },
};

// Files to skip (not papers) — internal notes, build artifacts, project planning
const skipFiles = [
  'README.md',
  'README-Document-Structure.md',
  // Internal project/planning docs
  'CLAUDE.md',
  'IMPORTANT.md',
  'REORG_PLAN.md',
  'OPEN_THEOREMS.md',
  'NEW_HORIZONS.md',
  'STRATEGIC_FORMALIZATION_PLAN.md',
  'DEDUP_ANALYSIS.md',
  'CONNES_DF_RECIPE.md',
  'HPW_UPGRADE_RECIPE.md',
  'GAUGE_THEORY_RESEARCH.md',
  'MATTER_SECTOR_RESEARCH.md',
  // Cycle transition notes (internal)
  'NOTES_CYCLE14_TRANSITION.md',
  'NOTES_CYCLE15_TRANSITION.md',
  // Keep letter cover/slope-test/supplementary internal; only executive summary published
  'Letter-ColdNeutron-CoverLetter.md',
  'Letter-ColdNeutron-Slope-Test.md',
  'Letter-ColdNeutron-SupplementaryMethods.md',
];

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

function addFrontmatter(content, meta) {
  const frontmatter = `---
title: "${meta.title}"
${meta.description ? `description: "${meta.description}"` : ''}
${meta.category ? `category: "${meta.category}"` : ''}
${meta.order ? `order: ${meta.order}` : ''}
---

`;

  // Check if file already has frontmatter
  if (content.startsWith('---')) {
    return content;
  }

  return frontmatter + content;
}

// Subfolders to scan (post-reorg 2026-04-20)
const paperSubdirs = ['', 'papers', 'appendices', 'letter-coldneutron', 'diagrams', 'notes'];
// Default categories by subdir (used when file not in papersMeta)
const categoryBySubdir = {
  '': 'Meta',
  'papers': 'Core Theory',
  'appendices': 'Appendices',
  'letter-coldneutron': 'PRL Submission',
  'diagrams': 'Visual',
  'notes': 'Research Notes',
};

function copyPapers() {
  ensureDir(papersDestDir);

  let copied = 0;
  let skipped = 0;

  for (const subdir of paperSubdirs) {
    const dir = path.join(papersSourceDir, subdir);
    if (!fs.existsSync(dir)) continue;
    const files = fs.readdirSync(dir);

    for (const file of files) {
      if (!file.endsWith('.md')) continue;
      if (skipFiles.includes(file)) {
        console.log(`⏭ Skipped: ${subdir}/${file}`);
        skipped++;
        continue;
      }

      const sourcePath = path.join(dir, file);
      const stats = fs.statSync(sourcePath);

      if (!stats.isFile()) continue;

      let content = fs.readFileSync(sourcePath, 'utf-8');

      const meta = papersMeta[file] || {
        title: file.replace('.md', '').replace(/-/g, ' '),
        category: categoryBySubdir[subdir] || 'Papers',
      };

      content = addFrontmatter(content, meta);

      const slug = file.toLowerCase().replace('.md', '');
      const destPath = path.join(papersDestDir, slug + '.md');

      fs.writeFileSync(destPath, content);
      console.log(`✓ Copied: ${subdir || 'root'}/${file} -> ${slug}.md`);
      copied++;
    }
  }

  console.log(`\nSummary: ${copied} papers copied, ${skipped} files skipped`);
}

console.log('Copying physics papers to content directory...\n');
copyPapers();
console.log('\nDone!');
