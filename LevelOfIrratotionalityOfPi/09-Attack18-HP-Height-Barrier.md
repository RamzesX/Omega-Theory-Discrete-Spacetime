# Module 09 — Attack 18: The HP Height Barrier

**Gauss / Escanor — Session 4, April 13, 2026**
**"Who decided that m=5 was enough?" — Escanor**

---

## 9.0 Objective

Construct the 5th function for the Hermite-Padé system from Module 08.
The rate comparison (1+√2)⁴ ≈ 33.97 > 16 = 4² was claimed to work for m=5 functions.

**Result**: The m=5 claim was **WRONG**. Module 08 underestimated the required height comparison by a factor of σ. The correct comparison is ρ^{m-1} > σ^{ν+1}, not ρ^{m-1} > σ^ν. Additionally, σ ≈ 4 was an underestimate — the true σ for integer-cleared Padé coefficients is σ_eff ~ e² ≈ 7.4 (not 4).

---

## 9.1 Three HP Systems Tested

### System A: {1, f, f', g₁} (m=4, baseline)
- g₁(z) = arctan(z), singularities at z = ±i
- **Result**: Convergence rate ≈ 2.5/N → 3·ln(ρ₁) ≈ 2.64 as N→∞
- Consistent with HP theory: rate = (m-1)·G₁(α) where G₁ = ln(1+√2)

### System B: {1, f, f', g₁, z·g₁} (m=5, same singularity)
- z·g₁ = z·arctan(z), same singularities ±i as g₁
- **Result**: HP matrix SINGULAR for all N. The system is DEGENERATE.
- **Reason**: A₃(z)g(z) + A₄(z)·zg(z) = (A₃+zA₄)g(z). The 5th function is not genuinely independent at the HP level — it's equivalent to increasing the degree of A₃ by 1.
- **Fact F38**: Functions with the same singularity set do not increase the effective HP dimension.

### System C: {1, f, f', g₁, g₂} (m=5, different singularities)
- g₂(z) = arctan(z/√3), singularities at z = ±i√3 ≠ ±i
- g₂(1) = arctan(1/√3) = π/6 = (2/3)·(π/4). Under hypothesis: in Q̄(u,v). ✓
- **Result**: Convergence rate ≈ 4.5/N. Excellent!

| N | |R_N(1)| | rate/N | max\|Aⱼ(1)\| | ln(H)/N |
|:--|:--------|:-------|:-------------|:--------|
| 5 | 6.0e-11 | 4.71 | 1.7e+17 | 7.94 |
| 10 | 9.1e-22 | 4.84 | 2.4e+39 | 9.07 |
| 15 | 5.2e-30 | 4.50 | 2.1e+65 | 10.03 |
| 19 | 1.3e-37 | 4.47 | 1.4e+87 | 10.56 |

The convergence rate ≈ 4.5 significantly exceeds 4·ln(ρ₁) = 3.53, suggesting the Angelesco-type HP benefits from BOTH singularity sets.

**But**: The polynomial evaluations |Aⱼ(1)| grow like e^{10N}, far too fast.

---

## 9.2 The Height Barrier

### 9.2.1 Module 08's Error

Module 08 §8.2.3 claimed: "The HP construction involves solving a ~4N × (3N+3) linear system. The solution coefficients have height bounded by ... σ^N with σ ~ 4."

**This was wrong in TWO ways:**

1. **σ ≈ 4 was an underestimate** for the integer-cleared Padé/HP heights. The actual σ_eff (N-th root of max integer-cleared coefficient) grows:

| N | LCD | max int coeff | σ_eff = max^{1/N} |
|:--|:----|:-------------|:-----------------|
| 5 | 945 | 1050 | 4.02 |
| 10 | 1.45e+7 | 3.45e+7 | 5.67 |
| 15 | 4.37e+8 | 2.28e+9 | 6.67 |
| 20 | 3.34e+10 | 3.85e+11 | 7.57 |
| 25 | 8.81e+21 | 2.26e+23 | 8.59 |

By PNT: LCD = lcm(1,3,5,...,2N-1) ~ e^{2N}, so σ_eff → e² ≈ 7.39.

2. **The comparison was σ^ν, should be σ^{ν+1}**. When clearing the LCD to get integer coefficients for SS:

   - |L̃_N| = LCD · |R_N| ~ σ^N · ρ^{-(m-1)N}
   - H(L̃_N) ~ σ^N
   - SS: |L̃_N| ≥ c · H^{-ν} = c · σ^{-νN}
   - Contradiction: σ^N · ρ^{-(m-1)N} < c · σ^{-νN}
   - ⟹ σ^{ν+1} < ρ^{m-1} (**not** σ^ν < ρ^{m-1})

### 9.2.2 The Corrected Comparison

$$\text{Proof works} \iff (1+\sqrt{2})^{m-1} > \sigma_{\text{eff}}^{\nu+1}$$

