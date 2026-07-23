function cfg = default_config()
%DEFAULT_CONFIG Phase 2 production settings for the MATLAB cavity solver.

cfg.U_lid = 1.0;
cfg.L = 1.0;

% Strict outer convergence definition. A case is converged only when every
% criterion passes for the requested number of consecutive iterations.
cfg.maxIter = 30000;
cfg.minimum_iterations = 200;
cfg.consecutive_passes = 20;
cfg.maximum_pressure_failures = 3;
cfg.tol_velocity_linf = 1e-8;
cfg.tol_divergence_linf = 1e-9;
cfg.tol_divergence_l2 = 2e-10;
cfg.tol_global_mass = 1e-12;
cfg.diverged_limit = 1e6;

% Pseudo-time and relaxation controls.
cfg.cfl = 0.60;
cfg.dt_max = 0.01;
cfg.dt_min = 1e-8;
cfg.alpha_u = 0.90;
cfg.alpha_p = 1.00;

% Pressure-correction Poisson solver.
cfg.poisson_maxIter = 5000;
cfg.poisson_check_every = 20;
cfg.poisson_tol_abs = 1e-10;
cfg.poisson_tol_rel = 1e-9;
cfg.sor_omega = 'auto';
cfg.sor_omega_min = 1.0;
cfg.sor_omega_max = 1.95;

% Stagnation diagnostics.
cfg.stagnation_window = 1500;
cfg.stagnation_minimum_reduction = 0.005;

% Study definitions. The production comparison uses the vectorized MATLAB
% implementation; the full MATLAB study also compares the loop version.
cfg.meshes = [32, 64, 128];
cfg.re_list = [100, 400, 1000];
cfg.schemes = {'upwind','central'};
cfg.pressure_solvers = {'RBGS','RBSOR'};
cfg.implementations = {'vectorized','loop'};
cfg.use_continuation = true;
cfg.strict = true;
cfg.progress_every = 1000;

% Practical benchmark limits against the Ghia centerline values.
cfg.validation_u_L2_limit_Re100 = 0.030;
cfg.validation_v_L2_limit_Re100 = 0.030;
cfg.validation_u_L2_limit_Re400 = 0.090;
cfg.validation_v_L2_limit_Re400 = 0.120;
cfg.validation_u_L2_limit_Re1000 = 0.160;
cfg.validation_v_L2_limit_Re1000 = 0.180;

% Output controls. Per-case figures are disabled for large studies by
% default because graphics can dominate batch runtime on COMPASS.
cfg.make_figures = true;
cfg.figure_every_case = false;
cfg.save_fields = true;
cfg.results_dir = fullfile('results');
cfg.data_dir = fullfile('results','data');
cfg.fig_dir = fullfile('results','figures');
end
