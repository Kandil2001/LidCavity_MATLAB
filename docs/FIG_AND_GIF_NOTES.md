# Figure and GIF Notes

## What is a `.fig` file?

A `.fig` file is MATLAB's native editable figure format.

It can be reopened in MATLAB to edit:

- axis labels,
- font size,
- line width,
- colors,
- legends,
- annotations,
- export settings.

Example:

```matlab
openfig("results/figures/example.fig")
```

---

## Should `.fig` files be uploaded to GitHub?

Usually no.

Reasons:

- `.fig` files can be large,
- they are MATLAB-specific,
- GitHub cannot preview them nicely,
- they are generated outputs.

The repository should ignore them using `.gitignore`.

---

## What figures should be uploaded?

Upload selected `.png` figures only.

Recommended folder:

```text
assets/figures/
```

Recommended examples:

- residual plot,
- velocity magnitude plot,
- streamline plot,
- Ghia validation plots,
- runtime comparison,
- pressure-solver comparison,
- mesh/scheme validation error.

---

## Why are GIFs optional?

GIFs can be useful for showing transient or pseudo-time evolution, but they can make the repository large.

For this project, static plots are enough to document:

- convergence,
- validation,
- velocity field,
- pressure solver comparison,
- scheme comparison.

A GIF can be added later if it is small and useful for the README.

---

## Recommended GitHub Approach

Use:

```text
assets/figures/*.png
```

Avoid:

```text
results/figures/*.fig
results/figures/*.png
```

The `results/` folder is generated output and should stay ignored.
