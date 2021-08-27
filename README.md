# Instructions for Software accompanying "Long-term Priors Influence Visual Perception through Recruitment of Long-range Feedback" by Richard Hardstone et al.

## All Code written by Richard Hardstone.

## System Requirements:
* Machine capable of running MATLAB R2017a (or later), and a valid license for MATLAB.
* Analysis was originally performed on a machine running Redhat Linux v7.8, and MATLAB R2017a.

## Installation Guide/Instructions for Use:
1.	Unzip package.
2.	To plot figures related to the experimental data, go to the directory ExperimentalFigures.  You can then run the script plotAllExperimentalFigures. This will set the appropriate paths, and plot all the figures. The scripts will also output the statistics in the command window. All Figures will be saved in the Figures directory. (Duration ~15 minutes)
3.	To run the computational model, go to the directory ComputationalModel, and run the script setupComputationalModel. This will set the path, run the model, and output the figures.  If you want to change any model parameters, edit the script modelParameters, and then rerun setupComputationalModel. Note the default parameters runs the model for 5e7 timesteps (Duration ~3 hours).  Setting params.nTimesteps to 1e6 will shorten the duration to ~5 minutes (but figures will not be identical to the paper). All Figures will be saved in the Figures directory. 

## Data Structure
* ExperimentalFigures/Data.mat contains all the analysis outputs from the experimental data required to plot the figures
* Data.Subjects contains results relating to the 14 subjects analyzed in Figures 1-4.
* Data.freqs contains the frequency values for the Granger causality results (Figure 3D,S3,S4E)
* Data.Longitudinal contains the perceptual bias for the 24 healthy subjects who completed 3 sessions (adjacent sessions spaced one week apart)
* Data.Online contains the perceptual bias for the 60 subjects who completed the online task
* Data.Subjects.Behavior contains the % times for each percept (used for Figure 1B) and the perceptual Bias statistics (used for Table S2)
* Data.Subjects.Electrodes contains the MNI coordinates for each electrode, and the lobe that the electrode lies on.
* Data.Subjects.SwitchMaintainAnalysis contains the p-values and corresponding t-stat for the 2-sided t-tests performed in Figure 2.
* Data.Subjects.Granger.Preferred_NonPreferred contains the Granger results for Figure 4, where the significance was determined by permuting preferred and non-preferred trials.
* Data.Subjects.Granger.Feedforward_Feedback contains the Granger results for Figure 3, where the significance was determined by permuting electrode labels.
* Data.Subjects.Granger.(permutationType).(image).Temporal.Rank* contains the rank of Granger causality results compared to the 1000 permutations (see Figure 3A, 4A)
* Data.Subjects.Granger.(permutationType).(image).Frequency.maxClusterSize* contains the max frequency cluster size for each permutation (used in Figures 3D,S3,S4E)
* Data.Subjects.Granger.(permutationType).(image).Frequency.Percentage* contains the percentage feedforward/feedback for the frequency domain Granger causality results (plotted in Figures 3D,S3,S4E)
* Data.Subjects.Granger.(permutationType).(image).Frequency.pValue* contains the uncorrected significance of the feedforward/feedback bias for the frequency domain Granger causality results (plotted in Figures 3D,S3,S4E).

