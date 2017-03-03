function blobStatsOut = orientAllBlobsInImage(Ibw)
% ORIENTALLBLOBSINIMAGE takes as input a binary image Ibw, and orients them
% all a certain direction for consistency.

if sum(Ibw(:))~=0
    blobStats = regionprops(Ibw,'Image');
    for i = 1:numel(blobStats)
        out =  orientBlob(blobStats(i));
        blobStatsOut(i) = regionprops(out,'All');
    end
else
    blobStatsOut = [];
end