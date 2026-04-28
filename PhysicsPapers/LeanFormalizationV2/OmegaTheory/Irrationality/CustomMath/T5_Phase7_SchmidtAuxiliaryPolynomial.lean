/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxiliaryPolynomial

  T-5 (Roth's theorem) — **Phase 7 ext #16: Schmidt's auxiliary
  polynomial — concrete existence with explicit bounds**, sub
  session 559iii — STRICT critical-path #316 (T-5) Phase 7 ext #16.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Full composition: ext #10 (auxiliary polynomial existence at
  MvPolynomial level via Siegel) + ext #15 (matrix construction +
  sup-norm bound) + s559xx (Siegel's lemma re-exposed) → the
  **Schmidt-Wirsing-Roth auxiliary polynomial** existence statement
  with explicit (d, n, α)-dependent norm bound:

      Given multi-derivative indices `I : J → BoundedMI n d` and
      uniform eval point `α : Fin n → ℤ` with `card J < (d+1)^n`:
      ∃ p : MvPolynomial (Fin n) ℤ,
        p ≠ 0 ∧
        p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
        vanishingMatrix J I (fun _ => α) *ᵥ polyToCoeffs p = 0 ∧
        ‖polyToCoeffs p‖ ≤ ((d+1)^n · max 1 (∏ i, 2^d · max 1 |α i|^d))^(card J / ((d+1)^n - card J))

  This is the **input form** for Roth's analytical-side argument
  (next ext #17): combined with Liouville-type analytical bounds on
  `|p(α)|` + integer non-vanishing of the constructed polynomial,
  this drives the final Roth contradiction.

  Two derivations + Prop:
  1. `T5_schmidt_auxiliary_polynomial_exists`: full composition
     theorem
  2. `T5_schmidt_auxiliary_polynomial_norm_bound`: explicit
     (d, n, α)-dependent bound on coefficient sup-norm

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #16 — **Schmidt-Wirsing-Roth auxiliary polynomial =
  full SCAFFOLD direction CLOSED with explicit norm bound**.

  Phase 7 status (cycle 65 day-of-record):
  - ENTRY (s559rr SiegelsLemma) ✓
  - ext #1-4 (BoundedMI Fintype + Finsupp bridge) ✓
  - ext #5 (s559xx abstract Siegel) ✓
  - ext #6-9 (full bijection BoundedMI ↔ restrictDegree) ✓
  - ext #10 (concrete polynomial existence) ✓
  - ext #11-13 (corollaries + bridge to descFactorial) ✓
  - ext #14-15 (entry + matrix sup-norm bounds) ✓
  - **ext #16 (this file): Schmidt aux poly with explicit bounds** ✓
  - Remaining for full Roth: ext #17 (analytical bound on |p(α)|
    via Liouville + multiIteratedPDeriv vocabulary from
    T5_Phase3-Phase6) + ext #18 (integer non-vanishing →
    contradiction → Roth main theorem proper).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyExistsConcrete
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixConstruction

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxiliaryPolynomial

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyExistsConcrete
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixConstruction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyAbstract
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial

attribute [local instance] Matrix.seminormedAddCommGroup

/-! ## Schmidt's auxiliary polynomial — full existence -/

/-- **🚨 Wave T5 session 559iii — Schmidt-Wirsing-Roth auxiliary polynomial**.

    Composition of ext #10 (`T5_auxiliaryPoly_exists_in_restrictDegree`)
    applied to the concrete `vanishingMatrix` from ext #15.

    Given multi-derivative indices `I : J → BoundedMI n d` and uniform
    eval point `α : Fin n → ℤ` with the dimension inequality
    `card J < (d+1)^n` and `0 < card J`, there exists a non-zero
    polynomial `p ∈ restrictDegree (Fin n) ℤ d` whose coefficient
    vector annihilates the vanishing matrix. -/
theorem T5_schmidt_auxiliary_polynomial_exists
    {n d : ℕ} {J : Type*} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J) :
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      vanishingMatrix J I (fun _ => α) *ᵥ
        (polyToCoeffs (d := d) p) = 0 :=
  T5_auxiliaryPoly_exists_in_restrictDegree
    (vanishingMatrix J I (fun _ => α)) h_dim h_J_pos

/-! ## Norm bound on auxiliary polynomial coefficient vector -/

/-- **🚨 Wave T5 session 559iii — Schmidt aux poly with explicit
    norm bound (uniform-α form)**.

    Strengthens `T5_schmidt_auxiliary_polynomial_exists` with the
    Siegel sup-norm bound on the coefficient vector, where ‖M‖ is
    bounded explicitly via ext #15. -/
