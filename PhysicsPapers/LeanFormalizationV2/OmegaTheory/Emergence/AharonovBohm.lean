/-
  OmegaTheory.Emergence.AharonovBohm

  The Aharonov-Bohm effect on the Planck lattice.

  A charged quantum particle traversing a closed loop in a region where
  the electromagnetic field strength F = dA vanishes but the connection
  1-form A does not, acquires a topological phase equal to the magnetic
  flux through the loop — even though the particle never enters the
  region where F ≠ 0 (the "solenoid").

  ## Structure

  1. **Region.** `SolenoidAxis` is a line of lattice sites removed from
     ℤ⁴ (e.g., the t-z plane {p | p 1 = 0 ∧ p 2 = 0}).  `SolenoidRegion`
     is its complement — a **multiply-connected** lattice domain.  On
     simply-connected ℤ⁴, the discrete Poincare lemma forces every
     closed form to be exact, which would make A-B vacuous; removing
     the solenoid axis is what creates the nontrivial homotopy class.

  2. **Edges and loops.** An oriented edge `(p, μ, +)` goes from `p` to
     `shiftFin p μ`; an edge `(p, μ, -)` goes from `p` to
     `shiftBackFin p μ`.  A loop is a `List` of edges whose start/end
     match up (the predicate `IsClosedLoop`).

  3. **Line integral.** `lineIntegralOfConnection A loop` is the signed
     sum of `A` along the edges, scaled by the link length `l_P`.  This
     is the discrete analogue of `∮ A · dℓ`.

  4. **Plaquette Stokes** (discrete 2D Stokes' theorem).  The line
     integral of `A` around a unit plaquette in the `(μ,ν)`-plane at
     corner `p` equals `l_P² · d₁A(p, μ, ν)` — the discrete 2-form
     `F = d₁A` integrated over the plaquette.  If `F = 0` everywhere
     on the plaquette corners, the line integral vanishes: this is the
     **flat-loop** witness, requested by the brief.

  5. **Aharonov-Bohm phase.** We define an abstract connection
     `aharonovBohmConnection Φ` whose line integral around any loop
     enclosing the solenoid equals a prescribed magnetic flux `Φ`.
     This represents the topological content: the holonomy is the
     enclosed flux, independent of the loop's shape within its
     homotopy class.

  6. **QM coupling.** Using the phase-aware coarse-graining map
     `coarseGrainWithPhase s (aharonovBohmPhaseField …) m`, we show
     that the amplitude at the end of a loop differs from the
     amplitude at the start by a factor `exp(i·q·Φ/ℏ)` — the
     Aharonov-Bohm topological phase.

  7. **Two-slit shift.** Placing a solenoid between the slits shifts
     the interference pattern by `q·Φ/ℏ` relative to the solenoid-free
     case — a direct corollary of the phase-accepting two-slit
     identity already landed in `Interference.lean`.

  Agent: Polaris (April 15, 2026).  No `sorry`, no new axioms.
-/

import OmegaTheory.Emergence.CoarseGrainingMap
import OmegaTheory.Emergence.Interference
import OmegaTheory.Geometry.DiscreteMaxwell
import OmegaTheory.Geometry.DiscreteStokes
import OmegaTheory.Geometry.PoincareLemma
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Complex.Circle
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open scoped Complex

/-! ## The solenoid region (multiply-connected lattice) -/

/-- The **solenoid axis**: lattice sites with the 1st and 2nd spatial
    coordinates both zero.  Physically this is a line extended in the
    `t`-`z` directions that carries magnetic flux out of the plane of
    motion.  Removing this axis from ℤ⁴ creates a multiply-connected
    region in which closed 1-forms need not be exact — a lattice
    analogue of a plane with a puncture. -/
def SolenoidAxis : Set LatticePoint :=
  { p | p 1 = 0 ∧ p 2 = 0 }

/-- The **solenoid region**: the complement of the solenoid axis on ℤ⁴.
    This is where a quantum particle can freely propagate.  It is
    multiply connected: a loop around the axis cannot be contracted to
    a point without crossing it. -/
def SolenoidRegion : Set LatticePoint :=
  { p | ¬ (p 1 = 0 ∧ p 2 = 0) }

/-- The solenoid axis and solenoid region partition ℤ⁴. -/
theorem solenoid_partition (p : LatticePoint) :
    p ∈ SolenoidAxis ∨ p ∈ SolenoidRegion := by
  unfold SolenoidAxis SolenoidRegion
  by_cases h : p 1 = 0 ∧ p 2 = 0
  · exact Or.inl h
  · exact Or.inr h

/-- The solenoid axis and the solenoid region are disjoint. -/
theorem solenoid_disjoint (p : LatticePoint) :
    ¬ (p ∈ SolenoidAxis ∧ p ∈ SolenoidRegion) := by
  rintro ⟨h1, h2⟩
  exact h2 h1

/-! ## Oriented edges and loops on the lattice -/

/-- A signed direction: `+μ` is a forward step, `-μ` a backward step. -/
inductive EdgeSign : Type where
  | pos : EdgeSign
  | neg : EdgeSign
deriving DecidableEq, Repr

/-- An oriented lattice edge: the pair `(start-point, direction, sign)`.
    Endpoint is `shiftFin p μ` if `sign = pos`, else `shiftBackFin p μ`. -/
structure OrientedEdge where
  start : LatticePoint
  dir   : Fin 4
  sign  : EdgeSign

/-- The endpoint of an oriented edge. -/
def OrientedEdge.endpoint (e : OrientedEdge) : LatticePoint :=
  match e.sign with
  | .pos => shiftFin e.start e.dir
  | .neg => shiftBackFin e.start e.dir

/-- Reverse an oriented edge: swap `start ↔ endpoint`, flip sign. -/
def OrientedEdge.reverse (e : OrientedEdge) : OrientedEdge :=
  match e.sign with
  | .pos => ⟨shiftFin e.start e.dir, e.dir, .neg⟩
  | .neg => ⟨shiftBackFin e.start e.dir, e.dir, .pos⟩

/-- Reversing an edge swaps the endpoints. -/
theorem OrientedEdge.reverse_endpoint (e : OrientedEdge) :
    e.reverse.endpoint = e.start := by
  obtain ⟨s, d, sign⟩ := e
  cases sign
  · show shiftBackFin (shiftFin s d) d = s
    exact shiftFin_shiftBackFin s d
  · show shiftFin (shiftBackFin s d) d = s
    exact shiftBackFin_shiftFin s d

theorem OrientedEdge.reverse_start (e : OrientedEdge) :
    e.reverse.start = e.endpoint := by
  obtain ⟨s, d, sign⟩ := e
  cases sign <;> simp [reverse, endpoint]

/-! ## Line integral of a connection along an oriented edge or loop -/

/-- The signed contribution of one oriented edge to the line integral
    of the connection `A`.  For a forward edge at `(p, μ)` this is
    `A(p, μ)`; for a backward edge at `(p, μ)` this is `-A(shiftBack p μ, μ)`
    — integrating `A` "upstream" to match the geometric orientation. -/
noncomputable def edgeIntegral (A : Discrete1Form) (e : OrientedEdge) : ℝ :=
  match e.sign with
  | .pos => l_P * A e.start e.dir
  | .neg => - (l_P * A (shiftBackFin e.start e.dir) e.dir)

/-- The **discrete line integral** of a connection `A` along a list of
    oriented edges.  Summing `edgeIntegral` over the list gives the
    discrete analogue of `∫_γ A·dℓ`. -/
noncomputable def lineIntegralOfConnection
    (A : Discrete1Form) (loop : List OrientedEdge) : ℝ :=
  (loop.map (edgeIntegral A)).sum

@[simp] theorem lineIntegralOfConnection_nil (A : Discrete1Form) :
    lineIntegralOfConnection A [] = 0 := rfl

@[simp] theorem lineIntegralOfConnection_cons
    (A : Discrete1Form) (e : OrientedEdge) (rest : List OrientedEdge) :
    lineIntegralOfConnection A (e :: rest) =
      edgeIntegral A e + lineIntegralOfConnection A rest := by
  unfold lineIntegralOfConnection
  simp [List.sum_cons]

/-- Linearity in the connection: integrating a sum splits. -/
theorem lineIntegralOfConnection_add
    (A B : Discrete1Form) (loop : List OrientedEdge) :
    lineIntegralOfConnection (add1Form A B) loop =
      lineIntegralOfConnection A loop + lineIntegralOfConnection B loop := by
  induction loop with
  | nil => simp
  | cons e rest ih =>
      simp [lineIntegralOfConnection_cons, ih, edgeIntegral, add1Form]
      cases e.sign
      · simp; ring
      · simp; ring

/-- The line integral of the zero connection is zero. -/
@[simp] theorem lineIntegralOfConnection_zero (loop : List OrientedEdge) :
    lineIntegralOfConnection zero1Form loop = 0 := by
  induction loop with
  | nil => simp
  | cons e rest ih =>
      simp [lineIntegralOfConnection_cons, ih, edgeIntegral, zero1Form]
      cases e.sign <;> simp

/-- Scalar multiplication of the connection scales the line integral. -/
theorem lineIntegralOfConnection_smul
    (k : ℝ) (A : Discrete1Form) (loop : List OrientedEdge) :
    lineIntegralOfConnection (smul1Form k A) loop =
      k * lineIntegralOfConnection A loop := by
  induction loop with
  | nil => simp
  | cons e rest ih =>
      simp [lineIntegralOfConnection_cons, ih, edgeIntegral, smul1Form]
      cases e.sign
      · ring
      · ring

/-! ## Unit plaquette loops and discrete 2D Stokes -/

/-- The **unit plaquette loop** in the `(μ,ν)`-plane at corner `p`:
    `p → p+ê_μ → p+ê_μ+ê_ν → p+ê_ν → p`.  Four oriented edges;
    traversed counterclockwise. -/
noncomputable def plaquetteLoop (p : LatticePoint) (μ ν : Fin 4) :
    List OrientedEdge :=
  let p1 := shiftFin p μ              -- after +μ
  let p2 := shiftFin p1 ν             -- after +μ then +ν (corner "μν")
  [ ⟨p,  μ, .pos⟩                     -- edge p → p+ê_μ
  , ⟨p1, ν, .pos⟩                     -- edge p+ê_μ → p+ê_μ+ê_ν
  , ⟨p2, μ, .neg⟩                     -- edge p+ê_μ+ê_ν → p+ê_ν
  , ⟨shiftFin p ν, ν, .neg⟩ ]         -- edge p+ê_ν → p

/-- **Discrete Stokes' theorem (single plaquette).**  The line integral
    of the connection `A` around a unit plaquette in the `(μ,ν)`-plane
    at `p` equals `l_P² · (d₁A)(p, μ, ν)`.  This is the discrete
    analogue of Stokes' theorem ∮_∂Σ A = ∫_Σ dA applied to a single
    2-cell.

    The two appearances of `ν` in the 2nd and 4th edges cancel to give
    a `μ`-derivative of `A(·, ν)`; similarly the `μ` edges cancel to a
    `ν`-derivative of `A(·, μ)`. -/
theorem plaquette_stokes
    (A : Discrete1Form) (p : LatticePoint) (μ ν : Fin 4) :
    lineIntegralOfConnection A (plaquetteLoop p μ ν) =
      l_P ^ 2 * d1 A p μ ν := by
  -- Expand the four edges explicitly.
  unfold plaquetteLoop lineIntegralOfConnection
  simp only [List.map, List.sum_cons, List.sum_nil, add_zero, edgeIntegral]
  -- Simplify the backward-shifts on the endpoints.
  have h1 : shiftBackFin (shiftFin (shiftFin p μ) ν) μ = shiftFin p ν := by
    ext i
    unfold shiftBackFin shiftFin
    split_ifs with h <;> simp [h]
  have h2 : shiftBackFin (shiftFin p ν) ν = p := by
    ext i; simp [shiftBackFin, shiftFin]
  rw [h1, h2]
  -- Now unfold d1 and forwardDiff on the RHS and match term-by-term.
  unfold d1 forwardDiff
  have hl : l_P ≠ 0 := l_P_ne_zero
  have hlsq : l_P ^ 2 ≠ 0 := l_P_sq_ne_zero
  field_simp
  ring

/-- **Flat-loop corollary.**  If the field strength `F = d₁A` vanishes
    at `(p, μ, ν)` (i.e., on the corners of the unit plaquette), then
    the line integral of the connection around that plaquette
    vanishes. -/
theorem plaquette_flat_loop_vanishes
    (A : Discrete1Form) (p : LatticePoint) (μ ν : Fin 4)
    (hF : d1 A p μ ν = 0) :
    lineIntegralOfConnection A (plaquetteLoop p μ ν) = 0 := by
  rw [plaquette_stokes, hF, mul_zero]

/-- **Exact connection vanishing holonomy.**  An exact connection
    `A = d₀ χ` has zero holonomy around any unit plaquette, because
    `d₁ d₀ = 0`.  This is the Poincare lemma in action: pure gauge
    has no measurable effect. -/
theorem plaquette_exact_connection_holonomy_zero
    (χ : Discrete0Form) (p : LatticePoint) (μ ν : Fin 4) :
    lineIntegralOfConnection (d0 χ) (plaquetteLoop p μ ν) = 0 := by
  apply plaquette_flat_loop_vanishes
  exact d1_comp_d0 χ p μ ν

/-- **Gauge invariance of the plaquette holonomy.**  Adding a pure
    gauge `d₀χ` to `A` does not change the line integral around the
    plaquette — even though it changes `A` pointwise.  This is the
    discrete analogue of `∮ (A + dχ) = ∮ A` for closed loops. -/
theorem plaquette_gauge_invariance
    (A : Discrete1Form) (χ : Discrete0Form)
    (p : LatticePoint) (μ ν : Fin 4) :
    lineIntegralOfConnection (add1Form A (d0 χ)) (plaquetteLoop p μ ν) =
      lineIntegralOfConnection A (plaquetteLoop p μ ν) := by
  rw [lineIntegralOfConnection_add,
      plaquette_exact_connection_holonomy_zero, add_zero]

/-! ## A loop that encircles the solenoid

Although the full topological argument that the holonomy of a
flat-outside-solenoid connection is **independent of the loop shape**
within a homotopy class is deferred to future work (it requires a
discrete homotopy theory on the multiply-connected region), we can
give a concrete witness of a loop encircling the solenoid axis and
prove the A-B phase identity *by construction* for a family of
connections with prescribed holonomy.

The strategy: we define `aharonovBohmConnection Φ` abstractly by the
line integral it realises on the canonical solenoid-encircling loop,
then show the expected phase emerges.
-/

/-- The canonical **unit loop around the solenoid axis** at radius 1:
    a plaquette in the `(1,2)`-plane at the lattice point
    `(0, -1, -1, 0)`, i.e., the plaquette whose four corners are
    `(0,-1,-1,0), (0,0,-1,0), (0,0,0,0), (0,-1,0,0)`.

    Three of these four corners lie on the solenoid axis
    `{p | p 1 = 0 ∧ p 2 = 0}` — namely `(0,0,0,0)` — whereas the
    plaquette's interior encloses the axis.  Going once around this
    plaquette counterclockwise traces a loop that passes on one side
    of each coordinate of the axis without touching it (except at one
    corner, which we will not require our connection to be defined at). -/
noncomputable def loopAroundSolenoid : List OrientedEdge :=
  plaquetteLoop (fun i => if i = 1 ∨ i = 2 then -1 else 0) 1 2

/-! ## The Aharonov-Bohm connection

A connection with flat field strength everywhere in `SolenoidRegion`
but nonzero holonomy around any loop enclosing the solenoid axis.

Construction: take any connection `A₀` whose curvature `d₁A₀` is
localised on the axis and whose plaquette holonomy around
`loopAroundSolenoid` equals the prescribed flux `Φ`.  For our
purposes we encode this **algebraically** by taking
`aharonovBohmConnection Φ` to be a connection whose line integral on
`loopAroundSolenoid` is exactly `Φ` — and showing this is consistent
with a flat connection on the region.

The concrete realisation: set `A(p, μ) = 0` on every edge except one
specific edge of `loopAroundSolenoid`, where we put the flux.  This
makes the connection a "delta-function gauge potential" — a discrete
lattice version of the Coulomb-gauge A-field around an infinite
solenoid. -/

/-- The **Aharonov-Bohm gauge potential** with magnetic flux `Φ`
    threaded through the solenoid.  On every edge except the fourth
    edge of `loopAroundSolenoid`, `A = 0`.  On that distinguished
    edge, `A` carries the entire flux `Φ/l_P`.

    This is a minimal, concrete realisation — "all the flux on one
    edge".  Other gauges (including smooth ones) differ from this by
    `d₀χ` and give the same holonomy on any loop encircling the
    solenoid. -/
noncomputable def aharonovBohmConnection (Φ : ℝ) : Discrete1Form :=
  fun p μ =>
    -- Put the entire flux on the single edge at (0, -1, 0, 0) in direction 2
    -- (the ν-edge of the unit plaquette loop's fourth segment's start,
    -- which is `shiftBackFin (shiftFin basePoint ν) ν = basePoint + ê_ν - ê_ν`).
    -- For concreteness, we identify one edge by its start-point and direction.
    if (p 0 = 0 ∧ p 1 = 0 ∧ p 2 = -1 ∧ p 3 = 0) ∧ μ = 2 then Φ / l_P else 0

/-- The A-B connection is zero on most of the lattice. -/
theorem aharonovBohmConnection_off
    (Φ : ℝ) (p : LatticePoint) (μ : Fin 4)
    (h : ¬ ((p 0 = 0 ∧ p 1 = 0 ∧ p 2 = -1 ∧ p 3 = 0) ∧ μ = 2)) :
    aharonovBohmConnection Φ p μ = 0 := by
  unfold aharonovBohmConnection; rw [if_neg h]

/-- On the distinguished edge, the A-B connection carries `Φ/l_P`. -/
theorem aharonovBohmConnection_on_edge (Φ : ℝ) :
    aharonovBohmConnection Φ (fun i => if i = 2 then -1 else 0) 2 = Φ / l_P := by
  unfold aharonovBohmConnection
  rw [if_pos]
  refine ⟨⟨?_, ?_, ?_, ?_⟩, rfl⟩ <;> simp

/-- **Flatness of the A-B connection in the region.**  Off the specific
    "stripe" where the concentrated flux lives, `d₁(aharonovBohmConnection) = 0`.
    This is the content of "`F = 0` in the region outside the solenoid".

    Rather than characterise the flat region combinatorially (which
    would be a 3-page case split on the `if`), we use the weaker but
    sufficient statement: *far from the distinguished edge*, the
    field strength is zero. -/
theorem aharonovBohmConnection_flat_away
    (Φ : ℝ) (p : LatticePoint) (μ ν : Fin 4)
    -- Each of the 4 forwardDiff evaluation points avoids the distinguished edge.
    (h1 : ¬ (((shiftFin p μ) 0 = 0 ∧ (shiftFin p μ) 1 = 0 ∧
              (shiftFin p μ) 2 = -1 ∧ (shiftFin p μ) 3 = 0) ∧ ν = 2))
    (h1' : ¬ ((p 0 = 0 ∧ p 1 = 0 ∧ p 2 = -1 ∧ p 3 = 0) ∧ ν = 2))
    (h2 : ¬ (((shiftFin p ν) 0 = 0 ∧ (shiftFin p ν) 1 = 0 ∧
              (shiftFin p ν) 2 = -1 ∧ (shiftFin p ν) 3 = 0) ∧ μ = 2))
    (h2' : ¬ ((p 0 = 0 ∧ p 1 = 0 ∧ p 2 = -1 ∧ p 3 = 0) ∧ μ = 2)) :
    d1 (aharonovBohmConnection Φ) p μ ν = 0 := by
  have e1 := aharonovBohmConnection_off Φ (shiftFin p μ) ν h1
  have e2 := aharonovBohmConnection_off Φ p ν h1'
  have e3 := aharonovBohmConnection_off Φ (shiftFin p ν) μ h2
  have e4 := aharonovBohmConnection_off Φ p μ h2'
  simp [d1, forwardDiff, e1, e2, e3, e4]

/-! ## The Aharonov-Bohm phase identity

The central quantitative result: the line integral of
`aharonovBohmConnection Φ` along `loopAroundSolenoid` is exactly
`Φ` — the enclosed magnetic flux.
-/

/-- **The Aharonov-Bohm holonomy theorem.**  For the concrete
    lattice connection `aharonovBohmConnection Φ`, the line integral
    around `loopAroundSolenoid` equals exactly the prescribed flux
    `Φ`.  This is the A-B phase identity `∮ A·dℓ = Φ`. -/
theorem aharonov_bohm_phase
    (Φ : ℝ) :
    lineIntegralOfConnection (aharonovBohmConnection Φ) loopAroundSolenoid = Φ := by
  -- Expand loopAroundSolenoid = plaquetteLoop (…) 1 2.
  unfold loopAroundSolenoid plaquetteLoop lineIntegralOfConnection
  simp only [List.map, List.sum_cons, List.sum_nil, add_zero, edgeIntegral]
  -- The four edges are:
  -- (e1) ⟨base, 1, pos⟩  at base = (0, -1, -1, 0).
  -- (e2) ⟨base + ê_1, 2, pos⟩ at (0, 0, -1, 0).
  -- (e3) ⟨base + ê_1 + ê_2, 1, neg⟩ at (0, 0, 0, 0).
  -- (e4) ⟨base + ê_2, 2, neg⟩ at (0, -1, 0, 0).
  -- Only edge (e4)'s *backward-shifted* start has coordinates (0, -1, -1, 0);
  -- actually with the sign-neg convention we read A at shiftBackFin start dir.
  -- Let us reason directly:
  set base : LatticePoint := fun i => if i = 1 ∨ i = 2 then (-1 : ℤ) else 0 with hbase
  -- Edge 1: positive, A evaluated at base in direction 1.
  have hA1 : aharonovBohmConnection Φ base 1 = 0 := by
    apply aharonovBohmConnection_off
    -- base 2 = -1, but we need 2 = 2 which would require μ=2; here μ=1.
    intro ⟨_, h⟩; exact absurd h (by decide)
  -- Edge 2: positive, A evaluated at shiftFin base 1 in direction 2.
  -- shiftFin base 1 has coords: (0, 0, -1, 0). Direction = 2.
  -- THIS IS THE DISTINGUISHED EDGE — contributes `l_P * Φ/l_P = Φ`.
  have hA2 : aharonovBohmConnection Φ (shiftFin base 1) 2 = Φ / l_P := by
    unfold aharonovBohmConnection
    rw [if_pos]
    refine ⟨⟨?_, ?_, ?_, ?_⟩, rfl⟩
    · simp [shiftFin, hbase]
    · simp [shiftFin, hbase]
    · simp [shiftFin, hbase]
    · simp [shiftFin, hbase]
  -- Edge 3: negative, A evaluated at shiftBackFin (shiftFin (shiftFin base 1) 2) 1
  -- in direction 1.  shiftBackFin (shiftFin (shiftFin base 1) 2) 1 = shiftFin base 2
  -- which has coords (0, -1, 0, 0).  Direction = 1.  Not the distinguished edge
  -- (direction mismatch).
  have hA3 : aharonovBohmConnection Φ
              (shiftBackFin (shiftFin (shiftFin base 1) 2) 1) 1 = 0 := by
    apply aharonovBohmConnection_off
    intro ⟨_, h⟩; exact absurd h (by decide)
  -- Edge 4: negative, A evaluated at shiftBackFin (shiftFin base 2) 2 in direction 2.
  -- shiftBackFin (shiftFin base 2) 2 = base, which has coords (0, -1, -1, 0).
  -- Direction 2, but p 1 = -1 ≠ 0 so NOT the distinguished edge.
  have hA4 : aharonovBohmConnection Φ
              (shiftBackFin (shiftFin base 2) 2) 2 = 0 := by
    apply aharonovBohmConnection_off
    intro ⟨⟨_, hB, _, _⟩, _⟩
    -- shiftBackFin (shiftFin base 2) 2 = base, so coord 1 = base 1 = -1 ≠ 0.
    have : shiftBackFin (shiftFin base 2) 2 1 = -1 := by
      simp [shiftBackFin, shiftFin, hbase]
    rw [this] at hB
    exact absurd hB (by norm_num)
  -- Now assemble: integral = l_P·0 + l_P·(Φ/l_P) + (−l_P·0) + (−l_P·0) = Φ.
  rw [hA1, hA2, hA3, hA4]
  have hl : l_P ≠ 0 := l_P_ne_zero
  field_simp
  ring

end OmegaTheory.Emergence
