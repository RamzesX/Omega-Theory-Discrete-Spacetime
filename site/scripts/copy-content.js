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
    title: 'Complete Omega-Theory Unified Framework (legacy comprehensive)',
    description: 'Full technical treatment with all equations — legacy 1036-line version',
    category: 'Core Theory',
    order: 3,
  },
  'CompleteOmegaTheory.md': {
    title: 'Ω-Theory: Machine-Verified Algebraic Framework (formal paper, 2026-05-04)',
    description: 'Clean formal academic paper. LaTeX equations, ASCII chain diagrams, step-by-step derivation, 55 Lean theorem index. All 5 OPEN bridge targets closed (cycle 65). Submission targets: PRL 2026-06, Foundations of Physics 2026-10.',
    category: 'Core Theory',
    order: 0,
  },
  'KeyInsight-Irrationals-Action-Thresholds.md': {
    title: 'Key Insight: Irrationals and Action Thresholds',
    description: 'The core mechanism of discrete spacetime',
    category: 'Core Theory',
    order: 4,
  },

  // ─────────────────────────────────────────────────────────────
  // V3-for-Lean / OmegaTheoryAlgebra — Magnetic Laplacian + Leiden +
  // FastRP over the Lean theorem graph (Neo4j `math` container).
  // First corpus-scale application of graph-theoretic methods to a
  // Lean theorem-prover corpus. Paper target: NeurIPS 2026 / ICLR 2027.
  // ─────────────────────────────────────────────────────────────
  'GROTHENDIECK_MATH_PUZZLE.md': {
    title: 'Grothendieck Math Puzzle — Missing-Piece Synthesis',
    description: '8-pass categorical / homological / spectral analysis of OmegaTheory V2 as a Lean-theory-with-structure — what mathematics is the graph asking for? Neo4j · Magnetic Laplacian · FastRP.',
    category: 'Graph Research · Neo4j',
    order: 100,
  },
  'ACHIEVEMENTS.md': {
    title: 'OmegaTheoryAlgebra — Graph Research Achievements',
    description: 'Design + empirical foundation for the V3-for-Lean paper: 10 design memos, 8,996 theorems × 15 arrow types × 3.95M typed edges. Rank-7 saturating, λ₁/λ₂=1.038, 73.3% non-commutativity.',
    category: 'Graph Research · Neo4j',
    order: 101,
  },
  '01_entity_types.md': {
    title: '01 — The 6 Lean Entity Types',
    description: 'V3\'s 6-entity model (Actor, Process, Resource, Rule, Event, Context) re-mapped for Lean 4: Axiom, Theorem/Lemma, Definition/Abbrev, Structure/Class, Instance, Namespace.',
    category: 'Graph Research · Neo4j',
    order: 110,
  },
  '02_relationships.md': {
    title: '02 — Typed Arrows (15 relationships)',
    description: '4 structural + 5 dependency + 3 type-theoretic + 3 computational typed arrows. IMPORTS, OPENS_NAMESPACE, EXTENDS, INSTANTIATES, ASSUMES, APPLIES, UNFOLDS, SPECIALIZES, ...',
    category: 'Graph Research · Neo4j',
    order: 111,
  },
  '03_selection_rules.md': {
    title: '03 — Selection Rules (Forbidden Compositions)',
    description: '13 design rules pruning the 6×15 product space. 7 ship as HARD_BLOCK :SelectionRule nodes in live Neo4j.',
    category: 'Graph Research · Neo4j',
    order: 112,
  },
  '04_magnetic_laplacian.md': {
    title: '04 — Magnetic Laplacian construction',
    description: '𝔄 ∈ ℂ^{6×6} Hermitian at magnetic phase g=1/4. Per-relation rank-2 decomposition, Hermiticity sketch.',
    category: 'Graph Research · Neo4j',
    order: 113,
  },
  '05_cycle_hypotheses.md': {
    title: '05 — Cycle hypotheses (𝔰𝔲(2) candidates)',
    description: 'SPECIALIZES⇌GENERALIZES and UNFOLDS⇌FOLDS bidirectional cycles. ±i eigenvalue predictions.',
    category: 'Graph Research · Neo4j',
    order: 114,
  },
  '06_fastrp_scaling.md': {
    title: '06 — FastRP scaling (Johnson–Lindenstrauss)',
    description: 'm=64 per relation for ~243K nodes. J-L bound, seed=42, weights [0.0, 1.0, 1.0, 0.5].',
    category: 'Graph Research · Neo4j',
    order: 115,
  },
  '07_single_lens_rationale.md': {
    title: '07 — Single-lens rationale',
    description: 'Why a single Qwen3-8B embedding beats V3\'s 3-lens overlay on a formal theorem-prover corpus.',
    category: 'Graph Research · Neo4j',
    order: 116,
  },
  '08_empirical_spectrum.md': {
    title: '08 — Empirical spectrum (live measurements)',
    description: 'Commutator eigenvalues on real OmegaTheory+Mathlib data. Rank-7 saturating, λ₁/λ₂ = 1.038, 5-scale hierarchy.',
    category: 'Graph Research · Neo4j',
    order: 117,
  },
  '09_subsystem_sanity.md': {
    title: '09 — Subsystem sanity check',
    description: 'Detected subsystems vs expected OmegaTheory physics themes (Foundations, Irrationality, Gauge, Emergence, Predictions, Conservation).',
    category: 'Graph Research · Neo4j',
    order: 118,
  },
  '10_neo4j_schema_map.md': {
    title: '10 — Neo4j schema map (Cypher pipeline)',
    description: 'Explicit Cypher-node / edge mapping. .neo4j/lean_algebra_ontology.cypher + lean_algebra_arrows.cypher + lean_magnetic_laplacian.cypher.',
    category: 'Graph Research · Neo4j',
    order: 119,
  },
  'mathlib_theorems_without_proof_body.md': {
    title: 'Mathlib theorems without proof body',
    description: 'Inventory of Mathlib theorems missing proof_body after the 175K-theorem ingest.',
    category: 'Graph Research · Neo4j',
    order: 120,
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
  const frontmatterBlock = `---
title: "${meta.title}"
${meta.description ? `description: "${meta.description}"` : ''}
${meta.category ? `category: "${meta.category}"` : ''}
${meta.order ? `order: ${meta.order}` : ''}
---

`;

  // If the file has its own frontmatter, check whether it satisfies the
  // papers schema (requires `title:`). If `title:` is missing but we have
  // a meta.title, replace the existing block — internal author-generated
  // frontmatter (e.g. `name: 03_selection_rules`) is not compatible with
  // the Astro content schema on its own.
  if (content.startsWith('---')) {
    const endIdx = content.indexOf('\n---', 4);
    if (endIdx === -1) return content;
    const block = content.slice(0, endIdx + 4);
    const rest = content.slice(endIdx + 4);
    const hasTitle = /^title:\s*["']?.+["']?\s*$/m.test(block);
    if (hasTitle) return content; // author-supplied frontmatter is fine
    if (!meta.title) return content; // nothing to inject
    // Replace the author frontmatter with the papersMeta block so the
    // Astro schema validates. Author's metadata is preserved as HTML
    // comment so it's not lost.
    const preservedInternal = block
      .split('\n')
      .slice(1, -1)
      .map((l) => `<!-- orig-frontmatter: ${l} -->`)
      .join('\n');
    return frontmatterBlock + preservedInternal + '\n' + rest.trimStart();
  }

  return frontmatterBlock + content;
}

// Subfolders to scan (post-reorg 2026-04-20)
const paperSubdirs = ['', 'papers', 'appendices', 'letter-coldneutron', 'diagrams', 'notes', 'OmegaTheoryAlgebra'];
// Default categories by subdir (used when file not in papersMeta)
const categoryBySubdir = {
  '': 'Meta',
  'papers': 'Core Theory',
  'appendices': 'Appendices',
  'letter-coldneutron': 'PRL Submission',
  'diagrams': 'Visual',
  'notes': 'Research Notes',
  // V3-for-Lean graph algebra — Magnetic Laplacian + Leiden + FastRP applied to
  // the Lean theorem graph (Neo4j `math` container). Surfaced through
  // /papers/grothendieck_math_puzzle/, /papers/achievements/, etc.
  'OmegaTheoryAlgebra': 'Graph Research · Neo4j',
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
