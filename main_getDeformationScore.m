% Cell-level and population level Deformation Score calculation for 
% Micropillar induced nuclear deformation (MIND) for cancell cell
% identification

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If you use this code, please cite the following paper:

% A high throughput approach for analysis of cell nuclear deformability at single cell level. 
% Scientific Reports 6:36917 (2016). doi:10.1038/srep36917

%Ermis, Menekse, Derya Akkaynak, Pu Chen, Utkan Demirci, and Vasif Hasirci. 


% For questions, comments, suggestions and bugs, please email Derya
% Akkaynak -- derya.akkaynak@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SURFACE SELECTION
%

% clear workspace variables
clear;close all;clc

% main image path
mainPath = 'Images/';
% paths where images are
surfaceSelectionPath = 'Surface selection/';
% path where we should save results
savePath = 'Results';
% surface types to test
surfaces = {'p4 g4','p4 g8','p4 g16','p8 g4','p8 g8','p8 g16','p16 g4','p16 g8','p16 g16','control'};
% Saos cells deform the most, so we will use those only for surface
% selection
cells = {'saos'};

% now loop through all folders and get blob properties in a struct called
% "blobs"

tic
blobs = processFolder([mainPath,surfaceSelectionPath],surfaces,cells);
toc


features = cell2mat({blobs.features}');
labels = ([blobs.source])';
% Scatter plot of ALL DATA we just processed
figure;
set(gcf,'units','normalized')
set(gcf,'position',[0 0 1 1])
gscatter(features(:,1),features(:,2),labels,[],'.',20)
legend('location','bestOutside')
set(gca,'fontsize',35)
xlabel('Rectangularity','fontsize',30)
ylabel('circle variance','fontsize',30)

saveas(gcf,[savePath,'/SurfaceSelection_scatterplot.jpg'])
close

% weights for Gating regions R1-R5
w = [1 2 3 4 5];

% individual-cell level deformation score
deformationScore = getCellLevelDeformationScore(features,w);

% population-level deformation score; in this case, for surfaces
% list of unique surfaces
unSurf = unique(labels);

pop_deformationScore = zeros(numel(unSurf),1);
clc
for i = 1:numel(unSurf)
    curSurf = unSurf{i};
    m = strfind(labels,curSurf);
    curSurfInds = find(~cellfun(@isempty,m));
    % For selecting the optimal surface, we only care about whether the
    % cells are in R1 or R2. 
    pop_deformationScore(i) = 1-sum(((deformationScore(curSurfInds)==1) | (deformationScore(curSurfInds)==2))./numel(curSurfInds));
    display(['Population level deformation score for ',curSurf,'=',num2str(pop_deformationScore(i))])
end

figure
set(gcf,'units','normalized')
set(gcf,'position',[0 0 1 1])
bar(pop_deformationScore)
set(gca,'xticklabel',unSurf)
set(gca,'fontsize',8)
xlabel('Surface Types','fontsize',20)
ylabel('% Deformed','fontsize',20)

saveas(gcf,[savePath,'/SurfaceSelection_percentDeformation.jpg'])
close

%% CANCER CELL ID of 5 POPULATIONS

% clear workspace variables
clear;close all;clc

% main image path
mainPath = 'Images/';
% paths where images are
cancerCellIDPath ='Cancer cell identification/';
% path where we should save results
savePath = 'Results';
% surface types to test - only p4g4 because it induces the most
% deformation
surfaces = {'p4 g4','control'};
% Out of these, HOb and L-929 are healthy populations
cells = {'L-929','hob','saos','mcf7','shsy-5y'};

% now loop through all folders and get blob properties in a struct called
% "blobs"

tic
blobs = processFolder([mainPath,cancerCellIDPath],surfaces,cells);
toc
features = cell2mat({blobs.features}');
labels = ([blobs.source])';
% Scatter plot of ALL DATA we just processed
figure;
gscatter(features(:,1),features(:,2),labels,[],'.',20)
set(gca,'fontsize',35)
xlabel('Rectangularity','fontsize',30)
ylabel('circle variance','fontsize',30)

saveas(gcf,[savePath,'/CancerCellID_scatterplot.jpg'])
close

% weights for Gating regions R1-R5
w = [1 2 3 4 5];

% individual-cell level deformation score
deformationScore = getCellLevelDeformationScore(features,w);
%
% population-level deformation score; in this case, for surfaces
% list of unique surfaces
unSurf = unique(labels);

pop_deformationScore = zeros(numel(unSurf),1);
clc
for i = 1:numel(unSurf)
    curSurf = unSurf{i};
    m = strfind(labels,curSurf);
    curSurfInds = find(~cellfun(@isempty,m));
    % For classifying cells as healthy vs cancerous, we utilized all 5 regions. 
    pop_deformationScore(i) = mean(deformationScore(curSurfInds));
    display(['Population level deformation score for ',curSurf,'=',num2str(pop_deformationScore(i))])
end

figure
set(gcf,'units','normalized')
set(gcf,'position',[0 0 1 1])
bar(pop_deformationScore)
set(gca,'xticklabel',unSurf)
set(gca,'fontsize',20)
xlabel('Cell Types','fontsize',20)
ylabel('Deformation Score','fontsize',20)
set(gca,'ylim',[0 5])
set(gca,'ytick',0:5)
hold on
grid on
plot(linspace(0,numel(unSurf)+1),3*ones(100,1),'r-','linewidth',5)
text(1,2.7,'Healthy','fontsize',25)
text(1,3.2,'Cancerous','fontsize',25)

saveas(gcf,[savePath,'/CancerCellID_deformationScore.jpg'])
close

