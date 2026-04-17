/-
  OmegaTheory.Emergence.AnomalyCancellation
  SM gauge anomaly vanishing (per Phecda's design). 0 sorry, 0 axioms.
-/

import OmegaTheory.Emergence.FermionContent
import Mathlib.Tactic

namespace OmegaTheory.Emergence

/-- Left-handed fermion species per generation. -/
inductive LHSpecies
  | QL | uRc | dRc | LL | eRc | nRc
  deriving DecidableEq, Fintype, Repr

/-- Multiplicity (isospin × color) for each LH species. -/
def multiplicity : LHSpecies → ℤ
  | .QL => 6  -- 2 isospin × 3 color
  | .uRc => 3 -- 3 color
  | .dRc => 3
  | .LL => 2  -- 2 isospin
  | .eRc => 1
  | .nRc => 1

/-- Hypercharge × 6 (integer-encoded to avoid rational). -/
def sixY : LHSpecies → ℤ
  | .QL  => 1    -- Y = 1/6 (note: using 6Y normalization)
  | .uRc => -4   -- Y = -2/3 (charge conjugate of uR)
  | .dRc => 2    -- Y = 1/3 (charge conjugate of dR)
  | .LL  => -3   -- Y = -1/2
  | .eRc => 6    -- Y = 1 (charge conjugate of eR)
  | .nRc => 0    -- Y = 0

def isDoublet : LHSpecies → Bool
  | .QL => true
  | .LL => true
  | _ => false

def isColoured : LHSpecies → Bool
  | .QL | .uRc | .dRc => true
  | _ => false

/-- U(1)_Y cubic anomaly. -/
def anomalyU1Cubed : ℤ :=
  Finset.univ.sum fun s : LHSpecies => multiplicity s * (sixY s)^3

/-- U(1)_Y × gravity² anomaly. -/
def anomalyU1Gravity : ℤ :=
  Finset.univ.sum fun s : LHSpecies => multiplicity s * sixY s

/-- U(1)_Y × SU(2)² anomaly (sum over doublets). -/
def anomalyU1SU2 : ℤ :=
  Finset.univ.sum fun s : LHSpecies => if isDoublet s then multiplicity s * sixY s else 0

/-- U(1)_Y × SU(3)² anomaly (sum over coloured species). -/
def anomalyU1SU3 : ℤ :=
  Finset.univ.sum fun s : LHSpecies => if isColoured s then multiplicity s * sixY s else 0

theorem anomaly_U1_cubed_vanishes : anomalyU1Cubed = 0 := by decide

theorem anomaly_U1_gravity_vanishes : anomalyU1Gravity = 0 := by decide

theorem anomaly_U1_SU2_squared_vanishes : anomalyU1SU2 = 0 := by decide

theorem anomaly_U1_SU3_squared_vanishes : anomalyU1SU3 = 0 := by decide

/-- Doublet count (number of SU(2) doublets per generation, with multiplicity). -/
def doubletCount : ℤ :=
  Finset.univ.sum fun s : LHSpecies => if isDoublet s then multiplicity s else 0

theorem witten_anomaly_even : Even doubletCount := ⟨4, by decide⟩

/-- Standard Model is anomaly-free (capstone bundle). -/
theorem standard_model_is_anomaly_free :
    anomalyU1Cubed = 0 ∧ anomalyU1Gravity = 0 ∧
    anomalyU1SU2 = 0 ∧ anomalyU1SU3 = 0 ∧ Even doubletCount :=
  ⟨anomaly_U1_cubed_vanishes, anomaly_U1_gravity_vanishes,
   anomaly_U1_SU2_squared_vanishes, anomaly_U1_SU3_squared_vanishes,
   witten_anomaly_even⟩

end OmegaTheory.Emergence
