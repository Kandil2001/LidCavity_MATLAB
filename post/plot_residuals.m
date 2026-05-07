function plot_residuals(result,cfg,case_name)
%PLOT_RESIDUALS Saves residual history.

figure('Visible','off');
semilogy(result.Ru,'LineWidth',1.5); hold on;
semilogy(result.Rv,'LineWidth',1.5);
semilogy(result.Rc_mass,'LineWidth',1.5);
if isfield(result,'Rc_div')
    semilogy(result.Rc_div,'--','LineWidth',1.0);
end
grid on;
xlabel('Outer iteration');
ylabel('Residual');
if isfield(result,'Rc_div')
    legend('R_u','R_v','R_c mass','R_c raw div','Location','best');
else
    legend('R_u','R_v','R_c','Location','best');
end
title(sprintf('Residuals: N=%d Re=%d %s %s %s', ...
    result.N,result.Re,result.scheme,result.pressure_solver,result.implementation), ...
    'Interpreter','none');

save_current_figure(fullfile(cfg.fig_dir, case_name + "_residuals"));
close;

if isfield(result,'poisson_relative_residual')
    figure('Visible','off');
    semilogy(result.poisson_relative_residual,'LineWidth',1.5);
    grid on;
    xlabel('Outer iteration');
    ylabel('Pressure Poisson relative residual');
    title('Pressure correction residual');
    save_current_figure(fullfile(cfg.fig_dir, case_name + "_pressure_poisson_residual"));
    close;
end
end
