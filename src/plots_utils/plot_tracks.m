function plot_tracks(file_path, save_path, plot_title, bmi, options)

    arguments
        file_path (1,1) string
        save_path (1,1) string
        plot_title (1,1) string
        bmi (1,1) double
        options.fs (1,1) double = 1000
        options.BicepTrack (1,1) double = 1
        options.TricepTrack (1,1) double = 2
        options.AntDeltTrack (1,1) double = 3
        options.PostDeltTrack (1,1) double = 4
        options.taskID (1,1) string
        options.taskName (1,1) string
        options.subject (1,1) string
        options.modality (1,1) string
        options.save_csv (1,1) string = ""
    end
    
    % Load data
    data = readtable(file_path);
    
    emg_vars = startsWith(string(data.Properties.VariableNames), "EMG_");
    EMG = data{:, emg_vars};
    
    time = data.Time;
    nTracks = size(EMG, 2);
    
    % Select the tracks
    bt  = min(max(1, options.BicepTrack), nTracks);
    tt  = min(max(1, options.TricepTrack), nTracks);
    adt = min(max(1, options.AntDeltTrack), nTracks);
    pdt = min(max(1, options.PostDeltTrack), nTracks);
    
    bicep_EMG     = EMG(:, bt);
    tricep_EMG    = EMG(:, tt);
    ant_delt_EMG  = EMG(:, adt);
    post_delt_EMG = EMG(:, pdt);
    
    % Process the signal
    bicep_proc     = process_EMG(bicep_EMG, time, options.fs, bmi);
    tricep_proc    = process_EMG(tricep_EMG, time, options.fs, bmi);
    ant_delt_proc  = process_EMG(ant_delt_EMG, time, options.fs, bmi);
    post_delt_proc = process_EMG(post_delt_EMG, time, options.fs, bmi);
    
    % Compute mean values
    mean_bicep     = mean(bicep_proc);
    mean_tricep    = mean(tricep_proc);
    mean_ant_delt  = mean(ant_delt_proc);
    mean_post_delt = mean(post_delt_proc);
    
    % Create figure
    max_val  = max([bicep_proc; tricep_proc; ant_delt_proc; post_delt_proc]);
    max_time = max(time);
    
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
    
    % Save figure
    [save_folder, file_name, ~] = fileparts(save_path);
    
    if ~exist(save_folder, 'dir')
        mkdir(save_folder);
    end
    
    if isfile(save_path + ".png")
        fprintf('   -> %s already exists\n', file_name);
    else
        saveas(fig, save_path, 'png');
        fprintf('   -> Saved plot : %s\n', file_name);
    end
    
    close(fig);
    
    % Save CSV
    if options.save_csv ~= ""
    
        muscles = ["Bicep"; "Tricep"; "DeltAnt"; "DeltPost"];
        means   = [mean_bicep; mean_tricep; mean_ant_delt; mean_post_delt];
    
        newRows = table( ...
            repmat(options.taskID, 4, 1), ...
            repmat(options.subject, 4, 1), ...
            repmat(options.modality, 4, 1), ...
            repmat(options.taskName, 4, 1), ...
            muscles, ...
            means, ...
            'VariableNames', {'TaskID', 'Subject', 'Modality', 'TaskName', 'Muscle', 'MeanActivation'});
    
        % Ensure directory exists
        [csv_dir, ~, ~] = fileparts(options.save_csv);
        if ~isempty(csv_dir) && ~exist(csv_dir, 'dir')
            mkdir(csv_dir);
        end
    
        % Write or append
        if ~exist(options.save_csv, 'file')
            writetable(newRows, options.save_csv);
        else
            writetable(newRows, options.save_csv, ...
                'WriteMode', 'Append', ...
                'WriteVariableNames', false);
        end
    
    end

end