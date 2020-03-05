% edited 20180515 CLC - allowed concatenation for different number of
% timepoints, created plot for normalized growth, added figQuality
% edited 20180531 CLC - added raw individual cell traces to each plot
function ALL = plotCumGrowth(ALL)
% GRAPH FOR CUMULATIVE GROWTH
% First parse cup and ctrl data
cond_names = {'ctrl';'cupr'};
for c = 1:length(cond_names)
    fields = fieldnames(ALL.(cond_names{c}));
    temp = [];
    for i = 1:length(fields)
        lnths = ALL.(cond_names{c}).(fields{i}).Total_SheathLengths;
        if length(lnths) < 8
            temp = [temp; [lnths,NaN(1,8-length(lnths))]];
        else
            temp = [temp; lnths];
        end
    end
    ALL.stats.allCummGrowth.(cond_names{c}) = temp;
    ALL.stats.normCummGrowth.(cond_names{c}) = temp./temp(:,1);
    ALL.stats.meanCummGrowth.(cond_names{c}) = mean(temp,1,'omitnan');
    ALL.stats.normMeanGrowth.(cond_names{c}) = mean(ALL.stats.normCummGrowth.(cond_names{c}),1,'omitnan');
    sem = [];
    normsem = [];
    for k = 1:size(ALL.stats.allCummGrowth.(cond_names{c}),2)  
        sem = [sem, std(ALL.stats.allCummGrowth.(cond_names{c})(:,k),'omitnan')./sqrt(length(ALL.stats.allCummGrowth.(cond_names{c})(:,k)))];
        normsem = [normsem, std(ALL.stats.normCummGrowth.(cond_names{c})(:,k),'omitnan')./sqrt(length(ALL.stats.normCummGrowth.(cond_names{c})(:,k)))];
    end
    ALL.stats.growthSEM.(cond_names{c}) = sem;
    ALL.stats.normGrowthSEM.(cond_names{c}) = normsem;
end
ctrlgrowth = ALL.stats.allCummGrowth.ctrl(:,end);
cuprgrowth = ALL.stats.allCummGrowth.cupr(:,end);
[ctrlgrowth,cuprgrowth] = forceConcat(ctrlgrowth,cuprgrowth);

[c1, c2] = getFigColors;
figure('Name','baseline net total length')
hold on
plotSpread([ctrlgrowth,cuprgrowth],'distributionMarkers',{'o'},'distributionColors',{c1,c2},'xNames',{'de novo','remyelinating'})
title('total myelin length at 14 days')
ylabel('total length (\mum)')
ctrl_avg = mean(ctrlgrowth,'omitnan');
sems = calcSEM(ctrlgrowth');
cupr_avg = mean(cuprgrowth,'omitnan');
data = [ctrl_avg, cupr_avg];
sems = [sems calcSEM(cuprgrowth')];
bar(data,'FaceColor','none','EdgeColor','k','LineWidth',1.5)
errorbar(1,ctrl_avg,sems(1),'k');
errorbar(2,cupr_avg,sems(2),'k');
hold off
figQuality(gcf,gca,[4 3])

figure
subplot(1,2,1)
hold on
errorbar([0,2,4,6,8,10,12,14],ALL.stats.meanCummGrowth.ctrl,ALL.stats.growthSEM.ctrl,'-s','Color',c1,'LineWidth',2,'MarkerFaceColor','auto')
errorbar([0,2,4,6,8,10,12,14],ALL.stats.meanCummGrowth.cupr,ALL.stats.growthSEM.cupr,'-s','Color',c2,'LineWidth',2,'MarkerFaceColor','auto')
plot([0,2,4,6,8,10,12,14],ALL.stats.allCummGrowth.ctrl','Color',c1);
plot([0,2,4,6,8,10,12,14],ALL.stats.allCummGrowth.cupr','Color',c2);
title('net total sheath growth')
xlabel('time (days)')
ylim([0 5200]);
ylabel('total sheath length (\mum)')
legend({'de novo','remyelinating'},'Location','southeast')
box off
hold off

subplot(1,2,2)
hold on
errorbar([0,2,4,6,8,10,12,14],ALL.stats.normMeanGrowth.ctrl,ALL.stats.normGrowthSEM.ctrl,'-s','Color',c1,'LineWidth',2,'MarkerFaceColor','auto')
errorbar([0,2,4,6,8,10,12,14],ALL.stats.normMeanGrowth.cupr,ALL.stats.normGrowthSEM.cupr,'-s','Color',c2,'LineWidth',2,'MarkerFaceColor','auto')
plot([0,2,4,6,8,10,12,14],ALL.stats.normCummGrowth.ctrl','Color',c1);
plot([0,2,4,6,8,10,12,14],ALL.stats.normCummGrowth.cupr','Color',c2);
title('net relative total sheath growth')
xlabel('time (days)')
ylabel('total sheath length relative to baseline')
ylim([0.5 1.5])
% legend({'CTRL','CUPR'},'Location','northwest')
hold off

figQuality(gcf,gca,[8 3])
end