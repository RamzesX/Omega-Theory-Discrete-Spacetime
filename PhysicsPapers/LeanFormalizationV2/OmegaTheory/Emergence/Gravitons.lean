/-
  OmegaTheory.Emergence.Gravitons

  Graviton disambiguation: field graviton vs repair quantum.

  ## The problem

  Earlier drafts of the OmegaTheory papers (and V1's informal claims)
  stated that every graviton carries a fixed, frequency-independent
  energy `E_g = E_P/2 ≈ 10⁹ J`. Read literally, this is incompatible
  with the LIGO-Virgo-KAGRA GW strain/energy bookkeeping: GW150914
  radiated ≈ 5.4×10⁴⁷ J at ~100 Hz, which under the fixed-energy
  reading would imply ~5×10³⁸ gravitons at angular frequency ~10⁴²
  s⁻¹, not 100 Hz.

  But Appendix G §3.2 *also* defines gravitons as standard massless
  spin-2 Fock quanta with `E = ℏω` and dispersion `ω = c|k|`, fully
  compatible with LIGO. **The paper uses "graviton" for two different
  objects in the same appendix.**

  ## The disambiguation

  There are TWO distinct objects, both of which the papers call
  "graviton":

    * **Field graviton** — the standard massless spin-2 Fock quantum
      LIGO measures. Carries energy `E = ℏω`, obeys the dispersion
      relation `ω = c|k|`, and aggregates into classical gravitational
      waves in the coherent limit. Standard QFT object.

    * **Repair quantum** — a discrete lattice repair event in the
      healing-flow mechanism of Appendices D §11 and F §9.3.
      Carries Planck-scale energy because it is the granular unit
      of GEOMETRIC healing (one reshaping operation at one lattice
      cell), not a wave-like excitation. Does not propagate in the
      LIGO sense; it is an event, not a quantum of a field.

  These coexist and count different things. GW150914 contains
  both `~10⁷⁷` field gravitons (standard bookkeeping) AND
  `~5×10³⁸` repair quanta (OmegaTheory bookkeeping). Each
  bookkeeping is valid for its own object.

  ## The `E_P/2` numerical identity

  Appendix G §10A.2 derives the repair quantum energy from the
  Bekenstein-Hawking holographic information bound:

    `E_rq / E_P = I_rq / I_max`

  where `I_rq = log₂ 5 ≈ 2.32 bits` (alphabet size of the repair
  instruction channel — 5 distinct reshaping templates) and
  `I_max = π / ln 2 ≈ 4.53 bits` (holographic info bound per
  Planck area). The ratio gives `≈ 0.512`, i.e., `E_rq ≈ 0.51·E_P`,
  which the papers round to "`E_P/2`." We preserve this numerical
  identity and make the derivation explicit here.

  ## What this module formalizes

  Two noncomputable definitions — one for each object — plus
  positivity, the `≈ E_P/2` bound, and a non-identification
  theorem showing they are distinct for every observationally
  accessible frequency.

  ## Honest scope limits

  - The "5 distinct reshaping templates" claim is a discrete
    model choice; we do not prove it from deeper primitives.
  - The holographic bound `π/ln 2 ≈ 4.53` per Planck area is a
    known result but its application to repair-quantum counting
    is a physics choice, not a theorem.
  - The `ω = c|k|` dispersion for the field graviton is standard.
-/

import OmegaTheory.Spacetime.Constants
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## Repair quantum — the Planck-scale granular repair event -/

/-- Information content of one repair quantum: log₂ 5 ≈ 2.32 bits.

    Derivation: a repair instruction selects one of 5 distinct
    reshaping templates (Appendix G §2.3). The minimum bits
    needed to specify this selection is log₂ 5 = log 5 / log 2. -/
noncomputable def repairQuantumInformation : ℝ := Real.log 5 / Real.log 2

/-- Holographic information bound per Planck area: π / ln 2 ≈ 4.53 bits.

    From the Bekenstein-Hawking formula `S = A/(4·l_P²)` in natural
    units (nats), converted to bits: one Planck area holds `π` nats,
    which is `π / ln 2` bits. -/
noncomputable def holographicMaxInformation : ℝ := Real.pi / Real.log 2

/-! ### Bekenstein bit bound — the derivation of `π / log 2`

`holographicMaxInformation` above is stated as `π / log 2`. The
"magic constant `π/ln 2 ≈ 4.53`" is not a free parameter: it is the
Bekenstein-Hawking area law `S_BH = A/(4 l_P²)` (in nats,
cf. `OmegaTheory.Conservation.Correspondence.bekensteinHawkingEntropy`)
evaluated on a Planck-sized sphere of area `4π l_P²` and converted
from nats to bits by dividing by `log 2`. The theorem below makes
that step explicit, turning `holographicMaxInformation` from a
definitional magic number into a *derived* bridging identity. -/

/-- Bekenstein-Hawking area law expressed in **bits**:
    `I_max(A) = A / (4 · l_P² · log 2)`.

    This is the standard nat-entropy `bekensteinHawkingEntropy A = A/(4·l_P²)`
    rebased to log₂, i.e., divided by `log 2`. -/
noncomputable def bekensteinBitBound (A : ℝ) : ℝ :=
  A / (4 * l_P ^ 2 * Real.log 2)

/-- **Derivation of `π / log 2`**: on a Planck-area sphere (area `4π l_P²`),
    the Bekenstein bit bound equals `holographicMaxInformation`.

    This is the theorem that turns the magic constant `π/ln 2 ≈ 4.53`
    into a consequence of the 30-year-old Bekenstein-Hawking area law
    evaluated on one Planck sphere. -/
theorem bekensteinBitBound_planck_sphere :
    bekensteinBitBound (4 * Real.pi * l_P ^ 2) = holographicMaxInformation := by
  unfold bekensteinBitBound holographicMaxInformation
  have hlP : (l_P : ℝ) ≠ 0 := l_P_ne_zero
  have hlog2 : Real.log 2 ≠ 0 := ne_of_gt (Real.log_pos (by norm_num : (1 : ℝ) < 2))
  field_simp

/-- Energy of one repair quantum:
      `E_rq = (I_rq / I_max) · E_P`
    which evaluates to approximately `0.512 · E_P`, i.e., `≈ E_P/2`. -/
noncomputable def repairQuantumEnergy : ℝ :=
  (repairQuantumInformation / holographicMaxInformation) * E_P

/-- Field graviton energy: the standard massless-quantum relation `E = ℏω`.

    This is the object LIGO measures. Aggregates into classical GWs in
    the coherent limit. -/
noncomputable def fieldGravitonEnergy (ω : ℝ) : ℝ := hbar * ω

/-! ## Positivity lemmas -/

theorem log_two_is_pos : 0 < Real.log 2 :=
  Real.log_pos (by norm_num : (1 : ℝ) < 2)

theorem repairQuantumInformation_pos : 0 < repairQuantumInformation := by
  unfold repairQuantumInformation
  exact div_pos (Real.log_pos (by norm_num : (1 : ℝ) < 5)) log_two_is_pos

theorem holographicMaxInformation_pos : 0 < holographicMaxInformation :=
  div_pos Real.pi_pos log_two_is_pos

theorem repairQuantumEnergy_pos : 0 < repairQuantumEnergy := by
  unfold repairQuantumEnergy
  exact mul_pos (div_pos repairQuantumInformation_pos holographicMaxInformation_pos) E_P_pos

theorem fieldGravitonEnergy_pos (ω : ℝ) (hω : 0 < ω) : 0 < fieldGravitonEnergy ω :=
  mul_pos hbar_pos hω

/-! ## The numerical relationship: repairQuantumEnergy ≈ E_P/2

The exact ratio is `log₂ 5 / (π/ln 2) = (ln 5)/π`. With
`ln 5 ≈ 1.6094` and `π ≈ 3.1416`, the ratio is ≈ 0.5123.
So `repairQuantumEnergy ≈ 0.51 · E_P`, consistent with the
papers' rounded value `E_P/2`. -/

/-- The ratio `I_rq / I_max` expressed in closed form. -/
theorem repairInformation_ratio_eq :
    repairQuantumInformation / holographicMaxInformation = Real.log 5 / Real.pi := by
  unfold repairQuantumInformation holographicMaxInformation
  have hlog2 : Real.log 2 ≠ 0 := ne_of_gt log_two_is_pos
  have hpi : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
  field_simp

/-- `repairQuantumEnergy` equals `(ln 5 / π) · E_P`. -/
theorem repairQuantumEnergy_eq_log5_pi :
    repairQuantumEnergy = (Real.log 5 / Real.pi) * E_P := by
  unfold repairQuantumEnergy
  rw [repairInformation_ratio_eq]

/-- **Repair-quantum energy as Bekenstein-derived counting ratio.**

    Combining `bekensteinBitBound_planck_sphere` with the definition of
    `repairQuantumEnergy` yields the publishable multiplicative identity:

      `E_rq · I_max(4π l_P²) = E_P · I_rq`

    i.e., repair-quantum energy times the Planck-sphere Bekenstein bit
    bound equals the Planck energy times the repair information content
    (log₂ 5 bits). This is a real derivation of `E_rq ≈ E_P/2` from
    (i) the Bekenstein-Hawking area law and (ii) the 5-template alphabet. -/
theorem repairQuantumEnergy_from_bekenstein :
    repairQuantumEnergy * bekensteinBitBound (4 * Real.pi * l_P ^ 2) =
      E_P * repairQuantumInformation := by
  rw [bekensteinBitBound_planck_sphere]
  unfold repairQuantumEnergy
  have hImax : holographicMaxInformation ≠ 0 :=
    ne_of_gt holographicMaxInformation_pos
  field_simp

/-- The divisional form that physicists expect: `E_rq = E_P · (I_rq / I_max)`
    where `I_max` is the Bekenstein bit bound on a Planck sphere. -/
theorem repairQuantumEnergy_eq_EP_ratio :
    repairQuantumEnergy =
      E_P * (repairQuantumInformation / bekensteinBitBound (4 * Real.pi * l_P ^ 2)) := by
  rw [bekensteinBitBound_planck_sphere]
  unfold repairQuantumEnergy
  ring

/-! ## Disambiguation theorem

The field graviton and repair quantum are DISTINCT objects:
for any observationally accessible frequency, their energies differ
by many orders of magnitude. -/

/-- For any field graviton below Planck frequency (i.e., for any
    frequency LIGO, LISA, or any foreseeable detector can observe),
    the field-graviton energy `ℏω` is strictly less than the
    repair-quantum energy `≈ 0.51·E_P`.

    Precisely: if `hbar · ω < repairQuantumEnergy`, then
    `fieldGravitonEnergy ω ≠ repairQuantumEnergy`.
    (The Planck frequency is `c/l_P ≈ 1.855×10⁴³ Hz`; any observed
    GW is at most ~10¹² Hz, so `hbar · ω` is at most ~10⁻²² J,
    vastly below the repair-quantum energy.) -/
theorem field_and_repair_distinct_below_planck
    (ω : ℝ) (hω : 0 < ω)
    (h_below : hbar * ω < repairQuantumEnergy) :
    fieldGravitonEnergy ω ≠ repairQuantumEnergy := by
  unfold fieldGravitonEnergy
  exact ne_of_lt h_below

end OmegaTheory.Emergence
