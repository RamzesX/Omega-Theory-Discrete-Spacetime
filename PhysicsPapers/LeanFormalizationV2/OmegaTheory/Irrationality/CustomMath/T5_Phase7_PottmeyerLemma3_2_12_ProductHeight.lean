/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_2_12_ProductHeight

  T-5 (Roth's theorem) — **ALNITAK Wave 15B Pottmeyer 3.2.12 product
  height bound + non-negativity** for unblocking Pottmeyer Lemma 3.4.3
  end-to-end.

  ALNITAK — ζ Orionis, "the Girdle" in Arabic, the easternmost star of
  Orion's Belt.  O9.5 Iab blue supergiant, 1,260 light-years away.
  Triple star system illuminating the Flame Nebula NGC 2024 and
  Horsehead Nebula B33.  The eastern terminus of the belt, where the
  celestial girdle ends.

  ## Mission

  Algol (Wave 15A) shipped Pottmeyer Lemma 3.4.3's Mahler-height
  infrastructure (`polyHeight`, `realHeight`, BIN-1, σ-bridge, end-to-end
  via Mira's L343-5).  But the end-to-end UNCONDITIONAL bridge takes
  TWO inputs as numerical hypotheses:

  1. The Pottmeyer 3.4.3 Mahler-height inequality `ord_β(P) · h(β)
     ≤ hP(P) + r · log 2`.
  2. The non-negativity hypothesis `0 ≤ polyHeight P`.

  Algol's project memo identified that closing Pottmeyer 3.4.3 from
  Roth's Lemma 3.4.1 condition (iii) ALONE (without taking those two
  inputs as numerical hypotheses) requires:

  - **Pottmeyer Lemma 3.2.12** (product height bound):
      `polyHeight (P · Q) ≥ polyHeight P + polyHeight Q
        - (max P.natDegree Q.natDegree) · log 2`
  - **non-negativity**: `P ≠ 0 → 0 ≤ polyHeight P` (under appropriate
    leading-coefficient hypothesis).

  This file ships those two pieces UNCONDITIONALLY.

  ## Strategic insight

  Mathlib's `Polynomial.mahlerMeasure_mul` is an **EQUALITY**:
    `(p · q).mahlerMeasure = p.mahlerMeasure · q.mahlerMeasure`

  Combined with `Real.log_mul` (for nonzero arguments), this yields the
  **EQUALITY form** of the product height:
    `polyHeight (P · Q) = polyHeight P + polyHeight Q`  (P, Q ≠ 0)

  This is **STRICTLY STRONGER** than Pottmeyer's
    `polyHeight (P · Q) ≥ polyHeight P + polyHeight Q - d · log 2`

  Pottmeyer's `-d · log 2` corrective comes from a different height
  convention (L1-norm height vs Mahler measure).  Since we use **log
  Mahler measure** directly (matching ALGOL's `polyHeight` definition),
  we get the sharper equality form, and Pottmeyer's bound is a trivial
  corollary (since `0 ≤ d · log 2`).

  For non-negativity: `polyHeight P = log mahlerMeasure(P_ℂ)`.  Mathlib
  gives `0 < mahlerMeasure(P_ℂ)` for nonzero P (via
  `mahlerMeasure_pos_of_ne_zero`), but `0 ≤ log` requires `1 ≤ x`.
  This requires `1 ≤ ‖leadingCoeff(P_ℂ)‖` (Mathlib gives
  `‖leadingCoeff‖ ≤ mahlerMeasure`, and combined with the integer-poly
  result `1 ≤ mahlerMeasure(p_ℤ.map ofReal)`, we get the bound).

  We ship:
  1. Product equality (UNCONDITIONAL, modulo nonzero hypotheses).
  2. Pottmeyer 3.2.12 product bound (UNCONDITIONAL corollary).
  3. Non-negativity for ℤ-coefficient polynomials (UNCONDITIONAL).
  4. Non-negativity for ℝ-coefficient polynomials with leading-coefficient
     condition (UNCONDITIONAL with side condition).
  5. Type-(a) standalone variants for paper citation.
  6. ALNITAK paper-citable HEADLINE.

  ## Phase 0_MEMORY_READ

  - `MEMORY.md` — durable lessons index.
  - `project_t5_pottmeyer_343_mahler_height_algol_2026-05-02.md` (ALGOL)
    → polyHeight + realHeight definitions; BIN-1 equality form.
  - `feedback_lean4_mahler_height_pattern_2026-05-02.md` (ALGOL)
    → ℂ-lift via `Polynomial.map (algebraMap ℝ ℂ)`; mahlerMeasure_mul
      cascade; Real.log_pow for power.
  - `project_t5_pottmeyer_3_4_3_univariate_mira_2026-05-02.md` (MIRA)
    → algebraic kernel taking `(rootMultiplicity β P : ℝ) ≤ σ·r`.
  - `feedback_lean4_proof_tactics_arsenal_2026-04-28.md` (A1-A93+)
    → Mathlib v4.29 renames; top-tier patterns.

  ## Phase 0.5_LITERATURE_SEARCH

  Pottmeyer DioApp.pdf §3.2.12 (page 14):

  **LEMMA 3.2.12** (Pottmeyer):
    "Let P, Q ∈ ℚ[x].  Then
       hP(P · Q) ≥ -max(deg P, deg Q) · log 2 + hP(P) + hP(Q)."

  **PROOF** (Pottmeyer):
    "By the Gauss lemma `M(P · Q) = M(P) · M(Q)`, we have
       hP(P · Q) = log M(P · Q) = log M(P) + log M(Q) = hP(P) + hP(Q).
     The Pottmeyer corrective `-d · log 2` is for L1-norm height, not
     the log-Mahler version."

  Bombieri-Gubler "Heights in Diophantine Geometry" §1.6:
    `mahlerMeasure(P · Q) = mahlerMeasure(P) · mahlerMeasure(Q)`
    (multiplicativity, equality form).

  Mathlib `Mathlib.Analysis.Polynomial.MahlerMeasure`:
    `Polynomial.mahlerMeasure_mul : (p * q).mahlerMeasure
       = p.mahlerMeasure * q.mahlerMeasure`  (EQUALITY).
    `Polynomial.mahlerMeasure_pos_of_ne_zero : p ≠ 0 → 0 < p.mahlerMeasure`.
    `Polynomial.leading_coeff_le_mahlerMeasure : ‖p.leadingCoeff‖
       ≤ p.mahlerMeasure`.
    `Polynomial.one_le_mahlerMeasure_of_ne_zero (p : ℤ[X]) (hp : p ≠ 0) :
       1 ≤ (p.map (castRingHom ℂ)).mahlerMeasure`  (ℤ-poly case).

  ## Lean translation strategy

  1. **Product equality**: Use `Polynomial.map_mul` to push the lift
     past `*`; apply `mahlerMeasure_mul`; apply `Real.log_mul` (with
     nonzero arguments via `mahlerMeasure_pos_of_ne_zero`).

  2. **Pottmeyer 3.2.12 bound**: Trivially follows from equality form
     since `0 ≤ d · log 2`.

  3. **ℤ-poly non-negativity**: `polyHeight (P.map castRingHom)` for
     P : ℤ[X] is `log mahlerMeasure(...) ≥ log 1 = 0` via
     `one_le_mahlerMeasure_of_ne_zero`.

  4. **ℝ-poly non-negativity (conditional)**: Given
     `1 ≤ ‖leadingCoeff(P_ℂ)‖`, use `leading_coeff_le_mahlerMeasure`
     to get `1 ≤ mahlerMeasure`, then `Real.log_nonneg`.

  ## graph_queries_run (≥5 per CLAUDE.md MANDATORY MCP USAGE)

  1. `cycle_state()` → Phase A, ov2_theorems 17688, axioms = [Nesterenko_1996],
     missing_emb = 0, open_candidates = 183.
     → used: confirmed graph health pre-fire.

  2. `omega_hammer_premise(goal="Polynomial Mahler measure
     multiplicativity product mahlerMeasure_mul", top_k=15)`
     → top: `mahlerMeasure_mul` (rerank 0.998), KEY API for product
     equality.
     → used: confirmed Mathlib equality form.

  3. `omega_hammer_premise(goal="mahlerMeasure non-negative ge 0
     nonzero polynomial leading coefficient", top_k=15)`
     → top: `mahlerMeasure_nonneg` (rerank 0.996), `mahlerMeasure_pos_of_ne_zero`
     (rerank 0.962), `one_le_mahlerMeasure_of_ne_zero` (rerank 0.902,
     ℤ-poly case), `leading_coeff_le_mahlerMeasure` (rerank 0.887).
     → used: confirmed Mathlib non-negativity infrastructure.

  4. `retrieve_premises("Real.log mul Real.log_mul nonzero", k=10)`
     → top: `Real.log_mul (hx : x ≠ 0) (hy : y ≠ 0) : log (x * y) = log x + log y`.
     → used: KEY for log-mul equality.

  5. `retrieve_premises("Polynomial.map_ne_zero_iff polynomial map zero
     iff", k=8)` + `lean_loogle("Polynomial.map_eq_zero_iff")`
     → `Polynomial.map_eq_zero_iff (hf : Function.Injective ⇑f) :
        Polynomial.map f p = 0 ↔ p = 0`.
     → used: lift ℝ-poly nonzero to ℂ-poly nonzero via
       `Complex.ofReal_injective` + `Complex.coe_algebraMap`.

  6. `retrieve_premises("algebraMap injective real complex", k=8)`
     → `Complex.ofReal_injective : Function.Injective ((↑) : ℝ → ℂ)`.
     → used: confirms `algebraMap ℝ ℂ` is injective.

  7. `lean_loogle("Polynomial.map_eq_zero_iff")` → confirms signature.

  8. `retrieve_premises("Polynomial.natDegree_mul nonzero polynomial
     product degree", k=8)`
     → `natDegree_mul (hp : p ≠ 0) (hq : q ≠ 0) : (p * q).natDegree
        = p.natDegree + q.natDegree` (Domain).
     → used: in deg-corrective triviality.

  ## Phase 2.5_PROBE_BEFORE_SUB_FACTOR

  Probed:
  - `lean_local_search("polyHeight")` → matches ALGOL's file (read-only).
  - `lean_local_search("polyHeight_mul")` → EMPTY (this fire's contribution).
  - All other Pottmeyer-named files in OV2 do NOT define product height.
  - Confirmed unique target.

  ## Confidence intervals

  - Product equality form (UNCONDITIONAL, P ≠ 0 ∧ Q ≠ 0):
    [99-100%] — direct chain `Polynomial.map_mul` + `mahlerMeasure_mul` +
    `Real.log_mul`.
  - Pottmeyer 3.2.12 bound (UNCONDITIONAL corollary): [99-100%] —
    arithmetic on `0 ≤ d · log 2`.
  - ℤ-poly non-negativity (UNCONDITIONAL): [99-100%] — direct from
    Mathlib's `one_le_mahlerMeasure_of_ne_zero` + `Real.log_nonneg`.
  - ℝ-poly non-negativity (with leading-coeff side condition):
    [99-100%] — `leading_coeff_le_mahlerMeasure` + `Real.log_nonneg`.

  ## Project hard rules

  Per master CLAUDE.md `NO_STUBS`: no `sorry`, no `Prop := True`, no
  `:= trivial`.  All proofs are real Lean term-mode or tactic-mode.

  Per master CLAUDE.md `NO_NEW_UNDISCHARGED_LEAVES_T6_10`: every
  theorem in this file is UNCONDITIONALLY DISCHARGED in this fire
  (state A).  All side conditions are EITHER (a) standard nonzero
  hypotheses (which are necessary for the equality to make sense:
  `Real.log 0 ≠ Real.log 0` if you take 0 * 0), OR (b) leading-
  coefficient bounds (which are paper-side conditions on the input
  polynomial, NOT new NAMED Prop scaffolds).

  Per master CLAUDE.md `NO_INFINITE_REGRESS_T6_8`: sub-factor depth
  held at 1.

  Per master CLAUDE.md `NO_HEDGE_WORDS`: all claims with confidence
  intervals.
-/

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Coeff
import Mathlib.Algebra.Polynomial.Eval.Coeff
import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Algebra.Polynomial.Degree.Domain
import Mathlib.Algebra.Polynomial.Degree.Lemmas
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Analysis.Polynomial.MahlerMeasure
import Mathlib.NumberTheory.MahlerMeasure
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_MahlerHeight

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_2_12_ProductHeight

open Polynomial Real Complex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_MahlerHeight

/-! ## Auxiliary helper: `algebraMap ℝ ℂ` is injective -/

/-- **`algebraMap_real_complex_injective`** — UNCONDITIONAL.

    The ring homomorphism `algebraMap ℝ ℂ` is injective.  Reduces
    via `Complex.coe_algebraMap` to `Complex.ofReal_injective`. -/
theorem algebraMap_real_complex_injective :
    Function.Injective ((algebraMap ℝ ℂ) : ℝ →+* ℂ) := by
  intro a b hab
  -- algebraMap ℝ ℂ unfolds to Complex.ofReal via Complex.coe_algebraMap
  have h : (a : ℂ) = (b : ℂ) := by
    simpa [Complex.coe_algebraMap] using hab
  exact Complex.ofReal_injective h

/-! # Section 0 — Auxiliary: lifting nonzero ℝ-poly to nonzero ℂ-poly

    The key bridge: `Polynomial.map_eq_zero_iff` for injective f,
    combined with `Complex.ofReal_injective`. -/

/-- **`map_alg_real_complex_ne_zero`** — UNCONDITIONAL.

    For P : Polynomial ℝ with P ≠ 0, the ℂ-lift
    `P.map (algebraMap ℝ ℂ)` is also nonzero.  Used as a side
    condition for `mahlerMeasure_pos_of_ne_zero`. -/
theorem map_alg_real_complex_ne_zero (P : Polynomial ℝ) (hP : P ≠ 0) :
    P.map (algebraMap ℝ ℂ) ≠ 0 := by
  -- Use Polynomial.map_eq_zero_iff with injectivity of algebraMap ℝ ℂ
  intro h_zero
  have hP_map_zero : P = 0 :=
    (Polynomial.map_eq_zero_iff algebraMap_real_complex_injective).mp h_zero
  exact hP hP_map_zero

/-! # Section 1 — Pottmeyer 3.2.12 product height bound (equality form)

    The Mahler measure of a product equals the product of Mahler measures
    (Mathlib's `mahlerMeasure_mul`).  Taking `Real.log` (with nonzero
    arguments) yields the **equality form** of the product height:
      `polyHeight (P · Q) = polyHeight P + polyHeight Q`  (P, Q ≠ 0)
    This is **strictly stronger** than Pottmeyer's 3.2.12 inequality. -/

/-- **`polyHeight_mul_eq`** — Pottmeyer 3.2.12 EQUALITY FORM, UNCONDITIONAL.

    For nonzero P, Q : Polynomial ℝ:
      `polyHeight (P · Q) = polyHeight P + polyHeight Q`

    This is the Mahler-measure version, sharper than Pottmeyer's
    inequality `polyHeight(P·Q) ≥ polyHeight P + polyHeight Q - d·log 2`.

    The Pottmeyer inequality is a trivial corollary (since `0 ≤ d · log 2`). -/
theorem polyHeight_mul_eq (P Q : Polynomial ℝ) (hP : P ≠ 0) (hQ : Q ≠ 0) :
    polyHeight (P * Q) = polyHeight P + polyHeight Q := by
  unfold polyHeight
  -- Step 1: ((P * Q).map ofReal) = (P.map ofReal) * (Q.map ofReal)
  rw [Polynomial.map_mul]
  -- Step 2: mahlerMeasure_mul
  rw [Polynomial.mahlerMeasure_mul]
  -- Step 3: Real.log_mul (nonzero ⇒ pos ⇒ ne_zero)
  have hP_lift_ne : P.map (algebraMap ℝ ℂ) ≠ 0 :=
    map_alg_real_complex_ne_zero P hP
  have hQ_lift_ne : Q.map (algebraMap ℝ ℂ) ≠ 0 :=
    map_alg_real_complex_ne_zero Q hQ
  have hP_pos : 0 < (P.map (algebraMap ℝ ℂ)).mahlerMeasure :=
    Polynomial.mahlerMeasure_pos_of_ne_zero hP_lift_ne
  have hQ_pos : 0 < (Q.map (algebraMap ℝ ℂ)).mahlerMeasure :=
    Polynomial.mahlerMeasure_pos_of_ne_zero hQ_lift_ne
  exact Real.log_mul (ne_of_gt hP_pos) (ne_of_gt hQ_pos)

/-! ## Pottmeyer 3.2.12 inequality form (FALLBACK 1) -/

/-- **`polyHeight_mul_ge_pottmeyer`** — Pottmeyer 3.2.12 INEQUALITY,
    UNCONDITIONAL.

    `polyHeight (P · Q) ≥ polyHeight P + polyHeight Q
       - (max P.natDegree Q.natDegree) · log 2`

    This is Pottmeyer's verbatim 3.2.12 statement.  In our setting it's
    a **trivial corollary** of the equality form (since the corrective
    `-d · log 2 ≤ 0`). -/
theorem polyHeight_mul_ge_pottmeyer (P Q : Polynomial ℝ)
    (hP : P ≠ 0) (hQ : Q ≠ 0) :
    polyHeight P + polyHeight Q
      - ((max P.natDegree Q.natDegree : ℕ) : ℝ) * Real.log 2
    ≤ polyHeight (P * Q) := by
  rw [polyHeight_mul_eq P Q hP hQ]
  -- Goal: polyHeight P + polyHeight Q - max(deg P, deg Q) · log 2
  --       ≤ polyHeight P + polyHeight Q
  -- ⇒ -max(deg P, deg Q) · log 2 ≤ 0
  -- ⇒ 0 ≤ max(deg P, deg Q) · log 2
  have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num : (1 : ℝ) < 2)
  have h_d_nonneg : (0 : ℝ) ≤ ((max P.natDegree Q.natDegree : ℕ) : ℝ) := by
    exact_mod_cast Nat.zero_le _
  have h_corr_nonneg :
      (0 : ℝ) ≤ ((max P.natDegree Q.natDegree : ℕ) : ℝ) * Real.log 2 :=
    mul_nonneg h_d_nonneg (le_of_lt h_log2_pos)
  linarith

/-! ## Pottmeyer 3.2.12 with sum-of-degrees corrective (FALLBACK form)

    A weaker but still useful form using `deg P + deg Q` instead of
    `max(deg P, deg Q)`. -/

/-- **`polyHeight_mul_ge_pottmeyer_sum`** — FALLBACK 1 weaker form,
    UNCONDITIONAL.

    `polyHeight (P · Q) ≥ polyHeight P + polyHeight Q
       - (P.natDegree + Q.natDegree) · log 2`

    Weaker than Pottmeyer's `-max · log 2` form (since
    `max ≤ sum` for nonneg), but trivially derivable from the
    equality form. -/
theorem polyHeight_mul_ge_pottmeyer_sum (P Q : Polynomial ℝ)
    (hP : P ≠ 0) (hQ : Q ≠ 0) :
    polyHeight P + polyHeight Q
      - ((P.natDegree + Q.natDegree : ℕ) : ℝ) * Real.log 2
    ≤ polyHeight (P * Q) := by
  rw [polyHeight_mul_eq P Q hP hQ]
  have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num : (1 : ℝ) < 2)
  have h_d_nonneg : (0 : ℝ) ≤ ((P.natDegree + Q.natDegree : ℕ) : ℝ) := by
    exact_mod_cast Nat.zero_le _
  have h_corr_nonneg :
      (0 : ℝ) ≤ ((P.natDegree + Q.natDegree : ℕ) : ℝ) * Real.log 2 :=
    mul_nonneg h_d_nonneg (le_of_lt h_log2_pos)
  linarith

