% Load subject info
subject = subject_info();
fprintf("Loaded information of subject %s\n", subject.code)

% Convert .emt files to .csv files
emt_folder_path = '../data_old/5_ROSA';
emtFolder2csv(emt_folder_path)

