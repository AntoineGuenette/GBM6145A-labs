function superimpose_EMG(file_path1, file_path2, file_path3, file_path4, save_dir)

    arguments
        file_path1 (1,1) string
        file_path2 (1,1) string
        file_path3 (1,1) string
        file_path4 (1,1) string
        save_dir (1,1) string
    end
    
    % Load subject information
    subjects = get_subject_info();
    
    % Build list of input file paths
    file_paths = [file_path1, file_path2, file_path3, file_path4];
    
    % Parse file names and collect metadata
    infos(4) = parse_filename(file_paths(1)); % preallocate
    for i = 1:4
        infos(i) = parse_filename(file_paths(i));
    end
    
    % Build output path for group-level plot
    group = infos(1).group;
    task_name = infos(1).task_name;
    file_name = "Group_" + group + "-" + task_name;
    save_path = fullfile(save_dir, file_name);
    
    % Find the file with the longest recording
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
    
    % Initialize EMG track matrices with max length
    tracks_1 = zeros(max_len, 4);
    tracks_2 = zeros(max_len, 4);
    tracks_3 = zeros(max_len, 4);
    tracks_4 = zeros(max_len, 4);
    
    % Process EMG for each subject and each channel
    for i = 1:4
        data = readtable(file_paths(i));
        [rows, ~] = size(data.Time);
        tracks_1(1:rows,i) = process_EMG(data.EMG_1, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
        tracks_2(1:rows, i) = process_EMG(data.EMG_2, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
        tracks_3(1:rows, i) = process_EMG(data.EMG_3, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
        tracks_4(1:rows, i) = process_EMG(data.EMG_4, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
    end
    
    % Compute global maximum amplitude and time axis
    max_val = max([ ...
        tracks_1(:); ...
        tracks_2(:); ...
        tracks_3(:); ...
        tracks_4(:) ...
    ]);
    max_time = max_len / 1000;
    
    % Build common time vector based on longest recording
    data_time = readtable(max_path);
    time = data_time.Time;
    
    % Create figure
    fig = figure('Visible','off');
    
    task_name = strrep(infos(1).task_name, "_", " ");
    sgtitle(sprintf("Comparison for %s",  task_name));
    
    legend_labels = strings(1,4);
    device_count = containers.Map;
    for i = 1:4
        dev = infos(i).modality;
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
    
    % Save figure
    [save_folder, file_name, ~] = fileparts(save_path);
    if isfile(save_path + ".png")
        fprintf('   -> %s already exists\n', file_name);
    else
        if ~exist(save_folder, 'dir')
            mkdir(save_folder);
        end
        
        saveas(fig, save_path, 'png');
        fprintf('   -> Saved plot : %s\n', file_name);
        
    close(fig);

    end

end