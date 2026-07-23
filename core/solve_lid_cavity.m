function result = solve_lid_cavity(N,Re,scheme,pressure_solver,implementation,cfg,initial_state)
%SOLVE_LID_CAVITY Phase 2 staggered-grid projection solver.
%
% Pressure is stored at cell centers, horizontal velocity on vertical faces,
% and vertical velocity on horizontal faces. The optional initial_state is
% used for Reynolds-number continuation in parameter studies.

if nargin < 7
    initial_state = struct();
end

scheme = lower(string(scheme));
pressure_solver = upper(string(pressure_solver));
implementation = lower(string(implementation));

if scheme ~= "upwind" && scheme ~= "central"
    error('Unknown convection scheme: %s',scheme);
end
if pressure_solver ~= "RBGS" && pressure_solver ~= "RBSOR"
    error('Unknown pressure solver: %s',pressure_solver);
end
if implementation ~= "vectorized" && implementation ~= "loop"
    error('Unknown MATLAB implementation: %s',implementation);
end

h = cfg.L/N;
nu = cfg.U_lid*cfg.L/Re;
maxIter = cfg.maxIter;

[u_face,v_face,p] = initialize_state(N,initial_state);
[u_face,v_face] = apply_normal_velocity_bc(u_face,v_face);

velocity_hist = nan(maxIter,1);
div_linf_hist = nan(maxIter,1);
div_l2_hist = nan(maxIter,1);
mass_hist = nan(maxIter,1);
dt_hist = nan(maxIter,1);
poisson_rel_hist = nan(maxIter,1);
poisson_iter_hist = nan(maxIter,1);
poisson_conv_hist = false(maxIter,1);

status = "max_iterations";
consecutive_pass_count = 0;
failed_pressure_solves = 0;

start_time = tic;

for iter = 1:maxIter
    u_old = u_face;
    v_old = v_face;

    dt = compute_time_step(u_face,v_face,h,nu,cfg);

    if implementation == "vectorized"
        [u_star,v_star] = predict_velocity_vectorized( ...
            u_face,v_face,p,h,nu,dt,scheme,cfg);
    else
        [u_star,v_star] = predict_velocity_loop( ...
            u_face,v_face,p,h,nu,dt,scheme,cfg);
    end

    [u_star,v_star] = apply_normal_velocity_bc(u_star,v_star);
    div_star = discrete_divergence(u_star,v_star,h);
    rhs = div_star/dt;

    [p_prime,pinfo] = pressure_poisson_phase2( ...
        rhs,h,pressure_solver,cfg);

    u_face = u_star;
    v_face = v_star;
    u_face(:,2:N) = u_star(:,2:N) ...
        - dt*(p_prime(:,2:N)-p_prime(:,1:N-1))/h;
    v_face(2:N,:) = v_star(2:N,:) ...
        - dt*(p_prime(2:N,:)-p_prime(1:N-1,:))/h;
    [u_face,v_face] = apply_normal_velocity_bc(u_face,v_face);

    p = p + cfg.alpha_p*p_prime;
    p = p - mean(p(:));

    residuals = calculate_residuals( ...
        u_face,v_face,u_old,v_old,h,cfg);

    velocity_hist(iter) = residuals.velocity_linf;
    div_linf_hist(iter) = residuals.divergence_linf;
    div_l2_hist(iter) = residuals.divergence_l2;
    mass_hist(iter) = residuals.global_mass;
    dt_hist(iter) = dt;
    poisson_rel_hist(iter) = pinfo.relative_residual;
    poisson_iter_hist(iter) = pinfo.iterations;
    poisson_conv_hist(iter) = pinfo.converged;

    if ~pinfo.converged
        failed_pressure_solves = failed_pressure_solves + 1;
    else
        failed_pressure_solves = 0;
    end

    if cfg.progress_every > 0 && mod(iter,cfg.progress_every) == 0
        fprintf('      iter=%d vel=%.6e div=%.6e p=%.6e\n', ...
            iter,residuals.velocity_linf,residuals.divergence_linf, ...
            pinfo.relative_residual);
    end

    if any(~isfinite(u_face(:))) || any(~isfinite(v_face(:))) ...
            || any(~isfinite(p(:)))
        status = "non_finite";
        break;
    end

    if max([residuals.velocity_linf,residuals.divergence_linf, ...
            residuals.divergence_l2,pinfo.relative_residual]) ...
            > cfg.diverged_limit
        status = "diverged";
        break;
    end

    if failed_pressure_solves > cfg.maximum_pressure_failures
        status = "pressure_not_converged";
        break;
    end

    all_pass = pinfo.converged ...
        && residuals.velocity_linf <= cfg.tol_velocity_linf ...
        && residuals.divergence_linf <= cfg.tol_divergence_linf ...
        && residuals.divergence_l2 <= cfg.tol_divergence_l2 ...
        && residuals.global_mass <= cfg.tol_global_mass;

    if iter >= cfg.minimum_iterations && all_pass
        consecutive_pass_count = consecutive_pass_count + 1;
    else
        consecutive_pass_count = 0;
    end

    if consecutive_pass_count >= cfg.consecutive_passes
        status = "converged";
        break;
    end

    if iter >= cfg.stagnation_window
        old_index = iter-cfg.stagnation_window+1;
        old_value = velocity_hist(old_index);
        if isfinite(old_value) && old_value > 0
            reduction = (old_value-residuals.velocity_linf)/old_value;
            if reduction < cfg.stagnation_minimum_reduction ...
                    && residuals.velocity_linf > 10*cfg.tol_velocity_linf
                status = "stagnated";
                break;
            end
        end
    end
