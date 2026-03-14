function EMG_proc = process_EMG(EMG, time, fs, bmi, options)

arguments
    EMG (:,1) double
    time (:,1) double
    fs (1,1) double
    bmi (1,1) double
    options.ShowGraph (1,1) logical = false
    options.BandpassLow (1,1) double = 10
    options.BandpassHigh (1,1) double = 400
    options.ACfreq (1,1) double = 60
    options.SmoothWin (1,1) double = 0.1
end

% Optionnal parameters
bp_low    = options.BandpassLow;
bp_high   = options.BandpassHigh;
ac_freq    = options.ACfreq;
smooth_win = options.SmoothWin;
show_graph = options.ShowGraph;

% Band-pass filter
[b_bp,a_bp] = butter(4,[bp_low bp_high]/(fs/2),'bandpass');
EMG_bp = filtfilt(b_bp,a_bp,EMG);

% Notch filter
bw = 2;
low = (ac_freq - bw)/(fs/2);
high = (ac_freq + bw)/(fs/2);

[b_notch, a_notch] = butter(2, [low high], 'stop');
EMG_lp = filtfilt(b_notch, a_notch, EMG_bp);

% Rectification
EMG_rect = abs(EMG_lp);

% Smoothing
win = round(smooth_win*fs);
EMG_smooth = movmean(EMG_rect,win);

% Normalization by Body-Mass Index (BMI)
EMG_norm = EMG_smooth / bmi;

% Normalization by max value
EMG_proc = EMG_norm / max(EMG_norm);

% Show figure if specified
if show_graph
    figure
    
    subplot(6,1,1)
    plot(time, EMG)
    title('Raw EMG signal')
    xlabel('Time (s)')
    ylabel('Amplitude (mV)')

    subplot(6,1,2)
    plot(time, EMG_bp)
    title('Band-pass')
    xlabel('Time (s)')
    ylabel('Amplitude (mV)')       

    subplot(6,1,3)
    plot(time, EMG_lp)
    title('Notch filter')
    xlabel('Time (s)')
    ylabel('Amplitude (mV)')

    subplot(6,1,4)
    plot(time, EMG_rect)
    title('Rectified EMG signal')
    xlabel('Time (s)')
    ylabel('Amplitude (mV)')

    subplot(6,1,5)
    plot(time, EMG_smooth)
    title('Smoothed EMG signal')
    xlabel('Time (s)')
    ylabel('Amplitude (mV)')

    subplot(6,1,6)
    plot(time, EMG_proc)
    title('Normalized EMG signal')
    xlabel('Time (s)')
    ylabel('Amplitude')

end

end