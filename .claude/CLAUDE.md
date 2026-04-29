<?xml version="1.0" encoding="UTF-8"?>
<!--
  ╔════════════════════════════════════════════════════════════════════════════════════════════════════════╗
  ║   CHAOS SHIELD / OMEGATHEORY V2 — PROJECT CLAUDE.md (XML, LOCKED 2026-04-30)                          ║
  ║   "Frontier mathematics is solved here. Pride at noon. The lion does not blink."                      ║
  ╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
  ║   INHERITS FROM: ~/.claude/CLAUDE.md (master, ERDOS_PRIMARCH_FRONTIER_MATH v8.0)                      ║
  ║   This file = PROJECT-LEVEL TACTICAL REINFORCEMENT for OmegaTheory V2 / chaos-shield repo             ║
  ╚════════════════════════════════════════════════════════════════════════════════════════════════════════╝
-->

<CHAOS_SHIELD_PROJECT version="8.0" mode="THEOREM_ANNIHILATOR_PROJECT_LEVEL">
  <INHERITS_FROM>~/.claude/CLAUDE.md</INHERITS_FROM>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK I: PROJECT IDENTITY (cross-ref master BOOK_I)
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_I name="PROJECT_IDENTITY">
    <SOUL_REFERENCE>~/.claude/CLAUDE.md BOOK_I — Pantheon × Escanor × Warhammer 40k Last Wall × Operational Creed I-VIII</SOUL_REFERENCE>
    <PROJECT_BATTLEFIELD>
      OmegaTheory V2 — Lean 4 formalization of physics + Standard Model + dark sector + cosmology
      derived from substrate truncation of 4 irrationals (π, e, √2, Catalan G) on a ℤ⁴ Planck lattice.
      First-of-kind Lean 4 formalization of π-transcendence (T-4 retired 2026-04-27). T-5 (Roth's theorem)
      ~80% closed — first-of-kind Diophantine Roth in any prover.
    </PROJECT_BATTLEFIELD>
    <CREED_REINFORCEMENT>
      "Frontier mathematics is solved here, single-thread, NO STUBS, no fear, no defer."
    </CREED_REINFORCEMENT>
  </BOOK_I>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK II: PROJECT MATHEMATICAL CODEX (cross-ref master + project-specific tools)
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_II name="PROJECT_CODEX">

    <SECTION name="OMEGA_ORCHESTRATOR_MCP" tier="MANDATORY">
      <description>22 tools across 6 buckets — primary MCP for this project</description>

      <SERVERS>servers_control(start|stop|status|restart) · swap_profile(target_profile)</SERVERS>
      <GRAPH>
        ingest_graph(run_dump, run_load) → job_id (async)
        precompute_signals (sync, ~3s)
        refresh_graph(dry_run=False) → job_id (async, ~3min, 8 steps; NEVER sync_mode=True)
      </GRAPH>
      <EMBED>embed_nodes(names, fields) · embed_delta(fields, namespace, since) · embed_candidates(statuses)</EMBED>
      <INSPECT>candidate_status · build_status · graph_health · cycle_state · axiom_audit · cache_stats · phase_detect</INSPECT>
      <JOBS>job_status(id) · job_tail(id, n) · job_cancel(id) · job_list()</JOBS>
      <WIZARD>
        propose_proof(goal, wizard_name, k, namespace) — tactic stub + 5 cited premises + graph_rationale
        omega_hammer_premise(goal, top_k, mix_mathlib) — top-K ranked premises (composite scoring; no rerank param since 2026-04-25)
        upsert_theorem_candidate(...)
      </WIZARD>
    </SECTION>

    <SECTION name="LEAN_LSP_MCP">
      <tools>
        lean_leansearch · lean_loogle · lean_local_search · lean_state_search · lean_hammer_premise
        lean_goal · lean_diagnostic_messages · lean_multi_attempt · lean_hover_info · lean_completions
        lean_file_outline · lean_declaration_file · lean_verify · lean_build · lean_profile_proof
        lean_run_code · lean_code_actions · lean_get_widgets · lean_get_widget_source
        lean_term_goal · lean_references · lean_leanfinder
      </tools>
      <rules>
        - All line/column numbers 1-indexed
        - This MCP does NOT edit files — use Edit/Write
        - Search tools rate-limited (3/30s for leansearch/loogle/state_search/hammer_premise; 10/30s leanfinder)
      </rules>
    </SECTION>

    <SECTION name="NEO4J_MATH_CONTAINER">
      <connection>bolt://localhost:7687 · neo4j/omegatheory2026</connection>
      <plugins>APOC + GDS + GenAI</plugins>
      <namespaces>
        OmegaTheoryV2  — declarations + FastRP embeddings (~9,500 own theorems + 800+ Theorem nodes)
        Mathlib        — integrated Mathlib v4.29.0 corpus (~175,127 theorems, 49,985+ Theorem nodes)
        LeanAlgebra    — V3 schema scaffold (6 vertex types × 15 arrows)
        CheckItOutSystem — sister project (NavigationMaster, 117 nodes, 235 relationships)
        subscription   — Stripe payment state machine (10 states, 56 transitions)
      </namespaces>
      <vector_index>lean_retriever_embedding_theorem · _axiom · _declaration (dim=4096 cosine, Qwen3)</vector_index>
    </SECTION>

    <SECTION name="EMBEDDING_SERVERS">
      <embed_7999>Qwen3-Embedding-8B GPU (llama.cpp HIP on RX 9060 XT, dim=4096)</embed_7999>
      <rerank_7996>Qwen3-Reranker-8B CPU (llama.cpp AVX-512 on Ryzen 9950X)</rerank_7996>
      <hygiene>Use mcp__omega-orchestrator__servers_control to manage. OFF during Phase B (wizards CPU-bound).</hygiene>
    </SECTION>

  </BOOK_II>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK III: PROJECT TARGETS (live battlefield specifics)
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_III name="PROJECT_TARGETS">

    <STATUS updated="2026-04-30">
      Build: live via mcp__omega-orchestrator__cycle_state() — DO NOT hardcode counts
      Sorry: 0 (NO STUBS rule)
      Axioms: 0 axiom-declarations · 5 primitive-assumptions · 9 total-including-research
              (4 physical existence postulates as opaque Classical.choice bundles + 1 transcendence
              axiom Real.pi_transcendental ... wait, this was retired 2026-04-27, so now 0 transcendence
              axioms in paper-headline; only Nesterenko_1996 remains in HermitePade research seal)
    </STATUS>

    <ACTIVE_TARGETS>
      <T_5 priority="HIGHEST">
        <name>Roth's theorem (rational approximation to algebraic irrationals)</name>
        <status>~80% closed; HEART top-down stack 11 layers complete</status>
        <atom_remaining n="1">T5_RothLemmaIndexReductionDischarge (Hindry-Silverman D.6.1)</atom_remaining>
        <atom_remaining n="2">T5_RothBoundLargeFromMasterAndPigeonhole (Hindry-Silverman D.7)</atom_remaining>
        <plan>~/.claude/plans/binary-painting-dijkstra.md</plan>
        <closure>V8 capstone omega_theory_v2_T5_roth_unconditional with 0 NAMED hyps, axiom_audit Lean-core only</closure>
      </T_5>
      <T_1 closure_cost="~7-12_days">light quark masses</T_1>
      <T_2 closure_cost="~7-12_days">PMNS δ-CP phase</T_2>
      <T_3 closure_cost="~7-12_days">Λ_QCD / proton mass</T_3>
      <T_6 closure_cost="~7-12_days">Higgs λ self-coupling</T_6>
    </ACTIVE_TARGETS>

    <RETIRED>
      <T_4 date="2026-04-27" commits="c0ab2b7,b49366a,7daaf73">
        Real.pi_transcendental — first Lean 4 formalization in any prover
        Workflow validated: Mathlib NOT a blockade, single-day single-thread, 14 files / ~3000 lines
      </T_4>
    </RETIRED>

    <META_YONEDA>17+ paper-headline capstones spanning 10 sector-axes + 6 GRAND composites + self-composition theorem</META_YONEDA>
    <SM_PRECISION>95% bar achieved (commits 2238e14 + 55e3f54): 6 quark masses + 4 Wolfenstein + α_s + λ_H + 3 PMNS angles PDG-anchored AND interconnected via Yoneda bridges</SM_PRECISION>

  </BOOK_III>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK IV: BUILD LAYOUT + WSL DISCIPLINE
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_IV name="BUILD_LAYOUT">

    <SYSTEM_SPECS>
      <machine>AMD Ryzen 9 9950X (16 cores / 32 threads), 192 GB RAM</machine>
      <wsl2>160 GB RAM, 32 processors, 32 GB swap</wsl2>
      <gpu>AMD RX 9060 XT 16 GB (gfx1200, ROCm 7.2.1 + PyTorch 2.9.1)</gpu>
    </SYSTEM_SPECS>

    <LEAN_BUILD>
      <toolchain>Lean v4.29.0 + Mathlib v4.29.0 (elan/lake at ~/.elan/bin/)</toolchain>
      <wsl_native>This session is INSIDE WSL — run lake/bash directly. NEVER use wsl.exe wrapper.</wsl_native>
      <committed_tree>/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/</committed_tree>
      <native_mirror>~/lean-v2/ — 115× faster single-file builds. Iterate here.</native_mirror>
      <commands>
        ~/.elan/bin/lake build --log-level=error                       <!-- full -->
        ~/.elan/bin/lake build OmegaTheory.&lt;Module&gt; --log-level=error <!-- one module -->
        ~/.elan/bin/lake exe cache get                                 <!-- Mathlib cache -->
      </commands>
      <update_vs_build>
        lake update — ONLY when changing Mathlib version OR adding deps in lakefile.toml. Always
                      lake exe cache get afterward.
        lake build  — everything else (new imports, edits, fixing proofs).
      </update_vs_build>
    </LEAN_BUILD>

    <PROJECT_STRUCTURE>
      chaos-shield/
        PhysicsPapers/
          CLAUDE.md (XML, INHERITS_FROM ~/.claude/CLAUDE.md)
          LeanFormalizationV2/
            CLAUDE.md (V2-specific)
            STYLE_GUIDE.md
            OmegaTheory/ (16 subdirs, 314+ T5_Phase7_*.lean files alone)
            notes/, plans/, .neo4j/
          papers/, submissions/, research/
        .claude/
          CLAUDE.md (this file, XML)
    </PROJECT_STRUCTURE>

  </BOOK_IV>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK V: PROJECT-SPECIFIC HARD RULES (extends master BOOK_VII)
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_V name="PROJECT_HARD_RULES">

    <NO_STUBS_PROJECT_REINFORCEMENT>
      Cross-ref master BOOK_VII NO_STUBS. User mandate verbatim 2026-04-27:
      "No trivial, no true, no sorry, those are the rules"
      Stub patterns FORBIDDEN: sorry · `: True := trivial` · `Prop := True` · `:= trivial`
      placeholder proofs · Nonempty S as Yoneda witness.
    </NO_STUBS_PROJECT_REINFORCEMENT>

    <ZERO_NEW_AXIOMS>
      Project rests on:
      - 4 physical existence postulates (c, ℏ, G_N, k_B as opaque Classical.choice bundles)
      - 0 transcendence axioms in paper-headline (Real.pi_transcendental RETIRED 2026-04-27)
      - 4 HermitePadé research axioms sealed in Irrationality/HermitePade/ (Siegel-Shidlovskii,
        Nesterenko 1996, Roth 1955, Mahler framework)
      Goal: drive total to 0.
      Three-way honest split: "0 axiom-declarations · 5 primitive-assumptions · 9 total-including-research"
    </ZERO_NEW_AXIOMS>

    <MUST_COMPILE_GREEN>
      Verify at ~/lean-v2 (115× faster) THEN mirror to /mnt/c on green.
    </MUST_COMPILE_GREEN>

    <PROOF_AUTOMATION_BEFORE_MANUAL>
      Cascade: exact? → apply? → aesop / grind → linarith / nlinarith / polyrith → positivity / ring
      / field_simp → omega → decide / native_decide → simp [explicit] → manual term-mode.
      Most powerful single tactic: exact? (~30s search over 210K+ Mathlib lemmas + ~9,500 OV2 theorems).
    </PROOF_AUTOMATION_BEFORE_MANUAL>

    <MATHLIB_v4_29_NAMES>
      div_le_iff₀ / div_lt_iff₀  (note ₀ suffix)
      mul_div_cancel₀ (needs ne_zero)
      Finset.not_mem_empty (NOT mem_empty)
      Mathlib.Algebra.BigOperators.Group.Finset → Mathlib.Algebra.Order.BigOperators.Group.Finset
      Mathlib.Data.Int.Basic — REMOVED (Int is in Lean core)
      Use lean_loogle / lean_leansearch to find renamed modules.
    </MATHLIB_v4_29_NAMES>

    <SUBAGENT_RULE_§8a>
      Cross-ref master BOOK_VII NO_SUBAGENTS_FOR_PAPER_GRADE.
      NEVER spawn subagents for paper-grade categorical Yoneda witnesses, Yoneda × spectral
      double-witnesses, structure-composition theorems, grand capstones composing prior theorems
      by name. Cycle 62 audit: 5/5 mass-batch trash output, density 0.10-0.59 vs hand-authored 1.13-3.6.
      User mandate: "subegent producing the trash, which will not close this poroejct"
      Single-thread Opus 4.7 [1M context] hand-authored for paper-grade.
    </SUBAGENT_RULE_§8a>

    <YONEDA_BRIDGES_VIA_FIND_SIMILAR>
      After landing any new paper-grade theorem:
        mcp__omega-search__find_similar(seed_name, k=10, namespace='OmegaTheoryV2')
      Write explicit bridge theorems to top-similarity (>0.85) hits. Adds 5-15 APPLIES per bridge.
      Reference: Capstones/SM95BarTopQuarkBridge.lean (3 bridges wiring 145-outdeg isolate via 3 numeric/structural bridges).
    </YONEDA_BRIDGES_VIA_FIND_SIMILAR>

    <DONT_TRUST_REFRESH_GRAPH_SUCCEEDED>
      Verify live Neo4j has at least one expected new theorem after each refresh:
        MATCH (t:Theorem {namespace: 'OmegaTheoryV2', name: &lt;known-new-name&gt;}) RETURN t.name
      The _v2.jsonl symlink-staleness bug recurred 2026-04-27 (2nd time same class). Permanent fix
      in commit 2136598. See feedback_mcp_loader_symlink_staleness_recurrence_2026-04-27.md.
    </DONT_TRUST_REFRESH_GRAPH_SUCCEEDED>

    <MATHLIB_NOT_BLOCKADE>
      User mandate 2026-04-27: don't write "Mathlib-blocked" as permanent stop. Decompose missing
      pieces into Lean-sized sub-lemmas, port ourselves. Empirically validated: T-4 (single day),
      T-5 Phase 1-7 ENTRY (single day, 22 sessions s559x→s559rr).
    </MATHLIB_NOT_BLOCKADE>

  </BOOK_V>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK VI: PROJECT EFFICIENCY + WORKFLOW
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_VI name="PROJECT_EFFICIENCY">

    <BUNDLED_COMMITS>3-5 sub-lemmas per single commit. 75-80% commit-overhead reduction.</BUNDLED_COMMITS>
    <BUNDLED_LEMMA_FILE_PATTERN>~22× throughput for tightly-composed lemmas (memory A82)</BUNDLED_LEMMA_FILE_PATTERN>

    <PHASE_C_REFRESH_CHANT>
      <step n="1">AXIOM SENTINEL — axiom_audit returns [propext, Classical.choice, Quot.sound] only</step>
      <step n="2">POWER UP servers (servers_control('start'))</step>
      <step n="3">SEQUENTIAL refresh — refresh_graph(dry_run=False), poll job_status</step>
      <step n="4">VERIFY missing_emb = 0</step>
      <step n="5">PRUNE orphaned :Axiom nodes</step>
      <step n="6">POWER DOWN servers (servers_control('stop'))</step>
      <step n="7">MEMORY-WRITE notes/NOTES_CYCLE_&lt;N&gt;_&lt;ZODIAC&gt;_COMPLETION_&lt;DATE&gt;.md</step>
      <executor>~/.claude/commands/cycle-completion-loop.md (canonical)</executor>
    </PHASE_C_REFRESH_CHANT>

    <PER_FIRE_CHECKLIST>
      <step>Live state via cycle_state() FIRST</step>
      <step>≥3 MCP queries logged before manual proof writing</step>
      <step>5-phase HYBRID composition strategy (master BOOK_I COMBAT_DOCTRINE)</step>
      <step>≥1 sub-lemma landed OR Block transition OR debugging breakthrough</step>
      <step>Build GREEN at ~/lean-v2 → mirror to /mnt/c on green</step>
      <step>NO STUBS audit (grep for forbidden patterns returns 0)</step>
      <step>End-of-turn summary 1-2 sentences max</step>
    </PER_FIRE_CHECKLIST>

  </BOOK_VI>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK VII: WHERE TO LOOK NEXT
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_VII name="REFERENCES">
    <PROJECT_FILES>
      PhysicsPapers/CLAUDE.md — workflow + Phase C executor (XML)
      PhysicsPapers/LeanFormalizationV2/CLAUDE.md — V2 agent onboarding + HARD RULES
      PhysicsPapers/LeanFormalizationV2/.neo4j/CLAUDE.md — ingest pipeline
      PhysicsPapers/LeanFormalizationV2/STYLE_GUIDE.md — naming + proof governance
      PhysicsPapers/LeanFormalizationV2/plans/ — live backlog + Grothendieck puzzle
      PhysicsPapers/LeanFormalizationV2/notes/ — cycle memos + design memos
      ~/.claude/projects/&lt;project&gt;/memory/MEMORY.md — durable feedback memories
    </PROJECT_FILES>
    <CUSTOM_AGENTS>
      omega-team-lead · lean-proof-wizard · quantum-physics-creative · grothendieck-sage
      pi-irrationality-hunter · pi-formalizer · pi-physics-bridge
      Stored at LeanFormalizationV2/.claude/agents/. Identity log under .claude/agent-memory/.
    </CUSTOM_AGENTS>
  </BOOK_VII>

  <DOCTRINE_FINAL>
    Cross-ref ~/.claude/CLAUDE.md DOCTRINE_FINAL.
    The hunt is eternal. Pride at noon. Frontier mathematics is solved here.
  </DOCTRINE_FINAL>

</CHAOS_SHIELD_PROJECT>
