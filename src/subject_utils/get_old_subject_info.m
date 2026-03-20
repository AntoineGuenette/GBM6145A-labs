function subjects = get_old_subject_info()

% General infos
subjects(1).code = '1_SCHP';
subjects(1).height_cm = 165;
subjects(1).weight_kg = 59;

subjects(2).code = '3_MICA';
subjects(2).height_cm = 171;
subjects(2).weight_kg = 57;

subjects(3).code = '4_STAV';
subjects(3).height_cm = 165;
subjects(3).weight_kg = 70;

subjects(4).code = '5_ROSA';
subjects(4).height_cm = 158;
subjects(4).weight_kg = 52;

% Compute BMI
for i = 1:numel(subjects)
    subjects(i).bmi = subjects(i).weight_kg / (subjects(i).height_cm/100)^2;
end

% Non-EMG scores
subjects(1).BBT_wouth = 57;
subjects(1).BBT_with = 55;
subjects(1).jamar_wouth = 30.5;
subjects(1).jamar_with = 34;

subjects(2).BBT_wouth = 68;
subjects(2).BBT_with = 63;
subjects(2).jamar_wouth = 34;
subjects(2).jamar_with = 32.5;

subjects(3).BBT_wouth = 76;
subjects(3).BBT_with = 71;
subjects(3).jamar_wouth = 27;
subjects(3).jamar_with = 30;

subjects(4).BBT_wouth = 62;
subjects(4).BBT_with = 66;
subjects(4).jamar_wouth = 32;
subjects(4).jamar_with = 35;

end