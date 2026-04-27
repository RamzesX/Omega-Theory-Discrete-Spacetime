/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAnalyticalBoundCombined

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 19 — combined
  analytical bound + nonzero-witness → False under L-W setup.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  CONDITIONAL on the orbit-product expansion identity, derives False
  from the L-W chain.  Built in three layers:

  Layer 1: `exists_prime_with_decay` — existence of prime p with both
    threshold AND analytic-bound `<1`.

  Layer 2: `lw_J_integer_construction` — for any prime p > threshold,
    construct the integer J = -m·n_p·D^{deg gp_p} - p·M_int with
    (a) J ≠ 0 via s18, (b) J : ℂ = D^{deg gp_p} · orbit-sum-residual.

  Layer 3: `lw_chain_derives_false` — chain Layer 1 + Layer 2 + analytic
    bound + |J| ≥ 1 to derive False.

  ## Honest narrower-true scope

  CONDITIONAL on `h_sum_exp_eq_neg_m` (subset-multiplicity orbit-product
  identity).  The hypothesis is a NAMED real Prop used non-vacuously —
  per NO-STUBS rule §3.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofWitnessNonzeroModPrime
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultiRootSum
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofExpPolyAtIPi
import Mathlib.NumberTheory.Transcendental.Lindemann.AnalyticalPart

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAnalyticalBoundCombined

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofWitnessNonzeroModPrime
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultiRootSum

/-! ## Layer 1 — Existence of large prime with decay-bound -/

/-- For threshold `T`, orbit_card, and any real `c`, there exists a prime
    `p > T` with `orbit_card * c^p / (p-1)! < 1`.  Uses s8 decay
    (`orbit_sum_bound_tendsto_zero`) + filter eventually-lt + infinite primes. -/
theorem exists_prime_with_decay
    (T : ℕ) (orbit_card : ℕ) (c : ℝ) :
    ∃ p : ℕ, p.Prime ∧ p > T ∧
      (orbit_card : ℝ) * c ^ p / ((p - 1).factorial : ℝ) < 1 := by
  have h_decay : Filter.Tendsto
      (fun p : ℕ => (orbit_card : ℝ) * c ^ p / ((p - 1).factorial : ℝ))
      Filter.atTop (nhds 0) :=
    orbit_sum_bound_tendsto_zero orbit_card c
  have h_eventually : ∀ᶠ p in Filter.atTop,
      (orbit_card : ℝ) * c ^ p / ((p - 1).factorial : ℝ) < 1 :=
    h_decay.eventually_lt_const zero_lt_one
  rw [Filter.eventually_atTop] at h_eventually
  obtain ⟨N₀, hN₀⟩ := h_eventually
  obtain ⟨p, h_le_p, h_prime⟩ := Nat.exists_infinite_primes (max T N₀ + 1)
  refine ⟨p, h_prime, ?_, ?_⟩
  · have h_max_ge : max T N₀ ≥ T := le_max_left _ _
    omega
  · apply hN₀
    have h_max_ge : max T N₀ ≥ N₀ := le_max_right _ _
    omega

/-! ## Layer 2 — Multiset linearity helper -/

private theorem multiset_sum_map_sub
    (s : Multiset ℂ) (f g : ℂ → ℂ) :
    (s.map (fun r => f r - g r)).sum = (s.map f).sum - (s.map g).sum := by
  induction s using Multiset.induction with
  | empty => simp
  | cons a s ih =>
      simp only [Multiset.map_cons, Multiset.sum_cons, ih]
      ring

/-! ## Layer 3 — Combined False derivation under L-W setup -/

/-- **Wave T4b session 19 — derive False from L-W setup**.

    Given the orbit-product identity `((h.aroots ℂ).map exp).sum = -m`
    for `h : ℤ[X]` with `h ≠ 0` and `h.eval 0 ≠ 0`, derive False. -/
