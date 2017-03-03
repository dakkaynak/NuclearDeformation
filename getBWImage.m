function Icontrol = getBWImage(I)
% GETBWIMAGE obtains a binary image from an input RGB image.

% Use only the blue channel
Icontrol = im2double(I(:,:,3));

% eliminate blobs that have varying intensities, these are usually
% artifacts or out of focus
Icontrol = eliminateGhostlyBlobs(Icontrol);

% obtain binary image
Icontrol = logical(Icontrol > graythresh(Icontrol));

% eliminate blobs on the boundaries
Icontrol = eliminateBorderBlobs((Icontrol));

% eliminate blobs based on relative size
Icontrol = eliminateSmallBlobs(Icontrol);
[Icontrol,~] = getRelativeAreaInImg(Icontrol);
Icontrol = removeMitosisCells(Icontrol);

% perform some morphological cleanup

A = 50;
Icontrol = bwareaopen(Icontrol,A,4);

h = fspecial('Gaussian',5,10);
Icontrol = logical(imfilter(Icontrol,h));

% Rerun these in case of artifacts
Icontrol = eliminateBorderBlobs((Icontrol));
Icontrol = eliminateSmallBlobs(Icontrol);
Icontrol = bwareaopen(Icontrol,A,4);





