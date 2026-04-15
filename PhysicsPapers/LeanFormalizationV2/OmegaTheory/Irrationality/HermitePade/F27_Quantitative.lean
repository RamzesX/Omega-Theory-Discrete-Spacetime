/-
  OmegaTheory.Irrationality.HermitePade.F27_Quantitative

  Quantitative form of F27 (Attack 13 ord_p dichotomy) —
  Paper-Attack13-Lucas-Extension §2.1, Proposition 2.1.

  Packages `F27_LegendreSlope.legendre_slope_bound` under a shorter
  name and records the factorial-valuation slope-of-1/(p-1) fact in
  the explicit form used by Attack 13's Lucas-separation argument.

  The underlying claim:
      k ≤ (p − 1) · v_p(k!) + (p − 1) · (log_p k + 1)
  rearranged: v_p(k!) ≥ k/(p−1) − (log_p k + 1), the asymptotic
  factorial-valuation slope.

  Byline: Norbert Marchewka and Rigel.
-/

import OmegaTheory.Irrationality.HermitePade.F27_LegendreSlope

namespace OmegaTheory.Irrationality.HermitePade

/--
**F27 quantitative slope (Paper-Attack13 §2.1 Proposition 2.1).**

For any prime `p` and any `k ≥ 1`,
    `k ≤ (p − 1) · v_p(k!) + (p − 1) · (log_p k + 1)`.

Re-export of `F27_LegendreSlope.legendre_slope_bound`, named for use
downstream in the Lucas-separation argument of Attack 13.
-/
theorem F27_quantitative
    {p : ℕ} [Fact p.Prime]
    {k : ℕ} (hk : k ≠ 0) :
    k ≤ (p - 1) * padicValNat p k.factorial + (p - 1) * (Nat.log p k + 1) :=
  legendre_slope_bound hk

end OmegaTheory.Irrationality.HermitePade
