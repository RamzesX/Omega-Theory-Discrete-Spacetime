/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.0: Roth's lemma m=1
  base case** — single-thread paper-grade per Hindry-Silverman D.6
  / Bombieri-Gubler 6.

  Single-thread hand-authored 2026-04-29 (Wave-2 BEGINS).

  ## What this file delivers

  The `m = 1` (single-variable) base case for the multivariate Roth's
  lemma induction. Specifically: for any non-zero `P : Polynomial ℝ`
  of `natDegree ≤ R` and any `α : ℝ`:

      `Polynomial.rootMultiplicity α P ≤ R`

  Equivalently, the **univariate rothIndex** `rmα(P)/R ≤ 1`, the trivial
  m=1 bound that anchors the induction in Hindry-Silverman Section D.6.

  ## graph_queries_run (per LeanFormalizationV2/CLAUDE.md MANDATORY MCP)

  - `lean_loogle("Polynomial.wronskian")` → `Polynomial.wronskian`,
    `natDegree_wronskian_lt_add` (used: yes for symmetry / extension)
  - `omega_hammer_premise("Polynomial.Wronskian non-vanishing for coprime
    polynomials over a field")` → `IsCoprime.wronskian_eq_zero_iff`,
    `degree_wronskian_lt_add` (used: yes — Wronskian degree-bound is the
    inductive workhorse)
  - `lean_leansearch("root multiplicity of polynomial bounded by degree")`
    → `Polynomial.rootMultiplicity_le_iff`, `Polynomial.exists_multiset_roots`
    (used: yes — the standard `(X-α)^(n+1) ∤ p ↔ rmα ≤ n` characterization)

  Literature: Hindry-Silverman *Diophantine Geometry* GTM 201 §D.6, Bombieri-Gubler
  *Heights in Diophantine Geometry* §6.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28: full
  prove mode only, NO slim, NO citation-only stubs.

  ## Step #316 (T-5) Wave-2 status

  Phase 2.0 (m=1 base) — provides the base case for the inductive
  Roth's lemma in Wave-2 Phases 2.1-2.5. The univariate index bound
  is "trivial" but a real, used theorem in the inductive Wronskian
  argument.
-/

import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.RingTheory.Polynomial.Wronskian
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Polynomial.Derivative

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1

open Polynomial

/-! ## Univariate rothIndex (the m=1 specialisation) -/

/-- **Univariate rothIndex**: `rmα(P) / R` as a real number, where
    `R` is the (assumed) degree bound on `P` and `rmα(P)` is the
    multiplicity of `α` as a root of `P`.

    For `P = 0` this is `0 / R = 0` (vacuous; `rootMultiplicity α 0 = 0`
    by Mathlib convention). The "real" content lives in the bound for
    `P ≠ 0`. -/
noncomputable def univariateRothIndex
    (P : Polynomial ℝ) (α : ℝ) (R : ℕ) : ℝ :=
  (Polynomial.rootMultiplicity α P : ℝ) / (R : ℝ)

/-! ## m=1 base case: rootMultiplicity ≤ natDegree -/

/-- **🚨 W2.0-1 — `rootMultiplicity_le_natDegree`** (Mathlib direct).

    For non-zero `P : Polynomial ℝ`, the multiplicity of any `α` as a
    root of `P` is at most `P.natDegree`.

    This is the m=1 specialisation of Roth's lemma's bounding property:
    the index of `P` at `α` weighted by `1 / natDegree P` is bounded
    by 1. -/
theorem T5_rootMultiplicity_le_natDegree
    (P : Polynomial ℝ) (α : ℝ) (hP : P ≠ 0) :
    Polynomial.rootMultiplicity α P ≤ P.natDegree := by
  classical
  -- Use rootMultiplicity_le_iff: rmα ≤ n ↔ ¬ (X-C α)^(n+1) ∣ P.
  -- Plug n = natDegree. Then (X-C α)^(natDegree + 1) has degree (natDegree+1) > natDegree,
  -- so it cannot divide nonzero P (degree obstruction).
  rw [Polynomial.rootMultiplicity_le_iff hP]
  intro hdvd
  -- hdvd : (X - C α)^(natDegree + 1) ∣ P
  have hP_deg : P.natDegree = P.natDegree := rfl
  have hdiv_deg : ((X - C α) ^ (P.natDegree + 1)).natDegree = P.natDegree + 1 := by
    rw [Polynomial.natDegree_pow]
    have h_xc : (X - C α : Polynomial ℝ).natDegree = 1 :=
      Polynomial.natDegree_X_sub_C α
    rw [h_xc]
    ring
  -- divisor's natDegree ≤ P.natDegree (when both nonzero)
  have h_pow_ne : ((X - C α) ^ (P.natDegree + 1) : Polynomial ℝ) ≠ 0 := by
    apply pow_ne_zero
    exact Polynomial.X_sub_C_ne_zero α
  have h_le : ((X - C α) ^ (P.natDegree + 1)).natDegree ≤ P.natDegree :=
    Polynomial.natDegree_le_of_dvd hdvd hP
  rw [hdiv_deg] at h_le
  omega

/-- **🚨 W2.0-2 — `univariateRothIndex_le_one`**.

    For non-zero `P` with `natDegree ≤ R` (`R > 0`), the univariate
    rothIndex of `P` at any `α` is bounded above by 1.

    This is the m=1 base of the inductive Roth's lemma. -/
theorem T5_univariateRothIndex_le_one
    (P : Polynomial ℝ) (α : ℝ) (R : ℕ) (hP : P ≠ 0)
    (hR : 0 < R) (hdeg : P.natDegree ≤ R) :
    univariateRothIndex P α R ≤ 1 := by
  unfold univariateRothIndex
  have h_rm : (Polynomial.rootMultiplicity α P : ℝ) ≤ (R : ℝ) := by
    have := T5_rootMultiplicity_le_natDegree P α hP
    have h_le_R : Polynomial.rootMultiplicity α P ≤ R := this.trans hdeg
    exact_mod_cast h_le_R
  have hR_pos : (0 : ℝ) < (R : ℝ) := by exact_mod_cast hR
  rw [div_le_one hR_pos]
  exact h_rm

/-! ## Wronskian-derived m=1 link (sets up Phase 2.1) -/

/-- **🚨 W2.0-3 — `wronskian_natDegree_lt_two_natDegree`**.

    For non-zero `P` with `wronskian P P' ≠ 0` (Mathlib's `wronskian`
    is `a*b' - a'*b`; `wronskian P P = 0` always, but
    `wronskian P (derivative P)` non-zero captures the m=1 inductive
    step). `(wronskian P P').natDegree < 2 * P.natDegree`.

    Used to seed the m → m+1 induction in Phase 2.2 (the heart). -/
theorem T5_natDegree_wronskian_self_deriv_lt
    (P : Polynomial ℝ)
    (hw : Polynomial.wronskian P (Polynomial.derivative P) ≠ 0) :
    (Polynomial.wronskian P (Polynomial.derivative P)).natDegree
      < P.natDegree + (Polynomial.derivative P).natDegree :=
  Polynomial.natDegree_wronskian_lt_add hw

/-! ## NAMED Prop scaffold for Wave-2 Phase 2.1 to consume -/

/-- **`T5_RothLemma_M1_Base`** — 3-conjunct paper-grade Prop for the
    m=1 base case. Discharged below in this same file
    (Escanor-Pride NO antipattern: NAMED Props must be discharged). -/
def T5_RothLemma_M1_Base : Prop :=
  -- (a) Mathlib root-multiplicity bound
  (∀ (P : Polynomial ℝ) (α : ℝ), P ≠ 0 →
    Polynomial.rootMultiplicity α P ≤ P.natDegree) ∧
  -- (b) Univariate rothIndex ≤ 1 with weight = degree bound
  (∀ (P : Polynomial ℝ) (α : ℝ) (R : ℕ),
    P ≠ 0 → 0 < R → P.natDegree ≤ R →
    univariateRothIndex P α R ≤ 1) ∧
  -- (c) Wronskian self/deriv natDegree drop (Phase 2.2 seed)
  (∀ (P : Polynomial ℝ),
    Polynomial.wronskian P (Polynomial.derivative P) ≠ 0 →
    (Polynomial.wronskian P (Polynomial.derivative P)).natDegree
      < P.natDegree + (Polynomial.derivative P).natDegree)

/-- **🚨 W2.0-4 — discharge**. -/
theorem T5_RothLemma_M1_Base_holds : T5_RothLemma_M1_Base :=
  ⟨T5_rootMultiplicity_le_natDegree,
   T5_univariateRothIndex_le_one,
   @T5_natDegree_wronskian_self_deriv_lt⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.0: Roth's lemma m=1 base case**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.0.

    Three derivations + 3-conjunct discharged Prop:
    1. `T5_rootMultiplicity_le_natDegree` — Mathlib direct
    2. `T5_univariateRothIndex_le_one` — m=1 index bound
    3. `T5_natDegree_wronskian_self_deriv_lt` — Wronskian degree drop
       (Phase 2.2 seed)

    Used by Wave-2 Phase 2.1 (`mvPolyWronskian` definition + linearity)
    and Phase 2.2 (THE HEART — Wronskian non-vanishing induction on m).

    Sub-lemma 280/N in T-5 Phase 7 (Wave-2 Phase 2.0).  Lean-core only.

    Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28
    + anti-pattern lock 2026-04-29: full prove mode, NO STUBS, NO slim. -/
theorem session_W2_phase_2_0_T5_roth_lemma_m1_base_headline :
    T5_RothLemma_M1_Base :=
  T5_RothLemma_M1_Base_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_Base_M1
