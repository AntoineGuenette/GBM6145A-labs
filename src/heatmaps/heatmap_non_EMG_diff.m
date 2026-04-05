function heatmap_non_EMG_diff(file_path, save_dir)

arguments (Input)
    file_path (1,1) string
    save_dir (1,1) string
end

results = readtable(file_path);

% ------ Filter non-EMG -------
mask = ~contains(results.Criteria, 'CAI') & ...
       ~contains(results.Criteria, 'MeanAct');
sub_table = results(mask, :);

% Define task order
taskOrder = [
    "HFT LLO - time"
    "Joystick - time"
    "Jamar - force"
    "HFT spoon - time"
    "BBT - nb blocks"];

% Extract labels
% Convert criteria to display labels.
ylabels = strtrim(replace(sub_table.Criteria, '_', ' '));
ylabels = strtrim(replace(ylabels, '-', ' - '));

% Reorder rows to match the desired task order.
% We assign each row a rank based on the first matching task name.
taskRank = zeros(height(sub_table), 1);

for i = 1:length(taskOrder)
    matchIdx = startsWith(ylabels, taskOrder(i));
    taskRank(matchIdx) = i;
end

% Keep original order among rows belonging to the same task.
[~, sortIdx] = sort(taskRank);
sub_table = sub_table(sortIdx, :);
ylabels = ylabels(sortIdx);

% Get subject columns (auto)
vars = sub_table.Properties.VariableNames;
data_vars = vars(~ismember(vars, "Criteria"));

% Build data matrix
data = [];
for c = data_vars
    data = [data, sub_table.(c{1})];
end

xlabels = strrep(data_vars, "_", " ");

% -------- FIGURE --------
fig = figure('Visible','off');

h = heatmap(xlabels, ylabels, data);

h.Colormap = redblue();
h.ColorLimits = [-100, 100];

h.Title = 'Non-EMG Results';
h.XLabel = 'Subjects';
h.YLabel = 'Task';

% Ensure save directory exists
if ~isfolder(save_dir)
    mkdir(save_dir);
end

% Save
output_file = fullfile(save_dir, "heatmap_non_EMG.png");
exportgraphics(fig, output_file, 'Resolution', 300);

close(fig);

end