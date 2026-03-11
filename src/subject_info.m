function subjects = subject_info()

% General infos
subjects(1).code = '1_SCHP';
subjects(1).age = 22.7833;
subjects(1).dominant_limb = 'R';
subjects(1).height_cm = 165;
subjects(1).weight_kg = 59;


subjects(2).code = '3_MICA';
subjects(2).age = 24.0333;
subjects(2).dominant_limb = 'R';
subjects(2).height_cm = 171;
subjects(2).weight_kg = 57;

subjects(3).code = '4_ZERM';
subjects(3).age = 22.6167;
subjects(3).dominant_limb = 'R';
subjects(3).height_cm = 167;
subjects(3).weight_kg = 60;

subjects(4).code = '5_ROSA';
subjects(4).age = 23.6583;
subjects(4).dominant_limb = 'R';
subjects(4).height_cm = 158;
subjects(4).weight_kg = 52;

% Compute BMI
for i = 1:numel(subjects)
    subjects(i).bmi = subjects(i).weight_kg / (subjects(i).height_cm/100)^2;
end

% Non-EMG scores (task group 2)
subjects(1).HFT_LLWObj_1_JAECO_s = 10 ;
subjects(1).HFT_LLWObj_2_JAECO_s = 10 ;
subjects(1).HFT_LLWObj_3_DynAReach_s = 10 ;
subjects(1).HFT_LLWObj_4_DynAReach_s = 10 ;
subjects(1).joystick_1_JAECO_s = 10 ;
subjects(1).joystick_2_JAECO_s = 10 ;
subjects(1).joystick_3_DynAReach_s = 10 ;
subjects(1).joystick_4_DynAReach_s = 10 ;

subjects(2).HFT_LLWObj_1_JAECO_s = 10 ;
subjects(2).HFT_LLWObj_2_JAECO_s = 10 ;
subjects(2).HFT_LLWObj_3_DynAReach_s = 10 ;
subjects(2).HFT_LLWObj_4_DynAReach_s = 10 ;
subjects(2).joystick_1_JAECO_s = 10 ;
subjects(2).joystick_2_JAECO_s = 10 ;
subjects(2).joystick_3_DynAReach_s = 10 ;
subjects(2).joystick_4_DynAReach_s = 10 ;

subjects(3).HFT_LLWObj_1_JAECO_s = 10 ;
subjects(3).HFT_LLWObj_2_JAECO_s = 10 ;
subjects(3).HFT_LLWObj_3_DynAReach_s = 10 ;
subjects(3).HFT_LLWObj_4_DynAReach_s = 10 ;
subjects(3).joystick_1_JAECO_s = 10 ;
subjects(3).joystick_2_JAECO_s = 10 ;
subjects(3).joystick_3_DynAReach_s = 10 ;
subjects(3).joystick_4_DynAReach_s = 10 ;

subjects(4).HFT_LLWObj_1_JAECO_s = 10 ;
subjects(4).HFT_LLWObj_2_JAECO_s = 10 ;
subjects(4).HFT_LLWObj_3_DynAReach_s = 10 ;
subjects(4).HFT_LLWObj_4_DynAReach_s = 10 ;
subjects(4).joystick_1_JAECO_s = 10 ;
subjects(4).joystick_2_JAECO_s = 10 ;
subjects(4).joystick_3_DynAReach_s = 10 ;
subjects(4).joystick_4_DynAReach_s = 10 ;

% Non-EMG scores (task group 3)
subjects(1).JAMAR_1_JAECO_kg = 53;
subjects(1).JAMAR_2_JAECO_kg = 53;
subjects(1).JAMAR_3_JAECO_kg = 53;
subjects(1).JAMAR_4_DynAReach_kg = 53;
subjects(1).HFT_spoon_1_JAECO_s = 10 ;
subjects(1).HFT_spoon_2_JAECO_s = 10 ;
subjects(1).HFT_spoon_3_JAECO_s = 10 ;
subjects(1).HFT_spoon_4_DynAReach_s = 10 ;
subjects(1).BBT_1_JAECO = 57;
subjects(1).BBT_2_JAECO = 57;
subjects(1).BBT_3_JAECO = 55;
subjects(1).BBT_4_DynAReach = 55;

subjects(2).JAMAR_1_JAECO_kg = 53;
subjects(2).JAMAR_2_JAECO_kg = 53;
subjects(2).JAMAR_3_JAECO_kg = 53;
subjects(2).JAMAR_4_DynAReach_kg = 53;
subjects(2).HFT_spoon_1_JAECO_s = 10 ;
subjects(2).HFT_spoon_2_JAECO_s = 10 ;
subjects(2).HFT_spoon_3_JAECO_s = 10 ;
subjects(2).HFT_spoon_4_DynAReach_s = 10 ;
subjects(2).BBT_1_JAECO = 57;
subjects(2).BBT_2_JAECO = 57;
subjects(2).BBT_3_JAECO = 55;
subjects(2).BBT_4_DynAReach = 55;

subjects(3).JAMAR_1_JAECO_kg = 53;
subjects(3).JAMAR_2_JAECO_kg = 53;
subjects(3).JAMAR_3_JAECO_kg = 53;
subjects(3).JAMAR_4_DynAReach_kg = 53;
subjects(3).HFT_spoon_1_JAECO_s = 10 ;
subjects(3).HFT_spoon_2_JAECO_s = 10 ;
subjects(3).HFT_spoon_3_JAECO_s = 10 ;
subjects(3).HFT_spoon_4_DynAReach_s = 10 ;
subjects(3).BBT_1_JAECO = 57;
subjects(3).BBT_2_JAECO = 57;
subjects(3).BBT_3_JAECO = 55;
subjects(3).BBT_4_DynAReach = 55;

subjects(4).JAMAR_1_JAECO_kg = 53;
subjects(4).JAMAR_2_JAECO_kg = 53;
subjects(4).JAMAR_3_JAECO_kg = 53;
subjects(4).JAMAR_4_DynAReach_kg = 53;
subjects(4).HFT_spoon_1_JAECO_s = 10 ;
subjects(4).HFT_spoon_2_JAECO_s = 10 ;
subjects(4).HFT_spoon_3_JAECO_s = 10 ;
subjects(4).HFT_spoon_4_DynAReach_s = 10 ;
subjects(4).BBT_1_JAECO = 57;
subjects(4).BBT_2_JAECO = 57;
subjects(4).BBT_3_JAECO = 55;
subjects(4).BBT_4_DynAReach = 55;

end