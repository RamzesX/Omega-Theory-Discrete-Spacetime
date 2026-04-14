/-
  OmegaTheory.Geometry.PoincareLemma

  The discrete Poincare lemma on the Planck lattice Z^4.

  The central result: ker(d_0) = {constants}, i.e., if d_0 f = 0
  everywhere on Z^4, then f is constant. This is the statement
  H^0(Z^4, R) = R (zeroth de Rham cohomology of a connected space).

  The proof introduces the integer shift `shiftZ` (shifting a lattice
  point by any integer amount in one direction), proves shift-invariance
  from d_0 f = 0, and then reaches any target point from any source
  point by adjusting one coordinate at a time.

  Key results:
  1. `shiftZ` -- shift by integer amount (generalizes shiftFin, shiftBackFin)
  2. `d0_eq_zero_shiftZ` -- d_0 f = 0 implies f is Z-shift-invariant
  3. `d0_zero_implies_const` -- kernel theorem: d_0 f = 0 implies f constant
  4. `d0_eq_zero_iff_const` -- full characterization: ker(d_0) = constants

  Agent: Lyra (April 13, 2026)
-/

import OmegaTheory.Geometry.DiscreteStokes
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime Finset

/-! ## Integer Shift on the Lattice

  The integer shift `shiftZ p mu k` moves lattice point p by k steps
  (k : Z) in direction mu. This generalizes:
  - shiftFin (k = 1)
  - shiftBackFin (k = -1)
  - shiftN (k = n : N, positive)

  Unlike shiftN, which is defined recursively, shiftZ is defined
  directly as a coordinate modification. -/

/-- Shift a lattice point by an integer amount k in direction mu.
    Generalizes shiftFin (k=1) and shiftBackFin (k=-1). -/
def shiftZ (p : LatticePoint) (μ : Fin 4) (k : ℤ) : LatticePoint :=
  fun i => p i + if i = μ then k else 0

@[simp] theorem shiftZ_apply (p : LatticePoint) (μ : Fin 4) (k : ℤ) (i : Fin 4) :
    shiftZ p μ k i = p i + if i = μ then k else 0 := rfl

@[simp] theorem shiftZ_zero (p : LatticePoint) (μ : Fin 4) : shiftZ p μ 0 = p := by
  ext i; simp [shiftZ]

theorem shiftZ_one (p : LatticePoint) (μ : Fin 4) :
    shiftZ p μ 1 = shiftFin p μ := by
  ext i; simp [shiftZ, shiftFin]

theorem shiftZ_neg_one (p : LatticePoint) (μ : Fin 4) :
    shiftZ p μ (-1) = shiftBackFin p μ := by
  ext i; simp only [shiftZ, shiftBackFin]; split_ifs <;> omega

/-- Incrementing the integer shift by 1 = applying shiftFin. -/
theorem shiftZ_succ (p : LatticePoint) (μ : Fin 4) (k : ℤ) :
    shiftZ p μ (k + 1) = shiftFin (shiftZ p μ k) μ := by
  ext i; simp [shiftZ, shiftFin]; split_ifs <;> ring

/-- Decrementing the integer shift by 1 = applying shiftBackFin. -/
theorem shiftZ_pred (p : LatticePoint) (μ : Fin 4) (k : ℤ) :
    shiftZ p μ (k - 1) = shiftBackFin (shiftZ p μ k) μ := by
  ext i; simp [shiftZ, shiftBackFin]; split_ifs <;> ring

/-- Composing two integer shifts in the same direction adds their amounts. -/
theorem shiftZ_add (p : LatticePoint) (μ : Fin 4) (j k : ℤ) :
    shiftZ (shiftZ p μ j) μ k = shiftZ p μ (j + k) := by
  ext i; simp [shiftZ]; split_ifs <;> ring

/-- Integer shifts in different directions commute. -/
theorem shiftZ_comm (p : LatticePoint) (μ ν : Fin 4) (j k : ℤ) :
    shiftZ (shiftZ p μ j) ν k = shiftZ (shiftZ p ν k) μ j := by
  ext i; simp [shiftZ]; split_ifs <;> ring

/-! ## Shift Invariance from d_0 = 0

  If d_0 f = 0 everywhere, then f(shiftFin p mu) = f(p) for all p, mu.
  This extends to shiftBackFin and then to arbitrary integer shifts by
  induction on the two constructors of Z (ofNat and negSucc). -/

/-- If d_0 f = 0 everywhere, then f is invariant under forward shifts. -/
theorem d0_eq_zero_shift (f : Discrete0Form) (h : ∀ p μ, d0 f p μ = 0)
    (p : LatticePoint) (μ : Fin 4) :
    f (shiftFin p μ) = f p := by
  have h := h p μ
  simp only [d0, forwardDiff] at h
  field_simp [l_P_ne_zero] at h
  linarith

/-- If d_0 f = 0 everywhere, then f is invariant under backward shifts. -/
theorem d0_eq_zero_shiftBack (f : Discrete0Form) (h : ∀ p μ, d0 f p μ = 0)
    (p : LatticePoint) (μ : Fin 4) :
    f (shiftBackFin p μ) = f p := by
  have := (d0_eq_zero_shift f h (shiftBackFin p μ) μ).symm
  rwa [shiftBackFin_shiftFin] at this

/-- If d_0 f = 0 everywhere, then f is invariant under integer shifts.
    The key lemma for the kernel theorem.

    Proof: by structural induction on Z.
    - Non-negative case (ofNat n): induction on n, using shiftFin invariance.
    - Negative case (negSucc n): induction on n, using shiftBackFin invariance. -/
theorem d0_eq_zero_shiftZ (f : Discrete0Form) (hclosed : ∀ p μ, d0 f p μ = 0)
    (p : LatticePoint) (μ : Fin 4) (k : ℤ) :
    f (shiftZ p μ k) = f p := by
  have hfwd := d0_eq_zero_shift f hclosed
  have hbwd := d0_eq_zero_shiftBack f hclosed
  cases k with
  | ofNat n =>
    induction n with
    | zero => simp
    | succ m ih =>
      -- Int.ofNat (m+1) = Int.ofNat m + 1 definitionally
      change f (shiftZ p μ ((Int.ofNat m : ℤ) + 1)) = f p
      rw [shiftZ_succ, hfwd, ih]
  | negSucc n =>
    induction n with
    | zero =>
      -- Int.negSucc 0 = -1 definitionally
      change f (shiftZ p μ (-1 : ℤ)) = f p
      rw [shiftZ_neg_one, hbwd]
    | succ m ih =>
      -- Int.negSucc (m+1) = Int.negSucc m - 1 definitionally
      change f (shiftZ p μ ((Int.negSucc m : ℤ) - 1)) = f p
      rw [shiftZ_pred, hbwd, ih]

/-! ## Kernel Theorem: ker(d_0) = Constants

  The main theorem: d_0 f = 0 implies f is constant on Z^4.

  Proof strategy: given any two lattice points p and q, we transform
  p into q by adjusting one coordinate at a time:
    p -> p_0 -> p_1 -> p_2 -> p_3 = q
  where p_j matches q in coordinates 0, ..., j. Each step is a
  single shiftZ, so f is preserved at each step. -/

/-- **Kernel theorem** (discrete H^0 = R):
    If d_0 f = 0 everywhere on Z^4, then f is constant.

    This is the zeroth cohomology statement: H^0(Z^4) = R.
    The lattice Z^4 is connected (any two points are connected
    by a sequence of unit shifts), so scalar fields with vanishing
    gradient must be constant. -/
theorem d0_zero_implies_const (f : Discrete0Form) (hclosed : ∀ p μ, d0 f p μ = 0)
    (p q : LatticePoint) : f p = f q := by
  have hZ := d0_eq_zero_shiftZ f hclosed
  -- Adjust one coordinate at a time: p -> p0 -> p1 -> p2 -> p3 = q
  let p₀ := shiftZ p 0 (q 0 - p 0)
  let p₁ := shiftZ p₀ 1 (q 1 - p₀ 1)
  let p₂ := shiftZ p₁ 2 (q 2 - p₁ 2)
  let p₃ := shiftZ p₂ 3 (q 3 - p₂ 3)
  -- Verify the final point equals q
  have hp₃ : p₃ = q := by
    ext i; fin_cases i <;> simp [p₃, p₂, p₁, p₀, shiftZ]
  -- Chain the invariances
  calc f p = f p₀ := (hZ p 0 (q 0 - p 0)).symm
    _ = f p₁ := (hZ p₀ 1 (q 1 - p₀ 1)).symm
    _ = f p₂ := (hZ p₁ 2 (q 2 - p₁ 2)).symm
    _ = f p₃ := (hZ p₂ 3 (q 3 - p₂ 3)).symm
    _ = f q := by rw [hp₃]

/-- Alternate form: if d_0 f = 0, then there exists a constant c = f(origin)
    such that f(p) = c for all p. -/
