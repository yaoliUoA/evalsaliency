%% A demo code to display overlap ratio values for evaluating salient object detection algorithms
% Yao Li, Jan 2014

clear all;%close all;
dataset = 'MSRA1000'; % name of the dataset
methods = {'hypergraph'}; % you can add more names of methods separated by comma
methods_colors = distinguishable_colors(length(methods));
resultpath = './result/OverlapRatio/';
num = length(methods);
for i = 1:num
    load(strcat(resultpath,dataset,'_',methods{i},'_OverlapRatio.mat'));
    fprintf('Overlap Ratio of %s: mean %.2f, std %.2f\n',methods{i},overlap_mean,overlap_std);
end