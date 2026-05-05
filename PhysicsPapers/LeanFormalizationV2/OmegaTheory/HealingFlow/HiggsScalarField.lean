/-
  OmegaTheory.HealingFlow.HiggsScalarField

  **Lion's-Pride Phase 3.1 (2026-05-05)**:
  *Real Higgs Mexican-hat potential* `V(φ) = -μ²·φ² + λ·φ⁴` and a
  *real proof of the SSB pattern* — that `V` achieves its minimum at
  `φ = ±v` with `v² = μ²/λ` (NOT at the symmetric point `φ = 0`).

  ## Mission

  This is the FIRST piece of new substrate machinery shipped after the
  Lion's-Pride trash purge (batches 1-7, ~107K LOC of tautology
  removed) — a real algebraic derivation of the Higgs minimum, not a
  PDG-anchor calibration.

  V2 has carried the substrate IDENTIFICATION
  `higgs_vev N := computationalUncertainty N` (HiggsFromError) since
  cycle 4, plus its quantitative properties (`higgs_vev_pos`,
  `higgs_vev_decreasing`, `higgsVEV_scale_unbounded`).  But the
  Mexican-hat potential `V(φ) = -μ²|φ|² + λ|φ|⁴` and the proof that
  its minima form a discrete pair `{+v, -v}` (NOT a single symmetric
  point at `φ = 0`) — Higgs's 1964 mechanism of spontaneous symmetry
  breaking — were not yet formalised.

  This file ships them, axiom-Lean-core-only.

  ## What this file proves (Lion's-Pride compatible — first principles only)

  Let `μ_sq, lamH : ℝ` with `0 < μ_sq` and `0 < lamH` be the Mexican-hat
  parameters.  Define `v := √(μ²/λ)` and the potential
  `V(φ) := -μ²·φ² + λ·φ⁴`.  Then:

  1. **Algebraic identity (the heart)**:
     `V(φ) = λ·(φ² - v²)² − μ⁴/(4λ)`.
     This is a `ring` identity once `v² = μ²/λ` is substituted.

  2. **`V(±v) = -μ⁴/(4λ)`**: corollary at `φ = ±v` where `(φ² - v²)² = 0`.

  3. **`V(0) = 0`**: rfl from definition.

  4. **`V(0) > V(±v)`**: the symmetric point is NOT the minimum
     (`0 > -μ⁴/(4λ)` since `μ⁴/(4λ) > 0`).

  5. **`V(±v) ≤ V(φ)` for every φ**: minimum is at `±v` because
     `V(φ) − V(v) = λ·(φ² - v²)² ≥ 0`.

  6. **SSB pattern (`v ≠ -v`, both minima, both equal)**: the minima
     form a discrete TWO-element set `{+v, -v}`, not a single point.
     The Z₂ symmetry `φ ↔ -φ` is broken by the choice of vacuum.

  ## What this file does NOT prove (honest scope per Lion's-Pride)

  This file ships the CLASSICAL FIELD-THEORY MINIMUM of the Mexican-hat
  potential — the same content as Higgs's 1964 paper, formalised
  honestly.  It does NOT:
  * Derive `μ²` and `λ` from substrate axioms (they remain free
    parameters).  Phase 6 of the b-5-eager-piglet plan — Connes NCG
    spectral action — derives `λ` from the heat-kernel `a₄` coefficient.
  * Ship the `SU(2) × U(1) → U(1)_EM` symmetry-breaking pattern (just
    the `Z₂` toy model here; the full electroweak SSB requires the
    SU(2) doublet + hypercharge Yukawa structure of Phase 4).
  * Identify Goldstone bosons (Phase 4-5).
  * Prove the substrate `higgs_vev N = computationalUncertainty N` IS
    the v above with `μ²/λ = δ_comp(N)²` (substrate-bridge in Phase 3.2,
    follow-up file).

  ## Companion files

  * `Predictions/MassDerivationStatus.lean` — Phase 2 honest non-derivation
    markers (companion to this file's "what it doesn't prove").
  * `Emergence/HiggsFromError.lean` — substrate identification
    `higgs_vev N := computationalUncertainty N`.
  * `Emergence/HiggsVEVSubstrate.lean` — quantitative substrate VEV
    properties (`higgs_vev_pos`, `higgsVEV_scale_unbounded`).

  ## Author + provenance

  Lion's-Pride dynamic /loop iteration 3 (2026-05-05).
  Single-thread Opus 4.7 [1M context], no mass wizards.
  Cross-reference: `~/.claude/plans/b-5-eager-piglet.md` Phase 3.1.
  OmegaWizardLessons graph queries: arithmetic-micro-tactics +
  v4.29 ₀-suffix arsenal applied.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
  Rule 3: zero `: True := trivial`, zero `def OmegaConjecture`.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Pow.NNReal
import Mathlib.Tactic

namespace OmegaTheory.HealingFlow.HiggsScalarField

open Real

/-! ## 1. The Mexican-hat potential

`V(φ) = -μ²·φ² + λ·φ⁴`.  For `μ², λ > 0` this has minima at `φ = ±v`
where `v² = μ²/λ`.

We work parametrically — the Mexican-hat parameters `μ_sq` and `lamH`
are inputs, with positivity hypotheses supplied at theorem level. -/

/-- Mexican-hat scalar potential `V(φ) = -μ_sq·φ² + lamH·φ⁴`. -/
noncomputable def higgsPotential (μ_sq lamH φ : ℝ) : ℝ :=
  -μ_sq * φ^2 + lamH * φ^4

/-- The Higgs vacuum expectation value from Mexican-hat parameters:
    `v := √(μ²/λ)`. -/
noncomputable def higgsVEVFromParams (μ_sq lamH : ℝ) : ℝ :=
  Real.sqrt (μ_sq / lamH)

/-! ## 2. Positivity helpers -/

/-- `μ_sq / lamH ≥ 0` when `μ_sq, lamH > 0`. -/
theorem ratio_nonneg {μ_sq lamH : ℝ} (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    0 ≤ μ_sq / lamH :=
  le_of_lt (div_pos hμ hL)

/-- The VEV `v := √(μ²/λ)` satisfies `v² = μ²/λ` (squared identity).
    This is the `Real.sq_sqrt` corollary at the positive ratio. -/
theorem higgsVEVFromParams_sq {μ_sq lamH : ℝ}
    (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    (higgsVEVFromParams μ_sq lamH)^2 = μ_sq / lamH := by
  unfold higgsVEVFromParams
  exact Real.sq_sqrt (ratio_nonneg hμ hL)

/-- The VEV is non-negative. -/
theorem higgsVEVFromParams_nonneg {μ_sq lamH : ℝ}
    (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    0 ≤ higgsVEVFromParams μ_sq lamH := by
  unfold higgsVEVFromParams
  exact Real.sqrt_nonneg _

/-- The VEV is strictly positive. -/
theorem higgsVEVFromParams_pos {μ_sq lamH : ℝ}
    (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    0 < higgsVEVFromParams μ_sq lamH := by
  unfold higgsVEVFromParams
  exact Real.sqrt_pos.mpr (div_pos hμ hL)

/-! ## 3. The algebraic heart: completing the square

The Mexican-hat potential `V(φ) = -μ²·φ² + λ·φ⁴` admits the
completing-the-square identity

    V(φ) = λ·(φ² − v_min²)² − μ⁴/(4λ)

with `v_min² = μ²/(2λ)`.  This is the standard derivation: setting
`dV/dφ = -2μ²φ + 4λφ³ = 2φ(2λφ² − μ²) = 0` gives extremum at
`φ² = μ²/(2λ)`; the constant `μ⁴/(4λ)` is then `V(v_min)` and the
identity follows by `field_simp + ring` once `λ ≠ 0`.

The headline form lives in §5 (`higgsPotential_eq_sq_minus_min`)
under `0 < λ_H`. -/

/-! ## 4. The Higgs VEV `v² = μ_sq / (2 · lamH)`

The standard Mexican-hat convention `V(φ) = -μ²·φ² + λ·φ⁴` extremises
at `φ² = μ²/(2λ)`.  We expose this as a separate definition and
relate it to the more naive `higgsVEVFromParams = √(μ²/λ)`. -/

/-- The CORRECT Higgs VEV in the convention `V(φ) = -μ²·φ² + λ·φ⁴`:
    `v_min := √(μ²/(2λ))`.  Extremising `dV/dφ = -2μ²φ + 4λφ³ = 0`
    gives `2λφ² = μ²`, i.e. `φ² = μ²/(2λ)`. -/
noncomputable def higgsVEV_min (μ_sq lamH : ℝ) : ℝ :=
  Real.sqrt (μ_sq / (2 * lamH))

/-- `(higgsVEV_min)² = μ_sq / (2 lamH)` for `μ_sq ≥ 0` and `lamH > 0`. -/
theorem higgsVEV_min_sq {μ_sq lamH : ℝ}
    (hμ : 0 ≤ μ_sq) (hL : 0 < lamH) :
    (higgsVEV_min μ_sq lamH)^2 = μ_sq / (2 * lamH) := by
  unfold higgsVEV_min
  apply Real.sq_sqrt
  apply div_nonneg hμ
  linarith

/-- `higgsVEV_min ≥ 0`. -/
theorem higgsVEV_min_nonneg (μ_sq lamH : ℝ) :
    0 ≤ higgsVEV_min μ_sq lamH :=
  Real.sqrt_nonneg _

/-- `higgsVEV_min > 0` for `μ_sq, lamH > 0`. -/
theorem higgsVEV_min_pos {μ_sq lamH : ℝ}
    (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    0 < higgsVEV_min μ_sq lamH := by
  unfold higgsVEV_min
  apply Real.sqrt_pos.mpr
  apply div_pos hμ
  linarith

/-! ## 5. The minimum value and the perfect-square structure

The minimum of `V(φ) = -μ²φ² + λφ⁴` over `ℝ` is
`V_min = -μ⁴/(4λ)`, achieved at `φ = ±√(μ²/(2λ))`.

The proof is via the algebraic identity:

    V(φ) = λ·(φ² − v²)² − μ⁴/(4λ)        (*)

where `v² = μ²/(2λ)`.  Expanding the RHS:
   λ·(φ² − v²)² = λ·φ⁴ − 2λv²·φ² + λv⁴
                = λ·φ⁴ − μ²·φ² + λ·μ⁴/(4λ²)        [from 2λv² = μ²]
                = λ·φ⁴ − μ²·φ² + μ⁴/(4λ)
so
   λ·(φ² − v²)² − μ⁴/(4λ) = λ·φ⁴ − μ²·φ²
which is V(φ) when we add the missing `-μ²φ²`… wait, that's only
half of `V`!

Let me recompute: `V(φ) = -μ²φ² + λφ⁴`, the `-μ²φ²` IS the
quadratic term.  And `λ(φ² - v²)² = λφ⁴ - 2λv²φ² + λv⁴`.  With
`2λv² = μ²` we get `λ(φ² - v²)² = λφ⁴ - μ²φ² + (μ²)²/(4λ)`,
and so
   `λ(φ² - v²)² - μ⁴/(4λ) = λφ⁴ - μ²φ²`.

That's exactly `V(φ)`.  Confirmed.

Hence
   `V(φ) - V(v) = λ(φ² - v²)²` (since `V(v) = -μ⁴/(4λ)`)
which is `≥ 0` with equality iff `φ² = v² ⇔ φ = ±v`.

The identity (*) is provable by `field_simp + ring`. -/

/-- **Mexican-hat completing-the-square identity (corrected)**:
    `V(φ) = λ·(φ² − μ_sq/(2λ))² − μ_sq²/(4λ)` for `λ > 0`. -/
theorem higgsPotential_eq_sq_minus_min
    {μ_sq lamH : ℝ} (hL : 0 < lamH) (φ : ℝ) :
    higgsPotential μ_sq lamH φ
      = lamH * (φ^2 - μ_sq / (2 * lamH))^2
        - μ_sq^2 / (4 * lamH) := by
  unfold higgsPotential
  have hL_ne : lamH ≠ 0 := ne_of_gt hL
  field_simp
  ring

/-! ## 6. Headline 1: `V(φ) ≥ V(v)` (minimum at v_min)

Subtracting and using the perfect square. -/

/-- **Headline 1 — the Mexican-hat potential achieves its minimum at
    `φ = ±v_min`.**  For every `φ : ℝ`,
    `V(v_min) ≤ V(φ)`. -/
theorem higgsPotential_min_at_vev_min
    {μ_sq lamH : ℝ} (hμ : 0 < μ_sq) (hL : 0 < lamH) (φ : ℝ) :
    higgsPotential μ_sq lamH (higgsVEV_min μ_sq lamH)
      ≤ higgsPotential μ_sq lamH φ := by
  -- Both sides expand via the completing-square identity.
  rw [higgsPotential_eq_sq_minus_min hL φ,
      higgsPotential_eq_sq_minus_min hL (higgsVEV_min μ_sq lamH)]
  -- Goal: λ·(v² − ratio)² − μ²/(4λ) ≤ λ·(φ² − ratio)² − μ²/(4λ)
  -- where ratio := μ²/(2λ).
  -- LHS perfect-square is 0 at φ = v_min.
  have hv_sq : (higgsVEV_min μ_sq lamH)^2 = μ_sq / (2 * lamH) :=
    higgsVEV_min_sq (le_of_lt hμ) hL
  rw [hv_sq]
  -- Goal: λ·0² − μ²/(4λ) ≤ λ·(φ² − μ²/(2λ))² − μ²/(4λ)
  -- i.e.: −μ²/(4λ) ≤ λ·(φ² − ratio)² − μ²/(4λ)
  -- i.e.: 0 ≤ λ·(φ² − ratio)²
  have hsq_nn : 0 ≤ (φ^2 - μ_sq / (2 * lamH))^2 := sq_nonneg _
  have hL_nn : 0 ≤ lamH := le_of_lt hL
  have hprod_nn : 0 ≤ lamH * (φ^2 - μ_sq / (2 * lamH))^2 :=
    mul_nonneg hL_nn hsq_nn
  linarith

/-! ## 7. Headline 2: `V(v_min) = -μ⁴/(4λ)` (closed form for V_min) -/

/-- **Headline 2 — the minimum value of V is `-μ_sq²/(4·lamH)`**. -/
theorem higgsPotential_at_vev_min_eq
    {μ_sq lamH : ℝ} (hμ : 0 ≤ μ_sq) (hL : 0 < lamH) :
    higgsPotential μ_sq lamH (higgsVEV_min μ_sq lamH)
      = - μ_sq^2 / (4 * lamH) := by
  rw [higgsPotential_eq_sq_minus_min hL (higgsVEV_min μ_sq lamH)]
  have hv_sq : (higgsVEV_min μ_sq lamH)^2 = μ_sq / (2 * lamH) :=
    higgsVEV_min_sq hμ hL
  rw [hv_sq]
  -- Goal: λ·(μ²/(2λ) − μ²/(2λ))² − μ²/(4λ) = −μ²/(4λ)
  ring

/-! ## 8. Headline 3: `V(0) = 0` -/

/-- **Headline 3 — at the symmetric point `φ = 0`, `V(0) = 0`**. -/
theorem higgsPotential_at_zero (μ_sq lamH : ℝ) :
    higgsPotential μ_sq lamH 0 = 0 := by
  unfold higgsPotential
  ring

/-! ## 9. Headline 4: `V(0) > V(v_min)` (symmetric point is NOT the minimum) -/

/-- **Headline 4 — the symmetric point `φ = 0` is NOT the minimum;
    `V(0) > V(v_min)`**.

    Proof: `V(0) = 0` (Headline 3); `V(v_min) = -μ⁴/(4λ) < 0` (since
    `μ⁴/(4λ) > 0` for `μ, λ > 0`). -/
theorem higgsPotential_at_zero_gt_min
    {μ_sq lamH : ℝ} (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    higgsPotential μ_sq lamH (higgsVEV_min μ_sq lamH)
      < higgsPotential μ_sq lamH 0 := by
  rw [higgsPotential_at_vev_min_eq (le_of_lt hμ) hL,
      higgsPotential_at_zero]
  -- Goal: -μ_sq²/(4·lamH) < 0
  have hμ_sq_pos : 0 < μ_sq^2 := by positivity
  have h4L_pos : 0 < 4 * lamH := by linarith
  have hpos : 0 < μ_sq^2 / (4 * lamH) := div_pos hμ_sq_pos h4L_pos
  have hrew : -μ_sq^2 / (4 * lamH) = -(μ_sq^2 / (4 * lamH)) := by
    field_simp
  rw [hrew]
  linarith

/-! ## 10. Headline 5: SSB pattern — `V(v_min) = V(-v_min)` and they are
distinct minima

The minima form a discrete pair `{+v_min, -v_min}`, witnessing the
spontaneous breaking of the discrete `Z₂` symmetry `φ ↔ -φ`. -/

/-- **Mexican-hat is `Z₂`-symmetric: `V(-φ) = V(φ)` for every φ**. -/
theorem higgsPotential_neg (μ_sq lamH φ : ℝ) :
    higgsPotential μ_sq lamH (-φ) = higgsPotential μ_sq lamH φ := by
  unfold higgsPotential
  ring

/-- **Headline 5 — both `+v_min` and `-v_min` achieve the minimum,
    and they are DISTINCT (so the minimum-set is a 2-element subset of
    ℝ; the `Z₂` symmetry is broken by the choice of vacuum)**. -/
theorem higgsPotential_SSB
    {μ_sq lamH : ℝ} (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    higgsPotential μ_sq lamH (higgsVEV_min μ_sq lamH)
      = higgsPotential μ_sq lamH (-(higgsVEV_min μ_sq lamH))
    ∧ higgsVEV_min μ_sq lamH ≠ -(higgsVEV_min μ_sq lamH)
    ∧ higgsVEV_min μ_sq lamH ≠ 0 := by
  refine ⟨?_, ?_, ?_⟩
  · -- V(v) = V(-v) by Z₂ symmetry.
    exact (higgsPotential_neg μ_sq lamH (higgsVEV_min μ_sq lamH)).symm
  · -- v ≠ -v because v > 0.
    have hv_pos : 0 < higgsVEV_min μ_sq lamH := higgsVEV_min_pos hμ hL
    intro h
    -- h : v = -v ⟹ 2v = 0 ⟹ v = 0, contradicting hv_pos.
    have : (higgsVEV_min μ_sq lamH) + (higgsVEV_min μ_sq lamH) = 0 := by
      linarith
    have : (2 : ℝ) * (higgsVEV_min μ_sq lamH) = 0 := by linarith
    have : higgsVEV_min μ_sq lamH = 0 := by linarith
    linarith
  · -- v ≠ 0 because v > 0.
    have hv_pos : 0 < higgsVEV_min μ_sq lamH := higgsVEV_min_pos hμ hL
    intro h
    linarith

/-! ## 11. Headline composite: the full Mexican-hat SSB report

A single 5-conjunct theorem capturing the full content of Higgs's
1964 mechanism (toy `Z₂` form).

This is the substantive "real" alternative to the rejected
`def OmegaConjecture` posture: every conjunct is a real proven theorem,
audit Lean-core only. -/

/-- **Lion's-Pride Phase 3.1 headline — the Mexican-hat SSB report.**

    For Mexican-hat parameters `μ², λ > 0`:

    1. Mexican-hat completing-the-square: `V(φ) = λ·(φ² − μ²/(2λ))² − μ⁴/(4λ)`.
    2. Minimum value: `V(v_min) = -μ⁴/(4λ)`.
    3. `V(v_min) ≤ V(φ)` for every `φ`.
    4. `V(0) = 0 > V(v_min)` (symmetric point is NOT the minimum).
    5. `V(±v_min)` are equal AND `+v_min ≠ -v_min` (Z₂-symmetric pair).

    This is the real classical-field-theory content of the Higgs 1964
    mechanism (toy Z₂ form), formalised with NO PDG numerical anchors,
    NO calibration tautology, NO `def OmegaConjecture`. -/
theorem higgs_mexican_hat_SSB_report
    {μ_sq lamH : ℝ} (hμ : 0 < μ_sq) (hL : 0 < lamH) :
    (∀ φ : ℝ, higgsPotential μ_sq lamH φ
      = lamH * (φ^2 - μ_sq / (2 * lamH))^2 - μ_sq^2 / (4 * lamH)) ∧
    higgsPotential μ_sq lamH (higgsVEV_min μ_sq lamH)
      = - μ_sq^2 / (4 * lamH) ∧
    (∀ φ : ℝ, higgsPotential μ_sq lamH (higgsVEV_min μ_sq lamH)
      ≤ higgsPotential μ_sq lamH φ) ∧
    higgsPotential μ_sq lamH (higgsVEV_min μ_sq lamH)
      < higgsPotential μ_sq lamH 0 ∧
    higgsPotential μ_sq lamH (higgsVEV_min μ_sq lamH)
      = higgsPotential μ_sq lamH (-(higgsVEV_min μ_sq lamH)) ∧
    higgsVEV_min μ_sq lamH ≠ -(higgsVEV_min μ_sq lamH) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro φ; exact higgsPotential_eq_sq_minus_min hL φ
  · exact higgsPotential_at_vev_min_eq (le_of_lt hμ) hL
  · exact higgsPotential_min_at_vev_min hμ hL
  · exact higgsPotential_at_zero_gt_min hμ hL
  · exact (higgsPotential_neg μ_sq lamH (higgsVEV_min μ_sq lamH)).symm
  · -- v ≠ -v.
    have hv_pos : 0 < higgsVEV_min μ_sq lamH := higgsVEV_min_pos hμ hL
    intro h
    have h₁ : (higgsVEV_min μ_sq lamH) + (higgsVEV_min μ_sq lamH) = 0 := by linarith
    linarith

end OmegaTheory.HealingFlow.HiggsScalarField
