function Figure3D_S3
%Plots Frequency GC results for Figure 3D and S3
load('Data.mat')
images = {'FaceVase','Cube'};
pThreshold = 0.05;
numPermutations = 1000;
clusterThreshold = numPermutations - (0.05 * numPermutations);
preferredColor = [51 204 0] / 255;
nonPreferredColor = [204 0 161] / 255;
lobeNames = Data.Subjects.Electrodes.LobeNames;

for i_image = 1:2
    imageName = images{i_image};
    for i_lobe1 = 1:4
        for i_lobe2 = 1:4
            if i_lobe1 > i_lobe2
                figure
                Percentage_Preferred = squeeze(Data.Subjects.Granger.Feedforward_Feedback.(imageName).Frequency.Percentage_Preferred(i_lobe2,i_lobe1,:));
                pValue_Preferred = squeeze(Data.Subjects.Granger.Feedforward_Feedback.(imageName).Frequency.pValues_Preferred(i_lobe2,i_lobe1,:));
                clusters_Preferred = find_temporal_clusters(Percentage_Preferred,pValue_Preferred,pThreshold);
                maxClusterStats_Preferred = sort(Data.Subjects.Granger.Feedforward_Feedback.(imageName).Frequency.maxClusterSize_Preferred(:,i_lobe2,i_lobe1));
                clusterCutoff = maxClusterStats_Preferred(clusterThreshold);
                sigClusters_Preferred = find(abs(clusters_Preferred.cluster_statSum) > clusterCutoff);
                plot(Data.freqs,Percentage_Preferred,'color',preferredColor,'linewidth',2);
                hold on
                
                if nnz(sigClusters_Preferred) > 0
                    for i_cluster = 1:length(sigClusters_Preferred)
                        plot(Data.freqs(clusters_Preferred.cluster_samples{sigClusters_Preferred(i_cluster)}),90 * ones(length(clusters_Preferred.cluster_samples{sigClusters_Preferred(i_cluster)}),1),'color',preferredColor);
                    end
                end
                
                Percentage_NonPreferred = squeeze(Data.Subjects.Granger.Feedforward_Feedback.(imageName).Frequency.Percentage_NonPreferred(i_lobe2,i_lobe1,:));
                plot(Data.freqs,Percentage_NonPreferred,'color',nonPreferredColor,'linewidth',2);
                pValue_NonPreferred = squeeze(Data.Subjects.Granger.Feedforward_Feedback.(imageName).Frequency.pValues_NonPreferred(i_lobe2,i_lobe1,:));
                clusters_NonPreferred = find_temporal_clusters(Percentage_NonPreferred,pValue_NonPreferred,pThreshold);
                maxClusterStats_NonPreferred = sort(Data.Subjects.Granger.Feedforward_Feedback.(imageName).Frequency.maxClusterSize_NonPreferred(:,i_lobe2,i_lobe1));
                clusterCutoff = maxClusterStats_NonPreferred(clusterThreshold);
                
                
                sigClusters_NonPreferred = find(abs(clusters_NonPreferred.cluster_statSum) > clusterCutoff);
                if nnz(sigClusters_NonPreferred) > 0
                    for i_cluster = 1:length(sigClusters_NonPreferred)
                        plot(Data.freqs(clusters_NonPreferred.cluster_samples{sigClusters_NonPreferred(i_cluster)}),-90 * ones(length(clusters_NonPreferred.cluster_samples{sigClusters_NonPreferred(i_cluster)}),1),'color',nonPreferredColor,'linewidth',2);
                    end
                end
                
                axis([0 50 -100 100]);
                axis square
                box off
                grid on
                print('-dpng',['Figures/Figure3D_S3_' imageName '_'  lobeNames{i_lobe1} '_' lobeNames{i_lobe2} '.png']);
                print('-depsc',['Figures/Figure3D_S3_' imageName '_' lobeNames{i_lobe1} '_' lobeNames{i_lobe2} '.eps']);
                close all
            end
        end
    end
end

