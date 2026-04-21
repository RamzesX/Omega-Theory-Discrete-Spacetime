# Submission package — Omega-Theory V2 QM Bridge

This directory contains a submission-ready package for the paper
**"Rigorous Machine-Checked Derivation of Non-Relativistic Quantum
Mechanics from Discrete-Gravity Healing Dynamics"**, converted from
the source `../PAPER_DRAFT.md`.

## Files

| File | Role |
|---|---|
| `main.tex` | Full long-form manuscript (Foundations of Physics / arXiv). ~50 pp at 11pt, one-sided, one-and-a-half spaced. |
| `letter.tex` | Compressed 4-page PRL letter (revtex4-2). |
| `cover_letter.tex` | Editor cover letter: novelty, differentiator, anticipated reviewer objections, priority claim. |
| `refs.bib` | BibTeX: Kulkarni 2026, 't Hooft, Wolfram, Adler trace dynamics, Bell/CHSH/Tsirelson, Aspect/Hensen/Giustina, Schrödinger/Born/Heisenberg/Robertson, Lean 4 + Mathlib, PhysLean, HPW, repo-internal notes. |
| `README_SUBMISSION.md` | This file. |

None of the files modify `PAPER_DRAFT.md`, any `.lean` file, or any
file outside this directory.

## Compile instructions

**Required tools:** `pdflatex`, `bibtex`, `revtex4-2` (only for the
PRL letter). The `listings` package is used to typeset Lean 4 code;
`minted` is *not* required, so no `--shell-escape` is needed.

### Long form (`main.tex`)

```bash
pdflatex main.tex
bibtex   main
pdflatex main.tex
pdflatex main.tex
```

### PRL letter (`letter.tex`)

```bash
pdflatex letter.tex
bibtex   letter
pdflatex letter.tex
pdflatex letter.tex
```

### Cover letter (`cover_letter.tex`)

Plain `letter` class; no bibliography.

```bash
pdflatex cover_letter.tex
```

## If compile fails

1. **`revtex4-2` not installed** → only affects `letter.tex`. Either
   install a TeX Live distribution that includes REVTeX
   (`tlmgr install revtex4-2`) or substitute
   `\documentclass[aps,prl,...]{revtex4-2}` with
   `\documentclass[twocolumn,10pt]{article}` + `\usepackage{abstract}`
   and strip the `\affiliation{...}` lines. The PRL-specific features
   used are limited to the two-column layout and the author-affiliation
   block; the content compiles as plain `article` with minimal surgery.
2. **`listings` Unicode errors** → the `listings` literate table in
   both `main.tex` and `letter.tex` maps Unicode math characters
   (`α`, `β`, `ℏ`, etc.) to LaTeX math. If a Lean excerpt contains a
   character not in the literate table, add a new `literate={χ}{...}`
   entry or replace the character with its ASCII equivalent in the
   listing.
3. **`hyperref` + `cleveref` conflict** → ensure `hyperref` is loaded
   before `cleveref` (already done).
4. **Long tables overflow** → the `longtable` package handles
   page-breaking for the hypothesis-inventory tables. If a table is
   squeezed, widen its first column in the `p{...}` spec inside the
   `\begin{longtable}{...}` preamble.
5. **`pdflatex` runs out of stack on the literate table** → known
   issue with very old pdfTeX versions. Upgrade to pdfTeX ≥ 1.40.22
   (any TeX Live 2021 or later).
6. **BibTeX warnings about missing fields** → only the default
   `plain` / `apsrev4-2` styles are used; if a field is genuinely
   missing, the entry will still print correctly with a fallback
   ordering. No fatal errors are expected.

## Where to submit

### arXiv preprint (recommended immediately)

- Category: `quant-ph` (primary), `gr-qc` (cross-list),
  `math.LO` (secondary, for the Lean-formalisation angle).
- Upload `main.tex` + `refs.bib` + any supplementary figures. Build
  artefacts (`*.aux`, `*.bbl`, `*.blg`, `*.log`, `*.out`, `*.toc`)
  should NOT be included.
- Title and abstract in the arXiv form match the manuscript.
- Comment field: `X pages, 0 figures; Lean 4 source published at ...`
  (update with the eventual repository DOI / Zenodo record at
  submission time).

### Foundations of Physics (long form)

- Submission portal: `https://editorialmanager.com/fopl`.
- Article type: **Original Research**.
- Use `main.tex` + `refs.bib`. The FoP house style accepts
  `article`-class submissions with bibtex bibliographies.
- Include `cover_letter.tex` (compiled to PDF) in the cover-letter
  field.

### Physical Review Letters (4-page letter)

- Submission portal: `https://journals.aps.org/prl/`.
- Article type: **Letter**.
- Use `letter.tex` + `refs.bib`. Must compile cleanly in REVTeX 4.2
  (check the PRL page-budget meter on the submission page).
