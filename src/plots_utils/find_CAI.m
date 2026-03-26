function [CAI_val] = find_CAI(file_path1, file_path2, bmi, options)
    arguments
        file_path1 (1,1) string
        file_path2 (1,1) string
        bmi (1,1) double
        options.Ag (1,1) string    
        options.Antag (1,1) string 
        options.title (1,1) string
        options.task (1,1) string
        options.save_folder (1,1) string
        options.save_csv (1,1) string
        options.subject (1,1) string
        options.device (1,1) string
    end
    

    muscles_map = dictionary("Bicep", 1, "Tricep", 2, "DeltAnt", 3, "DeltPost", 4);
    fs = 1000;

    % --- 1. Mappage et Chargement ---
    idx_Ag_map = muscles_map(options.Ag);
    idx_Antag_map = muscles_map(options.Antag);
    
    data2 = readtable(file_path2);
    time = data2.Time;
    all_var_names = string(data2.Properties.VariableNames);
    emg_idx = find(startsWith(all_var_names, "EMG_"));
    
    % Extraction et Traitement
    Ag_raw = data2{:, emg_idx(idx_Ag_map)};
    Antag_raw = data2{:, emg_idx(idx_Antag_map)};
    Ag_processed = process_EMG(Ag_raw, time, fs, bmi, "ShowGraph", false);
    Antag_processed = process_EMG(Antag_raw, time, fs, bmi, "ShowGraph", false);
    
    % --- 2. Baselines et Conditionnement ---
    h = 1;
    Ag_name = all_var_names(emg_idx(idx_Ag_map));
    Antag_name = all_var_names(emg_idx(idx_Antag_map));
    Ag_baseline = find_Tm(file_path1, h, "minSTD", true, "EMG", Ag_name);
    Antag_baseline = find_Tm(file_path1, h, "minSTD", true, "EMG", Antag_name);
    
    EMG_Ag = condition_EMG(Ag_baseline, Ag_processed);
    val_max = max(EMG_Ag);
    if val_max > 0
        EMG_Ag = EMG_Ag / val_max;
    end
    EMG_Antag = condition_EMG(Antag_baseline, Antag_processed);
    val_max = max(EMG_Antag);
    if val_max > 0
        EMG_Antag = EMG_Antag / val_max;
    end
    
    % --- 3. Calculs CAI ---
    A_Ag = trapz(time, EMG_Ag);
    A_Antag = trapz(time, EMG_Antag);
    area_common_curve = min(EMG_Ag, EMG_Antag);
    A_common = trapz(time, area_common_curve);
    CAI_val = 2 * (A_common / (A_Ag + A_Antag)) * 100;
    if CAI_val == 0
        CAI_val = 0.00;
    end
    
    % --- 4. Création de la Figure ---
    nomTachePropre = replace(options.title, "_", " ");
    fig = figure('Name', 'CAI_' + options.title, 'Visible', 'off'); % 'off' pour ne pas spammer ton écran
    
    plot(time, EMG_Ag, 'b', 'LineWidth', 1, 'DisplayName', "Agoniste: " + options.Ag);
    hold on
    plot(time, EMG_Antag, 'r', 'LineWidth', 1, 'DisplayName', "Antagoniste: " + options.Antag);
    area(time, area_common_curve, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none', 'DisplayName', 'Aire Commune');
    
    title(sprintf('CAI pour la tâche %s %s (%s vs %s) : %.2f%%', ...
        char(options.task), ...
        char(nomTachePropre), ...
        char(options.Ag), ...
        char(options.Antag), ...
        CAI_val), ...
        'Interpreter', 'none');
    xlabel('Temps (s)');
    ylabel('Amplitude EMG');
    legend show;
    grid on;

    % --- 5. Enregistrement ---
    file_name = sprintf('CAI_task-%s_%s_%s_vs_%s.png', options.task, options.title, options.Ag, options.Antag);
    save_path = fullfile(options.save_folder, file_name);
    if isfile(save_path)
        fprintf('   -> %s already exists\n', file_name);
    else
        if ~exist(options.save_folder, 'dir')
            mkdir(options.save_folder);
        end
        
        saveas(fig, save_path, 'png');
        fprintf('   -> Saved plot : %s\n', file_name);
    end
  
    close(fig);

    % --- 6. Enregistrement CSV  ---
    % On prépare la ligne avec exactement le même nombre de colonnes que les headers
    newRow = table(options.task, options.subject, options.device, options.title, options.Ag, options.Antag, CAI_val, ...
        'VariableNames', {'TaskID', 'Subject', 'Device', 'TaskName', 'Agonist', 'Antagonist', 'CAI'});

    % Vérifier si le dossier du CSV existe
    [csv_dir, ~, ~] = fileparts(options.save_csv);
    if ~isempty(csv_dir) && ~exist(csv_dir, 'dir')
        mkdir(csv_dir);
    end

    if ~exist(options.save_csv, 'file')
        % Première fois : on écrit avec les noms de variables
        writetable(newRow, options.save_csv);
    else
        % Ajout : on écrit sans les noms de variables pour ne pas les répéter
        writetable(newRow, options.save_csv, 'WriteMode', 'Append', 'WriteVariableNames', false);
    end
end