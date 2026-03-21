function initialize_CSV_results(file_path)

arguments
    file_path (1,1) string
end

    % Define header row
    header = {'Criteria','GUEA_ses1','RABA_ses1','GUEA_ses2','RABA_ses2'};

    % Define Criteria column
    criteria = { ...
        'Shoulder_Flexion-CAI_BiTri'
        'Shoulder_Flexion-CAI_Delt'
        'Elbow_Flexion-CAI_BiTri'
        'Elbow_Flexion-CAI_Delt'
        'Pointing-CAI_BiTri'
        'Pointing-CAI_Delt'
        'HFT_LLO-time'
        'HFT_LLO-CAI_BiTri'
        'HFT_LLO-CAI_Delt'
        'Joystick-time'
        'Joystick-CAI_BiTri'
        'Joystick-CAI_Delt'
        'Jamar-force'
        'Jamar-CAI_BiTri'
        'Jamar-CAI_Delt'
        'HFT_spoon-time'
        'HFT_spoon-CAI_BiTri'
        'HFT_spoon-CAI_Delt'
        'BBT-nb_blocks'
        'BBT-CAI_BiTri'
        'BBT-CAI_Delt'};

    nRows = numel(criteria);   % number of criteria rows

    % Initialize session columns with default value
    % Use "N/A" as string placeholder (to be filled later with [0..1])
    defaultVal = 'N/A';

    GUEA_ses1 = repmat({defaultVal}, nRows, 1);
    RABA_ses1 = repmat({defaultVal}, nRows, 1);
    GUEA_ses2 = repmat({defaultVal}, nRows, 1);
    RABA_ses2 = repmat({defaultVal}, nRows, 1);

    % Build full cell array: header + data
    dataBlock = [criteria, GUEA_ses1, RABA_ses1, GUEA_ses2, RABA_ses2];
    C = [header; dataBlock];

    % Write cell array to CSV file (overwrites existing file)
    writecell(C, file_path);
end
