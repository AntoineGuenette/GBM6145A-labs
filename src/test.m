
clear;
addpath("src/EMG_utils/")
addpath("src/files_utils/")
addpath("src/plots_utils/")
addpath("src/results_utils")
addpath("src/subject_utils/")

% Load subject info

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

input_path = "res/resultsCAI.csv";
output_path = "res/results.csv";

update_CAI_results(input_path, output_path);
