addpath("src/subject_utils/")
addpath("src/plots_utils/")
addpath("src/EMG_utils/")
addpath("src/files_utils/")

cheminDossier = "data/GUEA_ses1";
subjects = get_subject_info();
bmi = subjects(1).bmi;

listeFichiers = dir(fullfile(cheminDossier, '*.csv'));

% --- Définition du dictionnaire ---
mouvements = dictionary();
mouvements("Rest") = struct('agoniste', ["Bicep","Tricep"], 'antagoniste', ["DeltAnt","DeltPost"]);
mouvements("Shoulder_Flexion") = struct('agoniste', "DeltAnt", 'antagoniste', "DeltPost");
mouvements("Elbow_Flexion") = struct('agoniste', "Bicep", 'antagoniste', "Tricep");
mouvements("Pointing_Task") = struct('agoniste', ["Tricep","DeltAnt"], 'antagoniste', ["Bicep","DeltPost"]);
mouvements("HFT_Large_Light_Objects") = struct('agoniste', ["Bicep","DeltAnt"], 'antagoniste', ["Tricep","DeltPost"]);
mouvements("Switch_Joystick_and_Grid_Game") = struct('agoniste', ["Bicep","DeltAnt"], 'antagoniste', ["Tricep","DeltPost"]);
mouvements("JAMAR_Palmar_Grip") = struct('agoniste', "Bicep", 'antagoniste', "Tricep");
mouvements("HFT_Feeding_task") = struct('agoniste', "Bicep", 'antagoniste', "Tricep");
mouvements("Box_and_Blocs_Test") = struct('agoniste', ["Tricep","DeltAnt"], 'antagoniste', ["Bicep","DeltPost"]);

% Initialisation de file_path1 pour éviter les erreurs si le premier fichier n'est pas Rest
file_path1 = ""; 
tousLesMouvements = mouvements.keys();

% --- Boucle de traitement ---
for i = 1:length(listeFichiers)
    nomFichier = listeFichiers(i).name;
    parts = split(nomFichier, "-");
    
    if length(parts) < 4, continue; end
    
    taskFull = string(parts{4}); 
    task = string(parts{3});
    
    % Cas spécial pour le repos
    if contains(taskFull, "Rest")
        file_path1 = nomFichier;
        fprintf("Fichier de repos identifié : %s\n", nomFichier);
        continue; % On passe au fichier suivant
    end

    % --- Recherche de la clé dans le dictionnaire ---
    allKeys = mouvements.keys();
    matchedKey = "";
    
    for k = 1:length(allKeys)
        if startsWith(taskFull, allKeys(k))
            matchedKey = allKeys(k);
            break; 
        end
    end

    % --- Traitement si une correspondance est trouvée ---
    if matchedKey ~= ""
        file_path2 = nomFichier;
        
        if file_path1 == ""
            warning("Fichier de tâche détecté avant un fichier Rest. Saut de %s", nomFichier);
            continue;
        end

        Ag = mouvements(matchedKey).agoniste;
        Antag = mouvements(matchedKey).antagoniste;
        
        for j = 1:length(Ag)
            % Appel de la fonction avec les indices extraits
            CAI = find_CAI(fullfile(cheminDossier, file_path1), ...
                           fullfile(cheminDossier, file_path2), ...
                           bmi, "Ag", Ag(j), "Antag", Antag(j), "title",taskFull, "task",task);
        end
    else
        warning("La tâche '%s' n'est pas reconnue dans le dictionnaire.", taskFull);
    end
end

% --- Test d'affichage final ---
tache_test = "Pointing_Task";
indices_texte = string(mouvements(tache_test).agoniste); 
disp("Agonistes pour " + tache_test + " : " + strjoin(indices_texte, ', '));
