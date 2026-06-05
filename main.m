% MAIN Run the full 72-case parameter study.

clear; clc; close all;
setup_project();

cfg = default_config();

fprintf("\nFULL STUDY SELECTED\n");
fprintf("Meshes: %s\n", mat2str(cfg.meshes));
fprintf("Reynolds numbers: %s\n", mat2str(cfg.re_list));
fprintf("Schemes: %s\n", strjoin(string(cfg.schemes), ", "));
fprintf("Pressure solvers: %s\n", strjoin(string(cfg.pressure_solvers), ", "));
fprintf("Implementations: %s\n", strjoin(string(cfg.implementations), ", "));

nCases = numel(cfg.meshes) * numel(cfg.re_list) * numel(cfg.schemes) * ...
         numel(cfg.pressure_solvers) * numel(cfg.implementations);

fprintf("Total simulations: %d\n", nCases);
fprintf("Base max outer iterations per simulation: %d\n", cfg.maxIter);
fprintf("N=128 bonus iterations: %d\n", cfg.maxIter_N128_bonus);
fprintf("Re=1000 bonus iterations: %d\n", cfg.maxIter_Re1000_bonus);
fprintf("Central scheme bonus iterations: %d\n", cfg.maxIter_central_bonus);
fprintf("Max pressure iterations per outer iteration: %d\n\n", cfg.poisson_maxIter);

T = run_parametric_study(cfg);

disp(" ");
disp("Finished. Summary table:");
disp(T);

writetable(T, fullfile("results", "data", "study_summary.csv"));
plot_study_summary(T, cfg);

disp(" ");
disp("Results saved in results/data and results/figures.");
