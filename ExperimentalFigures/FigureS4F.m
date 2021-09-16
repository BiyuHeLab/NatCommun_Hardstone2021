function FigureS4F
% Plot directed connections and output tables containing interROI statistics.
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
    
    selectedElectrodes = find(Data.Subjects.Electrodes.ROI' > 0);
    Output.(imageName).ROI = Data.Subjects.Electrodes.ROI(selectedElectrodes);
    Output.(imageName).mniCoords = Data.Subjects.Electrodes.MNI_Coordinates(selectedElectrodes,:);    
    Rank_PreferredMinusPreferred_ToFrom = Data.Subjects.Granger.Preferred_NonPreferred.(imageName).Temporal.Rank_PreferredMinusNonPreferred_IndividualBias;
    Rank_PreferredMinusPreferred_ToFrom = Rank_PreferredMinusPreferred_ToFrom(selectedElectrodes,selectedElectrodes);
    
    
    %Find directed connections that have significant greater GC during
    %preferred (> upperThrehold) or non-preferred (< lowerThreshold)
    Output.(imageName).GreaterGCInPreferred_ToFrom = Rank_PreferredMinusPreferred_ToFrom > upperThreshold;
    Output.(imageName).GreaterGCInNonPreferred_ToFrom = Rank_PreferredMinusPreferred_ToFrom < lowerThreshold; 
    
    %Count number of connections between each ROI
    Output.(imageName).GreaterGCInPreferred_ToFrom_ROICount = zeros(7,7);
    Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROICount = zeros(7,7);
    
    for i_ROI_to = 1:7
        for i_ROI_from = 1:7
            toElecs   = find(Output.(imageName).ROI == i_ROI_to);
            fromElecs = find(Output.(imageName).ROI == i_ROI_from);
            preferred = Output.(imageName).GreaterGCInPreferred_ToFrom(toElecs,fromElecs);
            nonpreferred = Output.(imageName).GreaterGCInNonPreferred_ToFrom(toElecs,fromElecs);
            Output.(imageName).GreaterGCInPreferred_ToFrom_ROICount(i_ROI_to,i_ROI_from) = sum(preferred(:));
            Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROICount(i_ROI_to,i_ROI_from) = sum(nonpreferred(:));
            Output.(imageName).numROICountConnections(i_ROI_to,i_ROI_from) = nnz(~isnan(Rank_PreferredMinusPreferred_ToFrom(toElecs,fromElecs)));
        end
    end
    
    %Calculate %difference in counts and significance of that difference
    for i_ROI_to = 1:7
        for i_ROI_from = 1:7
            Output.(imageName).GreaterGCInPreferred_ToFrom_ROIPerc(i_ROI_to,i_ROI_from) = 100 * (Output.(imageName).GreaterGCInPreferred_ToFrom_ROICount(i_ROI_to,i_ROI_from) - Output.(imageName).GreaterGCInPreferred_ToFrom_ROICount(i_ROI_from,i_ROI_to)) / ...
                (Output.(imageName).GreaterGCInPreferred_ToFrom_ROICount(i_ROI_to,i_ROI_from) + Output.(imageName).GreaterGCInPreferred_ToFrom_ROICount(i_ROI_from,i_ROI_to));
            Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROIPerc(i_ROI_to,i_ROI_from) = 100 * (Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROICount(i_ROI_to,i_ROI_from) - Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROICount(i_ROI_from,i_ROI_to)) / ...
                (Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROICount(i_ROI_to,i_ROI_from) + Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROICount(i_ROI_from,i_ROI_to));
            [Output.(imageName).GreaterGCInPreferred_ToFrom_ROIPValue(i_ROI_to,i_ROI_from), Output.(imageName).GreaterGCInPreferred_ToFrom_ROIZValue(i_ROI_to,i_ROI_from)] =    applySignTest(Output.(imageName).GreaterGCInPreferred_ToFrom_ROICount(i_ROI_to,i_ROI_from),Output.(imageName).GreaterGCInPreferred_ToFrom_ROICount(i_ROI_from,i_ROI_to));
            [Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROIPValue(i_ROI_to,i_ROI_from),Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROIZValue(i_ROI_to,i_ROI_from)] = applySignTest(Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROICount(i_ROI_to,i_ROI_from),Output.(imageName).GreaterGCInNonPreferred_ToFrom_ROICount(i_ROI_from,i_ROI_to));
        end
    end
end
labels = Data.Subjects.Electrodes.ROINames;
RowNames = strcat('To_',labels);
ColumnNames = strcat('From_',labels);
percentageDifference_FaceVasePreferred = array2table(Output.FaceVase.GreaterGCInPreferred_ToFrom_ROIPerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_FaceVaseNonPreferred = array2table(Output.FaceVase.GreaterGCInNonPreferred_ToFrom_ROIPerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_CubePreferred = array2table(Output.Cube.GreaterGCInPreferred_ToFrom_ROIPerc,'RowNames',RowNames,'VariableNames',ColumnNames);
percentageDifference_CubeNonPreferred = array2table(Output.Cube.GreaterGCInNonPreferred_ToFrom_ROIPerc,'RowNames',RowNames,'VariableNames',ColumnNames);

pValue_FaceVasePreferred = array2table(log10(Output.FaceVase.GreaterGCInPreferred_ToFrom_ROIPValue)	,'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_FaceVaseNonPreferred = array2table(log10(Output.FaceVase.GreaterGCInNonPreferred_ToFrom_ROIPValue),'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_CubePreferred = array2table(log10(Output.Cube.GreaterGCInPreferred_ToFrom_ROIPValue),'RowNames',RowNames,'VariableNames',ColumnNames);
pValue_CubeNonPreferred = array2table(log10(Output.Cube.GreaterGCInNonPreferred_ToFrom_ROIPValue),'RowNames',RowNames,'VariableNames',ColumnNames);
clc
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

