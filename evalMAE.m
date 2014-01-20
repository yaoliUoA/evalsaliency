%% A demo code to compute mean Mean Absolute Error (MAE) for evaluating salient object detection algorithms
% Yao Li, Jan 2014
% please cite our paper "Contextual Hypergraph Modeling for Salient Object
% Detection", ICCV 2013, if you use the code in your research
% MAE is proposed by "Saliency Filters: Contrast Based Filtering for
% Salient Region Detection", CVPR 2012
%% initialization
clear all
close all;clc;
method = 'hypergraph'; % name of the salient object method you want to evaluate, you need to change this
dataset = 'MSRA1000'; % name of dataset, you need to change this
resultpath = ['../../Result/',dataset,'/',method,'/*.png']; % path to saliency maps, you need to change this
truthpath = ['../../Dataset/',dataset,'_binarymasks/*.bmp']; % path to ground-truth masks, yoiu need to change this
savepath = './result/MAE/'; % save path of the 256 combinations of precision-recall values
if ~exist(savepath,'dir')
    mkdir(savepath);
end
dir_im = dir(resultpath);
assert(~isempty(dir_im),'No saliency map found, please check the path!');
dir_tr= dir(truthpath);
assert(~isempty(dir_tr),'No ground-truth image found, please check the path!');
assert(length(dir_im)==length(dir_tr),'The number of saliency maps and ground-truth images are not equal!')
imNum = length(dir_tr);
MAE = 0;
%% compute MAE
for i = 1:imNum
  imName = dir_tr(i).name;
  input_im = imread([resultpath(1:end-5),imName(1:end-4),resultpath(end-3:end)]);
  input_im = double(input_im(:,:,1))./255;
  truth_im = imread([truthpath(1:end-5),imName]);
  truth_im = double(truth_im(:,:,1));
  if max(max(truth_im))==255
        truth_im = truth_im./255;
  end
  MAE = MAE + mean2(abs(truth_im-input_im));
  display(num2str(i));
end
MAE = MAE/imNum;
fprintf('MAE=%f\n',MAE);
save([savepath dataset '_' method '_MAE'],'MAE');

    
    