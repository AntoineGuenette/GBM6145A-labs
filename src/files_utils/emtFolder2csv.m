function emtFolder2csv(folderPath, fileNameDict)

    arguments
        folderPath (1,1) string
        fileNameDict (1,1) containers.Map
    end

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

    % Notify the user if no files are found
    if isempty(files)
        fprintf('No .emt files found in folder: %s\n', folderPath);
        return
    end

    fprintf('\nFound %d .emt files.\n', numel(files));

    % Process each file
    counter = 0;
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
            counter = counter + 1;
        else
            fprintf('   -> Converting: %s\n', files(k).name);
            emt2csv(emtPath, csvPath);
        end
    end

    % Skip the conversion if the CSV files already exist
    if counter > 0
        fprintf('   -> Skipped conversion for %d/%d files because the CSV files already exist.\n', ...
                counter, numel(files));
    end


    fprintf('Conversion completed.\n');

end