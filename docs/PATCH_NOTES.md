# Patch notes

## Toolbox-free plotting fix

The original version used `gscatter` inside:

```matlab
post/plot_study_summary.m
```

`gscatter` requires the Statistics and Machine Learning Toolbox.

This patched version uses only base MATLAB commands (`plot`, `unique`, `legend`) so it works on MATLAB R2022b without extra toolboxes.

Your simulations were already completed successfully. The previous error happened only during final summary plotting.
