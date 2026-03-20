function plot_tracks(file_path, save_path, plot_title, bmi, options)

arguments
    file_path (1,1) string
    save_path (1,1) string
    plot_title (1,1) string
    bmi (1,1) double
    options.BicepTrack (1,1) double = 1
    options.TricepTrack (1,1) double = 2
    options.AntDeltTrack (1,1) double = 3
    options.PostDeltTrack (1,1) double = 4
end

% Load EMG file and get time
data = readtable(file_path);

% Collect all columns whose names start with "EMG_"
emg_vars = startsWith(string(data.Properties.VariableNames), "EMG_");
EMG = data{:, emg_vars};

% Get time and number of tracks
time = data.Time;
nTracks = size(EMG, 2);

% Ensure requested tracks are within available range
bt  = min(max(1, options.BicepTrack), nTracks);
tt  = min(max(1, options.TricepTrack), nTracks);
adt = min(max(1, options.AntDeltTrack), nTracks);
pdt = min(max(1, options.PostDeltTrack), nTracks);

% Select valid EMG tracks based on options
bicep_EMG    = EMG(:, bt);
tricep_EMG   = EMG(:, tt);
ant_delt_EMG = EMG(:, adt);
post_delt_EMG= EMG(:, pdt);

% Process each valid EMG track
bicep_proc    = process_EMG(bicep_EMG, time, 1000, bmi);
tricep_proc   = process_EMG(tricep_EMG, time, 1000, bmi);
ant_delt_proc = process_EMG(ant_delt_EMG, time, 1000, bmi);
post_delt_proc= process_EMG(post_delt_EMG, time, 1000, bmi);

% Get max voltage value and max time
max_val = max([bicep_proc; tricep_proc; ant_delt_proc; post_delt_proc]);
max_time = max(time);

% Create figure
fig = figure('Visible','off');

subplot(4,1,1)
plot(time, bicep_proc)
title('Bicep')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0,max_time])
ylim([0,max_val])

subplot(4,1,2)
plot(time, tricep_proc)
title('Tricep')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0,max_time])
ylim([0,max_val])

subplot(4,1,3)
plot(time, ant_delt_proc)
title('Anterior Deltoid')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0,max_time])
ylim([0,max_val])

subplot(4,1,4)
plot(time, post_delt_proc)
title('Posterior Deltoid')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0,max_time])
ylim([0,max_val])

sgtitle(plot_title)

% Save the figure to the specified path
[save_folder, ~, ~] = fileparts(save_path);
if ~exist(save_folder, 'dir')
    mkdir(save_folder);
end

saveas(fig, save_path, 'png');
close(fig);

end