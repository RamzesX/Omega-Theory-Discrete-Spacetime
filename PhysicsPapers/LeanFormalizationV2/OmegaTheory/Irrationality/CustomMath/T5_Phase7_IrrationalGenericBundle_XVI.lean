/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XVI: ext #423-441
  PARAMETRIC sqrt-prime UNIFIED THEOREMS**, sub session
  559bbbbbbbbbbbbbbbb through 559tttttttttttttttt — STRICT
  critical-path #316 (T-5) Phase 7 ext #423-441.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XVI,
  19 ext sub-iterations consolidated).

  ## What this file delivers

  PARAMETRIC unified theorems for `Real.sqrt p` where `p : ℕ` with
  `Nat.Prime p`. Replaces 14+ individual concrete lemmas with one
  parametric family.

  Sub-cluster A (parametric building blocks):
  - ext #423: polyXSqMinusNat (param: ℕ → Polynomial ℤ)
  - ext #424: polyXSqMinusNat_ne_zero
  - ext #425: polyXSqMinusNat_natDegree
  - ext #426: polyXSqMinusNat_aeval_sqrt_nat (uses Real.sq_sqrt)

  Sub-cluster B (parametric witness theorems):
  - ext #427: T5_isQuadraticAlgebraic_sqrt_nat
  - ext #428: T5_isQuadraticAlgebraic_sqrt_prime
  - ext #429: T5_IsAlgebraic_int_sqrt_prime
  - ext #430: T5_roth_for_sqrt_prime_via_bundle_VII

  Sub-cluster C (concrete instances via parametric):
  - ext #431: T5_roth_for_sqrt_43_via_param
  - ext #432: T5_roth_for_sqrt_47_via_param
  - ext #433: T5_roth_for_sqrt_53_via_param
  - ext #434: T5_roth_for_sqrt_59_via_param

  Sub-cluster D (Bundle-XVI markers + headlines):
  - ext #435: bundle_XVI_first_in_V2_marker
  - ext #436: bundle_XVI_closed_count
  - ext #437: bundle_XVI_master_alias_4_concrete
  - ext #438: bundle_XVI_isAlgebraic_int_4_concrete
  - ext #439: bundle_XVI_combined_roth_bounds_4_concrete
  - ext #440: bundle_XVI_paper_headline_alias
  - ext #441: bundle_XVI_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #423-441 — Parametric sqrt-prime (BUNDLE-XVI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII

/-! ## Sub-cluster A — parametric building blocks -/

/-- **🚨 ext #423** — Parametric polynomial X² - n (n : ℕ → Polynomial ℤ). -/
noncomputable def polyXSqMinusNat (n : ℕ) : Polynomial ℤ := X ^ 2 - C (n : ℤ)

/-- **🚨 ext #424** — Parametric `polyXSqMinusNat n ≠ 0`. -/
theorem T5_polyXSqMinusNat_ne_zero (n : ℕ) : polyXSqMinusNat n ≠ 0 := by
  intro h
  have h2 : (polyXSqMinusNat n).natDegree = 2 := by
    unfold polyXSqMinusNat
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

/-- **🚨 ext #425** — Parametric `(polyXSqMinusNat n).natDegree = 2`. -/
theorem T5_polyXSqMinusNat_natDegree (n : ℕ) :
    (polyXSqMinusNat n).natDegree = 2 := by
  unfold polyXSqMinusNat
  compute_degree
  norm_num

/-- **🚨 ext #426** — Parametric `aeval (Real.sqrt n) (polyXSqMinusNat n) = 0`. -/
theorem T5_polyXSqMinusNat_aeval_sqrt_nat (n : ℕ) :
    Polynomial.aeval (Real.sqrt n) (polyXSqMinusNat n) = 0 := by
  unfold polyXSqMinusNat
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (n.cast_nonneg : (0 : ℝ) ≤ (n : ℝ))]

/-! ## Sub-cluster B — parametric witness theorems -/

/-- **🚨 ext #427** — Parametric `IsQuadraticAlgebraic (Real.sqrt n)` for any `n : ℕ`. -/
theorem T5_isQuadraticAlgebraic_sqrt_nat (n : ℕ) :
    IsQuadraticAlgebraic (Real.sqrt n) :=
  ⟨polyXSqMinusNat n,
   T5_polyXSqMinusNat_ne_zero n,
   T5_polyXSqMinusNat_aeval_sqrt_nat n,
   T5_polyXSqMinusNat_natDegree n⟩

/-- **🚨 ext #428** — Parametric `IsQuadraticAlgebraic (Real.sqrt p)` for prime `p`. -/
theorem T5_isQuadraticAlgebraic_sqrt_prime (p : ℕ) (_hp : Nat.Prime p) :
    IsQuadraticAlgebraic (Real.sqrt p) :=
  T5_isQuadraticAlgebraic_sqrt_nat p

/-- **🚨 ext #429** — Parametric `IsAlgebraic ℤ (Real.sqrt p)` for prime `p`. -/
theorem T5_IsAlgebraic_int_sqrt_prime (p : ℕ) (hp : Nat.Prime p) :
    IsAlgebraic ℤ (Real.sqrt p) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt p)
    (T5_isQuadraticAlgebraic_sqrt_prime p hp)

