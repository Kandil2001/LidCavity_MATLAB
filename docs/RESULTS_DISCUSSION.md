# Results Discussion

## Overview

This study evaluates a MATLAB SIMPLE-style pressure-correction solver for the two-dimensional incompressible lid-driven cavity problem.

The solver was tested across:

- three mesh sizes: `N = 32, 64, 128`,
- three Reynolds numbers: `Re = 100, 400, 1000`,
- two convection schemes: `upwind` and `central`,
- two pressure solvers: `RBGS` and `RBSOR`,
- two implementations: `loop` and `vectorized`.

This gives a total of:

```text
3 × 3 × 2 × 2 × 2 = 72 simulations
```

---

## Main Findings

### 1. Loop and vectorized implementations match

The loop-based and vectorized MATLAB implementations produced matching numerical results for equivalent cases.

This confirms that the vectorized implementation preserves the mathematical behavior of the reference loop solver.

This is important because it means the vectorized code was not only faster in structure, but also numerically consistent.

---

### 2. RBSOR is significantly faster than RBGS

The red-black SOR pressure solver reduced the pressure-correction cost compared with red-black Gauss-Seidel.

This was especially visible for larger meshes such as `N = 128`, where RBGS required many more pressure iterations and much longer runtime.

Therefore, RBSOR is the preferred pressure solver for the current implementation.

---

### 3. Mesh refinement improves validation quality

The results show that validation accuracy generally improves as the grid is refined.

For low Reynolds number cases such as `Re = 100`, both `N = 64` and `N = 128` provide good agreement with the Ghia benchmark.

For higher Reynolds numbers, especially `Re = 1000`, the finer `N = 128` mesh is required to obtain acceptable agreement.

---

### 4. Central differencing is more accurate when the mesh is sufficient

Central differencing produced better agreement with benchmark data for sufficiently resolved cases.

However, central differencing is more sensitive on coarse meshes and at higher Reynolds numbers.

This behavior is expected because central differencing introduces less numerical diffusion than upwind differencing, but it is less robust for under-resolved flow fields.

---

### 5. Upwind differencing is more robust on coarse meshes

The upwind scheme was more stable for coarse-grid and high-Reynolds-number cases.

However, it introduced more numerical diffusion, which reduced benchmark accuracy compared with central differencing on sufficiently refined meshes.

This demonstrates the classical trade-off between stability and accuracy.

---

## Validation Against Ghia Benchmark

The solver was compared against Ghia et al. benchmark centerline data using:

- vertical centerline velocity `u(y)` at `x = 0.5`,
- horizontal centerline velocity `v(x)` at `y = 0.5`.

The strongest validation behavior was observed for:

```text
N = 64,  Re = 100,  central scheme
N = 128, Re = 100,  central scheme
N = 128, Re = 400,  central scheme
N = 128, Re = 1000, central scheme
```

The coarse high-Reynolds-number cases, especially `N = 32` at `Re = 400` and `Re = 1000`, showed larger benchmark errors. These cases are considered under-resolved rather than solver failures.

---

## Performance Discussion

The vectorized solver gives the same numerical results as the loop solver.

However, the total speedup depends strongly on the pressure Poisson solver. In many cases, the pressure solver dominates the runtime, so vectorizing only the momentum predictor does not always produce a large global speedup.

The largest performance improvement came from using RBSOR instead of RBGS.

---

## Engineering Interpretation

The study demonstrates several important CFD principles:

1. Mesh refinement is necessary for high-Reynolds-number accuracy.
2. Central differencing is accurate but requires sufficient resolution.
3. Upwind differencing is more stable but more diffusive.
4. Pressure-solver efficiency strongly controls total runtime.
5. Vectorization improves MATLAB implementation quality, but the pressure solver remains the computational bottleneck.

---

## Recommended Cases for Presentation

For a clean validation example, use:

```text
N = 64, Re = 100, central, RBGS or RBSOR, vectorized
```

For a stronger high-resolution result, use:

```text
N = 128, Re = 1000, central, RBSOR, vectorized
```

For discussing numerical diffusion and stability, compare:

```text
upwind vs central
```

For discussing pressure-solver efficiency, compare:

```text
RBGS vs RBSOR
```

---

## Conclusion

The MATLAB solver successfully demonstrates a complete SIMPLE-style pressure-correction workflow for the lid-driven cavity benchmark.

The project shows:

- implementation of the 2D incompressible Navier-Stokes equations,
- pressure-velocity coupling through pressure correction,
- loop and vectorized MATLAB implementations,
- comparison of convection schemes,
- comparison of pressure solvers,
- mesh and Reynolds-number studies,
- validation against benchmark data.

The results confirm that the solver gives physically meaningful and benchmark-consistent results for sufficiently resolved meshes.

The study also shows that coarse meshes at higher Reynolds numbers are not sufficient for accurate validation, which is consistent with expected CFD behavior.

Overall, this project provides a transparent MATLAB framework for understanding incompressible CFD solver development, numerical stability, validation, and performance comparison.
