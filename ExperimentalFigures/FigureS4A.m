function FigureS4A
% Plot directed connections (Figure 4B) and output tables containing interlobe statistics.
load('Data.mat');
numPermutations = 1000;
pThreshold = 0.05;
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
    Output.(imageName).mniCoords = Data.Subjects.Electrodes.MNI_Coordinates(selectedElectrodes,:);
    
    Rank_PreferredMinusPreferred_ToFrom = Data.Subjects.Granger.Preferred_NonPreferred.(imageName).Temporal.Rank_PreferredMinusNonPreferred_SignificantIndividualBias;
    Rank_PreferredMinusPreferred_ToFrom = Rank_PreferredMinusPreferred_ToFrom(selectedElectrodes,selectedElectrodes);
    
    %Find directed connections that have significant greater GC during
    %preferred (> upperThrehold) or non-preferred (< lowerThreshold)
    Output.(imageName).GreaterGCInPreferred_ToFrom = Rank_PreferredMinusPreferred_ToFrom > upperThreshold;
    Output.(imageName).GreaterGCInNonPreferred_ToFrom = Rank_PreferredMinusPreferred_ToFrom < lowerThreshold; 
    
    %Count number of connections between each lobe
    Output.(imageName).GreaterGCInPreferred_ToFrom_LobeCount = zeros(4,4);
    Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeCount = zeros(4,4);
    
    for i_lobe_to = 1:4
        for i_lobe_from = 1:4
            toElecs   = find(Output.(imageName).Lobe == i_lobe_to);
            fromElecs = find(Output.(imageName).Lobe == i_lobe_from);
            preferred = Output.(imageName).GreaterGCInPreferred_ToFrom(toElecs,fromElecs);
            nonpreferred = Output.(imageName).GreaterGCInNonPreferred_ToFrom(toElecs,fromElecs);
            Output.(imageName).GreaterGCInPreferred_ToFrom_LobeCount(i_lobe_to,i_lobe_from) = sum(preferred(:));
            Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeCount(i_lobe_to,i_lobe_from) = sum(nonpreferred(:));
            Output.(imageName).numLobeCountConnections(i_lobe_to,i_lobe_from) = nnz(~isnan(Rank_PreferredMinusPreferred_ToFrom(toElecs,fromElecs)));
        end
    end
    
    %Calculate %difference in counts and significance of that difference
    for i_lobe_to = 1:4
        for i_lobe_from = 1:4
            Output.(imageName).GreaterGCInPreferred_ToFrom_LobePerc(i_lobe_to,i_lobe_from) = 100 * (Output.(imageName).GreaterGCInPreferred_ToFrom_LobeCount(i_lobe_to,i_lobe_from) - Output.(imageName).GreaterGCInPreferred_ToFrom_LobeCount(i_lobe_from,i_lobe_to)) / ...
                (Output.(imageName).GreaterGCInPreferred_ToFrom_LobeCount(i_lobe_to,i_lobe_from) + Output.(imageName).GreaterGCInPreferred_ToFrom_LobeCount(i_lobe_from,i_lobe_to));
            Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobePerc(i_lobe_to,i_lobe_from) = 100 * (Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeCount(i_lobe_to,i_lobe_from) - Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeCount(i_lobe_from,i_lobe_to)) / ...
                (Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeCount(i_lobe_to,i_lobe_from) + Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeCount(i_lobe_from,i_lobe_to));
            [Output.(imageName).GreaterGCInPreferred_ToFrom_LobePValue(i_lobe_to,i_lobe_from), Output.(imageName).GreaterGCInPreferred_ToFrom_LobeZValue(i_lobe_to,i_lobe_from)] =    applySignTest(Output.(imageName).GreaterGCInPreferred_ToFrom_LobeCount(i_lobe_to,i_lobe_from),Output.(imageName).GreaterGCInPreferred_ToFrom_LobeCount(i_lobe_from,i_lobe_to));
            [Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobePValue(i_lobe_to,i_lobe_from),Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeZValue(i_lobe_to,i_lobe_from)] = applySignTest(Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeCount(i_lobe_to,i_lobe_from),Output.(imageName).GreaterGCInNonPreferred_ToFrom_LobeCount(i_lobe_from,i_lobe_to));
        end
    end
end


RowNames = strcat('To_',Data.Subjects.Electrodes.LobeNames(1:4));
ColumnNames = strcat('From_',Data.Subjects.Electrodes.LobeNames(1:4));
percentageDifference_FaceVasePreferred = array2table(Output.FaceVase.GreaterGCInPreferred_ToFrom_LobePerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_FaceVaseNonPreferred = array2table(Output.FaceVase.GreaterGCInNonPreferred_ToFrom_LobePerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_CubePreferred = array2table(Output.Cube.GreaterGCInPreferred_ToFrom_LobePerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_CubeNonPreferred = array2table(Output.Cube.GreaterGCInNonPreferred_ToFrom_LobePerc,'RowNames',RowNames,'VariableNames',ColumnNames);

pValue_FaceVasePreferred = array2table(log10(Output.FaceVase.GreaterGCInPreferred_ToFrom_LobePValue)	,'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_FaceVaseNonPreferred = array2table(log10(Output.FaceVase.GreaterGCInNonPreferred_ToFrom_LobePValue),'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_CubePreferred = array2table(log10(Output.Cube.GreaterGCInPreferred_ToFrom_LobePValue),'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_CubeNonPreferred = array2table(log10(Output.Cube.GreaterGCInNonPreferred_ToFrom_LobePValue),'RowNames',RowNames,'VariableNames',ColumnNames);

disp('FaceVase Preferred');
disp('%Difference');
disp(percentageDifference_FaceVasePreferred);
disp('log10(pValue)');
disp(pValue_FaceVasePreferred)

disp('FaceVase NonPreferred');
disp('%Difference');
disp(percentageDifference_FaceVaseNonPreferred);
disp('log10(pValue)');
disp(pValue_FaceVaseNonPreferred)


disp('Cube Preferred');
disp('%Difference');
disp(percentageDifference_CubePreferred);
disp('log10(pValue)');
disp(pValue_CubePreferred)

disp('Cube NonPreferred');
disp('%Difference');
disp(percentageDifference_CubeNonPreferred);
disp('log10(pValue)');
disp(pValue_CubeNonPreferred)

