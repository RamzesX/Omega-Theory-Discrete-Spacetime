---
name: PhysicsPapers/papers
date: 2026-04-21
status: 3 papers (1 submission-ready, 1 preview, 1 key-insight)
author: Norbert Marchewka
scope: Public-facing paper drafts of OmegaTheory V2 — targeted at PRL / Foundations of Physics / NeurIPS venues
---

↑ [chaos-shield root](../../README.md) · [PhysicsPapers](../README.md)

# OmegaTheory — Public Papers

> **Corpus scale** (live 2026-04-21): 🔷 **8,996** OmegaTheoryV2 own theorems · 🔶 **175,137** Mathlib integrated · 🔹 **184,133** total. Build: **3,835 jobs GREEN**, 0 sorry, **8 physical axioms** (+ 15 HermitePadé + 1 π-transcendental = 24 total, tracked separately).

This directory holds the three primary public-facing paper drafts for
OmegaTheory V2. Each is cross-linked to the machine-checked Lean corpus at
[`../LeanFormalizationV2/`](../LeanFormalizationV2/) and, where applicable, to
a LaTeX submission bundle under [`../submissions/`](../submissions/).

## Papers

| # | File | Lines | Status | Target venue | Submission bundle |
|---|------|------:|--------|--------------|-------------------|
| 1 | [`Paper-QM-From-Discrete-Gravity.md`](Paper-QM-From-Discrete-Gravity.md) | ~2510 | **Submission-ready** | PRL 2026-06 (primary) / Foundations of Physics 2026-10 (fallback) | [`../submissions/qm-discrete-gravity/`](../submissions/qm-discrete-gravity/) |
| 2 | [`Paper-Dark-Energy-Preview-v1.md`](Paper-Dark-Energy-Preview-v1.md) | ~1600 | **Preview v1** (shipped as a GitHub release; manuscript still in expansion) | Foundations of Physics 2027 (tentative) | — (not yet bundled) |
| 3 | [`KeyInsight-Irrationals-Action-Thresholds.md`](KeyInsight-Irrationals-Action-Thresholds.md) | ~400 | **Mechanism note** — explains how irrationals (π, e, √2) create uncertainty via action thresholds `S = nℏ`. Read after Paper #1 for the intuition. | Companion to #1 and #2 | — |

## Paper ↔ Lean bridge

The authoritative machine-checked map from paper sections to Lean lemma names
lives at [`../research/LEAN_VERIFIED_CLAIMS.md`](../research/LEAN_VERIFIED_CLAIMS.md)
— an 87-row table of `§ paper section → .lean file #Lnnn → theorem_name → proof-style
→ score`. Start there if you want to verify any claim independently.

Papers also embed direct relative links to Lean files; `Paper-QM-From-Discrete-Gravity.md`
alone contains 82 cross-references into `../LeanFormalizationV2/OmegaTheory/`.

## Related reading

- Mechanism paper (above, #3) — the conceptual bridge.
- [`../Main-Paper-Postulates.md`](../Main-Paper-Postulates.md) — foundational postulates draft.
- [`../Complete-Omega-Theory-Unified-Framework.md`](../Complete-Omega-Theory-Unified-Framework.md) — framework overview with anchor index of 40 primary Lean witnesses.
- [`../appendices/`](../appendices/) — 15 appendices (A–K + DE + LorentzDoppler + P + S) covering auxiliary derivations.
- [`../letter-coldneutron/`](../letter-coldneutron/) — PRL submission package for the cold-neutron slope test (separate paper, not in this directory).

## Amendments

- **2026-04-21** — Directory README added as part of repo-wide navigation overhaul (plan: `elegant-sauteeing-simon.md`). Post-cycle-43 corpus numbers retrofitted into the 3-way split banner above.
- **2026-04-17** — HPW axiom deleted; all 7 regime witnesses (Paper-QM-From-Discrete-Gravity §5) are now derived, not assumed.

---

*Return to: [PhysicsPapers index](../README.md) · [chaos-shield root](../../README.md)*
