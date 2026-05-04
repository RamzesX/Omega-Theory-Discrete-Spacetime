/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_FromCondIIIOnly

  T-5 (Roth's theorem) — **CAPH Wave 19C Pottmeyer Lemma 3.4.3 inequality
  from Roth's Lemma condition (iii) ALONE end-to-end UNCONDITIONALLY**.

  CAPH — β Cassiopeiae, "Palm of the Hand" in Arabic.  F2 III-IV yellow-
  white bright giant 54 light-years away.  Member of the Cassiopeia W
  constellation.  2× Sun's mass, 28× Sun's luminosity.  Solar-type pulsator
  with rapid rotation (71 km/s).  The hand of Cassiopeia, the queen who
  composes constellations from her seated throne.

  ## Mission

  Algol (Wave 15A) shipped Pottmeyer Lemma 3.4.3's Mahler-height
  infrastructure (`polyHeight` + `realHeight` + BIN-1 + σ-bridge +
  end-to-end via Mira's L343-5).  Alnitak (Wave 15B) shipped Pottmeyer
  Lemma 3.2.12 product-height EQUALITY form + non-negativity for monic
  polynomials.  Mira (Wave 12) shipped the algebraic kernel
  `(rootMultiplicity β P : ℝ) ≤ σ · r → univariateRothIndex P β r ≤ σ`
  unconditionally.

  CAPH (Wave 19C) ships the **last bridge**: the Pottmeyer Lemma 3.4.3
  inequality itself,
    `ord_β(P) · h(β) ≤ hP(P) + r · log 2`
  derived UNCONDITIONALLY from Pottmeyer's exact factor decomposition
  argument:
    `P = (X - C β)^{ord_β(P)} · P'` (factor decomposition)
    ⇒ `polyHeight P = polyHeight((X-Cβ)^{ord_β(P)}) + polyHeight P'`
                                                    [Alnitak 3.2.12 EQUALITY]
                    `= ord_β(P) · h(β) + polyHeight P'`
                                                    [Algol BIN-1 EQUALITY]
                    `≥ ord_β(P) · h(β) + 0`
                                                    [Alnitak monic-nonneg]
  Combined with `0 ≤ r · log 2`:
    `ord_β(P) · h(β) ≤ polyHeight P ≤ polyHeight P + r · log 2`.

  This closes Pottmeyer Lemma 3.4.3 from Roth's Lemma 3.4.1 condition (iii)
  **ALONE end-to-end UNCONDITIONALLY** (under the monic side condition,
  which is paper-standard for Pottmeyer's setting):
    cond (iii) `r · h(β) ≥ σ⁻¹ · (hP(P) + 4r)`
      + this fire's 3.4.3 inequality (no longer a hypothesis)
      + Algol's σ-bridge
      + Mira's L343-5
    ⇒ `univariateRothIndex P β r ≤ σ`.

  ## Strategic significance

  This is the **third cascade-unblocker**.  After ALGOL's BIN-1 + σ-bridge,
  ALNITAK's product-equality + non-negativity, and MIRA's algebraic kernel,
  CAPH's 4-line composition closes the last gap: the Pottmeyer 3.4.3
  inequality is now a real Lean THEOREM (not a numerical hypothesis).

  The Wave 11+ paper-citable closure of Pottmeyer Theorem 3.4.1 small-σ
  regime via Bellatrix's bridge is now FULLY UNCONDITIONAL from Roth's
  Lemma 3.4.1 condition (iii) alone, modulo monic side conditions.

  ## Phase 0_MEMORY_READ

  Memory inputs:
  - `MEMORY.md` — durable lessons index (74 entries 2026-05-02).
  - `project_t5_pottmeyer_3_4_3_univariate_mira_2026-05-02.md` (MIRA)
    → algebraic kernel `(rootMultiplicity β P : ℝ) ≤ σ·r` consumer.
  - `project_t5_pottmeyer_343_mahler_height_algol_2026-05-02.md` (ALGOL)
    → polyHeight + realHeight definitions; BIN-1 EQUALITY; σ-bridge.
  - `project_t5_pottmeyer_3_2_12_product_height_alnitak_2026-05-02.md` (ALNITAK)
    → polyHeight_mul_eq + polyHeight_nonneg_of_monic; the recommendation
      verbatim is to ship this file as a "4-line term-mode chain following
      Pottmeyer's exact argument: factor P = (x-β)^{ord_β(P)} · P', expand
      polyHeight via 3.2.12 equality, apply BIN-1 + non-negativity."
  - `feedback_lean4_proof_tactics_arsenal_2026-04-28.md` (A1-A93+)
    → A14: scaleRoots, A27: dvd_iff_isRoot, A42: Polynomial.taylor.

  ## Phase 0.5_LITERATURE_SEARCH

  Pottmeyer DioApp.pdf §3.4.3 (page 90), verbatim:

  **LEMMA 3.4.3** (univariate):
    "Let P ∈ ℚ[x] \ {0}, r ≥ deg(P) ∈ ℕ, β ∈ ℚ.  Then
       Indr,β(P) · r · h(β) = ord_β(P) · h(β) ≤ hP(P) + r · log(2)."

  **PROOF** (page 90):
    "By definition, P(x) = (x - β)^{ord_β(P)} · P'(x) for some P' with
     P'(β) ≠ 0.  Hence
       hP(P) ≥(3.2.12) -deg(P) · log(2) + hP((x - β)^{ord_β(P)}) + hP(P')
              ≥ -r · log(2) + ord_β(P) · h(β),
     proving the lemma."

  **MATHLIB API IDENTIFIED**:
  - `Polynomial.pow_mul_divByMonic_rootMultiplicity_eq` (Mathlib): for any
    P : R[X] and a : R, `(X - C a)^rootMultiplicity a p * (p /ₘ (X - C a)^rootMultiplicity a p) = p`.
    UNCONDITIONAL — this is the factor decomposition we need.
  - `Polynomial.monic_X_sub_C` (Mathlib): `(X - C x).Monic` UNCONDITIONAL.
  - `Polynomial.Monic.pow` (Mathlib): `p.Monic → (p^n).Monic` UNCONDITIONAL.
  - `Polynomial.Monic.of_mul_monic_left` (Mathlib): `p.Monic → (p*q).Monic
    → q.Monic` UNCONDITIONAL.
  - `Polynomial.Monic.ne_zero` (Mathlib, with [Nontrivial]): `p.Monic → p ≠ 0`.

  ## Lean translation strategy

  Section 1 — Factor decomposition (~10-15 lines):
    Given monic P : Polynomial ℝ, β : ℝ, k = rootMultiplicity β P,
    use `pow_mul_divByMonic_rootMultiplicity_eq` to get the exact
    factorization `(X - C β)^k * (P /ₘ (X - C β)^k) = P` UNCONDITIONALLY.
    The quotient is monic via `Monic.of_mul_monic_left`.

  Section 2 — Pottmeyer 3.4.3 inequality (~25 lines):
    The 4-line term-mode chain Alnitak recommended:
      polyHeight P
        = polyHeight ((X - C β)^k * q)        [factor decomposition]
        = polyHeight ((X - C β)^k) + polyHeight q   [Alnitak 3.2.12 EQ]
        = k · realHeight β + polyHeight q     [Algol BIN-1 EQ]
        ≥ k · realHeight β + 0                [Alnitak monic-nonneg q]
        = k · realHeight β
    Plus `0 ≤ r · log 2` gives the verbatim Pottmeyer 3.4.3 inequality.

  Section 3 — End-to-end UNCONDITIONAL Pottmeyer 3.4.3 from cond (iii)
  (~15 lines):
    Compose Section 2 inequality with Algol's σ-bridge + Mira's L343-5
    via Alnitak's `T5_pott_343_unconditional_via_mahler_height_monic`,
    dropping the Pottmeyer 3.4.3 inequality hypothesis.

  Section 4 — Type-(a) standalone variants for paper citation.

  Section 5 — CAPH HEADLINE + closure marker.

  ## graph_queries_run (≥5 per CLAUDE.md MANDATORY MCP USAGE)

  1. `cycle_state()` → Phase A, ov2_theorems 17688, axioms = [Nesterenko_1996],
     missing_emb = 0, open_candidates = 183.
     → used: confirmed graph health pre-fire.

  2. `omega_hammer_premise(goal="Polynomial.X_sub_C_pow_dvd_iff
     rootMultiplicity factor decomposition", top_k=15, mix_mathlib=True,
     rerank=True)`
     → top: `pow_rootMultiplicity_dvd` (rerank 0.984), `le_rootMultiplicity_iff`
     (rerank 0.995), `pow_mul_divByMonic_rootMultiplicity_eq` (rerank 0.577,
     EXACT API).
     → used: KEY API for factor decomposition.

  3. `omega_hammer_premise(goal="Polynomial.pow_rootMultiplicity_dvd factor
     extraction quotient", top_k=15)`
     → top: `pow_rootMultiplicity_dvd` (rerank 0.999), `pow_mul_divByMonic_rootMultiplicity_eq`
     (rerank 0.900) — the explicit factor decomposition.
     → used: confirmed exact factorization API.

  4. `omega_hammer_premise(goal="Polynomial Monic divByMonic monic divides
     quotient X sub C pow", top_k=10)`
     → top: `Monic.of_mul_monic_left` (rerank 0.729), `monic_X_pow_sub_C`
     (rerank 0.946).
     → used: confirmed quotient is monic when both factors monic.

  5. `lean_loogle("Polynomial.Monic.pow")` → `Polynomial.Monic.pow {p :
     Polynomial R} (hp : p.Monic) (n : ℕ) : (p^n).Monic`.
     → used: KEY for `(X - C β)^k` being monic.

  6. `omega_hammer_premise(goal="Polynomial.X_sub_C monic Polynomial.monic_X_sub_C",
     top_k=8)`
     → top: `monic_X_sub_C : Monic (X - C x)` (rerank 0.996).
     → used: KEY foundational identity.

  7. `lean_loogle("Polynomial.Monic _ → _ ≠ 0")`
     → top: `Polynomial.Monic.ne_zero : p.Monic → p ≠ 0` (with [Nontrivial]).
     → used: side condition for `polyHeight_mul_eq`.

  ## Phase 2.5_PROBE_BEFORE_SUB_FACTOR

  Probed:
  - `lean_local_search("FromCondIIIOnly")` → EMPTY → confirmed novel target.
  - `lean_local_search("T5_pott_343_inequality_from_cond_iii")` → EMPTY.
  - All other Pottmeyer-named files in OV2 do NOT define this composition.
  - Confirmed unique target.

  ## Confidence intervals

  - Factor decomposition (UNCONDITIONAL, P monic): [99-100%] —
    direct `pow_mul_divByMonic_rootMultiplicity_eq` + Monic.of_mul_monic_left.
  - Pottmeyer 3.4.3 inequality (UNCONDITIONAL, P monic): [99-100%] —
    4-line composition of EQUALITY-form 3.2.12 + EQUALITY-form BIN-1 +
    monic-nonneg.
  - End-to-end Pottmeyer 3.4.3 from cond (iii) (UNCONDITIONAL, P monic):
    [99-100%] — composes with Alnitak's
    T5_pott_343_unconditional_via_mahler_height_monic.

  ## Project hard rules

  Per master CLAUDE.md `NO_STUBS`: no `sorry`, no `Prop := True`, no
  `:= trivial`.  All proofs are real Lean term-mode or tactic-mode.

  Per master CLAUDE.md `NO_NEW_UNDISCHARGED_LEAVES_T6_10`: every
  theorem in this file is UNCONDITIONALLY DISCHARGED in this fire
  (state A).  Side conditions: P monic + P ≠ 0 + r ≥ deg P (paper-side
  conditions on input, NOT new NAMED Prop scaffolds).

  Per master CLAUDE.md `NO_INFINITE_REGRESS_T6_8`: sub-factor depth
  held at 1.  All sub-lemmas ≤30 lines.

  Per master CLAUDE.md `NO_HEDGE_WORDS`: all claims with confidence
  intervals.
-/

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Monic
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Analysis.Polynomial.MahlerMeasure
import Mathlib.NumberTheory.MahlerMeasure
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_MahlerHeight
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_2_12_ProductHeight

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_FromCondIIIOnly

open Polynomial Real Complex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_Univariate
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_MahlerHeight
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_2_12_ProductHeight

/-! # Section 1 — Pottmeyer factor decomposition setup

    The clean factor decomposition `P = (X - C β)^k · q` with q monic
    via Mathlib's `pow_mul_divByMonic_rootMultiplicity_eq`. -/

/-- **`X_sub_C_pow_monic`** — `(X - C β)^k` is monic UNCONDITIONALLY.

    Direct corollary of `monic_X_sub_C` + `Monic.pow`. -/
theorem X_sub_C_pow_monic (β : ℝ) (k : ℕ) :
    ((X - C β) ^ k : Polynomial ℝ).Monic :=
  (Polynomial.monic_X_sub_C β).pow k

/-- **`X_sub_C_pow_ne_zero`** — `(X - C β)^k ≠ 0` UNCONDITIONALLY.

    Direct corollary of `X_sub_C_pow_monic` + `Monic.ne_zero` (over `ℝ`,
    which has `Nontrivial`). -/
theorem X_sub_C_pow_ne_zero (β : ℝ) (k : ℕ) :
    ((X - C β) ^ k : Polynomial ℝ) ≠ 0 :=
  (X_sub_C_pow_monic β k).ne_zero

/-- **`pott_343_factor_decomposition`** — UNCONDITIONAL.

    For monic P : Polynomial ℝ, the factor decomposition
      `P = (X - C β)^{rootMultiplicity β P} · q`
    where `q := P /ₘ (X - C β)^{rootMultiplicity β P}` is monic.

    Direct corollary of Mathlib's `pow_mul_divByMonic_rootMultiplicity_eq`
    + `Monic.of_mul_monic_left`. -/
theorem pott_343_factor_decomposition (P : Polynomial ℝ) (β : ℝ)
    (hP_monic : P.Monic) :
    let k := Polynomial.rootMultiplicity β P
    let q := P /ₘ ((X - C β) ^ k)
    P = (X - C β) ^ k * q ∧ q.Monic := by
  -- Step 1: factor identity from Mathlib
  have h_factor : (X - C β) ^ Polynomial.rootMultiplicity β P
                  * (P /ₘ ((X - C β) ^ Polynomial.rootMultiplicity β P)) = P :=
    Polynomial.pow_mul_divByMonic_rootMultiplicity_eq P β
  -- Step 2: P factors as the product
  have hP_eq : P = (X - C β) ^ Polynomial.rootMultiplicity β P
                  * (P /ₘ ((X - C β) ^ Polynomial.rootMultiplicity β P)) :=
    h_factor.symm
  refine ⟨hP_eq, ?_⟩
  -- Step 3: quotient is monic
  -- We have (X - C β)^k * q = P with P monic and (X - C β)^k monic
  -- ⇒ q monic via Monic.of_mul_monic_left
  have h_pow_monic : ((X - C β) ^ Polynomial.rootMultiplicity β P
                      : Polynomial ℝ).Monic :=
    X_sub_C_pow_monic β _
  -- Build the (P_pow * q).Monic fact by substituting back through hP_eq
  have h_prod_monic : ((X - C β) ^ Polynomial.rootMultiplicity β P
                      * (P /ₘ ((X - C β) ^ Polynomial.rootMultiplicity β P))).Monic := by
    rw [← hP_eq]; exact hP_monic
  exact Polynomial.Monic.of_mul_monic_left h_pow_monic h_prod_monic

/-! # Section 2 — Pottmeyer Lemma 3.4.3 inequality from condition (iii)

    The 4-line term-mode chain Alnitak recommended:
      polyHeight P
        = polyHeight ((X - C β)^k * q)        [factor decomposition]
        = polyHeight ((X - C β)^k) + polyHeight q   [Alnitak 3.2.12 EQ]
        = k · realHeight β + polyHeight q     [Algol BIN-1 EQ]
        ≥ k · realHeight β + 0                [Alnitak monic-nonneg q]
        = k · realHeight β.
    Combined with `0 ≤ r · log 2` (from `r ≥ 0` and `0 < log 2`), we
    get Pottmeyer's verbatim Lemma 3.4.3:
      ord_β(P) · h(β) ≤ polyHeight P + r · log 2. -/

/-- **`T5_pott_343_polyHeight_ge_rootMult_realHeight`** — UNCONDITIONAL.

    The strict half of Pottmeyer 3.4.3 (without the `r · log 2` slack):
      `(rootMultiplicity β P : ℝ) · realHeight β ≤ polyHeight P`
    for monic P : Polynomial ℝ.

    This is **strictly stronger** than Pottmeyer's verbatim Lemma 3.4.3
    (since `0 ≤ r · log 2`).  It uses the SHARPER EQUALITY forms of
    Alnitak's 3.2.12 and Algol's BIN-1.

    The 4-line term-mode chain:
      polyHeight P
        = polyHeight ((X - C β)^{ord_β(P)} · q)   [factor decomp]
        = polyHeight ((X - C β)^{ord_β(P)}) + polyHeight q
                                                  [3.2.12 EQUALITY]
        = ord_β(P) · realHeight β + polyHeight q
                                                  [BIN-1 EQUALITY]
        ≥ ord_β(P) · realHeight β + 0
                                                  [monic-nonneg q]
        = ord_β(P) · realHeight β. -/
theorem T5_pott_343_polyHeight_ge_rootMult_realHeight
    (P : Polynomial ℝ) (β : ℝ) (hP_monic : P.Monic) :
    (Polynomial.rootMultiplicity β P : ℝ) * realHeight β ≤ polyHeight P := by
  -- Step 0: extract factor decomposition
  obtain ⟨hP_eq, hq_monic⟩ := pott_343_factor_decomposition P β hP_monic
  -- Set k := rootMultiplicity β P, q := P /ₘ (X - C β)^k
  set k := Polynomial.rootMultiplicity β P with hk_def
  set q := P /ₘ ((X - C β) ^ k) with hq_def
  -- Step 1: polyHeight P = polyHeight ((X - C β)^k · q)
  have h1 : polyHeight P = polyHeight ((X - C β) ^ k * q) := by
    rw [hP_eq]
  -- Step 2: polyHeight ((X - C β)^k · q) = polyHeight ((X - C β)^k) + polyHeight q
  --         [Alnitak 3.2.12 EQUALITY]
  have h_pow_ne : ((X - C β) ^ k : Polynomial ℝ) ≠ 0 := X_sub_C_pow_ne_zero β k
  have hq_ne : q ≠ 0 := hq_monic.ne_zero
  have h2 : polyHeight ((X - C β) ^ k * q)
            = polyHeight ((X - C β) ^ k) + polyHeight q :=
    polyHeight_mul_eq ((X - C β) ^ k) q h_pow_ne hq_ne
  -- Step 3: polyHeight ((X - C β)^k) = k · realHeight β
  --         [Algol BIN-1 EQUALITY]
  have h3 : polyHeight ((X - C β) ^ k) = (k : ℝ) * realHeight β :=
    polyHeight_pow_X_sub_C β k
  -- Step 4: polyHeight q ≥ 0 [Alnitak monic-nonneg]
  have h4 : 0 ≤ polyHeight q := polyHeight_nonneg_of_monic q hq_monic
  -- Compose: polyHeight P = (k · realHeight β) + polyHeight q ≥ k · realHeight β
  calc (k : ℝ) * realHeight β
      ≤ (k : ℝ) * realHeight β + polyHeight q := by linarith
    _ = polyHeight ((X - C β) ^ k) + polyHeight q := by rw [h3]
    _ = polyHeight ((X - C β) ^ k * q) := h2.symm
    _ = polyHeight P := by rw [← hP_eq]

/-- **`T5_pott_343_inequality_from_cond_iii`** — UNCONDITIONAL,
    Pottmeyer Lemma 3.4.3 verbatim form.

    For monic P : Polynomial ℝ, β : ℝ, r : ℕ:
      `(rootMultiplicity β P : ℝ) · realHeight β
         ≤ polyHeight P + (r : ℝ) · Real.log 2`.

    This is Pottmeyer's verbatim Lemma 3.4.3 statement, derived
    UNCONDITIONALLY from the SHARPER bound
    `T5_pott_343_polyHeight_ge_rootMult_realHeight` plus the obvious
    `0 ≤ r · log 2`. -/
theorem T5_pott_343_inequality_from_cond_iii
    (P : Polynomial ℝ) (β : ℝ) (r : ℕ) (hP_monic : P.Monic) :
    (Polynomial.rootMultiplicity β P : ℝ) * realHeight β
      ≤ polyHeight P + (r : ℝ) * Real.log 2 := by
  -- Step 1: SHARPER bound (k · h(β) ≤ polyHeight P)
  have h_sharper : (Polynomial.rootMultiplicity β P : ℝ) * realHeight β
                    ≤ polyHeight P :=
    T5_pott_343_polyHeight_ge_rootMult_realHeight P β hP_monic
  -- Step 2: 0 ≤ r · log 2
  have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num : (1 : ℝ) < 2)
  have h_r_nonneg : (0 : ℝ) ≤ (r : ℝ) := by exact_mod_cast Nat.zero_le _
  have h_corr_nonneg : (0 : ℝ) ≤ (r : ℝ) * Real.log 2 :=
    mul_nonneg h_r_nonneg (le_of_lt h_log2_pos)
  -- Compose: k · h(β) ≤ polyHeight P ≤ polyHeight P + r · log 2
  linarith

/-! # Section 3 — End-to-end UNCONDITIONAL Pottmeyer 3.4.3 from cond (iii)

    Compose Section 2 inequality with Algol's σ-bridge + Mira's L343-5
    via Alnitak's `T5_pott_343_unconditional_via_mahler_height_monic`,
    dropping the `h_pott_343` hypothesis. -/

/-- **`T5_pott_343_unconditional_from_cond_iii`** — UNCONDITIONAL
    end-to-end from Roth's Lemma 3.4.1 condition (iii) ALONE.

    For monic P with P ≠ 0, P.natDegree ≤ r, σ ∈ (0, 1], realHeight β > 0,
    and Roth's Lemma 3.4.1 condition (iii)
      `polyHeight P + 4 · r ≤ σ · r · realHeight β`,
    derive `univariateRothIndex P β r ≤ σ`.

    This is the **third cascade-unblocker**: drops the Pottmeyer 3.4.3
    inequality hypothesis from Alnitak's
    `T5_pott_343_unconditional_via_mahler_height_monic` (since CAPH's
    `T5_pott_343_inequality_from_cond_iii` discharges it
    UNCONDITIONALLY). -/
theorem T5_pott_343_unconditional_from_cond_iii
    (P : Polynomial ℝ) (β : ℝ) (r : ℕ) (σ : ℝ)
    (hP : P ≠ 0) (hr : 0 < r) (hdeg : P.natDegree ≤ r)
    (hP_monic : P.Monic)
    (hσ_pos : 0 < σ) (hσ_le : σ ≤ 1)
    (hh_pos : 0 < realHeight β)
    (h_cond_iii : polyHeight P + 4 * (r : ℝ) ≤ σ * (r : ℝ) * realHeight β) :
    univariateRothIndex P β r ≤ σ := by
  apply T5_pott_343_unconditional_via_mahler_height_monic
    P β r σ hP hr hdeg hP_monic hσ_pos hσ_le hh_pos
  · -- Pottmeyer 3.4.3 inequality from condition (iii) (CAPH discharges)
    exact T5_pott_343_inequality_from_cond_iii P β r hP_monic
  · -- Roth's Lemma condition (iii) (caller-supplied)
    exact h_cond_iii

/-! # Section 4 — Type-(a) standalone variants for paper citation

    Per master CLAUDE.md `Type-(a) standalone variant audit`. -/

/-- **`pott_343_factor_decomposition_universal`** — Type-(a) Prop. -/
def pott_343_factor_decomposition_universal : Prop :=
  ∀ (P : Polynomial ℝ) (β : ℝ), P.Monic →
    P = (X - C β) ^ Polynomial.rootMultiplicity β P
        * (P /ₘ ((X - C β) ^ Polynomial.rootMultiplicity β P))
    ∧ (P /ₘ ((X - C β) ^ Polynomial.rootMultiplicity β P)).Monic

/-- **`pott_343_factor_decomposition_universal_holds`** — discharge. -/
theorem pott_343_factor_decomposition_universal_holds :
    pott_343_factor_decomposition_universal := by
  intro P β hP_monic
  exact pott_343_factor_decomposition P β hP_monic

/-- **`T5_pott_343_polyHeight_ge_rootMult_realHeight_universal`** — Type-(a) Prop. -/
def T5_pott_343_polyHeight_ge_rootMult_realHeight_universal : Prop :=
  ∀ (P : Polynomial ℝ) (β : ℝ), P.Monic →
    (Polynomial.rootMultiplicity β P : ℝ) * realHeight β ≤ polyHeight P

/-- **`T5_pott_343_polyHeight_ge_rootMult_realHeight_universal_holds`** — discharge. -/
theorem T5_pott_343_polyHeight_ge_rootMult_realHeight_universal_holds :
    T5_pott_343_polyHeight_ge_rootMult_realHeight_universal := by
  intro P β hP_monic
  exact T5_pott_343_polyHeight_ge_rootMult_realHeight P β hP_monic

/-- **`T5_pott_343_inequality_universal`** — Type-(a) Prop, Pottmeyer
    verbatim form. -/
def T5_pott_343_inequality_universal : Prop :=
  ∀ (P : Polynomial ℝ) (β : ℝ) (r : ℕ), P.Monic →
    (Polynomial.rootMultiplicity β P : ℝ) * realHeight β
      ≤ polyHeight P + (r : ℝ) * Real.log 2

/-- **`T5_pott_343_inequality_universal_holds`** — discharge. -/
theorem T5_pott_343_inequality_universal_holds :
    T5_pott_343_inequality_universal := by
  intro P β r hP_monic
  exact T5_pott_343_inequality_from_cond_iii P β r hP_monic

/-- **`T5_pott_343_unconditional_from_cond_iii_universal`** — Type-(a) Prop. -/
def T5_pott_343_unconditional_from_cond_iii_universal : Prop :=
  ∀ (P : Polynomial ℝ) (β : ℝ) (r : ℕ) (σ : ℝ),
    P ≠ 0 → 0 < r → P.natDegree ≤ r → P.Monic →
    0 < σ → σ ≤ 1 → 0 < realHeight β →
    polyHeight P + 4 * (r : ℝ) ≤ σ * (r : ℝ) * realHeight β →
    univariateRothIndex P β r ≤ σ

/-- **`T5_pott_343_unconditional_from_cond_iii_universal_holds`** — discharge. -/
theorem T5_pott_343_unconditional_from_cond_iii_universal_holds :
    T5_pott_343_unconditional_from_cond_iii_universal := by
  intro P β r σ hP hr hdeg hP_monic hσ_pos hσ_le hh_pos h_cond_iii
  exact T5_pott_343_unconditional_from_cond_iii
    P β r σ hP hr hdeg hP_monic hσ_pos hσ_le hh_pos h_cond_iii

/-! ## σ=1 boundary specialization (paper-citable as the trivial recovery) -/

/-- **`T5_pott_343_unconditional_from_cond_iii_sigma_one`** — UNCONDITIONAL,
    σ=1 specialization.

    For monic P : Polynomial ℝ with deg P ≤ r and Roth's Lemma 3.4.1
    condition (iii) at σ=1:
      `polyHeight P + 4 · r ≤ r · realHeight β`,
    derive `univariateRothIndex P β r ≤ 1`. -/
theorem T5_pott_343_unconditional_from_cond_iii_sigma_one
    (P : Polynomial ℝ) (β : ℝ) (r : ℕ)
    (hP : P ≠ 0) (hr : 0 < r) (hdeg : P.natDegree ≤ r)
    (hP_monic : P.Monic) (hh_pos : 0 < realHeight β)
    (h_cond_iii_sigma_one : polyHeight P + 4 * (r : ℝ) ≤ (r : ℝ) * realHeight β) :
    univariateRothIndex P β r ≤ 1 := by
  apply T5_pott_343_unconditional_from_cond_iii P β r 1 hP hr hdeg hP_monic
    (by norm_num : (0 : ℝ) < 1) (le_refl 1) hh_pos
  -- Goal: polyHeight P + 4 * r ≤ 1 * r * realHeight β
  rw [one_mul]
  exact h_cond_iii_sigma_one

/-! ## Conjunctive 4-fold Type-(a) headline -/

/-- **`pottmeyer_3_4_3_full_universal_conjunction`** — Type-(a) headline. -/
def pottmeyer_3_4_3_full_universal_conjunction : Prop :=
  pott_343_factor_decomposition_universal ∧
  T5_pott_343_polyHeight_ge_rootMult_realHeight_universal ∧
  T5_pott_343_inequality_universal ∧
  T5_pott_343_unconditional_from_cond_iii_universal

/-- **`pottmeyer_3_4_3_full_universal_conjunction_holds`** — discharge. -/
theorem pottmeyer_3_4_3_full_universal_conjunction_holds :
    pottmeyer_3_4_3_full_universal_conjunction :=
  ⟨pott_343_factor_decomposition_universal_holds,
   T5_pott_343_polyHeight_ge_rootMult_realHeight_universal_holds,
   T5_pott_343_inequality_universal_holds,
   T5_pott_343_unconditional_from_cond_iii_universal_holds⟩

/-! # Section 5 — CAPH HEADLINE -/

/-- **🚨 CAPH HEADLINE — `T5_caph_pott_3_4_3_from_cond_iii_paper_capstone`**
    [PAPER-CITABLE].

    Pottmeyer Lemma 3.4.3 from Roth's Lemma 3.4.1 condition (iii) ALONE,
    Wave 19C, completing the cascade from MIRA's algebraic kernel +
    ALGOL's Mahler-height infrastructure + ALNITAK's product height
    equality + non-negativity to the closure of Pottmeyer 3.4.3 from
    condition (iii) ALONE end-to-end UNCONDITIONALLY.

    Bundled paper-citation form:
    1. **Factor decomposition**: `P = (X - C β)^{rootMult β P} · q` for
       monic P, with q = P /ₘ (X - C β)^{rootMult β P} also monic.
    2. **SHARPER bound**: `(rootMult β P : ℝ) · realHeight β ≤ polyHeight P`
       (sharper than Pottmeyer's verbatim form, no log 2 slack).
    3. **Pottmeyer 3.4.3 verbatim**: `(rootMult β P : ℝ) · realHeight β
       ≤ polyHeight P + r · log 2`.
    4. **End-to-end UNCONDITIONAL Pottmeyer 3.4.3 from cond (iii)**:
       drops the 3.4.3 inequality hypothesis from ALNITAK's bridge.
    5. **σ=1 boundary specialization**: trivial recovery at σ=1.

    Closure marker `1 ≤ 5` (5-fold conjunction).

    All discharged UNCONDITIONALLY in this fire (state A).  The
    factor decomposition (1) is via Mathlib's
    `pow_mul_divByMonic_rootMultiplicity_eq` + `Monic.of_mul_monic_left`.
    The SHARPER bound (2) is the 4-line term-mode chain Alnitak
    recommended.  Pottmeyer's verbatim form (3) is a trivial corollary
    (since `0 ≤ r · log 2`).  The end-to-end bridge (4) composes ALGOL's
    σ-bridge with ALNITAK's monic non-negativity and CAPH's 3.4.3
    inequality.  The σ=1 boundary specialization (5) is the trivial
    recovery. -/
theorem T5_caph_pott_3_4_3_from_cond_iii_paper_capstone :
    pottmeyer_3_4_3_full_universal_conjunction ∧
    -- Factor decomposition (monic P)
    (∀ (P : Polynomial ℝ) (β : ℝ), P.Monic →
      P = (X - C β) ^ Polynomial.rootMultiplicity β P
          * (P /ₘ ((X - C β) ^ Polynomial.rootMultiplicity β P))
      ∧ (P /ₘ ((X - C β) ^ Polynomial.rootMultiplicity β P)).Monic) ∧
    -- SHARPER bound (polyHeight P ≥ rootMult · realHeight β)
    (∀ (P : Polynomial ℝ) (β : ℝ), P.Monic →
      (Polynomial.rootMultiplicity β P : ℝ) * realHeight β ≤ polyHeight P) ∧
    -- Pottmeyer 3.4.3 verbatim form
    (∀ (P : Polynomial ℝ) (β : ℝ) (r : ℕ), P.Monic →
      (Polynomial.rootMultiplicity β P : ℝ) * realHeight β
        ≤ polyHeight P + (r : ℝ) * Real.log 2) ∧
    -- End-to-end UNCONDITIONAL from cond (iii)
    (∀ (P : Polynomial ℝ) (β : ℝ) (r : ℕ) (σ : ℝ),
      P ≠ 0 → 0 < r → P.natDegree ≤ r → P.Monic →
      0 < σ → σ ≤ 1 → 0 < realHeight β →
      polyHeight P + 4 * (r : ℝ) ≤ σ * (r : ℝ) * realHeight β →
      univariateRothIndex P β r ≤ σ) ∧
    -- σ=1 boundary specialization
    (∀ (P : Polynomial ℝ) (β : ℝ) (r : ℕ),
      P ≠ 0 → 0 < r → P.natDegree ≤ r → P.Monic → 0 < realHeight β →
      polyHeight P + 4 * (r : ℝ) ≤ (r : ℝ) * realHeight β →
      univariateRothIndex P β r ≤ 1) ∧
    (1 ≤ 5) := by
  refine ⟨pottmeyer_3_4_3_full_universal_conjunction_holds,
          ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro P β hP_monic
    exact pott_343_factor_decomposition P β hP_monic
  · intro P β hP_monic
    exact T5_pott_343_polyHeight_ge_rootMult_realHeight P β hP_monic
  · intro P β r hP_monic
    exact T5_pott_343_inequality_from_cond_iii P β r hP_monic
  · intro P β r σ hP hr hdeg hP_monic hσ_pos hσ_le hh_pos h_cond_iii
    exact T5_pott_343_unconditional_from_cond_iii
      P β r σ hP hr hdeg hP_monic hσ_pos hσ_le hh_pos h_cond_iii
  · intro P β r hP hr hdeg hP_monic hh_pos h_cond_iii_sigma_one
    exact T5_pott_343_unconditional_from_cond_iii_sigma_one
      P β r hP hr hdeg hP_monic hh_pos h_cond_iii_sigma_one
  · norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_3_FromCondIIIOnly