end

runtime = toc(start_time);
last = iter;

velocity_hist = velocity_hist(1:last);
div_linf_hist = div_linf_hist(1:last);
div_l2_hist = div_l2_hist(1:last);
mass_hist = mass_hist(1:last);
dt_hist = dt_hist(1:last);
poisson_rel_hist = poisson_rel_hist(1:last);
poisson_iter_hist = poisson_iter_hist(1:last);
poisson_conv_hist = poisson_conv_hist(1:last);

[u_center,v_center,x,y] = face_to_cell_center(u_face,v_face,cfg.L);
speed = hypot(u_center,v_center);
vorticity = centered_vorticity(u_center,v_center,h);

result.N = N;
result.Re = Re;
result.scheme = char(scheme);
result.pressure_solver = char(pressure_solver);
result.implementation = char(implementation);
result.grid_type = 'staggered_MAC';

result.x = x;
result.y = y;
result.u = u_center;
result.v = v_center;
result.p = p;
result.speed = speed;
result.vorticity = vorticity;
result.u_face = u_face;
result.v_face = v_face;

% Backward-compatible fields used by the existing plotting functions.
result.Ru = velocity_hist;
result.Rv = velocity_hist;
result.Rc = mass_hist;
result.Rc_mass = mass_hist;
result.Rc_div = div_linf_hist;

result.velocity_update_linf = velocity_hist;
result.divergence_linf = div_linf_hist;
result.divergence_l2 = div_l2_hist;
result.global_mass_imbalance = mass_hist;
result.dt = dt_hist;
result.poisson_relative_residual = poisson_rel_hist;
result.poisson_iters = poisson_iter_hist;
result.poisson_converged = poisson_conv_hist;

result.iterations = last;
result.localMaxIter = maxIter;
result.runtime = runtime;
result.status = char(status);
result.consecutive_pass_count = consecutive_pass_count;
result.failed_pressure_solves = failed_pressure_solves;

result.final_Ru = velocity_hist(end);
result.final_Rv = velocity_hist(end);
result.final_Rc = mass_hist(end);
result.final_Rc_mass = mass_hist(end);
result.final_Rc_div = div_linf_hist(end);
result.final_velocity_linf = velocity_hist(end);
result.final_divergence_linf = div_linf_hist(end);
result.final_divergence_l2 = div_l2_hist(end);
result.final_global_mass = mass_hist(end);
result.final_poisson_relative_residual = poisson_rel_hist(end);
result.avg_poisson_iters = mean(poisson_iter_hist);
result.avg_poisson_relative_residual = mean(poisson_rel_hist);
result.pressure_saturation_ratio = mean(poisson_iter_hist >= cfg.poisson_maxIter);

