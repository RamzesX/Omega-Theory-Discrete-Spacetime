/-
  OmegaTheory.Predictions.InformationSecondLaw

  **Information 2nd Law on the substrate — Landauer + Bekenstein +
  δ_comp correction, minimal scalar formalization.**

  ## Physical narrative

  The three classical information-theoretic limits constrain how much
  information a physical system can store or erase:

  1. **Landauer (1961)** — erasing one bit of information at temperature
     `T` dissipates at least `E_L = k_B · T · ln 2` joules of heat.
     Landauer's principle is the thermodynamic lower bound on
     computation; every *logically irreversible* step pays this energy
     cost.

  2. **Bekenstein (1981)** — the information content (in bits) in a
     region of radius `R` with energy `E` is bounded above by
     `I_max = 2π · R · E / (ℏ · c · ln 2)`.  This is the classical
     holographic upper bound on the information density of matter.

  3. **Substrate extension (OmegaTheory, Marchewka 2026)** — on the
     ℤ⁴ Planck lattice the computational truncation of `π, e, √2`
     produces a non-zero residual `δ_comp(N) = ℓ_P · 4/(2N+3)` per
     iteration budget.  Divided by the Landauer erasure energy
     `k_B · T · ln 2` this becomes a dimensionless **information
     correction**

         ΔI_sub(T, N) = δ_comp(N) / (k_B · T · ln 2).

     It is strictly positive for every finite `N`, every `T > 0`,
     encoding the substrate's per-tick "computational entropy"
     ABOVE the standard Landauer floor.

  ## What this file proves

  * `landauerEnergyPerBit T`            := `k_B · T · ln 2`
  * `bekensteinEntropyBits R E`         := `2π · R · E / (ℏ · c · ln 2)`
  * `substrateInformationCorrection T N`:= `δ_comp(N) / (k_B · T · ln 2)`

  Positivity for all three, plus the **headline synthesis**

      `0 < Landauer ∧ 0 < Bekenstein ∧ 0 < substrateCorrection`

  expressing that the substrate supplies a *positive* correction above
  the two classical limits.

  ## Honest scoping

  This file deliberately stays at the level of scalar energy/info
  coefficients — NO entropy distributions, NO region-cardinality
  counting, NO holographic hypothesis (those live in
  `OmegaTheory.Emergence.BekensteinBound`).  The point is a
  **compositional** Information-2nd-Law bundle: the three scalar
  limits sit side-by-side and the substrate contribution is
  demonstrably non-zero.

  No `sorry`.  No new axioms.  Imports `computationalUncertainty`
  from `Irrationality/Uncertainty.lean` and the Planck constants
  from `Spacetime/Constants.lean` — everything else is Mathlib.

  References:
  * Landauer, R.  "Irreversibility and heat generation in the
    computing process." IBM J. Res. Dev. 5 (1961) 183.
  * Bekenstein, J.  "Universal upper bound on the entropy-to-energy
    ratio for bounded systems." Phys. Rev. D 23 (1981) 287.
  * Landauer Entropy 2024 synthesis; Bekenstein Quantum 2025 synthesis.
-/

import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.Spacetime.Constants
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality

/-! ## §1.  Landauer energy per erased bit -/

/-- **Landauer erasure energy per bit** at temperature `T`.
    Classical lower bound on the heat dissipated per logically
    irreversible bit operation:
        `E_L(T) = k_B · T · ln 2`.
    Formalized here without any appeal to the substrate — purely a
    statement about the three fundamental constants `k_B`, `T`, `ln 2`. -/
noncomputable def landauerEnergyPerBit (T : ℝ) : ℝ :=
  k_B * T * Real.log 2

/-- Positive Landauer cost at any positive temperature. -/
theorem landauerEnergyPerBit_pos (T : ℝ) (hT : 0 < T) :
    0 < landauerEnergyPerBit T := by
  unfold landauerEnergyPerBit
  exact mul_pos (mul_pos k_B_pos hT) (Real.log_pos (by norm_num))

/-- Non-negativity for non-negative temperature. -/
theorem landauerEnergyPerBit_nonneg (T : ℝ) (hT : 0 ≤ T) :
    0 ≤ landauerEnergyPerBit T := by
  unfold landauerEnergyPerBit
  have hlog : 0 ≤ Real.log 2 := le_of_lt (Real.log_pos (by norm_num))
  exact mul_nonneg (mul_nonneg (le_of_lt k_B_pos) hT) hlog

/-! ## §2.  Bekenstein information bound (bits) -/

/-- **Bekenstein universal bound (in bits)** on information content in
    a spherical region of radius `R` with total energy `E`:
        `I_max(R, E) = 2π · R · E / (ℏ · c · ln 2)`.
    Converts the usual nat-valued Bekenstein entropy `2π R E / (ℏ c)`
    into bit-valued information by dividing by `ln 2`. -/
noncomputable def bekensteinEntropyBits (R E : ℝ) : ℝ :=
  2 * Real.pi * R * E / (hbar * c * Real.log 2)

/-- Bekenstein bits are positive for any positive radius and energy. -/
theorem bekensteinEntropyBits_pos (R E : ℝ) (hR : 0 < R) (hE : 0 < E) :
    0 < bekensteinEntropyBits R E := by
  unfold bekensteinEntropyBits
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hpi : 0 < Real.pi := Real.pi_pos
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hnum : 0 < 2 * Real.pi * R * E :=
    mul_pos (mul_pos (mul_pos h2 hpi) hR) hE
  have hden : 0 < hbar * c * Real.log 2 :=
    mul_pos (mul_pos hbar_pos c_pos) hlog
  exact div_pos hnum hden

/-- Bekenstein bits are non-negative for non-negative radius and energy. -/
theorem bekensteinEntropyBits_nonneg (R E : ℝ) (hR : 0 ≤ R) (hE : 0 ≤ E) :
    0 ≤ bekensteinEntropyBits R E := by
  unfold bekensteinEntropyBits
  have hlog : 0 ≤ Real.log 2 := le_of_lt (Real.log_pos (by norm_num))
  have hnum : 0 ≤ 2 * Real.pi * R * E :=
    mul_nonneg (mul_nonneg (mul_nonneg (by norm_num : (0:ℝ) ≤ 2)
      (le_of_lt Real.pi_pos)) hR) hE
  have hden : 0 ≤ hbar * c * Real.log 2 :=
    mul_nonneg (mul_nonneg hbar_nonneg c_nonneg) hlog
  exact div_nonneg hnum hden

/-! ## §3.  Substrate information correction (δ_comp / Landauer) -/

/-- **Substrate information correction** above the Landauer floor.
    Per-tick truncation residual `δ_comp(N)` divided by the Landauer
    erasure energy:
        `ΔI_sub(T, N) = δ_comp(N) / (k_B · T · ln 2)`.
    Represents the dimensionless "computational-entropy per bit"
    that the substrate adds ABOVE standard thermodynamic information. -/
noncomputable def substrateInformationCorrection (T : ℝ) (N : ℕ) : ℝ :=
  computationalUncertainty N / (k_B * T * Real.log 2)

/-- The substrate correction is strictly positive for every finite
    iteration budget and every positive temperature. -/
theorem substrateInformationCorrection_pos
    (T : ℝ) (N : ℕ) (hT : 0 < T) :
    0 < substrateInformationCorrection T N := by
  unfold substrateInformationCorrection
  have hnum : 0 < computationalUncertainty N :=
    computationalUncertainty_pos N
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hden : 0 < k_B * T * Real.log 2 :=
    mul_pos (mul_pos k_B_pos hT) hlog
  exact div_pos hnum hden

/-- The substrate correction is non-negative for non-negative
    temperature (degenerate at `T = 0`). -/
