# Outputs and GitHub Upload Guide

## Purpose

This document explains which generated outputs should be uploaded to GitHub and which outputs should stay ignored.

The goal is to keep the repository clean, professional, and lightweight.

---

## Generated Output Folders

When the solver runs, it creates output in:

```text
results/data/
results/figures/
```

These folders can become very large.

Therefore, the full generated `results/` folder should not be committed to GitHub.

---

## What to Upload

Upload the source code, documentation, and selected representative outputs.

### Upload These Files

```text
README.md
LICENSE
.gitignore
main.m
main_quick.m
main_medium.m
default_config.m
run.sh
run_quick.sh
run_medium.sh
```

### Upload These Folders

```text
core/
studies/
validation/
post/
docs/
assets/
results/
```

The `results/` folder should only contain `.gitkeep` files:

```text
results/data/.gitkeep
results/figures/.gitkeep
```

---

## Selected Figures to Upload

Only selected figures should be copied into:

```text
assets/figures/
```

Recommended selected figures:

```text
case_029_N64_Re100_central_RBGS_vectorized_residuals.png
case_029_N64_Re100_central_RBGS_vectorized_speed.png
case_029_N64_Re100_central_RBGS_vectorized_streamlines.png
case_029_N64_Re100_central_RBGS_vectorized_ghia_u.png
case_029_N64_Re100_central_RBGS_vectorized_ghia_v.png
study_runtime_implementation.png
study_pressure_solver_iterations.png
study_ghia_error.png
```

These are enough to show:

- convergence behavior,
- velocity field,
- streamlines,
- validation,
- runtime comparison,
- pressure-solver comparison,
- mesh/scheme validation behavior.

---

## Selected Data to Upload

Upload only:

```text
assets/data/study_summary.csv
```

This file contains the numerical summary of the 72-case study.

---

## What Not to Upload

Do not upload:

```text
results.zip
*.mat
*.fig
full results/data/
full results/figures/
all generated PNG files
```

Reason:

- `.mat` files are generated simulation data,
- `.fig` files are MATLAB editable plots and can be large,
- all generated PNGs make the repository messy,
- the full results folder can become too large.

---

## Recommended `.gitignore`

Use:

```gitignore
# MATLAB autosave / backup files
*.asv
*.m~
*.mlx~
*.slxc

# Generated MATLAB data and editable figures
*.mat
*.fig

# Generated results
results/data/*
results/figures/*

# Keep empty results folders
!results/data/.gitkeep
!results/figures/.gitkeep

# Large generated media
*.avi
*.mp4

# Logs / temporary files
*.log
*.tmp

# Editor folders
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db
```

---

## Final GitHub Structure

The final uploaded repository should look like:

```text
LidCavity_MATLAB/
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
│
├── assets/
│   ├── figures/
│   └── data/
│
└── results/
    ├── data/
    │   └── .gitkeep
    └── figures/
        └── .gitkeep
```
