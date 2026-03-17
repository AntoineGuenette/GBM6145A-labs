function plot_tracks(file_path, bmi, options)

arguments
    file_path (1,1) string
    bmi (1,1) double
    options.BicepTrack (1,1) int8 = 1
    options.TricepTrack (1,1) int8 = 2
    options.AntDeltTrack (1,1) int8 = 3
    options.PostDeltTrack (1,1) int8 = 4

end

% Load EMG file
data = readtable(file_path);

% Extract columns
time = data.Time;
track_1 = data.EMG_1;
track_2 = data.EMG_2;
track_3 = data.EMG_3;
track_4 = data.EMG_4;
track_5 = data.EMG_5;
track_6 = data.EMG_6;

% Select valid EMG tracks based on options
EMG = [track_1, track_2, track_3, track_4, track_5, track_6];
bicep_EMG = EMG(:, options.BicepTrack);
tricep_EMG = EMG(:, options.TricepTrack);
ant_delt_EMG = EMG(:, options.AntDeltTrack);
post_delt_EMG = EMG(:, options.PostDeltTrack);

% Process each valid EMG track
bicep_proc = process_EMG(bicep_EMG, time, 1000, bmi);
tricep_proc = process_EMG(tricep_EMG, time, 1000, bmi);
ant_delt_proc = process_EMG(ant_delt_EMG, time, 1000, bmi);
post_delt_proc = process_EMG(post_delt_EMG, time, 1000, bmi);

% Normalize all tracks by the maximum value
max_val = max([bicep_proc; tricep_proc; ant_delt_proc; post_delt_proc]);
bicep_norm = bicep_proc / max_val;
tricep_norm = tricep_proc / max_val;
ant_delt_norm = ant_delt_proc / max_val;
post_delt_norm = post_delt_proc / max_val;


% Plot all valid tracks
figure
    
subplot(4,1,1)
plot(time, bicep_norm)
title('Bicep')
xlabel('Time (s)')
ylabel('Amplitude')
ylim([0,1])

subplot(4,1,2)
plot(time, tricep_norm)
title('Tricep')
xlabel('Time (s)')
ylabel('Amplitude')
ylim([0,1])

subplot(4,1,3)
plot(time, ant_delt_norm)
title('Anterior Deltoid')
xlabel('Time (s)')
ylabel('Amplitude')
ylim([0,1])

subplot(4,1,4)
plot(time, post_delt_norm)
title('Posterior Deltoid')
xlabel('Time (s)')
ylabel('Amplitude')
ylim([0,1])

end