theorem substrateInformationCorrection_nonneg
    (T : ℝ) (N : ℕ) (hT : 0 ≤ T) :
    0 ≤ substrateInformationCorrection T N := by
  unfold substrateInformationCorrection
  have hnum : 0 ≤ computationalUncertainty N :=
    computationalUncertainty_nonneg N
  have hlog : 0 ≤ Real.log 2 := le_of_lt (Real.log_pos (by norm_num))
  have hden : 0 ≤ k_B * T * Real.log 2 :=
    mul_nonneg (mul_nonneg (le_of_lt k_B_pos) hT) hlog
  exact div_nonneg hnum hden

/-! ## §4.  Headline: positive substrate correction -/

/-- **Information-2nd-Law substrate distinguisher.**  For any positive
    temperature and any finite iteration budget, the substrate adds a
    strictly positive correction to the Landauer floor — a purely
    substrate-level quantity with no classical counterpart. -/
theorem information_2nd_law_substrate_correction_positive
    (T : ℝ) (N : ℕ) (hT : 0 < T) :
    0 < substrateInformationCorrection T N :=
  substrateInformationCorrection_pos T N hT

/-! ## §5.  Synthesis bundle — all three limits positive -/

/-- **Information-2nd-Law synthesis.**  The Landauer erasure energy,
    the Bekenstein bit-bound, and the substrate information
    correction are ALL strictly positive for positive temperature,
    radius, and energy.  This packages the three limits into a
    single citeable bundle expressing that the substrate yields a
    *positive* information-content prediction above the two classical
    bounds.  Does NOT assert numerical ordering — the Bekenstein and
    substrate terms live in different domains; see the companion
    `OmegaTheory.Emergence.BekensteinBound` for the region-entropy
    formalization. -/
theorem information_second_law_substrate_synthesis
    (T R E : ℝ) (N : ℕ) (hT : 0 < T) (hR : 0 < R) (hE : 0 < E) :
    0 < landauerEnergyPerBit T
      ∧ 0 < bekensteinEntropyBits R E
      ∧ 0 < substrateInformationCorrection T N :=
  ⟨landauerEnergyPerBit_pos T hT,
   bekensteinEntropyBits_pos R E hR hE,
   substrateInformationCorrection_pos T N hT⟩

/-! ## §6.  CAPSTONE — unified Information-2nd-Law bundle with explicit formula -/

/-- **Information-2nd-Law unified capstone (cycle-4 target 6/6, Ascella 2026-04-20).**

    Packages the three fundamental information-theoretic limits plus the
    exact functional form of the substrate correction into a single
    4-conjunct citeable bundle:

    1. Landauer (1961) erasure floor `E_L = k_B · T · ln 2 > 0`,
    2. Bekenstein (1981) holographic bit-bound
       `I_max = 2π R E / (ℏ c ln 2) > 0`,
    3. Substrate δ_comp-lift above the Landauer floor
       `ΔI_sub = δ_comp(N) / (k_B · T · ln 2) > 0`,
    4. The EXACT analytic form of (3):
       `ΔI_sub(T, N) = δ_comp(N) / (k_B · T · ln 2)`.

    Conjunct (4) is a `rfl`-level equation exposing the closed-form
    of the substrate correction — it is NOT a derivation, only a
    definitional unveil that makes downstream composition
    (with Bekenstein-region entropy, with Popławski torsion bounce,
    with Connes spectral action) trivial to cite.

    This theorem subsumes `information_second_law_substrate_synthesis`
    (first three conjuncts) and adds the explicit formula as a fourth
    conjunct, giving a single paper-anchor for the Information-2nd-Law
    appendix. -/
theorem information_second_law_substrate_unified_capstone
    (T R E : ℝ) (N : ℕ) (hT : 0 < T) (hR : 0 < R) (hE : 0 < E) :
    (0 < landauerEnergyPerBit T)
      ∧ (0 < bekensteinEntropyBits R E)
      ∧ (0 < substrateInformationCorrection T N)
      ∧ (substrateInformationCorrection T N
          = computationalUncertainty N / (k_B * T * Real.log 2)) := by
  refine ⟨?_, ?_, ?_, rfl⟩
  · exact landauerEnergyPerBit_pos T hT
  · exact bekensteinEntropyBits_pos R E hR hE
  · exact substrateInformationCorrection_pos T N hT

end OmegaTheory.Predictions
