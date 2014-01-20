%% A demo code to display ROC curve for evaluating salient object detection algorithms
% Yao Li, Jan 2014

clear all;%close all;
dataset = 'MSRA1000'; % name of the dataset
methods = {'hypergraph'}; % you can add more names of methods separated by comma
methods_colors = distinguishable_colors(length(methods));
readpath = './result/ROC/'; 

%% load PRCurve.txt and draw PR curves
figure
hold on   
for m = 1:length(methods)
    prFileName = strcat(readpath,dataset, '_', methods{m}, '_ROCcurve.txt');
    R = load(prFileName);    
    TPR = R(:, 1);
    FPR = R(:, 2); 
    plot(FPR,TPR, 'Color', methods_colors(m,:),'linewidth',2);    
end
axis([0 1 0 1]);
hold off
grid on

legend(methods, 'Location', 'SouthEast');
xlabel('False positive rate','fontsize',12);
ylabel('True positive rate','fontsize',12);