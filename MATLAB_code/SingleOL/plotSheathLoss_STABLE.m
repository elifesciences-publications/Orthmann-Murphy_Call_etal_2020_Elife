function ALL = plotSheathLoss_STABLE(ALL)
ALL.stats.BaseNumSheaths.bzaS = [];
ALL.stats.LastNumSheaths.bzaS = [];
an = fieldnames(ALL.bzaS);
for a = 1:length(an)
    ALL.stats.BaseNumSheaths.bzaS = [ALL.stats.BaseNumSheaths.bzaS; ALL.bzaS.(an{a}).num_BslineSheaths];
    ALL.stats.LastNumSheaths.bzaS = [ALL.stats.LastNumSheaths.bzaS; ALL.bzaS.(an{a}).num_FinalSheaths];
end
numlost = ALL.stats.BaseNumSheaths.bzaS - ALL.stats.LastNumSheaths.bzaS;
[~,~,~,c1] = getFigColors;
figure
hold on
plotSpread(numlost,'distributionMarkers',{'o'},'distributionColors',c1)
title('number of sheaths lost')
ylabel('number of sheaths')
avg = mean(numlost,'omitnan');
sem = calcSEM(numlost');
bar(avg,'FaceColor','none','EdgeColor','k','LineWidth',1.5)
errorbar(1,avg,sem,'k');
ylim([0, max(numlost)+5])
hold off
figQuality(gcf,gca,[4 3])