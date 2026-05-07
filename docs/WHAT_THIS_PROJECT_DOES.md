# What this project is doing

This project solves the 2D lid-driven cavity problem.

The physical problem is:

- square cavity
- top lid moves with velocity U = 1
- all other walls are stationary
- incompressible Newtonian fluid

The solver advances a steady pseudo-time pressure-correction/SIMPLE-style iteration.

## Momentum equations

The code solves:

du/dt + u du/dx + v du/dy = -dp/dx + nu (d2u/dx2 + d2u/dy2)

dv/dt + u dv/dx + v dv/dy = -dp/dy + nu (d2v/dx2 + d2v/dy2)

## Continuity equation

du/dx + dv/dy = 0

The pressure correction equation enforces continuity.

## Vectorization

The vectorized solver replaces nested i-j loops in the momentum predictor with matrix slicing:

```matlab
uC = u(2:N-1,2:N-1);
uE = u(2:N-1,3:N);
uW = u(2:N-1,1:N-2);
uN = u(3:N,2:N-1);
uS = u(1:N-2,2:N-1);
```

This is much faster in MATLAB than looping cell by cell.

## Why red-black Gauss-Seidel?

Classical Gauss-Seidel is sequential because every new value immediately depends on previous updated values.

Red-black Gauss-Seidel splits the grid into two masks. This keeps the GS/SOR character while allowing vectorized updates.

## What is compared?

1. Mesh size:
   - accuracy and convergence behavior

2. Reynolds number:
   - flow physics and vortex strength

3. Central vs upwind:
   - central is less diffusive but can be less stable
   - upwind is more stable but adds numerical diffusion

4. RBGS vs RBSOR:
   - SOR usually reduces pressure iterations

5. Loop vs vectorized:
   - both solve the same equations
   - vectorized should be faster
