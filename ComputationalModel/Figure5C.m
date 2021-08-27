function Figure5C(preferredPercepts,nonPreferredPercepts)

preferredColor = [51 204 0] / 255;
nonpreferredColor = [204 0 161] / 255;

figure
preferredDurations = preferredPercepts.endPreferred - preferredPercepts.startPreferred;
nonPreferredDurations = nonPreferredPercepts.endNonPreferred - nonPreferredPercepts.startNonPreferred;
binWidth = 100;
maxDuration = ceil(max([max(preferredDurations) max(nonPreferredDurations)])/binWidth)*binWidth;
bins = 0:binWidth:maxDuration;
preferredDurationCounts = hist(preferredDurations,bins);
nonPreferredDurationCounts = hist(nonPreferredDurations,bins);
bar(bins,100*(preferredDurationCounts/sum(preferredDurationCounts)),'edgecolor',preferredColor,'facecolor','none')
hold on
bar(bins,100*(nonPreferredDurationCounts/sum(nonPreferredDurationCounts)),'edgecolor',nonpreferredColor,'facecolor','none')
axis([0 10000 0 15]);
box off
axis square
xlabel('Duration (ms)')
ylabel('% percepts')
print('-dpng','-r300','Figures/Figure5C.png');

