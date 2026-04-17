
function heatmap_meanAct_diff(file_path, save_dir)

%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    file_path (1,1) string
    save_dir (1,1) string
end

results = readtable(file_path);

% Criteria = "Task-MeanAct_Muscle"
mask = contains(results.Criteria, 'MeanAct')& ...
    ~contains(results.Criteria, 'JAMAR')& ...
    ~contains(results.Criteria, 'Joystick');
    
sub_table = results(mask, :);

% Extract Task and Muscle
parts = split(sub_table.Criteria, "-MeanAct_");
sub_table.Task = replace(parts(:,1), '_', ' ');
sub_table.Muscle = parts(:,2);

% Define task order
taskOrder = [
    "Shoulder Flexion"
    "Elbow Flexion"
    "Pointing"
    "HFT LLO"
    "HFT spoon"
    "BBT"];
sub_table.Task = categorical(sub_table.Task, taskOrder, 'Ordinal', true);

% Get subject columns
vars = sub_table.Properties.VariableNames;
data_vars = vars(~ismember(vars, ["Criteria","Task","Muscle"]));

% Ensure save directory exists
if ~isfolder(save_dir)
    mkdir(save_dir);
end

% -------- FIGURE --------
fig = figure('Visible','off');
fig.Position(3:4) = [1100 500];
t = tiledlayout(1,length(data_vars));

% Loop over all columns
for i = 1:length(data_vars)

    nexttile

    h = heatmap(sub_table, "Muscle", "Task", ...
        ColorVariable=data_vars{i});

    h.Colormap = redblue();
    h.ColorLimits = [-100, 100];
    h.Title = strrep(data_vars{i}, "_", " ");
    h.XLabel = ' ';
    h.YLabel = ' ';

    % Show y-axis labels only on the first subplot
    if i ~= 1
        h.YDisplayLabels = repmat("", size(h.YDisplayLabels));
    end

    % Only one colorbar
    if i ~= length(data_vars)
        h.ColorbarVisible = 'off';
    end
end

% Global labels
title(t, "Comparaison des différence d'activation moyenne - Tous les sujets", 'FontSize', 14);
xlabel(t, 'Muscle');
ylabel(t, 'Tâches');

% Save
output_file = fullfile(save_dir, "heatmap_meanAct_diff.png");
exportgraphics(fig, output_file, 'Resolution', 300);

close(fig);

end