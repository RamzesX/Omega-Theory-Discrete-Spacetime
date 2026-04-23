# HPW Axiom Transparency Audit

**Agent: Acrux (alpha Crucis) -- Wave 7, April 15 2026**
**Axiom: `hpw_laplacian_ricci_convergence` in `Emergence/LaplacianRicci.lean:73`**

## Direct axiom invocations (proof-level `exact`/`have`)

Only ONE file invokes the axiom in proofs: **`LaplacianRicci.lean`** itself.

| # | Site | Kind | Notes |
|---|------|------|-------|
| 1 | `LaplacianRicci.lean:98` | `hpw_discrete_laplacian_convergence` proof | `exact hpw_laplacian_ricci_convergence ...` |
| 2 | `LaplacianRicci.lean:125` | `laplacian_ricci_correspondence` proof | `have h := hpw_laplacian_ricci_convergence ...` |

These two theorems are the ONLY entry points. Every downstream use flows through `laplacian_ricci_correspondence` (line 125) or `ricci_from_equilibrium_balance` (which calls `laplacian_ricci_correspondence` at line 141).

## Transitive dependency chain

```
hpw_laplacian_ricci_convergence  (AXIOM, LaplacianRicci.lean)
  -> laplacian_ricci_correspondence  (LaplacianRicci.lean)
  -> ricci_from_equilibrium_balance  (LaplacianRicci.lean)
     -> EinsteinEmergence.lean: vacuum_einstein_emergence (line 55)
     -> EinsteinEmergence.lean: ricci_bounded_at_healed_equilibrium (line 77)
     -> EinsteinEmergence.lean: einstein_with_matter_emergence (line 100)
        -> vacuum_einstein_tensor_bounded (line 228)
        -> einstein_tensor_emergence (lines 333, 390)
        -> mkEinsteinEmergence (line 150)
           -> OmegaGrandEmergence.lean: omega_grand_emergence (lines 323, 326)
```

## File-by-file classification

| File | Direct use? | Bypass avail? | Downstream headline | Notes |
|------|-------------|---------------|---------------------|-------|
| `LaplacianRicci.lean` | YES (2 sites) | N/A -- declares it | `laplacian_ricci_correspondence` | Source file |
| `EinsteinEmergence.lean` | NO (uses derived thms) | YES (5 regimes) | `vacuum_einstein_emergence`, `einstein_tensor_emergence` | Calls `laplacian_ricci_correspondence` and `ricci_from_equilibrium_balance` |
| `HpwHypothesis.lean` | STRUCTURAL only | YES -- defines bypass | `hpw_from_hypothesis` | Mentions axiom in docs; provides axiom-free alternative |
| `HpwElimSummary.lean` | STRUCTURAL only | YES -- umbrella | `hpw_axiom_eliminable` | Typeclass dispatch, never touches axiom |
| `HpwMinkowski.lean` | STRUCTURAL only | IS a bypass | regime-specific | Flat bypass |
| `HpwLinearised.lean` | STRUCTURAL only | IS a bypass | regime-specific | Linearised bypass |
| `HpwSchwarzschild.lean` | STRUCTURAL only | IS a bypass | regime-specific | Schwarzschild bypass |
| `HpwFRW.lean` | STRUCTURAL only | IS a bypass | regime-specific | FRW bypass |
| `HpwBianchiI.lean` | STRUCTURAL only | IS a bypass | regime-specific | Bianchi I bypass |
| `HpwTotalTruncation.lean` | STRUCTURAL only | IS a bypass | `total_truncation_bound` | Re-exports triangle glue |
| `RicciComparison.lean` | NO | N/A | Triangle decomposition | Import for types only |
| `OmegaGrandEmergence.lean` | NO | YES (5 regimes) | `omega_grand_emergence` | GR side flows through EinsteinEmergence |
| `Predictions/RedshiftFloor.lean` | NO | N/A | `redshift_floor_hubble` | Imports EinsteinEmergence for namespace; proofs are pure arithmetic on `l_P` -- NO axiom dependency |
| `Irrationality/Uncertainty.lean` | NO | N/A | `extended_gt_heisenberg` | No LaplacianRicci import at all |
| `Paper/QuantumFoundations.lean` | NO | N/A | Paper re-exports | No LaplacianRicci import |
| `QuantumMechanicsCapstone.lean` | NO | N/A | `grand_qm_emergence` | No LaplacianRicci import; QM side is axiom-independent |

