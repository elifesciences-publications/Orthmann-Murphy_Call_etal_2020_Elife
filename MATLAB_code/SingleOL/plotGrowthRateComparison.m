function [ctrlGrowthStats, ctrlGrowthTbl, ctrlMultComp, cuprGrowthStats, cuprGrowthTbl, cuprMultComp] = plotGrowthRateComparison(ALL)
dcupr = diff(ALL.stats.allCummGrowth.cupr,[],2);
dcupr = abs(dcupr);
ycupr = mean(dcupr,'omitnan');
semcupr = calcSEM(dcupr);
[~,cuprGrowthTbl,cuprGrowthStats] = anovan(dcupr(:),[ones(10,1);ones(10,1).*2;ones(10,1).*3;ones(10,1).*4;ones(10,1).*5;ones(10,1).*6;ones(10,1).*7]);
cuprMultComp = multcompare(cuprGrowthStats,'CType','bonferroni');

dctrl = diff(ALL.stats.allCummGrowth.ctrl,[],2);
dctrl = abs(dctrl);
yctrl = mean(dctrl,'omitnan');
semctrl = calcSEM(dctrl);
[~,ctrlGrowthTbl,ctrlGrowthStats] = anovan(dctrl(:),[ones(10,1);ones(10,1).*2;ones(10,1).*3;ones(10,1).*4;ones(10,1).*5;ones(10,1).*6;ones(10,1).*7]);
ctrlMultComp = multcompare(ctrlGrowthStats,'CType','bonferroni');

[c1, c2] = getFigColors;
figure
hold on
errorbar([2,4,6,8,10,12,14],yctrl,semctrl,'-s','Color',c1,'LineWidth',2,'MarkerFaceColor','auto')
errorbar([2,4,6,8,10,12,14],ycupr,semcupr,'-s','Color',c2,'LineWidth',2,'MarkerFaceColor','auto')
plot([2,4,6,8,10,12,14],dctrl','Color',[c1 0.4]);
plot([2,4,6,8,10,12,14],dcupr','Color',[c2 0.4]);
title('total length change between timepoints')
xlabel('time (days)')
% ylim([0 5200]);
ylabel('| length change | (\mum)')
legend({'de novo','remyelinating'},'Location','northeast')
box off
hold off
figQuality(gcf,gca,[4 3])

% export_fig('C:\Users\codyl\OneDrive - Johns Hopkins University\SingleOLRemyelination\FigurePanels_SingleCell\growthRateComparison.eps')