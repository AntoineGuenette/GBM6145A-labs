function emtFolder2csv(folderPath)
%EMTFOLDER2CSV Convert all EMT files in a folder to CSV format.
%
%   EMTFOLDER2CSV(folderPath) searches the specified folder for all files
%   with the ".emt" extension and converts each of them to a CSV file using
%   the EMT2CSV function.
%
%   For every EMT file found, a CSV file with the same base name is created
%   in the same directory.
%
%   Inputs:
%       folderPath - Path to the folder containing EMT files
%
%   Output:
%       None. The function converts each EMT file and saves the result
%       as a CSV file in the same folder.
%
%   Behavior:
%       - Validates that the provided folder exists.
%       - Searches for all ".emt" files in the folder.
%       - If no EMT files are found, a message is printed and the function
%         exits.
%       - Each file is converted sequentially and progress is printed to
%         the command window.
%
%   Example:
%       emtFolder2csv('C:\Data\EMG');
%
%   See also EMT2CSV, DIR, FULLFILE.

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