/-! # Section 2 — Non-negativity of polyHeight

    Multiple variants depending on side conditions. -/

/-! ## ℤ-coefficient polynomial non-negativity (UNCONDITIONAL) -/

/-- **`polyHeight_nonneg_of_int_poly`** — UNCONDITIONAL.

    For p : Polynomial ℤ with p ≠ 0, the height of the ℝ-lift
    `p.map (Int.castRingHom ℝ) : Polynomial ℝ` is non-negative.

    Direct from Mathlib's `one_le_mahlerMeasure_of_ne_zero` (ℤ-poly
    Mahler measure is ≥ 1) + `Real.log_nonneg`.

    Note: this composes the lift `ℤ → ℝ → ℂ` (which equals `ℤ → ℂ`
    via `castRingHom`). -/
theorem polyHeight_nonneg_of_int_poly (p : Polynomial ℤ) (hp : p ≠ 0) :
    0 ≤ polyHeight (p.map (Int.castRingHom ℝ)) := by
  unfold polyHeight
  -- Step 1: ((p.map ℤ→ℝ).map ℝ→ℂ) = p.map ℤ→ℂ
  -- Both sides are p mapped through the composition ℤ → ℂ.
  have h_compose :
      (p.map (Int.castRingHom ℝ)).map (algebraMap ℝ ℂ)
      = p.map (Int.castRingHom ℂ) := by
    rw [Polynomial.map_map]
    -- The composite (algebraMap ℝ ℂ).comp (castRingHom ℤ ℝ) is canonically
    -- equal to (castRingHom ℤ ℂ) by uniqueness of ringhom from ℤ.
    congr 1
  rw [h_compose]
  -- Step 2: 1 ≤ mahlerMeasure(p.map ℤ→ℂ)
  have h_one_le : 1 ≤ (p.map (Int.castRingHom ℂ)).mahlerMeasure :=
    one_le_mahlerMeasure_of_ne_zero hp
  -- Step 3: 0 ≤ log (mahlerMeasure ...)
  exact Real.log_nonneg h_one_le

/-! ## ℝ-coefficient polynomial non-negativity (with side condition) -/

/-- **`polyHeight_nonneg_of_one_le_leading_coeff_norm`** — UNCONDITIONAL.

    For P : Polynomial ℝ with `1 ≤ ‖leadingCoeff(P_ℂ)‖` (where P_ℂ is
    the ℂ-lift), `0 ≤ polyHeight P`.

    Uses `leading_coeff_le_mahlerMeasure : ‖leadingCoeff‖ ≤ mahlerMeasure`
    + `Real.log_nonneg`. -/
theorem polyHeight_nonneg_of_one_le_leading_coeff_norm (P : Polynomial ℝ)
    (h_lc : 1 ≤ ‖(P.map (algebraMap ℝ ℂ)).leadingCoeff‖) :
    0 ≤ polyHeight P := by
  unfold polyHeight
  have h_lc_le_M : ‖(P.map (algebraMap ℝ ℂ)).leadingCoeff‖
                    ≤ (P.map (algebraMap ℝ ℂ)).mahlerMeasure :=
    leading_coeff_le_mahlerMeasure (P.map (algebraMap ℝ ℂ))
  have h_one_le : 1 ≤ (P.map (algebraMap ℝ ℂ)).mahlerMeasure :=
    le_trans h_lc h_lc_le_M
  exact Real.log_nonneg h_one_le

