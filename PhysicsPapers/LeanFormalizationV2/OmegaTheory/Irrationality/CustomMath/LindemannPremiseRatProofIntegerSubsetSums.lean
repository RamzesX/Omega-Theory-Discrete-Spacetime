/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerSubsetSums

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 16 — Galois-symmetric
  integer polynomial h whose roots include every nonzero subset-sum of
  f.aroots ℂ.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  PROVES: For nonzero `f : Polynomial ℤ`:

      ∃ h : Polynomial ℤ, h ≠ 0 ∧ Polynomial.eval 0 h ≠ 0 ∧
        ∀ σ ∈ subsetSums (f.aroots ℂ), σ ≠ 0 → Polynomial.aeval σ h = 0.

  Construction:
  1. Each `α ∈ f.aroots ℂ` is integral over ℚ (via aroots → IsAlgebraic ℤ
     → IsFractionRing.isAlgebraic_iff for ℤ ⊆ ℚ → IsAlgebraic ℚ → IsIntegral).
  2. Each `σ = T.sum` for `T ⊆ f.aroots ℂ` is integral over ℚ
     (`IsIntegral.multiset_sum`).
  3. For each non-zero `σ` in the support of `subsetSums`, take
     `minpoly ℚ σ`, which is monic, nonzero, has σ as root, and (since
     σ ≠ 0) has nonzero coeff at 0 (`minpoly.coeff_zero_ne_zero`).
  4. Take the Finset.prod of these minpolys over the indexing
     `(subsetSums).toFinset.filter (·≠0)`.  Result is monic in ℚ[X],
     vanishes at every σ ≠ 0, has nonzero coeff at 0.
  5. Lift to ℤ[X] via `IsLocalization.integerNormalization`.  Roots
     preserved by `integerNormalization_aeval_eq_zero`; nonzero by
     `integerNormalization_eq_zero_iff`; nonzero eval-at-0 by tracking
     the multiplier `b ∈ nonZeroDivisors ℤ` from
     `integerNormalization_spec` and using injectivity of `algebraMap ℤ ℚ`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS
  (no `Prop := True`, no `: True := trivial`, no `:= trivial` placeholders).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums
import Mathlib.RingTheory.Algebraic.Integral
import Mathlib.RingTheory.IntegralClosure.IsIntegralClosure.Basic
import Mathlib.RingTheory.Localization.Integral
import Mathlib.FieldTheory.Minpoly.Field

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerSubsetSums

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSums

/-! ## Step 1 — Algebraicity / integrality of `f.aroots ℂ` over ℚ -/

/-- Every `α ∈ f.aroots ℂ` is integral over ℚ when `f : ℤ[X]` is nonzero.

    Proof: `α` is a root of the integer poly `f`, so algebraic over ℤ
    (direct constructor); by `IsFractionRing.isAlgebraic_iff` (for ℤ ⊆ ℚ ⊆ ℂ),
    algebraic over ℚ; `IsAlgebraic.isIntegral` (over field). -/
theorem isIntegral_of_mem_aroots
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    {α : ℂ} (hα : α ∈ f.aroots ℂ) : IsIntegral ℚ α := by
  have h_root : (Polynomial.aeval α) f = 0 := (Polynomial.mem_aroots.mp hα).2
  have hZ : IsAlgebraic ℤ α := ⟨f, h_ne, h_root⟩
  have hQ : IsAlgebraic ℚ α := (IsFractionRing.isAlgebraic_iff ℤ ℚ ℂ).mp hZ
  exact hQ.isIntegral

/-- Every `σ ∈ subsetSums (f.aroots ℂ)` is integral over ℚ. -/
theorem isIntegral_of_mem_subsetSums
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    {σ : ℂ} (hσ : σ ∈ subsetSums (f.aroots ℂ)) : IsIntegral ℚ σ := by
  unfold subsetSums at hσ
  obtain ⟨T, hT_mem, rfl⟩ := Multiset.mem_map.mp hσ
  have hT_le : T ≤ f.aroots ℂ := Multiset.mem_powerset.mp hT_mem
  apply IsIntegral.multiset_sum
  intros α hα
  exact isIntegral_of_mem_aroots f h_ne (Multiset.mem_of_le hT_le hα)

/-! ## Step 2 — minpoly properties for σ ∈ subsetSums (σ ≠ 0) -/

/-- Bundled minpoly properties for nonzero subset-sums. -/
theorem minpoly_props
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    {σ : ℂ} (hσ_mem : σ ∈ subsetSums (f.aroots ℂ)) (hσ_ne : σ ≠ 0) :
    (minpoly ℚ σ) ≠ 0 ∧ (minpoly ℚ σ).Monic
      ∧ (minpoly ℚ σ).coeff 0 ≠ 0 ∧ (Polynomial.aeval σ) (minpoly ℚ σ) = 0 := by
  have hI : IsIntegral ℚ σ := isIntegral_of_mem_subsetSums f h_ne hσ_mem
  refine ⟨minpoly.ne_zero hI, minpoly.monic hI, ?_, minpoly.aeval ℚ σ⟩
  exact minpoly.coeff_zero_ne_zero hI hσ_ne

