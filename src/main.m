% Load subject info
subject = subject_info();
fprintf("Loaded information of subject %s\n", subject.code)

% Convert .emt files to .csv files
emtFolder2csv('../data_old/5_ROSA')

% Load one EMG file
data = readtable('../data_old/5_ROSA/0004~ac~Trial3_WithOrth.csv');

% Extract time and raw
time = data.Time;
EMG_raw = data.EMG_1;

% Process EMG and show each step
EMG_processed = process_EMG(EMG_raw, time, 1000);
