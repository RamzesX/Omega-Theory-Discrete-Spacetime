# SOTA Mathematical Theorem Decomposition — Literature Synthesis

**Author:** literature-scholar (team divide-et-impera)
**Date:** 2026-04-30
**Scope:** Classical to frontier (1945 → 2026); 10 topics, ≥10 web sources

---

## 1. Pólya — How to Solve It (1945, Princeton)

Pólya's foundational 4-step framework (continuously in print since 1945):

1. **Understand the problem.** What is unknown? What are the data? What is the condition? Is the condition sufficient/redundant/contradictory?
2. **Devise a plan.** Find connections between data and unknown — this is the heuristic moment.
3. **Carry out the plan.** Execute each step; check correctness at each.
4. **Look back.** Verify result, examine method, look for generalizations, alternative paths.

### Key Heuristics ("dictionary of devices")

- **Auxiliary problem:** "If you cannot solve the proposed problem, try first to solve some related problem."
- **Analogy:** Find a problem with the same/analogous unknown and exploit its solution.
- **Specialization:** Solve a particular case first (e.g. n=2 before general n).
- **Generalization:** Sometimes the more general problem is easier (Pólya's "inventor's paradox").
- **Working backward:** Start from goal, ask "what would suffice?" — recursively until reachable from data.
- **Decomposing & recombining:** Split unknown/condition/data into parts, solve sub-instances, recombine.
- **Auxiliary elements:** Introduce new objects (a line, a variable, a lemma) that bridge data to goal.
- **Drop a part of the condition** to land on a problem you can solve, then add back.

The framework is application-agnostic — Pólya's logical principles apply equally to physics, software, novel-writing.

---

## 2. Terence Tao — Modern Adaptation (2010s–2025)

### MasterClass 5 Tips ([masterclass.com](https://www.masterclass.com/articles/mathematical-problem-solving)):

1. **Choose wisely.** Work at the cutting edge of feasibility — problems just barely beyond your tools. You can change parameters: easier, harder, generalize, specialize.
2. **Trim the fat.** Use abstraction to identify which elements are most important; represent them as objects.
3. **Use analogies.** They expose the mechanics and even the philosophical underpinnings of a problem.
4. **Change your perspective ("get attached").** Treat the search as detective work or a battle, not algebra-grinding.
5. **Question everything.** Be innately skeptical of established methods.

### "Think Ahead" career advice ([blog](https://terrytao.wordpress.com/career-advice/think-ahead/)):

When you set out to prove a lemma, **don't get bogged down**. Ask:

- **How will this lemma be used downstream?**
- **Would a weaker lemma suffice?**
- **Is there a simpler formulation?**
- **What features of the lemma's statement are most important?**

This guides you toward the *minimal sufficient* formulation rather than over-engineering.

### "Create lemmas" advice ([blog](https://terrytao.wordpress.com/advice-on-writing-papers/create-lemmas/)):

- Each major milestone should be a self-contained, prominently located proposition.
- If the proof of a lemma is long, **promote it to a proposition** with its own dedicated section.
- Lemmas are "building blocks" — they reduce structural total complexity.
- Place milestones early in papers, before all technical apparatus.

### Polymath ([polymathprojects.org](https://polymathprojects.org/)):

Massively-collaborative model (Gowers/Tao 2009+) showed that **modular decomposition into named pieces** is what enables crowd-sourcing of hard theorems. Lean is now the natural substrate ("provided that it can be broken up in a modular fashion into smaller pieces that can be attacked without necessarily understanding all aspects of the project as a whole").

---

## 3. Hindry-Silverman GTM 201 — Roth's theorem as canonical named-lemma decomposition

[Springer GTM 201](https://link.springer.com/book/10.1007/978-1-4612-1210-2) — *Diophantine Geometry: An Introduction* by Hindry & Silverman (2000).

Roth's theorem ("an algebraic number has finitely many approximations of order 2 + ε") is proved in **Part D**. After Parts A (heights), B (algebraic geometry), C (Mordell-Weil), Part D presents Roth + Siegel via a canonical decomposition:

- **D.5 / D.6 — Auxiliary polynomial** construction (Siegel's lemma giving controlled height) vanishing to high order at specific algebraic points.
- **D.6 — Index reduction lemma** ("The Index is Large at Approximations"): a vanishing-index argument tightens around assumed good rational approximations.
- **D.7 — Index bound from above** ("The Index is Small via Roth's lemma"): induction on number of variables.
- **D.8 — Completion**: Combining the upper and lower index bounds gives the contradiction.

The canonical "Aux Poly + Index Large + Index Small + Completion" decomposition is the **gold-standard Bourbaki-style top-down named-lemma proof** in modern Diophantine geometry. It transforms a 30+ page Roth proof into 4 reusable named pieces.

---

## 4. Cassels (1957) and LeVeque

J.W.S. Cassels, [*An Introduction to Diophantine Approximation*](https://projecteuclid.org/euclid.bams/1183522285) (Cambridge 1957) — foundational text. **Roth's lemma** is proved by induction on number of variables (base case = univariate polynomial; step uses decomposition of polynomial into sums of products of lower-dimensional polynomials).

LeVeque generalized Roth so that the approximating numbers may be from a **fixed algebraic number field** — same induction skeleton, more general scalars.

This same "induction on variables + auxiliary polynomial with bounded height + nonvanishing lemma" pattern recurs in Bombieri-Gubler [*Heights in Diophantine Geometry*](https://www.cambridge.org/core/books/heights-in-diophantine-geometry/4117673141D14050628601C428E8748D/listing) (Cambridge 2006) — same canonical naming.

Bombieri-Gubler also includes **Schmidt's subspace theorem** (Chapter 7), which extends Roth to higher dimensions via the same auxiliary-polynomial framework — see also Vojta's [Diophantine approximation and the subspace theorem](https://arxiv.org/html/2502.00731v1) (2025).

---

## 5. Bourbaki — Top-down axiomatic style

Bourbaki ([Wikipedia](https://en.wikipedia.org/wiki/Nicolas_Bourbaki), [CMS Notes](https://notes.math.ca/en/article/bourbaki-structuralism-and-categories/)) is the archetype of **top-down general-to-particular** writing:

- Begin with the most abstract, axiomatic terms possible, treating prerequisites from scratch.
- **Never generalize from special cases** — always deduce special cases from the most general.
- Style is terse: definitions, theorems, proofs. **No discussion, no images, no context.**
- Foundation is set theory (ZF + Choice) followed by structures (groups, rings, topological spaces, ...).

This contrasts with **Fikhtenholz** (1947 Russian *Course of Differential and Integral Calculus*) — bottom-up rigorous calculus that builds from concrete examples but **always knows the destination**: every chapter ends at a major theorem the introductory examples were preparing.

The dialectic: Bourbaki = top-down pure structure (skeleton); Fikhtenholz = bottom-up concrete examples (flesh). Frontier proof engineering needs **both**: state the destination (top-down), build sub-machinery (bottom-up), recompose.

---

## 6. Modern Lean SOTA (2025-2026)

### MA-LoT ([arxiv 2503.03205](https://arxiv.org/abs/2503.03205))

Multi-Agent Lean-based Long Chain-of-Thought (March 2025). Two LoT-Solvers: **Prover Agent** and **Corrector Agent**. The Prover generates whole-proof attempts; the Corrector consumes Lean error feedback and revises. Achieves **61.07%** on MiniF2F-Test (vs DeepSeek-V3 33.61%, InternLM-Step-Prover 50.70%, Goedel-Prover 55.33%).

### Ax-Prover ([arxiv 2510.12787](https://arxiv.org/abs/2510.12787v2))

Anthropic Claude Code MCP-based theorem prover (Oct 2025). Uses **MCP (Model Context Protocol)** to equip Claude (Sonnet 4 in experiments) with Lean tools from `lean-lsp-mcp`. The LLM analyzes unproved theorems, proposes proof sketches, generates step-by-step Lean code; Lean tools allow inspection of goals, search, error location, verification. Demonstrated on **abstract algebra and quantum physics** (incl. Lo-Chau QKD entropy bound). This is the closest SOTA template to the OmegaTheoryV2 workflow.

### DeepSeek-Prover-V2 ([arxiv 2504.21801](https://arxiv.org/abs/2504.21801))

671B-param model (April 2025). Cold-start RL via **subgoal decomposition**: DeepSeek-V3 decomposes complex problems into proof sketches with subgoals formalized in Lean 4. Resolved subgoal proofs are synthesized into chain-of-thought, producing "a cohesive synthesis of informal reasoning and subsequent formalization". Achieves **88.9% MiniF2F-test**, 49/658 PutnamBench. Two subgoal-theorem types: (1) preceding subgoals as premises, (2) independent — both used in expert iteration.

### Goedel-Prover-V2 ([arxiv 2508.03613](https://arxiv.org/pdf/2508.03613))

8B / 32B (August 2025). Trains statement formalizers on 1.64M Lean 4 statements autoformalized from Numina. **Goedel-Prover-V2-32B = 88.1-90.4% MiniF2F** with self-correction; the 8B version (80× smaller than DeepSeek-V2-671B) reaches 84.6%.

### Aristotle ([arxiv 2510.01346](https://arxiv.org/abs/2510.01346))

Harmonic Team (Oct 2025). Three components: (1) Lean proof search via parallel Monte Carlo Graph Search; (2) **lemma-based informal reasoning** that generates informal proofs, breaks them into lemmas, formalizes each; (3) dedicated geometry solver. **Solved 5/6 IMO 2025 problems** with verified Lean. The lemma-decomposition loop iterates based on formal feedback — the most direct realization of "Pólya + Lean" yet.

### Prover Agent ([arxiv 2506.19923](https://arxiv.org/abs/2506.19923))

Coordinates informal LLM + formal prover + Lean feedback, **generating auxiliary lemmas** beyond just subgoals — including special cases or useful facts derived from assumptions. **88.1% MiniF2F**, 25/658 PutnamBench among small-LM methods.

### LeanDojo / ReProver ([leandojo.org](https://leandojo.org/leandojo.html), [arxiv 2306.15626](https://ar5iv.labs.arxiv.org/html/2306.15626))

ByT5 retrieval augmentation: encoder embeds proof state as query, retrieves top-100 premises by cosine similarity, feeds to encoder-decoder Transformer that generates next tactic. 98,734-theorem benchmark with novel-premise generalization split. **First retrieval-augmented Lean prover** — ancestor of all current Mathlib retrieval pipelines.

### DSP — Draft, Sketch, Prove ([arxiv 2210.12283](https://arxiv.org/abs/2210.12283))

Three-phase: **Draft** (informal NL goals) → **Sketch** (formal proof skeleton in Isabelle/Lean) → **Prove** (hammer/automated prover discharges sub-problems). DSP+ (2025) shows neuro-symbolic coordination of off-the-shelf reasoning models matches frontier provers without training.

### Hilbert / Mechanic / Delta Prover (2025)

- **Hilbert** ([arxiv 2509.22819](https://arxiv.org/pdf/2509.22819)) — recursively decomposes problems into subgoals; orchestrates DeepSeek-Prover-V2-7B + Goedel-Prover-V2-32B.
- **Mechanic** — `Sorrifier` agent uses `sorry` placeholder in Lean to **isolate unresolved subgoals while preserving surrounding verified proof structure**. Same shape as the Roth proof in Hindry-Silverman.
- **Delta Prover** — reflective decomposition + revision after failed decompositions. **95.9% MiniF2F-test** SOTA.
- **BFS-Prover-V2** — 95.08% MiniF2F, 41.4% ProofNet via hierarchical multi-agent search.
- **Seed-Prover** trains a "sketch model" that generates lemma-based Lean sketches as a hierarchical problem decomposer; agentic prover then solves sub-problems in parallel.

The unifying pattern: **sketch + named-lemma decomposition + automated discharge per sub-lemma + reflection on failure**.

---

## 7. Mathlib community decomposition patterns

[Naming conventions](https://leanprover-community.github.io/contribute/naming.html), [Style](https://leanprover-community.github.io/contribute/style.html):

- **Theorem names list hypotheses in order**: `A → B → C` named `C_of_A_of_B`.
- `≤` and `<` are preferred over `≥` and `>` (so `le_of_lt` not `ge_of_gt`).
- **Injectivity**: when the conclusion is `Function.Injective f`, name `f_injective`. **Bidirectional** injectivity = `f_inj`.
- Empty lines inside declarations are linter-discouraged (uniform style).
- **Normal forms**: pick a canonical form per equivalence class, register simp lemmas to convert.
- Mathlib's lemma decomposition is heavily **bottom-up filling** (small generic helpers compose into milestones) coupled with top-down structure of major theorems (e.g. `MeasureTheory.Integral.*`, `NumberTheory.Modular.*`).

---

## 8. Industrial proof engineering — Z3, Coq, Isabelle

[SMTCoq](https://www-sop.inria.fr/marelle/Laurent.Thery/pub1.pdf) — Coq plugin reconstructing SMT proofs from veriT/Z3/CVC4. Coq checks **98.6%** of veriT proof witnesses; Isabelle/HOL checks 88.0% of Z3 witnesses. The pattern: **decompose the goal into SMT-amenable sub-obligations**, dispatch to Z3, reconstruct certificate inside the proof assistant. This is the industrial analogue of `omega_hammer_premise` in OmegaTheoryV2.

[Sledgehammer for Isabelle/HOL](https://www.tcs.ifi.lmu.de/staff/jasmin-blanchette/frocos2011-dis-proof.pdf) — combines interactive prover generality with SMT automation; discharges tedious subgoals automatically. Sledgehammer is the canonical **automated discharge after manual decomposition** workflow.

CVC5 ([Stanford 2022](https://www-cs.stanford.edu/~preiner/publications/2022/BarbosaBBKLMMMN-TACAS22.pdf)) — versatile industrial-strength SMT solver; many SMT-LIB benchmarks come from industrial verification (mixed-signal circuits, hardware, software).

---

## 9. AI-agent decomposition — Anthropic multi-agent research system

[Anthropic engineering blog](https://www.anthropic.com/engineering/multi-agent-research-system):

- **90.2% lift** on internal research evals: Claude Opus 4 lead + Sonnet 4 subagents vs single-agent Opus 4.
- **Excels especially for breadth-first queries** that benefit from pursuing multiple independent directions simultaneously.
- Concrete example: "find all board members of S&P 500 IT companies" — multi-agent decomposed into per-company subagents and succeeded; single agent failed via slow sequential search.
- Strategies encoded in prompts: **decomposing difficult questions into smaller tasks**, evaluating source quality, adjusting search based on new info, and **recognizing when to focus on depth vs breadth**.

**When breadth-first wins:** parallelizable sub-questions with independent context.
**When depth-first wins:** tightly-coupled multi-step reasoning where each step depends on the prior.

The OmegaTheoryV2 wave-dispatch pattern (5-7 wizards parallel, sage proposes, parent owns batch) is exactly this: **breadth-first for tactical sub-lemmas, depth-first for paper-grade single-thread**.

---

## 10. Structural decomposition theory — graph-theoretic / topological views

Theorem dependency graphs (e.g. [Dependency Graphs for Interactive Theorem Provers](https://www.researchgate.net/publication/2396953_Dependency_Graphs_for_Interactive_Theorem_Provers)) visualize large proof developments as graphs where edges encode dependency. Decomposition lemmas appear in proofs of **local structure theorems** for graph minors (Robertson-Seymour-Thomas), tree-decompositions, etc.

**Pattern**: Choose a root piece, split the rest into connected components attaching to that piece, recurse. This is exactly the **named-lemma + composition skeleton** style transposed to graphs.

OmegaTheoryV2 uses Magnetic Laplacian + FastRP + Leiden clustering on the theorem-dependency graph (~9,500 OV2 + 49,985 Mathlib Theorem nodes) to find **subsystem boundaries** (= natural decomposition cuts). The Hindry-Silverman pattern applied at corpus scale.

---

## SYNTHESIS: The 5-Phase HYBRID Pattern (consensus across all 10 topics)

Every SOTA approach — classical Pólya, Tao, Hindry-Silverman, modern Aristotle/DeepSeek/Mechanic — converges on the same skeleton:

```
PHASE A (Pólya step 1+2 / Tao Think Ahead / Bourbaki top-down):
  STATE the hard theorem first with NAMED Prop hypotheses H₁..Hₙ.
  Compose them into the destination theorem (this is short — the "roadmap").
  Question: how is each Hᵢ used? Weaker version suffice? Simpler formulation?

PHASE B (Hindry-Silverman canon / Tao "trim the fat"):
  TRUTH-RANK Hᵢ by estimated likelihood:
    Tier-99 (routine cleanup) → discharge FIRST (build commit history, reveal
                                what machinery the heart actually needs).
    Tier-80 (medium difficulty) → discharge SECOND.
    Tier-Heart (analytical heart) → discharge LAST (long single-thread).

PHASE C (Per-tier discharge / Mechanic / Prover Agent):
  Tier-99: omega_hammer_premise → exact?, 1-3 sub-iterations.
  Tier-80: LSP-assisted manual proof, 3-7 sub-iterations.
  Tier-Heart: literature line-by-line, sustained burn, 2-3 sub-iterations.

PHASE D (Fikhtenholz bottom-up / Mathlib filling):
  When sub-machinery missing, build foundational pieces concretely with
  examples — but always knowing the destination from Phase A.

PHASE E (Pólya step 4 / Tao "Question everything" / Aristotle iteration):
  Compose all Hᵢ into the unconditional theorem.
  Yoneda bridge sweep: find_similar(seed, k=10), bridge >0.85 hits.
  Axiom audit: Lean-core only.
  Look back: minimum hypotheses? Generalizations? Stronger statement holds?
```

This is the pattern OmegaTheoryV2 has empirically validated:
- T-4 (π-transcendence) retired in **single day, 14 files / ~3000 lines** by single-thread Opus 4.7.
- T-5 (Roth) ~80% closed via 11-layer HEART top-down stack.
- The pattern matches Aristotle's IMO 5/6 + DeepSeek-Prover-V2's 88.9% + Mechanic's IMO/Putnam gains.

---

## Sources

- [Pólya — How to Solve It (Wikipedia)](https://en.wikipedia.org/wiki/How_to_Solve_It)
- [Pólya 1945 PDF — How to Solve It](https://www.hlevkin.com/hlevkin/90MathPhysBioBooks/Math/Polya/George_Polya_How%20to%20Solve%20It.pdf)
- [Heuristic of Pólya and AI (DTIC)](https://apps.dtic.mil/sti/tr/pdf/ADA106557.pdf)
- [Tao — 5 Tips MasterClass](https://www.masterclass.com/articles/mathematical-problem-solving)
- [Tao — Think Ahead](https://terrytao.wordpress.com/career-advice/think-ahead/)
- [Tao — Create Lemmas](https://terrytao.wordpress.com/advice-on-writing-papers/create-lemmas/)
- [Tao — 245A problem-solving strategies](https://terrytao.wordpress.com/2010/10/21/245a-problem-solving-strategies/)
- [Polymath Project](https://polymathprojects.org/)
- [Hindry-Silverman GTM 201 — Springer](https://link.springer.com/book/10.1007/978-1-4612-1210-2)
- [Hindry-Silverman AMS Bulletin Review](https://www.ams.org/journals/bull/2001-38-03/S0273-0979-01-00907-7/S0273-0979-01-00907-7.pdf)
- [Cassels review — Diophantine Approximation](https://projecteuclid.org/euclid.bams/1183522285)
- [Bombieri-Gubler — Heights in Diophantine Geometry](https://www.cambridge.org/core/books/heights-in-diophantine-geometry/4117673141D14050628601C428E8748D/listing)
- [Roth's theorem — Wikipedia](https://en.wikipedia.org/wiki/Roth's_theorem)
- [Vojta — Diophantine approximation and subspace theorem (2025)](https://arxiv.org/html/2502.00731v1)
- [Bourbaki — Wikipedia](https://en.wikipedia.org/wiki/Nicolas_Bourbaki)
- [Bourbaki, Structuralism, Categories — CMS Notes](https://notes.math.ca/en/article/bourbaki-structuralism-and-categories/)
- [MA-LoT — arxiv 2503.03205](https://arxiv.org/abs/2503.03205)
- [Ax-Prover — arxiv 2510.12787](https://arxiv.org/abs/2510.12787v2)
- [DeepSeek-Prover-V2 — arxiv 2504.21801](https://arxiv.org/abs/2504.21801)
- [Goedel-Prover-V2 — arxiv 2508.03613](https://arxiv.org/pdf/2508.03613)
- [Aristotle — arxiv 2510.01346](https://arxiv.org/abs/2510.01346)
- [Prover Agent — arxiv 2506.19923](https://arxiv.org/abs/2506.19923)
- [LeanDojo / ReProver — arxiv 2306.15626](https://ar5iv.labs.arxiv.org/html/2306.15626)
- [LeanDojo website](https://leandojo.org/leandojo.html)
- [DSP — Draft Sketch Prove arxiv 2210.12283](https://arxiv.org/abs/2210.12283)
- [Hilbert — arxiv 2509.22819](https://arxiv.org/pdf/2509.22819)
- [Mechanic — arxiv 2603.24465](https://arxiv.org/html/2603.24465)
- [Mathlib naming conventions](https://leanprover-community.github.io/contribute/naming.html)
- [Mathlib style guidelines](https://leanprover-community.github.io/contribute/style.html)
- [Anthropic — multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- [SMTCoq — Modular SAT/SMT in Coq](https://www-sop.inria.fr/marelle/Laurent.Thery/pub1.pdf)
- [Sledgehammer / Isabelle](https://www.tcs.ifi.lmu.de/staff/jasmin-blanchette/frocos2011-dis-proof.pdf)
- [CVC5 — versatile SMT solver](https://www-cs.stanford.edu/~preiner/publications/2022/BarbosaBBKLMMMN-TACAS22.pdf)
- [Lemma (mathematics) — Wikipedia](https://en.wikipedia.org/wiki/Lemma_(mathematics))
- [Dependency Graphs for ITPs](https://www.researchgate.net/publication/2396953_Dependency_Graphs_for_Interactive_Theorem_Provers)
