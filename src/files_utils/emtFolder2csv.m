function emtFolder2csv(folderPath, fileNameDict)

    % Check input argument
    if nargin < 1
        error('You must provide a folder path.');
    end

    % Verify that the folder exists
    if ~isfolder(folderPath)
        error('The specified folder does not exist: %s', folderPath);
    end

    % Find all EMT files in the folder
    files = dir(fullfile(folderPath, '*.emt'));

    % If no files are found, notify the user
    if isempty(files)
        fprintf('No .emt files found in folder: %s\n', folderPath);
        return
    end

    fprintf('\nFound %d .emt files.\n', numel(files));

    % Process each file
    for k = 1:numel(files)

        % Construct full input path
        emtPath = fullfile(files(k).folder, files(k).name);

        % Construct output CSV path
        emtName = string(files(k).name);
        task_name = fileNameDict(emtName);
        csvName = [task_name '.csv'];
        csvPath = fullfile(files(k).folder, csvName);

        % Convert file if the CSV does not exist
        if isfile(csvPath)
            fprintf('Skipping since %s already exists.\n', csvName);
            continue;
        else
            fprintf('Converting: %s\n', files(k).name);
            emt2csv(emtPath, csvPath);
        end

    end

    fprintf('Conversion completed.\n');

end