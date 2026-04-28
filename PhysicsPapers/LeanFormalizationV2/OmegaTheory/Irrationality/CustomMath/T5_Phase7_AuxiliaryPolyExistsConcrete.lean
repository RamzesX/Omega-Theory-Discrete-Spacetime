/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyExistsConcrete

  T-5 (Roth's theorem) — **Phase 7 ext #10: concrete auxiliary polynomial
  existence at MvPolynomial level**, sub session 559ccc — STRICT
  critical-path #316 (T-5) Phase 7 ext #10.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Lifts the abstract Siegel-level coefficient-vector existence
  (s559xx `T5_auxiliary_poly_abstract_exists`) to a concrete polynomial
  existence theorem at the `MvPolynomial (Fin n) ℤ` level using the
  full bijection from s559zz / s559aaa / s559bbb.

  Given any matrix `M : Matrix J (BoundedMI n d) ℤ` with
  `Fintype.card J < (d+1)^n` and `0 < Fintype.card J`, Siegel +
  bijection produces:

      ∃ p : MvPolynomial (Fin n) ℤ,
        p ≠ 0 ∧
        p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
        M *ᵥ polyToCoeffs p = 0

  This is the canonical "auxiliary polynomial" existence statement —
  the input form for Roth-Schmidt-Wirsing analytical-side arguments.

  Two derivations + Prop:
  1. `T5_polyToCoeffs_zero`: `polyToCoeffs 0 = 0` (zero polynomial maps
     to zero coefficient vector)
  2. `T5_auxiliaryPoly_exists_in_restrictDegree`: the headline
     existence theorem at MvPolynomial level

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #10 — concrete auxiliary polynomial existence.

  This closes the SCAFFOLD direction of the Roth proof:
  - Phase 7 ENTRY: Mathlib SiegelsLemma re-exposed (s559rr)
  - Phase 7 ext #1-#4: bounded multi-index Fintype + Finsupp bridge
  - Phase 7 ext #5: abstract auxiliary polynomial via Siegel (s559xx)
  - Phase 7 ext #6-#9: full bijection BoundedMI ↔ restrictDegree
  - **Phase 7 ext #10 (this file)**: lift to MvPolynomial level

  Remaining for full Roth: concrete vanishing-matrix construction
  from polynomial-derivative-evaluation linear functionals
  (ext #11-#13: IteratedPDerivVanishing, VanishingRowMatrix,
  AnalyticalBound) + final integer-bound contradiction.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyAbstract
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyExistsConcrete

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyAbstract
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffs

/-! ## polyToCoeffs of zero polynomial -/

/-- **🚨 Wave T5 session 559ccc — `polyToCoeffs 0 = 0`**.

    The extraction map applied to the zero polynomial yields the
    zero coefficient vector. -/
theorem T5_polyToCoeffs_zero {n d : ℕ} :
    polyToCoeffs (d := d) (0 : MvPolynomial (Fin n) ℤ)
      = (fun _ : BoundedMI n d => (0 : ℤ)) := by
  funext k
  unfold polyToCoeffs
  simp

/-! ## Concrete auxiliary polynomial existence -/

/-- **🚨 Wave T5 session 559ccc — concrete auxiliary polynomial existence**.

    Lift of s559xx (`T5_auxiliary_poly_abstract_exists`) to MvPolynomial
    level via the s559zz/aaa/bbb full bijection.  Given any matrix
    `M : Matrix J (BoundedMI n d) ℤ` encoding linear constraints with
    `Fintype.card J < (d+1)^n` (under-determined system) and
    `0 < Fintype.card J`, there exists a non-zero polynomial in
    `restrictDegree (Fin n) ℤ d` whose coefficient vector annihilates
    every row of `M`. -/
theorem T5_auxiliaryPoly_exists_in_restrictDegree
    {n d : ℕ} {J : Type*} [Fintype J]
    (M : Matrix J (BoundedMI n d) ℤ)
    (h_dim : Fintype.card J < (d + 1) ^ n)
    (h_J_pos : 0 < Fintype.card J) :
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      M *ᵥ (polyToCoeffs (d := d) p) = 0 := by
  obtain ⟨c, hc_ne, hc_eq⟩ :=
    T5_auxiliary_poly_abstract_exists M h_dim h_J_pos
  refine ⟨coeffsToPoly c, ?_, ?_, ?_⟩
  · -- coeffsToPoly c ≠ 0
    intro h
    apply hc_ne
    have h_round : polyToCoeffs (d := d) (coeffsToPoly c) = c :=
      T5_polyToCoeffs_coeffsToPoly c
    rw [h] at h_round
    rw [T5_polyToCoeffs_zero] at h_round
    exact h_round.symm
  · -- coeffsToPoly c ∈ restrictDegree
    exact T5_coeffsToPoly_mem_restrictDegree c
  · -- M *ᵥ polyToCoeffs (coeffsToPoly c) = 0
    rw [T5_polyToCoeffs_coeffsToPoly c]
    exact hc_eq

/-! ## AuxiliaryPolyExistsConcrete Prop scaffold -/

/-- **AuxiliaryPolyExistsConcrete**: 2-conjunct Prop packaging the
    polyToCoeffs-zero identity + concrete polynomial existence. -/
def AuxiliaryPolyExistsConcrete : Prop :=
  (∀ {n d : ℕ},
    polyToCoeffs (d := d) (0 : MvPolynomial (Fin n) ℤ)
      = (fun _ : BoundedMI n d => (0 : ℤ))) ∧
  (∀ {n d : ℕ} {J : Type*} [Fintype J]
    (M : Matrix J (BoundedMI n d) ℤ),
    Fintype.card J < (d + 1) ^ n →
    0 < Fintype.card J →
    ∃ p : MvPolynomial (Fin n) ℤ,
      p ≠ 0 ∧
      p ∈ MvPolynomial.restrictDegree (Fin n) ℤ d ∧
      M *ᵥ (polyToCoeffs (d := d) p) = 0)

/-- **🚨 Wave T5 session 559ccc — `AuxiliaryPolyExistsConcrete`**. -/
theorem T5_auxiliary_poly_exists_concrete : AuxiliaryPolyExistsConcrete :=
  ⟨@T5_polyToCoeffs_zero,
   @T5_auxiliaryPoly_exists_in_restrictDegree⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ccc — T-5 Phase 7 ext #10: concrete auxiliary polynomial existence**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #10.

    Lifts s559xx abstract Siegel-level coefficient-vector existence
    to a concrete polynomial existence theorem at MvPolynomial level
    using the full bijection from s559zz / s559aaa / s559bbb.

    Two derivations + Prop:
    1. `T5_polyToCoeffs_zero` — `polyToCoeffs 0 = 0`
    2. `T5_auxiliaryPoly_exists_in_restrictDegree` — concrete existence
    + AuxiliaryPolyExistsConcrete Prop (2-conjunct).

    Composes:
    - s559xx `T5_auxiliary_poly_abstract_exists` (Siegel applied at
      `BoundedMI n d → ℤ` coefficient-vector level)
    - s559aaa `T5_polyToCoeffs_coeffsToPoly` (bijection direction
      `polyToCoeffs ∘ coeffsToPoly = id`)
    - s559zz `T5_coeffsToPoly_mem_restrictDegree` (assembled
      polynomial in restrictDegree)

    The output `p : MvPolynomial (Fin n) ℤ` is the canonical
    "auxiliary polynomial" of Roth-Schmidt-Wirsing — input form for
    the analytical-side argument (Roth main theorem proper, ext #11+).

    Sub-lemma 203/N in T-1 (T-5 Phase 7 ext #10).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 concrete auxiliary polynomial
    existence at MvPolynomial level. -/
theorem session_559ccc_T5_phase7_auxiliary_poly_exists_concrete_headline :
    AuxiliaryPolyExistsConcrete :=
  T5_auxiliary_poly_exists_concrete

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AuxiliaryPolyExistsConcrete
