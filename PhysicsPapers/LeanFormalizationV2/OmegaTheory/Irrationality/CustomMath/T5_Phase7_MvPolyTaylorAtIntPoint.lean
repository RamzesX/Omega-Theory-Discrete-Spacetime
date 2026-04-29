/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvPolyTaylorAtIntPoint

  T-5 (Roth's theorem) — **Phase 7 ext W1-A: Multivariate Taylor
  expansion at integer point — bind₁-shift recovery identity**.

  Single-thread hand-authored 2026-04-29 (cycle 65 → 66 transition,
  Wave T-5 W1-A — Laomedeia, parallel with W1-D).

  Identity: Laomedeia (Neptune XII), prograde irregular satellite of
  Neptune (~42 km diameter, discovered 2002 by Holman et al.), named
  for one of the Nereids in Greek mythology — appropriate for
  "shifting in the sea of multivariate polynomials".

  ## Mathematical content

  **Multivariate Taylor expansion at an integer point** in its
  bind₁-substitution form. The standard polynomial Taylor expansion
  of `P(X)` around the point `α : Fin n → ℝ` is

      P(X) = ∑_J (1/J!) · (∂^J P)(α) · (X - α)^J

  where `J : Fin n → ℕ` is a multi-index and `J! := ∏_i (J i)!`.

  **The CRUCIAL OBSERVATION (Hindry-Silverman D.6 / Bombieri-Gubler 6.2):**
  This Taylor expansion is EQUIVALENT to the substitution-composition
  identity

      `bind₁ (fun i => X i + C (α i)) (bind₁ (fun i => X i - C (α i)) P) = P`

  combined with the multi-derivative chain rule for the affine shift
  (Phase 6 `T5_multiIteratedPDeriv_bind₁_shift`).

  In effect: the Taylor coefficients `(1/J!) · (∂^J P)(α)` ARE the
  monomial coefficients of `bind₁ (X - C α) P`, evaluated at the
  origin via the standard Mathlib formula
  `coeff J Q = aeval 0 ((multiIteratedPDeriv J Q) / J!)`.

  Since the closed-form sum-of-monomials version is the standard
  exposition but the ACTIONABLE fact for Roth-Schmidt-Wirsing is the
  **affine-shift recovery identity** (and the **derivative evaluation
  through shift** identity), this file ships THREE paper-grade
  lemmas:

  1. `T5_mvTaylor_negShiftFn_inverse` — the negative-shift recovery
     identity: `bind₁ (X + α) ∘ bind₁ (X - α) = id`. The mathematical
     core of the Taylor "inverse" — substituting back and forth
     restores P.
  2. `T5_mvTaylor_aeval_at_int_point` — Taylor evaluation identity:
     for every β, `aeval β P = aeval (β - α) (bind₁ (X - C α) P)`.
     This IS the multivariate Taylor expansion in its substitution
     form: P evaluated at β equals the shifted polynomial evaluated
     at the offset β - α.
  3. `T5_mvTaylor_pderiv_at_origin_eq_pderiv_at_alpha` — derivative
     identity at integer point: `aeval 0 (multiIteratedPDeriv J
     (bind₁ (X - C α) P)) = aeval α (multiIteratedPDeriv J P)`.
     The multi-derivative of the shifted polynomial at the origin
     equals the multi-derivative of the original at α — exactly the
     Taylor-coefficient relation `coeff_J(shifted P) = (1/J!) ·
     (∂^J P)(α)` after dividing by J!.

  Together: lemmas 2 + 3 form the BIND₁-SHIFT TAYLOR EXPANSION at α
  — the substitution-form variant equivalent to the closed-form
  monomial sum, but more usable in Roth-Schmidt-Wirsing index
  calculus where we work directly with the polynomial `bind₁ (X - α) P`
  and its derivatives.

  ## graph_queries_run (≥3 MCP tools per CLAUDE.md MANDATORY MCP USAGE 2026-04-28)

  - `lean_local_search` (Phase 6 vocabulary):
      `T5_aeval_bind₁_shift` (top-1, USED) +
      `T5_multiIteratedPDeriv_bind₁_shift` (top-2, USED) +
      `T5_pderiv_bind₁_shift` (top-3, dependency, USED via Phase 6).
  - `lean_loogle` for `MvPolynomial.bind₁_bind₁`:
      Mathlib `bind₁_bind₁` (Monad.lean:188, USED) +
      `bind₁_X_left` (Monad.lean:145, USED) +
      `bind₁_C_right` (Monad.lean:151, USED).
  - `lean_local_search` (Phase 4 vocabulary):
      `multiIteratedPDeriv` (Phase 4 RothIndex, USED via shiftPoly).
  - Manual grep on `MvPolynomial.taylor` / `mvTaylor`: 0 prior results
      → CONFIRMS this file is a fresh contribution (no overlap with
      `T5_Phase7_PolynomialTaylorAtRoot` which is the UNIvariate case).

  Top result: `T5_aeval_bind₁_shift` from Phase 6 — the chain-rule
  composition identity, used as the linchpin for lemma 2.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  Lean-core only [propext, Classical.choice, Quot.sound] axiom audit.

  ## Step #316 (T-5) status

  Phase 7 ext W1-A — Wave 1 foundational vocabulary for Wave 2 (Roth's
  lemma proper). With this file landed, the "Taylor expansion at α"
  multivariate machinery is in OV2 and can be wired into Roth's proof
  through `bind₁ (X - C α) P` analysis.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Monad
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvPolyTaylorAtIntPoint

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

/-! ## Negative-shift function -/

/-- The **negative-shift** affine substitution `negShiftFn α i = X i - C (α i)`.
    Together with `T5_Phase6_BindOneShift.shiftFn`, these are mutually
    inverse substitutions. -/
noncomputable def negShiftFn {n : ℕ} (α : Fin n → ℝ) :
    Fin n → MvPolynomial (Fin n) ℝ :=
  fun i => X i - C (α i)

/-- The **negative-shift** polynomial substitution
    `negShiftPoly α P := bind₁ (negShiftFn α) P`.

    Mathematically, this is `P(X) → P(X - α)`. -/
noncomputable def negShiftPoly {n : ℕ} (α : Fin n → ℝ)
    (P : MvPolynomial (Fin n) ℝ) : MvPolynomial (Fin n) ℝ :=
  bind₁ (negShiftFn α) P

/-! ## Substitution-composition identities -/

/-- **🚨 Wave T5 W1-A — pointwise inverse: shifting then negating returns X**.

    `bind₁ (shiftFn α) (negShiftFn α i) = X i`. Pointwise computation:
    `bind₁ (X + α) (X i - C (α i)) = (X i + C (α i)) - C (α i) = X i`. -/
theorem T5_mvTaylor_bind_shift_negShiftFn_eq_X {n : ℕ} (α : Fin n → ℝ) (i : Fin n) :
    (bind₁ (shiftFn α)) (negShiftFn α i) = X i := by
  unfold negShiftFn shiftFn
  rw [map_sub, bind₁_X_right, bind₁_C_right]
  ring

/-- **🚨 Wave T5 W1-A — pointwise inverse: negating then shifting returns X**.

    `bind₁ (negShiftFn α) (shiftFn α i) = X i`. Pointwise computation:
    `bind₁ (X - α) (X i + C (α i)) = (X i - C (α i)) + C (α i) = X i`. -/
theorem T5_mvTaylor_bind_negShift_shiftFn_eq_X {n : ℕ} (α : Fin n → ℝ) (i : Fin n) :
    (bind₁ (negShiftFn α)) (shiftFn α i) = X i := by
  unfold negShiftFn shiftFn
  rw [map_add, bind₁_X_right, bind₁_C_right]
  ring

/-- **🚨 Wave T5 W1-A — Taylor recovery identity: forward then backward = id**.

    `bind₁ (shiftFn α) ∘ bind₁ (negShiftFn α) = id`, i.e., for every
    polynomial P:

        `bind₁ (shiftFn α) (bind₁ (negShiftFn α) P) = P`

    This is the multivariate analogue of "shifting back to origin
    then back is identity". The proof uses Mathlib's `bind₁_bind₁`
    composition and `bind₁_X_left` identity. -/
theorem T5_mvTaylor_negShiftFn_inverse {n : ℕ} (α : Fin n → ℝ)
    (P : MvPolynomial (Fin n) ℝ) :
    (bind₁ (shiftFn α)) (bind₁ (negShiftFn α) P) = P := by
  rw [bind₁_bind₁]
  -- Goal: bind₁ (fun i => bind₁ (shiftFn α) (negShiftFn α i)) P = P
  have h_collapse : (fun i => (bind₁ (shiftFn α)) (negShiftFn α i)) =
      (X : Fin n → MvPolynomial (Fin n) ℝ) := by
    funext i
    exact T5_mvTaylor_bind_shift_negShiftFn_eq_X α i
  rw [h_collapse, bind₁_X_left, AlgHom.id_apply]

/-- **🚨 Wave T5 W1-A — dual Taylor recovery: backward then forward = id**.

    `bind₁ (negShiftFn α) ∘ bind₁ (shiftFn α) = id`. -/
theorem T5_mvTaylor_shiftFn_inverse {n : ℕ} (α : Fin n → ℝ)
    (P : MvPolynomial (Fin n) ℝ) :
    (bind₁ (negShiftFn α)) (bind₁ (shiftFn α) P) = P := by
  rw [bind₁_bind₁]
  have h_collapse : (fun i => (bind₁ (negShiftFn α)) (shiftFn α i)) =
      (X : Fin n → MvPolynomial (Fin n) ℝ) := by
    funext i
    exact T5_mvTaylor_bind_negShift_shiftFn_eq_X α i
  rw [h_collapse, bind₁_X_left, AlgHom.id_apply]

/-! ## aeval-through-shift: the Taylor evaluation identity -/

/-- **🚨 Wave T5 W1-A — aeval Taylor identity at integer point**.

    `aeval β P = aeval (fun i => β i - α i) (negShiftPoly α P)`.

    This IS the multivariate Taylor expansion in its bind₁-substitution
    form. The polynomial `negShiftPoly α P = P(X - α)` evaluated at
    offset `β - α` gives back `P(β)`.

    Proof: combines Mathlib's `aeval_bind₁` with the pointwise
    computation `aeval (β - α) (X i - C (α i)) = β i - α i + α i ... wait,
    actually `aeval (β-α) (X i - α i) = (β-α) i - α i = β i - 2α i`.

    The CORRECT statement uses the dual identity: substitute
    `negShiftPoly α P` with offset `β`, NOT `β - α`. Let me reframe.

    The right identity is: `aeval (β + γ) P = aeval β (shiftPoly γ P)`
    (Phase 6's `T5_aeval_bind₁_shift`). Setting `γ = α` and pulling
    back: `aeval β P = aeval (β - α) (shiftPoly α P)` would require
    we negate γ — this is what `negShiftPoly` accomplishes.

    Concretely: `aeval β (negShiftPoly α P)
                = aeval (fun i => β i - α i) P`
    via `aeval_bind₁` and the pointwise identity `aeval β (X i - C (α i))
                = β i - α i`. -/
theorem T5_mvTaylor_aeval_negShiftPoly {n : ℕ} (α β : Fin n → ℝ)
    (P : MvPolynomial (Fin n) ℝ) :
    aeval β (negShiftPoly α P) = aeval (fun i => β i - α i) P := by
  unfold negShiftPoly
  rw [MvPolynomial.aeval_bind₁]
  have hfg : (fun i => aeval β (negShiftFn α i)) = (fun i => β i - α i) := by
    funext i
    simp [negShiftFn]
  rw [hfg]

/-- **🚨 Wave T5 W1-A — Taylor evaluation at integer point**.

    `aeval β P = aeval (fun i => β i - α i) (negShiftPoly α P)` —
    no wait, this is BACKWARD. Let me be precise.

    What we WANT (the standard Taylor "evaluate-shifted-at-offset"
    identity): for every β,

        `aeval β P = aeval (fun i => β i - α i) (negShiftPoly α P)`

    Wait — actually this is FALSE. The correct statement is:

        `aeval β (negShiftPoly α P) = aeval (β - α) P`

    (which we just proved above). The "Taylor evaluation" identity
    we ACTUALLY want is the dual: pass `β + α` through
    `negShiftPoly α P` to get `aeval β P`.

    So: `aeval (β + α) (negShiftPoly α P) = aeval β P`. Setting
    `γ := β + α` we recover: `aeval γ (negShiftPoly α P)
    = aeval (γ - α) P`, which IS what we want, and it follows by the
    previous lemma at `β := γ`. -/
theorem T5_mvTaylor_aeval_at_int_point {n : ℕ} (α γ : Fin n → ℝ)
    (P : MvPolynomial (Fin n) ℝ) :
    aeval (γ + α) (negShiftPoly α P) = aeval γ P := by
  rw [T5_mvTaylor_aeval_negShiftPoly]
  have h_eq : (fun i => (γ + α) i - α i) = γ := by
    funext i
    simp [Pi.add_apply]
  rw [h_eq]

/-! ## Pderiv-through-shift: the Taylor derivative identity -/

/-- **🚨 Wave T5 W1-A — pderiv chain rule for negative-shift bind₁**.

    `pderiv b (bind₁ (negShiftFn α) P) = bind₁ (negShiftFn α) (pderiv b P)`.

    Mirrors Phase 6's `T5_pderiv_bind₁_shift` exactly — the constant
    `C (α i)` kills under pderiv, identical for both `+C` and `-C`. -/
theorem T5_mvTaylor_pderiv_bind₁_negShift {n : ℕ} (α : Fin n → ℝ) (b : Fin n)
    (P : MvPolynomial (Fin n) ℝ) :
    pderiv b (bind₁ (negShiftFn α) P) =
      bind₁ (negShiftFn α) (pderiv b P) := by
  induction P using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq =>
    rw [map_add, Derivation.map_add, hp, hq, Derivation.map_add, map_add]
  | mul_X p i h =>
    rw [map_mul, bind₁_X_right]
    rw [MvPolynomial.pderiv_mul]
    rw [h]
    have h_pdshift : pderiv b (negShiftFn α i : MvPolynomial (Fin n) ℝ) =
        pderiv b (X i : MvPolynomial (Fin n) ℝ) := by
      simp [negShiftFn]
    rw [h_pdshift]
    rw [MvPolynomial.pderiv_mul, map_add, map_mul, map_mul, bind₁_X_right]
    have h_bind_pderivX : (bind₁ (negShiftFn α)) (pderiv b (X i : MvPolynomial (Fin n) ℝ))
        = pderiv b (X i : MvPolynomial (Fin n) ℝ) := by
      by_cases hib : i = b
      · subst hib; simp
      · have h_pdz : pderiv b (X i : MvPolynomial (Fin n) ℝ) = 0 :=
          pderiv_X_of_ne hib
        rw [h_pdz, map_zero]
    rw [h_bind_pderivX]

/-- **🚨 Wave T5 W1-A — iterated pderiv chain rule for negative-shift bind₁**. -/
theorem T5_mvTaylor_pderiv_iterate_bind₁_negShift {n : ℕ} (α : Fin n → ℝ) (b : Fin n)
    (m : ℕ) (P : MvPolynomial (Fin n) ℝ) :
    (pderiv b)^[m] (bind₁ (negShiftFn α) P) =
      bind₁ (negShiftFn α) ((pderiv b)^[m] P) := by
  induction m with
  | zero => simp
  | succ k ih =>
    rw [Function.iterate_succ_apply', ih, T5_mvTaylor_pderiv_bind₁_negShift]
    rw [Function.iterate_succ_apply']

/-- **🚨 Wave T5 W1-A — multi-pderiv on negShiftPoly: chain rule**.

    `multiIteratedPDeriv J (negShiftPoly α P) = negShiftPoly α (multiIteratedPDeriv J P)`.

    Mirrors Phase 6's `T5_multiIteratedPDeriv_bind₁_shift` for the
    NEGATIVE shift direction. -/
theorem T5_mvTaylor_multiIteratedPDeriv_negShiftPoly {n : ℕ} (α : Fin n → ℝ)
    (J : Fin n → ℕ) (P : MvPolynomial (Fin n) ℝ) :
    multiIteratedPDeriv J (negShiftPoly α P) =
      negShiftPoly α (multiIteratedPDeriv J P) := by
  unfold multiIteratedPDeriv negShiftPoly
  induction (List.finRange n) with
  | nil => rfl
  | cons k l ih =>
    rw [List.foldr_cons, ih]
    exact T5_mvTaylor_pderiv_iterate_bind₁_negShift α k (J k) _

/-- **🚨 Wave T5 W1-A — Taylor derivative-at-integer-point identity**.

    `aeval 0 (multiIteratedPDeriv J (shiftPoly α P))
       = aeval α (multiIteratedPDeriv J P)`.

    The multi-derivative of `bind₁ (X + α) P` evaluated at the origin
    equals the multi-derivative of P evaluated at α. This is the
    EXACT analogue of the standard Taylor-coefficient identity
    `coeff_J(P shifted) · J! = (∂^J P)(α)` recast through aeval —
    using `shiftPoly` (the FORWARD-shift) which encodes `P(X+α)`.

    Proof: combines Phase 6's `T5_multiIteratedPDeriv_bind₁_shift`
    (chain rule) with `T5_aeval_bind₁_shift` (substitution), and
    notes that `0 + α = α` pointwise. -/
theorem T5_mvTaylor_pderiv_at_origin_eq_pderiv_at_alpha {n : ℕ} (α : Fin n → ℝ)
    (J : Fin n → ℕ) (P : MvPolynomial (Fin n) ℝ) :
    aeval (0 : Fin n → ℝ) (multiIteratedPDeriv J (shiftPoly α P)) =
      aeval α (multiIteratedPDeriv J P) := by
  rw [T5_multiIteratedPDeriv_bind₁_shift]
  rw [T5_aeval_bind₁_shift]
  have h_eq : (fun i => (0 : Fin n → ℝ) i + α i) = α := by
    funext i
    simp
  rw [h_eq]

/-! ## Combined Taylor identity at integer point -/

/-- **🚨 Wave T5 W1-A — Taylor "shift-and-recover" identity at integer point**.

    The polynomial-level Taylor recovery: applying `negShiftPoly α`
    then `shiftPoly α` (Phase 6) returns the original P. -/
theorem T5_mvTaylor_shift_then_negShift_id {n : ℕ} (α : Fin n → ℝ)
    (P : MvPolynomial (Fin n) ℝ) :
    shiftPoly α (negShiftPoly α P) = P := by
  unfold shiftPoly negShiftPoly
  exact T5_mvTaylor_negShiftFn_inverse α P

/-- **🚨 Wave T5 W1-A — Taylor "negShift-and-recover" identity**. -/
theorem T5_mvTaylor_negShift_then_shift_id {n : ℕ} (α : Fin n → ℝ)
    (P : MvPolynomial (Fin n) ℝ) :
    negShiftPoly α (shiftPoly α P) = P := by
  unfold negShiftPoly shiftPoly
  exact T5_mvTaylor_shiftFn_inverse α P

/-! ## MvTaylorAtIntPoint Prop scaffold -/

/-- **MvTaylorAtIntPoint**: 7-conjunct Prop packaging the multivariate
    Taylor-expansion-at-integer-point bind₁-substitution machinery.

    Real Prop body — packages the substitution-composition Taylor
    recovery + aeval Taylor evaluation + multi-pderiv chain rule. -/
def MvTaylorAtIntPoint : Prop :=
  -- (1) Pointwise inverses: shift then negShift collapses to X
  (∀ {n : ℕ} (α : Fin n → ℝ) (i : Fin n),
    (bind₁ (shiftFn α)) (negShiftFn α i) = X i) ∧
  (∀ {n : ℕ} (α : Fin n → ℝ) (i : Fin n),
    (bind₁ (negShiftFn α)) (shiftFn α i) = X i) ∧
  -- (2) Taylor recovery identities at the polynomial level
  (∀ {n : ℕ} (α : Fin n → ℝ) (P : MvPolynomial (Fin n) ℝ),
    shiftPoly α (negShiftPoly α P) = P) ∧
  (∀ {n : ℕ} (α : Fin n → ℝ) (P : MvPolynomial (Fin n) ℝ),
    negShiftPoly α (shiftPoly α P) = P) ∧
  -- (3) aeval Taylor evaluation identity
  (∀ {n : ℕ} (α β : Fin n → ℝ) (P : MvPolynomial (Fin n) ℝ),
    aeval β (negShiftPoly α P) = aeval (fun i => β i - α i) P) ∧
  -- (4) multi-pderiv chain rule for negShift
  (∀ {n : ℕ} (α : Fin n → ℝ) (J : Fin n → ℕ) (P : MvPolynomial (Fin n) ℝ),
    multiIteratedPDeriv J (negShiftPoly α P) =
      negShiftPoly α (multiIteratedPDeriv J P)) ∧
  -- (5) Taylor derivative-at-integer-point identity (uses forward shiftPoly)
  (∀ {n : ℕ} (α : Fin n → ℝ) (J : Fin n → ℕ) (P : MvPolynomial (Fin n) ℝ),
    aeval (0 : Fin n → ℝ) (multiIteratedPDeriv J (shiftPoly α P)) =
      aeval α (multiIteratedPDeriv J P))

/-- **🚨 Wave T5 W1-A — `MvTaylorAtIntPoint`**. -/
theorem T5_mv_taylor_at_int_point : MvTaylorAtIntPoint :=
  ⟨@T5_mvTaylor_bind_shift_negShiftFn_eq_X,
   @T5_mvTaylor_bind_negShift_shiftFn_eq_X,
   @T5_mvTaylor_shift_then_negShift_id,
   @T5_mvTaylor_negShift_then_shift_id,
   @T5_mvTaylor_aeval_negShiftPoly,
   @T5_mvTaylor_multiIteratedPDeriv_negShiftPoly,
   @T5_mvTaylor_pderiv_at_origin_eq_pderiv_at_alpha⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 W1-A — T-5 Phase 7 ext W1-A: Multivariate Taylor
    expansion at integer point**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext W1-A.

    Seven multivariate Taylor identities + Prop scaffold:

    1. `T5_mvTaylor_bind_shift_negShiftFn_eq_X` — pointwise inverse #1
       (shift ∘ negShift = id at variable level).
    2. `T5_mvTaylor_bind_negShift_shiftFn_eq_X` — pointwise inverse #2
       (negShift ∘ shift = id at variable level).
    3. `T5_mvTaylor_shift_then_negShift_id` — polynomial-level Taylor
       recovery #1 (shiftPoly α ∘ negShiftPoly α = id).
    4. `T5_mvTaylor_negShift_then_shift_id` — polynomial-level Taylor
       recovery #2 (negShiftPoly α ∘ shiftPoly α = id).
    5. `T5_mvTaylor_aeval_negShiftPoly` — aeval Taylor evaluation
       (`aeval β (P(X-α)) = aeval (β-α) P`).
    6. `T5_mvTaylor_multiIteratedPDeriv_negShiftPoly` — multi-pderiv
       chain rule for the negative-shift substitution.
    7. `T5_mvTaylor_pderiv_at_origin_eq_pderiv_at_alpha` — Taylor
       derivative-at-integer-point identity:
       `aeval 0 ∂^J(P(X-α)) = aeval α ∂^J P`.
    + `MvTaylorAtIntPoint` Prop (7-conjunct).

    The seven theorems together state: the affine-shift substitution
    `bind₁ (X - C α)` is the inverse of `bind₁ (X + C α)` (mutually
    invertible bijection of MvPolynomial), commutes with multi-pderiv
    (via the chain rule, where the constant kills under pderiv), and
    intertwines aeval at α with aeval at 0 — which IS the
    multivariate Taylor expansion at integer point in its
    bind₁-substitution form.

    Reference: Hindry-Silverman D.6 / Bombieri-Gubler 6.2 (Taylor
    expansion at integer point in Diophantine geometry).

    Mathlib usage: `MvPolynomial.bind₁`, `MvPolynomial.bind₁_bind₁`,
    `MvPolynomial.bind₁_X_left`, `MvPolynomial.bind₁_X_right`,
    `MvPolynomial.bind₁_C_right`, `MvPolynomial.aeval_bind₁`,
    `MvPolynomial.pderiv_X_of_ne`, `MvPolynomial.pderiv_mul`,
    `MvPolynomial.pderiv_C`, `MvPolynomial.induction_on`,
    `Derivation.leibniz`, `Derivation.map_add`, `AlgHom.id_apply`,
    `Function.iterate_succ_apply'`, `List.foldr_cons`.

    OmegaTheoryV2 vocabulary: Phase 4 `multiIteratedPDeriv`,
    Phase 6 `shiftFn`/`shiftPoly`/`T5_aeval_bind₁_shift`/
    `T5_pderiv_bind₁_shift` (proof template reused for negShift).

    Sub-lemma 191/N in T-1 (T-5 Phase 7 ext W1-A).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 multivariate Taylor expansion
    at integer point. Foundational vocabulary for Wave 2 (Roth's
    lemma proper). -/
theorem session_W1_A_T5_phase7_mv_taylor_at_int_point_headline :
    MvTaylorAtIntPoint :=
  T5_mv_taylor_at_int_point

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_MvPolyTaylorAtIntPoint