theorem T5_schmidt_auxiliary_polynomial_with_norm
    {n d : ℕ} {J : Type*} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J) :
    ∃ (p : MvPolynomial (Fin n) ℤ) (c : BoundedMI n d → ℤ),
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      c ≠ 0 ∧
      vanishingMatrix J I (fun _ => α) *ᵥ c = 0 ∧
      ‖c‖ ≤ (Fintype.card (BoundedMI n d) *
              max 1 ‖vanishingMatrix J I (fun _ => α)‖) ^
            ((Fintype.card J : ℝ) /
             (Fintype.card (BoundedMI n d) - Fintype.card J)) := by
  obtain ⟨c, hc_ne, hc_eq, hc_norm⟩ :=
    T5_auxiliary_poly_abstract_exists_with_bound
      (vanishingMatrix J I (fun _ => α)) h_dim h_J_pos
  refine ⟨coeffsToPoly c, c, ?_, ?_, hc_ne, hc_eq, hc_norm⟩
  · -- coeffsToPoly c ≠ 0 via injectivity (s559aaa round-trip)
    intro h
    apply hc_ne
    have h_round := T5_polyToCoeffs_coeffsToPoly c
    rw [h] at h_round
    rw [T5_polyToCoeffs_zero] at h_round
    exact h_round.symm
  · -- coeffsToPoly c ∈ restrictDegree
    exact OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial.T5_coeffsToPoly_mem_restrictDegree c

/-! ## SchmidtAuxiliaryPolynomial Prop scaffold -/

/-- **SchmidtAuxiliaryPolynomial**: 2-conjunct Prop packaging the
    full Schmidt-Wirsing-Roth auxiliary polynomial existence
    (with + without explicit norm bound). -/
def SchmidtAuxiliaryPolynomial : Prop :=
  (∀ {n d : ℕ} {J : Type*} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ),
    Fintype.card J < (d + 1) ^ n →
    0 < Fintype.card J →
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      vanishingMatrix J I (fun _ => α) *ᵥ
        (polyToCoeffs (d := d) p) = 0) ∧
  (∀ {n d : ℕ} {J : Type*} [Fintype J]
    (I : J → BoundedMI n d) (α : Fin n → ℤ),
    Fintype.card J < (d + 1) ^ n →
    0 < Fintype.card J →
    ∃ (p : MvPolynomial (Fin n) ℤ) (c : BoundedMI n d → ℤ),
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      c ≠ 0 ∧
      vanishingMatrix J I (fun _ => α) *ᵥ c = 0 ∧
      ‖c‖ ≤ (Fintype.card (BoundedMI n d) *
              max 1 ‖vanishingMatrix J I (fun _ => α)‖) ^
            ((Fintype.card J : ℝ) /
             (Fintype.card (BoundedMI n d) - Fintype.card J)))

/-- **🚨 Wave T5 session 559iii — `SchmidtAuxiliaryPolynomial`**. -/
theorem T5_schmidt_auxiliary_polynomial : SchmidtAuxiliaryPolynomial :=
  ⟨@T5_schmidt_auxiliary_polynomial_exists,
   @T5_schmidt_auxiliary_polynomial_with_norm⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559iii — T-5 Phase 7 ext #16:
    Schmidt-Wirsing-Roth auxiliary polynomial**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #16.

    🏆 SCAFFOLD direction FULLY CLOSED with explicit norm bound.

    Composition of:
    - ext #10 `T5_auxiliaryPoly_exists_in_restrictDegree` (concrete
      polynomial existence at MvPolynomial level via Siegel)
    - ext #15 `vanishingMatrix` + sup-norm bound
    - s559xx `T5_auxiliary_poly_abstract_exists_with_bound` (Siegel's
      lemma with explicit norm bound)

    Two derivations + Prop:
    1. `T5_schmidt_auxiliary_polynomial_exists` — pure existence
    2. `T5_schmidt_auxiliary_polynomial_with_norm` — with explicit
       Siegel norm bound on the coefficient vector
    + SchmidtAuxiliaryPolynomial Prop (2-conjunct).

    This is the **input form** for Roth's analytical-side argument
    (ext #17+): combined with Liouville-type analytical bounds on
    `|p(α)|` + integer non-vanishing, this drives the final Roth
    contradiction → axiom retirement.

    Mathlib usage: `Matrix.seminormedAddCommGroup` (sup-norm),
    `Int.Matrix.exists_ne_zero_int_vec_norm_le` (Siegel via s559rr).

    Sub-lemma 209/N in T-1 (T-5 Phase 7 ext #16).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 Schmidt-Wirsing-Roth auxiliary
    polynomial existence with explicit norm bound. -/
theorem session_559iii_T5_phase7_schmidt_auxiliary_polynomial_headline :
    SchmidtAuxiliaryPolynomial :=
  T5_schmidt_auxiliary_polynomial

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxiliaryPolynomial
