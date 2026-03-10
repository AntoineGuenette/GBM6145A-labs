function emt2csv(emtFile, csvFile)
%EMT2CSV Convert an EMT file to a CSV file.
%
%   EMT2CSV(emtFile) converts the specified EMT file to a CSV file with the
%   same name in the same directory.
%
%   EMT2CSV(emtFile, csvFile) converts the EMT file and writes the output
%   to the specified CSV file.
%
%   The function reads the EMT file, searches for the header line beginning
%   with "Frame", and then parses the numerical data that follows. The data
%   are assumed to contain the following columns:
%       Frame, Time, EMG_1, EMG_2, EMG_3, EMG_4, EMG_5, EMG_6
%
%   The extracted data are written to a CSV file with the corresponding
%   column headers.
%
%   Inputs:
%       emtFile - Path to the input EMT file
%       csvFile - (Optional) Path to the output CSV file
%
%   Output:
%       None. The function writes the converted data to a CSV file.
%
%   Example:
%       emt2csv('trial01.emt');
%       emt2csv('trial01.emt','trial01.csv');
%
%   Notes:
%       - The function automatically detects the start of the data by
%         locating the line beginning with "Frame".
%       - Empty lines in the EMT file are ignored.
%
%   See also WRITECELL, WRITEMATRIX.

if nargin < 2
    [p,n] = fileparts(emtFile);
    csvFile = fullfile(p,[n '.csv']);
end

fid = fopen(emtFile);

% Find the header line
while true
    line = fgetl(fid);
    if startsWith(strtrim(line),'Frame')
        break
    end
end

% Read first data line to determine number of columns
firstDataLine = fgetl(fid);
firstRow = str2num(firstDataLine); %#ok<ST2NM>

% Build column names
header = ["Frame","Time","EMG_1","EMG_2","EMG_3","EMG_4","EMG_5","EMG_6"];

% Read all data
data = firstRow;

while ~feof(fid)
    line = fgetl(fid);

    if isempty(line)
        continue
    end

    row = str2num(line); %#ok<ST2NM>

    if ~isempty(row)
        data = [data; row];
    end
end

fclose(fid);

% Write CSV
writecell(cellstr(header), csvFile)
writematrix(data, csvFile, 'WriteMode','append')

end