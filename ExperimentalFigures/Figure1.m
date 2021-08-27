function Figure1
% Plots Figures 1B and 1C and calculates and displays statistics
clc
load('Data.mat');

%% Parameters and plotting data
percentageData = [Data.Subjects.Behavior.FaceVase.Percentage_Vase; ...
    Data.Subjects.Behavior.FaceVase.Percentage_Face; ...
    Data.Subjects.Behavior.FaceVase.Percentage_Unsure; ...
    Data.Subjects.Behavior.Cube.Percentage_Green; ...
    Data.Subjects.Behavior.Cube.Percentage_Blue; ...
    Data.Subjects.Behavior.Cube.Percentage_Unsure;];
xlabelsPercentage = {'Vase','Face','Unsure','Green','Blue','Unsure'};

numSubjects = 14;
meanPercentage = mean(percentageData,2);
semPercentage = std(percentageData,[],2) / (numSubjects^0.5); 

%% Percentage Time (Figure 1B)
figure

violins = violinplot(percentageData');
hold on

for i_sub = 1:numSubjects
    line([violins(1).ScatterPlot.XData(i_sub) violins(2).ScatterPlot.XData(i_sub)], ...
         [violins(1).ScatterPlot.YData(i_sub) violins(2).ScatterPlot.YData(i_sub)]);
    line([violins(4).ScatterPlot.XData(i_sub) violins(5).ScatterPlot.XData(i_sub)], ...
         [violins(4).ScatterPlot.YData(i_sub) violins(5).ScatterPlot.YData(i_sub)]);
end
box off
axis square
axis([0 7 0 100])
set(gca,'xtick',1:6);
set(gca,'xticklabel',xlabelsPercentage);
ylabel('% Time');
print('-dpng','Figures/Figure1C.png');
print('-depsc','-painters','Figures/Figure1C.eps');

%Statistics Figure 1C
[pFaceVase,~,faceVaseStats] = signrank(Data.Subjects.Behavior.FaceVase.Percentage_Vase,Data.Subjects.Behavior.FaceVase.Percentage_Face);
signedRankFace_Vase = faceVaseStats.signedrank;

[pCube,~,cubeStats] = signrank(Data.Subjects.Behavior.Cube.Percentage_Green,Data.Subjects.Behavior.Cube.Percentage_Blue);
signedRankGreen_Blue = cubeStats.signedrank;

disp('Percentage');
disp(['FaceVase: ' ...
     ' mean vase = ' num2str(meanPercentage(1),3) ...
     ' sem vase = ' num2str(semPercentage(1),3) ...
     ' mean face = ' num2str(meanPercentage(2),3) ...
     ' sem face = ' num2str(semPercentage(2),3)]);
disp(['FaceVase: Wilcoxon signed rank(' num2str(numSubjects-1) ') = ' num2str(signedRankFace_Vase) ' p = ' num2str(pFaceVase)]);
 
disp(['Cube: ' ...
     ' mean green = ' num2str(meanPercentage(3),3) ...
     ' sem green = ' num2str(semPercentage(3),3) ...
     ' mean blue = ' num2str(meanPercentage(4),3) ...
     ' sem blue = ' num2str(semPercentage(4),3)]);
disp(['Cube: Wilcoxon signed rank(' num2str(numSubjects-1) ') = ' num2str(signedRankGreen_Blue) ' p = ' num2str(pCube)]);