result.continuation_state.available = strcmp(result.status,'converged');
result.continuation_state.u_face = u_face;
result.continuation_state.v_face = v_face;
result.continuation_state.p = p;
end

function [u,v,p] = initialize_state(N,initial_state)
u = zeros(N,N+1);
v = zeros(N+1,N);
p = zeros(N,N);

if ~isstruct(initial_state) || ~isfield(initial_state,'available') ...
        || ~initial_state.available
    return;
end

if isfield(initial_state,'u_face') && isequal(size(initial_state.u_face),size(u))
    u = initial_state.u_face;
end
if isfield(initial_state,'v_face') && isequal(size(initial_state.v_face),size(v))
    v = initial_state.v_face;
end
if isfield(initial_state,'p') && isequal(size(initial_state.p),size(p))
    p = initial_state.p;
    p = p-mean(p(:));
end
end

function [u,v] = apply_normal_velocity_bc(u,v)
u(:,1) = 0;
u(:,end) = 0;
v(1,:) = 0;
v(end,:) = 0;
end

function dt = compute_time_step(u,v,h,nu,cfg)
max_velocity = max([max(abs(u(:))),max(abs(v(:))),cfg.U_lid,1e-12]);
convection_limit = cfg.cfl*h/max_velocity;
diffusion_limit = 0.24*h*h/max(nu,1e-30);
dt = min([convection_limit,diffusion_limit,cfg.dt_max]);
dt = max(cfg.dt_min,min(cfg.dt_max,dt));
end

function [u_star,v_star] = predict_velocity_vectorized( ...
    u,v,p,h,nu,dt,scheme,cfg)
N = size(p,1);
u_star = u;
v_star = v;

% u momentum on vertical faces j=2:N.
u_ext = zeros(N+2,N+1);
u_ext(2:N+1,:) = u;
u_ext(1,:) = -u(1,:);
u_ext(N+2,:) = 2*cfg.U_lid-u(N,:);

uC = u(:,2:N);
uW = u(:,1:N-1);
uE = u(:,3:N+1);
uS = u_ext(1:N,2:N);
uN = u_ext(3:N+2,2:N);
vAtU = 0.25*(v(1:N,1:N-1)+v(2:N+1,1:N-1) ...
    +v(1:N,2:N)+v(2:N+1,2:N));

if scheme == "central"
    du_dx = (uE-uW)/(2*h);
    du_dy = (uN-uS)/(2*h);
else
    du_dx = upwind_derivative(uC,uW,uE,uC,h);
    du_dy = upwind_derivative(uC,uS,uN,vAtU,h);
end

lap_u = (uE-2*uC+uW+uN-2*uC+uS)/(h*h);
dp_dx = (p(:,2:N)-p(:,1:N-1))/h;
u_pred = uC+cfg.alpha_u*dt*( ...
    -uC.*du_dx-vAtU.*du_dy-dp_dx+nu*lap_u);
u_star(:,2:N) = u_pred;

% v momentum on horizontal faces i=2:N.
v_ext = zeros(N+1,N+2);
v_ext(:,2:N+1) = v;
v_ext(:,1) = -v(:,1);
v_ext(:,N+2) = -v(:,N);

vC = v(2:N,:);
vS = v(1:N-1,:);
vN = v(3:N+1,:);
vW = v_ext(2:N,1:N);
vE = v_ext(2:N,3:N+2);
uAtV = 0.25*(u(1:N-1,1:N)+u(1:N-1,2:N+1) ...
    +u(2:N,1:N)+u(2:N,2:N+1));

if scheme == "central"
    dv_dx = (vE-vW)/(2*h);
    dv_dy = (vN-vS)/(2*h);
else
    dv_dx = upwind_derivative(vC,vW,vE,uAtV,h);
    dv_dy = upwind_derivative(vC,vS,vN,vC,h);
end

