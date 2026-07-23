# Lid-Driven Cavity Flow Solver in MATLAB

A Phase 2 MATLAB implementation of the two-dimensional incompressible lid-driven cavity benchmark. The production solver now uses a staggered Marker-and-Cell grid and the same strict numerical acceptance logic used by the companion C++ repository.

## Phase 2 production features

- staggered MAC arrangement for pressure and face velocities
- projection method with compatible divergence, gradient, and Poisson operators
- first-order upwind and second-order central convection
- red-black Gauss-Seidel and red-black SOR pressure solvers
- loop-based and vectorized MATLAB momentum predictors
- strict convergence based on velocity update, divergence `Linf`, divergence `L2`, global mass balance, and pressure convergence
- required consecutive converged iterations and minimum iteration count
- Reynolds-number continuation for ordered parameter studies
- Ghia centerline benchmark comparison
- standardized summary, history, field, centerline, and MAT outputs
- named run modes matching the C++ workflow

## Run modes

| Mode | Cases | Purpose |
|---|---:|---|
| `single` | 1 | Canonical `N=32`, `Re=100`, upwind, RBSOR regression |
| `quick` | 2 | Vectorized versus loop implementation on the canonical case |
| `medium` | 6 | `N=32`, `Re=100/400/1000`, upwind/central, RBSOR |
| `grid` | 3 | `N=16/32/64`, `Re=100`, central, RBSOR |
| `re1000` | 1 | Representative `N=64`, `Re=1000`, central, RBSOR case |
| `full` | 72 | 3 meshes × 3 Reynolds numbers × 2 schemes × 2 pressure solvers × 2 MATLAB implementations |

Open MATLAB in the repository root and run:

```matlab
run_mode('single')
run_mode('medium')
run_mode('grid')
run_mode('re1000')
run_mode('full')
```

Equivalent scripts are available for Linux systems:

```bash
bash scripts/run_single.sh
bash scripts/run_medium.sh
bash scripts/run_grid.sh
bash scripts/run_re1000.sh
bash scripts/run_full.sh
```

Run the canonical regression test with:

```bash
bash scripts/run_tests.sh
```

## Output

Generated data are written to `results/data/`:

- `study_summary_<mode>.csv`
- `<case>_history.csv`
- `<case>_fields.csv`
- `<case>_centerlines.csv`
- `<case>.mat`

Figures are written to `results/figures/`. Large modes save study-level figures by default; the single case also saves per-case flow and validation figures.

## Numerical method

The unit-square cavity has a lid velocity of `1`, stationary remaining walls, and viscosity `nu = 1/Re`. Pressure is stored at cell centers, `u` on vertical faces, and `v` on horizontal faces. Each pseudo-time iteration predicts face velocities, solves a pressure-correction Poisson equation, projects the velocities onto a divergence-free field, and evaluates strict convergence metrics.

See [`docs/METHODOLOGY.md`](docs/METHODOLOGY.md), [`docs/RUNNING.md`](docs/RUNNING.md), and [`docs/PHASE2_VERIFICATION.md`](docs/PHASE2_VERIFICATION.md).

## Requirements

- MATLAB with base language functionality
- no external toolboxes required for the solver
- Linux shell only for the optional wrapper scripts

## Scope

This is an educational and research comparison solver. It is designed for transparent numerical experiments and cross-language comparison, not as a replacement for a production CFD package.

## Reference

Ghia, U., Ghia, K. N., & Shin, C. T. (1982). *High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method*. Journal of Computational Physics, 48(3), 387–411.

## Author

Ahmed Kandil — [Portfolio](https://kandil2001.github.io/) · [LinkedIn](https://www.linkedin.com/in/ahmed-kandil03/) · [ORCID](https://orcid.org/0009-0007-2724-4565)

Released under the [MIT License](LICENSE).
