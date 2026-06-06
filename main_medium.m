% MAIN_MEDIUM Run the MATLAB study without the N = 128 mesh.
% 48 simulations: [32,64] x [100,400,1000] x 2 schemes x 2 pressure solvers x 2 implementations.

clear; clc; close all;
addpath("startup");
setup_project();

cfg = default_config();
cfg.meshes = [32, 64];
cfg.re_list = [100, 400, 1000];
cfg.maxIter = 3500;
cfg.maxIter_N128_bonus = 0;
cfg.poisson_maxIter = 1800;

fprintf("\nMEDIUM STUDY SELECTED\n");

nCases = numel(cfg.meshes) * numel(cfg.re_list) * numel(cfg.schemes) * ...
         numel(cfg.pressure_solvers) * numel(cfg.implementations);

fprintf("Total simulations: %d\n", nCases);
fprintf("Base max outer iterations per simulation: %d\n\n", cfg.maxIter);

T = run_parametric_study(cfg);
disp(T);
writetable(T, fullfile("results", "data", "study_summary_medium.csv"));
plot_study_summary(T, cfg);
