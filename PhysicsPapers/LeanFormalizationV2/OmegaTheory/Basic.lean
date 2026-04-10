/-
  OmegaTheory — Discrete Spacetime with Error-Propagating Tensor Calculus

  A Lean 4 formalization of the Omega Theory of discrete quantum gravity.
  Key insight: Einstein's equations emerge from a discrete lattice where
  computational truncation errors are bounded and self-healing.

  Architecture (bottom-up):
  1. Foundations.ErrorAlgebra — how errors compose
  2. Spacetime.Lattice — Z^4 lattice
  3. Spacetime.Constants — Planck scale constants
  (more layers added as foundations are proven solid)
-/

-- Layer 0: Foundations
import OmegaTheory.Foundations.ErrorAlgebra

-- Layer 1: Discrete Spacetime
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Spacetime.Operators

-- Layer 2: Error-Propagating Tensor Operations
import OmegaTheory.Tensor.ErrorTensor
import OmegaTheory.Tensor.Operations

-- Layer 3: Discrete Differential Geometry
import OmegaTheory.Geometry.Metric
import OmegaTheory.Geometry.Connection
import OmegaTheory.Geometry.Curvature
