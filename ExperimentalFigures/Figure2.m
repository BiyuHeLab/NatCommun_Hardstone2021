function Figure2
%% Figure 2C, Table 2D and statistics for figure 2

load('Data.mat');

mniCoords = Data.Subjects.Electrodes.MNI_Coordinates;
mniCoords(:,1) = abs(Data.Subjects.Electrodes.MNI_Coordinates(:,1)); %Map all electrodes coordinates onto right hemisphere
numElectrodes = size(mniCoords,1);
sizeSignificantElectrodes = 2.5;
sizeNonSignificantElectrodes = 1;
significanceThreshold = 0.05;
%%
significantElectrodesFaceVase = Data.Subjects.SwitchMaintainAnalysis.FaceVase.pValue < significanceThreshold;
significantElectrodesCube     = Data.Subjects.SwitchMaintainAnalysis.Cube.pValue < significanceThreshold;
FaceVase_SignificantSwitch    = significantElectrodesFaceVase  & Data.Subjects.SwitchMaintainAnalysis.FaceVase.tStat > 0;
FaceVase_SignificantMaintain  = significantElectrodesFaceVase  & Data.Subjects.SwitchMaintainAnalysis.FaceVase.tStat < 0;
Cube_SignificantSwitch        = significantElectrodesCube     & Data.Subjects.SwitchMaintainAnalysis.Cube.tStat > 0;
Cube_SignificantMaintain      = significantElectrodesCube      & Data.Subjects.SwitchMaintainAnalysis.Cube.tStat < 0;

%%
Both_SignificantSwitch = FaceVase_SignificantSwitch & Cube_SignificantSwitch;
Both_SignificantMaintain = FaceVase_SignificantMaintain & Cube_SignificantMaintain;

%% Table for Figure 2D
categoryFaceVase = zeros(numElectrodes,1);
categoryFaceVase(significantElectrodesFaceVase) = 0;
categoryFaceVase(FaceVase_SignificantMaintain) = 1;
categoryFaceVase(FaceVase_SignificantSwitch) = 2;

categoryCube = zeros(numElectrodes,1);
categoryCube(significantElectrodesCube) = 0;
categoryCube(Cube_SignificantMaintain) = 1;
categoryCube(Cube_SignificantSwitch) = 2;

[actualTally,chiSquareValue,pValue] = crosstab(categoryCube,categoryFaceVase); %Chisquare test on overlap of categories;

actualTally = array2table(actualTally,'VariableNames',{'FaceVase_NotSignificant','FaceVase_Maintain','FaceVase_Switch'},'RowNames',{'Cube_NotSignificant','Cube_Maintain','Cube_Switch'});
pFV = sum(actualTally.Variables)/numElectrodes; %probability of different categories of electrode for FaceVase
pCB = sum(actualTally.Variables,2)/numElectrodes; %probability of different categories of electrode for Cube

expectedTally = round((pFV .* pCB) * numElectrodes); %Expected overlap of categories if independent
expectedTally = array2table(expectedTally,'VariableNames',{'FaceVase_NotSignificant','FaceVase_Maintain','FaceVase_Switch'},'RowNames',{'Cube_NotSignificant','Cube_Maintain','Cube_Switch'});

disp('Actual Tally');
disp(actualTally);
disp('Expected Tally');
disp(expectedTally);
disp(['Chi-Square: ' num2str(chiSquareValue) ' pValue = ' num2str(pValue)]);


%% FaceVase
figure
plotSizes = sizeNonSignificantElectrodes * ones(numElectrodes,1);
plotSizes(significantElectrodesFaceVase) = sizeSignificantElectrodes;

plotValue = zeros(numElectrodes,1);

plotValue(FaceVase_SignificantSwitch) = 0.5;
plotValue(Both_SignificantSwitch) = 1;

plotValue(FaceVase_SignificantMaintain) = -0.5;
plotValue(Both_SignificantMaintain) = -1;

figure_colormap = [0       0.6667     0.8; ...
        0       0.4167     0.5; ...
        0       0       0; ...
        0.5     0.3583  0; ...
        0.8     0.5733  0];
    
c = plotElectrodes(mniCoords,plotValue,plotSizes,[-1 1],figure_colormap); view(90,0); c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure2C_FaceVase.png');
newIm = imread('Figures/Figure2C_FaceVase.png');
imwrite(newIm(800:3700,1600:5500,:),'Figures/Figure2C_FaceVase.png');

close all
c = plotElectrodes_RH(mniCoords,plotValue,plotSizes,[-1 1],figure_colormap); view(0,-90); c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure2C_FaceVase_Ventral.png');
close all
c = plotElectrodes_RH(mniCoords,plotValue,plotSizes,[-1 1],figure_colormap); view(-90,0); c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure2C_FaceVase_Medial.png');
close all

%Statistics

[FaceVase_Coord_Stats.p,FaceVase_Coord_Stats.h,FaceVase_Coord_Stats.stats] = ranksum(mniCoords(FaceVase_SignificantSwitch,3),mniCoords(FaceVase_SignificantMaintain,3));
disp(['FaceVase Coordinate Statistics (z) = ' num2str(FaceVase_Coord_Stats.stats.zval)]);
disp(['p= ' num2str(FaceVase_Coord_Stats.p)]);

%% Cube
figure
plotSizes = sizeNonSignificantElectrodes * ones(numElectrodes,1);
plotSizes(significantElectrodesCube) = sizeSignificantElectrodes;

plotValue = zeros(numElectrodes,1);
plotValue(Cube_SignificantSwitch) = 0.5;
plotValue(Both_SignificantSwitch) = 1;

plotValue(Cube_SignificantMaintain) = -0.5;
plotValue(Both_SignificantMaintain) = -1;

figure_colormap = [0       0.6667     0.8; ...
        0       0.4167     0.5; ...
        0       0       0; ...
        0.5     0.3583  0; ...
        0.8     0.5733  0];
    
c = plotElectrodes(mniCoords,plotValue,plotSizes,[-1 1],figure_colormap); view(90,0); c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure2C_Cube.png');
newIm = imread('Figures/Figure2C_Cube.png');
imwrite(newIm(800:3700,1600:5500,:),'Figures/Figure2C_Cube.png');

close all
c = plotElectrodes_RH(mniCoords,plotValue,plotSizes,[-1 1],figure_colormap); view(0,-90); c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure2C_Cube_Ventral.png');
close all
c = plotElectrodes_RH(mniCoords,plotValue,plotSizes,[-1 1],figure_colormap); view(-90,0); c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure2C_Cube_Medial.png');
close all

%Statistics
[Cube_Coord_Stats.p,Cube_Coord_Stats.h,Cube_Coord_Stats.stats] = ranksum(mniCoords(Cube_SignificantSwitch,3),mniCoords(Cube_SignificantMaintain,3));
disp(['Cube Coordinate Statistics (z) = ' num2str(Cube_Coord_Stats.stats.zval)]);
disp(['p= ' num2str(Cube_Coord_Stats.p)]);

%%


