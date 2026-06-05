# Results

The full parameter study contains 72 cases:

```text
3 meshes × 3 Reynolds numbers × 2 schemes × 2 pressure solvers × 2 implementations
```

The numerical summary is available in [`assets/data/study_summary.csv`](../assets/data/study_summary.csv).

## Overview

| Result | Value |
|---|---:|
| Completed cases | 72 |
| Cases within the selected Ghia error limits | 44 |
| Cases that met the strict outer stopping criteria before `maxIter` | 0 |
| Passes at `N = 32` | 8 / 24 |
| Passes at `N = 64` | 12 / 24 |
| Passes at `N = 128` | 24 / 24 |

Every case reached its configured outer-iteration limit. Some still matched the Ghia centreline data reasonably well, but validation error and numerical convergence are not the same thing. The summary therefore reports both separately.

## Mesh and Reynolds-number effects

The mesh trend is clear in the current results:

- All 24 cases at `Re = 100` met the selected limits.
- At `Re = 400`, 12 of 24 cases met them.
- At `Re = 1000`, 8 of 24 cases met them.
- All 24 cases on the `N = 128` mesh met them.

This is not a formal grid-independence study, but it shows the expected loss of accuracy when a coarse mesh is used at a higher Reynolds number.

![Ghia error by mesh](../assets/figures/study_ghia_error.png)

## Upwind and central differencing

Central differencing met the selected limits in 24 of 36 cases, compared with 20 of 36 for upwind.

On better-resolved cases, central differencing usually followed the benchmark more closely. Upwind was more forgiving on coarse meshes, but its added numerical diffusion weakened the velocity gradients.

## Pressure-solver performance

The pressure solve was the main computational cost.

| Pressure solver | Mean pressure iterations per outer iteration | Mean total case runtime* |
|---|---:|---:|
| RBGS | about 1333 | about 1841 s |
| RBSOR | about 265 | about 458 s |

\*Runtime values are specific to the machine and settings used to generate the included summary. They are only intended for comparison within this study.

RBSOR had a much larger effect on total runtime than vectorizing the momentum predictor.

![Pressure solver comparison](../assets/figures/study_pressure_solver_iterations.png)

## Loop and vectorized implementations

Equivalent loop and vectorized cases produced matching numerical results. Their average total runtimes were also close:

- loop: about `1157 s`
- vectorized: about `1142 s`

The small difference shows that optimizing the momentum predictor alone has limited effect while the pressure solve remains the bottleneck.

![Implementation runtime comparison](../assets/figures/study_runtime_implementation.png)

## Next steps

The current study points to several useful improvements:

1. Revisit the stopping criteria and relaxation settings so representative cases reach convergence before `maxIter`.
2. Improve the collocated pressure-velocity treatment, for example with Rhie-Chow interpolation.
3. Replace or accelerate the pressure solver, ideally with multigrid or a sparse linear-system approach.
4. Run a dedicated grid-independence study.
5. Compare vortex locations and strengths in addition to centreline velocities.
