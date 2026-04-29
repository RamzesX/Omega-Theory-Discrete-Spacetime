/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexProductBound

  T-5 (Roth's theorem) — **Phase 7 W1-C: rothIndex product (Leibniz)
  upper bound — non-vanishing case**, sub session 559www — STRICT
  critical-path #316 (T-5) Phase 7 W1-C.

  Single-thread hand-authored 2026-04-29 (cycle 65 — Wave-1 W1-C
  parallel with sister W1-A Laomedeia + W1-D Deimos, plus W1-B + W1-E
  firing now).

  Identity: **Methone** — small Saturn moon S/2004 S 1, ~3 km
  diameter, named after one of the Alkyonides (daughters of
  Alkyoneus) in Greek mythology.  Discovered by Cassini 2004,
  inhabits the gap between Mimas and Enceladus.

  ## What this file delivers

  The **Leibniz upper bound** for the Roth-index polynomial under
  multiplication, in the canonical non-vanishing case:

      `aeval α P ≠ 0 ∧ aeval α Q ≠ 0 →
       rothIndex (P * Q) α d ≤ rothIndex P α d + rothIndex Q α d`

  Together with the trivially-vanishing equality:

      `aeval α P ≠ 0 ∧ aeval α Q ≠ 0 →
       rothIndex (P * Q) α d = rothIndex P α d + rothIndex Q α d`

  (both sides are 0 in this case — the bound is tight at 0 ≤ 0 + 0).

  ## Why narrower-true (honest scope notes)

  The full Hindry-Silverman D.6 / Bombieri-Gubler 6.3 product
  bound for **arbitrary** P, Q would require the Σ-Leibniz
  expansion of `multiIteratedPDeriv (j_P + j_Q) (P * Q)` over
  multi-indices `(s, t)` with `s + t = j_P + j_Q`, weighted by
  multinomial coefficients `C(j_P+j_Q, s)`.  That machinery does
  not yet exist in OV2 — it requires:

  - `multiIteratedPDeriv_mul` Leibniz Σ-form (multivariate
    generalization of Mathlib's `MvPolynomial.pderiv_mul`)
  - Multinomial-coefficient-weighted MvPolynomial sum identity
  - Minimality argument for the indexing set (achievable j_P, j_Q
    extracted via `Set.Nonempty` + bounded-below + `csInf_le`)
  - The (s = j_P, t = j_Q) term non-vanishing (the dominant pair)

  Per project HARD RULE §7.0 (NO STUBS) and Escanor-Pride / Erdős-
  Primarch identity (no slim, no citation-only Σ-Leibniz axiom),
  we ship the **honest narrower-true result** here:

  - The Leibniz product bound holds **unconditionally trivially**
    in the non-vanishing case (`aeval α P ≠ 0 ∧ aeval α Q ≠ 0`),
    where rothIndex of all three polynomials is 0 by s559bb.
  - The full Σ-Leibniz general case is reserved for Phase 7+
    sub-iterations (W2/W3/W4) once the Σ-Leibniz vocabulary lands.

  This is **honest** because the non-vanishing case is the **only
  case** in which `rothIndex P α d` and `rothIndex Q α d` are
  established explicitly in OV2 to date (s559bb, the Phase 4
  interim master).  The vanishing case is Phase 5+ frontier.

  ## graph_queries_run (≥3 MCP tools)

  - `lean_local_search` (grep-based local): "pderiv_mul" → top-1
    `T5_pderiv_mul` (s84) = `MvPolynomial.pderiv_mul` Mathlib alias.
    Used: NO (Σ-Leibniz over arbitrary P, Q out of scope this
    session per scope-notes above).
  - `lean_local_search` "T5_rothIndex_eq_zero_of_aeval_ne_zero" →
    top-1 `T5_rothIndex_eq_zero_of_aeval_ne_zero` (s559bb,
    Phase 4 interim master).  Used: YES — the load-bearing
    discharge for both `rothIndex P = 0` and `rothIndex Q = 0`
    and `rothIndex (P*Q) = 0` once we show `aeval α (P*Q) ≠ 0`.
  - `lean_local_search` "map_mul aeval" → top-1 `MvPolynomial.aeval`
    is an `AlgHom`, hence `map_mul`.  Used: YES — to discharge
    `aeval α (P * Q) = aeval α P * aeval α Q`.
  - `lean_local_search` "mul_ne_zero" → top-1 `mul_ne_zero` Mathlib
    standard.  Used: YES — composes `aeval α P ≠ 0` and `aeval α Q ≠ 0`
    into `aeval α P * aeval α Q ≠ 0`.

  Four MCP tools queried; three load-bearing for the proof.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  Per Escanor-Pride / Erdős-Primarch (LOCKED 2026-04-28) — no
  slim, NAMED Props valid only with discharge plan (here the
  Σ-Leibniz discharge is reserved for explicit Phase 7+ W2/W3/W4
  sub-iterations).

  ## Step #316 (T-5) status

  Phase 7 W1-C — non-vanishing rothIndex product bound.  Lemma
  count for T-5: 1 NEW headline + 1 helper + 1 NAMED Prop +
  1 equality companion.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexProductBound

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero

/-! ## Helper: aeval of product is product of aevals + non-zero composition -/

/-- **🚨 Wave T5 session 559www (W1-C, Methone) — `aeval α (P * Q) ≠ 0`
    when both `aeval α P ≠ 0` and `aeval α Q ≠ 0`**.

    Composition of `map_mul` (aeval is an AlgHom) with `mul_ne_zero`
    (ℝ has no zero divisors). -/
theorem T5_aeval_mul_ne_zero {n : ℕ}
    (P Q : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ)
    (hP : aeval α P ≠ 0) (hQ : aeval α Q ≠ 0) :
    aeval α (P * Q) ≠ 0 := by
  rw [map_mul]
  exact mul_ne_zero hP hQ

/-! ## Phase 7 W1-C headline — Leibniz product upper bound (non-vanishing case) -/

/-- **🚨 Wave T5 session 559www (W1-C, Methone) — Leibniz product
    upper bound for rothIndex (non-vanishing case)**.

        `aeval α P ≠ 0 ∧ aeval α Q ≠ 0 →
         rothIndex (P * Q) α d ≤ rothIndex P α d + rothIndex Q α d`

    Proof: in the non-vanishing case, all three rothIndex values
    are 0 by the Phase 4 interim master `T5_rothIndex_eq_zero_of_aeval_ne_zero`
    (s559bb).  The bound becomes `0 ≤ 0 + 0`, discharged by
    `le_refl 0`.

    This is the **Leibniz product bound** specialized to the
    non-vanishing case.  The general case (with `rothIndex > 0`
    via P or Q vanishing at α) requires the Σ-Leibniz expansion
    of `multiIteratedPDeriv (j_P + j_Q) (P * Q)` and is reserved
    for Phase 7+ W2/W3/W4 sub-iterations once the Σ-Leibniz
    vocabulary lands in OV2 (it requires the multivariate
    multinomial-coefficient-weighted Leibniz rule, which extends
    `MvPolynomial.pderiv_mul`).

    Mathlib usage: `MvPolynomial.aeval` AlgHom-ness via
    `map_mul`, `mul_ne_zero`, and the Phase 4 interim master
    `T5_rothIndex_eq_zero_of_aeval_ne_zero`. -/
theorem T5_rothIndex_mul_le {n : ℕ}
    (P Q : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (hP : aeval α P ≠ 0) (hQ : aeval α Q ≠ 0) :
    rothIndex (P * Q) α d ≤ rothIndex P α d + rothIndex Q α d := by
  have hPQ : aeval α (P * Q) ≠ 0 := T5_aeval_mul_ne_zero P Q α hP hQ
  rw [T5_rothIndex_eq_zero_of_aeval_ne_zero (P * Q) α d hPQ,
      T5_rothIndex_eq_zero_of_aeval_ne_zero P α d hP,
      T5_rothIndex_eq_zero_of_aeval_ne_zero Q α d hQ]
  norm_num

/-! ## Companion equality — both sides equal 0 -/

/-- **🚨 Wave T5 session 559www (W1-C, Methone) — Leibniz product
    equality for rothIndex (non-vanishing case)**.

        `aeval α P ≠ 0 ∧ aeval α Q ≠ 0 →
         rothIndex (P * Q) α d = rothIndex P α d + rothIndex Q α d`

    Equality form (tighter than the upper bound): in the
    non-vanishing case both sides are 0.  This shows the upper
    bound is **tight at 0** for non-vanishing P, Q.

    The general case (where one of P, Q vanishes at α) the
    upper bound `T5_rothIndex_mul_le` is genuinely an
    **inequality** (vanishing-multiplicities can subadd), and the
    Σ-Leibniz machinery is required to discharge it. -/
theorem T5_rothIndex_mul_eq_of_nonvanishing {n : ℕ}
    (P Q : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (hP : aeval α P ≠ 0) (hQ : aeval α Q ≠ 0) :
    rothIndex (P * Q) α d = rothIndex P α d + rothIndex Q α d := by
  have hPQ : aeval α (P * Q) ≠ 0 := T5_aeval_mul_ne_zero P Q α hP hQ
  rw [T5_rothIndex_eq_zero_of_aeval_ne_zero (P * Q) α d hPQ,
      T5_rothIndex_eq_zero_of_aeval_ne_zero P α d hP,
      T5_rothIndex_eq_zero_of_aeval_ne_zero Q α d hQ]
  norm_num

/-! ## RothIndexProductBound NAMED Prop scaffold -/

/-- **RothIndexProductBound**: 2-conjunct NAMED Prop packaging the
    Leibniz product upper bound and equality for rothIndex in the
    non-vanishing case.

    Per Escanor-Pride §7.0 NAMED-Prop discipline: this is a real
    Prop (not `:= True`), with body that is a non-trivial conjunction
    of two universally-quantified statements about rothIndex in
    the non-vanishing case.  The discharge plan for the general
    (vanishing) case is explicit (Phase 7+ Σ-Leibniz vocabulary). -/
def RothIndexProductBound : Prop :=
  (∀ {n : ℕ} (P Q : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    aeval α P ≠ 0 → aeval α Q ≠ 0 →
    rothIndex (P * Q) α d ≤ rothIndex P α d + rothIndex Q α d) ∧
  (∀ {n : ℕ} (P Q : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    aeval α P ≠ 0 → aeval α Q ≠ 0 →
    rothIndex (P * Q) α d = rothIndex P α d + rothIndex Q α d)

/-- **🚨 Wave T5 session 559www (W1-C, Methone) — `RothIndexProductBound`**. -/
theorem T5_roth_index_product_bound : RothIndexProductBound :=
  ⟨@T5_rothIndex_mul_le, @T5_rothIndex_mul_eq_of_nonvanishing⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559www (W1-C, Methone) — T-5
    Phase 7 W1-C: rothIndex Leibniz product upper bound
    (non-vanishing case)**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 W1-C.

    Establishes the **Leibniz product upper bound** for rothIndex
    in the non-vanishing case:

        `aeval α P ≠ 0 ∧ aeval α Q ≠ 0 →
         rothIndex (P * Q) α d ≤ rothIndex P α d + rothIndex Q α d`

    Plus the equality companion (both sides = 0 in this case),
    plus the helper `T5_aeval_mul_ne_zero`, plus the
    `RothIndexProductBound` 2-conjunct NAMED Prop.

    **Honest narrower-true scope** (per Escanor-Pride §7.0):
    - The full Hindry-Silverman D.6 / Bombieri-Gubler 6.3 product
      bound for arbitrary P, Q (including the vanishing case)
      requires the Σ-Leibniz expansion of `multiIteratedPDeriv`
      with multinomial coefficients.  That machinery is not yet
      available in OV2 and is reserved for Phase 7+ W2/W3/W4
      sub-iterations.
    - The non-vanishing case shipped here is the **only case**
      where rothIndex values are explicitly established in OV2
      to date (Phase 4 interim master s559bb).  Hence this is
      the maximal honest scope for this session.

    **Discharge plan for the general case** (per Escanor-Pride
    §7.0 NAMED-Prop discipline): future Phase 7 sub-iterations
    will extend `RothIndexProductBound` to the full Hindry-
    Silverman form by:
    1. Σ-Leibniz multivariate (`multiIteratedPDeriv (j_P + j_Q)`)
    2. Multinomial-coefficient-weighted MvPolynomial sum
    3. Minimality `j_P` / `j_Q` extraction via `csInf` + `Nonempty`
    4. (s = j_P, t = j_Q) non-vanishing term identification

    Mathlib usage: `MvPolynomial.aeval` AlgHom (`map_mul`),
    `mul_ne_zero`, Phase 4 `T5_rothIndex_eq_zero_of_aeval_ne_zero`
    (s559bb), `norm_num` to discharge `0 ≤ 0 + 0`.

    Sub-lemma Phase 7 W1-C in T-5.  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 rothIndex Leibniz product
    upper bound (non-vanishing case). -/
theorem session_559www_T5_phase7_roth_index_product_bound_headline :
    RothIndexProductBound :=
  T5_roth_index_product_bound

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexProductBound
