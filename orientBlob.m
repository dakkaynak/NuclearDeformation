function out = orientBlob(statsIn)
% ORIENTBLOB takes as input a struct of features for the blobs, and orients
% the blobs a certain way.

out = rotateBlob(statsIn(1).Image);

end

function out = rotateBlob(img)

% rotate the image on its long edge --> upright
s = size(img);
if s(2) > s(1)
    img = img';
end

% go ahead and rotate based on major axis orientation
s = regionprops(img,'Orientation');
imgR = imrotate(img,90-s(1).Orientation);
s = regionprops(imgR,'Image','Centroid');
C = s(1).Centroid;

% find the line between two farthest points
p = bwperim(imgR);
[x,y] = find(p);
D = pdist2([y x],[y x]);
m = find(D(:)==max(D(:)));
[a,b] = ind2sub(size(D),m);
%L = polyfit([y(a(1)) y(a(2))],[x(a(1)) x(a(2))],1);
%pts = polyval(L,1:size(imgR,1));

% left side mask
mask = poly2mask([y(a(1)) y(a(2)) 1 1 y(a(1))],[x(a(1)) x(a(2)) x(a(2)) x(a(1)) x(a(1))],size(imgR,1),size(imgR,2));
cimg = zeros(size(imgR));
C = round(C);
cimg(C(2),C(1)) = 1;
out = imgR;
if ~isempty(find(mask & cimg))
    out = fliplr(imgR);
end
outs = regionprops(out,'Image');
out = outs(1).Image;
end