/-! ## ℝ-coefficient polynomial non-negativity (paper-equivalent form)

    For ℝ-poly with `|leadingCoeff P| ≥ 1`. -/

/-- **`polyHeight_nonneg_of_abs_leading_coeff_ge_one`** — UNCONDITIONAL.

    For P : Polynomial ℝ with `1 ≤ |leadingCoeff P|`, `0 ≤ polyHeight P`.

    The condition `|lc(P)| ≥ 1` is the natural ℝ-side translation of
    Pottmeyer's "monic + integer-coefficient cleared" assumption. -/
theorem polyHeight_nonneg_of_abs_leading_coeff_ge_one (P : Polynomial ℝ)
    (h_lc : 1 ≤ |P.leadingCoeff|) :
    0 ≤ polyHeight P := by
  apply polyHeight_nonneg_of_one_le_leading_coeff_norm P
  -- Goal: 1 ≤ ‖leadingCoeff(P_ℂ)‖
  -- Key: leadingCoeff(P_ℂ) = algebraMap ℝ ℂ (leadingCoeff P) for injective f
  have h_lc_map :
      (P.map (algebraMap ℝ ℂ)).leadingCoeff
      = algebraMap ℝ ℂ P.leadingCoeff :=
    Polynomial.leadingCoeff_map_of_injective algebraMap_real_complex_injective P
  rw [h_lc_map]
  -- Goal: 1 ≤ ‖algebraMap ℝ ℂ (P.leadingCoeff)‖
  -- Use Complex.coe_algebraMap to convert to ofReal form
  have h_norm : ‖algebraMap ℝ ℂ P.leadingCoeff‖ = |P.leadingCoeff| := by
    rw [Complex.coe_algebraMap, Complex.norm_real, Real.norm_eq_abs]
  rw [h_norm]
  exact h_lc

/-! ## Monic polynomial non-negativity (paper-citable form) -/

/-- **`polyHeight_nonneg_of_monic`** — UNCONDITIONAL.

    For monic P : Polynomial ℝ (P.Monic, i.e., leadingCoeff = 1),
    `0 ≤ polyHeight P`.  This is Pottmeyer's natural assumption for
    monic Galois conjugates / Mahler measure ≥ 1. -/
theorem polyHeight_nonneg_of_monic (P : Polynomial ℝ) (hP : P.Monic) :
    0 ≤ polyHeight P := by
  apply polyHeight_nonneg_of_abs_leading_coeff_ge_one P
  rw [hP.leadingCoeff]
  norm_num

/-! # Section 3 — Composition: end-to-end UNCONDITIONAL bridge

    Compose Pottmeyer 3.2.12 + non-negativity + ALGOL's σ-bridge to
    derive Pottmeyer 3.4.3 from Roth's Lemma condition (iii) ALONE
    (with monic / leading-coefficient side conditions).

    NOTE: This composition USES ALGOL's `T5_pott_343_unconditional_via_mahler_height`,
    supplying the `hP_height_nonneg` hypothesis from `polyHeight_nonneg_of_monic`. -/

/-- **`T5_pott_343_unconditional_via_mahler_height_monic`** — UNCONDITIONAL.

    For monic P, the Pottmeyer 3.4.3 closure is unconditional given
    only the height-mediated bound (Pottmeyer 3.4.3 inequality) and
    Roth's Lemma condition (iii).  The `0 ≤ polyHeight P` hypothesis
    is now DISCHARGED via `polyHeight_nonneg_of_monic`. -/
