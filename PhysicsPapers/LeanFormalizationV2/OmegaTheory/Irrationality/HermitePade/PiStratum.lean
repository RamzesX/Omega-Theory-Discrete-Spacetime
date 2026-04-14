/-
  OmegaTheory.Irrationality.HermitePade.PiStratum

  F53 — Pi-stratum separation (Module 11 §11.4).

  Corollary of the Decoupling Theorem 4C.3 specialised to θ = π in ℝ.
  States: any ℤ-linear combination of `1, π, π², …, π^D` that vanishes
  in ℝ must be the zero combination.

  This is the "coefficient-at-each-power-of-π must vanish separately"
  step used across the π-irrationality diary (Module 04C, Module 11
  §11.4 F53, Attack 19 non-vanishing witness).

  Dependencies:
  • `decoupling_scalar` from `OmegaTheory.Irrationality.HermitePade.Decoupling`
  • `Real.pi_transcendental` — STATED AS AXIOM, citation: Lindemann (1882).
    Mathlib v4.29 ships the analytic part of Lindemann-Weierstrass
    (`Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart`)
    but has not yet derived `Transcendental ℚ Real.pi` as a corollary.
    Once Mathlib completes the Lindemann derivation, this axiom is
    replaced by a theorem with no further work here.
-/

import OmegaTheory.Irrationality.HermitePade.Decoupling
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.Real.Pi.Bounds

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/--
**Axiom (Lindemann 1882).**  The real number π is transcendental over ℚ.

Citation: F. Lindemann, *Über die Zahl π*, Math. Ann. 20 (1882), 213–225.

When Mathlib derives this from its Lindemann-Weierstrass infrastructure,
replace `axiom` with `theorem` and cite the Mathlib result.
-/
axiom Real.pi_transcendental : Transcendental ℚ (Real.pi : ℝ)

/--
**F53 — π-stratum separation (integer scalars).**

If a finite ℤ-linear combination of powers of π vanishes in ℝ, then every
coefficient is zero.

Proof: direct specialisation of `decoupling_scalar` at θ = π in ℝ,
casting integer coefficients through ℚ.  Transcendence of π gives the
conclusion in ℚ, whence also in ℤ by injectivity of ℤ → ℚ.
-/
theorem pi_stratum_integer
    {D : ℕ} (c : Fin (D + 1) → ℤ)
    (h : ∑ k : Fin (D + 1),
        (c k : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0) :
    ∀ k, c k = 0 := by
  -- Reindex the sum to match decoupling_scalar's hypothesis shape
  have h' : ∑ k : Fin (D + 1),
      (Real.pi : ℝ) ^ (k : ℕ) * algebraMap ℚ ℝ ((c k : ℚ)) = 0 := by
    have : ∀ k : Fin (D + 1),
        (Real.pi : ℝ) ^ (k : ℕ) * algebraMap ℚ ℝ ((c k : ℚ))
          = (c k : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) := by
      intro k
      simp [Rat.cast_intCast]
      ring
    simp_rw [this]
    exact h
  -- Apply the scalar decoupling theorem
  have rat_zero : ∀ k, ((c k : ℚ)) = 0 :=
    decoupling_scalar Real.pi_transcendental (fun k => (c k : ℚ)) h'
  -- ℚ-cast of an integer is zero ↔ the integer is zero
  intro k
  have := rat_zero k
  exact_mod_cast this

/--
**F53 — π-stratum separation (vector form, Module 11 §11.4).**

If an integer-matrix vector `L_n ∈ ℤ[π]^T` vanishes componentwise in
ℝ^T after evaluating π, then every π-degree component L_n^(k) also
vanishes as an integer vector.

This is the form directly used by Attack 19 to certify that a
π-polynomial identity among `{1, u, v}` (if one existed) would give
multiple integer-vector identities, one per π-power — any of which can
then be contradicted independently.
-/
theorem pi_stratum_vector
    {D T : ℕ} (v : Fin (D + 1) → Fin T → ℤ)
    (h : ∀ i : Fin T,
        ∑ k : Fin (D + 1),
          (v k i : ℝ) * (Real.pi : ℝ) ^ (k : ℕ) = 0) :
    ∀ k i, v k i = 0 := by
  intro k i
  exact pi_stratum_integer (fun k' => v k' i) (h i) k

end OmegaTheory.Irrationality.HermitePade
