function emt2csv(emtFile, csvFile)
% EMT2CSV Convert a BTS .emt EMG file to CSV with column names

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
header = ["Frame","Time","EMG Signal 1","EMG Signal 2","EMG Signal 3","EMG Signal 4","EMG Signal 5","EMG Signal 6"];

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