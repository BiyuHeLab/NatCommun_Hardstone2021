function Figure5B(output)

preferredColor = [51 204 0] / 255;
nonPreferredColor = [204 0 161] / 255;
yRange = [0 1];
timesteps = 120001:150000;

figure
h(1) = subplot(5,1,1);
plot(output.priorLayer.rate.preferred(timesteps),'color',preferredColor);
hold on
plot(output.priorLayer.rate.nonpreferred(timesteps),'color',nonPreferredColor);
set(gca,'ylim',yRange)
title('Prior Layer Rate')
set(gca,'xticklabel',[])
box off
ylabel('Rate');

h(2) = subplot(5,1,2);
plot(output.priorLayer.predictionError.preferred(timesteps),'color',preferredColor);
hold on
plot(output.priorLayer.predictionError.nonpreferred(timesteps),'color',nonPreferredColor);
set(gca,'ylim',yRange)
title('Prior Layer Prediction Error')
set(gca,'xticklabel',[])
box off
ylabel('Prediction Error');

h(3) = subplot(5,1,3);
plot(output.conceptLayer.rate.nonpreferred(timesteps),'color',nonPreferredColor);
hold on
plot(output.conceptLayer.rate.preferred(timesteps),'color',preferredColor);
set(gca,'ylim',yRange)
title('Concept Layer Rates')
set(gca,'xticklabel',[])
box off
ylabel('Rate');

h(4) = subplot(5,1,4);
plot(output.conceptLayer.predictionError.nonpreferred(timesteps),'color',nonPreferredColor);
hold on
plot(output.conceptLayer.predictionError.preferred(timesteps),'color',preferredColor);
title('Concept Layer PredictionError')
set(gca,'xticklabel',[])
set(gca,'ylim',yRange)
box off
ylabel('Prediction Error');

h(5) = subplot(5,1,5);
plot(output.sensoryLayer.rate.nonpreferred(timesteps),'color',nonPreferredColor);
hold on
plot(output.sensoryLayer.rate.preferred(timesteps),'color',preferredColor);
title('Sensory Layer Rates')
set(gca,'ylim',yRange)
box off
xlabel('Time (ms)');
ylabel('Rate');

linkaxes(h,'x')
set(gcf,'position',[49         191        1659         660])
print('-dpng','-r300','Figures/Figure5B.png');