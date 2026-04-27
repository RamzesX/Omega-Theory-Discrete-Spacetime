/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleImplications

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 134.
  `Liouville` → Transcendental + Irrational.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's classic Liouville implications:

  1. **`T5_Liouville_transcendental`** : Liouville numbers are
     transcendental over ℤ.
  2. **`T5_Liouville_irrational`** : Liouville numbers are irrational.

  Liouville (1844) was the first explicit proof of transcendence using
  these bounds.  Roth's theorem (1955, our T-5 target) STRENGTHENS the
  Liouville bound.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.NumberTheory.Transcendental.Liouville.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleImplications

/-! ## Liouville implications -/

/-- **Wave T5 session 134 — Liouville numbers are transcendental**.

    `Liouville x  →  Transcendental ℤ x`. -/
theorem T5_Liouville_transcendental {x : ℝ} (lx : Liouville x) :
    Transcendental ℤ x :=
  lx.transcendental

/-- **Wave T5 session 134 — Liouville numbers are irrational**.

    `Liouville x  →  Irrational x`. -/
theorem T5_Liouville_irrational {x : ℝ} (h : Liouville x) :
    Irrational x :=
  h.irrational

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 134 — Liouville implications**.

    Two classical implications:
    1. `Liouville x → Transcendental ℤ x`.
    2. `Liouville x → Irrational x`.

    Sub-lemma 23/N in T-5 Phase 3.  Lean-core only.

    Liouville (1844) was the first explicit proof of transcendence.
    Roth (1955) strengthens the bound — for algebraic α and p > 2,
    α is NOT LiouvilleWith p (so the contrapositive of "α is
    LiouvilleWith p" implies α is transcendental for p > 2). -/
theorem session_134_liouville_implications_headline :
    -- (1) Transcendental
    (∀ {x : ℝ}, Liouville x → Transcendental ℤ x)
    -- (2) Irrational
    ∧ (∀ {x : ℝ}, Liouville x → Irrational x) :=
  ⟨T5_Liouville_transcendental, T5_Liouville_irrational⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_LiouvilleImplications
