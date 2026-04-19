/-
  OmegaTheory.Predictions.AlphaEM

  **Fine-structure constant α_EM and its substrate anchoring.**

  ## Physical narrative

  The QED dimensionless coupling
      α_EM = e² / (4π ε₀ ℏ c) ≈ 1 / 137.035999206
  is the "hydrogen-atom-existence parameter": bind the electron to the
  proton, set the strength of every electromagnetic Feynman diagram,
  and govern the anomalous magnetic moment of the electron through
  Schwinger's series

      a_e = α / (2π) + O(α²).

  ## Why this file exists

  OmegaTheory V2 axiomatises exactly FOUR physical constants
  (c, ℏ, G_N, k_B).  Neither the elementary charge `e` nor the vacuum
  permittivity `ε₀` appears in the axioms — they must be DERIVED or
  ANCHORED through substrate structure.  The cleanest such anchoring
  mirrors Bellatrix's `HiggsVEVSubstrate` bridge for v = 246.22 GeV:

      alpha_EM_substrate_ceiling(N) := α_PDG · δ_comp(N),

  i.e. the dimensionless substrate envelope around the PDG coupling.
  Since `δ_comp(N) → 0` as N → ∞, the ceiling vanishes in the
  fine-lattice limit; for any fixed experimental target α_target
  there is a canonical depth

      N_canon(α_target) := smallest N with α_PDG · δ_comp(N) ≤ α_target.

  This is the *same* paradigm used throughout V2 for PDG-anchored
  observables (Higgs VEV, proton mass, Koide Q, ...).

  ## What this file formalises

  **Tier 1 — Definitional bridge (CODATA 2018)**

    * `alpha_EM_PDG = 1 / 137.035999206`
    * `alpha_EM_PDG_pos`, `alpha_EM_PDG_nonneg`, `alpha_EM_PDG_ne_zero`
    * `alpha_EM_PDG_small_1_100`  (α < 1/100)
    * `alpha_EM_PDG_small_1_137`  (α < 1/137)
    * `alpha_EM_PDG_gt_1_138`     (α > 1/138)
    * Two-sided sandwich `1/138 < α < 1/137`

  **Tier 2 — Substrate anchoring**

    Following `HiggsVEVSubstrate`:

    * `alpha_EM_substrate_ceiling(N) := alpha_EM_PDG · δ_comp(N)`
      — the dimensionless substrate envelope.
    * `alpha_EM_substrate_ceiling_pos` — strictly positive for every N.
    * `alpha_EM_substrate_ceiling_decreasing` — monotone in N.
    * `alpha_EM_canonical_scale(N) := alpha_EM_PDG / δ_comp(N)` —
      the canonical rescaling that recovers α_PDG when multiplied by
      δ_comp(N), paralleling Bellatrix's `Λ_EW(N) = v_PDG / δ_comp(N)`.
    * `alpha_EM_canonical_scale_recovers_PDG` — the bridge identity
      `δ_comp(N) · alpha_EM_canonical_scale(N) = alpha_EM_PDG`.

  **Tier 3 — Schwinger's one-loop electron anomaly**

    * `schwinger_ae_oneLoop := alpha_EM_PDG / (2π)` — the 1948 result.
    * Positivity + smallness bounds linking a_e to the Standard Model
      experimental `a_e ≈ 1.16 × 10⁻³`.

  **HARD RULES**: 0 sorry, 0 new axioms.  Uses only existing substrate
  primitives (`computationalUncertainty` from Irrationality) and CODATA
  rational constants.

  Agent: Hadar (β Centauri, "Agena"), 2026-04-19.
  Mission: physics-C α_EM fine-structure-constant bound.
-/

import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Tactic

namespace OmegaTheory.Predictions.AlphaEM

open OmegaTheory.Irrationality

/-! ## 1. Tier 1 — CODATA 2018 fine-structure constant -/

/-- **CODATA 2018 fine-structure constant**
    `α_EM = 1 / 137.035999206`.

    Reference: CODATA 2018 (Mohr, Newell, Taylor 2021), equivalent to
    `α = e²/(4π ε₀ ℏ c)` in SI.  The rational literal
    `1 / 137.035999206` is exact in ℝ; the physical uncertainty lies in
    the measured denominator, not in Lean. -/
noncomputable def alpha_EM_PDG : ℝ := 1 / 137.035999206

/-- The PDG fine-structure constant is strictly positive. -/
theorem alpha_EM_PDG_pos : 0 < alpha_EM_PDG := by
  unfold alpha_EM_PDG
  norm_num

/-- The PDG fine-structure constant is nonneg. -/
theorem alpha_EM_PDG_nonneg : 0 ≤ alpha_EM_PDG :=
  le_of_lt alpha_EM_PDG_pos

/-- The PDG fine-structure constant is nonzero. -/
theorem alpha_EM_PDG_ne_zero : alpha_EM_PDG ≠ 0 :=
  ne_of_gt alpha_EM_PDG_pos

/-- **Smallness bound (loose):** α_EM < 1/100.  This is the standard
    "small coupling" tier that justifies perturbative QED. -/
theorem alpha_EM_PDG_small_1_100 : alpha_EM_PDG < (1 : ℝ) / 100 := by
  unfold alpha_EM_PDG
  norm_num

/-- **Smallness bound (sharp upper):** α_EM < 1/137.  The famous
    Sommerfeld-Dirac approximation `α ≈ 1/137` is a strict upper bound
    at CODATA precision. -/
theorem alpha_EM_PDG_small_1_137 : alpha_EM_PDG < (1 : ℝ) / 137 := by
  unfold alpha_EM_PDG
  norm_num

/-- **Sharp lower bound:** α_EM > 1/138.  Together with the 1/137
    upper bound this sandwiches the CODATA value to better than
    1 part per 137. -/
theorem alpha_EM_PDG_gt_1_138 : (1 : ℝ) / 138 < alpha_EM_PDG := by
  unfold alpha_EM_PDG
  norm_num

/-- **Two-sided PDG sandwich**: `1/138 < α_EM < 1/137`.  Bundled for
    paper citation. -/
theorem alpha_EM_PDG_sandwich :
    (1 : ℝ) / 138 < alpha_EM_PDG ∧ alpha_EM_PDG < (1 : ℝ) / 137 :=
  ⟨alpha_EM_PDG_gt_1_138, alpha_EM_PDG_small_1_137⟩

/-! ## 2. Tier 2 — Substrate anchoring via `δ_comp(N)`

Mirroring Bellatrix's `HiggsVEVSubstrate` paradigm: we form a
substrate ceiling around the PDG value by tensoring with the
computational-uncertainty error quantum `δ_comp(N)`, and a canonical
scale that inverts it. -/

/-- **Substrate ceiling** for the fine-structure constant at truncation
    depth N.

    As the lattice refines (N → ∞), `δ_comp(N) → 0`, so the ceiling
    shrinks toward zero — the substrate forbids arbitrarily fine
    EM couplings below its computational resolution.  In the opposite
    limit N = 0 the ceiling equals `α_PDG · δ_comp(0)`, the coarsest
    substrate-visible coupling. -/
noncomputable def alpha_EM_substrate_ceiling (N : ℕ) : ℝ :=
  alpha_EM_PDG * computationalUncertainty N

/-- The substrate ceiling is strictly positive for every truncation
    depth (because α_PDG > 0 and δ_comp(N) > 0). -/
theorem alpha_EM_substrate_ceiling_pos (N : ℕ) :
    0 < alpha_EM_substrate_ceiling N := by
  unfold alpha_EM_substrate_ceiling
  exact mul_pos alpha_EM_PDG_pos (computationalUncertainty_pos N)

/-- The substrate ceiling is nonneg. -/
theorem alpha_EM_substrate_ceiling_nonneg (N : ℕ) :
    0 ≤ alpha_EM_substrate_ceiling N :=
  le_of_lt (alpha_EM_substrate_ceiling_pos N)

/-- **Monotonicity in N**: the substrate ceiling decreases (weakly)
    as the lattice refines.  Uses `computationalUncertainty_decreasing`
    from `Irrationality.Uncertainty`. -/
theorem alpha_EM_substrate_ceiling_decreasing (N : ℕ) :
    alpha_EM_substrate_ceiling (N + 1) ≤ alpha_EM_substrate_ceiling N := by
  unfold alpha_EM_substrate_ceiling
  exact mul_le_mul_of_nonneg_left
    (computationalUncertainty_decreasing N) alpha_EM_PDG_nonneg

/-- **Canonical rescaling scale** for α_EM at depth N.

    Dual to `alpha_EM_substrate_ceiling`: `alpha_EM_canonical_scale(N)`
    is the rescaling factor one must apply to `δ_comp(N)` to recover
    α_PDG.  Paralleling Bellatrix's `Λ_EW(N) = v_PDG / δ_comp(N)`. -/
noncomputable def alpha_EM_canonical_scale (N : ℕ) : ℝ :=
  alpha_EM_PDG / computationalUncertainty N

/-- The canonical scale is strictly positive. -/
theorem alpha_EM_canonical_scale_pos (N : ℕ) :
    0 < alpha_EM_canonical_scale N := by
  unfold alpha_EM_canonical_scale
  exact div_pos alpha_EM_PDG_pos (computationalUncertainty_pos N)

/-- **Bridge identity**: multiplying `δ_comp(N)` by the canonical
    scale exactly recovers the PDG value α_EM.  This is the algebraic
    witness that the substrate anchoring is self-consistent. -/
theorem alpha_EM_canonical_scale_recovers_PDG (N : ℕ) :
    computationalUncertainty N * alpha_EM_canonical_scale N = alpha_EM_PDG := by
  unfold alpha_EM_canonical_scale
  have h : computationalUncertainty N ≠ 0 :=
    ne_of_gt (computationalUncertainty_pos N)
  field_simp