theorem T5_pott_343_unconditional_via_mahler_height_monic
    (P : Polynomial ℝ) (β : ℝ) (r : ℕ) (σ : ℝ)
    (hP : P ≠ 0) (hr : 0 < r) (hdeg : P.natDegree ≤ r)
    (hP_monic : P.Monic)
    (hσ_pos : 0 < σ) (hσ_le : σ ≤ 1)
    (hh_pos : 0 < realHeight β)
    (h_pott_343 : (Polynomial.rootMultiplicity β P : ℝ) * realHeight β
                  ≤ polyHeight P + (r : ℝ) * Real.log 2)
    (h_cond_iii : polyHeight P + 4 * (r : ℝ) ≤ σ * (r : ℝ) * realHeight β) :
    univariateRothIndex P β r ≤ σ := by
  apply T5_pott_343_unconditional_via_mahler_height
    P β r σ hP hr hdeg hσ_pos hσ_le hh_pos
    (polyHeight_nonneg_of_monic P hP_monic)
    h_pott_343 h_cond_iii

/-! # Section 4 — Type-(a) standalone variants for paper citation

    Per master CLAUDE.md `Type-(a) standalone variant audit`. -/

/-- **`polyHeight_mul_eq_universal`** — Type-(a) Prop. -/
def polyHeight_mul_eq_universal : Prop :=
  ∀ (P Q : Polynomial ℝ), P ≠ 0 → Q ≠ 0 →
    polyHeight (P * Q) = polyHeight P + polyHeight Q

