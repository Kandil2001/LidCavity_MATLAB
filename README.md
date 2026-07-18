# Lid-Driven Cavity Flow Solver in MATLAB

<p align="center">
  <img src="https://img.shields.io/badge/Status-Completed-brightgreen.svg" alt="Completed">
  <img src="https://img.shields.io/badge/MATLAB-base%20MATLAB-orange.svg" alt="MATLAB">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT License">
  <a href="https://kandil2001.github.io/">
    <img src="https://img.shields.io/badge/Portfolio-kandil2001.github.io-2ea44f.svg" alt="Portfolio">
  </a>
</p>

A completed MATLAB implementation and parameter study of the two-dimensional lid-driven cavity benchmark.

This repository is the MATLAB reference implementation for a larger project that compares the same CFD problem across MATLAB, C++, C, Python, OpenMP, MPI, CUDA, and OpenFOAM-oriented workflows. The physical setup is kept consistent so that numerical behavior, accuracy, runtime, implementation style, and scalability can be compared.

## What the project contains

- structured collocated Cartesian grid
- pseudo-transient pressure-correction algorithm
- loop-based and vectorized momentum predictors
- first-order upwind and central convection schemes
- red-black Gauss-Seidel and red-black SOR pressure solvers
- Ghia centerline comparison
- automated field plots, residual histories, validation figures, and CSV summaries

The completed parameter study contains 72 configured combinations:

```text
3 meshes × 3 Reynolds numbers × 2 schemes × 2 pressure solvers × 2 implementations
```

## Representative result

This case uses `N = 64`, `Re = 100`, central differencing, RBGS, and the vectorized momentum predictor.

| Flow field | Centerline comparison |
|---|---|
| ![Streamlines](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_streamlines.png) | ![Ghia u validation](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_ghia_u.png) |
| ![Velocity magnitude](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_speed.png) | ![Ghia v validation](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_ghia_v.png) |

## Numerical approach

The solver advances the nondimensional incompressible Navier-Stokes equations through pseudo-time. Each outer iteration predicts the velocity field, solves a pressure-correction Poisson equation, corrects velocity and pressure, reapplies wall boundary conditions, and records convergence diagnostics.

A detailed description is available in [`docs/METHODOLOGY.md`](docs/METHODOLOGY.md).

## Study observations

- `44/72` cases met the selected Ghia centerline-error thresholds
- all `N = 128` cases met the selected validation thresholds
- coarse high-Reynolds-number cases were less accurate
- RBSOR reduced pressure-solver iterations and runtime compared with RBGS
- vectorizing the momentum predictor had a limited effect on total runtime because the pressure solve remained the main cost

The selected validation thresholds are practical comparison limits, not a substitute for a formal verification, grid-convergence, or uncertainty study. See [`docs/RESULTS.md`](docs/RESULTS.md) for the detailed discussion.

![Pressure solver comparison](assets/figures/study_pressure_solver_iterations.png)

## Run the project

Clone the repository, open MATLAB in the repository root, and run one of:

```matlab
main_quick    % reduced check
main_medium   % study without the N = 128 mesh
main          % complete 72-case configuration
```

Linux shell wrappers are also available:

```bash
bash scripts/run_quick.sh
bash scripts/run_medium.sh
bash scripts/run.sh
```

Generated files are written to `results/data/` and `results/figures/`. Detailed instructions are available in [`docs/RUNNING.md`](docs/RUNNING.md).

## Repository structure

```text
config/        default solver and study settings
startup/       path setup and output-folder creation
core/          solver routines
studies/       single-case and parameter-study runners
validation/    Ghia data and error calculations
post/          plotting and result export
scripts/       shell wrappers for MATLAB runs
assets/        selected figures and published summary data
docs/          methodology, results, validation, and running notes
results/       generated output; ignored by Git
```

## Requirements

The project uses base MATLAB scripts and functions. No external MATLAB toolboxes are required for the main solver workflow.

## Scope and limitations

This is a completed educational solver and study, not a replacement for a production CFD package.

Documented limitations include:

- collocated grid without Rhie-Chow interpolation
- iterative pressure solver without multigrid acceleration
- practical validation thresholds rather than a formal verification study
- high-Reynolds-number cases that require stronger convergence control
- no uncertainty quantification

The code is kept as the completed MATLAB reference implementation for the broader work-in-progress multi-language comparison project.

## Reference

Ghia, U., Ghia, K. N., & Shin, C. T. (1982). *High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method*. Journal of Computational Physics, 48(3), 387-411.

## Author

Ahmed Kandil — [Portfolio](https://kandil2001.github.io/) · [LinkedIn](https://www.linkedin.com/in/ahmed-kandil03/) · [ORCID](https://orcid.org/0009-0007-2724-4565)

Released under the [MIT License](LICENSE).
