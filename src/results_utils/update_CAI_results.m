function update_CAI_results(input_path, output_path)
arguments (Input)
    input_path (1,1) string
    output_path (1,1) string
end

% --- Dictionaries ---
tasks = dictionary("Pointing_Task","Pointing", "HFT_Large_Light_Objects","HFT_LLO", ...
    "Switch_Joystick_and_Grid_Game","Joystick", "JAMAR_Palmar_Grip","Jamar", ...
    "JAMAR_Palmar_Grip_(Maintained_force)","Jamar", "HFT_Feeding_task","HFT_spoon", ...
    "Box_and_Blocs_Test","BBT");
subjects = dictionary("GUEA_ses1", 2, "RABA_ses1", 3, "GUEA_ses2", 4, "RABA_ses2", 5);
muscles = dictionary("Bicep","BiTri", "Tricep","BiTri", "DeltAnt","Delt", "DeltPost","Delt");

% --- Reading files ---
C1 = readcell(input_path);
C2 = readcell(output_path);

% --- STRUCTURE OF TEMPORARY STORAGE ---
% We create a struct to store the CAI : storage.Subject_Task_Muscle.Modality = [valeurs]
storage = struct();

for i = 2:size(C1, 1)
    subject  = string(C1{i, 2});
    modality = string(C1{i, 3});
    taskName = string(C1{i, 4});
    agonist  = string(C1{i, 5});
    CAI      = C1{i, 7};

    if ~isKey(subjects, subject) || ~isKey(muscles, agonist), continue; end

    % Not taking into account BIS result
    if contains(taskName, "BIS")
        continue
    end
    % Translating de task name for the unique key
    if isKey(tasks, taskName), tName = tasks(taskName);
    else, tName = taskName;
    end
    mType = muscles(agonist);

    % Creating a unique key (ex: RABA_ses1_HFT_LLO_Delt)

    safe_key = "s_" + subject + "_" + tName + "_" + mType;

    % Replacing dask by underscore to have a valid name
    safe_key = replace(safe_key, "-", "_");

    % Initialising the key in the storage if it doesn't exist
    if ~isfield(storage, safe_key)
        storage.(safe_key).Baseline    = [];
        storage.(safe_key).Device      = [];
        storage.(safe_key).subjectName = subject;
        storage.(safe_key).taskName    = tName;
        storage.(safe_key).muscleType  = mType;
    end

    % Accumulating the data
    if modality == "Baseline"
        storage.(safe_key).Baseline(end+1) = CAI;
    elseif modality == "Device"
        storage.(safe_key).Device(end+1) = CAI;
    end
end

% --- MEAN COMPUTING AND FILLING C2 ---

fields = fieldnames(storage);
for f = 1:length(fields)
    key  = fields{f};
    data = storage.(key);

    if ~isempty(data.Baseline) && ~isempty(data.Device)
        avg_J = mean(data.Baseline); % Baseline
        avg_D = mean(data.Device);   % Device

        diff_perc = compute_CAI_diff(avg_J, avg_D);

        subj_name    = data.subjectName;
        task_label   = data.taskName;
        muscle_label = data.muscleType;

        criteria = task_label + "-CAI_" + muscle_label;
        row = find(strcmp(string(C2(:,1)), criteria));
        col = subjects(subj_name);

        if ~isempty(row)
            C2{row, col} = diff_perc;
        end
    end
end

% --- FINAL WRITTING ---
writecell(C2, output_path);
end