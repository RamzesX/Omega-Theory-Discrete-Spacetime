/-
  OmegaTheory.Foundations.JarlskogNonVanishing

  **Lion's-Pride Phase 6.5y (2026-05-06)**:
  *Necessary and sufficient conditions for Jarlskog invariant to be
  nonzero — closes the converse direction of the four
  `jarlskog_vanishes_*` theorems in `Emergence/CKMMatrix.lean`.*

  ## Why this file

  Audit of `Emergence/CKMMatrix.lean` (lines 121-146): file ships FOUR
  vanishing-direction theorems:

      jarlskog_vanishes_no_cp        : δ = 0 → J = 0
      jarlskog_vanishes_no_13mixing  : θ_13 = 0 → J = 0
      jarlskog_vanishes_no_12mixing  : θ_12 = 0 → J = 0
      jarlskog_vanishes_no_23mixing  : θ_23 = 0 → J = 0

  But it does NOT ship the CONVERSE direction:

      J ≠ 0 → (sin δ ≠ 0 ∧ sin θ_12 ≠ 0 ∧ sin θ_23 ≠ 0 ∧ sin θ_13 ≠ 0)

  This is the substantive content: CP violation in the SM (J ≠ 0)
  REQUIRES all three quark mixing angles to be nonzero AND a nonzero
  CP phase.  This is the famous "Kobayashi-Maskawa: 6 quark flavors
  needed for CP violation" theorem.

  ## What this file ships

  | Direction                                          | Theorem                                     |
  |----------------------------------------------------|---------------------------------------------|
  | J ≠ 0 → sin δ ≠ 0                                  | `jarlskog_nonzero_implies_sin_deltaCP`      |
  | J ≠ 0 → sin θ_13 ≠ 0                              | `jarlskog_nonzero_implies_sin_theta13`      |
  | J ≠ 0 → sin θ_12 ≠ 0                              | `jarlskog_nonzero_implies_sin_theta12`      |
  | J ≠ 0 → sin θ_23 ≠ 0                              | `jarlskog_nonzero_implies_sin_theta23`      |
  | iff form: J ≠ 0 ↔ (all 4 sins nonzero ∧ cos₁₂≠0 ∧ cos₂₃≠0 ∧ c_13²≠0) | (composite) |
  | Headline                                           | `jarlskog_nonvanishing_report`              |

  ## Honest scope

  This file ships the converse direction of Jarlskog vanishing.  It
  does NOT ship the Kobayashi-Maskawa result (CP violation REQUIRES
  ≥ 3 fermion generations) — that's a deeper theorem about minimum
  matrix dimension for nontrivial U(N) phases.

  What it DOES ship: every "single-factor zero" in the Jarlskog
  formula forces J = 0; equivalently, J ≠ 0 forces each of the
  six factors (s12, c12, s23, c23, s13, c13² treated as a unit, sin δ)
  to be nonzero individually.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure contrapositive of existing vanishing theorems via mul_ne_zero
  + the four `jarlskog_vanishes_*` premises.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Emergence.CKMMatrix
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.JarlskogNonVanishing

open OmegaTheory.Emergence

/-! ## 1. Single-factor implications

    Each component of the Jarlskog product `J = s12·c12·s23·c23·s13·c13²·sin δ`,
    if zero, forces J = 0.  The four "named" components (sin θ_12, sin θ_23,
    sin θ_13, sin δ) have direct theorems in `CKMMatrix.lean`.  We give
    contrapositive forms here and the additional cos-factor implications. -/

/-- **Direct: J ≠ 0 implies sin δ ≠ 0** (contrapositive of
    `jarlskog_vanishes_no_cp`). -/
theorem jarlskog_nonzero_implies_sin_deltaCP (a : CKMAngles)
    (h : jarlskogInvariant a ≠ 0) :
    Real.sin a.deltaCP ≠ 0 := by
  intro hsin
  apply h
  unfold jarlskogInvariant
  rw [hsin]
  ring

/-- **Direct: J ≠ 0 implies sin θ_13 ≠ 0**. -/
theorem jarlskog_nonzero_implies_sin_theta13 (a : CKMAngles)
    (h : jarlskogInvariant a ≠ 0) :
    Real.sin a.theta13 ≠ 0 := by
  intro hsin
  apply h
  unfold jarlskogInvariant
  rw [hsin]
  ring

/-- **Direct: J ≠ 0 implies sin θ_12 ≠ 0**. -/
theorem jarlskog_nonzero_implies_sin_theta12 (a : CKMAngles)
    (h : jarlskogInvariant a ≠ 0) :
    Real.sin a.theta12 ≠ 0 := by
  intro hsin
  apply h
  unfold jarlskogInvariant
  rw [hsin]
  ring

/-- **Direct: J ≠ 0 implies sin θ_23 ≠ 0**. -/
theorem jarlskog_nonzero_implies_sin_theta23 (a : CKMAngles)
    (h : jarlskogInvariant a ≠ 0) :
    Real.sin a.theta23 ≠ 0 := by
  intro hsin
  apply h
  unfold jarlskogInvariant
  rw [hsin]
  ring

