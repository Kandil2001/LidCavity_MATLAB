# Methodology

This note describes the numerical choices used in the solver and the reasoning behind the comparisons in the study.

## Problem setup

The domain is a unit square filled with an incompressible fluid. The top wall moves from left to right with a non-dimensional speed of `1`, while the other three walls are stationary. No-slip and no-penetration conditions are applied at every wall.

The non-dimensional governing equations are:

```text
Continuity:         ∇ · u = 0
Momentum equation:  ∂u/∂t + (u · ∇)u = −∇p + (1/Re)∇²u
```

The Reynolds number is based on the lid velocity and cavity length.

## Grid and discretization

The code uses a structured Cartesian collocated grid. Velocity and pressure are stored at the same grid locations. Spatial derivatives are calculated with finite differences.

Two convection schemes are available:

- **Upwind:** more robust on coarse meshes, but adds numerical diffusion.
- **Central:** less diffusive and usually closer to the benchmark on a sufficiently fine mesh, but more sensitive to under-resolution.

Diffusion and pressure gradients use central differences.

## Pressure-correction loop

The solver follows a SIMPLE-style pressure-correction sequence:

1. Apply the velocity boundary conditions.
2. Predict intermediate velocities from the momentum equations.
3. Calculate the divergence of the predicted field.
4. Solve the pressure-correction Poisson equation.
5. Correct the velocity field.
6. Update pressure with under-relaxation.
7. Calculate residuals and repeat.

The momentum predictor is available in two forms. `momentum_predictor_loop.m` is easier to follow cell by cell, while `momentum_predictor_vectorized.m` performs the same calculation using MATLAB array operations. Keeping both versions made it possible to check numerical consistency and compare runtime.

## Pressure solvers

The pressure-correction equation can be solved with:

- `RBGS`: red-black Gauss-Seidel
- `RBSOR`: red-black successive over-relaxation

RBSOR uses an automatically estimated relaxation factor, limited to a safe range in `default_config.m`. The pressure solver checks the residual of the Poisson equation rather than only checking how much the pressure correction changed between iterations.

## Time step and relaxation

Although the target problem is steady, the code advances through pseudo-time steps. The time step is limited by convection, diffusion, and a configured maximum value. Velocity and pressure relaxation factors are also set in `default_config.m`.

These settings were chosen to keep the broad parameter study stable. They are not claimed to be optimal for every mesh and Reynolds number.

## Residuals and stopping criteria

The code records:

- changes in the horizontal and vertical velocity fields,
- a normalized mass-imbalance residual,
- raw velocity divergence,
- pressure-solver iterations and relative residuals.

The mass residual and velocity residuals are used for the outer convergence check. Raw divergence is kept as an additional diagnostic.

## Validation

For `Re = 100`, `400`, and `1000`, the computed centerline velocities are interpolated to the locations reported by Ghia et al. The code then calculates L2 and maximum errors for:

- `u(y)` at `x = 0.5`
- `v(x)` at `y = 0.5`

The validation thresholds are study-specific values stored in `default_config.m`. See [VALIDATION.md](VALIDATION.md) for how I interpret them.

## Scope of the method

The code is useful for studying pressure correction, numerical diffusion, mesh effects, and MATLAB performance. It is not intended to reproduce all features of a production finite-volume solver. In particular, the collocated formulation does not include Rhie-Chow interpolation, and the pressure solver is iterative but not multigrid-accelerated.
