% Define directories
script_path = mfilename('fullpath');
[src_dir, ~, ~] = fileparts(script_path);
data_dir = fullfile(src_dir, "..", "data");
figs_dir = fullfile(src_dir, "..", "figs");
res_dir = fullfile(src_dir, "..", "res");

% Define sub-directories and files
sub_data_dir = fullfile(data_dir, "GUEA_ses1");
save_dir = fullfile(figs_dir, "EMG_process_pipeline");

% Load functions
addpath(fullfile(src_dir, "EMG_utils"))
addpath(fullfile(src_dir, "files_utils"))
addpath(fullfile(src_dir, "subject_utils"))

% Load subject info
subjects = get_subject_info();

% Load one EMG file
emg_file = fullfile(sub_data_dir, "Serie_1-Group_3-Task_10-HFT_Feeding_task-Baseline_(JAECO).csv");
data = readtable(emg_file);

% Extract time and raw
time = data.Time;
EMG_raw = data.EMG_2;

% Process EMG and show each step
EMG_processed = process_EMG(EMG_raw, time, 1000, subjects(1).bmi, ...
    SavePath=save_dir, ...
    ShowGraph=false, ...
    DoThreshold=true, ...
    StopTimeMs=4500);