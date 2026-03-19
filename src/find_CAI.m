function [CAI_val] = find_CAI(file_path1, file_path2, bmi, options)
    arguments
        file_path1 (1,1) string
        file_path2 (1,1) string
        bmi (1,1) double
        options.Ag (1,1) double = 1    % Index de la colonne EMG (ex: 1 pour EMG_1)
        options.Antag (1,1) double = 2 % Index de la colonne EMG (ex: 2 pour EMG_2)
    end
    subjects = get_subject_info();
    fs = 1000;

    % 1. Chargement des données
    data2 = readtable(file_path2);
    time = data2.Time;

    % 2. Extraction des colonnes EMG
    % On récupère les noms de colonnes qui commencent par "EMG_"
    all_var_names = string(data2.Properties.VariableNames);
    emg_idx = find(startsWith(all_var_names, "EMG_"));
    
    % On s'assure que les indices demandés existent
    if options.Ag > length(emg_idx) || options.Antag > length(emg_idx)
        error('Les indices Ag ou Antag dépassent le nombre de colonnes EMG disponibles.');
    end

    % Extraction des signaux bruts (vecteurs colonnes)
    Ag_raw = data2{:, emg_idx(options.Ag)};
    Antag_raw = data2{:, emg_idx(options.Antag)};

    Ag_processed = process_EMG(Ag_raw, time, fs, bmi, "ShowGraph", false);
    Antag_processed = process_EMG(Antag_raw, time, fs, bmi, "ShowGraph", false);

    % Récupération des noms exacts pour find_Tm (ex: "EMG_1")
    Ag_name = all_var_names(emg_idx(options.Ag));
    Antag_name = all_var_names(emg_idx(options.Antag));

    % 3. Calcul des baselines
    h = 3;
    % Calcul du Threshold
    Ag_baseline = find_Tm(file_path1, h, "minSTD", true, "EMG", Ag_name);
    Antag_baseline = find_Tm(file_path1, h, "minSTD", true, "EMG", Antag_name);

    % 4. Conditionnement (Soustraction baseline, Rectification, etc.)

    EMG_Ag = condition_EMG(Ag_baseline, Ag_processed);
    EMG_Antag = condition_EMG(Antag_baseline, Antag_processed);

    % 5. Calcul des Aires (trapz)
    A_Ag = trapz(time, EMG_Ag);
    A_Antag = trapz(time, EMG_Antag);
    
    % Aire commune (Co-activation)
    area_common_curve = min(EMG_Ag, EMG_Antag);
    A_common = trapz(time, area_common_curve);

    % 6. Calcul du CAI
    CAI_val = 2 * (A_common / (A_Ag + A_Antag)) * 100;

    % 7. Affichage
    figure('Name', 'Analyse de Co-activation (CAI)');
    plot(time, EMG_Ag, 'b', 'DisplayName', 'Agoniste');
    hold on
    plot(time, EMG_Antag, 'r', 'DisplayName', 'Antagoniste');
    % On remplit l'aire commune pour mieux visualiser
    area(time, area_common_curve, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none', 'DisplayName', 'Aire Commune');
    
    title(sprintf('Co-activation Index (CAI): %.2f%%', CAI_val));
    xlabel('Temps (s)');
    ylabel('Amplitude EMG');
    legend show;
    grid on;
end