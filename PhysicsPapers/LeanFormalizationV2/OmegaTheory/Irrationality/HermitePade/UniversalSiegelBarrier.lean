/-
  OmegaTheory.Irrationality.HermitePade.UniversalSiegelBarrier

  The Universal Siegel Barrier (Theorem 4D.2, Module 04D / Theorem C of
  Paper-K2-Opacity-Pi.md) as a named consequence of the Decoupling
  Theorem (4C.3).

  ## Statement

  ANY auxiliary-function construction that produces an integer solution
  vector `c : Fin (D+1) → Fin N → ℤ` of a coupled vanishing condition

      Σ_{d=0}^{D}  θ^d · (S *ᵥ c_d)  =  0   in K^T

  (where θ ∈ K is transcendental over ℚ and S is any rational auxiliary
  matrix ℚ^{T×N}) must satisfy each `S *ᵥ c_d = 0` separately.

  This is the content of the Universal Siegel Barrier: the Decoupling
  Theorem, proved at the level of rational matrices in `Decoupling.lean`,
  applies uniformly to every auxiliary-function method whose output is
  an integer combination — Siegel-Shidlovskii, Nesterenko-Philippon,
  and any variant whose existence proof uses the classical Siegel lemma.

  ## Byline

  Norbert Marchewka and Rigel, following Module 04D of the π K₂-opacity
  diary.

  ## Dependencies

  Imports `OmegaTheory.Irrationality.HermitePade.Decoupling` and uses
  `decoupling_matrix` as its single lemma. No new axioms, no sorries.
-/

import OmegaTheory.Irrationality.HermitePade.Decoupling

namespace OmegaTheory.Irrationality.HermitePade

open BigOperators Finset

/--
**Universal Siegel Barrier (Theorem 4D.2).**

For any transcendental θ over ℚ in a ℚ-algebra K, any rational auxiliary
matrix S, and any integer combination
    Σ_d θ^d · S·c_d = 0
the individual vectors S·c_d must vanish for every d ∈ Fin (D+1).

Direct corollary of `decoupling_matrix` from `Decoupling.lean`, re-named
to make its universal applicability explicit for downstream users.
-/
theorem universal_siegel_barrier
    {K : Type*} [Field K] [Algebra ℚ K]
    {θ : K} (hθ : Transcendental ℚ θ)
    {D N T : ℕ}
    (S : Fin T → Fin N → ℚ)
    (c : Fin (D + 1) → Fin N → ℤ)
    (h : ∀ i : Fin T,
        ∑ d : Fin (D + 1),
          θ ^ (d : ℕ) * algebraMap ℚ K
            (∑ j : Fin N, S i j * ((c d j : ℤ) : ℚ)) = 0) :
    ∀ d i, ∑ j : Fin N, S i j * ((c d j : ℤ) : ℚ) = 0 :=
  decoupling_matrix hθ S c h

end OmegaTheory.Irrationality.HermitePade
