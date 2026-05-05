// =====================================================================
// OmegaWizardLessons — high-value seed lessons across 6 of 10 clusters
//
// Loaded after bootstrap_wizard_lessons.cypher and wizard_lessons_recipes.cypher.
// Gives the first wizard fire under v4.4 doctrine immediate Phase 0 retrieval
// hits without falling back to .md files.
//
// All seeds carry confidence_pct in [85, 99] (verified-but-tunable) and are
// bi-temporal-current (invalid_at = NULL). Wizard provenance set to either
// 'OrchestratorBootstrap' or the original star whose work the lesson distills.
//
// To (re)load — IDEMPOTENT (after bootstrap + recipes):
//   docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
//     < .neo4j/wizard_lessons_seed.cypher
// =====================================================================

WITH [

  // ==== Doctrine cluster (3 entries) ====================================

  {cluster: 'Doctrine', kind: 'DoctrineRule', label_extra: 'DoctrineRule',
   name: 'doctrine_no_stubs',
   summary: 'NO STUBS rule: no `sorry`, no `Prop := True`, no `:= trivial`, no `: True := trivial`. User mandate verbatim 2026-04-27.',
   body: 'No `sorry`, no `Prop := True`, no `:= trivial` placeholders, no `: True := trivial` closure markers. Allowed: real theorems with real proofs, real Prop defs with non-trivial content, conditional theorems with NAMED real Prop hypotheses, honest noncomputable opaque {x : ℝ // 0 < x} via Classical.choice for physical constants. If a step is genuinely beyond current scope: prove it via real Mathlib API, defer the WHOLE file (do not ship partial), or reduce scope to what IS provable. NEVER stub. User mandate 2026-04-27: "No trivial, no true, no sorry, those are the rules".',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['stubs','sorry','soundness','user-mandate']
  },

  {cluster: 'Doctrine', kind: 'DoctrineRule', label_extra: 'DoctrineRule',
   name: 'doctrine_build_mathlib_machinery',
   summary: 'When Mathlib lacks an API the wizard needs, BUILD THE MACHINERY YOURSELF. Decompose into Lean-sized sub-lemmas + port from textbook line-by-line.',
   body: 'Mathlib upstream is NOT a blockade. Empirically validated: T-4 (π transcendence) was 14 hand-authored Lean files / ~3000 lines / single day. Pattern: web-search Mathlib HEAD repo for in-progress upstream PRs; port from textbook proofs verbatim (Pottmeyer DioApp.pdf, Hindry-Silverman, Schmidt LNM 785, Bombieri-Gubler, Lang) line-by-line; use auto-compact across long single-thread sessions; multi-day work permitted; 10k maxTurns covers 3-7 days of work. State (D) ARCHITECTURAL TRIAGE is RESERVED for: (i) STATEMENT literal-false (verdict B), (ii) TYPE-DISCREPANCY explicitly documented, (iii) genuinely beyond scope AFTER multi-day attempt with full ATTEMPT_LOG + multi-checkpoint progress record. NOT for early "Mathlib gap, defer to next wizard" exits.',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['mathlib-gap','machinery','textbook-port','no-defer']
  },

  {cluster: 'Doctrine', kind: 'DoctrineRule', label_extra: 'DoctrineRule',
   name: 'doctrine_parent_v4_5_anti_anxiety',
   summary: 'Parent v4.5 anti-anxiety: parent does NOT wrap up sessions preemptively; only A/B/C terminations; multi-day work permitted; auto-compact is a CHECKPOINT not a STOP-LOSS.',
   body: 'Anthropic official directive: "Your context window will be automatically compacted as it approaches its limit, allowing you to continue working INDEFINITELY from where you left off. Therefore, do not stop tasks early due to token budget concerns." Applies to PARENT and WIZARDS equally. State (D) and (E) exit doors REMOVED — only (A) landed / (B) verdict literal-false / (C) genuinely complete terminations. Empirical proof post-v4.5 (2026-05-02): wizards close hard targets (Pherkad 1151 lines; Atria 557 lines; Mimosa 446 lines first-try; Schedar Wave 39 σ-form Prop 4→2 primitives in 2 fires). Parent reads session-context memo + checkpoint memos to recover state across compaction.',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['v4.5','parent-discipline','auto-compact','termination-A-B-C']
  },

  // ==== MathlibAPI cluster (4 entries) ==================================

  {cluster: 'MathlibAPI', kind: 'MathlibFact', label_extra: 'MathlibFact',
   name: 'mathlib_v429_div_le_iff_zero_suffix',
   summary: 'Mathlib v4.29.0 renamed `div_le_iff` to `div_le_iff₀`. The non-zero-denominator hypothesis is in the name, not a separate parameter.',
   body: 'In Mathlib v4.29.0, division-comparison lemmas use the ₀ suffix to indicate the implicit non-zero hypothesis. Renamed in 2024-Q4. Affected names: `div_le_iff` → `div_le_iff₀`; `div_lt_iff` → `div_lt_iff₀`; `mul_div_cancel` → `mul_div_cancel₀` (now requires `ne_zero` hypothesis). Use `lean_loogle` or `lean_leansearch` to find renamed forms when a tactic fails with unknown_identifier.',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['mathlib-v4.29','rename','div','ne-zero']
  },

  {cluster: 'MathlibAPI', kind: 'MathlibFact', label_extra: 'MathlibFact',
   name: 'mathlib_v429_data_int_basic_removed',
   summary: '`Mathlib.Data.Int.Basic` was REMOVED in v4.29 — Int is in Lean core. Do not import the deleted module; use Lean core or a more specific Mathlib module.',
   body: 'In Mathlib v4.29.0, `Mathlib.Data.Int.Basic` was removed because Int now lives in Lean core (Init.Data.Int). Files importing it fail with "unknown module". Fix: drop the import (Int is available without it) OR import a specific module like `Mathlib.Data.Int.Defs` / `Mathlib.Data.Int.Order` / `Mathlib.Data.Int.GCD` for the API you need.',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['mathlib-v4.29','module-rename','int','core']
  },

  {cluster: 'MathlibAPI', kind: 'MathlibFact', label_extra: 'MathlibFact',
   name: 'mathlib_v429_finset_not_mem_empty',
   summary: '`Finset.mem_empty` does not exist in v4.29. Use `Finset.not_mem_empty` (negative form).',
   body: 'In Mathlib v4.29.0, the empty-membership lemma is `Finset.not_mem_empty : ∀ a, a ∉ (∅ : Finset α)`. The positive form `Finset.mem_empty` from older Mathlib does not exist. When a proof fails with unknown identifier, replace with the negation form and adjust surrounding logic.',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['mathlib-v4.29','finset','rename','negation']
  },

  {cluster: 'MathlibAPI', kind: 'MathlibFact', label_extra: 'MathlibFact',
   name: 'mathlib_v429_compute_degree_namespace',
   summary: '`compute_degree_le` is in `Mathlib.Tactic.ComputeDegree` namespace; `Polynomial.natDegree_C` is the public API for constants. Pair `compute_degree` with `norm_num` for `(1 : R) ≠ 0`.',
   body: 'For polynomial degree computation in v4.29: prefer `compute_degree` (open `Mathlib.Tactic.ComputeDegree`) over manual `Polynomial.natDegree_C`. The variant `compute_degree_le` lives in a private namespace; use the unprefixed `compute_degree` tactic. When the goal involves `1 ≠ 0` discharges (common for monic polynomials), pair with `norm_num` after `compute_degree` to close the side condition.',
   confidence: 95, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['mathlib-v4.29','polynomial','degree','tactic']
  },

  // ==== ProofComposition cluster (2 entries) ============================

  {cluster: 'ProofComposition', kind: 'Lesson', label_extra: 'Lesson',
   name: 'proof_5_phase_hybrid_composition',
   summary: '5-PHASE HYBRID composition: top-down statement → truth-rank → discharge per tier (99% first) → bottom-up filling → compose+review. Pólya + Tao + Hindry-Silverman canon.',
   body: 'Phase A: TOP-DOWN STATEMENT — state target with N NAMED Prop hypotheses Hᵢ. Phase B: TRUTH-RANK — sort {Hᵢ} by truth confidence: Tier-99 (≥99% true, routine) → Tier-80 (80-99%, medium) → Tier-Heart (<80%, analytical heart). Phase C: DISCHARGE PER TIER — Tier-99 via omega_hammer + exact?; Tier-80 via lean_loogle + aesop; Tier-Heart via web-search literature line-by-line. Phase D: BOTTOM-UP FILLING — when Hᵢ requires sub-machinery, build foundational pieces concretely (Fikhtenholz). Phase E: COMPOSE + REVIEW — Pólya step 4 looking-back; Yoneda bridge sweep via find_similar; axiom_audit Lean-core only. Why 99% first: cleanup wins build commit history + reveal what machinery the heart actually needs.',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['composition','top-down','named-prop','truth-rank','5-phase']
  },

  {cluster: 'ProofComposition', kind: 'Lesson', label_extra: 'Lesson',
   name: 'proof_bundled_lemma_file_pattern_a82',
   summary: 'BUNDLED-LEMMA-FILE pattern (arsenal A82): 3-5 sub-lemmas per file sharing namespace + imports + form yields ~22× throughput vs separate files.',
   body: 'When multiple ext sub-iterations share namespace + imports + form: bundle them in a single ~250-600 line file structured as sub-clusters A/B/C/D/E. Single namespace, all `open` siblings inline, ONE master headline at end aliases the bundle, real Nat bookkeeping for closure markers (NOT True := True.intro per NO STUBS). Throughput: ~22× vs separate files (single build invocation, single commit, single batch find_similar Yoneda sweep). Pattern empirically validated across T-5 Pottmeyer ladder, V8 capstone family, Yoneda bridge clusters. See feedback_lean4_proof_tactics_arsenal entry A82.',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['bundled-lemma-file','throughput','a82','arsenal']
  },

  // ==== LiteralFalseAuditing cluster (1 entry) ==========================

  {cluster: 'LiteralFalseAuditing', kind: 'AntiPattern', label_extra: 'AntiPattern',
   name: 'antipattern_literal_false_p_eq_1',
   summary: 'Audit checklist before discharging a NAMED Prop: P=1 escape (constant polynomial), q.den unbounded, ε→∞ vacuous, boundary-strict (≥0 vs >0). Catches literal-false NAMEDs in 30sec.',
   body: 'When a NAMED Prop appears too clean / too easy, audit BEFORE attempting discharge: (1) P=1 escape — does the statement hold trivially when the polynomial is constant? Often the case for "for all P : Polynomial ℝ" claims that should be "for all NON-CONSTANT P". (2) q.den unbounded — does the statement hold as q.den approaches infinity? Many Diophantine claims are vacuous in this limit. (3) ε → ∞ vacuous — does the statement degenerate when ε grows large enough? (4) Boundary-strict trap — `≥ 0` vs `> 0`: discharging the strict form when the non-strict was wanted (or vice versa) is a 1-character bug that wastes hours. Pattern empirically caught 4 literal-false NAMEDs in Wave 1-4 (2026-05-02) — each would have been ~6 days of failed Heart work. CHECKLIST IS MANDATORY before declaring a target "ready for discharge".',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['literal-false','named-prop','audit-checklist','vacuous']
  },

  // ==== BuildHygiene cluster (2 entries) ================================

  {cluster: 'BuildHygiene', kind: 'Lesson', label_extra: 'Lesson',
   name: 'build_lean_v2_native_mirror_pattern',
   summary: 'Iterate at ~/lean-v2 (native ext4, 115× faster single-file builds). Mirror to /mnt/c on green. md5sum verify before declaring done.',
   body: 'Build hygiene: ~/lean-v2/ is the WSL2-native ext4 mirror — 115× faster `lake build` for single-file iteration vs the /mnt/c mountpoint. Workflow: edit in ~/lean-v2, run `~/.elan/bin/lake build OmegaTheory.<Module> --log-level=error`; on green, `cp` to /mnt/c/.../LeanFormalizationV2/<same-path>; verify `md5sum <native> <mirror>` match before reporting done. Native build invocation NEVER uses `wsl.exe` wrapper — this session is INSIDE WSL already. Commit happens at /mnt/c (committed tree).',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['build','lean-v2','mirror','md5','115x']
  },

  {cluster: 'BuildHygiene', kind: 'Lesson', label_extra: 'Lesson',
   name: 'build_lake_update_vs_build',
   summary: '`lake update` ONLY when changing Mathlib version or adding deps in lakefile.toml. `lake build` for everything else. Always `lake exe cache get` after update.',
   body: 'Lake build commands: `lake update` rebuilds the Mathlib dependency tree from scratch — ONLY do this when changing Mathlib version OR adding deps in `lakefile.toml`. Always run `lake exe cache get` immediately afterward to fetch precompiled olean cache. For everything else (new imports, edits, fixing proofs): `lake build` only. Running `lake update` unnecessarily can take 30-60 minutes and may pull in incompatible upstream changes.',
   confidence: 99, wave: 'BOOTSTRAP', wizard: 'OrchestratorBootstrap',
   tags: ['build','lake','update','cache']
  },

  // ==== AnalyticBounds cluster (1 :ProofPattern from Schedar Wave 39) ===

  {cluster: 'AnalyticBounds', kind: 'ProofPattern', label_extra: 'ProofPattern',
   name: 'pattern_t5_sigma_form_3_regime_decomposition',
   summary: 'T-5 σ-form Prop closure via 3-regime decomposition: (R1 aeval≠0 UNCONDITIONAL via D-pre-aux1) ∧ (R2 trivial regime UNCONDITIONAL via TRR-1) ∧ (R3 small-σ Type-(b) self-reduction). Schedar Wave 39 reduced 4→2 primitives.',
   body: 'σ-form Prop FULL UNCONDITIONAL closure pattern (Pottmeyer 3.4.1 m → m+1): split via aeval case-split. Regime 1 (aeval ≠ 0): D-pre-aux1 contrapositive ONE LINE via T5_rothIndex_eq_zero_of_disj — UNCONDITIONAL. Regime 2 (trivial regime + in-box witness): TRR-1 + UWF-2 universal witness — UNCONDITIONAL. Regime 3 (small-σ): STRUCTURAL UNCONDITIONAL via Schedar Wave 39 (9 paper-citable HEADLINEs / ~60 UNCONDITIONAL theorems / quadruple TARGET α+β+γ+δ via Alkaid+ATRIA composition + multiIteratedPDeriv composition primitive + per-deriv bound Eq. 3.24 UNCONDITIONAL). Two multi-day primitives remain: (3.22) UB primitive (Wronskian + IH + Lemma 3.4.3 chain) and PHE-23 (shiftPoly degreeOf preservation, Mathlib v4.29 gap). Closes T-5 atom-1 in 1-2 days post-Schedar continuation.',
   confidence: 95, wave: 'WAVE-39', wizard: 'Schedar',
   tags: ['t-5','sigma-form','pottmeyer-3-4-1','three-regime','schedar','wave-39']
  }

] AS seeds

UNWIND seeds AS s
MATCH (cluster:LessonClusterNavigator {namespace:'OmegaWizardLessons', name: s.cluster})
CALL apoc.merge.node(
  ['WizardLeaf', s.label_extra],
  {namespace: 'OmegaWizardLessons', name: s.name},
  {
    kind: s.kind,
    summary: s.summary,
    body: s.body,
    wizard: s.wizard,
    wave: s.wave,
    tags: s.tags,
    confidence_pct: s.confidence,
    fire_count: 0,
    fire_success_count: 0,
    reference_count: 0,
    created_at: datetime(),
    last_referenced_at: datetime(),
    valid_at: datetime(),
    invalid_at: NULL,
    expired_at: NULL
  },
  {last_referenced_at: datetime()}
) YIELD node AS leaf

MERGE (cluster)-[:CONTAINS]->(leaf)
WITH leaf, s

MATCH (w:Wizard {namespace:'OmegaWizardLessons', star_name: s.wizard})
MERGE (w)-[:AUTHORED]->(leaf)
WITH leaf

RETURN leaf.name AS persisted ORDER BY persisted;
