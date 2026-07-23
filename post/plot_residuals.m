function plot_residuals(result,cfg,case_name)
%PLOT_RESIDUALS Save Phase 2 convergence and pressure histories.

figure('Visible','off');
semilogy(result.velocity_update_linf,'LineWidth',1.5); hold on;
semilogy(result.divergence_linf,'LineWidth',1.3);
semilogy(result.divergence_l2,'LineWidth',1.3);
semilogy(max(result.global_mass_imbalance,eps),'--','LineWidth',1.0);
hold off; grid on;
xlabel('Outer iteration');
ylabel('Dimensionless residual');
legend('Velocity update L_\infty','Divergence L_\infty', ...
    'Divergence L_2','Global mass imbalance','Location','best');
title(sprintf('Convergence: N=%d Re=%d %s %s %s', ...
    result.N,result.Re,result.scheme,result.pressure_solver, ...
    result.implementation),'Interpreter','none');
save_current_figure(fullfile(cfg.fig_dir,case_name + "_residuals"));
close;

figure('Visible','off');
semilogy(result.poisson_relative_residual,'LineWidth',1.5);
grid on;
xlabel('Outer iteration');
ylabel('Pressure Poisson relative residual');
title('Pressure-correction convergence');
save_current_figure(fullfile(cfg.fig_dir,case_name + "_pressure_poisson_residual"));
close;
end
