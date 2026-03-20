% Load subject info
subjects = get_subject_info();

% Convert .emt files to .csv files
FileNameDict_GUEA_ses1 = get_titles_GUEA_ses1();
emtFolder2csv('../data/GUEA_ses1', FileNameDict_GUEA_ses1);
FileNameDict_RABA_ses1 = get_titles_RABA_ses1();
emtFolder2csv('../data/RABA_ses1', FileNameDict_RABA_ses1);

% ------- SUBJECT 1 / SESSION 1 --------

save_dir = "../figs/GUEA_ses1/all_tracks";
fprintf("\nCreating plots for GUEA_ses1...\n")

% Process each file in the folder
files = dir(fullfile('../data/GUEA_ses1', '*.csv'));
for k = 1:numel(files)

    % Construct full input path
    emg_Path = fullfile(files(k).folder, files(k).name);

    % Get file name
    file_name = string(files(k).name);
    
    % Get title
    title = strrep(file_name, '.csv', '');
    save_path = fullfile(save_dir, title);
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
fprintf("All plots successfully created\n")

% ------- SUBJECT 2 / SESSION 1 --------

save_dir = "../figs/RABA_ses1/all_tracks";
fprintf("\nCreating plots for RABA_ses1...\n")

% Process each file in the folder
files = dir(fullfile('../data/RABA_ses1', '*.csv'));
for k = 1:numel(files)

    % Construct full input path
    emg_Path = fullfile(files(k).folder, files(k).name);

    % Get file name
    file_name = string(files(k).name);
    
    % Get title
    title = strrep(file_name, '.csv', '');
    save_path = fullfile(save_dir, title);
    title = strrep(title, '_', ' ');
    title = strrep(title, '-', ' - ');
     
    % Show all tracks
    plot_tracks(emg_Path, save_path, title, subjects(2).bmi)

end
fprintf("All plots successfully created...\n")
