function plotSheathLoss(ALL)
numlostctrl = ALL.stats.BaseNumSheaths.ctrl - ALL.stats.LastNumSheaths.ctrl;
numlostcupr = ALL.stats.BaseNumSheaths.cupr - ALL.stats.LastNumSheaths.cupr;
[numlostctrl,numlostcupr] = forceConcat(numlostctrl,numlostcupr);
[c1, c2] = getFigColors;
figure
hold on
plotSpread([numlostctrl,numlostcupr],'distributionMarkers',{'o'},'distributionColors',{c1,c2},'xNames',{'de novo','remyelinating'})
title('number of sheaths lost')
ylabel('number of sheaths')
ctrl_avg = mean(numlostctrl,'omitnan');
sems = calcSEM(numlostctrl');
cupr_avg = mean(numlostcupr,'omitnan');
data = [ctrl_avg, cupr_avg];
sems = [sems calcSEM(numlostcupr')];
bar(data,'FaceColor','none','EdgeColor','k','LineWidth',1.5)
errorbar(1,ctrl_avg,sems(1),'k');
errorbar(2,cupr_avg,sems(2),'k');
ylim([0 12])
hold off
figQuality(gcf,gca,[4 3])
[~,p_sheathsLost,~,stats_sheathsLost] = ttest2(numlostctrl,numlostcupr)