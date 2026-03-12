function EMG_proc = process_EMG(EMG, time, fs, bmi, options)
%PROCESS_EMG Process a raw EMG signal through filtering, rectification,
%smoothing, and normalization.
%
%   EMG_PROC = PROCESS_EMG(EMG, TIME, FS, BMI) processes the raw EMG signal
%   using a standard pipeline including band-pass filtering, low-pass
%   filtering, rectification, smoothing, and normalization. The resulting
%   signal is normalized by the subject's body-mass index (BMI) and by its
%   maximum value.
%
%   EMG_PROC = PROCESS_EMG(EMG, TIME, FS, BMI, OPTIONS) allows the user to
%   specify optional processing parameters.
%
%   INPUTS
%       EMG   - Raw EMG signal vector (Nx1) in millivolts.
%       TIME  - Time vector (Nx1) corresponding to the EMG samples (seconds).
%       FS    - Sampling frequency of the signal (Hz).
%       BMI   - Body-mass index of the subject used for normalization.
%
%   NAME-VALUE OPTIONS
%       ShowGraph    - Logical flag indicating whether to display the
%                      intermediate processing steps (default: false).
%       BandpassLow  - Low cutoff frequency of the band-pass filter (Hz)
%                      (default: 25).
%       BandpassHigh - High cutoff frequency of the band-pass filter (Hz)
%                      (default: 450).
%       EnvLP        - Cutoff frequency of the low-pass filter applied
%                      before rectification (Hz) (default: 25).
%       SmoothWin    - Window length for moving-average smoothing (seconds)
%                      (default: 0.1).
%
%   OUTPUT
%       EMG_PROC - Processed and normalized EMG signal (Nx1). The signal is
%                  normalized first by BMI and then by its maximum value.
%
%   If ShowGraph is true, a figure displaying each processing stage
%   (raw signal, band-pass filtered signal, low-pass filtered signal,
%   rectified signal, smoothed signal, and final normalized signal)
%   is generated.
%
%   Example
%       EMG_proc = process_EMG(EMG, time, fs, bmi, ...
%                   ShowGraph=true, SmoothWin=0.2);
%
%   See also BUTTER, FILTFILT, MOVMEAN.

arguments
    EMG (:,1) double
    time (:,1) double
    fs (1,1) double
    bmi (1,1) double
    options.ShowGraph (1,1) logical = false
    options.BandpassLow (1,1) double = 25
    options.BandpassHigh (1,1) double = 450
    options.EnvLP (1,1) double = 25
    options.SmoothWin (1,1) double = 0.1
end

% Optionnal parameters
bp_low    = options.BandpassLow;
bp_high   = options.BandpassHigh;
lp_env    = options.EnvLP;
smooth_win = options.SmoothWin;
show_graph = options.ShowGraph;

% Band-pass filter
[b_bp,a_bp] = butter(4,[bp_low bp_high]/(fs/2),'bandpass');
EMG_bp = filtfilt(b_bp,a_bp,EMG);

% Low-pass filter
[b_lp,a_lp] = butter(4,lp_env/(fs/2),'low');
EMG_lp = filtfilt(b_lp,a_lp,EMG_bp);

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
    title('Low-pass')
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