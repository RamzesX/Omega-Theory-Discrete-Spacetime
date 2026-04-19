/-
  OmegaTheory.Emergence.SU3JacobiIdentity

  Closes the **full SU(3) Jacobi identity** for arbitrary Lie-algebra
  elements `X, Y, Z : SU3LieAlgebra = Fin 8 → ℝ`:

      [[X, Y], Z] + [[Y, Z], X] + [[Z, X], Y] = 0.

  Prior agents (Kornephoros, Almach², Mizar²) delivered the numerical
  heart of the argument — the structure-constant Jacobi identity
  `su3f_jacobi_sum_zero` over ℝ via a ℚ + √3 decomposition closed by
  `native_decide` on 4096 rational cases. This file supplies the
  missing **trilinearity lift** from the summand-level identity to
  arbitrary Lie-algebra elements without introducing any new axioms
  or `sorry` obligations.

  Strategy: for each of the three cyclic terms `[[·, ·], ·] k`,
  rewrite the outer and inner `su3Bracket` definitions and then
  commute the finite sums so that `X(a)·Y(b)·Z(c)` are the
  outermost factors. The cyclic shift `(X,Y,Z) → (Y,Z,X)` in the
  second term and `(X,Y,Z) → (Z,X,Y)` in the third term is carried
  out by explicit reindexing of the summation variables. Adding
  the three quadruple sums yields a fourfold sum whose summand at
  fixed `(a,b,c)` factors as `X(a)·Y(b)·Z(c)` times the
  summand-level Jacobi polynomial of `su3f_jacobi_sum_zero`,
  which therefore vanishes.

  Deliverables:

    · `su3Bracket_right_linear`           — companion of
                                            `su3Bracket_left_linear`.
    · `sum_basis_expansion`               — `X = ∑_a X(a)·e_a`.
    · `bracket_bracket_expand_X`          — explicit fourfold-sum
                                            form for `[[X,Y],Z] k`.
    · `bracket_bracket_expand_Y`          — same for `[[Y,Z],X] k`.
    · `bracket_bracket_expand_Z`          — same for `[[Z,X],Y] k`.
    · `su3Bracket_jacobi_full_pointwise`  — pointwise Jacobi on
                                            arbitrary X, Y, Z.
    · `su3Bracket_jacobi_full`            — **unconditional Jacobi
                                            identity** at the
                                            `SU3LieAlgebra` level.
    · `mkExactSU3LieAlgebra_unconditional` — witness-free constructor
                                            of the exact SU(3) Lie
                                            algebra.
    · `errorGaugeSU3_lieBracket_jacobi`    — project-level alias
                                            named per the mission
                                            brief.

  Combined with the already-existing `su3Bracket_antisymmetric_pi`
  and `su3Bracket_smul_linear`, this completes the algebraic closure
  of the SU(3) colour-gauge Lie algebra underlying QCD.

  Agent: Bellatrix (γ Orionis, "Warrior Star"), April 19, 2026.
  No `sorry`, no new axioms.
-/

import OmegaTheory.Emergence.ErrorGaugeSU3
import OmegaTheory.Emergence.SU3JacobiHelper
import OmegaTheory.Emergence.SU3JacobiFull
import Mathlib.Tactic

namespace OmegaTheory.Emergence.SU3JacobiIdentity

open OmegaTheory.Emergence.ErrorGaugeSU3
open OmegaTheory.Emergence.SU3JacobiFull
open OmegaTheory.Foundations

/-! ## §1. Right linearity of `su3Bracket`

The companion of the already-established `su3Bracket_left_linear`.
Direct unfolding + ring; the structure constant is passive. -/

/-- Bracket linearity in the SECOND argument (pointwise). -/
theorem su3Bracket_right_linear
    (a b : ℝ) (X Y₁ Y₂ : SU3LieAlgebra) (k : Fin 8) :
    su3Bracket X (fun j => a * Y₁ j + b * Y₂ j) k =
    a * su3Bracket X Y₁ k + b * su3Bracket X Y₂ k := by
  simp only [su3Bracket, ← Finset.sum_add_distrib, Finset.mul_sum]
  congr 1; ext i; congr 1; ext j; ring

/-! ## §2. Basis expansion of arbitrary Lie-algebra elements -/

