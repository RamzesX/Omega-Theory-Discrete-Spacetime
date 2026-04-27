/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleWith

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 132.
  `LiouvilleWith` algebra closures.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `LiouvilleWith` algebra closures:

  1. **`T5_LiouvilleWith_mono`** : monotonicity in the exponent.
  2. **`T5_LiouvilleWith_add_rat`** : adding a rational preserves
     LiouvilleWith.
  3. **`T5_LiouvilleWith_mul_rat`** : multiplying by a non-zero rational
     preserves LiouvilleWith.

  Roth's theorem says: for algebraic α and `p > 2`, α is NOT
  LiouvilleWith p.  These algebra closures establish that the
  LiouvilleWith property is well-behaved.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.NumberTheory.Transcendental.Liouville.LiouvilleWith

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleWith

/-! ## LiouvilleWith closures -/

/-- **Wave T5 session 132 — LiouvilleWith monotonicity in p**.

    `LiouvilleWith p x  ∧  q ≤ p  →  LiouvilleWith q x`. -/
theorem T5_LiouvilleWith_mono {p q x : ℝ}
    (h : LiouvilleWith p x) (hle : q ≤ p) :
    LiouvilleWith q x :=
  h.mono hle

/-- **Wave T5 session 132 — LiouvilleWith preserved under +ℚ**.

    `LiouvilleWith p x  →  LiouvilleWith p (x + r)` for `r : ℚ`. -/
theorem T5_LiouvilleWith_add_rat {p x : ℝ}
    (h : LiouvilleWith p x) (r : ℚ) :
    LiouvilleWith p (x + (r : ℝ)) :=
  h.add_rat r

/-- **Wave T5 session 132 — LiouvilleWith preserved under *ℚ (non-zero)**.

    `LiouvilleWith p x  ∧  r ≠ 0  →  LiouvilleWith p (x * r)`. -/
theorem T5_LiouvilleWith_mul_rat {p x : ℝ} {r : ℚ}
    (h : LiouvilleWith p x) (hr : r ≠ 0) :
    LiouvilleWith p (x * (r : ℝ)) :=
  h.mul_rat hr

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 132 — LiouvilleWith algebra closures**.

    Three foundational algebra closures:
    1. `LiouvilleWith p x ∧ q ≤ p → LiouvilleWith q x` (monotone).
    2. `LiouvilleWith p x → LiouvilleWith p (x + r)` for r : ℚ.
    3. `LiouvilleWith p x ∧ r ≠ 0 → LiouvilleWith p (x * r)`.

    Sub-lemma 21/N in T-5 Phase 3.  Lean-core only.

    Roth's theorem is the headline statement: for algebraic α and
    `p > 2`, α is NOT LiouvilleWith p.  These algebra closures
    establish that `LiouvilleWith` is well-behaved under rational
    perturbation. -/
theorem session_132_liouville_with_algebra_headline :
    -- (1) Monotone
    (∀ {p q x : ℝ}, LiouvilleWith p x → q ≤ p → LiouvilleWith q x)
    -- (2) Add rat
    ∧ (∀ {p x : ℝ} (h : LiouvilleWith p x) (r : ℚ),
        LiouvilleWith p (x + (r : ℝ)))
    -- (3) Mul nonzero rat
    ∧ (∀ {p x : ℝ} {r : ℚ}, LiouvilleWith p x → r ≠ 0 →
        LiouvilleWith p (x * (r : ℝ))) := by
  refine ⟨?_, ?_, ?_⟩
  · intros p q x h hle; exact T5_LiouvilleWith_mono h hle
  · intros p x h r; exact T5_LiouvilleWith_add_rat h r
  · intros p x r h hr; exact T5_LiouvilleWith_mul_rat h hr

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleWith
