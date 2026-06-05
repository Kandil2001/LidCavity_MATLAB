# Running the code

## Requirements

The project uses MATLAB scripts and base MATLAB plotting functions. Run the scripts from the repository root so that the relative paths are added correctly.

Generated output is written to `results/data/` and `results/figures/`. These folders are kept in the repository, but their generated contents are ignored by Git.

## Available run modes

### Quick study

```matlab
main_quick
```

This is the best starting point after cloning the repository or changing a solver function. It uses smaller meshes and fewer Reynolds numbers than the full study, but it still compares both schemes, pressure solvers, and implementations.

### Medium study

```matlab
main_medium
```

This runs more cases without including the `N = 128` mesh.

### Full study

```matlab
main
```

This runs all 72 combinations. It can take a long time because each case may use thousands of outer iterations and many pressure iterations.

Linux shell wrappers are included for the same three modes:

```bash
./run_quick.sh
./run_medium.sh
./run.sh
```

The wrappers assume the `matlab` command is available in the shell path.

## Running one case

For a small editable example, open:

```matlab
studies/run_single_case.m
```

The mesh, Reynolds number, convection scheme, pressure solver, and implementation are defined near the top of that file.

`studies/run_best_validation_case.m` runs the representative `N = 64`, `Re = 100`, central-differencing case used in the README.

## Changing the study

Most settings are collected in `default_config.m`, including:

- mesh sizes and Reynolds numbers,
- convergence tolerances,
- relaxation factors,
- pressure-solver limits,
- validation thresholds,
- figure output settings.

The quick and medium scripts override a few of these values to reduce runtime.

## Main outputs

The parameter-study scripts create:

- one `.mat` file per case,
- a CSV and MAT summary table,
- residual and pressure-residual histories,
- velocity, pressure, vorticity, streamline, and vector plots,
- Ghia centerline comparison plots,
- study-level runtime and error comparisons.

Selected output from the completed study is copied to `assets/` so it is visible on GitHub without committing every generated file.

## Common issues

### MATLAB cannot find a function

Start MATLAB in the repository root and run one of the main scripts. They add `core/`, `studies/`, `validation/`, and `post/` to the path.

### A case reaches `maxIter`

This means the strict outer stopping criteria were not met before the configured limit. Check the residual histories, mass imbalance, validation error, and flow plots together. Do not use the validation flag alone as proof of convergence.

### The full study takes too long

Use `main_quick` first. The RBGS and `N = 128` combinations are especially expensive in the included setup.

### Generated figures do not appear on GitHub

The contents of `results/` are ignored by Git. Copy only the figures you want to publish into `assets/figures/` and reference those files in the README.
