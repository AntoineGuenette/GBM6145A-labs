function subjects = get_subject_info()

% General infos
subjects(1).code = '1_GUEA';
subjects(1).height_cm = 171;
subjects(1).weight_kg = 53;

subjects(2).code = 'Unknown';
subjects(2).height_cm = 0.1;
subjects(2).weight_kg = 0.1;

subjects(3).code = 'Unknown';
subjects(3).height_cm = 0.1;
subjects(3).weight_kg = 0.1;

subjects(4).code = 'Unknown';
subjects(4).height_cm = 0.1;
subjects(4).weight_kg = 0.1;

% Compute BMI
for i = 1:numel(subjects)
    subjects(i).bmi = subjects(i).weight_kg / (subjects(i).height_cm/100)^2;
end

% Non-EMG scores (task group 2)
subjects(1).HFT_LLWObj_1_JAECO_s = 'Unknown' ;
subjects(1).HFT_LLWObj_2_JAECO_s = 'Unknown' ;
subjects(1).HFT_LLWObj_3_DynAReach_s = 'Unknown' ;
subjects(1).HFT_LLWObj_4_DynAReach_s = 'Unknown' ;
subjects(1).joystick_1_JAECO_s = 'Unknown' ;
subjects(1).joystick_2_JAECO_s = 'Unknown' ;
subjects(1).joystick_3_DynAReach_s = 'Unknown' ;
subjects(1).joystick_4_DynAReach_s = 'Unknown' ;

subjects(2).HFT_LLWObj_1_JAECO_s = 'Unknown' ;
subjects(2).HFT_LLWObj_2_JAECO_s = 'Unknown' ;
subjects(2).HFT_LLWObj_3_DynAReach_s = 'Unknown' ;
subjects(2).HFT_LLWObj_4_DynAReach_s = 'Unknown' ;
subjects(2).joystick_1_JAECO_s = 'Unknown' ;
subjects(2).joystick_2_JAECO_s = 'Unknown' ;
subjects(2).joystick_3_DynAReach_s = 'Unknown' ;
subjects(2).joystick_4_DynAReach_s = 'Unknown' ;

subjects(3).HFT_LLWObj_1_JAECO_s = 'Unknown' ;
subjects(3).HFT_LLWObj_2_JAECO_s = 'Unknown' ;
subjects(3).HFT_LLWObj_3_DynAReach_s = 'Unknown' ;
subjects(3).HFT_LLWObj_4_DynAReach_s = 'Unknown' ;
subjects(3).joystick_1_JAECO_s = 'Unknown' ;
subjects(3).joystick_2_JAECO_s = 'Unknown' ;
subjects(3).joystick_3_DynAReach_s = 'Unknown' ;
subjects(3).joystick_4_DynAReach_s = 'Unknown' ;

subjects(4).HFT_LLWObj_1_JAECO_s = 'Unknown' ;
subjects(4).HFT_LLWObj_2_JAECO_s = 'Unknown' ;
subjects(4).HFT_LLWObj_3_DynAReach_s = 'Unknown' ;
subjects(4).HFT_LLWObj_4_DynAReach_s = 'Unknown' ;
subjects(4).joystick_1_JAECO_s = 'Unknown' ;
subjects(4).joystick_2_JAECO_s = 'Unknown' ;
subjects(4).joystick_3_DynAReach_s = 'Unknown' ;
subjects(4).joystick_4_DynAReach_s = 'Unknown' ;

% Non-EMG scores (task group 3)
subjects(1).JAMAR_1_JAECO_kg = 'Unknown';
subjects(1).JAMAR_2_JAECO_kg = 'Unknown';
subjects(1).JAMAR_3_JAECO_kg = 'Unknown';
subjects(1).JAMAR_4_DynAReach_kg = 'Unknown';
subjects(1).HFT_spoon_1_JAECO_s = 'Unknown' ;
subjects(1).HFT_spoon_2_JAECO_s = 'Unknown' ;
subjects(1).HFT_spoon_3_JAECO_s = 'Unknown' ;
subjects(1).HFT_spoon_4_DynAReach_s = 'Unknown' ;
subjects(1).BBT_1_JAECO = 'Unknown';
subjects(1).BBT_2_JAECO = 'Unknown';
subjects(1).BBT_3_JAECO = 'Unknown';
subjects(1).BBT_4_DynAReach = 'Unknown';

subjects(2).JAMAR_1_JAECO_kg = 'Unknown';
subjects(2).JAMAR_2_JAECO_kg = 'Unknown';
subjects(2).JAMAR_3_JAECO_kg = 'Unknown';
subjects(2).JAMAR_4_DynAReach_kg = 'Unknown';
subjects(2).HFT_spoon_1_JAECO_s = 'Unknown' ;
subjects(2).HFT_spoon_2_JAECO_s = 'Unknown' ;
subjects(2).HFT_spoon_3_JAECO_s = 'Unknown' ;
subjects(2).HFT_spoon_4_DynAReach_s = 'Unknown' ;
subjects(2).BBT_1_JAECO = 'Unknown';
subjects(2).BBT_2_JAECO = 'Unknown';
subjects(2).BBT_3_JAECO = 'Unknown';
subjects(2).BBT_4_DynAReach = 'Unknown';

subjects(3).JAMAR_1_JAECO_kg = 'Unknown';
subjects(3).JAMAR_2_JAECO_kg = 'Unknown';
subjects(3).JAMAR_3_JAECO_kg = 'Unknown';
subjects(3).JAMAR_4_DynAReach_kg = 'Unknown';
subjects(3).HFT_spoon_1_JAECO_s = 'Unknown' ;
subjects(3).HFT_spoon_2_JAECO_s = 'Unknown' ;
subjects(3).HFT_spoon_3_JAECO_s = 'Unknown' ;
subjects(3).HFT_spoon_4_DynAReach_s = 'Unknown' ;
subjects(3).BBT_1_JAECO = 'Unknown';
subjects(3).BBT_2_JAECO = 'Unknown';
subjects(3).BBT_3_JAECO = 'Unknown';
subjects(3).BBT_4_DynAReach = 'Unknown';

subjects(4).JAMAR_1_JAECO_kg = 'Unknown';
subjects(4).JAMAR_2_JAECO_kg = 'Unknown';
subjects(4).JAMAR_3_JAECO_kg = 'Unknown';
subjects(4).JAMAR_4_DynAReach_kg = 'Unknown';
subjects(4).HFT_spoon_1_JAECO_s = 'Unknown' ;
subjects(4).HFT_spoon_2_JAECO_s = 'Unknown' ;
subjects(4).HFT_spoon_3_JAECO_s = 'Unknown' ;
subjects(4).HFT_spoon_4_DynAReach_s = 'Unknown' ;
subjects(4).BBT_1_JAECO = 'Unknown';
subjects(4).BBT_2_JAECO = 'Unknown';
subjects(4).BBT_3_JAECO = 'Unknown';
subjects(4).BBT_4_DynAReach = 'Unknown';

end