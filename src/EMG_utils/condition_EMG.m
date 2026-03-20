EMfunction [EMG_conditionned] = condition_EMG(T_m,EMG)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% --- Détection Onset/Offset ---
detection = EMG > T_m;
sums = movsum(double(detection), [0 24], 'Endpoints', 'discard');

idx_on = find(sums == 25, 1);
idx_off = find(sums == 0, 1, 'last');

% Initialisation de la sortie
EMG_conditionned = zeros(size(EMG));

% Sécurité : vérifier si on a trouvé les deux indices
if ~isempty(idx_on) && ~isempty(idx_off) && (idx_off > idx_on)
    % On applique le seuil uniquement sur la zone active
    % Note : on ajoute 24 à idx_off pour inclure la fin de la fenêtre de silence
    EMG_conditionned(idx_on:idx_off+24) = EMG(idx_on:idx_off+24) - T_m;
    
    % On s'assure de ne pas avoir de valeurs négatives après soustraction du seuil
    EMG_conditionned(EMG_conditionned < 0) = 0;
else
    EMG_conditionned = EMG - T_m; % Set all values to zero if detection fails
    EMG_conditionned(EMG_conditionned < 0) = 0; % Ensure no negative values
    warning("Détection Onset/Offset incomplète pour l'EMG");
end
end