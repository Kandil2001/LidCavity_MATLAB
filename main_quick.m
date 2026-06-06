% MAIN_QUICK Run a reduced MATLAB study for a fast solver check.

clear; clc; close all;
addpath("startup");
setup_project();

cfg = default_config();
cfg.meshes = [32, 64];
cfg.re_list = [100, 400];
cfg.maxIter = 2000;
cfg.maxIter_N128_bonus = 0;
cfg.maxIter_Re1000_bonus = 0;
cfg.maxIter_central_bonus = 500;
cfg.poisson_maxIter = 1200;

fprintf("\nQUICK STUDY SELECTED\n");

nCases = numel(cfg.meshes) * numel(cfg.re_list) * numel(cfg.schemes) * ...
         numel(cfg.pressure_solvers) * numel(cfg.implementations);

fprintf("Total simulations: %d\n", nCases);
fprintf("Base max outer iterations per simulation: %d\n\n", cfg.maxIter);

T = run_parametric_study(cfg);
disp(T);
writetable(T, fullfile("results", "data", "study_summary_quick.csv"));
plot_study_summary(T, cfg);
