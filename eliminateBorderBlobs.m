function finalI = eliminateBorderBlobs(I)
% ELIMINATEBORDERBLOBS gets rid of blobs that are connected to the image
% border, as we have no idea about the true shape of those.
controlStats = regionprops(I,'PixelIdxList');

% finalImage will show which blobs are kept
finalI = zeros(size(I));

for i = 1:numel(controlStats)
    y = isBlobOnBoundary(size(I),controlStats(i).PixelIdxList);
    if ~y
        finalI(controlStats(i).PixelIdxList)=1;  
    end
end

finalI = logical(finalI);