/-! ## Step 3 — Build the rational polynomial hQ -/

/-- The rational product polynomial `hQ_of f : Polynomial ℚ` whose roots
    cover every nonzero subset-sum of `f.aroots ℂ`. -/
noncomputable def hQ_of (f : Polynomial ℤ) : Polynomial ℚ :=
  ((subsetSums (f.aroots ℂ)).toFinset.filter (· ≠ 0)).prod (fun σ => minpoly ℚ σ)

/-- `hQ_of f` is monic (Finset.prod of monic factors). -/
theorem hQ_monic (f : Polynomial ℤ) (h_ne : f ≠ 0) : (hQ_of f).Monic := by
  unfold hQ_of
  apply Polynomial.monic_prod_of_monic
  intros σ hσ
  rw [Finset.mem_filter] at hσ
  obtain ⟨hmem, hne⟩ := hσ
  exact (minpoly_props f h_ne (Multiset.mem_toFinset.mp hmem) hne).2.1

/-- `hQ_of f ≠ 0` — follows from monic. -/
theorem hQ_ne_zero (f : Polynomial ℤ) (h_ne : f ≠ 0) : hQ_of f ≠ 0 :=
  (hQ_monic f h_ne).ne_zero

/-- `(hQ_of f).coeff 0 ≠ 0` — Finset.prod-coeff-0 = product of factor-coeff-0,
    each factor coeff-0 ≠ 0 by `minpoly_props`. -/
