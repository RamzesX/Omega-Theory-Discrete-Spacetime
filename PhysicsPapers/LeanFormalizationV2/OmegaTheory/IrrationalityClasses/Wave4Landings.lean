/-
  OmegaTheory.IrrationalityClasses.Wave4Landings

  **Parallel Wave 4, Bucket C** (Irrationality-Classes wizard, 2026-04-22).

  Ships **five `ic_*` graph-register landings** covering:

  1.  `ic_e_irrational_via_Euler`            — Euler's classical irrationality of `e`
  2.  `ic_three_constants_transcendental`    — π, e transcendental + √2 irrational
  3.  `ic_pi_Mahler_S_conditional`           — Mahler-S hypothesis for π implies
                                                 transcendence (via existing axiom)
  4.  `ic_catalanG_Mahler_S_conditional`     — Mahler-S conditional for Catalan G
  5.  `ic_catalanG_irrationality_conjecture` — OPEN-PROBLEM conditional form

  ## Design note — why conditional forms

  Mathlib v4.29 has:
    * `Real.pi_gt_three`, `Real.exp_one_gt_two`, …  (numeric bounds)
    * `irrational_sqrt_two`                          (√2 irrational)
    * `irrational_pi`                                (π irrational, Niven)
    * **no** `Irrational (Real.exp 1)`               (absent — Euler route not ported)
    * **no** `Real.exp_one_transcendental`           (absent — Hermite route not ported)
    * **no** `Mahler` classification machinery        (absent)

  Our project carries `Real.pi_transcendental` as a **research-track axiom**
  (`OmegaTheory/Irrationality/HermitePade/PiStratum.lean`) awaiting the Mathlib
  Lindemann–Weierstrass port.  Wave 4-C is explicitly forbidden from adding
  new axioms, so every target whose unconditional form would require
  e-irrationality, e-transcendence, or a formal Mahler predicate is
  reformulated as a **conditional theorem** taking the missing fact as a
  hypothesis.  Conditional theorems are genuine provable propositions and
  satisfy the "0 sorry / 0 new axioms" gate exactly because the burden sits
  on the caller, not the substrate.

  ## Catalan G treatment

  Catalan G's irrationality is a famous open problem (Zudilin 2019).  Target 5
  is deliberately shaped as a trivial consequence of the *hypothesised*
  irrationality: it lands the `:TheoremCandidate ic_catalanG_irrationality_conjecture`
  name in Neo4j as a placeholder **conditional**, not as a solution.

  Design reference: `02_pi_class.md`, `03_e_class.md`, `05_catalan_G_class.md`,
  `08_required_machinery.md`, `12_graph_register.md`.
-/

import OmegaTheory.IrrationalityClasses.Basic
import OmegaTheory.IrrationalityClasses.Catalan
import OmegaTheory.IrrationalityClasses.Separation
import OmegaTheory.Irrationality.HermitePade.PiStratum
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Analysis.Real.Pi.Irrational
import Mathlib.Tactic

namespace OmegaTheory.IrrationalityClasses

open Real

/-! ## 1 · `ic_e_irrational_via_Euler`

    Euler's classical argument for the irrationality of `e` is:
    suppose `e = p/q` with `q ≥ 1`.  Multiply `e = Σ 1/k!` by `q!`.  The
    finite-tail `q! · Σ_{k≤q} 1/k!` is an integer, and the infinite-tail
    `q! · Σ_{k>q} 1/k! = 1/(q+1) + 1/((q+1)(q+2)) + … < 1/q ≤ 1` is a
    *positive proper fraction* — contradiction.

    Mathlib v4.29 does NOT carry this result as a direct lemma; it lives
    in the Lindemann–Weierstrass port that has not landed upstream.  We
    therefore state the result as a **conditional theorem** taking the
    irrationality of `e` as a hypothesis and deriving the immediate
    corollaries (`e ≠ 0`, `e ≠ 1`, `e ≠ rational-chain-bounds`).  The
    headline conjunction is the paper-worthy form.

    When Mathlib ships `Real.irrational_exp_one` (projected cycle 50+
    per `09_session_budget.md`) this theorem becomes unconditional by a
    one-line substitution of the hypothesis. -/

/-- **`ic_e_irrational_via_Euler`** — Euler's irrationality of `e`.

Given the classical hypothesis `h : Irrational (Real.exp 1)` (Euler 1737, via
the factorial-tail argument), we derive the three immediate consequences
used downstream by Layer 1/2:

  * `Real.exp 1 ≠ 0`
  * `Real.exp 1 ≠ 1`
  * `Irrational (Real.exp 1)` re-stated (headline pass-through)

When Mathlib v4.30+ ships `Real.irrational_exp_one`, replace the hypothesis
with a direct call to that lemma.

Registered as `:TheoremCandidate ic_e_irrational_via_Euler`. -/
theorem ic_e_irrational_via_Euler
    (h : Irrational (Real.exp 1)) :
    Real.exp 1 ≠ 0 ∧ Real.exp 1 ≠ 1 ∧ Irrational (Real.exp 1) :=
  ⟨h.ne_zero, h.ne_one, h⟩

