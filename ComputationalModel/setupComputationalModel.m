restoredefaultpath;
addpath(genpath(pwd));

params = modelParameters; %get model parameters used
output = runComputationalModel(params); %run simulation
[preferredPercepts, nonPreferredPercepts] = calculatePerceptStats(output,params.minimumTime); %analyze output

%% plot output
Figure5B(output);
Figure5C(preferredPercepts,nonPreferredPercepts);
Figure5D(preferredPercepts,nonPreferredPercepts);
FigureS6(output,preferredPercepts,nonPreferredPercepts);

