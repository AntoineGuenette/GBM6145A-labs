% Load subject info
subjects = subject_info();
fprintf("Loaded information of subject %s\n", subjects(1).code)
fprintf("Loaded information of subject %s\n", subjects(2).code)
fprintf("Loaded information of subject %s\n", subjects(3).code)
fprintf("Loaded information of subject %s\n", subjects(4).code)

% Convert .emt files to .csv files
% emtFolder2csv('../data_old/5_ROSA')

file_path = '../data_old/5_ROSA/0004~ac~Trial3_WithOrth.csv';
plot_tracks(file_path, subjects(4).bmi);
