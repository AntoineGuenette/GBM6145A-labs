% Load subject info
old_subjects = get_old_subject_info();
subjects = get_subject_info();

% Convert .emt files to .csv files
emtFolder2csv('../data_old/1_SCHP')
emtFolder2csv('../data_old/3_MICA')
emtFolder2csv('../data_old/4_STAV')
emtFolder2csv('../data_old/5_ROSA')

% Load one EMG file
file_path = '../data_old/5_ROSA/0004~ac~Trial3_WithOrth.csv';
data = readtable(file_path);

% Extract time and raw
time = data.Time;
EMG_raw = data.EMG_1;

% Process EMG and show each step
EMG_processed = process_EMG(EMG_raw, time, 1000, ...
    subjects(4).bmi, ShowGraph=true);

% Show all tracks
plot_tracks(file_path, subjects(4).bmi)