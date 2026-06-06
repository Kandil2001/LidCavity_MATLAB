# Lid-Driven Cavity Flow Solver in MATLAB

<p align="center">
  <img src="https://img.shields.io/badge/MATLAB-base%20MATLAB-orange.svg" alt="MATLAB">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License">
  <a href="https://kandil2001.github.io/">
    <img src="https://img.shields.io/badge/Portfolio-kandil2001.github.io-2ea44f.svg" alt="Portfolio">
  </a>
</p>

A two-dimensional incompressible-flow solver for the classical lid-driven cavity benchmark, written in MATLAB.

I built this project to work directly with pressure-velocity coupling, discretization, convergence behaviour, and validation rather than treating the CFD solver as a black box. The code includes both loop-based and vectorized momentum-predictor versions so the numerical setup and implementation style can be compared.

This repository is part of the same benchmark series as [LidCavity_CPP](https://github.com/Kandil2001/LidCavity_CPP), but it is written and presented as its own MATLAB implementation.

## What is included

- Structured collocated Cartesian grid
- Pseudo-transient pressure-correction algorithm
- Loop-based and vectorized momentum predictors
- First-order upwind and central convection schemes
- Red-black Gauss-Seidel and red-black SOR pressure solvers
- Validation against Ghia et al. centreline velocity data
- Automated field plots, validation plots, residual histories, and CSV summaries

The full parameter study runs 72 combinations:

```text
3 meshes × 3 Reynolds numbers × 2 schemes × 2 pressure solvers × 2 implementations
```

## Representative result

The case below uses `N = 64`, `Re = 100`, central differencing, RBGS, and the vectorized momentum predictor.

| Flow field | Centreline validation |
|---|---|
| ![Streamlines](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_streamlines.png) | ![Ghia u validation](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_ghia_u.png) |
| ![Velocity magnitude](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_speed.png) | ![Ghia v validation](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_ghia_v.png) |

## Numerical approach

The solver advances the non-dimensional incompressible Navier-Stokes equations through pseudo-time. At each outer iteration it predicts the velocity field, solves a pressure-correction Poisson equation, corrects velocity and pressure, reapplies the wall boundary conditions, and records convergence diagnostics.

A more detailed description is available in [docs/METHODOLOGY.md](docs/METHODOLOGY.md).

## Study observations

- `44/72` cases met the selected Ghia centreline-error limits.
- All `N = 128` cases met the selected validation limits.
- Coarse high-Reynolds-number cases were less accurate, which is expected for this setup.
- RBSOR reduced pressure-solver iterations and runtime compared with RBGS.
- Vectorizing the momentum predictor had a limited effect on total runtime because the pressure solve remained the main cost.

The validation limits are practical comparison thresholds, not a replacement for a formal verification or grid-independence study. See [docs/RESULTS.md](docs/RESULTS.md) for the full discussion.

![Pressure solver comparison](assets/figures/study_pressure_solver_iterations.png)

## Run the project

Clone the repository, open MATLAB in the repository root, and run one of:

```matlab
main_quick    % reduced check
main_medium   % study without the N = 128 mesh
main          % full 72-case study
```

Generated files are written to `results/data/` and `results/figures/`. Detailed instructions are in [docs/RUNNING.md](docs/RUNNING.md).

## Repository layout

```text
core/          solver routines
studies/       single-case and parameter-study runners
validation/    Ghia data and error calculations
post/          plotting and result export
assets/        selected figures and published summary data
docs/          methodology, results, validation, and running notes
results/       generated output; ignored by Git
```

## Requirements

This project uses base MATLAB scripts and functions.

No external MATLAB toolboxes are required for the main solver workflow.

## Limitations

This is an educational solver, not a replacement for a production CFD package. It uses a collocated grid without Rhie-Chow interpolation and an iterative pressure solver without multigrid acceleration. The convergence strategy and pressure-velocity treatment are the main areas for further improvement.

## Next steps

- Improve convergence control and stopping criteria
- Improve the high-Reynolds-number cases
- Clean the result comparison tables
- Use this MATLAB version as a reference when adding faster implementations in C++, OpenMP, MPI, or CUDA

## Reference

Ghia, U., Ghia, K. N., & Shin, C. T. (1982). *High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method*. Journal of Computational Physics, 48(3), 387-411.

## Author

Ahmed Kandil — [Portfolio](https://kandil2001.github.io/) · [LinkedIn](https://www.linkedin.com/in/ahmed-kandil03/)

Released under the [MIT License](LICENSE).