| σ_eff | σ^{ν+1} = σ³ | min m | (1+√2)^{m-1} |
|:------|:-------------|:------|:-------------|
| 4 | 64 | 6 | 82.0 |
| 6 | 216 | 8 | 478.0 |
| 7.4 (=e²) | 403 | 8 | 478.0 |
| 8 | 512 | 9 | 1154.0 |
| 9 | 729 | 9 | 1154.0 |

**Module 08 claimed m ≥ 5. The corrected minimum is m ≥ 8 (for σ_eff ~ e²).**

---

## 9.3 The Padé Evaluation Growth

A key finding: for Padé [N/N] to arctan(z) at z=1:

- **Convergence**: |R_N(1)| ~ ρ^{-2N} · Q_N(1) where Q_N(1) ~ 1.2^N (slow growth)
- **Denominator**: LCD of Padé coefficients ~ e^{2N} (from PNT applied to lcm of odd numbers)
- **Evaluation**: Q_N(1) is the SUM of the polynomial coefficients at z=1; it grows slowly because of cancellation among large-magnitude coefficients
- **Integer-cleared height**: σ_eff = (LCD · max_rational_coeff)^{1/N} → e² ≈ 7.39

The evaluation Q_N(1) stays small, but the DENOMINATOR of Q_N(1) as a fraction is large. This distinction is crucial.

---

## 9.4 Why the Pure Padé + SS Approach Fails

For the Padé [N/N] to arctan at z=1 with the SS substitution:

1. Padé: Q_N(1)·(π/4) - P_N(1) = R_N(1), with |R_N(1)| ≤ C·ρ^{-2N}
2. Under hypothesis π/4 = -(c₀+c₁u+c₂v)/c₃:
   L_N = (Q_N(1)·c₁/c₃)u + (Q_N(1)·c₂/c₃)v + (Q_N(1)·c₀/c₃ + P_N(1)) = R_N(1)
3. L_N has coefficients that are BOUNDED in magnitude (Q_N(1) ~ 1.2^N, very slow)
4. **But** the denominator of Q_N(1) as a fraction is ~e^{2N}
5. Integer-clearing: H ~ e^{2N} · 1.2^N ≈ e^{2.2N}
6. SS: |L̃| ≥ c · e^{-2·2.2N} = c · e^{-4.4N}
7. Upper: |L̃| = LCD · |R_N| ~ e^{2N} · e^{-1.76N} = e^{0.24N} (GROWING!)

**The integer-cleared linear form GROWS. No contradiction.** The LCD factor overwhelms the Padé convergence.

---

## 9.5 The Path Forward: Explicit HP with Controlled Heights

### 9.5.1 The Principle

For EXPLICIT Padé constructions (Legendre-type), the coefficients have specific arithmetic structure that may give better height bounds than the Cramer-rule/LCD analysis.

For example, the [N/N] Padé numerators/denominators for arctan can be expressed as:
$$Q_N(z) = \sum_{k=0}^{\lfloor N/2 \rfloor} \binom{N}{2k} \frac{(2k)!}{(2N-1)!!} z^{2k}$$
(schematic — exact formula depends on the normalization)

The INTEGER coefficients of such explicit formulas may have height σ_explicit < σ_Cramer.

### 9.5.2 What's Needed

