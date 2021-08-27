function [preferred, nonPreferred] = calculatePerceptStats(output, minTime)
%Splits timecourse into preferred and nonPreferred percept states depending
%on the rates in the concept layer.
%minTime (samples) used to allow model to reach steady state
preferredTime = output.conceptLayer.rate.preferred > output.conceptLayer.rate.nonpreferred;
startPreferred = find(diff([0 preferredTime])==1);
endPreferred = find(diff([preferredTime 0])==-1);
pickedPreferred = find(startPreferred > minTime);

nonpreferredTime = output.conceptLayer.rate.nonpreferred > output.conceptLayer.rate.preferred;
startNonPreferred = find(diff([0 nonpreferredTime])==1);
endNonPreferred = find(diff([nonpreferredTime 0])==-1);
pickedNonPreferred = find(startNonPreferred > minTime);

%remove first and last percept as they are not complete.
if ~isempty(pickedPreferred) > 0 && ~isempty(pickedNonPreferred) > 0
    if pickedPreferred(1) < pickedNonPreferred(1)
        pickedPreferred = pickedPreferred(2:end);
    else
        pickedNonPreferred = pickedNonPreferred(2:end);
    end
    if ~isempty(pickedPreferred) > 0 && ~isempty(pickedNonPreferred) > 0
    
    if pickedPreferred(end) > pickedNonPreferred(end)
        pickedPreferred = pickedPreferred(1:end-1);
    else
        pickedNonPreferred = pickedNonPreferred(1:end-1);
    end
    end
else
end


numPreferred = length(pickedPreferred);
startPreferred = startPreferred(pickedPreferred);
endPreferred = endPreferred(pickedPreferred);
preferred.startPreferred = startPreferred;
preferred.endPreferred = endPreferred;

numNonPreferred = length(pickedNonPreferred);
startNonPreferred = startNonPreferred(pickedNonPreferred);
endNonPreferred = endNonPreferred(pickedNonPreferred);



nonPreferred.startNonPreferred = startNonPreferred;
nonPreferred.endNonPreferred = endNonPreferred;


%% Calculate bottom up and top down for each percept
preferred.bottomUpPrior_Concept = zeros(numPreferred,1);
preferred.topDownPrior_Concept = zeros(numPreferred,1);
preferred.bottomUpConcept_Sensory = zeros(numPreferred,1);
preferred.topDownConcept_Sensory = zeros(numPreferred,1);

preferred.bottomUpPrior_Concept_Preferred = zeros(numPreferred,1);
preferred.topDownPrior_Concept_Preferred = zeros(numPreferred,1);
preferred.bottomUpPrior_Concept_NonPreferred = zeros(numPreferred,1);
preferred.topDownPrior_Concept_NonPreferred = zeros(numPreferred,1);

preferred.bottomUpConcept_Sensory_Preferred = zeros(numPreferred,1);
preferred.topDownConcept_Sensory_Preferred = zeros(numPreferred,1);
preferred.bottomUpConcept_Sensory_NonPreferred = zeros(numPreferred,1);
preferred.topDownConcept_Sensory_NonPreferred = zeros(numPreferred,1);


preferred.sensoryRate_Preferred = zeros(numPreferred,1);
preferred.sensoryRate_NonPreferred = zeros(numPreferred,1);
preferred.conceptRate_Preferred = zeros(numPreferred,1);
preferred.conceptRate_NonPreferred = zeros(numPreferred,1);
preferred.priorRate_Preferred = zeros(numPreferred,1);
preferred.priorRate_NonPreferred = zeros(numPreferred,1);

nonPreferred.bottomUpPrior_Concept = zeros(numNonPreferred,1);
nonPreferred.topDownPrior_Concept = zeros(numNonPreferred,1);
nonPreferred.bottomUpConcept_Sensory = zeros(numNonPreferred,1);
nonPreferred.topDownConcept_Sensory = zeros(numNonPreferred,1);

nonPreferred.bottomUpPrior_Concept_Preferred = zeros(numNonPreferred,1);
nonPreferred.topDownPrior_Concept_Preferred = zeros(numNonPreferred,1);
nonPreferred.bottomUpPrior_Concept_NonPreferred = zeros(numNonPreferred,1);
nonPreferred.topDownPrior_Concept_NonPreferred = zeros(numNonPreferred,1);

nonPreferred.bottomUpConcept_Sensory_Preferred = zeros(numNonPreferred,1);
nonPreferred.topDownConcept_Sensory_Preferred = zeros(numNonPreferred,1);
nonPreferred.bottomUpConcept_Sensory_NonPreferred = zeros(numNonPreferred,1);
nonPreferred.topDownConcept_Sensory_NonPreferred = zeros(numNonPreferred,1);

nonPreferred.sensoryRate_Preferred = zeros(numNonPreferred,1);
nonPreferred.sensoryRate_NonPreferred = zeros(numNonPreferred,1);
nonPreferred.conceptRate_Preferred = zeros(numNonPreferred,1);
nonPreferred.conceptRate_NonPreferred = zeros(numNonPreferred,1);
nonPreferred.priorRate_Preferred = zeros(numNonPreferred,1);
nonPreferred.priorRate_NonPreferred = zeros(numNonPreferred,1);

for i_percept = 1:numPreferred
    tms = startPreferred(i_percept):endPreferred(i_percept);
    
    preferred.bottomUpPrior_Concept(i_percept) = mean(output.priorLayer.predictionError.preferred(tms) + ...
        output.priorLayer.predictionError.nonpreferred(tms));
    
    preferred.topDownPrior_Concept(i_percept)  = mean(output.conceptLayer.topDown.preferred(tms) + ...
        output.conceptLayer.topDown.nonpreferred(tms));
    
    preferred.bottomUpConcept_Sensory(i_percept) = mean(output.conceptLayer.predictionError.preferred(tms) + ...
        output.conceptLayer.predictionError.nonpreferred(tms));
    
    preferred.topDownConcept_Sensory(i_percept) = mean(output.sensoryLayer.topDown.preferred(tms) + ...
        output.sensoryLayer.topDown.nonpreferred(tms));
    
    preferred.bottomUpPrior_Concept_Preferred(i_percept)    = mean(output.priorLayer.predictionError.preferred(tms));
    preferred.topDownPrior_Concept_Preferred(i_percept)     = mean(output.conceptLayer.topDown.preferred(tms));
    preferred.bottomUpPrior_Concept_NonPreferred(i_percept) = mean(output.priorLayer.predictionError.nonpreferred(tms));
    preferred.topDownPrior_Concept_NonPreferred(i_percept)  = mean(output.conceptLayer.topDown.nonpreferred(tms));
    
    preferred.bottomUpConcept_Sensory_Preferred(i_percept)    = mean(output.conceptLayer.predictionError.preferred(tms));
    preferred.topDownConcept_Sensory_Preferred(i_percept)     = mean(output.sensoryLayer.topDown.preferred(tms));
    preferred.bottomUpConcept_Sensory_NonPreferred(i_percept) = mean(output.conceptLayer.predictionError.nonpreferred(tms));
    preferred.topDownConcept_Sensory_NonPreferred(i_percept)  = mean(output.sensoryLayer.topDown.nonpreferred(tms));
    
    preferred.sensoryRate_Preferred = mean(output.sensoryLayer.rate.preferred(tms));
    preferred.sensoryRate_NonPreferred = mean(output.sensoryLayer.rate.nonpreferred(tms));
    preferred.conceptRate_Preferred = mean(output.conceptLayer.rate.preferred(tms));
    preferred.conceptRate_NonPreferred = mean(output.conceptLayer.rate.nonpreferred(tms));
    preferred.priorRate_Preferred = mean(output.priorLayer.rate.preferred(tms));
    
end

for i_percept = 1:numNonPreferred
    tms = startNonPreferred(i_percept):endNonPreferred(i_percept);
    nonPreferred.bottomUpPrior_Concept(i_percept) = mean(output.priorLayer.predictionError.preferred(tms) + ...
        output.priorLayer.predictionError.nonpreferred(tms));
    
    nonPreferred.topDownPrior_Concept(i_percept)  = mean(output.conceptLayer.topDown.preferred(tms) + ...
        output.conceptLayer.topDown.nonpreferred(tms));
    
    nonPreferred.bottomUpConcept_Sensory(i_percept) = mean(output.conceptLayer.predictionError.preferred(tms) + ...
        output.conceptLayer.predictionError.nonpreferred(tms));
    
    nonPreferred.topDownConcept_Sensory(i_percept) = mean(output.sensoryLayer.topDown.preferred(tms) + ...
        output.sensoryLayer.topDown.nonpreferred(tms));
    
    nonPreferred.bottomUpPrior_Concept_Preferred(i_percept)    = mean(output.priorLayer.predictionError.preferred(tms));
    nonPreferred.topDownPrior_Concept_Preferred(i_percept)     = mean(output.conceptLayer.topDown.preferred(tms));
    nonPreferred.bottomUpPrior_Concept_NonPreferred(i_percept) = mean(output.priorLayer.predictionError.nonpreferred(tms));
    nonPreferred.topDownPrior_Concept_NonPreferred(i_percept)  = mean(output.conceptLayer.topDown.nonpreferred(tms));
    
    nonPreferred.bottomUpConcept_Sensory_Preferred(i_percept) = mean(output.conceptLayer.predictionError.preferred(tms));
    nonPreferred.topDownConcept_Sensory_Preferred(i_percept) = mean(output.sensoryLayer.topDown.preferred(tms));
    nonPreferred.bottomUpConcept_Sensory_NonPreferred(i_percept) = mean(output.conceptLayer.predictionError.nonpreferred(tms));
    nonPreferred.topDownConcept_Sensory_NonPreferred(i_percept) = mean(output.sensoryLayer.topDown.nonpreferred(tms));
    
    nonPreferred.sensoryRate_Preferred = mean(output.sensoryLayer.rate.preferred(tms));
    nonPreferred.sensoryRate_NonPreferred = mean(output.sensoryLayer.rate.nonpreferred(tms));
    nonPreferred.conceptRate_Preferred = mean(output.conceptLayer.rate.preferred(tms));
    nonPreferred.conceptRate_NonPreferred = mean(output.conceptLayer.rate.nonpreferred(tms));
    nonPreferred.priorRate_Preferred = mean(output.priorLayer.rate.preferred(tms));
    nonPreferred.priorRate_NonPreferred = mean(output.priorLayer.rate.nonpreferred(tms));
end
