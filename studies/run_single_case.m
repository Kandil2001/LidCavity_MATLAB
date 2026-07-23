function result = run_single_case()
%RUN_SINGLE_CASE Run the canonical Phase 2 case interactively.

project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(project_root,'startup'));
setup_project();

cfg = default_config();
cfg.make_figures = true;
cfg.figure_every_case = true;

result = solve_lid_cavity(32,100,'upwind','RBSOR','vectorized',cfg);
metrics = validate_against_ghia(result,cfg);

if strcmp(result.status,'converged') && metrics.available && metrics.pass
    quality = "converged_benchmark_pass";
elseif strcmp(result.status,'converged')
    quality = "converged_benchmark_fail";
else
    quality = "needs_improvement";
end

case_name = "single_N32_Re100_upwind_RBSOR_vectorized";
write_case_outputs(result,metrics,quality,cfg,case_name);
plot_residuals(result,cfg,case_name);
plot_fields(result,cfg,case_name);
plot_validation(result,cfg,case_name);

disp(result);
disp(metrics);

if cfg.strict && ~strcmp(result.status,'converged')
    error('Canonical Phase 2 case did not converge: %s',result.status);
end
end
