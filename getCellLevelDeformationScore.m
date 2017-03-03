function deformationScore = getCellLevelDeformationScore(F,w)
% GETCELLLEVELDEFORMATIONSCORE is a function that takes as input a feature
% matrix F, and weights vector w for each feature, and calculates a
% deformation score.

x = F(:,1);
y = F(:,2);

% R1: no deformation
noDef = x <=0.1 & y <=0.1;
% R2: low deformation, more compact
lowDef_moreCompact = (x<=0.2& (y >0.1 & y<=0.2)) | ((x>=0.1 & x<=0.2) &  y <=0.2);
% R3: low deformation, less compact
lowDef_lessCompact = (x>0.2 & x<=1) & (y >0 & y<=0.3);
% R4: high deformation, more compact
hiDef_moreCompact = (x<=0.2) & (y<=1 & y>0.2);
% R5: high deformation, less compact
hiDef_lessCompact = (x>0.2 & x<=1) & (y>0.3 & y<=1);

deformationScore = zeros(size(F,1),1);
deformationScore(noDef) = w(1);
deformationScore(lowDef_moreCompact) = w(2);
deformationScore(lowDef_lessCompact) = w(3);
deformationScore(hiDef_moreCompact) = w(4);
deformationScore(hiDef_lessCompact) = w(5);


