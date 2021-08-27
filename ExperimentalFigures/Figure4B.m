function Figure4B
% Plot directed connections (Figure 4B) 
load('Data.mat');
numPermutations = 1000;
pThreshold = 0.002;
TwoSidedSignificanceInCountPermutations = numPermutations * (pThreshold/2);
upperThreshold = numPermutations -  TwoSidedSignificanceInCountPermutations;
lowerThreshold = TwoSidedSignificanceInCountPermutations;
images = {'FaceVase','Cube'};

Output = struct;
for i_image = 1:length(images)
    %% Step 1: Select electrodes that meet criteria
    imageName = images{i_image};
    
    selectedElectrodes = find(Data.Subjects.Electrodes.Lobe' < 5);
    Output.(imageName).Lobe = Data.Subjects.Electrodes.Lobe(selectedElectrodes);
    mniCoords = Data.Subjects.Electrodes.MNI_Coordinates(selectedElectrodes,:);
    
    Rank_PreferredMinusPreferred = Data.Subjects.Granger.Preferred_NonPreferred.(imageName).Temporal.Rank_PreferredMinusNonPreferred_IndividualBias;
    Rank_PreferredMinusPreferred = Rank_PreferredMinusPreferred(selectedElectrodes,selectedElectrodes);
    
    %Find directed connections that have significant greater GC during
    %preferred (> upperThrehold) or non-preferred (< lowerThreshold)
    Output.(imageName).GreaterGCInPreferred = Rank_PreferredMinusPreferred > upperThreshold;
    Output.(imageName).GreaterGCInNonPreferred = Rank_PreferredMinusPreferred < lowerThreshold; 
    
    %Count number of connections between each lobe
    Output.(imageName).GreaterGCInPreferred_LobeCount = zeros(4,4);
    Output.(imageName).GreaterGCInNonPreferred_LobeCount = zeros(4,4);
    
    for i_lobe_to = 1:4
        for i_lobe_from = 1:4
            toElecs   = find(Output.(imageName).Lobe == i_lobe_to);
            fromElecs = find(Output.(imageName).Lobe == i_lobe_from);
            preferred = Output.(imageName).GreaterGCInPreferred(toElecs,fromElecs);
            nonpreferred = Output.(imageName).GreaterGCInNonPreferred(toElecs,fromElecs);
            Output.(imageName).GreaterGCInPreferred_LobeCount(i_lobe_to,i_lobe_from) = sum(preferred(:));
            Output.(imageName).GreaterGCInNonPreferred_LobeCount(i_lobe_to,i_lobe_from) = sum(nonpreferred(:));
            Output.(imageName).numLobeCountConnections(i_lobe_to,i_lobe_from) = nnz(~isnan(Rank_PreferredMinusPreferred(toElecs,fromElecs)));
        end
    end
    
    %Calculate %difference in counts and significance of that difference
    for i_lobe_to = 1:4
        for i_lobe_from = 1:4
            Output.(imageName).GreaterGCInPreferred_LobePerc(i_lobe_to,i_lobe_from) = 100 * (Output.(imageName).GreaterGCInPreferred_LobeCount(i_lobe_to,i_lobe_from) - Output.(imageName).GreaterGCInPreferred_LobeCount(i_lobe_from,i_lobe_to)) / ...
                (Output.(imageName).GreaterGCInPreferred_LobeCount(i_lobe_to,i_lobe_from) + Output.(imageName).GreaterGCInPreferred_LobeCount(i_lobe_from,i_lobe_to));
            Output.(imageName).GreaterGCInNonPreferred_LobePerc(i_lobe_to,i_lobe_from) = 100 * (Output.(imageName).GreaterGCInNonPreferred_LobeCount(i_lobe_to,i_lobe_from) - Output.(imageName).GreaterGCInNonPreferred_LobeCount(i_lobe_from,i_lobe_to)) / ...
                (Output.(imageName).GreaterGCInNonPreferred_LobeCount(i_lobe_to,i_lobe_from) + Output.(imageName).GreaterGCInNonPreferred_LobeCount(i_lobe_from,i_lobe_to));
            [Output.(imageName).GreaterGCInPreferred_LobePValue(i_lobe_to,i_lobe_from), Output.(imageName).GreaterGCInPreferred_LobeZValue(i_lobe_to,i_lobe_from)] =    applySignTest(Output.(imageName).GreaterGCInPreferred_LobeCount(i_lobe_to,i_lobe_from),Output.(imageName).GreaterGCInPreferred_LobeCount(i_lobe_from,i_lobe_to));
            [Output.(imageName).GreaterGCInNonPreferred_LobePValue(i_lobe_to,i_lobe_from),Output.(imageName).GreaterGCInNonPreferred_LobeZValue(i_lobe_to,i_lobe_from)] = applySignTest(Output.(imageName).GreaterGCInNonPreferred_LobeCount(i_lobe_to,i_lobe_from),Output.(imageName).GreaterGCInNonPreferred_LobeCount(i_lobe_from,i_lobe_to));
        end
    end
end

mniCoords(:,1) = abs(mniCoords(:,1)); %Project all electrodes onto Right hemisphere
plotValues = ones(size(mniCoords,1),1);
plotSizes  = 1.5 * ones(size(mniCoords,1),1);

%% Cube

preferred    = Output.Cube.GreaterGCInPreferred;
nonpreferred = Output.Cube.GreaterGCInNonPreferred;
colormapElectrodes= [0 0 0; 0 0 0];

close all
c = plotConnectedElectrodes(mniCoords,plotValues,plotSizes,[0 1],colormapElectrodes,preferred);
view(90,0)
c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure4B_CubePreferred.png');
close all

c = plotConnectedElectrodes(mniCoords,plotValues,plotSizes,[0 1],colormapElectrodes,nonpreferred);
view(90,0)
c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure4B_CubeNonPreferred.png');
close all

%%
preferred = Output.FaceVase.GreaterGCInPreferred;
nonpreferred = Output.FaceVase.GreaterGCInNonPreferred;

close all
c = plotConnectedElectrodes(mniCoords,plotValues,plotSizes,[0 1],colormapElectrodes,preferred);
view(90,0)
c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure4B_FaceVasePreferred.png');
close all

c = plotConnectedElectrodes(mniCoords,plotValues,plotSizes,[0 1],colormapElectrodes,nonpreferred);
view(90,0)
c = camlight(c,'headlight');
print('-dpng','-r1200','Figures/Figure4B_FaceVaseNonPreferred.png');
close all

cubePreferred = imread(['Figures/Figure4B_CubePreferred.png']);
cubePreferred = cubePreferred(800:3600,1700:5500,:);
cubeNonPreferred = imread(['Figures/Figure4B_CubeNonPreferred.png']);
cubeNonPreferred = cubeNonPreferred(800:3600,1700:5500,:);
faceVasePreferred = imread(['Figures/Figure4B_FaceVasePreferred.png']);
faceVasePreferred = faceVasePreferred(800:3600,1700:5500,:);
faceVaseNonPreferred = imread(['Figures/Figure4B_FaceVaseNonPreferred.png']);
faceVaseNonPreferred = faceVaseNonPreferred(800:3600,1700:5500,:);

allImage = [[faceVasePreferred faceVaseNonPreferred] ; [cubePreferred cubeNonPreferred]];
imwrite(allImage,['Figures/Figure4B_CombinedImage.png']);