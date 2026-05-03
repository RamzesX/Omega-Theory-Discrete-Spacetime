/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_KappaFormulaValid_Discharge

  T-5 (Roth's theorem) — **κ-FORMULA-VALID DISCHARGE BRIDGE** (BHARANI Wave 1).

  Wizard: BHARANI (41 Arietis — second lunar mansion).

  Mission target: discharge `T5_NAMED_kappa_formula_valid` for the V7-N1-uniform
  decomposition (Block C, V7N1U-D1).

  ## Strategic finding — STATE (C) INLINE-ALREADY-DISCHARGED

  Phase 0 graph + corpus audit identified that
    `T5_NAMED_kappa_formula_valid_unconditional`
  is ALREADY UNCONDITIONALLY DISCHARGED in
    `T5_Phase7_RothLeafNAMEDProps_AllDischarges.lean`
  (line 138-194), and bundled into the partial leaf headline at line 209.

  Per BOOK_VII / NO_NEW_UNDISCHARGED_LEAVES_T6_10 doctrine:
    state (C) "already closed elsewhere; ship inline theorems wiring downstream
    chains to use the existing closure" is the correct termination.

  ## What this file ships (Pollux-style bridge + Type-(a) standalone variants)

  1. `T5_BHARANI_kappa_formula_valid_alias` — paper-citable alias under a
     V7N1U-aware short name (downstream chains can import this file alone
     without pulling the full LeafNAMEDProps_AllDischarges bundle).

  2. `T5_BHARANI_kappa_witness_for` — Type-(a) standalone constructor:
     given ε > 0 and m > ⌈16(2+ε)²/ε⌉, exhibits the explicit κ as a Σ-type
     witness `{κ : ℝ // 1 < κ ∧ κ = (2+ε)·(m/2 − 2√(mε))/m}`. Paper-citable
     in isolation; eliminates the need to re-unpack the universal Prop.

  3. `T5_BHARANI_kappa_witness_at_eps_one_m_two_hundred` — concrete numerical
     witness at ε = 1, m = 200 (sample point above threshold 16·9 = 144).
     Paper-citable existence demonstration of a Type-(a) closed-form value.

  4. `T5_BHARANI_kappa_threshold_explicit` — closed-form threshold function
     ε ↦ ⌈16(2+ε)²/ε⌉, exposed for downstream use.

  ## Audit (per `antipattern_literal_false_p_eq_1`)

  | Variant probed         | Result                                            |
  |------------------------|---------------------------------------------------|
  | ε = 1, m = 145         | κ ≈ 1.00172 > 1 ✓                                 |
  | ε = 1, m = 200         | κ ≈ 1.076 > 1 ✓                                   |
  | ε small (0.01), thresh | m_thresh = ⌈16·4.0401/0.01⌉ = 6465; m = 6500 → ✓  |
  | ε large (100), thresh  | m_thresh = ⌈16·10404/100⌉ = 1665; m = 2000 → ✓    |

  All probes positive — formula NOT literal-false; existing discharge
  algebra is valid.

  ## Build delta

  Baseline: 2433 jobs GREEN (existing AllDischarges file).
  New jobs from this file: only this module (downstream Pollux-style alias).

  Single-thread hand-authored 2026-05-03.
  Per project rule §7.0 NO STUBS — Pollux pattern, no new residual leaves.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_KappaFormulaValid_Discharge

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1UniformDecomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLeafNAMEDProps_AllDischarges

/-! ## (1) Pollux-style alias — V7N1U-D1 κ formula UNCONDITIONALLY -/

/-- **BHARANI-α — `T5_BHARANI_kappa_formula_valid_alias`**:
    Pollux-style alias for the existing unconditional discharge.

    Downstream chains (V7N1U-D5 composition, Block C Taylor upper bound)
    can `apply` this directly without pulling the wider LeafNAMEDProps
    bundle. Same content as `T5_NAMED_kappa_formula_valid_unconditional`,
    re-exported under a wave-named short alias. -/
theorem T5_BHARANI_kappa_formula_valid_alias :
    T5_NAMED_kappa_formula_valid :=
  T5_NAMED_kappa_formula_valid_unconditional

/-! ## (2) Type-(a) standalone witness constructor -/

/-- **BHARANI-β — `T5_BHARANI_kappa_threshold_explicit`**:
    explicit closed-form threshold ε ↦ ⌈16(2+ε)²/ε⌉.

    This is the witness that the universal `T5_NAMED_kappa_formula_valid`
    instantiates for `m_threshold`. Exposed standalone for paper citation
    and downstream specialization. -/
noncomputable def T5_BHARANI_kappa_threshold_explicit (ε : ℝ) : ℕ :=
  Nat.ceil (16 * (2 + ε)^2 / ε)

/-- **BHARANI-γ — `T5_BHARANI_kappa_witness_for`**:
    Type-(a) standalone Σ-type constructor for the κ witness.

    For ε > 0 and m strictly above the explicit threshold
    `⌈16(2+ε)²/ε⌉`, exhibits `κ : ℝ` together with a proof that
    1 < κ AND κ equals the closed-form expression
    `(2+ε)·(m/2 − 2√(mε))/m`.

    This is the **paper-citable Type-(a)** form: in isolation, it states
    "given ε,m above threshold, an explicit κ exists" — no unpacking of
    the universal NAMED Prop required. -/
theorem T5_BHARANI_kappa_witness_for
    (ε : ℝ) (hε : 0 < ε)
    (m : ℕ) (hm : T5_BHARANI_kappa_threshold_explicit ε < m) :
    ∃ (κ : ℝ), 1 < κ ∧
      κ = (2 + ε) * ((m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε)) / m := by
  -- Specialize the universal alias at (ε, m).
  obtain ⟨thr, hthr⟩ := T5_BHARANI_kappa_formula_valid_alias ε hε
  -- The threshold returned by the universal Prop is exactly
  -- T5_BHARANI_kappa_threshold_explicit ε (= Nat.ceil (16(2+ε)²/ε)),
  -- but at the universal level we cannot pin it; just transport the
  -- ∃-witness via hm.
  -- Concrete check: the existing discharge picks
  --   `Nat.ceil (16 * (2+ε)^2 / ε)` as its threshold;
  -- our threshold is by definition the same.
  -- However, the universal Prop hides `thr` behind ∃ — so we cannot
  -- assume `thr = T5_BHARANI_kappa_threshold_explicit ε` by reduction.
  -- INSTEAD: re-derive the witness by directly inlining the discharge
  -- algebra (same as Leaf-6) but specialized to our concrete threshold.
  --
  -- We do this by re-running the algebra for the explicit threshold:
  refine ⟨(2 + ε) * ((m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε)) / m, ?_, rfl⟩
  -- Replicate the algebra of Leaf-6:
  have hm_nat_pos : 0 < m :=
    lt_of_le_of_lt (Nat.zero_le _) hm
  have hm_real_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm_nat_pos
  have hε_pos_3 : (0 : ℝ) < 2 + ε := by linarith
  have hm_real_lt : 16 * (2 + ε)^2 / ε < (m : ℝ) := by
    have h_ceil : 16 * (2 + ε)^2 / ε ≤ (Nat.ceil (16 * (2 + ε)^2 / ε) : ℝ) :=
      Nat.le_ceil _
    have h_nat : T5_BHARANI_kappa_threshold_explicit ε < m := hm
    have h_cast :
        ((T5_BHARANI_kappa_threshold_explicit ε : ℕ) : ℝ) < (m : ℝ) := by
      exact_mod_cast h_nat
    -- T5_BHARANI_kappa_threshold_explicit ε = Nat.ceil (16(2+ε)²/ε) by defn
    calc 16 * (2 + ε)^2 / ε
        ≤ (Nat.ceil (16 * (2 + ε)^2 / ε) : ℝ) := h_ceil
      _ = ((T5_BHARANI_kappa_threshold_explicit ε : ℕ) : ℝ) := by
          simp [T5_BHARANI_kappa_threshold_explicit]
      _ < (m : ℝ) := h_cast
  -- Setup u = sqrt(mε)
  set u : ℝ := Real.sqrt ((m : ℝ) * ε) with hu_def
  have hmε_nn : 0 ≤ (m : ℝ) * ε := by positivity
  have hu_sq : u * u = (m : ℝ) * ε := Real.mul_self_sqrt hmε_nn
  have hu_nn : 0 ≤ u := Real.sqrt_nonneg _
  -- εm > 16(2+ε)²
  have h_eps_m : 16 * (2 + ε)^2 < ε * (m : ℝ) := by
    rw [div_lt_iff₀ hε] at hm_real_lt
    linarith [hm_real_lt]
  -- 4(2+ε)u < εm via squaring
  have h_4_kappa : 4 * (2 + ε) * u < ε * (m : ℝ) := by
    have h_lhs_nn : 0 ≤ 4 * (2 + ε) * u := by positivity
    have h_rhs_nn : 0 ≤ ε * (m : ℝ) := by positivity
    have h_lhs_sq : (4 * (2 + ε) * u)^2 = 16 * (2 + ε)^2 * (u * u) := by ring
    rw [hu_sq] at h_lhs_sq
    have h_sq_lt : (4 * (2 + ε) * u)^2 < (ε * (m : ℝ))^2 := by
      rw [h_lhs_sq]
      nlinarith [h_eps_m, hm_real_pos, hε, sq_nonneg (2 + ε), hε_pos_3]
    nlinarith [h_sq_lt, h_lhs_nn, h_rhs_nn]
  -- Final: 1 < (2+ε)(m/2 - 2u)/m
  rw [lt_div_iff₀ hm_real_pos]
  nlinarith [h_4_kappa, hε, hm_real_pos]

/-! ## (3) Concrete numerical witness — paper-citable existence -/

/-- **BHARANI-δ — `T5_BHARANI_kappa_threshold_at_eps_one`**:
    closed-form value of the threshold at ε = 1.
    `⌈16·(2+1)²/1⌉ = ⌈144⌉ = 144`. -/
theorem T5_BHARANI_kappa_threshold_at_eps_one :
    T5_BHARANI_kappa_threshold_explicit (1 : ℝ) = 144 := by
  unfold T5_BHARANI_kappa_threshold_explicit
  norm_num

/-- **BHARANI-ε — `T5_BHARANI_kappa_witness_at_eps_one_m_two_hundred`**:
    paper-citable concrete numerical witness at ε = 1, m = 200.

    Exhibits explicit κ > 1 with closed-form value
    κ = 3·(100 − 2√200)/200 ≈ 1.0757.

    Establishes Type-(a) existence-demonstration without universal
    quantifier unpacking — usable verbatim in paper §D.1 as a
    sample point above threshold. -/
theorem T5_BHARANI_kappa_witness_at_eps_one_m_two_hundred :
    ∃ (κ : ℝ), 1 < κ ∧
      κ = (2 + (1 : ℝ)) * (((200 : ℕ) : ℝ) / 2 -
            2 * Real.sqrt (((200 : ℕ) : ℝ) * 1)) / ((200 : ℕ) : ℝ) := by
  have hε : (0 : ℝ) < 1 := by norm_num
  have hm : T5_BHARANI_kappa_threshold_explicit (1 : ℝ) < 200 := by
    rw [T5_BHARANI_kappa_threshold_at_eps_one]
    norm_num
  exact T5_BHARANI_kappa_witness_for (1 : ℝ) hε 200 hm

/-! ## (4) Paper-citable headline -/

/-- **🚨🚨🚨 BHARANI-ζ — `T5_BHARANI_KAPPA_DISCHARGE_HEADLINE`**:
    paper-citable κ-formula-valid discharge headline.

    Bundles four paper-citable artefacts:
    (a) Universal alias: `T5_NAMED_kappa_formula_valid` holds.
    (b) Type-(a) standalone: explicit threshold + Σ-witness constructor.
    (c) Concrete sample: ε = 1, m = 200 yields explicit κ ≈ 1.076 > 1.
    (d) Threshold reduction: closed form `⌈16(2+ε)²/ε⌉`.

    Strategic significance: V7N1U-D1 is fully eliminated as a residual
    leaf — atomic component of the V7-N1-uniform decomposition (Block C,
    Hindry-Silverman D.7) is unconditionally discharged with paper-grade
    citations available in isolation. -/
theorem T5_BHARANI_KAPPA_DISCHARGE_HEADLINE :
    -- (a) Universal alias
    T5_NAMED_kappa_formula_valid ∧
    -- (b) Concrete witness at ε = 1, m = 200
    (∃ (κ : ℝ), 1 < κ ∧
      κ = (2 + (1 : ℝ)) * (((200 : ℕ) : ℝ) / 2 -
            2 * Real.sqrt (((200 : ℕ) : ℝ) * 1)) / ((200 : ℕ) : ℝ)) ∧
    -- (c) Threshold closed form at ε = 1
    T5_BHARANI_kappa_threshold_explicit (1 : ℝ) = 144 :=
  ⟨T5_BHARANI_kappa_formula_valid_alias,
   T5_BHARANI_kappa_witness_at_eps_one_m_two_hundred,
   T5_BHARANI_kappa_threshold_at_eps_one⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_KappaFormulaValid_Discharge
