% Load subject info
subjects = subject_info();
fprintf("Loaded information of subject %s\n", subjects(1).code)
fprintf("Loaded information of subject %s\n", subjects(2).code)
fprintf("Loaded information of subject %s\n", subjects(3).code)
fprintf("Loaded information of subject %s\n", subjects(4).code)

% Convert .emt files to .csv files
% emtFolder2csv('../data_old/5_ROSA')

% Load one EMG file
data = readtable('../data_old/5_ROSA/0004~ac~Trial3_WithOrth.csv');

% Extract time and raw
time = data.Time;
EMG_raw = data.EMG_1;

% Process EMG and show each step
EMG_processed = process_EMG(EMG_raw, time, 1000, subjects(4).bmi, ...
    ShowGraph=true);
