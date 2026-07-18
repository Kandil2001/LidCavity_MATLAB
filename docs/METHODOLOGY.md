# Methodology

## Problem setup

The domain is a unit square filled with an incompressible fluid. The top wall moves from left to right with a nondimensional speed of `1`; the other walls remain stationary. No-slip and no-penetration conditions are applied at all walls.

The solver uses the nondimensional equations:

```text
Continuity:         ∇ · u = 0
Momentum equation:  ∂u/∂t + (u · ∇)u = −∇p + (1/Re)∇²u
```

The Reynolds number is based on lid velocity and cavity length.

## Grid and spatial discretization

Velocity and pressure are stored on a structured Cartesian collocated grid. Spatial derivatives are calculated with finite differences.

Two convection schemes are available:

- **Upwind:** more stable on coarse meshes, but more diffusive
- **Central:** less diffusive, but more sensitive to mesh resolution

Diffusion terms and pressure gradients use central differences.

## Pressure-correction loop

The steady solution is approached through pseudo-time stepping. Each outer iteration:

1. applies velocity boundary conditions
2. predicts the intermediate velocity field
3. calculates its divergence
4. solves the pressure-correction Poisson equation
5. corrects velocity and pressure
6. records residuals
7. continues until the stopping criteria or iteration limit is reached

The momentum predictor is implemented twice:

- `momentum_predictor_loop.m` follows the equations cell by cell
- `momentum_predictor_vectorized.m` performs equivalent operations with MATLAB arrays

Keeping both versions supports runtime comparison while checking numerical consistency.

## Pressure solvers

The pressure-correction equation can be solved with:

- `RBGS`: red-black Gauss-Seidel
- `RBSOR`: red-black Successive Over-Relaxation

For RBSOR, the relaxation factor is estimated from grid size and limited by the bounds in `default_config.m`. The pressure solver stops using the relative residual of the Poisson equation.

## Time step and relaxation

The pseudo-time step is limited by convection, diffusion, and the configured maximum value. Velocity and pressure under-relaxation factors are also defined in `default_config.m`.

These settings were selected to keep the complete parameter study stable; they are not necessarily optimal for every individual case.

## Residuals

The solver records:

- changes in horizontal and vertical velocity
- normalized mass imbalance
- raw velocity divergence
- pressure-solver iterations and relative residuals

Velocity changes and mass imbalance are used for the outer stopping check. Raw divergence is retained as an additional diagnostic.

## Validation

For `Re = 100`, `400`, and `1000`, the computed centerline velocities are interpolated to the sample locations reported by Ghia et al. The code calculates `L2` and maximum errors for:

- `u(y)` at `x = 0.5`
- `v(x)` at `y = 0.5`

The limits used to classify cases are stored in `default_config.m` and discussed in [`VALIDATION.md`](VALIDATION.md).

## Scope

The repository records a completed educational solver and parameter study. It does not include Rhie-Chow interpolation, multigrid acceleration, turbulence modeling, or adaptive meshing.
