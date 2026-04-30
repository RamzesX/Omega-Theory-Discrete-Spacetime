/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A6_HighIndexVanish

  T-5 (Roth's theorem) — **SJWC-1 sub-lemma A6: high-index vanishing
  derivative at α-diagonal**.

  Single-thread hand-authored 2026-04-30 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Sub-lemma **A6** of the SJWC-1 (Schmidt-Jordan-Wirsing Composition #1)
  HEART decomposition of T-5.  The lemma states:

      if rothIndex of P at the α-diagonal point ≥ t,
      then any multi-index J with weighted sum < t
      has VANISHING aeval (multiIteratedPDeriv J P) at the α-diagonal.

  This is a thin bridge over the existing D-pre-aux6 lemma
  (`T5_rothIndex_lower_bound_implies_subthreshold_vanish`) — the
  Block-D contrapositive of the rothIndex definition.  We just
  re-package it for the SJWC-1 caller signature:

  - Specialize the ambient α-vector to the diagonal (`fun _ => α`).
  - Switch from `n` to `m` (caller name).
  - Switch from `d` to `R` (caller name).
  - Carry an unused `hR_pos : ∀ i, 0 < R i` for compositional
    convenience (downstream SJWC-1 callers need positivity of R
    in the next step; threading it through here keeps the call site
    clean — see SJWC-1 master composition plan).
  - Convert `≥ t` to `t ≤ ...` (defeq).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish
import Mathlib.Algebra.MvPolynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A6_HighIndexVanish

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

/-! ## A6 — High-index vanish at α-diagonal -/

/-- **SJWC-1 A6 — `T5_SJWC1_A6_high_index_vanish`**: high-index ⇒
    vanish, specialised to the α-diagonal point of the SJWC-1
    composition.

    Statement: if `rothIndex P (fun _ => α) R ≥ t`, then any multi-index
    `J` with `∑ J_i / R_i < t` has `aeval (fun _ => α) (multiIteratedPDeriv J P) = 0`.

    Proof: thin bridge to D-pre-aux6
    (`T5_rothIndex_lower_bound_implies_subthreshold_vanish`),
    instantiated at `α := (fun _ => α)`, `d := R`, `t := t`,
    `j := J`.  The hypothesis `h_idx : rothIndex P (fun _ => α) R ≥ t`
    is exactly the `t ≤ rothIndex …` precondition (≥ is `Ge.ge`,
    definitionally `t ≤ rothIndex …`).

    The unused `hR_pos` is threaded for compositional convenience
    (the SJWC-1 master uses `R i > 0` in the next step; carrying it
    here lets the caller pass a single hypothesis bundle rather than
    splitting). -/
theorem T5_SJWC1_A6_high_index_vanish
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ)
    (_hR_pos : ∀ i, 0 < R i) (t : ℝ)
    (h_idx : rothIndex P (fun _ => α) R ≥ t)
    (J : Fin m → ℕ) (hJ : ∑ i, (J i : ℝ) / (R i : ℝ) < t) :
    aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0 := by
  -- `h_idx : rothIndex P (fun _ => α) R ≥ t` is defeq to `t ≤ rothIndex …`
  exact T5_rothIndex_lower_bound_implies_subthreshold_vanish
    P (fun _ => α) R t h_idx J hJ

/-! ## Headline -/

/-- **HEADLINE — SJWC-1 A6 — High-index vanishing derivative at α-diagonal**.

    Sub-lemma A6 of the SJWC-1 HEART decomposition of T-5.

    Bridges to existing Block-D infrastructure
    (`T5_rothIndex_lower_bound_implies_subthreshold_vanish`,
    D-pre-aux6 from `T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish`).

    Lean-core only — no new axioms. -/
theorem session_T5_SJWC1_A6_headline
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (α : ℝ) (R : Fin m → ℕ)
    (hR_pos : ∀ i, 0 < R i) (t : ℝ)
    (h_idx : rothIndex P (fun _ => α) R ≥ t)
    (J : Fin m → ℕ) (hJ : ∑ i, (J i : ℝ) / (R i : ℝ) < t) :
    aeval (fun _ : Fin m => α) (multiIteratedPDeriv J P) = 0 :=
  T5_SJWC1_A6_high_index_vanish P α R hR_pos t h_idx J hJ

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A6_HighIndexVanish
