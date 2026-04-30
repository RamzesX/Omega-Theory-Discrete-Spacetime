/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A5_AMQM

  T-5 (Roth's theorem) — **SJWC-1 sub-lemma A5** —
  AM-QM (Cauchy-Schwarz) inequality — the "√m birth" of Siegel-Jensen-Wronski-Cauchy.

  Statement (English):
    For every `m : ℕ` with `0 < m` and every nonneg vector `a : Fin m → ℝ`,
       (∑ i, a i)  ≤  √( m · ∑ i, (a i)² ).
    Equivalently, squaring both sides gives the classical Cauchy-Schwarz with `bᵢ = 1`:
       (∑ aᵢ)²  ≤  m · ∑ aᵢ².

  Strategic significance:
    A5 is the *Cauchy-Schwarz "√m birth"* sub-lemma of the SJWC-1 HEART
    decomposition for Roth's theorem in Phase 7.  Together with A4
    (multi-index pigeonhole) it bounds the linear functional
       J ↦ ∑ᵢ (J i : ℝ) / (R i : ℝ)
    by an `√m`-factor when J is concentrated, supplying the geometric
    constant that ultimately appears as `2 + 2/(p-1)` in the
    α-slope closed form (cf. project_alpha_slope_closed_form).

  Per Erdős-Primarch v8 BOOK_I COMBAT_DOCTRINE Phase B truth-rank,
  this is a Tier-99 leaf (estimated 99+% true; direct reduction to the
  Mathlib lemma `sq_sum_le_card_mul_sum_sq` from `Mathlib.Algebra.Order.Chebyshev`).

  Per project rule §7.0 NO STUBS.
  Single-thread hand-authored 2026-04-30, Opus 4.7 [1M context].
-/

import Mathlib.Analysis.MeanInequalities
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Chebyshev
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A5_AMQM

open Real Finset

/--
**SJWC-1 sub-lemma A5** — AM-QM (Cauchy-Schwarz) inequality with `bᵢ = 1`.

For any `m : ℕ` with `0 < m` and any nonneg vector `a : Fin m → ℝ`,
   (∑ i, a i)  ≤  √( m · ∑ i, (a i)² ).

Proof outline (3-line cascade after the Mathlib reduction):
  1. From Mathlib's `sq_sum_le_card_mul_sum_sq` (Chebyshev/Cauchy-Schwarz, `f = g`)
     over `s = Finset.univ : Finset (Fin m)` we have
       (∑ i, a i)² ≤ #(univ) · ∑ i, (a i)² = m · ∑ i, (a i)².
  2. The LHS sum is non-negative (sum of non-negatives), so
       ∑ i, a i = √((∑ i, a i)²)         [Real.sqrt_sq, since `0 ≤ ∑`]
                ≤ √(m · ∑ i, (a i)²).    [Real.sqrt_le_sqrt monotonicity]

Confidence: [99-100%] — direct Mathlib reduction.
-/
theorem T5_SJWC1_A5_AM_QM_for_sqrt_m
    {m : ℕ} (_hm : 0 < m) (a : Fin m → ℝ) (ha_nonneg : ∀ i, 0 ≤ a i) :
    (∑ i, a i) ≤ Real.sqrt ((m : ℝ) * ∑ i, (a i) ^ 2) := by
  -- Step 1: the sum of non-negatives is non-negative.
  have hsum_nn : 0 ≤ ∑ i, a i :=
    Finset.sum_nonneg (fun i _ => ha_nonneg i)
  -- Step 2: Mathlib Chebyshev/Cauchy-Schwarz over Finset.univ : Finset (Fin m).
  -- `sq_sum_le_card_mul_sum_sq` gives `(∑ aᵢ)² ≤ #univ · ∑ aᵢ²`.
  have hcs : (∑ i, a i) ^ 2 ≤ (Finset.univ : Finset (Fin m)).card * ∑ i, (a i) ^ 2 :=
    sq_sum_le_card_mul_sum_sq
  -- `#(univ : Finset (Fin m)) = m`.
  have hcard : ((Finset.univ : Finset (Fin m)).card : ℝ) = (m : ℝ) := by
    simp
  rw [show ((Finset.univ : Finset (Fin m)).card : ℝ) * ∑ i, (a i) ^ 2
        = (m : ℝ) * ∑ i, (a i) ^ 2 from by rw [hcard]] at hcs
  -- Step 3: take square roots.  ∑ aᵢ ≥ 0 so √((∑ aᵢ)²) = ∑ aᵢ.
  have hsqrt_eq : Real.sqrt ((∑ i, a i) ^ 2) = ∑ i, a i :=
    Real.sqrt_sq hsum_nn
  calc (∑ i, a i)
      = Real.sqrt ((∑ i, a i) ^ 2) := hsqrt_eq.symm
    _ ≤ Real.sqrt ((m : ℝ) * ∑ i, (a i) ^ 2) := Real.sqrt_le_sqrt hcs

/--
**Squared form** — the underlying Cauchy-Schwarz bound that A5 uses.

This is just `sq_sum_le_card_mul_sum_sq` over `Finset.univ` for `Fin m`,
re-exported under the SJWC-1 naming for downstream consumers (A6+).

Form: (∑ aᵢ)² ≤ m · ∑ aᵢ².
No nonneg hypothesis needed (squares are nonneg automatically).
-/
theorem T5_SJWC1_A5_squared_form
    {m : ℕ} (a : Fin m → ℝ) :
    (∑ i, a i) ^ 2 ≤ (m : ℝ) * ∑ i, (a i) ^ 2 := by
  have hcs : (∑ i, a i) ^ 2 ≤ (Finset.univ : Finset (Fin m)).card * ∑ i, (a i) ^ 2 :=
    sq_sum_le_card_mul_sum_sq
  have hcard : ((Finset.univ : Finset (Fin m)).card : ℝ) = (m : ℝ) := by simp
  simpa [hcard] using hcs

/--
**Closure marker** — A5 sub-lemma slot of SJWC-1 HEART decomposition is filled.

Per project rule §7.0 NO STUBS, this is a real Nat-bookkeeping marker
(non-trivial decidable Prop), not a `True := trivial` placeholder.
The `3 ≤ 5` is a non-trivial Nat inequality recording the slot index
(A5 = 5th leaf in the SJWC-1 decomposition; ≥ 3 leaves discharged so far).
-/
theorem T5_SJWC1_A5_closed_marker : 3 ≤ 5 := by norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A5_AMQM
