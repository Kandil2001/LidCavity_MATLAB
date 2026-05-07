# Lid Cavity MATLAB

A MATLAB CFD benchmark project for the two-dimensional incompressible lid-driven cavity problem using a SIMPLE-style pressure-correction solver.

This repository contains only the MATLAB implementation.

---

## Overview

This project solves the 2D incompressible Navier-Stokes equations for the classical lid-driven cavity benchmark.

The solver includes:

- full 2D incompressible momentum equations,
- pressure-correction / SIMPLE-style coupling,
- loop-based MATLAB implementation,
- vectorized MATLAB implementation,
- upwind and central convection schemes,
- red-black Gauss-Seidel pressure solver,
- red-black SOR pressure solver,
- mesh and Reynolds-number studies,
- validation against Ghia et al. benchmark data,
- automatic generation of plots and summary tables.

The purpose of the project is to understand CFD from the numerical-method level rather than relying only on black-box CFD software.

---

## Features

- MATLAB implementation of a 2D incompressible Navier-Stokes solver.
- SIMPLE-style pressure correction.
- Collocated structured Cartesian grid.
- Vectorized and loop-based solver comparison.
- Upwind and central differencing comparison.
- RBGS and RBSOR pressure solver comparison.
- Mesh study with `N = 32, 64, 128`.
- Reynolds-number study with `Re = 100, 400, 1000`.
- Ghia benchmark validation.
- Residual, velocity, pressure, streamline, vorticity, and validation plots.

---

## Governing Equations

The continuity equation is:

```math
\nabla \cdot \mathbf{u} = 0
```

The incompressible Navier-Stokes equations are:

```math
\frac{\partial \mathbf{u}}{\partial t}
+
(\mathbf{u}\cdot\nabla)\mathbf{u}
=
-\nabla p
+
\frac{1}{Re}\nabla^2 \mathbf{u}
```

where:

- `u` and `v` are velocity components,
- `p` is pressure,
- `Re` is the Reynolds number.

---

## SIMPLE-Style Pressure Correction

The solver uses a pressure-correction procedure:

1. Initialize velocity and pressure.
2. Predict intermediate velocities from the momentum equations.
3. Solve the pressure correction Poisson equation.
4. Correct velocity using the pressure correction.
5. Update pressure with under-relaxation.
6. Compute residuals and repeat until convergence or maximum iteration count.

---

## Study Matrix

The full study runs:

| Parameter | Values |
|---|---|
| Mesh sizes | `32`, `64`, `128` |
| Reynolds numbers | `100`, `400`, `1000` |
| Convection schemes | `upwind`, `central` |
| Pressure solvers | `RBGS`, `RBSOR` |
| Implementations | `loop`, `vectorized` |

Total simulations:

```text
3 x 3 x 2 x 2 x 2 = 72 simulations
```

---

## Validation

The solver is validated against the benchmark centerline velocity data from:

Ghia, U., Ghia, K. N., and Shin, C. T.  
"High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method."  
Journal of Computational Physics, 48(3), 387-411, 1982.

The validation compares:

- vertical centerline velocity `u(y)` at `x = 0.5`,
- horizontal centerline velocity `v(x)` at `y = 0.5`.

Validation data is included for:

- `Re = 100`,
- `Re = 400`,
- `Re = 1000`.

---

## Example Results

### Residual History

![Residual plot](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_residuals.png)

### Velocity Magnitude

![Velocity magnitude](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_speed.png)

### Streamlines

![Streamlines](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_streamlines.png)

### Ghia Validation: u Centerline

![Ghia u validation](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_ghia_u.png)

### Ghia Validation: v Centerline

![Ghia v validation](assets/figures/case_029_N64_Re100_central_RBGS_vectorized_ghia_v.png)

### Runtime Comparison

![Runtime comparison](assets/figures/study_runtime_implementation.png)

### Pressure Solver Comparison

![Pressure solver comparison](assets/figures/study_pressure_solver_iterations.png)

### Mesh and Scheme Validation Error

![Ghia error study](assets/figures/study_ghia_error.png)

---

## Project Structure

```text
Lid-Cavity-Evolution/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── main.m
├── main_quick.m
├── main_medium.m
├── default_config.m
│
├── run.sh
├── run_quick.sh
├── run_medium.sh
│
├── core/
├── studies/
├── validation/
├── post/
├── docs/
├── assets/
└── results/
```

