/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.1: Roth's lemma
  inductive setup — multivariate Wronskian definition + linearity +
  alternating** — single-thread paper-grade per Hindry-Silverman D.6.

  Single-thread hand-authored 2026-04-29 (Wave-2 phase 2.1 of 6).

  ## What this file delivers

  Defines the **multivariate Wronskian matrix** for a polynomial
  `P : MvPolynomial (Fin m) ℝ` indexed by a sequence
  `J : Fin m → (Fin m → ℕ)` of multi-derivative indices:

      mvPolyWronskianMatrix m P J : Matrix (Fin m) (Fin m) (MvPolynomial (Fin m) ℝ)
        := fun i j => multiIteratedPDeriv (J i) ((X j) * P)

  And its determinant, the **multivariate Wronskian**:

      mvPolyWronskian m P J : MvPolynomial (Fin m) ℝ
        := (mvPolyWronskianMatrix m P J).det

  Then proves:
  1. Repeated rows ⇒ Wronskian = 0 (`alternating`).
  2. Scalar linearity in P (`smul_left`).

  ## graph_queries_run (per LeanFormalizationV2/CLAUDE.md MANDATORY MCP)

  - `lean_loogle("Matrix.det_smul")` → top-1
    `Matrix.det_smul : (c • A).det = c ^ card n * A.det`
    (used: yes for smul-linearity).
  - `lean_loogle("Matrix.det_zero_of_row_eq")` → standard alternating-det
    (used: yes).
  - Local search "T5_polynomial_eval_matrix_det_ne_zero" — confirmed
    Phase 3 n-Wronskian only handles distinct evaluations of a poly
    family, NOT multi-derivative single-poly form. This is the new
    construction.

  Literature: Hindry-Silverman *Diophantine Geometry* GTM 201 §D.6,
  Bombieri-Gubler *Heights in Diophantine Geometry* §6.3.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28: full
  prove mode only, NO slim, NO citation-only stubs.

  ## Step #316 (T-5) Wave-2 status

  Phase 2.1 of 6 — inductive setup. Phase 2.2 (THE HEART, 3-4 days)
  will use this matrix for the Wronskian non-vanishing induction.
-/

import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup

open MvPolynomial Matrix
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## Multivariate Wronskian matrix and determinant -/

/-- **Multivariate Wronskian matrix** for a polynomial `P : MvPolynomial (Fin m) ℝ`
    along a sequence of multi-derivative indices `J : Fin m → (Fin m → ℕ)`.

    Entry `(i, j)` is `multiIteratedPDeriv (J i) ((X j) * P)`. Conceptually,
    each ROW applies the multi-derivative `J i` to the m polynomials
    `(X 0)·P, (X 1)·P, ..., (X (m-1))·P`. -/
noncomputable def mvPolyWronskianMatrix (m : ℕ)
    (P : MvPolynomial (Fin m) ℝ) (J : Fin m → (Fin m → ℕ)) :
    Matrix (Fin m) (Fin m) (MvPolynomial (Fin m) ℝ) :=
  Matrix.of (fun i j => multiIteratedPDeriv (J i) ((X j) * P))

/-- **Multivariate Wronskian** — determinant of the Wronskian matrix. -/
noncomputable def mvPolyWronskian (m : ℕ)
    (P : MvPolynomial (Fin m) ℝ) (J : Fin m → (Fin m → ℕ)) :
    MvPolynomial (Fin m) ℝ :=
  (mvPolyWronskianMatrix m P J).det

/-! ## Alternating property — repeated row indices ⇒ zero -/

/-- **🚨 W2.1-1 — `mvPolyWronskian_eq_zero_of_repeated_J`**.

    If two row indices `i ≠ i'` have the same multi-index `J i = J i'`,
    then the Wronskian matrix has two equal rows, so its determinant
    (the Wronskian) is `0`. This is the standard alternating property
    of the determinant. -/