theorem hQ_coeff_zero_ne_zero (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    (hQ_of f).coeff 0 ≠ 0 := by
  have h_eq : (hQ_of f).coeff 0
            = ∏ σ ∈ ((subsetSums (f.aroots ℂ)).toFinset.filter (· ≠ 0)),
                (minpoly ℚ σ).coeff 0 := by
    unfold hQ_of
    simp only [Polynomial.coeff_zero_eq_eval_zero, Polynomial.eval_prod]
  rw [h_eq]
  apply Finset.prod_ne_zero_iff.mpr
  intros σ hσ
  rw [Finset.mem_filter] at hσ
  obtain ⟨hmem, hne⟩ := hσ
  exact (minpoly_props f h_ne (Multiset.mem_toFinset.mp hmem) hne).2.2.1

/-- Every nonzero `σ ∈ subsetSums (f.aroots ℂ)` is a root of `hQ_of f`. -/
theorem hQ_aeval_eq_zero
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    {σ : ℂ} (hσ_mem : σ ∈ subsetSums (f.aroots ℂ)) (hσ_ne : σ ≠ 0) :
    (Polynomial.aeval σ) (hQ_of f) = 0 := by
  unfold hQ_of
  rw [map_prod]
  have hσ_in_filter : σ ∈ ((subsetSums (f.aroots ℂ)).toFinset.filter (· ≠ 0)) :=
    Finset.mem_filter.mpr ⟨Multiset.mem_toFinset.mpr hσ_mem, hσ_ne⟩
  exact Finset.prod_eq_zero hσ_in_filter
    (minpoly_props f h_ne hσ_mem hσ_ne).2.2.2

/-! ## Step 4 — Lift hQ to ℤ[X] via IsLocalization.integerNormalization -/

/-- The integer polynomial `hZ_of f : Polynomial ℤ` lifted from `hQ_of f`. -/
noncomputable def hZ_of (f : Polynomial ℤ) : Polynomial ℤ :=
  IsLocalization.integerNormalization (nonZeroDivisors ℤ) (hQ_of f)

/-- `hZ_of f ≠ 0`. -/
theorem hZ_ne_zero (f : Polynomial ℤ) (h_ne : f ≠ 0) : hZ_of f ≠ 0 := by
  unfold hZ_of
  rw [Ne, IsFractionRing.integerNormalization_eq_zero_iff]
  exact hQ_ne_zero f h_ne

/-- `(hZ_of f).eval 0 ≠ 0`.

    Proof: `integerNormalization_spec` gives `b ∈ nonZeroDivisors ℤ` with
    `(hZ_of f).map (algebraMap ℤ ℚ) = b • hQ_of f`.  Take `coeff 0`.  RHS =
    `(b : ℚ) * (hQ_of f).coeff 0`, nonzero (b ≠ 0, coeff 0 ≠ 0).  LHS =
    `algebraMap ℤ ℚ ((hZ_of f).coeff 0)`, nonzero iff
    `(hZ_of f).coeff 0 ≠ 0` by injectivity. -/
theorem hZ_eval_zero_ne_zero (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    Polynomial.eval 0 (hZ_of f) ≠ 0 := by
  rw [← Polynomial.coeff_zero_eq_eval_zero]
  intro h_coeff_zero
  obtain ⟨b, hb_mem, hb_eq⟩ :=
    IsLocalization.integerNormalization_spec (nonZeroDivisors ℤ) (hQ_of f)
  -- hb_eq : Polynomial.map (algebraMap ℤ ℚ) (integerNormalization _ (hQ_of f))
  --       = b • hQ_of f
  -- Build chain: (algebraMap ℤ ℚ) ((hZ_of f).coeff 0) = (b : ℚ) * (hQ_of f).coeff 0
  have key : (algebraMap ℤ ℚ) ((hZ_of f).coeff 0)
            = (b : ℚ) * (hQ_of f).coeff 0 := by
    have h1 : (algebraMap ℤ ℚ) ((hZ_of f).coeff 0)
            = (Polynomial.map (algebraMap ℤ ℚ) (hZ_of f)).coeff 0 := by
      rw [Polynomial.coeff_map]
    rw [h1]
    show (Polynomial.map (algebraMap ℤ ℚ)
         (IsLocalization.integerNormalization (nonZeroDivisors ℤ) (hQ_of f))).coeff 0 = _
    rw [hb_eq, Polynomial.coeff_smul]
    -- Goal: b • (hQ_of f).coeff 0 = ↑b * (hQ_of f).coeff 0
    exact zsmul_eq_mul ((hQ_of f).coeff 0) b
  -- Now use h_coeff_zero
  rw [h_coeff_zero] at key
  -- key : (algebraMap ℤ ℚ) 0 = (b : ℚ) * (hQ_of f).coeff 0
  rw [map_zero] at key
  -- key : 0 = (b : ℚ) * (hQ_of f).coeff 0
  have h_b_ne : (b : ℚ) ≠ 0 :=
    Int.cast_ne_zero.mpr (nonZeroDivisors.ne_zero hb_mem)
  have h_q_coeff_ne : (hQ_of f).coeff 0 ≠ 0 := hQ_coeff_zero_ne_zero f h_ne
  exact (mul_ne_zero h_b_ne h_q_coeff_ne) key.symm

/-- Every nonzero `σ ∈ subsetSums (f.aroots ℂ)` is a root of `hZ_of f`. -/
theorem hZ_aeval_eq_zero
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    {σ : ℂ} (hσ_mem : σ ∈ subsetSums (f.aroots ℂ)) (hσ_ne : σ ≠ 0) :
    Polynomial.aeval σ (hZ_of f) = 0 := by
  unfold hZ_of
  exact IsLocalization.integerNormalization_aeval_eq_zero (nonZeroDivisors ℤ)
    (hQ_of f) (hQ_aeval_eq_zero f h_ne hσ_mem hσ_ne)

/-! ## Step 5 — Headline -/

/-- **HEADLINE — Wave T4b session 16**: For every nonzero `f : ℤ[X]`, there
    exists an integer polynomial `h : ℤ[X]` with `h ≠ 0`, `h.eval 0 ≠ 0`,
    and every nonzero subset-sum `σ ∈ subsetSums (f.aroots ℂ)` is a root
    of `h`.

    This is the algebraic-side foundation for the L-W contradiction: the
    polynomial `h` is what `exp_polynomial_approx` will be applied to in
    sessions 18-19, producing the integer `J_p` that combined with the
    analytic bound gives the contradiction. -/
theorem exists_integer_poly_for_subsetSums
    (f : Polynomial ℤ) (h_ne : f ≠ 0) :
    ∃ h : Polynomial ℤ, h ≠ 0 ∧ Polynomial.eval 0 h ≠ 0 ∧
      ∀ σ : ℂ, σ ∈ subsetSums (f.aroots ℂ) → σ ≠ 0 →
        Polynomial.aeval σ h = 0 :=
  ⟨hZ_of f, hZ_ne_zero f h_ne, hZ_eval_zero_ne_zero f h_ne,
   fun _ h1 h2 => hZ_aeval_eq_zero f h_ne h1 h2⟩

/-- **W-T4b session 16 paper bundle** — citation marker. -/
theorem session_16_integer_subset_sums_paper_bundle :
    (∀ (f : Polynomial ℤ), f ≠ 0 →
        ∃ h : Polynomial ℤ, h ≠ 0 ∧ Polynomial.eval 0 h ≠ 0 ∧
          ∀ σ : ℂ, σ ∈ subsetSums (f.aroots ℂ) → σ ≠ 0 →
            Polynomial.aeval σ h = 0)
    ∧ (∀ (f : Polynomial ℤ), f ≠ 0 →
        ∀ {σ : ℂ}, σ ∈ subsetSums (f.aroots ℂ) → IsIntegral ℚ σ) := by
  refine ⟨?_, ?_⟩
  · exact exists_integer_poly_for_subsetSums
  · intros f h_ne σ hσ
    exact isIntegral_of_mem_subsetSums f h_ne hσ

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerSubsetSums
