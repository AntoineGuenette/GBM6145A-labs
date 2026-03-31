clear;
addpath("src/heatmaps")
file_path = "res/results.csv";

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

results = readtable(file_path);

% ------ Heatmap non CAI results -------
xlabels = {"GUEA ses1", "RABA ses1"};
% Creating a mask that only keeps non CAI indexes
mask = ~contains(results.Criteria, 'CAI');
% Only keeping non CAI data
data = [results.GUEA_ses1(mask), results.RABA_ses1(mask)];
% Only keeping non CAI tasks
ylabels = results.Criteria(mask);
new_ylabels = replace(ylabels, '_', ' ');

% Calculate the visual limit for the heatmap
C = [results.GUEA_ses1(mask);results.RABA_ses1(mask)];
limite_visuelle = quantile(abs(C), 0.95);

% Heatmap
h = heatmap(xlabels, new_ylabels, data);
h.Colormap = redbluecmap;
h.ColorLimits = [-limite_visuelle, limite_visuelle];

h.Title = 'Heatmap of ses 1 Results';
h.XLabel = 'Subject';
h.YLabel = 'Task';