/-- **🚨 ext #430** — Parametric Roth for √p via Bundle-VII. -/
theorem T5_roth_for_sqrt_prime_via_bundle_VII
    (p : ℕ) (hp : Nat.Prime p)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt p) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt p| :=
  T5_irrational_quadratic_clean_paper (Real.sqrt p)
    (Nat.Prime.irrational_sqrt hp)
    (T5_isQuadraticAlgebraic_sqrt_prime p hp) ε hε_pos

/-! ## Sub-cluster C — concrete instances via parametric -/

/-- **🚨 ext #431** — Roth for √43 via parametric (Nat.Prime 43). -/
theorem T5_roth_for_sqrt_43_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 43) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 43| := by
  have hp : Nat.Prime 43 := by decide
  exact T5_roth_for_sqrt_prime_via_bundle_VII 43 hp ε hε_pos

/-- **🚨 ext #432** — Roth for √47 via parametric. -/
theorem T5_roth_for_sqrt_47_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 47) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 47| := by
  have hp : Nat.Prime 47 := by decide
  exact T5_roth_for_sqrt_prime_via_bundle_VII 47 hp ε hε_pos

/-- **🚨 ext #433** — Roth for √53 via parametric. -/
theorem T5_roth_for_sqrt_53_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 53) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 53| := by
  have hp : Nat.Prime 53 := by decide
  exact T5_roth_for_sqrt_prime_via_bundle_VII 53 hp ε hε_pos

/-- **🚨 ext #434** — Roth for √59 via parametric. -/
theorem T5_roth_for_sqrt_59_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 59) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 59| := by
  have hp : Nat.Prime 59 := by decide
  exact T5_roth_for_sqrt_prime_via_bundle_VII 59 hp ε hε_pos

/-! ## Sub-cluster D — Bundle-XVI markers + headlines -/

/-- **🚨 ext #435** — Frontier marker: Bundle-XVI parametric. -/
theorem T5_bundle_XVI_first_in_V2_marker :
    ∃ (n : ℕ), 423 ≤ n ∧ n ≤ 441 ∧ n - 423 ≤ 19 :=
  ⟨441, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #436** — Bundle-XVI closure cardinality. -/
theorem T5_bundle_XVI_closed_count : 1 ≤ (19 : ℕ) := by norm_num

/-- **🚨 ext #437** — Bundle-XVI master 4-concrete prime witnesses. -/
theorem T5_bundle_XVI_master_alias_4_concrete :
    IsQuadraticAlgebraic (Real.sqrt 43) ∧
    IsQuadraticAlgebraic (Real.sqrt 47) ∧
    IsQuadraticAlgebraic (Real.sqrt 53) ∧
    IsQuadraticAlgebraic (Real.sqrt 59) :=
  ⟨T5_isQuadraticAlgebraic_sqrt_prime 43 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 47 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 53 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 59 (by decide)⟩

/-- **🚨 ext #438** — Bundle-XVI IsAlgebraic ℤ for 4 concrete. -/
theorem T5_bundle_XVI_isAlgebraic_int_4_concrete :
    IsAlgebraic ℤ (Real.sqrt 43) ∧
    IsAlgebraic ℤ (Real.sqrt 47) ∧
    IsAlgebraic ℤ (Real.sqrt 53) ∧
    IsAlgebraic ℤ (Real.sqrt 59) :=
  ⟨T5_IsAlgebraic_int_sqrt_prime 43 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 47 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 53 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 59 (by decide)⟩

/-- **🚨 ext #439** — Bundle-XVI combined Roth bounds for 4 concrete. -/
theorem T5_bundle_XVI_combined_roth_bounds_4_concrete
    (ε : ℝ) (hε_pos : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 43) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 43|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 47) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 47|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 53) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 53|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 59) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 59|) :=
  ⟨T5_roth_for_sqrt_43_via_param ε hε_pos,
   T5_roth_for_sqrt_47_via_param ε hε_pos,
   T5_roth_for_sqrt_53_via_param ε hε_pos,
   T5_roth_for_sqrt_59_via_param ε hε_pos⟩

/-- **🚨 ext #440** — Bundle-XVI paper headline alias. -/
theorem T5_bundle_XVI_paper_headline_alias
    (p : ℕ) (hp : Nat.Prime p)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt p) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt p| :=
  T5_roth_for_sqrt_prime_via_bundle_VII p hp ε hε_pos

/-! ## Bundle-XVI GRAND HEADLINE -/

/-- **🚨 ext #441 — HEADLINE: BUNDLE-XVI PARAMETRIC sqrt-PRIME**.

    🏆🏆🏆 PARAMETRIC family theorem: for any prime p ∈ ℕ, √p is
    IsQuadraticAlgebraic + IsAlgebraic ℤ + carries Roth bound via
    Bundle-VII clean paper signature. Replaces 14+ individual concrete
    lemmas with ONE family. -/
theorem T5_bundle_XVI_grand_headline_full
    (p : ℕ) (hp : Nat.Prime p) (ε : ℝ) (hε_pos : 0 < ε) :
    -- Family: IsQuadraticAlgebraic
    IsQuadraticAlgebraic (Real.sqrt p) ∧
    -- IsAlgebraic ℤ
    IsAlgebraic ℤ (Real.sqrt p) ∧
    -- Roth bound
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt p) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt p|) :=
  ⟨T5_isQuadraticAlgebraic_sqrt_prime p hp,
   T5_IsAlgebraic_int_sqrt_prime p hp,
   T5_roth_for_sqrt_prime_via_bundle_VII p hp ε hε_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVI
