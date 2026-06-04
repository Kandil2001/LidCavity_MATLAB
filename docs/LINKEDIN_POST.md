# LinkedIn Post Draft

I recently finished a MATLAB CFD benchmark project for the two-dimensional incompressible lid-driven cavity problem.

The goal was not only to generate flow-field plots, but to build and study the numerical solver from the method level.

In this project, I implemented a SIMPLE-style pressure-correction solver for the incompressible Navier-Stokes equations and used it to compare different numerical choices.

The study includes:

- 2D incompressible Navier-Stokes solver in MATLAB
- SIMPLE-style pressure-velocity coupling
- loop-based and vectorized implementations
- upwind and central differencing schemes
- Red-Black Gauss-Seidel and Red-Black SOR pressure solvers
- mesh study with `N = 32, 64, 128`
- Reynolds-number study with `Re = 100, 400, 1000`
- 72 simulation cases in total
- validation against the classical Ghia et al. lid-driven cavity benchmark

Some of the main lessons from the project were:

- mesh refinement becomes critical at higher Reynolds numbers
- central differencing gives better accuracy when the mesh is sufficiently resolved
- upwind differencing is more robust but more diffusive
- pressure-solver performance strongly affects total runtime
- vectorization improves MATLAB implementation quality, but the pressure Poisson equation can still dominate the computational cost

This project helped me strengthen my understanding of CFD beyond commercial software by working directly with discretization, pressure correction, residuals, validation, and numerical stability.

GitHub repository: [add repository link]

#CFD #MATLAB #NumericalMethods #FluidDynamics #ComputationalFluidDynamics #NavierStokes #Engineering #Simulation #Programming #MechanicalEngineering
