function emt2csv(emtFile, csvFile)

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