# ROADMAP — Future Attacks on K₂-Opacity of π

**Methodology (agreed with Norbert, 2026-04-14)**: enumerate every known attack vector, try each honestly, record what works and what blocks. Whatever vectors remain open after exhaustion *are* the next-phase research targets. Barrier theorems ("this method provably cannot work") are publishable on their own — this diary has three (Decoupling 4C.3, Universal Siegel Barrier 4D.2, Hermite-Padé/Liouville reformulation in Module 11).

See also: `README.md` (theory), `SETUP.md` (tools), `ATTEMPTS.md` (log), `11-Attack19-Hermite-Pade-Pre-Siegel.md` (current attack in depth).

---

## 1. Where we are at end of Session 6

### Closed (BLOCKED with proven barriers — publishable as negative results)

| Attack | Vector | Barrier reached |
|---|---|---|
| 7–8 | Siegel-Shidlovskii extended to $\overline{\mathbb{Q}}[\pi]$ | Decoupling Theorem 4C.3 |
| 9 | Nesterenko-Philippon nonlinear | Universal Siegel Barrier 4D.2 |
| 11 | Jet / context compression | Reformulation only (G-jet flat, F25) |
| 15 | FA Specialization (ou → et) | Decoupling at Siegel step |

### Alive — no barrier reached yet

| # | Attack | Status end of Session 6 | Blocker |
|---|---|---|---|
| **19** | **Pure Hermite-Padé over $\mathbb{Z}[\pi]$** (Escanor) | ALIVE, quantitative frontier | Needs slice change, 2-adic toolkit, or sharper $\mu(\pi)$ |
| 13 | Congruence incompatibility | ALIVE, most promising classically | Formalize F27 linear-vs-log ord_p growth as full proof |
| 12 | Carlitz-Frobenius bridge | ALIVE, Mahler × Fuchsian specialization | GAP_C: mixed specialization theorem |
| 14 | Motivic periods | CONDITIONAL ALIVE | Grothendieck Period Conjecture |

### Computational evidence accumulated (all in `sage/` + Neo4j `pi_sun`)

- Target A: Padé polynomials for slice $(1/2, 3/2, 1/2)$, $n = 1..6$, all integer evaluations
- Target B: extended to $n = 20$, super-exponential decay $|L_n| \sim 1/(3n)!$ confirmed
- Target E: p-adic structure — $p = 2$ shows strong E-signature (slope $4n$), $p \geq 3$ flat

---

## 2. Immediate next moves (in recommended order)

### Session 7 — Falsifiability test of Conjecture 4A.4

**Tool**: `mpmath.pslq` (already have) or PARI `lindep` (install first).

**What**: compute $u = {}_1F_1(1/2; 3/2; 1/2)$, $v = {}_1F_1'(1/2; 3/2; 1/2)$ to 500–1000 digits. Run PSLQ on the tuple $[1, \pi, \pi^2, \pi^3, u, v, \pi u, \pi v]$ looking for integer relations of height $\leq 10^{200}$.

**Outcomes**:
- **PSLQ finds no relation**: strong empirical evidence FOR Conjecture 4A.4 for this slice. Confidence upgrade.
- **PSLQ finds a relation**: the attack is over (in an informative way — we have a counterexample candidate). Verify symbolically (SageMath / PARI). If the relation holds, Conjecture 4A.4 is FALSE for this slice, and Attack 19 collapses (but the method still applies elsewhere).
- **PSLQ borderline**: run at higher precision.

**Cost**: 30 minutes of coding + 5 minutes compute. **Highest information density** of any single task in the roadmap.

**Output**: `sage/target_f_pslq_falsifiability.py`, Neo4j `TargetF_PSLQ` node, memo note.

### Session 8 — Slice change: $(1/3, 4/3, 1/3)$

**Why**: Target E showed that at $(1/2, 3/2, 1/2)$ all p-adic mass is at $p = 2$, breaking the planned marriage with Attack 13's Lucas-congruence toolkit (which needs odd primes). Shifting to $(1/3, 4/3, z_0)$ concentrates p-adic mass at $p = 3$.

**What**: rerun Targets A, B, E on the new slice. Check:
1. Does kernel remain 1-dimensional (F49)? Expected yes.
2. Does decay remain $\sim 1/(3n)!$ (F50)? Expected yes.
3. Does $\operatorname{ord}_3$ grow linearly (F52 rescue)? Expected yes; this is the key question.

If F52 holds at $p = 3$, we can invoke ADH 2016 Lucas-congruence machinery directly — Attack 13 × Attack 19 synergy restored.

**Cost**: 1–2 hours (modify scripts, rerun, update module + graph).

**Output**: `sage/target_a_b_e_slice_1_3_4_3.py`, Neo4j new ComputationalResult nodes, Module 11 §Section on slice comparison.

### Session 9 — Formalize Decoupling Theorem in Lean

