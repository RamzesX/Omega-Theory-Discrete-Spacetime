# V3-for-Lean — Achievements (as of 2026-04-21)

Research memos + paper draft material for the V3-for-Lean submission.
Complements the design docs in `../OmegaTheoryAlgebra/`.

## Research memos (5 × ~30 KB each)

| Memo | Content | Status |
|---|---|---|
| `theorem_gap_hunter_design.md` | Hunter agent design for finding open theorems in the graph | Design complete, agent not yet realized |
| `proof_hunter_design_v2.md` | Evolved hunter design leveraging `:TheoremCandidate` nodes | Design complete |
| `mass_c_photon_bridge_memo.md` | Research on photon mass / c bridge (intermediate regime) — 5 candidates | Research memo (Mintaka) |
| `proton_critical_phases_memo.md` | Proton mass critical-phase analysis + 7 photon-electron boundary candidates | Research memo (Alkaid) |
| `substrate_exchange_deep_dive.md` | Deep dive on substrate exchange mechanisms (4 user questions) | Research memo (Alnair) |

## Paper skeleton (Team-E deliverable, 2026-04-21)

| File | Status | Content |
|---|---|---|
| `00_abstract.md` | **NEW** | 300-word abstract ready for submission (NeurIPS 2026 Math-AI / ICLR 2027 / Foundations of Physics) |
| `01_intro.md` | **NEW** | OmegaTheory V2 context + V3 framework + five contributions (C1–C5) |
| `02_related_work.md` | **NEW** | Four literatures: neural premise selection / conjecturing / graph-based retrieval / algebraic-spectral + V3 origin |
| `03_method_algebra.md` | **NEW** | `LeanAlgebra` schema: 6 entities × 15 arrows × 7 rules × 12 compositions × Magnetic Laplacian + Leiden fibration claim |
| `04_method_embeddings.md` | planned | Qwen3-8B BF16 (4096-d) + LeanDojo ByT5 (1472-d) substitution for Lean-Finder |
| `05_method_consumer.md` | planned | Erdős-tier SubsystemNavigator enrichment (top-14 macro-subsystems) |
| `06_experiments.md` | planned | MiniF2F-v2 + OmegaTheory-held-out + baseline comparison vs Magnushammer / Nazrin |
| `07_canary_einstein.md` | planned | `einstein_tensor_emergence` 172 → <100 lines target |
| `08_discussion.md` | planned | Failure modes, open questions, Catalan-$G$ sterile-$\nu$ pathway |
| `references.bib` | planned | BibTeX compilation |

## Subdirs

- `agents/` — directory reserved for `HypatiaIndexingAgent_V3_Lean.xml`
  (Lean-adapted indexing agent spec)
- `benchmark/` — will hold `run_minif2f.py` + `run_omega_heldout.py` + result CSVs
- `code/`
  - `cypher_recipes/semantic_arrows_v1.cypher` — SPECIALIZES / GENERALIZES / REWRITES_BY extraction (Sirius, 2026-04-19)
  - `cypher_recipes/subsystem_hub_shannon_entropy_v1.cypher` — hub-entropy enrichment
  - `lean_metaprograms/DumpDeclarations.lean` — env declaration dumper (Schedar)
  - `lean_metaprograms/DumpArrows.lean` — 12-arrow typed env extractor (Sheratan)
  - `servers/qwen3_embedding_server.py` — Qwen3-8B BF16 :7999
  - `servers/bge_reranker_cpu_server.py` — CPU reranker
  - `servers/reembed_omega_qwen3_v2.py` — delta re-embedder
- `figures/` — reserved for `laplacian_spectrum.pdf`, `subsystem_detection.pdf`

## Key cycle-43 headline findings

