function thumbs = colorThumbs(thumbs,col)
% COLORTHUMBS color blob thumbnails a custom color.
% thumbs is a cell array containing the thumbnail of the blob, a grayscale
% or binary image. Each image of size N x M.
% col is the RGB color it is supposed to have, 1 x 3.

for i = 1:numel(thumbs)
    
    colorThumb = zeros(size(thumbs{i},1),size(thumbs{i},2),3);
    mask = logical(thumbs{i});
    R = double(thumbs{i});
    G = double(thumbs{i});
    B = double(thumbs{i});
    R(mask) = col(1);
    G(mask) = col(2);
    B(mask) = col(3);
    colorThumb(:,:,1) = R;
    colorThumb(:,:,2) = G;
    colorThumb(:,:,3) = B;
    thumbs{i} = colorThumb;

end

