function superimpose_EMG(file_path1, file_path2, file_path3, file_path4)

file_paths = [file_path1, file_path2, file_path3, file_path4];
subjects = get_subject_info();

max_len = 0;
max_path = '';

for file_path = file_paths
    data = readtable(file_path);
    [rows, ~] = size(data.Time);
    if rows > max_len
        max_len = rows; % Update max_len if current rows are greater
        max_path = file_path;
    end

end

tracks_1 = zeros(max_len, 4);
tracks_2 = zeros(max_len, 4);
tracks_3 = zeros(max_len, 4);
tracks_4 = zeros(max_len, 4);

for i = 1:4
    data = readtable(file_paths(i));
    [rows, ~] = size(data.Time);
    tracks_1(1:rows,i) = process_EMG(data.EMG_1, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
    tracks_2(1:rows, i) = process_EMG(data.EMG_2, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
    tracks_3(1:rows, i) = process_EMG(data.EMG_3, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
    tracks_4(1:rows, i) = process_EMG(data.EMG_4, data.Time, 1000,subjects(1).bmi, ShowGraph = false);
end
data_time = readtable(max_path);
time = data_time.Time;
       figure
       sgtitle('Repos - Comparaison JAECO vs DynaReach');
       subplot(4,1,1)
       plot(time, tracks_1(:,1), "r-", "LineWidth",1);
       hold on
       plot(time, tracks_1(:,2), "b-", "LineWidth",1);
       hold on
       plot(time, tracks_1(:,3), "g-", "LineWidth",1);
       hold on
       plot(time, tracks_1(:,4), "y-", "LineWidth",1);
       hold off;
       xlabel('Time (s)');
       ylabel('EMG Signal');
       title('Biceps brachial');
       legend('JAECO', 'DynaReach 1', 'DynaReach 2', 'DynaReach 4');

       subplot(4,1,2)
       plot(time, tracks_2(:,1), "r-", "LineWidth",1);
       hold on
       plot(time, tracks_2(:,2), "b-", "LineWidth",1);
       hold on
       plot(time, tracks_2(:,3), "g-", "LineWidth",1);
       hold on
       plot(time, tracks_2(:,4), "y-", "LineWidth",1);
       hold off;
       xlabel('Time (s)');
       ylabel('EMG Signal');
       title('Tricep brachial');
       legend('JAECO', 'DynaReach 1', 'DynaReach 2', 'DynaReach 4');

        
       subplot(4,1,3)
       plot(time, tracks_3(:,1), "r-", "LineWidth",1);
       hold on
       plot(time, tracks_3(:,2), "b-", "LineWidth",1);
       hold on
       plot(time, tracks_3(:,3), "g-", "LineWidth",1);
       hold on
       plot(time, tracks_3(:,4), "y-", "LineWidth",1);
       hold off;
       xlabel('Time (s)');
       ylabel('EMG Signal');
       title('Deltoide antérieure');
       legend('JAECO', 'DynaReach 1', 'DynaReach 2', 'DynaReach 4');


       subplot(4,1,4)
       plot(time, tracks_4(:,1), "r-", "LineWidth",1);
       hold on
       plot(time, tracks_4(:,2), "b-", "LineWidth",1);
       hold on
       plot(time, tracks_4(:,3), "g-", "LineWidth",1);
       hold on
       plot(time, tracks_4(:,4), "y-", "LineWidth",1);
       hold off;
       xlabel('Time (s)');
       ylabel('EMG Signal');
       title('Deltoide postérieure');
       legend('JAECO', 'DynaReach 1', 'DynaReach 2', 'DynaReach 4');
end