lap_v = (vE-2*vC+vW+vN-2*vC+vS)/(h*h);
dp_dy = (p(2:N,:)-p(1:N-1,:))/h;
v_pred = vC+cfg.alpha_u*dt*( ...
    -uAtV.*dv_dx-vC.*dv_dy-dp_dy+nu*lap_v);
v_star(2:N,:) = v_pred;
end

function derivative = upwind_derivative(center,minus,plus,transport,h)
derivative = zeros(size(center));
pos = transport >= 0;
derivative(pos) = (center(pos)-minus(pos))/h;
derivative(~pos) = (plus(~pos)-center(~pos))/h;
end

function [u_star,v_star] = predict_velocity_loop( ...
    u,v,p,h,nu,dt,scheme,cfg)
N = size(p,1);
u_star = u;
v_star = v;

for i = 1:N
    for j = 2:N
        uc = u(i,j);
        vw = v(i,j-1);
        ve = v(i,j);
        vn_w = v(i+1,j-1);
        vn_e = v(i+1,j);
        v_at_u = 0.25*(vw+ve+vn_w+vn_e);

        u_w = u(i,j-1);
        u_e = u(i,j+1);
        if i == 1
            u_s = -u(i,j);
        else
            u_s = u(i-1,j);
        end
        if i == N
            u_n = 2*cfg.U_lid-u(i,j);
        else
            u_n = u(i+1,j);
        end

        if scheme == "central"
            du_dx = (u_e-u_w)/(2*h);
            du_dy = (u_n-u_s)/(2*h);
        else
            if uc >= 0
                du_dx = (uc-u_w)/h;
            else
                du_dx = (u_e-uc)/h;
            end
            if v_at_u >= 0
                du_dy = (uc-u_s)/h;
            else
                du_dy = (u_n-uc)/h;
            end
        end

        lap = (u_e-2*uc+u_w+u_n-2*uc+u_s)/(h*h);
        dpdx = (p(i,j)-p(i,j-1))/h;
        u_star(i,j) = uc+cfg.alpha_u*dt*( ...
            -uc*du_dx-v_at_u*du_dy-dpdx+nu*lap);
    end
end

for i = 2:N
    for j = 1:N
        vc = v(i,j);
        u_at_v = 0.25*(u(i-1,j)+u(i-1,j+1) ...
            +u(i,j)+u(i,j+1));

        v_s = v(i-1,j);
        v_n = v(i+1,j);
        if j == 1
            v_w = -v(i,j);
        else
            v_w = v(i,j-1);
        end
        if j == N
            v_e = -v(i,j);
        else
            v_e = v(i,j+1);
        end

        if scheme == "central"
            dv_dx = (v_e-v_w)/(2*h);
            dv_dy = (v_n-v_s)/(2*h);
        else
            if u_at_v >= 0
                dv_dx = (vc-v_w)/h;
            else
                dv_dx = (v_e-vc)/h;
            end
            if vc >= 0
                dv_dy = (vc-v_s)/h;
            else
                dv_dy = (v_n-vc)/h;
            end
        end

        lap = (v_e-2*vc+v_w+v_n-2*vc+v_s)/(h*h);
        dpdy = (p(i,j)-p(i-1,j))/h;
        v_star(i,j) = vc+cfg.alpha_u*dt*( ...
            -u_at_v*dv_dx-vc*dv_dy-dpdy+nu*lap);
    end
end
end

function div = discrete_divergence(u,v,h)
div = (u(:,2:end)-u(:,1:end-1))/h ...
    +(v(2:end,:)-v(1:end-1,:))/h;
end

function [pressure,info] = pressure_poisson_phase2(rhs,h,method,cfg)
N = size(rhs,1);
rhs = rhs-mean(rhs(:));
rhs_norm = max(max(abs(rhs(:))),1e-30);
pressure = zeros(N,N);

if method == "RBSOR"
    if isnumeric(cfg.sor_omega)
        omega = cfg.sor_omega;
    else
        omega = 2/(1+sin(pi/N));
        omega = min(cfg.sor_omega_max,max(cfg.sor_omega_min,omega));
    end
else
    omega = 1.0;
end

[row_index,col_index] = ndgrid(1:N,1:N);
red = mod(row_index+col_index,2) == 0;
black = ~red;

