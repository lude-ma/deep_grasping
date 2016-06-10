clear variables
close all
clc
% Set these to the paths to your folders containing the Cornell Grasping
% Dataset 
% (this folder should contain a lot of pcd_* files)
dataDir = fullfile(pwd, 'data', 'rawDataSet');
fprintf('I will look for raw data in %s.\n', dataDir);
% (this folder should contain a lot of pcdb_* files)
bgDir = fullfile(pwd, 'data', 'bgDataSet');
fprintf('I will look for background data in %s.\n', bgDir);

%% Load the grasping dataset
cd loadData/
[depthFeat, colorFeat, normFeat, classes, inst, accepted, depthMask, colorMask]  = loadAllGraspingDataImYUVNormals(dataDir);
classes = logical(classes);

%% Process data, splitting into train/test sets and whitening
cd ../processData/
processGraspData

%% Train Network
cd ../recTraining/
trainGraspRecMultiSparse

cd ../

% Workspace will be pretty messy here, but I don't like putting a clear all
% in this script, since you might have your own stuff there that you don't
% want to lose.