function FigureS6(output,preferredPercepts,nonPreferredPercepts)
% Scales all percepts to be 100 %tiles
% Plots figure S6

numPreferred = length(preferredPercepts.startPreferred);

preferredPercepts.bottomUpPrior_Concept_Scaled = zeros(numPreferred,100); 
preferredPercepts.topDownPrior_Concept_Scaled = zeros(numPreferred,100);
preferredPercepts.bottomUpConcept_Sensory_Scaled = zeros(numPreferred,100);
preferredPercepts.topDownConcept_Sensory_Scaled = zeros(numPreferred,100);

for i = 1:numPreferred
    tms = floor(linspace(preferredPercepts.startPreferred(i),preferredPercepts.endPreferred(i),100));    
    preferredPercepts.topDownPrior_Concept_Scaled(i,:) = output.priorLayer.rate.preferred(tms) + output.priorLayer.rate.nonpreferred(tms);
    preferredPercepts.bottomUpPrior_Concept_Scaled(i,:) = output.priorLayer.predictionError.preferred(tms) + output.priorLayer.predictionError.nonpreferred(tms);
    preferredPercepts.topDownConcept_Sensory_Scaled(i,:) = output.conceptLayer.rate.preferred(tms) + output.conceptLayer.rate.nonpreferred(tms);
    preferredPercepts.bottomUpConcept_Sensory_Scaled(i,:) = output.conceptLayer.predictionError.preferred(tms) + output.conceptLayer.predictionError.nonpreferred(tms);
end

%%

numNonPreferred = length(nonPreferredPercepts.startNonPreferred);

nonPreferredPercepts.bottomUpPrior_Concept_Scaled = zeros(numNonPreferred,100); 
nonPreferredPercepts.topDownPrior_Concept_Scaled = zeros(numNonPreferred,100);
nonPreferredPercepts.bottomUpConcept_Sensory_Scaled = zeros(numNonPreferred,100);
nonPreferredPercepts.topDownConcept_Sensory_Scaled = zeros(numNonPreferred,100);

for i = 1:numNonPreferred
    tms = floor(linspace(nonPreferredPercepts.startNonPreferred(i),nonPreferredPercepts.endNonPreferred(i),100));    
    nonPreferredPercepts.topDownPrior_Concept_Scaled(i,:) = output.priorLayer.rate.preferred(tms) + output.priorLayer.rate.nonpreferred(tms);
    nonPreferredPercepts.bottomUpPrior_Concept_Scaled(i,:) = output.priorLayer.predictionError.preferred(tms) + output.priorLayer.predictionError.nonpreferred(tms);
    nonPreferredPercepts.topDownConcept_Sensory_Scaled(i,:) = output.conceptLayer.rate.preferred(tms) + output.conceptLayer.rate.nonpreferred(tms);
    nonPreferredPercepts.bottomUpConcept_Sensory_Scaled(i,:) = output.conceptLayer.predictionError.preferred(tms) + output.conceptLayer.predictionError.nonpreferred(tms);
end


%%
close all
figure
subplot(2,1,1)
plot(mean(preferredPercepts.topDownPrior_Concept_Scaled),'b')
hold on
plot(mean(nonPreferredPercepts.topDownPrior_Concept_Scaled),'b--')
plot(mean(preferredPercepts.bottomUpPrior_Concept_Scaled),'r')
plot(mean(nonPreferredPercepts.bottomUpPrior_Concept_Scaled),'r--')
axis square
set(gca,'ylim',[0 1.5]);
set(gca,'xlim',[0 100]);
box off
xlabel('Percept (%tile)')
ylabel('Information Flow')
legend({'TopDown Preferred','TopDown NonPreferred', 'BottomUp Preferred', 'BottomUp NonPreferred'},'location','eastoutside')
subplot(2,1,2)
plot(mean(preferredPercepts.topDownConcept_Sensory_Scaled),'b')
hold on
plot(mean(nonPreferredPercepts.topDownConcept_Sensory_Scaled),'b--')
plot(mean(preferredPercepts.bottomUpConcept_Sensory_Scaled),'r')
plot(mean(nonPreferredPercepts.bottomUpConcept_Sensory_Scaled),'r--')
axis square
set(gca,'ylim',[0 1.5]);
set(gca,'xlim',[0 100]);
box off
xlabel('Percept (%tile)')
ylabel('Information Flow')
legend({'TopDown Preferred','TopDown NonPreferred', 'BottomUp Preferred', 'BottomUp NonPreferred'},'location','eastoutside')
print('-depsc','-painters',['Figures/FigureS6.eps']);
print('-dpng','Figures/FigureS6.png');

