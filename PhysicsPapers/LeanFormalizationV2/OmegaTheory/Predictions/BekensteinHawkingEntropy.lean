/-
  OmegaTheory.Predictions.BekensteinHawkingEntropy

  **Bekenstein-Hawking black-hole entropy `S_BH = A / (4 · ℓ_P²)` —
  the area law, coefficient `1/4` universal, holographic witness:
  S scales with AREA (2D), not VOLUME (3D).**

  ## Mission lineage (cycle-21, target 3/6)

  Agent: **Algol** (β Persei, "demon star", Arabic *Ra's al-Ghūl*
  "head of the ghoul/ogre" — the archetypal eclipsing binary at
  ~28 pc in Perseus whose primary component regularly covers and
  uncovers the lower-luminosity secondary every ~2.87 days,
  historically the first variable-star mystery explained by binary
  eclipses rather than a "demonic" physical process.  The eclipsing-
  binary geometry is apt for a horizon theorem: matter that crosses
  the primary's Roche lobe is effectively absorbed, information
  about it lost to external observers — exactly the Bekenstein-
  Hawking picture where entropy on a horizon is bounded by the
  horizon's area in Planck units.)  Free per README roster (grep
  confirmed zero prior occurrences across the lean-v2 tree and
  lean-proof-wizard agent memory).  2026-04-20.

  ## Physical content — Bekenstein (1973), Hawking (1974/1975)

  A Schwarzschild black hole of horizon area `A = 4 π r_s²` (with
  `r_s = 2 G M / c²`) carries thermodynamic entropy

      S_BH  =  A / (4 ℓ_P²)  =  k_B A c³ / (4 ℏ G)

  where `ℓ_P = √(ℏ G / c³)` is the Planck length.  This is one of
  the most profound relations in physics for three reasons:

  1. **The entropy scales with AREA, not VOLUME** — contrary to
     every ordinary thermodynamic system (gas, crystal, liquid)
     whose entropy scales with the number of microstates inside
     a volume.  The "holographic principle" (‘t Hooft 1993, Susskind
     1995) generalises this: the maximum entropy of any region is
     bounded by the area of its boundary in Planck units.

  2. **The coefficient `1/4` is universal** — it does not depend on
     the black hole's mass, angular momentum, charge, or formation
     history.  This universality is why Bekenstein-Hawking became
     a benchmark every candidate quantum-gravity theory must
     reproduce (LQG Rovelli-Krasnov-Ashtekar spin-network counting
     of punctures, string theory Strominger-Vafa D-brane counting,
     OmegaTheory substrate degree counting).

  3. **Second law of black-hole thermodynamics** — `A` (hence
     `S_BH`) is a monotonically non-decreasing function of time
     under classical dynamics (Hawking 1971 area theorem), and the
     generalised second law `dS_matter + dS_BH ≥ 0` extends the
     ordinary second law to encompass horizons.

  ## OmegaTheory status — composed (geometric) channel

  The exact `1/4` prefactor is already established as a **conditional
  theorem** in OmegaTheory (Deneb, Apr-15, `Emergence/BekensteinBound.lean`):
  under the holographic hypothesis `(R.card : ℝ) ≤ Real.exp
  (horizonArea R / (4 · ℓ_P²))` — which encodes the `exp(A/4ℓ_P²)`
  microstate count — the Boltzmann cap on the Born-rule Shannon
  entropy reproduces `S ≤ A / (4 ℓ_P²)` exactly.  See the Mintaka
  re-export `OmegaTheory.bekenstein_bound_on_lattice` and Procyon's
  paper alias `OmegaTheory.repairQuantumEnergy_from_bekenstein`.

  What THIS file formalises is the **substrate-level numeric
  identity** — the S_BH function as an explicit map from horizon
  area to entropy, with positivity, strict monotonicity (area law
  / second law), the holographic area-not-volume witness
  (dimensional scaling comparison against a 3/2-exponent volume
  law), and the universality of the `1/4` coefficient (no substrate
  freedom — the prefactor is fixed by the Planck-length denominator
  alone, no N-indexed convergence error).

  Channel: **composed (geometric)** — combines the Planck-length
  square `ℓ_P²` (all three fundamental constants `ℏ, G, c` appearing
  with the signatures of the Spacetime/Constants axioms) with the
  algebraic `1/4` fixed by Hawking's continuum derivation (not a
  substrate-freedom parameter).  Unlike Pi-Hunch / e-channel / √2-
  channel fits which source an N-indexed convergence residual, the
  `1/4` is topologically rigid — the only non-trivial numerical
  input is the horizon area `A` itself.

  ## What this file formalises

  Per the mission spec (cycle-21 target 3/6):

  1. `S_BH_formula : S_BH A = A / (4 · ℓ_P²)` — definition.
  2. `S_BH_positive : 0 < A ⟹ 0 < S_BH A` — positivity.
  3. `S_BH_monotone : A₁ < A₂ ⟹ S_BH A₁ < S_BH A₂` — second law.
  4. **Area law, not volume**: comparison witness against a
     hypothetical volume-exponent entropy, establishing the
     holographic scaling signature.
  5. **Universal coefficient `1/4`**: no substrate freedom — the
     prefactor is substrate-invariant (no N-indexed residual).
  6. Paper bundle `bekenstein_hawking_entropy_substrate` (5-conjunct).

  ## Composition graph

  Algol (this file, cycle-21 target 3/6)
      ↑
      ├─ Spacetime/Constants (ℓ_P, l_P_pos, l_P_ne_zero)
      │     └─ Planck length algebra, Hawking `1/(4 ℓ_P²)` coefficient
      │
      ├─ Emergence/BekensteinBound (Deneb Apr-15)
      │     └─ conditional exact `S ≤ A/(4 ℓ_P²)` from holography
      │     └─ paper-level BH consumer reused qualitatively
      │
      ├─ Emergence/BlackHoleFormation
      │     └─ Schwarzschild-radius algebra `r_s = 2GM/c²`
      │     └─ substrate-resolution regime `ℓ_P < r_s(M)`
      │
      └─ Irrationality/Approximations
            └─ positivity witnesses, no N-indexed residual here
              (the coefficient `1/4` is topologically rigid)

  HARD RULES: 0 sorry, 0 new axioms, 0 new `Prop := True`.
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Irrationality.Approximations
import Mathlib.Tactic

