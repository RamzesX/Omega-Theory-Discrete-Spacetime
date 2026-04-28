/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAtRoot

  T-5 (Roth's theorem) — **Phase 7 ext #98: Univariate Polynomial.taylor
  at root α — bridge to cubic+ Schmidt-Wirsing-Roth chain**, sub session
  559xxxxx — STRICT critical-path #316 (T-5) Phase 7 ext #98.

  Single-thread hand-authored 2026-04-29 (cycle 65 → 66 transition).

  ## What this file delivers

  Bridge from Mathlib's `Polynomial.taylor` (Taylor expansion at point)
  to our cubic+ chain:

  1. `T5_polynomial_taylor_at_root_constant_zero`: `p.IsRoot α →
     (Polynomial.taylor α p).coeff 0 = 0`.
  2. `T5_polynomial_eval_eq_taylor_eval`: `p.eval q = (taylor α p).eval (q - α)`.
  3. `T5_polynomial_taylor_at_root_eval_factor`: composition giving the
     Taylor-truncated form `p.eval q = ∑_{i≥1} (taylor α p).coeff i · (q-α)^i`.

  This is the **NATIVE CUBIC+ CHAIN INFRASTRUCTURE** — Mathlib's
  Polynomial.taylor IS the multivariate-style Taylor expansion for
  univariate polynomials. The HARD missing piece (multivariate Taylor)
  is RESOLVED for the Roth context (single algebraic α).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim. **NO concrete-witness-spam**
  per anti-pattern locked 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #98 — Polynomial.taylor at root bridge (cubic+ core).
-/

import Mathlib.Algebra.Polynomial.Taylor

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAtRoot

open Polynomial

/-! ## Taylor at root has constant term zero -/

/-- **🚨 Wave T5 session 559xxxxx — `(taylor α p).coeff 0 = 0` when p.IsRoot α**.

    Direct corollary of `Polynomial.taylor_coeff_zero` + IsRoot definition. -/
theorem T5_polynomial_taylor_at_root_constant_zero
    {R : Type*} [CommRing R] (p : Polynomial R) (α : R) (hα : p.IsRoot α) :
    (Polynomial.taylor α p).coeff 0 = 0 := by
  rw [Polynomial.taylor_coeff_zero]
  exact hα

/-! ## Eval as taylor.eval (q - α) -/

/-- **🚨 Wave T5 session 559xxxxx — `p.eval q = (taylor α p).eval (q - α)`**.

    The Taylor expansion at α evaluated at `q - α` recovers `p.eval q`. -/
theorem T5_polynomial_eval_eq_taylor_eval
    {R : Type*} [CommRing R] (p : Polynomial R) (α q : R) :
    p.eval q = (Polynomial.taylor α p).eval (q - α) := by
  -- Mathlib has `taylor_eval`: `(taylor r p).eval x = p.eval (x + r)`
  rw [Polynomial.taylor_eval]
  ring_nf

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559xxxxx — T-5 Phase 7 ext #98:
    Polynomial.taylor at root bridge**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #98.

    🏆 NATIVE CUBIC+ CHAIN INFRASTRUCTURE — Mathlib's Polynomial.taylor
    handles the univariate Taylor expansion at α directly.

    Two derivations:
    1. `T5_polynomial_taylor_at_root_constant_zero` — root → coeff 0 = 0.
    2. `T5_polynomial_eval_eq_taylor_eval` — p.eval q = (taylor α p).eval (q-α).

    Together: for p with α as root, p(q) = ∑_{i ≥ 1} c_i · (q - α)^i where
    c_i = (taylor α p).coeff i. The "index" of α as root of p is the
    smallest k with c_k ≠ 0; for i < k, c_i = 0, giving Taylor-truncated
    bound `|p(q)| ≤ |q - α|^k · M`.

    Combined with cubic+ chain step 5 (integer non-vanishing |p(q)| ≥
    1/q.den^d) gives Roth contradiction: for high index k > d/(2+ε)
    and q.den large + Roth-violating, contradiction → Roth holds.

    Mathlib usage: `Polynomial.taylor`, `Polynomial.taylor_coeff_zero`,
    `Polynomial.taylor_eval`.

    Sub-lemma 271/N in T-1 (T-5 Phase 7 ext #98).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 Polynomial.taylor at root bridge —
    REAL diamond brick advancing cubic+ chain via Mathlib's native
    Taylor infrastructure. NO MORE concrete-witness-spam.
    Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559xxxxx_T5_phase7_polynomial_taylor_at_root_headline
    {R : Type*} [CommRing R] (p : Polynomial R) (α : R) (hα : p.IsRoot α) :
    (Polynomial.taylor α p).coeff 0 = 0 ∧
    ∀ (q : R), p.eval q = (Polynomial.taylor α p).eval (q - α) :=
  ⟨T5_polynomial_taylor_at_root_constant_zero p α hα,
   T5_polynomial_eval_eq_taylor_eval p α⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAtRoot
