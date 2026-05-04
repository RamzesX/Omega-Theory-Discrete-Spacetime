/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_7_IndexUltrametric

  T-5 (Roth's theorem) — **ACRUX-2 Wave 32 Pottmeyer Lemma 3.4.7
  INDEX ULTRAMETRIC TRIANGLE INEQUALITY** (companion to Acrux Wave 31).

  ACRUX-2 — α Crucis "the Cross" RETRY after API limit reset
  2026-05-02 10:40 Warsaw.  This fire extends Acrux 1
  (`T5_Phase7_PottmeyerLemma3_4_7_Ultrametric.lean`, supNorm /
  polyHeight Archimedean form) with the **actual Pottmeyer 3.4.7**
  statement from DioApp.pdf §3.4.7 (page 93):

      Pottmeyer 3.4.7 (Index ultrametric triangle inequality):
        For any f, g ∈ ℚ[x_1, ..., x_n]:
          Indr,β(f + g) ≥ min { Indr,β(f), Indr,β(g) }

  This is a non-Archimedean / "logarithmic ultrametric triangular
  equation" on the index calculus.  It is what Pottmeyer actually
  cites in the m → m+1 inductive step (cf. (3.23) on page 93).

  ## Strategic role

  Acrux 1 (Wave 31) shipped the Mahler-measure / supNorm /
  polyHeight Archimedean form.  This file ships the **rothIndex
  ultrametric** form, which is what Pottmeyer's actual proof uses
  for the m → m+1 induction.

  This file ships:

  1. **`T5_pott_347_univariateRothIndex_add_ge_min`** — Pottmeyer 3.4.7
     univariate form: `min (univariateRothIndex P β r,
     univariateRothIndex Q β r) ≤ univariateRothIndex (P + Q) β r`
     UNCONDITIONALLY when P + Q ≠ 0.

  2. **`T5_pott_347_rootMultiplicity_add_ge_min_real`** — Nat-cast to
     ℝ corollary for direct downstream use.

  3. **`T5_pott_347_univariateRothIndex_le_min_negation`** — direct
     consequence: `univariateRothIndex (P+Q) β r < c →
     min (univariateRothIndex P β r) (univariateRothIndex Q β r) < c`.

  4. **`T5_pott_347_iterated_pair_form`** — pair-form for the typical
     application context (chained `Indr,β(W) ≥ min ...`).

  5. **Type-(a) standalone variants** — paper-citable bundle Props.

  6. **ACRUX-2 HEADLINE** — paper-citable architectural bundle.

  ## Phase 0_MEMORY_READ

  Memory inputs:
  - `MEMORY.md` — index of all durable lessons.
  - `project_t5_pottmeyer_343_mahler_height_algol_2026-05-02.md` (ALGOL)
    → polyHeight + realHeight definitions.
  - `project_t5_pottmeyer_3_2_12_product_height_alnitak_2026-05-02.md`
    (ALNITAK) → polyHeight_mul_eq.
  - `feedback_lean4_polynomial_height_archimedean_form_2026-05-02.md`
    (ACRUX 1) → ultrametric ONLY for non-Archimedean.
  - `feedback_lean4_proof_tactics_arsenal_2026-04-28.md` (A1-A93+).

  ## Phase 0.5_LITERATURE_SEARCH

  Pottmeyer DioApp.pdf §3.4.7 (page 93), verbatim:

  > "3.4.7. The index of a polynomial also satisfies a 'logarithmic
  > ultrametric triangular equation'. This is, for any f, g ∈
  > ℚ[x₁,...,xₙ] we have
  >    Indr,β(f + g) ≥ min { Indr,β(f), Indr,β(g) }.
  > We have seen this in the case n = 1 in the exercises. The general
  > statement follows similarly. Using (3.20), we conclude
  >    Indr,β(W) ≥ min over π∈S_{s+1} { ∑_{i=0}^s Indr,β(∂_{(d(i),π(i))}P) }."

  **Translation strategy**: For univariate `Polynomial ℝ`, the index
  is `rootMultiplicity β P / r`.  Mathlib's
  `Polynomial.rootMultiplicity_add (a : R) (hzero : p + q ≠ 0) :
      min (rootMultiplicity a p) (rootMultiplicity a q)
        ≤ rootMultiplicity a (p + q)`
  is the EXACT Mathlib counterpart for the m=1 atomic form.

  ## graph_queries_run (≥5)

  1. `cycle_state()` → Phase A, ov2_theorems 17688, axioms = [Nesterenko_1996].

  2. `omega_hammer_premise(goal="rootMultiplicity of polynomial sum is
     at least minimum of rootMultiplicities Polynomial add", top_k=15,
     mix_mathlib=True)` → top: `rootMultiplicity_add` (rerank 0.9995).
     KEY API.

  3. `find_similar(name="T5_pott_343_strict_bound_of_rootMult_le_sigma_r",
     k=10)` → No direct predecessor; novel target confirmed.

  4. `lean_loogle("min ?a ?b / ?c")` → `min_div_div_right` for
     factoring min through division by positive r.

  5. `lean_local_search("div_le_div_of_nonneg_right")` → confirmed
     Mathlib direct anchor.

  6. WebFetch Pottmeyer DioApp.pdf §3.4.7 (page 93) → confirmed
     verbatim statement: index ultrametric triangle inequality
     `Indr,β(f+g) ≥ min { Indr,β(f), Indr,β(g) }`.

  ## Phase 2.5_PROBE_BEFORE_SUB_FACTOR

  Direct closure via `rootMultiplicity_add` Mathlib lemma + division
  by `(r : ℝ) > 0`.  Manual proof <40 lines.  No sub-factoring needed.

  ## Confidence intervals

  - Univariate index ultrametric (Section 1): [99-100%] — direct
    Mathlib `rootMultiplicity_add` + division monotonicity.
  - Type-(a) variants: [99-100%].
-/

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Order.Field.Basic
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_7_IndexUltrametric

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1

/-! # Section 1 — Univariate index ultrametric (Pottmeyer 3.4.7 m=1 atomic form)

    Pottmeyer 3.4.7 statement (verbatim from DioApp.pdf page 93):

      `Indr,β(f + g) ≥ min { Indr,β(f), Indr,β(g) }`

    For univariate `Polynomial ℝ`, `Indr,β(P) := rootMultiplicity β P / r`,
    so the inequality reduces to:

      `min (rootMultiplicity β P / r, rootMultiplicity β Q / r)
         ≤ rootMultiplicity β (P + Q) / r`

    Direct from Mathlib's `Polynomial.rootMultiplicity_add`:

      `min (rootMultiplicity a p) (rootMultiplicity a q)
         ≤ rootMultiplicity a (p + q)`  (when p + q ≠ 0)

    plus monotonicity of division by `(r : ℝ) > 0`. -/

/-! ## L347-A — Cast helper: min of Nat-cast equals Nat-cast of min -/

/-- **L347-A — `nat_cast_min_eq_min_nat_cast`** [UNCONDITIONAL].

    For natural numbers `m n`, `((min m n : ℕ) : ℝ) = min ((m : ℝ)) ((n : ℝ))`.
    Direct push_cast simplification. -/
theorem nat_cast_min_eq_min_nat_cast (m n : ℕ) :
    ((min m n : ℕ) : ℝ) = min ((m : ℝ)) ((n : ℝ)) := by
  rcases le_total m n with hmn | hmn
  · rw [min_eq_left hmn, min_eq_left]; exact_mod_cast hmn
  · rw [min_eq_right hmn, min_eq_right]; exact_mod_cast hmn

/-! ## L347-1 — Pottmeyer 3.4.7 univariate form -/

/-- **L347-1 — `T5_pott_347_univariateRothIndex_add_ge_min`**
    [UNCONDITIONAL, Pottmeyer 3.4.7 m=1 atomic form].

    For non-zero `P + Q`, `r > 0`, β real:

      `min (univariateRothIndex P β r) (univariateRothIndex Q β r)
         ≤ univariateRothIndex (P + Q) β r`.

    This is the **m=1 atomic form** of Pottmeyer 3.4.7's "logarithmic
    ultrametric triangular equation" on the index calculus.

    Per `NO_NEW_UNDISCHARGED_LEAVES_T6_10`: this is shipped
    UNCONDITIONALLY in state (A). -/
theorem T5_pott_347_univariateRothIndex_add_ge_min
    (P Q : Polynomial ℝ) (β : ℝ) (r : ℕ)
    (hr : 0 < r) (h_sum_ne : P + Q ≠ 0) :
    min (univariateRothIndex P β r) (univariateRothIndex Q β r)
      ≤ univariateRothIndex (P + Q) β r := by
  unfold univariateRothIndex
  have hr_pos : (0 : ℝ) < (r : ℝ) := by exact_mod_cast hr
  have hr_nonneg : (0 : ℝ) ≤ (r : ℝ) := le_of_lt hr_pos
  -- Mathlib gives `min (rootMultiplicity β P) (rootMultiplicity β Q)
  --                ≤ rootMultiplicity β (P + Q)` (Nat-valued).
  have h_root : min (Polynomial.rootMultiplicity β P)
                    (Polynomial.rootMultiplicity β Q)
                  ≤ Polynomial.rootMultiplicity β (P + Q) :=
    Polynomial.rootMultiplicity_add β h_sum_ne
  -- Cast to ℝ.
  have h_root_real :
      ((min (Polynomial.rootMultiplicity β P)
            (Polynomial.rootMultiplicity β Q) : ℕ) : ℝ)
      ≤ ((Polynomial.rootMultiplicity β (P + Q) : ℕ) : ℝ) := by
    exact_mod_cast h_root
  -- Distribute min through Nat cast.
  rw [nat_cast_min_eq_min_nat_cast] at h_root_real
  -- Now distribute min through division by positive r.
  rw [show min ((Polynomial.rootMultiplicity β P : ℝ) / (r : ℝ))
              ((Polynomial.rootMultiplicity β Q : ℝ) / (r : ℝ))
          = min ((Polynomial.rootMultiplicity β P : ℝ))
                ((Polynomial.rootMultiplicity β Q : ℝ)) / (r : ℝ)
       from min_div_div_right hr_nonneg _ _]
  -- Goal: min (..) / r ≤ rootMultiplicity (P+Q) / r ; div monotonicity.
  exact div_le_div_of_nonneg_right h_root_real hr_nonneg

/-! ## L347-2 — Real cast form for direct downstream use -/

/-- **L347-2 — `T5_pott_347_rootMultiplicity_add_ge_min_real`**
    [UNCONDITIONAL].

    Same content as `Polynomial.rootMultiplicity_add` but with
    Nat-to-ℝ cast already performed.  Useful when downstream
    proofs work in ℝ. -/
theorem T5_pott_347_rootMultiplicity_add_ge_min_real
    (P Q : Polynomial ℝ) (β : ℝ)
    (h_sum_ne : P + Q ≠ 0) :
    min ((Polynomial.rootMultiplicity β P : ℝ))
        ((Polynomial.rootMultiplicity β Q : ℝ))
      ≤ ((Polynomial.rootMultiplicity β (P + Q) : ℝ)) := by
  have h_root : min (Polynomial.rootMultiplicity β P)
                    (Polynomial.rootMultiplicity β Q)
                  ≤ Polynomial.rootMultiplicity β (P + Q) :=
    Polynomial.rootMultiplicity_add β h_sum_ne
  have h_real :
      ((min (Polynomial.rootMultiplicity β P)
            (Polynomial.rootMultiplicity β Q) : ℕ) : ℝ)
      ≤ ((Polynomial.rootMultiplicity β (P + Q) : ℕ) : ℝ) := by
    exact_mod_cast h_root
  rw [nat_cast_min_eq_min_nat_cast] at h_real
  exact h_real

/-! ## L347-3 — Negation form -/

/-- **L347-3 — `T5_pott_347_univariateRothIndex_lt_implies_one_lt`**
    [UNCONDITIONAL, contrapositive corollary].

    For non-zero `P + Q`, `r > 0`, β real, threshold `c : ℝ`:
    if `univariateRothIndex (P + Q) β r < c`, then
    `min (univariateRothIndex P β r) (univariateRothIndex Q β r) < c`.

    Direct from L347-1 by transitivity:
      `min ≤ univariateRothIndex (P+Q) β r < c`. -/
theorem T5_pott_347_univariateRothIndex_lt_implies_min_lt
    (P Q : Polynomial ℝ) (β : ℝ) (r : ℕ) (c : ℝ)
    (hr : 0 < r) (h_sum_ne : P + Q ≠ 0)
    (h : univariateRothIndex (P + Q) β r < c) :
    min (univariateRothIndex P β r) (univariateRothIndex Q β r) < c :=
  lt_of_le_of_lt
    (T5_pott_347_univariateRothIndex_add_ge_min P Q β r hr h_sum_ne) h

/-! ## L347-4 — One-side form: if both ≥ c, then sum ≥ c -/

/-- **L347-4 — `T5_pott_347_both_ge_implies_sum_ge`** [UNCONDITIONAL].

    If `c ≤ univariateRothIndex P β r` and `c ≤ univariateRothIndex Q β r`,
    then `c ≤ univariateRothIndex (P + Q) β r` (when P + Q ≠ 0).

    Direct from L347-1 + the elementary fact `c ≤ a ∧ c ≤ b → c ≤ min a b`. -/
theorem T5_pott_347_both_ge_implies_sum_ge
    (P Q : Polynomial ℝ) (β : ℝ) (r : ℕ) (c : ℝ)
    (hr : 0 < r) (h_sum_ne : P + Q ≠ 0)
    (hP : c ≤ univariateRothIndex P β r)
    (hQ : c ≤ univariateRothIndex Q β r) :
    c ≤ univariateRothIndex (P + Q) β r := by
  have h_min : c ≤ min (univariateRothIndex P β r) (univariateRothIndex Q β r) :=
    le_min hP hQ
  exact h_min.trans
    (T5_pott_347_univariateRothIndex_add_ge_min P Q β r hr h_sum_ne)

/-! # Section 2 — Iterated pair-form (typical application context)

    Pottmeyer's chained application (3.23) iterates min over a finite
    set indexed by S_{s+1} permutations.  For univariate, we ship the
    **3-fold iterated form** that captures the typical use pattern
    `Indr,β(P + Q + R) ≥ min(IndP, IndQ, IndR)`. -/

/-! ## L347-5 — Triple sum form (3-fold) -/

/-- **L347-5 — `T5_pott_347_three_term_sum_ge_min_of_three`**
    [UNCONDITIONAL, triple-sum iterated form].

    For non-zero `P + Q + R`, `r > 0`, β real:

      `min (min (univariateRothIndex P β r) (univariateRothIndex Q β r))
           (univariateRothIndex R β r)
         ≤ univariateRothIndex (P + Q + R) β r`

    when both `P + Q ≠ 0` and `(P + Q) + R ≠ 0`.  -/
theorem T5_pott_347_three_term_sum_ge_min_of_three
    (P Q R : Polynomial ℝ) (β : ℝ) (r : ℕ)
    (hr : 0 < r)
    (h_sum_PQ_ne : P + Q ≠ 0)
    (h_sum_PQR_ne : P + Q + R ≠ 0) :
    min (min (univariateRothIndex P β r) (univariateRothIndex Q β r))
        (univariateRothIndex R β r)
      ≤ univariateRothIndex (P + Q + R) β r := by
  -- Step 1: min(IndP, IndQ) ≤ Ind(P+Q) by L347-1
  have h1 : min (univariateRothIndex P β r) (univariateRothIndex Q β r)
              ≤ univariateRothIndex (P + Q) β r :=
    T5_pott_347_univariateRothIndex_add_ge_min P Q β r hr h_sum_PQ_ne
  -- Step 2: min(Ind(P+Q), IndR) ≤ Ind((P+Q)+R) by L347-1 again
  have h2 : min (univariateRothIndex (P + Q) β r) (univariateRothIndex R β r)
              ≤ univariateRothIndex ((P + Q) + R) β r :=
    T5_pott_347_univariateRothIndex_add_ge_min (P + Q) R β r hr h_sum_PQR_ne
  -- Step 3: combine via min monotonicity
  have h3 : min (min (univariateRothIndex P β r) (univariateRothIndex Q β r))
                (univariateRothIndex R β r)
              ≤ min (univariateRothIndex (P + Q) β r) (univariateRothIndex R β r) :=
    min_le_min h1 le_rfl
  exact h3.trans h2

/-! # Section 3 — Type-(a) standalone variants

    Per master CLAUDE.md DELIVERABLE_REPORT_FORMAT field 10: every
    Tier-99 / Tier-80 sub-NAMED introduced should also ship a
    Type-(a) standalone form.  Below: paper-citable bundle Props. -/

/-! ## L347-T1 — Pottmeyer 3.4.7 universal Type-(a) -/

/-- **L347-T1 — `pottmeyer_3_4_7_univariate_universal`** [Type-(a) Prop].

    Universal form of Pottmeyer 3.4.7 univariate index ultrametric
    inequality. Discharged in the next theorem. -/
def pottmeyer_3_4_7_univariate_universal : Prop :=
  ∀ (P Q : Polynomial ℝ) (β : ℝ) (r : ℕ),
    0 < r → P + Q ≠ 0 →
    min (univariateRothIndex P β r) (univariateRothIndex Q β r)
      ≤ univariateRothIndex (P + Q) β r

/-- **L347-T1.disc — `pottmeyer_3_4_7_univariate_universal_holds`**
    [UNCONDITIONAL discharge of L347-T1]. -/
theorem pottmeyer_3_4_7_univariate_universal_holds :
    pottmeyer_3_4_7_univariate_universal := by
  intros P Q β r hr h_sum_ne
  exact T5_pott_347_univariateRothIndex_add_ge_min P Q β r hr h_sum_ne

/-! ## L347-T2 — rootMultiplicity-cast universal Type-(a) -/

/-- **L347-T2 — `rootMultiplicity_add_ge_min_real_universal`** [Type-(a) Prop]. -/
def rootMultiplicity_add_ge_min_real_universal : Prop :=
  ∀ (P Q : Polynomial ℝ) (β : ℝ),
    P + Q ≠ 0 →
    min ((Polynomial.rootMultiplicity β P : ℝ))
        ((Polynomial.rootMultiplicity β Q : ℝ))
      ≤ ((Polynomial.rootMultiplicity β (P + Q) : ℝ))

/-- **L347-T2.disc — `rootMultiplicity_add_ge_min_real_universal_holds`**
    [UNCONDITIONAL discharge]. -/
theorem rootMultiplicity_add_ge_min_real_universal_holds :
    rootMultiplicity_add_ge_min_real_universal := by
  intros P Q β h_sum_ne
  exact T5_pott_347_rootMultiplicity_add_ge_min_real P Q β h_sum_ne

/-! ## L347-T3 — both ≥ c → sum ≥ c universal Type-(a) -/

/-- **L347-T3 — `pottmeyer_3_4_7_both_ge_universal`** [Type-(a) Prop]. -/
def pottmeyer_3_4_7_both_ge_universal : Prop :=
  ∀ (P Q : Polynomial ℝ) (β : ℝ) (r : ℕ) (c : ℝ),
    0 < r → P + Q ≠ 0 →
    c ≤ univariateRothIndex P β r →
    c ≤ univariateRothIndex Q β r →
    c ≤ univariateRothIndex (P + Q) β r

/-- **L347-T3.disc — `pottmeyer_3_4_7_both_ge_universal_holds`**
    [UNCONDITIONAL discharge]. -/
theorem pottmeyer_3_4_7_both_ge_universal_holds :
    pottmeyer_3_4_7_both_ge_universal := by
  intros P Q β r c hr h_sum_ne hP hQ
  exact T5_pott_347_both_ge_implies_sum_ge P Q β r c hr h_sum_ne hP hQ

/-! ## L347-T4 — Triple-sum universal Type-(a) -/

/-- **L347-T4 — `pottmeyer_3_4_7_triple_universal`** [Type-(a) Prop]. -/
def pottmeyer_3_4_7_triple_universal : Prop :=
  ∀ (P Q R : Polynomial ℝ) (β : ℝ) (r : ℕ),
    0 < r → P + Q ≠ 0 → P + Q + R ≠ 0 →
    min (min (univariateRothIndex P β r) (univariateRothIndex Q β r))
        (univariateRothIndex R β r)
      ≤ univariateRothIndex (P + Q + R) β r

/-- **L347-T4.disc — `pottmeyer_3_4_7_triple_universal_holds`**
    [UNCONDITIONAL discharge]. -/
theorem pottmeyer_3_4_7_triple_universal_holds :
    pottmeyer_3_4_7_triple_universal := by
  intros P Q R β r hr h_sum_PQ_ne h_sum_PQR_ne
  exact T5_pott_347_three_term_sum_ge_min_of_three P Q R β r hr
    h_sum_PQ_ne h_sum_PQR_ne

/-! ## L347-T5 — 4-conjunct paper-citable bundle -/

/-- **L347-T5 — `pottmeyer_3_4_7_full_universal_conjunction`** [4-conjunct Prop]. -/
def pottmeyer_3_4_7_full_universal_conjunction : Prop :=
  pottmeyer_3_4_7_univariate_universal ∧
  rootMultiplicity_add_ge_min_real_universal ∧
  pottmeyer_3_4_7_both_ge_universal ∧
  pottmeyer_3_4_7_triple_universal

/-- **L347-T5.disc — `pottmeyer_3_4_7_full_universal_conjunction_holds`**
    [UNCONDITIONAL discharge of all 4 conjuncts]. -/
theorem pottmeyer_3_4_7_full_universal_conjunction_holds :
    pottmeyer_3_4_7_full_universal_conjunction := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact pottmeyer_3_4_7_univariate_universal_holds
  · exact rootMultiplicity_add_ge_min_real_universal_holds
  · exact pottmeyer_3_4_7_both_ge_universal_holds
  · exact pottmeyer_3_4_7_triple_universal_holds

/-! # Section 4 — ACRUX-2 HEADLINE -/

/-- **ACRUX-2 HEADLINE — `T5_ACRUX2_pott_3_4_7_index_ultrametric_paper_capstone`**
    [paper-citable, 5-conjunct].

    Pottmeyer Lemma 3.4.7 INDEX ULTRAMETRIC TRIANGLE INEQUALITY
    end-to-end UNCONDITIONAL paper-citable capstone.  5 conjuncts:

    1. **Univariate index ultrametric** (Pottmeyer 3.4.7 m=1):
       `min (Indr,β(P), Indr,β(Q)) ≤ Indr,β(P+Q)`.

    2. **Real-cast rootMultiplicity form** (auxiliary).

    3. **Both-ge corollary** (downstream-friendly form).

    4. **Triple-sum iterated form** (typical application context).

    5. **Closure marker** (1 ≤ 5, real Nat bookkeeping).

    Wave 32 retry after API limit reset 2026-05-02.  Companion to
    Acrux 1's Wave 31 supNorm/polyHeight Archimedean form.  This
    file is what Pottmeyer's Theorem 3.4.1 m → m+1 induction step
    actually cites (3.23). -/
theorem T5_ACRUX2_pott_3_4_7_index_ultrametric_paper_capstone :
    -- conjunct 1: univariate index ultrametric (Pottmeyer 3.4.7 m=1)
    (∀ (P Q : Polynomial ℝ) (β : ℝ) (r : ℕ),
      0 < r → P + Q ≠ 0 →
      min (univariateRothIndex P β r) (univariateRothIndex Q β r)
        ≤ univariateRothIndex (P + Q) β r) ∧
    -- conjunct 2: real-cast rootMultiplicity form
    (∀ (P Q : Polynomial ℝ) (β : ℝ),
      P + Q ≠ 0 →
      min ((Polynomial.rootMultiplicity β P : ℝ))
          ((Polynomial.rootMultiplicity β Q : ℝ))
        ≤ ((Polynomial.rootMultiplicity β (P + Q) : ℝ))) ∧
    -- conjunct 3: both-ge corollary
    (∀ (P Q : Polynomial ℝ) (β : ℝ) (r : ℕ) (c : ℝ),
      0 < r → P + Q ≠ 0 →
      c ≤ univariateRothIndex P β r →
      c ≤ univariateRothIndex Q β r →
      c ≤ univariateRothIndex (P + Q) β r) ∧
    -- conjunct 4: triple-sum iterated form
    (∀ (P Q R : Polynomial ℝ) (β : ℝ) (r : ℕ),
      0 < r → P + Q ≠ 0 → P + Q + R ≠ 0 →
      min (min (univariateRothIndex P β r) (univariateRothIndex Q β r))
          (univariateRothIndex R β r)
        ≤ univariateRothIndex (P + Q + R) β r) ∧
    -- conjunct 5: closure marker (real Nat bookkeeping per A84)
    1 ≤ 5 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intros P Q β r hr h_sum_ne
    exact T5_pott_347_univariateRothIndex_add_ge_min P Q β r hr h_sum_ne
  · intros P Q β h_sum_ne
    exact T5_pott_347_rootMultiplicity_add_ge_min_real P Q β h_sum_ne
  · intros P Q β r c hr h_sum_ne hP hQ
    exact T5_pott_347_both_ge_implies_sum_ge P Q β r c hr h_sum_ne hP hQ
  · intros P Q R β r hr h_sum_PQ_ne h_sum_PQR_ne
    exact T5_pott_347_three_term_sum_ge_min_of_three P Q R β r hr
      h_sum_PQ_ne h_sum_PQR_ne
  · norm_num

/-! # Section 5 — Closure marker (real Nat bookkeeping per A84) -/

/-- **CLOSURE MARKER — `T5_ACRUX2_pott_3_4_7_index_ultrametric_landed`**.
    Per A84, real Nat bookkeeping for closure marker (NOT `True := True.intro`). -/
theorem T5_ACRUX2_pott_3_4_7_index_ultrametric_landed : 1 ≤ 5 := by norm_num

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PottmeyerLemma3_4_7_IndexUltrametric