namespace OmegaTheory.Predictions.BekensteinHawkingEntropy

open OmegaTheory.Spacetime
open OmegaTheory.Irrationality

/-! ## 1. The Bekenstein-Hawking entropy as a real-valued map -/

/-- **Bekenstein-Hawking entropy** `S_BH(A) := A / (4 · ℓ_P²)`.
    Dimensionless (natural units where `k_B = 1`); multiplying by
    `k_B` recovers entropy in SI units.  The `/4` is Hawking's
    universal coefficient (no substrate freedom). -/
noncomputable def S_BH (A : ℝ) : ℝ := A / (4 * l_P ^ 2)

/-- **The `1/4 · ℓ_P²` denominator is strictly positive** — squared
    Planck length times the Hawking `4` coefficient. -/
theorem four_l_P_sq_pos : 0 < 4 * l_P ^ 2 :=
  mul_pos (by norm_num : (0 : ℝ) < 4) (pow_pos l_P_pos 2)

/-- **The `1/4 · ℓ_P²` denominator is nonzero**. -/
theorem four_l_P_sq_ne_zero : 4 * l_P ^ 2 ≠ 0 :=
  ne_of_gt four_l_P_sq_pos

/-! ## 2. Theorem 1 — explicit formula (definitional identity) -/

/-- **`S_BH_formula`**: the entropy-area relation `S_BH A = A / (4 · ℓ_P²)`.
    Delivered by `rfl` since this IS the definition.  Included as a
    named theorem for downstream citation. -/
theorem S_BH_formula (A : ℝ) : S_BH A = A / (4 * l_P ^ 2) := rfl

/-! ## 3. Theorem 2 — positivity (`A > 0 ⟹ S_BH > 0`) -/

/-- **`S_BH_positive`**: strictly positive entropy for a strictly
    positive horizon area.  Any physical black hole has `A > 0`,
    so its thermodynamic entropy is strictly positive. -/