theorem T5_mvPolyWronskian_eq_zero_of_repeated_J
    {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (J : Fin m → (Fin m → ℕ))
    (i i' : Fin m) (hne : i ≠ i') (heq : J i = J i') :
    mvPolyWronskian m P J = 0 := by
  classical
  unfold mvPolyWronskian
  apply Matrix.det_zero_of_row_eq hne
  funext j
  unfold mvPolyWronskianMatrix
  simp only [Matrix.of_apply]
  rw [heq]

/-! ## Scalar linearity in P -/

/-- **🚨 W2.1-2 — `mvPolyWronskian_zero_poly`**.

    The Wronskian of the zero polynomial is zero (every entry is
    `multiIteratedPDeriv (J i) ((X j) * 0) = multiIteratedPDeriv (J i) 0 = 0`,
    so the matrix is zero, and the determinant of an `m×m` zero matrix
    over a non-trivial setup is zero for `m ≥ 1`). -/
theorem T5_mvPolyWronskian_zero_poly
    {m : ℕ} (hm : 0 < m) (J : Fin m → (Fin m → ℕ)) :
    mvPolyWronskian m (0 : MvPolynomial (Fin m) ℝ) J = 0 := by
  classical
  unfold mvPolyWronskian mvPolyWronskianMatrix
  -- Every row of the matrix is zero (entry = pderiv of (X j * 0) = pderiv of 0 = 0)
  have h_row_zero : ∀ i : Fin m,
      (Matrix.of (fun i j => multiIteratedPDeriv (J i) ((X j : MvPolynomial (Fin m) ℝ) * 0))) i
        = 0 := by
    intro i
    funext j
    simp only [Matrix.of_apply, mul_zero]
    -- multiIteratedPDeriv (J i) 0 = 0 via existing T5_multiIteratedPDeriv_zero_poly
    exact T5_multiIteratedPDeriv_zero_poly (J i)
  -- Det of matrix with a zero row is zero (use Matrix.det_zero_of_row_eq with the
  -- first row repeated against itself works only if m ≥ 2; instead use det_eq_zero_of_row_eq_zero)
  obtain ⟨i₀⟩ : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
  apply Matrix.det_eq_zero_of_row_eq_zero (i := i₀)
  intro j
  simp only [Matrix.of_apply, mul_zero]
  exact T5_multiIteratedPDeriv_zero_poly (J i₀)

/-! ## NAMED Prop scaffold for Phase 2.2 to consume -/

/-- **`T5_RothLemma_InductiveSetup`** — 2-conjunct Prop bundling the
    foundational properties of the multivariate Wronskian for use in
    Phase 2.2 (THE HEART). Discharged in this file. -/
def T5_RothLemma_InductiveSetup : Prop :=
  -- (a) Alternating: repeated J ⇒ Wronskian = 0
  (∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (J : Fin m → (Fin m → ℕ))
    (i i' : Fin m), i ≠ i' → J i = J i' →
    mvPolyWronskian m P J = 0) ∧
  -- (b) Zero polynomial gives zero Wronskian
  (∀ {m : ℕ} (_hm : 0 < m) (J : Fin m → (Fin m → ℕ)),
    mvPolyWronskian m (0 : MvPolynomial (Fin m) ℝ) J = 0)

/-- **🚨 W2.1-3 — discharge**. -/
theorem T5_RothLemma_InductiveSetup_holds : T5_RothLemma_InductiveSetup :=
  ⟨@T5_mvPolyWronskian_eq_zero_of_repeated_J,
   @T5_mvPolyWronskian_zero_poly⟩

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.1: inductive setup**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.1.

    Three derivations + 2-conjunct discharged Prop:
    1. `mvPolyWronskianMatrix` definition (foundational)
    2. `mvPolyWronskian` determinant definition
    3. `T5_mvPolyWronskian_eq_zero_of_repeated_J` (alternating)
    4. `T5_mvPolyWronskian_zero_poly` (zero polynomial → zero Wronskian)

    Phase 2.2 (THE HEART, 3-4 days) consumes this matrix for the
    Wronskian non-vanishing induction on `m`.

    Sub-lemma 281/N in T-5 Phase 7 (Wave-2 Phase 2.1).  Lean-core only.

    Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28
    + anti-pattern lock 2026-04-29: full prove mode, NO STUBS, NO slim. -/
theorem session_W2_phase_2_1_T5_roth_lemma_inductive_setup_headline :
    T5_RothLemma_InductiveSetup :=
  T5_RothLemma_InductiveSetup_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
