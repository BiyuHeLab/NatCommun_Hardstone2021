function FigureS7
%Statistics and figures for online task
load('Data.mat')

%% Cube Data
cubeData = [Data.Online.viewFromAboveBlue; Data.Online.viewFromAboveGreen];
isviewFromAboveGreen = [zeros(size(Data.Online.viewFromAboveBlue,1),1); ones(size(Data.Online.viewFromAboveGreen,1),1)];

validSubjectsCube = find(nanmean(nanmean(cubeData,3),2)<90 & nanmean(nanmean(cubeData,3),2)>10);
cubeData = nanmean(cubeData(validSubjectsCube,:,:),3);
isviewFromAboveGreen = isviewFromAboveGreen(validSubjectsCube);

figure
subplot(1,2,1);
boxplot(cubeData,'symbol','')
hold on
title('Cube');

ylabel('%Time perceiving ViewFromAbove')
set(gca,'xticklabel',Data.Online.cbLabel)
refline(0,50)

indBlue = find(isviewFromAboveGreen==0);
y = cubeData(indBlue,:);
x = repmat(1:7,[length(indBlue) 1]);
x = x + (rand(size(x))-0.5)*0.2;
plot(x,y,'b.')

indGreen = find(isviewFromAboveGreen==1);
y = cubeData(indGreen,:);
x = repmat(1:7,[length(indGreen) 1]);
x = x + (rand(size(x))-0.5)*0.2;
plot(x,y,'g.')

for i_condition = 1:7
    conditionData = cubeData(:,i_condition);
    conditionData = conditionData(~isnan(conditionData))-50;
    [pCube(i_condition),~,stats] = signrank(conditionData,0,'method','approximate');
    zCube(i_condition) = stats.zval;
    disp(['Cube: ' Data.Online.cbLabel{i_condition} ' p-Value(uncorrected) = ' num2str(pCube(i_condition),3) ' z-Value = '  num2str(zCube(i_condition),3)]);
end

validSubjectsCubeAllConditions = find(sum(cubeData > 90 | cubeData < 10,2)==0);
cubeDataAllConditions = cubeData(validSubjectsCubeAllConditions,:);
[cube_ICC, ~, ~, cube_f, cube_df1, cube_df2, cube_p] = ICC(cubeDataAllConditions, '1-k');

disp(['Cube: ICC= ' num2str(cube_ICC) ...
               ' F= ' num2str(cube_f) ...
               ' df= ' num2str(cube_df1) ',' num2str(cube_df2) ...
               ' p= ' num2str(cube_p)]);

           
%% FaceVase Data
faceVaseData = Data.Online.faceVase;
validSubjectsFaceVase = find(nanmean(nanmean(faceVaseData,3),2)<90 & nanmean(nanmean(faceVaseData,3),2)>10);
faceVaseData = nanmean(faceVaseData(validSubjectsFaceVase,:,:),3);

subplot(1,2,2);
boxplot(faceVaseData,'symbol','')
hold on
title('FaceVase');

ylabel('%Time perceiving Vase')
set(gca,'xticklabel',Data.Online.fvLabel)

refline(0,50)

y = faceVaseData;
x = repmat(1:7,[length(faceVaseData) 1]);
x = x + (rand(size(x))-0.5)*0.2;
plot(x,y,'k.')
set(gcf,'position',[262         330        1457         420])
print('-dpng','Figures/FigureS7.png');
print('-depsc','-painters','Figures/FigureS7.eps');

for i_condition = 1:7
    conditionData = faceVaseData(:,i_condition);
    conditionData = conditionData(~isnan(conditionData))-50;
    [pFaceVase(i_condition),~,stats] = signrank(conditionData,0,'method','approximate');
    zFaceVase(i_condition) = stats.zval;
    disp(['FaceVase: ' Data.Online.fvLabel{i_condition} ' p-Value(uncorrected) = ' num2str(pFaceVase(i_condition),3) ' z-Value = '  num2str(zFaceVase(i_condition),3)]);
end

validSubjectsFaceVaseAllConditions = find(sum(faceVaseData > 90 | faceVaseData < 10,2)==0);
faceVaseDataAllConditions = faceVaseData(validSubjectsFaceVaseAllConditions,:);
[faceVase_ICC, ~, ~, faceVase_f, faceVase_df1, faceVase_df2, faceVase_p] = ICC(faceVaseDataAllConditions, '1-k');

disp(['FaceVase: ICC= ' num2str(faceVase_ICC) ...
               ' F= ' num2str(faceVase_f) ...
               ' df= ' num2str(faceVase_df1) ',' num2str(faceVase_df2) ...
               ' p= ' num2str(faceVase_p)]);
