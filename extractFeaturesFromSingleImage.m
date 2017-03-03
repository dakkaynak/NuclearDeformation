function [features,blobThumbs] = extractFeaturesFromSingleImage(imgPath)
% EXTRACTFEATURESFROMSINGLEIMAGE this function takes as input the path
% pointing to a folder of images, finds the blobs in each image, and
% extracts the features that are required.

% read the color image
I = imread(imgPath);
% get binary image with certain blobs eliminated.
Ibw = getBWImage(I);
% orient final blobs long side first
blobStats = orientAllBlobsInImage(Ibw);

% Gaussian kernel for low pass filtering
h = fspecial('Gaussian',5,10);

features = [];

if ~isempty(blobStats)
    % loop through and resize all to 64xNaN
    n  = 1;
    for i = 1:numel(blobStats)
        curImg = imresize(blobStats(i).Image,[64 NaN]);
        % sometimes resizing creates artifacts - clean
        curImg = medfilt2(curImg);
        curImg = imfilter(curImg,h);
        tempStats = regionprops(curImg,'All');
        
        % Clean out all blobs who occupy 100% of their boxes; these are
        % noise artifacts
        if tempStats(1).Extent ~=1
            % Rectangularity
            features(n,1) = abs((pi/4)-tempStats(1).Extent);
            % Circle variance
            C = tempStats(1).Centroid;
            inPerim = bwperim(tempStats(1).Image);
            [x,y] = find(inPerim);
            distVal = pdist2([y x],C);
            meanD = mean(distVal);
            stdD = std(distVal);
            features(n,2) = stdD./meanD;
            outStats(n) = tempStats(1);
            n = n+1;
        end
        
    end
    
    clear blobStats
    blobStats = outStats;
    blobThumbs = {blobStats.Image};
else
    blobThumbs = [];
end

