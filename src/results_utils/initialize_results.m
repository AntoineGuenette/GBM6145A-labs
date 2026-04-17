function initialize_results(file_path)

    arguments
        file_path (1,1) string
    end

    % Define header row
    header = {'Criteria','GUEA_ses1','RABA_ses1','GUEA_ses2','RABA_ses2'};

    % Define criteria column
    criteria = { ...
        'Shoulder_Flexion-CAI_Delt'
        'Shoulder_Flexion-MeanAct_Bicep'
        'Shoulder_Flexion-MeanAct_Tricep'
        'Shoulder_Flexion-MeanAct_DeltAnt'
        'Shoulder_Flexion-MeanAct_DeltPost'
        
        'Elbow_Flexion-CAI_BiTri'
        'Elbow_Flexion-MeanAct_Bicep'
        'Elbow_Flexion-MeanAct_Tricep'
        'Elbow_Flexion-MeanAct_DeltAnt'
        'Elbow_Flexion-MeanAct_DeltPost'
        
        'Pointing-CAI_BiTri'
        'Pointing-CAI_Delt'
        'Pointing-MeanAct_Bicep'
        'Pointing-MeanAct_Tricep'
        'Pointing-MeanAct_DeltAnt'
        'Pointing-MeanAct_DeltPost'
        
        'HFT_LLO-time'
        'HFT_LLO-CAI_BiTri'
        'HFT_LLO-CAI_Delt'
        'HFT_LLO-MeanAct_Bicep'
        'HFT_LLO-MeanAct_Tricep'
        'HFT_LLO-MeanAct_DeltAnt'
        'HFT_LLO-MeanAct_DeltPost'
        
        'Joystick-time'
        'Joystick-CAI_BiTri'
        'Joystick-CAI_Delt'
        'Joystick-MeanAct_Bicep'
        'Joystick-MeanAct_Tricep'
        'Joystick-MeanAct_DeltAnt'
        'Joystick-MeanAct_DeltPost'
        
        'Jamar-force'
        'Jamar-CAI_BiTri'
        'Jamar-CAI_Delt'
        'Jamar-MeanAct_Bicep'
        'Jamar-MeanAct_Tricep'
        'Jamar-MeanAct_DeltAnt'
        'Jamar-MeanAct_DeltPost'
        
        'HFT_spoon-time'
        'HFT_spoon-CAI_BiTri'
        'HFT_spoon-CAI_Delt'
        'HFT_spoon-MeanAct_Bicep'
        'HFT_spoon-MeanAct_Tricep'
        'HFT_spoon-MeanAct_DeltAnt'
        'HFT_spoon-MeanAct_DeltPost'
        
        'BBT-nb_blocks'
        'BBT-CAI_BiTri'
        'BBT-CAI_Delt'
        'BBT-MeanAct_Bicep'
        'BBT-MeanAct_Tricep'
        'BBT-MeanAct_DeltAnt'
        'BBT-MeanAct_DeltPost'};

    nRows = numel(criteria);   % number of criteria rows

    % Initialize session columns with default value ("N/A")
    defaultVal = 'N/A';

    GUEA_ses1 = repmat({defaultVal}, nRows, 1);
    RABA_ses1 = repmat({defaultVal}, nRows, 1);
    GUEA_ses2 = repmat({defaultVal}, nRows, 1);
    RABA_ses2 = repmat({defaultVal}, nRows, 1);

    % Build full cell array: header + data
    dataBlock = [criteria, GUEA_ses1, RABA_ses1, GUEA_ses2, RABA_ses2];
    C = [header; dataBlock];

    % Write cell array to CSV file
    writecell(C, file_path);
end
