# Running the code

Run the scripts from the repository root so MATLAB can add the required folders correctly.

Generated data and figures are written to:

```text
results/data/
results/figures/
```

The folders are kept in the repository, but their generated contents are ignored by Git.

## Run modes

### Quick check

```matlab
main_quick
```

Use this after cloning the repository or changing a solver function. It runs a reduced study while still comparing both convection schemes, pressure solvers, and implementations.

### Intermediate study

```matlab
main_medium
```

This runs more cases but does not include the `N = 128` mesh.

### Full study

```matlab
main
```

This runs all 72 combinations. It can take a long time because some cases require thousands of outer iterations and many pressure iterations.

Linux shell wrappers are also included in `scripts/`:

```bash
bash scripts/run_quick.sh
bash scripts/run_medium.sh
bash scripts/run.sh
```

They require the `matlab` command to be available in the shell path.

## Running one editable case

Open and run:

```matlab
studies/run_single_case.m
```

The mesh, Reynolds number, convection scheme, pressure solver, and implementation are defined near the top of the file.

`studies/run_representative_case.m` runs the `N = 64`, `Re = 100`, central-differencing case shown in the README.

## Changing the setup

Most settings are collected in:

```text
config/default_config.m
```

This includes:

- meshes and Reynolds numbers,
- convergence tolerances,
- relaxation factors,
- pressure-solver limits,
- validation limits,
- figure-output settings.

The quick and medium scripts override some of these values to reduce runtime.

## Output files

The parameter study creates:

- one `.mat` file per case,
- CSV and MAT summary tables,
- residual and pressure-residual histories,
- velocity, pressure, vorticity, streamline, and vector plots,
- Ghia centreline-comparison plots,
- study-level runtime and error comparisons.

Selected figures and the published summary are copied to `assets/` so they remain visible on GitHub.

## Common issues

### MATLAB cannot find a function

Start MATLAB in the repository root and run one of the main scripts. The main scripts call `startup/setup_project.m`, which adds the required project folders to the path.

### A case reaches `maxIter`

The outer stopping criteria were not met before the configured limit. Check the residual history, mass imbalance, validation error, and flow plots together. A low validation error alone does not prove numerical convergence.

### The full study takes too long

Start with `main_quick`. The `N = 128` and RBGS cases are the most expensive in the included setup.

### Generated figures do not appear on GitHub

The contents of `results/` are ignored by Git. Copy only the figures you want to publish into `assets/figures/` and reference those files in the README.
