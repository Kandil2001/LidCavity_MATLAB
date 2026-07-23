# Running the MATLAB Phase 2 Solver

## MATLAB command window

Start MATLAB in the repository root and run one mode:

```matlab
run_mode('single')
run_mode('quick')
run_mode('medium')
run_mode('grid')
run_mode('re1000')
run_mode('full')
```

The equivalent script entry points are `main_single`, `main_quick`, `main_medium`, `main_grid`, `main_re1000`, and `main`.

## Linux batch execution

```bash
bash scripts/run_single.sh
bash scripts/run_quick.sh
bash scripts/run_medium.sh
bash scripts/run_grid.sh
bash scripts/run_re1000.sh
bash scripts/run_full.sh
```

The wrapper uses `matlab -batch` and writes a timestamped log in `logs/`. When MATLAB is not on `PATH`, set its executable explicitly:

```bash
MATLAB_BIN=/path/to/matlab bash scripts/run_single.sh
```

## Recommended COMPASS sequence

Run the modes sequentially:

```bash
bash scripts/run_tests.sh
bash scripts/run_single.sh
bash scripts/run_medium.sh
bash scripts/run_grid.sh
bash scripts/run_re1000.sh
bash scripts/run_full.sh
```

Do not start multiple modes in the same repository simultaneously because they share `results/data/` and `results/figures/`.

## Outputs

Each mode writes `study_summary_<mode>.csv`. Each case writes convergence history, flattened fields, centerline profiles, and a MATLAB result file. Strict mode raises a MATLAB error when any requested case does not reach the numerical convergence definition.

## Runtime note

The full 72-case study includes the loop implementation and the `N = 128` mesh. It can be substantially slower than the production verification modes. Use `medium` and `grid` first to verify the environment and solver behavior.
