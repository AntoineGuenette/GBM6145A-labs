function [T_m] = find_threshold(EMG, time, fs, h)

arguments
    EMG (:,1) double
    time (:,1) double
    fs (1,1) double
    h (1,1) double
end

% Number of samples
numSamples = length(EMG);

% Define window size (in seconds)
windowSize = round(0.3 * fs);

% Number of windows
number_windows = floor(time(end)/0.3);

% Initialize standard deviation values
stdValues = zeros(number_windows, 1);

% Compute standard deviation for each window
for i = 1:number_windows
    startIdx = (i-1) * windowSize + 1;
    endIdx = min(i * windowSize, numSamples);
    stdValues(i) = std(EMG(startIdx:endIdx));
end

% Find the window with the minimum standard deviation (assumed baseline)
[sigma_m, I] = min(stdValues);

% Extract corresponding segment to compute mean
startIdx = (I-1) * windowSize + 1;
endIdx = min(I * windowSize, numSamples);
mu_m = mean(EMG(startIdx:endIdx));

% Compute threshold
T_m = mu_m + h * sigma_m;

end