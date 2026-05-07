function plot_study_summary(T,cfg)
%PLOT_STUDY_SUMMARY Generates study-level plots from the summary table.
%
% Uses base MATLAB only. No Statistics Toolbox functions.

if isempty(T)
    return;
end

% Runtime comparison: loop vs vectorized
figure('Visible','off');
impl = unique(string(T.Implementation), 'stable');
hold on;
for k = 1:numel(impl)
    mask = string(T.Implementation) == impl(k);
    values = T.Runtime_s(mask);
    x = k * ones(size(values));
    plot(x, values, 'o', 'MarkerSize', 6, 'DisplayName', char(impl(k)));
    plot(k, mean(values), 'x', 'MarkerSize', 10, 'LineWidth', 2, 'HandleVisibility','off');
end
hold off;
grid on;
xlim([0.5, numel(impl)+0.5]);
set(gca, 'XTick', 1:numel(impl), 'XTickLabel', cellstr(impl));
ylabel('Runtime [s]');
title('Runtime: loop vs vectorized');
save_current_figure(fullfile(cfg.fig_dir, "study_runtime_implementation"));
close;

% Pressure solver iterations
figure('Visible','off');
ps = unique(string(T.PressureSolver), 'stable');
hold on;
for k = 1:numel(ps)
    mask = string(T.PressureSolver) == ps(k);
    values = T.AvgPoissonIterations(mask);
    x = k * ones(size(values));
    plot(x, values, 'o', 'MarkerSize', 6, 'DisplayName', char(ps(k)));
    plot(k, mean(values), 'x', 'MarkerSize', 10, 'LineWidth', 2, 'HandleVisibility','off');
end
hold off;
grid on;
xlim([0.5, numel(ps)+0.5]);
set(gca, 'XTick', 1:numel(ps), 'XTickLabel', cellstr(ps));
ylabel('Average pressure iterations');
title('Pressure solver comparison');
save_current_figure(fullfile(cfg.fig_dir, "study_pressure_solver_iterations"));
close;

% Continuity mass residual by case
if any(strcmp(T.Properties.VariableNames,'FinalRcMass'))
    figure('Visible','off');
    semilogy(T.CaseID, T.FinalRcMass, 'o-','LineWidth',1.2);
    grid on;
    xlabel('Case ID');
    ylabel('Final normalized mass residual');
    title('Final continuity residual by case');
    save_current_figure(fullfile(cfg.fig_dir, "study_final_mass_residual"));
    close;
end

% Validation error vs mesh
valid = ~isnan(T.Ghia_u_L2);
if any(valid)
    figure('Visible','off');
    hold on;

    schemes = unique(string(T.Scheme(valid)), 'stable');
    for k = 1:numel(schemes)
        mask = valid & string(T.Scheme)==schemes(k);
        plot(T.N(mask), T.Ghia_u_L2(mask), 'o-', ...
            'LineWidth', 1.5, ...
            'MarkerSize', 6, ...
            'DisplayName', char(schemes(k)));
    end

    hold off;
    grid on;
    xlabel('Mesh size N');
    ylabel('L2 error in u centerline');
    legend('Location','best');
    title('Mesh / scheme validation error vs Ghia');
    save_current_figure(fullfile(cfg.fig_dir, "study_ghia_error"));
    close;
end

% Quality summary
if any(strcmp(T.Properties.VariableNames,'Quality'))
    figure('Visible','off');
    qualities = unique(string(T.Quality), 'stable');
    counts = zeros(size(qualities));
    for k = 1:numel(qualities)
        counts(k) = sum(string(T.Quality)==qualities(k));
    end
    bar(counts);
    grid on;
    set(gca,'XTick',1:numel(qualities),'XTickLabel',cellstr(qualities));
    xtickangle(30);
    ylabel('Number of cases');
    title('Case quality classification');
    save_current_figure(fullfile(cfg.fig_dir, "study_quality_summary"));
    close;
end
end
