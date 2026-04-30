/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A2A3_FactorBounds

  T-5 (Roth's theorem) — **Phase 7 SJWC-1 HEART decomposition** —
  sub-lemmas A2 and A3: per-i violator factor bound + product factor
  bound.

  Single-thread hand-authored 2026-04-30.

  ## What this file delivers

  Two HEART sub-lemmas of SJWC-1 (Schmidt-Jensen-Wronskian
  Completion-1 of Roth's theorem):

  A2 — `T5_SJWC1_A2_per_i_violator_factor` :
       For `q` a Roth-violating rational and `k : ℕ`,
       `|q - α|^k ≤ den(q)^(-(2+ε)*k)`.

  A3 — `T5_SJWC1_A3_product_factor_bound` :
       Product over `i : Fin m` of the per-i bound A2.

  ## Strategy

  A2: From `|q - α| < den(q)^(-(2+ε))` (the violating-set hypothesis),
       monotonicity of nat-pow on nonneg base gives
       `|q - α|^k ≤ (den(q)^(-(2+ε)))^k`. Bridge `(x^a)^k`
       (rpow then nat-pow) to `x^(a*k)` (rpow alone) via
       `Real.rpow_natCast` + `Real.rpow_mul`.

  A3: Apply A2 pointwise; combine with `Finset.prod_le_prod`
       (uses CommMonoidWithZero version requiring nonneg LHS).

  ## graph_queries_run

  - `mcp__omega-orchestrator__cycle_state` — phase A, OPEN candidates 183.
  - `lean_loogle("Real.rpow_natCast")` → exact signature
    `x ^ (n : ℝ) = x ^ n`.
  - `lean_loogle("Real.rpow_mul")` → `0 ≤ x → x^(y*z) = (x^y)^z`.
  - `lean_local_search("pow_le_pow_left")` → `pow_le_pow_left₀` in
    `Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic`.
  - grep for `prod_le_prod` → `Finset.prod_le_prod` in
    `Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset`
    (signature: `(h0 : ∀ i ∈ s, 0 ≤ f i) (h1 : ∀ i ∈ s, f i ≤ g i)`).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A2A3_FactorBounds

open Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

/-! ## A2 — Per-i violator factor bound -/

/-- **A2 — Per-i violator factor bound.**

    If `q` is a Roth-violating rational for `α, ε`, then for any `k : ℕ`,
    `|q - α|^k ≤ den(q)^(-(2+ε)*k)`. -/
theorem T5_SJWC1_A2_per_i_violator_factor
    (α : ℝ) (ε : ℝ) (_hε : 0 < ε)
    (q : ℚ) (hq : q ∈ T5_RothViolatingSet α ε) (k : ℕ) :
    |((q : ℚ) : ℝ) - α| ^ k ≤ ((q.den : ℝ)) ^ (-(2 + ε) * (k : ℝ)) := by
  -- Unfold violating-set membership: `|q - α| < den^(-(2+ε))` (real rpow)
  have hq_mem : |((q : ℚ) : ℝ) - α| < ((q.den : ℝ) : ℝ) ^ (-(2 + ε)) := hq
  -- Denominator positivity (Rat invariant)
  have hden_pos : (0 : ℝ) < (q.den : ℝ) := by exact_mod_cast q.den_pos
  have hden_nn : (0 : ℝ) ≤ (q.den : ℝ) := le_of_lt hden_pos
  -- Bridge `den^(-(2+ε)*k)` → `(den^(-(2+ε)))^k` :
  --   first split using `Real.rpow_mul` (rpow exponent times exponent),
  --   then convert outer rpow-of-(k:ℝ) to nat-pow via `Real.rpow_natCast`.
  have hsplit : ((q.den : ℝ)) ^ (-(2 + ε) * (k : ℝ)) =
                (((q.den : ℝ)) ^ (-(2 + ε))) ^ k := by
    rw [Real.rpow_mul hden_nn, Real.rpow_natCast]
  -- Nonnegativity of the violating-bound base (`den^(-(2+ε))` is positive)
  have hbase_nn : (0 : ℝ) ≤ ((q.den : ℝ)) ^ (-(2 + ε)) :=
    le_of_lt (Real.rpow_pos_of_pos hden_pos _)
  -- Nonnegativity of LHS argument
  have habs_nn : (0 : ℝ) ≤ |((q : ℚ) : ℝ) - α| := abs_nonneg _
  -- Strict `<` weakens to `≤` for `pow_le_pow_left₀`
  have hq_le : |((q : ℚ) : ℝ) - α| ≤ ((q.den : ℝ)) ^ (-(2 + ε)) :=
    le_of_lt hq_mem
  -- Apply nat-pow monotonicity on nonneg base
  have hpow : |((q : ℚ) : ℝ) - α| ^ k ≤ (((q.den : ℝ)) ^ (-(2 + ε))) ^ k :=
    pow_le_pow_left₀ habs_nn hq_le k
  -- Combine with the rpow-↔-nat-pow bridge
  rw [hsplit]
  exact hpow

/-! ## A3 — Combined per-i factor product -/

/-- **A3 — Combined per-i factor product.**

    Given `m` Roth-violating rationals indexed by `Fin m`, and a tuple
    of natural exponents `J : Fin m → ℕ`, the product of per-i absolute
    differences raised to `J i` is bounded by the product of the
    corresponding rpow bounds. -/
theorem T5_SJWC1_A3_product_factor_bound
    {m : ℕ} (α : ℝ) (ε : ℝ) (hε : 0 < ε)
    (q : Fin m → ℚ) (h_viol : ∀ i, q i ∈ T5_RothViolatingSet α ε)
    (J : Fin m → ℕ) :
    ∏ i, |((q i : ℚ) : ℝ) - α| ^ (J i) ≤
      ∏ i, ((q i).den : ℝ) ^ (-(2 + ε) * ((J i) : ℝ)) := by
  -- Apply Finset.prod_le_prod over the universe of Fin m.
  -- Need (h0) nonnegativity of LHS factors and
  --      (h1) per-i bound from A2.
  refine Finset.prod_le_prod (s := Finset.univ)
    (f := fun i => |((q i : ℚ) : ℝ) - α| ^ (J i))
    (g := fun i => ((q i).den : ℝ) ^ (-(2 + ε) * ((J i) : ℝ)))
    (fun i _ => ?_) (fun i _ => ?_)
  · -- LHS factor nonneg: `|x|^k ≥ 0`
    exact pow_nonneg (abs_nonneg _) _
  · -- Per-i bound from A2
    exact T5_SJWC1_A2_per_i_violator_factor α ε hε (q i) (h_viol i) (J i)

/-! ## Combined headline -/

/-- **A2 + A3 combined headline** — both sub-lemmas hold for the same
    parameters. Useful as a single-call entry point downstream. -/
theorem T5_SJWC1_A2A3_combined
    {m : ℕ} (α : ℝ) (ε : ℝ) (hε : 0 < ε)
    (q : Fin m → ℚ) (h_viol : ∀ i, q i ∈ T5_RothViolatingSet α ε)
    (J : Fin m → ℕ) :
    (∀ i, |((q i : ℚ) : ℝ) - α| ^ (J i) ≤
            ((q i).den : ℝ) ^ (-(2 + ε) * ((J i) : ℝ))) ∧
    (∏ i, |((q i : ℚ) : ℝ) - α| ^ (J i) ≤
       ∏ i, ((q i).den : ℝ) ^ (-(2 + ε) * ((J i) : ℝ))) := by
  refine ⟨fun i => ?_, ?_⟩
  · exact T5_SJWC1_A2_per_i_violator_factor α ε hε (q i) (h_viol i) (J i)
  · exact T5_SJWC1_A3_product_factor_bound α ε hε q h_viol J

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC1_A2A3_FactorBounds