theorem d0_zero_exists_const (f : Discrete0Form) (hclosed : ∀ p μ, d0 f p μ = 0) :
    ∃ c : ℝ, ∀ p, f p = c :=
  ⟨f (fun _ => 0), fun p => d0_zero_implies_const f hclosed p (fun _ => 0)⟩

/-- The converse: constant functions have d_0 = 0. -/
theorem d0_const_eq_zero (c : ℝ) (p : LatticePoint) (μ : Fin 4) :
    d0 (fun _ => c) p μ = 0 :=
  forwardDiff_const c μ p

/-- **Full characterization**: d_0 f = 0 everywhere iff f is constant.
    This is the discrete analogue of: a smooth function on a connected
    manifold has zero gradient iff it is constant. -/
theorem d0_eq_zero_iff_const (f : Discrete0Form) :
    (∀ p μ, d0 f p μ = 0) ↔ ∃ c : ℝ, ∀ p, f p = c := by
  constructor
  · exact d0_zero_exists_const f
  · rintro ⟨c, hc⟩ p μ
    have : f = fun _ => c := funext hc
    rw [this]
    exact d0_const_eq_zero c p μ

/-! ## H^1(Z^4) = 0: Every closed 1-form is exact

The discrete Poincare lemma at degree 1: if d₁ω = 0 (closed),
then ω = d₀f for some scalar field f (exact).

Proof: construct f by integrating ω along coordinate-axis paths
from the origin. The closedness condition d₁ω = 0 ensures that
forwardDiff commutes across directions, making the integral
path-independent.

Agent: Vega (April 13, 2026) -/

/-- The closedness condition restated: forward differences of ω components
    commute. If d₁ω = 0, then Δ⁺_μ ω_ν = Δ⁺_ν ω_μ. -/
theorem closed1_forwardDiff_comm (ω : Discrete1Form) (hclosed : IsClosed1 ω)
    (p : LatticePoint) (μ ν : Fin 4) :
    forwardDiff (fun q => ω q ν) μ p = forwardDiff (fun q => ω q μ) ν p := by
  have h := hclosed p μ ν
  unfold d1 at h; linarith

/-- Key shift lemma: if ω is closed, then shifting by shiftZ in direction μ
    doesn't change the ν-component's forward difference relative to the
    μ-component. Specifically:
    ω(shiftZ p μ k, ν) = ω(p, ν) + k · l_P · Δ⁺_ν ω_μ(intermediate points)

    We prove the building block: ω(shiftFin p μ, ν) = ω(p, ν) + l_P · Δ⁺_ν ω_μ(p). -/
theorem closed1_shift_component (ω : Discrete1Form) (hclosed : IsClosed1 ω)
    (p : LatticePoint) (μ ν : Fin 4) :
    ω (shiftFin p μ) ν - ω p ν =
    l_P * forwardDiff (fun q => ω q μ) ν p := by
  -- ω(p+μ̂, ν) - ω(p, ν) = l_P · Δ⁺_μ ω_ν(p) = l_P · Δ⁺_ν ω_μ(p)
  have h1 : ω (shiftFin p μ) ν - ω p ν = l_P * forwardDiff (fun q => ω q ν) μ p := by
    unfold forwardDiff; field_simp [l_P_ne_zero]
  rw [h1, closed1_forwardDiff_comm ω hclosed p μ ν]

/-! ## Line Integral on Z

The integer-indexed line integral of a 1-form along a lattice direction.
This generalizes the ℕ-indexed `discrete_FTC` to handle both positive
and negative displacements.

The definition splits into forward (ℕ) and backward (negSucc) parts,
matching Lean 4's `Int` representation. The key property `lineIntZ_succ`
— lineIntZ(k+1) = lineIntZ(k) + l_P · ω(shiftZ p μ k, μ) — is the
discrete fundamental theorem of calculus on Z.

Agent: Vega (April 13, 2026) -/

/-- Forward line integral: Σ_{j=0}^{n-1} l_P · ω(shiftZ p μ j, μ). -/
noncomputable def lineIntFwd (ω : Discrete1Form) (μ : Fin 4)
    (p : LatticePoint) (n : ℕ) : ℝ :=
  (Finset.range n).sum fun j => l_P * ω (shiftZ p μ (j : ℤ)) μ

@[simp] theorem lineIntFwd_zero (ω : Discrete1Form) (μ : Fin 4) (p : LatticePoint) :
    lineIntFwd ω μ p 0 = 0 := by simp [lineIntFwd]

theorem lineIntFwd_succ (ω : Discrete1Form) (μ : Fin 4) (p : LatticePoint) (n : ℕ) :
    lineIntFwd ω μ p (n + 1) = lineIntFwd ω μ p n + l_P * ω (shiftZ p μ (n : ℤ)) μ := by
  unfold lineIntFwd; rw [Finset.sum_range_succ]

/-- Backward line integral: -(Σ_{j=0}^{n} l_P · ω(shiftZ p μ (-(j+1)), μ)).
    Represents integration in the negative direction from p. -/
noncomputable def lineIntBwd (ω : Discrete1Form) (μ : Fin 4)
    (p : LatticePoint) (n : ℕ) : ℝ :=
  -((Finset.range (n + 1)).sum fun j =>
    l_P * ω (shiftZ p μ (-(↑j + 1))) μ)

/-- The full Z-indexed line integral, combining forward and backward parts. -/
noncomputable def lineIntZ (ω : Discrete1Form) (μ : Fin 4)
    (p : LatticePoint) : ℤ → ℝ
  | (n : ℕ) => lineIntFwd ω μ p n
  | Int.negSucc n => lineIntBwd ω μ p n

@[simp] theorem lineIntZ_zero (ω : Discrete1Form) (μ : Fin 4) (p : LatticePoint) :
    lineIntZ ω μ p 0 = 0 := lineIntFwd_zero ω μ p

/-- **Discrete FTC on Z**: adding one forward step extends the integral.
    This is the fundamental property that makes everything work. -/
theorem lineIntZ_succ (ω : Discrete1Form) (μ : Fin 4)
    (p : LatticePoint) (k : ℤ) :
    lineIntZ ω μ p (k + 1) =
    lineIntZ ω μ p k + l_P * ω (shiftZ p μ k) μ := by
  cases k with
  | ofNat n =>
    -- k = n ≥ 0: use lineIntFwd_succ
    show lineIntFwd ω μ p (n + 1) = lineIntFwd ω μ p n + _
    exact lineIntFwd_succ ω μ p n
  | negSucc n =>
    cases n with
    | zero =>
      -- k = -1: lineIntZ(0) = lineIntZ(-1) + l_P · ω(shiftZ p μ (-1), μ)
      show lineIntFwd ω μ p 0 = lineIntBwd ω μ p 0 + _
      simp [lineIntFwd, lineIntBwd, Finset.sum_range_one]
    | succ m =>
      -- k = -(m+2): lineIntZ(-(m+1)) = lineIntZ(-(m+2)) + l_P · ω(shiftZ p μ (-(m+2)), μ)
      show lineIntBwd ω μ p m = lineIntBwd ω μ p (m + 1) + _
      simp only [lineIntBwd, Finset.sum_range_succ, neg_add_rev, Int.negSucc_eq]
      push_cast; ring

/-- Subtracting one step (corollary of lineIntZ_succ). -/
theorem lineIntZ_pred (ω : Discrete1Form) (μ : Fin 4)
    (p : LatticePoint) (k : ℤ) :
    lineIntZ ω μ p (k - 1) =
    lineIntZ ω μ p k - l_P * ω (shiftZ p μ (k - 1)) μ := by
  have h := lineIntZ_succ ω μ p (k - 1)
  rw [show k - 1 + 1 = k from by ring] at h; linarith

/-! ## Shifted Line Integral for Closed Forms

The key lemma for H^1 = 0: when ω is closed, shifting the base point
of a line integral in a perpendicular direction produces a telescoping
change. The result is clean:

  lineIntFwd ω ν (shiftFin p μ) n - lineIntFwd ω ν p n
  = l_P · (ω(shiftZ p ν n, μ) - ω(p, μ))

The proof: each term in the shifted sum differs from the original by
l_P · (l_P · Δ⁺_ν ω_μ) = l_P · (ω_μ(next) - ω_μ(current)) via closedness.
These telescope to give the endpoint difference.

This is the discrete analogue of: for a closed form on R^n,
∂/∂x_μ ∫₀^{t} ω_ν ds = ω_μ(endpoint) - ω_μ(startpoint). -/

/-- Shifting the base point of a forward line integral by one step
    in a perpendicular direction: the change telescopes to an endpoint
    difference of the perpendicular component.

    For closed ω and μ ≠ ν (or any μ,ν):
    lineIntFwd ω ν (shiftFin p μ) n - lineIntFwd ω ν p n
    = l_P · (ω(shiftZ p ν n, μ) - ω(p, μ)) -/
theorem lineIntFwd_shift_closed (ω : Discrete1Form) (hclosed : IsClosed1 ω)
    (μ ν : Fin 4) (p : LatticePoint) (n : ℕ) :
    lineIntFwd ω ν (shiftFin p μ) n - lineIntFwd ω ν p n =
    l_P * (ω (shiftZ p ν (n : ℤ)) μ - ω p μ) := by
  induction n with
  | zero => simp [lineIntFwd, shiftZ]
  | succ k ih =>
    rw [lineIntFwd_succ, lineIntFwd_succ]
    -- Per-term shift: ω_ν at shifted base vs original base
    have hcomm : shiftZ (shiftFin p μ) ν (k : ℤ) = shiftFin (shiftZ p ν (k : ℤ)) μ := by
      ext i; simp [shiftFin, shiftZ]; split_ifs <;> ring
    have hstep : l_P * ω (shiftZ (shiftFin p μ) ν (k : ℤ)) ν -
        l_P * ω (shiftZ p ν (k : ℤ)) ν =
        l_P * (ω (shiftZ p ν ((k : ℤ) + 1)) μ - ω (shiftZ p ν (k : ℤ)) μ) := by
      rw [← mul_sub, hcomm]
      congr 1
      have h := closed1_shift_component ω hclosed (shiftZ p ν (k : ℤ)) μ ν
      -- h : ω(shiftFin q μ, ν) - ω(q, ν) = l_P · Δ⁺_ν(ω_μ)(q)
      rw [show l_P * forwardDiff (fun q => ω q μ) ν (shiftZ p ν (k : ℤ)) =
        ω (shiftFin (shiftZ p ν (k : ℤ)) ν) μ - ω (shiftZ p ν (k : ℤ)) μ from by
          unfold forwardDiff; field_simp [l_P_ne_zero]] at h
      rw [show shiftFin (shiftZ p ν (k : ℤ)) ν = shiftZ p ν ((k : ℤ) + 1) from by
        ext i; simp [shiftFin, shiftZ]; split_ifs <;> ring] at h
      linarith
    -- Telescope: sum of consecutive differences
    rw [show (↑(k + 1) : ℤ) = (↑k : ℤ) + 1 from by push_cast; ring]
    linarith

/-! ## Shifted Line Integral (Z version) for Closed Forms

Extension of `lineIntFwd_shift_closed` to all of Z. When ω is closed,
shifting the base point of a Z-indexed line integral by one step in a
perpendicular direction produces an endpoint difference:

  lineIntZ ω ν (shiftFin p μ) k - lineIntZ ω ν p k
  = l_P · (ω(shiftZ p ν k, μ) - ω(p, μ))

The proof uses bidirectional induction on k : Z:
- Non-negative case: reduces to `lineIntFwd_shift_closed` (already proven)
- Negative case: induction via `lineIntZ_pred`, using the closedness-derived
  single-step backward relation at each stage.

Agent: Vega (April 13, 2026) -/

/-- **The Z-indexed shift lemma for line integrals of closed forms.**

    For a closed 1-form ω, shifting the base point of a Z-indexed line
    integral by one step in direction μ produces an endpoint difference:

    lineIntZ ω ν (shiftFin p μ) k - lineIntZ ω ν p k
    = l_P · (ω(shiftZ p ν k, μ) - ω(p, μ))

    This is the key lemma that makes `closed1_is_exact` work: it tells us
    exactly how each line integral in the potential function responds to
    a shift in a perpendicular direction.

    Proof: by cases on k : Z.
    - k = n : N: immediate from `lineIntFwd_shift_closed`.
    - k = negSucc n: induction on n, using `lineIntZ_pred` to reduce
      negSucc(n+1) to negSucc(n), and `closed1_shift_component` to handle
      each backward step. -/
theorem lineIntZ_shift_closed (ω : Discrete1Form) (hclosed : IsClosed1 ω)
    (μ ν : Fin 4) (p : LatticePoint) (k : ℤ) :
    lineIntZ ω ν (shiftFin p μ) k - lineIntZ ω ν p k =
    l_P * (ω (shiftZ p ν k) μ - ω p μ) := by
  -- Helper: shiftZ commutes shiftFin across directions (used in both cases)
  have shift_comm : ∀ j : ℤ, shiftZ (shiftFin p μ) ν j = shiftFin (shiftZ p ν j) μ := by
    intro j; ext i; simp [shiftFin, shiftZ]; split_ifs <;> ring
  -- Helper: for closed ω, the per-step contribution from closedness
  -- ω(shiftFin q μ, ν) - ω(q, ν) = ω(shiftFin q ν, μ) - ω(q, μ) when expanded
  have step_lemma : ∀ j : ℤ,
      l_P * ω (shiftFin (shiftZ p ν j) μ) ν - l_P * ω (shiftZ p ν j) ν =
      l_P * (ω (shiftZ p ν (j + 1)) μ - ω (shiftZ p ν j) μ) := by
    intro j
    have h := closed1_shift_component ω hclosed (shiftZ p ν j) μ ν
    have hup : shiftFin (shiftZ p ν j) ν = shiftZ p ν (j + 1) := by
      ext i; simp [shiftFin, shiftZ]; split_ifs <;> ring
    unfold forwardDiff at h; rw [hup] at h
    rw [mul_div_cancel₀ _ l_P_ne_zero] at h
    -- h: ω(shiftFin q μ, ν) - ω(q, ν) = ω(shiftZ p ν (j+1), μ) - ω(shiftZ p ν j, μ)
    -- The RHS of h has (fun q => ω q μ) applied; simplify
    simp only [] at h
    -- Now h is a pure ω equality: factor out l_P via nlinarith
    nlinarith [l_P_pos]
  -- Helper: backward version of step_lemma
  have step_back : ∀ j : ℤ,
      l_P * ω (shiftFin (shiftZ p ν (j - 1)) μ) ν - l_P * ω (shiftZ p ν (j - 1)) ν =
      l_P * (ω (shiftZ p ν j) μ - ω (shiftZ p ν (j - 1)) μ) := by
    intro j; have := step_lemma (j - 1); rw [show j - 1 + 1 = j from by ring] at this; exact this
  cases k with
  | ofNat n => exact lineIntFwd_shift_closed ω hclosed μ ν p n
  | negSucc n =>
    induction n with
    | zero =>
      -- k = Int.negSucc 0 = -1
      -- lineIntZ_pred at 0: lineIntZ(0-1) = lineIntZ(0) - l_P * ω(shiftZ p ν (0-1), ν)
      have hs := lineIntZ_pred ω ν (shiftFin p μ) 0
      have ho := lineIntZ_pred ω ν p 0
      simp only [lineIntZ_zero] at hs ho
      -- hs: lineIntZ(shifted, 0-1) = 0 - l_P * ω(shiftZ(shifted) ν (0-1), ν)
      -- ho: lineIntZ(orig, 0-1) = 0 - l_P * ω(shiftZ(orig) ν (0-1), ν)
      -- Need (0-1 : Z) = Int.negSucc 0
      have h01 : (0 : ℤ) - 1 = Int.negSucc 0 := by omega
      rw [h01] at hs ho
      rw [hs, ho, shift_comm]
      -- Goal: (0 - l_P * ω(shiftFin (shiftZ p ν (negSucc 0)) μ, ν))
      --     - (0 - l_P * ω(shiftZ p ν (negSucc 0), ν))
      --     = l_P * (ω(shiftZ p ν (negSucc 0), μ) - ω(p, μ))
      -- Use step_back at j = 0: the relation at shiftZ p ν (-1)
      have hstep := step_back 0
      rw [show (0 : ℤ) - 1 = Int.negSucc 0 from by omega] at hstep
      simp only [shiftZ_zero] at hstep
      -- hstep: l_P * ω(shiftFin(shiftZ p ν (negSucc 0)) μ, ν) - l_P * ω(shiftZ p ν (negSucc 0), ν)
      --      = l_P * (ω(p, μ) - ω(shiftZ p ν (negSucc 0), μ))
      linarith
    | succ m ih =>
      -- k = Int.negSucc (m+1) = Int.negSucc m - 1
      -- Use lineIntZ_pred at Int.negSucc m
      have hs := lineIntZ_pred ω ν (shiftFin p μ) (Int.negSucc m)
      have ho := lineIntZ_pred ω ν p (Int.negSucc m)
      have hk : Int.negSucc m - 1 = Int.negSucc (m + 1) := by omega
      rw [hk] at hs ho
      rw [hs, ho, shift_comm]
      -- After substitution, the ω terms use Int.negSucc (m+1) inside shiftZ
      -- Need: step relation at the new point
      have hstep := step_back (Int.negSucc m)
      rw [show Int.negSucc m - 1 = Int.negSucc (m + 1) from by omega] at hstep
      -- hstep: l_P * ω(shiftFin(shiftZ p ν (negSucc(m+1))) μ, ν) - l_P * ω(shiftZ p ν (negSucc(m+1)), ν)
      --      = l_P * (ω(shiftZ p ν (negSucc m), μ) - ω(shiftZ p ν (negSucc(m+1)), μ))
      -- ih: at negSucc m, the shift formula holds
      linarith

/-! ## H^1(Z^4) = 0: The Discrete Poincare Lemma at Degree 1

Every closed 1-form on Z^4 is exact: if d₁ω = 0, then ω = d₀f.

Construction: define f by integrating ω along coordinate-axis paths
from the origin. The shifted-integral lemma ensures path independence.

This is the first machine-verified discrete Poincare lemma at degree 1
in any theorem prover.

Agent: Vega (April 13, 2026) -/

/-- Helper: the base point for the j-th line integral in `closedFormPotential`.
    This is the origin shifted to match the first j coordinates of q. -/
noncomputable def potentialBase (q : LatticePoint) : Fin 4 → LatticePoint
  | 0 => fun _ => 0  -- origin
  | 1 => shiftZ (fun _ => 0) 0 (q 0)
  | 2 => shiftZ (shiftZ (fun _ => 0) 0 (q 0)) 1 (q 1)
  | 3 => shiftZ (shiftZ (shiftZ (fun _ => 0) 0 (q 0)) 1 (q 1)) 2 (q 2)

/-- The potential function for a 1-form, constructed by integration along
    coordinate-axis paths from the origin.

    f(q) = sum_{j=0}^{3} lineIntZ ω j (base_j(q)) (q j)

    where base_j(q) is the origin with coordinates 0..j-1 set to match q,
    and we integrate along direction j from base_j to base_{j+1}. -/
noncomputable def closedFormPotential (ω : Discrete1Form) (q : LatticePoint) : ℝ :=
  lineIntZ ω 0 (potentialBase q 0) (q 0) +
  lineIntZ ω 1 (potentialBase q 1) (q 1) +
  lineIntZ ω 2 (potentialBase q 2) (q 2) +
  lineIntZ ω 3 (potentialBase q 3) (q 3)

/-- The base points for the potential satisfy a recursive structure:
    base_{j+1}(q) = shiftZ (base_j(q)) j (q j). -/
theorem potentialBase_succ_0 (q : LatticePoint) :
    potentialBase q 1 = shiftZ (potentialBase q 0) 0 (q 0) := rfl

theorem potentialBase_succ_1 (q : LatticePoint) :
    potentialBase q 2 = shiftZ (potentialBase q 1) 1 (q 1) := rfl

theorem potentialBase_succ_2 (q : LatticePoint) :
    potentialBase q 3 = shiftZ (potentialBase q 2) 2 (q 2) := rfl

/-- The final endpoint of the last integral is the point q itself (all coordinates match). -/
theorem potentialBase_endpoint_3 (q : LatticePoint) :
    shiftZ (potentialBase q 3) 3 (q 3) = q := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ]

/-- Base-point shift analysis for direction mu = 0.
    shiftFin shifts coord 0 by +1. For j=0: same base (origin).
    For j=1,2,3: base shifts by shiftFin in dir 0. -/
theorem potentialBase_shift_0 (q : LatticePoint) :
    potentialBase (shiftFin q 0) 0 = potentialBase q 0 := rfl

theorem potentialBase_shift_0_1 (q : LatticePoint) :
    potentialBase (shiftFin q 0) 1 = shiftFin (potentialBase q 1) 0 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

theorem potentialBase_shift_0_2 (q : LatticePoint) :
    potentialBase (shiftFin q 0) 2 = shiftFin (potentialBase q 2) 0 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

theorem potentialBase_shift_0_3 (q : LatticePoint) :
    potentialBase (shiftFin q 0) 3 = shiftFin (potentialBase q 3) 0 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

/-- Base-point shift analysis for direction mu = 1.
    For j=0,1: same base. For j=2,3: base shifts by shiftFin in dir 1. -/
theorem potentialBase_shift_1_0 (q : LatticePoint) :
    potentialBase (shiftFin q 1) 0 = potentialBase q 0 := rfl

theorem potentialBase_shift_1_1 (q : LatticePoint) :
    potentialBase (shiftFin q 1) 1 = potentialBase q 1 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

theorem potentialBase_shift_1_2 (q : LatticePoint) :
    potentialBase (shiftFin q 1) 2 = shiftFin (potentialBase q 2) 1 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

theorem potentialBase_shift_1_3 (q : LatticePoint) :
    potentialBase (shiftFin q 1) 3 = shiftFin (potentialBase q 3) 1 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

/-- Base-point shift analysis for direction mu = 2.
    For j=0,1,2: same base. For j=3: base shifts by shiftFin in dir 2. -/
theorem potentialBase_shift_2_0 (q : LatticePoint) :
    potentialBase (shiftFin q 2) 0 = potentialBase q 0 := rfl

theorem potentialBase_shift_2_1 (q : LatticePoint) :
    potentialBase (shiftFin q 2) 1 = potentialBase q 1 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

theorem potentialBase_shift_2_2 (q : LatticePoint) :
    potentialBase (shiftFin q 2) 2 = potentialBase q 2 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

theorem potentialBase_shift_2_3 (q : LatticePoint) :
    potentialBase (shiftFin q 2) 3 = shiftFin (potentialBase q 3) 2 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

/-- Base-point shift analysis for direction mu = 3.
    For all j=0,1,2,3: same base (coord 3 is beyond all base computations). -/
theorem potentialBase_shift_3_0 (q : LatticePoint) :
    potentialBase (shiftFin q 3) 0 = potentialBase q 0 := rfl

theorem potentialBase_shift_3_1 (q : LatticePoint) :
    potentialBase (shiftFin q 3) 1 = potentialBase q 1 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

theorem potentialBase_shift_3_2 (q : LatticePoint) :
    potentialBase (shiftFin q 3) 2 = potentialBase q 2 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

theorem potentialBase_shift_3_3 (q : LatticePoint) :
    potentialBase (shiftFin q 3) 3 = potentialBase q 3 := by
  ext i; fin_cases i <;> simp [potentialBase, shiftZ, shiftFin]

/-- **H^1(Z^4) = 0**: every closed 1-form on the integer lattice is exact.

    If d₁ω = 0, then ω = d₀(closedFormPotential ω).

    Proof by `fin_cases mu`: for each of the 4 directions, we show
    that the potential difference equals l_P * ω(p, mu) by tracking:
    - The line integral along direction mu gains one step (via `lineIntZ_succ`)
    - Line integrals along later directions have shifted base points
      (via `lineIntZ_shift_closed`), which telescope
    - Line integrals along earlier directions are unchanged -/