/-! ## 2. Cosine-factor implications

    The Jarlskog formula contains `cos θ_12, cos θ_23, cos²θ_13`.  Each
    of these vanishing also forces J = 0 — namely when an angle is
    π/2 (mod π).  These are the additional conditions not covered by
    the original four theorems. -/

/-- **J ≠ 0 implies cos θ_12 ≠ 0** (the (1,2)-mixing angle isn't ±π/2). -/
theorem jarlskog_nonzero_implies_cos_theta12 (a : CKMAngles)
    (h : jarlskogInvariant a ≠ 0) :
    Real.cos a.theta12 ≠ 0 := by
  intro hcos
  apply h
  unfold jarlskogInvariant
  rw [hcos]
  ring

/-- **J ≠ 0 implies cos θ_23 ≠ 0** (the (2,3)-mixing angle isn't ±π/2). -/
theorem jarlskog_nonzero_implies_cos_theta23 (a : CKMAngles)
    (h : jarlskogInvariant a ≠ 0) :
    Real.cos a.theta23 ≠ 0 := by
  intro hcos
  apply h
  unfold jarlskogInvariant
  rw [hcos]
  ring

/-- **J ≠ 0 implies cos θ_13 ≠ 0** (the (1,3)-mixing angle isn't ±π/2). -/
theorem jarlskog_nonzero_implies_cos_theta13 (a : CKMAngles)
    (h : jarlskogInvariant a ≠ 0) :
    Real.cos a.theta13 ≠ 0 := by
  intro hcos
  apply h
  unfold jarlskogInvariant
  rw [hcos]
  ring

/-! ## 3. Bidirectional (`iff`) summary -/

/-- **Necessary-and-sufficient condition for J ≠ 0**:
    all seven Jarlskog factors are nonzero. -/
theorem jarlskog_nonzero_iff_all_factors_nonzero (a : CKMAngles) :
    jarlskogInvariant a ≠ 0 ↔
      Real.sin a.theta12 ≠ 0 ∧
      Real.cos a.theta12 ≠ 0 ∧
      Real.sin a.theta23 ≠ 0 ∧
      Real.cos a.theta23 ≠ 0 ∧
      Real.sin a.theta13 ≠ 0 ∧
      Real.cos a.theta13 ≠ 0 ∧
      Real.sin a.deltaCP ≠ 0 := by
  constructor
  · intro h
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · exact jarlskog_nonzero_implies_sin_theta12 a h
    · exact jarlskog_nonzero_implies_cos_theta12 a h
    · exact jarlskog_nonzero_implies_sin_theta23 a h
    · exact jarlskog_nonzero_implies_cos_theta23 a h
    · exact jarlskog_nonzero_implies_sin_theta13 a h
    · exact jarlskog_nonzero_implies_cos_theta13 a h
    · exact jarlskog_nonzero_implies_sin_deltaCP a h
  · intro ⟨hs12, hc12, hs23, hc23, hs13, hc13, hδ⟩
    unfold jarlskogInvariant
    have hc13sq : (Real.cos a.theta13) ^ 2 ≠ 0 := pow_ne_zero _ hc13
    exact mul_ne_zero
            (mul_ne_zero
              (mul_ne_zero
                (mul_ne_zero
                  (mul_ne_zero
                    (mul_ne_zero hs12 hc12)
                    hs23)
                  hc23)
                hs13)
              hc13sq)
            hδ

/-! ## 4. Headline composite -/

/-- **Lion's-Pride Phase 6.5y headline — Jarlskog non-vanishing.**

    For every CKM angle assignment `a`:

    1. **CP violation requires nonzero CP phase**:
       J ≠ 0 → sin δ ≠ 0.

    2. **CP violation requires nonzero (1,3) mixing**:
       J ≠ 0 → sin θ_13 ≠ 0.

    3. **CP violation requires nonzero (1,2) mixing**:
       J ≠ 0 → sin θ_12 ≠ 0.

    4. **CP violation requires nonzero (2,3) mixing**:
       J ≠ 0 → sin θ_23 ≠ 0.

    Together with the existing `jarlskog_vanishes_*` theorems in
    `Emergence/CKMMatrix.lean`, this closes the bidirectional
    characterization: J ≠ 0 ↔ ALL seven factors nonzero. -/
theorem jarlskog_nonvanishing_report (a : CKMAngles) :
    (jarlskogInvariant a ≠ 0 → Real.sin a.deltaCP ≠ 0) ∧
    (jarlskogInvariant a ≠ 0 → Real.sin a.theta13 ≠ 0) ∧
    (jarlskogInvariant a ≠ 0 → Real.sin a.theta12 ≠ 0) ∧
    (jarlskogInvariant a ≠ 0 → Real.sin a.theta23 ≠ 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact jarlskog_nonzero_implies_sin_deltaCP a
  · exact jarlskog_nonzero_implies_sin_theta13 a
  · exact jarlskog_nonzero_implies_sin_theta12 a
  · exact jarlskog_nonzero_implies_sin_theta23 a

end OmegaTheory.Foundations.JarlskogNonVanishing
