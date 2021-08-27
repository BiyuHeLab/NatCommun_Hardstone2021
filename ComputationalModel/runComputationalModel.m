function output = runComputationalModel(params)

rng(params.randomSeed)
% Initialize outputs

output.priorLayer.rate.preferred = zeros(1, params.nTimesteps);
output.priorLayer.rate.nonpreferred = zeros(1, params.nTimesteps);
output.priorLayer.predictionError.preferred = zeros(1, params.nTimesteps);
output.priorLayer.predictionError.nonpreferred = zeros(1, params.nTimesteps);
output.priorLayer.adaptation.preferred = zeros(1, params.nTimesteps);
output.priorLayer.adaptation.nonpreferred = zeros(1, params.nTimesteps);

output.conceptLayer.rate.preferred = zeros(1, params.nTimesteps);
output.conceptLayer.rate.nonpreferred = zeros(1, params.nTimesteps);
output.conceptLayer.adaptation.preferred = zeros(1, params.nTimesteps);
output.conceptLayer.adaptation.nonpreferred = zeros(1, params.nTimesteps);
output.conceptLayer.predictionError.preferred = zeros(1, params.nTimesteps);
output.conceptLayer.predictionError.nonpreferred = zeros(1, params.nTimesteps);
output.conceptLayer.mutualInhibition.preferred = zeros(1, params.nTimesteps);
output.conceptLayer.mutualInhibition.nonpreferred = zeros(1, params.nTimesteps);
output.conceptLayer.topDown.preferred = zeros(1, params.nTimesteps);
output.conceptLayer.topDown.nonpreferred = zeros(1, params.nTimesteps);

output.sensoryLayer.rate.preferred = zeros(1, params.nTimesteps);
output.sensoryLayer.rate.nonpreferred = zeros(1, params.nTimesteps);
output.sensoryLayer.adaptation.preferred = zeros(1, params.nTimesteps);
output.sensoryLayer.adaptation.nonpreferred = zeros(1, params.nTimesteps);
output.sensoryLayer.predictionError.preferred = zeros(1, params.nTimesteps);
output.sensoryLayer.predictionError.nonpreferred = zeros(1, params.nTimesteps);
output.sensoryLayer.topDown.preferred = zeros(1, params.nTimesteps);
output.sensoryLayer.topDown.nonpreferred = zeros(1, params.nTimesteps);


output.priorLayer.noise.preferred = createOrnsteinUhlenbeckNoise(params);
output.priorLayer.noise.nonpreferred = createOrnsteinUhlenbeckNoise(params);
output.conceptLayer.noise.preferred = createOrnsteinUhlenbeckNoise(params);
output.conceptLayer.noise.nonpreferred = createOrnsteinUhlenbeckNoise(params);
output.sensoryLayer.noise.preferred = createOrnsteinUhlenbeckNoise(params);
output.sensoryLayer.noise.nonpreferred = createOrnsteinUhlenbeckNoise(params);


% initial conditions
output.priorLayer.rate.preferred(1) = 0;
output.priorLayer.predictionError.preferred(1) = 0;

output.conceptLayer.rate.preferred(1) = 0;
output.conceptLayer.rate.nonpreferred(1) = 0;
output.conceptLayer.adaptation.preferred(1) = 0;
output.conceptLayer.adaptation.nonpreferred(1) = 0;

output.sensoryLayer.rate.preferred(1) = 0;
output.sensoryLayer.rate.nonpreferred(1) = 0;
output.sensoryLayer.adaptation.preferred(1) = 0;
output.sensoryLayer.adaptation.nonpreferred(1) = 0;

%% Run Model
for t = 1:params.nTimesteps-1
    if mod(t,100000)==0; disp(t); end
    %% Update Rates
    [output.sensoryLayer.rate.preferred(t+1),...
        output.sensoryLayer.predictionError.preferred(t+1),...
        output.sensoryLayer.topDown.preferred(t+1)] = calculateSensoryLayerRate(params,output.sensoryLayer.rate.preferred(t), ...
                                                                                      output.sensoryLayer.adaptation.preferred(t),...
                                                                                      output.conceptLayer.rate.preferred(t), ...
                                                                                      output.sensoryLayer.noise.preferred(t));
    
    [output.sensoryLayer.rate.nonpreferred(t+1),...
        output.sensoryLayer.predictionError.nonpreferred(t+1),...
        output.sensoryLayer.topDown.nonpreferred(t+1)] = calculateSensoryLayerRate(params,output.sensoryLayer.rate.nonpreferred(t), ...
                                                                                         output.sensoryLayer.adaptation.nonpreferred(t), ...
                                                                                         output.conceptLayer.rate.nonpreferred(t), ...
                                                                                         output.sensoryLayer.noise.nonpreferred(t));
    
    [output.conceptLayer.rate.preferred(t+1),...
        output.conceptLayer.mutualInhibition.preferred(t+1),...
        output.conceptLayer.predictionError.preferred(t+1), ...
        output.conceptLayer.topDown.preferred(t+1)] = calculateConceptLayerRate(params,output.conceptLayer.rate.preferred(t), ...
                                                                                              output.conceptLayer.adaptation.preferred(t), ...
                                                                                              output.conceptLayer.rate.nonpreferred(t), ...
                                                                                              output.sensoryLayer.rate.preferred(t),...
                                                                                              output.priorLayer.rate.preferred(t), ... 
                                                                                              output.conceptLayer.noise.preferred(t));
    
    [output.conceptLayer.rate.nonpreferred(t+1),...
        output.conceptLayer.mutualInhibition.nonpreferred(t+1),...
        output.conceptLayer.predictionError.nonpreferred(t+1), ...
        output.conceptLayer.topDown.nonpreferred(t+1)] = calculateConceptLayerRate(params,output.conceptLayer.rate.nonpreferred(t), ...,
                                                                                                 output.conceptLayer.adaptation.nonpreferred(t), ...
                                                                                                 output.conceptLayer.rate.preferred(t), ...
                                                                                                 output.sensoryLayer.rate.nonpreferred(t), ...
                                                                                                 output.priorLayer.rate.nonpreferred(t), ... 
                                                                                                 output.conceptLayer.noise.nonpreferred(t));
    
       [output.priorLayer.rate.preferred(t+1),...
        output.priorLayer.predictionError.preferred(t+1)] = calculatePriorRate(params,output.priorLayer.rate.preferred(t), ...,
                                                                                                 output.priorLayer.adaptation.preferred(t), ...,
                                                                                                 output.conceptLayer.rate.preferred(t), ...
                                                                                                 params.priorLayer.bias.preferred, ...
                                                                                                 output.priorLayer.noise.preferred(t));
       [output.priorLayer.rate.nonpreferred(t+1),...
        output.priorLayer.predictionError.nonpreferred(t+1)] = calculatePriorRate(params,output.priorLayer.rate.nonpreferred(t), ...,
                                                                                                 output.priorLayer.adaptation.nonpreferred(t), ...,
                                                                                                 output.conceptLayer.rate.nonpreferred(t), ...
                                                                                                 params.priorLayer.bias.nonpreferred, ...
                                                                                                 output.priorLayer.noise.nonpreferred(t));

                                                                                             
    %% Update Adaptations
    output.sensoryLayer.adaptation.preferred(t+1)    = calculateAdaptation(params, output.sensoryLayer.adaptation.preferred(t),...
                                                                                  output.sensoryLayer.rate.preferred(t));
                                                                              
    output.sensoryLayer.adaptation.nonpreferred(t+1) = calculateAdaptation(params, output.sensoryLayer.adaptation.nonpreferred(t),...
                                                                                  output.sensoryLayer.rate.nonpreferred(t));
                                                                              
    output.conceptLayer.adaptation.preferred(t+1)    = calculateAdaptation(params, output.conceptLayer.adaptation.preferred(t),...
                                                                                  output.conceptLayer.rate.preferred(t));
                                                                              
    output.conceptLayer.adaptation.nonpreferred(t+1) = calculateAdaptation(params, output.conceptLayer.adaptation.nonpreferred(t),...
                                                                                  output.conceptLayer.rate.nonpreferred(t));
    
    output.priorLayer.adaptation.preferred(t+1)    = calculateAdaptation(params, output.priorLayer.adaptation.preferred(t),...
                                                                                  output.priorLayer.rate.preferred(t));
                                                                              
    output.priorLayer.adaptation.nonpreferred(t+1) = calculateAdaptation(params, output.priorLayer.adaptation.nonpreferred(t),...
                                                                                  output.priorLayer.rate.nonpreferred(t));
    
