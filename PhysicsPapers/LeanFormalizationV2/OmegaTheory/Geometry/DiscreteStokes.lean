/-
  OmegaTheory.Geometry.DiscreteStokes

  Discrete Stokes' theorem on the Planck lattice: the fundamental theorem
  of calculus for the discrete exterior derivative.

  The core result: summing d₀(f) along a lattice path from point a to
  point b gives f(b) - f(a). This is the discrete analogue of
  ∫_a^b df = f(b) - f(a), and the simplest instance of the general
  discrete Stokes' theorem ∫_M dω = ∫_{∂M} ω.

  Key results:
  1. `shiftN` — walk n steps along direction μ from a lattice point
  2. `discrete_FTC` — discrete fundamental theorem of calculus (telescoping)
  3. `discrete_stokes_d0` — Stokes for d₀: path integral of d₀f = endpoint difference

  Agent: Lyra (April 13, 2026)
-/

import OmegaTheory.Geometry.DiscreteForms
import Mathlib.Tactic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime Finset

/-! ## Iterated Lattice Shift

  Walking n steps in direction μ from a lattice point p. -/

/-- Walk n steps in direction μ from lattice point p. -/
def shiftN (p : LatticePoint) (μ : Fin 4) : ℕ → LatticePoint
  | 0 => p
  | n + 1 => shiftFin (shiftN p μ n) μ

@[simp] theorem shiftN_zero (p : LatticePoint) (μ : Fin 4) :
    shiftN p μ 0 = p := rfl

@[simp] theorem shiftN_succ (p : LatticePoint) (μ : Fin 4) (n : ℕ) :
    shiftN p μ (n + 1) = shiftFin (shiftN p μ n) μ := rfl

theorem shiftN_one (p : LatticePoint) (μ : Fin 4) :
    shiftN p μ 1 = shiftFin p μ := rfl

/-- shiftN adds n to the μ-th coordinate. -/
theorem shiftN_coord (p : LatticePoint) (μ : Fin 4) (n : ℕ) (i : Fin 4) :
    shiftN p μ n i = p i + if i = μ then (n : ℤ) else 0 := by
  induction n with
  | zero => simp
  | succ k ih =>
    simp only [shiftN_succ, shiftFin, ih]
    split_ifs with h <;> push_cast <;> ring

/-! ## Discrete Fundamental Theorem of Calculus

  The discrete FTC: summing the forward difference of f along a path
  gives f(endpoint) - f(startpoint). This is a telescoping sum. -/

/-- **Discrete Fundamental Theorem of Calculus** (telescoping sum):
    Σ_{k=0}^{n-1} Δ⁺_μ f(p + k·ê_μ) = (f(p + n·ê_μ) - f(p)) / l_P.

    This is the discrete analogue of ∫_a^b f'(x)dx = f(b) - f(a). -/
theorem discrete_FTC (f : ScalarField) (μ : Fin 4) (p : LatticePoint) (n : ℕ) :
    (Finset.range n).sum (fun k => forwardDiff f μ (shiftN p μ k)) =
    (f (shiftN p μ n) - f p) / l_P := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, ih, shiftN_succ]
    unfold forwardDiff
    field_simp [l_P_ne_zero]; ring

/-- Discrete Stokes for d₀: the path integral of d₀f equals the boundary evaluation.
    This is the d₀ version using the DEC notation. -/
theorem discrete_stokes_d0 (f : Discrete0Form) (μ : Fin 4) (p : LatticePoint) (n : ℕ) :
    (Finset.range n).sum (fun k => d0 f (shiftN p μ k) μ) =
    (f (shiftN p μ n) - f p) / l_P :=
  discrete_FTC f μ p n

/-- The l_P-scaled version: l_P times the path sum equals f(end) - f(start).
    This is the most natural form of the discrete fundamental theorem. -/
theorem discrete_FTC_scaled (f : ScalarField) (μ : Fin 4) (p : LatticePoint) (n : ℕ) :
    l_P * (Finset.range n).sum (fun k => forwardDiff f μ (shiftN p μ k)) =
    f (shiftN p μ n) - f p := by
  rw [discrete_FTC]
  field_simp [l_P_ne_zero]

/-- For n = 1, the FTC reduces to the definition of forwardDiff. -/
theorem discrete_FTC_one (f : ScalarField) (μ : Fin 4) (p : LatticePoint) :
    forwardDiff f μ p = (f (shiftFin p μ) - f p) / l_P := by
  rfl

/-- Concatenation: the FTC for paths a→b and b→c gives a→c. -/
theorem discrete_FTC_concat (f : ScalarField) (μ : Fin 4) (p : LatticePoint) (m n : ℕ) :
    (Finset.range (m + n)).sum (fun k => forwardDiff f μ (shiftN p μ k)) =
    (f (shiftN p μ (m + n)) - f p) / l_P :=
  discrete_FTC f μ p (m + n)

/-- If f is constant, the path integral vanishes. -/
theorem discrete_FTC_const (c : ℝ) (μ : Fin 4) (p : LatticePoint) (n : ℕ) :
    (Finset.range n).sum (fun k => forwardDiff (fun _ => c) μ (shiftN p μ k)) = 0 := by
  simp [forwardDiff_const]

end OmegaTheory.Geometry
