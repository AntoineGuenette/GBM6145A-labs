function update_CAI_results(input_path, output_path)

arguments (Input)
    input_path (1,1) string
    output_path (1,1) string
end

% --- Définition des dictionnaires ---
tasks = dictionary(...
    "Pointing_Task", "Pointing", ...
    "HFT_Large_Light_Objects", "HFT_LLO", ...
    "Switch_Joystick_and_Grid_Game", "Joystick", ...
    "JAMAR_Palmar_Grip", "Jamar", ...
    "JAMAR_Palmar_Grip_(Maintained_force)", "Jamar", ...
    "HFT_Feeding_task", "HFT_spoon", ...
    "Box_and_Blocs_Test", "BBT");

subjects = dictionary("GUEA_ses1", 2, "RABA_ses1", 3, "GUEA_ses2", 4, "RABA_ses2", 5);

muscles = dictionary("Bicep", "BiTri", "Tricep", "BiTri", "DeltAnt", "Delt", "DeltPost", "Delt");

% --- Lecture des fichiers ---
C1 = readcell(input_path);
C2 = readcell(output_path);

% --- Traitement ---
% Note: On boucle deux fois ou on s'assure que JAECO est traité d'abord.
% Ici, on traite ligne par ligne comme ton original.

for i = 2:size(C1, 1)
    go_ahead = 0;
    subject  = string(C1{i, 2});
    device   = string(C1{i, 3});
    taskName = string(C1{i, 4});
    agonist  = string(C1{i, 5});
    CAI      = C1{i, 7}; % Assure-toi que c'est bien un double

    % Validation de l'existence dans les dictionnaires
    if ~isKey(subjects, subject) || ~isKey(muscles, agonist)
        fprintf("Warning: Données manquantes pour %s ou %s à la ligne %d\n", subject, agonist, i);
        continue; 
    end

    % Gestion des tâches spéciales
    if isKey(tasks, taskName)
        task = tasks(taskName);
    elseif taskName == "Shoulder_Flexion" || taskName == "Elbow_Flexion"
        task = taskName;
    else
        fprintf("Warning: Task %s non reconnue\n", taskName);
        continue;
    end

    muscleType = muscles(agonist);
    criteria = task + "-CAI_" + muscleType;
    
    % Identification de la cellule cible
    row = find(strcmp(string(C2(:,1)), criteria));
    col = subjects(subject);

    if isempty(row)
        fprintf("Warning: Critère %s non trouvé dans le fichier de sortie\n", criteria);
        continue;
    end

    % On récupère le contenu actuel de la cellule
    current_val = C2{row, col};
    current_val_str = string(current_val);

    % LOGIQUE DE CALCUL "ONE-SHOT"
    if device == "JAECO" && (current_val_str == "N/A" || current_val_str == "")
        % ÉTAPE 1 : On remplit le JAECO seulement si la case est vierge
        C2{row, col} = CAI; 
        
    elseif device == "DynAReach"
        % ÉTAPE 2 : On ne calcule que si la case contient un NOMBRE (le JAECO)
        % isnumeric vérifie que c'est un chiffre, et on ajoute une sécurité :
        % on ne veut pas recalculer si c'est déjà un résultat de duo précédent.
        
        if isnumeric(current_val) && ~isempty(current_val)
            % On vérifie si ce n'est pas déjà un pourcentage calculé.
            % Une astuce simple : dans tes données, un CAI brut dépasse rarement 100,
            % mais pour être 100% sûr, on peut utiliser un flag ou simplement 
            % accepter que le premier DynAReach qui passe gagne.
            
            baseline = current_val; % C'est notre JAECO
            diff_perc = (abs(baseline - CAI) / baseline) * 100;


            
            % Pour empêcher un 2ème DynAReach de ré-utiliser ce pourcentage :
            % On transforme la valeur en texte, ainsi 'isnumeric' sera faux au prochain tour.
            C2{row, col} = sprintf('%.2f', diff_perc); 
        end
    end
end

% --- Écriture finale (Hors de la boucle) ---
writecell(C2, output_path);
fprintf("Mise à jour terminée avec succès.\n");

end

