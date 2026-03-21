addpath("EMG_utils/")
addpath("files_utils/")
addpath("plots_utils/")
addpath("subject_utils/")

% Load subject info
subjects = get_subject_info();

% Convert .emt files to .csv files
FileNameDict_GUEA_ses1 = get_titles_GUEA_ses1();
emtFolder2csv('../data/GUEA_ses1', FileNameDict_GUEA_ses1);
FileNameDict_RABA_ses1 = get_titles_RABA_ses1();
emtFolder2csv('../data/RABA_ses1', FileNameDict_RABA_ses1);

% Create results file
results_path = '../res/results.csv';
initialize_results(results_path)
% Add non-EMG-related results
update_non_EMG_results(results_path)

% Define movement dictionary
movements = dictionary();
movements("Rest") = struct('agoniste', ["Bicep","Tricep"], 'antagoniste', ["DeltAnt","DeltPost"]);
movements("Shoulder_Flexion") = struct('agoniste', "DeltAnt", 'antagoniste', "DeltPost");
movements("Elbow_Flexion") = struct('agoniste', "Bicep", 'antagoniste', "Tricep");
movements("Pointing_Task") = struct('agoniste', ["Tricep","DeltAnt"], 'antagoniste', ["Bicep","DeltPost"]);
movements("HFT_Large_Light_Objects") = struct('agoniste', ["Bicep","DeltAnt"], 'antagoniste', ["Tricep","DeltPost"]);
movements("Switch_Joystick_and_Grid_Game") = struct('agoniste', ["Bicep","DeltAnt"], 'antagoniste', ["Tricep","DeltPost"]);
movements("JAMAR_Palmar_Grip") = struct('agoniste', "Bicep", 'antagoniste', "Tricep");
movements("HFT_Feeding_task") = struct('agoniste', "Bicep", 'antagoniste', "Tricep");
movements("Box_and_Blocs_Test") = struct('agoniste', ["Tricep","DeltAnt"], 'antagoniste', ["Bicep","DeltPost"]);

% ------- SUBJECT 1 / SESSION 1 --------

data_dir = "../data/GUEA_ses1";
files = dir(fullfile(data_dir, '*.csv'));
all_tracks_dir = "../figs/GUEA_ses1/all_tracks";
superimpose_dir = "../figs/GUEA_ses1/superimpose";
CAI_dir = "../figs/GUEA_ses1/CAI";

% -- Build all tracks plot --
fprintf("\nCreating all tracks plots for GUEA_ses1...\n")
for k = 1:numel(files)

    % Construct full input path
    emg_Path = fullfile(files(k).folder, files(k).name);

    % Get file name
    file_name = string(files(k).name);
    
    % Get title
    title = strrep(file_name, '.csv', '');
    save_path = fullfile(all_tracks_dir, title);
    title = strrep(title, '_', ' ');
    title = strrep(title, '-', ' - ');
     
    % Show all tracks
    if file_name == "Serie_3-Group_3-Task_31-JAMAR_Palmar_Grip-Device_(DynAReach).csv"
        plot_tracks(emg_Path, save_path, title, subjects(1).bmi, ...
        BicepTrack=1, TricepTrack=2, AntDeltTrack=5, PostDeltTrack=4)
    else
        plot_tracks(emg_Path, save_path, title, subjects(1).bmi)
    end

end
fprintf("All tracks plots successfully created for GUEA_ses1.\n")

% -- Build superimpose plots --
fprintf("\nCreating superimpose plots for GUEA_ses1...\n")
plot_all_superimpose(data_dir, superimpose_dir)
fprintf("All superimpose plots successfully created for GUEA_ses1.\n")

% -- Build CAI plots --
fprintf("\nComputing CAI for GUEA_ses1...\n")

% Store last Rest file per group
last_rest_file = "";

for k = 1:numel(files)

    file_name = string(files(k).name);
    file_path = fullfile(data_dir, file_name);

    % Parse filename
    info = parse_filename(file_path);

    % Skip invalid files
    if isnan(info.group) || info.task_name == ""
        continue;
    end

    % Identify Rest file (per group!)
    if contains(info.task_name, "Rest")
        last_rest_file = file_path;
        fprintf("Rest file detected: %s\n", file_name);
        continue;
    end

    % Find matching movement key
    keys_list = movements.keys();
    matchedKey = "";

    for i = 1:length(keys_list)
        if startsWith(info.task_name, keys_list(i))
            matchedKey = keys_list(i);
            break;
        end
    end

    % If match found → compute CAI
    if matchedKey ~= ""

        % Check if Rest exists
        if last_rest_file == ""
            warning("No Rest file available yet. Skipping %s", file_name);
            continue;
        end

        file_path_rest = last_rest_file;

        Ag = movements(matchedKey).agoniste;
        Antag = movements(matchedKey).antagoniste;

        for j = 1:length(Ag)
            find_CAI( ...
                last_rest_file, ...
                file_path, ...
                subjects(1).bmi, ...
                "Ag", Ag(j), ...
                "Antag", Antag(j), ...
                "title", info.task_name, ...
                "task", string(info.task), ...
                "save_folder", CAI_dir ...
            );
        end

    else
        warning("Task '%s' not recognized in dictionary.", info.task_name);
    end

end
fprintf("CAI computation completed for GUEA_ses1.\n")


% ------- SUBJECT 2 / SESSION 1 --------

data_dir = "../data/RABA_ses1";
files = dir(fullfile(data_dir, '*.csv'));
all_tracks_dir = "../figs/RABA_ses1/all_tracks";
superimpose_dir = "../figs/RABA_ses1/superimpose";
CAI_dir = "../figs/RABA_ses1/CAI";

% -- Build all tracks plot --
fprintf("\nCreating all tracks plots for RABA_ses1...\n")
for k = 1:numel(files)

    % Construct full input path
    emg_Path = fullfile(files(k).folder, files(k).name);

    % Get file name
    file_name = string(files(k).name);
    
    % Get title
    title = strrep(file_name, '.csv', '');
    save_path = fullfile(all_tracks_dir, title);
    title = strrep(title, '_', ' ');
    title = strrep(title, '-', ' - ');
     
    % Show all tracks
    plot_tracks(emg_Path, save_path, title, subjects(1).bmi)

end
fprintf("All tracks plots successfully created for RABA_ses1.\n")

% -- Build superimpose plots --
fprintf("\nCreating superimpose plots for RABA_ses1...\n")
plot_all_superimpose(data_dir, superimpose_dir)
fprintf("All superimpose plots successfully created for RABA_ses1.\n")

% -- Build CAI plots --
fprintf("\nComputing CAI for RABA_ses1...\n")

% Store last Rest file per group
last_rest_file = "";

for k = 1:numel(files)

    file_name = string(files(k).name);
    file_path = fullfile(data_dir, file_name);

    % Parse filename
    info = parse_filename(file_path);

    % Skip invalid files
    if isnan(info.group) || info.task_name == ""
        continue;
    end

    % Identify Rest file (per group!)
    if contains(info.task_name, "Rest")
        last_rest_file = file_path;
        fprintf("Rest file detected: %s\n", file_name);
        continue;
    end

    % Find matching movement key
    keys_list = movements.keys();
    matchedKey = "";

    for i = 1:length(keys_list)
        if startsWith(info.task_name, keys_list(i))
            matchedKey = keys_list(i);
            break;
        end
    end

    % If match found → compute CAI
    if matchedKey ~= ""

        % Check if Rest exists
        if last_rest_file == ""
            warning("No Rest file available yet. Skipping %s", file_name);
            continue;
        end

        file_path_rest = last_rest_file;

        Ag = movements(matchedKey).agoniste;
        Antag = movements(matchedKey).antagoniste;

        for j = 1:length(Ag)
            find_CAI( ...
                last_rest_file, ...
                file_path, ...
                subjects(1).bmi, ...
                "Ag", Ag(j), ...
                "Antag", Antag(j), ...
                "title", info.task_name, ...
                "task", string(info.task), ...
                "save_folder", CAI_dir ...
            );
        end

    else
        warning("Task '%s' not recognized in dictionary.", info.task_name);
    end

end
fprintf("CAI computation completed for RABA_ses1.\n")
