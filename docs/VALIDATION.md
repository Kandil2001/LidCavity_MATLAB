# Validation against Ghia et al.

The solver output is compared with the centerline velocity data published by Ghia, Ghia, and Shin for the lid-driven cavity problem.

## Profiles

The repository includes reference data for `Re = 100`, `400`, and `1000`.

Two profiles are compared:

- horizontal velocity `u(y)` along the vertical centerline, `x = 0.5`
- vertical velocity `v(x)` along the horizontal centerline, `y = 0.5`

The reference values are stored in `validation/ghia_data.m`. The function `validation/validate_against_ghia.m` interpolates the computed profiles to the same sample locations and calculates `L2` and maximum absolute errors.

## Metrics in the summary

| Field | Meaning |
|---|---|
| `Ghia_u_L2` | `L2` error of the vertical-centerline `u` profile |
| `Ghia_v_L2` | `L2` error of the horizontal-centerline `v` profile |
| `Ghia_u_Linf` | maximum absolute error in the `u` profile |
| `Ghia_v_Linf` | maximum absolute error in the `v` profile |
| `ValidationPass` | whether both `L2` errors are below the selected limits |

## Interpreting the pass flag

The limits in `default_config.m` are practical values used to compare the 72 configured cases. They are not a formal verification criterion or proof of grid independence.

A case can have a low centerline error while still reaching the outer iteration limit. For that reason, `Status` and `ValidationPass` are stored separately and must be considered together.

## Trend in the completed study

- the `Re = 100` profiles agree reasonably well across the tested meshes
- higher Reynolds numbers require finer grids to resolve sharper velocity gradients
- the `N = 128` cases give the strongest agreement in the recorded study
- coarse high-Reynolds-number cases should be treated as under-resolved
- every case reached the configured outer-iteration limit

Example plots are available in `assets/figures/`, and the errors for every case are listed in `assets/data/study_summary.csv`.

## Reference

Ghia, U., Ghia, K. N., & Shin, C. T. (1982). *High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method*. Journal of Computational Physics, 48(3), 387–411.
