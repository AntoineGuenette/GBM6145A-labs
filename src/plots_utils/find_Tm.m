function [T_m] = find_Tm(file_path, h, options)
arguments
    file_path (1,1) string % Baseline EMG
    h (1,1) double
    options.minSTD (1,1) logical = true
    options.EMG (1,1) string = "EMG_1"
end

data = readtable(file_path);
% Sélection dynamique de l'EMG demandée
raw_EMG = data.(options.EMG); 

subjects = get_subject_info();
fs = 1000;
windowSize = round(0.3 * fs);
numSamples = length(raw_EMG);
time = data.Time;

% Traitement du signal (on utilise raw_EMG ici)
EMG1 = process_EMG(raw_EMG, time, fs, subjects(1).bmi, "ShowGraph", false);

% Calcul des fenêtres pour l'écart-type
number_windows = floor(time(end)/0.3);
stdValues = zeros(number_windows, 1);

for i = 1:number_windows
    startIdx = (i-1) * windowSize + 1;
    endIdx = min(i * windowSize, numSamples);
    stdValues(i) = std(EMG1(startIdx:endIdx));
end

[M, I] = min(stdValues);
startIdx = (I-1) * windowSize + 1;
endIdx = min(I * windowSize, numSamples);
mu_m = mean(EMG1(startIdx:endIdx));

if options.minSTD
    sigma_m = M;
else
    sigma_m = std(EMG1);
end

T_m = mu_m + h * sigma_m;

end