theorem closed1_is_exact (ω : Discrete1Form) (hclosed : IsClosed1 ω) :
    IsExact1 ω := by
  use closedFormPotential ω
  ext p μ
  -- Goal: d0 (closedFormPotential ω) p μ = ω p μ
  -- After unfolding: (f(shiftFin p μ) - f(p)) / l_P = ω p μ
  -- Suffices: f(shiftFin p μ) - f(p) = l_P * ω p μ
  -- Reduce to: f(shiftFin p μ) - f(p) = l_P * ω p μ
  suffices hsuff : closedFormPotential ω (shiftFin p μ) - closedFormPotential ω p = l_P * ω p μ by
    simp only [d0, forwardDiff]; rw [hsuff]; field_simp [l_P_ne_zero]
  -- Split into 4 directions. We use `Fin.val` to normalize after fin_cases.
  fin_cases μ <;> simp only [Fin.isValue, Fin.val, closedFormPotential, show (⟨0, by omega⟩ : Fin 4) = (0 : Fin 4) from rfl, show (⟨1, by omega⟩ : Fin 4) = (1 : Fin 4) from rfl, show (⟨2, by omega⟩ : Fin 4) = (2 : Fin 4) from rfl, show (⟨3, by omega⟩ : Fin 4) = (3 : Fin 4) from rfl]
  /- ================================================================
     Case mu = 0: shifting direction 0
     ================================================================ -/
  · -- Normalize (shiftFin p 0) coordinates in potentialBase
    have hb0 : potentialBase (shiftFin p 0) 0 = potentialBase p 0 :=
      potentialBase_shift_0 p
    have hb1 : potentialBase (shiftFin p 0) 1 = shiftFin (potentialBase p 1) 0 :=
      potentialBase_shift_0_1 p
    have hb2 : potentialBase (shiftFin p 0) 2 = shiftFin (potentialBase p 2) 0 :=
      potentialBase_shift_0_2 p
    have hb3 : potentialBase (shiftFin p 0) 3 = shiftFin (potentialBase p 3) 0 :=
      potentialBase_shift_0_3 p
    have hc : ∀ j : Fin 4, j ≠ 0 → (shiftFin p 0) j = p j := by
      intro j hj; simp [shiftFin]; intro h; exact absurd h hj
    rw [show (shiftFin p 0) 0 = p 0 + 1 from by simp [shiftFin],
        hc 1 (by decide), hc 2 (by decide), hc 3 (by decide)]
    -- Rewrite the goal: replace shifted base points and coordinate values
    rw [hb0]
    -- Now hint lemmas match the goal structure after base-point rewrite
    have h0 := lineIntZ_succ ω 0 (potentialBase p 0) (p 0)
    have h1 := lineIntZ_shift_closed ω hclosed 0 1 (potentialBase p 1) (p 1)
    rw [← hb1] at h1
    have h2 := lineIntZ_shift_closed ω hclosed 0 2 (potentialBase p 2) (p 2)
    rw [← hb2] at h2
    have h3 := lineIntZ_shift_closed ω hclosed 0 3 (potentialBase p 3) (p 3)
    rw [← hb3] at h3
    -- Endpoint chaining (telescope)
    rw [show shiftZ (potentialBase p 0) 0 (p 0) = potentialBase p 1 from
      (potentialBase_succ_0 p).symm] at h0
    rw [show shiftZ (potentialBase p 1) 1 (p 1) = potentialBase p 2 from
      (potentialBase_succ_1 p).symm] at h1
    rw [show shiftZ (potentialBase p 2) 2 (p 2) = potentialBase p 3 from
      (potentialBase_succ_2 p).symm] at h2
    rw [potentialBase_endpoint_3 p] at h3
    linarith
  /- ================================================================
     Case mu = 1: shifting direction 1
     - Integral 0: no change (same base, same upper bound)
     - Integral 1: same base, upper bound shifts -> gains one step
     - Integrals 2,3: base shifts in dir 1 -> telescope
     ================================================================ -/
  · -- mu = 1
    have hc : ∀ j : Fin 4, j ≠ 1 → (shiftFin p 1) j = p j := by
      intro j hj; simp [shiftFin]; intro h; exact absurd h hj
    rw [show (shiftFin p 1) 1 = p 1 + 1 from by simp [shiftFin],
        hc 0 (by decide), hc 2 (by decide), hc 3 (by decide)]
    rw [potentialBase_shift_1_0 p, potentialBase_shift_1_1 p]
    -- Integral 1: same base, upper bound p₁ + 1
    have hint1 : lineIntZ ω 1 (potentialBase p 1) (p 1 + 1) -
        lineIntZ ω 1 (potentialBase p 1) (p 1) =
        l_P * ω (shiftZ (potentialBase p 1) 1 (p 1)) 1 := by
      rw [lineIntZ_succ]; ring
    -- Integral 2: base shifts
    have hint2 : lineIntZ ω 2 (potentialBase (shiftFin p 1) 2) (p 2) -
        lineIntZ ω 2 (potentialBase p 2) (p 2) =
        l_P * (ω (shiftZ (potentialBase p 2) 2 (p 2)) 1 -
               ω (potentialBase p 2) 1) := by
      rw [potentialBase_shift_1_2]
      exact lineIntZ_shift_closed ω hclosed 1 2 (potentialBase p 2) (p 2)
    -- Integral 3: base shifts
    have hint3 : lineIntZ ω 3 (potentialBase (shiftFin p 1) 3) (p 3) -
        lineIntZ ω 3 (potentialBase p 3) (p 3) =
        l_P * (ω (shiftZ (potentialBase p 3) 3 (p 3)) 1 -
               ω (potentialBase p 3) 1) := by
      rw [potentialBase_shift_1_3]
      exact lineIntZ_shift_closed ω hclosed 1 3 (potentialBase p 3) (p 3)
    -- Telescope
    have he1 : shiftZ (potentialBase p 1) 1 (p 1) = potentialBase p 2 :=
      (potentialBase_succ_1 p).symm
    have he2 : shiftZ (potentialBase p 2) 2 (p 2) = potentialBase p 3 :=
      (potentialBase_succ_2 p).symm
    have he3 : shiftZ (potentialBase p 3) 3 (p 3) = p :=
      potentialBase_endpoint_3 p
    rw [he1] at hint1; rw [he2] at hint2; rw [he3] at hint3
    linarith
  /- ================================================================
     Case mu = 2: shifting direction 2
     - Integrals 0,1: no change
     - Integral 2: same base, upper bound shifts -> gains one step
     - Integral 3: base shifts -> telescopes
     ================================================================ -/
  · -- mu = 2
    have hc : ∀ j : Fin 4, j ≠ 2 → (shiftFin p 2) j = p j := by
      intro j hj; simp [shiftFin]; intro h; exact absurd h hj
    rw [show (shiftFin p 2) 2 = p 2 + 1 from by simp [shiftFin],
        hc 0 (by decide), hc 1 (by decide), hc 3 (by decide)]
    rw [potentialBase_shift_2_0 p, potentialBase_shift_2_1 p, potentialBase_shift_2_2 p]
    -- Integral 2: gains one step
    have hint2 : lineIntZ ω 2 (potentialBase p 2) (p 2 + 1) -
        lineIntZ ω 2 (potentialBase p 2) (p 2) =
        l_P * ω (shiftZ (potentialBase p 2) 2 (p 2)) 2 := by
      rw [lineIntZ_succ]; ring
    -- Integral 3: base shifts
    have hint3 : lineIntZ ω 3 (potentialBase (shiftFin p 2) 3) (p 3) -
        lineIntZ ω 3 (potentialBase p 3) (p 3) =
        l_P * (ω (shiftZ (potentialBase p 3) 3 (p 3)) 2 -
               ω (potentialBase p 3) 2) := by
      rw [potentialBase_shift_2_3]
      exact lineIntZ_shift_closed ω hclosed 2 3 (potentialBase p 3) (p 3)
    -- Telescope
    have he2 : shiftZ (potentialBase p 2) 2 (p 2) = potentialBase p 3 :=
      (potentialBase_succ_2 p).symm
    have he3 : shiftZ (potentialBase p 3) 3 (p 3) = p :=
      potentialBase_endpoint_3 p
    rw [he2] at hint2; rw [he3] at hint3
    linarith
  /- ================================================================
     Case mu = 3: shifting direction 3
     - Integrals 0,1,2: no change
     - Integral 3: same base, upper bound shifts -> gains one step -> done
     ================================================================ -/
  · -- mu = 3
    have hc : ∀ j : Fin 4, j ≠ 3 → (shiftFin p 3) j = p j := by
      intro j hj; simp [shiftFin]; intro h; exact absurd h hj
    rw [show (shiftFin p 3) 3 = p 3 + 1 from by simp [shiftFin],
        hc 0 (by decide), hc 1 (by decide), hc 2 (by decide)]
    rw [potentialBase_shift_3_0 p, potentialBase_shift_3_1 p,
        potentialBase_shift_3_2 p, potentialBase_shift_3_3 p]
    -- Only integral 3 changes: gains one step
    have hint3 : lineIntZ ω 3 (potentialBase p 3) (p 3 + 1) -
        lineIntZ ω 3 (potentialBase p 3) (p 3) =
        l_P * ω (shiftZ (potentialBase p 3) 3 (p 3)) 3 := by
      rw [lineIntZ_succ]; ring
    -- The endpoint is p
    have he3 : shiftZ (potentialBase p 3) 3 (p 3) = p :=
      potentialBase_endpoint_3 p
    rw [he3] at hint3
    linarith

/-- **Full characterization of H^1**: d₁ω = 0 iff ω is exact.
    Combined with `exact1_is_closed`, this gives H^1(Z^4) = 0. -/
theorem h1_trivial (ω : Discrete1Form) :
    IsClosed1 ω ↔ IsExact1 ω :=
  ⟨closed1_is_exact ω, exact1_is_closed ω⟩

/-! ## Toward H^2(Z^4) = 0: Cartan Homotopy Infrastructure

The Cartan contraction operator `cartanContract0 : Ω² → Ω¹` integrates a 2-form
along the x⁰-axis, producing a 1-form. This is the first step in the Cartan
homotopy formula for degree 2.

For a closed 2-form ω, the Cartan homotopy identity reads:
  d₁(cartanContract0 ω)(p, μ, ν) = ω(p, μ, ν) - π₀(ω)(p, μ, ν)
where π₀ is the "projection to x⁰ = 0" plus x⁰-invariant extension.

The full H^2(Z^4) = 0 theorem reduces by this identity plus induction on dimension
(H^2(Z^3) = 0 applied to the residue, and so on). This is the Cartan cascade.

Here we provide the infrastructure and prove the (0, ν)-component identity, which
depends only on discrete FTC + antisymmetry (not closedness).

Agent: Vega (April 14, 2026) -/

/-- Project a lattice point to have coordinate 0 in direction 0 (x⁰ = 0 hyperplane). -/
def projectAway0 (q : LatticePoint) : LatticePoint :=
  fun i => if i = 0 then 0 else q i

@[simp] theorem projectAway0_zero (q : LatticePoint) :
    projectAway0 q 0 = 0 := by simp [projectAway0]

