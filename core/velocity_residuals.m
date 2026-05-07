function [Ru,Rv,Rc_mass,Rc_div] = velocity_residuals(u,v,u_old,v_old,dx,dy,U,L)
%VELOCITY_RESIDUALS Velocity change + continuity residuals.
%
% Rc_div:
%   raw divergence infinity norm, max(|du/dx + dv/dy|)
%
% Rc_mass:
%   finite-volume-style normalized cell mass imbalance.
%   This is a better convergence residual than raw divergence because
%   raw divergence scales with grid spacing.
%
%   Rc_mass = max(|div|) * dx * dy / (U*L)

if nargin < 7
    U = 1.0;
end
if nargin < 8
    L = 1.0;
end

Ru = max(abs(u(:) - u_old(:)));
Rv = max(abs(v(:) - v_old(:)));

div = divergence_field(u,v,dx,dy);
Rc_div = max(abs(div(:)));

scale = max(U*L, eps);
Rc_mass = Rc_div * dx * dy / scale;
end