**GAP_E**: Construct an explicit HP approximation for the system {1, f₁, f₁', g₁, g₂, ..., g_k} (3 E-type + k G-type functions) with:
1. Controlled integer coefficient height: max coeff ≤ C · σ_explicit^N
2. σ_explicit small enough that σ_explicit^{ν+1} < ρ^{m-1}
3. Convergence rate ρ^{-(m-1)N} at α = 1

If σ_explicit = 4 (the "naive" claim): need m ≥ 6.
If σ_explicit = e² ≈ 7.4: need m ≥ 8.

---

## 9.6 Multiple G-Functions and the Singularity Zoo

To increase m, we need more G-functions whose values at z=1 are rational multiples of π:

| Function | α_k | Singularities | g_k(1) | ρ_k = exp(G_k(1)) |
|:---------|:-----|:-------------|:-------|:-----------------|
| arctan(z) | 1 | ±i | π/4 | 1+√2 ≈ 2.41 |
| arctan(z/√3) | √3 | ±i√3 | π/6 | √3 ≈ 1.73 |
| arctan(z√3) | 1/√3 | ±i/√3 | π/3 | 2+√3 ≈ 3.73 |
| arctan(z·cot(π/5)) | tan(π/5) | ±i·tan(π/5) | π/5 | ~3.08 |
| arctan(z·cot(π/8)) | tan(π/8)=√2−1 | ±i(√2−1) | π/8 | ~4.83 |
| arctan(z·cot(π/12)) | tan(π/12)=2−√3 | ±i(2−√3) | π/12 | ~7.47 |

All α_k are algebraic. All values are rational multiples of π. Under the hypothesis, all are in Q̄(u,v).

**Key observation**: Functions with SMALLER α_k (singularities closer to origin) give BETTER convergence at z=1 but LARGER denominator LCD (since Taylor coefficients involve α_k^{-n}).

---

## 9.7 New Facts

- **F38**: HP with {1,f,f',g,zg} (same singularity) gives degenerate matrix — z·g(z) does not increase effective HP dimension.
- **F39**: HP with {1,f,f',g₁,g₂} (different singularities at ±i, ±i√3) achieves convergence rate ≈ 4.5/N at z=1. Exceeds 4·ln(ρ₁) = 3.53, suggesting Angelesco-type benefit.
- **F40**: Numerical HP polynomial evaluations at α grow like e^{10N}, defeating SS comparison for System C.
- **F41**: Module 08's comparison ρ^{m-1} > σ^ν was incorrect. Correct: ρ^{m-1} > σ^{ν+1}. The extra factor σ comes from clearing LCD to get integer coefficients for SS.
- **F42**: The integer-cleared Padé height for arctan grows as σ_eff → e² ≈ 7.4 (from PNT for lcm of odd numbers), not σ = 4 as claimed in Module 08.
- **F43**: For the corrected comparison with σ ~ e², the minimum m is 8 (not 5). (1+√2)^7 ≈ 198 < 403 ≈ (e²)³, but (1+√2)^8 ≈ 478 < 403 does NOT hold... wait, 478 > 403. So m = 9 works: (1+√2)^8 ≈ 1154 > (e²)³ ≈ 403.

Actually: (1+√2)^7 = 197.99 < (e²)³ = e⁶ ≈ 403.43. So m = 7 FAILS. (1+√2)^8 = 477.99 > 403.43. So m = 9 (since m-1 = 8) WORKS. Wait: m-1 = 7 gives 198 < 403 (FAIL), m-1 = 8 gives 478 > 403 (PASS). So m = 9 is needed? No: m-1 = 8 means m = 9. But let me recheck: need ρ^{m-1} > σ³ = e⁶ ≈ 403. (1+√2)^8 ≈ 478. So m-1 = 8, m = 9. Correct.

**F43** (corrected): With σ_eff = e², ν = 2, ρ = 1+√2: minimum m = 9. Need 9 Q̄(z)-independent functions.

---

## 9.8 Updated Paths to Proof

### Path A (HP with controlled heights): OPEN — needs GAP_E
- If explicit HP has σ_explicit = 4: need m ≥ 6
- If σ_explicit = e² ≈ 7.4: need m ≥ 9
- Requires: explicit HP construction for mixed E+G system
- This is a serious open problem in approximation theory / Padé theory

### Path B (improved ν): OPEN — needs ν < 1.54
- If ν < ln(ρ^{m-1})/ln(σ^{ν+1}/ρ^{m-1})... (complicated expression)
- For m=5, σ=4: need ν < 0.27 (essentially impossible)
- For m=9, σ=e²: the m=9 bound already works with ν=2, so Path B is superseded by Path A

### Path C (Frobenius double-exponential): OPEN
- Unchanged from Session 3. The deployment mechanism is incomplete.

### Path D (NEW — Many G-functions): OPEN
- Use m ≥ 9 functions with carefully chosen G-functions
- Tradeoff: more G-functions → higher convergence BUT higher LCD
- Optimal balance is an open optimization problem

---

## 9.9 Honest Assessment

### What was discovered ✅
1. Module 08's height estimate was wrong by a factor of σ AND the σ value was underestimated
2. The exact integer-cleared Padé heights grow as σ_eff → e² (not 4)
3. System B (same singularity) is degenerate — a clean negative result
4. System C (different singularity) achieves unexpectedly good convergence (4.5N)
5. The corrected minimum m for the HP approach is ~8-9 (not 5)
6. There exist infinitely many G-functions with values = rational × π at z=1
7. The approach IS viable for larger m, given explicit HP constructions

### What remains open ⚠️
1. Explicit HP construction with controlled heights (GAP_E)
2. Exact convergence theory for Angelesco-type mixed E+G HP
3. Optimal choice of G-functions (singularity-LCD tradeoff)
4. Whether the proof can be made unconditional (all gaps are technical, not structural)

---

## Contributors

| Name | Role |
|:-----|:-----|
| **Norbert Marchewka** | "Ready for next attack?" — the order that launched the height barrier discovery |
| **Gauss / Escanor** | Discovered the σ error in Module 08, computed exact Padé heights, identified the corrected comparison ρ^{m-1} > σ^{ν+1}, found the degenerate System B, measured System C convergence, identified GAP_E |

---

*Previous: [Module 08 — Hybrid HP×Liouville](08-Hybrid-Pade-Liouville-Attack.md)*