info.iterations = 0;
info.converged = false;
info.absolute_residual = inf;
info.relative_residual = inf;
info.omega = omega;

for k = 1:cfg.poisson_maxIter
    pressure = red_black_sweep(pressure,rhs,h,red,omega);
    pressure = red_black_sweep(pressure,rhs,h,black,omega);

    if mod(k,50) == 0
        pressure = pressure-mean(pressure(:));
    end

    if k == 1 || mod(k,cfg.poisson_check_every) == 0 ...
            || k == cfg.poisson_maxIter
        absolute_residual = poisson_residual_linf(pressure,rhs,h);
        relative_residual = absolute_residual/rhs_norm;
        info.iterations = k;
        info.absolute_residual = absolute_residual;
        info.relative_residual = relative_residual;

        if absolute_residual <= cfg.poisson_tol_abs ...
                || relative_residual <= cfg.poisson_tol_rel
            info.converged = true;
            pressure = pressure-mean(pressure(:));
            return;
        end
    end
end

pressure = pressure-mean(pressure(:));
end

function pressure = red_black_sweep(pressure,rhs,h,mask,omega)
[neighbor_sum,neighbor_count] = poisson_neighbors(pressure);
candidate = (neighbor_sum-rhs*h*h)./neighbor_count;
pressure(mask) = (1-omega)*pressure(mask)+omega*candidate(mask);
end

function [neighbor_sum,neighbor_count] = poisson_neighbors(pressure)
N = size(pressure,1);
neighbor_sum = zeros(N,N);
neighbor_count = zeros(N,N);

neighbor_sum(2:N,:) = neighbor_sum(2:N,:)+pressure(1:N-1,:);
neighbor_count(2:N,:) = neighbor_count(2:N,:)+1;
neighbor_sum(1:N-1,:) = neighbor_sum(1:N-1,:)+pressure(2:N,:);
neighbor_count(1:N-1,:) = neighbor_count(1:N-1,:)+1;
neighbor_sum(:,2:N) = neighbor_sum(:,2:N)+pressure(:,1:N-1);
neighbor_count(:,2:N) = neighbor_count(:,2:N)+1;
neighbor_sum(:,1:N-1) = neighbor_sum(:,1:N-1)+pressure(:,2:N);
neighbor_count(:,1:N-1) = neighbor_count(:,1:N-1)+1;
end

function value = poisson_residual_linf(pressure,rhs,h)
[neighbor_sum,neighbor_count] = poisson_neighbors(pressure);
laplacian = (neighbor_sum-neighbor_count.*pressure)/(h*h);
value = max(abs(laplacian(:)-rhs(:)));
end

function residuals = calculate_residuals(u,v,u_old,v_old,h,cfg)
velocity_change = max([max(abs(u(:)-u_old(:))), ...
    max(abs(v(:)-v_old(:)))])/cfg.U_lid;
div = discrete_divergence(u,v,h)/(cfg.U_lid/cfg.L);

residuals.velocity_linf = velocity_change;
residuals.divergence_linf = max(abs(div(:)));
residuals.divergence_l2 = sqrt(mean(div(:).^2));

boundary_flux = sum(u(:,end)-u(:,1))*h ...
    +sum(v(end,:)-v(1,:))*h;
residuals.global_mass = abs(boundary_flux)/(cfg.U_lid*cfg.L);
end

function [u_center,v_center,x,y] = face_to_cell_center(u,v,L)
N = size(u,1);
h = L/N;
u_center = 0.5*(u(:,1:N)+u(:,2:N+1));
v_center = 0.5*(v(1:N,:)+v(2:N+1,:));
x = ((1:N)-0.5)*h;
y = ((1:N)-0.5)*h;
end

function omega = centered_vorticity(u,v,h)
N = size(u,1);
omega = zeros(N,N);
if N > 2
    omega(2:N-1,2:N-1) = ...
        (v(2:N-1,3:N)-v(2:N-1,1:N-2))/(2*h) ...
        -(u(3:N,2:N-1)-u(1:N-2,2:N-1))/(2*h);
end
end