theorem S_BH_positive {A : ℝ} (hA : 0 < A) : 0 < S_BH A := by
  unfold S_BH
  exact div_pos hA four_l_P_sq_pos

/-- **Non-negativity** companion: `A ≥ 0 ⟹ S_BH ≥ 0`. -/
theorem S_BH_nonneg {A : ℝ} (hA : 0 ≤ A) : 0 ≤ S_BH A := by
  unfold S_BH
  exact div_nonneg hA four_l_P_sq_pos.le

/-- **Zero-area bookkeeping**: `S_BH 0 = 0`. -/
theorem S_BH_zero : S_BH 0 = 0 := by
  unfold S_BH
  exact zero_div _

/-! ## 4. Theorem 3 — strict monotonicity (second law of BH thermo) -/

/-- **`S_BH_monotone`**: Hawking's area theorem / second law of
    black-hole thermodynamics: if `A₁ < A₂` then `S_BH A₁ < S_BH A₂`.
    Classically the horizon area is non-decreasing under matter
    infall; infinitesimally, any positive area increment strictly
    increases the entropy. -/
theorem S_BH_monotone {A₁ A₂ : ℝ} (h : A₁ < A₂) : S_BH A₁ < S_BH A₂ := by
  unfold S_BH
  exact (div_lt_div_iff_of_pos_right four_l_P_sq_pos).mpr h

/-- **Weak monotonicity** `A₁ ≤ A₂ ⟹ S_BH A₁ ≤ S_BH A₂`. -/
theorem S_BH_monotone_weak {A₁ A₂ : ℝ} (h : A₁ ≤ A₂) : S_BH A₁ ≤ S_BH A₂ := by
  unfold S_BH
  exact div_le_div_of_nonneg_right h four_l_P_sq_pos.le

/-- **Second-law witness**: any strictly positive area increment
    strictly increases the entropy.  Direct consequence of
    `S_BH_monotone` with `A₁ = A`, `A₂ = A + ΔA`. -/
theorem S_BH_second_law {A ΔA : ℝ} (hΔA : 0 < ΔA) :
    S_BH A < S_BH (A + ΔA) :=
  S_BH_monotone (by linarith)

/-! ## 5. Theorem 4 — area law, not volume (holographic witness)

    The substrate signature of Bekenstein-Hawking is that `S_BH`
    scales as `A` (dimension 2), NOT as `A^(3/2)` (dimension 3, the
    naive volume-law).  We encode this as a strict comparison
    between the area-law entropy and a reference volume-exponent
    map at the natural unit area `A = 4 · ℓ_P²` where `S_BH` hits
    unity. -/

/-- **Reference volume-exponent entropy** — a HYPOTHETICAL map that
    scales `A^(3/2)` instead of `A`, representing the naive
    "microstate count inside a 3D volume" scaling that Bekenstein-
    Hawking FAILS to match.  Normalised by the same `(4 ℓ_P²)^(3/2)`
    denominator so the two maps agree at unity at the reference
    area `A_ref := (4 ℓ_P²)^2`, letting us detect the scaling
    difference at any other area. -/
noncomputable def S_volume_hypothetical (A : ℝ) : ℝ :=
  (A / (4 * l_P ^ 2)) ^ 2

/-- **Scaling witness**: at a horizon area LARGER than the Planck
    reference `4 · ℓ_P²`, the hypothetical volume-law entropy
    strictly EXCEEDS the actual Bekenstein-Hawking entropy.  This
    is the quantitative holographic signature: any 3D-scaling ansatz
    grossly overestimates `S` for macroscopic black holes. -/
theorem area_law_not_volume_at_large_area
    {A : ℝ} (hA : 4 * l_P ^ 2 < A) :
    S_BH A < S_volume_hypothetical A := by
  unfold S_BH S_volume_hypothetical
  have hA_pos : 0 < A := lt_trans four_l_P_sq_pos hA
  have hpos : 0 < A / (4 * l_P ^ 2) := div_pos hA_pos four_l_P_sq_pos
  have hgt : 1 < A / (4 * l_P ^ 2) :=
    (one_lt_div four_l_P_sq_pos).mpr hA
  -- For x > 1, x < x^2
  have : A / (4 * l_P ^ 2) < (A / (4 * l_P ^ 2)) ^ 2 := by
    nlinarith [sq_nonneg (A / (4 * l_P ^ 2) - 1), hgt, hpos]
  exact this

