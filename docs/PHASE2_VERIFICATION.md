# Phase 2 Verification Plan

## Canonical regression

The required first check is:

```text
N = 32
Re = 100
scheme = upwind
pressure solver = RBSOR
MATLAB implementation = vectorized
```

Run:

```bash
bash scripts/run_tests.sh
```

The test fails unless the case converges, all strict residual limits pass, and the Ghia benchmark limits pass.

## Production verification modes

After the regression succeeds:

1. `medium`: six `N = 32` cases across `Re = 100, 400, 1000` and both convection schemes
2. `grid`: `N = 16, 32, 64` at `Re = 100`
3. `re1000`: representative `N = 64`, `Re = 1000` case
4. `full`: complete 72-case MATLAB comparison

## Required evidence

For each case, inspect:

- terminal status
- velocity-update `Linf`
- divergence `Linf` and `L2`
- global mass imbalance
- pressure residual and pressure iteration count
- Ghia `L2` and `Linf` errors
- runtime

The standardized CSV outputs allow direct comparison with the C++ Phase 2 results.

## Current execution status

The branch implementation was prepared without access to a MATLAB or Octave runtime in the editing environment. The COMPASS regression run is therefore the required numerical acceptance step before merging the Phase 2 branch into `main`.
