/-
  OmegaTheory.Foundations.HiggsBosonAsFockExcitation

  **Lion's-Pride Phase 6.5s (2026-05-06)**:
  *The Higgs boson as a Fock-space excitation around the substrate
  vacuum, using the existing `TruncatedFockSpace` infrastructure.
  Each excitation level corresponds to "n Higgs particles" with
  energy `n · m_H · c²` above the vacuum.*

  ## Why this file

  Phase 7.1 shipped `TruncatedFockSpace` with:
  * `numberOperatorTruncated N` : (N+1)×(N+1) diagonal matrix diag(0..N)
  * `harmonicHamiltonianTruncated ω N` := ω·N̂ + ω/2·I
  * Eigenvalue `Ĥ k k = ω·(k + 1/2)` (harmonic oscillator)

  This file specializes the Fock-space machinery to the HIGGS:
  * The Higgs Fock space is single-mode (one species per energy level)
  * The mode frequency is `ω_H := m_H_substrate · c² / ℏ`
  * Each excitation level n ↔ "n Higgs particles" with total energy
    `E_n = n · ℏ·ω_H + ℏ·ω_H/2 = (n + 1/2) · m_H · c²`
  * The vacuum energy `E_0 = ℏω_H/2 = m_H·c²/2` is the substrate's
    irreducible quantum-fluctuation residue.

  ## What this file ships

  | Property                                          | Theorem                                       |
  |---------------------------------------------------|-----------------------------------------------|
  | `higgsModeFrequency_substrate N := m_H·c²/ℏ`       | (definition)                                  |
  | `higgsHamiltonian_substrate N` (Fock Hamiltonian)  | (definition: harmonic oscillator at ω_H)     |
  | Eigenvalue at level k = (k+1/2)·m_H·c²            | `higgsHamiltonian_substrate_eigenvalue`        |
  | Vacuum energy = m_H·c²/2 = ℏω_H/2                 | `higgsHamiltonian_substrate_vacuumEnergy`      |
  | Single-Higgs energy gap = m_H·c²                   | `higgsHamiltonian_substrate_excitation_gap`    |
  | Headline 4-conjunct                                | `higgs_boson_as_fock_excitation_report`        |

  ## Honest scope

  This file ships the rigorous algebraic structure of the Higgs
  boson as a Fock excitation in the existing TruncatedFockSpace.
  It does NOT ship:

  * The full path-integral derivation of Higgs scattering amplitudes
    (Phase 9 + Phase 7.6 multi-month).
  * The connection of `m_H·c²/ℏ` to a CONTINUUM Klein-Gordon mode
    on smooth manifolds (Phase 6.5s-cont, multi-week).

  What it DOES ship: the formal identification of the Higgs boson
  with the substrate's harmonic-oscillator Fock state at frequency
  `ω_H = m_H·c²/ℏ`, derived purely from Phase 3.4 substrate Higgs
  mass + Spacetime constants.

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure composition: TruncatedFockSpace + HiggsCreationEventScale.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Foundations.TruncatedFockSpace
import OmegaTheory.Foundations.HiggsCreationEventScale
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.HiggsBosonAsFockExcitation

open OmegaTheory.Foundations.TruncatedFockSpace
open OmegaTheory.Foundations.HiggsCreationEventScale
open OmegaTheory.HealingFlow.HiggsMassFromCurvature
open OmegaTheory.Spacetime
open OmegaTheory.Irrationality

/-! ## 1. Higgs mode frequency

    `ω_H := m_H · c² / ℏ` — the angular frequency associated with
    the Higgs rest energy, by de Broglie/Planck-Einstein. -/

/-- **Higgs mode angular frequency** at substrate iteration N:
    `ω_H(N) := √(m_H²(N)) · c² / ℏ`. -/
noncomputable def higgsModeFrequency_substrate (N : ℕ) : ℝ :=
  Real.sqrt (higgs_mass_sq_substrate N) * c ^ 2 / hbar

/-- **Higgs mode frequency is strictly positive**. -/
theorem higgsModeFrequency_substrate_pos (N : ℕ) :
    0 < higgsModeFrequency_substrate N := by
  unfold higgsModeFrequency_substrate
  have h_m_pos := higgs_mass_sq_substrate_pos N
  have h_sqrt_pos : 0 < Real.sqrt (higgs_mass_sq_substrate N) :=
    Real.sqrt_pos.mpr h_m_pos
  have h_c_pos := c_pos
  have h_c_sq_pos : (0 : ℝ) < c ^ 2 := by positivity
  have h_hbar_pos := hbar_pos
  positivity

/-! ## 2. Higgs Fock-space Hamiltonian -/

/-- **Higgs harmonic-oscillator Hamiltonian** on the truncated
    Fock space `Fin(K+1)` at substrate iteration N:
    `Ĥ_H(N, K) := ω_H(N) · N̂ + ω_H(N)/2 · I`. -/
