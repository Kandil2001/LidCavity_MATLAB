# Numerical Methodology

## Problem definition

The solver models the nondimensional two-dimensional incompressible lid-driven cavity in a unit square. The top wall moves with velocity `U = 1`; the other walls remain stationary. The kinematic viscosity is

```text
nu = U L / Re
```

with `L = 1`.

## Staggered MAC grid

The Phase 2 production solver uses a Marker-and-Cell arrangement:

- pressure at cell centers
- horizontal velocity on vertical cell faces
- vertical velocity on horizontal cell faces

This removes the checkerboard pressure mode associated with the earlier collocated prototype and makes the pressure gradient, velocity correction, and discrete divergence compatible.

## Projection workflow

Each pseudo-time iteration:

1. calculates a stable time step from convection and diffusion limits
2. predicts face velocities from convection, diffusion, and pressure gradients
3. calculates cell-centered divergence of the predicted field
4. removes the mean from the Poisson right-hand side
5. solves the pressure-correction Poisson equation
6. corrects face velocities with pressure-correction gradients
7. updates and normalizes pressure
8. evaluates all convergence metrics

## Momentum discretization

The code supports first-order upwind and second-order central convection. Diffusion uses second-order central differences. Normal velocities are set directly to zero at solid boundary faces. Tangential no-slip conditions are imposed through ghost values; the upper-wall horizontal-velocity ghost value enforces the moving lid.

Two MATLAB implementations are available:

- `vectorized`: array-based momentum prediction
- `loop`: explicit cell-by-cell momentum prediction

They share the same pressure solver, projection, convergence checks, and output path.

## Pressure correction

The pressure-correction equation is solved using red-black Gauss-Seidel (`RBGS`) or red-black successive over-relaxation (`RBSOR`). Missing neighbors at boundaries implement homogeneous normal pressure-gradient conditions through the boundary stencil. The pressure correction and right-hand side are normalized to remove the constant null space.

Pressure convergence uses the true discrete equation residual. An outer case cannot report convergence while the pressure solve is failing.

## Strict convergence definition

The solver records:

- velocity-update `Linf`
- divergence `Linf`
- divergence `L2`
- global boundary mass imbalance
- pressure-Poisson relative residual

A case reports `converged` only when every configured criterion passes for a required number of consecutive iterations and the minimum iteration count has been reached.

Terminal states are:

```text
converged
max_iterations
pressure_not_converged
stagnated
diverged
non_finite
```

## Continuation

Parameter studies reuse a converged lower-Reynolds-number solution when mesh, convection scheme, pressure solver, and MATLAB implementation remain unchanged. This improves stability and reduces startup cost for `Re = 400` and `Re = 1000`.

## Benchmark comparison

Cell-centered velocities are interpolated to `x = 0.5` and `y = 0.5`, then interpolated again to the Ghia sample coordinates. The code reports `L2` and `Linf` errors for `u(y)` and `v(x)`.

This is a numerical benchmark comparison, not experimental validation.