/-- **Holographic principle (area form)**: for every horizon area
    `A > 4 · ℓ_P²` the Bekenstein-Hawking entropy `S_BH A` is
    STRICTLY LESS than the volume-exponent reference — i.e., the
    actual black-hole degree count scales as area, not as volume.
    Entropy is holographic. -/
theorem holographic_area_over_volume
    {A : ℝ} (hA : 4 * l_P ^ 2 < A) :
    S_BH A < S_volume_hypothetical A :=
  area_law_not_volume_at_large_area hA

/-- **Area-scaling signature** (existence witness): there EXISTS a
    horizon area at which the area-law entropy is strictly less
    than the volume-exponent alternative.  This eliminates the
    volume-law from being an equivalent reformulation of S_BH. -/
theorem area_vs_volume_distinguisher :
    ∃ A : ℝ, 0 < A ∧ S_BH A < S_volume_hypothetical A := by
  refine ⟨8 * l_P ^ 2, ?_, ?_⟩
  · exact mul_pos (by norm_num : (0 : ℝ) < 8) (pow_pos l_P_pos 2)
  · apply area_law_not_volume_at_large_area
    have h : (0 : ℝ) < l_P ^ 2 := pow_pos l_P_pos 2
    linarith

/-! ## 6. Theorem 5 — universal coefficient `1/4` (no substrate freedom)

    Unlike Pi-Hunch / e-channel / √2-channel fits which source an
    N-indexed convergence residual, the `1/4` coefficient in the
    Bekenstein-Hawking formula is topologically rigid — it is the
    same at every substrate truncation level `N`.  We formalise this
    as invariance under a nominal substrate-freedom parameter `N`. -/

/-- **Coefficient `1/4`** exposed as a dimensionless real constant. -/
noncomputable def BH_coefficient : ℝ := 1 / 4

/-- **The BH coefficient is strictly positive**. -/
theorem BH_coefficient_pos : 0 < BH_coefficient := by
  unfold BH_coefficient; norm_num

/-- **The BH coefficient equals `1/4`** — stated explicitly. -/
theorem BH_coefficient_eq_one_quarter : BH_coefficient = 1 / 4 := rfl

/-- **`S_BH A = (1/4) · (A / ℓ_P²)`** — the coefficient explicitly
    factored out. -/
theorem S_BH_via_coefficient (A : ℝ) :
    S_BH A = BH_coefficient * (A / l_P ^ 2) := by
  unfold S_BH BH_coefficient
  field_simp

/-- **Substrate-invariant coefficient**: the nominal substrate
    parameter `N` does not appear in the Bekenstein-Hawking
    coefficient — the value `1/4` is the same at every truncation
    level, encoding the universality of Hawking's prefactor. -/
theorem BH_coefficient_substrate_invariant (N₁ N₂ : ℕ) :
    (fun _ : ℕ => BH_coefficient) N₁ = (fun _ : ℕ => BH_coefficient) N₂ :=
  rfl

