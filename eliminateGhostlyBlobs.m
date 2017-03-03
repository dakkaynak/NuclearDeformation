function outImg = eliminateGhostlyBlobs(Ib)
% ELIMINATEGHOSTLY BLOBS takes as input a grayscale image Ib, and removes
% blobs that are not sharp, or have weird boundaries or dimensions.

% binary images in a coarse way
Icontrol = Ib > graythresh(Ib);

outImg = zeros(size(Icontrol));
s = regionprops(Icontrol, Ib, {'Centroid','PixelValues','PixelIdxList'});
numObj = numel(s);

stdVals = zeros(numel(s),1);

for k = 1 : numObj
    s(k).StandardDeviation = std(double(s(k).PixelValues));
    stdVals(k) = s(k).StandardDeviation;
    if stdVals(k) <=0.5
        outImg(s(k).PixelIdxList) = 1;
    end
    
end


