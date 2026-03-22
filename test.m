% Create results file
fprintf("\nCreating results CSV file...\n")
initialize_results(results_path)

% Add non-EMG-related results
update_non_EMG_results(results_path)

% Add CAI results
update_CAI_results(CAI_results_path, results_path);
fprintf("Results have been written in %s\n", results_path)
