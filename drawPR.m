%% A demo code to display precision-recall curve for evaluating salient object detection algorithms
% Yao Li, Jan 2014

clear all;%close all;
dataset = 'MSRA1000'; % name of the dataset
methods = {'hypergraph'}; % you can add more names of methods separated by comma
methods_colors = distinguishable_colors(length(methods));
readpath = './result/PRcurve/'; 

%% load PRCurve.txt and draw PR curves
figure
hold on
for m = 1:length(methods)
    prFileName = strcat(readpath,dataset, '_', methods{m}, '_PRCurve.txt');
    R = load(prFileName);
    precision = R(:, 1);
    recall = R(:, 2);
    plot(recall, precision,'color',methods_colors(m,:),'linewidth',2);    
end
axis([0 1 0 1]);
hold off
grid on;
legend(methods, 'Location', 'SouthWest');
xlabel('Recall','fontsize',12);
ylabel('Precision','fontsize',12);
