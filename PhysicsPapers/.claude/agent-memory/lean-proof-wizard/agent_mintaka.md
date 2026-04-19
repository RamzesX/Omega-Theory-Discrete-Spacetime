---
name: Agent identity — Mintaka
description: Took Mintaka name 2026-04-19; Ingredient F — C⁴ bound on convolution interpolant in WhitneyInterpolant.lean; 3 private helpers + main thm + glue ∀-variant; GREEN 3629 jobs
type: project
---

**Agent name:** Mintaka (taken 2026-04-19)

**Star rationale:** Mintaka is the westernmost of Orion's three belt stars. With Rigel (foot) and Saiph (knee) already claimed in this project, Mintaka (belt) fits the Orion cohort.

**Mission:** Ingredient F of HPW elimination chain — uniform C⁴ bound on the convolution interpolant.

**Deliverable** — `~/lean-v2/OmegaTheory/Emergence/WhitneyInterpolant.lean` (and mirror in LeanFormalizationV2):

1. `mollifierArg_eq_smul_sub` (private) — rewrites `mollifierArg x p = l_P⁻¹ • x - p_vec`.
2. `iteratedFDeriv_const_mul_scalar` (private) — `‖iteratedFDeriv 4 (c * f) x‖ = |c| * ‖iteratedFDeriv 4 f x‖`.
3. `iteratedFDeriv_phi_mollifierArg` (private) — chain rule: `iteratedFDeriv 4 (m.phi ∘ mollifierArg(·,p)) x = l_P⁻¹^4 • iteratedFDeriv 4 m.phi (mollifierArg x p)`. Uses `iteratedFDeriv_comp_const_smul` + `iteratedFDeriv_comp_sub`.
4. `convolutionTerm_c4_bound` (private) — per-term bound `‖iteratedFDeriv 4 (convolutionTerm ...) x‖ ≤ B * M_phi / l_P^4`.
5. `convolutionFixedBox_c4_bound` — main result. Uses `iteratedFDeriv_sum_apply` + `norm_sum_le` + `Finset.sum_le_sum` + `Finset.sum_const`.
6. `convolutionFixedBox_c4_bound_forall` — ∀-quantified glue.

**Build result:** GREEN, 3629 jobs, 0 sorry, 0 new axioms.

**Key Mathlib lemmas used (all Cypher-verified before use):**
- `iteratedFDeriv_sum_apply` (`Mathlib.Analysis.Calculus.ContDiff.Operations`)
- `iteratedFDeriv_const_smul_apply'` (`Mathlib.Analysis.Calculus.ContDiff.Operations`)
- `iteratedFDeriv_comp_const_smul` (`Mathlib.Analysis.Calculus.ContDiff.Operations`)
- `iteratedFDeriv_comp_sub` (`Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries`)
- `norm_sum_le` (`Mathlib.Analysis.Normed.Group.Basic`)
- `Finset.sum_le_sum`, `Finset.sum_const`, `Finset.sum_apply`

**Subtleties / traps avoided:**
1. `iteratedFDeriv_sum_apply` expects `(∑ j ∈ u, f j) x`, not the eta-expanded `fun x ↦ ∑ j ∈ u, f j x` — needed `Finset.sum_apply` bridge.
2. `field_simp; ring` timed out on simple divisional identity; `rw [div_eq_iff, sub_mul, mul_comm, mul_assoc, inv_mul_cancel₀, mul_one]` worked manually.
3. Splitting the per-term bound into `convolutionTerm_c4_bound` private helper avoided heartbeat timeout in main theorem.
4. Had to use `change` not `show` to avoid a linter warning (kept it anyway — `show` works fine).
5. The `.le` projection on a `Prop`-level `≤` doesn't exist; `linarith [heq]` is the correct finish.

**Lines added:** ~192 (file 375→567).

**Mirror copied to:** `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/OmegaTheory/Emergence/WhitneyInterpolant.lean` via `cp -p` 2026-04-19.
