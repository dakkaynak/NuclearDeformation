function y = isBlobOnBoundary(s,pix)
% ISBLOBONBOUNDARY determines whether the blob is on or very near the boundary.
% If so, eliminate it because these are cut off and do not correspond to
% biologically meaningful cell deformations.
y = 0;
buffer = 2;

col1 = [1:s(1) ; ones(1,s(1))];
colN = [1:s(1) ; s(2)*ones(1,s(1))];
row1 = [ones(1,s(2)); 1:s(2)];
rowN = [s(1)*ones(1,s(2)); 1:s(2)];

borderPix = [col1 colN row1 rowN];
inds = sub2ind(s, borderPix(1,:), borderPix(2,:));

img = zeros(s);
img(inds) = 1;
img = bwmorph(img,'dilate',buffer);

blob = zeros(s);
blob(pix)=1;
if sum(sum(img & blob)) % blob is on the boundary
    y = 1;
end
