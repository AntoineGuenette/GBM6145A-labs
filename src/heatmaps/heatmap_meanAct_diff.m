function heatmap_meanAct_diff(file_path, subject)
%UNTITLED4 Summary of this function goes here
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

mask_rest = ~contains(sub_table.TaskName, "Rest");
sub_table = sub_table(mask_rest, :);

mask_JAMAR = ~contains(sub_table.TaskName, "JAMAR");
sub_table = sub_table(mask_JAMAR, :);

%Clean up Task Names
sub_table.TaskName = replace(sub_table.TaskName, '_', ' ');

% Create a table for baseline and device
mask_baseline = contains(sub_table.Modality, "Baseline");
mask_device = contains(sub_table.Modality, "Device");
baseline_table = sub_table(mask_baseline, :);
device_table = sub_table(mask_device, :);

% Computes mean activation for tasknames and muscles
table_baseline = groupsummary(baseline_table, ["TaskName", "Muscle"], "mean", "MeanActivation");
table_device = groupsummary(device_table, ["TaskName", "Muscle"], "mean", "MeanActivation");

% Inner join between two tables 
combined_table = innerjoin(table_baseline, table_device, 'Keys', {'TaskName', 'Muscle'});

% Computes difference
combined_table.Difference = ((combined_table.mean_MeanActivation_table_device - combined_table.mean_MeanActivation_table_baseline)./combined_table.mean_MeanActivation_table_baseline) * 100;

% Heatmap
h = heatmap(combined_table, "Muscle", "TaskName", ColorVariable="Difference");
h.Colormap = redbluecmap;
h.Title = 'Mean Activation for each muscle [%] - ' + replace(subject,"_", " ");
h.XLabel = 'Muscle';
h.YLabel = 'Task Name';
h.ColorbarVisible = 'on';
end