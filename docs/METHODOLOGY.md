# Methodology

## Problem setup

The domain is a unit square filled with an incompressible fluid. The top wall moves from left to right with a non-dimensional speed of `1`; the other walls remain stationary. No-slip and no-penetration conditions are applied at all walls.

The solver uses the non-dimensional equations:

```text
Continuity:         ∇ · u = 0
Momentum equation:  ∂u/∂t + (u · ∇)u = −∇p + (1/Re)∇²u
```

The Reynolds number is based on the lid velocity and cavity length.

## Grid and spatial discretization

Velocity and pressure are stored on a structured Cartesian collocated grid. Spatial derivatives are calculated with finite differences.

Two convection schemes are available:

- **Upwind:** more stable on coarse meshes, but more diffusive.
- **Central:** less diffusive, but more sensitive to mesh resolution.

Diffusion terms and pressure gradients use central differences.

## Pressure-correction loop

The steady solution is approached through pseudo-time stepping. Each outer iteration follows this sequence:

1. Apply the velocity boundary conditions.
2. Predict the intermediate velocity field.
3. Calculate its divergence.
4. Solve the pressure-correction Poisson equation.
5. Correct velocity and pressure.
6. Record residuals and continue until the stopping criteria or iteration limit is reached.

The momentum predictor is implemented twice:

- `momentum_predictor_loop.m` follows the equations cell by cell and is easier to inspect.
- `momentum_predictor_vectorized.m` performs the same operations with MATLAB arrays.

Keeping both versions makes it possible to compare runtime while checking that they produce the same numerical result.

## Pressure solvers

The pressure-correction equation can be solved with:

- `RBGS`: red-black Gauss-Seidel
- `RBSOR`: red-black successive over-relaxation

For RBSOR, the relaxation factor is estimated from the grid size and limited by the bounds in `default_config.m`. The pressure solver is stopped using the residual of the Poisson equation.

## Time step and relaxation

The pseudo-time step is limited by convection, diffusion, and the configured maximum value. Velocity and pressure under-relaxation factors are also defined in `default_config.m`.

These settings were selected to keep the full parameter study stable; they are not necessarily optimal for every individual case.

## Residuals

The solver records:

- changes in the horizontal and vertical velocity fields,
- normalized mass imbalance,
- raw velocity divergence,
- pressure-solver iterations and relative residuals.

The velocity changes and mass imbalance are used for the outer stopping check. Raw divergence is retained as an additional diagnostic.

## Validation

For `Re = 100`, `400`, and `1000`, the computed centreline velocities are interpolated to the sample locations reported by Ghia et al. The code calculates L2 and maximum errors for:

- `u(y)` at `x = 0.5`
- `v(x)` at `y = 0.5`

The limits used to classify the cases are stored in `default_config.m` and discussed in [VALIDATION.md](VALIDATION.md).

## Scope

The solver is intended for studying the numerical behaviour of the cavity-flow problem. It does not include Rhie-Chow interpolation, multigrid acceleration, turbulence modelling, or adaptive meshing.