/-- Any `X : SU3LieAlgebra` decomposes on the standard basis:
    pointwise at index `i`, `(∑ a, X(a) · e_a(i)) = X(i)`. -/
theorem sum_basis_expansion (X : SU3LieAlgebra) (i : Fin 8) :
    (∑ a : Fin 8, X a * su3Basis a i) = X i := by
  rw [Finset.sum_eq_single i]
  · unfold su3Basis; simp
  · intros a _ hai
    unfold su3Basis
    rw [if_neg (fun h => hai (by rw [h]))]
    ring
  · intro h; exact absurd (Finset.mem_univ i) h

/-! ## §3. Quadruple-sum expansion of `[[·, ·], ·] k`

For each of the three cyclic Jacobi terms, we unfold both levels
of `su3Bracket` into a fourfold finite sum with the `(X,Y,Z)`
monomials at fixed positions and the order `(a,b,c,m)`. The
summand order for each of the three cyclic terms differs only in
which `su3f` factors point at which of `(a, b, c)`. -/

/-- **Term 1**. Explicit form of `[[X, Y], Z] k` as
    `∑_{a,b,c,m} f(a,b,m) · f(m,c,k) · X(a)·Y(b)·Z(c)`. -/
theorem bracket_bracket_expand_X
    (X Y Z : SU3LieAlgebra) (k : Fin 8) :
    su3Bracket (su3Bracket X Y) Z k =
    ∑ a : Fin 8, ∑ b : Fin 8, ∑ c : Fin 8, ∑ m : Fin 8,
      su3f a b m * su3f m c k * X a * Y b * Z c := by
  -- Start from the DEFINITION of the outer bracket with the INNER
  -- already expanded. Aiming for the form used downstream, we
  -- manipulate the quadruple sum to the target (a,b,c,m) order.
  show (∑ m : Fin 8, ∑ c : Fin 8, su3f m c k *
          (∑ a : Fin 8, ∑ b : Fin 8, su3f a b m * X a * Y b) * Z c) = _
  -- First: ∑_m ∑_c (∑_a ∑_b su3f a b m · X a · Y b) · (su3f m c k · Z c)
  --      = ∑_m ∑_c ∑_a ∑_b  su3f a b m · X a · Y b · su3f m c k · Z c
  -- using Finset.sum_mul / Finset.mul_sum carefully; then reorder.
  have step1 :
      (∑ m : Fin 8, ∑ c : Fin 8, su3f m c k *
        (∑ a : Fin 8, ∑ b : Fin 8, su3f a b m * X a * Y b) * Z c) =
      ∑ m : Fin 8, ∑ c : Fin 8, ∑ a : Fin 8, ∑ b : Fin 8,
        su3f a b m * su3f m c k * X a * Y b * Z c := by
    apply Finset.sum_congr rfl; intros m _
    apply Finset.sum_congr rfl; intros c _
    -- Goal: su3f m c k · (∑_a ∑_b …) · Z c = ∑_a ∑_b …
    -- Rewrite LHS: (A · S · C) → S · (A · C) → ∑_a (inner · (A·C))
    rw [show su3f m c k * (∑ a : Fin 8, ∑ b : Fin 8,
              su3f a b m * X a * Y b) * Z c =
        (∑ a : Fin 8, ∑ b : Fin 8, su3f a b m * X a * Y b) *
          (su3f m c k * Z c) from by ring]
    rw [Finset.sum_mul]
    apply Finset.sum_congr rfl; intros a _
    rw [Finset.sum_mul]
    apply Finset.sum_congr rfl; intros b _
    ring
  rw [step1]
  -- Reorder ∑_m ∑_c ∑_a ∑_b  →  ∑_a ∑_b ∑_c ∑_m.
  -- Step A: swap outer pair (m, c) → (c, m).
  rw [Finset.sum_comm]
  -- Current: ∑_c ∑_m ∑_a ∑_b …
  -- Step B: inner-most reindex c-before-m with a-before-b.
  -- We'll do it via nested congruence.
  -- First, under ∑_c, swap (m, a): ∑_c ∑_a ∑_m ∑_b …
  rw [show (∑ c : Fin 8, ∑ m : Fin 8, ∑ a : Fin 8, ∑ b : Fin 8,
              su3f a b m * su3f m c k * X a * Y b * Z c) =
      (∑ c : Fin 8, ∑ a : Fin 8, ∑ m : Fin 8, ∑ b : Fin 8,
              su3f a b m * su3f m c k * X a * Y b * Z c) from by
    apply Finset.sum_congr rfl; intros c _; exact Finset.sum_comm]
  -- Now swap outer (c, a): ∑_a ∑_c ∑_m ∑_b …
  rw [Finset.sum_comm]
  -- Under ∑_a, swap (c, m): ∑_a ∑_m ∑_c ∑_b …
  -- WAIT — we want ∑_a ∑_b ∑_c ∑_m, so we don't want to swap (c,m)
  -- outward. Instead, under ∑_a swap (m, b): ∑_a ∑_c ∑_b ∑_m …
  apply Finset.sum_congr rfl; intros a _
  -- Goal: ∑_c ∑_m ∑_b … = ∑_b ∑_c ∑_m …
  -- Under ∑_c, swap (m, b): ∑_c ∑_b ∑_m …
  rw [show (∑ c : Fin 8, ∑ m : Fin 8, ∑ b : Fin 8,
              su3f a b m * su3f m c k * X a * Y b * Z c) =
      (∑ c : Fin 8, ∑ b : Fin 8, ∑ m : Fin 8,
              su3f a b m * su3f m c k * X a * Y b * Z c) from by
    apply Finset.sum_congr rfl; intros c _; exact Finset.sum_comm]
  -- Now swap outer (c, b): ∑_b ∑_c ∑_m …
  rw [Finset.sum_comm]

