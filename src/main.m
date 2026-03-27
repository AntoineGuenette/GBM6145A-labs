% Define directories
script_path = mfilename('fullpath');
[src_dir, ~, ~] = fileparts(script_path);
data_dir = fullfile(src_dir, "..", "data");
figs_dir = fullfile(src_dir, "..", "figs");
res_dir = fullfile(src_dir, "..", "res");

% Define sub-directories and files
GUEA_ses1_data_dir = fullfile(data_dir, "GUEA_ses1");
GUEA_ses2_data_dir = fullfile(data_dir, "GUEA_ses2");
RABA_ses1_data_dir = fullfile(data_dir, "RABA_ses1");
RABA_ses2_data_dir = fullfile(data_dir, "RABA_ses2");
GUEA_ses1_figs_dir = fullfile(figs_dir, "GUEA_ses1");
GUEA_ses2_figs_dir = fullfile(figs_dir, "GUEA_ses2");
RABA_ses1_figs_dir = fullfile(figs_dir, "RABA_ses1");
RABA_ses2_figs_dir = fullfile(figs_dir, "RABA_ses2");
results_path = fullfile(res_dir, "results.csv");
CAI_results_path = fullfile(res_dir, "resultsCAI.csv");

% Load functions
addpath(fullfile(src_dir, "EMG_utils"))
addpath(fullfile(src_dir, "files_utils"))
addpath(fullfile(src_dir, "plots_utils"))
addpath(fullfile(src_dir, "results_utils"))
addpath(fullfile(src_dir, "subject_utils"))

% Load subject info
subjects = get_subject_info();

% Convert .emt files to .csv files
FileNameDict_GUEA_ses1 = get_titles_GUEA_ses1();
emtFolder2csv(GUEA_ses1_data_dir, FileNameDict_GUEA_ses1);
FileNameDict_RABA_ses1 = get_titles_RABA_ses1();
emtFolder2csv(RABA_ses1_data_dir, FileNameDict_RABA_ses1);
FileNameDict_GUEA_ses2 = get_titles_GUEA_ses2();
emtFolder2csv(GUEA_ses2_data_dir, FileNameDict_GUEA_ses2);

% Define movement dictionary
movements = dictionary();
movements("Rest") = struct('agoniste', ["Bicep","Tricep"], 'antagoniste', ["DeltAnt","DeltPost"]);
movements("Shoulder_Flexion") = struct('agoniste', "DeltAnt", 'antagoniste', "DeltPost");
movements("Elbow_Flexion") = struct('agoniste', "Bicep", 'antagoniste', "Tricep");
movements("Pointing_Task") = struct('agoniste', ["Tricep","DeltAnt"], 'antagoniste', ["Bicep","DeltPost"]);
movements("HFT_Large_Light_Objects") = struct('agoniste', ["Bicep","DeltAnt"], 'antagoniste', ["Tricep","DeltPost"]);
movements("Switch_Joystick_and_Grid_Game") = struct('agoniste', ["Bicep","DeltAnt"], 'antagoniste', ["Tricep","DeltPost"]);
movements("JAMAR_Palmar_Grip") = struct('agoniste', ["Bicep","DeltAnt"], 'antagoniste', ["Tricep","DeltPost"]);
movements("HFT_Feeding_task") = struct('agoniste', ["Bicep","DeltAnt"], 'antagoniste', ["Tricep","DeltPost"]);
movements("Box_and_Blocs_Test") = struct('agoniste', ["Tricep","DeltAnt"], 'antagoniste', ["Bicep","DeltPost"]);

% ------- SUBJECT 1 / SESSION 1 --------

sub_data_dir = GUEA_ses1_data_dir;
sub_figs_dir = GUEA_ses1_figs_dir;
files = dir(fullfile(sub_data_dir, '*.csv'));
all_tracks_dir = fullfile(sub_figs_dir, "all_tracks");
superimpose_dir = fullfile(sub_figs_dir, "superimpose");
CAI_dir = fullfile(sub_figs_dir, "CAI");

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
plot_all_superimpose_study_1(sub_data_dir, superimpose_dir)
fprintf("All superimpose plots successfully created for GUEA_ses1.\n")

% -- Build CAI plots --
fprintf("\nComputing CAI for GUEA_ses1...\n")

% Store last Rest file per group
last_rest_file = "";

