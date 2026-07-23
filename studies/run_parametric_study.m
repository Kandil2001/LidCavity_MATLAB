function T = run_parametric_study(cfg,mode)
%RUN_PARAMETRIC_STUDY Run a Phase 2 mode with continuation and strict checks.

if nargin < 2
    mode = 'full';
end
mode = lower(string(mode));
cases = study_definition(mode,cfg);
rows = cell(height(cases),29);
continuation = containers.Map('KeyType','char','ValueType','any');

fprintf('\nLID-DRIVEN CAVITY MATLAB PHASE 2 SOLVER\n');
fprintf('Mode: %s\n',mode);
fprintf('Total simulations: %d\n',height(cases));
fprintf('Summary: %s\n\n', ...
    fullfile(cfg.data_dir,"study_summary_" + mode + ".csv"));

for k = 1:height(cases)
    N = cases.N(k);
    Re = cases.Re(k);
    scheme = string(cases.Scheme(k));
    pressure_solver = string(cases.PressureSolver(k));
    implementation = string(cases.Implementation(k));

    continuation_key = sprintf('N%d_%s_%s_%s',N, ...
        char(scheme),char(pressure_solver),char(implementation));
    initial_state = struct('available',false);
    if cfg.use_continuation && isKey(continuation,continuation_key)
        initial_state = continuation(continuation_key);
    end

    case_name = sprintf('case_%03d_N%d_Re%d_%s_%s_%s', ...
        k,N,Re,char(scheme),char(pressure_solver),char(implementation));

    fprintf('[%03d] N=%d Re=%d Scheme=%s Pressure=%s Implementation=%s\n', ...
        k,N,Re,scheme,pressure_solver,implementation);

    result = solve_lid_cavity(N,Re,scheme,pressure_solver, ...
        implementation,cfg,initial_state);
    metrics = validate_against_ghia(result,cfg);
    quality = classify_quality(result,metrics);

    if strcmp(result.status,'converged')
        continuation(continuation_key) = result.continuation_state;
    elseif isKey(continuation,continuation_key)
        remove(continuation,continuation_key);
    end

    fprintf(['      status=%s quality=%s iter=%d/%d vel=%.6e ' ...
        'div=%.6e runtime=%.2fs\n'], ...
        result.status,quality,result.iterations,result.localMaxIter, ...
        result.final_velocity_linf,result.final_divergence_linf, ...
        result.runtime);
    if metrics.available
        fprintf('      Ghia L2: u=%.3e v=%.3e pass=%d\n', ...
            metrics.u_L2,metrics.v_L2,metrics.pass);
    end

    write_case_outputs(result,metrics,quality,cfg,case_name);

    if cfg.make_figures && cfg.figure_every_case
        plot_residuals(result,cfg,case_name);
        plot_fields(result,cfg,case_name);
        plot_validation(result,cfg,case_name);
    end

    rows(k,:) = { ...
        k,N,Re,scheme,pressure_solver,implementation, ...
        string(result.status),string(quality),result.iterations, ...
        result.localMaxIter,result.consecutive_pass_count, ...
        result.failed_pressure_solves,result.final_velocity_linf, ...
        result.final_divergence_linf,result.final_divergence_l2, ...
        result.final_global_mass,result.final_poisson_relative_residual, ...
        result.runtime,result.avg_poisson_iters, ...
        result.avg_poisson_relative_residual, ...
        result.pressure_saturation_ratio,metrics.available,metrics.pass, ...
        metrics.u_L2,metrics.v_L2,metrics.u_Linf,metrics.v_Linf, ...
        metrics.u_limit,metrics.v_limit};
end

T = cell2table(rows,'VariableNames',{ ...
    'CaseID','N','Re','Scheme','PressureSolver','Implementation', ...
    'Status','Quality','Iterations','LocalMaxIter', ...
    'ConsecutivePassCount','FailedPressureSolves', ...
    'FinalVelocityLinf','FinalDivergenceLinf','FinalDivergenceL2', ...
    'FinalGlobalMass','FinalPoissonRelativeResidual','Runtime_s', ...
    'AvgPoissonIterations','AvgPoissonRelResidual', ...
    'PressureSaturationRatio','HasGhia','ValidationPass', ...
    'Ghia_u_L2','Ghia_v_L2','Ghia_u_Linf','Ghia_v_Linf', ...
    'Ghia_u_L2_Limit','Ghia_v_L2_Limit'});

summary_path = fullfile(cfg.data_dir,"study_summary_" + mode + ".csv");
writetable(T,summary_path);
save(fullfile(cfg.data_dir,"study_summary_" + mode + ".mat"),'T');

if cfg.make_figures
    plot_study_summary(T,cfg);
end

if cfg.strict && any(T.Status ~= "converged")
    failed = T(T.Status ~= "converged", ...
        {'CaseID','N','Re','Scheme','PressureSolver','Implementation','Status'});
    disp(failed);
    error('Phase 2 strict mode: %d case(s) did not converge.',height(failed));
end
end

function quality = classify_quality(result,metrics)
if strcmp(result.status,'converged') && metrics.available && metrics.pass
    quality = "converged_benchmark_pass";
elseif strcmp(result.status,'converged') && metrics.available
    quality = "converged_benchmark_fail";
elseif strcmp(result.status,'converged')
    quality = "converged_no_benchmark";
elseif metrics.available && metrics.pass
    quality = "benchmark_pass_not_converged";
else
    quality = "needs_improvement";
end
end
