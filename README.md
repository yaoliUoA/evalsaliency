evalsaliency
============

Welcome to evalsaliency, a Matlab toolbox for evaluating salient object detection algorithms. 
This toolbox has been utilized to achieve experimental result presented in the following paper: 

##[Xi Li](http://cs.adelaide.edu.au/~xi/Xi_Li.html), [Yao Li](cs.adelaide.edu.au/~yaoli/), [Chunhua Shen](http://cs.adelaide.edu.au/~chhshen/), [Anthony Dick](http://cs.adelaide.edu.au/~ard/), [Anton van den Hengel](http://cs.adelaide.edu.au/~hengel/). Contextual Hypergraph Modeling for Salient Object Detection, ICCV 2013. [PDF](http://cs.adelaide.edu.au/~yaoli/wp-content/projects/HypergraphSaliency/Paper/iccv13_saliency.pdf) | [Project page](http://cs.adelaide.edu.au/~yaoli/?page_id=149). 

Please cite this paper if you use this toolbox in your research. 

MATLAB Quick Start Guide
=====================
To get started, please ensure that MATLAB has been installed and then download the toolbox from Github. The toolbox has been tested on Linux. 

##Evaluation criteria included

The current version of the evalsaliency toolbox contains five evaluation criteria used in salient object detection algorithms, including precision-recall curve, receiver operating characteristic curve, f-measure, mean absolute error and overlap ratio. 

##Folders and files

The "data" folder contains mean-shift segmentation of each image in a dataset. We have provided precomputed segmentation of two benchmark datasets, [MSRA1000](http://ivrgwww.epfl.ch/supplementary_material/RK_CVPR09/index.html)(ASD) and [BSD300](http://elderlab.yorku.ca/SOD/)(SOD).    
 
The "result" folder contains five subfolders, corresponding to result of five evaluation criteria.

"matlabPyrTools", "feature_util" and "edison_matlab_interface" are thee folders contain files to compute mean-shift segmentation. 

"eval*.m" are Matlab scripts for computing the five evaluation criteria. 
"draw*.m" are Matlab scripts for displaying result. 

##Computing precision-recall curve, receiver operating characteristic curve and mean absolute error

You need to change four variables in the corresponding "eval*.m" , including "method", "dataset", "resultpath" and "truthpath" and then run the script. 

##Computing f-measure and overlap ratio

As both f-measure and overlap ratio are rely on mean-shift segmentation, you need to ensure segmentations of the dataset are exist in the "data" folder. If exist, you then change the aforementioned four variables before running the script. If not, you need run "ExtractMeanShiftSegmentationMask.m" first to compute mean-shift segmentation. 

##Display result

After computing "eval*.m", you can run "draw*.m" to see figures. Keep in mind that you also need to change the four variables in the "draw*.m".

##Questions and feedback

If you have any questions or feedback, please email to yao.li01@adelaide.edu.au

 