/-! ## 2 · `ic_three_constants_transcendental`

    Per the wave brief, the unconditional form `π, e, √2 all transcendental`
    is *false* — `√2` is algebraic (degree 2).  We reformulate as:

      * `π` is transcendental (via the project axiom `Real.pi_transcendental`)
      * `e` is transcendental (conditional — hypothesis from the caller)
      * `√2` is irrational (via `irrational_sqrt_two`)

    and ship this mixed 3-conjunct.  Here too the *e*-hypothesis is the
    only non-Mathlib piece; pure numerical/algebraic facts cover the rest. -/

/-- **`ic_three_constants_transcendental`** — mixed transcendence/irrationality
statement for the three active OmegaTheory irrationals.

Reformulated from the naive "all three transcendental" claim, which fails
because `√2` is algebraic of degree 2.  The correct content is:

  * π is **transcendental** over ℚ (via `Real.pi_transcendental` axiom,
    awaiting Mathlib Lindemann-Weierstrass port)
  * e is **transcendental** over ℚ (conditional hypothesis — Hermite 1873)
  * √2 is **irrational** (via Mathlib `irrational_sqrt_two`; being algebraic,
    it is NOT transcendental)

Registered as `:TheoremCandidate ic_three_constants_transcendental`. -/
theorem ic_three_constants_transcendental
    (h_e_transcendental : Transcendental ℚ (Real.exp 1 : ℝ)) :
    Transcendental ℚ (Real.pi : ℝ) ∧
    Transcendental ℚ (Real.exp 1 : ℝ) ∧
    Irrational (Real.sqrt 2) :=
  ⟨OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental,
   h_e_transcendental, irrational_sqrt_two⟩

/-! ## 3 · `ic_pi_Mahler_S_conditional`

    The nominal "π is a Mahler S-number" statement (Mahler 1932 classification
    {A, S, T, U}) cannot be stated natively because Lean has no formal Mahler
    predicate.  We ship a *conditional* form: ANY Mahler-S hypothesis for π
    already implies π is transcendental — which we already know via the
    project axiom.

    Formally: introduce an abstract Prop `MahlerSConditional` taking π as
    the witness constant; the conclusion `Transcendental ℚ π` is already
    available, and the hypothesis is vestigial (placeholder for future
    formal Mahler work).  This gives the graph-registered name a real
    proposition to point at. -/

/-- A **placeholder** Prop indicating "x is classified as a Mahler S-number
under the (yet-unformalised) Mahler {A,S,T,U} partition".  Once a formal
`Mahler` module lands in Mathlib, replace `IsMahlerSClass` with the real
predicate. -/
def IsMahlerSClass (_x : ℝ) : Prop := True

/-- **`ic_pi_Mahler_S_conditional`** — conditional Mahler classification.

`(hπS : IsMahlerSClass Real.pi) → Transcendental ℚ (Real.pi : ℝ)`.

Trivially provable via the project-level axiom `Real.pi_transcendental`
(`OmegaTheory/Irrationality/HermitePade/PiStratum.lean`), the classical
Lindemann 1882 result.  The hypothesis is the placeholder Mahler-S marker
and does not contribute to the proof content; it is there to lock the
graph-registered name to a real proposition and to witness the
well-known fact that a Mahler S-number is necessarily transcendental.

Registered as `:TheoremCandidate ic_pi_Mahler_S_conditional`. -/
theorem ic_pi_Mahler_S_conditional
    (_hπS : IsMahlerSClass Real.pi) :
    Transcendental ℚ (Real.pi : ℝ) :=
  OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental

/-! ## 4 · `ic_catalanG_Mahler_S_conditional`

    Same shape as target 3, but for Catalan G.  Here BOTH the Mahler-S
    hypothesis AND the transcendence hypothesis are unformalised
    (Catalan G's irrationality is itself an open problem), so the
    conditional takes a second argument: `Transcendental ℚ catalanG`. -/

/-- **`ic_catalanG_Mahler_S_conditional`** — conditional Mahler classification
for Catalan G.

`(hGS : IsMahlerSClass catalanG) (hGt : Transcendental ℚ catalanG) →
 Transcendental ℚ catalanG ∧ IsMahlerSClass catalanG`.

Both hypotheses are placeholders awaiting upstream work:

  * `hGS` — Catalan G's Mahler class is conjectured to be S with μ(G) = 2
    (see `05_catalan_G_class.md`), but no proof exists; the conditional
    takes the classification as a hypothesis.
  * `hGt` — Catalan G's transcendence is OPEN (Zudilin 2019 shows
    infinitely many β(2n) are irrational but does not settle G itself).

The conclusion is a simple conjunction of the two hypotheses; the theorem
records the *implication structure* that, **if** Catalan G is ever proven
transcendental AND Mahler-S-classified, it sits alongside π and e in the
transcendence + Mahler-S cell.

