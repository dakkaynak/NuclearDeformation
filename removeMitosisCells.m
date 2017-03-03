function Ibwout = removeMitosisCells(Ibwin)
% REMOVEMITOSISCELLS is a function to identify and eliminate cells that are
% in the middle of division. Generally, these cells look like peanuts.
% Ibwin is the binary input image.

Iremove = zeros(size(Ibwin));
blobStats = regionprops(Ibwin,'Image','PixelIdxList');
[~,removePix] = getCellsToRemove(blobStats);
for i = 1:numel(removePix)
    Iremove(removePix{i}) = 1;
end

Ibwout = logical(Ibwin-Iremove);

end

function [removeInd,removePix] = getCellsToRemove(blobStats)

removeInd = [];
removePix = {};
n = 1;
for i = 1:numel(blobStats)
    curImg = blobStats(i).Image;
    kidneyFlag = breakMitosisCells(curImg);
    if kidneyFlag % there are two blobs
        removeInd = [removeInd;i];
        removePix{n} = blobStats(i).PixelIdxList;
        n = n+1;
    end
    
end

end

function kidneyFlag = breakMitosisCells(inImg)
kidneyFlag = 0;

inImg = logical(inImg);

img = inImg;
stats = regionprops(inImg,'All');
A = stats(1).Area;
P = stats(1).Perimeter;
C = 4*pi * A/P^2;

clear stats

if C <0.9
    D = -bwdist(~inImg,'chessboard');
    mask = imextendedmin(D,2);
    D2 = imimposemin(D,mask);
    Ld = watershed(D2);
    img(Ld==0) = 0;
    stats = regionprops(logical(img),'All');
    
    if numel(stats) ==2
        % now we have forced two blobs
        %stats = regionprops(logical(L),'All');
        % what are their circularities?
        C1 = getCircularity(stats(1));
        C2 = getCircularity(stats(2));
        
        if (~isinf(C1) && ~isinf(C2)) && ((C1 >= 0.8 && C1 < 1.2) && (C2 >=0.8 && C2 < 1.2))
            kidneyFlag = 1;
            
        end
    end
    
end


end

function C1 = getCircularity(stats)
P = stats.Perimeter;
A = stats.Area;

% Area of circle having the same perimeter as the shape to area of shape

C1 = 4*pi * A/P^2;
end

