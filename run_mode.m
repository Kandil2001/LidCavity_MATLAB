function T = run_mode(mode)
%RUN_MODE Run one named Phase 2 MATLAB study.

if nargin < 1
    mode = 'single';
end
mode = lower(string(mode));

project_root = fileparts(mfilename('fullpath'));
original_folder = pwd;
cleanup = onCleanup(@() cd(original_folder)); %#ok<NASGU>
cd(project_root);

addpath('startup');
setup_project();
cfg = default_config();

% Keep the canonical run visual, while larger batch studies prioritize data.
if mode == "single"
    cfg.make_figures = true;
    cfg.figure_every_case = true;
else
    cfg.make_figures = true;
    cfg.figure_every_case = false;
end

T = run_parametric_study(cfg,mode);

disp(' ');
disp('Finished. Summary table:');
disp(T);
fprintf('Results saved in %s\n',cfg.data_dir);
end
