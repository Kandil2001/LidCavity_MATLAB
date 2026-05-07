function metrics = validate_against_ghia(result,cfg)
%VALIDATE_AGAINST_GHIA Compares centerline profiles to Ghia data if available.

if nargin < 2
    cfg = default_config();
end

data = ghia_data(result.Re);

metrics.available = ~isempty(data);
metrics.u_L2 = NaN;
metrics.v_L2 = NaN;
metrics.u_Linf = NaN;
metrics.v_Linf = NaN;
metrics.pass = false;
metrics.u_limit = NaN;
metrics.v_limit = NaN;

if isempty(data)
    return;
end

N = result.N;
mid = round((N+1)/2);

% Numerical profiles. u at x=0.5 as function of y, v at y=0.5 as function of x.
u_center = result.u(:,mid);
v_center = result.v(mid,:);

% Interpolate numerical values onto Ghia sample points.
u_num = interp1(result.y, u_center, data.y_u, 'linear', 'extrap');
v_num = interp1(result.x, v_center, data.x_v, 'linear', 'extrap');

eu = u_num(:) - data.u(:);
ev = v_num(:) - data.v(:);

metrics.u_L2 = sqrt(mean(eu.^2));
metrics.v_L2 = sqrt(mean(ev.^2));
metrics.u_Linf = max(abs(eu));
metrics.v_Linf = max(abs(ev));

switch result.Re
    case 100
        metrics.u_limit = cfg.validation_u_L2_limit_Re100;
        metrics.v_limit = cfg.validation_v_L2_limit_Re100;
    case 400
        metrics.u_limit = cfg.validation_u_L2_limit_Re400;
        metrics.v_limit = cfg.validation_v_L2_limit_Re400;
    case 1000
        metrics.u_limit = cfg.validation_u_L2_limit_Re1000;
        metrics.v_limit = cfg.validation_v_L2_limit_Re1000;
    otherwise
        metrics.u_limit = inf;
        metrics.v_limit = inf;
end

metrics.pass = metrics.u_L2 <= metrics.u_limit && metrics.v_L2 <= metrics.v_limit;
end