theorem lw_chain_derives_false
    (h : Polynomial ℤ) (h_ne : h ≠ 0) (h_eval0_ne : Polynomial.eval 0 h ≠ 0)
    (m : ℕ) (h_m_pos : 0 < m)
    (h_sum_exp_eq_neg_m :
        ((h.aroots ℂ).map Complex.exp).sum = -(m : ℂ)) :
    False := by
  set D : ℤ := h.leadingCoeff with h_D_def
  have h_D_ne : D ≠ 0 := Polynomial.leadingCoeff_ne_zero.mpr h_ne
  have h_card : (h.aroots ℂ).card = h.natDegree :=
    aroots_card_eq_natDegree_general h h_ne
  -- aroots empty case derives False directly
  rcases Multiset.empty_or_exists_mem (h.aroots ℂ) with h_empty | ⟨r₀, hr₀⟩
  · rw [h_empty] at h_sum_exp_eq_neg_m
    simp at h_sum_exp_eq_neg_m
    -- h_sum_exp_eq_neg_m at this point: m = 0 (ℕ form) after simp's handling
    omega
  -- Now h.aroots ℂ is nonempty
  obtain ⟨c, hc⟩ := LindemannWeierstrass.exp_polynomial_approx h h_eval0_ne
  let c' : ℝ := (D.natAbs : ℝ) ^ h.natDegree * c
  let T : ℕ := max (max (Polynomial.eval 0 h).natAbs m) (max D.natAbs h.natDegree)
  obtain ⟨p, h_prime, h_p_gt_T, h_bound_lt_1⟩ :=
    exists_prime_with_decay T h.natDegree c'
  have h_p_gt_eval0 : p > (Polynomial.eval 0 h).natAbs := by
    have : T ≥ (Polynomial.eval 0 h).natAbs := le_max_of_le_left (le_max_left _ _)
    omega
  have h_p_gt_m : p > m := by
    have : T ≥ m := le_max_of_le_left (le_max_right _ _)
    omega
  have h_p_gt_D : p > D.natAbs := by
    have : T ≥ D.natAbs := le_max_of_le_right (le_max_left _ _)
    omega
  obtain ⟨n_p, h_n_ne_p, gp_p, h_gp_deg, h_per_root⟩ := hc p h_p_gt_eval0 h_prime
  obtain ⟨M_int, hM_int⟩ :=
    aroots_aeval_sum_D_scaled_is_integer h h_ne gp_p
  -- The integer J
  let J : ℤ := -(m : ℤ) * n_p * D ^ gp_p.natDegree - (p : ℤ) * M_int
  -- J ≠ 0 by s18
  have h_J_ne : J ≠ 0 :=
    witness_nonzero_mod_prime p h_prime m h_m_pos h_p_gt_m
      n_p h_n_ne_p D h_p_gt_D h_D_ne gp_p.natDegree M_int
  -- |J:ℝ| ≥ 1
  have h_J_abs_ge_1 : (1 : ℝ) ≤ |(J : ℝ)| := by
    rw [← Int.cast_abs]
    exact_mod_cast Int.one_le_abs h_J_ne
  -- (J : ℂ) = D^{deg gp_p} * (n_p · (-m) - p · ∑_r aeval r gp_p)
  have h_J_complex : (J : ℂ) =
      (D : ℂ) ^ gp_p.natDegree *
        ((n_p : ℂ) * (-(m : ℂ)) - (p : ℂ) * ((h.aroots ℂ).map
          (fun r => Polynomial.aeval r gp_p)).sum) := by
    simp only [J]
    push_cast
    have h_step := hM_int
    -- hM_int : (D : ℂ) ^ gp_p.natDegree * sum = (M_int : ℂ)
    linear_combination (p : ℂ) * h_step
  -- Multiset.sum of per-root residuals
  have h_orbit_residual_eq :
      ((h.aroots ℂ).map (fun r =>
        (n_p : ℂ) * Complex.exp r - (p : ℂ) * Polynomial.aeval r gp_p)).sum
      = (n_p : ℂ) * (-(m : ℂ)) - (p : ℂ) * ((h.aroots ℂ).map
          (fun r => Polynomial.aeval r gp_p)).sum := by
    rw [multiset_sum_map_sub]
    have h_lhs : ((h.aroots ℂ).map (fun r => (n_p : ℂ) * Complex.exp r)).sum
              = (n_p : ℂ) * ((h.aroots ℂ).map Complex.exp).sum := by
      rw [Multiset.sum_map_mul_left]
    have h_rhs : ((h.aroots ℂ).map (fun r => (p : ℂ) * Polynomial.aeval r gp_p)).sum
              = (p : ℂ) * ((h.aroots ℂ).map (fun r => Polynomial.aeval r gp_p)).sum := by
      rw [Multiset.sum_map_mul_left]
    rw [h_lhs, h_rhs, h_sum_exp_eq_neg_m]
  -- Per-root bound from exp_polynomial_approx, in (n : ℂ) * z form
  have h_per_root_mul : ∀ r ∈ h.aroots ℂ,
      ‖(n_p : ℂ) * Complex.exp r - (p : ℂ) * Polynomial.aeval r gp_p‖
        ≤ c ^ p / ((p - 1).factorial : ℝ) := by
    intros r hr
    have hr_bound := h_per_root hr
    rwa [zsmul_eq_mul, nsmul_eq_mul] at hr_bound
  -- The orbit-residual norm bound
  have h_residual_norm_bound :
      ‖((h.aroots ℂ).map (fun r =>
        (n_p : ℂ) * Complex.exp r - (p : ℂ) * Polynomial.aeval r gp_p)).sum‖
        ≤ ((h.aroots ℂ).card : ℝ) * (c ^ p / ((p - 1).factorial : ℝ)) := by
    have h_cp_nonneg : 0 ≤ c ^ p / ((p - 1).factorial : ℝ) :=
      le_trans (norm_nonneg _) (h_per_root_mul r₀ hr₀)
    exact norm_multiset_sum_le_card_mul_bound (h.aroots ℂ)
      (fun r => (n_p : ℂ) * Complex.exp r - (p : ℂ) * Polynomial.aeval r gp_p)
      _ h_cp_nonneg h_per_root_mul
  -- Use h_orbit_residual_eq to substitute
  rw [h_orbit_residual_eq] at h_residual_norm_bound
  -- Compute ‖(J : ℂ)‖
  have h_J_norm_eq : ‖(J : ℂ)‖ =
      (D.natAbs : ℝ) ^ gp_p.natDegree *
      ‖(n_p : ℂ) * (-(m : ℂ)) - (p : ℂ) * ((h.aroots ℂ).map
        (fun r => Polynomial.aeval r gp_p)).sum‖ := by
    rw [h_J_complex, norm_mul, norm_pow]
    have h_D_norm : ‖(D : ℂ)‖ = (D.natAbs : ℝ) := by
      rw [Complex.norm_intCast]
      exact_mod_cast (Nat.cast_natAbs D).symm
    rw [h_D_norm]
  -- Combined bound
  have h_J_norm_bound : ‖(J : ℂ)‖ ≤
      (D.natAbs : ℝ) ^ gp_p.natDegree *
      (((h.aroots ℂ).card : ℝ) * (c ^ p / ((p - 1).factorial : ℝ))) := by
    rw [h_J_norm_eq]
    apply mul_le_mul_of_nonneg_left h_residual_norm_bound
    positivity
  -- |D|^{deg gp_p} ≤ (|D|^{natDeg})^p (since |D| ≥ 1, deg gp_p ≤ p · natDeg)
  have h_D_natAbs_ge_1 : (1 : ℝ) ≤ (D.natAbs : ℝ) := by
    have h_one_le : 1 ≤ D.natAbs := Int.natAbs_pos.mpr h_D_ne
    exact_mod_cast h_one_le
  have h_deg_le : gp_p.natDegree ≤ p * h.natDegree := by
    by_cases hp_natDeg_zero : p * h.natDegree = 0
    · rw [hp_natDeg_zero] at h_gp_deg ⊢
      omega
    · omega
  have h_D_pow_le : (D.natAbs : ℝ) ^ gp_p.natDegree ≤
      ((D.natAbs : ℝ) ^ h.natDegree) ^ p := by
    rw [← pow_mul]
    apply pow_le_pow_right₀ h_D_natAbs_ge_1
    linarith [h_deg_le]
  -- ‖(J:ℂ)‖ < 1
  have h_J_lt_1 : ‖(J : ℂ)‖ < 1 := by
    apply lt_of_le_of_lt h_J_norm_bound
    rw [h_card]
    have h_cp_nonneg : 0 ≤ c ^ p / ((p - 1).factorial : ℝ) :=
      le_trans (norm_nonneg _) (h_per_root_mul r₀ hr₀)
    have h_natDeg_nonneg : (0 : ℝ) ≤ (h.natDegree : ℝ) := Nat.cast_nonneg _
    calc (D.natAbs : ℝ) ^ gp_p.natDegree *
          ((h.natDegree : ℝ) * (c ^ p / ((p - 1).factorial : ℝ)))
        ≤ ((D.natAbs : ℝ) ^ h.natDegree) ^ p *
          ((h.natDegree : ℝ) * (c ^ p / ((p - 1).factorial : ℝ))) :=
        mul_le_mul_of_nonneg_right h_D_pow_le
          (mul_nonneg h_natDeg_nonneg h_cp_nonneg)
      _ = (h.natDegree : ℝ) * c' ^ p / ((p - 1).factorial : ℝ) := by
            show ((D.natAbs : ℝ) ^ h.natDegree) ^ p *
              ((h.natDegree : ℝ) * (c ^ p / ((p - 1).factorial : ℝ)))
              = (h.natDegree : ℝ) *
                (((D.natAbs : ℝ) ^ h.natDegree * c) ^ p) /
                ((p - 1).factorial : ℝ)
            rw [mul_pow]; ring
      _ < 1 := h_bound_lt_1
  -- |J:ℝ| = ‖(J:ℂ)‖ — relate them via Real.norm and Int cast
  have h_J_real_lt_1 : |(J : ℝ)| < 1 := by
    have h_eq : |(J : ℝ)| = ‖(J : ℂ)‖ := by
      rw [Complex.norm_intCast]
    rw [h_eq]
    exact h_J_lt_1
  linarith [h_J_abs_ge_1, h_J_real_lt_1]

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAnalyticalBoundCombined
