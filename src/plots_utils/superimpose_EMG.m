function superimpose_EMG(file_path1, file_path2, file_path3, file_path4, save_dir)

arguments
    file_path1 (1,1) string
    file_path2 (1,1) string
    file_path3 (1,1) string
    file_path4 (1,1) string
    save_dir (1,1) string
end

subjects = get_subject_info();

% Create a list with all file paths
file_paths = [file_path1, file_path2, file_path3, file_path4];

% Create a struct with all the file infos
infos(4) = parse_filename(file_paths(1)); % preallocate
for i = 1:4
    infos(i) = parse_filename(file_paths(i));
end

% Create save_path
group = infos(1).group;
task_name = infos(1).task_name;
file_name = "Group_" + group + "-" + task_name;
save_path = fullfile(save_dir, file_name);

% Search for the file with the longest run time
max_len = 0;
max_path = '';
for file_path = file_paths
    data = readtable(file_path);
    [rows, ~] = size(data.Time);
    if rows > max_len
        max_len = rows;
        max_path = file_path;
    end

end

% Initialize tracks
tracks_1 = zeros(max_len, 4);
tracks_2 = zeros(max_len, 4);
tracks_3 = zeros(max_len, 4);
tracks_4 = zeros(max_len, 4);

% Process the EMG data for each track
for i = 1:4
    data = readtable(file_paths(i));
    [rows, ~] = size(data.Time);
    tracks_1(1:rows,i) = process_EMG(data.EMG_1, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
    tracks_2(1:rows, i) = process_EMG(data.EMG_2, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
    tracks_3(1:rows, i) = process_EMG(data.EMG_3, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
    tracks_4(1:rows, i) = process_EMG(data.EMG_4, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
end

% Find the maximum value across all tracks
max_val = max([ ...
    tracks_1(:); ...
    tracks_2(:); ...
    tracks_3(:); ...
    tracks_4(:) ...
]);
max_time = max_len / 1000;

data_time = readtable(max_path);
time = data_time.Time;

% Create figure
fig = figure('Visible','off');

% Add suptitle
task_name = strrep(infos(1).task_name, "_", " ");
sgtitle(sprintf("Comparison for %s",  task_name));

% Generate legend labels
legend_labels = strings(1,4);
device_count = containers.Map;
for i = 1:4
    dev = infos(i).device;
    if isKey(device_count, dev)
        device_count(dev) = device_count(dev) + 1;
    else
        device_count(dev) = 1;
    end

    if device_count(dev) == 1
        legend_labels(i) = dev;
    else
        legend_labels(i) = sprintf("%s %d", dev, device_count(dev));
    end
end

% Create subplots
subplot(4,1,1)
plot(time, tracks_1(:,1), "r-", "LineWidth",1);
hold on
plot(time, tracks_1(:,2), "b-", "LineWidth",1);
hold on
plot(time, tracks_1(:,3), "g-", "LineWidth",1);
hold on
plot(time, tracks_1(:,4), "y-", "LineWidth",1);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('Bicep');
legend(legend_labels);
xlim([0,max_time])
ylim([0,max_val])

subplot(4,1,2)
plot(time, tracks_2(:,1), "r-", "LineWidth",1);
hold on
plot(time, tracks_2(:,2), "b-", "LineWidth",1);
hold on
plot(time, tracks_2(:,3), "g-", "LineWidth",1);
hold on
plot(time, tracks_2(:,4), "y-", "LineWidth",1);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('Tricep');
legend(legend_labels);
xlim([0,max_time])
ylim([0,max_val])

subplot(4,1,3)
plot(time, tracks_3(:,1), "r-", "LineWidth",1);
hold on
plot(time, tracks_3(:,2), "b-", "LineWidth",1);
hold on
plot(time, tracks_3(:,3), "g-", "LineWidth",1);
hold on
plot(time, tracks_3(:,4), "y-", "LineWidth",1);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('Anterior deltoid');
legend(legend_labels);
xlim([0,max_time])
ylim([0,max_val])

subplot(4,1,4)
plot(time, tracks_4(:,1), "r-", "LineWidth",1);
hold on
plot(time, tracks_4(:,2), "b-", "LineWidth",1);
hold on
plot(time, tracks_4(:,3), "g-", "LineWidth",1);
hold on
plot(time, tracks_4(:,4), "y-", "LineWidth",1);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('Posterior deltoid');
legend(legend_labels);
xlim([0,max_time])
ylim([0,max_val])

% Save the figure to the specified path
[save_folder, ~, ~] = fileparts(save_path);
if ~exist(save_folder, 'dir')
    mkdir(save_folder);
end

saveas(fig, save_path, 'png');
close(fig);

end