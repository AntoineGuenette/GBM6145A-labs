function heatmap_brut_CAI(file_path, subject)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    file_path (1,1) string
    subject (1,1) string
end

results = readtable(file_path);

% 1. Extract data for the subject only
mask_subject = contains(results.Subject, subject);
sub_table = results(mask_subject, :);

% Remove BIS and maintained force data
mask_bis = ~contains(sub_table.TaskName, "BIS");
sub_table = sub_table(mask_bis, :);

mask_maintained_force = ~contains(sub_table.TaskName, "Maintained");
sub_table = sub_table(mask_maintained_force, :);

% 2. Clean up the names of the agonist
mask_ceps = contains(sub_table.Agonist, "cep");
sub_table.Agonist(mask_ceps) = {'Biceps/Triceps'};

mask_delt = contains(sub_table.Agonist, "Delt");
sub_table.Agonist(mask_delt) = {'Deltoid Ant/Post'};

% 3. Clean up task names
sub_table.TaskName = replace(sub_table.TaskName, '_', ' ');

% 4. Make a table for baseline and device
mask_baseline = contains(sub_table.Modality, "Baseline");
mask_device = contains(sub_table.Modality, "Device");
baseline_table = sub_table(mask_baseline, :);
device_table = sub_table(mask_device, :);

% 5. Min and maxvalue for a better color distribution
minimal = min(sub_table.CAI);
maximal = max(sub_table.CAI);

% 6. Heatmaps 

% ------ HEATMAP BASELINE --------
nexttile
h1 = heatmap(baseline_table,"Agonist","TaskName", "ColorVariable","CAI");
h1.ColorLimits = [minimal, maximal];
h1.Colormap = cool;
% Customize heatmap appearance
h1.Title = 'CAI Heatmap - Baseline';
h1.XLabel = 'Agonist';
h1.YLabel = 'Task Name';
h1.ColorbarVisible = 'on';

% ------ HEATMAP DEVICE --------
nexttile
h2 = heatmap(device_table,"Agonist","TaskName", "ColorVariable","CAI");
h2.ColorLimits = [minimal, maximal];
h2.Colormap = cool;
% Customize heatmap appearance
h2.Title = 'CAI Heatmap - Device';
h2.XLabel = 'Agonist';
h2.YLabel = 'Task Name';
h2.ColorbarVisible = 'on';

end