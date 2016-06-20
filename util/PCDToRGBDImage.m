% Loads the given instance number from the given directory (containing the
% dataset), and returns the RGB-D data as a 4-channel image, with RGB as
% channels 1-3 and D as channel 4.
%
% Author: Marvin Ludersdorfer

function I = PCDToRGBDImage(dataDir, fileNum)

pcdFile = sprintf('%s/pcd%04d.pcd', dataDir, fileNum);
imFile = sprintf('%s/pcd%04dr.jpg', dataDir, fileNum);

points = loadpcd(pcdFile);

I = double(imread(imFile));
D = points(:,:,3);

I(:,:,4) = D;
