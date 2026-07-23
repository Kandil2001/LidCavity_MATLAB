function write_case_outputs(result,metrics,quality,cfg,case_name)
%WRITE_CASE_OUTPUTS Save standardized MAT and CSV files for one case.

if ~exist(cfg.data_dir,'dir')
    mkdir(cfg.data_dir);
end

save(fullfile(cfg.data_dir,case_name + ".mat"), ...
    'result','metrics','quality','-v7.3');

iteration = (1:result.iterations)';
history = table(iteration, ...
    result.velocity_update_linf(:), ...
    result.divergence_linf(:), ...
    result.divergence_l2(:), ...
    result.global_mass_imbalance(:), ...
    result.dt(:), ...
    result.poisson_relative_residual(:), ...
    result.poisson_iters(:), ...
    result.poisson_converged(:), ...
    'VariableNames',{'Iteration','VelocityUpdateLinf', ...
    'DivergenceLinf','DivergenceL2','GlobalMassImbalance', ...
    'Dt','PoissonRelativeResidual','PoissonIterations', ...
    'PoissonConverged'});
writetable(history,fullfile(cfg.data_dir,case_name + "_history.csv"));

if cfg.save_fields
    [X,Y] = meshgrid(result.x,result.y);
    fields = table(X(:),Y(:),result.u(:),result.v(:),result.p(:), ...
        result.speed(:),result.vorticity(:), ...
        'VariableNames',{'x','y','u','v','p','speed','vorticity'});
    writetable(fields,fullfile(cfg.data_dir,case_name + "_fields.csv"));
end

u_centerline = interpolate_vertical_centerline(result.u,result.x);
v_centerline = interpolate_horizontal_centerline(result.v,result.y);
profiles = table(result.x(:),result.y(:),u_centerline(:),v_centerline(:), ...
    'VariableNames',{'x','y','u_at_x_0p5','v_at_y_0p5'});
writetable(profiles,fullfile(cfg.data_dir,case_name + "_centerlines.csv"));
end

function values = interpolate_vertical_centerline(field,x)
N = size(field,1);
values = zeros(N,1);
for i = 1:N
    values(i) = interp1(x,field(i,:),0.5,'linear','extrap');
end
end

function values = interpolate_horizontal_centerline(field,y)
N = size(field,2);
values = zeros(N,1);
for j = 1:N
    values(j) = interp1(y,field(:,j),0.5,'linear','extrap');
end
end
