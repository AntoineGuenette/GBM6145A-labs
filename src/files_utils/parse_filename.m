function info = parse_filename(file_path)

    % Initialize all fields
    info = struct( ...
        'serie', NaN, ...
        'group', NaN, ...
        'task', "", ...
        'task_name', "", ...
        'modality', "" ...
    );

    % Get file name
    [~, name, ~] = fileparts(file_path);

    % Split
    parts = split(name, "-");

    % Safety check
    if numel(parts) < 5
        warning("Filename mal formé: %s", name);
        return;
    end

    % Extract values
    info.serie = double(str2double(erase(parts(1), "Serie_")));
    info.group = double(str2double(erase(parts(2), "Group_")));
    info.task  = erase(parts(3), "Task_");
    info.task_name = string(parts(4));

    % Extract device
    modality_token = string(parts(5));
    if startsWith(modality_token, "Baseline")
        info.modality = "Baseline";
    else
        info.modality = "Device";
    end

end