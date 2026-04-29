/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_DualWitness

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 DUAL-WITNESS BUNDLE**
  consolidating BOTH witness families for m ≤ 3:
  - Original e_{i-1} witness: det = (-1)^(m-1) · X_{m-1} · P^m
  - Alt e_i witness: det = X_0 · P^m

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_Bundle
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_AltWitness

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_DualWitness

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_Bundle
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_AltWitness

/-! ## Dual-witness consolidation -/

/-- **`T5_RothWronskian_m3_dual_witness`** — 4-conjunct paper bundle: -/
def T5_RothWronskian_m3_dual_witness : Prop :=
  -- (a) Original m=2 witness gives det = -X 1 · P²
  (∀ (P : MvPolynomial (Fin 2) ℝ),
    mvPolyWronskian 2 P m2_witness_J =
      -(X 1 : MvPolynomial (Fin 2) ℝ) * P^2) ∧
  -- (b) Alt m=2 witness gives det = X 0 · P²
  (∀ (P : MvPolynomial (Fin 2) ℝ),
    mvPolyWronskian 2 P m2_alt_witness_J =
      (X 0 : MvPolynomial (Fin 2) ℝ) * P^2) ∧
  -- (c) Original m=3 witness gives det = X 2 · P³
  (∀ (P : MvPolynomial (Fin 3) ℝ),
    mvPolyWronskian 3 P m3_witness_J =
      (X 2 : MvPolynomial (Fin 3) ℝ) * P^3) ∧
  -- (d) Alt m=3 witness gives det = X 0 · P³
  (∀ (P : MvPolynomial (Fin 3) ℝ),
    mvPolyWronskian 3 P m3_alt_witness_J =
      (X 0 : MvPolynomial (Fin 3) ℝ) * P^3)

/-- **🚨 4-conjunct dual-witness discharge**. -/
theorem T5_RothWronskian_m3_dual_witness_unconditional :
    T5_RothWronskian_m3_dual_witness :=
  ⟨T5_m2_wronskian_det,
   T5_m2_alt_wronskian_det,
   T5_m3_wronskian_det,
   T5_m3_alt_wronskian_det⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 DUAL-WITNESS FAMILY**.

    🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 DUAL.

    Two witness families discharged for m ∈ {2, 3}:
    1. Original `e_{i-1}` witness: det = (-1)^(m-1) · X_{m-1} · P^m
       - m=2: -X 1 · P²
       - m=3: X 2 · P³
    2. Alt `e_i` witness: det = X_0 · P^m
       - m=2: X 0 · P²
       - m=3: X 0 · P³

    Both witnesses give non-vanishing determinants, providing
    REDUNDANT confirmation of Wronskian non-vanish for m ≤ 3.

    The alt-witness pattern J = (const 0, e_1, e_2, ..., e_{m-1})
    has a UNIFORM clean formula `det = X_0 · P^m` (always +1 sign),
    whereas the e_{i-1} pattern has alternating sign (-1)^(m-1).

    Sub-lemma 311/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_m3_dual_witness_headline :
    T5_RothWronskian_m3_dual_witness :=
  T5_RothWronskian_m3_dual_witness_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_DualWitness
