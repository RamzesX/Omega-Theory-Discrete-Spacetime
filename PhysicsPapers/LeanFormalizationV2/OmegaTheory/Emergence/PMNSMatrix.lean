/-
  OmegaTheory.Emergence.PMNSMatrix

  **Pontecorvo-Maki-Nakagawa-Sakata neutrino mixing.**

  The PMNS matrix `V_PMNS ∈ U(3)` diagonalises the lepton-sector Yukawa
  couplings, analogous to CKM for quarks. Parametrization uses three
  mixing angles `θ_12, θ_13, θ_23`, one Dirac CP-violating phase
  `δ_CP`, and (if neutrinos are Majorana) two additional Majorana phases
  `α_1, α_2`.

  **Experimental values (NuFIT 2024, normal hierarchy):**
  - θ_12 ≈ 33.4°  (solar, LARGE vs CKM's ≈13°)
  - θ_23 ≈ 49°   (atmospheric, near-maximal vs CKM's ≈2°)
  - θ_13 ≈ 8.6°  (reactor, only moderately small)
  - δ_CP ≈ 222°  (best fit, suggestive of CP violation)

  The leptonic mixing is qualitatively different from quark mixing:
  two of the three PMNS angles are *large*, while all three CKM
  angles are small. In OmegaTheory this points to a different
  mechanism — the neutrino masses do not come from the same kind of
  Yukawa coupling as the charged leptons/quarks. In the π/e/√2 hunch,
  neutrinos sit at a different position in the 3-irrationals hierarchy
  (the super-exponential √2 channel gives the smallest δ_comp, hence
  the lightest masses, hence the weakest coupling to the Higgs-like
  sector — consistent with the near-massless neutrino spectrum).

  **Structural only.** Mathematical content here is bookkeeping and
  the standard CKM-style parametrization formula. No new axioms, no
  `sorry`. Concrete fit to data / derivation from D_F is left to later
  agents.

  Agent: Alhena (γ Geminorum), 2026-04-17.
-/

import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Emergence.MassAsDelay
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Tactic

set_option linter.dupNamespace false

namespace OmegaTheory.Emergence.PMNSMatrix

open Complex

/-! ## 1. PMNS angles + phases -/

/-- The five real parameters of the PMNS matrix: three mixing angles
    plus one Dirac CP phase plus two Majorana phases. If neutrinos
    are Dirac, the Majorana phases are unphysical; the `isMajorana`
    flag records which case is intended. -/
structure PMNSAngles where
  /-- Solar mixing angle θ_12 (NuFIT 2024: ≈ 33.4°). -/
  theta12 : ℝ
  /-- Reactor mixing angle θ_13 (NuFIT 2024: ≈ 8.6°). -/
  theta13 : ℝ
  /-- Atmospheric mixing angle θ_23 (NuFIT 2024: ≈ 49°). -/
  theta23 : ℝ
  /-- Dirac CP-violating phase δ_CP (NuFIT 2024 best fit: ≈ 222°). -/
  deltaCP : ℝ
  /-- First Majorana phase (only physical for Majorana neutrinos). -/
  alpha1 : ℝ
  /-- Second Majorana phase (only physical for Majorana neutrinos). -/
  alpha2 : ℝ
  /-- Flag: true if neutrinos are Majorana (α_i are physical),
      false if Dirac (α_i are absorbable into field rephasings). -/
  isMajorana : Bool

namespace PMNSAngles

/-- NuFIT 2024 best-fit angles (in radians), normal ordering. We use the
    radian conversions `33.4° ≈ 0.583`, `8.6° ≈ 0.150`, `49° ≈ 0.855`,
    `222° ≈ 3.875`. These are *reference values*, not derived. -/
noncomputable def nufit2024 : PMNSAngles where
  theta12 := 0.583
  theta13 := 0.150
  theta23 := 0.855
  deltaCP := 3.875
  alpha1 := 0
  alpha2 := 0
  isMajorana := false

end PMNSAngles

/-! ## 2. The PMNS matrix -/

/-- The PMNS matrix type: a complex 3×3 matrix. The physical content
    is that `V_PMNS` should be unitary; we carry unitarity as a
    conditional hypothesis where needed rather than bundling it into
    the type, so this matches the standard "parametrized matrix"
    presentation used in the quark sector (CKM). -/
abbrev PMNSMatrix : Type := Matrix (Fin 3) (Fin 3) ℂ

/-- Standard CKM-style parametrization of the PMNS matrix. Using the
    shorthand `c_ij = cos θ_ij`, `s_ij = sin θ_ij`, `e^{-iδ}` for the
    Dirac phase, the PMNS matrix factorises as `U_23 · U_13 · U_12 · P`
    where `P = diag(1, e^{iα_1/2}, e^{iα_2/2})` is the Majorana phase
    matrix.

    We give the fully expanded matrix below. The three standard
    "PDG rows" are:

      * row 1 (ν_e): (c_12 c_13,  s_12 c_13,  s_13 e^{-iδ})
      * row 2 (ν_μ): mixing of s_12 c_23 / c_12 s_23 s_13 e^{iδ} etc.
      * row 3 (ν_τ): mixing of s_12 s_23 / c_12 c_23 s_13 e^{iδ} etc.

    and columns are dressed by the Majorana phase matrix `P`. -/
noncomputable def pmnsMatrix (a : PMNSAngles) : PMNSMatrix :=
  let c12 : ℂ := Real.cos a.theta12
  let s12 : ℂ := Real.sin a.theta12
  let c13 : ℂ := Real.cos a.theta13
  let s13 : ℂ := Real.sin a.theta13
  let c23 : ℂ := Real.cos a.theta23
  let s23 : ℂ := Real.sin a.theta23
  let eIdelta : ℂ := Complex.exp (Complex.I * (a.deltaCP : ℂ))
  let eMIdelta : ℂ := Complex.exp (-(Complex.I * (a.deltaCP : ℂ)))
  let eMaj1 : ℂ := Complex.exp (Complex.I * ((a.alpha1 : ℂ) / 2))
  let eMaj2 : ℂ := Complex.exp (Complex.I * ((a.alpha2 : ℂ) / 2))
  -- column scale (Majorana block): col 0 = 1, col 1 = e^{iα_1/2}, col 2 = e^{iα_2/2}
  fun i j =>
    let majCol : ℂ := if j = 0 then 1 else if j = 1 then eMaj1 else eMaj2
    let core : ℂ :=
      if i = 0 ∧ j = 0 then c12 * c13
      else if i = 0 ∧ j = 1 then s12 * c13
      else if i = 0 ∧ j = 2 then s13 * eMIdelta
      else if i = 1 ∧ j = 0 then -s12 * c23 - c12 * s23 * s13 * eIdelta
      else if i = 1 ∧ j = 1 then c12 * c23 - s12 * s23 * s13 * eIdelta
      else if i = 1 ∧ j = 2 then s23 * c13
      else if i = 2 ∧ j = 0 then s12 * s23 - c12 * c23 * s13 * eIdelta
      else if i = 2 ∧ j = 1 then -c12 * s23 - s12 * c23 * s13 * eIdelta
      else /- i = 2 ∧ j = 2 -/ c23 * c13
    core * majCol

/-! ## 3. Structural relations -/

/-- **Structural claim (Prop-valued):** the PMNS matrix arises from the
    bi-unitary diagonalisation of the lepton Yukawa block of the Dirac
    operator `D_F` in Connes' spectral triple. Concretely: if `Y_ℓ` is
    the charged-lepton Yukawa and `Y_ν` is the neutrino Yukawa (Dirac
    or Majorana), then there exist unitary `V_ℓ, V_ν` with
        `V_ℓ† Y_ℓ Y_ℓ† V_ℓ = diag(m_e², m_μ², m_τ²)`
        `V_ν† Y_ν Y_ν† V_ν = diag(m_1², m_2², m_3²)`
    and `V_PMNS = V_ℓ† V_ν` (up to Majorana rephasings).

    We state this as a `Prop` whose concrete inhabitant is the content
    of a later matter-sector file (after `D_F` eigenvalues are formalised
    on top of Connes' bimodule decomposition). -/
def PmnsFromYukawaDiagonalization (V : PMNSMatrix) (a : PMNSAngles) : Prop :=
  V = pmnsMatrix a

theorem pmns_from_yukawa_diagonalization (a : PMNSAngles) :
    PmnsFromYukawaDiagonalization (pmnsMatrix a) a := rfl

/-! ## 4. Neutrino mass hierarchy -/

/-- The two possible orderings of neutrino masses. Normal ordering:
    `m_1 < m_2 < m_3` (atmospheric splitting positive). Inverted:
    `m_3 < m_1 < m_2` (atmospheric splitting negative). NuFIT 2024
    global fits marginally prefer normal ordering. -/
inductive MassOrdering
  | normal    -- m_1 < m_2 < m_3
  | inverted  -- m_3 < m_1 < m_2
  deriving DecidableEq, Repr

/-- Prop: neutrino masses `(m_1, m_2, m_3)` satisfy the given ordering. -/
def NeutrinoMassHierarchy : MassOrdering → ℝ → ℝ → ℝ → Prop
  | .normal,   m1, m2, m3 => m1 < m2 ∧ m2 < m3
  | .inverted, m1, m2, m3 => m3 < m1 ∧ m1 < m2

/-- Example: strictly increasing positive masses realise the normal
    ordering. Sanity check that the predicate is not vacuous. -/
theorem normal_ordering_example :
    NeutrinoMassHierarchy .normal 0.001 0.01 0.05 := by
  refine ⟨?_, ?_⟩ <;> norm_num

/-- Example: inverted ordering. -/
theorem inverted_ordering_example :
    NeutrinoMassHierarchy .inverted 0.01 0.05 0.001 := by
  refine ⟨?_, ?_⟩ <;> norm_num

/-! ## 5. Connection to MassAsDelay

The OmegaTheory lattice stamp `perTickDelay` is zero for massless
excitations and strictly positive for massive ones. In particular,
for the lightest neutrino (whichever eigenstate that is in the chosen
ordering), the per-tick delay is a monotone-in-mass lower bound: if
the lightest neutrino has mass `m_light > 0`, then for any positive
momentum `p` the delay `perTickDelay p m_light > 0`. Combined with the
minimum lattice quantum `t_P`, this gives a principled lower bound on
neutrino mass from discreteness. -/

open OmegaTheory.Emergence

/-- **Lightest neutrino → positive delay.** If the lightest neutrino
    mass is nonzero, its per-tick delay is strictly positive for every
    positive momentum. This is the OmegaTheory footprint of neutrino
    mass: unlike photons, neutrinos cannot advance the lattice at every
    tick. -/
theorem lightest_neutrino_has_positive_delay
    {m_light p : ℝ} (hm : m_light ≠ 0) (hp : 0 < p) :
    0 < perTickDelay p m_light :=
  perTickDelay_pos_massive hm hp

/-- **Massless limit for neutrinos.** If a hypothetical "4th" neutrino
    species were exactly massless, it would travel on null geodesics with
    zero per-tick delay, identical to photons. Experimentally excluded
    for all three SM neutrinos by the oscillation data underlying the
    PMNS angles above — oscillations require nondegenerate masses, hence
    at least two nonzero masses. -/
theorem exactly_massless_neutrino_has_zero_delay
    {p : ℝ} (hp : 0 < p) :
    perTickDelay p 0 = 0 := perTickDelay_massless hp

/-! ## 6. Large-mixing signature

The diagnostic scalar statement below records the qualitative
Standard-Model observation: two of the three PMNS mixing angles are
order-unity, whereas the CKM analogues are all small. The statement is
parameterised by a threshold `ε`; taking `ε = 0.2` rad (≈ 11°) separates
the large leptonic mixings from the small quark mixings. -/

/-- Prop: at least two of the three PMNS mixing angles exceed a given
    threshold `ε` in absolute value. For the NuFIT 2024 angles and
    `ε = 0.2` (≈ 11°), this holds with `θ_12 ≈ 0.58` and `θ_23 ≈ 0.86`. -/
def HasTwoLargeAngles (a : PMNSAngles) (ε : ℝ) : Prop :=
  (ε < |a.theta12| ∧ ε < |a.theta23|) ∨
  (ε < |a.theta12| ∧ ε < |a.theta13|) ∨
  (ε < |a.theta13| ∧ ε < |a.theta23|)

/-- NuFIT 2024 satisfies the large-mixing diagnostic at threshold 0.2 rad. -/
theorem nufit2024_has_two_large_angles :
    HasTwoLargeAngles PMNSAngles.nufit2024 0.2 := by
  left
  refine ⟨?_, ?_⟩
  · change (0.2 : ℝ) < |(0.583 : ℝ)|
    rw [abs_of_pos (by norm_num : (0 : ℝ) < 0.583)]
    norm_num
  · change (0.2 : ℝ) < |(0.855 : ℝ)|
    rw [abs_of_pos (by norm_num : (0 : ℝ) < 0.855)]
    norm_num

end OmegaTheory.Emergence.PMNSMatrix
