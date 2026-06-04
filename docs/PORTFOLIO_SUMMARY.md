# Portfolio Summary

## Short version

Developed a MATLAB CFD solver for the 2D incompressible lid-driven cavity benchmark using SIMPLE-style pressure correction. The project compares loop-based and vectorized implementations, upwind and central differencing, RBGS and RBSOR pressure solvers, and validates the results against Ghia et al. centerline velocity data for `Re = 100`, `400`, and `1000`.

## CV bullet version

- Developed a MATLAB CFD benchmark solver for the 2D incompressible lid-driven cavity problem using SIMPLE-style pressure-velocity coupling.
- Implemented and compared loop-based and vectorized momentum predictors, upwind and central differencing, and RBGS/RBSOR pressure solvers.
- Conducted a 72-case mesh/Reynolds-number study and validated centerline velocity profiles against the Ghia et al. benchmark.
- Automated generation of residual plots, velocity/pressure/vorticity fields, streamline plots, validation curves, and summary tables.

## Technical keywords

CFD, MATLAB, Navier-Stokes, incompressible flow, SIMPLE algorithm, pressure correction, Poisson equation, finite difference, lid-driven cavity, Ghia benchmark, numerical methods, residual monitoring, mesh study, Reynolds number, vectorization.

## Repository description

A portfolio-style MATLAB CFD project for the classical lid-driven cavity benchmark. The repository documents the full workflow from governing equations and solver implementation to parametric study, validation, post-processing, and honest discussion of numerical limitations.
