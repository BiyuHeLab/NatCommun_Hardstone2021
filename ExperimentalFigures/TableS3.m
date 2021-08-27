function TableS3
% Tallies for Table S3
load('Data.mat');
images = {'FaceVase','Cube'};
pThreshold = 0.05;
Output = struct;
for i_image = 1:length(images)
    %% Step 1: Select electrodes that meet criteria
    imageName = images{i_image};
    
    selectedElectrodes = find(Data.Subjects.Electrodes.Lobe < 5);
    Output.(imageName).sigElectrodes = Data.Subjects.SwitchMaintainAnalysis.(imageName).pValue(selectedElectrodes) < pThreshold;
    Output.(imageName).notSigElectrodes = ~Output.(imageName).sigElectrodes;
    Output.(imageName).Lobe = Data.Subjects.Electrodes.Lobe(selectedElectrodes);
    
    Rank_PreferredMinusPreferred_ToFrom = Data.Subjects.Granger.Preferred_NonPreferred.(imageName).Temporal.Rank_PreferredMinusNonPreferred_IndividualBias;
    Rank_PreferredMinusPreferred_ToFrom = Rank_PreferredMinusPreferred_ToFrom(selectedElectrodes,selectedElectrodes);
    Rank_PreferredMinusPreferred_ToFromSigElectrodes = Rank_PreferredMinusPreferred_ToFrom;
    Rank_PreferredMinusPreferred_ToFromSigElectrodes(Output.(imageName).notSigElectrodes,Output.(imageName).notSigElectrodes) = nan; %remove connections where neither electrode is a switch or maintain selective electrode
    
    for i_lobe_to = 1:4
        for i_lobe_from = 1:4
            toElecs   = find(Output.(imageName).Lobe == i_lobe_to);
            fromElecs = find(Output.(imageName).Lobe == i_lobe_from);
            Output.(imageName).numLobeCountConnections(i_lobe_to,i_lobe_from) = nnz(~isnan(Rank_PreferredMinusPreferred_ToFrom(toElecs,fromElecs)));
            Output.(imageName).numLobeCountConnectionsSigElectrodes(i_lobe_to,i_lobe_from) = nnz(~isnan(Rank_PreferredMinusPreferred_ToFromSigElectrodes(toElecs,fromElecs)));
        end
    end
end

disp('#Electrodes per Lobe')
disp(array2table(hist(Output.FaceVase.Lobe,[1:4]),'VariableNames',Data.Subjects.Electrodes.LobeNames(1:4)));

disp('Potential inter-lobe Pairs')
disp(array2table(Output.FaceVase.numLobeCountConnections,'RowNames',Data.Subjects.Electrodes.LobeNames(1:4),'VariableNames',Data.Subjects.Electrodes.LobeNames(1:4)));

disp('#Switch/Maintain Electrodes per Lobe (FaceVase)')
disp(array2table(hist(Output.FaceVase.Lobe(Output.FaceVase.sigElectrodes),[1:4]),'VariableNames',Data.Subjects.Electrodes.LobeNames(1:4)));

disp('Potential inter-lobe Pairs (FaceVase)')
disp(array2table(Output.FaceVase.numLobeCountConnectionsSigElectrodes,'RowNames',Data.Subjects.Electrodes.LobeNames(1:4),'VariableNames',Data.Subjects.Electrodes.LobeNames(1:4)));

disp('#Switch/Maintain Electrodes per Lobe (Cube)')
disp(array2table(hist(Output.Cube.Lobe(Output.Cube.sigElectrodes),[1:4]),'VariableNames',Data.Subjects.Electrodes.LobeNames(1:4)));

disp('Potential inter-lobe Pairs (Cube)')
disp(array2table(Output.Cube.numLobeCountConnectionsSigElectrodes,'RowNames',Data.Subjects.Electrodes.LobeNames(1:4),'VariableNames',Data.Subjects.Electrodes.LobeNames(1:4)));
