function [CAI_val] = plot_CAI(rest_path, EMG_path, bmi, fs, options)

arguments
    rest_path (1,1) string
    EMG_path (1,1) string
    bmi (1,1) double
    fs (1,1) double
    options.Ag (1,1) string
    options.Antag (1,1) string
    options.title (1,1) string
    options.task (1,1) string
    options.save_folder (1,1) string
    options.save_csv (1,1) string
    options.subject (1,1) string
    options.modality (1,1) string
end

% Muscle mapping
muscles_map = dictionary( ...
    "Bicep", 1, ...
    "Tricep", 2, ...
    "DeltAnt", 3, ...
    "DeltPost", 4);

% Mapping and Data Loading
idx_Ag = muscles_map(options.Ag);
idx_Antag = muscles_map(options.Antag);

rest_data = readtable(rest_path);
EMG_data  = readtable(EMG_path);

time = EMG_data.Time;

% Extract EMG variable indices
all_var_names = string(EMG_data.Properties.VariableNames);
emg_idx = find(startsWith(all_var_names, "EMG_"));

% Extract raw EMG signals
rest_Ag_raw    = rest_data{:, emg_idx(idx_Ag)};
rest_Antag_raw = rest_data{:, emg_idx(idx_Antag)};
Ag_raw         = EMG_data{:, emg_idx(idx_Ag)};
Antag_raw      = EMG_data{:, emg_idx(idx_Antag)};

% Signal Processing
rest_Ag_proc    = process_EMG(rest_Ag_raw, time, fs, bmi, "DoThreshold", false);
rest_Antag_proc = process_EMG(rest_Antag_raw, time, fs, bmi, "DoThreshold", false);
Ag_proc    = process_EMG(Ag_raw, time, fs, bmi, "DoThreshold", false);
Antag_proc = process_EMG(Antag_raw, time, fs, bmi, "DoThreshold", false);

% Baseline Estimatio
Ag_baseline    = find_threshold(rest_Ag_proc, time, fs, 3);
Antag_baseline = find_threshold(rest_Antag_proc, time, fs, 3);

% Conditioning
EMG_Ag    = condition_EMG(Ag_baseline, Ag_proc, 25);
EMG_Antag = condition_EMG(Antag_baseline, Antag_proc, 25);

% Normalization
if max(EMG_Ag) > 0
    EMG_Ag = EMG_Ag / max(EMG_Ag);
end

if max(EMG_Antag) > 0
    EMG_Antag = EMG_Antag / max(EMG_Antag);
end

% CAI Computation
A_Ag    = trapz(time, EMG_Ag);
A_Antag = trapz(time, EMG_Antag);

area_common = min(EMG_Ag, EMG_Antag);
A_common = trapz(time, area_common);

CAI_val = 2 * (A_common / (A_Ag + A_Antag)) * 100;

% Avoid negative zero / numerical artifacts
CAI_val = max(CAI_val, 0);

% 7. Plotting
task_name_clean = replace(options.title, "_", " ");

fig = figure('Name', 'CAI_' + options.title, 'Visible', 'off');

plot(time, EMG_Ag, 'b', 'LineWidth', 1, ...
    'DisplayName', "Agonist: " + options.Ag);
hold on

plot(time, EMG_Antag, 'r', 'LineWidth', 1, ...
    'DisplayName', "Antagonist: " + options.Antag);

area(time, area_common, ...
    'FaceColor', [0.7 0.7 0.7], ...
    'EdgeColor', 'none', ...
    'DisplayName', 'Common Area');

title(sprintf('CAI for task %s %s (%s vs %s): %.2f%%', ...
    char(options.task), ...
    char(task_name_clean), ...
    char(options.Ag), ...
    char(options.Antag), ...
    CAI_val), ...
    'Interpreter', 'none');

xlabel('Time (s)');
ylabel('Normalized EMG');

legend show
grid on

% Save Figure
file_name = sprintf('CAI_task-%s_%s_%s_vs_%s.png', ...
    options.task, options.title, options.Ag, options.Antag);

save_path = fullfile(options.save_folder, file_name);

if ~exist(options.save_folder, 'dir')
    mkdir(options.save_folder);
end

if isfile(save_path)
    fprintf(' -> %s already exists\n', file_name);
else
    saveas(fig, save_path, 'png');
    fprintf(' -> Saved plot: %s\n', file_name);
end

close(fig);

% Save CSV
newRow = table( ...
    options.task, ...
    options.subject, ...
    options.modality, ...
    options.title, ...
    options.Ag, ...
    options.Antag, ...
    CAI_val, ...
    'VariableNames', {'TaskID', 'Subject', 'Modality', 'TaskName', 'Agonist', 'Antagonist', 'CAI'});

% Ensure directory exists
[csv_dir, ~, ~] = fileparts(options.save_csv);
if ~isempty(csv_dir) && ~exist(csv_dir, 'dir')
    mkdir(csv_dir);
end

if ~exist(options.save_csv, 'file')
    writetable(newRow, options.save_csv);
else
    writetable(newRow, options.save_csv, ...
        'WriteMode', 'Append', ...
        'WriteVariableNames', false);
end

end