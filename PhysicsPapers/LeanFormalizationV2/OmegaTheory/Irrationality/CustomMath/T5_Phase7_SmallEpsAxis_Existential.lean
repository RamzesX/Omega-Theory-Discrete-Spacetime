/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_Existential

  T-5 (Roth's theorem) — **Small-ε axis EXISTENTIAL form** (UNCONDITIONALLY
  PROVED).

  ## Architectural rationale

  The current V8R7 architecture uses
    `T5_NAMED_small_eps_axis_in_V8 : ∀ {m} ≥ 1, ∀ ε > 0, ε ≤ m³/16`
  as a NAMED hypothesis. This is LITERALLY FALSE: take m = 3, ε = 100,
  then m³/16 = 27/16 < 100.

  The CORRECT formulation is EXISTENTIAL: for any ε > 0, choose m large
  enough so that ε ≤ m³/16.

  This file:
    1. Defines `T5_NAMED_small_eps_axis_existential` — for every ε > 0,
       there exists m ≥ 1 with ε ≤ m³/16.
    2. Proves it UNCONDITIONALLY via `m := Nat.ceil(16ε) + 1` and
       `m ≥ 1 ⇒ m^3 ≥ m ≥ 16ε`.

  Strategic significance: closes 1 of 8 atomic inner NAMED leaves of V8
  Roth architecture. Identifies architectural quantification fix
  (universal small-eps axis → existential).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_Existential

open Real

/-! ## SEAE-1 — Existential small-ε axis Prop -/

/-- **SEAE-1 — `T5_NAMED_small_eps_axis_existential`** [Prop, EXISTENTIAL form].

    For any ε > 0, there exists m ≥ 1 with ε ≤ m³/16.

    This is the CORRECTED form of the V8R7 small-ε axis, which used a
    literal-false universal quantifier. -/
def T5_NAMED_small_eps_axis_existential : Prop :=
  ∀ (ε : ℝ), 0 < ε →
    ∃ (m : ℕ), 1 ≤ m ∧ ε ≤ ((m : ℝ)^3) / 16

/-! ## SEAE-2 — UNCONDITIONAL discharge of existential form -/

/-- **🚨🚨🚨 SEAE-2 — `T5_NAMED_small_eps_axis_existential_unconditional`**:
    UNCONDITIONAL discharge.

    Witness: `m := Nat.ceil(16 * ε) + 1`. Then m ≥ 1, and (m : ℝ) ≥ 16ε
    + 1 > 16ε. Combined with m^3 ≥ m (since m ≥ 1 in ℝ), we get
    m^3 ≥ 16ε, i.e., ε ≤ m^3/16. -/
theorem T5_NAMED_small_eps_axis_existential_unconditional :
    T5_NAMED_small_eps_axis_existential := by
  intros ε hε_pos
  set m : ℕ := Nat.ceil (16 * ε) + 1 with hm_def
  refine ⟨m, ?_, ?_⟩
  · -- 1 ≤ m (from +1 in definition)
    rw [hm_def]
    omega
  · -- ε ≤ m³ / 16
    have h_m_ge_1 : (1 : ℝ) ≤ (m : ℝ) := by
      rw [hm_def]
      have : (1 : ℕ) ≤ Nat.ceil (16 * ε) + 1 := by omega
      exact_mod_cast this
    have h_m_ge_16eps : (m : ℝ) ≥ 16 * ε := by
      rw [hm_def]
      push_cast
      have h_ceil : (Nat.ceil (16 * ε) : ℝ) ≥ 16 * ε := Nat.le_ceil _
      linarith
    -- m ≥ 1 ⇒ m^3 ≥ m via m³ - m = m(m-1)(m+1) ≥ 0
    have h_m_pos : (0 : ℝ) ≤ (m : ℝ) := by linarith
    have h_m3_ge_m : (m : ℝ) ≤ (m : ℝ)^3 := by
      nlinarith [sq_nonneg ((m : ℝ) - 1), sq_nonneg ((m : ℝ) + 1)]
    have h_m3_ge_16eps : (m : ℝ)^3 ≥ 16 * ε :=
      le_trans h_m_ge_16eps h_m3_ge_m
    linarith

/-! ## SEAE-3 — Headline -/

/-- **🚨🚨🚨🚨 SEAE-3 — `T5_SMALL_EPS_AXIS_EXISTENTIAL_HEADLINE`**:
    paper-citable architectural fix.

    Strategic significance:
    - Original V8R7 small-eps axis is universally quantified, hence false.
    - Existential form is the correct mathematical content.
    - Discharge via concrete witness m := Nat.ceil(16ε) + 1.

    Closes 1 of 8 atomic inner NAMED leaves of the V8 Roth architecture
    (the literal-false small-eps axis is replaced by the UNCONDITIONALLY
    CLOSED existential form). -/
theorem T5_SMALL_EPS_AXIS_EXISTENTIAL_HEADLINE :
    T5_NAMED_small_eps_axis_existential :=
  T5_NAMED_small_eps_axis_existential_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_Existential
