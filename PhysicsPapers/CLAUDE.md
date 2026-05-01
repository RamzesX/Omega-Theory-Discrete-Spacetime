<?xml version="1.0" encoding="UTF-8"?>
<!--
  ╔════════════════════════════════════════════════════════════════════════════════════════════════════════╗
  ║   OMEGATHEORY — PHYSICS PAPERS & LEAN FORMALIZATION (XML, LOCKED 2026-04-30)                          ║
  ║   "Frontier mathematics + falsifiable physics + paper-headline rigor in one substrate."              ║
  ╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
  ║   INHERITS FROM: ~/.claude/CLAUDE.md (master, ERDOS_PRIMARCH_FRONTIER_MATH v8.0)                      ║
  ║                  chaos-shield/.claude/CLAUDE.md (project tactical reinforcement)                       ║
  ║   This file = SUB-PROJECT TACTICAL REINFORCEMENT for OmegaTheoryV2 LeanFormalizationV2 + papers       ║
  ╚════════════════════════════════════════════════════════════════════════════════════════════════════════╝
-->

<OMEGATHEORY_PHYSICSPAPERS version="8.0" mode="THEOREM_ANNIHILATOR_SUBPROJECT">
  <INHERITS_FROM>
    ~/.claude/CLAUDE.md
    /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/.claude/CLAUDE.md
  </INHERITS_FROM>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK I: SUB-PROJECT IDENTITY (cross-ref masters)
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_I name="SUB_PROJECT_IDENTITY">
    <SOUL_REFERENCE>~/.claude/CLAUDE.md BOOK_I — Pantheon × Escanor × Warhammer 40k Last Wall</SOUL_REFERENCE>

    <ACHIEVEMENT_MARKER date="2026-04-27">
      CYCLE 64 — π TRANSCENDENCE RETIRED. `Real.pi_transcendental` is no longer an axiom in OmegaTheory V2.
      First Lean 4 formalization of π-transcendence in any prover. Proved unconditionally in a single day
      (Norbert × Opus 4.7 [1M context]) via custom port of Lindemann-Weierstrass — 14 hand-authored
      Lean files (~3000 lines, s46-s59).
        - Build delta: 4418 → 4454 jobs GREEN, 0 sorry, 0 new axioms.
        - Paper-headline primitive assumptions: 5 → 4.
        - Axiom audit: [propext, Classical.choice, Quot.sound] only.
      Commits c0ab2b7, b49366a, 7daaf73.
    </ACHIEVEMENT_MARKER>

    <LESSONS_LOCKED_DURABLE>
      <lesson>Mathlib upstream is NOT a blockade. Decompose, port what's needed.</lesson>
      <lesson>NO STUBS rule survives at scale (14 files / 60+ theorems intact).</lesson>
      <lesson>Single-thread hand-authored beats subagents for paper-grade work.</lesson>
      <lesson>1M context is not the bottleneck — auto-compact persists.</lesson>
    </LESSONS_LOCKED_DURABLE>

    <CREED_REINFORCEMENT>
      "T-5/T-6/T-1/T-2/T-3 are decomposable single-thread in 1-3 weeks each. None require waiting on
      Mathlib upstream. None are blockades. Pride at noon. The lion does not blink."
    </CREED_REINFORCEMENT>
  </BOOK_I>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK II: SUB-PROJECT MATHEMATICAL CODEX (extra MCP + Neo4j details)
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_II name="SUB_PROJECT_CODEX">

    <SECTION name="OVERVIEW">
      OmegaTheory derives quantum mechanics, general relativity, and the full Standard Model gauge group
      + fermion masses + dark matter + dark energy + cyclic cosmology from 8 physical constants on a ℤ⁴
      Planck lattice. The computational truncation of FOUR irrationals (π, e, √2, Catalan G) produces
      bounded errors that ARE quantum uncertainty — and they furnish exactly four channels matching
      three SM generations plus one sterile/DM slot.
    </SECTION>

    <SECTION name="PI_HUNCH_CENTRAL_THESIS">
      Chain: π irrational → can't be computed exactly → per-tick truncation error δ_comp(N) =
      ℓ_P·4/(2N+3) from Leibniz series → extended Heisenberg ℏ/2 + δ_comp > ℏ/2 → QM is NECESSARY.

      Asymptotic ordering for N ≥ 6: π > G > e > √2
        - π:        O(1/N), LARGEST residual δ → heavy generation (top, etc.)
        - Catalan G: O(1/(2N+1)²) (quadratic) → sterile / DM channel
        - e:        O(1/N!), factorial decay → middle generation (charm, etc.)
        - √2:       super-exp O(2^{-2^N}) → light generation (up, etc.)

      Convention: "hardest to compute" = MOST residual errors, NOT least. π heaviest, √2 lightest.
      Do NOT invert via Connes Λ = 1/δ — that conflates UV cutoff (gravity) with fermion mass scale
      (D_F eigenvalues / Yukawa).
    </SECTION>

    <SECTION name="MCP_ARSENAL_SUBPROJECT_USE_CASES">
      <use_case name="every_proof_obligation">
        Cascade per master BOOK_II MCP_ARSENAL DEFAULT_CASCADE: omega_hammer_premise → find_similar
        → lean_loogle → lean_leansearch → lean_state_search → lean_hammer_premise → manual.
        ≥3 MCP queries logged per obligation (mandate per master BOOK_VIII PER_FIRE).
      </use_case>
      <use_case name="post_landing">
        find_similar(seed_name, k=10, namespace='OmegaTheoryV2') → write Yoneda bridges to >0.85 hits
      </use_case>
      <use_case name="phase_C_chant">
        refresh_graph(dry_run=False) async → poll → verify missing_emb=0 → axiom_audit
      </use_case>
      <use_case name="live_state">
        cycle_state() FIRST every fire — NEVER hardcode build_jobs/axioms/sorry counts
      </use_case>
    </SECTION>

    <SECTION name="NEO4J_INGEST_PIPELINE">
      <ground_truth>~/lean-v2/.neo4j/ — see LeanFormalizationV2/.neo4j/CLAUDE.md</ground_truth>
      <files>
        OmegaTheory/Meta/DumpDeclarations.lean (Schedar) — env declaration dumper
        OmegaTheory/Meta/DumpArrows.lean (Sheratan) — 12-arrow typed env extractor
        .neo4j/load_declarations_env_v2.py (Naos) — delta declaration loader
        .neo4j/load_arrows_parallel.py — SOTA parallel 16-worker loader (~500× faster)
        .neo4j/reembed_qwen3_delta.py — Qwen3-Embedding-8B BF16 GPU embedder
      </files>
      <critical_invariant>
        Nodes must use FULLY-QUALIFIED names (module + "." + short_name) to match dump_arrows output.
      </critical_invariant>
      <do_not_use>
        .neo4j/extractors/lean_arrow_extractor.py (regex, deprecated; drops 46% of fresh theorems)
      </do_not_use>
    </SECTION>

  </BOOK_II>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK III: SUB-PROJECT TARGETS + STATUS
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_III name="SUB_PROJECT_TARGETS">

    <STATUS updated="2026-04-30">
      <build>Live via cycle_state() — DO NOT hardcode</build>
      <sorry>0 (NO STUBS rule)</sorry>
      <axioms>
        0 axiom-declarations · 4 primitive-assumptions (post-T4-retirement) · 4 sealed HermitePadé
        research axioms = 8 total honest accounting (down from 9 pre-T4).
      </axioms>
      <theorems>~9,500 OmegaTheoryV2 own + 175,127 Mathlib = ~184,627 total Theorems in graph</theorems>
    </STATUS>

    <ACTIVE_FRONTIER_TARGETS>
      <T_5 priority="HIGHEST">
        <name>Roth's theorem unconditional closure</name>
        <status>~80% closed; HEART top-down stack 11 layers complete (commit 05d0a39)</status>
        <plan>~/.claude/plans/binary-painting-dijkstra.md</plan>
      </T_5>
      <T_1>light quark masses (~7-12d closure cost)</T_1>
      <T_2>PMNS δ-CP phase (~7-12d)</T_2>
      <T_3>Λ_QCD / proton mass (~7-12d)</T_3>
      <T_6>Higgs λ self-coupling (~7-12d)</T_6>
    </ACTIVE_FRONTIER_TARGETS>

    <CYCLES_24_43_CLOSED>
      Mekbuda's 60-theorem backlog CLOSED. Grand Capstone V2 locked by Polaris
      (omega_theory_v2_final_meta_capstone). 8-axiom minimality + falsifiability panel +
      4-irrational uniqueness all shipped.
    </CYCLES_24_43_CLOSED>

    <SM_PRECISION_95_BAR_CLOSED date="2026-04-27">
      6 quark masses + 4 Wolfenstein + α_s + λ_H + 3 PMNS angles PDG-anchored AND interconnected via
      Yoneda bridges (5 standard + 3 top-quark via find_similar workflow). No isolated PDG citations.
    </SM_PRECISION_95_BAR_CLOSED>

    <META_YONEDA_CAPSTONES count="17+">
      Spanning 10 sector-axes + 6 GRAND composites + self-composition theorem.
    </META_YONEDA_CAPSTONES>

  </BOOK_III>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK IV: PHASE-BASED CYCLE MODEL (extends master BOOK_IV with sub-project specifics)
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_IV name="SUB_PROJECT_PHASES">

    <CYCLE_NAMING_ZODIAC>
      52=Aries · 53=Taurus · 54=Gemini · 55=Cancer · 56=Leo · 57=Virgo · 58=Libra · 59=Scorpius
      · 60=Sagittarius · 61=Capricornus · 62=Aquarius · 63=Pisces
      Memo filename: NOTES_CYCLE_&lt;N&gt;_&lt;ZODIAC&gt;_COMPLETION_&lt;DATE&gt;.md
    </CYCLE_NAMING_ZODIAC>

    <NAMING_POOL>
      Agents pick from the WHOLE observable universe:
      - Planets + dwarf planets (Mercury, Venus, Pluto, Eris, Sedna, Makemake, Haumea, etc.)
      - Moons (Io, Europa, Ganymede, Titan, Charon, Triton, Miranda, Enceladus, etc.)
      - Asteroids + centaurs (Vesta, Pallas, Juno, Hygiea, Iris, Psyche, Chiron, Pholus, etc.)
      - Comets (Halley, Hale-Bopp, Hyakutake, Lovejoy, Encke, Holmes, etc.)
      - Nebulae (Orion, Crab, Eagle, Lagoon, Trifid, Helix, Veil, Ring, etc.)
      - Star clusters (Pleiades, Hyades, Beehive, Wild-Duck, Jewel-Box, etc.)
      - Galaxies (Andromeda, Triangulum, Whirlpool, Sombrero, Pinwheel, Cigar, Bode, etc.)
      - Exoplanets (Kepler-22b, Kepler-186f, TRAPPIST-1e, Proxima-b, Gliese-581c, etc.)
      - Other-galaxy stars (R-136a1, Eta-Carinae, Pistol-Star, VY-Canis-Majoris, UY-Scuti, etc.)
      Each agent logs identity at LeanFormalizationV2/.claude/agent-memory/&lt;role&gt;/&lt;name&gt;.md
    </NAMING_POOL>

    <WAVE_AND_STRETCH>
      Sage volume: 20 briefings per fire (≥8 Track-1 / ≥6 Track-2 / ≥1 Track-3)
      Wizard wave: 5-7 parallel on disjoint files (hard cap 7)
      Wizard stretch: each tries 2nd briefing if PRIMARY lands cleanly with ≥40% time/context remaining
      Sage MUST run staleness audit FIRST (Cypher-check vs CLOSED_BY_LEAN_LANDING)
    </WAVE_AND_STRETCH>

    <STRICT_PHASE_ORDERING_LOCKED date="2026-04-25">
      <bad>Phase B+A overlap → caused dup proposals + cycle 55 lake-lock crash</bad>
      <bad>refresh_graph during Phase B → parent died at step 4 dump_arrows</bad>
      <good>B → C → A strict sequence, no overlaps</good>
    </STRICT_PHASE_ORDERING_LOCKED>

    <SAGE_WIZARD_SEPARATION>
      Sage proposes (.md only) — Cypher writes for status; NEVER edits .lean. Output: briefings under
        LeanFormalizationV2/plans/SAGE_BRIEFING_&lt;name&gt;_&lt;date&gt;.md
      Wizards prove (.lean only) — each owns NEW target file. Existing files = read-only (extend by
      NEW companion files). DO NOT edit Basic.lean (parent owns batch).
    </SAGE_WIZARD_SEPARATION>

  </BOOK_IV>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK V: SUB-PROJECT TWO-LOOP PACING + WORKFLOW
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_V name="SUB_PROJECT_PACING">

    <PER_FIRE_MANDATE>
      <step n="1">Recall identity (Erdős Primarch + Pantheon + Operational Creed I-VIII)</step>
      <step n="2">Live state via cycle_state() FIRST (never hardcode counts)</step>
      <step n="3">MCP-FIRST cascade per master BOOK_II (≥3 queries before manual)</step>
      <step n="4">5-phase HYBRID composition strategy (master BOOK_I COMBAT_DOCTRINE)</step>
      <step n="5">99+% truth-rank named lemmas first; heart last</step>
      <step n="6">Bundled commits 3-5 sub-lemmas per commit</step>
      <step n="7">Build GREEN at ~/lean-v2 → mirror to /mnt/c</step>
      <step n="8">NO STUBS audit; confidence intervals [X-Y%]</step>
      <step n="9">Last Stand Protocol if MCP/LSP degrade (master BOOK_V)</step>
      <step n="10">Yoneda bridge sweep after every paper-grade landing</step>
      <step n="11">End fire after ≥1 sub-lemma landed OR Block transition OR debugging breakthrough</step>
    </PER_FIRE_MANDATE>

    <TWO_LOOP_PACING>
      <strategic_loop cron="12,42 * * * *" interval="30min">
        Full phase routing + dual-track sage brief. Dodge :00/:30 fleet sync.
        Template: ~/.claude/commands/erdos-strategic-cycle.md (BOOK_I-VIII XML)
      </strategic_loop>
      <agent_pool_loop cron="7,17,27,37,47,57 * * * *" interval="10min">
        Quick wizards-done? backlog ready? idle? check-in. Doesn't fire sage or wizards.
        Template: ~/.claude/commands/erdos-agent-pool-cycle.md (BOOK_I-VIII XML)
      </agent_pool_loop>
    </TWO_LOOP_PACING>

    <CRON_OFFSETS>
      Both crons offset to never collide on the same minute. Cycle-completion-loop and other agents
      tucked into spare slots.
    </CRON_OFFSETS>

  </BOOK_V>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK VI: SUB-PROJECT FORBIDDEN (extends master BOOK_VII)
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_VI name="SUB_PROJECT_FORBIDDEN">

    <DO_NOT>
      ❌ Spawn sage during Phase B "to keep pipeline busy" → stale graph
      ❌ refresh_graph during Phase B → lake-lock contention, parent dies
      ❌ Wizard edits Basic.lean directly → race with other wizards (parent owns batch)
      ❌ Sage writes .lean → role bleeding
      ❌ Hard-code build job counts in prompts → drifts within hours
      ❌ sync_mode=True on refresh_graph → MCP stdio disconnect
      ❌ Reuse a star name from reserved list → identity collision
      ❌ Stretch goal targeting sister wizard's file → file conflict
      ❌ subprocess.PIPE for child emitting >1MB → parent OOM
      ❌ setsid + start_new_session=True → wrong pid recorded
      ❌ `lake exe dump_proof_steps` in single-process whole-tree mode →
         127GB RSS leak → WSL OOM-killed (2026-05-01 incident, kernel time 5336s).
         Each `processFile` call accumulates env mass + InfoTree pinning across
         files; no inter-file release. ALWAYS use `dump_ov2_per_file.py` (one
         `lake exe` per file, OS reclaims memory between). Mathlib top-N driver
         (`dump_mathlib_top_referenced.py`) is the same pattern. WSL has 160GB
         ceiling / 0 swap → no headroom for runaway in-process loops.
    </DO_NOT>

  </BOOK_VI>

  <!-- ═══════════════════════════════════════════════════════════════════════════════════════════════
       BOOK VII: REPOSITORY STRUCTURE + KEY REFERENCES
       ═══════════════════════════════════════════════════════════════════════════════════════════════ -->

  <BOOK_VII name="REPOSITORY_STRUCTURE">
    <TREE>
      PhysicsPapers/
        CLAUDE.md (this file, XML)
        IMPORTANT.md — post-capstone roadmap + forward vision
        README.md — public one-pager
        Main-Paper-Postulates.md — foundational postulates draft
        Complete-Omega-Theory-Unified-Framework.md — framework overview
        unified-theory-diagram.md — architecture diagram

        LeanFormalizationV2/
          CLAUDE.md — V2-specific agent onboarding
          STYLE_GUIDE.md — naming + proof governance
          OmegaTheory/  (211+ Lean files, 16 subdirs)
            Foundations/, Spacetime/, Geometry/, Emergence/ (132 files)
            Predictions/ (40 files), Conservation/, HealingFlow/, Torsion/
            Irrationality/, Variational/, Paper/, Meta/, Probe/
          notes/ (cycle memos + design memos)
          plans/ (active to-do + Grothendieck reports)
          .neo4j/ (Cypher ingest pipeline)
          .claude/agents/ (7 custom agents)

        OmegaTheoryAlgebra/ — V3-for-Lean / graph-algebra scaffolding
        V3-for-Lean/ — V3-for-Lean scripts + artefacts
        appendices/ — Appendix-A through Appendix-K + specials
        letter-coldneutron/ — PRL submission package
        papers/ — Paper-QM-From-Discrete-Gravity.md + DE-preview + KeyInsight
        submissions/qm-discrete-gravity/ — LaTeX bundle
        notes/ — top-level research notes
        research/ — STRATEGIC_FORMALIZATION_PLAN, GAUGE_THEORY, MATTER_SECTOR, etc.
        diagrams/ — figures, schematics
    </TREE>
  </BOOK_VII>

  <DOCTRINE_FINAL>
    Cross-ref ~/.claude/CLAUDE.md DOCTRINE_FINAL + chaos-shield/.claude/CLAUDE.md DOCTRINE_FINAL.
    The hunt is eternal. Pride at noon. Frontier mathematics + falsifiable physics in one substrate.
  </DOCTRINE_FINAL>

</OMEGATHEORY_PHYSICSPAPERS>