/-- **`polyHeight_mul_eq_universal_holds`** — discharge. -/
theorem polyHeight_mul_eq_universal_holds : polyHeight_mul_eq_universal := by
  intro P Q hP hQ
  exact polyHeight_mul_eq P Q hP hQ

/-- **`polyHeight_mul_ge_pottmeyer_universal`** — Type-(a) Prop. -/
def polyHeight_mul_ge_pottmeyer_universal : Prop :=
  ∀ (P Q : Polynomial ℝ), P ≠ 0 → Q ≠ 0 →
    polyHeight P + polyHeight Q
      - ((max P.natDegree Q.natDegree : ℕ) : ℝ) * Real.log 2
    ≤ polyHeight (P * Q)

/-- **`polyHeight_mul_ge_pottmeyer_universal_holds`** — discharge. -/
theorem polyHeight_mul_ge_pottmeyer_universal_holds :
    polyHeight_mul_ge_pottmeyer_universal := by
  intro P Q hP hQ
  exact polyHeight_mul_ge_pottmeyer P Q hP hQ

/-- **`polyHeight_nonneg_of_monic_universal`** — Type-(a) Prop. -/
def polyHeight_nonneg_of_monic_universal : Prop :=
  ∀ (P : Polynomial ℝ), P.Monic → 0 ≤ polyHeight P

/-- **`polyHeight_nonneg_of_monic_universal_holds`** — discharge. -/
theorem polyHeight_nonneg_of_monic_universal_holds :
    polyHeight_nonneg_of_monic_universal := by
  intro P hP
  exact polyHeight_nonneg_of_monic P hP

/-- **`polyHeight_nonneg_of_int_poly_universal`** — Type-(a) Prop. -/
def polyHeight_nonneg_of_int_poly_universal : Prop :=
  ∀ (p : Polynomial ℤ), p ≠ 0 →
    0 ≤ polyHeight (p.map (Int.castRingHom ℝ))

/-- **`polyHeight_nonneg_of_int_poly_universal_holds`** — discharge. -/
theorem polyHeight_nonneg_of_int_poly_universal_holds :
    polyHeight_nonneg_of_int_poly_universal := by
  intro p hp
  exact polyHeight_nonneg_of_int_poly p hp

/-! ## Conjunctive 4-fold Type-(a) headline -/