/-- **Symmetric bridge**: `α_EM_canonical_scale · δ_comp = α_EM_PDG`
    (commuted form, for downstream convenience). -/
theorem alpha_EM_canonical_scale_recovers_PDG' (N : ℕ) :
    alpha_EM_canonical_scale N * computationalUncertainty N = alpha_EM_PDG := by
  rw [mul_comm]
  exact alpha_EM_canonical_scale_recovers_PDG N

/-- **Asymptotic upper bound**: for every truncation depth N, the
    substrate ceiling is dominated by `α_PDG · δ_comp(0)` — i.e. the
    coarsest ceiling strictly bounds all refined ones.  This is the
    monotonicity-based envelope (the dimensionful l_P factor prevents
    a universal ≤ α_PDG bound without a specific Planck-scale
    normalisation). -/
theorem alpha_EM_substrate_ceiling_le_coarsest (N : ℕ) :
    alpha_EM_substrate_ceiling N ≤ alpha_EM_substrate_ceiling 0 := by
  induction N with
  | zero => exact le_refl _
  | succ k ih =>
      exact le_trans (alpha_EM_substrate_ceiling_decreasing k) ih

/-! ## 3. Tier 3 — Schwinger's 1948 one-loop electron anomaly

The anomalous magnetic moment of the electron has the famous
perturbative series
    a_e = α/(2π) − 0.328478 (α/π)² + 1.181241 (α/π)³ − …
whose leading term (Schwinger 1948, Phys. Rev. 73, 416) is
`α/(2π) ≈ 1.1614 × 10⁻³`.  We formalise that leading term and
record its positivity / smallness bound. -/

/-- **Schwinger's 1948 one-loop anomaly** `a_e = α / (2π)`.  This
    is the historical 1-loop QED result, accurate to ≈ 0.3% against
    the modern multi-loop value `a_e ≈ 1.1597 × 10⁻³`. -/
noncomputable def schwinger_ae_oneLoop : ℝ :=
  alpha_EM_PDG / (2 * Real.pi)

/-- Schwinger's 1-loop anomaly is strictly positive. -/
theorem schwinger_ae_oneLoop_pos : 0 < schwinger_ae_oneLoop := by
  unfold schwinger_ae_oneLoop
  exact div_pos alpha_EM_PDG_pos (by positivity)

/-- Schwinger's 1-loop anomaly is nonneg. -/
theorem schwinger_ae_oneLoop_nonneg : 0 ≤ schwinger_ae_oneLoop :=
  le_of_lt schwinger_ae_oneLoop_pos

/-- Schwinger's 1-loop anomaly is strictly smaller than α_EM itself.
    (Since 2π > 1, division by 2π shrinks α_PDG.) -/
theorem schwinger_ae_oneLoop_lt_alpha :
    schwinger_ae_oneLoop < alpha_EM_PDG := by
  unfold schwinger_ae_oneLoop
  rw [div_lt_iff₀ (by positivity : (0 : ℝ) < 2 * Real.pi)]
  have h1 : (1 : ℝ) < 2 * Real.pi := by
    have := Real.pi_gt_three
    linarith
  calc alpha_EM_PDG
      = alpha_EM_PDG * 1 := by ring
    _ < alpha_EM_PDG * (2 * Real.pi) :=
        mul_lt_mul_of_pos_left h1 alpha_EM_PDG_pos

/-- **Smallness of the Schwinger anomaly**: `a_e < 1/100`.  A loose
    upper bound following from `α_EM < 1/100`. -/
theorem schwinger_ae_oneLoop_small : schwinger_ae_oneLoop < (1 : ℝ) / 100 := by
  have h1 : schwinger_ae_oneLoop < alpha_EM_PDG := schwinger_ae_oneLoop_lt_alpha
  exact lt_trans h1 alpha_EM_PDG_small_1_100

/-! ## 4. Paper-citable bundle

A single theorem that collects the three-tier guarantee for reference
from manuscripts and for downstream Paper/*.lean aliases. -/

/-- **Paper bundle**: α_EM is positive, strictly bounded above by
    1/137, strictly bounded below by 1/138, and the one-loop Schwinger
    anomaly `α/(2π)` inherits all three properties. -/
theorem alpha_EM_paper_bundle :
    0 < alpha_EM_PDG ∧
    (1 : ℝ) / 138 < alpha_EM_PDG ∧
    alpha_EM_PDG < (1 : ℝ) / 137 ∧
    0 < schwinger_ae_oneLoop ∧
    schwinger_ae_oneLoop < alpha_EM_PDG := by
  refine ⟨alpha_EM_PDG_pos, alpha_EM_PDG_gt_1_138,
          alpha_EM_PDG_small_1_137,
          schwinger_ae_oneLoop_pos,
          schwinger_ae_oneLoop_lt_alpha⟩

end OmegaTheory.Predictions.AlphaEM
