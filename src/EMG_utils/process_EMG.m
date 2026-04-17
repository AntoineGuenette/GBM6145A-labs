function EMG_proc = process_EMG(EMG, time, fs, bmi, options)

    arguments
        EMG (:,1) double
        time (:,1) double
        fs (1,1) double
        bmi (1,1) double
        options.DoThreshold (1,1) logical = true
        options.ShowGraph (1,1) logical = false
        options.BandpassLow (1,1) double = 10
        options.BandpassHigh (1,1) double = 400
        options.ACfreq (1,1) double = 60
        options.SmoothWin (1,1) double = 0.1
        options.SavePath (1,1) string = ""
        options.StopTimeMs (1,1) double = inf
    end
    
    % Define optional parameters
    bp_low       = options.BandpassLow;
    bp_high      = options.BandpassHigh;
    ac_freq      = options.ACfreq;
    smooth_win   = options.SmoothWin;
    show_graph   = options.ShowGraph;
    do_threshold = options.DoThreshold;
    save_path    = options.SavePath;
    stop_time_ms = options.StopTimeMs;
    stop_time_s  = stop_time_ms / 1000;
    
    % Create folder if needed
    if save_path ~= ""
        if ~isfolder(save_path)
            mkdir(save_path);
        end
    end
    
    % Apply band-pass filter
    [b_bp,a_bp] = butter(4,[bp_low bp_high]/(fs/2),'bandpass');
    EMG_bp = filtfilt(b_bp,a_bp,EMG);
    
    % Apply notch filter
    bw = 2;
    low = (ac_freq - bw)/(fs/2);
    high = (ac_freq + bw)/(fs/2);
    [b_notch, a_notch] = butter(2, [low high], 'stop');
    EMG_lp = filtfilt(b_notch, a_notch, EMG_bp);
    
    % Apply rectification
    EMG_rect = abs(EMG_lp);
    
    % Apply smoothing
    win = round(smooth_win*fs);
    EMG_smooth = movmean(EMG_rect, win);
    
    % Normalize by BMI
    EMG_norm = EMG_smooth / bmi;
    EMG_proc = EMG_norm;
    
    % Keep only the activations
    if do_threshold
        threshold = find_threshold(EMG_proc, time, fs, 3);
        EMG_proc = condition_EMG(threshold, EMG_proc, 25);
    end
    
    % Display and/or save graphs
    signals = {EMG, EMG_bp, EMG_lp, EMG_rect, EMG_smooth, EMG_norm, EMG_proc};
    titles  = {"Figure 2a : Signal brut", ...
               "Figure 2b : Signal filtré (passe-bas)", ...
               "Figure 2c : Signal filtré (Notch)", ...
               "Figure 2d : Signal rectifié", ...
               "Figure 2e : Signal lissé", ...
               "Figure 2f : Signal normalisé", ...
               "Figure 2g : Signal d'activation"};
    
    ylabels = {"Amplitude (mV)", ...
               "Amplitude (mV)", ...
               "Amplitude (mV)", ...
               "Amplitude (mV)", ...
               "Amplitude (mV)", ...
               "Amplitude", ...
               "Amplitude"};
    
    files = {"00_raw_emg.png", ...
             "01_bandpass.png", ...
             "02_notch.png", ...
             "03_rectified.png", ...
             "04_smoothed.png", ...
             "05_normalized.png", ...
             "06_processed.png"};
    
    colors = ["#606060", ...
              "#fe6a6b", ...
              "#03c1cb", ...
              "#ffd166", ...
              "#0ad69f", ...
              "#8359aa", ...
              "#4488de"];
    
    for i = 1:numel(signals)
        fig = figure('Visible', ternary(show_graph, 'on', 'off'));
        fig.Position(3:4) = [400 400];
    
        plot(time, signals{i}, 'LineWidth', 1, 'Color', colors(i))
        title(titles{i})
        xlabel('Temps (s)')
        ylabel(ylabels{i})
        grid on
    
        if isfinite(stop_time_s)
            xlim([time(1) min(stop_time_s, time(end))])
        end
    
        if save_path ~= ""
            exportgraphics(gca, fullfile(save_path, files{i}), 'Resolution', 300);
        end
    
        if ~show_graph
            close(fig)
        end
        
    end

end