theorem projectAway0_other (q : LatticePoint) (i : Fin 4) (hi : i ≠ 0) :
    projectAway0 q i = q i := by simp [projectAway0, hi]

/-- Shifting in direction 0 then projecting away direction 0: the shift is erased. -/
theorem projectAway0_shiftFin_0 (q : LatticePoint) :
    projectAway0 (shiftFin q 0) = projectAway0 q := by
  ext i
  simp [projectAway0, shiftFin]
  split_ifs with h <;> omega

/-- Shifting in direction μ ≠ 0 commutes with projectAway0. -/
theorem projectAway0_shiftFin_ne (q : LatticePoint) (μ : Fin 4) (hμ : μ ≠ 0) :
    projectAway0 (shiftFin q μ) = shiftFin (projectAway0 q) μ := by
  ext i
  simp [projectAway0, shiftFin]
  split_ifs with h1 h2 h2
  · omega
  · rfl
  · rfl
  · rfl

/-- shiftZ of projectAway0 in direction 0 by q^0 recovers q. -/
theorem shiftZ_projectAway0_coord0 (q : LatticePoint) :
    shiftZ (projectAway0 q) 0 (q 0) = q := by
  ext i
  simp [shiftZ, projectAway0]
  split_ifs with h
  · subst h; ring
  · ring

/-- **Cartan contraction along direction 0**: maps 2-forms to 1-forms.
    (h₀ ω)(q, ν) = integral of ω(·, 0, ν) along x⁰-axis from (0, q̂) to q
    where q̂ = projectAway0 q = (0, q^1, q^2, q^3). -/
noncomputable def cartanContract0 (ω : Discrete2Form) : Discrete1Form :=
  fun q ν => lineIntZ (fun p _ => ω p 0 ν) 0 (projectAway0 q) (q 0)

/-- For antisymmetric ω, the 0-component of the Cartan contraction vanishes. -/
theorem cartanContract0_zero_component (ω : Discrete2Form) (hanti : IsAntisymmetric2 ω)
    (q : LatticePoint) : cartanContract0 ω q 0 = 0 := by
  unfold cartanContract0
  -- lineIntZ of the constant zero function along any path is zero
  have hz : ∀ p : LatticePoint, ∀ μ : Fin 4, ω p 0 0 = 0 := fun p _ =>
    hanti.diag_zero p 0
  -- Rewrite the integrand to the zero function
  have hfn : (fun p (_ : Fin 4) => ω p 0 0) = fun _ _ => 0 := by
    funext p μ; exact hz p μ
  rw [hfn]
  -- Now lineIntZ of zero is zero
  cases h : q 0 with
  | ofNat n =>
    show lineIntFwd (fun _ _ => (0 : ℝ)) 0 (projectAway0 q) n = 0
    unfold lineIntFwd; simp
  | negSucc n =>
    show lineIntBwd (fun _ _ => (0 : ℝ)) 0 (projectAway0 q) n = 0
    unfold lineIntBwd; simp

/-- **Key discrete FTC step for Cartan contraction**: shifting q in direction 0
    adds one step to the line integral. -/
theorem cartanContract0_shift0 (ω : Discrete2Form)
    (p : LatticePoint) (ν : Fin 4) :
    cartanContract0 ω (shiftFin p 0) ν - cartanContract0 ω p ν =
    l_P * ω p 0 ν := by
  unfold cartanContract0
  -- (shiftFin p 0) 0 = p 0 + 1
  have hcoord : (shiftFin p 0) 0 = p 0 + 1 := by simp [shiftFin]
  -- projectAway0 (shiftFin p 0) = projectAway0 p
  rw [hcoord, projectAway0_shiftFin_0]
  -- Now LHS = lineIntZ _ 0 (projectAway0 p) (p 0 + 1) - lineIntZ _ 0 (projectAway0 p) (p 0)
  -- By lineIntZ_succ, this equals l_P * ω(shiftZ (projectAway0 p) 0 (p 0), 0, ν)
  --                              = l_P * ω(p, 0, ν)  [by shiftZ_projectAway0_coord0]
  rw [lineIntZ_succ]
  rw [shiftZ_projectAway0_coord0]
  ring

/-- **(0, ν)-component of the Cartan homotopy identity** (antisymmetric ω).

    For antisymmetric 2-form ω (not necessarily closed):
    (d₁ (cartanContract0 ω))(p, 0, ν) = ω(p, 0, ν).

    Proof: Δ⁺_0 of the contraction gives ω_{0, ν} by FTC.
    Δ⁺_ν of the 0-component vanishes since the 0-component is zero (antisymmetry).
    So the combined d₁ reduces to ω(p, 0, ν). -/
