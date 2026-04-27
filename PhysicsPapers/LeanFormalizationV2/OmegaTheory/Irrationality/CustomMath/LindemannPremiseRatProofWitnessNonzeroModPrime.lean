/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofWitnessNonzeroModPrime

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 18 — modular-
  arithmetic non-zero-mod-p witness theorem.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Provides the modular-arithmetic core of the L-W contradiction-integer
  non-zero argument:

  Given prime `p` larger than `m`, `|n|`, and `|D|`, and `¬ p ∣ n`:
  the integer `N := -m·n·D^k - p·M` is non-zero (modulo p, hence in ℤ).

  This is the Fermat-style argument that forces `J_p ≠ 0` in the Lindemann-
  Weierstrass contradiction integer construction: the second term `p·M`
  vanishes mod p, leaving the first term `-m·n·D^k` whose factors are all
  non-zero mod p (under the threshold hypotheses).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Field.ZMod

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofWitnessNonzeroModPrime

/-! ## Step 1 — Helper: |D| < p ∧ D ≠ 0 → D ≢ 0 (mod p) -/

/-- Helper: if `|D|.natAbs < p` and `D ≠ 0`, then `(D : ZMod p) ≠ 0`. -/
private theorem D_nonzero_zmod
    (p : ℕ) [Fact p.Prime]
    (D : ℤ) (h_D_lt : D.natAbs < p) (h_D_ne : D ≠ 0) :
    ((D : ℤ) : ZMod p) ≠ 0 := by
  intro h_eq
  have h_dvd : (p : ℤ) ∣ D := (ZMod.intCast_zmod_eq_zero_iff_dvd D p).mp h_eq
  have h_p_le : (p : ℤ).natAbs ≤ D.natAbs :=
    Int.natAbs_le_of_dvd_ne_zero h_dvd h_D_ne
  have h_p_eq : (p : ℤ).natAbs = p := Int.natAbs_natCast p
  rw [h_p_eq] at h_p_le
  exact absurd h_p_le (Nat.not_le.mpr h_D_lt)

/-- Helper: if `0 < m` and `m < p`, then `((m : ℕ) : ZMod p) ≠ 0`. -/
private theorem m_nonzero_zmod
    (p : ℕ) (m : ℕ) (h_m_pos : 0 < m) (h_m_lt : m < p) :
    ((m : ℕ) : ZMod p) ≠ 0 := by
  intro h_eq
  have h_dvd : p ∣ m := (ZMod.natCast_eq_zero_iff m p).mp h_eq
  have h_p_le : p ≤ m := Nat.le_of_dvd h_m_pos h_dvd
  exact absurd h_p_le (Nat.not_le.mpr h_m_lt)

/-- Helper: if `¬ (p : ℤ) ∣ n`, then `(n : ZMod p) ≠ 0`. -/
private theorem n_nonzero_zmod
    (p : ℕ) (n : ℤ) (h_n_ne : ¬ (p : ℤ) ∣ n) :
    ((n : ℤ) : ZMod p) ≠ 0 := by
  intro h_eq
  exact h_n_ne ((ZMod.intCast_zmod_eq_zero_iff_dvd n p).mp h_eq)

/-! ## Step 2 — Main theorem -/

/-- **Witness non-zero mod prime**: For prime `p`, integer `m > 0` with `m < p`,
    integer `n` with `¬ p ∣ n`, integer `D ≠ 0` with `|D|.natAbs < p`, and any
    natural `k` and integer `M`:
    `-m·n·D^k - p·M ≠ 0`.

    Proof: in `ZMod p`:
    - `-m·n·D^k - p·M ≡ -m·n·D^k (mod p)` (since `p ≡ 0 mod p`)
    - `m, n, D ≢ 0 (mod p)` by helpers
    - `D^k ≢ 0 (mod p)` since `D ≢ 0` and `ZMod p` is integral domain
    - Product `m · n · D^k ≢ 0 (mod p)` -/
