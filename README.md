# Full SIMPLE / Pressure-Correction Lid-Driven Cavity CFD Project

This project is a complete MATLAB CFD study framework for the 2D incompressible lid-driven cavity problem.

It includes:

- Full 2D incompressible Navier-Stokes momentum equations
- SIMPLE-style pressure correction / projection loop
- Full vectorized momentum predictor and velocity correction
- Loop-based reference solver for comparison
- Central differencing and sign-based upwind convection
- Vectorized Jacobi, red-black Gauss-Seidel, and red-black SOR pressure solvers
- Mesh-size study
- Reynolds-number study
- Scheme comparison
- Pressure-solver comparison
- Loop vs vectorized performance comparison
- Residual plots
- Velocity magnitude, pressure, streamlines, vorticity, and vector plots
- Ghia et al. benchmark centerline validation for Re = 100 and Re = 400
- CSV and MAT exports

## Run

From the project folder:

```bash
chmod +x run.sh
./run.sh
```

Or from MATLAB:

```matlab
main
```

For a quick debug case:

```matlab
addpath("core"); addpath("studies"); addpath("validation"); addpath("post");
run_single_case
```

## Important technical note

This is a collocated finite-difference educational/research solver using a pressure-correction/SIMPLE-style method.

It solves the full incompressible Navier-Stokes equations in 2D, but it is not a commercial finite-volume SIMPLE implementation with Rhie-Chow interpolation. For a master's CFD coding project and numerical-methods study, it is the right level: transparent, modular, inspectable, and extendable.

## What the solver does

For each outer iteration:

1. Applies lid-driven cavity no-slip boundary conditions.
2. Solves/predicts the momentum equations:
   - convection
   - diffusion
   - pressure gradient
3. Builds the pressure-correction Poisson equation from velocity divergence.
4. Solves the Poisson equation with Jacobi, red-black Gauss-Seidel, or red-black SOR.
5. Corrects velocity and pressure.
6. Computes residuals:
   - u change
   - v change
   - continuity error
7. Stops when velocity and continuity residuals meet tolerance or max iterations are reached.

## Study outputs

Files are saved to:

```text
results/data
results/figures
```

The main summary file is:

```text
results/data/study_summary.csv
```

## How to make the study heavier

Edit `main.m` or `default_config.m`:

```matlab
cfg.meshes = [32,64,128];
cfg.re_list = [100,400,1000];
cfg.implementations = {'vectorized','loop'};
cfg.maxIter = 3000;
```

For high Reynolds numbers, use upwind first. Central differencing can be less stable unless the mesh and pseudo-time step are sufficient.

## Files

```text
core/
  solve_lid_cavity.m
  momentum_predictor_vectorized.m
  momentum_predictor_loop.m
  pressure_poisson.m
  apply_lid_bc.m
  divergence_field.m
  velocity_residuals.m
  compute_vorticity.m
  compute_dt.m

studies/
  run_parametric_study.m
  run_single_case.m

validation/
  ghia_data.m
  validate_against_ghia.m

post/
  plot_residuals.m
  plot_fields.m
  plot_validation.m
  plot_study_summary.m
```
## Run modes added in this version

This version has three run modes.

### Quick run: 32 simulations

```bash
chmod +x run_quick.sh
./run_quick.sh
```

Equivalent MATLAB command:

```matlab
main_quick
```

### Medium run: 48 simulations

```bash
chmod +x run_medium.sh
./run_medium.sh
```

Equivalent MATLAB command:

```matlab
main_medium
```

### Full run: 72 simulations

This is the default now.

```bash
chmod +x run.sh
./run.sh
```

Equivalent MATLAB command:

```matlab
main
```

The full run uses:

```matlab
cfg.meshes = [32, 64, 128];
cfg.re_list = [100, 400, 1000];
cfg.schemes = {'upwind','central'};
cfg.pressure_solvers = {'RBGS','RBSOR'};
cfg.implementations = {'vectorized','loop'};
```

Number of simulations:

```text
3 x 3 x 2 x 2 x 2 = 72 simulations
```

Solver limits were also increased:

```matlab
cfg.maxIter = 3000;
cfg.poisson_maxIter = 1200;
cfg.poisson_tol = 1e-5;
cfg.sor_omega = 1.4;
cfg.alpha_u = 0.65;
cfg.alpha_p = 0.25;
```

## Warning about runtime

The full 72-case run can take a long time, especially the 128 x 128 loop-based cases. If you only want to check that the code works, use `run_quick.sh` first.

# Convergence-validation version

This version was edited after inspecting the first 72-case run.

## What was fixed

1. **Continuity residual definition**
   - Old version used raw divergence only.
   - New version uses normalized finite-volume mass imbalance:
     ```matlab
     Rc_mass = max(abs(divergence)) * dx * dy / (U*L)
     ```
   - Raw divergence is still saved as `FinalRcDiv`.

2. **Pressure Poisson convergence**
   - Old version stopped based mainly on field change.
   - New version computes true Poisson residual:
     ```matlab
     residual = norm(Laplacian(phi) - rhs, inf)
     ```

3. **Adaptive solver limits**
   - N=128, Re=1000, and central differencing automatically receive more outer iterations.

4. **Automatic SOR omega**
   - `cfg.sor_omega = 'auto'`
   - The code chooses a mesh-dependent omega and clamps it for stability.

5. **Re=1000 Ghia validation**
   - Added benchmark centerline data for Re=1000.

6. **Quality classification**
   Each case is labeled as:
   - `converged_validated`
   - `converged_not_validated`
   - `validated_but_not_converged`
   - `needs_improvement`

## Important honesty

The code no longer pretends every case is valid. It only labels a case as `converged_validated` when both solver convergence and Ghia validation gates are passed.

High-Re central differencing on coarse meshes can still be physically under-resolved. That is not a coding bug; it is a numerical-method limitation and should be discussed in the report.
