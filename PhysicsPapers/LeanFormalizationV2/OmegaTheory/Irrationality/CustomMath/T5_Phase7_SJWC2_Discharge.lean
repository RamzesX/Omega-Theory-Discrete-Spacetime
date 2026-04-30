/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC2_Discharge

  T-5 (Roth's theorem) — **SJWC-2 partial discharge under non-degeneracy**.

  Discharges the SJWC-2 NAMED Prop (`T5_NAMED_index_set_nonempty_at_q`)
  under a CONCRETE non-degeneracy hypothesis: existence of SOME
  multi-index `j` with `aeval q (multiIteratedPDeriv j P) ≠ 0`.

  This is the "P does not vanish to all orders at q" condition — generic
  non-degeneracy.  In the V8-D5 chain, this condition is established by
  Schmidt aux poly P_int construction (P_int has bounded total degree,
  cannot vanish to all orders at any q ≠ 0).

  Strategic significance: factors SJWC-2 into a SMALLER NAMED leaf
  (existence of single non-vanishing derivative) — Tier-99 routine.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC2_Discharge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition

/-! ## SJWC2D-1 — Single-witness discharge -/

/-- **SJWC2D-1 — `T5_index_set_nonempty_from_single_witness`**: if there
    exists ONE multi-index `j` with non-vanishing derivative at the
    q-tuple, then the rothIndex set at q is nonempty.

    Trivial unfolding: the rothIndex set is `{ r | ∃ j, ... ∧ r = ... }`,
    and we have an explicit witness `j` plus its corresponding `r`. -/
theorem T5_index_set_nonempty_from_single_witness {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ) (R : Fin m → ℕ)
    (h_witness : ∃ j : Fin m → ℕ,
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0) :
    ({ r : ℝ | ∃ j : Fin m → ℕ,
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
        r = ∑ i, (j i : ℝ) / (R i : ℝ) } : Set ℝ).Nonempty := by
  obtain ⟨j, h_aeval_ne⟩ := h_witness
  exact ⟨∑ i, (j i : ℝ) / (R i : ℝ), j, h_aeval_ne, rfl⟩

/-! ## SJWC2D-2 — Discharge SJWC-2 NAMED under universal-witness -/

/-- **SJWC2D-2 — `T5_SJWC2_discharge_via_universal_witness`**: discharges
    SJWC-2 NAMED Prop under the universal hypothesis that for any
    `m, P, q, R, P ≠ 0`, there exists some non-vanishing derivative.

    This converts SJWC-2 from a "convenience" NAMED leaf into a
    smaller analytical NAMED leaf (single-witness existence). -/
theorem T5_SJWC2_discharge_via_universal_witness
    (h_universal : ∀ {m : ℕ}, 1 ≤ m →
      ∀ (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ),
      P ≠ 0 →
      ∃ j : Fin m → ℕ,
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0) :
    T5_NAMED_index_set_nonempty_at_q := by
  intros m hm P q R hP
  apply T5_index_set_nonempty_from_single_witness
  exact h_universal hm P q hP

/-! ## SJWC2D-3 — Headline -/

/-- **🚨🚨 SJWC2D-3 — `T5_SJWC2_DISCHARGE_HEADLINE`**: paper-citable
    bundle showing SJWC-2 reduces to single-witness existence.

    Strategic significance: V8-D5 atom-1 NAMED leaf count further
    reduced.  SJWC-2 is no longer a separate hypothesis — it follows
    from the smaller "non-degeneracy" NAMED Prop. -/
theorem T5_SJWC2_DISCHARGE_HEADLINE :
    -- (a) single-witness ⇒ rothIndex set nonempty (concrete)
    (∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ) (R : Fin m → ℕ),
      (∃ j : Fin m → ℕ,
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0) →
      ({ r : ℝ | ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (R i : ℝ) } : Set ℝ).Nonempty) ∧
    -- (b) universal single-witness ⇒ SJWC-2 NAMED
    ((∀ {m : ℕ} (_hm : 1 ≤ m)
        (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ),
        P ≠ 0 →
        ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0) →
      T5_NAMED_index_set_nonempty_at_q) :=
  ⟨fun {m} P q R h => T5_index_set_nonempty_from_single_witness P q R h,
   fun h_universal => T5_SJWC2_discharge_via_universal_witness
     (fun {m} hm P q hP => h_universal hm P q hP)⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC2_Discharge