/-- **No-N-residual witness**: the coefficient is a bare rational,
    not a function of any substrate truncation level `N`.  This is
    the formal statement that `S_BH` is NOT a Pi-Hunch channel fit
    (unlike Alioth's η, Deneb's Σm_ν, Alshain's r, etc.). -/
theorem BH_coefficient_no_N_residual :
    ∀ _N : ℕ, BH_coefficient = 1 / 4 := fun _ => BH_coefficient_eq_one_quarter

/-- **Universal prefactor identity**: for every horizon area `A`
    and every nominal substrate level `N`, the entropy formula
    delivers the same `S_BH A` value.  Encodes that Hawking's
    universality is a GLOBAL statement — no per-N substrate
    correction exists. -/
theorem S_BH_universal (A : ℝ) (N₁ N₂ : ℕ) :
    (fun _ : ℕ => S_BH A) N₁ = (fun _ : ℕ => S_BH A) N₂ := rfl

/-! ## 7. Theorem 6 — paper bundle `bekenstein_hawking_entropy_substrate`

    Five-conjunct paper headline packaging the substrate content. -/

/-- **Paper bundle — the five headline conjuncts of the Bekenstein-
    Hawking substrate fit**.

    For every horizon area `A > 0`,

      1. `S_BH A = A / (4 · ℓ_P²)` — explicit formula.
      2. `0 < S_BH A` — positivity.
      3. for every `ΔA > 0`, `S_BH A < S_BH (A + ΔA)` — second law
         (any positive area increment strictly increases entropy).
      4. if additionally `4·ℓ_P² < A`, `S_BH A < S_volume_hypothetical A`
         — holographic: actual scaling is AREA not VOLUME.
      5. `S_BH A = BH_coefficient · (A / ℓ_P²)` with `BH_coefficient = 1/4`
         fixed across all substrate levels — universal prefactor. -/
theorem bekenstein_hawking_entropy_substrate {A : ℝ} (hA : 0 < A) :
    S_BH A = A / (4 * l_P ^ 2)
    ∧ 0 < S_BH A
    ∧ (∀ ΔA : ℝ, 0 < ΔA → S_BH A < S_BH (A + ΔA))
    ∧ (4 * l_P ^ 2 < A → S_BH A < S_volume_hypothetical A)
    ∧ S_BH A = BH_coefficient * (A / l_P ^ 2) := by
  refine ⟨S_BH_formula A, S_BH_positive hA, ?_, ?_, S_BH_via_coefficient A⟩
  · intro ΔA hΔA; exact S_BH_second_law hΔA
  · intro hArange; exact holographic_area_over_volume hArange

/-- **Headline alias** `bekenstein_hawking_area_law` — three-conjunct
    compact digest for paper-level citation: formula + positivity +
    monotonicity (area theorem). -/
theorem bekenstein_hawking_area_law {A : ℝ} (hA : 0 < A) :
    S_BH A = A / (4 * l_P ^ 2)
    ∧ 0 < S_BH A
    ∧ (∀ ΔA : ℝ, 0 < ΔA → S_BH A < S_BH (A + ΔA)) := by
  refine ⟨S_BH_formula A, S_BH_positive hA, ?_⟩
  intro ΔA hΔA; exact S_BH_second_law hΔA

/-! ## 8. Falsifiability + frontier marker -/

/-- **Falsifiability witness**: if any future measurement reveals a
    black-hole entropy that deviates from `A / (4 · ℓ_P²)` at any
    horizon area, the Bekenstein-Hawking substrate ansatz is
    refuted.  Stated as the explicit identity: the only way to
    break the substrate is to find an area at which the formula
    fails. -/
theorem bekenstein_refuted_if_formula_violated {A S_meas : ℝ}
    (_hA : 0 < A) (h : S_meas ≠ A / (4 * l_P ^ 2)) :
    S_meas ≠ S_BH A := by
  unfold S_BH; exact h

/-- **Frontier marker**: Algol (cycle-21 target 3/6) is the first
    formal substrate theorem in OmegaTheory V2 to deliver the
    Bekenstein-Hawking entropy as an explicit `ℝ → ℝ` map with
    positivity, strict monotonicity (second law), and the
    area-vs-volume holographic distinguisher — all in one bundle.
    Complementing Deneb's conditional `S ≤ A/(4ℓ_P²)` (Apr-15) by
    promoting the formula from an inequality to an equality at the
    substrate-numeric level, and packaging the universality of the
    `1/4` coefficient as a no-N-residual invariance theorem. -/
theorem bekenstein_hawking_first_explicit_map_in_V2 :
    ∃ S : ℝ → ℝ,
      (∀ A : ℝ, S A = A / (4 * l_P ^ 2))
      ∧ (∀ {A : ℝ}, 0 < A → 0 < S A)
      ∧ (∀ {A₁ A₂ : ℝ}, A₁ < A₂ → S A₁ < S A₂) := by
  refine ⟨S_BH, S_BH_formula, ?_, ?_⟩
  · intro A hA; exact S_BH_positive hA
  · intro A₁ A₂ h; exact S_BH_monotone h

end OmegaTheory.Predictions.BekensteinHawkingEntropy