theorem witness_nonzero_mod_prime
    (p : ℕ) (h_prime : p.Prime)
    (m : ℕ) (h_m_pos : 0 < m) (h_m_lt : m < p)
    (n : ℤ) (h_n_ne : ¬ (p : ℤ) ∣ n)
    (D : ℤ) (h_D_lt : D.natAbs < p) (h_D_ne : D ≠ 0)
    (k : ℕ) (M : ℤ) :
    (- (m : ℤ) * n * D ^ k - (p : ℤ) * M) ≠ 0 := by
  haveI : Fact p.Prime := ⟨h_prime⟩
  intro h_zero
  -- Cast to ZMod p
  have h_zmod : ((- (m : ℤ) * n * D ^ k - (p : ℤ) * M : ℤ) : ZMod p) = 0 := by
    rw [h_zero]; simp
  -- Distribute casts
  simp only [Int.cast_sub, Int.cast_mul, Int.cast_neg, Int.cast_natCast] at h_zmod
  -- h_zmod : -↑m * ↑n * ↑D^k - ↑p * ↑M = 0  (in ZMod p)
  -- (p : ZMod p) = 0 via ZMod.natCast_self
  rw [show ((p : ℕ) : ZMod p) = 0 from ZMod.natCast_self p] at h_zmod
  -- h_zmod : -↑m * ↑n * ↑D^k - 0 * ↑M = 0
  simp at h_zmod
  -- h_zmod : ↑m * ↑n * ↑D^k = 0  or -↑m * ↑n * ↑D^k = 0
  -- Each factor is non-zero in ZMod p
  have h_m_zmod : ((m : ℕ) : ZMod p) ≠ 0 := m_nonzero_zmod p m h_m_pos h_m_lt
  have h_n_zmod : ((n : ℤ) : ZMod p) ≠ 0 := n_nonzero_zmod p n h_n_ne
  have h_D_zmod : ((D : ℤ) : ZMod p) ≠ 0 := D_nonzero_zmod p D h_D_lt h_D_ne
  have h_Dk_zmod : ((D : ℤ) : ZMod p) ^ k ≠ 0 := pow_ne_zero k h_D_zmod
  -- Product non-zero in ZMod p
  -- After simp, h_zmod is decomposed into disjunctions automatically
  rcases h_zmod with (h_m_or_n | h_D_and)
  · rcases h_m_or_n with h_m | h_n
    · exact absurd h_m h_m_zmod
    · exact absurd h_n h_n_zmod
  · exact absurd h_D_and.1 h_D_zmod

/-! ## Variants and bridge to integer_bound_contradiction (s2) -/

/-- **Bridge to integer-bound contradiction (s2)**: combine the non-zero
    mod-p witness with an analytic bound `|N| < B` and `B ≤ 1` to get
    `False` via `integer_bound_contradiction`. -/
theorem witness_bound_combined_to_false
    (p : ℕ) (h_prime : p.Prime)
    (m : ℕ) (h_m_pos : 0 < m) (h_m_lt : m < p)
    (n : ℤ) (h_n_ne : ¬ (p : ℤ) ∣ n)
    (D : ℤ) (h_D_lt : D.natAbs < p) (h_D_ne : D ≠ 0)
    (k : ℕ) (M : ℤ)
    (B : ℝ) (h_abs : |((- (m : ℤ) * n * D ^ k - (p : ℤ) * M : ℤ) : ℝ)| < B)
    (h_B : B ≤ 1) :
    False := by
  apply OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofStructural.integer_bound_contradiction
    (- (m : ℤ) * n * D ^ k - (p : ℤ) * M) B h_abs h_B
  exact witness_nonzero_mod_prime p h_prime m h_m_pos h_m_lt n h_n_ne D h_D_lt h_D_ne k M

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 18 modular-arithmetic non-zero witness**.

    Single 2-conjunct stating:
      1. The non-zero mod-p witness theorem (raw form).
      2. The combined bound→False bridge.

    `#print axioms` returns Lean-core only.  Zero project axioms touched. -/
theorem session_18_witness_nonzero_mod_prime_headline :
    (∀ (p : ℕ), p.Prime →
      ∀ (m : ℕ), 0 < m → m < p →
      ∀ (n : ℤ), ¬ (p : ℤ) ∣ n →
      ∀ (D : ℤ), D.natAbs < p → D ≠ 0 →
      ∀ (k : ℕ) (M : ℤ),
        (- (m : ℤ) * n * D ^ k - (p : ℤ) * M) ≠ 0)
    ∧ (∀ (p : ℕ), p.Prime →
        ∀ (m : ℕ), 0 < m → m < p →
        ∀ (n : ℤ), ¬ (p : ℤ) ∣ n →
        ∀ (D : ℤ), D.natAbs < p → D ≠ 0 →
        ∀ (k : ℕ) (M : ℤ) (B : ℝ),
          |((- (m : ℤ) * n * D ^ k - (p : ℤ) * M : ℤ) : ℝ)| < B →
          B ≤ 1 →
          False) := by
  refine ⟨?_, ?_⟩
  · exact witness_nonzero_mod_prime
  · exact witness_bound_combined_to_false

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofWitnessNonzeroModPrime
