function finalI = eliminateSmallBlobs(I)
% ELIMINATESMALLBLOBS takes as input a binary image I, and gets rid of
% certain blobs if they are much smaller than the average. We'd like to be able to run this code on different magnification levels,
% so we'll crop out blobs that have small relative size, not absolute size.
controlStats = regionprops(I,'Area','PixelIdxList');

% finalImage will show which blobs are kept
finalI = zeros(size(I));

% make a list of blob areas
sizes = zeros(1,numel(controlStats));
for i = 1:numel(controlStats)
    sizes(i) = controlStats(i).Area;
end

medSize = mean(sizes);
keepInds = sizes./medSize >0.1;

for i = 1:numel(keepInds)
    if keepInds(i)
        
        finalI(controlStats(i).PixelIdxList)=1;
    end
end

finalI = logical(finalI);
finalI = bwareaopen(finalI,5);






