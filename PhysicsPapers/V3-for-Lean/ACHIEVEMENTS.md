# V3-for-Lean — Achievements (as of 2026-04-21)

Research memos + paper draft material for the V3-for-Lean submission. Complements the design docs in `../OmegaTheoryAlgebra/`.

## Research memos (5 × ~30 KB each)

| Memo | Content | Status |
|---|---|---|
| `theorem_gap_hunter_design.md` | Hunter agent design for finding open theorems in the graph | Design complete, agent not yet realized |
| `proof_hunter_design_v2.md` | Evolved hunter design leveraging `:TheoremCandidate` nodes | Design complete |
| `mass_c_photon_bridge_memo.md` | Research on photon mass / c bridge (intermediate regime) | Research memo |
| `proton_critical_phases_memo.md` | Proton mass critical-phase analysis | Research memo |
| `substrate_exchange_deep_dive.md` | Deep dive on substrate exchange mechanisms (4 user questions) | Research memo |

## Subdirs

- `agents/` — `HypatiaIndexingAgent_V3_Lean.xml` (Lean-adapted indexing agent spec)
- `benchmark/` — `run_minif2f.py` + `run_omega_heldout.py` + result CSVs (stub)
- `code/` — reference code including `reembed_omega_qwen3_v2.py`
- `figures/` — (planned: laplacian_spectrum.pdf, subsystem_detection.pdf)

## Paper structure (from Pollux cycle-43 closing memo)

```
V3-for-Lean v1.1
├── 00_abstract.md          (300 words, headline = Magnetic Laplacian + Leiden on 9k-theorem corpus)
├── 01_intro.md             (Pi Hunch + 8 constants + OmegaTheory V2 context)
├── 02_related_work.md      (arXiv 2510.23637 graph-augmented Lean retrieval, Lean-Finder 2510.15940, LeanAgent ICLR 2025)
├── 03_method_algebra.md    (Hypatia for Lean — 6 entity / 15 arrow schema)
├── 04_method_embeddings.md (Qwen3-8B 4096d substitution for Lean-Finder)
├── 05_method_consumer.md   (Erdős-tier SubsystemNavigator enrichment)
├── 06_experiments.md       (MiniF2F-v2 + OmegaTheory held-out)
├── 07_canary_einstein.md   (einstein_tensor_emergence 172 → <100 lines target)
├── 08_discussion.md
└── references.bib
```

## Headline findings (from cycles 24-43)

1. **Magnetic Laplacian first empirical**: λ₁/λ₂ = 1.038, non-commutativity 73.3% → OmegaTheory substrate is provably non-abelian at the theorem-graph level (Alt-A paper narrative)
2. **m_μ/m_e = λ_√2/λ_e exact identity** (Avior cycle 30) + **0.14% PDG match** (Rigel Kentaurus): Higgs VEV cancels in substrate mass ratios → pure irrationality-residual number
3. **12-order fermion hierarchy** from α=4/7 (leptons) / 3/7 (quarks) Nashira kernel (Homam cycle 35)
4. **9-cycle N=4 consistency** (cycles 17/24/25/27/28/29/30/31/33/34/35) — same ℤ⁴ lattice budget works across all observables
5. **BH info paradox three-channel resolution** (Electra cycle 37): I_initial = I_Hawking + I_baby + 0
6. **`omega_theory_v2_final_meta_capstone`** (Polaris cycle 43) — single Lean proposition = the paper abstract

## Target venues

| Venue | Deadline | Status |
|---|---|---|
| **Physical Review Letters** (4-page) | 2026-06 | Abstract + substrate EM+mass ratio focus |
| **Foundations of Physics** (long-form) | 2026-10 | Full 60-theorem cycle-24-43 walkthrough |
| NeurIPS 2026 (Math-AI workshop) | Aug 2026 | V3-for-Lean methodology paper |
| ICLR 2027 | Oct 2026 | Backup if NeurIPS rejects |

## Open (cycles 44-60+)

See `~/papers/V3-for-Lean/` (local) or `../LeanFormalizationV2/plans/` for:
- 40+ SPECULATIVE `:GraphFinding` nodes waiting to be promoted to theorems
- Cycles 44-60 roadmap driven by cycle-memo speculations (Catalan-G sterile-ν mass derivation, Kempf β/γ/δ pathways, DESI evolving-w response, GW multi-band parent-BH discriminator, etc.)
