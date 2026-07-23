function plot_study_summary(T,cfg)
%PLOT_STUDY_SUMMARY Generate compact Phase 2 study-level figures.

if isempty(T)
    return;
end

if ~exist(cfg.fig_dir,'dir')
    mkdir(cfg.fig_dir);
end

% Runtime by implementation.
figure('Visible','off');
impl = unique(string(T.Implementation),'stable');
hold on;
for k = 1:numel(impl)
    mask = string(T.Implementation) == impl(k);
    values = T.Runtime_s(mask);
    plot(k*ones(size(values)),values,'o','MarkerSize',6, ...
        'DisplayName',char(impl(k)));
    plot(k,mean(values),'x','MarkerSize',10,'LineWidth',2, ...
        'HandleVisibility','off');
end
hold off; grid on;
xlim([0.5,numel(impl)+0.5]);
set(gca,'XTick',1:numel(impl),'XTickLabel',cellstr(impl));
ylabel('Runtime [s]');
title('MATLAB implementation runtime');
save_current_figure(fullfile(cfg.fig_dir,'study_runtime_implementation'));
close;

% Pressure solver effort.
figure('Visible','off');
solvers = unique(string(T.PressureSolver),'stable');
hold on;
for k = 1:numel(solvers)
    mask = string(T.PressureSolver) == solvers(k);
    values = T.AvgPoissonIterations(mask);
    plot(k*ones(size(values)),values,'o','MarkerSize',6, ...
        'DisplayName',char(solvers(k)));
    plot(k,mean(values),'x','MarkerSize',10,'LineWidth',2, ...
        'HandleVisibility','off');
end
hold off; grid on;
xlim([0.5,numel(solvers)+0.5]);
set(gca,'XTick',1:numel(solvers),'XTickLabel',cellstr(solvers));
ylabel('Average pressure iterations');
title('Pressure solver comparison');
save_current_figure(fullfile(cfg.fig_dir,'study_pressure_solver_iterations'));
close;

% Final divergence and velocity-update diagnostics.
figure('Visible','off');
semilogy(T.CaseID,T.FinalVelocityLinf,'o-','LineWidth',1.2); hold on;
semilogy(T.CaseID,T.FinalDivergenceLinf,'s-','LineWidth',1.2);
semilogy(T.CaseID,T.FinalDivergenceL2,'^-','LineWidth',1.2);
hold off; grid on;
xlabel('Case ID');
ylabel('Final dimensionless residual');
legend('Velocity update L_\infty','Divergence L_\infty', ...
    'Divergence L_2','Location','best');
title('Final convergence metrics');
save_current_figure(fullfile(cfg.fig_dir,'study_final_residuals'));
close;

% Ghia error vs mesh.
valid = ~isnan(T.Ghia_u_L2);
if any(valid)
    figure('Visible','off'); hold on;
    schemes = unique(string(T.Scheme(valid)),'stable');
    for k = 1:numel(schemes)
        mask = valid & string(T.Scheme) == schemes(k);
        plot(T.N(mask),T.Ghia_u_L2(mask),'o-','LineWidth',1.5, ...
            'MarkerSize',6,'DisplayName',char(schemes(k)));
    end
    hold off; grid on;
    xlabel('Mesh cells per direction, N');
    ylabel('L2 error in u centerline');
    legend('Location','best');
    title('Ghia centerline error');
    save_current_figure(fullfile(cfg.fig_dir,'study_ghia_error'));
    close;
end

% Quality summary.
figure('Visible','off');
qualities = unique(string(T.Quality),'stable');
counts = zeros(size(qualities));
for k = 1:numel(qualities)
    counts(k) = sum(string(T.Quality) == qualities(k));
end
bar(counts); grid on;
set(gca,'XTick',1:numel(qualities),'XTickLabel',cellstr(qualities));
xtickangle(30);
ylabel('Number of cases');
title('Case quality classification');
save_current_figure(fullfile(cfg.fig_dir,'study_quality_summary'));
close;
end
