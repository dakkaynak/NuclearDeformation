function blobs = processFolder(mainPath,surfaces,cells,cmap)
% PROCESSFOLDER is a function that takes the path pointing to a folder of
% images, the names of the surfaces that are meant to be processed, cell
% kinds, and a desired colormap, and extracts each blob from each image.

% create an empty struct for each blob
blobs = struct('features',[],'thumbs',{},'filePath','','surface','','cell','','source','');
n = 1;
m = 1;
if isempty(surfaces)
    surfaces = {'test'};
end

if isempty(cells)
    cells = {'test'};
end

if nargin<4
    cmap = jet(30);
end

for i = 1:numel(surfaces) % loop through each surface type
    for j = 1:numel(cells) % loop through each cell type
        if strcmp(surfaces{1},'test')
            curFolder = [mainPath,'/'];
            fileNames = dir([curFolder,'*.jpg']);
        else
            curFolder = [mainPath,surfaces{i},'/',cells{j},'/'];
            fileNames = dir([curFolder,'*.tiff']);
        end
        
        curStr = [surfaces{i},' ',cells{j}];
        curStr(isspace(curStr)) = [];
        for k = 1:numel(fileNames)% loop through all images for cell type
            blobs(n).surface = surfaces{i};
            blobs(n).cell = cells{j};
            curImgPath = [curFolder,fileNames(k).name];
            blobs(n).filePath = curImgPath;
            [blobs(n).features,blobs(n).thumbs] = extractFeaturesFromSingleImage(curImgPath);

            blobs(n).thumbs = colorThumbs(blobs(n).thumbs,cmap(m,:));
            N = numel(blobs(n).thumbs);
            blobs(n).source = repmat({curStr},[1 N]);
            blobs(n).color = cmap(m,:);
            n = n+1
        end
        m = m+1;
        display([surfaces{i},' surface cell type ',cells{j},' is done!'])
    end
    
end
