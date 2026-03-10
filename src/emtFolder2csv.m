function emtFolder2csv(folderPath)
% EMTFOLDER2CSV Convert all .emt files in a folder to CSV files.
%
%   emtFolder2csv(folderPath) converts every .emt file located in the
%   specified folder into a CSV file using the function EMT2CSV.
%
%   The CSV files are written in the same directory as the input files
%   and keep the same base filename.
%
%   Example
%       emtFolder2csv('C:\Data\EMG')
%
%   See also EMT2CSV, DIR, FULLFILE

    % ---- Check input argument ----
    if nargin < 1
        error('You must provide a folder path.');
    end

    % Verify that the folder exists
    if ~isfolder(folderPath)
        error('The specified folder does not exist: %s', folderPath);
    end

    % ---- Find all EMT files in the folder ----
    files = dir(fullfile(folderPath, '*.emt'));

    % If no files are found, notify the user
    if isempty(files)
        fprintf('No .emt files found in folder: %s\n', folderPath);
        return
    end

    fprintf('Found %d .emt files.\n', numel(files));

    % ---- Process each file ----
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