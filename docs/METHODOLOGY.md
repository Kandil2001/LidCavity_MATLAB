# Methodology

## Governing Equations

The solver models two-dimensional incompressible Newtonian flow.

The continuity equation is:

```math
\nabla \cdot \mathbf{u} = 0
```

The incompressible Navier-Stokes equations are:

```math
\frac{\partial \mathbf{u}}{\partial t}
+
(\mathbf{u}\cdot\nabla)\mathbf{u}
=
-\nabla p
+
\frac{1}{Re}\nabla^2 \mathbf{u}
```

where:

- `u` and `v` are the velocity components,
- `p` is pressure,
- `Re` is the Reynolds number.

---

## Numerical Formulation

The project uses a collocated structured Cartesian grid and a finite-difference pressure-correction formulation.

The solver is written for clarity and study purposes. It is not intended to replace a commercial finite-volume CFD code.

---

## Pressure-Velocity Coupling

The solver uses a SIMPLE-style pressure-correction procedure.

The steps are:

1. initialize velocity and pressure,
2. apply lid-driven cavity boundary conditions,
3. predict intermediate velocities from the momentum equations,
4. compute the divergence of the predicted velocity field,
5. solve the pressure correction Poisson equation,
6. correct the velocity field,
7. update pressure using under-relaxation,
8. compute residuals,
9. repeat until convergence or maximum iteration count.

---

## Momentum Predictor

The momentum predictor computes intermediate velocities:

```math
\mathbf{u}^{*}
=
\mathbf{u}^{n}
+
\Delta t
\left[
-(\mathbf{u}\cdot\nabla)\mathbf{u}
-\nabla p
+
\frac{1}{Re}\nabla^2\mathbf{u}
\right]
```

The code includes two implementations:

- loop-based implementation,
- vectorized MATLAB implementation.

Both implementations solve the same numerical equations.

---

## Pressure Correction

The pressure correction equation is:

```math
\nabla^2 p'
=
\frac{1}{\Delta t}
\nabla \cdot \mathbf{u}^{*}
```

where `p'` is the pressure correction.

The corrected velocity is:

```math
\mathbf{u}^{n+1}
=
\mathbf{u}^{*}
-
\Delta t \nabla p'
```

The pressure update is:

```math
p^{n+1}
=
p^n
+
\alpha_p p'
```

where `αp` is the pressure under-relaxation factor.

---

## Convection Schemes

Two convection schemes are implemented.

### Upwind Scheme

The upwind scheme uses information from the upstream direction.

Advantages:

- more stable,
- more robust on coarse meshes,
- useful at higher Reynolds numbers.

Disadvantages:

- more numerically diffusive,
- may reduce benchmark accuracy.

### Central Scheme

The central scheme uses neighboring values symmetrically.

Advantages:

- less numerical diffusion,
- better accuracy on sufficiently refined meshes.

Disadvantages:

- less robust on coarse meshes,
- more sensitive at high Reynolds numbers.

---

## Pressure Solvers

The pressure Poisson equation is solved using:

| Solver | Description |
|---|---|
| `RBGS` | Red-black Gauss-Seidel |
| `RBSOR` | Red-black Successive Over-Relaxation |

`RBSOR` is usually faster because it applies over-relaxation to accelerate convergence.

---

## Residuals

The solver monitors:

| Residual | Meaning |
|---|---|
| `FinalRu` | Final horizontal velocity residual |
| `FinalRv` | Final vertical velocity residual |
| `FinalRcMass` | Normalized continuity / mass residual |
| `FinalRcDiv` | Raw divergence residual |
| `AvgPoissonIterations` | Average pressure iterations |
| `PressureSaturationRatio` | Fraction of pressure solves reaching max iterations |

The normalized mass residual is the most useful continuity indicator for comparing cases with different mesh sizes.

---

## Validation Method

The numerical solution is compared against Ghia et al. benchmark data using:

- vertical centerline velocity `u(y)` at `x = 0.5`,
- horizontal centerline velocity `v(x)` at `y = 0.5`.

The error is reported as:

- `Ghia_u_L2`,
- `Ghia_v_L2`,
- `Ghia_u_Linf`,
- `Ghia_v_Linf`.

---

## Important Note

The method is suitable for learning and numerical comparison. For industrial-grade collocated finite-volume SIMPLE solvers, Rhie-Chow interpolation and stronger pressure-velocity coupling treatment would normally be added.
