%% A demo code to compute mean Mean Absolute Error (MAE) for evaluating salient object detection algorithms
% Yao Li, Jan 2014
% please cite our paper "Contextual Hypergraph Modeling for Salient Object
% Detection", ICCV 2013, if you use the code in your research
% MAE is proposed by "Saliency Filters: Contrast Based Filtering for
% Salient Region Detection", CVPR 2012

clear all;%close all;
dataset = 'MSRA1000'; % name of the dataset
methods = {'hypergraph'}; % you can add more names of methods separated by comma
methods_colors = distinguishable_colors(length(methods));
readpath = './result/MAE/'; 


num = length(methods);
MAE_all = zeros(num,1);
for i = 1:num
    load(strcat(readpath,dataset,'_',methods{i},'_MAE.mat'));
    MAE_all(i) = MAE;
end
h = bar(MAE_all,'r');
grid on;
set(gca,'YLim',[0 0.45]); 
set(gca,'YTick',0:0.05:0.45);
set(gca,'xticklabel',methods);
%xlabel(strcat('Methods (', dataset, ')'));
%ylabel('Mean Absolute Error');