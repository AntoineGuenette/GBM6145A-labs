function [EMG1_conditionned, Tm] = method2_part1(file_path, h, options)
arguments
    file_path (1,1) string
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

% --- Détection Onset/Offset ---
detection = EMG1 > T_m;
sums = movsum(double(detection), [0 24], 'Endpoints', 'discard');

idx_on = find(sums == 25, 1);
idx_off = find(sums == 0, 1, 'last');

% Initialisation de la sortie
EMG1_conditionned = zeros(size(EMG1));

% Sécurité : vérifier si on a trouvé les deux indices
if ~isempty(idx_on) && ~isempty(idx_off) && (idx_off > idx_on)
    % On applique le seuil uniquement sur la zone active
    % Note : on ajoute 24 à idx_off pour inclure la fin de la fenêtre de silence
    EMG1_conditionned(idx_on:idx_off+24) = EMG1(idx_on:idx_off+24) - T_m;
    
    % On s'assure de ne pas avoir de valeurs négatives après soustraction du seuil
    EMG1_conditionned(EMG1_conditionned < 0) = 0;
else
    warning('Détection Onset/Offset incomplète pour le fichier : %s', file_path);
end

end