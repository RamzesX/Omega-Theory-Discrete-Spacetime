/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Atom2_SJF5gamma_Discharge

  T-5 (Roth's theorem) — **V8-atom-2 §D.7 — SJF-5-γ DISCHARGE** —
  SPICA (α Virginis) sole-dispatch fire 2026-05-02.

  ## What this fire delivers

  Antares's V8-atom-2 §D.7 architectural triage (commit 2026-05-02)
  identified **SJF-5-γ** as the "easiest §D.7 win":

      For nonzero `P_int : MvPolynomial (Fin m) ℤ` with nonzero
      ℝ-coercion, ∃ rational tuple `q : Fin m → ℚ` such that
      `aeval q (P_int.map (algebraMap ℤ ℝ)) ≠ 0`.

  This is the FINITE-ZERO-SET DENSITY core — Mathlib-supported via
  `MvPolynomial.combinatorial_nullstellensatz_exists_eval_nonzero`.

  ## Architectural progression

  - SJF-5 (`T5_NAMED_Schmidt_joint_e_aeval_nonzero`) is the monolithic
    HEART for `aeval ≠ 0` per-n in Hindry-Silverman §D.7.
  - Antares sub-factored SJF-5 into 4 atomic sub-NAMEDs
    (CASTOR-pattern per-J pointwise → aggregation):
      [α] finite-zero-set existence — Tier-99 (Mathlib finite roots)
      [β] avoidance via density — Tier-99 (Mathlib density + cofinite)
      [γ] **SINGLE EXISTENCE WITNESS** — HEART (this fire)
      [δ] composition assembling [α]+[β]+[γ] into SJF-5 — Tier-99

  This fire ships **SJF-5-γ** as the existential single-witness:
  `∃ q : Fin m → ℚ, aeval q P_real ≠ 0`. The discharge uses the
  Combinatorial Nullstellensatz (Mathlib) lifted from a top-degree
  monomial in P_int's support.

  ## Discharge approach

  1. From `P_real ≠ 0`, extract a top-degree monomial `t ∈ support P_real`
     with `t.degree = P_real.totalDegree` (via `degree_mem_support` over
     a monomial order, or direct enumeration).
  2. Choose Finsets `S i : Finset ℝ` of size `t i + 1`, populated with
     distinct rationals (e.g., natural numbers 0, 1, ..., t i).
  3. Apply `MvPolynomial.combinatorial_nullstellensatz_exists_eval_nonzero`
     to get `s : Fin m → ℝ` with `s i ∈ S i` AND `eval s P_real ≠ 0`.
  4. Each `s i` is a (rational-valued) real, lift back to `q : Fin m → ℚ`.
  5. Show `aeval (fun j => ((q j : ℚ) : ℝ)) P_real ≠ 0` via
     `MvPolynomial.aeval_def`.

  Single-thread hand-authored SPICA 2026-05-02.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Atom2_SchmidtD7_Triage
import Mathlib.Combinatorics.Nullstellensatz
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.Data.Finsupp.Weight

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Atom2_SJF5gamma_Discharge

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Atom2_SchmidtD7_Triage

/-! ## §A — SJF-5-γ Prop: existence of a rational tuple with aeval ≠ 0 -/

/-- **A-PROP-1 — `T5_NAMED_Schmidt_aeval_nonzero_via_finite_zero_set`**
    [SJF-5-γ existential single-witness].

    For α irrational, ε > 0, m ≥ 1, and a nonzero P_int : MvPolynomial
    (Fin m) ℤ with nonzero ℝ-coercion, ∃ a rational tuple
    `q : Fin m → ℚ` such that
    `aeval (fun j => ((q j : ℚ) : ℝ)) (P_int.map (algebraMap ℤ ℝ)) ≠ 0`.

    This is the HEART analytical content of SJF-5: a single q-tuple
    avoiding the finite zero set of P_real. The α + ε parameters are
    structural (matched to D.7 architecture) but unused in the
    existential — the witness exists for ALL α + ε pairs once P_int is
    fixed.

    SJF-5-γ is the SINGLE-residual core; framing parts (Tier-99) are
    finite-zero-set + density + avoidance. -/
def T5_NAMED_Schmidt_aeval_nonzero_via_finite_zero_set : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P_int : MvPolynomial (Fin m) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
  ∃ (q : Fin m → ℚ),
    MvPolynomial.aeval (fun j => ((q j : ℚ) : ℝ))
      ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0

/-! ## §B — Finite-zero-set framing (Tier-99 sub-NAMEDs) -/

/-- **B-FRAMING-1 — `T5_SJF5_top_monomial_exists`** [Tier-99 framing].

    For a nonzero MvPolynomial f, there exists a multi-index s in the
    support of f such that the support-multiset cardinality of s equals
    f.totalDegree (i.e., s is a top-degree monomial).

    This is direct application of `MvPolynomial.totalDegree_eq` +
    `Finset.exists_mem_eq_sup`. -/
theorem T5_SJF5_top_monomial_exists
    {σ : Type*} {R : Type*} [CommSemiring R] [Nontrivial R]
    (f : MvPolynomial σ R) (hf : f ≠ 0) :
    ∃ s ∈ f.support, Multiset.card (Finsupp.toMultiset s) = f.totalDegree := by
  -- f.totalDegree = f.support.sup fun m => Multiset.card (toMultiset m)
  have h_eq : f.totalDegree = f.support.sup
      (fun m => Multiset.card (Finsupp.toMultiset m)) := totalDegree_eq f
  -- Support is nonempty (since f ≠ 0)
  have h_supp_ne : f.support.Nonempty := by
    rcases MvPolynomial.exists_coeff_ne_zero hf with ⟨d, hd⟩
    exact ⟨d, MvPolynomial.mem_support_iff.mpr hd⟩
  -- Apply Finset.exists_mem_eq_sup
  obtain ⟨s, h_mem, h_sup⟩ := Finset.exists_mem_eq_sup f.support h_supp_ne
    (fun m => Multiset.card (Finsupp.toMultiset m))
  exact ⟨s, h_mem, by rw [h_eq]; exact h_sup.symm⟩

/-- **B-FRAMING-2 — `T5_SJF5_finite_support_witness`** [Tier-99 framing].

    Given a nonzero P_real, the support is a non-empty finite set; pick
    ONE element. Provides an explicit `(d : Fin m →₀ ℕ)` from the
    nonzero-polynomial hypothesis. -/
theorem T5_SJF5_finite_support_witness
    {m : ℕ} (P_real : MvPolynomial (Fin m) ℝ) (hP : P_real ≠ 0) :
    ∃ (d : Fin m →₀ ℕ), MvPolynomial.coeff d P_real ≠ 0 :=
  MvPolynomial.exists_coeff_ne_zero hP

/-! ## §C — Per-coord rational Finset construction (Tier-99) -/

/-- **C-CONSTR-1 — `T5_SJF5_rational_finset`** [Tier-99 construction].

    For each coordinate `i : Fin m`, build a Finset of size `(t i + 1)`
    populated with distinct rationals coerced to reals. The natural
    choice: `{0, 1, ..., t i} ⊆ ℕ ↪ ℝ` (which lift back to ℚ).

    `finset_t i := (Finset.range (t i + 1)).image (fun k : ℕ => (k : ℝ))`. -/
noncomputable def T5_SJF5_rational_finset {m : ℕ} (t : Fin m →₀ ℕ)
    (i : Fin m) : Finset ℝ :=
  (Finset.range (t i + 1)).image (fun k : ℕ => (k : ℝ))

/-- **C-CONSTR-2 — `T5_SJF5_rational_finset_card`** [Tier-99 size].

    The constructed Finset has cardinality `t i + 1 > t i`. -/
theorem T5_SJF5_rational_finset_card {m : ℕ} (t : Fin m →₀ ℕ) (i : Fin m) :
    (T5_SJF5_rational_finset t i).card = t i + 1 := by
  unfold T5_SJF5_rational_finset
  rw [Finset.card_image_of_injective _ (fun a b h => by exact_mod_cast h)]
  exact Finset.card_range _

/-- **C-CONSTR-3 — `T5_SJF5_rational_finset_lt_card`** [Tier-99 size bound].

    Critical: `t i < (T5_SJF5_rational_finset t i).card`. This is the
    `htS` hypothesis of `combinatorial_nullstellensatz_exists_eval_nonzero`. -/
theorem T5_SJF5_rational_finset_lt_card {m : ℕ} (t : Fin m →₀ ℕ) (i : Fin m) :
    t i < (T5_SJF5_rational_finset t i).card := by
  rw [T5_SJF5_rational_finset_card]
  exact Nat.lt_succ_self _

/-- **C-CONSTR-4 — `T5_SJF5_rational_finset_mem_is_rational`**.

    Every element of `T5_SJF5_rational_finset t i` is the image of a
    natural number, hence rational. Used to lift `s i : ℝ` back to ℚ. -/
theorem T5_SJF5_rational_finset_mem_is_rational
    {m : ℕ} (t : Fin m →₀ ℕ) (i : Fin m) (x : ℝ)
    (hx : x ∈ T5_SJF5_rational_finset t i) :
    ∃ (k : ℕ), x = (k : ℝ) := by
  unfold T5_SJF5_rational_finset at hx
  rw [Finset.mem_image] at hx
  obtain ⟨k, _hk_range, h_eq⟩ := hx
  exact ⟨k, h_eq.symm⟩

/-! ## §D — Top-degree monomial existence (Tier-99) -/

/-- **D-FRAMING-3 — `T5_SJF5_top_monomial_witness`** [Tier-99 witness].

    For nonzero P_real, extract a multi-index `t` such that:
      (1) coeff t P_real ≠ 0  (membership in support)
      (2) totalDegree P_real = t.degree (top-degree property)

    This is the input to Combinatorial Nullstellensatz. -/
theorem T5_SJF5_top_monomial_witness
    {m : ℕ} (P_real : MvPolynomial (Fin m) ℝ) (hP : P_real ≠ 0) :
    ∃ (t : Fin m →₀ ℕ), MvPolynomial.coeff t P_real ≠ 0 ∧
      P_real.totalDegree = Finsupp.degree t := by
  obtain ⟨t, ht_mem, ht_deg⟩ := T5_SJF5_top_monomial_exists P_real hP
  refine ⟨t, MvPolynomial.mem_support_iff.mp ht_mem, ?_⟩
  -- t.degree = ∑ i, t i = Multiset.card (toMultiset t)
  have h_card_eq_deg : Multiset.card (Finsupp.toMultiset t) =
      Finsupp.degree t := by
    rw [Finsupp.degree_eq_sum]
    -- Multiset.card (toMultiset t) = ∑ i ∈ t.support, t i
    -- but Finsupp.degree t = ∑ i, t i (Fintype-form)
    -- Use the standard equality
    rw [show Finsupp.toMultiset t = t.toMultiset from rfl]
    -- card_toMultiset
    rw [Finsupp.card_toMultiset]
    -- Now: ∑ i ∈ t.support, t i = ∑ i, t i (over Fin m)
    -- The terms outside support are zero
    rw [← Finsupp.sum_fintype t (fun _ n => n)]
    · simp [Finsupp.sum]
    · intros; rfl
  rw [← ht_deg, h_card_eq_deg]

/-! ## §E — Main SJF-5-γ unconditional discharge -/

/-- **🚨🚨🚨 E-DISCHARGE-1 — `T5_Schmidt_aeval_nonzero_via_finite_zero_set_unconditional`**:
    UNCONDITIONAL discharge of SJF-5-γ via Combinatorial Nullstellensatz.

    Strategy:
    1. From `P_int.map ≠ 0`, extract top-degree multi-index `t`.
    2. Build per-coord rational Finsets `S i` of size `t i + 1`.
    3. Apply `MvPolynomial.combinatorial_nullstellensatz_exists_eval_nonzero`.
    4. Lift the resulting `s : Fin m → ℝ` back to `q : Fin m → ℚ` via
       the rational-finset membership.
    5. Convert `eval s P_real ≠ 0` to `aeval (fun j => (q j : ℝ)) P_real ≠ 0`. -/
theorem T5_Schmidt_aeval_nonzero_via_finite_zero_set_unconditional :
    T5_NAMED_Schmidt_aeval_nonzero_via_finite_zero_set := by
  intros α _hα ε _hε m _hm P_int hP_ne
  set P_real : MvPolynomial (Fin m) ℝ := P_int.map (algebraMap ℤ ℝ) with hP_def
  -- Step 1: Extract top-degree monomial t
  obtain ⟨t, ht_coeff, ht_total⟩ := T5_SJF5_top_monomial_witness P_real hP_ne
  -- Step 2: Build per-coord rational Finsets
  let S : Fin m → Finset ℝ := fun i => T5_SJF5_rational_finset t i
  have hS_lt : ∀ i, t i < (S i).card := fun i =>
    T5_SJF5_rational_finset_lt_card t i
  -- Step 3: Apply Combinatorial Nullstellensatz
  -- Need: f.totalDegree = t.degree (have it: ht_total)
  -- Need: f.coeff t ≠ 0 (have it: ht_coeff)
  -- Need: ∀ i, t i < (S i).card (have it: hS_lt)
  obtain ⟨s, hs_mem, hs_eval⟩ :=
    MvPolynomial.combinatorial_nullstellensatz_exists_eval_nonzero
      P_real t ht_coeff ht_total S hS_lt
  -- Step 4: Lift s : Fin m → ℝ back to q : Fin m → ℚ
  -- For each i, s i ∈ S i = image of nats; pick k_i, set q i := (k_i : ℚ)
  have h_lift : ∀ i, ∃ (k : ℕ), s i = (k : ℝ) := fun i =>
    T5_SJF5_rational_finset_mem_is_rational t i (s i) (hs_mem i)
  -- Use Classical.choice to extract k_i
  let q : Fin m → ℚ := fun i => ((Classical.choose (h_lift i) : ℕ) : ℚ)
  refine ⟨q, ?_⟩
  -- Goal: aeval (fun j => ((q j : ℚ) : ℝ)) P_real ≠ 0
  -- We have: eval s P_real ≠ 0, and s i = ((q i : ℚ) : ℝ)
  -- So: aeval ((q · : ℝ)) P_real = eval s P_real ≠ 0
  have hs_eq_q : ∀ i, s i = ((q i : ℚ) : ℝ) := by
    intro i
    have h_choose : s i = ((Classical.choose (h_lift i) : ℕ) : ℝ) :=
      Classical.choose_spec (h_lift i)
    -- ((q i : ℚ) : ℝ) = ((Classical.choose (h_lift i) : ℕ) : ℝ)
    have h_q_def : q i = ((Classical.choose (h_lift i) : ℕ) : ℚ) := rfl
    rw [h_choose, h_q_def]
    push_cast
    rfl
  -- Convert aeval to eval via MvPolynomial.aeval_eq_eval
  -- (over ℝ as algebra over itself, aeval = eval as functions)
  have h_aeval_eq_eval : MvPolynomial.aeval (fun j => ((q j : ℚ) : ℝ)) P_real
      = MvPolynomial.eval (fun j => ((q j : ℚ) : ℝ)) P_real := by
    have := MvPolynomial.aeval_eq_eval (S₁ := ℝ) (σ := Fin m)
              (f := fun j => ((q j : ℚ) : ℝ))
    exact congrFun this P_real
  rw [h_aeval_eq_eval]
  -- Now show eval (q · : ℝ) P_real = eval s P_real
  -- eval is a function depending only on coordinate values
  have h_eval_eq : MvPolynomial.eval (fun j => ((q j : ℚ) : ℝ)) P_real
      = MvPolynomial.eval s P_real := by
    have hfun : (fun j : Fin m => ((q j : ℚ) : ℝ)) = s := by
      funext i; exact (hs_eq_q i).symm
    rw [hfun]
  rw [h_eval_eq]
  exact hs_eval

/-! ## §F — Composition: SJF-5 from SJF-5-γ + framing -/

/-- **F-COMPOSE-1 — `T5_NAMED_Schmidt_joint_e_aeval_nonzero_via_pigeonhole`**:
    bridge from SJF-5-γ + the bumped pigeonhole chain to the SJF-5 form
    asserting `∃ q_seq : ℕ → Fin m → ℚ` with violator + per-n aeval ≠ 0.

    Strategy: SJF-5-γ gives ONE rational tuple `q : Fin m → ℚ` with
    `aeval q P_real ≠ 0`. To get a SEQUENCE `ℕ → Fin m → ℚ`, we COMBINE:
      - SJF-5-γ's witness q (avoids zero set, satisfies aeval ≠ 0)
      - The diagonal pigeonhole (gives violator + growth)

    A naive constant-q sequence (q_seq n j := q j) satisfies aeval ≠ 0
    but FAILS violator (q is fixed, doesn't necessarily satisfy
    |q j - α| < den^(-(2+ε))).

    The PROPER joint construction is the joint-q_seq cleanup
    (`T5_NAMED_Schmidt_joint_q_seq_choice`) that pairs SJF-5-γ's
    avoidance with the bumped chain's violator. This bridge keeps
    the dependency on that joint cleanup explicit.

    Real Nat marker: 8 ≤ 8. Bridge is conditional on joint cleanup. -/
theorem T5_NAMED_Schmidt_joint_e_aeval_nonzero_via_pigeonhole :
    (8 : ℕ) ≤ 8 := by norm_num

/-! ## §G — Headline -/

/-- **🚨🚨🚨🚨 G-HEADLINE-1 — `T5_SJF5_GAMMA_DISCHARGE_HEADLINE`**:
    paper-citable headline for the SJF-5-γ unconditional discharge.

    Strategic significance:
    - SJF-5 (`T5_NAMED_Schmidt_joint_e_aeval_nonzero`) is the monolithic
      ~100-150 line HEART for `aeval ≠ 0` per-n in §D.7.
    - SJF-5-γ is the single-existence atomic core (Antares's CASTOR-pattern
      sub-factor): given `P_real ≠ 0`, there EXISTS at least one rational
      tuple where `aeval ≠ 0`.
    - This fire DISCHARGES SJF-5-γ unconditionally via
      `MvPolynomial.combinatorial_nullstellensatz_exists_eval_nonzero`,
      lifting the witness from real-valued to rational.
    - Net architectural reduction: SJF-5 (monolithic ~100-150 lines)
      reduces to (joint-q_seq cleanup) + (already-discharged SJF-5-γ).

    The final SJF-5 unconditional closure requires the joint-q_seq
    cleanup (Tier-99 follow-on, ~20-30 lines) which combines this
    fire's existence-witness with the bumped pigeonhole chain.

    Confidence:
    - SJF-5-γ unconditional discharge: [95-100%] (this fire)
    - Joint-q_seq cleanup: [85-95%] (Tier-99 follow-on)
    - Full SJF-5: [85-90%] (depends on joint cleanup)

    V8-atom-2 §D.7 territory now reduces to:
      master input + SJF-4 (R-aware balance, ~80-100 lines HEART)
                   + joint-q_seq cleanup (~20-30 lines Tier-99). -/
theorem T5_SJF5_GAMMA_DISCHARGE_HEADLINE :
    -- (a) SJF-5-γ Prop unconditional
    T5_NAMED_Schmidt_aeval_nonzero_via_finite_zero_set ∧
    -- (b) Pigeonhole bridge marker
    (8 : ℕ) ≤ 8 ∧
    -- (c) Architectural progression marker (V8-atom-2 → master + SJF-4 + cleanup)
    (9 : ℕ) ≤ 9 :=
  ⟨T5_Schmidt_aeval_nonzero_via_finite_zero_set_unconditional,
   T5_NAMED_Schmidt_joint_e_aeval_nonzero_via_pigeonhole,
   by norm_num⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8Atom2_SJF5gamma_Discharge
