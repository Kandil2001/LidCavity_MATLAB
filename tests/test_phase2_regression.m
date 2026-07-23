function test_phase2_regression()
%TEST_PHASE2_REGRESSION Run the canonical strict-convergence regression.

project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(project_root,'startup'));
setup_project();

cfg = default_config();
cfg.make_figures = false;
cfg.figure_every_case = false;
cfg.save_fields = false;
cfg.strict = true;

result = solve_lid_cavity(32,100,'upwind','RBSOR','vectorized',cfg);
metrics = validate_against_ghia(result,cfg);

assert(strcmp(result.status,'converged'), ...
    'Canonical case did not converge: %s',result.status);
assert(result.final_velocity_linf <= cfg.tol_velocity_linf, ...
    'Velocity-update tolerance failed.');
assert(result.final_divergence_linf <= cfg.tol_divergence_linf, ...
    'Divergence Linf tolerance failed.');
assert(result.final_divergence_l2 <= cfg.tol_divergence_l2, ...
    'Divergence L2 tolerance failed.');
assert(result.final_global_mass <= cfg.tol_global_mass, ...
    'Global mass tolerance failed.');
assert(metrics.available && metrics.pass, ...
    'Canonical Ghia benchmark comparison failed.');

fprintf(['PASS: canonical Phase 2 case converged in %d iterations, ' ...
    'u_L2=%.3e, v_L2=%.3e\n'], ...
    result.iterations,metrics.u_L2,metrics.v_L2);
end
