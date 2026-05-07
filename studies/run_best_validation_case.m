function result = run_best_validation_case()
%RUN_BEST_VALIDATION_CASE Recommended single case to verify the solver.

addpath("core");
addpath("validation");
addpath("post");

cfg = default_config();
cfg.meshes = 64;
cfg.re_list = 100;
cfg.schemes = {'central'};
cfg.pressure_solvers = {'RBGS'};
cfg.implementations = {'vectorized'};
cfg.figure_every_case = true;

result = solve_lid_cavity(64,100,'central','RBGS','vectorized',cfg);
metrics = validate_against_ghia(result,cfg);

case_name = "best_validation_N64_Re100_central_RBGS_vectorized";
plot_residuals(result,cfg,case_name);
plot_fields(result,cfg,case_name);
plot_validation(result,cfg,case_name);

disp(result);
disp(metrics);
end