end

end

%Model functions

function stepFunctionOutput = stepFunction(theta, k, u)
stepFunctionOutput = 1./(1+exp((theta-u)./k));
end


function [newPriorRate, predictionError] = calculatePriorRate(params,currentPriorRate, currentAdaptation, currentConceptRate, priorBias,  noise)

predictionError    = max(0,params.predictionErrorWeight_PriorLayer * (currentConceptRate - currentPriorRate));
adaptation       = params.adaptation.phi_weight        * currentAdaptation;

if params.priorLayerNoise == true
    noise = noise;
else
    noise = 0;
end
stepFunctionOutputPrior = stepFunction(params.stepFunction.theta,params.stepFunction.k,predictionError + noise + priorBias - adaptation);

newPriorRate = currentPriorRate + ((params.euler.dt / params.priorLayer.tau_timeconstant) * (-currentPriorRate + stepFunctionOutputPrior));

end


function [newConceptRate, mutualInhibition, predictionError, topDown] = calculateConceptLayerRate(params,currentConceptRate, currentAdaptation, currentConceptRate_OtherPop, currentSensoryRate, currentPriorRate, noise)

mutualInhibition = params.beta_mutualInhibitionWeight  * currentConceptRate_OtherPop;
adaptation       = params.adaptation.phi_weight        * currentAdaptation;
predictionError  = max(0,params.predictionErrorWeight_delta  * (currentSensoryRate - currentConceptRate));
topDown          = params.topDownPriorWeight_eta *  currentPriorRate;
if params.conceptLayerNoise == true
    noise            = noise;
else
    noise = 0;
end

stepFunctionOutputConcept = stepFunction(params.stepFunction.theta,params.stepFunction.k, -mutualInhibition - adaptation + predictionError + topDown + noise);

newConceptRate = currentConceptRate + ((params.euler.dt / params.conceptLayer.tau_timeconstant) * (-currentConceptRate + stepFunctionOutputConcept));

end


function [newSensoryRate, predictionError, topDown] = calculateSensoryLayerRate(params,currentSensoryRate, currentAdaptation, currentConceptRate, noise)

adaptation      = params.adaptation.phi_weight       *  currentAdaptation;
predictionError = max(0,params.predictionErrorWeight_delta * (params.inputPreferred - currentSensoryRate));
topDown         = params.topDownPredictionWeight_eta *  currentConceptRate;
if params.sensoryLayerNoise == true
    noise            = noise;
else
    noise = 0;
end

stepFunctionOutputSensory = stepFunction(params.stepFunction.theta,params.stepFunction.k,-adaptation + predictionError + topDown + noise);

newSensoryRate = currentSensoryRate + ((params.euler.dt / params.sensoryLayer.tau_timeconstant) * (-currentSensoryRate + stepFunctionOutputSensory));

end


function newAdaptation = calculateAdaptation(params, currentAdaptation, currentRate)

stepFunctionAdaptation = stepFunction(params.stepFunction.theta,params.stepFunction.k,currentRate);
newAdaptation = currentAdaptation + ((params.euler.dt / params.adaptation.tau_timeconstant) * (-currentAdaptation + stepFunctionAdaptation));

end