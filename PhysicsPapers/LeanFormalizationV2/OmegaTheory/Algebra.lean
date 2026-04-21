/-
  OmegaTheory.Algebra — umbrella module for the V3-for-Lean graph algebra.

  Lifts the Phase 0 design memos `OmegaTheoryAlgebra/01..04_*.md` into
  machine-checkable Lean 4 types and structures.  Four sub-modules:

    * `Entity`    — the six core entity types (Axiom, Definition, Instance,
                    Namespace, Structure, Theorem), their heights, and the
                    Axiom-as-pure-source / Namespace-as-strict-sink theorems.
    * `Arrow`     — the fifteen core typed arrows in four categories
                    (4 structural + 5 dependency + 3 type-theoretic + 3
                    computational), with `source`, `target`, `category`
                    functions and the 4 category-count lemmas.
    * `Selection` — the seven HARD_BLOCK selection rules SR_L1..SR_L7
                    as a decidable `ForbiddenTriple` predicate plus seven
                    individual witness lemmas and the
                    `canonical_triples_are_legal` consistency theorem.
    * `Laplacian` — the 6×6 Hermitian Magnetic Laplacian 𝔄 in canonical
                    alphabetical order, with Hermiticity, trace, Namespace
                    decoupling, and per-diagonal entries proved.

  This matches the live Neo4j `LeanAlgebra` namespace 1:1 on the core
  ontology (6 QuiverVertex + 15 QuiverArrow + 7 HARD_BLOCK SelectionRule +
  1 MagneticLaplacian).  Level B + C extensions (Tactic/Attribute vertices,
  USES_TACTIC/TAGGED_AS/MUTUALLY_IMPLIES/DUAL_OF/ADDITIVE_PAIR arrows) are
  intentionally excluded — per memo 02 §13, they live on the data graph,
  not on the schema.

  Agent: Kitalpha (α Equulei), 2026-04-21, cycle 44 first ship.
-/

import OmegaTheory.Algebra.Entity
import OmegaTheory.Algebra.Arrow
import OmegaTheory.Algebra.Selection
import OmegaTheory.Algebra.Laplacian