**Why**: the Decoupling Theorem 4C.3 is the central barrier of the entire project. Every "BLOCKED by Siegel" verdict depends on it. A machine-verified proof removes all risk of a subtle error propagating through future sessions.

**What**: create `OmegaTheory/Irrationality/HermitePade/Decoupling.lean` in `PhysicsPapers/LeanFormalizationV2/`. Statement and proof (~50 lines):

```lean
theorem decoupling {K : Type*} [Field K] [Algebra ℚ K]
    (θ : K) (hθ : Transcendental ℚ θ)
    {T N D : ℕ} (S : Matrix (Fin T) (Fin N) ℚ)
    (c : Fin (D+1) → Fin N → ℤ)
    (h : ∑ d, θ^(d : ℕ) • (S.map (algebraMap ℚ K) *ᵥ
                           (fun i => ((c d i : ℤ) : K))) = 0) :
    ∀ d, S.map (algebraMap ℚ K) *ᵥ (fun i => ((c d i : ℤ) : K)) = 0
```

Proof: transcendence of $\theta$ gives `LinearIndependent ℚ (fun d => θ^d)`; apply to the expansion.

**Cost**: 1 working session with Mathlib search. Most of the time goes into finding the right lemma names.

**Output**: `Decoupling.lean` in Lean project, graph link to Barrier node.

### Session 10 — Rigorous bound for Target B via Arb

**Why**: Target B reported "|L_20| ≈ 4.9e-74" — a floating-point estimate. To feed this into the formal Lean argument we need **certified intervals**.

**What**: rewrite `target_b_asymptotic.py` using `python-flint`'s `arb` / `acb` types. Every $|L_n|$ becomes an interval $[a_n, b_n]$ with proven error radius. The resulting bounds can be ported directly into Lean as `∃ proof`.

**Cost**: 2–3 hours (port + verify).

**Output**: `sage/target_b_rigorous.py`, proven bounds for $n \leq 20$, data artefact for Lean import.

### Session 11 — Attack 13 independent closure

**Why**: Attack 13 (Congruence Incompatibility) is currently "ALIVE, most promising" in the diary but never fully developed. Session 11 opens it as a first-class attack on its own, independent of whether Attack 19's slice-change rescue (Session 8) succeeds.

**What**: formalize F27 linear-vs-log $\operatorname{ord}_p$ growth into an actual proof of E/G separation:
- E-function coefficient $c_n$: $\operatorname{ord}_p(c_n) = \Theta(n)$ (from factorials in Pochhammer denominators)
- G-function coefficient $d_n$: $\operatorname{ord}_p(d_n) = O(\log n)$ (from rational-function coefficients)
- Apply ADH 2016 Lucas-congruence extension to derive: no mixed E + G linear combination can vanish at algebraic points if $\operatorname{ord}_p$ discrepancy is forced.

**Cost**: multi-session. Deep literature work (ADH 2016 framework + extensions).

**Output**: Module 12 (Attack 13 development), possible standalone paper if it goes through.

---

## 3. Longer-term attacks (Sessions 12+)

### Attack 20 candidate — Hodge-theoretic via period monodromy

**Idea**: Π appears as a period of the exponential (e^{iπ} + 1 = 0). The Stokes multipliers of the Kummer irregular singularity at $\infty$ also contain π. A consistency condition between the "π-from-E-function-ratio" and the "π-from-Stokes-data" could be violated by explicit computation. Uses Dettweiler-Reiter motivic framework.

**Blocker**: requires Hodge-theoretic / motivic machinery not yet in our toolkit. May need Mathematica's modular form library, or external collaboration with a Hodge theorist.

### Attack 21 candidate — Nesterenko-modular μ(π) sharpening

**Idea**: Nesterenko 1996 used Ramanujan modular systems to prove tr.deg$\{\pi, e^\pi, \Gamma(1/4)\} = 3$. A refined version for E-function value systems could produce a sharper $\mu(\pi)$ bound. If $\mu(\pi)$ drops below 3, the revised GAP_F (Module 11 §11.7a) fires at $n^* \sim 10^3$ — reachable by computation.

**Blocker**: requires modular-form infrastructure. SageMath has partial; Mathematica has full. Good candidate for "conditionally install Mathematica if this attack is prioritized."

### Attack 22 candidate — Subspace theorem of Schmidt

