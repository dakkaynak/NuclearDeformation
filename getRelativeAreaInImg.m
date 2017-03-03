function [Ibw_keep,out] = getRelativeAreaInImg(Ibw)
% GETRELATIVEAREAINIMG calculates the areas of all blobs in the binary
% image Ibw, and eliminates very small ones.

blobStats = regionprops(Ibw,'Area','PixelIdxList');
s = size(Ibw);
N = s(1)*s(2);
features = [blobStats.Area]./N;

inds_keep = features <=0.01;
Ibw_keep = zeros(size(Ibw));
Ibw_exclude = zeros(size(Ibw));

for i = 1:numel(blobStats)
    if inds_keep(i)
        Ibw_keep(blobStats(i).PixelIdxList) = 1;
    else
        Ibw_exclude(blobStats(i).PixelIdxList) = 1;
    end
end

R = double(Ibw);
G = double(Ibw);
B = double(Ibw);

R(logical(Ibw_exclude)) = 0;
G(logical(Ibw_exclude)) = 0;
B(logical(Ibw_exclude)) = 1;

out = zeros(size(Ibw,1),size(Ibw,2),3);
out(:,:,1) = R;
out(:,:,2) = G;
out(:,:,3) = B;
Ibw_keep = logical(Ibw_keep);
Ibw_keep = bwareaopen(Ibw_keep,15);
