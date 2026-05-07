function cfg = default_config()
%DEFAULT_CONFIG Central configuration for the validated convergence version.

cfg.U_lid = 1.0;
cfg.L = 1.0;

% ------------------------------------------------------------
% Outer SIMPLE / pressure-correction controls
% ------------------------------------------------------------
% These are higher than the previous study and are mesh/Re aware inside
% solve_lid_cavity.m. The local maximum may be increased automatically.
cfg.maxIter = 4000;
cfg.maxIter_N128_bonus = 3000;
cfg.maxIter_Re1000_bonus = 3000;
cfg.maxIter_central_bonus = 1500;

% Convergence criteria
% Rc is now a finite-volume-style mass imbalance residual:
% div(u) * dx * dy / (U*L)
cfg.tol_mass = 1e-7;
cfg.tol_divergence = 2e-3;      % diagnostic only
cfg.tol_velocity = 5e-7;
cfg.diverged_limit = 1e6;

% Pseudo-time controls
cfg.cfl = 0.25;
cfg.dt_max = 0.0025;
cfg.dt_min = 1e-6;

% SIMPLE / pressure-correction relaxation
cfg.alpha_u = 0.55;
cfg.alpha_p = 0.20;

% ------------------------------------------------------------
% Pressure Poisson controls
% ------------------------------------------------------------
% The pressure solver now checks the true Poisson residual:
%   ||Lap(phi) - rhs||_inf / max(1,||rhs||_inf)
cfg.poisson_maxIter = 2500;
cfg.poisson_tol_abs = 1e-8;
cfg.poisson_tol_rel = 1e-4;
cfg.poisson_check_every = 25;

% SOR controls
% Use 'auto' to compute omega from the mesh. This is safer than a fixed 1.4.
cfg.sor_omega = 'auto';
cfg.sor_omega_min = 1.15;
cfg.sor_omega_max = 1.90;

% If a pressure solve stagnates, the outer solver will still continue, but
% the case summary records average pressure residuals and saturation ratio.
cfg.allow_pressure_maxIter = true;

% ------------------------------------------------------------
% Full default study:
% 3 meshes x 3 Reynolds x 2 schemes x 2 pressure solvers x 2 implementations
% = 72 simulations
% ------------------------------------------------------------
cfg.meshes = [32, 64, 128];
cfg.re_list = [100, 400, 1000];
cfg.schemes = {'upwind','central'};
cfg.pressure_solvers = {'RBGS','RBSOR'};
cfg.implementations = {'vectorized','loop'};

% Validation thresholds against Ghia centerlines.
% These are intentionally realistic for an educational collocated solver.
cfg.validation_u_L2_limit_Re100 = 0.030;
cfg.validation_v_L2_limit_Re100 = 0.030;
cfg.validation_u_L2_limit_Re400 = 0.090;
cfg.validation_v_L2_limit_Re400 = 0.120;
cfg.validation_u_L2_limit_Re1000 = 0.160;
cfg.validation_v_L2_limit_Re1000 = 0.180;

% Output
cfg.make_figures = true;
cfg.figure_every_case = true;
cfg.results_dir = "results";
cfg.data_dir = fullfile("results","data");
cfg.fig_dir = fullfile("results","figures");
end
