function [phi, info] = pressure_poisson(rhs,dx,dy,solver_type,cfg)
%PRESSURE_POISSON Solves Laplacian(phi)=rhs for pressure correction.
%
% Supported:
%   'JACOBI' : vectorized Jacobi
%   'RBGS'   : vectorized red-black Gauss-Seidel
%   'RBSOR'  : vectorized red-black SOR
%
% Major improvement over the previous version:
%   The solver now monitors the true Poisson residual:
%       r = Laplacian(phi) - rhs
%   not only max(abs(phi_new - phi_old)).
%
% Also:
%   - RHS compatibility is enforced by subtracting the interior mean.
%   - SOR omega can be selected automatically from the mesh size.
%   - Residual history is returned for diagnostics.

N = size(rhs,1);
phi = zeros(N,N);
solver_type = upper(string(solver_type));

C = 2:N-1;

% Neumann Poisson compatibility: integral(rhs) should be zero.
rhs2 = rhs;
interior_rhs = rhs2(C,C);
rhs2(C,C) = interior_rhs - mean(interior_rhs(:));

den = 2*(dx^2 + dy^2);

tol_abs = cfg.poisson_tol_abs;
tol_rel = cfg.poisson_tol_rel;
maxIter = cfg.poisson_maxIter;
check_every = cfg.poisson_check_every;

if ischar(cfg.sor_omega) || isstring(cfg.sor_omega)
    if lower(string(cfg.sor_omega)) == "auto"
        % Classical estimate for Poisson SOR. Clamped for robustness.
        omega = 2 / (1 + sin(pi/(N-1)));
        omega = min(max(omega, cfg.sor_omega_min), cfg.sor_omega_max);
    else
        omega = str2double(cfg.sor_omega);
    end
else
    omega = cfg.sor_omega;
end

[II,JJ] = ndgrid(C,C);
red = mod(II+JJ,2)==0;
black = ~red;

res_hist = zeros(maxIter,1);
change_hist = zeros(maxIter,1);

rhs_norm = max(1.0, max(abs(rhs2(C,C)), [], 'all'));

converged = false;
final_res = inf;
final_change = inf;

for it = 1:maxIter

    phi_old = phi;

    if solver_type == "JACOBI"

        phi_new = phi;
        phi_new(C,C) = ((phi(C+1,C)+phi(C-1,C))*dy^2 + ...
                        (phi(C,C+1)+phi(C,C-1))*dx^2 - ...
                        rhs2(C,C)*dx^2*dy^2) / den;
        phi = phi_new;
        phi = apply_pressure_bc(phi);

    elseif solver_type == "RBGS" || solver_type == "RBSOR"

        % ---------------- Red update ----------------
        candidate = ((phi(C+1,C)+phi(C-1,C))*dy^2 + ...
                     (phi(C,C+1)+phi(C,C-1))*dx^2 - ...
                     rhs2(C,C)*dx^2*dy^2) / den;

        block = phi(C,C);
        if solver_type == "RBSOR"
            block(red) = (1-omega)*block(red) + omega*candidate(red);
        else
            block(red) = candidate(red);
        end
        phi(C,C) = block;
        phi = apply_pressure_bc(phi);

        % ---------------- Black update ----------------
        candidate = ((phi(C+1,C)+phi(C-1,C))*dy^2 + ...
                     (phi(C,C+1)+phi(C,C-1))*dx^2 - ...
                     rhs2(C,C)*dx^2*dy^2) / den;

        block = phi(C,C);
        if solver_type == "RBSOR"
            block(black) = (1-omega)*block(black) + omega*candidate(black);
        else
            block(black) = candidate(black);
        end
        phi(C,C) = block;
        phi = apply_pressure_bc(phi);

    else
        error("Unknown pressure solver: %s", solver_type);
    end

    final_change = max(abs(phi(:)-phi_old(:)));
    change_hist(it) = final_change;

    if mod(it,check_every)==0 || it==1 || it==maxIter
        final_res = poisson_true_residual(phi,rhs2,dx,dy);
        rel_res = final_res / rhs_norm;
        res_hist(it) = rel_res;

        if final_res < tol_abs || rel_res < tol_rel
            converged = true;
            break;
        end
    end
end

% Ensure final residual is recorded even if last iteration was not check_every
if ~converged && (it < numel(res_hist)) && res_hist(it)==0
    final_res = poisson_true_residual(phi,rhs2,dx,dy);
    rel_res = final_res / rhs_norm;
    res_hist(it) = rel_res;
end

info.iter = it;
info.converged = converged;
info.final_true_residual = final_res;
info.final_relative_residual = final_res / rhs_norm;
info.final_change = final_change;
info.omega = omega;
info.residual_history = res_hist(1:it);
info.change_history = change_hist(1:it);
end


function res = poisson_true_residual(phi,rhs,dx,dy)
%POISSON_TRUE_RESIDUAL Infinity norm of Laplacian(phi)-rhs on interior.

N = size(phi,1);
C = 2:N-1;

lap = (phi(C,C+1)-2*phi(C,C)+phi(C,C-1))/dx^2 + ...
      (phi(C+1,C)-2*phi(C,C)+phi(C-1,C))/dy^2;

r = lap - rhs(C,C);
res = max(abs(r(:)));
end