**Idea**: Schmidt's subspace theorem is the multi-dimensional generalization of Roth's theorem. It doesn't go through Siegel's existential lemma (so Decoupling doesn't block), and has been used by Adamczewski-Bugeaud 2005 to get irrationality measures for automatic numbers. Could potentially attack K₂-opacity of π directly.

**Blocker**: Schmidt subspace theorem not formalized in Mathlib. Deep theorem; axiomatizing it is honest but we'd want to trace the logical dependency tree carefully.

---

## 4. Formalization program (Lean 4 + Mathlib)

**Strategic purpose**: after enumeration of informal attacks, the remaining BLOCKED conjectures are candidates for formal proof. Lean makes informal arguments auditable and provides a collaborative artifact even non-mathematicians can interrogate.

### Phase 1 — barrier theorems (already partially written informally)

| Theorem | Lean file | Cost estimate | Depends on |
|---|---|---|---|
| F49 Hermite-Padé existence | `F49_Existence.lean` | ~50 lines | Matrix rank-nullity (in Mathlib) |
| F50 super-exponential decay | `F50_Decay.lean` | ~100 lines | Adapts existing `e_error_bound` |
| F53 π-stratum separation | `F53_PiStratum.lean` | ~30 lines | `Transcendental ℚ π` axiom (see Phase 2) |
| Decoupling Theorem 4C.3 | `Decoupling.lean` | ~50 lines | `Transcendental ℚ π`, linear algebra |
| Universal Siegel Barrier 4D.2 | `UniversalBarrier.lean` | ~150 lines | Decoupling Theorem, auxiliary-function framework |

### Phase 2 — axioms we will have to state explicitly

Until these are formalized in Mathlib, we take them as cited axioms (with paper references):

```lean
-- Lindemann 1882
axiom Real.pi_transcendental : Transcendental ℚ Real.pi

-- Siegel 1929 + Shidlovskii 1956
axiom siegel_shidlovskii {K : Type*} [Field K] (f : Fin n → FormalPowerSeries K) ...

-- Salikhov 2008 / Zeilberger-Zudilin 2020
axiom mu_pi_bound : ∀ q : ℚ, |Real.pi - q.num / q.den| > 1 / q.den^(7.1032)
```

Each axiom carries a clear bibliographic citation. When Mathlib formalizes one, we remove the axiom line.

### Phase 3 — open statements

The informal conjectures (4A.4, revised GAP_F, GAP_C, GAP_D) are stated in Lean as theorems with `sorry`. This makes them:
- concrete shared goals (not prose)
- collaboratively attackable (anyone can try to replace the `sorry`)
- monotonically convergent — partial proofs land as sublemmas

---

## 5. Publication strategy

**Paper 1 (now-publishable)**: "The Decoupling Theorem and Universal Siegel Barrier for Mixed E/G Specialization."
- Content: Theorems 4C.3 + 4D.2, stated and proved informally, then machine-verified in Lean (Phase 1 target).
- Audience: *Journal de Théorie des Nombres de Bordeaux*, *Acta Arithmetica*, or arxiv first.
- Author: Norbert Marchewka, with clear "AI-assisted, sessions 1–5" disclosure.

**Paper 2 (pending Session 8)**: "Pre-Siegel Hermite-Padé Attack on K₂-Opacity of π: Structure of the Quantitative Frontier."
- Content: Attack 19's framework, Target A–E numerics, revised GAP_F formulation.
- Needs: slice change success (Session 8), rigorous bounds (Session 10).
- Conditional on positive results.

**Paper 3 (long-term)**: "A Formal Proof Assistant Approach to Transcendence Barriers" — the Lean formalization as a standalone software-engineering contribution.

---

## 6. Tool-installation gates

Each session's start requires certain tools. From `SETUP.md`:

| Session | Tools required | Currently available |
|---|---|---|
| 7 (PSLQ falsifiability) | mpmath OR PARI | ✓ mpmath; PARI is a 2-min install |
| 8 (slice change) | Python + sympy + mpmath | ✓ all available |
| 9 (Lean Decoupling) | Lean 4 + Mathlib v4.29 | ✓ already cached |
| 10 (rigorous bounds) | python-flint (Arb) | need 5-min install |
| 11+ (Attack 13) | SageMath helpful, PARI essential | need installs |

**Recommended pre-sessions install**: the one-shot command from `SETUP.md §3` (~7 minutes).

---

## 7. Failure-mode planning (Popperian honest)

If the whole attack family ultimately blocks, the diary documents:
- 19+ attempts tried
- 4 proven barrier theorems (publishable)
- Precise arithmetic locus identified (Module 04A §4A.9)
- Quantitative threshold $n^* \sim 10^8$ derived
- Lean-formalized barriers available for anyone else to build on
- Neo4j namespace preserved as research map

That alone is publishable as "the current state of knowledge on K₂-opacity of π", analogous to published surveys of the Riemann Hypothesis or Goldbach: honest, detailed, useful.

---

## 8. Decision points for Norbert (one per session)

Each session opens with one explicit choice:
1. Which attack vector this session tackles (from §2 or §3 list)
2. Which tool installation, if any, to front-load
3. Honest "BLOCKED / ALIVE / DEAD" verdict at session close

No session extends forever. Every session produces artifacts: a module update, Neo4j nodes, memo file, and updated `ATTEMPTS.md` entry.

---

*Last updated: 2026-04-14, end of Session 6.*
*Next session start: run `SETUP.md §3` one-shot install, then open Session 7 with PSLQ falsifiability test.*
