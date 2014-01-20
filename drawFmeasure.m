%% Draw F-measure
clear all;%close all;
dataset = 'MSRA1000';
methods = {'hypergraph'};%,
num = length(methods);
p = zeros(num,1);
r = zeros(num,1);
resultpath = './result/Fmeasure/';
for i = 1:num
    load(strcat(resultpath,dataset,'_',methods{i},'_Fmeasure_meanshift.mat'));
    p(i) = precision;
    r(i) = recall;
end
f = 1.3.*p.*r./(0.3.*p+r);
%h = bar([roundn(p,-2),roundn(r,-2),roundn(f,-2)],'hist');
h = bar([p,r,f],'hist');
set(h(1),'FaceColor','b');
set(h(2),'FaceColor','r');
set(h(3),'FaceColor','y');
set(gca,'YLim',[0 1]); 
set(gca,'XLim',[0 num+1]);
set(gca,'xticklabel',methods,'fontsize',12);
%set(gca,'xticklabel',methods2);
grid on;
legend('Precision','Recall','F-measure','Orientation','horizonal');
%xlabel(strcat('Methods (', dataset, ')'));
set(legend,'FontSize',10);