- Include `cover_letter.tex` (compiled to PDF) in the cover-letter
  field; adjust the opening salutation accordingly.
- PRL requires ≤ 4 journal pages; use the page-budget meter to
  confirm before submission.

### Journal of Mathematical Physics (fallback)

- Submission portal: `https://aip.scitation.org/journal/jmp`.
- Long form compatible; use `main.tex`. The house style is
  `aipauth4-2`; convert the title / author block if needed (no
  content change required).

## Manuscript-prep checklist

Before submission to any venue, the following items must be resolved.
Each is a blocker; none is blocked by a remaining theorem
(the paper is complete as of 2026-04-15).

- [ ] Insert the commit hash of the Lean source at the bottom of
      `main.tex` (line "Source tree:" in the status block) and in
      the `OmegaTheoryV2Source` bibtex entry.
- [ ] Replace the `*_prover` / `probability_conservator` /
      `interference_prover` / `measurement_prover` /
      `entanglement_architect` `[pending]` placeholders in the
      Acknowledgments with final display names once agents have
      chosen them. Verify that `Bellatrix` is used consistently for
      the Heisenberg agent (the draft already reflects this).
- [ ] Complete the References section of the long form. The `refs.bib`
      here is authoritative; `main.tex` cites by BibTeX key only. Make
      sure every `\cite{...}` in `main.tex` resolves against `refs.bib`
      (run `bibtex main` and check `main.blg` for missing citations).
- [ ] Confirm that the PRL letter fits within 4 pages once the final
      bibliography is rendered. If it overruns, compress Section~4
      ("The seven pillars") by dropping per-theorem prose and using
      only the `\paragraph{Tk.}` summaries with a single-line Lean
      wrapper name.
- [ ] Add a figure of the two-slit interference pattern (optional but
      recommended for PRL). The cleanest option is a 2D plot of
      $4A^{2}\cos^{2}(\Delta\varphi/2)$ sampled on the lattice, with
      bright and dark fringes labelled. No figure is present in the
      draft; it is the only content-level addition that needs design
      rather than translation.
- [ ] Verify arXiv classification codes are current (as of 2026-04,
      `quant-ph` primary + `gr-qc` cross-list is correct; check
      before submission in case codes change).
- [ ] Ensure `pdflatex` final-pass output for both `main.pdf` and
      `letter.pdf` contains zero `overfull hbox` / `underfull hbox`
      warnings. If present, either rewrap the paragraph or ignore if
      the overflow is <10pt (standard in revtex double-column).
- [ ] Before submitting to PRL: compile against actual
      `revtex4-2.cls`; the submission meter will not accept the
      fallback `article` class.
- [ ] Cover letter: replace the generic greeting
      (`The Editors / Foundations of Physics / ...`) with the
      specific journal's editor and venue before sending.
- [ ] Double-check the "To the authors' knowledge" wording in each
      priority claim: the phrase must be preserved verbatim. `grep
      -n "authors' knowledge" main.tex` should return hits only at
      the intended priority-claim sections (§1, §5.6, §6.5, §7
      interpretation, §8, §9, §10, §11, capstone §12) --- never
      silent.

## Faithful-translation notes

The following markdown-to-LaTeX translations deserve explicit
acknowledgement so reviewers / future authors can audit them:

- Every hypothesis-inventory table in `PAPER_DRAFT.md`
  (§5.2, §6.3, §9.4, §10.4, §11.8) is translated to a
  `longtable` in `main.tex` preserving the same fields. No hypothesis
  was silently dropped.
- Lean code blocks are preserved verbatim except for Unicode
  characters that pass through the `listings` literate table. Any
  character not in the table has been ASCII-substituted and flagged
  inline.
- Every `paper_*` theorem name used in the manuscript has been
  cross-verified against `OmegaTheory/Emergence/QmBridgePaper.lean`
  (41 wrapper theorems, verified as of 2026-04-15) and
  `OmegaTheory/Emergence/QuantumMechanicsCapstone.lean` (5 capstone
  theorems).
- The "honest scope" paragraphs in §5.3, §9.3, §10.5, and §13
  are preserved verbatim; no hedging was added or removed.
- The acknowledgments section lists every contributing agent with
  their Lean file and headline theorems, matching
  `PAPER_DRAFT.md` §14 one-to-one.

## Version and dependencies

- **Lean 4 toolchain**: `lean-toolchain` specifies `leanprover/lean4:v4.29.0`.
- **Mathlib**: v4.29 (pinned in `lake-manifest.json`).
- **TeX distribution**: TeX Live 2023+ / MiKTeX 23.10+ recommended.
- **PDF output target**: PDF/A-2b (for long-term archiving; check
  with arXiv's upload form before submission).

---

Last updated: 2026-04-15. Prepared by `paper_polisher`
(coordination handle; display name pending) on team
`omega_legendary_v2`.
