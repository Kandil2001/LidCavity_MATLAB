# Run modes

## Quick

```bash
./run_quick.sh
```

Runs 32 simulations:

```text
2 meshes x 2 Re x 2 schemes x 2 pressure solvers x 2 implementations = 32
```

## Medium

```bash
./run_medium.sh
```

Runs 48 simulations:

```text
2 meshes x 3 Re x 2 schemes x 2 pressure solvers x 2 implementations = 48
```

## Full

```bash
./run.sh
```

Runs 72 simulations:

```text
3 meshes x 3 Re x 2 schemes x 2 pressure solvers x 2 implementations = 72
```

The full mode also uses higher solver limits:

```matlab
cfg.maxIter = 3000;
cfg.poisson_maxIter = 1200;
```

This means every case is allowed to converge longer than the old 1500-iteration version.
