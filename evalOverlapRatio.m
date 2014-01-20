%% A demo code to compute overlap ratio for evaluating salient object detection algorithms
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
savepath = './result/OverlapRatio/'; % save path of the 256 combinations of precision-recall values
if ~exist(savepath,'dir')
    mkdir(savepath);
end
dir_im = dir(resultpath);
assert(~isempty(dir_im),'No saliency map found, please check the path!');
dir_tr= dir(truthpath);
assert(~isempty(dir_tr),'No ground-truth image found, please check the path!');
assert(length(dir_im)==length(dir_tr),'The number of saliency maps and ground-truth images are not equal!')
dir_tr = dir(truthpath);
imNum = length(dir_tr);
overlap = zeros(imNum,1);

%% compute overlap ratio
for i = 1:imNum
   imName = dir_tr(i).name;
   OverSegmentFilePath = strcat('./MeanShiftSegDir_',dataset,'_F/',imName(1:end-4),'_ms.mat');
   load(OverSegmentFilePath); % load segmentation
    
    input_im = imread([resultpath(1:end-5),imName(1:end-4),resultpath(end-3:end)]);
    truth_im = imread([truthpath(1:end-5),imName]);
    truth_im = truth_im(:,:,1);
    input_im = input_im(:,:,1);
    

    if max(max(truth_im))==255
        truth_im = truth_im./255;
    end
    
    spstats = regionprops(segments, 'PixelIdxList');
    num_region = max(segments(:));
    
    resultimg_smoothed = zeros(size(input_im));
    for ii=1:num_region
        resultimg_smoothed(spstats(ii).PixelIdxList) = mean(input_im(spstats(ii).PixelIdxList));
    end
    
    threshold = 2*mean2(resultimg_smoothed);
    index1 = (resultimg_smoothed>=threshold);
 %   imwrite(index1,[savepath_seg imName(1:end-4) '.png'],'png');
 %   imwrite(index1,[savepath_seg 'Image_' num2str(i) '.png'],'png');
    truePositive = length(find(index1 & truth_im));
    mm = length(find(index1 | truth_im));
    %groundTruth = length(find(truth_im));
    %detected = length(find(index1));
    
    if truePositive~=0
    overlap(i) = truePositive/mm;  
    else
    overlap(i) = 0;
    end
    display(num2str(i));
end
overlap_mean = mean(overlap);
overlap_std = std(overlap);
fprintf(' mean=%f, std=%f\n',overlap_mean,overlap_std);
save([savepath dataset '_' method '_OverlapRatio'],'overlap_mean','overlap_std');