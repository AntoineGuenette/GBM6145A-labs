function heatmap_CAI_diff(file_path, save_dir)

    arguments (Input)
        file_path (1,1) string
        save_dir (1,1) string
    end
    
    %% PREPARE DATA

    results = readtable(file_path);

    % Filter CAI
    mask = contains(results.Criteria, 'CAI');
    sub_table = results(mask, :);
    
    % Extract task and muscle
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
    
    %% CREATE FIGURE
    fig = figure('Visible', 'off');
    fig.Position(3:4) = [700 500];
    t = tiledlayout(1,4);
    
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
    
        % Keep one color bar
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