# Troubleshooting

## MATLAB cannot find a function

Run the scripts from the repository root folder. The main scripts add the required folders automatically:

```matlab
addpath("core");
addpath("studies");
addpath("validation");
addpath("post");
```

If you are running individual functions manually, add these paths first.

---

## The full study takes too long

Start with:

```matlab
main_quick
```

Then try:

```matlab
main_medium
```

Only run the full `main` study after the quick and medium runs work.

The full study includes 72 simulations and can take a long time, especially for `N = 128`, `Re = 1000`, and RBGS pressure-solver cases.

---

## Generated results are not showing on GitHub

This is expected. The generated `results/data/` and `results/figures/` contents are ignored by Git to keep the repository clean.

Selected representative figures should be copied to:

```text
assets/figures/
```

The README uses figures from `assets/figures/`, not from `results/figures/`.

---

## A case reaches `maxIter`

This does not automatically mean the result is useless. The project records additional quality fields such as:

- `FinalRcMass`,
- `FinalRcDiv`,
- `Ghia_u_L2`,
- `Ghia_v_L2`,
- `ValidationPass`,
- `Quality`.

Some cases can be validated against Ghia centerline data while still reaching the configured maximum iteration count. The repository intentionally reports this honestly.

---

## High-Reynolds-number cases look less accurate

This is expected on coarse meshes. Higher Reynolds-number lid-driven cavity flow contains sharper gradients and stronger vortical structures. Use a finer mesh and compare validation errors before interpreting the result.

---

## Central differencing behaves worse on coarse meshes

Central differencing has lower numerical diffusion than upwind differencing, but it is more sensitive to under-resolution. On coarse meshes or higher Reynolds numbers, upwind can be more robust while central can require stronger mesh resolution.
