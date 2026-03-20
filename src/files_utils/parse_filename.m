function info = parse_filename(file_path)

    % Initialize all fields
    info = struct( ...
        'serie', NaN, ...
        'group', NaN, ...
        'task', NaN, ...
        'task_name', "", ...
        'device', "" ...
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
    info.task  = double(str2double(erase(parts(3), "Task_")));
    info.task_name = string(parts(4));

    % Extract device
    token = regexp(parts(5), '\((.*?)\)', 'tokens', 'once');
    if ~isempty(token)
        info.device = string(token{1});
    else
        info.device = "Unknown";
    end

end