noncomputable def higgsHamiltonian_substrate (N : ℕ) (K : ℕ) :
    Matrix (Fin (K + 1)) (Fin (K + 1)) ℂ :=
  harmonicHamiltonianTruncated (higgsModeFrequency_substrate N) K

/-! ## 3. Eigenvalues at each excitation level -/

/-- **k-th excitation eigenvalue** of the Higgs Hamiltonian:
    `Ĥ_H k k = ω_H · (k + 1/2)`. Multiply by ℏ to recover energy
    `E_k = ℏω_H · (k + 1/2) = (k + 1/2) · m_H · c²`. -/
theorem higgsHamiltonian_substrate_eigenvalue (N : ℕ) (K : ℕ) (k : Fin (K + 1)) :
    (higgsHamiltonian_substrate N K) k k
      = ((higgsModeFrequency_substrate N : ℂ)) * ((k.val : ℂ) + 1 / 2) := by
  unfold higgsHamiltonian_substrate
  exact harmonicHamiltonian_eigenvalue_k _ K k

/-! ## 4. Vacuum energy -/

/-- **Vacuum energy of the Higgs Fock space**:
    `E_0(N) = ω_H(N) / 2 = m_H · c² / (2ℏ)` (in angular-freq units;
    multiply by ℏ for energy → `m_H·c²/2`).

    This is the substrate's irreducible Higgs zero-point energy —
    even in the n=0 "no Higgs" state, the substrate retains this
    fluctuation energy. -/
theorem higgsHamiltonian_substrate_vacuumEnergy (N : ℕ) (K : ℕ) :
    (higgsHamiltonian_substrate N K) ⟨0, Nat.succ_pos K⟩ ⟨0, Nat.succ_pos K⟩
      = (higgsModeFrequency_substrate N : ℂ) / 2 := by
  unfold higgsHamiltonian_substrate
  exact harmonicHamiltonian_vacuumEnergy _ K

/-! ## 5. Single-Higgs excitation gap -/

/-- **Single-Higgs energy gap**: from level k to level k+1, the
    Hamiltonian eigenvalue increases by `ω_H` (i.e., one quantum
    `ℏω_H = m_H·c²` of Higgs energy).

    Concretely:
    `Ĥ_H (k+1) (k+1) − Ĥ_H k k = ω_H`. -/
theorem higgsHamiltonian_substrate_excitation_gap
    (N : ℕ) (K : ℕ) (k : Fin K) :
    (higgsHamiltonian_substrate N (K + 1)) ⟨k.val + 1, by omega⟩ ⟨k.val + 1, by omega⟩
      - (higgsHamiltonian_substrate N (K + 1)) ⟨k.val, by omega⟩ ⟨k.val, by omega⟩
      = (higgsModeFrequency_substrate N : ℂ) := by
  rw [higgsHamiltonian_substrate_eigenvalue, higgsHamiltonian_substrate_eigenvalue]
  push_cast
  ring

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 6.5s headline — Higgs boson as Fock excitation.**

    For substrate iteration N and Fock-space truncation K:

    1. **Higgs frequency positivity**:
       `0 < ω_H(N) = √(m_H²)·c²/ℏ`.

    2. **k-th eigenvalue**:
       `Ĥ_H(N, K) k k = ω_H(N) · (k + 1/2)`.
       Energy `E_k = (k + 1/2) · m_H · c²`.

    3. **Vacuum energy**:
       `Ĥ_H(N, K) 0 0 = ω_H(N)/2 = m_H·c²/(2ℏ)`.

    4. **Single-Higgs excitation gap**:
       `Ĥ_H(N, K+1) (k+1) − Ĥ_H(N, K+1) k = ω_H(N) = m_H·c²/ℏ`. -/
theorem higgs_boson_as_fock_excitation_report
    (N : ℕ) (K : ℕ) (k : Fin K) :
    0 < higgsModeFrequency_substrate N ∧
    (higgsHamiltonian_substrate N K) ⟨0, Nat.succ_pos K⟩ ⟨0, Nat.succ_pos K⟩
      = (higgsModeFrequency_substrate N : ℂ) / 2 ∧
    (∀ K' : ℕ, ∀ j : Fin (K' + 1),
       (higgsHamiltonian_substrate N K') j j
         = ((higgsModeFrequency_substrate N : ℂ)) * ((j.val : ℂ) + 1 / 2)) ∧
    (higgsHamiltonian_substrate N (K + 1)) ⟨k.val + 1, by omega⟩ ⟨k.val + 1, by omega⟩
      - (higgsHamiltonian_substrate N (K + 1)) ⟨k.val, by omega⟩ ⟨k.val, by omega⟩
      = (higgsModeFrequency_substrate N : ℂ) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact higgsModeFrequency_substrate_pos N
  · exact higgsHamiltonian_substrate_vacuumEnergy N K
  · intros K' j
    exact higgsHamiltonian_substrate_eigenvalue N K' j
  · exact higgsHamiltonian_substrate_excitation_gap N K k

end OmegaTheory.Foundations.HiggsBosonAsFockExcitation
