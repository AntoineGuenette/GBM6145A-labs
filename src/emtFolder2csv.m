function emtFolder2csv(folderPath)

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
        [~, name] = fileparts(files(k).name);
        csvPath = fullfile(files(k).folder, [name '.csv']);

        fprintf('Converting: %s\n', files(k).name);

        % Convert file using the previously defined function
        emt2csv(emtPath, csvPath);

    end

    fprintf('Conversion completed.\n');

end