/-- **Term 2**. Explicit form of `[[Y, Z], X] k` as
    `∑_{a,b,c,m} f(b,c,m) · f(m,a,k) · X(a)·Y(b)·Z(c)`. -/
theorem bracket_bracket_expand_Y
    (X Y Z : SU3LieAlgebra) (k : Fin 8) :
    su3Bracket (su3Bracket Y Z) X k =
    ∑ a : Fin 8, ∑ b : Fin 8, ∑ c : Fin 8, ∑ m : Fin 8,
      su3f b c m * su3f m a k * X a * Y b * Z c := by
  -- Apply Term 1 with (X, Y, Z) = (Y, Z, X):
  --   [[Y,Z],X] k = ∑ p ∑ q ∑ r ∑ m, f(p,q,m)·f(m,r,k)·Y(p)·Z(q)·X(r)
  -- where under the renaming (p, q, r) = (b, c, a) the summand is
  --   f(b,c,m)·f(m,a,k)·Y(b)·Z(c)·X(a)  =  f(b,c,m)·f(m,a,k)·X(a)·Y(b)·Z(c)
  -- and we must reorder (p, q, r) from outer (Y, Z, X)-style to the
  -- standardised outer order (a, b, c).
  rw [bracket_bracket_expand_X Y Z X k]
  -- Move r (corresponds to a) outermost by swapping past q then p.
  rw [show (∑ p : Fin 8, ∑ q : Fin 8, ∑ r : Fin 8, ∑ m : Fin 8,
              su3f p q m * su3f m r k * Y p * Z q * X r) =
      (∑ p : Fin 8, ∑ r : Fin 8, ∑ q : Fin 8, ∑ m : Fin 8,
              su3f p q m * su3f m r k * Y p * Z q * X r) from by
    apply Finset.sum_congr rfl; intros p _; exact Finset.sum_comm]
  rw [Finset.sum_comm]
  -- Now ∑_r ∑_p ∑_q ∑_m. Under (r, p, q) → (a, b, c), summand
  -- f(p,q,m)·f(m,r,k)·Y(p)·Z(q)·X(r) = f(b,c,m)·f(m,a,k)·Y(b)·Z(c)·X(a).
  apply Finset.sum_congr rfl; intros a _
  apply Finset.sum_congr rfl; intros b _
  apply Finset.sum_congr rfl; intros c _
  apply Finset.sum_congr rfl; intros m _
  ring

/-- **Term 3**. Explicit form of `[[Z, X], Y] k` as
    `∑_{a,b,c,m} f(c,a,m) · f(m,b,k) · X(a)·Y(b)·Z(c)`. -/
theorem bracket_bracket_expand_Z
    (X Y Z : SU3LieAlgebra) (k : Fin 8) :
    su3Bracket (su3Bracket Z X) Y k =
    ∑ a : Fin 8, ∑ b : Fin 8, ∑ c : Fin 8, ∑ m : Fin 8,
      su3f c a m * su3f m b k * X a * Y b * Z c := by
  rw [bracket_bracket_expand_X Z X Y k]
  -- Under (p, q, r) = (c, a, b), the summand is
  -- f(c,a,m)·f(m,b,k)·Z(c)·X(a)·Y(b)  =  f(c,a,m)·f(m,b,k)·X(a)·Y(b)·Z(c).
  -- Move q (=a) past p (=c) then r (=b) past p to land on (a, b, c, m).
  rw [Finset.sum_comm]
  -- Current: ∑_q ∑_p ∑_r ∑_m.
  -- Under ∑_q (=a), swap (p, r) so r (=b) comes before p (=c):
  apply Finset.sum_congr rfl; intros a _
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl; intros b _
  apply Finset.sum_congr rfl; intros c _
  apply Finset.sum_congr rfl; intros m _
  ring

/-! ## §4. The structural Jacobi sum, pulled across X·Y·Z monomials -/

-- 4-fold finite sum, distributed over three cyclic Jacobi terms,
-- each of which expands to a quadruple sum; `ring` normalises at
-- every leaf.
set_option maxHeartbeats 2000000 in
/-- **SU(3) Jacobi identity — pointwise form.**
    For arbitrary `X, Y, Z : SU3LieAlgebra` and every `k : Fin 8`,
    `[[X,Y],Z] k + [[Y,Z],X] k + [[Z,X],Y] k = 0`. -/
theorem su3Bracket_jacobi_full_pointwise
    (X Y Z : SU3LieAlgebra) (k : Fin 8) :
    su3Bracket (su3Bracket X Y) Z k +
    su3Bracket (su3Bracket Y Z) X k +
    su3Bracket (su3Bracket Z X) Y k = 0 := by
  rw [bracket_bracket_expand_X X Y Z k,
      bracket_bracket_expand_Y X Y Z k,
      bracket_bracket_expand_Z X Y Z k]
  -- Collapse the three quadruple sums into one whose summand at fixed
  -- (a,b,c,m) factors as X·Y·Z × (the Jacobi summand in `m`).
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  apply Finset.sum_eq_zero; intros a _
  rw [show
      (∑ b : Fin 8, ∑ c : Fin 8, ∑ m : Fin 8,
         su3f a b m * su3f m c k * X a * Y b * Z c) +
      (∑ b : Fin 8, ∑ c : Fin 8, ∑ m : Fin 8,
         su3f b c m * su3f m a k * X a * Y b * Z c) +
      (∑ b : Fin 8, ∑ c : Fin 8, ∑ m : Fin 8,
         su3f c a m * su3f m b k * X a * Y b * Z c) =
      ∑ b : Fin 8, ∑ c : Fin 8, ∑ m : Fin 8,
        (su3f a b m * su3f m c k * X a * Y b * Z c +
         su3f b c m * su3f m a k * X a * Y b * Z c +
         su3f c a m * su3f m b k * X a * Y b * Z c) from by
    rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl; intros b _
    rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl; intros c _
    rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]]
  apply Finset.sum_eq_zero; intros b _
  apply Finset.sum_eq_zero; intros c _
  -- ∑_m (Jacobi-summand · X a · Y b · Z c) = (X·Y·Z) · ∑_m Jacobi-summand.
  rw [show
      (∑ m : Fin 8,
        (su3f a b m * su3f m c k * X a * Y b * Z c +
         su3f b c m * su3f m a k * X a * Y b * Z c +
         su3f c a m * su3f m b k * X a * Y b * Z c)) =
      (X a * Y b * Z c) *
        (∑ m : Fin 8,
          (su3f a b m * su3f m c k +
           su3f b c m * su3f m a k +
           su3f c a m * su3f m b k)) from by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl; intros m _
    ring]
  rw [su3f_jacobi_sum_zero a b c k]
  ring

/-! ## §5. The Jacobi identity at the `SU3LieAlgebra` level -/

/-- **SU(3) Jacobi identity — functional form.**
    For arbitrary Lie-algebra elements `X, Y, Z : SU3LieAlgebra`,
    `[[X,Y],Z] + [[Y,Z],X] + [[Z,X],Y] = 0`
    as an equality of `SU3LieAlgebra` elements. -/
theorem su3Bracket_jacobi_full
    (X Y Z : SU3LieAlgebra) :
    (su3Bracket (su3Bracket X Y) Z +
     su3Bracket (su3Bracket Y Z) X +
     su3Bracket (su3Bracket Z X) Y : SU3LieAlgebra) = 0 := by
  ext k
  simp only [Pi.add_apply, Pi.zero_apply]
  exact su3Bracket_jacobi_full_pointwise X Y Z k

/-- Project-level alias mandated by the mission brief. Identical to
    `su3Bracket_jacobi_full`; exposed under the name used by
    downstream consumers and papers. -/
theorem errorGaugeSU3_lieBracket_jacobi
    (X Y Z : SU3LieAlgebra) :
    (su3Bracket (su3Bracket X Y) Z +
     su3Bracket (su3Bracket Y Z) X +
     su3Bracket (su3Bracket Z X) Y : SU3LieAlgebra) = 0 :=
  su3Bracket_jacobi_full X Y Z

/-! ## §6. Witness-free exact SU(3) Lie algebra -/

/-- Witness-free constructor of the exact SU(3) Lie algebra.
    The Jacobi hypothesis `hJ` that was previously parametrised on
    `mkExactSU3LieAlgebra` is now discharged by
    `su3Bracket_jacobi_full`. -/
@[reducible]
noncomputable def mkExactSU3LieAlgebra_unconditional :
    ErrorLieAlgebra SU3LieAlgebra :=
  mkExactSU3LieAlgebra su3Bracket_jacobi_full

/-- Convenience extraction: `mkExactSU3LieAlgebra_unconditional`
    has zero Jacobi error by construction. -/
theorem mkExactSU3LieAlgebra_unconditional_jacobi_error :
    mkExactSU3LieAlgebra_unconditional.εJacobi = 0 := rfl

/-- The Jacobi error of the witness-free exact SU(3) Lie algebra is
    zero on every triple of inputs, reflecting the exact closure
    achieved by `su3Bracket_jacobi_full`. -/
theorem mkExactSU3LieAlgebra_unconditional_jacobi_tight
    (X Y Z : SU3LieAlgebra) :
    mkExactSU3LieAlgebra_unconditional.norm
      (mkExactSU3LieAlgebra_unconditional.toErrorLieBracket.bracket
        (mkExactSU3LieAlgebra_unconditional.toErrorLieBracket.bracket X Y) Z +
       mkExactSU3LieAlgebra_unconditional.toErrorLieBracket.bracket
        (mkExactSU3LieAlgebra_unconditional.toErrorLieBracket.bracket Y Z) X +
       mkExactSU3LieAlgebra_unconditional.toErrorLieBracket.bracket
        (mkExactSU3LieAlgebra_unconditional.toErrorLieBracket.bracket Z X) Y) =
    0 := by
  change normInf8
      (su3Bracket (su3Bracket X Y) Z +
       su3Bracket (su3Bracket Y Z) X +
       su3Bracket (su3Bracket Z X) Y) = 0
  rw [su3Bracket_jacobi_full X Y Z]
  exact normInf8_zero_val

/-! ## §7. Summary

This file closes the SU(3) Jacobi identity unconditionally:

  · `su3Bracket_right_linear`                 — bracket linearity
                                                in the SECOND
                                                argument.
  · `sum_basis_expansion`                     — any `X` is
                                                `∑ a, X(a)·e_a`.
  · `bracket_bracket_expand_{X,Y,Z}`          — the three cyclic
                                                `[[·,·],·] k`
                                                terms rewritten as
                                                common-outer-order
                                                quadruple sums.
  · `su3Bracket_jacobi_full_pointwise`        — pointwise Jacobi.
  · `su3Bracket_jacobi_full`                  — **unconditional**
                                                functional Jacobi.
  · `errorGaugeSU3_lieBracket_jacobi`         — mission-brief alias.
  · `mkExactSU3LieAlgebra_unconditional`      — witness-free
                                                constructor.

Together with `su3f_jacobi_sum_zero` (the 4096-case numerical heart,
closed by `native_decide` after ℚ+√3 decomposition), this delivers
the full algebraic closure of the SU(3) colour-gauge Lie algebra
that underlies QCD.

No `sorry`, no new axioms.
-/

end OmegaTheory.Emergence.SU3JacobiIdentity
