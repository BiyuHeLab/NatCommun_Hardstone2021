function FigureS1

load('Data.mat');
numSubjects = 14;
cmap = [hsv(numSubjects-1); 0 0 0];
for i_sub = 1:14
    i_sub
    pickedElectrodes = Data.Subjects.Electrodes.SubjectID == i_sub;
    mniCoords = Data.Subjects.Electrodes.MNI_Coordinates(pickedElectrodes,:);
    c = plotElectrodes(mniCoords,Data.Subjects.Electrodes.SubjectID(pickedElectrodes),3 * ones(length(pickedElectrodes),1),[1 numSubjects],cmap);
    view(90,0); c = camlight(c,'headlight');
    print('-dpng','-r600',['Figures/FigureS1_Sub' num2str(i_sub) '_R.png']);
    view(-90,0); c = camlight(c,'headlight');
    print('-dpng','-r600',['Figures/FigureS1_Sub' num2str(i_sub) '_L.png']);
    close all
end

for i_sub = 1:numSubjects
    newIm = imread(['Figures/FigureS1_Sub' num2str(i_sub) '_L.png']);
    newIm = newIm(400:1850,880:2830,:);
    imwrite(newIm,['Figures/FigureS1_Sub' num2str(i_sub) '_L.png']);
    close all
    newIm = imread(['Figures/FigureS1_Sub' num2str(i_sub) '_R.png']);
    newIm = newIm(400:1850,800:2750,:);
    imwrite(newIm,['Figures/FigureS1_Sub' num2str(i_sub) '_R.png']);
    close all
end


mniCoords = Data.Subjects.Electrodes.MNI_Coordinates;
mniCoords(:,1) = abs(mniCoords(:,1));
c = plotElectrodes_RH(mniCoords,Data.Subjects.Electrodes.SubjectID,2 * ones(length(mniCoords),1),[1 numSubjects],cmap);
view(90,0); c = camlight(c,'headlight');
print('-dpng','-r600','Figures/FigureS1_AllSubs_R.png');
view(-90,0); c = camlight(c,'headlight');
print('-dpng','-r600','Figures/FigureS1_AllSubs_L.png');
view(0,-90); c = camlight(c,'headlight');
print('-dpng','-r600','Figures/FigureS1_AllSubs_B.png');
close all

newIm = imread('Figures/FigureS1_AllSubs_L.png');
newIm = newIm(400:1850,880:2830,:);
imwrite(newIm,'Figures/FigureS1_AllSubs_L.png');

newIm = imread('Figures/FigureS1_AllSubs_R.png');
newIm = newIm(400:1850,800:2750,:);
imwrite(newIm,'Figures/FigureS1_AllSubs_R.png');




