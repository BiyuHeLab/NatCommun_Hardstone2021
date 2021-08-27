function params = modelParameters
% model parameters (see table S4)
params = struct;

params.priorLayer.tau_timeconstant = 10;
params.conceptLayer.tau_timeconstant = 10;
params.sensoryLayer.tau_timeconstant = 10;
params.adaptation.phi_weight = 0.8;
params.adaptation.tau_timeconstant = 5000;

params.beta_mutualInhibitionWeight = 2;
params.predictionErrorWeight_delta = 2;
params.topDownPredictionWeight_eta = 2;
params.topDownPriorWeight_eta = 1;
params.predictionErrorWeight_PriorLayer = 1;

params.priorLayerNoise = true;
params.conceptLayerNoise = true;
params.sensoryLayerNoise = true;
params.randomSeed = 1982;
params.noise.tau = 200; % ms
params.noise.sigma = 0.02;


params.stepFunction.theta = 0.2;
params.stepFunction.k = 0.1;
params.euler.dt = 1;
params.nTimesteps = 50000000;
params.inputPreferred = 0.8;
params.inputNonPreferred = 0.8;

params.priorLayer.bias.preferred = 0.3;
params.priorLayer.bias.nonpreferred = -params.priorLayer.bias.preferred;
params.minimumTime = 10000; % Number of samples at beginning discarded from analysis, to allow model to reach steady state
