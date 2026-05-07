# Convergence-validation notes

## Why the old results all showed `maxIter`

The old code used raw divergence as the continuity residual. Raw divergence does not account for cell area, so it scales with grid spacing and can look large even when the finite-volume mass imbalance is small.

The new code stores both:

- `FinalRcMass`: normalized finite-volume mass imbalance
- `FinalRcDiv`: raw divergence diagnostic

## Why the pressure solver was changed

The previous pressure solver checked mostly:

```matlab
max(abs(phi_new - phi_old))
```

This is not the true equation residual.

The new solver checks:

```matlab
Laplacian(phi) - rhs
```

and returns:

```matlab
AvgPoissonRelResidual
PressureSaturationRatio
```

## How to interpret a case

A good case should have:

```text
Status = converged
Quality = converged_validated
FinalRcMass <= 1e-7
ValidationPass = true
PressureSaturationRatio reasonably low
```

## Warning about central differencing

Central differencing at high Reynolds number on coarse meshes may converge numerically but still be inaccurate or oscillatory.

This is expected. In the report, use this to explain stability vs accuracy:

- central: less numerical diffusion, more sensitive
- upwind: more stable, more diffusive
