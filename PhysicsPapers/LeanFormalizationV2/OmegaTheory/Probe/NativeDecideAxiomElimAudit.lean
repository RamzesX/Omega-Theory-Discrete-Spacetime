/-
  OmegaTheory.Probe.NativeDecideAxiomElimAudit

  Cycle-54 Phase B audit deliverable (Beid, 2026-04-25).

  ## Mandate

  The Zubeneschamali briefing
  `plans/SAGE_BRIEFING_native_decide_axiom_elim_via_decide_2026-04-25.md`
  proposed eliminating `native_decide` axioms from `SU3JacobiFull.jacobi_rat_zero`
  and `SU3JacobiFull.jacobi_sqrt3_zero`, replacing them with `decide` or
  `fin_cases + decide`.

  ## Finding — already closed by cycle-49 P3t

  An audit of the OmegaTheory codebase shows **zero `native_decide` tactic
  invocations** anywhere in `OmegaTheory/`. The cycle-49 P3t closure
  (Almach², April 17, 2026) already eliminated them via the chain
    `su3f_jacobi_sum_zero_via_matrix`        (∑ = 0 in ℝ from Gell-Mann commutator)
    + `su3f_decomp`                          (ℝ-sum = ↑rat + √3 · ↑sqrt3)
    + `rat_sqrt3_linear_independent`         (ℚ-LI of {1, √3}).

  All four headline theorems
    · `jacobi_rat_zero`
    · `jacobi_sqrt3_zero`
    · `su3f_jacobi_sum_zero`
    · `su3Bracket_jacobi_basis_all`
  carry axiom footprint `[propext, Classical.choice, Quot.sound]` only —
  Lean core. No `Lean.ofReduceBool` / `_native_decide_ax_*` axioms.

  ## What this file does

  This module is a **defensive regression sentinel**. It re-asserts each
  of the four theorems as a fresh top-level lemma whose proof body is just
  the existing theorem name. If a future refactor accidentally re-introduces
  `native_decide`, the resulting `Lean.ofReduceBool` axiom would (a) stay
  attached to the original theorem and (b) be inherited by these audit
  re-assertions, where it would be visible in any subsequent `#print axioms`.

  We do NOT add a new axiom; we do NOT add a new mathematical claim.

  Beid (omicron¹ Eridani K2III), cycle-54 Phase B, 2026-04-25.
  No sorry, no new axioms.
-/

import OmegaTheory.Emergence.SU3JacobiFull

namespace OmegaTheory.Probe.NativeDecideAxiomElimAudit

open OmegaTheory.Emergence.SU3JacobiFull
open OmegaTheory.Emergence.SU3JacobiDefs
open OmegaTheory.Emergence.ErrorGaugeSU3

/-! ## §1. Audit re-assertions of the four headline theorems.

Each of these is just a name-alias of the corresponding `SU3JacobiFull`
theorem. The point is **NOT** the mathematical content — that already
ships from `SU3JacobiFull`. The point is to give a stable verification
target for `#print axioms` so any future regression that re-introduces
a `native_decide`-derived axiom anywhere in the dependency closure of
`jacobi_rat_zero` / `jacobi_sqrt3_zero` / `su3f_jacobi_sum_zero` /
`su3Bracket_jacobi_basis_all` will be flagged here.

Expected `#print axioms` for each: `[propext, Classical.choice, Quot.sound]`.
A fifth entry such as `Lean.ofReduceBool` indicates regression. -/

/-- Audit alias: ℚ-component Jacobi sum vanishes. -/
theorem audit_jacobi_rat_zero (a b c d : Fin 8) :
    jacobiRatSum a b c d = 0 :=
  jacobi_rat_zero a b c d

/-- Audit alias: √3-component Jacobi sum vanishes. -/
theorem audit_jacobi_sqrt3_zero (a b c d : Fin 8) :
    jacobiSqrt3Sum a b c d = 0 :=
  jacobi_sqrt3_zero a b c d

/-- Audit alias: kernel-level structural-constant Jacobi sum vanishes in ℝ. -/
theorem audit_su3f_jacobi_sum_zero (a b c k : Fin 8) :
    ∑ e : Fin 8, (su3f a b e * su3f e c k +
                  su3f b c e * su3f e a k +
                  su3f c a e * su3f e b k) = 0 :=
  su3f_jacobi_sum_zero a b c k

/-- Audit alias: basis-vector Jacobi identity on ALL 512 triples in `Fin 8³`. -/
theorem audit_su3Bracket_jacobi_basis_all (a b c : Fin 8) :
    (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis c) +
     su3Bracket (su3Bracket (su3Basis b) (su3Basis c)) (su3Basis a) +
     su3Bracket (su3Bracket (su3Basis c) (su3Basis a)) (su3Basis b) :
      SU3LieAlgebra) = 0 :=
  su3Bracket_jacobi_basis_all a b c

/-! ## §2. Audit summary lemma.

Single-conjunction wrap of all four audit aliases — gives a one-name
target for `#print axioms` so a regression test only needs to look at
this single declaration. -/

/-- **Audit summary**: all four SU(3) Jacobi headline theorems hold
    simultaneously. The point of this lemma is its axiom footprint
    (`[propext, Classical.choice, Quot.sound]`); a regression that
    introduces `Lean.ofReduceBool` anywhere in the dependency closure
    of `SU3JacobiFull` will surface here. -/
theorem native_decide_axiom_elim_audit_pure_decide :
    (∀ (a b c d : Fin 8), jacobiRatSum a b c d = 0) ∧
    (∀ (a b c d : Fin 8), jacobiSqrt3Sum a b c d = 0) ∧
    (∀ (a b c k : Fin 8),
        ∑ e : Fin 8, (su3f a b e * su3f e c k +
                      su3f b c e * su3f e a k +
                      su3f c a e * su3f e b k) = 0) ∧
    (∀ (a b c : Fin 8),
        (su3Bracket (su3Bracket (su3Basis a) (su3Basis b)) (su3Basis c) +
         su3Bracket (su3Bracket (su3Basis b) (su3Basis c)) (su3Basis a) +
         su3Bracket (su3Bracket (su3Basis c) (su3Basis a)) (su3Basis b) :
          SU3LieAlgebra) = 0) :=
  ⟨audit_jacobi_rat_zero,
   audit_jacobi_sqrt3_zero,
   audit_su3f_jacobi_sum_zero,
   audit_su3Bracket_jacobi_basis_all⟩

/-! ## §3. Audit verification commands.

Uncomment in a scratch file (do NOT leave uncommented in committed code):

  #print axioms native_decide_axiom_elim_audit_pure_decide
  -- Expected: [propext, Classical.choice, Quot.sound]

  #print axioms audit_jacobi_rat_zero
  #print axioms audit_jacobi_sqrt3_zero
  #print axioms audit_su3f_jacobi_sum_zero
  #print axioms audit_su3Bracket_jacobi_basis_all
  -- All four expected: [propext, Classical.choice, Quot.sound]
-/

end OmegaTheory.Probe.NativeDecideAxiomElimAudit
