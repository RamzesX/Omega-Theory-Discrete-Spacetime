/-
  OmegaTheory.Predictions.T1_NeutronMassPDG

  T-1 (light quark masses) — Phase 2 sub session 208.
  Neutron mass PDG anchor + n-p mass split.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 neutron mass:
  - m_n = 939.565 MeV (CODATA, ±0.000048)

  Plus n-p mass split: m_n - m_p ≈ 1.293 MeV (small relative to m_p).

  This split is QCD-isospin breaking + EM contribution (m_d > m_u → n
  heavier than p).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import OmegaTheory.Predictions.T1_ProtonMassPDG

namespace OmegaTheory.Predictions.T1_NeutronMassPDG

open OmegaTheory.Predictions.T1_ProtonMassPDG

/-! ## PDG anchor -/

/-- **m_n PDG 2024**: `939.565 MeV` (neutron mass, CODATA). -/
noncomputable def m_n_PDG : ℝ := 939565 / 1000

/-! ## Positivity -/

/-- **Wave T1 session 208 — `m_n > 0`**. -/
theorem T1_m_n_PDG_pos : 0 < m_n_PDG := by
  unfold m_n_PDG; norm_num

/-! ## n-p mass split -/

/-- **Wave T1 session 208 — `m_n > m_p`** (neutron heavier than proton).

    The split m_n - m_p ≈ 1.293 MeV is positive because m_d > m_u
    (down quark heavier than up quark) and the neutron has more d-quarks. -/
theorem T1_m_n_gt_m_p : m_n_PDG > m_p_PDG := by
  unfold m_n_PDG m_p_PDG; linarith

/-- **Wave T1 session 208 — `m_n - m_p > 1`** (split > 1 MeV). -/
theorem T1_m_n_minus_m_p_gt_1 : m_n_PDG - m_p_PDG > 1 := by
  unfold m_n_PDG m_p_PDG; linarith

/-- **Wave T1 session 208 — `m_n - m_p < 2`** (split < 2 MeV). -/
theorem T1_m_n_minus_m_p_lt_2 : m_n_PDG - m_p_PDG < 2 := by
  unfold m_n_PDG m_p_PDG; linarith

/-! ## Sanity bounds -/

/-- **Wave T1 session 208 — `m_n > 939`**. -/
theorem T1_m_n_PDG_gt_939 : m_n_PDG > 939 := by
  unfold m_n_PDG; norm_num

/-- **Wave T1 session 208 — `m_n < 940`**. -/
theorem T1_m_n_PDG_lt_940 : m_n_PDG < 940 := by
  unfold m_n_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 208 — neutron mass PDG anchor + n-p split**.

    Six foundational facts:
    1. `m_n = 939.565 MeV > 0`.
    2. `939 < m_n < 940`.
    3. `m_n > m_p` (neutron heavier than proton).
    4. `1 < m_n - m_p < 2` (PDG ≈ 1.293 MeV).

    The n-p mass split arises from m_d > m_u (down heavier than up)
    + EM contribution. OV2's substrate hierarchy at gen0 has
    m_u(N) = m_d(N), so the split is QCD-isospin-breaking effect.

    Sub-lemma 33/N in T-1.  Lean-core only. -/
theorem session_208_m_n_PDG_anchor_headline :
    0 < m_n_PDG
    ∧ m_n_PDG > 939 ∧ m_n_PDG < 940
    ∧ m_n_PDG > m_p_PDG
    ∧ m_n_PDG - m_p_PDG > 1 ∧ m_n_PDG - m_p_PDG < 2 :=
  ⟨T1_m_n_PDG_pos, T1_m_n_PDG_gt_939, T1_m_n_PDG_lt_940,
   T1_m_n_gt_m_p, T1_m_n_minus_m_p_gt_1, T1_m_n_minus_m_p_lt_2⟩

end OmegaTheory.Predictions.T1_NeutronMassPDG
