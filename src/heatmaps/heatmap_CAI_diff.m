function heatmap_CAI_diff(file_path, save_dir)

arguments (Input)
    file_path (1,1) string
    save_dir (1,1) string
end

results = readtable(file_path);

% ------ Filter CAI -------
mask = contains(results.Criteria, 'CAI');
sub_table = results(mask, :);

% Extract Task and Muscle
parts = split(sub_table.Criteria, "-CAI_");
sub_table.Task = replace(parts(:,1), '_', ' ');
sub_table.Muscle = parts(:,2);

% Define task order
taskOrder = [
    "Shoulder Flexion"
    "Elbow Flexion"
    "Pointing"
    "HFT LLO"
    "Joystick"
    "Jamar"
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
fig = figure('Visible', 'off');
t = tiledlayout(1,4,TileSpacing="compact",Padding="compact");

% Loop over all columns (assumes 4)
for i = 1:length(data_vars)

    nexttile

    h = heatmap(sub_table, "Muscle", "Task", ...
        ColorVariable=data_vars{i});

    h.Colormap = redblue();
    h.ColorLimits = [-100, 100];
    h.Title = strrep(data_vars{i}, "_", " ");
    h.XLabel = ' ';
    h.YLabel = ' ';

    % Keep only ONE colorbar (last plot)
    if i ~= length(data_vars)
        h.ColorbarVisible = 'off';
    end
end

% Global labels
title(t, "CAI Difference Comparison - All Subjects", 'FontSize', 14);
xlabel(t, 'Muscle pairs');
ylabel(t,  'Task');

% Save
output_file = fullfile(save_dir, "heatmap_CAI_diff.png");
exportgraphics(fig, output_file, 'Resolution', 300);

end

function cmap = redblue(m)
if nargin < 1
    m = 256;
end

bottom = [0 0 1];
middle = [1 1 1];
top = [1 0 0];

cmap = zeros(m,3);
for i = 1:m
    t = (i-1)/(m-1);
    if t < 0.5
        cmap(i,:) = (1-2*t)*bottom + (2*t)*middle;
    else
        cmap(i,:) = (1-2*(t-0.5))*middle + (2*(t-0.5))*top;
    end
end

end