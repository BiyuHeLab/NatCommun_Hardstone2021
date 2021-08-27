function Figure5D(preferredPercepts,nonPreferredPercepts)
preferredColor = [51 204 0] / 255;
nonPreferredColor = [204 0 161] / 255;

figure
subplot(2,2,1);
preferredTopDown_PriorConcept = preferredPercepts.topDownPrior_Concept;
nonPreferredTopDown_PriorConcept = nonPreferredPercepts.topDownPrior_Concept;
maxValue = ceil(max([max(preferredTopDown_PriorConcept) max(nonPreferredTopDown_PriorConcept)]*10))/10;
minValue = floor(min([min(preferredTopDown_PriorConcept) min(nonPreferredTopDown_PriorConcept)])*10)/10;
bins = minValue:0.005:maxValue;
preferredTopDown_PriorConceptCounts = hist(preferredTopDown_PriorConcept,bins);
nonPreferredTopDown_PriorConceptCounts = hist(nonPreferredTopDown_PriorConcept,bins);
bar(bins,100*(preferredTopDown_PriorConceptCounts/sum(preferredTopDown_PriorConceptCounts)),'edgecolor',preferredColor,'facecolor','none')
hold on
bar(bins,100*(nonPreferredTopDown_PriorConceptCounts/sum(nonPreferredTopDown_PriorConceptCounts)),'edgecolor',nonPreferredColor,'facecolor','none')
axis([0 0.6 0 60])
box off
axis square
title('Prior <-> Concept')
xlabel('Prediction')
ylabel('% Percepts')

subplot(2,2,3);
preferredTopDown_ConceptSensory = preferredPercepts.topDownConcept_Sensory;
nonPreferredTopDown_ConceptSensory = nonPreferredPercepts.topDownConcept_Sensory;
maxValue = ceil(max([max(preferredTopDown_ConceptSensory) max(nonPreferredTopDown_ConceptSensory)]*10))/10;
minValue = floor(min([min(preferredTopDown_ConceptSensory) min(nonPreferredTopDown_ConceptSensory)])*10)/10;
bins = minValue:0.005:maxValue;
preferredTopDown_ConceptSensoryCounts = hist(preferredTopDown_ConceptSensory,bins);
nonPreferredTopDown_ConceptSensoryCounts = hist(nonPreferredTopDown_ConceptSensory,bins);
bar(bins,100*(preferredTopDown_ConceptSensoryCounts/sum(preferredTopDown_ConceptSensoryCounts)),'edgecolor',preferredColor,'facecolor','none')
hold on
bar(bins,100*(nonPreferredTopDown_ConceptSensoryCounts/sum(nonPreferredTopDown_ConceptSensoryCounts)),'edgecolor',nonPreferredColor,'facecolor','none')
axis([1.1 1.7 0 15])
box off
axis square
title('Concept <-> Sensory')
xlabel('Prediction')
ylabel('% Percepts')


subplot(2,2,2);
preferredBottomUp_PriorConcept = preferredPercepts.bottomUpPrior_Concept;
nonPreferredBottomUp_PriorConcept = nonPreferredPercepts.bottomUpPrior_Concept;
maxValue = ceil(max([max(preferredBottomUp_PriorConcept) max(nonPreferredBottomUp_PriorConcept)]*10))/10;
minValue = floor(min([min(preferredBottomUp_PriorConcept) min(nonPreferredBottomUp_PriorConcept)])*10)/10;
bins = minValue:0.005:maxValue;
preferredBottomUp_PriorConceptCounts = hist(preferredBottomUp_PriorConcept,bins);
nonPreferredBottomUp_PriorConceptCounts = hist(nonPreferredBottomUp_PriorConcept,bins);
bar(bins,100*(preferredBottomUp_PriorConceptCounts/sum(preferredBottomUp_PriorConceptCounts)),'edgecolor',preferredColor,'facecolor','none')
hold on
bar(bins,100*(nonPreferredBottomUp_PriorConceptCounts/sum(nonPreferredBottomUp_PriorConceptCounts)),'edgecolor',nonPreferredColor,'facecolor','none')

axis([0 0.6 0 60])
box off
axis square
title('Prior <-> Concept')
xlabel('Prediction Error')
ylabel('% Percepts')


subplot(2,2,4);
preferredBottomUpConcept_Sensory = preferredPercepts.bottomUpConcept_Sensory;
nonPreferredBottomUpConcept_Sensory = nonPreferredPercepts.bottomUpConcept_Sensory;
maxValue = ceil(max([max(preferredBottomUpConcept_Sensory) max(nonPreferredBottomUpConcept_Sensory)]*10))/10;
minValue = floor(min([min(preferredBottomUpConcept_Sensory) min(nonPreferredBottomUpConcept_Sensory)])*10)/10;
bins = minValue:0.005:maxValue;
preferredBottomUpConcept_SensoryCounts = hist(preferredBottomUpConcept_Sensory,bins);
nonPreferredBottomUpConcept_SensoryCounts = hist(nonPreferredBottomUpConcept_Sensory,bins);
bar(bins,100*(preferredBottomUpConcept_SensoryCounts/sum(preferredBottomUpConcept_SensoryCounts)),'edgecolor',preferredColor,'facecolor','none')
hold on
bar(bins,100*(nonPreferredBottomUpConcept_SensoryCounts/sum(nonPreferredBottomUpConcept_SensoryCounts)),'edgecolor',nonPreferredColor,'facecolor','none')

axis([1.1 1.7 0 15])
box off
axis square
title('Concept <-> Sensory')
xlabel('Prediction Error')
ylabel('% Percepts')


print('-dpng','-r300','Figures/Figure5D.png');