theorem cartanContract0_d1_component_0 (ω : Discrete2Form) (hanti : IsAntisymmetric2 ω)
    (p : LatticePoint) (ν : Fin 4) :
    d1 (cartanContract0 ω) p 0 ν = ω p 0 ν := by
  unfold d1
  -- LHS = forwardDiff (fun q => cartanContract0 ω q ν) 0 p
  --     - forwardDiff (fun q => cartanContract0 ω q 0) ν p
  -- Second term vanishes because cartanContract0 ω q 0 = 0 for all q
  have hzero : ∀ q, cartanContract0 ω q 0 = 0 :=
    cartanContract0_zero_component ω hanti
  have hzero' : (fun q => cartanContract0 ω q 0) = fun _ => 0 := funext hzero
  rw [hzero']
  -- forwardDiff of the zero function is zero
  have h2 : forwardDiff (fun _ : LatticePoint => (0 : ℝ)) ν p = 0 :=
    forwardDiff_const 0 ν p
  rw [h2]
  -- First term: forwardDiff (fun q => cartanContract0 ω q ν) 0 p = ω p 0 ν
  have h1 : forwardDiff (fun q => cartanContract0 ω q ν) 0 p = ω p 0 ν := by
    unfold forwardDiff
    rw [show cartanContract0 ω (shiftFin p 0) ν - cartanContract0 ω p ν =
        l_P * ω p 0 ν from cartanContract0_shift0 ω p ν]
    field_simp [l_P_ne_zero]
  rw [h1]; ring

/-! ## Closedness identity for 2-forms at index 0

The d₂ω = 0 identity at indices (0, μ, ν) relates three forward differences:
  Δ⁺_0 ω_{μν} - Δ⁺_μ ω_{0ν} + Δ⁺_ν ω_{0μ} = 0
Rearranging: Δ⁺_μ ω_{0ν} = Δ⁺_0 ω_{μν} + Δ⁺_ν ω_{0μ}.

This is the closedness consequence we use to prove the 2-form shift lemma. -/

/-- **d₂ω=0 identity** at indices (0, μ, ν): for closed ω,
    Δ⁺_μ ω(·, 0, ν) = Δ⁺_0 ω(·, μ, ν) + Δ⁺_ν ω(·, 0, μ). -/
theorem closed2_d2_identity_0 (ω : Discrete2Form) (hclosed : IsClosed2 ω)
    (μ ν : Fin 4) (q : LatticePoint) :
    forwardDiff (fun p => ω p 0 ν) μ q =
    forwardDiff (fun p => ω p μ ν) 0 q + forwardDiff (fun p => ω p 0 μ) ν q := by
  have h := hclosed q 0 μ ν
  unfold d2 at h
  linarith

/-- ShiftZ in direction 0 and shiftFin in direction μ ≠ 0 commute. -/
theorem shiftZ_shiftFin_comm_ne_0 (q : LatticePoint) (μ : Fin 4) (hμ : μ ≠ 0) (k : ℤ) :
    shiftZ (shiftFin q μ) 0 k = shiftFin (shiftZ q 0 k) μ := by
  ext i; simp [shiftZ, shiftFin]; split_ifs with h1 h2 <;> omega

/-! ## Key Shift Lemma for 2-Form Line Integrals

For closed ω and μ ≠ 0, shifting the base point of cartanContract0's line integral
in direction μ produces a difference that decomposes into:
  (a) An endpoint Δω(μν) telescoping contribution
  (b) A cross-term involving the line integral of ω(·, 0, μ) shifted in direction ν

This is the 2-form analog of `lineIntFwd_shift_closed`. -/

/-- Shift identity for lineIntFwd applied to the ω(·, 0, ν) slice. For closed
    antisymmetric ω and μ ≠ 0, the base-point shift of the line integral splits
    into a telescoping endpoint difference and a cross integral term. -/
theorem lineIntFwd_shift_2form_closed
    (ω : Discrete2Form) (hclosed : IsClosed2 ω)
    (μ ν : Fin 4) (hμ : μ ≠ 0) (base : LatticePoint) (n : ℕ) :
    lineIntFwd (fun p' _ => ω p' 0 ν) 0 (shiftFin base μ) n -
    lineIntFwd (fun p' _ => ω p' 0 ν) 0 base n =
    l_P * (ω (shiftZ base 0 (n : ℤ)) μ ν - ω base μ ν) +
    (lineIntFwd (fun p' _ => ω p' 0 μ) 0 (shiftFin base ν) n -
     lineIntFwd (fun p' _ => ω p' 0 μ) 0 base n) := by
  induction n with
  | zero =>
    simp [lineIntFwd]
  | succ k ih =>
    rw [lineIntFwd_succ, lineIntFwd_succ, lineIntFwd_succ, lineIntFwd_succ]
    -- Key per-step identity (derived from d₂ ω = 0):
    -- ω(shiftFin q μ, 0, ν) - ω(q, 0, ν) = (ω(shiftFin q 0, μ, ν) - ω(q, μ, ν)) + (ω(shiftFin q ν, 0, μ) - ω(q, 0, μ))
    -- at q = shiftZ base 0 k. Using commutativity of shifts, this translates directly
    -- to the per-step increment we need.
    have hcomm_μ : shiftZ (shiftFin base μ) 0 (k : ℤ) =
        shiftFin (shiftZ base 0 (k : ℤ)) μ := shiftZ_shiftFin_comm_ne_0 base μ hμ k
    have hcomm_ν : shiftFin (shiftZ base 0 (k : ℤ)) ν =
        shiftZ (shiftFin base ν) 0 (k : ℤ) := by
      rcases Decidable.em (ν = 0) with hν | hν
      · subst hν
        ext i; simp [shiftFin, shiftZ]; split_ifs with h <;> ring
      · exact (shiftZ_shiftFin_comm_ne_0 base ν hν k).symm
    have hsucc_0 : shiftFin (shiftZ base 0 (k : ℤ)) 0 = shiftZ base 0 ((k : ℤ) + 1) := by
      ext i; simp [shiftFin, shiftZ]; split_ifs with h <;> ring
    -- d₂ ω = 0 at indices (0, μ, ν): Δ⁺_μ ω_{0ν} - Δ⁺_0 ω_{μν} + Δ⁺_ν ω_{0μ} = 0
    -- Wait, let me recheck the sign. Actually hclosed gives
    -- d2 ω p 0 μ ν = Δ⁺_0 ω_{μν} - Δ⁺_μ ω_{0ν} + Δ⁺_ν ω_{0μ} = 0
    -- So Δ⁺_μ ω_{0ν} = Δ⁺_0 ω_{μν} + Δ⁺_ν ω_{0μ}
    have hclosed_eq := closed2_d2_identity_0 ω hclosed μ ν (shiftZ base 0 (k : ℤ))
    -- Translate hclosed_eq to the (shifted, unshifted) form, multiplying by l_P²:
    -- ω(shiftFin q μ, 0, ν) - ω(q, 0, ν) = (ω(shiftFin q 0, μ, ν) - ω(q, μ, ν)) + (ω(shiftFin q ν, 0, μ) - ω(q, 0, μ))
    have hstep_eq : ω (shiftFin (shiftZ base 0 (k : ℤ)) μ) 0 ν -
        ω (shiftZ base 0 (k : ℤ)) 0 ν =
        (ω (shiftFin (shiftZ base 0 (k : ℤ)) 0) μ ν - ω (shiftZ base 0 (k : ℤ)) μ ν) +
        (ω (shiftFin (shiftZ base 0 (k : ℤ)) ν) 0 μ - ω (shiftZ base 0 (k : ℤ)) 0 μ) := by
      -- forwardDiff f μ q = (f(shiftFin q μ) - f(q)) / l_P
      -- So hclosed_eq (dividing by l_P) gives exactly what we need
      have := hclosed_eq
      unfold forwardDiff at this
      -- (a - b) / l_P = c / l_P + d / l_P  iff  (a - b) = c + d  (using l_P ≠ 0)
      have hlp : l_P ≠ 0 := l_P_ne_zero
      field_simp [hlp] at this
      linarith
    -- Now apply the commutativity rewrites to hstep_eq
    rw [hcomm_μ] at *
    -- Replace shiftFin q 0 and shiftFin q ν in hstep_eq
    rw [hsucc_0, hcomm_ν] at hstep_eq
    -- Multiply hstep_eq by l_P to match the form of terms in the goal
    have hstep_eq_lP : l_P * ω (shiftFin (shiftZ base 0 (k : ℤ)) μ) 0 ν -
        l_P * ω (shiftZ base 0 (k : ℤ)) 0 ν =
        l_P * (ω (shiftZ base 0 ((k : ℤ) + 1)) μ ν - ω (shiftZ base 0 (k : ℤ)) μ ν) +
        l_P * (ω (shiftZ (shiftFin base ν) 0 (k : ℤ)) 0 μ -
               ω (shiftZ base 0 (k : ℤ)) 0 μ) := by
      linear_combination l_P * hstep_eq
    -- And the target uses `↑(k+1)` which should equal `↑k + 1` as ℤ
    have coerce : (↑(k + 1) : ℤ) = (↑k : ℤ) + 1 := by push_cast; ring
    rw [coerce]
    linarith

/-! ## Extension to ℤ-Indexed Line Integrals -/

/-- **The ℤ-indexed shift identity for 2-form line integrals.**
    Same as `lineIntFwd_shift_2form_closed` but for arbitrary ℤ shifts,
    handling both the non-negative (lineIntFwd) and negative (lineIntBwd) cases. -/
theorem lineIntZ_shift_2form_closed
    (ω : Discrete2Form) (hclosed : IsClosed2 ω)
    (μ ν : Fin 4) (hμ : μ ≠ 0) (base : LatticePoint) (k : ℤ) :
    lineIntZ (fun p' _ => ω p' 0 ν) 0 (shiftFin base μ) k -
    lineIntZ (fun p' _ => ω p' 0 ν) 0 base k =
    l_P * (ω (shiftZ base 0 k) μ ν - ω base μ ν) +
    (lineIntZ (fun p' _ => ω p' 0 μ) 0 (shiftFin base ν) k -
     lineIntZ (fun p' _ => ω p' 0 μ) 0 base k) := by
  -- Helper: shifts in dir 0 commute with shift in dir μ (for μ ≠ 0)
  have shiftcomm_μ : ∀ j : ℤ, shiftZ (shiftFin base μ) 0 j = shiftFin (shiftZ base 0 j) μ :=
    fun j => shiftZ_shiftFin_comm_ne_0 base μ hμ j
  -- Helper: shifts in dir 0 commute with shift in dir ν (any ν)
  have shiftcomm_ν : ∀ j : ℤ, shiftFin (shiftZ base 0 j) ν = shiftZ (shiftFin base ν) 0 j := by
    intro j
    rcases Decidable.em (ν = 0) with hν | hν
    · subst hν; ext i; simp [shiftFin, shiftZ]; split_ifs with h <;> ring
    · exact (shiftZ_shiftFin_comm_ne_0 base ν hν j).symm
  -- Helper: shiftFin in dir 0 of shiftZ base 0 j = shiftZ base 0 (j+1)
  have shiftFin_succ_0 : ∀ j : ℤ, shiftFin (shiftZ base 0 j) 0 = shiftZ base 0 (j + 1) := by
    intro j; ext i; simp [shiftFin, shiftZ]; split_ifs with h <;> ring
  -- Per-step closedness identity (multiplied by l_P): the d_2 ω = 0 derivation
  have step_eq_lP : ∀ j : ℤ,
      l_P * ω (shiftFin (shiftZ base 0 j) μ) 0 ν -
      l_P * ω (shiftZ base 0 j) 0 ν =
      l_P * (ω (shiftZ base 0 (j + 1)) μ ν - ω (shiftZ base 0 j) μ ν) +
      l_P * (ω (shiftZ (shiftFin base ν) 0 j) 0 μ -
             ω (shiftZ base 0 j) 0 μ) := by
    intro j
    have hclosed_eq := closed2_d2_identity_0 ω hclosed μ ν (shiftZ base 0 j)
    have hlp : l_P ≠ 0 := l_P_ne_zero
    have hstep_eq : ω (shiftFin (shiftZ base 0 j) μ) 0 ν -
        ω (shiftZ base 0 j) 0 ν =
        (ω (shiftFin (shiftZ base 0 j) 0) μ ν - ω (shiftZ base 0 j) μ ν) +
        (ω (shiftFin (shiftZ base 0 j) ν) 0 μ - ω (shiftZ base 0 j) 0 μ) := by
      have := hclosed_eq
      unfold forwardDiff at this
      field_simp [hlp] at this
      linarith
    rw [shiftFin_succ_0 j, shiftcomm_ν j] at hstep_eq
    linear_combination l_P * hstep_eq
  cases k with
  | ofNat n => exact lineIntFwd_shift_2form_closed ω hclosed μ ν hμ base n
  | negSucc n =>
    induction n with
    | zero =>
      -- k = -1
      have hs := lineIntZ_pred (fun p' _ => ω p' 0 ν) 0 (shiftFin base μ) 0
      have ho := lineIntZ_pred (fun p' _ => ω p' 0 ν) 0 base 0
      have hsm := lineIntZ_pred (fun p' _ => ω p' 0 μ) 0 (shiftFin base ν) 0
      have hom := lineIntZ_pred (fun p' _ => ω p' 0 μ) 0 base 0
      simp only [lineIntZ_zero] at hs ho hsm hom
      have h01 : (0 : ℤ) - 1 = Int.negSucc 0 := by omega
      rw [h01] at hs ho hsm hom
      rw [hs, ho, hsm, hom]
      rw [shiftcomm_μ (Int.negSucc 0)]
      -- Use step_eq_lP at j = Int.negSucc 0
      have hstep := step_eq_lP (Int.negSucc 0)
      rw [show Int.negSucc 0 + 1 = (0 : ℤ) from by omega, shiftZ_zero] at hstep
      -- hstep relates the values at shiftZ base 0 (negSucc 0) to those at base
      linarith
    | succ m ih =>
      -- k = Int.negSucc (m+1) = Int.negSucc m - 1
      have hs := lineIntZ_pred (fun p' _ => ω p' 0 ν) 0 (shiftFin base μ) (Int.negSucc m)
      have ho := lineIntZ_pred (fun p' _ => ω p' 0 ν) 0 base (Int.negSucc m)
      have hsm := lineIntZ_pred (fun p' _ => ω p' 0 μ) 0 (shiftFin base ν) (Int.negSucc m)
      have hom := lineIntZ_pred (fun p' _ => ω p' 0 μ) 0 base (Int.negSucc m)
      have hk : Int.negSucc m - 1 = Int.negSucc (m + 1) := by omega
      rw [hk] at hs ho hsm hom
      rw [hs, ho, hsm, hom]
      rw [shiftcomm_μ (Int.negSucc (m + 1))]
      -- Use step_eq_lP at j = Int.negSucc (m + 1)
      have hstep := step_eq_lP (Int.negSucc (m + 1))
      rw [show Int.negSucc (m + 1) + 1 = Int.negSucc m from by omega] at hstep
      linarith

/-! ## Cartan Homotopy Identity for μ, ν ≠ 0 Case

For μ ≠ 0 AND ν ≠ 0, the cartanContract0 shift identity reduces to the
Cartan homotopy formula via the closedness consequence at (0, μ, ν) indices. -/

/-- **Shift identity for cartanContract0** when both μ, ν ≠ 0. -/
theorem cartanContract0_shift_mu_nu_nonzero (ω : Discrete2Form) (hclosed : IsClosed2 ω)
    (μ ν : Fin 4) (hμ : μ ≠ 0) (hν : ν ≠ 0) (p : LatticePoint) :
    cartanContract0 ω (shiftFin p μ) ν - cartanContract0 ω p ν =
    l_P * (ω p μ ν - ω (projectAway0 p) μ ν) +
    (cartanContract0 ω (shiftFin p ν) μ - cartanContract0 ω p μ) := by
  unfold cartanContract0
  -- (shiftFin p μ) 0 = p 0  (since μ ≠ 0)
  have hcoord_μ : (shiftFin p μ) 0 = p 0 := by
    simp only [shiftFin]
    by_cases h : (0 : Fin 4) = μ
    · exact absurd h.symm hμ
    · simp [h]
  have hcoord_ν : (shiftFin p ν) 0 = p 0 := by
    simp only [shiftFin]
    by_cases h : (0 : Fin 4) = ν
    · exact absurd h.symm hν
    · simp [h]
  rw [hcoord_μ, hcoord_ν, projectAway0_shiftFin_ne p μ hμ, projectAway0_shiftFin_ne p ν hν]
  -- Apply lineIntZ_shift_2form_closed at base = projectAway0 p, k = p 0
  have h := lineIntZ_shift_2form_closed ω hclosed μ ν hμ (projectAway0 p) (p 0)
  rw [shiftZ_projectAway0_coord0 p] at h
  exact h

/-- **Cartan homotopy identity at (μ, ν) with μ, ν ≠ 0**: for closed antisymmetric ω,
    d₁(cartanContract0 ω)(p, μ, ν) = ω(p, μ, ν) - ω(projectAway0 p, μ, ν). -/
theorem cartanContract0_d1_component_mu_nu_nonzero
    (ω : Discrete2Form) (hclosed : IsClosed2 ω) (hanti : IsAntisymmetric2 ω)
    (p : LatticePoint) (μ ν : Fin 4) (hμ : μ ≠ 0) (hν : ν ≠ 0) :
    d1 (cartanContract0 ω) p μ ν =
    ω p μ ν - ω (projectAway0 p) μ ν := by
  unfold d1
  unfold forwardDiff
  -- The shift identity (when both μ, ν ≠ 0):
  -- cartanContract0 ω (shiftFin p μ) ν - cartanContract0 ω p ν =
  --   l_P · (ω p μ ν - ω (projectAway0 p) μ ν) +
  --   (cartanContract0 ω (shiftFin p ν) μ - cartanContract0 ω p μ)
  have h := cartanContract0_shift_mu_nu_nonzero ω hclosed μ ν hμ hν p
  have hlp : l_P ≠ 0 := l_P_ne_zero
  field_simp [hlp]
  linarith

/-! ## Full Cartan Homotopy Identity Statement -/

/-- **Full Cartan homotopy identity for direction 0**: for closed antisymmetric ω,

      d₁(cartanContract0 ω)(p, μ, ν) = ω(p, μ, ν) - residue(p, μ, ν)

    where residue(p, μ, ν) = 0 if μ = 0 ∨ ν = 0, else ω(projectAway0 p, μ, ν).

    This is the discrete Cartan homotopy formula at degree 2 in direction 0.
    The residue is the 2-form ω restricted to the x⁰=0 hyperplane (extended
    x⁰-invariantly), which is itself closed (by d² ∘ d¹ = 0) and lives on Z³. -/
theorem cartanContract0_d1_identity
    (ω : Discrete2Form) (hclosed : IsClosed2 ω) (hanti : IsAntisymmetric2 ω)
    (p : LatticePoint) (μ ν : Fin 4) :
    d1 (cartanContract0 ω) p μ ν =
    ω p μ ν - (if μ = 0 ∨ ν = 0 then 0 else ω (projectAway0 p) μ ν) := by
  rcases Decidable.em (μ = 0) with hμ | hμ
  · subst hμ
    rw [if_pos (Or.inl rfl)]
    rw [cartanContract0_d1_component_0 ω hanti p ν]
    ring
  · rcases Decidable.em (ν = 0) with hν | hν
    · subst hν
      rw [if_pos (Or.inr rfl)]
      -- For ν = 0, μ ≠ 0: use d₁ antisymmetry
      have hd1_anti : d1 (cartanContract0 ω) p μ 0 = -d1 (cartanContract0 ω) p 0 μ := by
        have := d1_antisymmetric (cartanContract0 ω) p μ 0
        linarith
      rw [hd1_anti, cartanContract0_d1_component_0 ω hanti p μ, hanti p μ 0]
      ring
    · rw [if_neg (by tauto : ¬ (μ = 0 ∨ ν = 0))]
      exact cartanContract0_d1_component_mu_nu_nonzero ω hclosed hanti p μ ν hμ hν

/-! ## H^2(Z^4) = 0 for 2-Forms Vanishing on x⁰=0 Hyperplane

For a closed antisymmetric 2-form ω that vanishes on the x⁰=0 hyperplane
(i.e., ω(projectAway0 p, μ, ν) = 0 for all p, μ, ν), the residue in the
Cartan identity vanishes, so ω = d₁(cartanContract0 ω) is exact.

This is a partial H^2(Z^4) = 0 result for a meaningful subclass.
The full H^2(Z^4) = 0 requires iterating the Cartan contraction in all
4 directions (cascade: Z⁴ → Z³ → Z² → trivial). -/

/-- **Vanishing on x⁰=0 hyperplane** predicate for 2-forms. -/
def VanishesOnX0Hyperplane (ω : Discrete2Form) : Prop :=
  ∀ p μ ν, ω (projectAway0 p) μ ν = 0

/-- **Partial H²(Z⁴) = 0**: every closed antisymmetric 2-form vanishing on the
    x⁰=0 hyperplane is exact, with potential given by `cartanContract0 ω`.

    This is the first step of the discrete Cartan cascade for H². The full
    H²(Z⁴) = 0 reduces to H²(Z³) = 0 applied to the Cartan residue. -/
theorem closed2_vanishing_hyperplane_is_exact
    (ω : Discrete2Form) (hclosed : IsClosed2 ω) (hanti : IsAntisymmetric2 ω)
    (hvanish : VanishesOnX0Hyperplane ω) :
    IsExact2 ω := by
  use cartanContract0 ω
  ext p μ ν
  rw [cartanContract0_d1_identity ω hclosed hanti p μ ν]
  -- The residue vanishes by hypothesis
  split_ifs with h
  · ring
  · rw [hvanish p μ ν]; ring

end OmegaTheory.Geometry
