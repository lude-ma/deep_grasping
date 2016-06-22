function [bestRect, bestScore] = evaluateFile(instNum, dataDir)
    str = strsplit(dataDir, '/');
    if strcmp(str{end}, 'rawDataSet')
        bgDir = '../../data/bgDataSet';
        imgFN = sprintf('%s/pcd%04dr.png', dataDir, instNum);
        pcdFN = sprintf('%s/pcd%04d.txt', dataDir, instNum);
        load ../../data/bgNums.mat
        bgFN = sprintf('%s/pcdb%04dr.png', bgDir, bgNo(instNum));
    else
        bgDir = dataDir;
        imgFN = sprintf('%s/pcd%04dr.jpg', dataDir, instNum);
        pcdFN = sprintf('%s/pcd%04d.pcd', dataDir, instNum);
        bgFN = sprintf('%s/pcdb%04dr.jpg', bgDir, 1);
    end
    
    I = double(imread(imgFN));
    BG = double(imread(bgFN));
    assert(isequal(size(I), size(BG)), 'DeepGrasping:IBGsize', ...
        'Image and Background must have same dimension!')
    
    if strcmp(str{end}, 'rawDataSet')
        [points, imPoints] = readGraspingPcd(pcdFN);
        D = zeros(size(I,2), size(I,1));
        D(imPoints) = points(:,3);
        D = D';
    else
        D = loadpcd(pcdFN);
        D = double(D(:,:,3));
    end
    assert(isequal(size(I), size(D)), 'DeepGrasping:IDsize', ...
        'Image, Background and Depth Image must have same dimension!')
    
    load ../../weights/graspWFinal.mat  % w1 w2 w_class
    load ../../data/graspWhtParams.mat  % featMeans featStds
    rotAngs = 0:15:(15*11);
    hts = 10:10:90;
    wds = 10:10:90;
    scanStep = 10;
    load ../../data/graspModes24.mat  % trainModes

    [bestRect,bestScore] = onePassDetectionNormDisplayMod(...
        I, D, BG, ...
        w1, w2, w_class, ...
        featMeans, featStds, ...
        rotAngs, hts, wds, scanStep, trainModes);
end