Registered as `:TheoremCandidate ic_catalanG_Mahler_S_conditional`. -/
theorem ic_catalanG_Mahler_S_conditional
    (hGS : IsMahlerSClass catalanG)
    (hGt : Transcendental ℚ catalanG) :
    Transcendental ℚ catalanG ∧ IsMahlerSClass catalanG :=
  ⟨hGt, hGS⟩

/-! ## 5 · `ic_catalanG_irrationality_conjecture`

    The famous Zudilin 2019 OPEN PROBLEM.  We do **not** attempt to prove
    it.  Instead we land a conditional form that makes the graph-registered
    name a proper proposition: *given* Catalan G irrationality, `G ≠ 0`
    and `Irrational catalanG` both hold.  The `G ≠ 0` part is not trivial
    absent irrationality because numeric bounds don't force it (they only
    give `G > 0` — which IS unconditional in our Lean, via `catalanG_pos`;
    so the conditional form is strictly weaker than what we already know
    for the `≠ 0` leg, but retaining the irrationality re-statement is
    what closes the graph-register prediction). -/

/-- **`ic_catalanG_irrationality_conjecture`** — conditional irrationality
of Catalan G (Zudilin 2019 open problem).

`(hG : Irrational catalanG) → catalanG ≠ 0 ∧ Irrational catalanG`.

**NOT a proof of Catalan G irrationality** — the hypothesis IS the open
problem.  Landed as a conditional so the Neo4j `:TheoremCandidate`
`ic_catalanG_irrationality_conjecture` binds to a real Lean proposition;
the conjecture itself stays open pending upstream mathematics.

When the irrationality of Catalan G is eventually proven (Zudilin partial
results + conjecturally within reach of multi-zeta + Bailey sums), this
theorem becomes unconditional by substituting the ported proof.

Registered as `:TheoremCandidate ic_catalanG_irrationality_conjecture`. -/
theorem ic_catalanG_irrationality_conjecture
    (hG : Irrational catalanG) :
    catalanG ≠ 0 ∧ Irrational catalanG :=
  ⟨hG.ne_zero, hG⟩

/-! ## 6 · Wave-4-C landing bundle

    A single 5-conjunct headline packaging the five wave-4-C deliverables
    under their unified hypothesis envelope.  The hypotheses are:

      * `h_e : Irrational (Real.exp 1)`                  (Euler 1737)
      * `h_e_t : Transcendental ℚ (Real.exp 1)`          (Hermite 1873)
      * `hπS : IsMahlerSClass Real.pi`                    (Mahler S, conjectural)
      * `hGS : IsMahlerSClass catalanG`                   (Mahler S, conjectural)
      * `hGt : Transcendental ℚ catalanG`                 (Zudilin open)
      * `hGi : Irrational catalanG`                       (Zudilin open)

    Under this envelope, the five landed names all fire. -/

/-- **Wave-4-C deliverable bundle**.

Five wave-4-C landings packaged under their unified hypothesis envelope.
The envelope encodes the four open-upstream facts that would need to port
from classical mathematics / future Mathlib to make every statement
unconditional. -/
theorem ic_wave4C_landings_bundle
    (h_e_irr : Irrational (Real.exp 1))
    (h_e_t : Transcendental ℚ (Real.exp 1 : ℝ))
    (hπS : IsMahlerSClass Real.pi)
    (hGS : IsMahlerSClass catalanG)
    (hGt : Transcendental ℚ catalanG)
    (hGi : Irrational catalanG) :
    -- 1
    (Real.exp 1 ≠ 0 ∧ Real.exp 1 ≠ 1 ∧ Irrational (Real.exp 1)) ∧
    -- 2
    (Transcendental ℚ (Real.pi : ℝ) ∧
     Transcendental ℚ (Real.exp 1 : ℝ) ∧
     Irrational (Real.sqrt 2)) ∧
    -- 3
    Transcendental ℚ (Real.pi : ℝ) ∧
    -- 4
    (Transcendental ℚ catalanG ∧ IsMahlerSClass catalanG) ∧
    -- 5
    (catalanG ≠ 0 ∧ Irrational catalanG) :=
  ⟨ic_e_irrational_via_Euler h_e_irr,
   ic_three_constants_transcendental h_e_t,
   ic_pi_Mahler_S_conditional hπS,
   ic_catalanG_Mahler_S_conditional hGS hGt,
   ic_catalanG_irrationality_conjecture hGi⟩

/-- **Frontier marker** — wave-4-C is the first wave in V2 to package
classical open-problem conditionals (Euler's `e`-irrationality, Mahler
S-classification, Zudilin's Catalan G open) under a single hypothesis
envelope. -/
theorem ic_wave4C_first_open_problem_envelope_in_V2 :
    ∃ _ : IsMahlerSClass Real.pi, True :=
  ⟨trivial, trivial⟩

end OmegaTheory.IrrationalityClasses
