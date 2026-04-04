function heatmap_diff_CAI(file_path, subject)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    file_path (1,1) string
    subject (1,1) string
end

results = readtable(file_path);
% ------ Heatmap non CAI results -------
% Creating a mask that only keeps non CAI indexes
mask = contains(results.Criteria, 'CAI');
sub_table = results(mask, :);

% 2. Extraire le Nom de la Tâche et le Muscle à partir de la colonne Criteria
% Format attendu : "Nom_Task-CAI_Muscle"
% On sépare au niveau du "-CAI_"
parts = split(sub_table.Criteria, "-CAI_");
sub_table.Task = replace(parts(:,1), '_', ' '); % Nettoyage immédiat des '_'
sub_table.Muscle = parts(:,2);

if subject == "GUEA"
    minValues = min([sub_table.GUEA_ses1;sub_table.GUEA_ses2]);
    maxValues = max([sub_table.GUEA_ses1; sub_table.GUEA_ses2]);
    t = tiledlayout(1,2,TileSpacing="compact");
    nexttile
    h1 = heatmap(sub_table, "Muscle", "Task", ColorVariable="GUEA_ses1");
    h1.Colormap = redbluecmap;
    h1.ColorLimits = [minValues, maxValues];
    h1.Title = 'JAECO vs DynaReach';
    h1.ColorbarVisible = 'off';
    h1.XLabel = ' ';
    h1.YLabel = ' ';
    
    nexttile
    h2 = heatmap(sub_table, "Muscle", "Task", ColorVariable="GUEA_ses2");
    h2.Colormap = redbluecmap;
    h2.ColorLimits = [minValues, maxValues];
    h2.Title = 'Corset vs Chaise';
    h2.ColorbarVisible = 'on';
    h2.XLabel = ' ';
    h2.YLabel = ' ';
    
    % 2. AJOUT DU TITRE GÉNÉRAL
    title(t, 'CAI difference Comparison - GUEA', 'FontSize', 14);
    
    % 3. Optionnel : Ajouter un label commun pour les axes
    xlabel(t, 'Agonist Muscle Group');
    ylabel(t, 'Rehabilitation Tasks');
elseif subject == "RABA"
    minValues = min([sub_table.RABA_ses1; sub_table.RABA_ses2]);
    maxValues = max([sub_table.RABA_ses1; sub_table.RABA_ses2]);
    t = tiledlayout(1,2,TileSpacing="compact");
    nexttile
    h1 = heatmap(sub_table, "Muscle", "Task", ColorVariable="RABA_ses1");
    h1.Colormap = redbluecmap;
    h1.ColorLimits = [minValues, maxValues];
    h1.Title = 'JAECO vs DynaReach';
    h1.ColorbarVisible = 'off';
    h1.XLabel = ' ';
    h1.YLabel = ' ';
    
    nexttile
    h2 = heatmap(sub_table, "Muscle", "Task", ColorVariable="RABA_ses2");
    h2.Colormap = redbluecmap;
    h2.ColorLimits = [minValues, maxValues];
    h2.Title = 'Corset vs Chaise';
    h2.ColorbarVisible = 'on';
    h2.XLabel = ' ';
    h2.YLabel = ' ';
    
    title(t, 'CAI difference Comparison - RABA', 'FontSize', 14);
    xlabel(t, 'Agonist Muscle Group');
    ylabel(t, 'Rehabilitation Tasks');
end
end