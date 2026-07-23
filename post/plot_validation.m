function plot_validation(result,cfg,case_name)
%PLOT_VALIDATION Centerline comparison against Ghia data when available.

data = ghia_data(result.Re);
if isempty(data)
    return;
end

u_centerline = zeros(numel(result.y),1);
for i = 1:numel(result.y)
    u_centerline(i) = interp1(result.x,result.u(i,:),0.5, ...
        'linear','extrap');
end

v_centerline = zeros(numel(result.x),1);
for j = 1:numel(result.x)
    v_centerline(j) = interp1(result.y,result.v(:,j),0.5, ...
        'linear','extrap');
end

figure('Visible','off');
plot(u_centerline,result.y,'LineWidth',1.5); hold on;
plot(data.u,data.y_u,'o','LineWidth',1.2);
grid on;
xlabel('u velocity at x=0.5');
ylabel('y');
legend('Solver','Ghia et al.','Location','best');
title(sprintf('Vertical centerline benchmark, Re=%d',result.Re));
save_current_figure(fullfile(cfg.fig_dir,case_name + "_ghia_u"));
close;

figure('Visible','off');
plot(result.x,v_centerline,'LineWidth',1.5); hold on;
plot(data.x_v,data.v,'o','LineWidth',1.2);
grid on;
xlabel('x');
ylabel('v velocity at y=0.5');
legend('Solver','Ghia et al.','Location','best');
title(sprintf('Horizontal centerline benchmark, Re=%d',result.Re));
save_current_figure(fullfile(cfg.fig_dir,case_name + "_ghia_v"));
close;
end
