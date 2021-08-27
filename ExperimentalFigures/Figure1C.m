function Figure1C
%Plots electrodes from all subjects in different orientations

load('Data.mat')

mniCoords = [Data.Subjects.Electrodes.MNI_Coordinates];
mniCoords(:,1) = abs(mniCoords(:,1)); %Projects all electrodes onto Right Hemisphere.

numElectrodes_Subjects = size(Data.Subjects.Electrodes.MNI_Coordinates,1);

plotValues = ones(numElectrodes_Subjects,1);
plotValues(1:numElectrodes_Subjects) = 0;
plotColors = [0 0 0; 1 0 0];
c = plotElectrodes_RH(mniCoords,plotValues,2 * ones(numElectrodes_Subjects),[0 1],plotColors);
view(0,-90); c = camlight(c,'headlight');

print('-dpng','-r600','Figures/Figure1C_Vent.png');

view(90,0); c = camlight(c,'headlight');
print('-dpng','-r600','Figures/Figure1C_Lat.png');
close all
newIm = imread('Figures/Figure1C_Lat.png');
newIm = newIm(400:1850,800:2750,:);
imwrite(newIm,'Figures/Figure1C_Lat.png');

