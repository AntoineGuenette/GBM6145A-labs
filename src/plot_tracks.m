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

% Plot all valid tracks
figure
    
subplot(4,1,1)
plot(time, bicep_proc)
title('Bicep')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(4,1,2)
plot(time, tricep_proc)
title('Tricep')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(4,1,3)
plot(time, ant_delt_proc)
title('Anterior Deltoid')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(4,1,4)
plot(time, post_delt_proc)
title('Posterior Deltoid')
xlabel('Time (s)')
ylabel('Amplitude')

end