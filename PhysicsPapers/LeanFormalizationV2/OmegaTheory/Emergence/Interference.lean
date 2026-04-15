/-
  OmegaTheory.Emergence.Interference

  **Phase 4 of the QM-bridge plan.**  Two-slit interference emerges as
  a theorem from the superposition of two plane-wave coarse-grained
  fields sharing a common amplitude substrate.

  ## Physical story

  A single substrate snapshot sequence `s : SnapshotSequence` carries a
  Boltzmann-type amplitude `A(p, n) = exp(−I_KL(g(n), g₀, p) / 2)` that
  is **phase- and mass-independent** (see `abs_coarseGrainWithPhase` in
  `CoarseGrainingMap.lean`).  "Going through slit `j`" attaches a
  plane-wave phase

        φⱼ(p, n) = kⱼ · p − ωⱼ · n

  to that common amplitude, giving a complex coarse-grained field
  `ψⱼ = A · exp(i · φⱼ)`.  The quantum-mechanical superposition
  principle says: when both slits are open, the detected field is the
  complex sum

        ψ_super(p, n) = ψ₁(p, n) + ψ₂(p, n).

  The detection probability is `|ψ_super|²`, which we compute
  **exactly** — no `O(ℓ_P)` remainder, no smoothness hypothesis:

        |ψ_super(p, n)|²
            = A(p,n)² · (2 + 2·cos(φ₁(p,n) − φ₂(p,n)))
            = |ψ₁(p,n)|² + |ψ₂(p,n)|² + 2·|ψ₁|·|ψ₂|·cos(Δφ).

  The last line is the **textbook two-slit interference formula**.  The
  `2·|ψ₁||ψ₂|cos(Δφ)` term is the interference; at integer multiples of
  `2π` in `Δφ` we get constructive peaks and at `(2k+1)π` we get
  destructive zeros.

  ## Why the superposition operation lives at the complex-field level

  An earlier design explored a "⊕" at the snapshot-sequence level —
  `s₁ ⊕ s₂ : SnapshotSequence` whose metric is some pointwise
  combination of `s₁.metric` and `s₂.metric`.  That is **not**
  honestly possible here: `DiscreteMetric` is `LatticePoint → Fin 4 →
  Fin 4 → ℝ` and pointwise *sums* of metrics are not metrics (they do
  not respect the Lorentzian signature structure used by
  `informationDensityKL`).  A non-linear "merge" rule that did yield a
  valid metric would force an `O(ℓ_P)` error term into the
  superposition identity, losing the exact interference formula.

  The clean, textbook-consistent resolution is: the substrate is
  shared (same `s`), and "which slit" is encoded in a **phase label**
  on that shared amplitude.  This matches the Feynman path-integral
  description of the two-slit experiment in which the amplitudes from
  different paths are summed over a *common* background.  All
  ingredients in this file are exact; no residues need to be tracked.

  ## Contents

  * `superposedField` — complex-field superposition `ψ₁ + ψ₂`.
  * `superposedField_abs_sq` — the interference identity:
    `|ψ₁ + ψ₂|² = |ψ₁|² + |ψ₂|² + 2·Re(ψ₁ · conj ψ₂)`.
  * `planeWaveField` — `A · exp(i·planeWavePhase k ω)` on a substrate.
  * `planeWaveField_abs` — amplitude is the substrate's.
  * `planeWaveField_conj_product_re` — the real part of
    `ψ₁ · conj ψ₂` for two plane waves equals `A² · cos(Δφ)`.
  * `two_slit_interference` — **headline theorem**.  The exact
    two-slit formula.
  * `double_slit_visibility` — balanced-amplitude corollary.
    `|ψ_super|² = 2·A²·(1 + cos(Δφ))`, the canonical cos²(Δφ/2) form.
  * `two_slit_constructive_peak` — `Δφ = 0` ⇒ `|ψ_super|² = 4·A²`.
  * `two_slit_destructive_null` — `Δφ = π` ⇒ `|ψ_super|² = 0`.

  No `sorry`.  No new axioms.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.SnapshotDynamics
import OmegaTheory.Emergence.BornRule
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Complex.Log
import Mathlib.Analysis.SpecialFunctions.Complex.Circle

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open scoped Complex

/-! ## Complex-field superposition -/

/-- Pointwise complex-field superposition.  This is the additive
    superposition of two `LatticeComplexField`s — the natural
    operation on the target of the coarse-graining map.  We do **not**
    attempt to lift this to a "superposition of snapshot sequences":
    see the file header for why the complex-field level is the honest
    venue. -/
noncomputable def superposedField
    (ψ₁ ψ₂ : LatticeComplexField) : LatticeComplexField :=
  fun p n => ψ₁ p n + ψ₂ p n

/-- Superposition is symmetric. -/
theorem superposedField_comm (ψ₁ ψ₂ : LatticeComplexField) :
    superposedField ψ₁ ψ₂ = superposedField ψ₂ ψ₁ := by
  unfold superposedField
  funext p n
  ring

/-- **The interference identity at the complex-field level.**
    For any two complex values `a, b`,

          |a + b|² = |a|² + |b|² + 2·Re(a · conj b).

    This is the algebraic heart of the two-slit theorem.  Stated
    pointwise on the lattice, it is exact — no residues. -/
theorem superposedField_abs_sq
    (ψ₁ ψ₂ : LatticeComplexField) (p : LatticePoint) (n : ℕ) :
    ‖superposedField ψ₁ ψ₂ p n‖ ^ 2 =
      ‖ψ₁ p n‖ ^ 2 + ‖ψ₂ p n‖ ^ 2 +
        2 * (ψ₁ p n * (starRingEnd ℂ) (ψ₂ p n)).re := by
  unfold superposedField
  set a := ψ₁ p n
  set b := ψ₂ p n
  -- Expand |a + b|² via Complex.sq_norm.
  rw [Complex.sq_norm, Complex.sq_norm, Complex.sq_norm]
  -- Use the normSq addition formula.
  exact Complex.normSq_add a b

/-! ## Plane-wave coarse-grained fields -/

/-- The **plane-wave coarse-grained field** on a snapshot sequence `s`
    with wavevector `k` and frequency `ω`.  Shorthand for
    `coarseGrainWithPhase s (planeWavePhase k ω) m`.  The substrate
    `s` carries the shared amplitude `A(p, n) = exp(−I_KL / 2)`; the
    plane wave contributes only to the phase. -/
noncomputable def planeWaveField
    (s : SnapshotSequence) (m : ℝ)
    (k : LatticePoint) (ω : ℝ) : LatticeComplexField :=
  coarseGrainWithPhase s (planeWavePhase k ω) m

/-- The modulus of a plane-wave coarse-grained field equals the
    substrate's amplitude — independent of `k, ω, m`.  Immediate from
    `abs_coarseGrainWithPhase`. -/
theorem planeWaveField_abs
    (s : SnapshotSequence) (m : ℝ) (k : LatticePoint) (ω : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖planeWaveField s m k ω p n‖ = coarseGrainAmplitude s p n := by
  unfold planeWaveField
  exact abs_coarseGrainWithPhase s (planeWavePhase k ω) m p n

/-- Squared modulus of a plane-wave field equals `exp(−I_KL)`.  The
    plane-wave phase does not contribute to `|ψ|²`. -/
theorem planeWaveField_abs_sq
    (s : SnapshotSequence) (m : ℝ) (k : LatticePoint) (ω : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖planeWaveField s m k ω p n‖ ^ 2 =
      Real.exp (- (informationDensityKL (s.metric n) s.reference p)) := by
  unfold planeWaveField
  exact sq_abs_coarseGrainWithPhase s (planeWavePhase k ω) m p n

/-- Explicit polar form of the plane-wave field:
    `ψ(p,n) = A(p,n) · exp(i·(k·p − ω·n))`. -/
theorem planeWaveField_polar
    (s : SnapshotSequence) (m : ℝ) (k : LatticePoint) (ω : ℝ)
    (p : LatticePoint) (n : ℕ) :
    planeWaveField s m k ω p n =
      (coarseGrainAmplitude s p n : ℂ) *
        Complex.exp (Complex.I * ((planeWavePhase k ω p n : ℝ) : ℂ)) := by
  unfold planeWaveField coarseGrainWithPhase
  rfl

/-! ## The two-slit identity

    At the heart of two-slit interference is the following exact
    identity.  For two plane waves sharing a common substrate
    amplitude `A`,

        ψ₁ · conj ψ₂ = A² · exp(i · (φ₁ − φ₂))

    so `Re(ψ₁ · conj ψ₂) = A² · cos(φ₁ − φ₂)`.
-/

/-- **Key algebraic identity.**  The real part of
    `ψ₁(p,n) · conj(ψ₂(p,n))` for two plane waves on the same
    substrate equals `A(p,n)² · cos(φ₁(p,n) − φ₂(p,n))`. -/
theorem planeWaveField_conj_product_re
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    (planeWaveField s m k₁ ω₁ p n *
      (starRingEnd ℂ) (planeWaveField s m k₂ ω₂ p n)).re =
      coarseGrainAmplitude s p n ^ 2 *
        Real.cos (planeWavePhase k₁ ω₁ p n - planeWavePhase k₂ ω₂ p n) := by
  -- Unfold planeWaveField to its polar form.
  unfold planeWaveField coarseGrainWithPhase
  set A : ℝ := coarseGrainAmplitude s p n with hA_def
  set φ₁ : ℝ := planeWavePhase k₁ ω₁ p n with hφ₁_def
  set φ₂ : ℝ := planeWavePhase k₂ ω₂ p n with hφ₂_def
  -- Step 1: reduce ψ₁ · conj ψ₂ to A² · exp(i · (φ₁ − φ₂)).
  have hprod :
      (A : ℂ) * Complex.exp (Complex.I * (φ₁ : ℂ)) *
        (starRingEnd ℂ)
          ((A : ℂ) * Complex.exp (Complex.I * (φ₂ : ℂ))) =
      ((A * A : ℝ) : ℂ) *
        Complex.exp (((φ₁ - φ₂ : ℝ) : ℂ) * Complex.I) := by
    have hconj_exp :
        (starRingEnd ℂ) (Complex.exp (Complex.I * (φ₂ : ℂ))) =
          Complex.exp (-(Complex.I * (φ₂ : ℂ))) := by
      rw [← Complex.exp_conj]
      congr 1
      rw [map_mul, Complex.conj_I, Complex.conj_ofReal]
      ring
    have hexp_sum :
        Complex.exp (Complex.I * (φ₁ : ℂ)) *
          Complex.exp (-(Complex.I * (φ₂ : ℂ)))
        = Complex.exp (((φ₁ - φ₂ : ℝ) : ℂ) * Complex.I) := by
      rw [← Complex.exp_add]
      congr 1
      push_cast
      ring
    calc (A : ℂ) * Complex.exp (Complex.I * (φ₁ : ℂ)) *
            (starRingEnd ℂ)
              ((A : ℂ) * Complex.exp (Complex.I * (φ₂ : ℂ)))
        = (A : ℂ) * Complex.exp (Complex.I * (φ₁ : ℂ)) *
            ((A : ℂ) *
              (starRingEnd ℂ) (Complex.exp (Complex.I * (φ₂ : ℂ)))) := by
              rw [map_mul, Complex.conj_ofReal]
      _ = (A : ℂ) * Complex.exp (Complex.I * (φ₁ : ℂ)) *
            ((A : ℂ) * Complex.exp (-(Complex.I * (φ₂ : ℂ)))) := by
              rw [hconj_exp]
      _ = ((A * A : ℝ) : ℂ) *
            (Complex.exp (Complex.I * (φ₁ : ℂ)) *
              Complex.exp (-(Complex.I * (φ₂ : ℂ)))) := by
              push_cast
              ring
      _ = ((A * A : ℝ) : ℂ) *
            Complex.exp (((φ₁ - φ₂ : ℝ) : ℂ) * Complex.I) := by
              rw [hexp_sum]
  -- Step 2: extract the real part of A² · exp(i(φ₁-φ₂)).
  rw [hprod]
  rw [Complex.exp_mul_I]
  -- Now goal:
  --   ((A*A : ℂ) * (cos (φ₁-φ₂ : ℂ) + sin (φ₁-φ₂ : ℂ) * I)).re
  --     = A^2 * Real.cos (φ₁ - φ₂)
  rw [Complex.mul_re]
  have h_re :
      ((A * A : ℝ) : ℂ).re = A * A := Complex.ofReal_re _
  have h_im : ((A * A : ℝ) : ℂ).im = 0 := Complex.ofReal_im _
  rw [h_re, h_im, zero_mul, sub_zero]
  -- Goal: A * A * (cos (↑(φ₁-φ₂)) + sin (↑(φ₁-φ₂)) * I).re = A^2 * Real.cos (φ₁-φ₂)
  rw [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  -- Goal is now of shape:
  --   A * A * ((Complex.cos ↑(φ₁-φ₂)).re + (0 - (Complex.sin ↑(φ₁-φ₂)).im))
  --     = A^2 * Real.cos (φ₁ - φ₂)
  rw [Complex.cos_ofReal_re, Complex.sin_ofReal_im]
  ring

/-! ## The headline theorem: two-slit interference -/

/-- **Two-slit interference theorem.**  For two plane-wave
    coarse-grained fields `ψ₁, ψ₂` on a common substrate `s` with
    effective mass `m`, wavevectors `k₁, k₂`, and frequencies `ω₁, ω₂`,
    the superposed-field probability density is exactly

        |ψ₁ + ψ₂|² = |ψ₁|² + |ψ₂|² + 2 · A² · cos(Δφ),

    where `A(p,n) = exp(−I_KL(g(n), g₀, p)/2)` is the shared substrate
    amplitude and `Δφ(p,n) = (k₁ − k₂) · p − (ω₁ − ω₂) · n` is the
    phase difference of the two "slits".

    This is the machine-checked two-slit interference formula, derived
    from the OmegaTheory V2 discrete-gravity substrate with **no**
    residue terms and **no** new axioms.  The interference term
    `2 · A² · cos(Δφ)` alternates between constructive peaks
    (`Δφ = 2πk`) and destructive zeros (`Δφ = π(2k+1)`), reproducing
    the standard single-source double-slit fringe pattern.

    The proof chain:
      (i) `superposedField_abs_sq` expands `|ψ₁+ψ₂|²` into
          `|ψ₁|² + |ψ₂|² + 2 Re(ψ₁ conj ψ₂)`;
      (ii) `planeWaveField_conj_product_re` evaluates the cross term
           to `A² cos(Δφ)` exactly.
    Both (i) and (ii) are algebraic identities — no estimates, no
    smoothness hypotheses.  Phases entering only multiplicatively
    through `exp(i·φ)` make the whole chain clean. -/
theorem two_slit_interference
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 =
      ‖planeWaveField s m k₁ ω₁ p n‖ ^ 2 +
      ‖planeWaveField s m k₂ ω₂ p n‖ ^ 2 +
      2 * coarseGrainAmplitude s p n ^ 2 *
        Real.cos (planeWavePhase k₁ ω₁ p n - planeWavePhase k₂ ω₂ p n) := by
  rw [superposedField_abs_sq, planeWaveField_conj_product_re]
  ring

/-- **Two-slit interference in KL-density form.**  Rewriting the
    individual `|ψⱼ|²` via `planeWaveField_abs_sq`, the theorem
    becomes an identity in the Boltzmann weights:

        |ψ₁ + ψ₂|² = 2 · exp(−I_KL) + 2 · A² · cos(Δφ).

    This is the most transparent physics form: the `2·exp(−I_KL)`
    piece is the classical (incoherent) intensity and the cosine
    term is the purely-quantum coherence. -/
theorem two_slit_interference_KL
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 =
      2 * Real.exp (- (informationDensityKL (s.metric n) s.reference p)) +
      2 * coarseGrainAmplitude s p n ^ 2 *
        Real.cos (planeWavePhase k₁ ω₁ p n - planeWavePhase k₂ ω₂ p n) := by
  rw [two_slit_interference]
  rw [planeWaveField_abs_sq, planeWaveField_abs_sq]
  ring

/-! ## Balanced-amplitude corollary: the canonical visibility formula -/

/-- **Double-slit visibility** (balanced amplitudes).  When the two
    plane-wave slits share the same substrate — automatic in our
    formulation — the probability density reduces to the canonical
    cos²-shaped fringe formula

        |ψ_super|² = 2 · A² · (1 + cos(Δφ)) = 4 · A² · cos²(Δφ/2).

    This is the standard textbook expression.  We state the `(1 +
    cos)` form because it is the one that falls out of
    `two_slit_interference`; the `cos²(Δφ/2)` identity is a trivial
    algebraic rewrite on the RHS using the half-angle formula.

    No hypothesis of equal amplitudes is needed because in our
    construction both plane waves inherit the same substrate
    amplitude by design. -/
theorem double_slit_visibility
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 =
      2 * coarseGrainAmplitude s p n ^ 2 *
        (1 + Real.cos (planeWavePhase k₁ ω₁ p n -
                        planeWavePhase k₂ ω₂ p n)) := by
  rw [two_slit_interference]
  rw [planeWaveField_abs_sq, planeWaveField_abs_sq]
  have hA : coarseGrainAmplitude s p n ^ 2 =
      Real.exp (- (informationDensityKL (s.metric n) s.reference p)) := by
    unfold coarseGrainAmplitude
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  rw [hA]
  ring

/-! ## Constructive and destructive limits -/

/-- **Constructive interference peak.**  When the phase difference
    `Δφ = 0`, the double-slit intensity is `4 · A²` — four times
    the single-slit intensity.  This is the canonical quantum-doubling
    at the maximum fringe. -/
theorem two_slit_constructive_peak
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ)
    (hΔφ : planeWavePhase k₁ ω₁ p n - planeWavePhase k₂ ω₂ p n = 0) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 =
      4 * coarseGrainAmplitude s p n ^ 2 := by
  rw [double_slit_visibility, hΔφ, Real.cos_zero]
  ring

/-- **Destructive interference null.**  When the phase difference
    `Δφ = π`, the double-slit intensity is exactly zero — complete
    cancellation.  This is the canonical quantum-minimum. -/
theorem two_slit_destructive_null
    (s : SnapshotSequence) (m : ℝ)
    (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ)
    (hΔφ : planeWavePhase k₁ ω₁ p n - planeWavePhase k₂ ω₂ p n = Real.pi) :
    ‖superposedField (planeWaveField s m k₁ ω₁)
        (planeWaveField s m k₂ ω₂) p n‖ ^ 2 = 0 := by
  rw [double_slit_visibility, hΔφ, Real.cos_pi]
  ring

/-! ## Consistency with Born-rule conservation (Phase 3)

    Under the static regime (`HasZeroFunctional`), the substrate
    amplitude `A(p, n)` is tick-invariant (see
    `sq_abs_coarseGrainWithPhase_static_under_dynamics` in
    `BornRule.lean`).  Hence the interference pattern's *amplitude
    envelope* is time-stationary in that regime — the only tick
    dependence sits in the `cos(Δφ)` factor through the `−ω · n`
    piece of the plane-wave phases.

    This is the honest compatibility statement with Phase 3: probability
    is conserved at the substrate (amplitude) level, while interference
    fringes can still move across ticks because the phase difference
    picks up `(ω₂ − ω₁) · n` per tick. -/

/-- **Amplitude envelope is tick-invariant under `HasZeroFunctional`.**
    In the static-functional regime, the tick-indexed "Boltzmann
    envelope" `2 · A(p, n)²` of the two-slit pattern does not change
    with `n`; all tick dependence of `|ψ_super|²` is through
    `cos(Δφ)`.  This is the Born-rule-consistency corollary. -/
theorem two_slit_envelope_tick_invariant
    (d : DynamicalSnapshotSequence)
    (hF : d.HasZeroFunctional)
    (m : ℝ) (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n k : ℕ) :
    coarseGrainAmplitude d.toSnapshotSequence p n =
      coarseGrainAmplitude d.toSnapshotSequence p k := by
  unfold coarseGrainAmplitude
  simp only [DynamicalSnapshotSequence.toSnapshotSequence_metric,
    DynamicalSnapshotSequence.toSnapshotSequence_reference]
  rw [d.metric_eq_initial_under_hasZero hF n,
    d.metric_eq_initial_under_hasZero hF k]

/-! ## Flat-vacuum sanity check -/

/-- **Flat-vacuum interference pattern.**  On the flat Minkowski
    substrate, the substrate amplitude is the constant `exp(−1)`
    (from `coarseGrainAmplitude_flat`), so the two-slit interference
    reduces to a pure cosine fringe

        |ψ_super|² = 2 · exp(−2) · (1 + cos(Δφ)).

    This is the sanity check: on the vacuum, interference is visible
    at full contrast, with the cosine-fringe shape recovered exactly. -/
theorem two_slit_on_flat
    (m : ℝ) (k₁ k₂ : LatticePoint) (ω₁ ω₂ : ℝ)
    (p : LatticePoint) (n : ℕ) :
    ‖superposedField (planeWaveField SnapshotSequence.flat m k₁ ω₁)
        (planeWaveField SnapshotSequence.flat m k₂ ω₂) p n‖ ^ 2 =
      2 * Real.exp (-2) *
        (1 + Real.cos (planeWavePhase k₁ ω₁ p n -
                        planeWavePhase k₂ ω₂ p n)) := by
  rw [double_slit_visibility]
  rw [coarseGrainAmplitude_flat]
  have hexp : Real.exp (-1) ^ 2 = Real.exp (-2) := by
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  rw [hexp]

end OmegaTheory.Emergence
