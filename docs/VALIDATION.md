# Validation against Ghia et al.

The solver is compared with the centreline velocity data published by Ghia, Ghia, and Shin for the lid-driven cavity problem.

## Profiles

The repository includes reference data for `Re = 100`, `400`, and `1000`.

Two profiles are compared:

- horizontal velocity `u(y)` along the vertical centreline, `x = 0.5`
- vertical velocity `v(x)` along the horizontal centreline, `y = 0.5`

The reference values are stored in `validation/ghia_data.m`. The function `validation/validate_against_ghia.m` interpolates the computed profiles to the same sample locations and calculates L2 and maximum absolute errors.

## Metrics in the summary

| Field | Meaning |
|---|---|
| `Ghia_u_L2` | L2 error of the vertical-centreline `u` profile |
| `Ghia_v_L2` | L2 error of the horizontal-centreline `v` profile |
| `Ghia_u_Linf` | Maximum absolute error in the `u` profile |
| `Ghia_v_Linf` | Maximum absolute error in the `v` profile |
| `ValidationPass` | Whether both L2 errors are below the selected limits |

## Interpreting the pass flag

The limits in `default_config.m` are practical values used to compare the 72 cases. They are not a formal verification criterion or proof of grid independence.

A case can have a low centreline error while still reaching the outer iteration limit. For that reason, `Status` and `ValidationPass` are stored separately and should be considered together.

## Trend in the current results

- The `Re = 100` profiles agree reasonably well across the tested meshes.
- Higher Reynolds numbers require finer grids to resolve the sharper velocity gradients.
- The `N = 128` cases give the best agreement in the current study.
- Coarse high-Reynolds-number cases should be treated as under-resolved.

Example plots are available in `assets/figures/`, and the errors for every case are listed in `assets/data/study_summary.csv`.

## Reference

Ghia, U., Ghia, K. N., & Shin, C. T. (1982). *High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method*. Journal of Computational Physics, 48(3), 387–411.