1. **Grand Capstone**. Cycle 43 (Polaris) delivered `omega_theory_v2_final_meta_capstone` — a single Lean proposition that equals the paper abstract: QM, GR, $U(1)\times SU(2)\times SU(3)$, dark energy $w=-1$, Bell nonlocality, path integrals from 8 constants on $\ell_P\cdot\mathbb{Z}^4$. Build: $3{,}835$ jobs GREEN, $8{,}996$ theorems, $0$ `sorry`, $8$ axioms.
2. **Magnetic Laplacian first empirical**: $\lambda_1/\lambda_2 = 1.038$ — first machine-proved non-abelian signal in a theorem-prover corpus. Non-commutativity $73.3\%$ across $15$ arrow types.
3. **Fibered 4-channel structure** (Navi / $\gamma$ Cassiopeiae, cycle 43+). Leiden at $\gamma = 0.5$: $Q = 0.89$, $116$ communities, **no 4-band gap**. Channel-wise FastRP norm ordering $\|v_\pi\|^2 > \|v_G\|^2 > \|v_{\sqrt{2}}\|^2$ matches Pi-Hunch residual ordering. This is the paper's key empirical claim.
4. **23 predicted theorem candidates** (Navi MP-1 through MP-8): 12 FastRP bridges between under-connected Leiden pairs + 7 missing left/right dual fermion doublets + 4 Pi-Hunch frontier statements (tightness, saturation, uniqueness, stability).
5. **Catalan-$G$ 4th-irrational channel** (post-capstone). $29$ theorems already carry a `catalan` / `sterile` keyword in their name; the Pi-Hunch extends to a 4-way ordering $\pi > e > G > \sqrt{2}$.
6. **$m_\mu/m_e = \lambda_{\sqrt{2}}/\lambda_e$** matches PDG to $0.14\%$ (Avior cycle 30, Rigel Kentaurus confirmation, cycles 30–32). Higgs VEV cancels in substrate mass ratios — pure irrationality residual.
7. **12-order fermion hierarchy** from $\alpha=4/7$ (leptons) / $3/7$ (quarks) Nashira kernel (Homam, cycle 35).
8. **9-cycle $N=4$ consistency** (cycles 17/24/25/27/28/29/30/31/33/34/35) — same $\ell_P\cdot\mathbb{Z}^4$ budget works across all observables.
9. **BH info paradox three-channel resolution** (Electra, cycle 37): $I_{\text{initial}} = I_{\text{Hawking}} + I_{\text{baby}} + 0$.

## Navi's artefacts (2026-04-21, cycle 43+)

- `OmegaTheoryAlgebra/GROTHENDIECK_MATH_PUZZLE.md` ($969$ lines, 8/8 MP-$k$ passes, 23 predicted-bridge TheoremCandidates)
- `:GraphFinding` nodes (7 new): `omegatheory_categorical_signature_navi`, `omegatheory_homological_signature_navi`, `connes_vocabulary_adoption_profile_navi`, `kempf_bandlimit_pathway_completion_navi`, `four_irrational_spectral_partition_navi`, `fastrp_bridge_prediction_navi`, `dual_pair_gaps_navi`, `pi_hunch_frontier_navi`
- `:GrothendieckRecipe` entries for each MP-$k$ computation
- `navi_community` property on $11{,}921$ nodes (Leiden $\gamma=0.5$ membership)
- `:ReservedName {name:'Navi'}` node

## Target venues

| Venue | Deadline | Status |
|---|---|---|
| **NeurIPS 2026 Math-AI workshop** | Aug 2026 | V3-for-Lean methodology paper (primary) |
| ICLR 2027 | Oct 2026 | Backup if NeurIPS rejects |
| **Physical Review Letters** (4-page) | 2026-06 | Abstract + substrate EM+mass ratio focus (companion) |
| **Foundations of Physics** (long-form) | 2026-10 | Full 60-theorem cycle-24-43 walkthrough (companion) |

## Open (cycles 44-60+)

See `~/papers/V3-for-Lean/` (local) or `../LeanFormalizationV2/plans/` for:
- 40+ SPECULATIVE `:GraphFinding` nodes waiting to be promoted to theorems
- 23 Navi-predicted `:TheoremCandidate` from the Grothendieck Math Puzzle
- 144 `:TheoremCandidate` across the whole frontier (cf. `LeanFormalizationV2/plans/THEOREM_BACKLOG_CYCLES_24_43.md`)
- 44 paper-worthy `:GraphFinding` nodes
- Cycles 44-60 roadmap driven by cycle-memo speculations (Catalan-G sterile-$\nu$ mass derivation, Kempf $\beta/\gamma/\delta$ pathways, DESI evolving-$w$ response, GW multi-band parent-BH discriminator, etc.)