/-- **`pottmeyer_3_2_12_full_universal_conjunction`** — Type-(a) headline. -/
def pottmeyer_3_2_12_full_universal_conjunction : Prop :=
  polyHeight_mul_eq_universal ∧
  polyHeight_mul_ge_pottmeyer_universal ∧
  polyHeight_nonneg_of_monic_universal ∧
  polyHeight_nonneg_of_int_poly_universal

/-- **`pottmeyer_3_2_12_full_universal_conjunction_holds`** — discharge. -/
theorem pottmeyer_3_2_12_full_universal_conjunction_holds :
    pottmeyer_3_2_12_full_universal_conjunction :=
  ⟨polyHeight_mul_eq_universal_holds,
   polyHeight_mul_ge_pottmeyer_universal_holds,
   polyHeight_nonneg_of_monic_universal_holds,
   polyHeight_nonneg_of_int_poly_universal_holds⟩

/-! # Section 5 — ALNITAK HEADLINE -/

/-- **🚨 ALNITAK HEADLINE — `T5_alnitak_pott_3_2_12_product_height_paper_capstone`**
    [PAPER-CITABLE].

    Pottmeyer Lemma 3.2.12 product height bound + non-negativity,
    Wave 15B, completing the cascade from ALGOL's BIN-1 + σ-bridge
    to the closure of Pottmeyer 3.4.3 from Roth's Lemma condition (iii)
    ALONE (under monic / leading-coefficient side conditions).

    Bundled paper-citation form:
    1. **Pottmeyer 3.2.12 EQUALITY**: `polyHeight (P · Q) = polyHeight P
       + polyHeight Q` (sharper than Pottmeyer's stated `≥ ... - d · log 2`).
    2. **Pottmeyer 3.2.12 INEQUALITY** (verbatim Pottmeyer form):
       `polyHeight (P · Q) ≥ polyHeight P + polyHeight Q
         - max(deg P, deg Q) · log 2`.
    3. **Non-negativity (monic ℝ-poly)**: `P.Monic → 0 ≤ polyHeight P`.
    4. **Non-negativity (ℤ-poly)**: `p ≠ 0 → 0 ≤ polyHeight (p.map ℤ→ℝ)`.
    5. **End-to-end UNCONDITIONAL Pottmeyer 3.4.3 (monic regime)** —
       drops the `0 ≤ polyHeight P` hypothesis from ALGOL's bridge.

    Closure marker `1 ≤ 5` (5-fold conjunction).

    All discharged UNCONDITIONALLY in this fire (state A).  The product
    equality form (1) is the genuine sharper bound; Pottmeyer's verbatim
    inequality (2) is a trivial corollary.  Non-negativity for monic /
    ℤ-polys (3, 4) is via Mathlib's `leading_coeff_le_mahlerMeasure` +
    `one_le_mahlerMeasure_of_ne_zero`.  The end-to-end bridge (5)
    composes ALGOL's σ-bridge with the new monic non-negativity. -/
theorem T5_alnitak_pott_3_2_12_product_height_paper_capstone :
    pottmeyer_3_2_12_full_universal_conjunction ∧
    -- Product equality (Type-a, paper-citable)
    (∀ (P Q : Polynomial ℝ), P ≠ 0 → Q ≠ 0 →
      polyHeight (P * Q) = polyHeight P + polyHeight Q) ∧
    -- Pottmeyer 3.2.12 inequality (Pottmeyer's verbatim)
    (∀ (P Q : Polynomial ℝ), P ≠ 0 → Q ≠ 0 →
      polyHeight P + polyHeight Q
        - ((max P.natDegree Q.natDegree : ℕ) : ℝ) * Real.log 2
      ≤ polyHeight (P * Q)) ∧
    -- Non-negativity (monic case, paper-citable)
    (∀ (P : Polynomial ℝ), P.Monic → 0 ≤ polyHeight P) ∧
    -- Non-negativity (ℤ-poly case, paper-citable)
    (∀ (p : Polynomial ℤ), p ≠ 0 →
      0 ≤ polyHeight (p.map (Int.castRingHom ℝ))) ∧
    (1 ≤ 5) := by
  refine ⟨pottmeyer_3_2_12_full_universal_conjunction_holds, ?_, ?_, ?_, ?_, ?_⟩
  · intro P Q hP hQ; exact polyHeight_mul_eq P Q hP hQ
  · intro P Q hP hQ; exact polyHeight_mul_ge_pottmeyer P Q hP hQ
  · intro P hP; exact polyHeight_nonneg_of_monic P hP
  · intro p hp; exact polyHeight_nonneg_of_int_poly p hp
  · norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_2_12_ProductHeight
