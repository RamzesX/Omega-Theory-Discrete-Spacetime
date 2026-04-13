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

end OmegaTheory.Geometry
