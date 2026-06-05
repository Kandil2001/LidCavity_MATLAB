# Validation against Ghia et al.

The solver is compared with the lid-driven cavity benchmark published by Ghia, Ghia, and Shin in 1982. Their centerline velocity data is widely used to check incompressible cavity-flow solvers.

## Profiles used

The repository includes data for `Re = 100`, `400`, and `1000`. Two profiles are compared:

- horizontal velocity `u(y)` along the vertical centreline, `x = 0.5`
- vertical velocity `v(x)` along the horizontal centreline, `y = 0.5`

The reference values are stored in `validation/ghia_data.m`. `validation/validate_against_ghia.m` interpolates the computed profiles to the reference locations and calculates L2 and maximum absolute errors.

## Reported metrics

| Field in the summary | Meaning |
|---|---|
| `Ghia_u_L2` | L2 error of the vertical-centreline `u` profile |
| `Ghia_v_L2` | L2 error of the horizontal-centreline `v` profile |
| `Ghia_u_Linf` | Maximum absolute error in the `u` profile |
| `Ghia_v_Linf` | Maximum absolute error in the `v` profile |
| `ValidationPass` | Whether both L2 errors are below the selected study thresholds |

## About the pass/fail thresholds

The pass limits in `default_config.m` are practical thresholds chosen for this study. They are useful for sorting the 72 cases and identifying trends, but they are not a formal verification or grid-independence criterion.

A case can meet the centerline-error threshold while still reaching the maximum outer iteration count. For that reason, the summary reports `Status` and `ValidationPass` separately. Both should be checked before drawing conclusions from a case.

## Interpreting the comparison

The included results show the expected pattern:

- `Re = 100` is resolved reasonably well across the tested meshes.
- Higher Reynolds numbers need finer grids to reproduce the sharper gradients.
- The `N = 128` cases give the strongest agreement in this study.
- Coarse high-Reynolds-number cases are useful for showing under-resolution, but should not be used as final validation cases.

Example plots are available in `assets/figures/`, and the numerical errors for every case are listed in `assets/data/study_summary.csv`.

## Reference

Ghia, U., Ghia, K. N., & Shin, C. T. (1982). *High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method*. Journal of Computational Physics, 48(3), 387–411.