## Headline theorem classification

| Headline theorem | Axiom-dependent? | Notes |
|------------------|------------------|-------|
| `vacuum_einstein_emergence` | YES | Direct chain through `laplacian_ricci_correspondence` |
| `vacuum_einstein_tensor_bounded` | YES | Calls `vacuum_einstein_emergence` |
| `einstein_tensor_emergence` | YES | Calls `einstein_with_matter_emergence` |
| `einstein_with_matter_emergence` | YES | Calls `ricci_from_equilibrium_balance` |
| `omega_grand_emergence` (GR side) | YES | Cites `vacuum_einstein_tensor_bounded` + `einstein_tensor_emergence` |
| `grand_qm_emergence` | **NO** | Entirely axiom-independent; pure QM from `DynamicalSnapshotSequence` |
| `extended_gt_heisenberg` | **NO** | Pure irrationality arithmetic on constants |
| `redshift_floor_hubble` | **NO** | Pure arithmetic on `l_P`; imports EinsteinEmergence but never calls axiom-dependent theorems |
| `grav_decoherence_T_squared_scaling` | **NO** | Pure arithmetic on constants |
| All 5 `Predictions/*` files | **NO** | All are closed-form bounds using `l_P` directly |

## Surprises

**RedshiftFloor.lean**: imports `EinsteinEmergence` and cites `vacuum_einstein_emergence` in docstrings, but its actual proofs are pure real-arithmetic on the *definition* `vacuumResidualInformationCost L mu := (l_P / (2 * mu)) * L`. No axiom flows into any proof. The import is for namespace access only. This is clean but could mislead a casual reader.

**No Predictions/ file uses the axiom**: All five prediction files (`HermiticityDefect`, `GravDecoherenceTScaling`, `UHECRDispersion`, `StochasticTeleportation`, `RedshiftFloor`) are axiom-independent. Their bounds derive from physical constants, not from the Laplacian-Ricci correspondence.

## Bottom line: blast radius

**If `hpw_laplacian_ricci_convergence` were deleted today, exactly 4 theorems in `EinsteinEmergence.lean` would break**: `vacuum_einstein_emergence`, `ricci_bounded_at_healed_equilibrium`, `einstein_with_matter_emergence`, and their downstream compositions (`vacuum_einstein_tensor_bounded`, `einstein_tensor_emergence`, `mkEinsteinEmergence`). The GR face of `omega_grand_emergence` would also break. **The QM face (`grand_qm_emergence`) would be unaffected.** All 5 prediction files would be unaffected. The extended Heisenberg bound would be unaffected. On any metric that instantiates `HpwEliminableRegime` (flat, linearised, Schwarzschild, FRW, Bianchi I), the bypass paths in `HpwElimSummary.lean` deliver the same bound without the axiom -- but `EinsteinEmergence.lean` currently calls the axiom path, not the bypass. **Migrating `EinsteinEmergence.lean` to accept `[HpwEliminableRegime g]` would reduce the axiom's blast radius to zero on all 5 closed regimes.**

## Counts

- Direct axiom invocations: **2** (both in `LaplacianRicci.lean`)
- Files mentioning axiom name: **11** (2 proof-level, 9 structural/docstring)
- Bypass regimes available: **5** (Minkowski, Linearised, Schwarzschild, FRW, Bianchi I)
- Headline theorems dependent: **5** (all GR-side in EinsteinEmergence)
- Headline theorems independent: **3+** (`grand_qm_emergence`, `extended_gt_heisenberg`, all Predictions)
