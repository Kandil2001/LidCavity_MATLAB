function metrics = validate_against_ghia(result,cfg)
%VALIDATE_AGAINST_GHIA Compare interpolated centerlines with Ghia data.

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

u_num = interp1(result.y,u_centerline,data.y_u,'linear','extrap');
v_num = interp1(result.x,v_centerline,data.x_v,'linear','extrap');

eu = u_num(:)-data.u(:);
ev = v_num(:)-data.v(:);
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

metrics.pass = metrics.u_L2 <= metrics.u_limit ...
    && metrics.v_L2 <= metrics.v_limit;
end
