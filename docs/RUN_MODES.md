# Run Modes

The project includes three main run modes.

---

## Quick Run

Use this to check that the code works.

```bash
chmod +x run_quick.sh
./run_quick.sh
```

or inside MATLAB:

```matlab
main_quick
```

This run is smaller and faster than the full study.

Use it when:

- you just cloned the repo,
- you want to test MATLAB paths,
- you changed a function and want quick feedback.

---

## Medium Run

Use this for an intermediate study.

```bash
chmod +x run_medium.sh
./run_medium.sh
```

or inside MATLAB:

```matlab
main_medium
```

Use it when:

- the quick run works,
- you want more cases,
- you do not want to wait for the full 72-case run.

---

## Full Run

Use this to run the full study.

```bash
chmod +x run.sh
./run.sh
```

or inside MATLAB:

```matlab
main
```

The full run includes:

```text
3 mesh sizes × 3 Reynolds numbers × 2 schemes × 2 pressure solvers × 2 implementations
```

Total:

```text
72 simulations
```

---

## Recommended Workflow

The recommended workflow is:

1. run `main_quick`,
2. check that figures and CSV files are generated,
3. run `main_medium`,
4. only then run `main`.

This avoids waiting a long time if there is a path or environment problem.

---

## Runtime Warning

The full run can take a long time, especially for:

```text
N = 128
```

and for the loop-based implementation.

The generated output can also become large. This is why the full `results/` folder should not be committed to GitHub.
