% Load subject info
old_subjects = get_old_subject_info();
subjects = get_subject_info();

% Convert .emt files to .csv files
emtFolder2csv('../data_old/1_SCHP')
emtFolder2csv('../data_old/3_MICA')
emtFolder2csv('../data_old/4_STAV')
emtFolder2csv('../data_old/5_ROSA')

emtFolder2csv('../data/GUEA_ses1')

% ------- SUBJECT 1 --------

save_dir = "../figs/GUEA_ses1/all_tracks";
titles = get_titles_GUEA_ses1();

% Process each file in the folder
files = dir(fullfile('../data/GUEA_ses1', '*.csv'));
for k = 1:numel(files)

    % Construct full input path
    emg_Path = fullfile(files(k).folder, files(k).name);

    % Get file name
    file_name = string(files(k).name);
    save_path = fullfile(save_dir, titles(file_name));

    % Get test name and deduce title
    test_name = titles(file_name);
    title = strrep(test_name, '_', ' ');
    title = strrep(title, '-', ' - ');
    
    % Show all tracks
    if file_name == "0038~aa~t31.csv"
        plot_tracks(emg_Path, save_path, title, subjects(1).bmi, ...
        BicepTrack=1, TricepTrack=2, AntDeltTrack=5, PostDeltTrack=4)
    else
        plot_tracks(emg_Path, save_path, title, subjects(1).bmi)
    end

end

