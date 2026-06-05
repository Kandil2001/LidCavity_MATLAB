# Lid-Driven Cavity Flow Solver in MATLAB

<p align="center">
  <img src="https://img.shields.io/badge/MATLAB-base%20MATLAB-orange.svg" alt="MATLAB">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License">
  <a href="https://kandil2001.github.io/">
    <img src="https://img.shields.io/badge/Portfolio-kandil2001.github.io-2ea44f.svg" alt="Portfolio">
  </a>
</p>

This repository contains my MATLAB implementation of the two-dimensional incompressible lid-driven cavity problem. I built it to work directly with the numerical method instead of only using a ready-made CFD solver.

The code uses a pseudo-transient pressure-correction loop and compares different choices for convection discretization, pressure solution, mesh size, Reynolds number, and MATLAB implementation style.

<p align="center">
  <img src="assets/figures/readme_overview.png" alt="Overview of the lid-driven cavity results" width="900">
</p>

## Main features

- Structured collocated grid
- Pressure-correction coupling for incompressible flow
- Loop-based and vectorized momentum predictors
- First-order upwind and central convection schemes
- Red-black Gauss-Seidel (`RBGS`) and red-black SOR (`RBSOR`) pressure solvers
- Meshes `N = 32, 64, 128`
- Reynolds numbers `Re = 100, 400, 1000`
- Validation against the centreline data of Ghia et al.
- Automatic plots and a CSV summary for the parameter study

The full study contains 72 cases:

```text
3 meshes × 3 Reynolds numbers × 2 schemes × 2 pressure solvers × 2 implementations
```

## Representative result

The case below uses `N = 64`, `Re = 100`, central differencing, RBGS, and the vectorized momentum predictor.

| Flow field | Centreline validation |
|---|---|
| ![Streamlines](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_streamlines.png) | ![Ghia u validation](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_ghia_u.png) |
| ![Velocity magnitude](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_speed.png) | ![Ghia v validation](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_ghia_v.png) |

## Numerical method

The non-dimensional equations solved are:

```text
Continuity:         ∇ · u = 0
Momentum equation:  ∂u/∂t + (u · ∇)u = −∇p + (1/Re)∇²u
```

Each outer iteration predicts the velocity field, solves a Poisson equation for a pressure correction, corrects velocity and pressure, and records the residuals. The implementation is described in [docs/METHODOLOGY.md](docs/METHODOLOGY.md).

## Results from the current study

The published summary contains results for all 72 combinations. The main observations are:

- `44/72` cases met the selected Ghia centreline-error limits.
- All cases reached their configured outer-iteration limit before meeting the strict stopping criteria, so I do not describe them as fully converged.
- All `N = 128` cases met the selected Ghia limits; the coarser high-Reynolds-number cases were less accurate.
- RBSOR reduced the average pressure-solver iterations and total runtime substantially compared with RBGS.
- Vectorizing the momentum predictor changed the total runtime only slightly because the pressure solve remained the main cost.

The validation limits are practical thresholds used to compare the cases in this study. They are not a substitute for a formal grid-independence or verification study.

![Pressure solver comparison](assets/figures/study_pressure_solver_iterations.png)

The numerical summary and a longer discussion are available in [docs/RESULTS.md](docs/RESULTS.md).

## Running the code

Run one of the following scripts from the repository root:

```matlab
main_quick    % smaller check
main_medium   % intermediate study
main          % full 72-case study
```

The full study can take a long time, especially for `N = 128` and RBGS cases. Generated data and figures are written to `results/data/` and `results/figures/`. More details are in [docs/RUNNING.md](docs/RUNNING.md).

## Repository structure

```text
core/          numerical routines
studies/       single-case and parameter-study runners
validation/    Ghia data and error calculation
post/          plotting and result export
assets/        selected figures and the published study summary
docs/          method, results, validation, and run notes
results/       generated output; ignored by Git
```

## Notes and limitations

This is a learning solver, not a replacement for a production CFD package. The current version uses a collocated grid without Rhie-Chow interpolation and an iterative pressure solver without multigrid acceleration. The convergence settings also need further work, as shown by the cases reaching `maxIter`.

Useful next steps include a stronger pressure-velocity treatment, a faster pressure solver, and a dedicated grid-independence study.

## Reference

Ghia, U., Ghia, K. N., & Shin, C. T. (1982). *High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method*. Journal of Computational Physics, 48(3), 387–411.

## Author

Ahmed Kandil — [Portfolio](https://kandil2001.github.io/) · [GitHub](https://github.com/Kandil2001) · [LinkedIn](https://www.linkedin.com/in/ahmed-kandil03/)

Released under the [MIT License](LICENSE).
