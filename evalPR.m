%% A demo code to compute precision-recall curve for evaluating salient object detection algorithms
% Yao Li, Jan 2014
% please cite our paper "Contextual Hypergraph Modeling for Salient Object
% Detection", ICCV 2013, if you use the code in your research
%% initialization
clear all
close all;clc;
method = 'hypergraph'; % name of the salient object method you want to evaluate, you need to change this
dataset = 'MSRA1000'; % name of dataset, you need to change this
resultpath = ['../../Result/',dataset,'/',method,'/*.png']; % path to saliency maps, you need to change this
truthpath = ['../../Dataset/',dataset,'_binarymasks/*.bmp']; % path to ground-truth masks, yoiu need to change this
savepath = './result/PRcurve/'; % save path of the 256 combinations of precision-recall values
if ~exist(savepath,'dir')
    mkdir(savepath);
end
dir_im = dir(resultpath);
assert(~isempty(dir_im),'No saliency map found, please check the path!');
dir_tr= dir(truthpath);
assert(~isempty(dir_tr),'No ground-truth image found, please check the path!');
assert(length(dir_im)==length(dir_tr),'The number of saliency maps and ground-truth images are not equal!')
imNum = length(dir_tr);
precision = zeros(256,1);
recall = zeros(256,1);

%% compute pr curve
for i = 1:imNum
  imName = dir_tr(i).name;
  input_im = imread([resultpath(1:end-5),imName(1:end-4),resultpath(end-3:end)]);
  truth_im = imread([truthpath(1:end-5),imName]);
  truth_im = truth_im(:,:,1);
  input_im = input_im(:,:,1);
  if max(max(truth_im))==255
        truth_im = truth_im./255;
  end
   for threshold = 0:255
    index1 = (input_im>=threshold);
    truePositive = length(find(index1 & truth_im));
    groundTruth = length(find(truth_im));
    detected = length(find(index1));
    if truePositive~=0
     precision(threshold+1) = precision(threshold+1)+truePositive/detected;
     recall(threshold+1) = recall(threshold+1)+truePositive/groundTruth;
    end
    end
    display(num2str(i));
end
precision = precision./imNum;
recall = recall./imNum;
pr = [precision'; recall'];
fid = fopen([savepath dataset, '_', method, '_PRCurve.txt'],'at');
fprintf(fid,'%f %f\n',pr);
fclose(fid);
disp('Done!');
