function plotSheathNumLnthTot_new(ALL)
cuprTot = [ALL.stats.allCummGrowth.cupr(1:8,end);ALL.stats.allCummGrowth.cupr(9,7);NaN];
ctrlTot = ALL.stats.allCummGrowth.ctrl(:,end);

[c1, c2] = getFigColors;
figure
hold on
plotSpread([ctrlTot,cuprTot],'distributionMarkers',{'o'},'distributionColors',{c1,c2},'xNames',{'de novo','remyelinating'})
title('total myelin length at 12-14 days')
ylabel('total length (\mum)')
ctrl_avg = mean(ctrlTot,'omitnan');
sems = calcSEM(ctrlTot');
cupr_avg = mean(cuprTot,'omitnan');
data = [ctrl_avg, cupr_avg];
sems = [sems calcSEM(cuprTot')];
bar(data,'FaceColor','none','EdgeColor','k','LineWidth',1.5)
errorbar(1,ctrl_avg,sems(1),'k');
errorbar(2,cupr_avg,sems(2),'k');
hold off
figQuality(gcf,gca,[4 3])
[~,p_totLnth,~,stats_totLnth] = ttest2(cuprTot,ctrlTot)

cuprNum = ALL.stats.LastNumSheaths.cupr(:,end);
ctrlNum = ALL.stats.LastNumSheaths.ctrl(:,end);
figure
hold on
plotSpread([ctrlNum,cuprNum],'distributionMarkers',{'o'},'distributionColors',{c1,c2},'xNames',{'de novo','remyelinating'})
title('number of sheaths per cell at 12-14 days')
ylabel('number of sheaths')
ctrl_avg = mean(ctrlNum,'omitnan');
sems = calcSEM(ctrlNum');
cupr_avg = mean(cuprNum,'omitnan');
data = [ctrl_avg, cupr_avg];
sems = [sems calcSEM(cuprNum')];
bar(data,'FaceColor','none','EdgeColor','k','LineWidth',1.5)
errorbar(1,ctrl_avg,sems(1),'k');
errorbar(2,cupr_avg,sems(2),'k');
hold off
figQuality(gcf,gca,[4 3])
[~,p_numSheaths,~,stats_numSheaths] = ttest2(cuprNum,ctrlNum)

cuprLnth = cuprTot./cuprNum;
ctrlLnth = ctrlTot./ctrlNum;
figure
hold on
plotSpread([ctrlLnth,cuprLnth],'distributionMarkers',{'o'},'distributionColors',{c1,c2},'xNames',{'de novo','remyelinating'})
title('average sheath length at 12-14 days')
ylabel('sheath length (\mum)')
ctrl_avg = mean(ctrlLnth,'omitnan');
sems = calcSEM(ctrlLnth');
cupr_avg = mean(cuprLnth,'omitnan');
data = [ctrl_avg, cupr_avg];
sems = [sems calcSEM(cuprLnth')];
bar(data,'FaceColor','none','EdgeColor','k','LineWidth',1.5)
errorbar(1,ctrl_avg,sems(1),'k');
errorbar(2,cupr_avg,sems(2),'k');
hold off
figQuality(gcf,gca,[4 3])
[~,p_lnthSheaths,~,stats_lnthSheaths] = ttest2(cuprLnth,ctrlLnth)