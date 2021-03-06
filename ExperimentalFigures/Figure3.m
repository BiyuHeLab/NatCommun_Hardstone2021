function Figure3
% Output percentage difference and p-values for number of significant interlobe directed connections 
load('Data.mat')
numPermutations = 1000;
pThreshold = 0.05;
TwoSidedSignificanceInCountPermutations = numPermutations * (pThreshold/2);
upperThreshold = numPermutations -  TwoSidedSignificanceInCountPermutations;
images = {'FaceVase','Cube'};

%%
Output = struct;
for i_image = 1:length(images)
    imageName = images{i_image};
    selectedElectrodes = find(Data.Subjects.Electrodes.Lobe < 5 ); %select only electrodes localized to Frontal, Temporal, Parietal, Occipital lobes
    Output.(imageName).Lobe = Data.Subjects.Electrodes.Lobe(selectedElectrodes);
    
    %Find directed connections that have significant greater GC in that
    %direction compared to the permutations
    Output.(imageName).GreaterGCPreferredTrials    = Data.Subjects.Granger.Feedforward_Feedback.(imageName).Temporal.Rank_Preferred_IndividualBias(selectedElectrodes,selectedElectrodes) > upperThreshold;
    Output.(imageName).GreaterGCNonPreferredTrials = Data.Subjects.Granger.Feedforward_Feedback.(imageName).Temporal.Rank_NonPreferred_IndividualBias(selectedElectrodes,selectedElectrodes) > upperThreshold;
    
    %Count number of connections between each lobe
    Output.(imageName).GreaterGCPreferredTrials_LobeCount = zeros(4,4);
    Output.(imageName).GreaterGCNonPreferredTrials_LobeCount = zeros(4,4);
     for i_lobe_to = 1:4
         for i_lobe_from = 1:4
             toElecs   = find(Output.(imageName).Lobe == i_lobe_to);
             fromElecs = find(Output.(imageName).Lobe == i_lobe_from);
             preferred = Output.(imageName).GreaterGCPreferredTrials(toElecs,fromElecs);
             nonpreferred = Output.(imageName).GreaterGCNonPreferredTrials(toElecs,fromElecs);
             Output.(imageName).GreaterGCPreferredTrials_LobeCount(i_lobe_to,i_lobe_from) = sum(preferred(:));
             Output.(imageName).GreaterGCNonPreferredTrials_LobeCount(i_lobe_to,i_lobe_from) = sum(nonpreferred(:));
             Output.(imageName).numLobeCountConnections(i_lobe_to,i_lobe_from) = nnz(~isnan(Data.Subjects.Granger.Feedforward_Feedback.(imageName).Temporal.Rank_Preferred_IndividualBias(selectedElectrodes(toElecs),selectedElectrodes(fromElecs))));
         end
     end
     
    %Calculate %difference in counts and significance of that difference
     for i_lobe_to = 1:4
         for i_lobe_from = 1:4
             Output.(imageName).GreaterGCPreferredTrials_LobePerc(i_lobe_to,i_lobe_from) = 100 * (Output.(imageName).GreaterGCPreferredTrials_LobeCount(i_lobe_to,i_lobe_from) - Output.(imageName).GreaterGCPreferredTrials_LobeCount(i_lobe_from,i_lobe_to)) / ...
                 (Output.(imageName).GreaterGCPreferredTrials_LobeCount(i_lobe_to,i_lobe_from) + Output.(imageName).GreaterGCPreferredTrials_LobeCount(i_lobe_from,i_lobe_to));
             Output.(imageName).GreaterGCNonPreferredTrials_LobePerc(i_lobe_to,i_lobe_from) = 100 * (Output.(imageName).GreaterGCNonPreferredTrials_LobeCount(i_lobe_to,i_lobe_from) - Output.(imageName).GreaterGCNonPreferredTrials_LobeCount(i_lobe_from,i_lobe_to)) / ...
                 (Output.(imageName).GreaterGCNonPreferredTrials_LobeCount(i_lobe_to,i_lobe_from) + Output.(imageName).GreaterGCNonPreferredTrials_LobeCount(i_lobe_from,i_lobe_to));
             
             [Output.(imageName).GreaterGCPreferredTrials_LobePValue(i_lobe_to,i_lobe_from), ...
                 Output.(imageName).GreaterGCPreferredTrials_LobeZ(i_lobe_to,i_lobe_from)] = applySignTest(Output.(imageName).GreaterGCPreferredTrials_LobeCount(i_lobe_to,i_lobe_from),Output.(imageName).GreaterGCPreferredTrials_LobeCount(i_lobe_from,i_lobe_to));
             
             [Output.(imageName).GreaterGCNonPreferredTrials_LobePValue(i_lobe_to,i_lobe_from), ...
                 Output.(imageName).GreaterGCNonPreferredTrials_LobeZ(i_lobe_to,i_lobe_from)] = applySignTest(Output.(imageName).GreaterGCNonPreferredTrials_LobeCount(i_lobe_to,i_lobe_from),Output.(imageName).GreaterGCNonPreferredTrials_LobeCount(i_lobe_from,i_lobe_to));
         end
     end
end

% Output tables 
RowNames = strcat('To_',Data.Subjects.Electrodes.LobeNames(1:4));
ColumnNames = strcat('From_',Data.Subjects.Electrodes.LobeNames(1:4));
percentageDifference_FaceVasePreferred = array2table(Output.FaceVase.GreaterGCPreferredTrials_LobePerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_FaceVaseNonPreferred = array2table(Output.FaceVase.GreaterGCNonPreferredTrials_LobePerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_CubePreferred = array2table(Output.Cube.GreaterGCPreferredTrials_LobePerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_CubeNonPreferred = array2table(Output.Cube.GreaterGCNonPreferredTrials_LobePerc,'RowNames',RowNames,'VariableNames',ColumnNames);

pValue_FaceVasePreferred = array2table(log10(Output.FaceVase.GreaterGCPreferredTrials_LobePValue)	,'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_FaceVaseNonPreferred = array2table(log10(Output.FaceVase.GreaterGCNonPreferredTrials_LobePValue),'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_CubePreferred = array2table(log10(Output.Cube.GreaterGCPreferredTrials_LobePValue),'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_CubeNonPreferred = array2table(log10(Output.Cube.GreaterGCNonPreferredTrials_LobePValue),'RowNames',RowNames,'VariableNames',ColumnNames);

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


%%
disp('')
disp(['Cube Preferred: (Occipital-> Frontal,Frontal->Occipital,p-value) (' num2str(Output.Cube.GreaterGCPreferredTrials_LobeCount(1,4)) ',' num2str(Output.Cube.GreaterGCPreferredTrials_LobeCount(4,1)) ', ' num2str(Output.Cube.GreaterGCPreferredTrials_LobePValue(1,4)) ')']);
disp(['Cube Non-Preferred: (Occipital-> Frontal,Frontal->Occipital,p-value)(' num2str(Output.Cube.GreaterGCNonPreferredTrials_LobeCount(1,4)) ',' num2str(Output.Cube.GreaterGCNonPreferredTrials_LobeCount(4,1)) ', ' num2str(Output.Cube.GreaterGCNonPreferredTrials_LobePValue(1,4)) ')']);
