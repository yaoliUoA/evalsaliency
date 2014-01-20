clear all; close all; 
addpath('./feature_util');
addpath('./edison_matlab_interface');
addpath('./matlabPyrTools');
%run('./vlfeat/toolbox/vl_setup');
dataset = 'MSRA1000';

MatSaveDir = ['./data/MeanShiftSegDir_',dataset,'_F/'];
if ~exist(MatSaveDir,'dir')
    mkdir(MatSaveDir);
end

readpath = ['../../Dataset/',dataset,'/*.bmp']; % path to dataset, you need to change this
ImgDir = dir(readpath);
assert(~isempty(ImgDir),'No image found, please check the path!');
for tt=1:length(ImgDir)
    str = ImgDir(tt).name;
    fprintf('\nRunning %s, %d images remain.\n',str,length(ImgDir)-tt);
    org_img = imread([readpath(1:end-5),str]);
    im = im2single(org_img);
    [fimage, labels, modes, regSize] = edison_wrapper(im, @ExtractFeature, 'SpatialBandWidth', 7, 'RangeBandWidth', 10, 'MinimumRegionArea', 20);%7,12,200
    segments = labels + 1;
    DestMatFilePath = sprintf('%s%s_ms.mat', MatSaveDir, str(1:end-4));
    save(DestMatFilePath, 'segments');
    clear im;
    clear segments;
    clear labels;
end