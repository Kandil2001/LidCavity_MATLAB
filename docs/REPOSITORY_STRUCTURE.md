# Repository Structure

This document explains the purpose of each folder in the repository.

---

## Root Files

| File | Purpose |
|---|---|
| `README.md` | Main project overview |
| `LICENSE` | MIT license |
| `.gitignore` | Prevents generated files from being committed |
| `main.m` | Runs the full study |
| `main_quick.m` | Runs a smaller quick study |
| `main_medium.m` | Runs an intermediate study |
| `default_config.m` | Main solver and study configuration |
| `run.sh` | Shell script for full run |
| `run_quick.sh` | Shell script for quick run |
| `run_medium.sh` | Shell script for medium run |

---

## `core/`

Contains the main CFD solver functions.

Important files:

| File | Purpose |
|---|---|
| `solve_lid_cavity.m` | Main solver function |
| `momentum_predictor_vectorized.m` | Vectorized momentum predictor |
| `momentum_predictor_loop.m` | Loop-based momentum predictor |
| `pressure_poisson.m` | Pressure correction Poisson solver |
| `apply_lid_bc.m` | Lid-driven cavity boundary conditions |
| `apply_pressure_bc.m` | Pressure boundary conditions |
| `divergence_field.m` | Computes velocity divergence |
| `velocity_residuals.m` | Computes residuals |
| `compute_dt.m` | Computes pseudo-time step |
| `compute_vorticity.m` | Computes vorticity field |

---

## `studies/`

Contains scripts that run simulations and parameter studies.

| File | Purpose |
|---|---|
| `run_parametric_study.m` | Runs the full combination of cases |
| `run_single_case.m` | Runs one case for debugging |
| `run_best_validation_case.m` | Runs a recommended validation case |

---

## `validation/`

Contains benchmark validation tools.

| File | Purpose |
|---|---|
| `ghia_data.m` | Stores Ghia benchmark data |
| `validate_against_ghia.m` | Compares solver results with Ghia data |

---

## `post/`

Contains plotting and post-processing functions.

| File | Purpose |
|---|---|
| `plot_fields.m` | Plots velocity, pressure, streamlines, vorticity |
| `plot_residuals.m` | Plots residual histories |
| `plot_validation.m` | Plots Ghia validation comparisons |
| `plot_study_summary.m` | Plots study-level comparison figures |
| `save_current_figure.m` | Saves figures consistently |

---

## `docs/`

Contains written explanations.

Recommended files:

| File | Purpose |
|---|---|
| `WHAT_THIS_PROJECT_DOES.md` | High-level project explanation |
| `METHODOLOGY.md` | Numerical method explanation |
| `RUN_MODES.md` | How to run quick, medium, and full studies |
| `VALIDATION.md` | Validation methodology |
| `RESULTS_DISCUSSION.md` | Discussion and conclusion |
| `OUTPUTS_AND_UPLOAD_GUIDE.md` | What to upload to GitHub |
| `FIG_AND_GIF_NOTES.md` | Notes about figures and generated plots |
| `REPOSITORY_STRUCTURE.md` | Explanation of repository folders |

---

## `assets/`

Contains selected files for the GitHub README.

Use:

```text
assets/figures/
assets/data/
```

Do not put all generated results here. Only upload selected figures and the summary CSV.

---

## `results/`

Contains generated solver output.

This folder is ignored by Git except for `.gitkeep` files.

It should contain:

```text
results/data/.gitkeep
results/figures/.gitkeep
```

Generated simulation outputs will be written here when the code is run.