for k = 1:numel(files)

    file_name = string(files(k).name);
    file_path = fullfile(sub_data_dir, file_name);

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
                "save_folder", CAI_dir, ...
                "save_csv", CAI_results_path, ...
                "subject","GUEA_ses1", ...
                "modality", info.modality ...
            );
        end

    else
        warning("Task '%s' not recognized in dictionary.", info.task_name);
    end

end
fprintf("CAI computation completed for GUEA_ses1.\n")


% ------- SUBJECT 2 / SESSION 1 --------

sub_data_dir = RABA_ses1_data_dir;
sub_figs_dir = RABA_ses1_figs_dir;
files = dir(fullfile(sub_data_dir, '*.csv'));
all_tracks_dir = fullfile(sub_figs_dir, "all_tracks");
superimpose_dir = fullfile(sub_figs_dir, "superimpose");
CAI_dir = fullfile(sub_figs_dir, "CAI");

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
plot_all_superimpose_study_1(sub_data_dir, superimpose_dir)
fprintf("All superimpose plots successfully created for RABA_ses1.\n")

% -- Build CAI plots --
fprintf("\nComputing CAI for RABA_ses1...\n")

% Store last Rest file per group
last_rest_file = "";

for k = 1:numel(files)

    file_name = string(files(k).name);
    file_path = fullfile(sub_data_dir, file_name);

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
                subjects(2).bmi, ...
                "Ag", Ag(j), ...
                "Antag", Antag(j), ...
                "title", info.task_name, ...
                "task", string(info.task), ...
                "save_folder", CAI_dir, ...
                "save_csv", CAI_results_path, ...
                "subject", "RABA_ses1", ...
                "modality", info.modality ...
            );
        end

    else
        warning("Task '%s' not recognized in dictionary.", info.task_name);
    end

end
fprintf("CAI computation completed for RABA_ses1.\n")

% ------- SUBJECT 1 / SESSION 2 --------

sub_data_dir = GUEA_ses2_data_dir;
sub_figs_dir = GUEA_ses2_figs_dir;
files = dir(fullfile(sub_data_dir, '*.csv'));
all_tracks_dir = fullfile(sub_figs_dir, "all_tracks");
superimpose_dir = fullfile(sub_figs_dir, "superimpose");
CAI_dir = fullfile(sub_figs_dir, "CAI");

% -- Build all tracks plot --
fprintf("\nCreating all tracks plots for GUEA_ses2...\n")
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
    if any(file_name == [ ...
        "Serie_4-Group_3-Task_42-HFT_Feeding_task-Device_(Brace)", ...
        "Serie_4-Group_3-Task_43-Box_and_Blocs_Test-Device_(Brace)"])
        plot_tracks(emg_Path, save_path, title, subjects(3).bmi, ...
        BicepTrack=1, TricepTrack=2, AntDeltTrack=5, PostDeltTrack=4)
    else
        plot_tracks(emg_Path, save_path, title, subjects(3).bmi)
    end

end
fprintf("All tracks plots successfully created for GUEA_ses2.\n")

% -- Build superimpose plots --
fprintf("\nCreating superimpose plots for GUEA_ses2...\n")
plot_all_superimpose_study_2(sub_data_dir, superimpose_dir)
fprintf("All superimpose plots successfully created for GUEA_ses2.\n")

% -- Build CAI plots --
fprintf("\nComputing CAI for GUEA_ses2...\n")

% Store last Rest file per group
last_rest_file = "";

for k = 1:numel(files)

    file_name = string(files(k).name);
    file_path = fullfile(sub_data_dir, file_name);

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
                subjects(3).bmi, ...
                "Ag", Ag(j), ...
                "Antag", Antag(j), ...
                "title", info.task_name, ...
                "task", string(info.task), ...
                "save_folder", CAI_dir, ...
                "save_csv", CAI_results_path, ...
                "subject","GUEA_ses2", ...
                "modality", info.modality ...
            );
        end

    else
        warning("Task '%s' not recognized in dictionary.", info.task_name);
    end

end
fprintf("CAI computation completed for GUEA_ses2.\n")

% Create results file
fprintf("\nCreating results CSV file...\n")
initialize_results(results_path)

% Add non-EMG-related results
update_non_EMG_results(results_path)

% Add CAI results
update_CAI_results(CAI_results_path, results_path);
fprintf("Results have been written in %s\n", results_path)
