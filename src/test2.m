file_path1 = "data/GUEA_ses1/0038~aa~t3.csv";

data1 = readtable(file_path1);
time = data1.Time;

minSTD = true;
h = 3;
EMG1_conditionned = method_2_Tm(file_path1, h, "minSTD",true, "EMG","EMG_1");
EMG2_conditionned = method_2_Tm(file_path1, h, "minSTD",true, "EMG","EMG_2");
EMG3_conditionned = method_2_Tm(file_path1, h, "minSTD",true, "EMG","EMG_3");
EMG4_conditionned = method_2_Tm(file_path1, h, "minSTD",true, "EMG","EMG_4");


A_Bicep = trapz(time, EMG1_conditionned);
A_Tricep = trapz(time, EMG2_conditionned);
A_Delt_Ant = trapz(time, EMG3_conditionned);
A_Delt_Post = trapz(time, EMG4_conditionned);

area_common = min(EMG1_conditionned, EMG2_conditionned);
A_common = trapz(time, area_common);
CAI = 2 * (A_common/(A_Bicep + A_Tricep)) * 100;
% Prepare the figure for plotting
figure

plot(time, EMG1_conditionned)
hold on
plot(time, EMG2_conditionned)
hold on
plot(time, area_common)
title('Bicep')
xlabel('Time (s)')
ylabel('Amplitude')
 
