function cases = study_definition(mode,cfg)
%STUDY_DEFINITION Return the ordered Phase 2 case matrix for one run mode.

mode = lower(string(mode));
rows = {};

switch mode
    case "single"
        rows = add_cases(rows,32,100,{'upwind'},{'RBSOR'},{'vectorized'});

    case "quick"
        % Compare MATLAB implementations on the canonical case.
        rows = add_cases(rows,32,100,{'upwind'},{'RBSOR'}, ...
            {'vectorized','loop'});

    case "medium"
        % Same six production cases used by the C++ Phase 2 verification.
        rows = add_cases(rows,32,[100,400,1000], ...
            {'upwind','central'},{'RBSOR'},{'vectorized'});

    case "grid"
        rows = add_cases(rows,[16,32,64],100, ...
            {'central'},{'RBSOR'},{'vectorized'});

    case "re1000"
        rows = add_cases(rows,64,1000, ...
            {'central'},{'RBSOR'},{'vectorized'});

    case "full"
        % Complete MATLAB study, including loop/vectorized comparison.
        rows = add_cases(rows,cfg.meshes,cfg.re_list,cfg.schemes, ...
            cfg.pressure_solvers,cfg.implementations);

    otherwise
        error('Unknown study mode: %s',mode);
end

case_ids = num2cell((1:size(rows,1))');
rows = [case_ids,rows];
cases = cell2table(rows,'VariableNames', ...
    {'CaseID','N','Re','Scheme','PressureSolver','Implementation'});
end

function rows = add_cases(rows,meshes,reynolds,schemes,solvers,implementations)
% Order Reynolds number inside a fixed numerical configuration so that
% continuation can reuse the lower-Re solution.
for iN = 1:numel(meshes)
    for iS = 1:numel(schemes)
        for iP = 1:numel(solvers)
            for iI = 1:numel(implementations)
                for iR = 1:numel(reynolds)
                    rows(end+1,:) = { ...
                        meshes(iN), ...
                        reynolds(iR), ...
                        string(schemes{iS}), ...
                        string(solvers{iP}), ...
                        string(implementations{iI})}; %#ok<AGROW>
                end
            end
        end
    end
end
end
