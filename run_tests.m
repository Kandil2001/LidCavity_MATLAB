function run_tests()
%RUN_TESTS Execute the MATLAB Phase 2 regression suite.
project_root = fileparts(mfilename('fullpath'));
addpath(fullfile(project_root,'startup'));
setup_project();
addpath(fullfile(project_root,'tests'));
test_phase2_regression();
end
