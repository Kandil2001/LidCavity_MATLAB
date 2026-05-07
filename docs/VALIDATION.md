# Validation

## Purpose

Validation checks whether the solver produces physically meaningful results by comparing it against established benchmark data.

For this project, the reference data comes from:

> Ghia, U., Ghia, K. N., and Shin, C. T.  
> High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method.  
> Journal of Computational Physics, 48(3), 387-411, 1982.

---

## Validation Data

The project includes Ghia benchmark data for:

```text
Re = 100
Re = 400
Re = 1000
```

The validation uses two centerline profiles:

1. vertical centerline velocity:
   ```text
   u(y) at x = 0.5
   ```

2. horizontal centerline velocity:
   ```text
   v(x) at y = 0.5
   ```

---

## Validation Files

The validation is handled by:

```text
validation/ghia_data.m
validation/validate_against_ghia.m
```

### `ghia_data.m`

Stores the benchmark centerline data.

### `validate_against_ghia.m`

Interpolates the numerical solution onto the benchmark sample points and computes error metrics.

---

## Validation Metrics

The summary table reports:

| Metric | Meaning |
|---|---|
| `Ghia_u_L2` | L2 error for vertical centerline `u(y)` |
| `Ghia_v_L2` | L2 error for horizontal centerline `v(x)` |
| `Ghia_u_Linf` | Maximum absolute error for `u(y)` |
| `Ghia_v_Linf` | Maximum absolute error for `v(x)` |
| `ValidationPass` | Whether the case passes the selected validation tolerance |

---

## How to Interpret Validation

A validation error should be interpreted together with mesh size and Reynolds number.

### Low Reynolds Number

At `Re = 100`, the flow is easier to resolve. Good agreement can be obtained on moderate meshes such as `N = 64`.

### Higher Reynolds Number

At `Re = 400` and `Re = 1000`, stronger gradients and more complex vortical structures appear. A finer mesh is required.

### Coarse Meshes

Coarse meshes such as `N = 32` can be useful for demonstrating trends, but they are not expected to give accurate high-Reynolds-number validation.

---

## Recommended Validation Cases

Good cases to show in the README or report:

```text
N = 64, Re = 100, central, vectorized
N = 128, Re = 100, central, vectorized
N = 128, Re = 400, central, vectorized
N = 128, Re = 1000, central, vectorized
```

These cases better demonstrate the solver's validation behavior on sufficiently resolved meshes.

---

## Important Interpretation

A failed validation case does not automatically mean the solver is wrong.

For example:

```text
N = 32, Re = 1000
```

is likely under-resolved. The larger error is mainly a mesh-resolution issue, not necessarily a coding error.

This is an important CFD conclusion: mesh quality and resolution directly affect validation accuracy.
