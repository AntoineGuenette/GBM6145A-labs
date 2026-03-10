function EMG_proc = process_EMG(EMG, time, fs)
%PROCESS_EMG Process a raw EMG signal to obtain a smoothed envelope.
%
%   EMG_proc = PROCESS_EMG(EMG, time, fs) processes a raw electromyography
%   (EMG) signal through a sequence of filtering and signal conditioning
%   steps to obtain a smoothed EMG envelope.
%
%   The processing pipeline includes:
%       1. Band-pass filtering (25–450 Hz) using a 4th-order Butterworth
%          filter to remove motion artifacts and high-frequency noise.
%       2. Low-pass filtering (25 Hz) using a 4th-order Butterworth filter.
%       3. Full-wave rectification of the signal.
%       4. Moving average smoothing using a 0.1 s window.
%
%   The function also generates a figure displaying the signal at each
%   processing stage:
%       - Raw EMG signal
%       - Band-pass filtered signal
%       - Low-pass filtered signal
%       - Rectified signal
%       - Final processed EMG envelope
%
%   Inputs:
%       EMG   - Raw EMG signal vector (mV)
%       time  - Time vector corresponding to the EMG signal (s)
%       fs    - Sampling frequency (Hz)
%
%   Output:
%       EMG_proc - Processed EMG signal (smoothed envelope)
%
%   Example:
%       EMG_proc = process_EMG(EMG, time, 1000);
%
%   See also BUTTER, FILTFILT, MOVMEAN.

figure

subplot(5,1,1)
plot(time, EMG)
title('Raw EMG signal')
xlabel('Time (s)')
ylabel('Amplitude (mV)')

% Parameters
bp_low = 25;        % band-pass low cutoff frequency (Hz)
bp_high = 450;      % band-pass high cutoff frequency (Hz)
lp_env = 25;         % low-pass cutoff frequency for EMG envelope (Hz)
smooth_win = 0.1;   % moving average window (s)

% Band-pass filter
[b_bp,a_bp] = butter(4,[bp_low bp_high]/(fs/2),'bandpass');
EMG_bp = filtfilt(b_bp,a_bp,EMG);

subplot(5,1,2)
plot(time, EMG_bp)
title('Band-pass')
xlabel('Time (s)')
ylabel('Amplitude (mV)')

% Low-pass filter
[b_lp,a_lp] = butter(4,lp_env/(fs/2),'low');
EMG_lp = filtfilt(b_lp,a_lp,EMG_bp);

subplot(5,1,3)
plot(time, EMG_lp)
title('Low-pass')
xlabel('Time (s)')
ylabel('Amplitude (mV)')

% Rectification
EMG_rect = abs(EMG_lp);

subplot(5,1,4)
plot(time, EMG_rect)
title('Rectified EMG signal')
xlabel('Time (s)')
ylabel('Amplitude (mV)')

% Smoothing
win = round(smooth_win*fs);
EMG_proc = movmean(EMG_rect,win);

subplot(5,1,5)
plot(time, EMG_proc)
title('Processed EMG signal')
xlabel('Time (s)')
ylabel('Amplitude (mV)')

end