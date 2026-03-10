function subject = subject_info()

subject.code = '5_ROSA' ;
subject.age = 23.6583 ;
subject.dominant_limb = 'R' ;

subject.height_cm = 158 ;
subject.weight_kg = 52 ;
subject.bmi = subject.weight_kg / (subject.height_cm / 100)^2;

subject.L_hum_length_cm = 25.5 ;
subject.R_hum_length_cm = 25.5 ;
subject.L_for_length_cm = 21.0 ;
subject.R_for_length_cm = 23.0 ;
subject.L_midarm_width_cm = 26.5 ;
subject.R_midarm_width_cm = 27.5 ;
subject.L_midfor_width_cm = 20.75 ;
subject.R_midfor_width_cm = 21.5 ;
subject.shosho_ext_length_cm = 44 ;
subject.L_elb_width_cm = 5.95 ;
subject.R_elb_width_cm = 5.85 ;
subject.L_spi_to_scap_cm = 8.5 ;
subject.R_spi_to_scap_cm = 9.0 ;
subject.L_spi_to_shou_cm = 29.0 ;
subject.R_spi_to_shou_cm = 27.0 ;
subject.L_shou_height_cm = 47.0 ;
subject.R_shou_height_cm = 46.0 ;

subject.for_weight_kg = 0.45 ;
subject.arm_for_weight_kg = 3.55 ;

subject.L_shou_to_back_poles_cm = 10.5 ;
subject.R_shou_to_back_poles_cm = 10.0 ;
subject.chair_back_ext_width_cm = 41 ;

end