---

## Important Files

### Main scripts

| File | Purpose |
|---|---|
| `main.m` | Runs the full 72-case study |
| `main_quick.m` | Runs a smaller quick study |
| `main_medium.m` | Runs an intermediate study |
| `default_config.m` | Main configuration file |

### Core solver

| Folder | Purpose |
|---|---|
| `core/` | Solver, pressure correction, residuals, boundary conditions |
| `studies/` | Study automation scripts |
| `validation/` | Ghia benchmark validation |
| `post/` | Plotting and result export |
| `assets/` | Selected figures for GitHub |
| `results/` | Generated results, ignored by Git |

---

## How to Run

### Quick Run

```bash
chmod +x run_quick.sh
./run_quick.sh
```

or in MATLAB:

```matlab
main_quick
```

### Medium Run

```bash
chmod +x run_medium.sh
./run_medium.sh
```

or in MATLAB:

```matlab
main_medium
```

### Full Run

```bash
chmod +x run.sh
./run.sh
```

or in MATLAB:

```matlab
main
```

---

## Output

Generated output is saved in:

```text
results/data/
results/figures/
```

Typical generated files include:

- `study_summary.csv`,
- residual plots,
- velocity magnitude contours,
- pressure contours,
- streamlines,
- vorticity plots,
- Ghia validation plots.

The full generated `results/` folder is not intended to be committed to GitHub.

Only selected figures are stored in:

```text
assets/figures/
```

---

## Summary Table Columns

The generated `study_summary.csv` contains:

| Column | Meaning |
|---|---|
| `Implementation` | Loop or vectorized |
| `N` | Mesh size |
| `Re` | Reynolds number |
| `Scheme` | Upwind or central |
| `PressureSolver` | RBGS or RBSOR |
| `FinalRu` | Final u-velocity residual |
| `FinalRv` | Final v-velocity residual |
| `FinalRcMass` | Normalized continuity residual |
| `FinalRcDiv` | Raw divergence residual |
| `Runtime_s` | Runtime in seconds |
| `AvgPoissonIterations` | Average pressure iterations |
| `Ghia_u_L2` | L2 error for u centerline |
| `Ghia_v_L2` | L2 error for v centerline |
| `ValidationPass` | Benchmark validation status |

---

## Notes on MATLAB `.fig` Files

`.fig` files are MATLAB-native editable figures.

They are useful if you want to reopen a plot in MATLAB and edit:

- axes,
- labels,
- legends,
- colors,
- line widths,
- annotations.

They are not needed for GitHub and are ignored by `.gitignore`.

---

## Known Limitations

This is an educational and research-style MATLAB CFD solver.

Current limitations:

- The solver uses a collocated finite-difference formulation.
- It is not a commercial finite-volume CFD solver.
- Rhie-Chow interpolation is not implemented.
- Turbulence modeling is not included.
- High-Reynolds-number cases require sufficiently fine meshes.
- Coarse high-Reynolds-number cases can be under-resolved.
- The code prioritizes clarity and numerical comparison over maximum performance.

---

## Repository Hygiene

The following generated files are ignored:

```text
*.mat
*.fig
results/data/*
results/figures/*
```

Only selected plots are included under:

```text
assets/figures/
```

---

## References

1. Ghia, U., Ghia, K. N., and Shin, C. T.  
   High-Re solutions for incompressible flow using the Navier-Stokes equations and a multigrid method.  
   Journal of Computational Physics, 48(3), 387-411, 1982.

2. Patankar, S. V.  
   Numerical Heat Transfer and Fluid Flow.  
   Hemisphere Publishing, 1980.

3. Ferziger, J. H., Peric, M., and Street, R. L.  
   Computational Methods for Fluid Dynamics.  
   Springer, 2002.

4. Versteeg, H. K., and Malalasekera, W.  
   An Introduction to Computational Fluid Dynamics: The Finite Volume Method.  
   Pearson, 2007.

---

## License

This project is licensed under the MIT License.

See `LICENSE` for details.

---

## Contact

Ahmed Kandil

- GitHub: [Kandil2001](https://github.com/Kandil2001)
- LinkedIn: [Ahmed Kandil](https://www.linkedin.com/in/ahmed-kandil01)
- Email: a.akandil@outlook.com
