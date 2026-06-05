function result = run_best_validation_case()
%RUN_BEST_VALIDATION_CASE Backward-compatible wrapper for the example case.

warning("run_best_validation_case is kept for compatibility. Use run_representative_case instead.");
result = run_representative_case();
end
