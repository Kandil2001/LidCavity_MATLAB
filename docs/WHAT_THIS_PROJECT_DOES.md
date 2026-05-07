# What This Project Does

## Purpose

This project is a MATLAB CFD benchmark study for the two-dimensional incompressible lid-driven cavity problem.

The goal is not only to obtain a flow field, but to demonstrate the complete workflow of developing and evaluating a numerical CFD solver:

1. implement the governing equations,
2. couple pressure and velocity,
3. compare numerical schemes,
4. compare pressure solvers,
5. compare loop-based and vectorized MATLAB implementations,
6. validate the results against benchmark data,
7. document the numerical behavior clearly.

---

## Physical Problem

The lid-driven cavity consists of a square domain filled with an incompressible fluid.

The boundary conditions are:

- the top wall moves with a constant horizontal velocity,
- the bottom wall is fixed,
- the left wall is fixed,
- the right wall is fixed,
- no penetration through any wall.

In non-dimensional form, the lid velocity is set to:

```text
U_lid = 1
```

The main control parameter is the Reynolds number:

```math
Re = \frac{UL}{\nu}
```

where:

- `U` is the lid velocity,
- `L` is the cavity length,
- `ν` is the kinematic viscosity.

---

## What the Solver Calculates

For each case, the solver calculates:

- horizontal velocity `u`,
- vertical velocity `v`,
- pressure `p`,
- velocity magnitude,
- vorticity,
- streamlines,
- residual histories,
- pressure-solver iteration statistics,
- Ghia benchmark validation errors.

---

## Main Numerical Study

The full study runs:

```text
3 mesh sizes × 3 Reynolds numbers × 2 convection schemes × 2 pressure solvers × 2 implementations
```

This gives:

```text
3 × 3 × 2 × 2 × 2 = 72 simulations
```

The investigated parameters are:

| Category | Values |
|---|---|
| Mesh sizes | `N = 32, 64, 128` |
| Reynolds numbers | `Re = 100, 400, 1000` |
| Convection schemes | `upwind`, `central` |
| Pressure solvers | `RBGS`, `RBSOR` |
| Implementations | `loop`, `vectorized` |

---

## Main Questions Answered by the Project

This project answers the following engineering questions:

1. Does the MATLAB solver reproduce the Ghia benchmark trends?
2. How does mesh refinement affect validation accuracy?
3. How does Reynolds number affect the flow field and convergence?
4. What is the difference between upwind and central differencing?
5. How much faster is RBSOR than RBGS?
6. Does the vectorized implementation match the loop reference implementation?
7. Which cases are sufficiently resolved and which are under-resolved?

---

## Short Summary

In simple words, this project:

> builds a MATLAB CFD solver from scratch, validates it against a known benchmark, and studies how numerical choices affect accuracy, stability, and runtime.
